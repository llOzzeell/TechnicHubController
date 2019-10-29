import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."
import "qrc:/Controls"

Item {
    id:root
    readonly property string title: ConstList_Text.page_connectedDevices
    readonly property bool isAddButtonVisible: true

    Component.onCompleted: {
        var count = cpp_Favorite.getCount();
        if(count > 0){
            var addrlist = [];
            for(var i = 0; i < count; i++){
                var list = cpp_Favorite.getFavoriteDevice(i);

                var listElement = { "index": -1,
                                    "name": list[0],
                                    "type": list[1],
                                    "address": list[2],
                                    "isConnected":false,
                                    "isFavorite":true};
                connectedModel.append(listElement);
                addrlist[i] = list[2];
            }
        }
    }

    ListView {
        id: connectedDeviceView
        spacing: Units.dp(10)
        anchors.margins: Units.dp(10)
        anchors.fill: parent
        model: connectedModel
        delegate: ConnectedDevices_Delegate{
            _isConnected: isConnected
            _isFavorite: isFavorite
            //_factoryName: factoryName
            Component.onCompleted: {
             disconnectClicked.connect(root.disconnectDelegateClicked);
                favoriteClicked.connect(root.favoriteDelegateClicked);
                    nameChanged.connect(root.nameDelegateChanged);
          }
       }
    }

    function disconnectDelegateClicked(index){
        if(connectedModel.get(index).isFavorite){
            cpp_Connector.disconnectDevice(connectedModel.get(index).address);
        }
        else{
            cpp_Connector.disconnectDevice(connectedModel.get(index).address);
            connectedModel.remove(index);
        }
    }

    function favoriteDelegateClicked(index, state){
        connectedModel.setProperty(index, "isFavorite", state);

        if(state){
            cpp_Favorite.pushNew(connectedModel.get(index).name, connectedModel.get(index).type, connectedModel.get(index).address);
        }
        else{
            cpp_Favorite.deleteFavorite(connectedModel.get(index).address);
            if(!connectedModel.get(index).isConnected){
                connectedModel.remove(index);
            }
        }
    }

    function nameDelegateChanged(index, name){
        connectedModel.setProperty(index, "name",name);
        cpp_Favorite.updateName(name,  connectedModel.get(index).address );
        cpp_Connector.updateConnectedDeviceName(connectedModel.get(index).address, name)
    }

    Label {
        id: label
        text: qsTr("No connected hubs.")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: Qt.application.font.pixelSize * 1.5
        visible: connectedModel.count == 0
        opacity: 0.5
    }

    ListModel{
        id:connectedModel
    }

    function isExists(address){
        for(var i = 0; i < connectedModel.count; i++){
            if(connectedModel.get(i).address === address){
                return true;
            }
        }
        return false;
    }

    function getIndexByAddress(address){
        for(var i = 0; i < connectedModel.count; i++){
            if(connectedModel.get(i).address === address){
                return i;
            }
        }
        return -1;
    }

    function createNew(index, type, name, address, isConnected, isFavorite){
        var listElement = { "index": index,
                            "type": type,
                            "name": name,
                            "address": address,
                            "isConnected":isConnected,
                            "isFavorite":isFavorite};
        connectedModel.append(listElement);
    }

    Connections{
        target:cpp_Connector
        onNewDeviceAdded:{
            var strlist = list;

            if(isExists(strlist[3])){              
                var index = getIndexByAddress(strlist[3]);
                connectedModel.setProperty(index, "isConnected", true);
            }
            else{
                createNew(parseInt(strlist[0]), strlist[1], strlist[2], strlist[3], true, false)
            }
        }
        onQmlDisconnected:{
            if(isExists(address))connectedModel.setProperty(getIndexByAddress(address), "isConnected", false);
        }
    }

}
