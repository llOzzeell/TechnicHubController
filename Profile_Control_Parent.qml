import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

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
        z: 2
        visible: editorMode
        anchors.fill: parent

        Gui_Profile_CircleButton {
            id: scalePlus
            y: 14
            width: 32
            height: 32
            backgroundColor: Material.primary
            anchors.left: scaleMinus.right
            anchors.leftMargin: 10
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
            width: 32
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
            width: 32
            height: 32
            anchors.right: parent.right
            anchors.rightMargin: 0
            backgroundColor: Material.color(Material.red, Material.Shade500)
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

        ComboBox {
            id: comboBox
            x: 30
            width: 60
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
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

        DelayButton {
            id: delayButton
            y: 70
            height: 32
            text: qsTr("Инверсия")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -6
            delay: 10
            font.bold: false
            topPadding: 8
            font.capitalization: Font.AllUppercase
            font.family: Style.robotoCondensed
            font.pointSize: 10
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            opacity: 1
            Material.background: Material.primary
            onCheckedChanged: inverted = checked;
//            Material.foreground: checked? Material.accent : textColor
//            property color textColor : Material.theme == Material.Dark ? Style.dark_foreground : Style.light_foreground

        }
    }

}
