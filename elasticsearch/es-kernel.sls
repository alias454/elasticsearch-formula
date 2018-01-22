{% from "elasticsearch/map.jinja" import host_lookup as config with context -%}

# Disable transparent hugepages
elasticesearch-/etc/default/grub:
  file.replace:
    - name: /etc/default/grub
    - pattern: rhgb quiet
    - repl: rhgb quiet transparent_hugepage=never
    - onlyif: grep "rhgb quiet\"" /etc/default/grub

# Rebuild the grub config
command-rebuild-es-grub-cfg:
  cmd.run:
    - name: grub2-mkconfig -o /boot/grub2/grub.cfg
    - onchanges:
      - file: /etc/default/grub

# Create the tuned profile on the host
/etc/tuned/elasticsearch/tuned.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true
    - contents: |
        # Managed by Salt do not edit
        # /etc/tuned/myprofile-nothp/tuned.conf 
        [main]
        include=throughput-performance
        
        [vm]
        transparent_hugepages=never

# Set the es tuned profile as default
command-set-elasticsearch-tuned-profile:
  cmd.run:
    - name: tuned-adm profile elasticsearch
    - require:
      - file: /etc/tuned/elasticsearch/tuned.conf
    - unless: tuned-adm active |grep elasticsearch

# Create kernel override config for swappiness
# max_map_count, and ipv6 support
/etc/sysctl.d/10-ES_KernelOverride.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'

# Set kernel override for vm.swappiness
sysctl-set-swappiness:
  sysctl.present:
    - name: vm.swappiness
    - value: {{ config.kernel.vm_swappiness }}
    - config: /etc/sysctl.d/10-ES_KernelOverride.conf
    - require:
      - file: /etc/sysctl.d/10-ES_KernelOverride.conf 

# Set kernel override for vm.max_map_count
sysctl-set-max-map-count:
  sysctl.present:
    - name: vm.max_map_count
    - value: {{ config.kernel.vm_max_map_count }}
    - config: /etc/sysctl.d/10-ES_KernelOverride.conf
    - require:
      - file: /etc/sysctl.d/10-ES_KernelOverride.conf 

# Set kernel override for ipv6 all
sysctl-set-ipv6-all-disable-ipv6:
  sysctl.present:
    - name: net.ipv6.conf.all.disable_ipv6
    - value: 1
    - config: /etc/sysctl.d/10-ES_KernelOverride.conf
    - require:
      - file: /etc/sysctl.d/10-ES_KernelOverride.conf 

# Set kernel override for ipv6 default
sysctl-set-ipv6-default-disable-ipv6:
  sysctl.present:
    - name: net.ipv6.conf.default.disable_ipv6
    - value: 1
    - config: /etc/sysctl.d/10-ES_KernelOverride.conf
    - require:
      - file: /etc/sysctl.d/10-ES_KernelOverride.conf 

# Set kernel override for ipv6 lo
sysctl-set-ipv6-lo-disable-ipv6:
  sysctl.present:
    - name: net.ipv6.conf.lo.disable_ipv6
    - value: 1
    - config: /etc/sysctl.d/10-ES_KernelOverride.conf
    - require:
      - file: /etc/sysctl.d/10-ES_KernelOverride.conf 

# Set resource limits for the elasticsearch user
/etc/security/limits.d/90-elasticsearch.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        # Managed by Salt do not edit
        # Set resource limits for es user
        elasticsearch soft nofile 65536
        elasticsearch hard nofile 65536

        # allow user 'elasticsearch' mlockall
        elasticsearch soft memlock unlimited
        elasticsearch hard memlock unlimited
