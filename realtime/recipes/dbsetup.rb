node[:deploy].each do |app_name, deploy|
   execute "mysql-create-table" do
    command "/usr/bin/s3cmd --config=/srv/www/realtime/current/.s3cfg get s3://#{deploy[:database][:bucketnast]}/schema/realtime.sql; mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} -h#{deploy[:database][:host]} < realtime.sql"
    not_if "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} -h#{deploy[:database][:host]} #{deploy[:database][:database]} -e'SHOW TABLES' | grep #{node[:realtime][:dbtable]}"
    action :run
  end
end
