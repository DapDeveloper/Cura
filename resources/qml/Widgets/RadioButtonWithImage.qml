// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.0 as Cura


//
// Cura-style RadioButton.
//
    RadioButton
    {
        id: radioButton
        font: UM.Theme.getFont("default")
        property var imageSRC:"../images/printers/leonardo.png"
        property var imgH:400
        
        property var textV:""
        width:400
        height:400
        background: Item
        {
            anchors.fill: parent
        }
        indicator: Rectangle
        {
            implicitWidth:0 //UM.Theme.getSize("radio_button").width
            implicitHeight:0 //UM.Theme.getSize("radio_button").height
            anchors.verticalCenter: parent.verticalCenter
            anchors.alignWhenCentered: false
            radius: 0
            border.width: 0//UM.Theme.getSize("default_lining").width
            border.color: radioButton.hovered ? UM.Theme.getColor("small_button_text") : UM.Theme.getColor("small_button_text_hover")
            Rectangle
            {
                width: (parent.width / 2) | 0
                height: widths
                anchors.centerIn: parent
                radius: width / 2
                color: red//radioButton.hovered ? UM.Theme.getColor("primary_button_hover") : UM.Theme.getColor("primary_button")
                visible: radioButton.checked
            }
            Image
            {
                id:img1
                width:  400
                height: imgH
                anchors.left:parent.left
                anchors.top:lbl1.bottom
                source: /*enabled ?*/ imageSRC//"../images/printers/leonardo.png"// : "../images/printers/s300.png"
                visible: control.checked
            }
            Label
            {
                id:lbl1
                width:parent.width
                height:50
                text:textV
                //anchors.left:img1.left
                anchors.horizontalCenter:img1.horizontalCenter
                anchors.top:parent.top
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 25
                font.italic: true
                color: "#353535"


            }
        }
        /*contentItem: Label
        {
            verticalAlignment: Text.AlignVCenter
            leftPadding: radioButton.indicator.width + radioButton.spacing
            text: radioButton.text
            font: radioButton.font
            renderType: Text.NativeRendering
        } */
    }


  
    
