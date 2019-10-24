import QtQuick 2.0
import QtQuick.Controls.Material 2.2

import ".."
import "qrc:/Controls"

Parent{
    id:root
    height: width/4

    type: 3   
    property int minWidth: Units.dp(60)
    property int maxWidth: Units.dp(80)

    Component.onCompleted:{
        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.multichoose = true;
    }

    onSizeMinusClicked: {
        if(height > minWidth) {

            height -= Units.dp(10);
            width = height*5;
        }
    }

    onSizePlusClicked: {
        if(height < maxWidth) {

            height += Units.dp(10);
            width = height*5;
        }
    }

    CustomCircle{
        id:background
        anchors.fill: parent
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color
    }
}
