import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root
    Component.onCompleted: {
        deviceModel.clear();
        gui_Radar.start();
        hubFinder.startScan();
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
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: -400
        anchors.left: parent.left
        anchors.leftMargin: -400

        Connections{
            target: hubFinder
            onScanFinished:{
                gui_Radar.stop();
            }
        }
    }

    ListView {
        id: deviceView
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 4
        anchors.top: gui_TopBar.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
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


    Gui_TopBar {
        id: gui_TopBar
        labelText: qsTr("Finder") + " (" + deviceView.count + ")"
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        right1ButtonVisible: false
        right2ButtonVisible: true
        right1ButtonIconSource: "icons/find.svg"
        right2ButtonIconSource: "icons/profileEdit.svg"
        backButtonVisible: false
        onRight2ButtonClicked: stackView.push(appSettings)
        onRight1ButtonClicked: {
            if(hubFinder.scanIsRunning()){hubFinder.stopScan();}
                deviceModel.clear();
                gui_Radar.start();
                hubFinder.startScan();

        }
    }




    Page_Connect {
        id: page_Connect
        anchors.fill: parent
        visible: false
        onNoConnected: page_Connect.visible = false;
        onDeviceConnected:{
            hubFinder.stopScan();
            wasConnected()
        }
    }



}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:954.4724508459077}
}
##^##*/
