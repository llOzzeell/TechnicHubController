import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/ModelsControls"

Item {
    id:root
    //opacity: 0
    visible: false
    z: 11

//    Behavior on opacity{
//        NumberAnimation{
//            duration: 200
//        }
//    }

    signal componentChoosed(int type, string path, int width, int height)
    onComponentChoosed: hide()

    readonly property bool isVisible: root.visible

    function show(){
        //opacity = 1;
        root.visible = true
    }

    function hide(){
        //opacity = 0;
        root.visible = false
    }

    function getPathByType(type){
        return root.pathArray[type];
    }

    property var previewSizeSteering:{"width": Units.dp(160), "height":Units.dp(160)}
    property var previewSizeMoving:{"width": Units.dp(160), "height":Units.dp(160)}
    property var previewSizeButtons:{"width": Units.dp(180), "height":Units.dp(90)}
    property var previewSizeButtonsV:{"width": Units.dp(90), "height":Units.dp(180)}
    property var previewSizeSliderH:{"width": Units.dp(200), "height":Units.dp(50)}
    property var previewSizeSliderV:{"width": Units.dp(50), "height":Units.dp(200)}

    property var createNewSizeSteering:{"width": Units.dp(160), "height":Units.dp(160)}
    property var createNewSizeMoving:{"width": Units.dp(160), "height":Units.dp(160)}
    property var createNewSizeButtons:{"width": Units.dp(160), "height":Units.dp(80)}
    property var createNewSizeButtonsV:{"width": Units.dp(80), "height":Units.dp(160)}
    property var createNewSizeSliderH:{"width": Units.dp(250), "height":Units.dp(50)}
    property var createNewSizeSliderV:{"width": Units.dp(50), "height":Units.dp(250)}


    property var pathArray:[
    "qrc:/ModelsControls/JoySteering.qml",
        "qrc:/ModelsControls/JoyMoving.qml",
            "qrc:/ModelsControls/Buttons.qml",
                "qrc:/ModelsControls/ButtonsV.qml",
                    "qrc:/ModelsControls/SliderH.qml",
                        "qrc:/ModelsControls/SliderV.qml"]



    Component{
        id: joySteering
        JoySteering {
            width: root.previewSizeSteering.width
            height: root.previewSizeSteering.height
            editorMode: false
            paletteMode: true
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(0,root.pathArray[0], root.createNewSizeSteering.width,root.createNewSizeSteering.height)
            }
            Label{
                text: ConstList_Text.control_name_steering
                anchors.topMargin: Units.dp(5)
                anchors.top: parent.bottom
                font.pixelSize: Qt.application.font.pixelSize * 1.2
                font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on opacity{
                    NumberAnimation{
                        duration: 1
                    }
                }
            }
        }
    }

    Component{
        id: joyMoving
        JoyMoving {
            width: root.previewSizeMoving.width
            height: root.previewSizeMoving.height
            editorMode: false
            paletteMode: true
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(1,root.pathArray[1], root.createNewSizeMoving.width,root.createNewSizeMoving.height)
            }
            Label{
                text: ConstList_Text.control_name_moving
                anchors.topMargin: Units.dp(5)
                anchors.top: parent.bottom
                font.pixelSize: Qt.application.font.pixelSize * 1.2
                font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on opacity{
                    NumberAnimation{
                        duration: 1
                    }
                }
            }
        }
    }

    Component{
        id: buttons
        Buttons {
            width: root.previewSizeButtons.width
            height: root.previewSizeButtons.height
            editorMode: false
            paletteMode: true
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(2,root.pathArray[2], root.createNewSizeButtons.width,root.createNewSizeButtons.height)
            }
            Label{
                text: ConstList_Text.control_name_buttons
                anchors.topMargin: Units.dp(5)
                anchors.top: parent.bottom
                font.pixelSize: Qt.application.font.pixelSize * 1.2
                font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on opacity{
                    NumberAnimation{
                        duration: 1
                    }
                }
            }
        }
    }

    Component{
        id: buttonsV
        ButtonsV {
            width: root.previewSizeButtonsV.width
            height: root.previewSizeButtonsV.height
            editorMode: false
            paletteMode: true
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(3,root.pathArray[3], root.createNewSizeButtonsV.width,root.createNewSizeButtonsV.height)
            }
            Label{
                text: ConstList_Text.control_name_buttonsV
                anchors.topMargin: Units.dp(5)
                anchors.top: parent.bottom
                font.pixelSize: Qt.application.font.pixelSize * 1.2
                font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on opacity{
                    NumberAnimation{
                        duration: 1
                    }
                }
            }
        }
    }

    Component{
        id:hslider
        SliderH{
            width: root.previewSizeSliderH.width
            height: root.previewSizeSliderH.height
            editorMode: false
            paletteMode: true
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(4,root.pathArray[4], root.createNewSizeSliderH.width,root.createNewSizeSliderH.height)
            }
            Label{
                text: ConstList_Text.control_name_hslider
                anchors.topMargin: Units.dp(5)
                anchors.top: parent.bottom
                font.pixelSize: Qt.application.font.pixelSize * 1.2
                font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on opacity{
                    NumberAnimation{
                        duration: 1
                    }
                }
            }
        }
    }

    Component{
        id:vslider
        SliderV{
            width: root.previewSizeSliderV.width
            height: root.previewSizeSliderV.height
            editorMode: false
            paletteMode: true
            MouseArea{
                anchors.fill: parent
                onClicked: root.componentChoosed(5,root.pathArray[5], root.createNewSizeSliderV.width,root.createNewSizeSliderV.height)
            }
            Label{
                text: ConstList_Text.control_name_vslider
                anchors.topMargin: Units.dp(5)
                anchors.top: parent.bottom
                font.pixelSize: Qt.application.font.pixelSize * 1.2
                font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
                Behavior on opacity{
                    NumberAnimation{
                        duration: 1
                    }
                }
            }
        }
    }

    //////////////////////////////////////////////////

    Rectangle {
        id: background
        color: Material.background
        anchors.fill: parent
        opacity: 0.95
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            hide();
        }
    }

    Flickable {
        id: flickable
        height: column.height
        flickableDirection: Flickable.HorizontalFlick
        anchors.right: parent.right
        anchors.rightMargin: column.spacing
        anchors.left: parent.left
        anchors.leftMargin: column.spacing
        anchors.verticalCenter: parent.verticalCenter
        contentWidth: column.width;
        contentHeight: column.height

        Row {
            id: column
            width: root.previewSizeSteering.width +
                   root.previewSizeMoving.width +
                   root.previewSizeButtons.width +
                   root.previewSizeButtonsV.width +
                   root.previewSizeSliderH.width +
                   root.previewSizeSliderV.width +
                   spacing * 6

            height: Units.dp(160)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            spacing: Units.dp(60)

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: joySteering
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: joyMoving
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: buttons
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: buttonsV
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: hslider
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: vslider
            }
        }
    }
}

