# vim: sts=2 ts=2 sw=2 et ai
{% from "composer/map.jinja" import composer with context %}

composer-install-pkg:
  pkgrepo.managed:
    - name: {{ composer.lookup.apt }}
    - dist: trusty
  pkg.latest:
    - name: {{ composer.lookup.pkgname }} 
    - refresh: True
    - forceyes: True
    - require:
      - pkgrepo: composer-install-pkg 
  cmd.run:
    - name: "composer self-update"
    - require:
      - pkg: composer-install-pkg
