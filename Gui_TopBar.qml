import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    height:40
    width:parent.width

    Rectangle {
        id: rectangle
        color: Material.accent
        anchors.fill: parent
    }

    Image {
        id: image
        width: 28
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        fillMode: Image.PreserveAspectFit
        source: "icons/more.svg"
        ColorOverlay{
            source: image
            color: Style.dark_background
            anchors.fill: parent
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
        }
    }

}
