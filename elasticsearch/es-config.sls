{% from "elasticsearch/map.jinja" import host_lookup as config with context %}

# Create elasticsearch config file using template
/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch.yml
    - template: jinja
    - user: root
    - group: elasticsearch
    - mode: '0640'

# Create elasticsearch logging config file using template
/etc/elasticsearch/logging.yml:
  file.managed:
    - source: salt://elasticsearch/files/logging.yml
    - template: jinja
    - user: root
    - group: elasticsearch
    - mode: '0640'

# Update sysconfig config file with HEAP size
/etc/sysconfig/elasticsearch:
  file.replace:
    - name: /etc/sysconfig/elasticsearch
    - pattern: |
        .?ES_HEAP_SIZE=[0-9]+g
    - repl: |
        ES_HEAP_SIZE={{ config.elasticsearch.es_heap_size }}
