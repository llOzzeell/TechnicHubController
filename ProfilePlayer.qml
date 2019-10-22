import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/assets"
import "qrc:/Controls"
import "qrc:/ModelsControls"

Item {
    id: root
    readonly property string title:""
    Component.onCompleted: { /*cpp_Android.setOrientationSensorLandscape();*/ toolBar.visible = false; cpp_Settings.setImmersiveMode(true); }
    Component.onDestruction: { /*cpp_Android.setOrientationPortrait();*/ toolBar.visible = true; cpp_Settings.setImmersiveMode(false); }

    property bool editorMode: false

    function generateCID(){
        return (+new Date).toString(16);
    }

    function loadProfile(index){

    }

    function createNewControl(type, path, width, height){

        var component = Qt.createComponent(path)

        var propObj = {cid: root.generateCID(), type:type, "x": root.width/2-width/2, "y": root.height/2-height/2, width: width, height: height, inverted:false, servoangle:90, speedlimit:100, vertical:false};

        component.createObject(root, propObj);
    }

    ControlsPalette {
        id: controlsPalette
        z: 1
        anchors.fill: parent
        enabled: isVisible
        onComponentChoosed: createNewControl(type, path, width, height);
    }

    RoundButton {
        id: addControlButton
        width: Units.dp(48)
        height: Units.dp(48)
        z: 2
        Material.background: Material.accent
        icon.source: "qrc:/assets/icons/add.svg"
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(10)
        Material.elevation: Units.dp(1)
        visible: !editButton.visible && !controlsPalette.isVisible
        onClicked: {
            controlsPalette.show();
        }
    }

    RoundButton {
        id: editButton
        width: Units.dp(48)
        height: Units.dp(48)
        z: 2
        Material.background: Material.accent
        icon.source: "qrc:/assets/icons/tune.svg"
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(10)
        Material.elevation: Units.dp(1)
        visible: !root.editorMode
        onClicked: {
            root.editorMode = true;
        }
    }

    RoundButton {
        id: saveButton
        width: Units.dp(48)
        height: Units.dp(48)
        z: 2
        Material.background: Material.accent
        icon.source: "qrc:/assets/icons/save.svg"
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.rightMargin: Units.dp(10)
        icon.width: Units.dp(24)
        anchors.right: parent.right
        icon.height: Units.dp(24)
        Material.elevation: Units.dp(1)
        visible: !editButton.visible
        onClicked: {
            root.editorMode = false;
            if(controlsPalette.isVisible)controlsPalette.hide();
        }
    }
}
