import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import ".."
import "qrc:/assets"
import "qrc:/Controls"
import "qrc:/ModelsControls"

Item {
    id:root
    width:parent.width
    onWidthChanged: canvas.requestPaint();
    height: parent.height
    onHeightChanged: canvas.requestPaint();

    property var linkToPalette: controlsPalette

    property int cellSize:canvas.cellSize/2

    signal gridSnapChanged(bool value)

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
            "x": canvas.startX + canvas.cellSize*2,
            "y": canvas.startY + canvas.cellSize*2,
            "width": width,
            "height": height,
            inverted:false,
            servoangle:90,
            speedlimit:100,
            ports:[0,0,0,0],
            chName:"",
            chAddress:"",
            z:0
        };
        var obj = component.createObject(parent, propObj);
        parent.saveState.connect(obj.save);
        gridSnapChanged.connect(obj.setGridSnap);
        parent.emptyLoaded = false;
    }

    function showPropertyPage(link){
        controlPropertyList.show(link);
    }

    Canvas{
        id:canvas
        anchors.fill: parent
        visible: gridButton.gridSnap

        property int cellSize: Units.dp(40)

        property int verticalLineCount: parseInt(root.height / cellSize);
        property int startY: parseInt((root.height - ((verticalLineCount-1) * cellSize))/2)
        property int horizontalLinecount: parseInt(root.width / cellSize);
        property int startX: parseInt((root.width - ((horizontalLinecount-1) * cellSize))/2)

        onPaint: {
            var ctx = canvas.getContext("2d");

            ctx.reset();

            var cellDevidedY = parseInt(root.height / (cellSize/2));
            var cellDevidedX = parseInt(root.width / (cellSize/2));

            for(var i = 0; i < cellDevidedY; i++){
                ctx.lineWidth = Units.dp(1);
                ctx.strokeStyle = Qt.darker(Material.primary, 1.5);
                ctx.beginPath();
                ctx.moveTo(0, parseInt(startY-cellSize/2) + (cellSize * i));
                ctx.lineTo(root.width, parseInt(startY-cellSize/2) + (cellSize * i));
                ctx.stroke();
            }

            for(i = 0; i < cellDevidedX; i++){
                ctx.lineWidth = Units.dp(1);
                ctx.strokeStyle = Qt.darker(Material.primary, 1.5);
                ctx.beginPath();
                ctx.moveTo(parseInt(startX-cellSize/2) + (cellSize * i), 0);
                ctx.lineTo(parseInt(startX-cellSize/2) + (cellSize * i), root.width);
                ctx.stroke();
            }

            for(i = 0; i < verticalLineCount; i++){
                ctx.lineWidth = Units.dp(1);
                ctx.strokeStyle = Qt.darker(Material.primary, 1);
                ctx.beginPath();
                ctx.moveTo(0, startY + (cellSize * i));
                ctx.lineTo(root.width, startY + (cellSize * i));
                ctx.stroke();
            }

            for(i = 0; i < horizontalLinecount; i++){
                ctx.lineWidth = Units.dp(1);
                ctx.strokeStyle = Qt.darker(Material.primary, 1);
                ctx.beginPath();
                ctx.moveTo(startX + (cellSize * i), 0);
                ctx.lineTo(startX + (cellSize * i), root.height);
                ctx.stroke();
            }
        }
    }

    Label {
        id: noConnectedOnlyEditorLabel
        height: Units.dp(26)
        text: qsTr("No hub is connected, only editor mode is available.")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: saveButton.verticalCenter
        fontSizeMode: Text.VerticalFit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Qt.application.font.pixelSize
        visible: !cpp_Controller.isNotEmpty();
        opacity: 0.6
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

    RoundButton {
        id: addButton
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
        Material.elevation: Units.dp(1)
        visible: !editButton.visible && !controlsPalette.isVisible
        onClicked: {
            controlsPalette.show();
        }
    }

    RoundButton {
        id: gridButton
        height: Units.dp(48)
        width: Units.dp(48)
        anchors.left: addButton.right
        anchors.leftMargin: Units.dp(10)
        icon.source: gridSnap ? "qrc:/assets/icons/gridOFF.svg" : "qrc:/assets/icons/gridON.svg"
        Material.background: Material.accent
        anchors.topMargin: Units.dp(10)
        anchors.top: parent.top
        icon.height: Units.dp(24)
        icon.width: Units.dp(24)
        font.pixelSize: Qt.application.font.pixelSize

        property bool gridSnap: true

        onClicked: {
            gridSnap = !gridSnap;
            root.gridSnapChanged(gridSnap);
        }
    }

    RoundButton {
        id: saveButton
        height: Units.dp(48)
        width: Units.dp(48)
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
        font.pixelSize: Qt.application.font.pixelSize
        onClicked: {

        }
    }

    ControlsPalette {
        id: controlsPalette
        width: root.width
        height: root.height
        z: 5
        anchors.fill: parent
        enabled: isVisible
        onComponentChoosed: createNewControl(type, path, width, height);
    }
}

