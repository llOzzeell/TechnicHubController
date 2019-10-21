import QtQuick 2.0

Item{
    id:root
    height: width

        Item {

            implicitWidth: 64
            implicitHeight: (width/3)*3.4
            height:implicitHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            clip: true

            property alias ledColor: hubLed.color
            width: root.width/1.4

            Rectangle {
                id: hub
                color: "#b4b4b4"
                radius: 0
                border.color: "#2d2d2d"
                border.width: 1
                anchors.fill: parent
            }

            Rectangle {
                id: hubPortZoneLeft
                width: root.width/8
                height: root.height/1.9
                color: "#b4b4b4"
                radius: 0
                border.color: "#2d2d2d"
                border.width: 1
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

            Rectangle {
                id: hubPortZoneRight
                width: root.width/8
                height: root.height/1.9
                color: "#b4b4b4"
                radius: 0
                border.color: "#2d2d2d"
                border.width: 1
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
            }

            Rectangle {
                id: hubButton
                width: root.width/8
                height: width
                color: "#22b442"
                radius: 2
                border.color: "#2d2d2d"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: hubPortZoneLeft.verticalCenter
            }

            Rectangle {
                id: hubLed
                x: 67
                width: root.width/20
                height: root.height/8
                color: "#0b76f9"
                border.color: "#2d2d2d"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
            }

        }
}
