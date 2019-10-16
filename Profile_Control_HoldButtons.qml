import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Profile_Control_Parent {
    id:root
    width:140
    height: width/2

    scalePlusButtonOpacity: root.width === maxControlWidth ? 0.3 : 1
    scaleMinusButtonOpacity: root.width === minControlWidth ? 0.3 : 1

    property int minControlWidth: 140
    property int maxControlWidth: 200

    onScaleMinus: {
        if( width > minControlWidth) width -= 20;
    }

    onScalePlus: {
        if( width < maxControlWidth) width += 20;
    }

    function save(){
        profilesController.addProfileControls(profileIndex,
                                              type,
                                              width,
                                              0,
                                              x,
                                              y,
                                              (inverted > 0),
                                              port1,
                                              port2,
                                              0,
                                              maxspeed,
                                              false);
    }

    Rectangle {
        id: rectangle
        color: dark ? Style.dark_control_border : Style.light_control_border
        radius: height/2
        anchors.fill: parent
        layer.enabled: true
        layer.effect: DropShadow{
            radius:8
        }
    }

    Rectangle {
        id: reverseButton
        width: root.height
        height: width
        color: dark ? Style.dark_control_primary : Style.light_control_primary
        radius: height/2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        border.width: root.height/20
        border.color: dark ? Style.dark_control_border : Style.light_control_border

        Behavior on border.width{
            NumberAnimation{
                duration: 200
            }
        }

        Behavior on color{
            ColorAnimation{
                duration: 200
            }
        }

        property bool isPressed: false

        MultiPointTouchArea{
            id: mouseArea
            anchors.fill: parent
            enabled: !editorMode && !forwardButton.isPressed

            onPressed: {
                if(tap && !editorMode)androidFunc.vibrate(50);
                reverseButton.isPressed = true;
                reverseButton.border.width = root.height/8
                reverseButton.color = desaturate(Material.accent, 90)
                var spd = inverted ? maxspeed : - maxspeed;
                if(!editorMode)hubOperator.motor_RunPermanent(port1, spd)
            }
            onReleased: {
                reverseButton.isPressed = false;
                reverseButton.border.width = root.height/20
                reverseButton.color = dark ? Style.dark_control_primary : Style.light_control_primary
                if(!editorMode)hubOperator.motor_RunPermanent(port1, 0)
            }
        }

        Image {
            id: image1
            width: 26
            height: width
            visible:false
            fillMode: Image.PreserveAspectFit
            source: "icons/anticlockwise.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        ColorOverlay{
            source: image1
            color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.fill: image1
        }
    }

    Rectangle {
        id: forwardButton
        width: root.height
        height: width
        color: dark ? Style.dark_control_primary : Style.light_control_primary
        radius: height/2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        border.color: dark ? Style.dark_control_border : Style.light_control_border
        border.width: root.height/20

        Behavior on border.width{
            NumberAnimation{
                duration: 200
            }
        }

        Behavior on color{
            ColorAnimation{
                duration: 200
            }
        }

        property bool isPressed: false

        MultiPointTouchArea{
            id: mouseArea1
            anchors.fill: parent
            enabled: !editorMode && !reverseButton.isPressed

            onPressed: {
                if(tap && !editorMode)androidFunc.vibrate(50);
                forwardButton.isPressed = true;
                forwardButton.border.width = root.height/8
                forwardButton.color = desaturate(Material.accent, 90)
                var spd = inverted ? -maxspeed : maxspeed;
                if(!editorMode)hubOperator.motor_RunPermanent(port1, spd)
            }
            onReleased: {
                forwardButton.isPressed = false;
                forwardButton.border.width = root.height/20
                forwardButton.color = dark ? Style.dark_control_primary : Style.light_control_primary
                if(!editorMode)hubOperator.motor_RunPermanent(port1, 0)
            }
        }

        Image {
            id: image
            width: 26
            height: width
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "icons/clockwise.svg"
        }

        ColorOverlay{
            source: image
            color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.fill: image
        }
    }

}
