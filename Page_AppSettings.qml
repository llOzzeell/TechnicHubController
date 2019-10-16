import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root

    Component.onCompleted: {

        darkModeSwitch.checked = appSett.getDarkMode();
        tapTickSwitch.checked = appSett.getTapTick()
        window.tapTick = tapTickSwitch.checked;
        root.updateModel();
        comboBox.currentIndex = appSett.getCurrentLanguageInt();
        console.log(appSett.getCurrentLanguageInt())
    }

    function updateModel(){
        var list = appSett.getNames();
        list.forEach(function(item){
            nameModel.append({"name":item});
        })
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
                text: qsTr("View")
                font.weight: Font.Medium
                font.family: "Roboto"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pointSize: 20

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
                text: qsTr("Dark theme")
                font.pointSize: 18
                font.family: "Roboto"
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
                text: qsTr("Control")
                font.family: "Roboto"
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pointSize: 20
                anchors.verticalCenter: parent.verticalCenter
                font.weight: Font.Medium
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
                text: qsTr("Tactile response")
                font.family: "Roboto"
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pointSize: 18
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item {
            id: element4
            width: parent.width
            height: 48

            Label {
                id: label4
                text: qsTr("Regional settings")
                font.family: "Roboto"
                font.weight: Font.Medium
                anchors.leftMargin: 0
                font.pointSize: 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }
        }

        Item {
            id: element5
            width: parent.width
            height: 36

            Label {
                id: label5
                text: qsTr("Language")
                font.family: "Roboto"
                anchors.leftMargin: 0
                font.pointSize: 18
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            ComboBox {
                id: comboBox
                x: 449
                y: 36
                width: 150
                height: 48
                font.family: "Roboto"
                font.pointSize: 18
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                model:nameModel
                onActivated:{
                    appSett.setLanguage(currentIndex);
                }
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
        labelText: qsTr("Settings")
        backButtonVisible: true
        right1ButtonVisible: false
        right2ButtonVisible: false
    }

    ListModel{
        id:nameModel
    }
}
