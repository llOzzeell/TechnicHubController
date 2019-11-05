import QtQuick 2.0
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import ".."

Item {
    id:root

    readonly property int buttonUnitHeight: Units.dp(48)
    property bool paletteMode: false
    property bool glow:false
    property int rotatePropItem:0

    property int scaleStep:0
    onScaleStepChanged: console.log("SCALESTEP: " + scaleStep)

    property int currentProfileIndex:-1

    property string cid:""

    property int type:-1

    property bool inverted:false

    property var ports:[0,0,0,0]

    property int servoangle:0

    property int speedlimit:0

    property string chName: ""

    property string chAddress: ""
    
    property string name: ""

    property bool workAsServo: false

    property var gridParamArray: parent.gridParamArray

    signal sizePlusClicked()
    signal sizeMinusClicked()
    signal propClicked(var link)

    signal touchPressed(int x, int y);
    signal touchReleased(int x, int y);
    signal touchUpdated(int x, int y)

    property var requiredParameters:{"ports":false,"inversion":false,"servoangle":false, "speedlimit":false, "multichoose":false, "workAsServo":false}

    property bool editorMode:root.parent.editorMode
    onEditorModeChanged: {
        checkReady();
        if(!editorMode){
            save();
        }
    }

    function save(){
        var propObj = {
            cid: cid,
            type: type,
            "x": x,
            "y": y,
            width: width,
            height: height,
            inverted: inverted,
            servoangle: servoangle,
            speedlimit: speedlimit,
            port1: ports[0],
            port2: ports[1],
            port3: ports[2],
            port4: ports[3],
            chName: chName,
            chAddress: chAddress,
            name: name,
            workAsServo: workAsServo,
            scaleStep: scaleStep};
        cpp_Profiles.p_addOrUpdateControl(currentProfileIndex, cid, propObj);
    }

    function remove(){
        cpp_Profiles.p_deleteControl(currentProfileIndex, cid);
        root.destroy();
    }

    function checkReady(){
        notReadyItem.checkVisible()
    }

    MultiPointTouchArea {
        id:touchArea
        anchors.fill: parent
        maximumTouchPoints: 1
        touchPoints: [TouchPoint{id:tpoint}]
        z:1
        enabled: !root.paletteMode

        property var startPoint:{"x":0, "y":0}

        onPressed: {
            if(!paletteMode)moving(true, false, editorMode);
            if(!editorMode && !paletteMode)root.touchPressed(tpoint.x, tpoint.y);
        }

        onReleased: {
            if(!editorMode && !paletteMode)root.touchReleased(tpoint.x, tpoint.y);
        }

        onTouchUpdated: {
            if(!paletteMode)moving(false, true, editorMode);
            if(!editorMode && !paletteMode)root.touchUpdated(tpoint.x, tpoint.y);
        }

        function moving(_pressed, _touchUpdated, _editorMode){
            if(_editorMode){
                if(_pressed){
                    touchArea.startPoint.x = tpoint.x;
                    touchArea.startPoint.y = tpoint.y;
                }
                if(_touchUpdated){
                    if(gridParamArray.gridSnap){
                        withBinding();
                    }
                    else{
                        absolute();
                    }
                }
            }
        }

        function absolute(){
            var delta = Qt.point(tpoint.x-startPoint.x, tpoint.y-startPoint.y)

            var newX = root.x + delta.x

            if(newX < 0) newX = 0;
            if(newX > Screen.width - root.width) newX = Screen.width - root.width;

            if(newX > 0 && newX < Screen.width - root.width){
                root.x += delta.x;
            }

            var newY = (root.y + delta.y)

            if(newY < controlName.topMarginValue) newY = controlName.topMarginValue;
            if(newY > Screen.height - root.height) newY = Screen.height - root.height;

            if(newY > controlName.topMarginValue && newY < Screen.height - root.height){
                root.y += delta.y;
            }
        }

        function withBinding(){

            if(!isBounded()){
                snapToGrid();
            }

            moveX(); moveY();
        }

        function moveX(){
            if(Math.abs(tpoint.x-touchArea.startPoint.x) > gridParamArray.cellSize){

                var moveToRight = (tpoint.x-touchArea.startPoint.x > 0);

                if(moveToRight){
                    if((root.x + gridParamArray.cellSize + root.width) > root.parent.width)return;
                }
                else{
                    if((root.x - gridParamArray.cellSize) < 0)return;
                }

                root.x += moveToRight ? gridParamArray.cellSize : -gridParamArray.cellSize;
            }
        }

        function moveY(){
            if(Math.abs(tpoint.y-touchArea.startPoint.y) > gridParamArray.cellSize){

                var moveToBottom = (tpoint.y-touchArea.startPoint.y > 0);

                if(moveToBottom){
                    if((root.y + gridParamArray.cellSize + root.height) > root.parent.height)return;
                }
                else{
                    if((root.y - gridParamArray.cellSize) < 0)return;
                }

                root.y += moveToBottom ? gridParamArray.cellSize : -gridParamArray.cellSize;
            }
        }

        function snapToGrid(){
            root.x -= (root.x - gridParamArray.startX) % gridParamArray.cellSize;
            root.y -= (root.y - gridParamArray.startY) % gridParamArray.cellSize;
        }

        function isBounded(){

            var xshift = ((root.x - gridParamArray.startX) % gridParamArray.cellSize) == 0;
            var yshift = ((root.y - gridParamArray.startY) % gridParamArray.cellSize) == 0;

            return xshift && yshift;
        }
    }

    Rectangle {
        id: editorModeFade
        color: Material.background
        radius: Math.min(width, height)/2
        visible: editorMode
        z: 2
        opacity: 0.8
        anchors.fill: parent
    }

    Rectangle {
        id: glowRectangle
        color: "#00000000"
        anchors.fill: parent
        border.width: Units.dp(1)
        border.color: Material.accent
        radius: Math.min(editorModeFade.width, editorModeFade.height)/2
        z: 2
        visible: root.glow
    }

    Rectangle {
        id: positionFrame
        color: "#00000000"
        z: 2
        visible: editorMode && gridParamArray.gridSnap
        border.width: Units.dp(1)
        border.color: Material.accent
        anchors.fill: parent
    }

    Item {
        id: propButtonsItem
        visible: editorMode
        anchors.fill: parent
        z: 2

        Item {
            id: btnItem
            width: sizeP.width*3 + sizeM.anchors.rightMargin * 2
            height: sizeP.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            rotation:root.rotatePropItem

            ToolButton {
                id: sizeP
                width: Units.dp(32)
                height: Units.dp(32)
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                icon.width: Units.dp(24)
                icon.height: Units.dp(24)
                icon.source: "qrc:/assets/icons/plus.svg"
                onClicked: if(root.editorMode)root.sizePlusClicked()
            }

            ToolButton {
                id: sizeM
                width: Units.dp(32)
                height: Units.dp(32)
                anchors.right: sizeP.left
                anchors.rightMargin: Units.dp(20)
                icon.width: Units.dp(24)
                icon.height: Units.dp(24)
                icon.source: "qrc:/assets/icons/minus.svg"
                anchors.verticalCenter: sizeP.verticalCenter
                onClicked: if(root.editorMode)root.sizeMinusClicked()
            }

            ToolButton {
                id: prop
                width: Units.dp(32)
                height: Units.dp(32)
                anchors.left: sizeP.right
                anchors.leftMargin: Units.dp(20)
                icon.width: Units.dp(24)
                icon.height: Units.dp(24)
                icon.source: "qrc:/assets/icons/settings.svg"
                anchors.verticalCenter: sizeP.verticalCenter
                onClicked: if(root.editorMode)root.parent.showProperty(root);
            }
        }
    }

    Item {
        id: notReadyItem
        anchors.fill: parent
        z: 2
        visible: false

        Component.onCompleted: checkVisible();

        function checkVisible(){

            if(paletteMode) { notReadyItem.visible = false; return; }

            if(!root.editorMode && root.chName === "" && root.chAddress === ""){

                if(type == 6){notReadyItem.visible = true; return; }

                if(ports[0] === 0 && ports[1] === 0 && ports[2] === 0 && ports[3] === 0 ) notReadyItem.visible = true;
                else notReadyItem.visible = false;
            }
            else if(type == 6){notReadyItem.visible = false; return; }
        }

        Rectangle {
            color: Material.background
            radius: Math.min(width, height)/2
            opacity: 0.8
            anchors.fill: parent
        }

        MouseArea {
            id: mouseArea
            z: 2
            anchors.fill: parent
            onClicked: root.parent.showProperty(root);
        }

        Image {
            id: image
            width: Units.dp(32)
            height: Units.dp(32)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/assets/icons/notReady.svg"
            fillMode: Image.PreserveAspectFit

            ColorOverlay{
                source:image
                anchors.fill:image
                color:ConstList_Color.delete_Color
            }
        }
    }

    RoundButton {
        id: controlName
        height: Units.dp(Qt.application.font.pixelSize/2)
        opacity: 0.5
        enabled: true
        font.pixelSize: Qt.application.font.pixelSize
        visible: !paletteMode && valueFromSetting && root.type != 6
        anchors.topMargin: -topMarginValue
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: nameLabel.width + Units.dp(24)

        property int topMarginValue: visible ? (controlName.height + Units.dp(5)) : 0

        property bool valueFromSetting: cpp_Settings.getControlsLabelsVisible();

        TextInput {
            id: nameLabel
            text: root.name;
            color: Material.foreground
            z: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            font.weight: Font.Normal
            font.family: "Roboto"
            font.pixelSize: Qt.application.font.pixelSize
            verticalAlignment: Text.AlignVCenter
            maximumLength: 26
            enabled: editorMode
            property string previousName: ""
            readonly property string empty: qsTr("No name")

            onFocusChanged: {
                if(focus) previousName = text;
                if(!focus && text.length <= 0){
                    if(previousName.length > 0) { text = previousName; }
                }
            }
            onAccepted: {
                if(text.length > 0){
                    root.name = text;
                }
                else {
                    if(previousName.length > 0)text = previousName;
                }
                nameLabel.focus = false;
            }
        }

        Connections{
            target:cpp_Settings
            onControlsLabelVisibleChanged:{
                controlName.valueFromSetting = value;
            }
        }
    }

}

