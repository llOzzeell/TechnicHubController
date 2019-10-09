import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id:root
    implicitWidth:48
    implicitHeight: implicitWidth
    width:48
    height:width

    signal clicked
    property color iconColor: "black"
    property alias source: image.source

    Image {
        id: image
        anchors.fill: parent
        source: "qrc:/qtquickplugin/images/template_image.png"
        visible: false
    }

    ColorOverlay{
        source:image
        color: iconColor
        smooth: true
        anchors.fill: image
    }

    MouseArea {
        id: mouseArea
        anchors.rightMargin: -6
        anchors.leftMargin: -6
        anchors.bottomMargin: -6
        anchors.topMargin: -6
        anchors.fill: parent
        onClicked: root.clicked()
    }


}
