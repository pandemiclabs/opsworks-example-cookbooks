node[:deploy].each do |app_name, deploy|

  template "#{deploy[:deploy_to]}/current/config/db.js" do
    source "db.js.erb"
    mode 0660
    group deploy[:group]
    owner "root"

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
      :mongoport =>(deploy[:mongo][:port] rescue nil),
      :bucketnast => (deploy[:database][:bucketnast] rescue nil)
    )

    only_if do
      File.directory?("#{deploy[:deploy_to]}/current")
    end
  end
  
  template "#{deploy[:deploy_to]}/current/.s3cfg" do
    source "s3cmd.config.erb"
    mode 0660
    group deploy[:group]
    owner "root"

    variables(
      :access_key => (deploy[:mongo][:access_key] rescue nil),
      :secret_key => (deploy[:mongo][:secret_key] rescue nil)
    )

    only_if do
      File.directory?("#{deploy[:deploy_to]}/current")
    end
  end
end
