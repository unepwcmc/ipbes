namespace :ipbes do
  desc "Import data from 'countries.csv' into countries' table"
  task import_countries: :environment do
    require 'csv'

    Country.delete_all

    countries = CSV.read("#{Rails.root}/lib/data/countries.csv", {headers: true})
    countries.each do |row|
      Country.create(name: row[0], iso: row[1])
    end
  end
end

# Import countries on db:seed task
namespace :db do
  task seed: 'ipbes:import_countries'
end
