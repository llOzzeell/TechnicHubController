import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id: root
    height: 40
    width:parent.width

    property string _name

    Rectangle {
        id: background
        color: Material.accent
        radius: 2
        anchors.fill: parent
    }

    Image {
        id: icon
        width: height
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        fillMode: Image.PreserveAspectFit
        source: "icons/profile.svg"
        ColorOverlay{
            source: icon
            color: Style.dark_background
            anchors.fill: parent
        }
    }


    Label {
        id: label
        text: _name
        font.bold: true
        font.family: Style.robotoCondensed
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        font.pointSize: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: 10
        color: Style.dark_background
    }


}

/*##^##
Designer {
    D{i:1;anchors_height:200;anchors_width:200}D{i:2;anchors_height:100}
}
##^##*/
