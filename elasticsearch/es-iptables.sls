{% from "elasticsearch/map.jinja" import host_lookup as config with context %}
{% if config.firewall.iptables.status == 'Active' %}

# add some firewall magic
include:
  - firewall.iptables

# Loop through list of http_allowed_sources and create firewall rules
{% for node in config.elasticsearch.http_allowed_sources %}

# Add permanent http_allowed_sources rule enabled on restarts
#-A INPUT -p tcp -m state --state NEW -m tcp --dport 9200 -j ACCEPT        
iptables-firewall-rule-es-http-allowed-{{ node.name }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: NEW
    - proto: tcp
    - comment: "es_http_allowed_sources"
    - source: {{ node.ip }}{{ node.mask }}
    - dport: {{ node.port }}
    - jump: ACCEPT
    - save: True 

{% endfor %}

# Loop through list of sources and create firewall rules
{% for node in config.elasticsearch.sources %}

#-A INPUT -p tcp -m state --state NEW -m tcp --dport 9300 -j ACCEPT        
iptables-firewall-rule-es-transport-allowed-{{ node.name }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: NEW
    - proto: tcp
    - comment: "es_transport_allowed_sources"
    - source: {{ node.ip }}{{ node.mask }}
    - dport: {{ node.port }}
    - jump: ACCEPT
    - save: True 

{% endfor %}

iptables-firewall-rule-allow-ssh:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: NEW
    - proto: tcp
    - dport: 22
    - jump: ACCEPT
    - save: True

iptables-firewall-rule-allow-established:
  iptables.append:
    - position: 100
    - table: filter
    - chain: INPUT
    - match: state
    - connstate: ESTABLISHED
    - jump: ACCEPT
    - save: True

iptables-firewall-rule-reject:
  iptables.append:
    - position: 101
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - save: True

{% endif %}
