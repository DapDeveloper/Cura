// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

//
// This the content in the "Printer" tab in the Machine Settings dialog.
//
Item
{
    id: base
    UM.I18nCatalog { id: catalog; name: "cura" }
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    property int labelWidth: 170 * screenScaleFactor
    property int controlWidth: (UM.Theme.getSize("setting_control").width * 3 / 4.5) | 0
    property var labelFont: UM.Theme.getFont("default")
    property int columnWidth: ((parent.width - 2 * UM.Theme.getSize("default_margin").width) / 2) | 0
    property int columnSpacing: 3 * screenScaleFactor
    property int propertyStoreIndex: manager.storeContainerIndex  // definition_changes
    property string machineStackId: Cura.MachineManager.activeMachineId
    property var forceUpdateFunction: manager.forceUpdate
    property var forceUpdateQuality: Cura.MachineManager.updateQualityChanges()
   
    Item  // Start and End G-code
    {
        id: lowerBlock
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: UM.Theme.getSize("default_margin").width
        Cura.GcodeTextArea   // "Start G-code"
        {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: UM.Theme.getSize("default_margin").height
            anchors.left: parent.left
            width: base.columnWidth - UM.Theme.getSize("default_margin").width
            labelText: catalog.i18nc("@title:label", "Start G-code")
            containerStackId: machineStackId
            settingKey: "machine_start_gcode"
            settingStoreIndex: propertyStoreIndex
        }
        Cura.GcodeTextArea   // "End G-code"
        {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: UM.Theme.getSize("default_margin").height
            anchors.right: parent.right
            width: base.columnWidth - UM.Theme.getSize("default_margin").width
            labelText: catalog.i18nc("@title:label", "End G-code")
            containerStackId: machineStackId
            settingKey: "machine_end_gcode"
            settingStoreIndex: propertyStoreIndex
        }
    }
}
