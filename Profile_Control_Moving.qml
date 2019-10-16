import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Profile_Control_Parent{
    id:root

    width:140
    height: width

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

    onHeightChanged: toCenter.start();

    property int currentSpeed:0

    signal currentSpeedReady(int currentSpeed)
    onCurrentSpeedReady:{
        if(!editorMode){
            hubOperator.motor_RunPermanent(port1, currentSpeed)
        }
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

    Item{
        id:controlItem
        rotation: -90
        anchors.fill: parent

        Rectangle {
            id: backgroundRectangle
            color: dark ? Style.dark_control_background : Style.light_control_background
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
                border.width: root.height/30
                border.color: dark ? Style.dark_control_border : Style.light_control_border
                anchors.verticalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
            }

            PropertyAnimation{
                id:toCenter
                property: "x"
                target: steeringPoint
                from: steeringPoint.x
                to: steeringItem.center
                duration: 80
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
                property bool press: false

                onTouchUpdated: {
                    var mouseXNormalized = point1.x - width/2;
                    if(mouseXNormalized > steeringItem.steeringLenght || mouseXNormalized < -steeringItem.steeringLenght){
                        shift = mouseXNormalized < 0 ? -steeringItem.steeringLenght : steeringItem.steeringLenght
                    }
                    else shift = mouseXNormalized
                    var angle = (100/steeringItem.steeringLenght)*Math.abs(shift);
                    if(press)backgroundRectangle.color = desaturate(Material.accent, angle);
                    if(!inverted) currentSpeed = shift < 0 ? angle : -angle;
                    else currentSpeed = shift < 0 ? -angle : angle;
                }
                onPressed: {
                    press = true
                    backgroundRectangle.color = desaturate(Material.accent, 0)
                    if(tap && !editorMode)androidFunc.vibrate(50);
                }
                onReleased: {
                    press = false
                    toCenter.start();
                    currentSpeedReady(0)
                    discreteTimer.savedLastSpeed = 0;
                    backgroundRectangle.color = dark ? Style.dark_control_background : Style.light_control_background
                }
            }

            Timer{
                id: discreteTimer
                running: steeringZone.press
                interval: 200
                repeat: true
                property int savedLastSpeed:0
                onTriggered:{
                    if(savedLastSpeed != currentSpeed){
                        if(tap && !editorMode)androidFunc.vibrate(20);
                        root.currentSpeedReady(currentSpeed);
                        savedLastSpeed = currentSpeed;
                    }
                }
            }
        }
    }
 }
