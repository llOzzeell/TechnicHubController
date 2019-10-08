import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    clip: true

    function addProfile(){
        var data = {'name': "New"};
        profileModel.append(data);
    }

    function deleteProfile(index){
        if(index < profileModel.count)profileModel.remove(index);
    }

    ListView {
        id: profileView
        interactive: (contentItem.height > profileView.height)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.top: topBar.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        clip: false
        visible: true
        spacing: 10
        model: profileModel
        delegate: profileDelegate
    }

    Gui_TopBar{
        id:topBar
        labelText: "Профили"
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        onAddClick: addProfile();
    }

    ListModel{
        id:profileModel
    }

    Component{
        id:profileDelegate
        Gui_ProfileView_Delegate_Extension{
            isCurrent: ListView.isCurrentItem
            _index:index
        }
    }
}

