base-pkgs:
  pkg.installed:
    - names:
      - build-essential
      - python-dev
      - python-pip
      - python-virtualenv
      - libevent-dev

nginx:
  pkg.installed

supervisor:
  pip.installed:
    - require:
      - pkg: base-pkgs

  file:
    - managed
    - name: /etc/init/supervisor.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://webserver/configs/supervisor/upstart.jinja
    - require:
      - pip: supervisor

  cmd:
    - run
    - name: echo_supervisord_conf > /etc/supervisord.conf
    - unless: test -f /etc/supervisord.conf
    - require:
      - pip: supervisor

  service:
    - running
    - restart: True
    - stop: True
    - watch:
      - file: supervisor
      - cmd: supervisor

gevent:
  pip.installed:
    - require:
      - pkg: base-pkgs

uwsgi:
  pip.installed:
    - require:
      - pkg: base-pkgs

