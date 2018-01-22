{% from "elasticsearch/map.jinja" import host_lookup as config with context -%}

# Configure repo file for RHEL based systems
{% if salt.grains.get('os_family') == 'RedHat' %}
elasticsearch_repo:
  pkgrepo.managed:
    - name: Elasticsearch
    - comments: |
        # Managed by Salt Do not edit
        # Elasticsearch repository for {{ config.elasticsearch.repo_version }} packages
    - baseurl: {{ config.elasticsearch.repo_baseurl }}
    - gpgcheck: 1
    - gpgkey: {{ config.elasticsearch.repo_gpgkey }}
    - enabled: 1

# Import signing key for Elasticsearch
command-import-es-signing-key:
  cmd.run:
    - name: rpm --import {{ config.elasticsearch.repo_gpgkey }}
    - onchanges:
      - pkgrepo: elasticsearch_repo
{% endif %}
