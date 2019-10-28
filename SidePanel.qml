import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."
import "qrc:/assets"
import "qrc:/Controls"

Item {
    id: root

    signal clicked(string page)

    CustomPane{
        id:background
        anchors.fill: parent
        Material.elevation:Units.dp(8)
        radius: 0
    }

    Label {
        id: appName
        text: Constlist_text.appName
        anchors.rightMargin: Units.dp(20)
        anchors.right: parent.right
        anchors.topMargin: Units.dp(20)
        anchors.leftMargin: Units.dp(20)
        anchors.top: parent.top
        fontSizeMode: Text.HorizontalFit
        font.pixelSize: Qt.application.font.pixelSize * 2.8
        font.family: Constlist_font.appName
        verticalAlignment: Text.AlignBottom
        anchors.left: parent.left
    }

    Label {
        id: appMotto
        text: Constlist_text.appMotto
        leftPadding: Units.dp(5)
        anchors.left: appName.left
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.top: appName.bottom
        verticalAlignment: Text.AlignTop
        font.pixelSize: Qt.application.font.pixelSize
        font.family: Constlist_font.appName
        fontSizeMode: Text.HorizontalFit
    }

    Column {
        id: column
        anchors.topMargin: Units.dp(60)
        spacing: Units.dp(10)
        anchors.top: appName.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(20)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(20)

        Sidepanel_Delegate {
            id: sidepanel_Delegate1
            text: ConstList_Text.sidepanel_item1
            icon:"qrc:/assets/icons/profile.svg"

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    parent.clickEffect(pressed);
                }
                onReleased: {
                    parent.clickEffect(pressed);

                }
                onClicked: root.clicked("profiles")
            }
        }

        Sidepanel_Delegate {
            id: sidepanel_Delegate2
            text: ConstList_Text.sidepanel_item2
            icon:"qrc:/assets/icons/connectedDevice.svg"

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    parent.clickEffect(pressed);
                }
                onReleased: {
                    parent.clickEffect(pressed);
                }
                onClicked: root.clicked("connectedDevices")
            }
        }

        Sidepanel_Delegate {
            id: sidepanel_Delegate3
            text: ConstList_Text.sidepanel_item3
            icon:"qrc:/assets/icons/settings.svg"

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    parent.clickEffect(pressed);
                }
                onReleased: {
                    parent.clickEffect(pressed);

                }
                onClicked: root.clicked("settings");
            }
        }

        Sidepanel_Delegate {
            id: sidepanel_Delegate4
            text: ConstList_Text.sidepanel_item4
            icon:"qrc:/assets/icons/about.svg"

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    parent.clickEffect(pressed);
                }
                onReleased: {
                    parent.clickEffect(pressed);

                }
                onClicked: root.clicked("about")
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
