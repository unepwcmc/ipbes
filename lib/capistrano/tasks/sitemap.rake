namespace :sitemap
  desc "Generate sitemap"
  task :generate do
    on roles(:app) do
      execute "cd #{latest_release} && bundle exec RAILS_ENV=#{rails_env} sitemap:refresh"
    end
  end
end


namespace :sitemap
  desc "Geocode"
  task :geocode do
    on roles(:app) do
      execute "cd #{latest_release} && bundle exec #{rake} RAILS_ENV=#{rails_env} ipbes:geocode_countries"
   end
 end
end

