import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "."

ApplicationWindow {
    id: window
    visible: true
    color: Material.background

    width: 400
    height: width/9*18

    Component.onCompleted:{
        setDarkTheme(appSett.getDarkMode());
        //androidFunc.setOrientation("portraite");
    }

    property bool currentDarkTheme: true
    function setDarkTheme(param){
        currentDarkTheme = param;
        appSett.setDarkMode(param);
        return param? setDark():setLight();
    }
    function setDark(){

        Material.theme = Material.Dark
        Material.background = Style.dark_background;
        Material.primary = Style.dark_primary;
        Material.accent = Style.dark_accent;
        Material.foreground = Style.dark_foreground

        return 0;
    }
    function setLight(){
        Material.theme = Material.Light
        Material.background = Style.light_background;
        Material.primary = Style.light_primary;
        Material.accent = Style.light_accent;
        Material.foreground = Style.light_foreground

        return 0;
    }

    Shortcut {
        //sequence: "Back"
        sequence: "Backspace"
        onActivated:{
            stackView.pop();
            if(swipe.currentIndex == 0){
                Qt.quit();
            }
        }
    }

    ListModel{
        id:controlModel
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

    SwipeView{
        id:swipe
        anchors.fill: parent
        clip: true
        visible: true
        interactive: false
        currentIndex: 1

        Page_Finder{
            id:finder
            clip: true
            onDeviceWasConnected: {
                swipe.incrementCurrentIndex();
            }

        }

        StackView{
            id:stackView
            clip: true
            initialItem: usrProfiles
        }
    }

    Component{
        id:usrProfiles
        Page_UsersProfile{
        }
    }

    Component{
        id:profile
        Page_Profile{
        }
    }

    Component{
        id:appSettings
        Page_AppSettings{

        }
    }

    Loader{
        id:pageLoader
        anchors.fill: parent
        //source: {"qrc:/Gui_AppLoader.qml"}
        Timer{
            interval: 1200
            repeat: false
            running: true
            onTriggered: pageLoader.source = "";
        }
    }

}
