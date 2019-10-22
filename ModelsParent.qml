import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root
    width: Units.dp(160)
    height : Units.dp(160)

    property int type:-1
    property bool inverted:false
    property var ports:[]
    property int servoangle:0
    property int speedlimit:0
    property bool vertical:false

    Row {
        id: row
        width: Units.dp(48) * 3 + Units.dp(10) * 2
        height: Units.dp(48)
        anchors.bottom: parent.top
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Units.dp(10)

        ToolButton {
            id: sizeP
            width: Units.dp(48)
            height: Units.dp(48)
            icon.width: Units.dp(24)
            icon.height: Units.dp(24)
            icon.source: "qrc:/assets/icons/plus.svg"
            anchors.verticalCenter: parent.verticalCenter
        }

        ToolButton {
            id: sizeM
            width: Units.dp(48)
            height: Units.dp(48)
            icon.width: Units.dp(24)
            icon.height: Units.dp(24)
            icon.source: "qrc:/assets/icons/minus.svg"
            anchors.verticalCenter: parent.verticalCenter
        }

        ToolButton {
            id: prop
            width: Units.dp(48)
            height: Units.dp(48)
            icon.width: Units.dp(24)
            icon.height: Units.dp(24)
            icon.source: "qrc:/assets/icons/settings.svg"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

}
