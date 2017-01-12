{% from "elasticsearch/map.jinja" import host_lookup as config with context %}

{% if config.elasticsearch.mounts.create_data_dir == 'true' %}
{{ config.elasticsearch.mounts.data_dir_name }}:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - mode: '0755'
    - makedirs: True
{% endif %}

{% if config.elasticsearch.mounts.create_archive_dir == 'true' %}
{{ config.elasticsearch.mounts.archive_dir_name }}:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - mode: '0755'
    - makedirs: True
{% endif %}

{% if config.elasticsearch.mounts.use_data_mount_device == 'true' %}
mount-{{ config.elasticsearch.mounts.data_dir_name }}:
  mount.mounted:
    - name: {{ config.elasticsearch.mounts.data_dir_name }}
    - fstype: {{ config.elasticsearch.mounts.data_mount_fstype }}
    - device: {{ config.elasticsearch.mounts.data_mount_device }}
    - mkmnt: True 
    - require:
      - file: {{ config.elasticsearch.mounts.data_dir_name }}
{% endif %}

{% if config.elasticsearch.mounts.use_data_mount_device == 'true' %}
mount-{{ config.elasticsearch.mounts.archive_dir_name }}:
  mount.mounted:
    - name: {{ config.elasticsearch.mounts.archive_dir_name }}
    - fstype: {{ config.elasticsearch.mounts.archive_mount_fstype }}
    - device: {{ config.elasticsearch.mounts.archive_mount_device }}
    - mkmnt: True
    - require:
      - file: {{ config.elasticsearch.mounts.archive_dir_name }}
{% endif %}
