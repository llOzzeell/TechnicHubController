import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id: root

    function clearColor(){
        comboBox.currentIndex = 3;
    }

    SmartHub {
        id: smartHub
        x: 250
        anchors.top: rectangle.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: rectangle
        x: 229
        width: 130
        height: 26
        color: Material.primary
        radius: 13
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20

        Label {
            id: label
            width: 95
            text: qsTr("Подключено")
            anchors.bottomMargin: 2
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            opacity: 0.7
            font.capitalization: Font.MixedCase
            font.bold: true
            font.pointSize: 11
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: robotoCondensed
        }

        Image {
            id: image
            x: 128
            width: 24
            height: 24
            anchors.verticalCenterOffset: 0
            fillMode: Image.Stretch
            opacity: 0.7
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 1
            source: "icons/connected.png"
        }
    }

    Button {
        id: button
        y: 424
        text: qsTr("Отключить")
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pointSize: 10
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        onClicked: { smartHubConnector.disconnectFromDevice(); layout.setFinderPage();}
        font.family: robotoCondensed
        Material.background: Material.primary
    }

    ComboBox {
        id: comboBox
        x: 250
        width: 140
        height: 38
        font.family: robotoCondensed
        font.pointSize: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: smartHub.bottom
        anchors.topMargin: 20
        model:colorModel
        currentIndex: 3

        onCurrentIndexChanged: {

            if(currentIndex > 0 && currentIndex < 10){
                smartHubConnector.setRGBColor(currentIndex);
                smartHub.ledColor = colorArray[currentIndex];
            }
        }

        property var colorArray: [
            "#b4b4b4",
            Material.color(Material.Pink),
            Material.color(Material.Purple),
            Material.color(Material.Blue),
            Material.color(Material.LightBlue),
            Material.color(Material.Cyan),
            Material.color(Material.Green),
            Material.color(Material.Yellow),
            Material.color(Material.Orange),
            Material.color(Material.Red),
            Material.color(Material.Green, Material.Shade50)]

        ListModel{
            id:colorModel
            ListElement{
                text: "Выключен"
            }
            ListElement{
                text: "Розовый"
            }
            ListElement{
                text: "Фиолетовый"
            }
            ListElement{
                text: "Синий"
            }
            ListElement{
                text: "Голубой"
            }
            ListElement{
                text: "Циан"
            }
            ListElement{
                text: "Зеленый"
            }
            ListElement{
                text: "Желтый"
            }
            ListElement{
                text: "Оранжевый"
            }
            ListElement{
                text: "Красный"
            }
            ListElement{
                text: "Белый"
            }
        }
    }

}
