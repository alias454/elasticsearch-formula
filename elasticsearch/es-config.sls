{% from "elasticsearch/map.jinja" import host_lookup as config with context %}

# Create elasticsearch config file using template
/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch.yml
    - template: jinja
    - user: root
    - group: elasticsearch
    - mode: '0640'

# Elasticsearch version is 2.x
{% if config.package.repo_version == '2.x' %}

# Create elasticsearch logging config file using 2.x template
/etc/elasticsearch/logging.yml:
  file.managed:
    - source: salt://elasticsearch/files/logging.yml
    - template: jinja
    - user: root
    - group: elasticsearch
    - mode: '0640'

# Update appropriate 2.x config file with JAVA HEAP size
java_heap_setting:
  file.replace:
    - name: /etc/sysconfig/elasticsearch
    - pattern: |
        .?ES_HEAP_SIZE=[0-9]+g
    - repl: |
        ES_HEAP_SIZE={{ config.elasticsearch.es_heap_size }}

# Elasticsearch version is not 2.x
{% else %}

# Create elasticsearch logging config file using template
/etc/elasticsearch/log4j2.properties:
  file.managed:
    - source: salt://elasticsearch/files/log4j2.properties
    - template: jinja
    - user: root
    - group: elasticsearch
    - mode: '0640'

# Update appropriate 5.x config file with JAVA HEAP size
java_heap_setting:
  file.replace:
    - name: /etc/elasticsearch/jvm.options
    - pattern: |
        ^-Xms[0-9]+g
        ^-Xmx[0-9]+g
    - repl: |
        -Xms{{ config.elasticsearch.es_heap_size }}
        -Xmx{{ config.elasticsearch.es_heap_size }}

{% endif %}
