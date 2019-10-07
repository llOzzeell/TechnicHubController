import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    width:  parent.width
    height: parent.height
    Component.onCompleted: { /*androidFunc.setOrientation("landscape");*/ window.header.visible = false; }

    property bool editorMode: false

    property int objectCounter:0
    property var dynamicControlsArray:[]

    function createControl(control){
        var component = Qt.createComponent(control)
        var _x = width/2;
        var _y = height/2;
        var propObj = {"width":120, "x": _x - 12/2, "y": _y - 120/2, editorMode: root.editorMode, createIndex: objectCounter };
        var controlObject = component.createObject(root, propObj);
        dynamicControlsArray[objectCounter] = controlObject;
        objectCounter++;
    }

    function setEditorModeToAllControls(value){
        dynamicControlsArray.forEach(function(item){
            item.editorMode = value;
        })
    }

    function deleteControl(index){
        if(dynamicControlsArray[index] !== undefined ){ dynamicControlsArray[index].destroy(); dynamicControlsArray[index] = undefined; }
    }

    function loadProfile(){

    }

    function saveProfile(){
        console.log("-----------------------------")
        dynamicControlsArray.forEach(function(item){
            if(item !== undefined)console.log(item.width + " " + item.inverted + " " + item.port + " " + item.x + " " + item.y)
        })
        console.log("-----------------------------")
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: editorMode && controlsList.isVisible
        onClicked: if(controlsList.isVisible) controlsList.hide();
    }

    Gui_Profile_Button {
        id: editorButton
        x: 190
        text: "Редактор"
        z: 1
        opacity: 1
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        iconSource: "icons/editor.svg"
        visible: !editorMode
        onClicked: {
            editorMode = true;
            setEditorModeToAllControls(editorMode);
        }

        Behavior on visible {
            NumberAnimation{
                duration: 100
            }
        }
    }

    Gui_Profile_Button {
        id: saveButton
        x: 199
        text: "Сохранить"
        z: 1
        anchors.verticalCenter: editorButton.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        iconSource: "icons/save.svg"
        visible: editorMode
        onClicked: {
            editorMode = false;
            setEditorModeToAllControls(editorMode);
            if(controlsList.isVisible) controlsList.hide();
            saveProfile();
        }

        Behavior on visible {
            NumberAnimation{
                duration: 100
            }
        }
    }

    Gui_Profile_CircleButton{
        id:addButton
        width: 48
        anchors.top: parent.top
        anchors.topMargin: 10
        z: 1
        anchors.left: parent.left
        anchors.leftMargin: 10
        visible: editorMode && !controlsList.isVisible
        Behavior on visible {
            NumberAnimation{
                duration: 100
            }
        }

        onClicked: { controlsList.show(); }
    }

    Gui_Profile_Editor_ControlsList {
        id: controlsList
        y: hidedY
        z: 2
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter

        property bool isVisible: false
        property int hidedY: -height

        function hide(){
            controlsList.y = hidedY;
            isVisible = false;
        }

        function show(){
            controlsList.y = controlsList.spacing;
            isVisible = true;
        }

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }

        onControlChoosed: { createControl(element); hide(); }

    }

}
