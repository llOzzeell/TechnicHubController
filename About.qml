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
        anchors.rightMargin: Units.dp(20)
        anchors.leftMargin: Units.dp(20)
        anchors.right: parent.right
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        anchors.topMargin: Units.dp(20)
        anchors.top: parent.top
        fontSizeMode: Text.VerticalFit
        font.pixelSize: Qt.application.font.pixelSize * 3.2
        font.family: Constlist_font.appName
        verticalAlignment: Text.AlignBottom
    }

    Label {
        id: appVersion
        height: Units.dp(26)
        text: qsTr("Version: ") + "1.3"
        anchors.top: appName.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        font.pixelSize: Qt.application.font.pixelSize * 1.1
        font.family: Constlist_font.appName
        fontSizeMode: Text.VerticalFit
    }

    RoundButton {
        id: rateButton
        height: Units.dp(44)
        text: qsTr("Rate the app")
        rightPadding: Units.dp(24)
        leftPadding: Units.dp(24)
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
        height: Units.dp(44)
        text: qsTr("Forum")
        rightPadding: Units.dp(24)
        leftPadding: Units.dp(24)
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
