namespace :ipbes do
  desc "Geocodes all countries (just calls save on each country, rate limited)"
  task geocode_countries: :environment do
    # Trigger rate limited save on every country, geocode gem takes care of the rest
    Country.all.each do |country|
      country.save
      sleep(0.5)
    end
  end
end
