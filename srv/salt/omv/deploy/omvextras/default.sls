# @license   http://www.gnu.org/licenses/gpl.html GPL Version 3
# @author    Volker Theile <volker.theile@openmediavault.org>
# @copyright Copyright (c) 2009-2019 Volker Theile
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

{% set config = salt['omv_conf.get']('conf.system.apt.distribution') %}
{% set use_kernel_backports = salt['pillar.get']('default:OMV_APT_USE_KERNEL_BACKPORTS', True) -%}

configure_apt_sources_list_omvextras:
  file.managed:
    - name: "/etc/apt/sources.list.d/omvextras.list"
    - source:
      - salt://{{ slspath }}/files/etc-apt-sources_list_d-omvextras_list.j2
    - template: jinja
    - context:
        config: {{ config | json }}
    - user: root
    - group: root
    - mode: 644

{% if not use_kernel_backports | to_bool %}

remove_apt_pref_omvextras:
  file.absent:
    - name: "/etc/apt/preferences.d/omvextras.pref"

{% else %}

configure_apt_pref_omvextras:
  file.managed:
    - name: "/etc/apt/preferences.d/omvextras.pref"
    - source:
      - salt://{{ slspath }}/files/etc-apt-preferences_d-omvextras_pref.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{% endif %}

refresh_apt_database:
  module.run:
    - name: pkg.refresh_db
