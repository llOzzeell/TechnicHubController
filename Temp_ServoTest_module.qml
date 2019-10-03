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
        anchors.leftMargin: 10
        font.pointSize: 14
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: robotoCondensed
    }

    Slider {
        id: slider
        height: 38
        stepSize: (to*2)/20
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: comboBox1.bottom
        anchors.topMargin: 5
        to: spinBox.value
        from: -spinBox.value
        anchors.right: parent.right
        anchors.rightMargin: 0
        value: 0
        onValueChanged: smartHubOperator.motor_TurnToDegrees(portModel.get(comboBox1.currentIndex).name, value);
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
        x: 0
        y: -23
        width: 43
        height: 16
        text: qsTr("Угол")
        anchors.right: spinBox.left
        anchors.rightMargin: 10
        font.pointSize: 14
        anchors.verticalCenter: comboBox1.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.family: robotoCondensed
        font.bold: true
    }

    SpinBox {
        id: spinBox
        x: 216
        y: 109
        width: 144
        height: 40
        font.bold: true
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenterOffset: 5
        font.family: robotoCondensed
        font.pointSize: 14
        value: 45
        to: 180
        stepSize: 5
        anchors.verticalCenter: comboBox1.verticalCenter
    }

}

/*##^##
Designer {
    D{i:1;anchors_x:0}D{i:2;anchors_height:38;anchors_width:115;anchors_x:263;anchors_y:-92}
D{i:3;anchors_x:393}D{i:9;anchors_x:0}D{i:10;anchors_x:263}
}
##^##*/
