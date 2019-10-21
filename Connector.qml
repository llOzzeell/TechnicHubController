import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import ".."

Item {
    id:root
    readonly property string title:ConstList_Text.page_connector
    opacity: 0

    Behavior on opacity {
        NumberAnimation{duration:200}
    }

    Connections{
        target: cpp_Connector
        onConnected:{
            stackView.pop();
            stackView.pop();
        }
    }

    function tryConnect(index, name){
        countDownAnimation.start();
        root.opacity = 1
        label.deviceName = name.slice(0, name.indexOf("(")-1);
        cpp_Connector.connectDevice(index);
    }

    Rectangle {
        id: background
        color: Material.background
        opacity: 0.8
        anchors.fill: parent
    }

    Label {
        id: label
        text: qsTr("Connect to ") + deviceName
        font.weight: Font.Medium
        font.pixelSize: Qt.application.font.pixelSize
        anchors.bottom: countDownRectangle.top
        anchors.bottomMargin: Units.dp(10)
        anchors.horizontalCenter: parent.horizontalCenter

        property string deviceName: ""

        }

    Rectangle {
        id: countDownRectangle
        width: root.width/1.2
        height: Units.dp(4)
        color: Material.accent
        radius: Units.dp(2)
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        PropertyAnimation{
            id:countDownAnimation
            target: countDownRectangle
            property: "width"
            from:countDownRectangle.width
            to:0
            duration: 10000

            onStopped: {
                stackView.pop();
            }
        }
    }
}
