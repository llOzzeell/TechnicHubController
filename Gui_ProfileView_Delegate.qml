import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id: root
    height: 40
    width:parent.width

    property string _name

    property int _index:0

    Rectangle {
        id: background
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
        id: icon
        width: 40
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        fillMode: Image.PreserveAspectFit
        source: "icons/profile.svg"
        visible: false
    }

    ColorOverlay{
        source: icon
        color: Material.foreground
        visible: false
        anchors.fill: icon
        smooth: true
    }


    Label {
        id: label
        color: Material.foreground
        text: _name
        font.weight: Font.Light
        font.bold: false
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        font.pointSize: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }


}

/*##^##
Designer {
    D{i:1;anchors_height:200;anchors_width:200}D{i:2;anchors_height:100}
}
##^##*/
