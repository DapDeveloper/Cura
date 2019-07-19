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
    title: catalog.i18nc("@title:label","Structure")
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
        /*  
        border
        {
            color: UM.Theme.getColor("wizard_color1")
            width: borderSize // TODO: Remove once themed
        }
        */
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
        Cura.MachineStructureSettingsTab
        {
            id:machineStructureSettings
            width:parent.width
            anchors
            {
                left:parent.left
                top:parent.top
            }
        }
    }
}