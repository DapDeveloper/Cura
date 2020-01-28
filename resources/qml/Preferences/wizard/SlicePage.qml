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
    title: catalog.i18nc("@title:label","Slice")
    id: generalPreferencesPage
    property real progress: UM.Backend.progress
    property int backendState: UM.Backend.state
    property bool preSlicedData: PrintInformation.preSliced

    function sliceOrStopSlicing()
    {
        if (generalPreferencesPage.backendState == UM.Backend.NotStarted)
        {
            Cura.Actions.autoSaveProfile.trigger()
            CuraApplication.backend.forceSlice()

        }
        else
        {
            CuraApplication.backend.stopSlicing()
        }
    }
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
        width:100
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
        Timer
        {
            id: sliceTimer
            repeat: false
            interval: 1
            onTriggered: sliceOrStopSlicing()
        }

        Cura.PrimaryButton
        {
            id: sliceButton
            width:100
            height:50
            anchors.left: parent.left
            anchors.bottom:parent.bottom
            anchors.bottomMargin:20
            anchors.leftMargin:20
            text: catalog.i18nc("@button", "Slice")
            tooltip: catalog.i18nc("@label", "Start the slicing process")
            enabled: generalPreferencesPage.backendState != UM.Backend.Error
            visible: generalPreferencesPage.backendState == UM.Backend.NotStarted || generalPreferencesPage.backendState == UM.Backend.Error
            onClicked: 
            {
                Cura.ContainerManager.updateQualityChanges()
                sliceTimer.start()
            }
        }
         Cura.SecondaryButton
        {
            id:saveProfileButton
            //width:200
            height:25
            text:catalog.i18nc("@button","Create profile from current settings/overrides...")
            visible:!Cura.MachineManager.stacksHaveErrors && lblSlicingDone.visible
            anchors
            {
                right:parent.right
                top:parent.top
            }
            onClicked:Cura.Actions.addProfile.trigger()
        }

        /*Cura.SliceProcessWidget
        {
            id:sliceProcessWidget
            width:100
            height:50
            visible: generalPreferencesPage.backendState == UM.Backend.NotStarted || generalPreferencesPage.backendState == UM.Backend.Error
            anchors
            {
                top:sliceButton.bottom
                left:sliceButton.left
            }
        }*/
        Label
        {
            id: lblSlicing
            anchors
            {
                top:parent.top
                left:sliceButton.left
            }
            anchors.topMargin:20
            width: parent.width
            wrapMode: Text.WordWrap
            text: catalog.i18nc("@label","Slicing...")
            font.pointSize: 20
            renderType: Text.NativeRendering
            visible:generalPreferencesPage.backendState!=UM.Backend.Done && cancelButton.visible==true
        }
        Label
        {
            id: lblSlicingDone
            anchors
            {
                top:lblSlicing.top
                left:lblSlicing.left
            }
            width: parent.width/2
            wrapMode: Text.WordWrap
            text: catalog.i18nc("@label","Slicing done!")
            font.pointSize: 20
            renderType: Text.NativeRendering
            visible:generalPreferencesPage.backendState==UM.Backend.Done && lblSlicing.visible==false
        }
       
        UM.ProgressBar
        {
            id: progressBar
            width: parent.width-50
            height: UM.Theme.getSize("progressbar").height
            value: progress
            indeterminate: widget.backendState == UM.Backend.NotStarted
            visible: generalPreferencesPage.backendState!=UM.Backend.Done && cancelButton.visible==true
            anchors
            {
                top:lblSlicing.bottom
                left:lblSlicing.left
            }
            anchors.topMargin:5
        }
        Cura.SecondaryButton
        {
            id: cancelButton
            width:100
            height:50
            anchors.left: parent.left
            anchors.bottom:parent.bottom
            anchors.bottomMargin:20
            anchors.leftMargin:20
            text: catalog.i18nc("@button", "Cancel")
            enabled: sliceButton.enabled
            visible: !sliceButton.visible //&& generalPreferencesPage.backendState!=UM.Backend.Done
            onClicked: 
            {
                Cura.ContainerManager.updateQualityChanges()
                sliceTimer.start()
            }
        } 
        Cura.OutputDevicesActionButton
        {
            id: outputDevicesButton
            //anchors.left: cancelButton.right
            anchors
            {
                bottom:parent.bottom
                right:parent.right
            }
            anchors.bottomMargin:20
            anchors.rightMargin:20
            width: 200
            height: 50  
            visible: generalPreferencesPage.backendState==UM.Backend.Done
        }
        Cura.PrintJobInformation
        {
            id:printJobInformation
            width:500
            height:500
            visible:UM.Backend.state == UM.Backend.Done//!sliceButton.visible
            anchors
            {
                left:estimatedTime.left
                top:estimatedTime.bottom
            }
        }
   /*     Cura.OutputProcessWidget
        {
            id:printJobInformation2
            width:500
            height:500
            visible:!sliceButton.visible
            anchors
            {
                left:printJobInformation.left
                top:printJobInformation.bottom
            }
        }*/
        Cura.IconWithText
        {
            id: estimatedTime
            width: parent.width
            text: preSlicedData ? catalog.i18nc("@label", "No time estimation available") : PrintInformation.currentPrintTime.getDisplayString(UM.DurationFormat.Long)
            source: UM.Theme.getIcon("clock")
            font: UM.Theme.getFont("medium_bold")
            visible:generalPreferencesPage.backendState==UM.Backend.Done
            anchors
            {
                left:progressBar.left
                top:progressBar.bottom
            }
        }
      /*  Cura.IconWithText
        {
            id: estimatedCosts
            width: parent.width
            property var printMaterialLengths: PrintInformation.materialLengths
            property var printMaterialWeights: PrintInformation.materialWeights
            property var printMaterialCosts: PrintInformation.materialCosts
            anchors
            {
                left:estimatedTime.right
                top:estimatedTime.top
            }
            text:
            {
                if (preSlicedData)
                {
                    return catalog.i18nc("@label", "No cost estimation available")
                }
                var totalLengths = 0
                var totalWeights = 0
                var totalCosts = 0.0
                if (printMaterialLengths)
                {
                    for(var index = 0; index < printMaterialLengths.length; index++)
                    {
                        if(printMaterialLengths[index] > 0)
                        {
                            totalLengths += printMaterialLengths[index]
                            totalWeights += Math.round(printMaterialWeights[index])
                            var cost = printMaterialCosts[index] == undefined ? 0.0 : printMaterialCosts[index]
                            totalCosts += cost
                        }
                    }
                }
                if(totalCosts > 0)
                {
                    var costString = "%1 %2".arg(UM.Preferences.getValue("cura/currency")).arg(totalCosts.toFixed(2))
                    return totalWeights + "g · " + totalLengths.toFixed(2) + "m · " + costString
                }
                return totalWeights + "g · " + totalLengths.toFixed(2) + "m"
            }
            source: UM.Theme.getIcon("spool")
        }*/
        /* Cura.SecondaryButton
        {
            id: previewStageShortcut

            anchors
            {
                top: outputDevicesButton.top
                left: outputDevicesButton.right
            }
            width: 100
            height: 50  
            text: catalog.i18nc("@button", "Preview")
            tooltip: text
            fixedWidthMode: true
            toolTipContentAlignment: Cura.ToolTip.ContentAlignment.AlignLeft
            onClicked:{ UM.Controller.setActiveStage("PreviewStage");  Cura.actions.sliceWizardHide.trigger()}
        }*/
    }
}