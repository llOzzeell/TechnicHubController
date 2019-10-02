import QtQuick 2.0

Item {
    id:root
    width: 140
    height: (width/3)*3.5
    clip: true

    property alias ledColor: hubLed.color

    Rectangle {
        id: hub
        color: "#b4b4b4"
        radius: 0
        border.color: "#2d2d2d"
        border.width: 2
        anchors.fill: parent
    }

    Rectangle {
        id: hubPortZoneLeft
        width: root.width/7
        height: root.height/1.7
        color: "#b4b4b4"
        radius: 0
        border.color: "#2d2d2d"
        border.width: 2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Rectangle {
        id: hubPortZoneRight
        x: -2
        y: 6
        width: root.width/7
        height: root.height/1.7
        color: "#b4b4b4"
        radius: 0
        border.color: "#2d2d2d"
        border.width: 2
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Rectangle {
        id: hubButton
        x: 261
        y: 33
        width: root.width/6
        height: width
        color: "#22b442"
        radius: 4
        border.color: "#2d2d2d"
        border.width: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: hubPortZoneLeft.verticalCenter
    }

    Rectangle {
        id: hubLed
        x: 67
        width: root.width/14
        height: root.height/8
        color: "#0b76f9"
        border.color: "#2d2d2d"
        border.width: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
    }

}
