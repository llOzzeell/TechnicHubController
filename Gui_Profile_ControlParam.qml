import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
    id: root
    width: parent.width
    height: parent.height
    opacity: visible? 1 : 0
    enabled: true
    z: 1
    visible: true

    Behavior on opacity {
        NumberAnimation{
            duration: 100
        }
    }

    property bool someChanges:false
    property var link : this;
    function setLink(_link){

        someChanges = false;
        link = undefined;
        link = _link;

        setParamsVisibility(link.type);

        port1.currentIndex = link.port1;
        port2.currentIndex = link.port2;
        switchD.checked = link.inverted;
        servoA.value = link.servoangle;
        maxSpeed.value = link.maxspeed;
        switchO.checked = link.orientation
    }

    property var paramsVisibility:[false,false,false,false,false,false]
    function setParamsVisibility(type){
                                         // p1    p2   inv  ser  maxsp  ori
        if(type === 0) paramsVisibility = [true,false,true,true,false,false];
        if(type === 1) paramsVisibility = [true,false,true,false,false,false];
        if(type === 2) paramsVisibility = [true,false,true,false,true,false];
        if(type === 3) paramsVisibility = [true,false,true,false,true,true];
    }


    Rectangle {
        id: rectangle
        color: Material.primary
        opacity: 0.5
        anchors.fill: parent
    }

    ListModel{
        id:portModel
        ListElement{
            name: "A"
        }
        ListElement{
            name: "B"
        }
        ListElement{
            name: "C"
        }
        ListElement{
            name: "D"
        }
    }

    MouseArea {
        id: mouseArea
        z: 5
        anchors.fill: parent
    }

    Item {
        id: propsItem
        width: 260
        height: 260
        z: 8
        rotation: 90
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Pane{
            opacity: 0.8
            anchors.fill: parent
            Material.background: Material.background
            Material.elevation: 4
        }

        Gui_Profile_Button {
            id: gui_Profile_Button
            height: 26
            text: root.someChanges ? qsTr("Save")  :  qsTr("Close")
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            labelFontpointSize: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            onClicked: { root.visible = false; root.link.highlight(false); }
        }

        Column {
            id: column
            width: 240
            smooth: true
            enabled: true
            anchors.fill: parent
            spacing: 0

            Item {
                id: propItem_1
                width: parent.width
                height: 40
                visible: root.paramsVisibility[0]

                Gui_ComboBox_Custom{
                    id: port1
                    width: 60
                    height: parent.height
                    rotation: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    font.pointSize: 12
                    //visible: editorMode
                    model: portModel
                    onActivated: {  link.port1 = index; root.someChanges = true; }
                }

                Label {
                    id: label
                    text: qsTr("Port 1")
                    font.weight: Font.Light
                    font.pointSize: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: propItem_2
                width: parent.width
                height: 40
                visible: root.paramsVisibility[1]

                Gui_ComboBox_Custom {
                    id: port2
                    width: 60
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    model: portModel
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    //visible: editorMode
                    font.bold: true
                    font.pointSize: 12
                    onActivated: { link.port2 = index; root.someChanges = true; }
                }

                Label {
                    id: label2
                    text: qsTr("Port 2")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.weight: Font.Light
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }
            }

            Item {
                id: propItem_3
                width: parent.width
                height: 40
                visible: root.paramsVisibility[2]

                Label {
                    id: label1
                    text: qsTr("Inversion")
                    font.weight: Font.Light
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    anchors.left: parent.left
                    font.pointSize: 16
                }

                Switch {
                    id: switchD
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    onCheckedChanged: { link.inverted = checked; root.someChanges = true;}
                }
            }

            Item {
                id: propItem_4
                width: parent.width
                height: 40
                visible: root.paramsVisibility[3]

                Label {
                    id: label3
                    text: qsTr("Servo angle")
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    anchors.left: parent.left
                    font.weight: Font.Light
                    anchors.verticalCenter: parent.verticalCenter
                }

                SpinBox {
                    id: servoA
                    x: 86
                    y: 270
                    width: 120
                    height: 31
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    value: 90
                    to: 179
                    onValueChanged: { link.servoangle = value; root.someChanges = true; }
                }
            }

            Item {
                id: propItem_5
                width: parent.width
                height: 40
                visible: root.paramsVisibility[4]

                Label {
                    id: label4
                    text: qsTr("Speed limit")
                    anchors.leftMargin: 10
                    font.pointSize: 16
                    anchors.left: parent.left
                    font.weight: Font.Light
                    anchors.verticalCenter: parent.verticalCenter
                }

                SpinBox {
                    id: maxSpeed
                    width: 120
                    height: 31
                    from: 1
                    anchors.right: parent.right
                    value: 100
                    anchors.rightMargin: 0
                    to: 100
                    anchors.verticalCenter: parent.verticalCenter
                    onValueChanged: { link.maxspeed = value; root.someChanges = true; }
                }
            }

            Item {
                id: propItem_6
                width: parent.width
                height: 40
                visible: root.paramsVisibility[5]
                Label {
                    id: label5
                    text: qsTr("Vertical")
                    font.pointSize: 16
                    font.weight: Font.Light
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                Switch {
                    id: switchO
                    height: parent.height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    onCheckedChanged: { link.orientation = checked; root.someChanges = true; }
                }

            }

        }

    }
}

/*##^##
Designer {
    D{i:7;anchors_height:100;anchors_width:100}D{i:10;anchors_x:10}
}
##^##*/
