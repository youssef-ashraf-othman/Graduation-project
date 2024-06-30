# Graduation-project
# Nurse Calling System

A comprehensive system designed to enhance patient care and improve communication between patients and nurses using ESP32 microcontrollers, Ethernet modules, Raspberry Pi, and custom PCBs.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Hardware Components](#hardware-components)
- [Software Components](#software-components)
- [System Architecture](#system-architecture)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [Future Improvements](#future-improvements)
- [Acknowledgements](#acknowledgements)

## Introduction
The Nurse Calling System is designed to improve patient care by enabling efficient communication between patients and nurses. The system consists of ESP32 microcontrollers for room-based input, a Raspberry Pi for call processing and display at the nurse station, and a Flutter application for real-time notifications.

## Features
- **Room-Based Call Buttons**: Each room has two buttons per bed (normal call and emergency call).
- **Real-Time Notifications**: Calls are displayed in real-time on a screen at the nurse station and sent to a Flutter mobile application.
- **Ethernet Connectivity**: ESP32 microcontrollers are connected to a router via Ethernet for reliable communication.
- **Scalable Architecture**: Easily add more ESP32 units and beds.

## Hardware Components
- **ESP32 Microcontrollers**: 2 units
- **Buttons**: 2 per bed (normal call and emergency call)
- **Ethernet Modules**: 2 units for ESP32
- **Router**
- **Raspberry Pi**
- **Screen**: Connected to the Raspberry Pi for call display

## Software Components
- **Python Application**: Runs on the Raspberry Pi to display incoming calls.
- **Flutter Application**: Receives notifications and displays calls on mobile devices.

## System Architecture
1. **Button Press**: Patient presses either normal call or emergency call button.
2. **Signal Transmission**: ESP32 sends call signal to the router via Ethernet.
3. **Router Forwarding**: Signal is forwarded to the Raspberry Pi.
4. **Call Display**: Raspberry Pi processes the signal and displays the call on the nurse station screen, and sends a notification to the Flutter app.
5. **Notification**: Flutter app displays the call to the nurse or caregiver on their mobile device.

## Setup and Installation
1. **Hardware Setup**:
    - Connect buttons to ESP32 units.
    - Connect ESP32 units to the router using Ethernet modules.
    - Connect the Raspberry Pi to the router and set up the display screen.

2. **Software Setup**:
    - **ESP32 Code**: Upload the ESP32 firmware from the `esp32` directory.
    - **Python Application**: Set up the Python app on the Raspberry Pi from the `raspberry_pi` directory.
        ```bash
        cd raspberry_pi
        pip install -r requirements.txt
        python app.py
        ```
    - **Flutter Application**: Install the Flutter app on mobile devices from the `flutter_app` directory.
        ```bash
        cd flutter_app
        flutter pub get
        flutter run
        ```

## Usage
1. Power on the ESP32 units and the Raspberry Pi.
2. Ensure all devices are connected to the router.
3. Monitor the nurse station screen for incoming calls.
4. Use the Flutter app on mobile devices to receive real-time notifications.

## Future Improvements
- Implement redundancy with a secondary communication path.
- Add a logging system for call tracking and analytics.
- Enhance security with encrypted data transmission.


## Acknowledgements
Special thanks to my supervisor and dedicated team members for their support and hard work.

---
