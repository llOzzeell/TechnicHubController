import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    clip: true
    Component.onCompleted: {
        var list = profilesController.getProfilesNames();
        list.forEach(function(name){loadProfile(name)})
    }

    function loadProfile(name){
        var data = {'name': name};
        profileModel.append(data);
    }

    function addProfile(){
        var defaultName = "New profile";
        var data = {'name': defaultName};
        profileModel.append(data);
        profilesController.addProfile(defaultName);
    }

    function deleteProfile(index){
        if(index < profileModel.count)profileModel.remove(index);
        console.log(profilesController.deleteProfile(index))
    }

    function changeName(value){
        profileModel.setProperty(profileView.currentIndex, "name", value );
    }

    ListView {
        id: profileView
        interactive: true
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
        onCountChanged: currentIndex = -1
    }

    Gui_TopBar{
        id:topBar
        labelText: "Профили" + " (" + profileModel.count + ")"
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
        Gui_ProfileView_Delegate_new{
            isCurrent: ListView.isCurrentItem
        }
    }
}

