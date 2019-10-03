import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root
    height: 80

    Label {
        id: label
        y: -31
        width: 53
        height: 16
        text: qsTr("Порт")
        anchors.verticalCenter: comboBox1.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pointSize: 14
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: robotoCondensed
    }

    ComboBox {
        id: comboBox1
        width: 70
        height: 38
        font.family: robotoCondensed
        font.bold: true
        anchors.top: parent.top
        anchors.topMargin: 0
        font.pointSize: 14
        anchors.left: label.right
        anchors.leftMargin: 10
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
        width: 92
        height: 16
        text: qsTr("Скорость")
        anchors.top: comboBox1.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pointSize: 14
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.family: robotoCondensed
        font.bold: true
    }

    Button {
        id: button1
        x: -93
        y: 52
        height: 38
        text: qsTr("Стоп")
        anchors.verticalCenter: comboBox1.verticalCenter
        font.pointSize: 12
        Material.background: Material.primary
        anchors.right: parent.right
        anchors.rightMargin: 0
        font.family: robotoCondensed
        font.bold: true
        onClicked: smartHubOperator.motor_Stop(portModel.get(comboBox1.currentIndex).name)
    }

    Slider {
        id: slider
        to: 100
        from: -100
        stepSize: 5
        anchors.verticalCenter: label1.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: label1.right
        anchors.leftMargin: 10
        value: 0
        onValueChanged: smartHubOperator.motor_RunPermanent(portModel.get(comboBox1.currentIndex).name, slider.value)
    }

}

/*##^##
Designer {
    D{i:1;anchors_x:0}D{i:2;anchors_height:38;anchors_width:115;anchors_x:263;anchors_y:-92}
D{i:3;anchors_x:393}D{i:9;anchors_x:0}D{i:10;anchors_x:263}
}
##^##*/
