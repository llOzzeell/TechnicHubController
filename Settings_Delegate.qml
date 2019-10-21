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
    property bool isGroupTitle:false
    property alias text: label.text

    Label {
        id: label
        text: ""
        font.weight: isGroupTitle ? Font.DemiBold : Font.Normal
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: isGroupTitle ? Qt.application.font.pixelSize * 1.1 : Qt.application.font.pixelSize
        anchors.left: parent.left
        anchors.leftMargin: 0

        anchors.verticalCenter: parent.verticalCenter
    }

}
