import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "."

ApplicationWindow {
    id: window
    visible: true

    width: 400
    height: width/9*18
    color: Material.background

    function setOrientation(value){
        if(value === "landscape")setLandscape();
        else setPortraite();
    }

    function setPortraite(){
        window.width = 400
        window.height = width/9*18
    }

    function setLandscape(){
        window.height = 400
        window.width = height/9*18
    }

    Component.onCompleted:{ setTheme(true); androidFunc.setOrientation("portraite"); }

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

    Shortcut {
        sequence: "Back"
        onActivated:{
            var prevoius = stackView.pop()
            if(prevoius.name === "profile"){
                setOrientation("P"); androidFunc.setOrientation("portraite");
            }
        }
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
        }
    }

    Component{
        id:usrProfiles
        Page_UsersProfile{
            id:usrProfilesItem
        }
    }

    Component{
        id:profile
        Page_Profile{
            id:profileItem
        }
    }
}
