import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import "qrc:/Controls"
import ".."

Item {
    id:root
    readonly property string title:ConstList_Text.page_finder
    Component.onCompleted: { cpp_Finder.start(); radar.start(); }
    Component.onDestruction: cpp_Finder.stop();

    Radar{
        id: radar
        anchors.fill: parent
    }

    Connections{
        target: cpp_Finder
        onDeviceFound:{
            foundedDevicesModel.clear();
            list.forEach(function(device){
                var listElement = {"name": device};
                foundedDevicesModel.append(listElement);
            })
        }
    }

    ListModel{
        id:foundedDevicesModel
    }

    ListView {
        id: listView
        spacing: Units.dp(10)
        anchors.margins: Units.dp(10)
        anchors.fill: parent
        model:foundedDevicesModel
        delegate: Component{
            Finder_Delegate{
                MouseArea{
                    anchors.fill: parent
                    onClicked:{



                        var address = foundedDevicesModel.get(index).name;
                        address = address.slice(address.indexOf("(")+1, address.indexOf(")"));
                        cpp_Connector.connectDevice(address);
                        stackView.push(component_Connector)
                        stackView.currentItem.tryConnect(foundedDevicesModel.get(index).name);
                    }
                }
            }
        }
    }
}
