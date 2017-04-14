#!/usr/bin/env python3
# 2015-12-09
#
# Take a single picture from the camera

import time
import picamera

with picamera.PiCamera() as camera:
    camera.resolution = (1600, 1200)
    camera.brightness = 70
    # The following is equivalent
    #camera.resolution = camera.MAX_IMAGE_RESOLUTION
    camera.start_preview()
    camera.start_recording('video.avi')
    time.sleep(5)
    camera.stop_recording()
