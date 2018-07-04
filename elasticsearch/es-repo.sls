{% from "elasticsearch/map.jinja" import host_lookup as config with context -%}

# Configure repo file for RHEL based systems
{% if salt.grains.get('os_family') == 'RedHat' %}
elasticsearch_repo:
  pkgrepo.managed:
    - name: Elasticsearch
    - comments: |
        # Managed by Salt Do not edit
        # Elasticsearch repository for {{ config.package.repo_version }} packages
    - baseurl: {{ config.package.repo_baseurl }}
    - gpgcheck: 1
    - gpgkey: {{ config.package.repo_gpgkey }}
    - enabled: 1

# Import signing key for Elasticsearch
command-import-es-signing-key:
  cmd.run:
    - name: rpm --import {{ config.package.repo_gpgkey }}
    - onchanges:
      - pkgrepo: elasticsearch_repo

# Configure repo file for Debian based systems
{% elif salt.grains.get('os_family') == 'Debian' %}
# Import keys for pfring
command-apt-key-elasticsearch:
  cmd.run:
    - name: apt-key adv --fetch-keys {{ config.package.repo_gpgkey }}
    - unless: apt-key list elasticsearch

elasticsearch_repo:
  pkgrepo.managed:
    - name: {{ config.package.repo_baseurl }} /
    - file: /etc/apt/sources.list.d/elastic.list
    - comments: |
        # Managed by Salt Do not edit
        # Elasticsearch repository for {{ config.package.repo_version }} packages (Debian) 
    - gpgcheck: 1
    - key_url: {{ config.package.repo_gpgkey }}
    - disabled: True
{% endif %}
