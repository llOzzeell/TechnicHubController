import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.3

Item {
    id:root
    opacity: 0
    onOpacityChanged:{
        if(opacity <= 0) fallBack();
    }

    Behavior on opacity {
        NumberAnimation{duration:200}
    }

    property color lineColor: Material.accent
    property color sectionColor: Material.foreground

    function start(){
        root.opacity = 0.2;
        radarSpinning.start()
    }
    function stop(){
        root.opacity = 0;
        radarSpinning.stop()
    }

    function fallBack(){
            radarSection1.width = root.width/10;
            radarSection1.opacity = 0;
            radarSection2.width = root.width/10;
            radarSection2.opacity = 0;
            radarSection3.width = root.width/10;
            radarSection3.opacity = 0;
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
        id: lineItem
        width: root.width
        height: width
        opacity: 0

        Rectangle {
            id: lineRectangle
            width: 4
            color: lineColor
            radius: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 0
        }
    }

    ParallelAnimation{
        id:radarSpinning

        ParallelAnimation{
            PropertyAnimation{
                target: radarSection1
                property: "width"
                from: root.width/10
                to: root.width*1.5
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

        SequentialAnimation{
            NumberAnimation{
                duration: 2000
            }
            ParallelAnimation{
                PropertyAnimation{
                    target: radarSection2
                    property: "width"
                    from: root.width/10
                    to: root.width*1.5
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
        }

        SequentialAnimation{
            NumberAnimation{
                duration: 4000
            }
            ParallelAnimation{
                PropertyAnimation{
                    target: radarSection3
                    property: "width"
                    from: root.width/10
                    to: root.width*1.5
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
        }
    }
}
