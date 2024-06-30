from PyQt5 import QtWidgets
from ui_mainWindow import Ui_MainWindow
import paho.mqtt.client as mqtt
from PyQt5.QtCore import QTimer
from datetime import datetime

class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

        self.mqtt_client = mqtt.Client()
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        self.mqtt_client.connect("192.168.1.110", 1883, 60)
        self.mqtt_client.loop_start()

        # Setup interactions for room 1
        self.ui.pushButton_2.clicked.connect(lambda: self.reset_bed("esp32/bed1/room1/reset", self.ui.pushButton_2))
        self.ui.pushButton_3.clicked.connect(lambda: self.reset_bed("esp32/bed2/room1/reset", self.ui.pushButton_3))
        
        # Setup interactions for room 2
        self.ui.pushButton_4.clicked.connect(lambda: self.reset_bed("esp32/bed1/room2/reset", self.ui.pushButton_4))
        self.ui.pushButton_5.clicked.connect(lambda: self.reset_bed("esp32/bed2/room2/reset", self.ui.pushButton_5))

        # Initialize lists to keep messages history
        self.room1_messages = []
        self.room2_messages = []

    def on_connect(self, client, userdata, flags, rc):
        print("Connected with result code " + str(rc))
        client.subscribe("esp32/bed1/room1")
        client.subscribe("esp32/bed2/room1")
        client.subscribe("esp32/bed1/room2")
        client.subscribe("esp32/bed2/room2")

    def on_message(self, client, userdata, msg):
        message = msg.payload.decode()
        current_time = datetime.now().strftime("%H:%M:%S")
        room = "Room 1" if "room1" in msg.topic else "Room 2"
        bed = "Bed 1" if 'bed1' in msg.topic else "Bed 2"
        
        message_text = f"{room} {bed}: {message} at {current_time}"
        if "room1" in msg.topic:
            self.room1_messages.insert(0, message_text)
            if len(self.room1_messages) > 3:
                self.room1_messages.pop()
            self.ui.pushButton_2.setStyleSheet(f"background-color: {message.lower()};") if 'bed1' in msg.topic else \
            self.ui.pushButton_3.setStyleSheet(f"background-color: {message.lower()};")
        else:
            self.room2_messages.insert(0, message_text)
            if len(self.room2_messages) > 3:
                self.room2_messages.pop()
            self.ui.pushButton_4.setStyleSheet(f"background-color: {message.lower()};") if 'bed1' in msg.topic else \
            self.ui.pushButton_5.setStyleSheet(f"background-color: {message.lower()};")

        self.update_messages()

    def update_messages(self):
        self.ui.room1Label.setText("\n".join(self.room1_messages) if self.room1_messages else "Room 1 Status: None")
        self.ui.room2Label.setText("\n".join(self.room2_messages) if self.room2_messages else "Room 2 Status: None")

    def reset_bed(self, topic, button):
        button.setStyleSheet("background-color: black;")
        if "room1" in topic:
            self.room1_messages.clear()
        else:
            self.room2_messages.clear()
        self.update_messages()
        self.mqtt_client.publish(topic, "RESET")

if __name__ == '__main__':
    app = QtWidgets.QApplication([])
    window = MainWindow()
    window.show()
    app.exec_()
