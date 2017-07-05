# -*- coding: utf-8 -*-
#########################################################################
#
# Copyright (C) 2016 OSGeo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
#########################################################################

import os
from geonode.settings import MAP_BASELAYERS

PROJECT_ROOT = os.path.abspath(os.path.dirname(__file__))
PROJECT_DIR = os.path.dirname(os.path.dirname(PROJECT_ROOT))

SITEURL = os.environ.get("SITEURL", "http://localhost/")

ALLOWED_HOSTS = [
    'localhost', '127.0.0.1',
    'geonode',
    os.environ.get("ALLOWED_HOST_IP", '127.0.0.1'), os.environ.get("ALLOWED_HOST_NAME", 'localhost')
]
PROXY_ALLOWED_HOSTS = (
    'localhost', '127.0.0.1',
    'geonode',
    os.environ.get("PROXY_ALLOWED_HOST_IP", '127.0.0.1'), os.environ.get("PROXY_ALLOWED_HOST_NAME", 'localhost'), 
)
POSTGIS_VERSION = (2, 1, 2)

DATABASES = {
    'default': {
         'ENGINE': 'django.db.backends.postgresql_psycopg2',
         'NAME': 'geonode',
         'USER': 'geonode',
         'PASSWORD': 'geonode',
         'HOST' : '{{ database_host }}',
         'PORT' : '5432',
     },
    # vector datastore for uploads
    'datastore' : {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        #'ENGINE': '', # Empty ENGINE name disables
        'NAME': '{{ data_db_name }}',
        'USER' : 'geonode',
        'PASSWORD' : 'geonode',
        'HOST' : '{{ database_host }}',
        'PORT' : '5432',
    }
}

GEOSERVER_LOCATION = os.getenv(
    'GEOSERVER_LOCATION', 'http://{{ geoserver_host }}:{{ geoserver_port }}/{{ geoserver_name }}/'
)
GEOSERVER_PUBLIC_LOCATION = os.getenv(
    'GEOSERVER_PUBLIC_LOCATION', "%s{{ geoserver_name }}/" % SITEURL
)

# OGC (WMS/WFS/WCS) Server Settings
OGC_SERVER = {
    'default': {
        'BACKEND': 'geonode.geoserver',
        'LOCATION': GEOSERVER_LOCATION,
        'LOGIN_ENDPOINT': 'j_spring_oauth2_geonode_login',
        'LOGOUT_ENDPOINT': 'j_spring_oauth2_geonode_logout',
        # PUBLIC_LOCATION needs to be kept like this because in dev mode
        # the proxy won't work and the integration tests will fail
        # the entire block has to be overridden in the local_settings
        'PUBLIC_LOCATION': GEOSERVER_PUBLIC_LOCATION,
        'USER' : 'admin',
        'PASSWORD' : 'geoserver',
        'MAPFISH_PRINT_ENABLED' : True,
        'PRINT_NG_ENABLED' : True,
        'GEONODE_SECURITY_ENABLED' : True,
        'GEOGIG_ENABLED' : False,
        'WMST_ENABLED' : False,
        'BACKEND_WRITE_ENABLED': True,
        'WPS_ENABLED' : False,
        'LOG_FILE' : '/dev/stdout',
        # Set to dictionary identifier of database containing spatial data in DATABASES dictionary to enable
        'DATASTORE': 'datastore',
    }
}

# If you want to enable Mosaics use the following configuration
#UPLOADER = {
##    'BACKEND': 'geonode.rest',
#    'BACKEND': 'geonode.importer',
#    'OPTIONS': {
#        'TIME_ENABLED': True,
#        'MOSAIC_ENABLED': True,
#        'GEOGIG_ENABLED': False,
#    }
#}


CATALOGUE = {
    'default': {
        # The underlying CSW implementation
        # default is pycsw in local mode (tied directly to GeoNode Django DB)
        #'ENGINE': 'geonode.catalogue.backends.pycsw_local',
        # pycsw in non-local mode
        # 'ENGINE': 'geonode.catalogue.backends.pycsw_http',
        # GeoNetwork opensource
        'ENGINE': 'geonode.catalogue.backends.geonetwork',
        # deegree and others
        # 'ENGINE': 'geonode.catalogue.backends.generic',

        # The FULLY QUALIFIED base url to the CSW instance for this GeoNode
        # 'URL': '%scatalogue/csw' % SITEURL,
        'URL': 'http://{{ catalog_host }}:{{ catalog_port }}/{{ catalog_name }}/srv/en/csw',
        # 'URL': 'http://localhost:8080/deegree-csw-demo-3.0.4/services',

        # login credentials (for GeoNetwork)
        'USER': 'admin',
        'PASSWORD': 'admin',
    }
}
MEDIA_ROOT = os.getenv('MEDIA_ROOT', os.path.join(PROJECT_DIR, "uploaded"))

# Absolute path to the directory that holds static files like app media.
# Example: "/home/media/media.lawrence.com/apps/"
STATIC_ROOT = os.getenv('STATIC_ROOT',
                        os.path.join(PROJECT_DIR, "static_root")
                        )

# Default preview library
#LAYER_PREVIEW_LIBRARY = 'geoext'

# Custom settings

MODIFY_TOPICCATEGORY = True

DEBUG = os.getenv("DEBUG", False)


LOCAL_GEOSERVER = {
        "source": {
            "ptype": "gxp_wmscsource",
            "url": OGC_SERVER['default']['PUBLIC_LOCATION'] + "wms",
            "restUrl": "/gs/rest"
        }
    }

# Disable by default
DEFAULT_OPENSTREET_MAP = {
        "source": {"ptype": "gxp_osmsource"},
        "type": "OpenLayers.Layer.OSM",
        "name": "mapnik",
        "visibility": True,
        "fixed": True,
        "group": "background"
    }

IGN_GEOSERVER = {
        "source": {"ptype": "gxp_olsource"},
        "type": "OpenLayers.Layer.WMS",
        "args": [
            'ING',
            'http://wms.ign.gob.ar/geoserver/wms',
            {
            'layers': ['capabaseargenmap'],
            "format":"image/png",
            "tiled": True,
            "tilesOrigin": [-20037508.34, -20037508.34],
            },

        ],
        "visibility": True,
        "fixed": True,
        "group": "background",
    }

MAP_BASELAYERS = [
    LOCAL_GEOSERVER,
    {
        "source": {"ptype": "gxp_olsource"},
        "type": "OpenLayers.Layer",
        "args": ["No background"],
        "name": "background",
        "visibility": False,
        "fixed": True,
        "group":"background"
    },
    IGN_GEOSERVER,
]