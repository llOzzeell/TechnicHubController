import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import ".."
import "qrc:/Controls"

Item {
    id:root
    readonly property string title: ConstList_Text.page_profiles
    readonly property bool isAddButtonVisible: true

    Component.onCompleted: {
        var list = cpp_Profiles.getProfilesList();
        list.forEach(function(name){
            var data = {'name': name};
            profilesModel.append(data);
        })
    }

    Connections{
        target:cpp_Profiles
        onProfilesUpdated:{
            profilesModel.clear();
            var list = cpp_Profiles.getProfilesList();
            list.forEach(function(name){
                var data = {'name': name};
                profilesModel.append(data);
            })
        }
    }

    function profileClicked(index){
        stackView.push(component_ProfilePlayer);
        if(!cpp_Controller.isNotEmpty())stackView.currentItem.editorMode = true;
        stackView.currentItem.loadProfile(index);
    }

    function deleteProfile(index){
        cpp_Profiles.deleteProfile(index)
    }

    ListView{
        id:profilesView
        anchors.fill: parent
        spacing: Units.dp(10)
        anchors.margins: Units.dp(10)
        model:profilesModel
        onCountChanged: currentIndex = -1
        delegate: Component{
            Profiles_Delegate{
                isCurrent: ListView.isCurrentItem
                Component.onCompleted: {
                    clicked.connect(root.profileClicked)
                    deleteClicked.connect(root.deleteProfile)
                }
            }
        }
    }

    Label {
        id: label
        text: qsTr("No profiles.")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: Qt.application.font.pixelSize * 1.5
        visible: profilesModel.count == 0
        opacity: 0.5
    }

    ListModel{
        id:profilesModel
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
