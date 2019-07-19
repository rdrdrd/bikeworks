import os
import sys

import RPi.GPIO as GPIO

from functools import partial
from PyQt5                              import QtCore, QtGui, QtWidgets
from PyQt5.QtGui                        import QPixmap
from PyQt5.QtWidgets                    import QPushButton, QMainWindow, QApplication

from AutoGeneratedMainWindow            import Ui_MainWindow
from PathManager import ProjectDirectory

class MainWindow(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self, projectDirectory):
    
        self.projectDirectory = projectDirectory
        
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)

        taskBarIcon = QtGui.QIcon()
        taskBarIcon.addFile(os.path.join(self.projectDirectory.PROJECT_DIRECTORY + '/Images/RaspberryPiIcon.png'))
        self.setWindowIcon(taskBarIcon)
        
        pixmap = QPixmap(os.path.join(self.projectDirectory.PROJECT_DIRECTORY + '/Images/RaspberryPi2Pinout75Pecent.png'))

        w = self.label.width();
        h = self.label.height();
        self.label.setPixmap(pixmap);
        
        GPIO.setmode(GPIO.BOARD)
        self.gpioPinList = [3,5,7,11,13,15,19,21,23,29,31,33,35,37,8,10,12,16,18,22,24,26,32,36,38,40]
        self.gpioButtonList = [self.pushButtonGPIO_02, self.pushButtonGPIO_03, self.pushButtonGPIO_04, self.pushButtonGPIO_17, self.pushButtonGPIO_27, self.pushButtonGPIO_22, self.pushButtonGPIO_10, self.pushButtonGPIO_09, self.pushButtonGPIO_11, self.pushButtonGPIO_05, self.pushButtonGPIO_06, self.pushButtonGPIO_13, self.pushButtonGPIO_19, self.pushButtonGPIO_26, self.pushButtonGPIO_14, self.pushButtonGPIO_15, self.pushButtonGPIO_18, self.pushButtonGPIO_23, self.pushButtonGPIO_24, self.pushButtonGPIO_25, self.pushButtonGPIO_08, self.pushButtonGPIO_07, self.pushButtonGPIO_12, self.pushButtonGPIO_16, self.pushButtonGPIO_20, self.pushButtonGPIO_21]

        for index, button in enumerate(self.gpioButtonList):   
            button.setStyleSheet(
            "QPushButton {\n" +
            "background-color: gray;\n" + 
            "border-style: outset;\n" +
            "border-width: 1px;\n" + 
            "border-radius: 10px;\n" +
            "border-color: black;\n"+
            "font: bold 14px;}\n")       
            button.setCheckable(True)
            button.setChecked(True)
            button.toggle()
            button.clicked.connect(partial(self.toggleGpio, index))
            GPIO.setup(self.gpioPinList[index], GPIO.OUT, initial = 0)
            
        self.show()
        
    def toggleGpio(self, index):
        if self.gpioButtonList[index].isChecked():
            self.gpioButtonList[index].setStyleSheet(
            "QPushButton {\n" +
            "background-color: green;\n" + 
            "border-style: outset;\n" +
            "border-width: 1px;\n" + 
            "border-radius: 10px;\n" +
            "border-color: black;\n"+
            "font: bold 14px;}\n")  
             
            GPIO.output(self.gpioPinList[index], GPIO.HIGH)
        else:
            self.gpioButtonList[index].setStyleSheet(
            "QPushButton {\n" +
            "background-color: gray;\n" + 
            "border-style: outset;\n" +
            "border-width: 1px;\n" + 
            "border-radius: 10px;\n" +
            "border-color: black;\n"+
            "font: bold 14px;}\n")  
            GPIO.output(self.gpioPinList[index], GPIO.LOW)
        
