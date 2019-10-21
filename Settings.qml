import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."
import "qrc:/Controls"

Item {
    id:root
    readonly property string title: ConstList_Text.page_settings

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
                id: switch1
                width: Units.dp(38)
                height: Units.dp(48)
                checked: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: darkTheme(checked)
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
                id: switch2
                width: Units.dp(38)
                height: Units.dp(48)
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                onCheckedChanged: console.log(checked)
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

            ComboBox {
                id: comboBox
                x: 66
                width: 534
                height: 314
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
            }
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
