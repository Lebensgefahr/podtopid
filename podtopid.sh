#!/bin/bash

set -e


function sshrun(){
  COMMAND="$@"
  ssh -o ConnectTimeout=10 \
      -o StrictHostKeyChecking=no \
      "$USERNAME@$NODENAME" "$COMMAND"
}

function getNodeName(){
  kubectl get "$PODNAME" -o jsonpath='{.spec.nodeName}'
}

function getContainerIDS(){
  IDS=($(kubectl get "$PODNAME" -o jsonpath='{.status.containerStatuses[*].containerID}'))
  for ID in ${IDS[@]}; do 
    IDS_ARRAY+=(${ID/docker:\/\/})
  done
}

function getChildPidsByID(){
  for ID in ${IDS_ARRAY[@]}; do
    PID="$(sudo docker inspect --format '{{.State.Pid}}' "$ID")"
    getChildByPPID "$PID"
  done    
}

function getChildPidsThroughSSH(){
  sshrun "$(declare -f getChildPidsByID getChildByPPID); 
            IDS_ARRAY=(${IDS_ARRAY[@]}); getChildPidsByID"
}

function getChildByPPID {
  tp=($(pgrep -P "$1"))
  if [[ "${#tp[@]}" -eq 0 ]]; then
    ps -o pid=,cmd= "$1"
  else
    for i in ${tp[@]}; do        
      getChildByPPID $i
    done
  fi
}

PODNAME="$1"
IDS_ARRAY=()
USERNAME="user"
NODENAME="$(getNodeName)"

echo "Node:$NODENAME"
getContainerIDS && getChildPidsThroughSSH

