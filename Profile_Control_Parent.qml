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
    property string port: portModel.get(comboBox.currentIndex).name
    property bool inverted: false

    width: implicitWidth
    height: implicitheight

    function setScalePlus(){
        if( width < maxControlWidth) width += 20;
    }

    function setScaleMinus(){
        if( width > minControlWidth) width -= 20;
    }

    Drag.active: movingMouseArea.drag.active

    MouseArea {
        id: movingMouseArea
        z: 1
        anchors.fill: parent
        visible: editorMode
        drag.target: parent
    }

    Item {
        id: editorItem
        visible: true
        z: 2
        anchors.fill: parent

        Gui_Profile_CircleButton {
            id: scalePlus
            y: 14
            width: 36
            height: width
            backgroundColor: Material.primary
            anchors.left: scaleMinus.right
            anchors.leftMargin: 6
            anchors.bottom: parent.top
            anchors.bottomMargin: 10
            iconSource: "icons/plus.svg"
            visible: editorMode
            onClicked: setScalePlus();
            opacity: root.width === maxControlWidth ? 0.3 : 1
        }

        Gui_Profile_CircleButton {
            id: scaleMinus
            y: 14
            width: 36
            backgroundColor: Material.primary
            anchors.left: parent.left
            anchors.leftMargin: 0
            iconSource: "icons/minus.svg"
            anchors.verticalCenter: scalePlus.verticalCenter
            visible: editorMode
            onClicked: setScaleMinus();
            opacity: root.width === minControlWidth ? 0.3 : 1
        }

        Gui_Profile_CircleButton {
            id: deleteButton
            x: -118
            width: 32
            height: 32
            anchors.right: scaleMinus.left
            anchors.rightMargin: 20
            anchors.verticalCenterOffset: 0
            backgroundColor: Material.color(Material.red, Material.Shade400)
            anchors.verticalCenter: scalePlus.verticalCenter
            iconSource: "icons/remove.svg"
            visible: editorMode
            onClicked: root.parent.deleteControl(createIndex)
        }

        Rectangle {
            id: rectangle1
            color: "#00000000"
            border.color: Material.primary
            opacity: 0.3
            border.width: 2
            anchors.fill: parent
        }


        Gui_Profile_CircleButton {
            id: propButton
            x: 9
            y: 23
            width: 36
            height: width
            z: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: scalePlus.verticalCenter
            visible: editorMode
            backgroundColor: Material.primary
            opacity: root.width === maxControlWidth ? 0.3 : 1
            iconSource: "icons/profileEdit.svg"
            onClicked: paramItem.visible = true
        }

        Item {
            id: paramItem
            anchors.right: propButton.right
            anchors.rightMargin: 0
            visible: false
            anchors.left: deleteButton.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: scalePlus.top
            anchors.topMargin: 0

            Rectangle {
                id: background
                color: Material.primary
                radius: 2
                anchors.fill: parent
                layer.enabled: true
                layer.effect: DropShadow{
                    radius: 8
                    samples: 12
                    color: "black"
                    opacity: 0.5
                }
            }

            Column {
                id: column
                spacing: 2
                anchors.fill: parent

                Item {
                    id: propItem_1
                    width: parent.width
                    height: 30

                    ComboBox {
                        id: comboBox
                        x: 319
                        y: 13
                        width: 60
                        height: parent.height
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                        font.pointSize: 12
                        font.family: Style.robotoCondensed
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
                        font.pointSize: 12
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Item {
                    id: propItem_2
                    width: parent.width
                    height: 30

                    Label {
                        id: label1
                        text: qsTr("Инверсия")
                        font.weight: Font.Light
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10
                        anchors.left: parent.left
                        font.pointSize: 12
                    }

                    Switch {
                        id: delayButton1
                        height: parent.height
                        text: qsTr("")
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckedChanged: inverted = checked;
                    }
                }
            }

            Gui_Profile_Button {
                id: gui_Profile_Button
                x: 0
                y: 0
                width: 90
                height: 26
                text: "Закрыть"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: paramItem.visible = false
            }
        }
    }

}
