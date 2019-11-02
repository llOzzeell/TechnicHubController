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
        hubInfoVisible.checked = cpp_Settings.getHubInfo();
        controlsLabelVisible.checked = cpp_Settings.getControlsLabelsVisible();
    }

    Flickable{
        id: flickable
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent
        anchors.margins: Units.dp(20)
        contentHeight: column.height + prop_lang.height*2

        Column {
            id: column
            anchors.right: parent.right
            anchors.left: parent.left
            spacing: Units.dp(10)

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
                id: prop_hubInfo
                width: parent.width
                height: Units.dp(40)
                text: ConstList_Text.settings_prop_battery
                isGroupTitle: false

                CustomSwitch {
                    id: hubInfoVisible
                    width: Units.dp(38)
                    height: Units.dp(48)
                    anchors.verticalCenter: parent.verticalCenter
                    checked: false
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    onCheckedChanged: cpp_Settings.setHubInfo(checked)
                }
            }

            Settings_Delegate {
                id: prop_controlsLabels
                width: parent.width
                height: Units.dp(40)
                text: ConstList_Text.settings_prop_labelVisible
                isGroupTitle: false

                CustomSwitch {
                    id: controlsLabelVisible
                    width: Units.dp(38)
                    height: Units.dp(48)
                    anchors.verticalCenter: parent.verticalCenter
                    checked: false
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    onCheckedChanged: cpp_Settings.setControlsLabelsVisible(checked)
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
}
