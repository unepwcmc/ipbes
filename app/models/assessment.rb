class Assessment < ActiveRecord::Base
  belongs_to :editor, class_name: 'User', foreign_key: 'editor_id'

  has_many :answers, dependent: :destroy
  has_many :contacts

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:text_value].blank? }, allow_destroy: true

  validates :title, presence: true, uniqueness: true

  # Search with google custom search engine
  # Returns a scope object to only matching IDs
  #
  # @params [String] query The term to search for
  # @return [Relation] scoped assessments
  def self.search(query)
    require 'open-uri'
    response = Nokogiri::XML(open("http://www.google.com/search?cx=013379249883164858539:b_mvcbrgpgk&client=google-csbe&output=xml_no_dtd&q=#{query}"))

    # Get the response IDs
    ids = []
    response.xpath('//GSP/RES/R/U').each do |result|
      ids << result.content.split('/').last
    end
    ids.uniq
    Assessment.where(:id => ids)
  end

end
