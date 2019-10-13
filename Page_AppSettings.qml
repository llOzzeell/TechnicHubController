import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root

    Component.onCompleted: {

        darkModeSwitch.checked = appSett.getDarkMode();
        tapTickSwitch.checked = appSett.getTapTick()
        window.tapTick = tapTickSwitch.checked;
    }

    property int changeColorDuration:200

    Rectangle {
        id: rectangle
        color: Material.background
        anchors.fill: parent

        Behavior on color{
            ColorAnimation {
                duration: changeColorDuration
            }
        }
    }

    Column{
        id: row
        anchors.top: gui_TopBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        anchors.bottomMargin: 20
        spacing: 0
        anchors.rightMargin: 20
        anchors.leftMargin: 20

        Item {
            id: element2
            width: parent.width
            height: 48

            Label {
                id: label1
                text: qsTr("Внешний вид")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.weight: Font.Normal
                anchors.leftMargin: 0
                font.pointSize: 16

                Behavior on color{
                    ColorAnimation {
                        duration: changeColorDuration
                    }
                }
            }
        }

        Item {
            id: element
            width: parent.width
            height: 36

            Switch {
                id: darkModeSwitch
                x: 560
                y: 0
                width: 40
                height: 48
                anchors.verticalCenter: parent.verticalCenter
                checked: true
                checkable: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                onCheckedChanged: window.setDarkTheme(checked)
            }

            Label {
                id: label
                text: qsTr("Темная тема")
                font.weight: Font.Light
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0

                Behavior on color{
                    ColorAnimation {
                        duration: changeColorDuration
                    }
                }
            }
        }

        Item {
            id: element3
            width: parent.width
            height: 48
            Label {
                id: label2
                text: qsTr("Управление")
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                font.weight: Font.Normal
            }
        }

        Item {
            id: element1
            width: parent.width
            height: 36
            Switch {
                id: tapTickSwitch
                x: 560
                y: 0
                width: 40
                height: 48
                checked: true
                checkable: true
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                onCheckedChanged: appSett.setTapTick(checked)
            }

            Label {
                id: label3
                text: qsTr("Тактильный отклик элементов управления")
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                font.weight: Font.Light
            }
        }

    }

    Gui_TopBar {
        id: gui_TopBar
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        labelText: "Настройки"
        backButtonVisible: true
        right1ButtonVisible: false
        right2ButtonVisible: false
    }

}
