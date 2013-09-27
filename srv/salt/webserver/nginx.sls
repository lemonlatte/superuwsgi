{% set user = pillar.get("user", "www-data") %}

/etc/nginx/nginx.conf:
  file.replace:
    - pattern: user www-data;
    - repl: user {{ user }};

/etc/nginx/sites-enabled/default:
  file:
    - absent

nginx:
  pkg:
    - installed
  require:
    - file: /etc/nginx/nginx.conf
  service:
    - running
    - enable: True
    - restart: True
