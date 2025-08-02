# Easy ELK Stack Setup for Beginners

Greetings and Salutations!
This guide helps you set up the **ELK Stack** (Elasticsearch, Logstash, Kibana) on an fresh Ubuntu system — without crying - so much.

If you’re brand new to this stuff, don’t worry. Just follow along step-by-step. If something breaks, it’s not your fault. Probably. If it is, search for the answer in open stack and put problem solving capabilities in your resume.

---

## What Is This?

This script installs a log monitoring system (aka **SIEM**) using free tools:

- **Elasticsearch** — where your logs are stored
- **Kibana** — lets you view logs in a browser
- **Logstash** — collects and processes logs
  
This is great for home labs, learning cybersecurity, or feeling cool while watching your system logs scroll like you’re in a movie.

---

## What You Need

- A computer running **Ubuntu 20.04 or later**
- An internet connection
- A terminal (aka the black screen with the scary blinking cursor)
- A password for your system’s `elastic` user (you’ll set it after install)
- 😅 Some patience — the script takes a few minutes to run

---

## How to Use This (Step-by-Step)

### 1. **Open your terminal** (press Ctrl + Alt + T on Ubuntu or you can customize your settings in Ubuntu to open with Ctrl+T)

### 2. **Download the script**

If you have `git` installed:
```bash
git clone https://github.com/your-username/elk-siem-setup.git
cd elk-siem-setup

If not, just copy the script into a file manually:

nano elk-siem-setup.sh

Paste the script contents in, then save and exit (Ctrl+O, then Enter, then Ctrl+X).

Make the script executable

chmod +x elk-siem-setup.sh

Run the script as admin (this installs everything)

sudo ./elk-siem-setup.sh

You’ll be asked for your system password to confirm admin credentials to run.

Go get coffee, or stare into the void and ponder your existence. This script installs Java, Elasticsearch, Kibana, Logstash, Filebeat, and sets everything up so they essentially talk to each other.

Once the script finishes:

Open your browser

Go to:
http://localhost:5601 (or use your server’s IP if it’s remote)

Login as elastic with the password you set (or reset it using Elasticsearch docs)

You’ll see dashboards, logs, and all your system activity.

Test if it worked

curl -X GET http://localhost:9200

If you see a block that says something like "You Know, for Search", then that means Elasticsearch is working.

sudo systemctl restart elasticsearch
sudo systemctl restart kibana
sudo systemctl restart logstash


Explore Kibana’s “Discover” tab to view your system logs


Break something on purpose and watch it log it, or bruteforce passwords and locate logs with different add ons. I only have the trial for elastic for 8 more days so in the coming days I'm excited to see everything we're able to do together. 

This script is just a simple way to get started. You can upgrade it later by adding:

TLS encryption

Users and roles

Remote log collection

Alerts, dashboards, and more

For now — enjoy your new SIEM stack. You earned it.
