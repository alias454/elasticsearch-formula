# Install elasticsearch from a package

package-install-elasticsearch:
  pkg.installed:
    - pkgs:
      - java-1.8.0-openjdk-headless
      - elasticsearch
    - require:
      - pkgrepo: elasticsearch_repo
