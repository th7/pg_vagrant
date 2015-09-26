set -e
sudo yum update -y

# install postgres
sudo yum localinstall -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
sudo yum install -y postgresql94-server

# initialize
sudo /usr/pgsql-9.4/bin/postgresql94-setup initdb

# configure -- what even is security?
echo "listen_addresses = '*'" | sudo tee -a /var/lib/pgsql/9.4/data/postgresql.conf
echo 'port = 5432' | sudo tee -a /var/lib/pgsql/9.4/data/postgresql.conf
echo 'host    all             all             192.168.1.0/16          trust' | sudo tee -a /var/lib/pgsql/9.4/data/pg_hba.conf

# start with os and start now
sudo chkconfig postgresql-9.4 on
sudo service postgresql-9.4 start

# open port 5432
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=5432/tcp --permanent
sudo firewall-cmd --reload
