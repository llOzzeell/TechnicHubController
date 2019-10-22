import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/ModelsControls"

Item {
    id:root
    opacity: 0

    Behavior on opacity{
        NumberAnimation{
            duration: 200
        }
    }

    signal componentChoosed(int type, string path, int width, int height)
    onComponentChoosed: hide()

    readonly property bool isVisible: root.opacity == 1 ? true : false

    function show(){
        opacity = 1;
    }

    function hide(){
        opacity = 0;
    }

    Rectangle {
        id: background
        color: ConstList_Color.darkBackground
        anchors.fill: parent
        opacity: 0.8
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            hide();
        }
    }

    Flickable {
        id: flickable
        height: column.height
        flickableDirection: Flickable.HorizontalFlick
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        Row {
            id: column
            width: Units.dp(1740)
            height: Units.dp(240)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: Units.dp(60)

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: joySteering
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: joyMoving
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: buttons
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: hslider
            }
        }

    }

    Component{
        id: joySteering
        JoySteering {
            width: Units.dp(240)
            height: Units.dp(240)
            editorMode: false
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(0,"qrc:/ModelsControls/JoySteering.qml", Units.dp(140),Units.dp(140))
            }
        }
    }

    Component{
        id: joyMoving
        JoySteering {
            width: Units.dp(240)
            height: Units.dp(240)
            editorMode: false
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(1,"qrc:/ModelsControls/JoyMoving.qml", Units.dp(140),Units.dp(140))
            }
        }
    }

    Component{
        id: buttons
        Buttons {
            width: Units.dp(480)
            height: Units.dp(240)
            editorMode: false
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(2,"qrc:/ModelsControls/Buttons.qml", Units.dp(200),Units.dp(100))
            }
        }
    }

    Component{
        id:hslider
        SliderH{
            width: Units.dp(600)
            height: Units.dp(120)
            editorMode: false
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(3,"qrc:/ModelsControls/SliderH.qml", Units.dp(300),Units.dp(60))
            }
        }
    }

}


