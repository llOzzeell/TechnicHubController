import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id: root
    height: 40
    width:parent.width

    readonly property int delegateHeight : height
    property string _name
    property string _icon

    Pane {
        id: background
        Material.background: Material.primary
        //radius: 2
        Material.elevation: 4
        anchors.fill: parent
//        layer.enabled: true
//        layer.effect: DropShadow{
//            radius: 8
//            samples: 12
//            color: "black"
//            opacity: 0.5
//        }
    }

    Image {
        id: icon
        width: 32
        height:width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        fillMode: Image.Stretch
        source: _icon
        visible: false
    }

    ColorOverlay{
        source: icon
        color: Material.foreground
        anchors.fill: icon
        smooth: true
    }

    Label {
        id: label
        color: Material.foreground
        text: _name
        font.weight: Font.Light
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        font.pointSize: 14
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: 10
    }
}
