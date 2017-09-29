VAGRANTFILE_API_VERSION = "2"

BRANCH = ENV['BRANCH'] || 'master'

$script = <<SCRIPT
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce=17.06.2~ce-0~ubuntu
sudo su -c "curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose

sudo -E bash -c "$(wget -O - https://raw.githubusercontent.com/datosgobar/portal-geoandino/master/install/install.sh)"
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "bento/ubuntu-16.04"
  config.vm.define "server" do |web|
      web.vm.network "private_network", ip: "192.168.36.10"
      config.vm.provision "shell", inline: $script,
        env: {
        "POSTGRES_USER" => "psql_user",
        "POSTGRES_DB" => "psql_db",
        "DATASTORE_DB" => "psql_datastore",
        "ALLOWED_HOST_IP" => "*",
        "ALLOWED_HOST" => "*",
        "SITEURL" => "http://192.168.36.10",
        "POSTGRES_PASSWORD" => "pass",
        "GEOANDINO_YES_INSTALL" => "1"
      }
  end

end
