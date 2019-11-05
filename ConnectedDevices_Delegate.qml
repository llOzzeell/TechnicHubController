import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

import ".."
import "qrc:/assets"

Item {
    id:root
    implicitHeight: Units.dp(140)
    height:Units.dp(160)
    width: parent.width

    property bool _isConnected:false
    on_IsConnectedChanged: {
        if(!_isConnected){
            portA.enabled = false;
            portB.enabled = false;
            portC.enabled = false;
            portD.enabled = false;
        }
    }

    property bool _isFavorite: false

    signal disconnectClicked(int index)
    signal favoriteClicked(int index, bool state)
    signal nameChanged(int index, string name)


    CustomPane{
        id:background
        anchors.fill: parent
        Material.background: Material.primary
        Material.elevation:Units.dp(2)
    }

    Column {
        id: column
        spacing: 0
        anchors.fill: parent

        Item {
            id: element
            width: parent.width
            height: Units.dp(44)

            ToolButton {
                id: favoriteButton
                width: Units.dp(44)
                height: Units.dp(44)
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                icon.width: Units.dp(32)
                icon.height: Units.dp(32)
                icon.source: root._isFavorite ? "qrc:/assets/icons/favoriteYES.svg" : "qrc:/assets/icons/favoriteNO.svg"
                onClicked: {
                    root._isFavorite = !root._isFavorite;
                    root.favoriteClicked(root.index, _isFavorite);
                }
            }

            ToolButton{
                id:disconnectButton
                width: Units.dp(44)
                height: Units.dp(44)
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: favoriteButton.left
                anchors.rightMargin: 0
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                icon.width: Units.dp(32)
                icon.height: Units.dp(32)
                icon.source: "qrc:/assets/icons/disconnect.svg"
                visible: root._isConnected
                onClicked: root.disconnectClicked(root.index);
            }

            TextInput {
                id: nameLabel
                color: Material.foreground
                text: name
                anchors.rightMargin: Units.dp(10)
                anchors.right: disconnectButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Units.dp(10)
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                font.weight: Font.Medium
                font.family: "Roboto"
                cursorVisible: false
                font.pixelSize: Qt.application.font.pixelSize  * 1.5
                verticalAlignment: Text.AlignVCenter
                maximumLength: 20
                enabled: root._isFavorite && root._isConnected
                height: Units.dp(26)

                property string previousName: ""

                onFocusChanged: {
                    if(focus) previousName = text;
                    if(!focus && text.length <= 0){
                        text = previousName;
                    }
                }

                onAccepted: {
                    if(text.length > 0){
                        root.nameChanged(root.index, nameLabel.text);
                    }
                    else {
                        text = previousName;
                    }
                    nameLabel.focus = false;
                }
            }
        }

        Item {
            id: element1
            width: parent.width
            height: Units.dp(36)
            visible: root._isConnected

            Label {
                text: qsTr("Hub address")
                fontSizeMode: Text.VerticalFit
                anchors.left: parent.left
                anchors.leftMargin: Units.dp(10)
                font.weight: Font.Medium
                font.pixelSize: Qt.application.font.pixelSize
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: deviceAddressLabel
                text: address
                fontSizeMode: Text.VerticalFit
                anchors.right: parent.right
                anchors.rightMargin: Units.dp(10)
                anchors.verticalCenter: parent.verticalCenter
                font.weight: Font.Medium
                font.pixelSize: Qt.application.font.pixelSize
            }
        }

        Item {
            id: element2
            width: parent.width
            height: Units.dp(36)
            visible: root._isConnected

            Label {
                id: bateeryLabel
                text: qsTr("Battery")
                fontSizeMode: Text.VerticalFit
                anchors.left: parent.left
                anchors.leftMargin: Units.dp(10)
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Qt.application.font.pixelSize
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Medium
            }

            CustomProgressBar {
                id: batteryLevelProgressBar
                height: Units.dp(4)
                from:0
                to: 100
                value:0
                color: Material.primary
                anchors.right: bateeryValueLabel.left
                anchors.rightMargin: Units.dp(10)
                anchors.left: bateeryLabel.right
                anchors.leftMargin: Units.dp(10)
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: bateeryValueLabel
                text: batteryLevelProgressBar.value + " %"
                anchors.right: parent.right
                anchors.rightMargin: Units.dp(10)
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Qt.application.font.pixelSize
                font.weight: Font.Medium
            }
        }

        Item {
            id: element3
            width: parent.width
            height: Units.dp(36)
            visible: root._isConnected

            Label {
                id: bateeryLabel1
                text: qsTr("Connected ports")
                fontSizeMode: Text.FixedSize
                anchors.rightMargin: Units.dp(10)
                anchors.right: row.left
                anchors.leftMargin: Units.dp(10)
                font.weight: Font.Medium
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Qt.application.font.pixelSize
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                id: row
                layoutDirection: Qt.RightToLeft
                spacing: Units.dp(10)
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: Units.dp(10)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0


                RoundButton {
                    id: portD
                    width: Units.dp(36)
                    height: width
                    text: "D"
                    anchors.verticalCenter: parent.verticalCenter
                    Material.background: Material.accent
                    font.pixelSize: Qt.application.font.pixelSize * 0.8
                    enabled: false
                }




                RoundButton {
                    id: portC
                    width: Units.dp(36)
                    height: width
                    text: "C"
                    anchors.verticalCenter: parent.verticalCenter
                    Material.background: Material.accent
                    font.pixelSize: Qt.application.font.pixelSize * 0.8
                    enabled: false
                }


                RoundButton {
                    id: portB
                    width: Units.dp(36)
                    height: width
                    text: "B"
                    anchors.verticalCenter: parent.verticalCenter
                    Material.background: Material.accent
                    font.pixelSize: Qt.application.font.pixelSize * 0.8
                    enabled: false
                }

                RoundButton {
                    id: portA
                    width: Units.dp(36)
                    height: width
                    text: "A"
                    anchors.verticalCenter: parent.verticalCenter
                    Material.background: Material.accent
                    font.pixelSize: Qt.application.font.pixelSize * 0.8
                    enabled: false
                }
            }
        }
    }

    Connections{
        target: cpp_Connector
        onDeviceParamsChanged:{
            if(address == deviceAddressLabel.text){
                var value = list[0];
                batteryLevelProgressBar.value = value;
                if(value){
                    if(value >= 50)batteryLevelProgressBar.color = ConstList_Color.accentGreen;
                    if(value >= 25 && value <50)batteryLevelProgressBar.color = ConstList_Color.accentYellow;
                    if(value < 25)batteryLevelProgressBar.color = ConstList_Color.accentRed;
                }
            }
        }
        onExternalPortsIOchanged:{
            if(address == deviceAddressLabel.text){
                portA.enabled = list[0];
                portB.enabled = list[1];
                portC.enabled = list[2];
                portD.enabled = list[3];
            }
        }
    }
}

