
import QtQuick 2.7
import QtQuick.Templates 2.0 as T
import "."

T.Slider {

    id: control
    implicitWidth: 200
    implicitHeight: 26
    property var handleColor1:"#079600"
    property var handleColor2:"#078A00"
    
    snapMode: T.Slider.NoSnap
    handle: Rectangle {
        x: control.visualPosition * (control.width - width)
        y: (control.height - height) / 2
        width: 20
        height: 15
        radius: 5
        color: control.pressed ? handleColor1 : handleColor2
        //border.color: UIStyle.colorQtGray7
    }
    background: Rectangle {
        y: (control.height - height) / 2
        height: 4
        radius: 2
        color: "#ededed"
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#ededed"
            radius: 2
        }
    }
}