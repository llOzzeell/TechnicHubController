import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.12

Profile_Control_Parent{
    id:root

    width:120
    height: width

    function send(curr){
        if(tap)androidFunc.vibrate(10);
        hubOperator.motor_SendServoAngle(port1, curr, servoangle)
    }

    Rectangle {
        id: backgroundRectangle
        color: "#474646"
        radius: height/2
        border.width: root.height/30
        border.color: "#302f2f"
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

    Item {
        id: steeringItem
        height: root.height/2
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        onHeightChanged: toCenter.start();

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
            color: "#868686"
            radius: height/2
            border.width: root.height/30
            border.color: "#302f2f"
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            layer.enabled: false
            layer.effect: DropShadow{
                radius:8
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

            onTouchUpdated: {
                var mouseXNormalized = point1.x - width/2;
                if(mouseXNormalized > steeringItem.steeringLenght || mouseXNormalized < -steeringItem.steeringLenght){
                    shift = mouseXNormalized < 0 ? -steeringItem.steeringLenght : steeringItem.steeringLenght
                }
                else shift = mouseXNormalized

                var angle = parseInt((servoangle/steeringItem.steeringLenght)*Math.abs(shift));
                var _currentDegrees = 0;
                if(!inverted)_currentDegrees = shift>0 ? angle : -angle;
                else _currentDegrees = shift>0 ? -angle : angle;
                if( _currentDegrees % 10 == 0 /*||  _currentDegrees % 10 == 5*/) {
                    currentDegrees = _currentDegrees;
                }
            }

            onPressed: {
                press = true
                backgroundRectangle.color = Qt.lighter("#474646", 1.4)
                if(tap)androidFunc.vibrate(50);
            }
            onReleased: {
                press = false
                toCenter.running = true;
                backgroundRectangle.color = "#474646"
                if(!editorMode)root.send(port1, 0, 0, servoangle);
            }
            property int currentDegrees:0
            onCurrentDegreesChanged: {
                if(!editorMode)root.send(steeringZone.currentDegrees)
                lastDegrees = currentDegrees;
            }

            property bool press: false
            property int lastDegrees:0
            property int shift:0
        }
    }
}
