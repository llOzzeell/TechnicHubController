import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root

    property int timeout: 10000

    signal deviceConnected
    onDeviceConnected: {
        countDownAnimation.running = false;
    }

    signal noConnected

    function start(){
        countDownRectangle.width = root.width/1.2
        countDownAnimation.running = true;
    }

    Connections{
        target:hubConnector

        onDeviceNameNotify:{
            start();
            label.deviceName = name;
        }

        onDeviceConnectedQML:{
            root.deviceConnected();
        }
    }

    Rectangle {
        id: rectangle
        color: Material.background
        anchors.fill: parent
    }

    Label {
        id: label
        text: qsTr("Подключение к ") + deviceName
        font.weight: Font.Light
        font.bold: false
        font.pointSize: 18
        anchors.bottom: countDownRectangle.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        property string deviceName: ""

    }


    Rectangle {
        id: countDownRectangle
        width: root.width/1.2
        height: 4
        color: Material.accent
        radius: 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        onWidthChanged: if(width <= 0) root.noConnected();

        PropertyAnimation{
            id:countDownAnimation
            target: countDownRectangle
            property: "width"
            from:countDownRectangle.width
            to:0
            duration: timeout
        }
    }

}
