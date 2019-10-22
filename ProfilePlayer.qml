import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/assets"
import "qrc:/Controls"
import "qrc:/Controls/ModelsControls"

Item {
    id: root
    readonly property string title:""
    Component.onCompleted: { cpp_Android.setOrientationSensorLandscape(); toolBar.visible = false; cpp_Settings.setImmersiveMode(true); }
    Component.onDestruction: { cpp_Android.setOrientationPortrait(); toolBar.visible = true; cpp_Settings.setImmersiveMode(false); }

    property bool editorMode: false

    ControlsPalette {
        id: controlsPalette
        anchors.fill: parent
    }

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
        onClicked: {
            controlsPalette.show();
        }
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
        visible: !root.editorMode
        onClicked: {
            root.editorMode = true;
        }
    }

    RoundButton {
        id: saveButton
        width: Units.dp(48)
        height: Units.dp(48)
        Material.background: Material.accent
        icon.source: "qrc:/assets/icons/save.svg"
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.rightMargin: Units.dp(10)
        icon.width: Units.dp(24)
        anchors.right: parent.right
        icon.height: Units.dp(24)
        visible: !editButton.visible
        onClicked: {
            root.editorMode = false;
            if(controlsPalette.isVisible)controlsPalette.hide();
        }
    }

    ModelsParent {
        id: modelsParent
        width:Units.dp(160)
        height:Units.dp(160)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:2;anchors_x:87;anchors_y:141}D{i:3;anchors_x:87;anchors_y:141}
D{i:4;anchors_x:87;anchors_y:141}
}
##^##*/
