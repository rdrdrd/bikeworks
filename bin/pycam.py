#!/usr/bin/env python3
# 2015-12-09
#
# Take a single picture from the camera

import time
import picamera

with picamera.PiCamera() as camera:
    camera.resolution = (2592, 1944)
    # The following is equivalent
    #camera.resolution = camera.MAX_IMAGE_RESOLUTION
    camera.start_preview()
    time.sleep(2)
    camera.capture('foo.jpg')
