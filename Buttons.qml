import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import ".."
import "qrc:/assets"
import "qrc:/Controls"


Parent{
    id:root
    height: width/2

    property int minWidth: Units.dp(100)
    property int maxWidth: Units.dp(140)

    name: ConstList_Text.control_name_buttons

    Component.onCompleted:{
        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.speedlimit = true;
        requiredParameters.multichoose = true;
        requiredParameters.workAsServo = true;
    }

    onSizeMinusClicked: {
        if(height > minWidth) {

            height -= Units.dp(20);
            width = height*2;
        }
    }

    onSizePlusClicked: {
        if(height < maxWidth) {

            height += Units.dp(20);
            width = height*2;
        }
    }

    onTouchPressed:{
        if(root.parent.taptic)cpp_Android.vibrateMiddle();
        if(x > root.width/2){
            forward.press();
        }
        else{
            reverse.press();
        }
    }

    onTouchReleased:{
        if(forward.isPressed)forward.release();
        if(reverse.isPressed)reverse.release();
    }

    CustomCircle{
        id:background
        anchors.fill: parent
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color
        color: borderColor
    }

    Item {
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        CustomCircle{
            id:reverse
            anchors.fill: parent
            anchors.margins: Units.dp(6)
            elevationEnabled: false
            color: Material.primary

            property bool isPressed:false

            Behavior on anchors.margins{
                NumberAnimation{duration:200}
            }

            Behavior on color{
                ColorAnimation { duration: 400 }
            }

            function press(){
                reverse.anchors.margins = Units.dp(8);
                reverse.color = Qt.lighter(Material.accent, 1.2);
                reverse.isPressed = true;

                if(!workAsServo)cpp_Controller.runMotor(inverted? speedlimit: -speedlimit, chAddress, ports[0], ports[1], ports[2], ports[3])
                else cpp_Controller.rotateMotor(inverted? servoangle: -servoangle, chAddress, ports[0], ports[1], ports[2], ports[3]);
            }

            function release(){
                reverse.anchors.margins = Units.dp(6);
                reverse.color = Material.primary;
                reverse.isPressed = false;

                if(!workAsServo)cpp_Controller.runMotor(0, chAddress, ports[0], ports[1], ports[2], ports[3])
                else cpp_Controller.rotateMotor(0, chAddress, ports[0], ports[1], ports[2], ports[3]);
            }

            ToolButton{
                width: Units.dp(44)
                height: Units.dp(44)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                icon.width: Units.dp(44)
                icon.height: Units.dp(44)
                icon.source: "qrc:/assets/icons/reverseArrow.svg"
                enabled:false
            }

            Material.onPrimaryChanged: reverse.color = Material.primary;
        }
    }

    Item {
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        CustomCircle{
            id:forward
            anchors.fill: parent
            anchors.margins: Units.dp(6)
            elevationEnabled: false
            color: Material.primary

            property bool isPressed:false

            Behavior on anchors.margins{
                NumberAnimation{duration:200}
            }

            Behavior on color{
                ColorAnimation { duration: 400 }
            }

            function press(){
                forward.anchors.margins = Units.dp(8);
                forward.color = Qt.lighter(Material.accent, 1.2);
                forward.isPressed = true;

                if(!workAsServo)cpp_Controller.runMotor(inverted? -speedlimit: speedlimit, chAddress, ports[0], ports[1], ports[2], ports[3])
                else cpp_Controller.rotateMotor(inverted? -servoangle: servoangle, chAddress, ports[0], ports[1], ports[2], ports[3]);
            }

            function release(){
                forward.anchors.margins = Units.dp(6);
                forward.color = Material.primary;
                forward.isPressed = false;

                if(!workAsServo)cpp_Controller.runMotor(0, chAddress, ports[0], ports[1], ports[2], ports[3])
                else cpp_Controller.rotateMotor(0, chAddress, ports[0], ports[1], ports[2], ports[3]);
            }

            ToolButton{
                width: Units.dp(44)
                height: Units.dp(44)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                icon.width: Units.dp(44)
                icon.height: Units.dp(44)
                icon.source: "qrc:/assets/icons/forwardArrow.svg"
                enabled:false
            }

            Material.onPrimaryChanged: forward.color = Material.primary;
        }
    }
}

