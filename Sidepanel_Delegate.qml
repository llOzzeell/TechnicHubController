import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import ".."
import "qrc:/assets"

Item {
    id:root
    implicitHeight: Units.dp(40)
    height:Units.dp(40)
    width: parent.width
    property alias icon: image.source
    property alias text: label.text

    function clickEffect(value){
        background.opacity = value ? 1 : 0;
    }

    Rectangle{
        id:background
        color: Material.primary
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.fill: parent
        opacity: 0

        Behavior on opacity {
            NumberAnimation{
                duration: 100
            }
        }
    }

    Image {
        id: image
        width: Units.dp(24)
        height: Units.dp(24)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(20)
        anchors.verticalCenter: parent.verticalCenter
        visible: false
        source: ""
    }

    ColorOverlay{
        source:image
        color:label.color
        smooth: true
        anchors.fill: image
    }


    Label {
        id: label
        height: Units.dp(26)
        text: ""
        fontSizeMode: Text.VerticalFit
        anchors.rightMargin: Units.dp(20)
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: Qt.application.font.pixelSize
        anchors.left: image.right
        anchors.leftMargin: Units.dp(20)
        font.weight: Font.Medium
        anchors.verticalCenter: parent.verticalCenter
    }

}
