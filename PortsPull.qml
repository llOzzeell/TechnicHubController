import QtQuick 2.0

Item {
    id:root
    Connections{
        target:cpp_Connector
        onAddDevicePortsPull:{
             console.log(" ")
            console.log(" ")
            console.log(" ")
            console.log(" ")
            console.log(" ")
            console.log("ADD: " + name + " " + portsCount)
            console.log(" ")
            console.log(" ")
            console.log(" ")
            console.log(" ")
            console.log(" ")
        }
        onDeleteDevicePortsPull:{
            console.log(" ")
           console.log(" ")
           console.log(" ")
           console.log(" ")
           console.log(" ")
           console.log("DELETE: " + name + " " + portsCount)
           console.log(" ")
           console.log(" ")
           console.log(" ")
           console.log(" ")
           console.log(" ")
        }
    }
}
