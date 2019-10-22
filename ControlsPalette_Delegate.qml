import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import ".."
import "qrc:/assets"

Item{
    id:control
    property alias icon: icon
    property alias label:label

    CustomPane{
        id: customPane
        Material.elevation: Units.dp(4)
        anchors.fill: parent
        ColorOverlay{
            id: colorOverlay
            anchors.fill: icon
            source:Image{
                width: Units.dp(32)
                height: Units.dp(32)
                anchors.left: control.left
                anchors.leftMargin: (control.height - height)/2
                anchors.verticalCenter: control.verticalCenter
                id:icon
            }
        }
        Label{
            id:label
            anchors.left: colorOverlay.right
            anchors.leftMargin: Units.dp(10)
            font.pixelSize: Qt.application.font.pixelSize
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }
    }
}
