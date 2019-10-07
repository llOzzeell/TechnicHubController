import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Item {
    id:root
    width: 200
    height: width
    opacity: 0;

    Behavior on opacity {
        SequentialAnimation{
            NumberAnimation{
                duration: 1000
            }
        }

    }

    property color lineColor: Material.accent
    property color sectionColor: Material.foreground

    function start(){
        animationClear();
        root.opacity = 1;
        lineAnimate.running = true;
        radarAnimate1.running = true;
        timer.running = true;
        element.opacity = 0.5;
    }
    function stop(){
        root.opacity = 0;
    }

    function animationClear(){
        lineAnimate.running = false;
        timer.running = false;
        timer.counter = 0;
        radarAnimate1.running = false;
        radarAnimate2.running = false;
        radarAnimate3.running = false;
        radarSection1.width = root.width/10;
        radarSection1.opacity = 0;
        radarSection2.width = root.width/10;
        radarSection2.opacity = 0;
        radarSection3.width = root.width/10;
        radarSection3.opacity = 0;
        element.rotation = 0;
    }

    Rectangle {
        id: radarSection1
        width: root.width/10
        height: width
        color: sectionColor
        radius: height/2
        opacity: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: radarSection2
        width: root.width/10
        height: width
        color: sectionColor
        radius: height/2
        opacity: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: radarSection3
        width: root.width/10
        height: width
        color: sectionColor
        radius: height/2
        opacity: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Item {
        id: element
        width: root.width
        height: width
        opacity: 0

        Rectangle {
            id: rectangle
            width: 4
            color: lineColor
            radius: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 0
            visible: true
            layer.enabled: false
            layer.effect: DropShadow{
                color: lineColor
                radius: 4
                horizontalOffset: -2
            }
        }
    }

    ParallelAnimation{
        id:radarAnimate1
        PropertyAnimation{
            target: radarSection1
            property: "width"
            from: root.width/10
            to: root.width
            duration: 6000
            loops: Animation.Infinite
        }
        PropertyAnimation{
            target: radarSection1
            property: "opacity"
            from: 0.8
            to: 0
            duration: 6000
            loops: Animation.Infinite
        }
    }

    ParallelAnimation{
        id:radarAnimate2
        PropertyAnimation{
            target: radarSection2
            property: "width"
            from: root.width/10
            to: root.width
            duration: 6000
            loops: Animation.Infinite
        }
        PropertyAnimation{
            target: radarSection2
            property: "opacity"
            from: 0.8
            to: 0
            duration: 6000
            loops: Animation.Infinite
        }
    }

    ParallelAnimation{
        id:radarAnimate3
        PropertyAnimation{
            target: radarSection3
            property: "width"
            from: root.width/10
            to: root.width
            duration: 6000
            loops: Animation.Infinite
        }
        PropertyAnimation{
            target: radarSection3
            property: "opacity"
            from: 0.8
            to: 0
            duration: 6000
            loops: Animation.Infinite
        }
    }

    PropertyAnimation{
        id:lineAnimate
        target: element
        property: "rotation"
        from:0
        to:360
        duration: 5000
        loops: Animation.Infinite
    }

    Timer{
        id:timer
        interval: 2000
        repeat: true
        property int counter:0
        onTriggered: {
            counter++;
            if(counter === 1)radarAnimate2.running = true;
            if(counter === 2)radarAnimate3.running = true;

        }
    }


}

/*##^##
Designer {
    D{i:5;anchors_height:200}
}
##^##*/
