import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Profile_Control_Parent{
    id:root

    width:120
    height: width
    onHeightChanged: toCenter.start();

    property int speedLimit: 100
    property int currentSpeed:0

    signal currentSpeedReady(int currentSpeed)
    onCurrentSpeedReady: hubOperator.motor_RunPermanent(port, currentSpeed)

    Item{
        id:controlItem
        rotation: -90
        anchors.fill: parent

        Rectangle {
            id: backgroundRectangle
            color: "#474646"
            radius: height/2
            rotation: 0
            border.width: controlItem.height/30
            border.color: "#302f2f"
            anchors.fill: parent

            Behavior on color{
                ColorAnimation{
                    duration: 500
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
                width: controlItem.height/2.2
                height: width
                color: "#868686"
                radius: height/2
                border.width: controlItem.height/20
                border.color: "#696969"
                anchors.verticalCenterOffset: 0
                anchors.verticalCenter: parent.verticalCenter
                layer.enabled: false
                layer.effect: DropShadow{
                    radius:8
                }
                onXChanged: {
                    var shift = steeringItem.center - x;
                    var angle = (speedLimit/steeringItem.steeringLenght)*Math.abs(shift);
                    if(!inverted) currentSpeed = shift < 0 ? angle : -angle;
                    else currentSpeed = shift < 0 ? -angle : angle;
                }
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
                touchPoints: [ TouchPoint { id: point1 } ]
                property int shift:0
                onTouchUpdated: {
                    var mouseXNormalized = point1.x - width/2;

                    if(mouseXNormalized > steeringItem.steeringLenght || mouseXNormalized < -steeringItem.steeringLenght){

                        shift = mouseXNormalized < 0 ? -steeringItem.steeringLenght : steeringItem.steeringLenght
                    }
                    else shift = mouseXNormalized

                }

                onPressed: {
                    backgroundRectangle.color = Qt.lighter("#474646", 1.4)
                }
                onReleased: {
                    backgroundRectangle.color = "#474646"
                    toCenter.start();
                    currentSpeedReady(0)
                    discreteTimer.savedLastSpeed = 0;
                }
            }

            Timer{
                id: discreteTimer
                running: steeringZone.pressed
                interval: 200
                repeat: true
                property int savedLastSpeed:0
                onTriggered:{
                    if(savedLastSpeed != currentSpeed){

                        root.currentSpeedReady(currentSpeed);
                        savedLastSpeed = currentSpeed;
                    }
                }
            }

        }

    }

 }
