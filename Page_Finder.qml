import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root
    Component.onCompleted:{
        //androidFunc.setOrientation("portraite");
        //window.header.visible = false;
    }

    signal deviceWasConnected
    signal deviceClicked(int index)
    onDeviceClicked:{

        page_Connect.visible = true;
        page_Connect.start();
        hubConnector.connectTo(index);
    }

    Gui_Radar {
        id: gui_Radar
        width: 320
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        Connections{
                target: hubFinder
                onScanFinished:{
                    gui_Radar.stop();
                }
        }
    }

    Button {
        id: scanButton
        height: 58
        text: qsTr("Поиск устройств")
        font.weight: Font.Light
        font.bold: false
        font.pointSize: 18
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: gui_Radar.bottom
        anchors.topMargin: 10
        Material.background: Material.accent
        Material.foreground: Style.dark_background
        onClicked: {
            if(!hubFinder.scanIsRunning()){
                gui_Radar.start();
                hubFinder.startScan();
            }
        }
    }

    ListView {
        id: deviceView
        spacing: 4
        anchors.top: scanButton.bottom
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.right: scanButton.right
        anchors.rightMargin: 0
        anchors.left: scanButton.left
        anchors.leftMargin: 0
        delegate: deviceDelegate
        model: deviceModel

        Component{
            id:deviceDelegate
            Gui_DeviceView_Delegate{
                _name:name

                MouseArea{
                    id:mouseArea
                    anchors.fill: parent
                    onClicked:root.deviceClicked(index);
                }
            }
        }

        ListModel{
            id:deviceModel
        }

        Connections{
                target: hubFinder
                onDevicesFound:{
                    deviceModel.clear();
                    var list = hubFinder.getDeviceInfoFromQML();
                    list.forEach(function(item,i,arr){
                        var data = {'name': item};
                        deviceModel.append(data);
                    });
                }
        }
    }

    Page_Connect {
        id: page_Connect
        anchors.fill: parent
        visible: false
        onNoConnected: page_Connect.visible = false;
        onDeviceConnected: root.deviceWasConnected();
    }


}
