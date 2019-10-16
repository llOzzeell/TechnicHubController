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

    property alias backButtonVisible: back.visible

    property alias right1ButtonVisible: add.visible
    property alias right1ButtonIconSource: add.icon.source
    signal right1ButtonClicked

    property alias right2ButtonVisible: more.visible
    property alias right2ButtonIconSource: more.icon.source
    signal right2ButtonClicked

    property alias labelVisible: label.visible

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
            spacing: 0
            Layout.fillWidth: true
            anchors.fill: parent

            ToolButton {
                id:back
                width:24
                height:width
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                icon.source: "icons/arrow_back.svg"
                onClicked: {if(visible)stackView.pop();}
            }

            Label {
                id: label
                text: ""
                font.family: "Roboto"
                leftPadding: 10
                font.pointSize: 20
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
                onClicked: {if(visible)root.right1ButtonClicked()}
            }

            ToolButton {
                id:more
                width:24
                height:width
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                icon.source: "icons/more.svg"
                onClicked: {if(visible)root.right2ButtonClicked()}
            }

        }
    }
}
