import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4

ComboBox{
    id:control
    font.pointSize: 12
    font.family: "Roboto"
    font.weight: Font.Light

    delegate: MenuItem {
        width: parent.width-6
        height:36
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        Material.foreground: control.currentIndex === index ? parent.Material.accent : parent.Material.foreground
        hoverEnabled: control.hoverEnabled
        rotation: 90
    }

    contentItem: Label {
        padding: 6
        leftPadding: control.editable ? 2 : control.mirrored ? 0 : 12
        rightPadding: control.editable ? 2 : control.mirrored ? 12 : 0

        text: control.editable ? control.editText : control.displayText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pointSize: 13
        font.family: "Roboto"
        font.weight: Font.Light
        color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
    }

}
