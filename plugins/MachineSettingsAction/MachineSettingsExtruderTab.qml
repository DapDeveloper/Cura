// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import UM 1.3 as UM
import Cura 1.1 as Cura

//
// This component contains the content for the "Welcome" page of the welcome on-boarding process.
//
Item
{
    id: base
    UM.I18nCatalog { id: catalog; name: "cura" }
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    property int labelWidth: 210 * screenScaleFactor
    property int controlWidth: (UM.Theme.getSize("setting_control").width * 3 / 4) | 0
    property var labelFont: UM.Theme.getFont("medium")
    property int columnWidth: ((parent.width - 2 * UM.Theme.getSize("default_margin").width) / 2) | 0
    property int columnSpacing: 3 * screenScaleFactor
    property int propertyStoreIndex: manager.storeContainerIndex  // definition_changes
    property string extruderStackId: ""
    property int extruderPosition: 0
    property var forceUpdateFunction: manager.forceUpdate
    property var forceUpdateQuality: Cura.MachineManager.updateQualityChanges()
    property var forceUpdateAllSetings:manager.forceUpdateAllSetings

    property QtObject settingVisibilityPresetsModel: CuraApplication.getSettingVisibilityPresetsModel()
    property var editable1:settingVisibilityPresetsModel.items[1].presetId == settingVisibilityPresetsModel.activePreset
    property var editable2:settingVisibilityPresetsModel.items[2].presetId == settingVisibilityPresetsModel.activePreset
    property var editable3:settingVisibilityPresetsModel.items[3].presetId == settingVisibilityPresetsModel.activePreset

    function updateMaterialDiameter()
    {
        manager.updateMaterialForDiameter(extruderPosition)
    }

    Item
    {
        id: upperBlock
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: UM.Theme.getSize("default_margin").width
        height: childrenRect.height
        // =======================================
        // Left-side column "Nozzle Settings"
        // =======================================
        Column
        {
            anchors.top: parent.top
            anchors.left: parent.left
            width: parent.width/2
            id:column1
            spacing: base.columnSpacing
            Label   // Title Label
            {
                text: catalog.i18nc("@title:label", "Nozzle Settings")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
            }
            Cura.NumericSliderWithUnit  // "Nozzle size"
            {
                id: extruderNozzleSizeField
                visible: !Cura.MachineManager.hasVariants
                containerStackId: base.extruderStackId
                settingKey: "machine_nozzle_size"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Nozzle size")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                sliderMin:0
                sliderMax:2
                precision:1
                minValueWarning:0.4
                maxValueWarning:0.8
                step_value:0.1
            }
            Cura.NumericSliderWithUnit  // "Compatible material diameter"
            {
                id: extruderCompatibleMaterialDiameterField
                containerStackId: base.extruderStackId
                settingKey: "material_diameter"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Filament diameter")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                // Other modules won't automatically respond after the user changes the value, so we need to force it.
                afterOnEditingFinishedFunction: updateMaterialDiameter
                sliderMin:0
                sliderMax:5
                precision:2
                minValueWarning:1.75
                maxValueWarning:3.0
                step_value:0.01
            }
            /*Cura.NumericTextFieldWithUnit  // "Nozzle offset X"
            {
                id: extruderNozzleOffsetXField
                containerStackId: base.extruderStackId
                settingKey: "machine_nozzle_offset_x"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Nozzle offset X")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.NumericTextFieldWithUnit  // "Nozzle offset Y"
            {
                id: extruderNozzleOffsetYField
                containerStackId: base.extruderStackId
                settingKey: "machine_nozzle_offset_y"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Nozzle offset Y")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }*/

        /*   Cura.NumericTextFieldWithUnit  // "Cooling Fan Number"
            {
                id: extruderNozzleCoolingFanNumberField
                containerStackId: base.extruderStackId
                settingKey: "machine_extruder_cooling_fan_number"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Cooling Fan Number")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: ""
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
        */

            Cura.NumericSliderWithUnit  // "Line WIDTH"
            {
                id: extruderLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
              
                sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "wall Line WIDTH"
            {
                id: extruderWallLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_wall_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Wall line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
             
                sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "wall Line WIDTH 0"
            {
                id: extruderWallLineWidth0
                containerStackId: base.extruderStackId
                settingKey: "machine_wall_line_width0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Wall line width 0")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                  sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "wall Line WIDTH X"
            {
                id: extruderWallLineWidthX
                containerStackId: base.extruderStackId
                settingKey: "machine_wall_line_widthx"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Wall line width X")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "skin Line WIDTH"
            {
                id: extruderSkinLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_skin_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Skin line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
              
                     sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "Support Line WIDTH"
            {
                id: extruderSupportLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_support_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
            
                     sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "Inteface Line WIDTH"
            {
                id: extruderInterfaceLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_interface_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support interface line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
              
                     sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "Roof Line WIDTH"
            {
                id: extruderRoofLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_roof_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support roof line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
      
                      sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "Bottom Line WIDTH"
            {
                id: extruderBottomLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_bottom_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support bottom line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
 
                      sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
              Cura.NumericSliderWithUnit  // "Prime tower Line WIDTH"
            {
                id: extruderPrimeTowerLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_prime_tower_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Prime tower line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
 
                      sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "Initial layer Line WIDTH"
            {
                id: extruderInitialLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_initial_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Initial line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
    
                sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
            Cura.NumericSliderWithUnit  // "infill Line WIDTH"
            {
                id: extruderInfillLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_infill_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Infill line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                sliderMin:0
                sliderMax:2
                precision:2
                minValueWarning:extruderNozzleSizeField.sliderValue-extruderNozzleSizeField.sliderValue/100*20
                maxValueWarning:extruderNozzleSizeField.sliderValue+extruderNozzleSizeField.sliderValue/100*20
                step_value:0.01
            }
              Cura.NumericSliderWithUnit  // "prime tower flow"
            { 
                id: extruderPrimeTowerFlow
                containerStackId: base.extruderStackId
                settingKey: "machine_prime_tower_flow"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Prime tower flow")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "%")
                forceUpdateOnChangeFunction: forceUpdateFunction
                sliderMin:0
                sliderMax:200
                precision:0
                minValueWarning:90
                maxValueWarning:110
                step_value:1
            }
        }
        /* Column
        {
            anchors.top: parent.top
            anchors.left: column1.right
            width: parent.width /2
            spacing: base.columnSpacing
            /*    Cura.NumericTextFieldWithUnit  // "Initial layer Line WIDTH"
            {
                id: extruderInitialLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_initial_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Initial line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "%")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.NumericTextFieldWithUnit  // "infill Line WIDTH"
            {
                id: extruderInfillLineWidth
                containerStackId: base.extruderStackId
                settingKey: "machine_infill_line_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Infill line width")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
              Cura.NumericTextFieldWithUnit  // "prime tower flow"
            { 
                id: extruderPrimeTowerFlow
                containerStackId: base.extruderStackId
                settingKey: "machine_prime_tower_flow"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Prime tower flow")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "%")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }*/

           /* Cura.NumericTextFieldWithUnit  // "infill extruder nr"
            {
                id: extruderInfillNumber
                containerStackId: base.extruderStackId
                settingKey: "machine_infill_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Infill extruder nr")
                labelFont: base.labelFont
                 labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
          Cura.NumericTextFieldWithUnit  // "support extruder nr"
            {
                id: extruderSupportNumber
                containerStackId: base.extruderStackId
                settingKey: "machine_support_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support extruder nr")
                labelFont: base.labelFont
                  labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
              Cura.NumericTextFieldWithUnit  // "support infill extruder nr"
            {
                id: extruderSupportInfillNumber
                containerStackId: base.extruderStackId
                settingKey: "machine_support_infill_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support infill extruder nr")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            
            Cura.NumericTextFieldWithUnit  // "support extruder nr layer 0"
            {
                id: extruderSupportInfillNumberLayer0
                containerStackId: base.extruderStackId
                settingKey: "machine_support_infill_extruder_nr_layer0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "First Layer Support Extruder")
                labelFont: base.labelFont
                 labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.NumericTextFieldWithUnit  // "support interface extruder nr"
            {
                id: extruderSupportInterfaceExtruderNr
                containerStackId: base.extruderStackId
                settingKey: "machine_support_interface_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support interface extruder nr")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.NumericTextFieldWithUnit  // "support roof extruder nr"
            {
                id: extruderSupportRoofExtruderNr
                containerStackId: base.extruderStackId
                settingKey: "machine_support_roof_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support roof extruder nr")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.NumericTextFieldWithUnit  // "support bottom extruder nr"
            {
                id: extruderSupportBottomExtruderNr
                containerStackId: base.extruderStackId
                settingKey: "machine_support_bottom_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support bottom extruder nr")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.NumericTextFieldWithUnit  // "adhesion extruder nr"
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
                forceUpdateOnChangeFunction: forceUpdateQuality
            }*/
           /*   Cura.ComboBoxWithOptions
            {
                id: machineAdhesionExtruder
                containerStackId: machineStackId
                settingKey: "machine_adhesion_extruder_nr"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Build Plate Adhesion Extruder")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                forceUpdateOnChangeFunction: forceUpdateQuality
            }*/
            /* Cura.NumericTextFieldWithUnit  // "prime tower flow"
            { 
                id: extruderPrimeTowerFlow
                containerStackId: base.extruderStackId
                settingKey: "machine_prime_tower_flow"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Prime tower flow")
                labelFont: base.labelFont
                labelWidth: base.labelWidth/1.2
                controlWidth: base.controlWidth/1.5
                unitText: catalog.i18nc("@label", "%")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }*/
        //}
    }
/*
    Item  // Extruder Start and End G-code
    {
        id: lowerBlock
        anchors.top: upperBlock.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: UM.Theme.getSize("default_margin").width
        Cura.GcodeTextArea   // "Extruder Start G-code"
        {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: UM.Theme.getSize("default_margin").height
            anchors.left: parent.left
            width: base.columnWidth - UM.Theme.getSize("default_margin").width
            labelText: catalog.i18nc("@title:label", "Extruder Start G-code")
            containerStackId: base.extruderStackId
            settingKey: "machine_extruder_start_code"
            settingStoreIndex: propertyStoreIndex
        }
        Cura.GcodeTextArea   // "Extruder End G-code"
        {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: UM.Theme.getSize("default_margin").height
            anchors.right: parent.right
            width: base.columnWidth - UM.Theme.getSize("default_margin").width

            labelText: catalog.i18nc("@title:label", "Extruder End G-code")
            containerStackId: base.extruderStackId
            settingKey: "machine_extruder_end_code"
            settingStoreIndex: propertyStoreIndex
        }
    }*/
}
