{% set user = pillar.get("user", "www-data") %}

/etc/nginx/nginx.conf:
  file.replace:
    - pattern: user www-data;
    - repl: user {{ user }};
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file:
    - absent

nginx:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - restart: True
    - watch:
      - file: /etc/nginx/nginx.conf
