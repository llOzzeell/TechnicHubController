import QtQuick 2.0
import ".."

Item {
    id:root
    readonly property string title: ConstList_Text.page_profiles

    Text {
        id: text1
        text: title
        font.pointSize: 20
        font.family: "Tahoma"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
    }

}
