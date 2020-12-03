#!/bin/bash

time=$(date "+%Y%m%d%H%M")

zip -r kbase-core_bak${time}.zip kbase-core -x "kbase-core/DATAS/*" -x "kbase-core/WEB-INF/logs/*"

zip -r kbaseui-std_bak${time}.zip kbaseui-std -x "kbaseui-std/DATAS/*" -x "kbaseui-std/WEB-INF/logs/*" -x "kbaseui-std/docs/temp/*" -x "kbaseui-std/doc/export/*" -x "kbaseui-std/doc/struct/*"
