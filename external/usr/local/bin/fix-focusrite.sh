#!/bin/bash
# Resetting Focusrite Scarlett 18i20 on Bus 1 Port 5
echo "1-5" > /sys/bus/usb/drivers/usb/unbind
sleep 2
echo "1-5" > /sys/bus/usb/drivers/usb/bind
