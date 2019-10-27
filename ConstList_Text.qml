pragma Singleton
import QtQuick 2.0
import "."

QtObject{

    readonly property string appName: "Controlz"
    readonly property string appMotto: qsTr("Easy way to play!")

    //Sidepanel items names
    readonly property string sidepanel_item1: page_profiles
    readonly property string sidepanel_item2: page_connectedDevices
    readonly property string sidepanel_item3: page_settings
    readonly property string sidepanel_item4: page_about

    // Pages title
    readonly property string page_mainScreen: qsTr("Main screen")
    readonly property string page_connectedDevices: qsTr("Connected hubs")
    readonly property string page_finder: qsTr("Finder")
    readonly property string page_connector: qsTr("Connector")
    readonly property string page_profiles: qsTr("Profiles")
    readonly property string page_settings: qsTr("Settings")
    readonly property string page_about: qsTr("About")

    //Settings group title
    readonly property string settings_group_gui: qsTr("Interface")
    readonly property string settings_group_control: qsTr("Control")
    readonly property string settings_group_regional: qsTr("Regional settings")

    //Settings prop title
    readonly property string settings_prop_dark: qsTr("Dark theme")
    readonly property string settings_prop_tactile: qsTr("Tactile responce")
    readonly property string settings_prop_lang: qsTr("Language")

    //When new profile created, it named:
    readonly property string profile_new_name: qsTr("New profile")

    // Names of controls
    readonly property string control_name_steering: qsTr("Steering")
    readonly property string control_name_moving: qsTr("Moving")
    readonly property string control_name_buttons: qsTr("Buttons")
    readonly property string control_name_buttonsV: qsTr("Buttons vert.")
    readonly property string control_name_hslider: qsTr("Slider")
    readonly property string control_name_vslider: qsTr("Slider vert.")

    //Controls property page prop names
    readonly property string control_propertypage_ports: qsTr("Hub ports")
    readonly property string control_propertypage_hubs: qsTr("Connected hubs")
    readonly property string control_propertypage_inversion: qsTr("Inversion")
    readonly property string control_propertypage_servoangle: qsTr("Servo angle")
    readonly property string control_propertypage_speedlimit: qsTr("Motor speed")

    //EmptyProfile text
    readonly property string empty_profile_text: qsTr("Profile is empty. Add items in editor mode.")
}
