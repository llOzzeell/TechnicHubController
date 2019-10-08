import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    width: parent.width
    height: 48

    property string _name

    Rectangle {
        id: rectangle
        height: 36
        color: Material.primary
        radius: 2
        anchors.fill: parent
        layer.enabled: true
        layer.effect: DropShadow{
            radius: 8
            samples: 12
            color: "black"
            opacity: 0.5
        }
    }

    Image {
        id: image
        width: 32
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        fillMode: Image.PreserveAspectFit
        source: "icons/hub.svg"
        visible: false
    }

    ColorOverlay{
        source: image
        color: Material.foreground
        anchors.fill: image
        smooth: true
    }

    Label {
        id: label
        color: Material.foreground
        text: _name
        font.capitalization: Font.AllUppercase
        font.weight: Font.Normal
        font.pointSize: 16
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: image.right
        anchors.leftMargin: 0
    }
}

/*##^##
Designer {
    D{i:2;anchors_height:100}
}
##^##*/
