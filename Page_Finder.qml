import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root

    signal deviceWasConnected
    signal deviceClicked(int index)
    onDeviceClicked:{

        page_Connect.visible = true;
        page_Connect.start();
        hubConnector.connectTo(index);
    }

    Gui_TopBar {
        id: gui_TopBar
        labelText: qsTr("Finder")
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        right1ButtonVisible: true
        right2ButtonVisible: true
        right1ButtonIconSource: "icons/find.svg"
        right2ButtonIconSource: "icons/profileEdit.svg"
        backButtonVisible: false
        onRight2ButtonClicked: stackView.push(appSettings)
        onRight1ButtonClicked: {
            if(!hubFinder.scanIsRunning()){
                deviceModel.clear();
                gui_Radar.start();
                hubFinder.startScan();
            }
        }
    }

    Gui_Radar {
        id: gui_Radar
        height: width
        anchors.right: parent.right
        anchors.rightMargin: -200
        anchors.left: parent.left
        anchors.leftMargin: -200
        anchors.verticalCenter: parent.verticalCenter

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
        text: qsTr("Device search")
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
        visible: false
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
        anchors.top: gui_TopBar.bottom
        anchors.topMargin: 10
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
        onDeviceConnected:{
            //root.deviceWasConnected();
            wasConnected()
        }
    }



}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
