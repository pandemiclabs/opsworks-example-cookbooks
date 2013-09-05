node[:deploy].each do |app_name, deploy|
    script "mysql-create-schema" do
        interpreter "bash"
        user "root"
        cwd "#{deploy[:deploy_to]}/current"
        code <<-EOH
        /usr/bin/s3cmd --config=#{deploy[:deploy_to]}/current/.s3cfg get s3://#{deploy[:database][:bucketnast]}/schema/#{deploy[:database][:schema]}
        /usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} -h#{deploy[:database][:host]} < #{deploy[:database][:schema]}
        EOH
    end

    not_if do
        File.exists?("#{deploy[:deploy_to]}/current/#{deploy[:database][:schema]}")
    end
end
