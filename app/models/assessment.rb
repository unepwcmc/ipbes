class Assessment < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :contacts, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:text_value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :references, allow_destroy: true
  accepts_nested_attributes_for :contacts, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  validates :title, presence: true, uniqueness: true
  
  # Search with google custom search engine
  # Returns a scope object to only matching IDs
  #
  # @params [String] query The term to search for
  # @return [Relation] scoped assessments
  def self.search(filters)
    return all if filters['query'].blank? && filters['geo_scale'].blank?
    
    results = query(filters['query']).filter_by_answer_type('geo_scale', filters['geo_scale'])
    results.is_a?(Class) ? [] : results
  end

  def self.query(q, attachments = false)
    return self if q.blank?

    require 'open-uri'
    response = Nokogiri::XML(open("http://www.google.com/search?cx=013379249883164858539:b_mvcbrgpgk&client=google-csbe&output=xml_no_dtd&q=#{q}"))

    ids_array = response.xpath('//GSP/RES/R/U').map { |u| u.content.split('/').last }.uniq

    where(id: ids_array)
  end
  
  def self.filter_by_answer_type(type, value)
    return self if type.blank? || value.blank?

    joins('LEFT OUTER JOIN answers ON assessment_id=assessments.id').where(answers: { answer_type: type }).where(answers: { text_value: value })
  end
end
