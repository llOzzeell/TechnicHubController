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

        Row {
            id: column1
            x: -27
            y: -48
            width: content.width
            height: 38
            anchors.bottom: parent.top
            anchors.bottomMargin: 10
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
                z: 0
                visible: editorMode
                backgroundColor: Material.primary
                iconSource: "icons/profileEdit.svg"
                onClicked: paramItem.visible = true
            }
        }

        Rectangle {
            id: rectangle1
            color: "#00000000"
            radius: 2
            border.color: Material.primary
            opacity: 0.5
            border.width: 2
            anchors.fill: parent
        }

        Item {
            id: paramItem
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: column1.right
            anchors.rightMargin: -6
            visible: false
            anchors.left: column1.left
            anchors.leftMargin: -6
            anchors.top: column1.top
            anchors.topMargin: 0

            Pane {
                id: background
                Material.background: Material.primary
                anchors.fill: parent
                Material.elevation: 2
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
                y: 0
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

}

/*##^##
Designer {
    D{i:4;anchors_width:90;anchors_x:0}D{i:23;anchors_width:90;anchors_x:0}
}
##^##*/
