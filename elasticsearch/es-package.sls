package-install-elasticsearch:
  pkg.installed:
    - pkgs:
      - java-1.8.0-openjdk-headless
      - elasticsearch
    - require:
      - file: /etc/yum.repos.d/Elasticsearch-2.x.repo
