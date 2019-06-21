// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.2
import QtQuick.Controls 2.3
import UM 1.2 as UM
import Cura 1.0 as Cura
Item
{
    id: base
    width: buttons.width
    height: 500
    property int activeY
    anchors
    {
        right:parent.right
        top:parent.top
    }
    anchors.topMargin:200
    /*
    activeId: Cura.MachineManager.activeMachineId
    activeIndex: activeMachineIndex()
    function activeMachineIndex()
    {
        for(var i = 0; i < model.count; i++)
        {
            if (model.getItem(i).id == Cura.MachineManager.activeMachineId)
            {
                return i;
            }
        }
        return -1;
    }*/
    Item
    {
        id: buttons
        width:300//parent.visible ? toolButtons.width : 0
        height:500
        Behavior on width { NumberAnimation { duration: 100 } }
        Rectangle
        {
            anchors
            {
                fill: toolButtons
                leftMargin: -radius 
                //rightMargin: -border.width
                topMargin: -border.width
                bottomMargin: -border.width
            }
            radius:15
            color: UM.Theme.getColor("psColor")
        }
        Rectangle
        {
            width:500
            anchors
            {
                fill: extruderButtons
                leftMargin: -radius - border.width
                rightMargin: -border.width
                topMargin: -border.width-10
                bottomMargin: -border.width-10
            }
            radius: 15
            color: UM.Theme.getColor("psColor")
            visible: extrudersModel.items.length > 1
        }//Print Selected Model With:
        Column
        {
            width:500
            id: extruderButtons
            anchors.topMargin: UM.Theme.getSize("default_margin").height
            anchors.top: toolButtons.bottom
            //anchors.right: parent.right
            //anchors.rightMargin:180
            anchors.left:parent.left
            height: parent.height/1.5
            Label
            {
                id:lblTitle2
                text:catalog.i18nc("@label","Print settings") 
                //font:UM.Theme.getFont("default_bold")
                font.pointSize:23
                anchors
                {
                    left:parent.left
                }
            }
            Label
            {
                id:lbl1
                text:catalog.i18nc("@label","Active printer:")+Cura.MachineManager.activeMachine.name
                font.pointSize:13
                //text:catalog.i18nc("@label", "Active printer")
            }
            Item
            {
                id:itmPers1
                anchors
                {
                    left:parent.left
                    top:lbl1.bottom
                }
                Cura.CustomPrintSetupViewer
                {
                    id:pers1
                    width:300//600extruderButtons.width
                    height:200
                    anchors
                    {
                        left:extruderButtons.left
                        top:parent.top
                    }
                }
               
            }
          /*  Cura.CustomPrintSetupResolution
            {
                 id:pers1
                width:extruderButtons.width
                height:200
                 anchors
                {
                    left:extruderButtons.left
                    right:extruderButtons.right
                    top:lbl2.bottom
                }
                anchors.rightMargin:200
            }
*/

               

        }
    }
}
