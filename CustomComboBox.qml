import QtQuick 2.3
import QtQuick.Window 2.3
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3
import QtQuick.Templates 2.5 as T
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.3
import ".."

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    topInset: Units.dp(6)
    bottomInset: Units.dp(6)

    font.pixelSize: Qt.application.font.pixelSize

    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    Material.elevation: flat ? control.pressed || control.hovered ? Units.dp(2) : 0
                             : control.pressed ? Units.dp(8) : Units.dp(2)
    Material.background: flat ? "transparent" : undefined
    Material.foreground: flat ? undefined : Material.primaryTextColor

    delegate: MenuItem {
        width: parent.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        Material.foreground: control.currentIndex === index ? parent.Material.accent : parent.Material.foreground
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    indicator: ColorImage {
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2
        color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        width:Units.dp(24)
        height: Units.dp(24)
        source: "qrc:/qt-project.org/imports/QtQuick/Controls.2/Material/images/drop-indicator.png"
    }

    contentItem: T.TextField {
        padding: Units.dp(6)
        leftPadding: control.editable ? Units.dp(2) : control.mirrored ? 0 : Units.dp(12)
        rightPadding: control.editable ? Units.dp(2) : control.mirrored ? Units.dp(12) : 0

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator

        font: control.font
        color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        selectionColor: control.Material.accentColor
        selectedTextColor: control.Material.primaryHighlightedTextColor
        verticalAlignment: Text.AlignVCenter

        cursorDelegate: CursorDelegate { }
    }

    background: Rectangle {
        width: Units.dp(120)
        height: Units.dp(48)

        radius: control.flat ? 0 : Units.dp(2)
        color: !control.editable ? control.Material.dialogColor : "transparent"

        layer.enabled: control.enabled && !control.editable && control.Material.background.a > 0
        layer.effect: ElevationEffect {
            elevation: control.Material.elevation
        }

        Rectangle {
            visible: control.editable
            y: parent.y + control.baselineOffset
            width: parent.width
            height: control.activeFocus ? Units.dp(2) : Units.dp(1)
            color: control.editable && control.activeFocus ? control.Material.accentColor : control.Material.hintTextColor
        }

        Ripple {
            clip: control.flat
            clipRadius: control.flat ? 0 : Units.dp(2)
            x: control.editable && control.indicator ? control.indicator.x : 0
            width: control.editable && control.indicator ? control.indicator.width : parent.width
            height: parent.height
            pressed: control.pressed
            anchor: control.editable && control.indicator ? control.indicator : control
            active: control.pressed || control.visualFocus || control.hovered
            color: control.Material.rippleColor
        }
    }

    popup: T.Popup {
        y: control.editable ? control.height - Units.dp(5) : 0
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        transformOrigin: Item.Top
        topMargin: Units.dp(12)
        bottomMargin: Units.dp(12)

        Material.theme: control.Material.theme
        Material.accent: control.Material.accent
        Material.primary: control.Material.primary

        enter: Transition {
            // grow_fade_in
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        exit: Transition {
            // shrink_fade_out
            NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            radius: Units.dp(2)
            color: parent.Material.dialogColor

            layer.enabled: control.enabled
            layer.effect: ElevationEffect {
                elevation: Units.dp(8)
            }
        }
    }
}
