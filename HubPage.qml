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

    Column {
        id: row
        visible: true
        spacing: 20
        anchors.bottom: disconnectButton.top
        anchors.bottomMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10

        Temp_LED_module {
            id: temp_LED_module
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Temp_ServoTest_module {
            id: temp_ServoTest_module
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Temp_RunMotor_module {
            id: temp_RunMotor_module
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Temp_RunMotorForTime_module {
            id: temp_RunMotorForTime_module
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Temp_RunMotorForDegrees_module {
            id: temp_RunMotorForDegrees_module
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }
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

    Button {
        id: button
        x: 10
        y: 8
        width: 175
        height: 35
        text: qsTr("Экран управления")
        anchors.bottom: disconnectButton.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Material.background: Material.primary
        onClicked: layout.currentIndex = 3
    }
}
