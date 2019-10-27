import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root
    readonly property string title: ConstList_Text.page_about

    Label {
        id: appName
        text: Constlist_text.appName
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Units.dp(20)
        anchors.top: parent.top
        fontSizeMode: Text.HorizontalFit
        font.pixelSize: Qt.application.font.pixelSize * 4
        font.family: Constlist_font.appName
        verticalAlignment: Text.AlignBottom
    }

    Label {
        id: appMotto
        text: qsTr("Version: 1.2")
        anchors.right: appName.right
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.top: appName.bottom
        verticalAlignment: Text.AlignTop
        font.pixelSize: Qt.application.font.pixelSize * 1.2
        font.family: Constlist_font.appName
        fontSizeMode: Text.HorizontalFit
    }

    RoundButton {
        id: rateButton
        width: root.width/1.5
        height: Units.dp(44)
        text: qsTr("Rate the app for support")
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
        text: qsTr("Link to the forum")
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
