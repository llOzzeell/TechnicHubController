import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import ".."
import "qrc:/Controls"
import Qt.labs.calendar 1.0

Parent{
    id:root
    implicitWidth:Units.dp(140)
    implicitHeight:Units.dp(50)

    name: ConstList_Text.control_name_hslider

    onEditorModeChanged: {
        if(editorMode && root.speedValue > 0) stop();
    }

    property int speedValue: 0

    Component.onCompleted:{
        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.multichoose = true;
    }
    Component.onDestruction: {
        stop();
    }

    onSizeMinusClicked: {
        if(scaleStep > 0) {

            height -= Units.dp(20);
            width = height*4;
            scaleStep--;
        }
    }

    onSizePlusClicked: {
        if(scaleStep < 1) {

            height += Units.dp(20);
            width = height*4;
            scaleStep++;
        }
    }

    function calcSpeed(x){
        if(x < touchPoint.startPoint) x = touchPoint.startPoint;
        if(x > touchPoint.endPoint) x = touchPoint.endPoint;
        touchPoint.x = x-touchPoint.startPoint;

        var sp = 100 / ((touchPoint.endPoint - touchPoint.startPoint) / (x - touchPoint.startPoint) )
        speedValue = sp;
        return parseInt(sp);
    }

    function speedReady(speed){   
        cpp_Controller.runMotor(inverted? -speed: speed, chAddress, ports[0], ports[1], ports[2], ports[3])
    }

    function stop(){
        touchPoint.x = 0;
        speedValue = 0;
        speedReady(0);
    }

    function vibrate(force){
        if(root.parent.taptic){

            if(force === "middle"){
                cpp_Android.vibrateMiddle();
            }
            else cpp_Android.vibrateWeak();

        }
    }

    onTouchPressed: {
        vibrate("middle");
        speedReady(calcSpeed(x));
    }

    onTouchUpdated: {
        var sp = calcSpeed(x);
        if(sp % 2 == 0){
            speedReady(sp);
        }
        if(sp % 10 == 0 && sp > 0 && sp < 100){
            vibrate("weak");
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
        anchors.right: touchPoint.right
        anchors.rightMargin: 0
        anchors.leftMargin: touchPoint.borderWidth
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: touchPoint.borderWidth
        anchors.top: parent.top
        anchors.topMargin: touchPoint.borderWidth
        opacity: root.speedValue/100
    }

    CustomCircle{
        id:touchPoint
        x:0
        width:height
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color
        color: Qt.darker(Material.primary, 1.05)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        property int startPoint: touchPoint.width/2
        property int endPoint: root.width - startPoint;

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
