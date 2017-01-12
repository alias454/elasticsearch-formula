elasticesearch-/etc/default/grub:
  file.replace:
    - name: /etc/default/grub
    - pattern: rhgb quiet
    - repl: rhgb quiet transparent_hugepage=never
    - onlyif: grep "rhgb quiet\"" /etc/default/grub

command-rebuild-es-grub-cfg:
  cmd.run:
    - name: grub2-mkconfig -o /boot/grub2/grub.cfg
    - onchanges:
      - file: /etc/default/grub

/etc/tuned/elasticsearch/tuned.conf:
  file.managed:
    - source: salt://elasticsearch/files/es_tuned.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

command-set-elasticsearch-tuned-profile:
  cmd.run:
    - name: tuned-adm profile elasticsearch
    - require:
      - file: /etc/tuned/elasticsearch/tuned.conf
    - unless: tuned-adm active |grep elasticsearch

/etc/sysctl.d/10-ES_KernelOverride.conf:
  file.managed:
    - source: salt://elasticsearch/files/10-ES_KernelOverride.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

/etc/security/limits.d/90-elasticsearch.conf:
  file.managed:
    - source: salt://elasticsearch/files/90-elasticsearch.conf
    - user: root
    - group: root
    - mode: '0644'
