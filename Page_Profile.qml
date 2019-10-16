import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id:root
    Component.onCompleted: { setModeToAllControls(false); }

    property int ind_temp:-1
    onInd_tempChanged:{ profileParam.setIndex(ind_temp) }

    property int templateRotation:90

    QtObject{
        id:profileParam

        property int _index: root.ind_temp
        property bool _mode: false

        function getMode(){ console.log("getMode(): " + _mode); return _mode }

        function getIndex(){ console.log("getIndex(): " + _index); return _index }

        function setMode(value){
            _mode = value;
            root.setModeToAllControls(value);
        }

        function setIndex(value){
            _index = value;
            root.loadProfile(value);
        }
    }

    function setModeToAllControls(value){
        dynamicControlsArray.forEach(function(item){
            if(item !== undefined)item.editorMode = value;
        })
    }

    property var typeArr:[controlModel.get(0).element,controlModel.get(1).element,controlModel.get(2).element,controlModel.get(3).element]

    property int loadedControls: 0
    property int objectCounter:0
    property var dynamicControlsArray:[]

    function createNewControl(control){

        var component = Qt.createComponent(control)
        var _type;
        if(control === typeArr[0])_type = 0;
        if(control === typeArr[1])_type = 1;
        if(control === typeArr[2])_type = 2;
        if(control === typeArr[3])_type = 3;
        var _x = width/2;
        var _y = height/2;
        var _port1 = 0;
        var _port2 = 0;
        var _servo = 90;
        var _maxspeed = 100;
        var _orientation = false;
        var propObj = {
            profileIndex: profileParam.getIndex(),
            rotation:templateRotation,
            type:_type,
            editorMode: profileParam.getMode(),
            createIndex: objectCounter,
            "x": _x,
            "y": _y,
            port1: _port1,
            port2: _port2,
            servoangle: _servo,
            maxspeed:_maxspeed,
            orientation: _orientation};
        var controlObject = component.createObject(root, propObj);
        dynamicControlsArray[objectCounter] = controlObject;
        objectCounter++;
    }

    function deleteControl(_index){
        if(dynamicControlsArray[_index] !== undefined ){

            dynamicControlsArray[_index].destroy();
            dynamicControlsArray[_index] = undefined;
        }
    }

    function createWhileLoadControl(type, width, height, x, y, inverted, port1, port2, servoangle, maxspeed, orientation){

        var component = Qt.createComponent(typeArr[type])
        var propObj = {
            profileIndex: profileParam.getIndex(),
            rotation:templateRotation,
            type:type,
            editorMode: profileParam.getMode(),
            createIndex: objectCounter,
            "width":width,
//            "height":height,
            "x": x,
            "y": y,
            port1: port1,
            port2: port2,
            inverted:inverted,
            servoangle: servoangle,
            maxspeed:maxspeed,
            orientation: orientation};
        var controlObject = component.createObject(root, propObj);
        dynamicControlsArray[objectCounter] = controlObject;
        objectCounter++;
    }

    function saveProfile(_index){
        if(objectCounter > 0 && _index >= 0){
            profilesController.clearControlInProfile(profileParam.getIndex());
            dynamicControlsArray.forEach(function(control){
                if(control !== undefined){
                   // profilesController.addProfileControls(_index, control.type, control.width, control.height, control.x, control.y, (control.inverted > 0) , control.port1, control.port2, control.servoangle, control.maxspeed, (control.orientation > 0));
                   control.save();
                }
            })
            profilesController.saveToFile();
        }
    }

    function loadProfile(_index){
        if(_index >= 0){

            var count = profilesController.getControlsCounts(profileParam.getIndex());

            if(count === 0){

                emptyprofile.visible = true;
                return;
            }

            loadedControls = count;

            for(var i = 0; i < count; i++){

                var list = profilesController.getProfileControls(profileParam.getIndex(),i);

                createWhileLoadControl(list[0], list[1], list[2], list[3], list[4], (list[5] > 0), list[6], list[7], list[8], list[9], (list[10] > 0));
            }
        }
    }

    MouseArea {
        id: mouseArea
        z: 2
        anchors.fill: parent
        enabled: profileParam.getMode() && controlsList.isVisible
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
        visible: profileParam.getMode()
        onClicked: {
            if(!controlParam.visible){
                saveProfile(profileParam.getIndex());
                emptyprofile.visible = false;
                profileParam.setMode(false)
                if(controlsList.isVisible) controlsList.hide();
            }
        }
        backgroundColor: controlParam.visible ? Material.primary : Material.accent

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
        visible: profileParam.getMode()

        backgroundColor: controlParam.visible ? Material.primary : Material.accent

        Behavior on visible {
            NumberAnimation{
                duration: 100
            }
        }

        onClicked: {if(!controlParam.visible){ controlsList.show(); } }
    }

    Gui_Profile_Editor_ControlsList {
        id: controlsList
        z: 2
        property bool isVisible: false
        x: root.width + 5 - (width - height)/2
        anchors.verticalCenterOffset: 0

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: 200
            }
        }

        function hide(){
            controlsList.x = root.width + 5 - (width - height)/2
            isVisible = false;
            opacity = 0;
        }

        function show(){
            controlsList.x = root.width - 5 - (width - height)/2 - height
            isVisible = true;
            opacity = 1;
        }

        rotation: 90
        anchors.verticalCenter: parent.verticalCenter
        onControlChoosed: { createNewControl(element); hide(); }
    }

    Item {
        id: emptyprofile
        width: 360
        height: 90
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rotation: 90
        visible: false

        TextEdit {
            id: label
            color: Material.foreground
            text: qsTr("Profile is empty. Add items in editor mode.")
            textFormat: Text.PlainText
            readOnly: true
            font.family: "Roboto"
            anchors.fill: parent

            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 18
            font.weight: Font.Light
        }

        Gui_Profile_Button {
            id: gui_Profile_Button
            x: 120
            y: 82
            height: 32
            text: qsTr("Editor")
            labelFontpointSize: 16
            iconSource: ""
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked:  { parent.visible = false; profileParam.setMode(true); }
        }
    }

    function openControlParam(link){
        controlParam.setLink(link);
        controlParam.visible = true;
    }

    Gui_Profile_ControlParam{
        id: controlParam
        anchors.fill: parent
        visible: false
    }

    Gui_IconButton {
        id: editButton
        x: 207
        y: 3
        width: 32
        anchors.horizontalCenter: saveButton.horizontalCenter
        anchors.verticalCenter: saveButton.verticalCenter
        visible: !profileParam.getMode() && !emptyprofile.visible
        iconColor: Material.foreground
        source: "icons/profileEdit.svg"
        z: 2
        rotation: 90
        onClicked: if(!controlParam.visible){ profileParam.setMode(true); }
    }

    ListModel{
        id:controlModel
        ListElement{
            name: qsTr("Steering");
            ico: "icons/steering.svg"
            element:"Profile_Control_Steering.qml"
        }
        ListElement{
            name: qsTr("Moving");
            ico: "icons/moving.svg"
            element:"Profile_Control_Moving.qml"
        }
        ListElement{
            name: qsTr("Plain button");
            ico: "icons/linear.svg"
            element:"Profile_Control_HoldButtons.qml"
        }
        ListElement{
            name: qsTr("Slider");
            ico: "icons/linear.svg"
            element:"Profile_Control_Slider.qml"
        }
    }
}


