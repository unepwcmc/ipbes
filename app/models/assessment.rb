class Assessment < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :contacts, dependent: :destroy
  belongs_to :last_editor, :class_name => 'User'

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:text_value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :references, allow_destroy: true
  accepts_nested_attributes_for :contacts, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  validates :title, presence: true, uniqueness: true
  
  def self.search(filters)
    return scoped if filters['q'].blank? && filters['geo_scale'].blank?
    
    attachments = filters['attachments'] == 't'
    results = cse_query(filters['q'], attachments).filter_by_answer_type('geo_scale', filters['geo_scale'])
  end

  def self.cse_query(q, attachments = false)
    return scoped if q.blank?

    require 'open-uri'
    response = Nokogiri::XML(open("http://www.google.com/search?cx=013379249883164858539:b_mvcbrgpgk&client=google-csbe&output=xml_no_dtd&q=#{q}"))

    ids_array = response.xpath('//GSP/RES/R/U').map { |u|
      id = 0
      # To get the ID from the URL, first we must work out what path it is
      case u.content
      when /.*\/assessments\/([0-9]*)/
        # Assessment show
        id = $1
      when /.*\/assessment\/([0-9]*)\/references\/files\/[0-9]*\/.*/
        # Reference show
        id = $1 if attachments
      end
      id 
    }.uniq

    where(id: ids_array)
  end
  
  def self.filter_by_answer_type(type, value)
    return scoped if type.blank? || value.blank?

    joins('LEFT OUTER JOIN answers ON assessment_id=assessments.id').where(answers: { answer_type: type }).where(answers: { text_value: value })
  end

  # gets all the countries associated through the geo_countries answers. Bit slow, sorry
  def countries
    countries_ids = self.answers.where(answer_type: 'geo_countries').first.try(:text_value).split(',')
    Country.where(:id => countries_ids)
  end
end
