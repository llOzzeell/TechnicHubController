import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "qrc:/assets"
import ".."

Item {
    id:root

    implicitWidth:Units.dp(44)
    implicitHeight:Units.dp(44)
    width:Units.dp(44)
    height: width

    property alias color:colorOverlay.color
    property int rssi:0
    onRssiChanged: {
        if(rssi < 0 && rssi > -127){
            setIcon(Math.abs(root.rssi));
        }
        if(rssi > 0)setIcon(0);
    }

    function setIcon(value){
        if(value >= 0 && value < 70) image.source = "qrc:/assets/icons/rssi_4.svg";
            if(value >= 70 && value < 85) image.source = "qrc:/assets/icons/rssi_3.svg";
                if(value >= 85 && value < 100) image.source = "qrc:/assets/icons/rssi_2.svg";
                    if(value >= 100 && value < 115) image.source = "qrc:/assets/icons/rssi_1.svg";
                        if(value >= 115 && value < 127) image.source = "qrc:/assets/icons/rssi_0.svg";
    }

    Image {
        id: image
        source: "qrc:/assets/icons/rssi_0.svg"
        anchors.fill: parent
        anchors.margins: Units.dp(4)
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    ColorOverlay{
        id:colorOverlay
        source:image
        smooth: true
        anchors.fill: image
    }

}
