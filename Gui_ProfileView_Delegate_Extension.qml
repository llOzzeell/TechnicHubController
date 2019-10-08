import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Gui_ProfileView_Delegate{
    id: root
    height: 40
    _name: name

    property bool isCurrent:false
    onIsCurrentChanged: {
        if(!isCurrent && delItem.isExpanded) delItem.collapse()
    }

    function forseCollapse(){
        if(delItem.isExpanded) delItem.collapse();
    }

    MultiPointTouchArea{
        id:mouseArea
        maximumTouchPoints: 1
        touchPoints: [ TouchPoint { id: point1 } ]
        onPressed:{
            profileView.currentIndex = _index
            slideToDelete(true);
        }
        onReleased: {
            slideToDelete(false);
        }

        property int startPoint:0

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.top: parent.top

        function slideToDelete(pressTrigger){
            if(pressTrigger){
                startPoint = point1.x
            }
            else{
                if(startPoint - point1.x > 100 && !delItem.isExpanded){

                    delItem.expand();
                }
                else{
                    if(delItem.isExpanded) { delItem.collapse(); }
                    else{
                        stackView.push(profile);
                        stackView.currentItem.editorMode = false;
                        startPoint = 0;
                    }
                }
            }
        }

    }

    ColorOverlay{
        source: image
        color: Material.foreground
        anchors.fill: image
        smooth: true
    }

    Image {
        id: image
        width: 26
        height: width
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        source: "icons/profileEdit.svg"
        visible: false
    }

    MouseArea{
        id: editorModeMA
        width: image.width + 12
        height: width
        z: 1
        anchors.horizontalCenter: image.horizontalCenter
        anchors.verticalCenter: image.verticalCenter
        onClicked:{
            profileView.currentIndex = _index
            stackView.push(profile);
            stackView.currentItem.editorMode = true;
        }
    }

    Item {
        id: delItem
        width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        visible: width > 0

        property bool isExpanded: width === showed

        readonly property int showed: 60

        function expand(){
            delItem.width = delItem.showed;
        }

        function collapse(){
            delItem.width = 0;
        }

        Behavior on width{
            NumberAnimation{
                duration: 150
            }
        }
        z: 2

        Rectangle {
            id: deleteRectangle
            color: Material.color(Material.Red, Material.Shade500)
            radius: 2
            anchors.rightMargin: 0
            visible: true
            anchors.fill: parent
        }

        Rectangle {
            id: rectangle1
            width: 2
            color: Material.background
            anchors.right: parent.right
            anchors.rightMargin: 58
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        ColorOverlay {
            color: Material.foreground
            visible: delItem.isExpanded
            anchors.fill: delIco
            smooth: true
            source: delIco
        }


        Image {
            id: delIco
            width: 26
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "icons/remove48.svg"
            visible: false
        }


        MouseArea {
            id: editorModeMA1
            width: image.width + 12
            height: width
            z: 2
            anchors.verticalCenter: delIco.verticalCenter
            anchors.horizontalCenter: delIco.horizontalCenter
            onClicked: if(delItem.isExpanded)deleteProfile(index);
        }



    }
}
