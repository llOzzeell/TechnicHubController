import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 300
    height: (width/9)*18

    Component.onCompleted: {
        Material.background = Material.color(Material.Grey, Material.Shade900);
        Material.primary = Material.color(Material.Grey, Material.Shade700);
        Material.accent = Material.color(Material.Teal, Material.Shade500);
    }

    property string robotoCondensed: regularFont.name
    property FontLoader regularFont: FontLoader { source: "fonts/RobotoCondensed-Regular.ttf" }

    SwipeView{
        id:layout
        interactive: false
        anchors.fill: parent
        currentIndex: 0

        FinderPage{
            id:finderPage
        }

        ConnectionLoader{
            id:loaderPage
        }

        HubPage{
            id:hubPage
        }

        function setLoaderPage(){
            loaderPage.opacity = 1;
            layout.currentIndex = 1;
        }

        function setFinderPage(){
            layout.currentIndex = 0;
            finderPage.clear();

        }

        function setHubPage(){
            layout.currentIndex = 2;
            loaderPage.opacity = 0;
            hubPage.clearColor();
        }

    }

}
