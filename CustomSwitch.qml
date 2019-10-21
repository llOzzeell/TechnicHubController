import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.12
import ".."

Switch {
    id: control

    width: Units.dp(38)
    height: Units.dp(48)

    padding: 8
    spacing: 8

    indicator:
        Item {
            id: indicator
            implicitWidth: Units.dp(38)
            implicitHeight: Units.dp(32)

            x: text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
            y: control.topPadding + (control.availableHeight - height) / 2
            control: control

            property Item control
            property alias handle: handle

            Material.elevation: 1

            Rectangle {
                width: parent.width
                height: Units.dp(14)
                radius: Units.dp(7)
                y: parent.height / 2 - height / 2
                color: control.enabled ? (control.checked ? control.Material.switchCheckedTrackColor : control.Material.switchUncheckedTrackColor)
                                       : control.Material.switchDisabledTrackColor
            }

            Rectangle {
                id: handle
                x: Math.max(0, Math.min(parent.width - width, control.visualPosition * parent.width - (width / 2)))
                y: (parent.height - height) / 2
                width: Units.dp(20)
                height: Units.dp(20)
                radius: Units.dp(10)
                color: control.enabled ? (control.checked ? control.Material.switchCheckedHandleColor : control.Material.switchUncheckedHandleColor)
                                       : control.Material.switchDisabledHandleColor

                Behavior on x {
                    enabled: !control.pressed
                    SmoothedAnimation {
                        duration: 300
                    }
                }
            }
        }

}
