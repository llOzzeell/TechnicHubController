import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."

Item {
    id:root
    height: Units.dp(44)

    readonly property int componentwidth: row.width

    property bool multipleChoose:false

    property bool _enabled: true

    property var linkToPortsArrayOfControl
    onLinkToPortsArrayOfControlChanged: {
        if(linkToPortsArrayOfControl !== undefined)colorize();
    }

    function onlyOnePortChoosed(){
        var counter = 0;
        buttonsArray.forEach(function(port, index){
            if(linkToPortsArrayOfControl[index] > 0){
                counter++;
            }
            if(counter > 1) return false;
        })
        return true;
    }

    property var buttonsArray:[portA,portB, portC, portD]

    function colorize(){
        buttonsArray.forEach(function(port, index){
            if(linkToPortsArrayOfControl[index] > 0){
                port.Material.background = Material.accent
            }
            else{
                port.Material.background = Material.primary
            }
        })
    }

    function clear(){
        if(linkToPortsArrayOfControl !== undefined){
            buttonsArray.forEach(function(port, index){
                linkToPortsArrayOfControl[index] = 0;
                port.Material.background = Material.primary;
            })
        }
    }

    property string currentHubAddress:""
    onCurrentHubAddressChanged: {
        var list = cpp_Connector.getHubPortsState(currentHubAddress);
        portAconnected = list[0];
        portBconnected = list[1];
        portCconnected = list[2];
        portDconnected = list[3];
    }

    property bool portAconnected:false
    property bool portBconnected:false
    property bool portCconnected:false
    property bool portDconnected:false

    Component.onCompleted: {
        if(currentHubAddress.length > 0){
            var list = cpp_Connector.getHubPortsState(currentHubAddress);
            portAconnected = list[0];
            portBconnected = list[1];
            portCconnected = list[2];
            portDconnected = list[3];
        }
    }

    Row {
        id: row
        width: portA.width * 4 + spacing * 3
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: 0
        spacing: Units.dp(5)

        RoundButton {
            id: portA
            text: "A"
            font.weight: Font.Medium
            width:Units.dp(44)
            height:Units.dp(44)
            font.pixelSize: Qt.application.font.pixelSize * 0.9
            Material.background: Material.primary
            enabled: _enabled && root.portAconnected
            opacity: enabled ? 1 : 0.7
            onClicked:{
                if(multipleChoose){
                    if(linkToPortsArrayOfControl[0] > 0)linkToPortsArrayOfControl[0] = 0;
                    else linkToPortsArrayOfControl[0] = 1;
                }
                else{
                    linkToPortsArrayOfControl[0] = 1;
                    linkToPortsArrayOfControl[1] = 0;
                    linkToPortsArrayOfControl[2] = 0;
                    linkToPortsArrayOfControl[3] = 0;
                }
                colorize();
            }
        }

        RoundButton {
            id: portB
            text: "B"
            font.weight: Font.Medium
            width:Units.dp(44)
            height:Units.dp(44)
            font.pixelSize: Qt.application.font.pixelSize * 0.9
            Material.background: Material.primary
            enabled: _enabled && root.portBconnected
            opacity: enabled ? 1 : 0.7
            onClicked:{
                if(multipleChoose){
                    if(linkToPortsArrayOfControl[1] > 0)linkToPortsArrayOfControl[1] = 0;
                    else linkToPortsArrayOfControl[1] = 1;
                }
                else{
                    linkToPortsArrayOfControl[1] = 1;
                    linkToPortsArrayOfControl[0] = 0;
                    linkToPortsArrayOfControl[2] = 0;
                    linkToPortsArrayOfControl[3] = 0;
                }
                colorize();
            }
        }

        RoundButton {
            id: portC
            text: "C"
            font.weight: Font.Medium
            width:Units.dp(44)
            height:Units.dp(44)
            font.pixelSize: Qt.application.font.pixelSize * 0.9
            Material.background: Material.primary
            enabled: _enabled && root.portCconnected
            opacity: enabled ? 1 : 0.7
            onClicked:{
                if(multipleChoose){
                    if(linkToPortsArrayOfControl[2] > 0)linkToPortsArrayOfControl[2] = 0;
                    else linkToPortsArrayOfControl[2] = 1;
                }
                else{
                    linkToPortsArrayOfControl[2] = 1;
                    linkToPortsArrayOfControl[1] = 0;
                    linkToPortsArrayOfControl[0] = 0;
                    linkToPortsArrayOfControl[3] = 0;
                }
                colorize();
            }
        }

        RoundButton {
            id: portD
            text: "D"
            font.weight: Font.Medium
            width:Units.dp(44)
            height:Units.dp(44)
            font.pixelSize: Qt.application.font.pixelSize * 0.9
            Material.background: Material.primary
            enabled: _enabled && root.portDconnected
            opacity: enabled ? 1 : 0.7
            onClicked:{
                if(multipleChoose){
                    if(linkToPortsArrayOfControl[3] > 0)linkToPortsArrayOfControl[3] = 0;
                    else linkToPortsArrayOfControl[3] = 1;
                }
                else{
                    linkToPortsArrayOfControl[3] = 1;
                    linkToPortsArrayOfControl[1] = 0;
                    linkToPortsArrayOfControl[2] = 0;
                    linkToPortsArrayOfControl[0] = 0;
                }
                colorize();
            }
        }
    }

    Connections{
        target: cpp_Connector
        onExternalPortsIOchanged:{
            if(address == root.currentHubAddress){
                clear();
                portAconnected = list[0];
                portBconnected = list[1];
                portCconnected = list[2];
                portDconnected = list[3];
            }
        }
    }
}
