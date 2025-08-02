# ELK Stack + Filebeat Setup Script for Ubuntu
# Because you *could* do this manually... but also, why?

set -e  # If this breaks, it breaks fast. Just like me under pressure.

ES_VER="8.9.0"
KIBANA_VER="$ES_VER"
LOGSTASH_VER="$ES_VER"
BEATS_VER="$ES_VER"

#Make sure you log in as a root user. You can log in by inputting:
sudo passwd root
Set password, then log in with set password with:
su root

#Now it should show "Root" in front of your name symbolizing you're now logged in as a root user
 
echo "📦 Step 1: Installing your nerdy necessities..."
sudo apt update
sudo apt install default-jre 

#You can also see the list of Java options:

java -version

echo "🔑 Step 2: Adding Elastic's official repo (aka inviting the cool kids to your package list)..."
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list'
sudo apt update
wget -q0 - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
### Elasticsearch ###
echo "📡 Step 3: Installing Elasticsearch — the brain of the operation."
sudo apt install -y elasticsearch=$ES_VER

echo "🛠 Step 4: Configuring Elasticsearch. Talking to localhost like a true introvert..."
sudo tee /etc/elasticsearch/elasticsearch.yml > /dev/null <<EOF
cluster.name: siem-cluster
network.host: 0.0.0.0
discovery.type: single-node
xpack.security.enabled: true
EOF

echo "🚀 Starting Elasticsearch. Give it a second... she dramatic."
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

### Kibana ###
echo "🖼 Step 5: Installing Kibana — aka the thing that makes you look smart with pretty graphs."
sudo apt install -y kibana=$KIBANA_VER

echo "🎛 Step 6: Making sure Kibana talks to Elasticsearch like they’re on speaking terms..."
sudo tee /etc/kibana/kibana.yml > /dev/null <<EOF
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
EOF

sudo systemctl enable kibana
sudo systemctl start kibana

### Logstash ###
echo "💬 Step 7: Installing Logstash — the middleman who’s trying his best."
sudo apt install -y logstash=$LOGSTASH_VER

echo "🧩 Step 8: Giving Logstash something to do with a basic pipeline..."
sudo tee /etc/logstash/conf.d/02-syslog.conf > /dev/null <<EOF
input {
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
EOF

sudo systemctl enable logstash
sudo systemctl start logstash

### Filebeat ###
echo "🪲 Step 9: Installing Filebeat — your loyal log butler."
sudo apt install -y filebeat=$BEATS_VER

echo "🛎 Step 10: Enabling the system module, because your system *definitely* has problems worth logging."
sudo filebeat modules enable system

echo "📡 Step 11: Configuring Filebeat to talk to Elasticsearch and show off in Kibana..."
sudo sed -i 's/#output.elasticsearch:/output.elasticsearch:\n  hosts: ["localhost:9200"]/' /etc/filebeat/filebeat.yml
sudo sed -i 's/#setup.kibana:/setup.kibana:\n  host: "localhost:5601"/' /etc/filebeat/filebeat.yml

echo "📊 Step 12: Setting up dashboards so your logs don't just vibe in the void..."
sudo filebeat setup

echo "🎬 Final Step: Starting Filebeat — the log courier you didn’t know you needed."
sudo systemctl enable filebeat
sudo systemctl start filebeat

echo ""
echo "✅ Done. Your Elastic SIEM stack is alive. Like Frankenstein. But cooler."
echo "➡ Visit: http://<your_server_ip>:5601 to feel like a hacker in a Netflix show."
echo "🔐 Login as 'elastic' and try to remember that password you swore you'd never forget."


FN-W swap wasd
