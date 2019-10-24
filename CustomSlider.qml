import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import ".."

T.Slider {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)
    padding: Units.dp(6)

    handle:Item {
        id: root
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        width: Units.dp(13)
        height: Units.dp(13)

        property real value: control.value
        property bool handleHasFocus: control.visualFocus
        property bool handlePressed: control.pressed
        property bool handleHovered: control.hovered

        Rectangle {
            id: handleRect
            width: parent.width
            height: parent.height
            radius: width / 2
            color: control.Material.accentColor
            scale: root.handlePressed ? 1.5 : 1

            Behavior on scale {
                NumberAnimation {
                    duration: 250
                }
            }
        }

        Ripple {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: Units.dp(22); height: Units.dp(22)
            pressed: root.handlePressed
            active: root.handlePressed || root.handleHasFocus || root.handleHovered
            color: control.Material.rippleColor
        }
    }

    background: Rectangle {
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        implicitWidth: control.horizontal ? 200 : 48
        implicitHeight: control.horizontal ? 48 : 200
        width: control.horizontal ? control.availableWidth : 1
        height: Units.dp(1)
        color: control.Material.foreground
        scale: control.horizontal && control.mirrored ? -1 : 1

        Rectangle {
            x: control.horizontal ? 0 : (parent.width - width) / 2
            y: control.horizontal ? (parent.height - height) / 2 : control.visualPosition * parent.height
            width: control.horizontal ? control.position * parent.width : 3
            height: Units.dp(3)
            color: control.Material.accentColor
        }
    }
}
