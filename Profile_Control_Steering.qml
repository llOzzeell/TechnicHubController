import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.12

Profile_Control_Parent{
    id:root

    width:140
    height: width

    onHeightChanged: {
        allMovingToCenter.start();
    }

    property int minControlWidth: 140
    property int maxControlWidth: 200

    onScaleMinus: {
        if( width > minControlWidth)width -= 20;
        else scaleMinusButtonOpacity = 0.2
    }

    onScalePlus: {
        if( width < maxControlWidth)width += 20;
    }

    scalePlusButtonOpacity: root.width === maxControlWidth ? 0.3 : 1
    scaleMinusButtonOpacity: root.width === minControlWidth ? 0.3 : 1

    function send(angle){
        hubOperator.motor_SendServoAngle(port1, angle, servoangle)
        if(tap && !editorMode)androidFunc.vibrate(20);
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
                                              servoangle,
                                              0,
                                              false);
    }

    //    function stopAll(){
    //        steeringZone.shift = 0;
    //        steeringZone.last = -1;
    //        allMovingToCenter.start();
    //        hubOperator.motor_SendServoAngle(port1, 0, servoangle)
    //    }

    Item {
        id: angleIndicator
        enabled: false
        rotation: 0
        anchors.fill: parent

        Behavior on rotation{
            NumberAnimation{
                duration: 200
            }
        }

        Rectangle {
            id: arrowRectangle
            width: root.height/6
            height: width
            color: backgroundRectangle.color
            rotation: 45
            anchors.topMargin: -height/2.5
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            layer.enabled: true
            layer.effect: DropShadow{
                radius:Style.controlDropShadowValue
                color: Style.controlDropShadowColor
            }
        }
    }

    Rectangle {
        id: backgroundRectangle
        color: desaturate(Material.accent, Math.abs(0));
        radius: height/2
        enabled: false
        border.width: root.height/30
        border.color: dark ? Style.dark_control_border : Style.light_control_border
        anchors.fill: parent
        layer.enabled: true
        layer.effect: DropShadow{
            radius:Style.controlDropShadowValue
            color: Style.controlDropShadowColor
        }

        property color startColor: desaturate(Material.accent, 0);

        function clearColor(){
            color = startColor;
        }

        Behavior on color{
            ColorAnimation{
                duration: 200
            }
        }
    }

    Item {
        id: steeringItem
        height: root.height/2
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        property int center: steeringItem.width/2 - steeringPoint.width/2
        property int steeringLenght: steeringPoint.width/1.8
        property int currentSteeringShift:0

        Rectangle {
            id: rectangle
            height: backgroundRectangle.border.width
            color: backgroundRectangle.border.color
            enabled: false
            anchors.rightMargin: backgroundRectangle.border.width/2
            anchors.leftMargin: backgroundRectangle.border.width/2
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: steeringPoint
            x: steeringItem.center + steeringZone.shift
            width: root.height/2.2
            height: width
            color: dark ? Style.dark_control_primary : Style.light_control_primary
            radius: height/2
            enabled: false
            border.width: root.height/20
            border.color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            layer.enabled: true
            layer.effect: DropShadow{
                radius:Style.joystickDropShadowValue
                color: Style.controlDropShadowColor
            }
        }

        MultiPointTouchArea{
            id: steeringZone
            minimumTouchPoints: 1
            enabled: !editorMode
            touchPoints: [ TouchPoint { id: point1 } ]

            property int shift:-1

            property int last:-1
            property bool firstSendValue: true
            anchors.fill: parent
            z: 3

            onTouchUpdated: {
                var mouseXNormalized = point1.x - width/2;

                if(mouseXNormalized > steeringItem.steeringLenght || mouseXNormalized < -steeringItem.steeringLenght){
                    shift = mouseXNormalized < 0 ? -steeringItem.steeringLenght : steeringItem.steeringLenght
                }
                else shift = mouseXNormalized

                steeringPoint.x = steeringItem.center + steeringZone.shift

                var _angle = parseInt((servoangle/steeringItem.steeringLenght)*Math.abs(shift));

                backgroundRectangle.color = desaturate(Material.accent, _angle);

                if(!inverted)_angle = shift>0 ? _angle : -_angle;
                else _angle = shift>0 ? -_angle : _angle;

                if(firstSendValue){root.send(_angle); firstSendValue = false; }

                angleIndicator.rotation = _angle;

                if(steeringZone.last !== _angle){
                    if( _angle % 10 == 0 /*||  _angle % 10 == 5*/) {
                        root.send(_angle)
                    }
                }
                steeringZone.last = _angle;
            }
            onPressed: {
                if(tap && !editorMode)androidFunc.vibrate(50);
            }
            onReleased: {
                allMovingToCenter.start();
            }
        }

        PropertyAnimation{
            id:allMovingToCenter
            property: "x"
            target: steeringPoint
            from: steeringPoint.x
            to: steeringItem.center
            duration: 100
            onStopped: {
                backgroundRectangle.clearColor();
                root.send(0);
                angleIndicator.rotation = 0;
                steeringZone.firstSendValue = true;
                steeringZone.shift = -1;
                steeringZone.last = -1;
            }
        }

    }
}

/*##^##
Designer {
    D{i:11;anchors_width:70;anchors_y:70}
}
##^##*/
