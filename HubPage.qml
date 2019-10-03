import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id: root

    function clearColor(){
        temp_LED_module.clearColor();
    }

    Button {
        id: disconnectButton
        y: 424
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
        Material.background: Material.primary
    }

    Column {
        id: row
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

    Control_Moving {
        id: control_Moving
        x: 10
        y: 470
        width: 160
        anchors.right: parent.right
        anchors.rightMargin: 20
        port: "A"
        anchors.verticalCenter: parent.verticalCenter
        onCurrentSpeedReady: smartHubOperator.motor_RunPermanent(port, currentSpeed)
    }

    Control_Steering {
        id: control_Steering
        width: 160
        port: "B"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        onCurrentDegreesReady: smartHubOperator.motor_TurnToDegrees(port, currentDegrees)
    }
}
