import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    width: 310
    height: profileView.height
    implicitHeight: 128
    implicitWidth: 300

    signal controlChoosed(int index, string element)

    readonly property int spacing : profileView.spacing

    function getControlName(index){
        if(index >=0 && index < controlModel.count){
            return controlModel.get(index).element
        }
    }

    Rectangle {
        id: rectangle
        color: "#7d3d3d"
        visible: false
        anchors.fill: parent
    }

    ListView {
        id: profileView
        height: profileView.contentHeight
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        interactive: false
        clip: false
        visible: true
        spacing: 4
        model: controlModel
        delegate:controlsListDelegate

    }

    Component{
        id:controlsListDelegate
        Gui_ControlList_Delegate{
            _name:name
            _icon:ico
            MouseArea{
                id:ma
                anchors.fill: parent
                onClicked:{
                    root.controlChoosed(index, controlModel.get(index).element);
                }
            }
        }
    }
}
