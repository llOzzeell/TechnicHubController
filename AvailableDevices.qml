import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root

    property bool isNotEmpty: (deviceModel.count > 0);

    function highlightIfPossible(){

        console.log("TRY HIGHLIGHT: " + linkToControl.chAddress)
        for(var i = 0; i < deviceModel.count; i++){
            if(deviceModel.get(i).address === linkToControl.chAddress){
                console.log(deviceModel.get(i).address + "  =  " + linkToControl.chAddress)
                listView.currentIndex = i;
                return;
            }
        }
        listView.currentIndex = -1;
        console.log(" NOT FOUND ADDRESS: set -1")
    }

    function loadDeviceList(){

        deviceModel.clear();
        var count = cpp_Controller.getDevicesCount();
        for(var i = 0; i < count; i++){
            var list = cpp_Controller.getDevicesListQML();
            deviceModel.append(list);
            var t1 = {"name": "t1", "address": "a1"}
            deviceModel.append(t1);
            var t2 = {"name": "t2", "address": "a2"}
            deviceModel.append(t2);
        }

        highlightIfPossible();
    }

    Rectangle {
        id: rectangle
        color: "#00000000"
        border.color: Material.primary
        border.width: Units.dp(2)
        anchors.fill: parent
        radius:Units.dp(4)
        visible: false
    }

    Label {
        id: label
        text: qsTr("No connected hubs")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        font.pixelSize: Qt.application.font.pixelSize
        visible: !isNotEmpty
    }

    ListView {
        id: listView
        clip: true
        anchors.fill: parent
        anchors.margins: Units.dp(5)
        model:deviceModel
        spacing: Units.dp(10)
        delegate:     Item {
            height: Units.dp(24)
            width: listView.width
            property bool isCur : ListView.isCurrentItem
            CustomPane{
                id: customPane
                anchors.fill: parent
                Material.background: isCur ? Material.accent : Material.primary
                Material.elevation:Units.dp(2)
                radius: height/2
            }

            Label{
                text:name
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: Qt.application.font.pixelSize
            }

            MouseArea{
                anchors.fill: parent
                onClicked:{
                    listView.currentIndex = index;
                    linkToControl.chName = deviceModel.get(index).name;
                    linkToControl.chAddress = deviceModel.get(index).address;
                }
            }
        }
    }
    
    Rectangle {
        id: rectangle1
        height: Units.dp(2)
        radius: height/2
        color: Material.primary
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    ListModel{
        id:deviceModel
    }

    Rectangle {
        id: rectangle2
        height: Units.dp(2)
        radius: height/2
        color: Material.primary
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.left: parent.left
    }


}
