# Nurse Calling System - Flutter Application

A Flutter application for the Nurse Calling System, providing an interface for nurses to receive and respond to patient calls in real-time. The app consists of three main screens: Signup, Login, and Dashboard.


## Introduction
The Flutter application for the Nurse Calling System allows nurses to sign up, log in, and manage patient calls. The app provides real-time notifications of patient calls and displays timing to achieve priority on the Dashboard screen.

## Features
- **Signup and Login**: Secure user authentication with embedded database support.
- **Real-Time Dashboard**: Displays patient calls in real-time, including timing to achieve priority.
- **Notification System**: Alerts nurses of new patient calls with push notifications.
- **Responsive UI**: User-friendly interface for efficient navigation and interaction.

## Screens

### Signup Screen
The Signup screen allows new users to create an account. User information is stored in a local database using the `sqflite` package.

### Login Screen
The Login screen enables existing users to log into the app. Authentication is handled through the local database.

### Dashboard Screen
The Dashboard screen displays active patient calls. Each call is represented by a container that appears when a call is received and disappears when the call is responded to. It also shows the timing to achieve priority for each call.

## Notification System
The app utilizes push notifications to alert nurses of new patient calls. Notifications provide timely updates even when the app is not actively open.

## Database Integration
The app uses the `sqflite` package for local database management. User credentials and session data are securely stored and retrieved from the database.

##Usage
Signup: Open the app and navigate to the Signup screen to create a new account.
Login: Use the Login screen to access your account.
Dashboard: Monitor and respond to patient calls from the Dashboard screen. Calls will appear as containers with timing to achieve priority displayed. Responding to a call will remove the container and send an indication back to the patient.

##Future Improvements
Enhanced Priority Management: Implement algorithms for better prioritization of patient calls.
Localization: Add support for multiple languages to accommodate diverse healthcare settings.
Performance Optimization: Fine-tune app performance for smoother user experience.

