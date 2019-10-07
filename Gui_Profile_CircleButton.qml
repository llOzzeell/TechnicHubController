import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    width:48
    height: width
    implicitWidth: 48
    implicitHeight: implicitWidth

    property alias backgroundColor: rectangle.color
    property string iconSource: "icons/plus.svg"

    signal clicked

    Rectangle {
        id: rectangle
        color: Material.accent
        radius: height/2
        anchors.fill: parent

    }

    Image {
        id: image
        width: root.width/2
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: iconSource
        ColorOverlay{
            source: image
            anchors.fill: parent
            color: Style.dark_background
        }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            clickAnimation.start();
            root.clicked();
        }

        SequentialAnimation{
            id:clickAnimation
            PropertyAnimation{
                target:rectangle
                property: "color"
                from: rectangle.color
                to: Qt.lighter(rectangle.color, 1.3)
                duration: 200
            }
            PropertyAnimation{
                target:rectangle
                property: "color"
                from: rectangle.color
                to: rectangle.color
                duration: 200
            }
        }
    }
}
