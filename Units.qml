pragma Singleton
import QtQuick 2.2
import QtQuick.Window 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0

QtObject {

    property real pixelRatio: dpi > 120 ? 2.2 : 1
    property int dpi: Screen.pixelDensity * 25.4

    function dp(x) {
        if(dpi < 120) return x;
        else return x*(dpi/160);
    }

    function dpBack(dp){
        if(dpi < 120) return x;
        else return (160 * dp)/dpi;
    }

    function em(x) {
        return Math.round( x * TextSingleton.font.pixelSize );
    }

}
