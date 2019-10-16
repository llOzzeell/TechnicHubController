import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root

    property int profileIndex:-1
    property int createIndex: -1
    property bool editorMode: false

    property bool dark: appSett.getDarkMode()
    property bool tap : appSett.getTapTick()

    property int type
    property int port1
    property int port2
    property bool inverted
    property int maxspeed
    property int servoangle
    property bool orientation

    property alias scalePlusButtonOpacity: scalePlus.opacity
    property alias scaleMinusButtonOpacity: scaleMinus.opacity

    signal scaleMinus
    signal scalePlus

    function highlight(trigger){
        frame.visible = trigger;
    }

    function desaturate(color, value){
        var ic = color.toString()
        var r = parseInt(ic.substr(1, 2), 16)
        var g = parseInt(ic.substr(3, 2), 16)
        var b = parseInt(ic.substr(5, 2), 16)
        var hsl = rgbToHsl(r, g, b)
        hsl.s *= (value/100)
        return Qt.hsla(hsl.h, hsl.s, hsl.l, 1)
    }

    function rgbToHsl(r, g, b) {
      r /= 255
      g /= 255
      b /= 255
      var max = Math.max(r, g, b), min = Math.min(r, g, b)
      var h, s, l = (max + min) / 2
      if (max === min) {
        h = s = 0
      } else {
        var d = max - min
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
        switch (max) {
        case r:
          h = (g - b) / d + (g < b ? 6 : 0)
          break
        case g:
          h = (b - r) / d + 2
          break
        case b:
          h = (r - g) / d + 4
          break
        }
        h /= 6;
      }
      return {"h":h, "s":s, "l":l};
    }

    Item {
        id: editorItem
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        visible: editorMode
        z: 2
        anchors.fill: parent

        Row {
            id: circlebuttonPanel
            height: 38
            enabled: true
            anchors.bottom: parent.top
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 14

            Gui_Profile_CircleButton {
                id: deleteButton
                width: 40
                height: width
                backgroundColor: Style.remove_Red
                iconSource: "icons/delete.svg"

                onClicked: root.parent.deleteControl(createIndex)
            }

            Gui_Profile_CircleButton {
                id: scaleMinus
                width: 40
                backgroundColor: Material.primary
                iconSource: "icons/minus.svg"
                onClicked: root.scaleMinus()
            }

            Gui_Profile_CircleButton {
                id: scalePlus
                width: 40
                height: width
                backgroundColor: Material.primary
                iconSource: "icons/plus.svg"
                onClicked: root.scalePlus()
            }

            Gui_Profile_CircleButton {
                id: orienationButton
                width: 40
                height: width
                backgroundColor: Material.primary
                visible: (type === 3)
                iconSource: "icons/orientation.svg"
                onClicked:{ orientation = !orientation }
            }

            Gui_Profile_CircleButton {
                id: propButton
                width: 40
                height: width
                backgroundColor: Material.primary
                iconSource: "icons/profileEdit.svg"
                onClicked:{
                    root.highlight(true);
                    root.parent.openControlParam(root);
                }
            }

        }

        Rectangle {
            id: frame
            color: "#99f48fb1"
            radius: height/2
            border.color: Material.accent
            rotation: 0
            anchors.rightMargin: -border.width/2
            anchors.leftMargin: -border.width/2
            anchors.bottomMargin: -border.width/2
            anchors.topMargin: -border.width/2
            opacity: visible ? 1 : 0
            border.width: 4
            anchors.fill: parent
            visible:false

            Behavior on opacity {
                NumberAnimation{
                    duration:150
                }
            }
        }
    }

    Drag.active:  movingMouseArea.drag.active

    MouseArea {
        id: movingMouseArea
        z: 1
        anchors.fill: parent
        visible: editorMode
        drag.target: parent
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
