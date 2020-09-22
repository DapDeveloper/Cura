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
                width: parent.width/2
                height: 100
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
            }

            Cura.SimpleCheckBox  // "Origin at center"
            {
                id: originAtCenterCheckBox
                containerStackId: machineStackId
                settingKey: "machine_center_is_zero"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Origin at center")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.SimpleCheckBox  // "Heated bed"
            {
                id: heatedBedCheckBox
                containerStackId: machineStackId
                settingKey: "machine_heated_bed"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Heated bed")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
            Cura.SimpleCheckBox  // "Chamber"
            {
                id: heatedChamberCheckBox
                containerStackId: machineStackId
                settingKey: "machine_heated_chamber"
                settingStoreIndex: propertyStoreIndex
                labelText: catalog.i18nc("@label", "Heated chamber")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
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
            }
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
           anchors.margins:20
        }
       ScrollView
            {
                id: objectListContainer2
                frameVisible: true
                width: parent.width/2-20
                height: 100
                anchors.left:lblAccelerationsSettings.left
                anchors.top:lblAccelerationsSettings.bottom
        Column
        {
            width: objectListContainer2.width/2
            id:column11
            spacing: base.columnSpacing
            padding:10
            Cura.SimpleCheckBox  // "Acceleration control"
            {
                id: machineAccelerationControl
                settingStoreIndex: propertyStoreIndex
                containerStackId: machineStackId
                settingKey: "machine_acceleration_enable"
                labelText: catalog.i18nc("@label", "Acceleration control")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
            }
              Cura.NumericTextFieldWithUnit  // "Acceleration print"
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
            }
             Cura.NumericTextFieldWithUnit  // "Acceleration infill"
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration wall"
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration wall 0" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration wall 0" 
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
            }
             Cura.NumericTextFieldWithUnit  // "Acceleration wall roofing" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration topbottom" 
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
            }
             Cura.NumericTextFieldWithUnit  // "Acceleration support" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration support infill" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration support interface" 
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
            }
           Cura.NumericTextFieldWithUnit  // "Acceleration support roof" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration support bottom" 
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
            }
             Cura.NumericTextFieldWithUnit  // "Acceleration travel" 
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
            }
               Cura.NumericTextFieldWithUnit  // "Acceleration prime tower" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration first layer" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration print layer 0" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration print travel layer 0" 
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
            }
            Cura.NumericTextFieldWithUnit  // "Acceleration skirt brim" 
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
            }
          
            
        }
    }

             Label   // Title Label
            {
                id:lblPrinterJerk
                text: catalog.i18nc("@title:label", "Jerk Settings")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors.left:lblPrinterSettings.left
                anchors.top:objectListContainer.bottom
            }

        ScrollView
            {
                id: objectListContainer3
                frameVisible: true
                width: parent.width/2
                height: 100
                anchors.left:lblPrinterJerk.left
                anchors.top:lblPrinterJerk.bottom
        Column
        {
            width: objectListContainer.width/2
            id:columnX
            spacing: base.columnSpacing
            padding:10

            Cura.SimpleCheckBox  // "Jerk control"
            {
                id: machineJerkControl
                settingStoreIndex: propertyStoreIndex
                containerStackId: machineStackId
                settingKey: "machine_jerk_enable"
                labelText: catalog.i18nc("@label", "Jerk control")
                labelFont: base.labelFont
                labelWidth: base.labelWidth
                forceUpdateOnChangeFunction: forceUpdateFunction
            }

            Cura.NumericTextFieldWithUnit  // "jerk print"
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
            }

             Cura.NumericTextFieldWithUnit  // "jerk infill"
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk wall"
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
            }
              Cura.NumericTextFieldWithUnit  // "jerk wall 0"
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
            }

            Cura.NumericTextFieldWithUnit  // "jerk wall 0"
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
            }

        Cura.NumericTextFieldWithUnit  // "jerk roofing"
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
            }
            
            Cura.NumericTextFieldWithUnit  // "jerk topbottom"
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk support"
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
            }

            Cura.NumericTextFieldWithUnit  // "jerk support infill"
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk support interface"
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk support interface roof"
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
            } 
            Cura.NumericTextFieldWithUnit  // "jerk support interface bottom"
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk prime tower "
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk travel "
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk layer 0 "
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk print layer 0 "
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
            }
             Cura.NumericTextFieldWithUnit  // "jerk print layer 0 "
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
            }
            Cura.NumericTextFieldWithUnit  // "jerk skirt brim"
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
            }

        }
    }  

               /*Label   // Title Label
                {
                    id:lblCollingController
                    text: catalog.i18nc("@title:label", "Cooling controller")
                    font: UM.Theme.getFont("medium_bold")
                    renderType: Text.NativeRendering
                    anchors.left:lblAccelerationsSettings.left
                    anchors.top:objectListContainer.bottom
                }
               ScrollView
                {
                    id: objectListContainer4
                    frameVisible: true
                    width: parent.width/2-20
                    height: 100
                    anchors.left:lblCollingController.left
                    anchors.top:lblCollingController.bottom
                    Column
                    {
                        width: objectListContainer.width/2
                        id:columnXx
                        spacing: base.columnSpacing
                        padding:10
                        Cura.NumericTextFieldWithUnit  // "machine fan speed min"
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
                        }
                    }
                }  */

         Label
            {
                id:lblRaftController
                text: catalog.i18nc("@title:label", "Raft controller")
                font: UM.Theme.getFont("medium_bold")
                renderType: Text.NativeRendering
                anchors.left:lblAccelerationsSettings.left
                anchors.top:objectListContainer.bottom
               
            }
            ScrollView
            {
                id: objectListContainer5
                frameVisible: true
                width: parent.width/2
                height: 100
                anchors.left:lblRaftController.left
                anchors.top:lblRaftController.bottom
                Column
                {
                    width: objectListContainer.width/2
                    id:columnXx3
                    spacing: base.columnSpacing
                    padding:10

                    Cura.NumericTextFieldWithUnit  // "Raft speed"
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
                    }  
                     Cura.NumericTextFieldWithUnit  // "Raft speed roof"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "Raft speed interface"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "Raft speed base"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "Raft acceleration"
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
                    }
                     Cura.NumericTextFieldWithUnit  // "Raft acceleration roof"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "Raft acceleration interface"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "Raft acceleration base"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "raft jerk"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "raft jerk roof"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "raft jerk interface"
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
                    }
                    Cura.NumericTextFieldWithUnit  // "raft jerk base"
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
                    }
                }
            }  
           /* Item
            { 
                anchors.left:objectListContainer5.right
                anchors.top:lblRaftController.top
                anchors.margins:20
                Cura.SimpleCheckBox  // "Acceleration control"
                    {
                        id: machineRelativeExtrusion
                        settingStoreIndex: propertyStoreIndex
                        containerStackId: machineStackId
                        settingKey: "machine_relative_extrusion"
                       
                        labelText: catalog.i18nc("@label", "Relative extrusion")
                        labelFont: base.labelFont
                        labelWidth: base.labelWidth
                        forceUpdateOnChangeFunction: forceUpdateFunction
                    }

            }*/
    }//end item
}
