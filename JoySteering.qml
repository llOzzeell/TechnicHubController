import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import ".."
import "qrc:/Controls"
import "qrc:/assets"

Parent{
    id:root

    height:width

    name: ConstList_Text.control_name_steering

    Component.onCompleted:{
        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.servoangle = true;
    }

    property int minWidth: Units.dp(150)
    property int maxWidth: Units.dp(190)

    onSizeMinusClicked: {
        if(width > minWidth) {

            width -= Units.dp(10);
            height = width;
        }
        touchPoint.x = root.width/2 - touchPoint.width/2
    }

    onSizePlusClicked: {
        if(width < maxWidth) {

            width += Units.dp(10);
            height = width;
        }
        touchPoint.x = root.width/2 - touchPoint.width/2
    }

    property int angle:0
    width: 180

    onTouchPressed: {
        vibrate("middle");
        angleReady(calcAngle(x));
    }

    onTouchReleased: {
        touchPointToCenter.start();
    }

    onTouchUpdated: {
        var an = calcAngle(x);
        if(an % 10 == 0){
            angleReady(an);
        }
        if(an % 10 == 0 && an > -servoangle && an < servoangle){
            vibrate("weak");
        }
    }

    function calcAngle(x){
        if(x < touchPoint.width/2) x = (touchPoint.width/2);
        if(x > root.width - touchPoint.width/2) x = (root.width - touchPoint.width/2);
        touchPoint.x = x-touchPoint.width/2;
        var an = Math.round(servoangle * 2/(root.width-touchPoint.width)*(x - root.width/2));
        root.angle = an;
        return an;
    }

    function angleReady(angle){
        cpp_Controller.rotateMotor(inverted? -angle: angle, chAddress, ports[0], ports[1], ports[2], ports[3]);
    }

    function vibrate(force){
        if(root.parent.taptic){

            if(force === "middle"){
                cpp_Android.vibrateMiddle();
            }
            else cpp_Android.vibrateWeak();
        }
    }

    CustomCircle{
        id:background
        anchors.fill: parent
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color

//        Item {
//            id: angleArrowItem
//            width: root.width
//            height: width
//            rotation: root.angle

//            Behavior on rotation {
//                NumberAnimation{
//                    duration: 100
//                }
//            }

//            Image {
//                id: image
//                width: Units.dp(32)
//                height: Units.dp(32)
//                anchors.horizontalCenterOffset: 0
//                anchors.topMargin: background.borderWidth * 1.2
//                anchors.top: parent.top
//                anchors.horizontalCenter: parent.horizontalCenter
//                source: "qrc:/assets/icons/angleArrow.svg"
//                visible: false
//            }

//            ColorOverlay{
//                source:image
//                anchors.fill: image
//                color:Material.accent
//                rotation:-90
//            }
//        }
    }

    Rectangle {
        id: rectangle
        color: Material.accent
        radius: height/2
        anchors.fill: parent
        anchors.margins: background.borderWidth
        opacity: Math.abs(root.angle * 1.1)/100

        Behavior on color{
            ColorAnimation {
                duration: 200
            }
        }
    }

    Rectangle {
        id: directionLine
        height: root.height/14
        color: ConstList_Color.controls_border_color
        radius: height/2
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(18)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(18)
        anchors.verticalCenter: parent.verticalCenter
    }


    CustomCircle{
        id:touchPoint
        x: root.width/2 - width/2
        width: root.height/2.5
        height: width
        anchors.verticalCenter: parent.verticalCenter
        borderWidth: Units.dp(8)
        borderColor: ConstList_Color.controls_border_color
        elevationValue: 8
        color: Qt.darker(Material.primary, 1.05)
        z: 0

        ParallelAnimation{
            id:touchPointToCenter
            PropertyAnimation{
                target:touchPoint
                property:"x"
                to: root.width/2 - touchPoint.width/2
                duration: 100
            }
            PropertyAnimation{
                target:angleArrowItem
                property:"rotation"
                to: 0
                duration: 100
            }
            onStopped: {
                root.angleReady(0);
                root.angle = 0;
            }
        }

        Item {
            id: gripItem
            width: parent.height/3
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: grip1
                width: touchPoint.borderWidth/2
                color: touchPoint.borderColor
                radius: width/2
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                layer.enabled: true
                layer.effect: DropShadow{
                    radius: Units.dp(3)
                    samples: Units.dp(6)
                    color: "#7F000000"
                }
            }

            Rectangle {
                id: grip2
                width: touchPoint.borderWidth/2
                color: touchPoint.borderColor
                radius: width/2
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                layer.enabled: true
                layer.effect: DropShadow{
                    radius: Units.dp(3)
                    samples: Units.dp(6)
                    color: "#7F000000"
                }
            }

            Rectangle {
                id: grip3
                width: touchPoint.borderWidth/2
                color: touchPoint.borderColor
                radius: width/2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                layer.enabled: true
                layer.effect: DropShadow{
                    radius: Units.dp(3)
                    samples: Units.dp(6)
                    color: "#7F000000"
                }
            }
        }

    }


}

/*##^##
Designer {
    D{i:4;anchors_height:96;anchors_width:96;anchors_x:-59;anchors_y:-57}D{i:3;anchors_y:46}
D{i:5;anchors_y:46}
}
##^##*/
