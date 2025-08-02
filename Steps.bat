# ELK Stack + Filebeat Setup Script for Ubuntu
# Because you *could* do this manually... but also, why?
# Make sure you log in as a root user. You can log in by inputting:
sudo passwd root
Set password, then log in with set password with:
su root

# Now it should show "Root" in front of your name symbolizing you're now logged in as a root user
 
echo "Step 1: Installing your necessities"
sudo apt update
sudo apt install default-jre 

# You can also see the list of Java options:

java -version

echo "Step 2: Adding Elastic's official repo"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch --no-check-certificate | sudo apt-key add -
# If you don't have command wget install with:
sudo apt install wget 
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list'
sudo apt update
wget -q0 - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
### Elasticsearch ###
echo "Step 3: Installing Elasticsearch — the brain of the operation."
sudo apt install -y elasticsearch

echo "Step 4: Configuring Elasticsearch"
sudo nano /etc/elasticsearch/elasticsearch.ymlcluster.name: siem-cluster
network.host: 0.0.0.0 (Remove #)
port:9200 (Remove #)
discovery.type: single-node
xpack.security.enabled: true


echo "🚀 Starting Elasticsearch. Give it a sec, she's dramatic"
# It seems like it's not going to launch but it can take an awkwardly long time
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch
# Verify status with 
sudo systemctl status elasticsearch

### Kibana ###
echo "Step 5: Installing Kibana — aka the thing that makes you look smart with pretty graphs"
sudo apt install -y kibana

echo "Step 6: Making sure Kibana talks to Elasticsearch after a messy divorce"
sudo nano /etc/kibana/kibana.yml
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
port:5601

sudo systemctl enable kibana
sudo systemctl start kibana
sudo systemctl status kibana

### Logstash ###
echo "Step 7: Installing Logstash — the middleman who’s trying his best."
sudo apt install -y logstash

echo "Step 8: Giving Logstash pipeline....."
sudo nano /etc/logstash/conf.d/2-beats-input.confinput {
 
beats {
    port => 5044
  }
}
filter {
  if [fileset][module] == "system" {
    grok {
      match => { "message" => "%{SYSLOGLINE}" }
    }
    date {
      match => [ "timestamp", "ISO8601" ]
    }
  }
}
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    user => "elastic"
    password => "YOUR_PASSWORD"  # <- Replace me. Seriously. Don't leave it like this.
    index => "syslog-%{+YYYY.MM.dd}"
  }
}


sudo systemctl enable logstash
sudo systemctl start logstash


echo "Login as 'elastic' and try to remember that password you swore you'd never forget."


FN-W swap wasd

# Sorry that was a note for my reddragon keyboard that had the arrow keys swapped foor wasd. I hope this helped with creating your own SIEM Home lab. Make sure to log into elastic to configure your integrations to see specific logs.
# The next project will be me using this same homelab to onboard users and simulate a ssh brute force attack against various users and spotting the attack on the logs that will be customized. 

# See you then and thanks for reading!
