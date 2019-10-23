import QtQuick 2.0
import QtQuick.Controls.Material 2.2

import ".."
import "qrc:/Controls"

Parent{
    id:root
    type: 2
    height: width/2
    property int minWidth: Units.dp(80)
    property int maxWidth: Units.dp(140)

    onSizeMinusClicked: {
        if(height > minWidth) {

            height -= Units.dp(20);
            width = height*2;
        }
    }

    onSizePlusClicked: {
        if(height < maxWidth) {

            height += Units.dp(20);
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
