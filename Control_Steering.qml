import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: item1
    width: 300
    height: width
    rotation: 0

    property string port: "A"
    property int steeringDegrees: 90
    property int currentDegrees:0

    signal currentDegreesReady(int currentDegrees)

    Rectangle {
        id: backgroundRectangle
        color: "#474646"
        radius: height/2
        border.width: item1.height/30
        border.color: "#302f2f"
        anchors.fill: parent
    }

    Item {
        id: steeringItem
        y: 100
        height: item1.height/2
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
            width: item1.height/2.2
            height: width
            color: "#868686"
            radius: height/2
            border.width: item1.height/20
            border.color: "#696969"
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            layer.enabled: true
            layer.effect: DropShadow{
                //transparentBorder: true
                //smooth: true
                radius:8
            }
            onXChanged: {
                var shift = steeringItem.center - x;
                var angle = (steeringDegrees/steeringItem.steeringLenght)*Math.abs(shift);
                item1.currentDegrees = shift < 0 ? angle : -angle;
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


        MouseArea {
            id: steeringZone
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            onReleased: {
                toCenter.running = true;
                item1.currentDegreesReady(0)
                discreteTimer.lastSaved = 0;
            }

            onMouseXChanged: {
                var mouseXNormalized = mouseX - width/2;

                if(mouseXNormalized > steeringItem.steeringLenght || mouseXNormalized < -steeringItem.steeringLenght){

                    shift = mouseXNormalized < 0 ? -steeringItem.steeringLenght : steeringItem.steeringLenght
                }
                else shift = mouseXNormalized

            }

            property int shift:0
        }

        Timer{
            id: discreteTimer
            running: steeringZone.pressed
            interval: 200
            repeat: true
            property int lastSaved:0
            onTriggered:{
                if(lastSaved != item1.currentDegrees) { item1.currentDegreesReady(item1.currentDegrees); lastSaved = item1.currentDegrees; }
            }
        }
    }

}
