pragma Singleton
import QtQuick 2.0
import "."

QtObject{

    property string appName: font.name
    property FontLoader font: FontLoader {source: "qrc:/assets/fonts/Montserrat-Thin.ttf" }

}
