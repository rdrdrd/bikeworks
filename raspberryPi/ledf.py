#!/usr/bin/env python3

import RPi.GPIO, time, sys

pin = 2
delay = 1.0
blink = 10
if len(sys.argv) == 2:
    pin = int(sys.argv[1])
elif len(sys.argv) == 3:
    pin = int(sys.argv[1])
    delay = float(sys.argv[2])
elif len(sys.argv) == 4:
    pin = int(sys.argv[1])
    delay = float(sys.argv[2])
    blink = int(sys.argv[3])

print('using pin', pin, ', delay = ', delay)

def init(pin):
    RPi.GPIO.setmode(RPi.GPIO.BCM)
    RPi.GPIO.setup(pin, RPi.GPIO.OUT, initial = RPi.GPIO.LOW)

def doIt(blink, pin, delay):
    for i in range(blink):
        print(i)
        RPi.GPIO.output(pin, True)
        time.sleep(delay)
        RPi.GPIO.output(pin, RPi.GPIO.LOW)
        time.sleep(delay)

def cleanup(): RPi.GPIO.cleanup()

class LED(object):
    def __init__(self, blink = 5, pin = 4, delay = 0.5):
        self.blink = blink
    delf init: pass

if __name__ == '__main__':
    init(pin)
    doit(blink, pin, delay)
    cleanup()

    l1 = LED()
    l2 = LED(4)
    l3 = LED(6, 7)
    l4 = LED(6, 7, 8)
    l5 = LED(delay = 66)
