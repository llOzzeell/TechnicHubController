import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."
import "qrc:/assets"
import "qrc:/Controls"

Item {
    id: root

    signal clicked(string page)

    Image {
        id: appIco
        width: Units.dp(56)
        height: width
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(20)
        anchors.top: parent.top
        anchors.topMargin: Units.dp(20)
        source: "qrc:/assets/icons/sidePanelIco.png"
    }

    Label {
        id: appName
        text: Constlist_text.appName
        fontSizeMode: Text.HorizontalFit
        font.pixelSize: Qt.application.font.pixelSize * 2.5
        font.family: Constlist_font.appName
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(20)
        anchors.left: appIco.right
        anchors.leftMargin: Units.dp(5)
        anchors.verticalCenter: appIco.verticalCenter
    }

    Column {
        id: column
        spacing: Units.dp(10)
        anchors.top: appIco.bottom
        anchors.topMargin: Units.dp(60)
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
