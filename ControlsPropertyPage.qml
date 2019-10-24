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
            inverted.checked = linkToControl.inverted
            servo.value = linkToControl.servoangle
            speedlimit.value = linkToControl.speedlimit
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
                text: ConstList_Text.control_propertypage_servoangle  + " " + servo.value + "°"
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
                from: 1
                to: 100
                value: 100
                stepSize: 1
                onValueChanged:{
                    linkToControl.speedlimit = parseInt(value)
                }
            }
        }

        Item{
            id:portsItem
            height:Units.dp(40)
            width:parent.width
            visible: linkToControl !== undefined ? linkToControl.requiredParameters.ports : false

            Label {
                text: ConstList_Text.control_propertypage_ports
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Qt.application.font.pixelSize
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
    D{i:1;anchors_height:400;anchors_width:200;anchors_x:220;anchors_y:46}D{i:9;anchors_width:200}
D{i:12;anchors_width:200}
}
##^##*/
