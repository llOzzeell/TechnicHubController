import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/assets"
import "qrc:/Controls"

Item {
    id: root
    readonly property string title:""
    Component.onCompleted: { cpp_Android.setOrientationSensorLandscape(); toolBar.visible = false; cpp_Settings.setImmersiveMode(true); }
    Component.onDestruction: { cpp_Android.setOrientationPortrait(); toolBar.visible = true; cpp_Settings.setImmersiveMode(false); }

    RoundButton {
        id: addControlButton
        width: Units.dp(48)
        height: Units.dp(48)
        Material.background: Material.accent
        icon.source: "qrc:/assets/icons/add.svg"
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(10)
        Material.elevation: Units.dp(4)
        visible: !editButton.visible
    }

    RoundButton {
        id: editButton
        width: Units.dp(48)
        height: Units.dp(48)
        Material.background: Material.accent
        icon.source: "qrc:/assets/icons/tune.svg"
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(10)
        Material.elevation: Units.dp(4)
        visible:!addControlButton.visible
    }

    RoundButton {
        id: saveButton
        width: Units.dp(48)
        height: Units.dp(48)
        Material.background: Material.accent
        icon.source: "qrc:/assets/icons/tune.svg"
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.rightMargin: Units.dp(10)
        icon.width: Units.dp(24)
        anchors.right: parent.right
        icon.height: Units.dp(24)
        visible: !editButton.visible
    }

//    ControlsPalette {
//        id: controlsPalette
//        width: 350
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter
//    }

}
