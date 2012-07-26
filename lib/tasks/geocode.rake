namespace :ipbes do
  desc "Geocodes all countries (just calls save on each country, rate limited)"
  task geocode_countries: :environment do
    # Trigger rate limited save on every country, geocode gem takes care of the rest
    Country.find_in_batches(:batch_size => 5) do |countries|
      countries.each(&:save)
      sleep(2)
    end
  end
end
