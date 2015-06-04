# vim: sts=2 ts=2 sw=2 et ai
{% from "composer/map.jinja" import composer with context %}

composer-install-pkg:
  pkgrepo.managed:
    - name: {{ composer.lookup.apt }}
    - dist: trusty
  pkg.installed:
    - name: {{ composer.lookup.pkgname }}
    - refresh: True
    - force_yes: True
    - require:
      - pkgrepo: composer-install-pkg
  cmd.run:
    - name: "composer self-update"
    - env:
      - HOME: '/root'
    - require:
      - pkg: composer-install-pkg
