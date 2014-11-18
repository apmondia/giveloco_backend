namespace :api do
  desc "API Routes"
  task :routes => :environment do
    API::Root.routes.each do |api|
      if api.route_method && api.route_path && api.route_version
        method = api.route_method.ljust(10)
        path = api.route_path.gsub(":version", api.route_version)
        puts "     #{method} #{path}"
      elsif api.route_method && api.route_path
        puts "     #{api.route_method.ljust(10)} #{api.route_path}"
      end
    end
  end
end