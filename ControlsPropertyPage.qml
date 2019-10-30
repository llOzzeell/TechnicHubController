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
        linkToControl.glow = false;
        flickable.contentY = 0;
    }


    CustomPane{
        id:background
        anchors.fill: parent
        Material.elevation:Units.dp(8)
        radius: 0
        opacity: 0.8
    }

    Flickable {
        id: flickable
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(20)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(20)
        anchors.bottomMargin: Units.dp(10)
        anchors.topMargin: Units.dp(20)
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick
        anchors.bottom: saveButton.top
        anchors.top: parent.top

        Column {
            id: column
            width: parent.width
            height: inversionsItem.height + servoItem.height + speedlimitItem.height + portsItem.height + devicesItem.height + 6 * spacing
            spacing: Units.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(20)

            Item{
                id:inversionsItem
                height:Units.dp(40)
                width:parent.width
                visible: linkToControl !== undefined ? linkToControl.requiredParameters.inversion : false

                Label {
                    height: Units.dp(26)
                    text: ConstList_Text.control_propertypage_inversion
                    fontSizeMode: Text.VerticalFit
                    anchors.right: inverted.left
                    anchors.rightMargin: 0
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Qt.application.font.pixelSize
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
                    height: Units.dp(26)
                    text: ConstList_Text.control_propertypage_servoangle  + " " + servo.value + "°"
                    fontSizeMode: Text.VerticalFit
                    anchors.right: servo.left
                    anchors.rightMargin: 0
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Qt.application.font.pixelSize
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
                    stepSize: 10
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
                    height: Units.dp(26)
                    text: ConstList_Text.control_propertypage_speedlimit + " " + speedlimit.value + "%"
                    fontSizeMode: Text.VerticalFit
                    anchors.right: speedlimit.left
                    anchors.rightMargin: 0
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Qt.application.font.pixelSize
                }

                CustomSlider{
                    id:speedlimit
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    from: 10
                    to: 100
                    value: 100
                    stepSize: 10
                    onValueChanged:{
                        linkToControl.speedlimit = parseInt(value)
                    }
                }
            }

            Item {
                id: portsItem
                height: Units.dp(48) + portsLabel.height
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                Label {
                    id: portsLabel
                    height: Units.dp(26)
                    text: ConstList_Text.control_propertypage_ports
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    fontSizeMode: Text.VerticalFit
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: Qt.application.font.pixelSize
                }

                AvailablePorts {
                    id: availablePorts
                    height: Units.dp(44)
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:componentwidth
                    multipleChoose: linkToControl !== undefined ? linkToControl.requiredParameters.multichoose : false
                    _enabled: (availableDevices.isNotEmpty && availableDevices.hubChoosed)
                }
            }

            Item{
                id:devicesItem
                width:parent.width
                height: Units.dp(140)
                visible: linkToControl !== undefined ? linkToControl.requiredParameters.ports : false

                Label {
                    id:devicesLabel
                    height: Units.dp(26)
                    text: ConstList_Text.control_propertypage_hubs
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    fontSizeMode: Text.VerticalFit
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pixelSize: Qt.application.font.pixelSize
                }

                AvailableDevices {
                    id: availableDevices
                    anchors.topMargin: Units.dp(8)
                    anchors.bottomMargin: 0
                    anchors.top: devicesLabel.bottom
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                }
            }


        }
    }

    RoundButton {
        id: saveButton
        height: Units.dp(44)
        text: qsTr("Close")
        rightPadding: Units.dp(12)
        leftPadding: Units.dp(12)
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Qt.application.font.pixelSize
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Units.dp(10)
        Material.background: Material.accent
        onClicked: {
            linkToControl.save();
            linkToControl.checkReady();
            root.hide();
        }
    }

    RoundButton {
        id: deleteButton
        width: Units.dp(44)
        height: Units.dp(44)
        anchors.rightMargin: Units.dp(10)
        anchors.verticalCenter: saveButton.verticalCenter
        icon.width: Units.dp(24)
        icon.height: Units.dp(24)
        anchors.right: parent.right
        icon.source: "qrc:/assets/icons/delete.svg"
        Material.background: ConstList_Color.delete_Color
        onClicked: {
            linkToControl.remove();
            root.hide();
        }
    }

}

/*##^##
Designer {
    D{i:2;anchors_height:300;anchors_width:300;anchors_x:0;anchors_y:57}D{i:19;anchors_width:200}
}
##^##*/
