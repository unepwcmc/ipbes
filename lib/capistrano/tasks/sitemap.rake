namespace :sitemap do
  desc "Generate sitemap"
  task :generate do
    on roles(:app) do
      within release_path do
      execute :bundle, :exec, :rake, "RAILS_ENV=#{fetch(:rails_env)} 'sitemap:refresh'"
    end
  end
end
end

namespace :sitemap do
  desc "Geocode"
  task :geocode do
    on roles(:app) do
      within release_path do
      execute :bundle, :exec, :rake,  "RAILS_ENV=#{fetch(:rails_env)} 'ipbes:geocode_countries'"
   end
 end
end
end
