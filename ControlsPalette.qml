import QtQuick 2.0
import ".."

Item {
    id:root
    onWidthChanged: { width = Units.dp(width); }
    height: itemsHeight * 4 + 3 * row.spacing;

    property int itemsHeight: Units.dp(60)
    onItemsHeightChanged: { itemsHeight = Units.dp(itemsHeight); }

    Column {
        id: row
        spacing: Units.dp(10)
        anchors.fill: parent

        ControlsPalette_Delegate{
            id:item1
            height: root.itemsHeight
            width: parent.width
            label.text: ConstList_Text.control_name_steering
            icon.source: "qrc:/assets/icons/add.svg"
        }

        ControlsPalette_Delegate{
            id:item2
            height: root.itemsHeight
            width: parent.width
            label.text: ConstList_Text.control_name_moving
            icon.source: "qrc:/assets/icons/add.svg"
        }

        ControlsPalette_Delegate{
            id:item3
            height: root.itemsHeight
            width: parent.width
            label.text: ConstList_Text.control_name_linear
            icon.source: "qrc:/assets/icons/add.svg"
        }

        ControlsPalette_Delegate{
            id:item4
            height: root.itemsHeight
            width: parent.width
            label.text: ConstList_Text.control_name_slider
            icon.source: "qrc:/assets/icons/add.svg"
        }
    }
}
