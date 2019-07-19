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
    title: catalog.i18nc("@label","Resolution")
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
       Cura.CustomPrintSetupResolutionWizard
            {
                anchors.topMargin:10
                id: machineProfile
                width:parent.width
                height:parent.height
                /*anchors
                {
                    left:printerSetup.left
                    top:printerSetup.bottom
                }*/
            }
    }
}