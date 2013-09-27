/etc/init/supervisor.conf:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://webserver/templates/supervisor/upstart.jinja
    - require:
      - pip: supervisor

/etc/supervisord/conf.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/supervisord.conf:
  cmd.run:
    - name: echo_supervisord_conf > /etc/supervisord.conf
    - unless: test -f /etc/supervisord.conf
    - require:
      - pip: supervisor

  file.append:
    - sources:
      - salt://webserver/templates/supervisor/include.jinja
    - require:
      - cmd: /etc/supervisord.conf
      - file: /etc/supervisord/conf.d


supervisor:
  pip.installed:
    - require:
      - pkg: base-pkgs

  service:
    - running
    - enable: True
    - restart: True
    - require:
      - pip: supervisor
    - watch:
      - file: /etc/init/supervisor.conf
      - file: /etc/supervisord.conf
