class Country < ActiveRecord::Base
  geocoded_by :name
  after_validation :geocode

  def to_param
    iso
  end

  # Get all countries for given assessment. Bit slow, sorry about that
  def self.for_assessments assessments
    countries = assessments.collect do |a|
      a.countries
    end
    countries.flatten.uniq
  end
end
