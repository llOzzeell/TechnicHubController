import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id: root
    height: 60
    clip: true
    width:parent.width

    property string _name

    property int _index:0
    property int nameLabelWidth: nameLabel.width+10
    property alias nameLabelVisible: nameLabel.visible

    signal nameLabelClicked

    Pane {
        id: background
        Material.background: Material.primary
        Material.elevation: 4
        anchors.fill: parent
    }

    Label {
        id: nameLabel
        color: Material.foreground
        text: name
        renderType: Text.QtRendering
        visible: true
        font.weight: Font.Light
        font.bold: false
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10

        onWidthChanged: {
            console.log("nameWidth: " + width )
        }

        MouseArea {
            id: profileNameMouseArea
            anchors.leftMargin: -6
            anchors.bottomMargin: -6
            anchors.topMargin: -6
            z: 1
            anchors.fill: parent
            onClicked: root.nameLabelClicked()
        }
    }


}

/*##^##
Designer {
    D{i:1;anchors_height:200;anchors_width:200}D{i:2;anchors_height:100}D{i:5;anchors_height:100;anchors_width:100;anchors_x:0;anchors_y:0}
D{i:4;anchors_height:40}
}
##^##*/
