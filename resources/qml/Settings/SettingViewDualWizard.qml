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
    // Mouse area that gathers the scroll events to not propagate it to the main view.
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
            right: parent.right
            left: parent.left
        }

        style: UM.Theme.styles.scrollview
        flickableItem.flickableDirection: Flickable.VerticalFlick
        __wheelAreaScrollSpeed: 75  // Scroll three lines in one scroll event
        ListView
        {
            id: contents
            spacing: UM.Theme.getSize("default_lining").height
            cacheBuffer: 1000000   // Set a large cache to effectively just cache every list item.
            model: UM.SettingDefinitionsModel
            {
                id: definitionsModel
                containerId: Cura.MachineManager.activeDefinitionId
                visibilityHandler: UM.SettingPreferenceVisibilityHandler { }
                /*
                  exclude: ["machine_settings", "command_line_settings",
                 "infill_mesh", "infill_mesh_order", "cutting_mesh", 
                 "support_mesh", "anti_overhang_mesh",
                 "resolution","shell","infill","speed","travel",
                 "cooling","support","platform_adhesion","dual",
                 "meshfix","blackmagic","experimental","material"
                 ,] 
                */
                 exclude: ["wall_thickness","wall_0_wipe_dist","resolution",
                 "material","speed","travel","cooling",
                 "roofing_layer_count","top_bottom_thickness",
                 "top_bottom_pattern","top_bottom_pattern_0","skin_angles",
                 "wall_0_inset","optimize_wall_printing_order","outer_inset_first",
                 "alternate_extra_perimeter","travel_compensate_overlapping_walls_enabled",
                 "fill_perimeter_gaps","filter_out_tiny_gaps","fill_outline_gaps",
                 "xy_offset","xy_offset_layer_0","z_seam_type","z_seam_corner",
                 "skin_no_small_gaps_heuristic","ironing_enabled","skin_outline_count",
                 "infill_sparse_density","infill_pattern","zig_zaggify_infill",
                 "connect_infill_polygons","infill_angles","infill_offset_x",
                 "infill_offset_y","infill_multiplier","infill_overlap","skin_outline_count",
                 "infill_wipe_dist","infill_sparse_thickness","gradual_infill_steps",
                 "infill_support_enabled","skin_preshrink","expand_skins_expand_distance",
                 "max_skin_angle_for_expansion","support_enable","adhesion_type",
                 "skirt_line_count","skirt_gap","skirt_brim_minimal_length",
                 "brim_width","brim_replaces_support","brim_outside_only","raft_margin",
                 "raft_smoothing","raft_airgap","layer_0_z_overlap","raft_surface_layers",
                 "raft_surface_thickness","raft_surface_line_width","raft_surface_line_spacing",
                 "raft_interface_thickness","raft_interface_line_width","raft_interface_line_spacing",
                 "raft_base_thickness","raft_base_line_width","raft_base_line_spacing","raft_speed",
                 "raft_acceleration","raft_jerk","raft_fan_speed","min_infill_area","infill_before_walls",
                 "support_type","support_angle","support_pattern","support_wall_count",
                 "zig_zaggify_support","support_connect_zigzags","support_infill_rate",
                 "support_z_distance","support_xy_distance","support_xy_overrides_z",
                 "support_xy_distance_overhang","support_bottom_stair_step_height",
                 "support_bottom_stair_step_width","support_join_distance",
                 "support_interface_enable","support_interface_height","support_use_towers",
                 "support_tower_diameter","support_tower_maximum_supported_diameter","support_tower_roof_angle",
                 "support_offset","support_infill_sparse_thickness","gradual_support_infill_steps",
                 "minimum_support_area","skin_overlap_mm","platform_adhesion",
                 "dual","meshfix","blackmagic","experimental"]  // TODO: infill_mesh settigns are excluded hardcoded, but should be based on the fact that settable_globally, settable_per_meshgroup and settable_per_extruder are false.
                 expanded: CuraApplication.expandedCategories
                onExpandedChanged:
                {
                    if (!findingSettings)
                    {
                        // Do not change expandedCategories preference while filtering settings
                        // because all categories are expanded while filtering
                        CuraApplication.setExpandedCategories(expanded)
                    }
                }
                onVisibilityChanged: Cura.SettingInheritanceManager.forceUpdate()
            }
            property var indexWithFocus: -1
            delegate: Loader
            {
                id: delegate
                width: scrollView.width
                height: provider.properties.enabled == "True" ? UM.Theme.getSize("section").height : - contents.spacing
                Behavior on height { NumberAnimation { duration: 100 } }
                opacity: provider.properties.enabled == "True" ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
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
                property real minValueWarning:materialData.properties.minimum_value_warning
                property real maxValueWarning:materialData.properties.maximum_value_warning
                property var defaultValue:materialData.properties.default_value
                property real stepSizeValue:materialData.properties.step_value
                property int precision:materialData.properties.precision
                property real sliderMin:materialData.properties.slider_min
                property real sliderMax:materialData.properties.slider_max
                //Qt5.4.2 and earlier has a bug where this causes a crash: https://bugreports.qt.io/browse/QTBUG-35989
                //In addition, while it works for 5.5 and higher, the ordering of the actual combo box drop down changes,
                //causing nasty issues when selecting different options. So disable asynchronous loading of enum type completely.
                asynchronous: model.type != "enum" && model.type != "extruder" && model.type != "optional_extruder"
                active: model.type != undefined
                source:
                {
                    switch(model.type)
                    {
                        case "int":
                            return "SettingTextFieldSlider.qml"
                        case "[int]":
                            return "SettingTextFieldSlider.qml"
                        case "float":
                            return "SettingTextFieldSlider.qml"
                        case "enum":
                            return "SettingComboBox.qml"
                        case "extruder":
                            return "SettingExtruderC.qml"
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
                    when: model.settable_per_extruder || (inheritStackProvider.properties.limit_to_extruder != null && inheritStackProvider.properties.limit_to_extruder >= 0);
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

                UM.SettingPropertyProvider
                {
                    id: materialData
                    containerStackId:  Cura.ExtruderManager.extruderIds[Cura.ExtruderManager.activeExtruderIndex]
                    key: model.key
                    watchedProperties: [ 
                                        "minimum_value_warning","maximum_value_warning","default_value","step_value","precision","slider_min","slider_max"
                                        ]
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
                    //onShowTooltip: base.showTooltip(delegate, Qt.point(- settingsView.x - UM.Theme.getSize("default_margin").width, 0), text)
                    //onHideTooltip: base.hideTooltip()
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
            }

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
                    //: Settings context menu action
                    text: catalog.i18nc("@action:menu", "Copy value to all extruders")
                    visible: machineExtruderCount.properties.value > 1
                    enabled: contextMenu.provider != undefined && contextMenu.provider.properties.settable_per_extruder != "False"
                    onTriggered: Cura.MachineManager.copyValueToExtruders(contextMenu.key)
                }

                MenuItem
                {
                    //: Settings context menu action
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
                    //: Settings context menu action
                    visible: !findingSettings
                    text: catalog.i18nc("@action:menu", "Hide this setting");
                    onTriggered:
                    {
                        definitionsModel.hide(contextMenu.key);
                        // visible settings have changed, so we're no longer showing a preset
                        if (settingVisibilityPresetsModel.activePreset != "")
                        {
                            settingVisibilityPresetsModel.setActivePreset("custom");
                        }
                    }
                }
                MenuItem
                {
                    //: Settings context menu action
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
                        // visible settings have changed, so we're no longer showing a preset
                        if (settingVisibilityPresetsModel.activePreset != "")
                        {
                            settingVisibilityPresetsModel.setActivePreset("custom");
                        }
                    }
                }
                MenuItem
                {
                    //: Settings context menu action
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
