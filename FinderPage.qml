import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id: root

    function clear(){
        mymodel.clear();
    }

    Connections{
        target: smartHubFinder
        onDevicesFound:{
            root.clear();
            var list = smartHubFinder.getDeviceInfoFromQML();
            list.forEach(function(item,i,arr){
                var data = {'name': item};
                mymodel.append(data);
            });
        }
    }

    Button {
        id: button
        height: 69
        text: qsTr("Поиск устройств")
        font.pointSize: 14
        font.bold: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        onClicked: { root.clear(); smartHubFinder.startScan(); radarAnimation.running = true;}
        Material.background: Material.accent
        font.family: robotoCondensed
    }

    ListView {
        id: listView
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        spacing: 4
        anchors.top: button.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        delegate: hubListItem
        model: mymodel
    }

    Item {
        id: itemRadar
        height: 100
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: button.top
        anchors.bottomMargin: 20

        Image {
            id: image
            x: 689
            y: -11
            width: 80
            height: 80
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "icons/radar.png"
        }
    }


    ListModel{
        id:mymodel
    }


    Component{
        id:hubListItem
        HubListItem{
            _name: name

            MouseArea{
                id:mouseArea
                anchors.fill: parent
                onClicked: { smartHubConnector.connectTo(index); }
            }
        }
    }


    ParallelAnimation{
        id:radarAnimation

        PropertyAnimation{
            target:image
            property:"rotation"
            from:0
            to:360
            duration: 5000
        }
        SequentialAnimation{
            PropertyAnimation{
                target:image
                property:"opacity"
                from:1
                to:0.3
                duration: 1250/2
            }
            PropertyAnimation{
                target:image
                property:"opacity"
                from:0.3
                to:1
                duration: 1250/2
            }

            PropertyAnimation{
                target:image
                property:"opacity"
                from:1
                to:0.3
                duration: 1250/2
            }
            PropertyAnimation{
                target:image
                property:"opacity"
                from:0.3
                to:1
                duration: 1250/2
            }

            PropertyAnimation{
                target:image
                property:"opacity"
                from:1
                to:0.3
                duration: 1250/2
            }
            PropertyAnimation{
                target:image
                property:"opacity"
                from:0.3
                to:1
                duration: 1250/2
            }

            PropertyAnimation{
                target:image
                property:"opacity"
                from:1
                to:0.3
                duration: 1250/2
            }
            PropertyAnimation{
                target:image
                property:"opacity"
                from:0.3
                to:1
                duration: 1250/2
            }
        }

    }





}
