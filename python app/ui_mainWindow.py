from PyQt5.QtCore import QCoreApplication, QMetaObject, Qt, QTimer
from PyQt5.QtGui import QFont, QCursor
from PyQt5.QtWidgets import QMainWindow, QWidget, QPushButton, QTextEdit, QGridLayout, QLabel

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 600)
        font = QFont()
        font.setFamily("Segoe UI")
        font.setPointSize(10)
        MainWindow.setFont(font)
        MainWindow.setStyleSheet("""
        QMainWindow {background-color: #F9F9F9;}
        QTextEdit, QLabel {
            border: 1px solid #CCCCCC;
            border-radius: 5px;
            font-size: 12px;
            padding: 10px;
            color: #333333;
            background-color: #FFFFFF;
        }
        QPushButton {
            border: 2px solid #CCCCCC;
            border-radius: 10px;
            color: #FFFFFF;
            font-size: 18px;
            padding: 20px;
            background-color: #5A5A5A;
            min-width: 200px;
            min-height: 100px;
        }
        QPushButton:hover {background-color: #787878;}
        QPushButton:pressed {background-color: #505050;}
        """)

        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        
        self.gridLayout = QGridLayout(self.centralwidget)
        self.gridLayout.setSpacing(20)
        self.gridLayout.setContentsMargins(10, 10, 10, 10)

        # Add text and buttons for Room 1
        self.room1Label = QLabel("Room 1 Status: None", self.centralwidget)
        self.gridLayout.addWidget(self.room1Label, 0, 0, 1, 2)

        # TextEdit for visual indication (Room 1)
        self.textEdit = QTextEdit(self.centralwidget)
        self.textEdit.setObjectName("textEdit")
        self.textEdit.setHtml(QCoreApplication.translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:16pt;\">Room 1</span></p></body></html>", None))
        self.gridLayout.addWidget(self.textEdit, 1, 0, 1, 1)

        # Buttons for Room 1
        self.pushButton_2 = QPushButton("Bed 1", self.centralwidget)
        self.pushButton_2.setObjectName("pushButton_2")
        self.pushButton_2.setCursor(QCursor(Qt.PointingHandCursor))
        self.gridLayout.addWidget(self.pushButton_2, 2, 0, 1, 1)
        self.pushButton_3 = QPushButton("Bed 2", self.centralwidget)
        self.pushButton_3.setObjectName("pushButton_3")
        self.pushButton_3.setCursor(QCursor(Qt.PointingHandCursor))
        self.gridLayout.addWidget(self.pushButton_3, 3, 0, 1, 1)

        # Add text and buttons for Room 2
        self.room2Label = QLabel("Room 2 Status: None", self.centralwidget)
        self.gridLayout.addWidget(self.room2Label, 0, 1, 1, 2)

        # TextEdit for visual indication (Room 2)
        self.textEdit_2 = QTextEdit(self.centralwidget)
        self.textEdit_2.setObjectName("textEdit_2")
        self.textEdit_2.setHtml(QCoreApplication.translate("MainWindow", "<html><head/><body><p align=\"center\"><span style=\" font-size:16pt;\">Room 2</span></p></body></html>", None))
        self.gridLayout.addWidget(self.textEdit_2, 1, 1, 1, 1)

        # Buttons for Room 2
        self.pushButton_4 = QPushButton("Bed 1", self.centralwidget)
        self.pushButton_4.setObjectName("pushButton_4")
        self.pushButton_4.setCursor(QCursor(Qt.PointingHandCursor))
        self.gridLayout.addWidget(self.pushButton_4, 2, 1, 1, 1)
        self.pushButton_5 = QPushButton("Bed 2", self.centralwidget)
        self.pushButton_5.setObjectName("pushButton_5")
        self.pushButton_5.setCursor(QCursor(Qt.PointingHandCursor))
        self.gridLayout.addWidget(self.pushButton_5, 3, 1, 1, 1)

        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QMainWindow.menuBar(MainWindow)
        self.menubar.setGeometry(QRect(0, 0, 800, 26))
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QMainWindow.statusBar(MainWindow)

        self.retranslateUi(MainWindow)
        QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", "Patient Room Control", None))
