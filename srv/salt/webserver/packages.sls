base-pkgs:
  pkg.installed:
    - names:
      - build-essential
      - python-dev
      - python-pip
      - python-virtualenv

{% if pillar.get("use_gevent", False) %}
libevent-dev:
  pkg.installed:
    - require_in:
      - pip: gevent

gevent:
  pip.installed:
    - require:
      - pkg: base-pkgs

{% endif %}
uwsgi:
  pip.installed:
    - require:
      - pkg: base-pkgs
