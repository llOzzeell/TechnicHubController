import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import ".."
import "qrc:/assets"

Item {
    id:root
    implicitHeight: Units.dp(140)
    height:Units.dp(140)
    width: parent.width
    opacity: _isConnected ? 1 : 0.5

    property int _index:-1
    property bool _isConnected:false
    property int _type:-1
    property bool _isFavorite: false

    CustomPane{
        id:background
        anchors.fill: parent
        Material.background: Material.primary
        Material.elevation:Units.dp(2)
    }

    TextInput {
            id: nameLabel
            color: Material.foreground
            text: name
            font.weight: Font.Medium
            anchors.top: parent.top
            anchors.topMargin: Units.dp(10)
            font.family: "Roboto"
            cursorVisible: false
            font.pixelSize: Qt.application.font.pixelSize  * 1.5
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: Units.dp(10)
            maximumLength: 20

            property string previousName: ""

            onFocusChanged: {
                if(focus) previousName = text;
                if(!focus && text == ""){
                    text = previousName;
                }
            }
            onAccepted: {
                if(text != ""){
                    cpp_Favorite.updateName(nameLabel.text,  deviceAddressLabel.text );
                }
                else {
                    text = previousName;
                }
                nameLabel.focus = false;
            }
        }

    Label {
        id: deviceAddressLabel
        text: address
        font.weight: Font.Medium
        anchors.left: nameLabel.left
        anchors.leftMargin: 0
        anchors.top: nameLabel.bottom
        anchors.topMargin: 0
        font.pixelSize: Qt.application.font.pixelSize
    }

    ProgressBar {
        id: batteryLevelProgressBar
        visible: root._isConnected
        height: Units.dp(4)
        from:0
        to: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Units.dp(10)
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(10)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(10)
        value: /*_isConnected ? 100 : 0*/ 0

        contentItem.implicitHeight:  height
        background.height: height

    }

    Label {
        id: bateeryValueLabel
        text: batteryLevelProgressBar.value + " %"
        anchors.bottomMargin: Units.dp(5)
        anchors.right: batteryLevelProgressBar.right
        anchors.rightMargin: 0
        anchors.bottom: batteryLevelProgressBar.bottom
        visible: batteryLevelProgressBar.visible
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: Qt.application.font.pixelSize
        font.weight: Font.Medium
    }

    ToolButton{
        id:disconnectButton
        width: Units.dp(48)
        height: Units.dp(48)
        icon.width: Units.dp(32)
        icon.height: Units.dp(32)
        anchors.verticalCenter: nameLabel.verticalCenter
        anchors.right: favoriteButton.left
        anchors.rightMargin: 0
        icon.source: "qrc:/assets/icons/disconnect.svg"
        visible: root._isConnected
        onClicked: {
            if(_isFavorite){
                cpp_Connector.disconnectDevice(deviceAddressLabel.text);
            }
            else{
                cpp_Connector.disconnectDevice(deviceAddressLabel.text);
                connectedModel.remove(getIndexByAddress(deviceAddressLabel.text));
            }
        }
    }

    SignalStrengh {
        id: signalStrengh
        width: Units.dp(32)
        height: Units.dp(32)
        color: Material.foreground
        visible: batteryLevelProgressBar.visible
        anchors.left: nameLabel.right
        anchors.leftMargin: Units.dp(10)
        anchors.verticalCenter: nameLabel.verticalCenter
    }

    Label {
        id: bateeryLabel
        text: qsTr("Battery")
        anchors.bottomMargin: Units.dp(5)
        anchors.left: batteryLevelProgressBar.left
        anchors.leftMargin: 0
        font.pixelSize: Qt.application.font.pixelSize
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        anchors.bottom: batteryLevelProgressBar.bottom
        visible: batteryLevelProgressBar.visible
        font.weight: Font.Medium
    }

    ToolButton {
        id: favoriteButton
        width: Units.dp(48)
        height: Units.dp(48)
        icon.width: Units.dp(32)
        icon.height: Units.dp(32)
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: nameLabel.verticalCenter
        icon.source: root._isFavorite ? "qrc:/assets/icons/favoriteYES.svg" : "qrc:/assets/icons/favoriteNO.svg"
        onClicked: {
            root._isFavorite = !root._isFavorite;

            if(root._isFavorite){
                cpp_Favorite.pushNew(nameLabel.text, root._type, deviceAddressLabel.text );
            }
            else{
                cpp_Favorite.deleteFavorite(deviceAddressLabel.text);
                if(!root._isConnected){
                    connectedModel.remove(getIndexByAddress(deviceAddressLabel.text));
                    if(cpp_Favorite.isEmpty() && cpp_Finder.isFavoriteScanning()){
                        cpp_Finder.stop();
                        console.log("NO MORE FAVORITE, STOP SCANNING");
                    }
                }
            }
        }
    }

    Connections{
        target: cpp_Connector
        onDeviceParamsChanged:{
            if(address == deviceAddressLabel.text){
                batteryLevelProgressBar.value = list[0];
                signalStrengh.rssi = list[1];
            }
        }
    }
}
