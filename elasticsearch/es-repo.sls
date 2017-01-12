/etc/yum.repos.d/Elasticsearch-2.x.repo:
  file.managed:
    - source: salt://elasticsearch/files/Elasticsearch-2.x.repo
    - user: root
    - group: root
    - mode: '0644'

command-import-es-signing-key:
  cmd.run:
    - name: rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
    - onchanges:
      - file: /etc/yum.repos.d/Elasticsearch-2.x.repo
