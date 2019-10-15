import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "."

ApplicationWindow {
    id: window
    visible: true
    color: "#000000"

//    width : 400
//    height: width/9 * 18

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

    signal backPushed

    Shortcut {
        sequence: "Back"
        onActivated:{
            backPushed();
            if(stackView.depth  > 0) stackView.pop();
        }
    }

    Rectangle {
        id: rectangle
        color: Material.background
        anchors.fill: parent
    }

    StackView{
        id:stackView
        anchors.fill: parent
        clip: true
        initialItem: finder
    }

    function wasConnected(){
        stackView.clear()
        stackView.push(userProfiles);
    }

    Component{
        id:finder
        Page_Finder{
        }
    }

    Component{
        id:connect
        Page_Connect{
        }
    }

    Component{
        id:userProfiles
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
            interval: 2000
            repeat: false
            running: true
            onTriggered: pageLoader.source = "";
        }
    }
}

