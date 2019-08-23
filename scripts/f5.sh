#!/bin/bash

#wait for big-ip
logger -p local0.info 'firstrun debug: waiting for big-ip'
sleep 180

#configure big-ip
logger -p local0.info 'firstrun debug: starting tmsh config'

#admin
tmsh modify auth user admin { password 6xEIT6dc@6YPqiM }
tmsh modify auth user admin shell bash
tmsh modify sys global-settings gui-setup disabled

#vlan
tmsh create net vlan external interfaces add { 1.1 { untagged } }
tmsh create net self 10.0.1.200 address 10.0.1.200/24 vlan external
tmsh create net vlan internal interfaces add { 1.2 { untagged } }
tmsh create net self 10.0.2.200 address 10.0.2.200/24 vlan internal

tmsh modify net self-allow defaults all

tmsh save sys config
