import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtGraphicalEffects 1.0
import ".."

T.Pane {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            contentHeight + topPadding + bottomPadding)
    height: width

    property alias borderWidth: rectangle.borderWidth
    property alias borderColor: rectangle.borderColor
    property alias color: rectangle.color

    background: Rectangle {
        color: control.Material.backgroundColor
        radius: control.height/2

        layer.enabled: control.enabled && control.Material.elevation > 0
        layer.effect: ElevationEffect {
            elevation: control.Material.elevation
        }
    }

    Rectangle {
        id: rectangle
        color: Material.primary
        radius: height/2
        border.width: borderWidth
        border.color: borderColor
        anchors.fill: parent
        property int borderWidth : 0
        property color borderColor: "Black"
        layer.enabled: true
        layer.effect: DropShadow{
            radius: 14
            samples: 18
            color: "#7F000000"
        }
    }
}

