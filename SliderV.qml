import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import ".."
import "qrc:/Controls"

Parent{
    id:root
    implicitWidth:Units.dp(50)
    implicitHeight:Units.dp(140)

    name: ConstList_Text.control_name_vslider

    onEditorModeChanged: {
        if(editorMode && root.speedValue > 0) stop();
    }

    property int speedValue: 0

    Component.onCompleted:{

        root.rotatePropItem = 90;

        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.multichoose = true;
    }

    Component.onDestruction: {
        stop();
    }

    onSizeMinusClicked: {
        if(scaleStep > 0) {

            width -= Units.dp(20);
            height = width*4;
            scaleStep--;
        }
        touchPoint.y = root.height - touchPoint.height
    }

    onSizePlusClicked: {
        if(scaleStep < 1) {

            width += Units.dp(20);
            height = width*4;
            scaleStep++;
        }
        touchPoint.y = root.height - touchPoint.height
    }

    function calcSpeed(y){

        if(y > touchPoint.startPoint) y = touchPoint.startPoint;
        if(y < touchPoint.endPoint) y = touchPoint.endPoint;
        touchPoint.y = y - touchPoint.height/2;

        var sp = 100 / ((touchPoint.endPoint - touchPoint.startPoint) / (y - touchPoint.startPoint) )
        speedValue = sp;
        return parseInt(sp);
    }

    function speedReady(speed){
        cpp_Controller.runMotor(inverted? -speed: speed, chAddress, ports[0], ports[1], ports[2], ports[3])
    }

    function stop(){
        touchPoint.y = root.height-touchPoint.height;
        speedValue = 0;
        speedReady(0);
    }

    onTouchPressed: {
        vibrate("middle");
        speedReady(calcSpeed(y));
    }

    onTouchUpdated: {
        var sp = calcSpeed(y);
        if(sp % 2 == 0){
            speedReady(sp);
        }
        if(sp % 10 == 0 && sp > 0 && sp < 100){
            vibrate("weak");
        }
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
        anchors.rightMargin: touchPoint.borderWidth
        anchors.top: touchPoint.top
        anchors.topMargin: 0
        anchors.right: touchPoint.right
        anchors.leftMargin: touchPoint.borderWidth
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: touchPoint.borderWidth
        opacity: root.speedValue/100
    }

    CustomCircle{
        id:touchPoint
        y:root.height - width
        height:width
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color
        color: Qt.darker(Material.primary, 1.05)
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        property int startPoint: root.height - touchPoint.height/2
        property int endPoint: touchPoint.height/2;

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
