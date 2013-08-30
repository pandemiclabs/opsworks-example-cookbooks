node[:deploy].each do |app_name, deploy|

  template "#{deploy[:deploy_to]}/current/config/db.js" do
    source "db.js.erb"
    mode 0660
    group deploy[:group]

    if platform?("ubuntu")
      owner "www-data"
    elsif platform?("amazon")   
      owner "apache"
    end

    variables(
      :host =>     (deploy[:database][:host] rescue nil),
      :user =>     (deploy[:database][:username] rescue nil),
      :password => (deploy[:database][:password] rescue nil),
      :db =>       (deploy[:database][:database] rescue nil),
      :port =>     (deploy[:database][:port] rescue nil),
      :mongohost =>(deploy[:mongo][:host] rescue nil),
      :database => (deploy[:mongo][:database] rescue nil),
      :mongoport =>(deploy[:mongo][:port] rescue nil)
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end
