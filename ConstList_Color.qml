pragma Singleton
import QtQuick 2.0
import "."

QtObject{

    property color accentRed : "#f44336"
    property color accentBlue : "#29b6f6"
    property color accentYellow : "#cc8f00"
    property color accentGreen : "#00a273"


    property color darkBackground : "#202125"
    property color darkPrimary : "#525459"
    property color darkForeground : "#e9eaee"

    property color dark_controls_border_color: Qt.darker(darkPrimary, 1.4)

    property color lightBackground : "#e3e3e3"
    property color lightPrimary : "#fafafa"
    property color lightForeground : "#202123"

    property color light_controls_border_color: Qt.darker(lightPrimary, 1.4)

    property color controls_border_color

    property color delete_Color: "#ef5350"

    property color battery_green: accentGreen
    property color battery_yellow: accentYellow
    property color battery_red: accentRed

}
