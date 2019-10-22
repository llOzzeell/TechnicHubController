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
        font.weight: Font.Medium
        font.pixelSize: Qt.application.font.pixelSize * 1.3;
        anchors.left: image.right
        anchors.leftMargin: Units.dp(10)
        anchors.verticalCenter: parent.verticalCenter
    }

}
