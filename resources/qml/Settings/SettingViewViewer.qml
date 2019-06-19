// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.2
import UM 1.2 as UM
import Cura 1.0 as Cura
import "../Menus"

Item
{
    id: settingsView
    property QtObject settingVisibilityPresetsModel: CuraApplication.getSettingVisibilityPresetsModel()
    property Action configureSettings
    property bool findingSettings
    Rectangle
    {
        id: filterContainer
        visible: false
        radius: UM.Theme.getSize("setting_control_radius").width
    }
    ToolButton
    {
        id: settingVisibilityMenu
        visible:false
        anchors
        {
            top: filterContainer.top
            bottom: filterContainer.bottom
            right: parent.right
            rightMargin: UM.Theme.getSize("wide_margin").width
        }
    }
    MouseArea
    {
        anchors.fill: scrollView
        acceptedButtons: Qt.AllButtons
        onWheel: wheel.accepted = true
    }
    ScrollView
    {
        id: scrollView
        anchors
        {
            top: filterContainer.bottom
            topMargin: UM.Theme.getSize("default_margin").height
            bottom: parent.bottom
            //right: parent.right
            left: parent.left
        }
        style: UM.Theme.styles.scrollview
        flickableItem.flickableDirection: Flickable.VerticalFlick
        __wheelAreaScrollSpeed: 75  // Scroll three lines in one scroll event
        ListView
        {
            id: contents
            spacing:UM.Theme.getSize("default_lining").height
            cacheBuffer: 1000000   // Set a large cache to effectively just cache every list item.
            model: UM.SettingDefinitionsModel
            {
                id: definitionsModel
                containerId: Cura.MachineManager.activeDefinitionId
                visibilityHandler: UM.SettingPreferenceVisibilityHandler { }
                exclude: ["machine_settings", "command_line_settings",
                "infill_mesh", "infill_mesh_order", "cutting_mesh", 
                 "support_mesh", "anti_overhang_mesh",
                 "travel",
                 "cooling","support","platform_adhesion","dual",
                 "meshfix","blackmagic","experimental"]
                 expanded: CuraApplication.expandedCategories
                 onExpandedChanged:
                {
                    if (!findingSettings)
                    {
                       CuraApplication.setExpandedCategories(expanded)
                    }
                }
                onVisibilityChanged: Cura.SettingInheritanceManager.forceUpdate()
            }
             /* Label
            {
                id:lblExtruderName
                text:"Extruder name:"+Cura.ExtruderManager.getExtruderName(Cura.ExtruderManager.activeExtruderIndex)
                anchors
                {
                    left:definitionsModel.left
                    top:definitionsModel.bottom
                }
            }*/

          /*   UM.SettingPropertyProvider
            {
                id: machineExtruderCount
                containerStack: Cura.MachineManager.activeMachine
                key: "machine_extruder_count"
                watchedProperties: [ "value" ]
                storeIndex: 0
            }*/
            Item
            {
                id:itemExtTemp
                anchors
                {
                    left:definitionsModel.left
                    top:definitionsModel.bottom
                }
                UM.SettingPropertyProvider
                {
                    id: materialTemp
                    containerStackId:  Cura.ExtruderManager.extruderIds[Cura.ExtruderManager.activeExtruderIndex]
                    key: "default_material_print_temperature"
                    watchedProperties: [ "value" ]
                }
                UM.SettingPropertyProvider
                {
                    id: bedTemperature
                  containerStackId:  Cura.ExtruderManager.extruderIds[Cura.ExtruderManager.activeExtruderIndex]
                    key: "material_bed_temperature"
          watchedProperties: [ "value" ]
                }
                 UM.SettingPropertyProvider
                {
                    id: firstLayerTemperature
                  containerStackId:  Cura.ExtruderManager.extruderIds[Cura.ExtruderManager.activeExtruderIndex]
                    key: "material_print_temperature_layer_0"
                  watchedProperties: [ "value" ]
                }
              

              /*               UM.SettingPropertyProvider
                {
                    id: layerHeight
                    containerStackId: Cura.MachineManager.activeMachineId
                    key: "layer_height"
                    watchedProperties: [ "value", "enabled", "state", "validationState", "settable_per_extruder", "resolve" ]
                    storeIndex: 0
                    removeUnusedValue: model.resolve == undefined
                }
*/

         
        UM.SettingPropertyProvider
        {
            id: layerHeight
            containerStack: Cura.MachineManager.activeStack
            key: "layer_height"
            watchedProperties: ["value"]
        }

           UM.SettingPropertyProvider
                {
                    id: nozzleSize
                  containerStackId:  Cura.ExtruderManager.extruderIds[Cura.ExtruderManager.activeExtruderIndex]
                    key: "machine_nozzle_size"
                  watchedProperties: [ "value" ]
                }

       UM.SettingPropertyProvider
                {
                    id: filamentDiameter
                  containerStackId:  Cura.ExtruderManager.extruderIds[Cura.ExtruderManager.activeExtruderIndex]
                    key: "material_diameter"
                  watchedProperties: [ "value" ]
                }

                Label
                {
                    id:lblTemperatureExtruder
                    text:catalog.i18nc("@title:label", "Printing Temperature")+":"+materialTemp.properties.value
                    anchors
                    {
                        left:definitionsModel.left
                        top:definitionsModel.bottom
                    }
                }
                Label
                {
                    id:lblTemperatureFirstLayer
                    text:catalog.i18nc("@title:label", "Printing Temperature Initial Layer")+":"+firstLayerTemperature.properties.value
                    anchors
                    {
                        left:definitionsModel.left
                        top:lblTemperatureExtruder.bottom
                    }
                }
                Label
                {
                    id:lblTemperatureBed
                    text:catalog.i18nc("@title:label", "Bed Temperature")+":"+bedTemperature.properties.value
                    anchors
                    {
                        left:definitionsModel.left
                        top:lblTemperatureFirstLayer.bottom
                    }
                }
                Label
                {
                    id:lblLayerHeight
                    text:catalog.i18nc("@title:label", "Layer Height")+":"+layerHeight.properties.value
                    anchors
                    {
                        left:definitionsModel.left
                        top:lblTemperatureBed.bottom
                    }
                }
                Label
                {
                    id:lblNozzleSize
                    text:catalog.i18nc("@title:label", "Nozzle Size")+":"+nozzleSize.properties.value
                    anchors
                    {
                        left:definitionsModel.left
                        top:lblLayerHeight.bottom
                    }
                }
                Label
                {
                    id:lblFilamentDiameter
                    text:catalog.i18nc("@title:label", "Filament diameter")+":"+filamentDiameter.properties.value
                    anchors
                    {
                        left:definitionsModel.left
                        top:lblNozzleSize.bottom
                    }
                }
            }
            /*
            UM.SettingPropertyProvider
            {
                id: extruderTemperature
                containerStackId: Cura.ExtruderManager.extruderIds[position]
                key: "material_print_temperature"
                watchedProperties: ["value", "minimum_value", "maximum_value", "resolve"]
                storeIndex: 0
                property var resolve: Cura.MachineManager.activeStack != Cura.MachineManager.activeMachine ? properties.resolve : "None"
                 anchors
                {
                    left:definitionsModel.left
                    top:lblExtruderName.bottom
                }
            }*/

            property var indexWithFocus: -1
           /* delegate: Loader
            {
                id: delegate
                width: scrollView.width
                height: provider.properties.enabled == "True" ? UM.Theme.getSize("section").height : - contents.spacing
                Behavior on height { NumberAnimation { duration: 100 } }
                opacity: provider.properties.enabled == "True" ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
                anchors
                {
                    left:definitionsModel.left
                    top:lblTemp.bottom
                }
                enabled:
                {
                    if (!Cura.ExtruderManager.activeExtruderStackId && machineExtruderCount.properties.value > 1)
                    {
                        // disable all controls on the global tab, except categories
                        return model.type == "category"
                    }
                    return provider.properties.enabled == "True"
                }
                property var definition: model
                property var settingDefinitionsModel: definitionsModel
                property var propertyProvider: provider
                property var globalPropertyProvider: inheritStackProvider
                property var externalResetHandler: false
                asynchronous: model.type != "enum" && model.type != "extruder" && model.type != "optional_extruder"
                active: model.type != undefined
                source:
                {
                    switch(model.type)
                    {
                        case "int":
                            return "SettingTextField.qml"
                        case "[int]":
                            return "SettingTextField.qml"
                        case "float":
                            return "SettingTextField.qml"
                        case "enum":
                            return "SettingComboBox.qml"
                        case "extruder":
                            return "SettingExtruder.qml"
                        case "bool":
                            return "SettingCheckBox.qml"
                        case "str":
                            return "SettingTextField.qml"
                        case "category":
                            return "SettingCategory.qml"
                        case "optional_extruder":
                            return "SettingOptionalExtruder.qml"
                        default:
                            return "SettingUnknown.qml"
                    }
                }
                // Binding to ensure that the right containerstack ID is set for the provider.
                // This ensures that if a setting has a limit_to_extruder id (for instance; Support speed points to the
                // extruder that actually prints the support, as that is the setting we need to use to calculate the value)
                Binding
                {
                    target: provider
                    property: "containerStackId"
                    when: model.settable_per_extruder||(inheritStackProvider.properties.limit_to_extruder != null && inheritStackProvider.properties.limit_to_extruder >= 0);
                    value:
                    {
                        // associate this binding with Cura.MachineManager.activeMachineId in the beginning so this
                        // binding will be triggered when activeMachineId is changed too.
                        // Otherwise, if this value only depends on the extruderIds, it won't get updated when the
                        // machine gets changed.
                        var activeMachineId = Cura.MachineManager.activeMachineId;
                        if (!model.settable_per_extruder)
                        {
                            //Not settable per extruder or there only is global, so we must pick global.
                            return activeMachineId;
                        }
                        if (inheritStackProvider.properties.limit_to_extruder != null && inheritStackProvider.properties.limit_to_extruder >= 0)
                        {
                            //We have limit_to_extruder, so pick that stack.
                            return Cura.ExtruderManager.extruderIds[String(inheritStackProvider.properties.limit_to_extruder)];
                        }
                        if (Cura.ExtruderManager.activeExtruderStackId)
                        {
                            //We're on an extruder tab. Pick the current extruder.
                            return Cura.ExtruderManager.activeExtruderStackId;
                        }
                        //No extruder tab is selected. Pick the global stack. Shouldn't happen any more since we removed the global tab.
                        return activeMachineId;
                    }
                }
                // Specialty provider that only watches global_inherits (we cant filter on what property changed we get events
                // so we bypass that to make a dedicated provider).
                UM.SettingPropertyProvider
                {
                    id: inheritStackProvider
                    containerStackId: Cura.MachineManager.activeMachineId
                    key: model.key
                    watchedProperties: [ "limit_to_extruder" ]
                }
                UM.SettingPropertyProvider
                {
                    id: provider
                    containerStackId: Cura.MachineManager.activeMachineId
                    key: model.key ? model.key : ""
                    watchedProperties: [ "value", "enabled", "state", "validationState", "settable_per_extruder", "resolve" ]
                    storeIndex: 0
                    removeUnusedValue: model.resolve == undefined
                }
                Connections
                {
                    target: item
                    onContextMenuRequested:
                    {
                        contextMenu.key = model.key;
                        contextMenu.settingVisible = model.visible;
                        contextMenu.provider = provider
                        contextMenu.popup();
                    }
                    onShowTooltip: base.showTooltip(delegate, Qt.point(- settingsView.x - UM.Theme.getSize("default_margin").width, 0), text)
                    onHideTooltip: base.hideTooltip()
                    onShowAllHiddenInheritedSettings:
                    {
                        var children_with_override = Cura.SettingInheritanceManager.getChildrenKeysWithOverride(category_id)
                        for(var i = 0; i < children_with_override.length; i++)
                        {
                            definitionsModel.setVisible(children_with_override[i], true)
                        }
                        Cura.SettingInheritanceManager.manualRemoveOverride(category_id)
                    }
                    onFocusReceived:
                    {
                        contents.indexWithFocus = index;
                        animateContentY.from = contents.contentY;
                        contents.positionViewAtIndex(index, ListView.Contain);
                        animateContentY.to = contents.contentY;
                        animateContentY.running = true;
                    }
                    onSetActiveFocusToNextSetting:
                    {
                        if (forward == undefined || forward)
                        {
                            contents.currentIndex = contents.indexWithFocus + 1;
                            while(contents.currentItem && contents.currentItem.height <= 0)
                            {
                                contents.currentIndex++;
                            }
                            if (contents.currentItem)
                            {
                                contents.currentItem.item.focusItem.forceActiveFocus();
                            }
                        }
                        else
                        {
                            contents.currentIndex = contents.indexWithFocus - 1;
                            while(contents.currentItem && contents.currentItem.height <= 0)
                            {
                                contents.currentIndex--;
                            }
                            if (contents.currentItem)
                            {
                                contents.currentItem.item.focusItem.forceActiveFocus();
                            }
                        }
                    }
                }
            }*/
            UM.I18nCatalog { id: catalog; name: "cura"; }
            NumberAnimation {
                id: animateContentY
                target: contents
                property: "contentY"
                duration: 50
            }
            add: Transition {
                SequentialAnimation {
                    NumberAnimation { properties: "height"; from: 0; duration: 100 }
                    NumberAnimation { properties: "opacity"; from: 0; duration: 100 }
                }
            }
            remove: Transition {
                SequentialAnimation {
                    NumberAnimation { properties: "opacity"; to: 0; duration: 100 }
                    NumberAnimation { properties: "height"; to: 0; duration: 100 }
                }
            }
            addDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 100 }
            }
            removeDisplaced: Transition {
                SequentialAnimation {
                    PauseAnimation { duration: 100; }
                    NumberAnimation { properties: "x,y"; duration: 100 }
                }
            }
            Menu
            {
                id: contextMenu
                property string key
                property var provider
                property bool settingVisible
                MenuItem
                {
                    text: catalog.i18nc("@action:menu", "Copy value to all extruders")
                    visible: machineExtruderCount.properties.value > 1
                    enabled: contextMenu.provider != undefined && contextMenu.provider.properties.settable_per_extruder != "False"
                    onTriggered: Cura.MachineManager.copyValueToExtruders(contextMenu.key)
                }
                MenuItem
                {
                    text: catalog.i18nc("@action:menu", "Copy all changed values to all extruders")
                    visible: machineExtruderCount.properties.value > 1
                    enabled: contextMenu.provider != undefined
                    onTriggered: Cura.MachineManager.copyAllValuesToExtruders()
                }
                MenuSeparator
                {
                    visible: machineExtruderCount.properties.value > 1
                }
                Instantiator
                {
                    id: customMenuItems
                    model: Cura.SidebarCustomMenuItemsModel { }
                    MenuItem
                    {
                        text: model.name
                        iconName: model.icon_name
                        onTriggered:
                        {
                            customMenuItems.model.callMenuItemMethod(name, model.actions, {"key": contextMenu.key})
                        }
                    }
                   onObjectAdded: contextMenu.insertItem(index, object)
                   onObjectRemoved: contextMenu.removeItem(object)
                }
                MenuSeparator
                {
                    visible: customMenuItems.count > 0
                }
                MenuItem
                {
                    visible: !findingSettings
                    text: catalog.i18nc("@action:menu", "Hide this setting");
                    onTriggered:
                    {
                        definitionsModel.hide(contextMenu.key);
                        if (settingVisibilityPresetsModel.activePreset != "")
                        {
                            settingVisibilityPresetsModel.setActivePreset("custom");
                        }
                    }
                }
                MenuItem
                {
                    text:
                    {
                        if (contextMenu.settingVisible)
                        {
                            return catalog.i18nc("@action:menu", "Don't show this setting");
                        }
                        else
                        {
                            return catalog.i18nc("@action:menu", "Keep this setting visible");
                        }
                    }
                    visible: findingSettings
                    onTriggered:
                    {
                        if (contextMenu.settingVisible)
                        {
                            definitionsModel.hide(contextMenu.key);
                        }
                        else
                        {
                            definitionsModel.show(contextMenu.key);
                        }
                        if (settingVisibilityPresetsModel.activePreset != "")
                        {
                            settingVisibilityPresetsModel.setActivePreset("custom");
                        }
                    }
                }
                MenuItem
                {
                    text: catalog.i18nc("@action:menu", "Configure setting visibility...");
                    onTriggered: Cura.Actions.configureSettingVisibility.trigger(contextMenu);
                }
            }
            UM.SettingPropertyProvider
            {
                id: machineExtruderCount
                containerStackId: Cura.MachineManager.activeMachineId
                key: "machine_extruder_count"
                watchedProperties: [ "value" ]
                storeIndex: 0
            }
        }
    }
}
