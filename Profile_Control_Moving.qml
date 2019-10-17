import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Profile_Control_Parent{
    id:root

    width:140
    height: width

    onHeightChanged: {
        allMovingToCenter.start();
    }

    property int minControlWidth: 140
    property int maxControlWidth: 200

    scalePlusButtonOpacity: root.width === maxControlWidth ? 0.3 : 1
    scaleMinusButtonOpacity: root.width === minControlWidth ? 0.3 : 1

    onScaleMinus: {
        if( width > minControlWidth) width -= 20;
    }

    onScalePlus: {
        if( width < maxControlWidth) width += 20;
    }

    function send(speed){
        hubOperator.motor_RunPermanent(port1, speed);
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
                                              0,
                                              0,
                                              false);
    }

//    function stopAll(){
//        steeringZone.shift = 0;
//        steeringZone.last = -1;
//        allMovingToCenter.start();
//        hubOperator.motor_RunPermanent(port1, 0);
//    }

    Item{
        id:controlItem
        rotation: -90
        anchors.fill: parent

        Rectangle {
            id: backgroundRectangle
            color: startColor
            radius: height/2
            rotation: 0
            border.width: controlItem.height/30
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
            y: 100
            height: controlItem.height/2
            z: 0
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

            PropertyAnimation{
                id:allMovingToCenter
                property: "x"
                target: steeringPoint
                from: steeringPoint.x
                to: steeringItem.center
                duration: 100
                onStopped: {
                    backgroundRectangle.clearColor()
                    steeringZone.firstSendValue = true;
                    steeringZone.shift = -1;
                    steeringZone.last = -1;
                    root.send(0);
                }
            }

            MultiPointTouchArea {
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

                property int shift:0
                property int last:-1
                property bool firstSendValue: true

                onTouchUpdated: {
                    var mouseXNormalized = point1.x - width/2;
                    if(mouseXNormalized > steeringItem.steeringLenght || mouseXNormalized < -steeringItem.steeringLenght){
                        shift = mouseXNormalized < 0 ? -steeringItem.steeringLenght : steeringItem.steeringLenght
                    }
                    else shift = mouseXNormalized

                    steeringPoint.x = steeringItem.center + steeringZone.shift

                    var _speed = (100/steeringItem.steeringLenght)*Math.abs(shift);

                    backgroundRectangle.color = desaturate(Material.accent, _speed);

                    if(!inverted) _speed = shift < 0 ? _speed : -_speed;
                    else _speed = shift < 0 ? -_speed : _speed;


                    if(firstSendValue){ root.send( _speed); firstSendValue = false; }

                    if(steeringZone.last !== _speed){
                        if( _speed % 10 == 0 ||  _speed % 10 == 5) {
                            root.send(_speed)
                        }
                    }
                    steeringZone.last = _speed;
                }
                onPressed: {
                    if(tap && !editorMode)androidFunc.vibrate(50);
                }
                onReleased: {
                    allMovingToCenter.start();
                }
            }
        }
    }
 }
