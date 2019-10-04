import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root
    height: 40

    function clearColor(){
        comboBox.currentIndex = 3;
    }

    ComboBox {
        id: comboBox
        x: 227
        y: 140
        width: 133
        height: 38
        font.bold: true
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        font.family: robotoCondensed
        font.pointSize: 14
        model:colorModel
        currentIndex: 3

        onCurrentIndexChanged: {

            if(currentIndex >= 0 && currentIndex <= 10){
                smartHubOperator.hub_SetRGB(currentIndex)
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

    Label {
        id: label
        text: qsTr("Установка цвета RGB")
        font.pointSize: 14
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: robotoCondensed
    }


}
