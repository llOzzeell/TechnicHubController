import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root
    readonly property string title: ConstList_Text.page_about

    Label {
        id: appName
        height: Units.dp(64)
        text: Constlist_text.appName
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Units.dp(20)
        anchors.top: parent.top
        fontSizeMode: Text.VerticalFit
        font.pixelSize: Qt.application.font.pixelSize * 2.8
        font.family: Constlist_font.appName
        verticalAlignment: Text.AlignVCenter
    }

    Label {
        id: appVersion
        height: Units.dp(26)
        text: qsTr("Version: 1.2.1")
        anchors.top: appName.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Qt.application.font.pixelSize
        font.family: Constlist_font.appName
        fontSizeMode: Text.VerticalFit
    }

    RoundButton {
        id: rateButton
        width: root.width/1.5
        height: Units.dp(44)
        text: qsTr("Rate the app")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Qt.application.font.pixelSize
        Material.background: Material.accent
        onClicked: {
            cpp_Android.rateApp();
        }
    }

    RoundButton {
        id: linkToForum
        width: root.width/2.2
        height: Units.dp(44)
        text: qsTr("Forum")
        anchors.topMargin: Units.dp(10)
        anchors.top: rateButton.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Qt.application.font.pixelSize
        Material.background: Material.accent
        onClicked: {
            cpp_Android.forumLink();
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
