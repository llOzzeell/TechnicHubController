import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    width: 310
    height: 140
    implicitHeight: 128
    implicitWidth: 300

    signal controlChoosed(int index, string element)

    readonly property int spacing : profileView.spacing

    Rectangle {
        id: rectangle
        color: Material.primary
        visible: false
        anchors.fill: parent
    }

    ListView {
        id: profileView
        anchors.fill: parent
        interactive: false
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickDirection
        clip: false
        visible: true
        spacing: 4
        model: profileModel
        delegate:Item {
            height: 32
            width:parent.width

            Rectangle {
                id: background
                color: Material.accent
                radius: 2
                anchors.fill: parent
            }

            Image {
                id: icon
                width: 24
                height:width
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                fillMode: Image.PreserveAspectFit
                source: ico
                ColorOverlay{
                    source: icon
                    color: Style.dark_background
                    anchors.fill: parent
                }
            }

            Label {
                id: label
                text: name
                font.bold: false
                font.family: Style.robotoCondensed
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                font.pointSize: 14
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: 10
                color: Style.dark_background
            }

            MouseArea{
                id:ma
                anchors.fill: parent
                onClicked: root.controlChoosed(index, profileModel.get(index).element);
            }

        }


    }


    ListModel{
        id:profileModel
        ListElement{
            name: "Рулевое управление";
            ico: "icons/steering.svg"
            element:"Profile_Control_Steering.qml"
        }
        ListElement{
            name: "Управление передвижением";
            ico: "icons/moving.svg"
            element:"Profile_Control_Moving.qml"
        }
        ListElement{
            name: "Линейная кнопка";
            ico: "icons/linear.svg"
            element:"Profile_Control_HoldButtons.qml"
        }
    }


}
