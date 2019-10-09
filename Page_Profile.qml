import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root

    property bool editorMode: true
    onEditorModeChanged:{
        setEditorModeToAllControls(editorMode);
    }

    readonly property string name: "profile"
    property int index:-1
    onIndexChanged: console.log(index)
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
            if(item !== undefined)item.editorMode = value;
        })
    }

    function deleteControl(index){
        if(dynamicControlsArray[index] !== undefined ){ dynamicControlsArray[index].destroy(); dynamicControlsArray[index] = undefined; }
    }

    MouseArea {
        id: mouseArea
        z: 2
        anchors.fill: parent
        enabled: editorMode && controlsList.isVisible
        onClicked: if(controlsList.isVisible) controlsList.hide();
    }

    Gui_Profile_CircleButton {
        id: saveButton
        x: 199
        width: 48
        height: width
        anchors.top: parent.top
        anchors.topMargin: 10
        z: 2
        anchors.right: parent.right
        anchors.rightMargin: 10
        iconSource: "icons/save.svg"
        visible: editorMode
        onClicked: {
            editorMode = false;
            if(controlsList.isVisible) controlsList.hide();
            saveProfile();
            setOrientation("portraite");
            //androidFunc.setOrientation("portraite");
            stackView.pop();
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
        z: 2
        anchors.left: parent.left
        anchors.leftMargin: 10
        visible: editorMode && !controlsList.isVisible

//        Behavior on visible {
//            NumberAnimation{
//                duration: 100
//            }
//        }

        onClicked: { controlsList.show(); }
    }

    Gui_Profile_Editor_ControlsList {
        id: controlsList
        y: hidedY
        z: 2
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter

        property bool isVisible: false
        property int hidedY: -height-10

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

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
