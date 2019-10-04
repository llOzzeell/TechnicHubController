import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id: root
    width: 400
    height: (width/9)*18

    function clearColor(){
        temp_LED_module.clearColor();
    }

    Button {
        id: disconnectButton
        y: 424
        height: 79
        text: qsTr("Отключить")
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pointSize: 16
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        onClicked: { smartHubConnector.disconnectFromDevice(); layout.setFinderPage();}
        font.family: robotoCondensed
        Material.background: Material.color(Material.Red, Material.Shade400)
    }

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

    ComboBox {
        id: comboBox1
        width: 70
        height: 38
        visible: true
        anchors.bottom: control_Moving.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: control_Moving.horizontalCenter
        font.family: robotoCondensed
        font.bold: true
        font.pointSize: 14
        anchors.leftMargin: 10
        model:portModel
        currentIndex: 1
    }

    Control_Moving {
        id: control_Moving
        x: 10
        y: 470
        width: 160
        anchors.verticalCenterOffset: -50
        visible: true
        anchors.right: parent.right
        anchors.rightMargin: 20
        port: portModel.get(comboBox1.currentIndex).name
        anchors.verticalCenter: parent.verticalCenter
        onCurrentSpeedReady: smartHubOperator.motor_RunPermanent(port, currentSpeed)
    }

    ComboBox {
        id: comboBox2
        width: 70
        height: 38
        visible: true
        anchors.bottom: control_Steering.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: control_Steering.horizontalCenter
        font.family: robotoCondensed
        font.bold: true
        font.pointSize: 14
        anchors.leftMargin: 10
        model:portModel
        currentIndex: 0
    }

    Control_Steering {
        id: control_Steering
        width: 160
        anchors.verticalCenterOffset: -50
        visible: true
        port: portModel.get(comboBox2.currentIndex).name
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    Control_FunctionButtonHold {
        id: control_FunctionButtonHold
        width: 160
        anchors.top: control_Moving.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: control_Moving.horizontalCenter
        port: portModel.get(comboBox1.currentIndex).name
    }

    Button {
        id: button
        x: 10
        y: 8
        width: 71
        height: 35
        text: qsTr("Назад")
        anchors.bottom: disconnectButton.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Material.background: Material.primary
        onClicked: layout.currentIndex = 2
    }
}
