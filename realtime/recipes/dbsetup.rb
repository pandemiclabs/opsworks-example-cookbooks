node[:deploy].each do |app_name, deploy|
   "mysql-create-table" do
    command "/usr/bin/s3cmd --config=/srv/www/realtime/current/.s3cfg get #{deploy[:mongo][:bucketnast]}/schema/realtime.sql; mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} < /srv/www/realtime/current/realtime.sql"
    not_if "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} -e'SHOW TABLES' | grep #{node[:realtime][:dbtable]}"
    action :run
  end
end
