import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/assets"
import "qrc:/Controls"
import "qrc:/ModelsControls"

Item {
    id: root
    readonly property string title:"*"

    Component.onCompleted: {
        cpp_Android.setOrientationSensorLandscape();
        cpp_Settings.setImmersiveMode(true);
    }

    Component.onDestruction: {
        root.saveState();
        cpp_Settings.setImmersiveMode(false);
        cpp_Android.setOrientationUser();
    }

    property bool taptic: cpp_Settings.getTapTick();

    Connections{
        target:cpp_Settings
        onTaptickChanged:{
            root.taptic = value;
        }
    }

    property int currentProfileIndex:-1
    property bool editorMode: false
    property bool emptyLoaded:false

    signal saveState()

    function generateCID(){
        var cid = (+new Date).toString(16);
        return cid;
    }

    function loadProfile(index){
        root.currentProfileIndex = index;
        var count = cpp_Profiles.p_getControlsCount(index);
        if(count <= 0) root.emptyLoaded = true;
        for(var i = 0; i < count; i++){
            var control = cpp_Profiles.p_getControl(index, i);
            var component = Qt.createComponent(controlsPalette.getPathByType(control.type))
            var propObj = {
                currentProfileIndex: index,
                cid: control.cid,
                type:control.type,
                "x": control.x,
                "y": control.y,
                "width": control.width,
                "height": control.height,
                inverted:control.inverted,
                servoangle:control.servoangle,
                speedlimit:control.speedlimit,
                ports:[control.port1,control.port2,control.port3,control.port4],
                chName:control.chName,
                chAddress:control.chAddress
            };
            var obj = component.createObject(root, propObj);
            saveState.connect(obj.save);
        }
    }

    function createNewControl(type, path, width, height){
        var component = Qt.createComponent(path)
        var propObj = {
            currentProfileIndex: root.currentProfileIndex,
            cid: root.generateCID(),
            type:type,
            "x": root.width/2-width/2,
            "y": root.height/2-height/2,
            "width": width,
            "height": height,
            inverted:false,
            servoangle:90,
            speedlimit:100,
            ports:[0,0,0,0],
            chName:"",
            chAddress:""
        };
        var obj = component.createObject(root, propObj);
        saveState.connect(obj.save);
        root.emptyLoaded = false;
    }

    function showPropertyPage(link){
        controlPropertyList.show(link);
    }

    Label {
        id: noConnectedOnlyEditorLabel
        height: Units.dp(26)
        text: qsTr("No hub is connected, only editor mode is available.")
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(150)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(150)
        anchors.verticalCenter: lostConnectionLabel.verticalCenter
        fontSizeMode: Text.VerticalFit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Qt.application.font.pixelSize
        visible: !cpp_Controller.isNotEmpty();
        opacity: 0.6
        z: 10
    }

    Connections{
        target:cpp_Connector
        onQmlDisconnected:{
            lostConnectionLabel.visible = true;
        }
    }

    Label {
        id: lostConnectionLabel
        height: Units.dp(26)
        text: qsTr("Lost connection with one of the hubs. Reconnect to continue.")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(150)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(150)
        fontSizeMode: Text.VerticalFit
        anchors.verticalCenter: saveButton.verticalCenter
        font.pixelSize: Qt.application.font.pixelSize
        visible: false
        opacity: 0.6
        z: 10
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

    ToolButton {
        id: editButton
        width: Units.dp(48)
        height: Units.dp(48)
        anchors.top: parent.top
        anchors.topMargin: Units.dp(10)
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(10)
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        icon.source: "qrc:/assets/icons/tune.svg"
        z: 2
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
            root.saveState();
            if(cpp_Controller.isNotEmpty()){
                root.editorMode = false;
                if(controlsPalette.isVisible)controlsPalette.hide();
            }
            else{
                stackView.pop();
            }
        }
    }

    ControlsPalette {
        id: controlsPalette
        width: root.width
        height: root.height
        z: 11
        anchors.fill: parent
        enabled: isVisible
        onComponentChoosed: createNewControl(type, path, width, height);
    }

    EmptyProfile {
        id: emptyProfile
        anchors.fill: parent
        visible: (!root.editorMode && root.emptyLoaded)
        onGoEditClicked: root.editorMode = true;
    }

    CustomDrawer {
        id: controlPropertyList
        width: root.width * 0.42
        height: root.height
        interactive: false
        Material.elevation: Units.dp(8)
        edge: Qt.RightEdge

        Behavior on position {
            NumberAnimation{ duration: 200 }
        }

        function show(link){
            visible = true;
            position = 1;
            propPage.linkToControl = link;
        }

        function collapse(){
            position = 0;
            visible = false;
            propPage.linkToControl = undefined;
        }

        ControlsPropertyPage{
            id:propPage
            anchors.fill: parent
            onHide: controlPropertyList.collapse();
        }
    }

    BatteryWidget {
        id: batteryWidget
        height: Units.dp(40)
        anchors.rightMargin: Units.dp(20)
        anchors.verticalCenter: editButton.verticalCenter
        anchors.right: editButton.left
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(20)
        opacity: 0.6
        z:1
    }
}

