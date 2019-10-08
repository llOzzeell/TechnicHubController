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
        if(index >=0 && index < profileModel.count){
            return profileModel.get(index).element
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
        height: profileView.count * profileView.currentItem.delegateHeight + profileView.spacing * (profileView.count-1)
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
        model: profileModel
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
                onClicked: root.controlChoosed(index, profileModel.get(index).element);
            }
        }
    }

    ListModel{
        id:profileModel
        ListElement{
            name: "Рулевое управление";
            ico: "icons/steering.svg"
            element:"Profile_Control_Steering.qml"
        }
        ListElement{
            name: "Управление передвижением";
            ico: "icons/moving.svg"
            element:"Profile_Control_Moving.qml"
        }
        ListElement{
            name: "Линейная кнопка";
            ico: "icons/linear.svg"
            element:"Profile_Control_HoldButtons.qml"
        }
    }



}
