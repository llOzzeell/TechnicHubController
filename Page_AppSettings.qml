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
            console.log("LANG NAME: " + item);
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
                text: qsTr("Dark theme")
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
                text: qsTr("Control")
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
                text: qsTr("Tactile response")
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                font.weight: Font.Light
            }
        }

        Item {
            id: element4
            width: parent.width
            height: 48
            Label {
                id: label4
                text: qsTr("Regional settings")
                font.weight: Font.Normal
                anchors.leftMargin: 0
                font.pointSize: 16
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
                font.weight: Font.Light
                anchors.leftMargin: 0
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            ComboBox {
                id: comboBox
                x: 440
                y: 36
                width: 120
                height: 36
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

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
