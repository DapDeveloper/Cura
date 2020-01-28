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
    property QtObject settingVisibilityPresetsModel: CuraApplication.getSettingVisibilityPresetsModel()
    property var editable1:settingVisibilityPresetsModel.items[1].presetId == settingVisibilityPresetsModel.activePreset
    property var editable2:settingVisibilityPresetsModel.items[2].presetId == settingVisibilityPresetsModel.activePreset
    property var editable3:settingVisibilityPresetsModel.items[3].presetId == settingVisibilityPresetsModel.activePreset
    
    

    Item
    {
        id: upperBlock
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: UM.Theme.getSize("default_margin").width
        height: childrenRect.height

        Label   // Title Label
            {
                id:lblPrinterSettings
                text: catalog.i18nc("@title:label", "Printer Settings")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
            }
        ScrollView
            {
                id: objectListContainer
                frameVisible: true
                width: parent.width/4.2
                height: 280
                anchors.left:parent.left
                anchors.top:lblPrinterSettings.bottom
        Column
        {
            width: objectListContainer.width/2
            id:column1
            spacing: base.columnSpacing
            padding:10
            
            Cura.NumericTextFieldWithUnit  // "X (Width)"
            {
                id: machineXWidthField
                containerStackId: machineStackId
                settingKey: "machine_width"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "X (Width)")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
            }
            Cura.NumericTextFieldWithUnit  // "Y (Depth)"
            {
                id: machineYDepthField
                containerStackId: machineStackId
                settingKey: "machine_depth"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Y (Depth)")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
            }
            Cura.NumericTextFieldWithUnit  // "Z (Height)"
            {
                id: machineZHeightField
                containerStackId: machineStackId
                settingKey: "machine_height"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Z (Height)")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3    
            }
            Cura.ComboBoxWithOptions  // "Build plate shape"
            {
                id: buildPlateShapeComboBox
                containerStackId: machineStackId
                settingKey: "machine_shape"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Build plate shape")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                visible:editable3  
            }

            Cura.SimpleCheckBoxCustom  // "Origin at center"
            {
                id: originAtCenterCheckBox
                containerStackId: machineStackId
                settingKey: "machine_center_is_zero"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Origin at center")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3    
            }
            Cura.SimpleCheckBoxCustom  // "Heated bed"
            {
                id: heatedBedCheckBox
                containerStackId: machineStackId
                settingKey: "machine_heated_bed"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Heated bed")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3    
            }

            Cura.SimpleCheckBoxCustom  // "Chamber"
            {
                id: heatedChamberCheckBox
                containerStackId: machineStackId
                settingKey: "machine_heated_chamber"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Heated chamber")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                      editable:editable3    
            }

            Cura.ComboBoxWithOptions  // "G-code flavor"
            {
                id: gcodeFlavorComboBox
                containerStackId: machineStackId
                settingKey: "machine_gcode_flavor"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "G-code flavor")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                // FIXME(Lipu): better document this.
                // This has something to do with UM2 and UM2+ regarding "has_material" and the gcode flavor settings.
                // I don't remember exactly what.
                afterOnEditingFinishedFunction: manager.updateHasMaterialsMetadata
                visible:editable3  
            }
            /*Cura.SimpleCheckBoxCustom  // "Acceleration control"
                {
                    id: machineRelativeExtrusion
                    settingStoreIndex: propertyStoreIndex
                    containerStackId: machineStackId
                    settingKey: "machine_relative_extrusion"
                    labelText: catalog.i18nc("@label", "Relative extrusion")
                    labelFont: base.labelFont
                    labelWidth: base.labelWidth
                    forceUpdateOnChangeFunction: forceUpdateFunction
                    editable:editable3   
                    visible:false 
                }
*/

        }

      

        // =======================================
        // Right-side column for "Printhead Settings"
        // =======================================
       /* Column
        {
            anchors.top: column1.top
            anchors.left: column1.right
            width: base.columnWidth
            spacing: base.columnSpacing
            id:column2
            Label   // Title Label
            {
                text: catalog.i18nc("@title:label", "Printhead Settings")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
            }
            Cura.PrintHeadMinMaxTextField  // "X min"
            {
                id: machineXMinField
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "X min")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                axisName: "x"
                axisMinOrMax: "min"
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.PrintHeadMinMaxTextField  // "Y min"
            {
                id: machineYMinField
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Y min")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                axisName: "y"
                axisMinOrMax: "min"
                forceUpdateOnChangeFunction: forceUpdateFunction
            }

            Cura.PrintHeadMinMaxTextField  // "X max"
            {
                id: machineXMaxField
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "X max")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                axisName: "x"
                axisMinOrMax: "max"
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.PrintHeadMinMaxTextField  // "Y max"
            {
                id: machineYMaxField
                containerStackId: machineStackId
                settingKey: "machine_head_with_fans_polygon"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Y max")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                axisName: "y"
                axisMinOrMax: "max"
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.NumericTextFieldWithUnit  // "Gantry Height"
            {
                id: machineGantryHeightField
                containerStackId: machineStackId
                settingKey: "gantry_height"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Gantry Height")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm")
                forceUpdateOnChangeFunction: forceUpdateFunction
            }

            Cura.ComboBoxWithOptions  // "Number of Extruders"
            {
                id: numberOfExtrudersComboBox
                containerStackId: machineStackId
                settingKey: "machine_extruder_count"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Number of Extruders")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                // FIXME(Lipu): better document this.
                // This has something to do with UM2 and UM2+ regarding "has_material" and the gcode flavor settings.
                // I don't remember exactly what.
                afterOnEditingFinishedFunction: manager.updateHasMaterialsMetadata
                setValueFunction: manager.setMachineExtruderCount

                optionModel: ListModel
                {
                    id: extruderCountModel
                    Component.onCompleted:
                    {
                        extruderCountModel.clear()
                        for (var i = 1; i <= Cura.MachineManager.activeMachine.maxExtruderCount; i++)
                        {
                            // Use String as value. JavaScript only has Number. PropertyProvider.setPropertyValue()
                            // takes a QVariant as value, and Number gets translated into a float. This will cause problem
                            // for integer settings such as "Number of Extruders".
                            extruderCountModel.append({ text: String(i), value: String(i) })
                        }
                    }
                }
            }
        }*/
    }  
        Label   // Title Label
        {
            id:lblAccelerationsSettings
            text: catalog.i18nc("@title:label", "Accelerations Settings")
            font: UM.Theme.getFont("medium_bold")
            renderType: Text.NativeRendering
            anchors.top:lblAccelerationsSettings.top
            anchors.left:objectListContainer.right
           anchors.leftMargin:5
           anchors.topMargin:5
        }
        ScrollView
            {
                id: objectListContainer2
                frameVisible: true
                width: parent.width/4.2-10
                height: 600
                anchors.left:lblAccelerationsSettings.left
                anchors.top:lblAccelerationsSettings.bottom
        Column
        {
            width: objectListContainer2.width/2
            id:column11
            spacing: base.columnSpacing
            padding:10
            Cura.SimpleCheckBoxCustom  // "Acceleration control"
            {
                id: machineAccelerationControl
                settingStoreIndex: propertyStoreIndex
                containerStackId: machineStackId
                settingKey: "machine_acceleration_enable"
                labelText: catalog.i18nc("@label", "Acceleration control")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                
            }
              Cura.NumericSliderWithUnit  // "Acceleration print"
            {
                id: machineAccelerationPrint
                containerStackId: machineStackId
                settingKey: "machine_acceleration_print"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Acceleration print")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

        
                titleWidth:170
                sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration infill"
            {
                id: machineAccelerationInfill
                containerStackId: machineStackId
                settingKey: "machine_acceleration_infill"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Acceleration infill")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                
                titleWidth:170
                  sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration wall"
            {
                id: machineAccelerationWall
                containerStackId: machineStackId
                settingKey: "machine_acceleration_wall"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Acceleration wall")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                
                titleWidth:170
                sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration wall 0" 
            {
                id: machineAccelerationWall0
                containerStackId: machineStackId
                settingKey: "machine_acceleration_wall0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Outer Wall Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                
                titleWidth:170
                  sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration wall 0" 
            {
                id: machineAccelerationWallX
                containerStackId: machineStackId
                settingKey: "machine_acceleration_wallX"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Inner Wall Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                titleWidth:170
                 sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
             Cura.NumericSliderWithUnit  // "Acceleration wall roofing" 
            {
                id: machineAccelerationRoofing
                containerStackId: machineStackId
                settingKey: "machine_acceleration_roofing"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Top Surface Skin Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                titleWidth:170
                  sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration topbottom" 
            {
                id: machineAccelerationTopBottom
                containerStackId: machineStackId
                settingKey: "machine_acceleration_topbottom"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Top/Bottom Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                
                titleWidth:170
                  sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
             Cura.NumericSliderWithUnit  // "Acceleration support" 
            {
                id: machineAccelerationSupport
                containerStackId: machineStackId
                settingKey: "machine_acceleration_support"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                
                titleWidth:170
                  sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration support infill" 
            {
                id: machineAccelerationSupportInfill
                containerStackId: machineStackId
                settingKey: "machine_acceleration_support_infill"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support Infill Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                
                titleWidth:170
                  sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration support interface" 
            {
                id: machineAccelerationSupportInterface
                containerStackId: machineStackId
                settingKey: "machine_acceleration_support_interface"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support Interface Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                
               
                titleWidth:170
                sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
           Cura.NumericSliderWithUnit  // "Acceleration support roof" 
            {
                id: machineAccelerationSupportRoof
                containerStackId: machineStackId
                settingKey: "machine_acceleration_support_roof"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support Roof Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                
                titleWidth:170
                sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration support bottom" 
            {
                id: machineAccelerationSupportBottom
                containerStackId: machineStackId
                settingKey: "machine_acceleration_support_bottom"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Support Bottom Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                
                titleWidth:170
             sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
             Cura.NumericSliderWithUnit  // "Acceleration travel" 
            {
                id: machineAccelerationTravel
                containerStackId: machineStackId
                settingKey: "machine_acceleration_travel"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Travel Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                
                titleWidth:170
               sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
               Cura.NumericSliderWithUnit  // "Acceleration prime tower" 
            {
                id: machineAccelerationPrimeTower
                containerStackId: machineStackId
                settingKey: "machine_acceleration_prime_tower"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Prime tower Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                
                titleWidth:170
               sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration first layer" 
            {
                id: machineAccelerationLayer0
                containerStackId: machineStackId
                settingKey: "machine_acceleration_layer_0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "First layer Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                titleWidth:170
                sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration print layer 0" 
            {
                id: machineAccelerationPrintLayer0
                containerStackId: machineStackId
                settingKey: "machine_acceleration_print_layer_0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Initial Layer Print Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

                
                titleWidth:170
                 sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration print travel layer 0" 
            {
                id: machineAccelerationTravelPrintLayer0
                containerStackId: machineStackId
                settingKey: "machine_acceleration_travel_print_layer_0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Initial Layer Travel Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  
                
                titleWidth:170
                sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "Acceleration skirt brim" 
            {
                id: machineAccelerationSkirtBrim
                containerStackId: machineStackId
                settingKey: "machine_acceleration_skirt_brim"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Skirt/brim Acceleration")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s²")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3  

               
                titleWidth:170
                sliderWidth:50
                unitWidth:50
                sliderMin:100
                sliderMax:5000
                precision:0
                minValueWarning:500
                maxValueWarning:3000
                step_value:1     
            }
        }
    }
             Label   // Title Label
            {
                id:lblPrinterJerk
                text: catalog.i18nc("@title:label", "Jerk Settings")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors.left:objectListContainer5.right
                anchors.top:lblRaftController.top
                anchors.leftMargin:5
            }
        ScrollView
            {
                id: objectListContainer3
                frameVisible: true
                width: parent.width/4
                height: 600
                anchors.left:lblPrinterJerk.left
                anchors.top:lblPrinterJerk.bottom
                
        Column
        {
            width: objectListContainer.width/2
            id:columnX
            spacing: base.columnSpacing
            padding:10
            Cura.SimpleCheckBoxCustom  // "Jerk control"
            {
                id: machineJerkControl
                settingStoreIndex: propertyStoreIndex
                containerStackId: machineStackId
                settingKey: "machine_jerk_enable"
                labelText: catalog.i18nc("@label", "Jerk control")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
                             editable:editable3

            }
            Cura.NumericSliderWithUnit  // "jerk print"
            {
                id: machineJerkPrint
                containerStackId: machineStackId
                settingKey: "machine_jerk_print"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk print")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
             Cura.NumericSliderWithUnit  // "jerk infill"
            {
                id: machineJerkInfill
                containerStackId: machineStackId
                settingKey: "machine_jerk_infill"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk infill")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                 sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk wall"
            {
                id: machineJerkWall
                containerStackId: machineStackId
                settingKey: "machine_jerk_wall"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk wall")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1                  
            }
              Cura.NumericSliderWithUnit  // "jerk wall 0"
            {
                id: machineJerkWall0
                containerStackId: machineStackId
                settingKey: "machine_jerk_wall_0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Outer Wall Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1             
            }
            Cura.NumericSliderWithUnit  // "jerk wall 0"
            {
                id: machineJerkWallX
                containerStackId: machineStackId
                settingKey: "machine_jerk_wall_x"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Inner Wall Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }

        Cura.NumericSliderWithUnit  // "jerk roofing"
            {
                id: machineJerkRoofing
                containerStackId: machineStackId
                settingKey: "machine_jerk_roofing"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Top Surface Skin Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            
            Cura.NumericSliderWithUnit  // "jerk topbottom"
            {
                id: machineJerkTopBottom
                containerStackId: machineStackId
                settingKey: "machine_jerk_topbottom"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Top Bottom Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk support"
            {
                id: machineJerkSupport
                containerStackId: machineStackId
                settingKey: "machine_jerk_support"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk support")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }

            Cura.NumericSliderWithUnit  // "jerk support infill"
            {
                id: machineJerkSupportInfill
                containerStackId: machineStackId
                settingKey: "machine_jerk_support_infill"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk support infill")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk support interface"
            {
                id: machineJerkSupportInterface
                containerStackId: machineStackId
                settingKey: "machine_jerk_support_interface"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk support interface")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk support interface roof"
            {
                id: machineJerkSupportInterfaceRoof
                containerStackId: machineStackId
                settingKey: "machine_jerk_support_interface_roof"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk support interface roof")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            } 
            Cura.NumericSliderWithUnit  // "jerk support interface bottom"
            {
                id: machineJerkSupportInterfaceBottom
                containerStackId: machineStackId
                settingKey: "machine_jerk_support_interface_bottom"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk support interface bottom")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk prime tower "
            {
                id: machineJerkPrimeTower
                containerStackId: machineStackId
                settingKey: "machine_jerk_prime_tower"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk prime tower")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk travel "
            {
                id: machineJerkTravel
                containerStackId: machineStackId
                settingKey: "machine_jerk_travel"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Jerk travel")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk layer 0 "
            {
                id: machineJerkLayer0
                containerStackId: machineStackId
                settingKey: "machine_jerk_layer_0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Initial Layer Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk print layer 0 "
            {
                id: machineJerkPrintLayer0
                containerStackId: machineStackId
                settingKey: "machine_jerk_print_layer_0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Initial Layer Print Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
             Cura.NumericSliderWithUnit  // "jerk print layer 0 "
            {
                id: machineJerkTravelLayer0
                containerStackId: machineStackId
                settingKey: "machine_jerk_travel_layer_0"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Initial Layer Travel Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            Cura.NumericSliderWithUnit  // "jerk skirt brim"
            {
                id: machineJerkSkirtBrim
                containerStackId: machineStackId
                settingKey: "machine_jerk_skirt_brim"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Skirt/Brim Jerk")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                controlWidth: base.controlWidth
                unitText: catalog.i18nc("@label", "mm/s")
                forceUpdateOnChangeFunction: forceUpdateFunction
                 editable:editable3
                sliderWidth:50
                unitWidth:50
                sliderMin:0
                sliderMax:100
                precision:0
                minValueWarning:5
                maxValueWarning:20
                step_value:1
            }
            }
        }  
              /* Label   // Title Label
                {
                    id:lblCollingController
                    text: catalog.i18nc("@title:label", "Cooling controller")
                    font: UM.Theme.getFont("medium_bold")
                    renderType: Text.NativeRendering
                    anchors.left:lblPrinterSettings.left
                    anchors.top:objectListContainer.bottom
                }
               ScrollView
                {
                    id: objectListContainer4
                    frameVisible: true
                    width: parent.width/4.2
                    height: 100
                    anchors.left:lblCollingController.left
                    anchors.top:lblCollingController.bottom
                    Column
                    {
                        width: objectListContainer.width/2
                        id:columnXx
                        spacing: base.columnSpacing
                        padding:10
                        Cura.NumericSliderWithUnit  // "machine fan speed min"
                        {
                            id: machineFanSpeedMin
                            containerStackId: machineStackId
                            settingKey: "machine_fan_speed_min"
                            settingStoreIndex: propertyStoreIndex
                            labelText: catalog.i18nc("@label", "Fan speed min")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            controlWidth: base.controlWidth
                            unitText: catalog.i18nc("@label", "%")
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                            titleWidth:100
                            sliderWidth:100
                            unitWidth:50
                            
                            sliderMin:0
                            sliderMax:100
                            precision:0
                            minValueWarning:-1
                            maxValueWarning:110
                            step_value:1
                        }
                        Cura.NumericSliderWithUnit  // "machine fan speed max"
                        {
                            id: machineFanSpeedMax
                            containerStackId: machineStackId
                            settingKey: "machine_fan_speed_max"
                            settingStoreIndex: propertyStoreIndex
                            labelText: catalog.i18nc("@label", "Fan speed max")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            controlWidth: base.controlWidth
                            unitText: catalog.i18nc("@label", "%")
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                            titleWidth:100      
                            sliderWidth:100
                            unitWidth:50
                            sliderMin:0
                            sliderMax:100
                            precision:0
                            minValueWarning:-1
                            maxValueWarning:110
                            step_value:1

                        }
                    }
                }  */

                Label   // Title Label
                {
                    id:lblAditionalFeatures
                    text: catalog.i18nc("@title:label", "Aditional Features")
                    font: UM.Theme.getFont("medium_bold")
                    renderType: Text.NativeRendering
                    anchors.left:lblPrinterSettings.left
                    anchors.top:objectListContainer.bottom
                }
                ScrollView
                {
                    id: objectListContainerAditionalFeatures
                    frameVisible: true
                    width: parent.width/4.2
                    height: 250
                    anchors.left:lblAditionalFeatures.left
                    anchors.top:lblAditionalFeatures.bottom
                    Column
                    {
                        width: objectListContainer.width/2
                        id:columnAditionalFeatures
                        spacing: base.columnSpacing
                        padding:10
                        Cura.SimpleCheckBoxCustom  // Machine encoder sensor
                        {
                            id: machineEncoderSensor
                            settingStoreIndex: propertyStoreIndex
                            containerStackId: machineStackId
                            settingKey: "machine_has_encoder"
                            labelText: catalog.i18nc("@label", "Encoder Sensor")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3    
                        }
                        UM.SettingPropertyProvider
                        {
                            id: machineProperties1
                            containerStackId: machineStackId
                            key: "machine_has_encoder"
                            watchedProperties: [ "value" ]
                            storeIndex: 0
                        }

                        Cura.SimpleCheckBoxCustom  // Machine encoder sensor
                        {
                            id: machineEncoderSensorControl
                            settingStoreIndex: propertyStoreIndex
                            containerStackId: machineStackId
                            settingKey: "machine_encoder_control"
                            labelText: catalog.i18nc("@label", "    Encoder Control")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                        }

                        Cura.NumericSliderWithUnit  // "Machine encoder error percentage"
                        {
                            id: machineEncoderErrorPercentage
                            containerStackId: machineStackId
                            settingKey: "machine_encoder_percentage"
                            settingStoreIndex: propertyStoreIndex
                            labelText: catalog.i18nc("@label", "   Encoder error percentage")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            controlWidth: base.controlWidth
                            unitText: catalog.i18nc("@label", "%")
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                            anchors.left:lblAditionalFeatures.left
                            anchors.leftMargin:10


                            titleWidth:180      
                            sliderWidth:60
                            unitWidth:50
                            sliderMin:20
                            sliderMax:100
                            precision:0
                            minValueWarning:25
                            maxValueWarning:60
                            step_value:1

                        }

                        Cura.SimpleCheckBoxCustom  // Machine door sensor
                        {
                            id: machineDoorSensor
                            settingStoreIndex: propertyStoreIndex
                            containerStackId: machineStackId
                            settingKey: "machine_has_door_sensor"
                            labelText: catalog.i18nc("@label", "Door sensor")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                        }

                        Cura.SimpleCheckBoxCustom  // Machine door security
                        {
                            id: machineDoorSecurity
                            settingStoreIndex: propertyStoreIndex
                            containerStackId: machineStackId
                            settingKey: "machine_door_security"
                            labelText: catalog.i18nc("@label", "    Door security")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                            anchors.left:lblAditionalFeatures.left
                            anchors.leftMargin:10
                        }

                        Cura.SimpleCheckBoxCustom  // Machine adhesion feature
                        {
                            id: machineAdhesionFeature
                            settingStoreIndex: propertyStoreIndex
                            containerStackId: machineStackId
                            settingKey: "machine_has_adhesion_control"
                            labelText: catalog.i18nc("@label", "Adhesion feature")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                        }
                         Cura.NumericSliderWithUnit  // "Machine encoder error percentage"
                        {
                            id: machineLayersNoFan
                            containerStackId: machineStackId
                            settingKey: "machine_layers_no_fan"
                            settingStoreIndex: propertyStoreIndex
                            labelText: catalog.i18nc("@label", "    Layers without fan")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            controlWidth: base.controlWidth
                            unitText: catalog.i18nc("@label", "Layers")
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                            anchors.left:lblAditionalFeatures.left
                            anchors.leftMargin:10

                            titleWidth:180      
                            sliderWidth:60
                            unitWidth:50
                            sliderMin:0
                            sliderMax:20
                            precision:0
                            minValueWarning:4
                            maxValueWarning:10
                            step_value:1

                        }
                       /* Cura.NumericTextFieldWithUnit  // "machine fan speed min"
                        {
                            id: machineFanSpeedMin
                            containerStackId: machineStackId
                            settingKey: "machine_fan_speed_min"
                            settingStoreIndex: propertyStoreIndex
                            labelText: catalog.i18nc("@label", "Fan speed min")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            controlWidth: base.controlWidth
                            unitText: catalog.i18nc("@label", "%")
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                        }
                        
                        Cura.NumericTextFieldWithUnit  // "machine fan speed max"
                        {
                            id: machineFanSpeedMax
                            containerStackId: machineStackId
                            settingKey: "machine_fan_speed_max"
                            settingStoreIndex: propertyStoreIndex
                            labelText: catalog.i18nc("@label", "Fan speed max")
                            labelFont: base.labelFont
                            labelWidth: base.labelWidth
                            controlWidth: base.controlWidth
                            unitText: catalog.i18nc("@label", "%")
                            forceUpdateOnChangeFunction: forceUpdateFunction
                            editable:editable3
                        }*/
                    }
                } 


         Label
            {
                id:lblRaftController
                text: catalog.i18nc("@title:label", "Raft Controller")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors.left:objectListContainer2.right
                anchors.top:lblAccelerationsSettings.top
                anchors.leftMargin:5
            }
            ScrollView
            {
                id: objectListContainer5
                frameVisible: true
                width: parent.width/4.2+50
                height: 380
                anchors.left:lblRaftController.left
                anchors.top:lblRaftController.bottom
                Column
                {
                    width: objectListContainer.width/2
                    id:columnXx3
                    spacing: base.columnSpacing
                    padding:10

                    Cura.NumericSliderWithUnit  // "Raft speed"
                    {
                        id: machineRaftSpeed
                        containerStackId: machineStackId
                        settingKey: "machine_raft_speed"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft speed")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:10
                        maxValueWarning:50
                        step_value:1


                    }  
                     Cura.NumericSliderWithUnit  // "Raft speed roof"
                    {
                        id: machineRaftSpeedRoof
                        containerStackId: machineStackId
                        settingKey: "machine_raft_speed_roof"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft speed roof")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:10
                        maxValueWarning:50
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "Raft speed interface"
                    {
                        id: machineRaftSpeedInterface
                        containerStackId: machineStackId
                        settingKey: "machine_raft_speed_interface"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft speed interface")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                        titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:10
                        maxValueWarning:50
                        step_value:1

                    }
                    Cura.NumericSliderWithUnit  // "Raft speed base"
                    {
                        id: machineRaftSpeedBase
                        containerStackId: machineStackId
                        settingKey: "machine_raft_speed_base"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft speed base")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                        titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:10
                        maxValueWarning:50
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "Raft acceleration"
                    {
                        id: machineRaftAcceleration
                        containerStackId: machineStackId
                        settingKey: "machine_raft_acceleration"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Print Acceleration")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s²")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                        titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:100
                        sliderMax:5000
                        precision:0
                        minValueWarning:500
                        maxValueWarning:3000
                        step_value:1
                    }
                     Cura.NumericSliderWithUnit  // "Raft acceleration roof"
                    {
                        id: machineRaftAccelerationRoof
                        containerStackId: machineStackId
                        settingKey: "machine_raft_acceleration_roof"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Top Print Acceleration")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s²")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                      titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:100
                        sliderMax:5000
                        precision:0
                        minValueWarning:500
                        maxValueWarning:3000
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "Raft acceleration interface"
                    {
                        id: machineRaftAccelerationInterface
                        containerStackId: machineStackId
                        settingKey: "machine_raft_acceleration_interface"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Middle Print Acceleration")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s²")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                         titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:100
                        sliderMax:5000
                        precision:0
                        minValueWarning:500
                        maxValueWarning:3000
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "Raft acceleration base"
                    {
                        id: machineRaftAccelerationBase
                        containerStackId: machineStackId
                        settingKey: "machine_raft_acceleration_base"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Base Print Acceleration")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s²")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:100
                        sliderMax:5000
                        precision:0
                        minValueWarning:500
                        maxValueWarning:3000
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "raft jerk"
                    {
                        id: machineJerk
                        containerStackId: machineStackId
                        settingKey: "machine_raft_jerk"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft jerk")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                        titleWidth:200
                    sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:5
                        maxValueWarning:20
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "raft jerk roof"
                    {
                        id: machineJerkRoof
                        containerStackId: machineStackId
                        settingKey: "machine_raft_jerk_roof"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Top Print Jerk")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3

                        
                        titleWidth:200
                 sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:5
                        maxValueWarning:20
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "raft jerk interface"
                    {
                        id: machineJerkInterface
                        containerStackId: machineStackId
                        settingKey: "machine_raft_jerk_interface"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Middle Print Jerk")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3
                        
                 titleWidth:200
                      sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:5
                        maxValueWarning:20
                        step_value:1
                    }
                    Cura.NumericSliderWithUnit  // "raft jerk base"
                    {
                        id: machineJerkBase
                        containerStackId: machineStackId
                        settingKey: "machine_raft_jerk_base"
                        settingStoreIndex: propertyStoreIndex
                        labelText: catalog.i18nc("@label", "Raft Base Print Jerk")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        controlWidth: base.controlWidth
                        unitText: catalog.i18nc("@label", "mm/s")
                        forceUpdateOnChangeFunction: forceUpdateFunction
                        editable:editable3
    titleWidth:200
                        sliderWidth:70
                        unitWidth:50
                        sliderMin:0
                        sliderMax:100
                        precision:0
                        minValueWarning:5
                        maxValueWarning:20
                        step_value:1
                    }
                }
            }  
          
    }//end item
}
