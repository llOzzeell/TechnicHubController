import QtQuick 2.0
import QtQuick.Controls.Material 2.2

import ".."
import "qrc:/Controls"

Parent{
    id:root
    height: width/2

    type: 2
    property int minWidth: Units.dp(90)
    property int maxWidth: Units.dp(140)

    Component.onCompleted:{
        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.speedlimit = true;

    }

    onSizeMinusClicked: {
        if(height > minWidth) {

            height -= Units.dp(10);
            width = height*2;
        }
    }

    onSizePlusClicked: {
        if(height < maxWidth) {

            height += Units.dp(10);
            width = height*2;
        }
    }

    CustomCircle{
        id:background
        anchors.fill: parent
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color
    }
}
