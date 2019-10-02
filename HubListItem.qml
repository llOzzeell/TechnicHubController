import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:delegate
    width: parent.width
    height: 36

    property string _name

    Rectangle {
        id: rectangle
        color: Material.primary
        radius: 2
        anchors.fill: parent
    }

    Image {
        id: image
        x: 10
        y: -19
        width: 24
        height: 24
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        source: "icons/hub.png"
    }

    Label {
        id: label
        x: 44
        y: 0
        height: 35
        text: name
        font.underline: false
        font.capitalization: Font.MixedCase
        anchors.right: parent.right
        anchors.rightMargin: 10
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 10
        anchors.left: image.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.family: robotoCondensed
    }
}
