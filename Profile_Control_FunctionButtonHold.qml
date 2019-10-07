import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id: root
    width: 120
    height: width/2
    rotation: 0

    property int createIndex: -1

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
                //smartHubOperator.motor_RunPermanent(port, -speed)
            }
            onReleased: {
                reverseButton.border.width = root.height/20
                reverseButton.color = "#474646"
                //smartHubOperator.motor_RunPermanent(port, 0)
            }
        }

        Image {
            id: image1
            width: 26
            height: width
            opacity: 0.5
            fillMode: Image.PreserveAspectFit
            source: "icons/anticlockwise.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            ColorOverlay{
                source: image1
                color: Style.dark_foreground
                opacity: 1
                anchors.fill: parent
            }
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
                //smartHubOperator.motor_RunPermanent(port, speed)
            }
            onReleased: {
                forwardButton.border.width = root.height/20
                forwardButton.color = "#474646";
                //smartHubOperator.motor_RunPermanent(port, 0)
            }
        }

        Image {
            id: image
            width: 26
            height: width
            opacity: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "icons/clockwise.svg"

            ColorOverlay{
                source: image
                color: Style.dark_foreground
                anchors.fill: parent
            }
        }
    }

    property bool editorMode: false
    property string port: portModel.get(comboBox.currentIndex).name

    function setScalePlus(){
        if(width < 200) width += 20;
    }

    function setScaleMinus(){
        if(width > 100) width -= 20;
    }

    Drag.active: movingMouseArea.drag.active

    MouseArea {
        id: movingMouseArea
        anchors.fill: parent
        visible: editorMode
        drag.target: parent
    }

    Item {
        id: editorItem
        visible: editorMode
        anchors.fill: parent

        Gui_Profile_CircleButton {
            id: scalePlus
            x: 9
            y: 14
            width: 32
            height: 32
            anchors.bottom: parent.top
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            iconSource: "icons/plus.svg"
            visible: editorMode
            onClicked: setScalePlus();
        }

        Gui_Profile_CircleButton {
            id: scaleMinus
            x: -38
            y: 14
            width: 32
            anchors.right: scalePlus.left
            anchors.rightMargin: 10
            iconSource: "icons/minus.svg"
            anchors.verticalCenter: scalePlus.verticalCenter
            visible: editorMode
            onClicked: setScaleMinus();
        }

        Gui_Profile_CircleButton {
            id: deleteButton
            y: -52
            width: 32
            height: 32
            anchors.verticalCenter: scalePlus.verticalCenter
            anchors.left: scalePlus.right
            anchors.leftMargin: 10
            iconSource: "icons/delete.svg"
            visible: editorMode
        }

        Rectangle {
            id: rectangle1
            color: "#00000000"
            border.color: Material.primary
            opacity: 0.5
            border.width: 2
            anchors.fill: parent
        }

        ComboBox {
            id: comboBox
            x: 30
            y: -38
            width: root.width/2
            height: 32
            anchors.right: scaleMinus.left
            anchors.rightMargin: 10
            anchors.verticalCenter: scalePlus.verticalCenter
            font.pointSize: 12
            font.family: Style.robotoCondensed
            visible: editorMode
            model: portModel

            ListModel{
                id:portModel
                ListElement{
                    name: "A"
                }
                ListElement{
                    name: "B"
                }
                ListElement{
                    name: "C"
                }
                ListElement{
                    name: "D"
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:10;anchors_width:30}
}
##^##*/
