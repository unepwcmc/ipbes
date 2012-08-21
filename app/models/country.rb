class Country < ActiveRecord::Base
  geocoded_by :name
  after_validation :geocode
  has_many :assessments

  attr_accessor :assessment_count

  def to_param
    iso
  end

  # Get all countries for given assessments, plus their counts.
  # Bit slow because it doesn't use a proper join, sorry about that
  def self.for_assessments assessments
    countries = []
    assessments.each do |a|
      a.countries.each do |c|
        # Find index of country if already inserted
        index = countries.index do |stored_country|
          stored_country.id == c.id
        end
        if index.present?
          countries[index].assessment_count += 1
        else
          c.assessment_count ||= 1
          countries << c
        end
      end
    end
    countries
  end
end
