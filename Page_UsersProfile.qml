import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root
    width:  parent.width
    height: parent.height
    Component.onCompleted: {
        androidFunc.setOrientation("portraite");
        window.header.visible = false;
    }

    ListView {
        id: profileView
        height: root.height/3
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        clip: false
        visible: true
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter
        model: profileModel
        delegate: profileDelegate
    }

    ListModel{
        id:profileModel
        ListElement{
            name: "Профиль 1";
        }
        ListElement{
            name: "Профиль 2";
        }
        ListElement{
            name: "Профиль 3";
        }
    }

    Component{
        id:profileDelegate
        Gui_ProfileView_Delegate{
            _name: name

            MouseArea{
                id:mouseArea
                anchors.fill: parent
            }
        }
    }

}

