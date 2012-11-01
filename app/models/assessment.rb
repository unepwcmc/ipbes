class Assessment < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :references, dependent: :destroy
  has_many :contacts, dependent: :destroy
  belongs_to :last_editor, :class_name => 'User'

  default_scope order('LOWER(title)')

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:answer_type] =~ /\_other(s)?/ && a[:text_value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :references, reject_if: lambda { |a| a[:file].blank? }, allow_destroy: true
  accepts_nested_attributes_for :contacts, reject_if: lambda { |a| a[:name].blank? }, allow_destroy: true

  validates :title, presence: true, uniqueness: true
  validates_presence_of :contacts

  scope :filter_by_published, lambda { |user_signed_in| user_signed_in ? scoped : where(published: true) }
  
  # Kaminari
  paginates_per 1001
  
  def self.search(filters)
    cse_query(filters['q'], (filters['attachments'] == 't'))
      .filter_by_answer_type([
        {type: 'geo_scale', value: filters['geo_scale']},
        {type: 'systems_assessed', value: filters['systems_assessed']},
        {type: 'tools_and_approaches', value: filters['tools_and_approaches']},

        {type: 'provisioning', value: filters['ecosystem_services_functions_assessed'], accepted_values: ['Food', 'Water', 'Timber/fibres', 'Genetic resources', 'Medicinal resources', 'Ornamental resources', 'Energy/fuel'], other_option: 'other_provisioning'},
        {type: 'supporting', value: filters['ecosystem_services_functions_assessed'], accepted_values: ['Habitat maintenance', 'Nutrient cycling', 'Soil formation and fertility', 'Primary production'], other_option: 'other_supporting'},
        {type: 'cultural_services', value: filters['ecosystem_services_functions_assessed'], accepted_values: ['Recreation and tourism', 'Spiritual, inspiration and cognitive development'], other_option: 'other_cultural'},
        {type: 'regulating', value: filters['ecosystem_services_functions_assessed'], accepted_values: ['Air quality', 'Climate regulation', 'Moderation of extreme events', 'Regulation of water flows', 'Regulation of water quality', 'Waste treatment', 'Erosion prevention', 'Pollination', 'Pest and disease control'], other_option: 'other_regulating'},

        {type: 'geo_countries', value: filters['country_id']}
      ])
  end

  def self.cse_query(q, attachments = false)
    return scoped if q.blank?

    require 'open-uri'
    response = Nokogiri::XML(open("http://www.google.com/search?cx=013379249883164858539:b_mvcbrgpgk&client=google-csbe&output=xml_no_dtd&q=#{Rack::Utils.escape(q)}"))

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

  def self.filter_by_answer_type(queries)
    answer_join = 1

    queries.
      # Make sure value is an Array or Nil
      each { |query|
        unless query[:value].nil?
          query[:value] = [query[:value]].flatten
          #query[:value] = (query[:value] & query[:accepted_values])
        end
      }.
      # Delete nil value queries
      delete_if { |query| query[:value].blank? }.
      map! { |query|
        text_value_queries = query[:value].
          map { |v|
            if !v.blank? && (!query[:accepted_values] || query[:accepted_values].include?(v))
              sanitize_sql_array(["',' || answers_#{answer_join}.text_value || ',' ILIKE ?", "%,#{ v },%"])
            end
          }.compact.join(' AND ')

        final_query = []

        unless text_value_queries.empty?
          final_query.push("(#{ sanitize_sql_array(["answers_#{answer_join}.answer_type = ?", query[:type]]) } AND (#{ text_value_queries }))")
        end

        if query[:other_option] && query[:value].any? { |v| v == query[:other_option] }
          final_query.push( sanitize_sql_array(["answers_#{answer_join}.answer_type = ?", "#{query[:type]}_other"]) )
        end

        # Increment answer_join
        answer_join += 1

        final_query.empty? ? nil : final_query.join(' AND ')
      }.compact!

    if queries.empty?
      scoped
    else
      join_queries = []
      (1...answer_join).to_a.each { |answer_num|
        join_queries.push("LEFT OUTER JOIN answers AS answers_#{answer_num} ON answers_#{answer_num}.assessment_id = assessments.id")
      }
      joins(join_queries).where(queries.join(' AND '))
    end
  end

  # Gets all the countries associated through the geo_countries answers. Bit slow, sorry
  def countries
    countries_ids = self.answers.where(answer_type: 'geo_countries').first.try(:text_value).split(',')
    Country.where(:id => countries_ids)
  end

  def self.set_db_timeout
    timeout = 10000
    Rails.logger.info "Setting DB timeout to #{timeout}"
    Assessment.connection.execute("SET statement_timeout TO #{timeout};")
  end

  def self.unset_db_timeout
    Rails.logger.info "Unsetting DB timeout"
    Assessment.connection.execute('RESET statement_timeout;')
  end
end
