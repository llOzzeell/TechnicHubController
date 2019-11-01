import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import ".."
import "qrc:/assets"

Item {
    id:root
    width: 200
    height: 40
    visible: !parent.editorMode && cpp_Controller.isNotEmpty() && hubInfoVisible

    property bool hubInfoVisible : cpp_Settings.getHubInfo();

    Connections{
        target:cpp_Settings
        onHubInfoChanged:{
            hubInfoVisible = value;
        }
    }

    Connections{
        target: cpp_Connector
        onDeviceParamsChanged:{

            if(root.visible){
                if(isExists(name)){
                    deviceModel.setProperty(getIndexByName(name), "batteryValue", list[0] );
                }
                else{
                    var listElement = { "name": name, "address": address, "batteryValue":list[0] };
                    deviceModel.append(listElement);
                }
            }
        }
        onQmlDisconnected:{
            if(root.visible){
                deviceModel.remove(getIndexByAddress(address));
            }
        }
    }

    function isExists(name){
        for(var i = 0; i < deviceModel.count; i++){
            if(deviceModel.get(i).name === name){
                return true;
            }
        }
        return false;
    }

    function getIndexByName(name){
        for(var i = 0; i < deviceModel.count; i++){
            if(deviceModel.get(i).name === name){
                return i;
            }
        }
        return -1;
    }

    function getIndexByAddress(address){
        for(var i = 0; i < deviceModel.count; i++){
            if(deviceModel.get(i).address === address){
                return i;
            }
        }
        return -1;
    }

    ListView {
        id: listView
        spacing: Units.dp(10)
        flickableDirection: Flickable.HorizontalFlick
        orientation: ListView.Horizontal
        interactive: contentWidth >= root.width ? true : false
        anchors.fill: parent
        model:deviceModel
        delegate: Item{
            id: element
            width: image.width + Units.dp(10) + label.width + Units.dp(5) + label1.width
            height: Units.dp(40)

            property color batteryValueColor:ConstList_Color.accentGreen
            property string _name:name
            property int _batteryValue:batteryValue
            on_BatteryValueChanged: {
                if(_batteryValue){
                    if(_batteryValue >= 50)batteryValueColor = ConstList_Color.accentGreen;
                    if(_batteryValue >= 25 && _batteryValue <50)batteryValueColor = ConstList_Color.accentYellow;
                    if(_batteryValue < 25)batteryValueColor = ConstList_Color.accentRed;
                }
            }

            Image {
                id: image
                width: Units.dp(16)
                height: Units.dp(24)
                anchors.left: parent.left
                anchors.leftMargin: Units.dp(10)
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectCrop
                source: "qrc:/assets/icons/battery.svg"
                visible: false
            }

            ColorOverlay{
                source:image
                anchors.fill: image
                color: batteryValueColor
            }

            Label {
                id: label
                text: _batteryValue + "%"
                color: batteryValueColor
                font.weight: Font.DemiBold
                anchors.leftMargin: Units.dp(5)
                anchors.left: image.right
                font.pixelSize: Qt.application.font.pixelSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
            }

            Label {
                id: label1
                text: _name
                font.weight: Font.DemiBold
                font.pixelSize: Qt.application.font.pixelSize
                verticalAlignment: Text.AlignVCenter
                anchors.left: label.right
                anchors.leftMargin: Units.dp(5)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
            }
        }
    }

    ListModel{
        id:deviceModel
    }
}
