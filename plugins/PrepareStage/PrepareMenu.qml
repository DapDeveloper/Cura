// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3
import UM 1.3 as UM
import Cura 1.1 as Cura
import QtGraphicalEffects 1.0 // For the dropshadow
Item
{
    id: prepareMenu
    anchors.bottom:parent.bottom
    UM.I18nCatalog
    {
        id: catalog
        name: "cura"
    }/*
    Item
    {
        anchors.right:parent.left
        anchors.bottom:parent.bottom
        Cura.PrimaryButton
        {
            id: sliceWizardButton
            text: catalog.i18nc("@button", "Slice wizard")
            visible: true
            onClicked: Cura.Actions.sliceWizard.trigger()
        }
        Cura.SecondaryButton
        {
            id: prepareStageShortcut
            anchors
            {
                top: sliceWizardButton.bottom
                left: sliceWizardButton.left
            }
            width: 100
            height: 50  
            text: catalog.i18nc("@button", "Prepare")
            tooltip: text
            fixedWidthMode: true
            toolTipContentAlignment: Cura.ToolTip.ContentAlignment.AlignLeft
            onClicked:{ UM.Controller.setActiveStage("PrepareStage"); }
        }
        Cura.SecondaryButton
        {
            id: previewStageShortcut
            anchors
            {
                top: prepareStageShortcut.bottom
                left: prepareStageShortcut.left
            }
            width: 100
            height: 50  
            text: catalog.i18nc("@button", "Preview")
            tooltip: text
            fixedWidthMode: true
            toolTipContentAlignment: Cura.ToolTip.ContentAlignment.AlignLeft
            onClicked:{ UM.Controller.setActiveStage("PreviewStage"); }
        }
    }*/
    // Item to ensure that all of the buttons are nicely centered.
    Item
    {
        anchors.right: parent.right
        anchors.bottom:parent.bottom
        width: openFileButton.width + UM.Theme.getSize("default_margin").width
        height: parent.height
/*
        RowLayout
        {
            id: itemRow
            anchors.left: openFileButton.right
            anchors.leftMargin: UM.Theme.getSize("default_margin").width
            width: Math.round(0.9 * prepareMenu.width)
            height: parent.height
            spacing: 0

            Cura.MachineSelector
            {
                id: machineSelection
                headerCornerSide: Cura.RoundedRectangle.Direction.Left
                Layout.minimumWidth: UM.Theme.getSize("machine_selector_widget").width
                Layout.maximumWidth: UM.Theme.getSize("machine_selector_widget").width
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Separator line
       /*     Rectangle
            {
                height: parent.height
                width: UM.Theme.getSize("default_lining").width
                color: UM.Theme.getColor("lining")
            }*/

           /* Cura.ConfigurationMenu
            {
                id: printerSetup
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: itemRow.width - machineSelection.width - printSetupSelectorItem.width - 2 * UM.Theme.getSize("default_lining").width
            }
*/
            // Separator line
          /*  Rectangle
            {
                height: parent.height
                width: UM.Theme.getSize("default_lining").width
                color: UM.Theme.getColor("lining")
            }
            Item
            {
                id: printSetupSelectorItem
                // This is a work around to prevent the printSetupSelector from having to be re-loaded every time
                // a stage switch is done.
                children: [printSetupSelector]
                height: childrenRect.height
                width: childrenRect.width
            }
    }*/
    
        Button
        {
            id: openFileButton
            height: UM.Theme.getSize("stage_menu").height
            width: UM.Theme.getSize("stage_menu").height
            onClicked: Cura.Actions.open.trigger()
            hoverEnabled: true
            contentItem: Item
            {
                anchors.fill: parent
                UM.RecolorImage
                {
                    id: buttonIcon
                    anchors.centerIn: parent
                    source: UM.Theme.getIcon("load")
                    width: UM.Theme.getSize("button_icon").width
                    height: UM.Theme.getSize("button_icon").height
                    color: UM.Theme.getColor("icon")

                    sourceSize.height: height
                }
            }

            background: Rectangle
            {
                id: background
                height: UM.Theme.getSize("stage_menu").height
                width: UM.Theme.getSize("stage_menu").height

                radius: UM.Theme.getSize("default_radius").width
                color: openFileButton.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
            }

            DropShadow
            {
                id: shadow
                // Don't blur the shadow
                radius: 0
                anchors.fill: background
                source: background
                verticalOffset: 2
                visible: true
                color: UM.Theme.getColor("action_button_shadow")
                // Should always be drawn behind the background.
                z: background.z - 1
            }
        }
    }
}
