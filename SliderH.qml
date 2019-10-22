import QtQuick 2.0
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.2

import ".."
import "qrc:/Controls"

Parent{
    id:root
    type: 3
    height: width/4
    property int minWidth: Units.dp(60)
    property int maxWidth: Units.dp(120)

    onSizeMinusClicked: {
        if(height > minWidth) {

            height -= Units.dp(20);
            width = height*5;
        }
    }

    onSizePlusClicked: {
        if(height < maxWidth) {

            height += Units.dp(20);
            width = height*5;
        }
    }

    CustomCircle{
        id:background
        anchors.fill: parent
        borderWidth: Units.dp(8)
        borderColor: ConstList_Color.controls_border_color
    }

    MultiPointTouchArea {
        id:touchArea
        anchors.fill: parent
        maximumTouchPoints: 1
        touchPoints: [TouchPoint{id:tpoint}]

        property var startPoint:{"x":0, "y":0}

        onPressed: {
            moving(true, false, editorMode);
        }

        onTouchUpdated: {
            moving(false, true, editorMode);
        }

        function moving(_pressed, _touchUpdated, _editorMode){
            if(_editorMode){
                if(_pressed){
                    touchArea.startPoint.x = tpoint.x;
                    touchArea.startPoint.y = tpoint.y;
                }
                if(_touchUpdated){
                    var delta = Qt.point(tpoint.x-startPoint.x, tpoint.y-startPoint.y)

                    var newX = root.x + delta.x

                    if(newX < 0) newX = 0;
                    if(newX > Screen.width - root.width) newX = Screen.width - root.width;

                    if(newX > 0 && newX < Screen.width - root.width){
                       root.x += delta.x;
                    }

                    var newY = (root.y + delta.y)

                    if(newY < root.buttonUnitHeight) newY = root.buttonUnitHeight;
                    if(newY > Screen.height - root.height) newY = Screen.height - root.height;

                    if(newY > root.buttonUnitHeight && newY < Screen.height - root.height){
                       root.y += delta.y;
                    }
                }
            }
        }
    }
}
