import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "."

ApplicationWindow {
    id: window
    visible: true

//    width: 400
//    height: width/9*18

    height: 400
    width: height/9*18

//    function setLandscape(value){
//        if(value){
//                width= 400
//                height= width/9*18
//        }
//        else{
//            height= 400
//            width= height/9*18
//        }
//    }

    Component.onCompleted:{ setTheme(false); }

    function setTheme(param){
            return param? setDark():setLight();
        }
    function setDark(){

            Material.theme = Material.Dark
            Material.background = Style.dark_background;
            Material.primary = Style.dark_primary;
            Material.accent = Style.dark_accent;
            Material.foreground = Style.dark_foreground
        }
    function setLight(){
            Material.theme = Material.Light
            Material.background = Style.light_background;
            Material.primary = Style.light_primary;
            Material.accent = Style.light_accent;
            Material.foreground = Style.light_foreground
        }

    header: Gui_TopBar{
        id:topBar
    }

    Component{
        id:finder
        Page_Finder{
            onDeviceClicked: { stackView.push(tryConnect); stackView.currentItem.start(); hubConnector.connectTo(index); }
        }
    }

    Component{
        id:tryConnect
        Page_Connect{
            onNoConnected: stackView.push(finder);
            onDeviceConnected: {stackView.push(profile); }
        }
    }

    Component{
        id:userProfile
        Page_UsersProfile{

        }
    }

    Component{
        id:settingsPage
        Page_SettingsPage{

        }
    }

    Component{
        id:profile
        Page_Profile{

        }
    }

    StackView{
        id:stackView
        anchors.fill: parent
        initialItem: profile
    }
}
