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

    signal createNew(int type, string path, int width, int height)

    property var linkToPalette: controlsPalette

    property alias gridSnap: gridButton.gridSnap

    signal saveClicked()

    function showPropertyPage(link){
        controlPropertyList.show(link);
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

        property bool gridSnap: cpp_Settings.getGridSnap();

        onClicked: {
            gridSnap = !gridSnap;
            cpp_Settings.setGridSnap(gridSnap);
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
            if(controlsPalette.isVisible)controlsPalette.hide();
            root.saveClicked();
        }
    }

    ControlsPalette {
        id: controlsPalette
        width: root.width
        height: root.height
        z: 1
        anchors.fill: parent
        enabled: isVisible
        onComponentChoosed: root.createNew(type, path, width, height);
    }
}

