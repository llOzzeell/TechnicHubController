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

    padding: Units.dp(12)

    property int radius: Units.dp(4)
    property alias color: rectangle.color
    property bool elevationEnabled:true
    property int elevationValue: 6

    background: Rectangle {
        id:rectangle
        color: control.Material.backgroundColor
        radius: control.radius

        layer.enabled: elevationEnabled
        layer.effect: DropShadow{
            radius: Units.dp(elevationValue)
            samples: Units.dp(elevationValue * 1.2)
            color: "#7F000000"
        }
    }
}

