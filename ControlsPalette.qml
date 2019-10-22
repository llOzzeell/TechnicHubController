import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import ".."

Item {
    id:root
    opacity: 0

    Behavior on opacity{
        NumberAnimation{
            duration: 200
        }
    }

    readonly property bool isVisible: root.opacity == 1 ? true : false

    function show(){
        opacity = 1;
    }

    function hide(){
        opacity = 0;
    }

    Rectangle {
        id: background
        color: Material.background
        anchors.fill: parent
        opacity: 0.6
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            hide();
        }
    }
}
