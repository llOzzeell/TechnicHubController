import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."
import "qrc:/Controls"

Item {
    id:root
    readonly property string title: ConstList_Text.page_settings

    Component.onCompleted: {
        darkmode.checked = cpp_Settings.getDarkMode();
        taptick.checked = cpp_Settings.getTapTick();
        comboBox.currentIndex = cpp_Settings.getLanguage();
    }

    Column {
        id: column
        spacing: Units.dp(5)
        anchors.rightMargin: Units.dp(20)
        anchors.leftMargin: Units.dp(20)
        anchors.topMargin: Units.dp(20)
        anchors.fill: parent

        Settings_Delegate {
            id: group_gui
            width: parent.width
            height: Units.dp(40)
            text: ConstList_Text.settings_group_gui
            isGroupTitle: true
        }

        Settings_Delegate {
            id: prop_dark
            width: parent.width
            height: Units.dp(40)
            text: ConstList_Text.settings_prop_dark
            isGroupTitle: false

            CustomSwitch {
                id: darkmode
                width: Units.dp(38)
                height: Units.dp(48)
                checked: false
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: cpp_Settings.setDarkMode(checked)
            }
        }

        Settings_Delegate {
            id: group_control
            width: parent.width
            height: Units.dp(40)
            text: ConstList_Text.settings_group_control
            isGroupTitle: true
        }

        Settings_Delegate {
            id: prop_tactile
            width: parent.width
            height: Units.dp(40)
            text: ConstList_Text.settings_prop_tactile
            isGroupTitle: false

            CustomSwitch {
                id: taptick
                width: Units.dp(38)
                height: Units.dp(48)
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                onCheckedChanged:{ cpp_Settings.setTapTick(checked)}
            }
        }

        Settings_Delegate {
            id: group_regional
            width: parent.width
            height: Units.dp(40)
            text: ConstList_Text.settings_group_regional
            isGroupTitle: true
        }

        Settings_Delegate {
            id: prop_lang
            width: parent.width
            height: Units.dp(40)
            text: ConstList_Text.settings_prop_lang
            isGroupTitle: false

            CustomComboBox {
                id: comboBox
                width: Units.dp(120)
                height: Units.dp(40)
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                model: ListModel{
                    ListElement{
                        name: "English"
                    }
                    ListElement{
                        name: "Русский"
                    }
                }
                onActivated: {
                   cpp_Settings.setLanguage(currentIndex);
                }
            }
        }
    }
}
