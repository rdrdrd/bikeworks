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

if __name__ == '__main__':
    init(pin)
    doIt(blink, pin, delay)
    cleanup()
