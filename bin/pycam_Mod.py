#!/usr/bin/env python3
# 2015-12-09
#
# Take a single picture from the camera

import time
import picamera
import sys

with picamera.PiCamera() as camera:
    camera.resolution = (1600, 1200)
    camera.video_stabilization = True
    camera.meter_mode = 'average'
    # The following is equivalent
    #camera.resolution = camera.MAX_IMAGE_RESOLUTION
    camera.start_preview()
    time.sleep(5)
    filename = 'foo.jpg'
    if len(sys.argv) > 1:
        filename = sys.argv[1]
    camera.capture(filename)
