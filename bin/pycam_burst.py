#!/usr/bin/env python3
# 2015-12-09
#
# Take a single picture from the camera

import time
import picamera

with picamera.PiCamera() as camera:
    camera.resolution = (1600, 1200)
    # The following is equivalent
    #camera.resolution = camera.MAX_IMAGE_RESOLUTION
    camera.start_preview()
    time.sleep(2)
    camera.capture('Picture_1.jpg')
    time.sleep(0.1)
    camera.capture('Picture_3.jpg')
    time.sleep(0.1)
    camera.capture('Picture_4.jpg')
    time.sleep(0.1)
    camera.capture('Picture_5.jpg')
    time.sleep(0.1)
    camera.capture('Picture_6.jpg')
    time.sleep(0.1)
    camera.capture('Picture_7.jpg')
    time.sleep(0.1)
    camera.capture('Picture_8.jpg')
    time.sleep(0.1)
    camera.capture('Picture_9.jpg')
