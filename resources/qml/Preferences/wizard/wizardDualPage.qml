// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import UM 1.3 as UM
import Cura 1.1 as Cura
UM.PreferencesPage
{
    //: General configuration page title
    title: catalog.i18nc("@label","Dual Extrusion")
    id: generalPreferencesPage
    anchors
    {
        left:parent.left
        right:parent.right
        top:parent.top
        bottom:parent.bottom
    }
    anchors.rightMargin:10
    Rectangle
    {
        id: background
        anchors
        {
            left:parent.left
            right:parent.right
            top:parent.top
            bottom:parent.bottom
        }
        color: UM.Theme.getColor("wizard_color1")
        radius: 5 * screenScaleFactor // TODO: Theme!
    }
    Column
    {
        id:items
        anchors
        {
            left:parent.left
            right:parent.right
            top:parent.top
            bottom:parent.bottom
        }
        anchors.rightMargin:10
        anchors.leftMargin:10
        anchors.topMargin:10
        anchors.bottomMargin:10
        Label
        {
            id:lblTitle
            text:catalog.i18nc("@label","Printer Type")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHLeft
            width:parent.width
        }
        Cura.MachineSelector
        {
            id:machineSelector_id
            width:parent.width/2
            height:lblTitle.height*3
            anchors
            {
                left:lblTitle.left
                top:lblTitle.bottom
            }
            anchors.topMargin:10
        }
        Label
        {
            id:lblTitleMaterials
            text:catalog.i18nc("@label","Materials")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHLeft
            width:parent.width
            anchors
            {
                top:machineSelector_id.bottom
                left:machineSelector_id.left
            }
            anchors.topMargin:10
        }
        Cura.ConfigurationMenu
        {
            anchors
            {
              left:lblTitleMaterials.left
              top:lblTitleMaterials.bottom
            }
            anchors.topMargin:10
            id: printerSetup
            width:parent.width
        }
        Cura.CustomPrintSetupEasy
        {
            anchors.topMargin:10
            id: machineProfile
            width:parent.width
            //height:210
            anchors
            {
                left:printerSetup.left
                top:printerSetup.bottom
                bottom:parent.bottom
            }
        }

       /* Label
        {
            id:lblTitleNozzle
            text:catalog.i18nc("@label","Nozzle")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHLeft
            width:parent.width
            anchors
            {
                top:printerSetup.bottom
                left:printerSetup.left
            }
            anchors.topMargin:10
        }*/
      /* Cura.MachineAction
        {
            UM.I18nCatalog { id: catalog; name: "cura" }
            anchors
            {
                top:lblTitleNozzle.bottom
                left:lblTitleNozzle.left
            }
            width:parent.width
            //height:200
            property var extrudersModel: Cura.ExtrudersModel {}
            // If we create a TabButton for "Printer" and use Repeater for extruders, for some reason, once the component
            // finishes it will automatically change "currentIndex = 1", and it is VERY difficult to change "currentIndex = 0"
            // after that. Using a model and a Repeater to create both "Printer" and extruder TabButtons seem to solve this
            // problem.
            Connections
            {
                target: extrudersModel
                onItemsChanged: tabNameModel.update()
            }
            ListModel
            {
                id: tabNameModel
                Component.onCompleted: update()
                function update()
                {
                    clear()
                    for (var i = 0; i < extrudersModel.count; i++)
                    {
                        const m = extrudersModel.getItem(i)
                        append({ name: m.name })
                    }
                }
            }
            Label
            {
             text:extrudersModel.getItem(0)
            }
            Cura.RoundedRectangle
            {
                anchors
                {
                    top: tabBar.bottom
                    topMargin: -UM.Theme.getSize("default_lining").height
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                cornerSide: Cura.RoundedRectangle.Direction.Down
                border.color: UM.Theme.getColor("lining")
                border.width: UM.Theme.getSize("default_lining").width
                radius: UM.Theme.getSize("default_radius").width
                color: UM.Theme.getColor("main_background")
                StackLayout
                {
                    id: tabStack
                    anchors.fill: parent
                    currentIndex: tabBar.currentIndex
                     
                   

                 
                    Repeater
                    {
                        model: extrudersModel
                        MachineSettingsExtruderTab
                        {
                            id: discoverTab
                            extruderPosition: model.index
                            extruderStackId: model.id
                        }
                    }
                }
            }
            UM.TabRow
            {
                id: tabBar
                width: parent.width
                Repeater
                {
                    model: tabNameModel
                    delegate: UM.TabRowButton
                    {
                        text: model.name
                    }
                }
            }
        }*/

        
    }
}