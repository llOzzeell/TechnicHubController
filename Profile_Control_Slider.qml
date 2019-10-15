import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.12

Profile_Control_Parent{
    id:root

    width: 180
    height: width/3

    property int minControlWidth: 200
    property int maxControlWidth: 280

    scalePlusButtonOpacity: !orientation ? (root.width === maxControlWidth ? 0.3 : 1) : (root.height === maxControlWidth ? 0.3 : 1)
    scaleMinusButtonOpacity: !orientation ? (root.width === minControlWidth ? 0.3 : 1) : (root.height === minControlWidth ? 0.3 : 1)

    function send(speed){
        hubOperator.motor_RunPermanent(port1, speed)
    }

    onScaleMinus: {
        if(!orientation){
            if( width > minControlWidth) width -= 20;
        }
        else{
            if( height > minControlWidth) height -= 20;
        }
    }

    onScalePlus: {
        if(!orientation){
            if( width < maxControlWidth) width += 20;
        }
        else{
            if( height < maxControlWidth) height += 20;
        }
    }

    onOrientationChanged:{
        if(orientation){
            slider.rotation = -90;

            var t = root.height;
            root.height = root.width;
            root.width = t;
        }
        else{
            slider.rotation = 0;

            t = root.height;
            root.height = root.width;
            root.width = t;
        }
    }

    Item {
        id: slider
        width: orientation ? parent.height : parent.width
        height: orientation ? parent.width/2 : parent.height/2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        rotation: 0

        Rectangle {
            id: backgroundRectangle
            color: dark ? Style.dark_control_background : Style.light_control_background
            radius: height/2
            border.width: orientation ? root.width/14 : root.height/14
            border.color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.fill: parent
            layer.enabled: true
            layer.effect: DropShadow{
                radius:8
            }

            Behavior on color{
                ColorAnimation{
                    duration: 200
                }
            }
        }

        Rectangle {
            id: powerRectangle
            color: desaturate(Material.accent, steeringZone.currentSpeed)
            radius: height/2
            anchors.rightMargin: slider.width - steeringZone.shift - steeringPoint.width
            anchors.fill: parent
            border.color: dark ? Style.dark_control_border : Style.light_control_border
            border.width: orientation ? root.width/14 : root.height/14
        }

        Item {
            id: steeringItem
            height: backgroundRectangle.height * 1.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Rectangle {
                id: steeringPoint
                x: steeringZone.shift
                width: steeringItem.height
                height: width
                color: dark ? Style.dark_control_primary : Style.light_control_primary
                radius: height/2
                border.width: backgroundRectangle.border.width
                border.color: dark ? Style.dark_control_border : Style.light_control_border
                anchors.verticalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
                layer.enabled: false
                layer.effect: DropShadow{
                    radius:8
                }
            }

            MultiPointTouchArea{
                id: steeringZone
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                minimumTouchPoints: 1
                enabled: !editorMode
                touchPoints: [ TouchPoint { id: point1 } ]

                property int currentSpeed:0
                property int shift:0

                onTouchUpdated: {
                    var mouseXNormalized = point1.x - steeringPoint.width/2;

                    if(mouseXNormalized < 0) mouseXNormalized = 0;
                    else if(mouseXNormalized > (steeringItem.width - steeringPoint.width)) mouseXNormalized = steeringItem.width - steeringPoint.width;

                    steeringZone.shift = mouseXNormalized;

                    var speed = parseInt((100/(steeringItem.width - steeringPoint.width))*Math.abs(shift));
                    if(speed % 10 == 0 || speed % 10 == 5)currentSpeed = inverted? -speed : speed;
                }
                onPressed: {
                    if(tap && !editorMode)androidFunc.vibrate(50);
                }
                onCurrentSpeedChanged: {
                    if(tap && !editorMode){
                        root.send(currentSpeed);
                        androidFunc.vibrate(20);
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:4;anchors_height:0;anchors_width:0;anchors_x:0;anchors_y:0}
}
##^##*/
