{% from "elasticsearch/map.jinja" import host_lookup as config with context %}

# Create elasticsearch config override for systemd service
{% if config.elasticsearch.repo_version == '5.x' %}
/etc/systemd/system/elasticsearch.service.d/elasticsearch.conf:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch.systemd.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: '0640'
{% endif %}

# Make sure the service is running and restart the service unless
# restart_service_after_state_change is false
service-elasticsearch:
  service.running:
    - name: elasticsearch
    - enable: True
    - require:
      - pkg: package-install-elasticsearch
    {% if config.elasticsearch.restart_service_after_state_change == 'true' %}
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: java_heap_setting
     {% endif %}
