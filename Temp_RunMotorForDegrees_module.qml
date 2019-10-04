import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root
    height: 80

    ComboBox {
        id: comboBox1
        y: -272
        width: 70
        height: 38
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: slider.verticalCenter
        font.family: robotoCondensed
        font.bold: true
        font.pointSize: 14
        model:portModel
        currentIndex: 0

        ListModel{
            id:portModel
            ListElement{
                name: "A"
            }
            ListElement{
                name: "B"
            }
            ListElement{
                name: "C"
            }
            ListElement{
                name: "D"
            }
        }
    }

    Label {
        id: label1
        x: 153
        y: -233
        width: 121
        height: 16
        text: qsTr("Скорость:  ") + slider.value
        anchors.right: slider.left
        anchors.rightMargin: 10
        anchors.verticalCenter: slider.verticalCenter
        font.pointSize: 14
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.family: robotoCondensed
        font.bold: true
    }

    Button {
        id: button1
        y: 52
        height: 38
        text: qsTr("Старт")
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: slider1.verticalCenter
        font.pointSize: 12
        Material.background: Material.primary
        font.family: robotoCondensed
        font.bold: true
        onClicked: smartHubOperator.motor_RunForDegrees(portModel.get(comboBox1.currentIndex).name, slider.value, slider1.value)
    }

    Slider {
        id: slider
        x: -2
        width: 100
        height: 48
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        to: 100
        from: -100
        stepSize: 1
        value: 0
    }

    Label {
        id: label2
        x: 365
        y: -245
        width: 106
        height: 16
        text: qsTr("Угол:  ") + slider1.value
        anchors.right: slider1.left
        anchors.rightMargin: 10
        anchors.verticalCenter: slider1.verticalCenter
        horizontalAlignment: Text.AlignLeft
        font.family: robotoCondensed
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pointSize: 14
    }

    Slider {
        id: slider1
        x: 440
        y: 52
        width: 100
        height: 48
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        from: 0
        stepSize: 1
        value: 0
        to: 180
    }

    Button {
        id: button2
        y: 8
        height: 38
        text: qsTr("Стоп")
        anchors.left: button1.right
        anchors.leftMargin: 10
        anchors.verticalCenter: slider1.verticalCenter
        font.family: robotoCondensed
        Material.background: Material.primary
        font.bold: true
        font.pointSize: 12
        onClicked: smartHubOperator.motor_Stop(portModel.get(comboBox1.currentIndex).name)
    }

}

/*##^##
Designer {
    D{i:1;anchors_x:0}D{i:2;anchors_height:38;anchors_width:115;anchors_x:263;anchors_y:-92}
D{i:3;anchors_x:393}D{i:9;anchors_x:0}D{i:10;anchors_x:263}
}
##^##*/
