#!/bin/bash

#wait for big-ip
logger -p local0.info 'waiting for big-ip'
sleep 120

#admin config
logger -p local0.info 'starting tmsh admin config'
tmsh modify auth user admin { password ${password} }
tmsh modify auth user admin shell bash
tmsh modify sys global-settings gui-setup disabled

#sd packages - to do


tmsh save sys config
