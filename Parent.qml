import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root
    width: Units.dp(160)
    height:Units.dp(160)
    readonly property int buttonUnitHeight: Units.dp(48)

    property int cid:-1
    property int type:-1
    property bool inverted:false
    property var ports:[]
    property int servoangle:0
    property int speedlimit:0
    property bool vertical:false

    signal sizePlusClicked
    signal sizeMinusClicked
    signal propClicked

    property bool editorMode:root.parent.editorMode

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
        onClicked: if(root.editorMode)root.propClicked()
        visible: editorMode
    }

}
