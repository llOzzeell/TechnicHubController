import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import "qrc:/Controls"
import ".."

Item {
    id:root
    readonly property string title:ConstList_Text.page_finder
    Component.onCompleted: { radar.start(); cpp_Finder.start(); }
    Component.onDestruction: if(cpp_Finder != null && cpp_Finder != undefined)cpp_Finder.stop();

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
                        stackView.push(component_Connector)
                        stackView.currentItem.tryConnect(index, foundedDevicesModel.get(index).name);
                    }
                }
            }
        }
    }
}
