import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."
import "qrc:/assets"

Item {
    id:root
    width: 300

    property var linkToControl
    onLinkToControlChanged: {
        if(linkToControl !== undefined){
            linkToControl.glow = true;
            inverted.checked = linkToControl.inverted;
            servo.value = linkToControl.servoangle;
            speedlimit.value = linkToControl.speedlimit;
            availablePorts.linkToPortsArrayOfControl = linkToControl.ports;
            availableDevices.loadDeviceList();
        }
    }

    signal hide()
    onHide:{
        root.linkToControl.glow = false;
    }

    function deleteControl(){
        cpp_Profiles.p_deleteControl(linkToControl.currentProfileIndex, linkToControl.cid);
        linkToControl.destroy();
    }

    CustomPane{
        id:background
        anchors.fill: parent
        Material.elevation:Units.dp(8)
        radius: 0
        opacity: 0.8
    }

    Column {
        id: column
        spacing: Units.dp(20)
        anchors.bottom: saveButton.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: Units.dp(10)
        anchors.margins: Units.dp(20)


        Item{
            id:inversionsItem
            height:Units.dp(40)
            width:parent.width
            visible: linkToControl !== undefined ? linkToControl.requiredParameters.inversion : false

            Label {
                text: ConstList_Text.control_propertypage_inversion
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Qt.application.font.pixelSize * 1.1
            }
            CustomSwitch {
                id:inverted
                width: Units.dp(38)
                height: Units.dp(48)
                checked: false
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged:{
                    linkToControl.inverted = checked;
                }
            }
        }


        Item{
            id:servoItem
            height:Units.dp(40)
            width:parent.width
            visible: linkToControl !== undefined ? linkToControl.requiredParameters.servoangle : false

            Label {
                text: ConstList_Text.control_propertypage_servoangle  + " " + servo.value + "°"
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Qt.application.font.pixelSize * 1.1
            }
            CustomSlider {
                id:servo
                height: Units.dp(48)
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                from: 10
                to: 130
                value: 90
                stepSize: 1
                onValueChanged:{
                    linkToControl.servoangle = parseInt(value)
                }
            }
        }


        Item{
            id:speedlimitItem
            height:Units.dp(40)
            width:parent.width
            visible: linkToControl !== undefined ? linkToControl.requiredParameters.speedlimit : false

            Label {
                text: ConstList_Text.control_propertypage_speedlimit + " " + speedlimit.value + "%"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Qt.application.font.pixelSize * 1.1
            }

            CustomSlider{
                id:speedlimit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                from: 1
                to: 100
                value: 100
                stepSize: 1
                onValueChanged:{
                    linkToControl.speedlimit = parseInt(value)
                }
            }
        }

        Item {
            id: portsItem
            height: Units.dp(40)
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Label {
                id: portsLabel
                text: ConstList_Text.control_propertypage_ports
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                font.pixelSize: Qt.application.font.pixelSize * 1.1
                anchors.leftMargin: 0
            }

            AvailablePorts {
                id: availablePorts
                height: Units.dp(44)
                width:componentwidth
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                multipleChoose: linkToControl !== undefined ? linkToControl.requiredParameters.multichoose : false
                _enabled: availableDevices.isNotEmpty
            }
        }

        Item{
            id:devicesItem
            width:parent.width
            height: Units.dp(130)
            visible: linkToControl !== undefined ? linkToControl.requiredParameters.ports : false

            Label {
                id:devicesLabel
                height: Units.dp(40)
                text: ConstList_Text.control_propertypage_hubs
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pixelSize: Qt.application.font.pixelSize * 1.1
            }

            AvailableDevices {
                id: availableDevices
                anchors.bottomMargin: 0
                anchors.top: devicesLabel.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 0
            }
        }

    }

    RoundButton {
        id: saveButton
        width: root.width/2
        height: Units.dp(44)
        text: qsTr("Close")
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Qt.application.font.pixelSize
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Units.dp(20)
        Material.background: Material.accent
        onClicked: root.hide();
    }

    RoundButton {
        id: deleteButton
        width: Units.dp(44)
        height: Units.dp(44)
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(20)
        anchors.bottomMargin: Units.dp(20)
        anchors.bottom: parent.bottom
        icon.source: "qrc:/assets/icons/delete.svg"
        Material.background: ConstList_Color.delete_Color
        onClicked: {
            deleteControl();
            root.hide();
        }
    }
}

/*##^##
Designer {
    D{i:12;anchors_width:200}D{i:16;anchors_x:86;anchors_y:456}D{i:17;anchors_x:86;anchors_y:456}
D{i:19;anchors_x:86;anchors_y:456}
}
##^##*/
