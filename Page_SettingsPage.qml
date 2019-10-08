import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root

    Row {
        id: row
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.fill: parent

        Item {
            id: element
            height: 48
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Switch {
                id: element1
                text: qsTr("")
                checked: true
                checkable: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                onCheckedChanged: setTheme(checked)
            }

            Label {
                id: label
                text: qsTr("Темная тема")
                font.weight: Font.Light
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0
            }
        }
    }
}
