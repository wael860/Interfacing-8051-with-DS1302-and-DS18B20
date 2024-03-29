# Interfacing-8051-with-DS1302-and-DS18B20
This project involves interfacing the 8051-microcontroller with the DS1302 real-time clock (RTC) and the DS18B20 temperature sensor

The Microcontroller 8051 is widely used for different applications, these applications include remote control, alarms, and many more. This project utilizes 8051 to achieve two tasks. The first task is to use the chip time (DS1302) that is interfaced with the 8051 through the development board (STC 8051). To illustrate, date and time are to be extracted from DS1302 and displayed on the 16x2 LCD screen, where the first row should display the date (Like so: yyyy/mm/dd), and the second row should display the time in a 24-hour format (Like so: 23:59 /59/59). Furthermore, date and time should be synchronized and updated continuously.

The second task is to use the temperature sensor (DS18B20) to read the data from the temperature sensor and display it in the 7-segment display. Temperature is in C° unit, with a floating decimal of 4 digits (i.e., 25.5 C° will be displayed like so: 25.5000). The temperature should be updated continuously.
