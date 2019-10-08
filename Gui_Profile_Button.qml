import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    width: 120
    height: 26
    implicitHeight: 26
    implicitWidth: 120

    property alias iconSource: icon.source
    property alias text: label.text

    signal clicked

    Rectangle {
        id: background
        color: Material.accent
        radius: height/2
        anchors.fill: parent
    }

    Image {
        id: icon
        width: 20
        height: 20
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        source: ""
        fillMode: Image.PreserveAspectFit
        opacity: 0
    }

    ColorOverlay{
        source: icon
        color: Material.foreground
        anchors.fill: icon
        smooth: true
    }

    Label {
        id: label
        text: qsTr("")
        font.weight: Font.Light
        font.pointSize: 12
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: icon.right
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        color: Material.foreground
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { root.clicked();}
    }

    SequentialAnimation{
        id:clickAnimation
        PropertyAnimation{
            target:background
            property: "color"
            from: background.color
            to: Qt.lighter(background.color, 1.3)
            duration: 200
        }
        PropertyAnimation{
            target:background
            property: "color"
            to: background.color
            duration: 200
        }
    }
}

/*##^##
Designer {
    D{i:1;anchors_height:26;anchors_width:100;anchors_x:220}
}
##^##*/
