import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root

    Rectangle {
        id: rectangle
        color: Material.background
        anchors.fill: parent
    }

    signal goEditClicked()

    Label {
        id: label
        height: Units.dp(26)
        text: ConstList_Text.empty_profile_text
        fontSizeMode: Text.VerticalFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Qt.application.font.pixelSize
    }

    RoundButton {
        id: roundButton
        height: Units.dp(44)
        font.pixelSize: Qt.application.font.pixelSize
        text: qsTr("Editor")
        rightPadding: Units.dp(24)
        leftPadding: Units.dp(24)
        Material.background: Material.accent
        anchors.horizontalCenter: label.horizontalCenter
        anchors.top: label.bottom
        anchors.topMargin: Units.dp(5)
        onClicked: root.goEditClicked()
    }
}
