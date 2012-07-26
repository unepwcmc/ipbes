class Assessment < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :contacts, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:text_value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :references, allow_destroy: true
  accepts_nested_attributes_for :contacts, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  validates :title, presence: true, uniqueness: true
  
  # Search with google custom search engine, then filter by answer types
  # Returns a scope object to only matching IDs
  # * q: the search term
  # * geo_scale: constrain results to the given geo scale
  #
  # @params [Hash] filters hash containing search params
  # @return [Relation] scoped assessments
  def self.search(filters)
    return all if filters['q'].blank? && filters['geo_scale'].blank?
    
    results = cse_query(filters['q']).filter_by_answer_type('geo_scale', filters['geo_scale'])
  end

  # Queries google custom search for the given query
  #
  # @params [String] q the search term
  # @return [Relation] scoped assessments
  def self.cse_query(q, attachments = false)
    return self if q.blank?

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
        id = $1
      end
      id 
    }.uniq

    where(id: ids_array)
  end
  
  # Adds the condition that answer_type=type answers must have given value
  #
  # @params [String] type answer types to filter on
  # @params [String] value answer_text value to require
  # @return [Relation] scoped assessments
  def self.filter_by_answer_type(type, value)
    return where('true') if type.blank? || value.blank?

    joins('LEFT OUTER JOIN answers ON assessment_id=assessments.id').where(answers: { answer_type: type }).where(answers: { text_value: value })
  end
end
