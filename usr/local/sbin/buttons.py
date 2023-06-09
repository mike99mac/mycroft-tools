#!/usr/bin/env python3
from mycroft_bus_client import MessageBusClient, Message
import signal
import subprocess
import sys
import RPi.GPIO as GPIO

class Buttons:
  """
  trap when GPIO pins 17, 27 and 22 are pressed and call
  prev_track(), stop() or next_track() in Mycroft
  """
  prev_button: int 
  stop_button: int 
  next_button: int     
  client:      MessageBusClient 
  message:     Message
  def __init__(self):
    """
    GPIO pin layout - odd pins are toward the inside of the Pi:
    '!' shows the pins used
       3V3  (1)  (2)  5V
     GPIO2  (3)  (4)  5V
     GPIO3  (5)  (6)  GND
     GPIO4  (7)  (8)  GPIO14
       GND  (9)! (10) GPIO15
    GPIO17 (11)! (12) GPIO18
    GPIO27 (13)! (14) GND
    GPIO22 (15)! (16) GPIO23
       3V3 (17)  (18) GPIO24
    GPIO10 (19)  (20) GND
     GPIO9 (21)  (22) GPIO25
    GPIO11 (23)  (24) GPIO8
       GND (25)  (26) GPIO7
     GPIO0 (27)  (28) GPIO1
     GPIO5 (29)  (30) GND
     GPIO6 (31)  (32) GPIO12
    GPIO13 (33)  (34) GND
    GPIO19 (35)  (36) GPIO16
    GPIO26 (37)  (38) GPIO20
       GND (39)  (40) GPIO21
    """
    print("in __init__()")
    self.prev_button = 17       
    self.stop_button = 27      
    self.next_button = 22     
    self.client = None
    self.monitor_buttons()

  def monitor_buttons(self):
    print("in monitor_buttons()")
    self.attach_message_bus()
    GPIO.setmode(GPIO.BCM)                 # set GPIO numbering
    GPIO.setup(self.prev_button, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.setup(self.stop_button, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.setup(self.next_button, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.add_event_detect(self.prev_button, GPIO.FALLING, callback=self.button_pressed, bouncetime=100)
    GPIO.add_event_detect(self.stop_button, GPIO.FALLING, callback=self.button_pressed, bouncetime=100)
    GPIO.add_event_detect(self.next_button, GPIO.FALLING, callback=self.button_pressed, bouncetime=100)
    signal.signal(signal.SIGINT, self.signal_handler)
    signal.pause()
  
  def attach_message_bus(self):
    """
    Attach to the Mycroft message bus 
    """
    print("Connecting to Mycroft message bus")
    self.client = MessageBusClient()
    print("Calling client.run_in_thread()")
    try:
      self.client.run_in_thread()
    except Exception as e:
      print("ERROR: run_in_thread() failed - is Mycroft running?")
      sys.exit(1)
  
  def signal_handler(self, sig, frame):
    """
    Trap Ctrl-C and cleanup before exiting
    """
    GPIO.cleanup()
    sys.exit(0)
  
  def send_message(self, the_message):
    """
    Send a message to the Mycroft message bus
    """
    the_command = "python3 -m mycroft.messagebus.send '"+the_message+"'"
    print("send_message(): running command: "+the_command)
    try:
      result = subprocess.check_output(the_command, shell=True)
    except subprocess.CalledProcessError as e:
      self.mpc_rc = str(e.returncode)
      print("send_message(): command: "+the_command+" returned "+str(e.returncode))

  def button_pressed(self, channel):
    """
    Perform action when one of the buttons is pressed 
    """
    print("button_pressed() channel = "+str(channel))
    GPIO.remove_event_detect(channel)      # turn button off to avoid double hits
    match channel:
      case self.prev_button:  
        print("Previous button - sending message: mycroft.audio.service.prev")
        self.send_message("mycroft.audio.service.prev")
      case self.stop_button:  
        print("Stop button - sending message: mycroft.stop")
        self.send_message("mycroft.stop")
      case self.next_button:  
        print("Next button - sending message: mycroft.audio.service.next")
        self.send_message("mycroft.audio.service.next")
      case _:                                # not expected
        print("Did not expect channel = "+str(channel))
    GPIO.add_event_detect(channel, GPIO.FALLING, callback=self.button_pressed, bouncetime=5) # turn button back on
          
buttons = Buttons()                        # create the singleton
  
