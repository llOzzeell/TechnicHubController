import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "."

ApplicationWindow {
    id: window
    visible: true
    color: "#000000"

    property bool tapTick: false

    Component.onCompleted:{
        setDarkTheme(appSett.getDarkMode());
        androidFunc.setOrientation("portraite");
    }

    onClosing: {
        if(stackView.depth > 1){
            close.accepted = false
            stackView.pop();
        }else{
            return;
        }
    }

    function setDarkTheme(param){
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

    function setColorToStatusBar(color){
        androidFunc.setStatusBarColor(color);
        window.color = color;
    }

    Shortcut {
        sequence: "Back"
        onActivated:{
            if(stackView.depth  > 0) stackView.pop();
            if(swipe.currentIndex <= 0)return 0;
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

    Rectangle {
        id: rectangle
        color: Material.background
        anchors.fill: parent
    }

    SwipeView{
        id:swipe
        anchors.fill: parent
        clip: true
        visible: true
        interactive: false
        currentIndex: 0

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

//            pushEnter: Transition {
//                    PropertyAnimation {
//                        property: "opacity"
//                        from: 0
//                        to:1
//                        duration: 200
//                    }
//                }
//            pushExit: Transition {
//                    PropertyAnimation {
//                        property: "opacity"
//                        from: 1
//                        to:0
//                        duration: 200
//                    }
//                }
//            popEnter: Transition {
//                    PropertyAnimation {
//                        property: "opacity"
//                        from: 0
//                        to:1
//                        duration: 200
//                    }
//                }
//            popExit: Transition {
//                    PropertyAnimation {
//                        property: "opacity"
//                        from: 1
//                        to:0
//                        duration: 200
//                    }
//                }
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
        source: {"qrc:/Gui_AppLoader.qml"}
        Timer{
            interval: 2200
            repeat: false
            running: true
            onTriggered: pageLoader.source = "";
        }
    }
}
