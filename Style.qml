pragma Singleton
import QtQuick 2.9
import QtQuick.Controls.Material 2.4
import "."

QtObject{
    id:root

    // FONTS
    property string logoFont: font.name
    property FontLoader font: FontLoader { source: "fonts/Montserrat-Thin.ttf" }

    // COLORS

    property color dark_background: "#181818"
    property color dark_primary: "#292929"
    property color dark_accent: "#B5184B"
    property color dark_foreground: Material.color(Material.Grey, Material.Shade300);

    property color dark_control_border: "#302f2f"
    property color dark_control_background: "#474646"
    property color dark_control_primary: "#868686"
    property color dark_control_foreground: dark_foreground

    property color light_background: Material.color(Material.Grey, Material.Shade100);
    property color light_primary: Material.color(Material.Grey, Material.Shade300);
    property color light_accent: dark_accent
    property color light_foreground: Material.color(Material.Grey, Material.Shade900);

    property color light_control_border: "#b3b2b2"
    property color light_control_background: "#dad8d8"
    property color light_control_primary: "#f2f2f2"
    property color light_control_foreground: "#b3b2b2"

    property color remove_Red: Material.color(Material.Red, Material.Shade500);

    //SHADOW

    property int controlDropShadowValue:6
    property int joystickDropShadowValue:4
    property color controlDropShadowColor: "#aa000000"
}

