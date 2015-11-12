# Primary domain name of your application. Used in the Apache configs
set :domain, "http://catalog.ipbes.net"
## List of servers
server "unepwcmc-014.vm.brightbox.net", :app, :web, :db, :primary => true
