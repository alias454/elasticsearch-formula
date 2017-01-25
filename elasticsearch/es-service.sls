{% from "elasticsearch/map.jinja" import host_lookup as config with context %}

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
      - file: /etc/sysconfig/elasticsearch
     {% endif %}
