#!/bin/bash

#wait for big-ip
sleep 120

#admin config
tmsh modify auth user admin { password ${password} }
tmsh modify auth user admin shell bash
tmsh modify sys global-settings gui-setup disabled

tmsh save sys config
