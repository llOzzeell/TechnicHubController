import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import ".."
import "."
import "qrc:/assets"

Item {
    id:root
    implicitHeight: Units.dp(60)
    implicitWidth: parent.width
    width: parent.width
    height: Units.dp(60)

    property bool isCurrent: false
    onIsCurrentChanged:{ clearCard(); }

    function clearCard(){
        if(fieldItem.middleState || fieldItem.expanded)
        {
            collapseAnimation.start();
        }
    }

    signal clicked(int index)

    CustomPane{
        anchors.fill: parent
        opacity: 1
        visible: true
        Material.elevation: Units.dp(4)
        Material.background: Material.primary
    }

    Item {
        id: deleteItem
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 0

        property int deleteFieldWidth:Units.dp(60)

        Rectangle {
            id: redCard
            width: fieldItem.fieldRightShift+Units.dp(8)
            color: ConstList_Color.delete_Color
            radius: Units.dp(4)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible: fieldItem.fieldRightShift >= mouseArea.minimumFingerSHift
        }

        ToolButton {
            id: removeButton
            width: Units.dp(44)
            height: Units.dp(44)
            icon.width: Units.dp(32)
            icon.height: Units.dp(32)
            icon.source: "qrc:/assets/icons/delete.svg"
            anchors.rightMargin: (deleteItem.deleteFieldWidth - width)/2
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            onClicked: cpp_Profiles.deleteOne(index)
        }
    }

    Item {
        id: fieldItem
        anchors.right: parent.right
        anchors.rightMargin: fieldRightShift
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        property int fieldRightShift:0
        property bool expanded: (fieldRightShift >= deleteItem.deleteFieldWidth)
        property bool middleState: (fieldRightShift > 0)

        PropertyAnimation{
            id:collapseAnimation
            target:fieldItem
            property: "fieldRightShift"
            from: fieldItem.fieldRightShift
            to:0
            duration: 100
        }

        Rectangle {
            id: background_field
            color: Material.primary
            radius: Units.dp(4)
            visible: true
            anchors.fill: parent
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            z: 0
            property bool wasExpanded: false
            property int minimumFingerSHift:Units.dp(10)
            property int shift:0
            property int startPoint:0

            onPressed: {
                profilesView.currentIndex = index;
                if(fieldItem.middleState || fieldItem.expanded){
                    collapseAnimation.start()
                    wasExpanded = true;
                    return;
                }
                if(!fieldItem.expanded)startPoint = mouseX;
            }

            onReleased: {
                if(shift <= minimumFingerSHift){
                    if(!fieldItem.middleState)root.clicked(index)
                    else collapseAnimation.start();
                    return;
                }

                if(fieldItem.middleState && !fieldItem.expanded)collapseAnimation.start()
                if(wasExpanded) wasExpanded = false;
                profilesView.interactive = true;
            }

            onMouseXChanged: {
                if(pressed && !fieldItem.expanded && !wasExpanded){
                    shift = startPoint - mouseArea.mouseX;

                    if(shift < 0) shift = 0;
                    if(shift > deleteItem.deleteFieldWidth)shift = deleteItem.deleteFieldWidth;

                    if(shift >= 0 && shift <= deleteItem.deleteFieldWidth && shift >= minimumFingerSHift){
                        profilesView.interactive = false;
                        fieldItem.fieldRightShift = shift;
                    }
                }
            }
        }
    }

    TextInput {
            id: nameLabel
            color: Material.foreground
            text: name
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Units.dp(10)
            font.weight: Font.Medium
            font.family: "Roboto"
            cursorVisible: false
            font.pixelSize: Qt.application.font.pixelSize  * 1.3
            verticalAlignment: Text.AlignVCenter
            anchors.left: profIco.right
            maximumLength: 20

            property string previousName: ""
            readonly property string empty: qsTr("No name")

            onFocusChanged: {
                if(focus) previousName = text;
                if(!focus && text == ""){
                    if(previousName !== "") { text = previousName; }
                }
            }
            onAccepted: {
                if(text != ""){
                    cpp_Profiles.changeName(index, text)
                }
                else {
                    if(previousName !== "")text = previousName;
                }
                nameLabel.focus = false;
            }
        }

    Image {
        id: profIco
        width: Units.dp(32)
        height: Units.dp(32)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(10)
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/assets/icons/profile.svg"
        fillMode: Image.PreserveAspectFit
    }

    ColorOverlay{
        source:profIco
        color: Material.foreground
        smooth: true
        anchors.fill: profIco
    }


}
