pragma Singleton
import QtQuick 2.0
import "."

QtObject{


    property color darkBackground : "#202125"
    property color darkPrimary : "#525459"
    property color darkAccent : "#00a273"
    property color darkForeground : "#e9eaee"

    property color dark_controls_border_color: Qt.darker(darkPrimary, 1.4)
    //property color darkTitleForeground : "#e9eaee"

    property color lightBackground : "#E0E0E0"
    property color lightPrimary : "#dbdce0"
    property color lightAccent : "#00875f"
    property color lightForeground : "#202123"

    property color light_controls_border_color: Qt.darker(lightPrimary, 1.4)
    //property color lightTitleForeground : "#202123"


    property color controls_border_color
    //property color titleForeground: "#e9eaee"

    property color delete_Color: "#ef5350"

}
