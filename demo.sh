#!/bin/bash
threshold=-20
setup=Squelch
channel=26
tag=$4


if [[ "$setup" == "UDP" ]]; then
    echo "Using the UDP setup"

elif [[ "$setup" == "RSSI_filter" ]]; then
    echo "Using the RSSI setup"

elif [[ "$setup" == "Squelch" ]]; then
    echo "Using the Squelch setup"
else
    echo "Using the NB-IOT setup"
fi


#Variables
docker_image=ericssonsics/5g-coral:$tag
#Get the ip address for the docker hosts from the /etc/host file
lower_host=sics-radiohead
upper_host=sics-edge

#get the pwd for the script
here=$(dirname $0)

echo "Installing tmux"
#sudo apt-get install tmux

echo "Deploying SICS-radiohead"
#$here/docker-remote-start.sh $docker_image sics-radiohead $lower_host 10.0.0.

echo "Deploying SICS-edge"
#$here/docker-remote-start.sh $docker_image sics-edge $upper_host 10.0.0.
session=5gCoral
window=$session:0

tmux  new-session -d -s $session

if [[ "$setup" != "nbiot" ]]; then
    # Setup a window for tailing log files
    tmux new-window -t $window -n "$window"
    tmux select-window -t $window
    tmux split-window -h
    tmux split-window -v -t left
    tmux split-window -v -t right
    tmux split-window -v -t bottom-right

    tmux select-pane -t left
    if [[ "$setup" == "UDP" ]]; then
        tmux send-keys "ssh -i coralkey user@$upper_host \"python -u Ericsson-SICS-SDR/iot-gw/common/setter_wrapper.py iot-gw/bin/iotgw_upper_udp.iotgw_upper_udp --lower-host=$lower_host\"" Enter
    else
        tmux send-keys "ssh -i coralkey user@$upper_host \"python -u Ericsson-SICS-SDR/iot-gw/common/setter_wrapper.py iot-gw/bin/iotgw_upper.iotgw_upper --lower-host=$lower_host\"" Enter
    fi

    tmux select-pane -t bottom-left
    if [[ "$setup" == "UDP" ]]; then
        tmux send-keys "ssh -i coralkey user@$lower_host \"python -u Ericsson-SICS-SDR/iot-gw/common/setter_wrapper.py iot-gw/bin/iotgw_usrp_lower_udp.iotgw_usrp_lower_udp --upper-host=$upper_host --base-channel=$channel --Threshold=$threshold\"" Enter

    elif [[ "$setup" == "RSSI_filter" ]]; then
        tmux send-keys "ssh -i coralkey user@$lower_host \"python -u Ericsson-SICS-SDR/iot-gw/common/setter_wrapper.py iot-gw/bin/iotgw_usrp_lower.iotgw_usrp_lower --upper-host=$upper_host --base-channel=$channel\"" Enter

    elif [[ "$setup" == "Squelch" ]]; then
        tmux send-keys "ssh -i coralkey user@$lower_host \"python -u Ericsson-SICS-SDR/iot-gw/common/setter_wrapper.py iot-gw/bin/iotgw_usrp_lower_squelch.iotgw_usrp_lower_squelch --upper-host=$upper_host --base-channel=$channel --Threshold=$threshold\"" Enter
    fi

    tmux select-pane -t top-right
    tmux send-keys "ssh -i coralkey user@$upper_host java -jar ./leshan-server-demo.jar" Enter

    tmux select-pane -D
    tmux send-keys "ssh -i coralkey user@$upper_host demo-eucnc/cng-iot-gw.sh" Enter

else
    tmux new-window -t $window -n "$window"
    tmux select-window -t $window
    tmux split-window -h

    tmux select-pane -t left
    
    tmux send-keys "ssh -i coralkey user@$upper_host \"python -u Ericsson-SICS-SDR/gr-nbiot/apps/edge.py --ip=$upper_host\"" Enter
    
    tmux select-pane -t right

    tmux send-keys "ssh -i coralkey -X user@$lower_host \"gnuradio-companion\"" Enter
fi


tmux attach-session -t $session

