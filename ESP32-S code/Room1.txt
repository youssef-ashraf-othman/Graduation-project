# Nurse Calling System - ESP32 Code

This code is part of the Nurse Calling System project. It runs on ESP32 microcontrollers and handles the communication between patient call buttons and the nurse station. The ESP32s are connected to a router via Ethernet and use MQTT for communication.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Hardware Components](#hardware-components)
- [Dependencies](#dependencies)


## Introduction
The ESP32 code is designed to interface with patient call buttons and send call status to a central server using MQTT. It handles normal and emergency calls, indicated by different button presses, and updates the nurse station via MQTT messages.

## Features
- **Button Press Detection**: Detects normal and emergency calls from patient buttons.
- **LED Indication**: Changes LED states based on call status.
- **MQTT Communication**: Sends call status to the server and receives reset commands.
- **Ethernet Connectivity**: Connects to the network via Ethernet for reliable communication.

## Hardware Components
- **ESP32 Microcontroller**
- **Ethernet Module**: For network connectivity
- **Buttons**: Two per bed (normal call and emergency call)
- **LEDs**: For visual indication of call status (green for idle, red for active call)

## Dependencies
- **SPI.h**: SPI communication library
- **Ethernet2.h**: Ethernet library for network connectivity
- **PubSubClient.h**: MQTT client library

