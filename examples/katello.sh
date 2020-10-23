#!/bin/sh

set -e

foreman-installer -v --scenario katello --no-colors --foreman-proxy-tftp false \
--foreman-plugin-tasks-automatic-cleanup true \
--enable-foreman-plugin-remote-execution --enable-foreman-proxy-plugin-remote-execution-ssh \
--foreman-initial-admin-password foreman

hammer organization create --name VVC
hammer defaults add --param-name organization --param-value VVC

# Use NIL as a workaround https://bugzilla.redhat.com/show_bug.cgi?id=1649011
hammer settings set --name default_proxy_download_policy --value immediate --organization NIL

hammer sync-plan create --name daily --interval daily --enabled yes --sync-date "$(date +%Y-%m-%d) 01:01:01"

hammer content-credentials create --content-type gpg_key --name RPM-GPG-KEY-foreman --key /etc/pki/rpm-gpg/RPM-GPG-KEY-foreman
hammer product create --name Foreman --gpg-key RPM-GPG-KEY-foreman --sync-plan daily
hammer repository create --name 'Foreman client 2.1 - el7' --label foreman-client-2_1-el7 \
--product Foreman --content-type yum --checksum-type sha256 \
--download-policy immediate --mirror-on-sync yes \
--url https://yum.theforeman.org/client/2.1/el7/x86_64 
hammer repository synchronize --product Foreman 

hammer content-view create --name EL7 --solve-dependencies yes
hammer content-view add-repository --name EL7 --repository 'Foreman client 2.1 - el7'
hammer content-view publish --name EL7

hammer activation-key create --name EL7 --content-view EL7 --environment Library
hammer activation-key add-subscription --name EL7 --subscription Foreman
