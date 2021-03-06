import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "qrc:/assets"
import ".."

Item {
    id:root
    implicitHeight: Units.dp(60)
    height: Units.dp(60)
    width: parent.width

    CustomPane{
        id:background
        anchors.fill: parent
        Material.background: Material.primary
        Material.elevation:Units.dp(2)
    }

    Image {
        id: image
        width: Units.dp(24)
        height: Units.dp(24)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(10)
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/assets/icons/foundedDevice.svg"
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    ColorOverlay{
        source:image
        color:label.color
        smooth: true
        anchors.fill: image
    }

    Label {
        id: label
        text: name
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(10)
        height: Units.dp(26)
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.Medium
        font.pixelSize: Qt.application.font.pixelSize;
        anchors.left: image.right
        anchors.leftMargin: Units.dp(10)
    }

}
