pragma Singleton
import QtQuick 2.0
import "."

QtObject{

    readonly property string appName: "Controlz"

    //Sidepanel items names
    readonly property string sidepanel_item1: qsTr("Profiles")
    readonly property string sidepanel_item2: qsTr("Connected devices")
    readonly property string sidepanel_item3: qsTr("Settings")
    readonly property string sidepanel_item4: qsTr("About")

    // Pages title
    readonly property string page_mainScreen: qsTr("Main screen")
    readonly property string page_connectedDevices: qsTr("Connected devices")
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

}
