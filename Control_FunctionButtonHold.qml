import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id: root
    width: 160
    height: width/2
    rotation: 0

    property string port: ""
    property int speed: 100

    Rectangle {
        id: rectangle
        color: "#302f2f"
        radius: height/2
        anchors.fill: parent
        layer.enabled: false
        layer.effect: DropShadow{
            radius:8
        }
    }

    Rectangle {
        id: reverseButton
        width: root.height
        height: width
        color: "#474646"
        radius: height/2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        border.width: root.height/20
        border.color: "#302f2f"

        Behavior on border.width{
            NumberAnimation{
                duration: 200
            }
        }

        Behavior on color{
            ColorAnimation{
                duration: 500
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            onPressed: {
                reverseButton.border.width = root.height/8
                reverseButton.color = Qt.lighter("#474646", 1.2)
                smartHubOperator.motor_RunPermanent(port, -speed)
            }
            onReleased: {
                reverseButton.border.width = root.height/20
                reverseButton.color = "#474646"
                smartHubOperator.motor_RunPermanent(port, 0)
            }
        }

        Label {
            id: label
            height: root.height/2
            text: qsTr("↶")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.left: parent.left
            font.pointSize: 100
            fontSizeMode: Text.Fit
            opacity: 0.5
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Rectangle {
        id: forwardButton
        x: -6
        width: root.height
        height: width
        color: "#474646"
        radius: height/2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        border.color: "#302f2f"
        border.width: root.height/20

        Behavior on border.width{
            NumberAnimation{
                duration: 200
            }
        }

        Behavior on color{
            ColorAnimation{
                duration: 500
            }
        }

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            onPressed: {
                forwardButton.border.width = root.height/8
                forwardButton.color = Qt.lighter("#474646", 1.4)
                smartHubOperator.motor_RunPermanent(port, speed)
            }
            onReleased: {
                forwardButton.border.width = root.height/20
                forwardButton.color = "#474646";
                smartHubOperator.motor_RunPermanent(port, 0)
            }
        }

        Label {
            id: label1
            y: -2
            height: root.height/2
            text: qsTr("↷")
            font.pointSize: 100
            fontSizeMode: Text.Fit
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.left: parent.left
            opacity: 0.5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }


}
