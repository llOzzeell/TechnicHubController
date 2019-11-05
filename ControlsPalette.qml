import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/ModelsControls"

Item {
    id:root
    visible: false

    signal componentChoosed(int type, string path, int width, int height)
    onComponentChoosed: hide()

    readonly property bool isVisible: root.visible

    function show(){
        root.visible = true
    }

    function hide(){
        root.visible = false
    }

    function getPathByType(type){
        return root.pathArray[type];
    }

    property var pathArray:[
    "qrc:/ModelsControls/JoySteering.qml",
        "qrc:/ModelsControls/JoyMoving.qml",
            "qrc:/ModelsControls/Buttons.qml",
                "qrc:/ModelsControls/ButtonsV.qml",
                    "qrc:/ModelsControls/SliderH.qml",
                        "qrc:/ModelsControls/SliderV.qml",
                            "qrc:/ModelsControls/TiltMonitor.qml"
    ]

    //////////////////////////////////////////////////


    Rectangle {
        id: background
        color: Material.primary
        anchors.fill: parent
        opacity: 0.95
    }

    Label {
        id: label
        text: qsTr("Palette of controls")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: flickable.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Qt.application.font.pixelSize * 2
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
        maximumFlickVelocity: 3500
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
            height: Units.dp(240)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            spacing: Units.dp(60)

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted:{ setSource("qrc:/Controls/ControlsPalette_Delegate.qml",
                                                 {
                                                     "width":Units.dp(400),
                                                     "height":Units.dp(240),
                                                     "name":"steering",
                                                     "sourceString":pathArray[0],
                                                     "invertPossible":true,
                                                     "steeringPossible":true,
                                                     "servoanglePossible":true,
                                                     "movingPossible":false,
                                                     "speedlimitPossible":false,
                                                      "tiltXPossible":false,
                                                      "tiltYPossible":false,

                                                      "type":0,
                                                      "newWidth":Units.dp(160),
                                                      "newHeight":Units.dp(160)
                                                 });
                }
                onLoaded: item.clicked.connect(root.componentChoosed);
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted:{ setSource("qrc:/Controls/ControlsPalette_Delegate.qml",
                                                 {
                                                     "width":Units.dp(400),
                                                     "height":Units.dp(240),
                                                     "name":"moving",
                                                     "sourceString":pathArray[1],
                                                     "invertPossible":true,
                                                     "steeringPossible":false,
                                                     "servoanglePossible":false,
                                                     "movingPossible":true,
                                                     "speedlimitPossible":true,
                                                      "tiltXPossible":false,
                                                      "tiltYPossible":false,

                                                      "type":1,
                                                      "newWidth":Units.dp(160),
                                                      "newHeight":Units.dp(160)
                                                 });
                }
                onLoaded: item.clicked.connect(root.componentChoosed);
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted:{ setSource("qrc:/Controls/ControlsPalette_Delegate.qml",
                                                 {
                                                     "width":Units.dp(400),
                                                     "height":Units.dp(240),
                                                     "name":"buttons",
                                                     "sourceString":pathArray[2],
                                                     "invertPossible":true,
                                                     "steeringPossible":true,
                                                     "servoanglePossible":true,
                                                     "movingPossible":true,
                                                     "speedlimitPossible":true,
                                                      "tiltXPossible":false,
                                                      "tiltYPossible":false,

                                                      "type":2,
                                                      "newWidth":Units.dp(160),
                                                      "newHeight":Units.dp(80)
                                                 });
                }
                onLoaded: item.clicked.connect(root.componentChoosed);
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted:{ setSource("qrc:/Controls/ControlsPalette_Delegate.qml",
                                                 {
                                                     "width":Units.dp(400),
                                                     "height":Units.dp(240),
                                                     "name":"buttonsV",
                                                     "sourceString":pathArray[3],
                                                     "invertPossible":true,
                                                     "steeringPossible":false,
                                                     "servoanglePossible":false,
                                                     "movingPossible":true,
                                                     "speedlimitPossible":true,
                                                      "tiltXPossible":false,
                                                      "tiltYPossible":false,

                                                      "type":3,
                                                      "newWidth":Units.dp(80),
                                                      "newHeight":Units.dp(160)
                                                 });
                }
                onLoaded: item.clicked.connect(root.componentChoosed);

            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted:{ setSource("qrc:/Controls/ControlsPalette_Delegate.qml",
                                                 {
                                                     "width":Units.dp(400),
                                                     "height":Units.dp(240),
                                                     "name":"hslider",
                                                     "sourceString":pathArray[4],
                                                     "invertPossible":true,
                                                     "steeringPossible":false,
                                                     "servoanglePossible":false,
                                                     "movingPossible":true,
                                                     "speedlimitPossible":false,
                                                      "tiltXPossible":false,
                                                      "tiltYPossible":false,

                                                      "type":4,
                                                      "newWidth":Units.dp(240),
                                                      "newHeight":Units.dp(60)
                                                 });
                }
                onLoaded: item.clicked.connect(root.componentChoosed);
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted:{ setSource("qrc:/Controls/ControlsPalette_Delegate.qml",
                                                 {
                                                     "width":Units.dp(400),
                                                     "height":Units.dp(240),
                                                     "name":"vslider",
                                                     "sourceString":pathArray[5],
                                                     "invertPossible":true,
                                                     "steeringPossible":false,
                                                     "servoanglePossible":false,
                                                     "movingPossible":true,
                                                     "speedlimitPossible":false,
                                                     "tiltXPossible":false,
                                                     "tiltYPossible":false,

                                                      "type":5,
                                                      "newWidth":Units.dp(60),
                                                      "newHeight":Units.dp(240)
                                                 });

                }
                onLoaded: item.clicked.connect(root.componentChoosed);
            }

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted:{ setSource("qrc:/Controls/ControlsPalette_Delegate.qml",
                                                 {
                                                      "width":Units.dp(400),
                                                      "height":Units.dp(240),
                                                     "name":"tilt",
                                                     "sourceString":pathArray[6],
                                                     "invertPossible":false,
                                                     "steeringPossible":false,
                                                     "servoanglePossible":false,
                                                     "movingPossible":false,
                                                     "speedlimitPossible":false,
                                                      "tiltXPossible":true,
                                                      "tiltYPossible":true,

                                                      "type":6,
                                                      "newWidth":Units.dp(160),
                                                      "newHeight":Units.dp(80)
                                                 });

                }
                onLoaded: item.clicked.connect(root.componentChoosed);
            }
        }
    }

}

