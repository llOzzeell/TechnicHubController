import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root

    implicitWidth: 120
    implicitHeight: 120


    property int minControlWidth:120
    property int maxControlWidth:260

    property int createIndex: -1
    property bool editorMode: true

    property int type;
    property alias port1: port1.currentIndex
    property alias port2: port2.currentIndex
    property alias inverted: switchD.checked
    property int maxspeed;
    property int servoangle;

    width: implicitWidth
    height: implicitheight
    rotation: 90

    function setScalePlus(){
        if( width < maxControlWidth) width += 20;
    }

    function setScaleMinus(){
        if( width > minControlWidth) width -= 20;
    }

    Drag.active: movingMouseArea.drag.active


    Item {
        id: editorItem
        visible: true
        z: 2
        anchors.fill: parent

        Row {
            id: circlebuttonPanel
            height: 38
            anchors.bottom: parent.top
            anchors.bottomMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Gui_Profile_CircleButton {
                id: deleteButton
                width: 36
                height: width
                backgroundColor: Style.remove_Red
                iconSource: "icons/remove.svg"
                visible: editorMode
                onClicked: root.parent.deleteControl(createIndex)
            }

            Gui_Profile_CircleButton {
                id: scaleMinus
                width: 36
                backgroundColor: Material.primary
                iconSource: "icons/minus.svg"
                visible: editorMode
                onClicked: setScaleMinus();
                opacity: root.width === minControlWidth ? 0.3 : 1
            }

            Gui_Profile_CircleButton {
                id: scalePlus
                width: 36
                height: width
                backgroundColor: Material.primary
                iconSource: "icons/plus.svg"
                visible: editorMode
                onClicked: setScalePlus();
                opacity: root.width === maxControlWidth ? 0.3 : 1
            }

            Gui_Profile_CircleButton {
                id: propButton
                width: 36
                height: width
                visible: editorMode
                backgroundColor: Material.primary
                iconSource: "icons/profileEdit.svg"
                onClicked: paramItem.visible = true
            }
        }

        Rectangle {
            id: frame
            color: "#00000000"
            radius: 2
            border.color: Material.foreground
            visible: editorMode
            opacity: 0.3
            border.width: 2
            anchors.fill: parent
        }

    }

    MouseArea {
        id: movingMouseArea
        z: 1
        anchors.fill: parent
        visible: editorMode
        drag.target: parent
    }

    Item {
        id: paramItem
        x: -42
        y: -74
        width: 220
        height: 251
        z: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false

        Pane {
            id: background
            anchors.fill: parent
            Material.background: Material.primary
            Material.elevation: 4
        }

        Column {
            id: column
            height: 94
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            spacing: 2

            Item {
                id: propItem_1
                width: parent.width
                height: 40

                Gui_ComboBox_Custom{
                    id: port1
                    x: 319
                    y: 13
                    width: 60
                    height: parent.height
                    rotation: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    font.pointSize: 12
                    visible: editorMode
                    model: portModel

                    ListModel{
                        id:portModel
                        ListElement{
                            name: "A"
                        }
                        ListElement{
                            name: "B"
                        }
                        ListElement{
                            name: "C"
                        }
                        ListElement{
                            name: "D"
                        }
                    }
                }

                Label {
                    id: label
                    text: qsTr("Порт")
                    font.weight: Font.Light
                    font.pointSize: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: propItem_2
                width: parent.width
                height: 40
                visible: false

                Gui_ComboBox_Custom {
                    id: port2
                    width: 60
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    model: portModel
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    visible: editorMode
                    font.bold: true
                    font.pointSize: 12
                }

                Label {
                    id: label2
                    text: qsTr("Порт")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.weight: Font.Light
                    anchors.leftMargin: 10
                    font.pointSize: 12
                }
            }

            Item {
                id: propItem_3
                width: parent.width
                height: 40

                Label {
                    id: label1
                    text: qsTr("Инверсия")
                    font.weight: Font.Light
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                    font.pointSize: 10
                }

                Switch {
                    id: switchD
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: propItem_4
                width: parent.width
                height: 40
                Label {
                    id: label3
                    text: qsTr("Угол серво")
                    anchors.leftMargin: 10
                    font.pointSize: 9
                    anchors.left: parent.left
                    font.weight: Font.Light
                    anchors.verticalCenter: parent.verticalCenter
                }

                SpinBox {
                    id: servoA
                    x: 86
                    y: 270
                    width: 120
                    height: 31
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    value: 90
                    to: 179
                }
            }

            Item {
                id: propItem_5
                width: parent.width
                height: 40
                Label {
                    id: label4
                    text: qsTr("Макс. скорость")
                    anchors.leftMargin: 10
                    font.pointSize: 9
                    anchors.left: parent.left
                    font.weight: Font.Light
                    anchors.verticalCenter: parent.verticalCenter
                }

                SpinBox {
                    id: servoA1
                    x: 86
                    y: 270
                    width: 120
                    height: 31
                    from: 1
                    anchors.right: parent.right
                    value: 100
                    anchors.rightMargin: 0
                    to: 100
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        }

        Gui_Profile_Button {
            id: gui_Profile_Button
            height: 26
            text: "Закрыть"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            onClicked: paramItem.visible = false
        }
    }
}


