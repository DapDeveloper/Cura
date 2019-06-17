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
            append({ name: catalog.i18nc("@title:tab", "Printer") })
            append({ name: catalog.i18nc("@title:tab", "Gcode") })
            for (var i = 0; i < extrudersModel.count; i++)
            {
                const m = extrudersModel.getItem(i)
                append({ name: m.name })
            }
        }
    }
    Item
    {
        id: upperBlock
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: UM.Theme.getSize("default_margin").width
        Column
        {
            width: parent.width
            id:column1
            spacing: base.columnSpacing
            padding:10
            Cura.ComboBoxWithOptions
            {
                id: machineAdhesionType
                containerStackId: machineStackId
                anchors
                {
                    top:parent.top
                    left:parent.left
                }
                settingKey: "adhesion_type"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Build Plate Adhesion Type")
                labelWidth: 200
                controlWidth: 100
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
         /*   Cura.ComboBoxWithOptions
            {
                id: machineAdhesionExtruder
                containerStackId: machineStackId
                anchors
                {
                   top:machineAdhesionType.bottom
                   left:machineAdhesionType.left
                }
                settingKey: "adhesion_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Build Plate Adhesion Extruder")
                labelWidth: 200
                controlWidth: 100
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
*/
             /* Cura.NumericTextFieldWithUnit  // "adhesion extruder nr"
            { 
                id: extruderAdhesionExtruderNr
                containerStackId: base.extruderStackId
                settingKey: "machine_adhesion_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Build Plate Adhesion Extruder number")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                  anchors
                {
                    top:machineAdhesionType.bottom
                    left:machineAdhesionType.left
                }
                forceUpdateOnChangeFunction: forceUpdateQuality
            }**/
            Label
            {
                id:lblSkirtSettings
                text:/* "SELECTED:"+machineAdhesionType.selectedIndex//*/catalog.i18nc("@title:label", "Skirt")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors
                {
                    left:machineAdhesionType.left
                    top:machineAdhesionType.bottom
                }
            }
            ScrollView
            {
                id: skirtObjectListContainer
                frameVisible: true
                width: parent.width/2
                height:80
                anchors.left:lblSkirtSettings.left
                anchors.top:lblSkirtSettings.bottom
                visible:true//machineAdhesionType.currentIndex==0
                Column
                {
                    width: skirtObjectListContainer.width/2
                    id:skirtColumn2
                    spacing: base.columnSpacing
                    padding:10
                    Cura.NumericTextFieldWithUnit  // Skirt Line count
                    {
                        id: machineSkirtLineCount
                        containerStackId: machineStackId
                        settingKey: "skirt_line_count"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Skirt line count")
                        labelWidth: 100
                        controlWidth: 100
                        unitText: catalog.i18nc("@label", "")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    } 
                    Cura.NumericTextFieldWithUnit  // Skirt distance
                    {
                        id: machineSkirtDistance
                        containerStackId: machineStackId
                        settingKey: "skirt_gap"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Skirt Distance")
                        labelWidth: 100
                        controlWidth: 100
                        unitText: catalog.i18nc("@label", "mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                }
            }  
            Label
            {
                id:lblBrimSettings
                text: catalog.i18nc("@title:label", "Brim")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors
                {
                    left:skirtObjectListContainer.left
                    top:skirtObjectListContainer.bottom
                }
            }
            ScrollView
            {
                id: brimObjectListContainer
                frameVisible: true
                width: parent.width/2
                height:50
                anchors.left:lblBrimSettings.left
                anchors.top:lblBrimSettings.bottom
                Column
                {
                    width: BrimObjectListContainer.width/2
                    id:column2
                    spacing: base.columnSpacing
                    padding:10
                    Cura.NumericTextFieldWithUnit  // "Print Speed"
                    {
                        id: machineBrimWidthSettings
                        containerStackId: machineStackId
                        settingKey: "brim_width"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Brim Width")
                        labelWidth: 100
                        controlWidth: 100
                        unitText: catalog.i18nc("@label", "mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                }
            }
            Label
            {
                id:lblRaftSettings
                text: catalog.i18nc("@title:label", "Raft")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors
                {
                    left:brimObjectListContainer.left
                    top:brimObjectListContainer.bottom
                }
            }
            ScrollView
            {
                id: raftObjectListContainer
                frameVisible: true
                width: parent.width/1.8
                anchors.left:lblRaftSettings.left
                anchors.top:lblRaftSettings.bottom
                Column
                {
                    width: raftObjectListContainer.width/2
                    id:columnRaft
                    spacing: base.columnSpacing
                    padding:10
                    Cura.NumericTextFieldWithUnit  // "Raft extra margin"
                    {
                        id: machineRaftExtraMarginSettings
                        containerStackId: machineStackId
                        settingKey: "raft_margin"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Extra Margin")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label", "mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                    Cura.NumericTextFieldWithUnit  // "Raft topLayers"
                    {
                        id: machineRaftTopLayersSettings
                        containerStackId: machineStackId
                        settingKey: "raft_surface_layers"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label","Raft Top Layers")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label","")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                      Cura.NumericTextFieldWithUnit  // "Raft top layer thickness"
                    {
                        id: machineRaftTopThicknessSettings
                        containerStackId: machineStackId
                        settingKey: "raft_surface_thickness"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label","Raft Top Thickness")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label","mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }//raft_base_line_spacing
                     Cura.NumericTextFieldWithUnit  // "Raft top spacing"
                    {
                        id: machineRaftTopSpacingSettings
                        containerStackId: machineStackId
                        settingKey: "raft_surface_line_spacing"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label","Raft Top Spacing")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label","mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                     Cura.NumericTextFieldWithUnit  // "raft_middle_line_spacing"
                    {
                        id: machineMiddleThickness
                        containerStackId: machineStackId
                        settingKey: "raft_interface_thickness"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label","Raft Middle Thickness")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label","mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                    Cura.NumericTextFieldWithUnit  // "raft_base_line_spacing"
                    {
                        id: machineMiddleLineSpacing
                        containerStackId: machineStackId
                        settingKey: "raft_interface_line_spacing"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label","Raft Middle Line Spacing")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label","mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                    Cura.NumericTextFieldWithUnit  // "raft_base_line_spacing"
                    {
                        id: machineBaseThickness
                        containerStackId: machineStackId
                        settingKey: "raft_base_thickness"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label","Raft Base Thickness")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label","mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                    Cura.NumericTextFieldWithUnit  // "raft_base_line_spacing"
                    {
                        id: machineBaseLineSpacing
                        containerStackId: machineStackId
                        settingKey: "raft_base_line_spacing"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label","Raft Base Line Spacing")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label","mm")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }
                }
            }
           /*Label
            {
                id:lblAdhesionTemp
                text: catalog.i18nc("@title:label", "Temperatures")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors
                {
                    left:raftObjectListContainer.left
                    top:raftObjectListContainer.bottom
                }
            }
            ScrollView
            {
                id: adTemperatureObjectListContainer
                frameVisible: true
                width: parent.width/1.8
                anchors.left:lblAdhesionTemp.left
                anchors.top:lblAdhesionTemp.bottom
                Column
                {
                    width: adTemperatureObjectListContainer.width/2
                    id:columnTemperature
                    spacing: base.columnSpacing
                    padding:10
                    /*
                    Cura.NumericTextFieldWithUnit  // first layer temperature
                    {
                        id: machineFirstLayerTemperature
                        containerStackId: machineStackId
                        settingKey: "material_print_temperature_layer_0"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Printing Temperature Initial Layer")
                        labelWidth: 150
                        controlWidth: 100
                        unitText: catalog.i18nc("@label", "°C")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }*/
                    /*
                    Repeater
                    {
                        model: extrudersModel
                        delegate: MachineSettingsExtruderTab
                        {
                            id: discoverTab
                            extruderPosition: model.index
                            extruderStackId: model.id
                        }
                    }
                    */  /*               
                }
            }*/
        }
    }
}