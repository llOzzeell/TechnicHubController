import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.12

Profile_Control_Parent{
    id:root

    width: 200
    height: width/3

    property int minControlWidth: 200
    property int maxControlWidth: 300

    scalePlusButtonOpacity: !orientation ? (root.width === maxControlWidth ? 0.3 : 1) : (root.height === maxControlWidth ? 0.3 : 1)
    scaleMinusButtonOpacity: !orientation ? (root.width === minControlWidth ? 0.3 : 1) : (root.height === minControlWidth ? 0.3 : 1)

    function send(speed){
        hubOperator.motor_RunPermanent(port1, speed)
    }

    function stop(){

        steeringZone.currentSpeed = 0;
        steeringZone.shift = 0;
        hubOperator.motor_RunPermanent(port1, 0)
    }

    onScaleMinus: {
        if(!orientation){
            if( width > minControlWidth){
                width -= 20;
                height = width/3;
            }
        }
        else{
            if( height > minControlWidth){
                height -= 20;
                width = height/3
            }
        }
    }

    onScalePlus: {
        if(!orientation){
            if( width < maxControlWidth){

                width += 20;
                height = width/3;
            }
        }
        else{
            if( height < maxControlWidth){

                height += 20;
                width = height/3
            }
        }
    }

    onOrientationChanged:{

        if(orientation){

            root.height = root.width;
            root.width = root.width/3;
            slider.rotation = -90;
        }
        else{

            root.width = root.height;
            root.height = root.height/3;
            slider.rotation = 0;
        }

    }

    function save(){

        profilesController.addProfileControls(profileIndex,
                                              type,
                                              orientation ? height : width,
                                              0,
                                              x,
                                              y,
                                              (inverted > 0),
                                              port1,
                                              port2,
                                              0,
                                              0,
                                              orientation);
    }

    Item {
        id: slider
        width: orientation ? parent.height : parent.width
        height: orientation ? parent.width/2 : parent.height/2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: steeringPointShadow
            x: steeringPoint.x
            y: steeringPoint.y
            width: steeringPoint.width
            height: steeringPoint.height
            color: dark ? Style.dark_control_border : Style.light_control_border
            radius: height/2
            enabled: false
            layer.enabled: true
            layer.effect: DropShadow{
                radius:Style.controlDropShadowValue
                color: Style.controlDropShadowColor
            }
        }

        Rectangle {
            id: backgroundRectangle
            color: desaturate(Material.accent, 0)
            radius: Math.min(root.width, root.height)/2
            enabled: false
            border.width: orientation ? root.width/18 : root.height/18
            border.color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.fill: parent
            layer.enabled: true
            layer.effect: DropShadow{
                radius:Style.controlDropShadowValue
                color: Style.controlDropShadowColor
            }
        }


        Rectangle {
            id: powerRectangle
            color: desaturate(Material.accent, Math.abs(steeringZone.currentSpeed))
            radius: height/2
            enabled: false
            anchors.rightMargin: slider.width - steeringZone.shift - steeringPoint.width
            anchors.fill: parent
            border.color: backgroundRectangle.border.color
            border.width: backgroundRectangle.border.width

//            Behavior on color{
//                ColorAnimation{
//                    duration: 200
//                }
//            }
        }


        Rectangle {
            id: steeringPoint
            x: powerRectangle.width - width
            y: 0
            width: steeringItem.height
            height: width
            color: dark ? Style.dark_control_primary : Style.light_control_primary
            radius: height/2
            enabled: false
            border.width: orientation ? root.width/11 : root.height/11
            border.color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: steeringItem
            height: backgroundRectangle.height * 1.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

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

                    var speed = parseInt((100/(steeringItem.width - steeringPoint.width))*Math.abs(mouseXNormalized));
                    var touchSpeed = inverted ? -speed : speed;

                    if(!editorMode){root.send(touchSpeed); powerRectangle.color = desaturate(Material.accent, Math.abs(touchSpeed));}
                    if(speed % 10 == 0 || speed % 10 == 5)currentSpeed = inverted ? -speed : speed;

                }
                onPressed: {
                    if(tap && !editorMode)androidFunc.vibrate(50);
                }
                onCurrentSpeedChanged: {
                    if(tap && !editorMode)androidFunc.vibrate(20);
                    if(!editorMode){ root.send(currentSpeed); powerRectangle.color = desaturate(Material.accent, Math.abs(currentSpeed));}
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:10;anchors_height:200;anchors_width:200}
}
##^##*/
