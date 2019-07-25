// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Controls1
import UM 1.3 as UM
import Cura 1.0 as Cura
// This element contains all the elements the user needs to create a printjob from the
// model(s) that is(are) on the buildplate. Mainly the button to start/stop the slicing
// process and a progress bar to see the progress of the process.
Column
{
    id: widget
    visible:false
    spacing: UM.Theme.getSize("thin_margin").height
    UM.I18nCatalog
    {
        id: catalog
        name: "cura"
    }
    property real progress: UM.Backend.progress
    property int backendState: UM.Backend.state
    function sliceOrStopSlicing()
    {
        if (widget.backendState == UM.Backend.NotStarted)
        {
            Cura.ContainerManager.updateQualityChanges();
            Cura.Actions.autoSaveProfile.trigger()
            CuraApplication.backend.forceSlice()
        }
        else
        {
            CuraApplication.backend.stopSlicing()
        }
    }
    /*Label
    {
        id: autoSlicingLabel
        width: parent.width
        visible: progressBar.visible
        text: catalog.i18nc("@label:PrintjobStatus", "Slicing...")
        color: UM.Theme.getColor("text")
        font: UM.Theme.getFont("default")
        renderType: Text.NativeRendering
    }*/
    Cura.IconWithText
    {
        id: unableToSliceMessage
        width: parent.width
        visible: widget.backendState == UM.Backend.Error
        text: catalog.i18nc("@label:PrintjobStatus", "Unable to slice")
        source: UM.Theme.getIcon("warning")
        iconColor: UM.Theme.getColor("warning")
    }
    // Progress bar, only visible when the backend is in the process of slice the printjob
    UM.ProgressBar
    {
        id: progressBar
        width: parent.width
        height: UM.Theme.getSize("progressbar").height
        value: progress
        indeterminate: widget.backendState == UM.Backend.NotStarted
        visible: (widget.backendState == UM.Backend.Processing || (prepareButtons.autoSlice && widget.backendState == UM.Backend.NotStarted))
    }
    Item
    {
        id: prepareButtons
        // Get the current value from the preferences
        property bool autoSlice: UM.Preferences.getValue("general/auto_slice")
        // Disable the slice process when
        width: parent.width
        height: UM.Theme.getSize("action_button").height
        visible: false//!autoSlice
        Cura.PrimaryButton
        {
            id: sliceButton
            width:parent.width/2
            height: parent.height
            anchors.left: parent.left
            text: catalog.i18nc("@button", "Slice")
            tooltip: catalog.i18nc("@label", "Start the slicing process")
            enabled: widget.backendState != UM.Backend.Error
            visible: widget.backendState == UM.Backend.NotStarted || widget.backendState == UM.Backend.Error
            onClicked: sliceOrStopSlicing()
        }
        Cura.PrimaryButton
        {
            id: sliceWizardButton
            fixedWidthMode:true
            //anchors.top: parent.top
            anchors.left: parent.left
            anchors.right:parent.right
            leftPadding: UM.Theme.getSize("default_margin").width
            rightPadding: UM.Theme.getSize("default_margin").width
            text: catalog.i18nc("@button", "Wizard")
            visible: false
            onClicked: Cura.Actions.sliceWizard.trigger()
        }
        /*Cura.SecondaryButton
        {
            id: cancelButton
            fixedWidthMode: true
            height: parent.height
            anchors.left: parent.left
            anchors.right: parent.right
            text: catalog.i18nc("@button", "Cancel")
            enabled: sliceButton.enabled
            visible: !sliceButton.visible
            onClicked: sliceOrStopSlicing()
        }*/
    }
    // React when the user changes the preference of having the auto slice enabled
    Connections
    {
        target: UM.Preferences
        onPreferenceChanged:
        {
            if (preference !== "general/auto_slice")
            {
                return;
            }
            var autoSlice = UM.Preferences.getValue("general/auto_slice")
            if(prepareButtons.autoSlice != autoSlice)
            {
                prepareButtons.autoSlice = autoSlice
                if(autoSlice)
                {
                    CuraApplication.backend.forceSlice()
                }
            }
        }
    }
    Timer
        {
            id: sliceTimer
            repeat: false
            interval: 1
            onTriggered: sliceOrStopSlicing()
        }
        
    // Shortcut for "slice/stop"
    Controls1.Action
    {
        shortcut: "Ctrl+P"
        onTriggered:
        {
            if (sliceButton.enabled)
            {
            
               Cura.ContainerManager.updateQualityChanges()
               sliceTimer.start()
            }
        }
    }
    /*
     Cura.PrimaryButton
        {
            id: sliceWizardButton
            fixedWidthMode:true
            //anchors.top: parent.top
            anchors.left: parent.left
            anchors.right:parent.right
            leftPadding: UM.Theme.getSize("default_margin").width
            rightPadding: UM.Theme.getSize("default_margin").width
            text: catalog.i18nc("@button", "Slice wizard")
            visible: true
            onClicked: Cura.Actions.sliceWizard.trigger()
        }
     */
     Controls1.Action
    {
        shortcut: "Ctrl+S"
        onTriggered:
        {
          Cura.Actions.sliceWizard.trigger()
        }
    }
}
