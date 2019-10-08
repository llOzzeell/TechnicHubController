import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Gui_ProfileView_Delegate{
    id: root
    height: 60
    _name: name

    property bool isCurrent:false
    width: 400
    onIsCurrentChanged: {
        if(!isCurrent && delItem.isExpanded) delItem.collapse()
    }

    function forseCollapse(){
        if(delItem.isExpanded) delItem.collapse();
    }

    onNameLabelClicked: {
        profileView.currentIndex = _index
        root.nameLabelVisible = false;
        nameInput.visible = !root.nameLabelVisible
        nameInput.text = name;
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
        anchors.leftMargin: nameLabelWidth
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
                if(startPoint - point1.x > 20 && !delItem.isExpanded){

                    delItem.expand();
                }
                else{
                    if(delItem.isExpanded) { delItem.collapse(); }
                    else{
                        setOrientation("landscape");
                        androidFunc.setOrientation("landscape");
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
            setOrientation("landscape");
            androidFunc.setOrientation("landscape");
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
            color: Style.remove_Red
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
            width: 20
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

    TextField {
        id: nameInput
        width: 348
        height: 43
        z: 3
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        visible: false
    }

    Gui_Profile_CircleButton {
        id: gui_Profile_CircleButton
        width: 32
        z: 3
        iconSource: "icons/accepted.svg"
        anchors.left: nameInput.right
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        visible: nameInput.visible
        onClicked: {
            if(nameInput.text !== ""){
                root.nameLabelVisible = true;
                nameInput.visible = !root.nameLabelVisible
                name = nameInput.text;
                nameInput.text = "";
                changeName(name);
            }
            else{
                root.nameLabelVisible = true;
                nameInput.visible = !root.nameLabelVisible
                nameInput.text = "";
            }
        }
    }
}

/*##^##
Designer {
    D{i:3;anchors_height:200;anchors_width:200}D{i:12;anchors_height:200;anchors_width:200;anchors_x:21}
}
##^##*/
