{% from "elasticsearch/map.jinja" import host_lookup as config with context %}
{% if config.firewall.firewalld == 'Active' %}

# add some firewall magic
include:
  - firewall.firewalld

/etc/firewalld/services/es-transport.xml:
  file.managed:
    - source: salt://elasticsearch/files/es-transport.xml
    - user: root
    - group: root
    - mode: '0640'

command-restorecon-es-/etc/firewalld/services:
  cmd.run:
    - name: restorecon -R /etc/firewalld/services
    - unless:
      - ls -Z /etc/firewalld/services/es-transport.xml| grep firewalld_etc_rw_t

{% for server in config.firewall.allowed_sources %}

command-add-perm-rich-rule-es-transport-{{ server }}:
  cmd.run:
    - name: firewall-cmd --zone=internal --add-rich-rule="rule family="ipv4" source address="{{ server }}" service name="es-transport" accept" --permanent
    - unless: firewall-cmd --zone=internal --list-all |grep es-transport

command-add-rich-rule-es-transport-{{ server }}:
  cmd.run:
    - name: firewall-cmd --zone=internal --add-rich-rule="rule family="ipv4" source address="{{ server }}" service name="es-transport" accept"
    - unless: firewall-cmd --zone=internal --list-all |grep es-transport

{% endfor %}
{% endif %}
