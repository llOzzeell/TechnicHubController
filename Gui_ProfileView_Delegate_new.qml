import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id:root
    implicitHeight: 60
    implicitWidth: parent.width
    width: parent.width
    height: 60

    function removeClick(){
        console.log("REM")
        deleteProfile(index);
    }

    function editorClick(){
        console.log("EDIT")
        setOrientation("landscape");
        stackView.push(profile);
        stackView.currentItem.editorMode = true;
    }

    function runProfileClick(){
        console.log("RUN")
        setOrientation("landscape");
        stackView.push(profile);
        stackView.currentItem.editorMode = false;
    }

    Pane{
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 2
        opacity: 1
        visible: true
        anchors.fill: parent
        Material.elevation: 8
        Material.background: Style.remove_Red
    }

    Item {
        id: deleteItem
        y: 7
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 0

        property int deleteFieldWidth:60

        Gui_IconButton {
            id: gui_IconButton
            width: 32
            source: "icons/delete.svg"
            iconColor: Material.primary
            anchors.rightMargin: (deleteItem.deleteFieldWidth - width)/2
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                root.removeClick();
            }
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
        onFieldRightShiftChanged: console.log(fieldRightShift)
        property bool expanded: (fieldRightShift >= deleteItem.deleteFieldWidth)

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
            radius: 1
            visible: true
            anchors.fill: parent
        }


        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onPressed: {
                if(fieldItem.expanded){
                    collapseAnimation.start()
                    wasExpanded = true;
                    return;
                }
                if(!fieldItem.expanded)startPoint = mouseX;
            }
            onReleased: {
                if(fieldItem.fieldRightShift < minimumFingerSHift){
                    root.runProfileClick();
                    return;
                }

                if(!fieldItem.expanded)collapseAnimation.start()
                if(wasExpanded) wasExpanded = false;
            }

            property bool wasExpanded: false
            property int minimumFingerSHift:10
            property int shift:0
            property int startPoint:0

            onMouseXChanged: {
                if(pressed && !fieldItem.expanded && !wasExpanded){
                    shift = startPoint - mouseArea.mouseX;

                    if(shift < 0) shift = 0;
                    if(shift > deleteItem.deleteFieldWidth)shift = deleteItem.deleteFieldWidth;

                    if(shift >= 0 && shift <= deleteItem.deleteFieldWidth && shift >= minimumFingerSHift){
                        fieldItem.fieldRightShift = shift;
                    }
                }
            }
        }

        Gui_IconButton {
            id: gui_IconButton1
            width: 32
            source: "icons/profileEdit.svg"
            iconColor: Material.foreground
            anchors.rightMargin: (deleteItem.deleteFieldWidth - width)/2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            opacity: (100-(100/deleteItem.deleteFieldWidth * fieldItem.fieldRightShift))/100
            onClicked: {
                if(opacity === 1)root.editorClick()
            }
        }
    }


}
