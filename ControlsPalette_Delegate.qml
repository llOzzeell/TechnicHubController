import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.3
import ".."

Item {
    id: root
    width: Units.dp(400)
    height: Units.dp(240)

    property bool invertPossible:false
    property bool steeringPossible:false
    property bool servoanglePossible:false
    property bool movingPossible:false
    property bool speedlimitPossible:false
    property bool tiltXPossible:false
    property bool tiltYPossible:false

    property int type:-1
    property int newWidth:0
    property int newHeight:0

    property string name
    property string sourceString
    onSourceStringChanged: {
        if(sourceString.length > 0){
            loader.setSource(sourceString, {"paletteMode":true, "editorMode":false})
        }
    }

    CustomPane {
        id: customCircle
        anchors.fill: parent
        color: Material.background
    }

    Label {
        id: label
        text: getConstText(root.name);
        font.weight: Font.DemiBold
        font.pixelSize: Qt.application.font.pixelSize * 1.3
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: element.top
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        function getConstText(name){
            switch(name){
            case "steering": return ConstList_Text.control_name_steering;
                case "moving": return ConstList_Text.control_name_moving;
                    case "buttons": return ConstList_Text.control_name_buttons;
                        case "buttonsV": return ConstList_Text.control_name_buttonsV;
                            case "hslider": return ConstList_Text.control_name_hslider;
                                case "vslider": return ConstList_Text.control_name_vslider;
                                    case "tilt": return ConstList_Text.control_name_tilt;
            }
        }
    }

    Column {
        id: column
        anchors.rightMargin: Units.dp(10)
        anchors.leftMargin: Units.dp(20)
        anchors.verticalCenter: element.verticalCenter
        spacing: Units.dp(10)
        anchors.left: parent.left
        anchors.right: element.left

        Item {
            id: inversion
            width: parent.width
            height: Units.dp(20)
            visible: invertPossible
            Label {
                id: label2
                height: Units.dp(20)
                text: qsTr("Inversion possible")
                fontSizeMode: Text.VerticalFit
                font.pixelSize: Qt.application.font.pixelSize
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
        }

        Item {
            id: steering
            width: parent.width
            height: Units.dp(20)
            visible: steeringPossible
            Label {
                id: label4
                height: Units.dp(20)
                text: qsTr("Motor rotation possible")
                fontSizeMode: Text.VerticalFit
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Qt.application.font.pixelSize
                horizontalAlignment: Text.AlignLeft
            }
        }

        Item {
            id: servoangle
            width: parent.width
            height: Units.dp(20)
            visible: servoanglePossible
            Label {
                id: label6
                height: Units.dp(20)
                text: qsTr("Changable rotation angle")
                fontSizeMode: Text.VerticalFit
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Qt.application.font.pixelSize
                horizontalAlignment: Text.AlignLeft
            }
        }

        Item {
            id: moving
            width: parent.width
            height: Units.dp(20)
            visible: movingPossible
            Label {
                id: label5
                height: Units.dp(20)
                text: qsTr("Motor run possible")
                fontSizeMode: Text.VerticalFit
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Qt.application.font.pixelSize
                horizontalAlignment: Text.AlignLeft
            }
        }

        Item {
            id: speedlimit
            width: parent.width
            height: Units.dp(20)
            visible: speedlimitPossible
            Label {
                id: label3
                height: Units.dp(20)
                text: qsTr("Motor speed limit possible")
                fontSizeMode: Text.VerticalFit
                font.pixelSize: Qt.application.font.pixelSize
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
        }

        Item {
            id: tiltX
            width: parent.width
            height: Units.dp(20)
            Label {
                id: label7
                height: Units.dp(20)
                text: qsTr("Shows lateral tilt (X axis)")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Qt.application.font.pixelSize
                fontSizeMode: Text.VerticalFit
                anchors.fill: parent
            }
            visible: tiltXPossible
        }

        Item {
            id: tiltY
            width: parent.width
            height: Units.dp(20)
            Label {
                id: label8
                height: Units.dp(20)
                text: qsTr("Shows a longitudinal tilt (Y axis)")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Qt.application.font.pixelSize
                fontSizeMode: Text.VerticalFit
                anchors.fill: parent
            }
            visible: tiltYPossible
        }
    }

    Item {
        id: element
        width: root.height/1.5
        height: width
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(20)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Units.dp(20)

        Loader{
            id: loader
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    signal clicked(int type, string path, int width, int height)

    MouseArea {
        id: mouseArea
        z: 1
        anchors.fill: parent
        onClicked: {
            root.clicked(type, sourceString, newWidth, newHeight)
        }
    }
}
