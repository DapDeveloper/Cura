import QtQuick 2.8
import QtQuick.Templates 2.1 as T

T.Switch {
    id: control

    //implicitWidth: indicator.implicitWidth
    //implicitHeight: background.implicitHeight

    background: Rectangle {
        width: 50
        height: 30
        color: "#909090"
        border.color: "#6F6F6F"
        visible:false
    }
    leftPadding: 4

    indicator: Rectangle {
        id: switchHandle
        width: 35
        height: 20

        anchors.top:parent.top
        anchors.left:parent.left
        anchors.topMargin:5
        anchors.leftMargin:5
        radius: 10 * 1.3
        color: "#F3F3F3"
        border.color: "#343434"
        border.width:1

        Rectangle {
            id: rectangle
            width: 20
            height: 20
            radius: 20
            color: "#ffffff"
            x:0
            border.color: "#343434"
            border.width:1
            //anchors.verticalCenter:parent.verticalCenter
            anchors.top:parent.top
            anchors.topMargin:0
        }

        states: [
            State {
                name: "off"
                when: !control.checked && !control.down
            },
            State {
                name: "on"
                when: control.checked && !control.down

                PropertyChanges {
                    target: switchHandle
                    color: "#079600"
                    border.color: "#343434"
                }

                PropertyChanges {
                    target: rectangle
                    x: parent.width - width
                    color:"#ffffff"
                  
                }
            },
            State {
                name: "off_down"
                when: !control.checked && control.down

                PropertyChanges {
                    target: rectangle
                    color: "#079600"
                }

            }
           /* State {
                name: "on_down"
                extend: "off_down"
                when: control.checked && control.down
                PropertyChanges {
                    target: rectangle
                    //x: parent.width - width
                    x: 2//parent.width - width
                    width:36.5
                    color: "#079600"
                }
                /*PropertyChanges {
                    target: switchHandle
                    color: "#079600"
                    border.color:"#079600"
                }
            }*/
        ]
    }
}