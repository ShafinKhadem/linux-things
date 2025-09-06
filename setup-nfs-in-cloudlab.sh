#!/bin/bash

# Copy this script to project-wise NFS /proj/<project_id>/bin.
# Run this on node0 to set up an NFS server. Uses ssh to install/mount an
# NFS client on each of the other nodes in the experiment.

set -e
#set -x

NFS_PATH=/mnt/nfs
SSH_OPTS="-o StrictHostKeyChecking=no"
SSH="ssh ${SSH_OPTS}"

function host_list() {
    geni-get -a | \
        grep -Po '<host name=\\".*?\"' | \
        sed 's/<host name=\\"\(.*\)\\"/\1/' | \
        sort | \
        uniq
}

function setup_nfs_server() {
    sudo apt-get update
    sudo apt-get install -y nfs-kernel-server

    sudo mkdir -p ${NFS_PATH}
    sudo chown nobody:nogroup ${NFS_PATH}
    sudo chmod 777 ${NFS_PATH}
    grep "${NFS_PATH}" /etc/exports || echo "${NFS_PATH} (rw,no_subtree_check)" | sudo tee -a /etc/exports
    sudo exportfs -a
}

function setup_nfs_client() {
    sudo apt-get update && sudo apt-get install -y nfs-common
    sudo mkdir -p ${NFS_PATH}
    sudo mount -t nfs node0:${NFS_PATH} ${NFS_PATH}
}

host=$(hostname -s)
host_count=$(($(/usr/local/etc/emulab/tmcc hostnames | wc -l)-1))

case $host in
    "node0")
        echo Setting up nfs server on $host.
        setup_nfs_server

        echo Setting up nfs as client on $host_count nodes.
        SCRIPT_PATH=$(readlink -f "$0")
        for i in $(seq 1 ${host_count}); do
            ${SSH} node${i} ${SCRIPT_PATH}
        done
    ;;

    *)
        echo Setting up nfs client on $host.
        setup_nfs_client
    ;;
esac

