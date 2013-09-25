{% set mongodb_version = pillar.get("mongodb_version") %}

10gen-repo:
  pkgrepo.managed:
    - humanname: 10gen-repo
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com

mongodb-10gen:
  pkg.installed:
    - require:
      - pkgrepo: 10gen-repo
{% if mongodb_version %}
    - version: {{ mongodb_version }}
{% endif %}
