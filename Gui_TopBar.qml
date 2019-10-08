import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id:root
    width:parent.width
    height: 48
    property alias labelText: label.text

    signal addClick

    Rectangle {
        id: rectangle
        color: Material.accent
        anchors.fill: parent
    }

    ToolBar {
        id: toolBar
        height: root.height
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        Material.background: Material.accent
        RowLayout{
            Layout.fillWidth: true
            anchors.fill: parent
//            ToolButton {
//                id:back
//                width:24
//                height:width
//                icon.source: "icons/arrow_back.svg"
//                onClicked: stackView.pop()
            //            }
            Label {
                id: label
                text: ""
                font.weight: Font.Light
                leftPadding: 10
                font.pointSize: 16
                elide: Label.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: Material.foreground
            }
            ToolButton {
                id: add
                width: 24
                height: width
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                icon.source: "icons/plus.svg"
                onClicked: root.addClick()
            }

            ToolButton {
                id:more
                width:24
                height:width
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                icon.source: "icons/more.svg"
            }

        }
    }
}
