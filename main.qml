import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.0
import "qrc:/Pages"
import "qrc:/Controls"
import "qrc:/assets"
import "."

ApplicationWindow {
    id: window
    width: Screen.width
    height:Screen.height
    visible: true
    color: Material.background

    Component.onCompleted: {
        darkTheme(cpp_Settings.getDarkMode())
    }

    Connections{
        target:cpp_Settings
        onThemeChanged:{
            window.darkTheme(value);
        }
    }

    function darkTheme(value){
        Material.theme = value ? Material.Dark : Material.Light
        Material.background = value ? ConstList_Color.darkBackground : ConstList_Color.lightBackground
        Material.primary = value ? ConstList_Color.darkPrimary : ConstList_Color.lightPrimary
        Material.accent = value ? ConstList_Color.darkAccent : ConstList_Color.lightAccent
        Material.foreground = value ? ConstList_Color.darkForeground : ConstList_Color.lightForeground
        //ConstList_Color.titleForeground = value ? ConstList_Color.darkTitleForeground : ConstList_Color.lightTitleForeground
    }

    ///////////////////////////////////////////////

    Shortcut{
        sequences:["Backspace","Back"]
        onActivated: stackView.backPushed();
    }

    header: ToolBar {
        id: toolBar
        height: Units.dp(48)
        Material.background: Material.accent

        RowLayout {
            spacing: Units.dp(10)
            anchors.fill: parent
            anchors.leftMargin: Units.dp(15)
            anchors.rightMargin: Units.dp(15)

            ToolButton {
                id: toolButton
                height: Units.dp(48)
                width: Units.dp(48)
                icon.width: Units.dp(24)
                icon.height: Units.dp(24)
                font.weight: Font.Medium
                font.pixelSize: Qt.application.font.pixelSize
                icon.source: stackView.depth > 1 ? "qrc:/assets/icons/toolbar_back.svg" : "qrc:/assets/icons/toolbar_menu.svg"
                onClicked: {

                    if (stackView.depth > 1) {

                        a_back_click.start()
                        stackView.pop()
                    }
                    else {
                        a_forward_click.start()
                        drawer.open()
                    }
                }

                ParallelAnimation{
                    id:a_back_click
                    SequentialAnimation{
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:-180
                            duration: 200
                        }
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:0
                            duration: 1
                        }
                    }
                }

                ParallelAnimation{
                    id:a_forward_click
                    SequentialAnimation{
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:180
                            duration: 200
                        }
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:0
                            duration: 1
                        }
                    }
                }

            }

            Label {
                text: stackView.currentItem.title
                font.weight: Font.Medium
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: Material.foreground
                font.pixelSize: Qt.application.font.pixelSize  * 1.3
            }

            ToolButton{
                id:addButton
                height: Units.dp(48)
                width: Units.dp(48)
                icon.width: Units.dp(24)
                icon.height: Units.dp(24)
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                icon.source: setAddButtonIcon(stackView.currentItem.title)
                visible: addButtonVisibleParse(stackView.currentItem.isAddButtonVisible)
                onClicked:{
                    switch(stackView.currentItem.title){
                        case ConstList_Text.page_connectedDevices: stackView.push(component_Finder); break;
                            case ConstList_Text.page_profiles: cpp_Profiles.addNew(ConstList_Text.profile_new_name); break;
                        default : break;
                    }
                }

                function addButtonVisibleParse(value){
                    if(value !== undefined) return value;
                    else return false;
                }
                function setAddButtonIcon(title){
                    switch(title){
                        case ConstList_Text.page_connectedDevices: return "qrc:/assets/icons/connectedDevice.svg";
                            case ConstList_Text.page_profiles: return "qrc:/assets/icons/add.svg";
                        default : return "";
                    }
                }
            }
        }
    }

    CustomDrawer {
        id: drawer
        width: window.width * 0.66
        height: window.height
        dragMargin:Units.dp(20)
        Material.elevation: Units.dp(8)

        Behavior on position {
            NumberAnimation{ duration: 200 }
        }

        function collapse(){
            drawer.position = 0;
            drawer.visible = false;
        }

        SidePanel{
            anchors.fill: parent
            onClicked: {
                switch(page){
                case "connectedDevices": stackView.push(component_ConnectedDevices); break;
                case "profiles": stackView.push(component_Profiles); break;
                case "settings": stackView.push(component_Settings); break;
                case "about": stackView.push(component_About); break;
                }
                drawer.collapse();
            }
        }
    }

    StackView {
        id: stackView
        initialItem: component_MainScreen
        anchors.fill: parent

        function backPushed(){
            if (stackView.depth > 1) {

                a_back_click.start()
                stackView.pop()
            }
        }
    }

    Component{id:component_Profiles;Profiles{}}

    ConnectedDevices{id:component_ConnectedDevices}

    Component{id:component_Finder; Finder{}}

    Component{id:component_Connector;Connector{}}

    Component{id:component_MainScreen;MainScreen{}}

    Component{id:component_Settings;Settings{}}

    Component{id:component_About;About{}}
}
