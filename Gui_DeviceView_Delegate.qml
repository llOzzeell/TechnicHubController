import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    width: parent.width
    height: 46

    property string _name

    Rectangle {
        id: rectangle
        height: 46
        color: Material.primary
        radius: 2
        anchors.fill: parent
    }

    Image {
        id: image
        width: 28
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        fillMode: Image.PreserveAspectFit
        source: "icons/hub.svg"
        ColorOverlay{
            source: image
            color: Material.foreground
            anchors.fill: parent
        }
    }

    Label {
        id: label
        color: Material.foreground
        text: _name
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        fontSizeMode: Text.Fit
        font.pointSize: 50
        font.bold: true
        font.family: Style.robotoCondensed
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }
}

/*##^##
Designer {
    D{i:2;anchors_height:100}
}
##^##*/
