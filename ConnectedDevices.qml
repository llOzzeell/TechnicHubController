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
                var listElement = {"index": -1, "name": list[0], "type": list[1], "address": list[2], "isConnected":false, "isFavorite":true};
                connectedModel.append(listElement);
                addrlist[i] = list[2];
            }
            //cpp_Finder.startScanFavorite(addrlist);
        }
    }

    ListView {
        id: connectedDeviceView
        spacing: Units.dp(10)
        anchors.margins: Units.dp(10)
        anchors.fill: parent
        model: connectedModel
        delegate: Component{
           ConnectedDevices_Delegate{
                _index: index
                _isConnected: isConnected
                _isFavorite: isFavorite
                _type:type
           }
        }
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
        var listElement = {"index": index, "type": type, "name": name, "address": address, "isConnected":isConnected, "isFavorite":isFavorite};
        connectedModel.append(listElement);
    }

    Connections{
        target:cpp_Connector
        onNewDeviceAdded:{
            var strlist = list;

            if(isExists(strlist[3])){
                connectedModel.remove(getIndexByAddress(strlist[3]));
                createNew(parseInt(strlist[0]), strlist[1], strlist[2], strlist[3], true, true)
            }
            else{
                createNew(parseInt(strlist[0]), strlist[1], strlist[2], strlist[3], true, false)
            }
        }
        onLostConnection:{
            console.log("QML DISCONNECTED")
            connectedModel.setProperty(getIndexByAddress(address), "isConnected", false);
        }
    }
}
