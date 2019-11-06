import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import ".."
import "qrc:/assets"
import "qrc:/Controls"


Parent{
    id:root
    width:Units.dp(140)
    height:Units.dp(70)

    property int axisX:0
    property int axisY:0

    name: ConstList_Text.control_name_tilt

    Component.onCompleted:{
        requiredParameters.ports = false;
    }

    onSizeMinusClicked: {
        if(scaleStep > 0) {

            height -= Units.dp(20);
            width = height*2;
            scaleStep--;
        }
    }

    onEditorModeChanged: {
        if(editorMode){
            axisX = 0;
            axisY = 0;
        }
    }

    onSizePlusClicked: {
        if(scaleStep < 3) {

            height += Units.dp(20);
            width = height*2;
            scaleStep++;
        }
    }

    CustomCircle {
        id: customCircle
        anchors.fill: parent
    }

    Rectangle {
        id: rectangle
        width: root.height/1.1
        height: width
        color: Material.background
        radius: height/2
        clip: true
        anchors.leftMargin: (root.height - height)/2
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Item {
            id: element2
            width: parent.width
            height: parent.width
            rotation: root.axisX
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Behavior on rotation{
                NumberAnimation{duration:60}
            }

            Item {
                id: element
                width: parent.width
                height: parent.width/2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true

                Rectangle {
                    id: rectangle2
                    width: parent.width
                    height: parent.width
                    color: Material.accent
                    radius: height/2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                }

                Image {
                    id: image2
                    width: parent.width/1.2
                    height: width
                    anchors.verticalCenterOffset: Units.dp(-8)
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:assets/icons/carFront.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                id: label
                text: getAngleText(root.axisX) + "°"
                anchors.topMargin: 0
                anchors.bottom: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottomMargin: 0
                visible: true
                font.weight: Font.Thin
                fontSizeMode: Text.HorizontalFit
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: root.height/3
                anchors.margins: Units.dp(10)

                function getAngleText(x){
                    x = Math.abs(x);
                    if(x > 90) return ">90";
                    else return x;
                }
            }
        }


    }

    Rectangle {
        id: rectangle1
        width: root.height/1.1
        height: width
        color: Material.background
        radius: height/2
        clip: true
        anchors.rightMargin: (root.height - height)/2
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Item {
            id: element3
            width: parent.width
            height: parent.width
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            rotation: root.axisY

            Behavior on rotation{
                NumberAnimation{duration:60}
            }

            Item {
                id: element1
                width: parent.width
                height: parent.width/2
                clip: true
                anchors.bottomMargin: 0
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    id: rectangle3
                    width: parent.width
                    height: parent.width
                    color: Material.accent
                    radius: height/2
                    anchors.bottomMargin: 0
                    anchors.bottom: parent.bottom
                }

                Image {
                    id: image1
                    width: parent.width/1.2
                    height: width
                    anchors.verticalCenterOffset: Units.dp(-8)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:assets/icons/carSide.svg"
                }
            }

            Label {
                id: label1
                text:  Math.abs(root.axisY) + "°"
                anchors.topMargin: 0
                anchors.bottom: parent.verticalCenter
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottomMargin: 0
                visible: true
                font.weight: Font.Thin
                fontSizeMode: Text.HorizontalFit
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: root.height/3
                anchors.margins: Units.dp(10)
            }
        }


    }

    Connections{
        target:cpp_Connector
        onTiltDegreesChanged:{
            if(address === chAddress && !editorMode){
                axisX = x;
                axisY = y;
            }
        }
    }
}

