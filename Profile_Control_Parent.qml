import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root

    implicitWidth: 120
    implicitHeight: 120
    width: implicitWidth
    height: implicitheight
    rotation: 90

    property int minControlWidth:120
    property int maxControlWidth:220

    property int createIndex: -1
    property alias editorMode: editorItem.visible

    property int type
    property int port1
    property int port2
    property bool inverted
    property int maxspeed
    property int servoangle

    function setScalePlus(){
        if( width < maxControlWidth) width += 20;
    }

    function setScaleMinus(){
        if( width > minControlWidth) width -= 20;
    }

    function highlight(trigger){
        if(trigger){
            frame.visible = true;
        }
        else{
            frame.visible = false;
        }
    }

    Item {
        id: editorItem
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        visible: true
        z: 2
        anchors.fill: parent

        Row {
            id: circlebuttonPanel
            height: 38
            enabled: true
            anchors.bottom: parent.top
            anchors.bottomMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Gui_Profile_CircleButton {
                id: deleteButton
                width: 36
                height: width
                backgroundColor: Style.remove_Red
                iconSource: "icons/remove.svg"
                visible: editorMode
                onClicked: root.parent.deleteControl(createIndex)
            }

            Gui_Profile_CircleButton {
                id: scaleMinus
                width: 36
                backgroundColor: Material.primary
                iconSource: "icons/minus.svg"
                visible: editorMode
                onClicked: setScaleMinus();
                opacity: root.width === minControlWidth ? 0.3 : 1
            }

            Gui_Profile_CircleButton {
                id: scalePlus
                width: 36
                height: width
                backgroundColor: Material.primary
                iconSource: "icons/plus.svg"
                visible: editorMode
                onClicked: setScalePlus();
                opacity: root.width === maxControlWidth ? 0.3 : 1
            }

            Gui_Profile_CircleButton {
                id: propButton
                width: 36
                height: width
                visible: editorMode
                backgroundColor: Material.primary
                iconSource: "icons/profileEdit.svg"
                onClicked:{

                    root.highlight(true);
                    root.parent.openControlParam(root);
                }
            }
        }

        Rectangle {
            id: frame
            color: "#99f48fb1"
            radius: height/2
            border.color: Material.accent
            rotation: 0
            anchors.rightMargin: -border.width/2
            anchors.leftMargin: -border.width/2
            anchors.bottomMargin: -border.width/2
            anchors.topMargin: -border.width/2
            visible: false
            opacity: visible ? 1 : 0
            border.width: 4
            anchors.fill: parent

            Behavior on opacity {
                NumberAnimation{
                    duration:150
                }
            }
        }
    }

    Drag.active:  movingMouseArea.drag.active

    MouseArea {
        id: movingMouseArea
        z: 1
        anchors.fill: parent
        visible: editorMode
        drag.target: parent
    }

}

