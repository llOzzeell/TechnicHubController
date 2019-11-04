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

    property var gridParamArray:{"gridSnap": vEditor.gridSnap, "cellSize":canvas.cellSize, "startX":canvas.startX, "startY":canvas.startY}

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

    function loadProfile(index){
        root.currentProfileIndex = index;
        var count = cpp_Profiles.p_getControlsCount(index);
        if(count <= 0) root.emptyLoaded = true;
        for(var i = 0; i < count; i++){
            var control = cpp_Profiles.p_getControl(index, i);
            var component = Qt.createComponent(vEditor.linkToPalette.getPathByType(control.type))
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
                chAddress:control.chAddress,
                name:control.name,
                z:0,
                workAsServo:control.workAsServo,
                scaleStep:control.scaleStep
            };
            var obj = component.createObject(root, propObj);
            saveState.connect(obj.save);
        }
    }

    function showProperty(element){
        vEditor.showPropertyPage(element);
    }

    function generateCID(){
        var cid = (+new Date).toString(16);
        return cid;
    }

    function createNewControl(type, path, width, height){
        var component = Qt.createComponent(path)
        var propObj = {
            currentProfileIndex: root.currentProfileIndex,
            cid: root.generateCID(),
            type:type,
            "x": gridParamArray.startX + gridParamArray.cellSize*4,
            "y": gridParamArray.startY + gridParamArray.cellSize*4,
            "width": width,
            "height": height,
            inverted:false,
            servoangle:90,
            speedlimit:100,
            ports:[0,0,0,0],
            chName:"",
            chAddress:"",
            z:0,
            workAsServo:false,
            scaleStep:0
        };
        var obj = component.createObject(root, propObj);
        saveState.connect(obj.save);
        emptyLoaded = false;
    }

    Connections{
        target:cpp_Connector
        onQmlDisconnected:{
            lostConnectionLabel.visible = true;
        }
    }

    Canvas{
        id:canvas
        anchors.fill: parent
        visible: editorMode && vEditor.gridSnap

        property int cellSize: Units.dp(20)

        property int verticalLineCount: parseInt(root.height / cellSize);
        property int startY: parseInt( (root.height - (verticalLineCount-1) * cellSize)/2 )
        property int horizontalLineCount: parseInt(root.width / cellSize);
        property int startX: parseInt( (root.width - (horizontalLineCount-1) * cellSize)/2 )

        onPaint: {
            var ctx = canvas.getContext("2d");

            ctx.reset();

            var lineDarker = cpp_Settings.getDarkMode() ? 1.5 : 2
            var lineLighter = cpp_Settings.getDarkMode() ? 1 : 1.5

            for(var i = 0; i < verticalLineCount; i++){
                ctx.lineWidth = Units.dp(1);

                ctx.strokeStyle = i % 2 == 0 ? Qt.darker(Material.primary, lineLighter) : Qt.darker(Material.primary, lineDarker)
                ctx.beginPath();
                ctx.moveTo(0, startY + (cellSize * i));
                ctx.lineTo(root.width, startY + (cellSize * i));
                ctx.stroke();
            }

            for(i = 0; i < horizontalLineCount; i++){
                ctx.lineWidth = Units.dp(1);
                ctx.strokeStyle = i % 2 == 0 ? Qt.darker(Material.primary, lineLighter) : Qt.darker(Material.primary, lineDarker)
                ctx.beginPath();
                ctx.moveTo(startX + (cellSize * i), 0);
                ctx.lineTo(startX + (cellSize * i), root.height);
                ctx.stroke();
            }
        }
    }

    Label {
        id: lostConnectionLabel
        height: Units.dp(26)
        text: qsTr("Lost connection with one of the hubs. Reconnect to continue.")
        z: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: editButton.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.VerticalFit
        font.pixelSize: Qt.application.font.pixelSize
        visible: false
        opacity: 0.6
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

    EmptyProfile {
        id: emptyProfile
        z: 2
        anchors.fill: parent
        visible: (!root.editorMode && root.emptyLoaded)
        onGoEditClicked: root.editorMode = true;
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

    VisualEditor{
        id:vEditor
        z: 3
        anchors.fill: parent
        visible: editorMode
        onCreateNew:{
            root.createNewControl(type, path, width, height);
        }
        onSaveClicked: {
            root.saveState();
            if(cpp_Controller.isNotEmpty()){
                root.editorMode = false;
            }
            else{
                stackView.pop();
            }
        }
    }

}

