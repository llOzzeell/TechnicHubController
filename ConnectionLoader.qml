import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    id: root

    property int timeOutConnection: 10000

    BusyIndicator {
        id: busyIndicator
        width: 70
        height: 70
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: label1
            text: counter
            font.family: robotoCondensed
            font.pointSize: 22
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent

            property int counter: root.timeOutConnection/1000
            width: 70
        }
    }

    PropertyAnimation {
        id:countdownAnimation
        target: label1
        property:"counter"
        from: root.timeOutConnection/1000
        to:0
        duration: root.timeOutConnection
    }

    Label {
        id: label
        text: "Подключение к " + deviceNameString
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 16
        font.bold: true
        anchors.top: busyIndicator.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: robotoCondensed

        property string deviceNameString:""

        Connections{
            target:smartHubConnector

            onDeviceNameNotify:{
                label1.counter = root.timeOutConnection/1000;
                timerTimeOutConnection.running = true;
                countdownAnimation.running = true;
                label.deviceNameString = name;
                layout.setLoaderPage();
            }

            onDeviceConnectedQML:{
                timerTimeOutConnection.running = false;
                countdownAnimation.running = false;
                layout.setHubPage();
            }
        }
    }

    Timer{
     id:timerTimeOutConnection
     interval: root.timeOutConnection
     repeat: false
     onTriggered: layout.setFinderPage();
    }

}
