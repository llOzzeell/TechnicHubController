import QtQuick 2.0
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
        stackView.currentItem.loadProfile(index);
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
                }
            }
        }
    }

    ListModel{
        id:profilesModel
    }

}
