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
    //property var forceUpdateQuality: Cura.MachineManager.updateQualityChanges()
    //property var forceUpdateAllSetings:manager.forceUpdateAllSetings
    Item
    {
        id: upperBlock
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: UM.Theme.getSize("default_margin").width
        Cura.ComboBoxWithOptions  // "infill_pattern"
        {
            id: machineInfillPatern
            containerStackId: machineStackId
            anchors
            {
                top:parent.top
                left:parent.left
            }
            settingKey: "infill_pattern"
            settingStoreIndex: propertyStoreIndex
            labelText: catalog.i18nc("@label", "Infill patern")
            labelFont: base.labelFont
            labelWidth: 100
            controlWidth: 100
            forceUpdateOnChangeFunction: forceUpdateFunction
        } 
        /*
                Cura.ComboBoxWithOptions  // "Build plate shape"
                    {
                        id: buildPlateShapeComboBox
                        containerStackId: machineStackId
                        settingKey: "infill_pattern"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Build plate shape")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
        */

        Label   // Title Label
            {
                id:lblPrinterSettings
                text: catalog.i18nc("@title:label", "Speed")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors
                {
                    left:machineInfillPatern.left
                    top:machineInfillPatern.bottom
                }
            }
        ScrollView
            {
                id: objectListContainer
                frameVisible: true
                width: parent.width/2
                height: 200
                anchors.left:parent.left
                anchors.top:lblPrinterSettings.bottom
        Column
        {
            width: objectListContainer.width/2
            id:column1
            spacing: base.columnSpacing
            padding:10
            Cura.NumericTextFieldWithUnit  // "Print Speed"
            {
                id: machinePrintSpeed
                containerStackId: machineStackId
                settingKey: "speed_print"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Print Speed")
                labelFont: base.labelFont
                labelWidth: 100
                controlWidth: 100
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
            } 
            Cura.NumericTextFieldWithUnit  // "wall speed"
            {
                id: machineWallSpeed
                containerStackId: machineStackId
                settingKey: "speed_wall"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Wall Speed")
                labelFont: base.labelFont
                labelWidth: 100
                controlWidth: 100
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
            } 
                Cura.NumericTextFieldWithUnit  // "speed_topbottom"
            {
                id: machineTopBottomSpeed
                containerStackId: machineStackId
                settingKey: "speed_topbottom"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Top/Bottom Speed")
                labelFont: base.labelFont
                labelWidth: 100
                controlWidth: 100
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
            } 
                Cura.NumericTextFieldWithUnit  // "speed_topbottom"
            {
                id: machineSupportSpeed
                containerStackId: machineStackId
                settingKey: "speed_support"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support speed")
                labelFont: base.labelFont
                labelWidth: 100
                controlWidth: 100
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
            } 
            //speed_support
        }
    }  
    }//end item
}
