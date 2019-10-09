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

    function setEditorModeToAllControls(value){
        dynamicControlsArray.forEach(function(item){
            if(item !== undefined)item.editorMode = value;
        })
    }

    property var typeArr:[controlModel.get(0).element,controlModel.get(1).element,controlModel.get(2).element]
    readonly property string name: "profile"
    property int index:-1
    onIndexChanged: loadProfile()

    property int objectCounter:0
    property var dynamicControlsArray:[]

    function createNewControl(control){

        var component = Qt.createComponent(control)
        var _x = width/2;
        var _y = height/2;
        var _width = 140;
        var _port1 = 0;
        var _port2 = 0;
        var _servo = 90;
        var _maxspeed = 100;
        var propObj = {
            editorMode: root.editorMode,
            createIndex: objectCounter,
            "width":_width,
            "x": _x,
            "y": _y,
            port1: _port1,
            port2: _port2,
            servoangle: _servo,
            maxspeed:_maxspeed };
        var controlObject = component.createObject(root, propObj);
        dynamicControlsArray[objectCounter] = controlObject;
        objectCounter++;
    }

    function deleteControl(index){
        if(dynamicControlsArray[index] !== undefined ){ dynamicControlsArray[index].destroy(); dynamicControlsArray[index] = undefined; }
    }

    function createWhileLoadControl(type, width, x, y, inverted, port1, port2, servoangle, maxspeed){

        var component = Qt.createComponent(typeArr[type])
        var propObj = {
            editorMode: root.editorMode,
            createIndex: objectCounter,
            "width":width,
            "x": x,
            "y": y,
            port1: port1,
            port2: port2,
            inverted:inverted,
            servoangle: servoangle,
            maxspeed:maxspeed };
        var controlObject = component.createObject(root, propObj);
        dynamicControlsArray[objectCounter] = controlObject;
        objectCounter++;
    }

    function saveProfile(){
        if(objectCounter > 0 && index >= 0){
            profilesController.clearControlInProfile(index);
            dynamicControlsArray.forEach(function(control){
               if(control !== undefined){
                   var inv = false; inv = (control.inverted > 0);
                   console.log("QML SAVE INVERTED: " + inv);
                   profilesController.addProfileControls(index, control.type, control.width, control.x, control.y, inv , control.port1, control.port2, control.servoangle, control.maxspeed);
               }
            })
            profilesController.saveToFile();
            index=-1;
        }
    }

    function loadProfile(){
        if(index >= 0){
            var count = profilesController.getControlsCounts(index);
            for(var i = 0; i < count; i++){
                var list = profilesController.getProfileControls(index,i);
                var inv = false; inv = (list[4] > 0);
                console.log("QML LOAD INVERTED: " + inv);
                createWhileLoadControl(list[0], list[1], list[2], list[3], inv, list[5], list[6], list[7], list[8]);
            }
        }
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
        height: 48
        rotation: 90
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        z: 2
        anchors.right: parent.right
        anchors.rightMargin: 10
        iconSource: "icons/save.svg"
        visible: editorMode
        onClicked: {
            editorMode = false;
            if(controlsList.isVisible) controlsList.hide();
            saveProfile();
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
        rotation: 90
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        z: 2
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
        x: root.width+5 - 91
        z: 2
        property bool isVisible: false
        anchors.verticalCenterOffset: 0

        Behavior on x{
            NumberAnimation{
                duration: 100
            }
        }

        function hide(){
            controlsList.x = root.width+5 - 91;
            isVisible = false;
        }

        function show(){
            controlsList.x = root.width - width + 91  - 5;
            isVisible = true;
        }

        rotation: 90
        anchors.verticalCenter: parent.verticalCenter

        onControlChoosed: { createNewControl(element); hide(); }
    }

}

