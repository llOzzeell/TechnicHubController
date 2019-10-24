import QtQuick 2.0
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root

    readonly property int buttonUnitHeight: Units.dp(48)
    property bool paletteMode: false
    property bool glow:false

    property int currentProfileIndex:-1

    property string cid:""
    property int type:-1
    property bool inverted:false
    property var ports:[0,0,0,0]
    property int servoangle:0
    property int speedlimit:0
    property string chName: ""
    onChNameChanged: console.log("FROM PARENT name: " + chName)
    property string chAddress: ""
    onChAddressChanged: console.log("FROM PARENT address: " + chAddress)

    signal sizePlusClicked()
    signal sizeMinusClicked()
    signal propClicked(var link)

    property var requiredParameters:{"ports":false,"inversion":false,"servoangle":false, "speedlimit":false, "multichoose":false}

    property bool editorMode:root.parent.editorMode
    onEditorModeChanged: {
        if(!editorMode){
            save();
        }
    }

    function save(){
        var propObj = {
            cid:root.cid,
            type:type,
            "x": root.x,
            "y": root.y,
            width: root.width,
            height: root.height,
            inverted:root.inverted,
            servoangle:root.servoangle,
            speedlimit:root.speedlimit,
            port1:root.ports[0],
            port2:root.ports[1],
            port3:root.ports[2],
            port4:root.ports[3],
            chName:root.chName,
            chAddress:root.chAddress};
        cpp_Profiles.p_addOrUpdateControl(root.currentProfileIndex, root.cid, propObj);
    }

    ToolButton {
        id: sizeP
        width: Units.dp(48)
        height: Units.dp(48)
        anchors.bottom: parent.top
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        icon.source: "qrc:/assets/icons/plus.svg"
        onClicked: if(root.editorMode)root.sizePlusClicked()
        visible: editorMode
    }

    ToolButton {
        id: sizeM
        width: Units.dp(48)
        height: Units.dp(48)
        anchors.right: sizeP.left
        anchors.rightMargin: Units.dp(10)
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        icon.source: "qrc:/assets/icons/minus.svg"
        anchors.verticalCenter: sizeP.verticalCenter
        onClicked: if(root.editorMode)root.sizeMinusClicked()
        visible: editorMode
    }

    ToolButton {
        id: prop
        width: Units.dp(48)
        height: Units.dp(48)
        anchors.left: sizeP.right
        anchors.leftMargin: Units.dp(10)
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        icon.source: "qrc:/assets/icons/settings.svg"
        anchors.verticalCenter: sizeP.verticalCenter
        onClicked: if(root.editorMode)root.parent.showPropertyPage(root);
        visible: editorMode
    }

    MultiPointTouchArea {
        id:touchArea
        anchors.fill: parent
        maximumTouchPoints: 1
        touchPoints: [TouchPoint{id:tpoint}]
        z:3
        enabled: !root.paletteMode

        property var startPoint:{"x":0, "y":0}

        onPressed: {
            if(!paletteMode)moving(true, false, editorMode);
        }

        onTouchUpdated: {
            if(!paletteMode)moving(false, true, editorMode);
        }

        function moving(_pressed, _touchUpdated, _editorMode){
            if(_editorMode){
                if(_pressed){
                    touchArea.startPoint.x = tpoint.x;
                    touchArea.startPoint.y = tpoint.y;
                }
                if(_touchUpdated){
                    var delta = Qt.point(tpoint.x-startPoint.x, tpoint.y-startPoint.y)

                    var newX = root.x + delta.x

                    if(newX < 0) newX = 0;
                    if(newX > Screen.width - root.width) newX = Screen.width - root.width;

                    if(newX > 0 && newX < Screen.width - root.width){
                       root.x += delta.x;
                    }

                    var newY = (root.y + delta.y)

                    if(newY < root.buttonUnitHeight) newY = root.buttonUnitHeight;
                    if(newY > Screen.height - root.height) newY = Screen.height - root.height;

                    if(newY > root.buttonUnitHeight && newY < Screen.height - root.height){
                       root.y += delta.y;
                    }
                }
            }
        }
    }

    Rectangle {
        id: glowRectangle
        color: "#00000000"
        anchors.topMargin: -Units.dp(5)-sizeP.height
        anchors.rightMargin: -Units.dp(5)
        anchors.leftMargin: -Units.dp(5)
        anchors.bottomMargin: -Units.dp(5)
        anchors.fill: parent
        border.width: Units.dp(2)
        border.color: Material.accent
        radius: Units.dp(4)
        visible: root.glow
    }
}
