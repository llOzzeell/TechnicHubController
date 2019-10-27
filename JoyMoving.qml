import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import ".."
import "qrc:/Controls"

Parent{
    id:root

    height:width

    Component.onCompleted:{
        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.multichoose = true;
    }

    property int minWidth: Units.dp(160)
    property int maxWidth: Units.dp(200)

    onSizeMinusClicked: {
        if(width > minWidth) {

            width -= Units.dp(10);
            height = width;
        }
        touchPoint.y = root.height/2 - touchPoint.height/2
    }

    onSizePlusClicked: {
        if(width < maxWidth) {

            width += Units.dp(10);
            height = width;
        }
        touchPoint.y = root.height/2 - touchPoint.height/2
    }

    property int speed:0

    onTouchPressed: {
        vibrate("middle");
        speedReady(calcSpeed(y));
    }

    onTouchReleased: {
        touchPointToCenter.start();
    }

    onTouchUpdated: {
        var sp = calcSpeed(y);
        if(sp % 10 == 0 || sp % 5 == 0){
            speedReady(sp);
        }
        if(sp % 10 == 0 && sp > -100 && sp < 100){
            vibrate("weak");
        }
    }

    function calcSpeed(y){
        if(y < touchPoint.width/2) y = (touchPoint.width/2);
        if(y > root.width - touchPoint.width/2) y = (root.width - touchPoint.width/2);
        touchPoint.y = y-touchPoint.width/2;
        var sp = Math.round(100 * 2/(root.width-touchPoint.width)*(y - root.width/2));
        speed = -sp;
        return -sp;
    }

    function speedReady(speed){
        cpp_Controller.runMotor(inverted? -speed: speed, chAddress, ports[0], ports[1], ports[2], ports[3])
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
    }


    Rectangle {
        id: rectangle
        color: Material.accent
        radius: height/2
        anchors.fill: parent
        anchors.margins: background.borderWidth
        opacity: Math.abs(root.speed)/100

        Behavior on color{
            ColorAnimation {
                duration: 200
            }
        }
    }

    Rectangle {
        id: directionLine
        width: root.width/14
        color: ConstList_Color.controls_border_color
        radius: height/2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Units.dp(18)
        anchors.top: parent.top
        anchors.topMargin: Units.dp(18)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    CustomCircle{
        id:touchPoint
        y: root.width/2 - width/2
        width: root.height/2.5
        height: width
        borderWidth: Units.dp(8)
        borderColor: ConstList_Color.controls_border_color
        elevationValue: 8
        color: Qt.darker(Material.primary, 1.05)
        anchors.horizontalCenter: parent.horizontalCenter
        z: 0

        PropertyAnimation{
            id:touchPointToCenter
            target:touchPoint
            property:"y"
            to: root.width/2 - touchPoint.width/2
            duration: 100

            onStopped: {
                root.speedReady(0);
                root.speed = 0;
            }
        }

        Item {
            id: gripItem
            width: parent.height/3
            height: width
            rotation: 90
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
