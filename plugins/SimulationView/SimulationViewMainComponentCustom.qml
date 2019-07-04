// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0
import UM 1.4 as UM
import Cura 1.0 as Cura

Item
{
    property bool is_simulation_playing: false
    visible: UM.SimulationView.layerActivity && CuraApplication.platformActivity
    PathSlider
    {
        id: pathSlider
        height: UM.Theme.getSize("slider_handle").width
        width: UM.Theme.getSize("slider_layerview_size").height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50//UM.Theme.getSize("default_margin").height
        /*
        anchors.left:parent.left
        anchors.leftMargin:200
        */
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter:parent.verticalCenter
        visible: !UM.SimulationView.compatibilityMode
        // Custom properties
        handleValue: UM.SimulationView.currentPath
        maximumValue: UM.SimulationView.numPaths
        // Update values when layer data changes.
        Connections
        {
            target: UM.SimulationView
            onMaxPathsChanged: pathSlider.setHandleValue(UM.SimulationView.currentPath)
            onCurrentPathChanged:
            {
                // Only pause the simulation when the layer was changed manually, not when the simulation is running
                if (pathSlider.manuallyChanged)
                {
                    playButton.pauseSimulation()
                }
                pathSlider.setHandleValue(UM.SimulationView.currentPath)
            }
        }
        // Ensure that the slider handlers show the correct value after switching views.
        Component.onCompleted:
        {
            pathSlider.setHandleValue(UM.SimulationView.currentPath)
        }
    }
    UM.SimpleButton
    {
        id: playButton
        iconSource: !is_simulation_playing ? "./resources/simulation_resume.svg": "./resources/simulation_pause.svg"
        width: UM.Theme.getSize("small_button").width
        height: UM.Theme.getSize("small_button").height
        hoverColor: UM.Theme.getColor("slider_handle_active")
        color: UM.Theme.getColor("slider_handle")
        iconMargin: UM.Theme.getSize("thick_lining").width
        visible: !UM.SimulationView.compatibilityMode
        Connections
        {
            target: UM.Preferences
            onPreferenceChanged:
            {
                if (preference !== "view/only_show_top_layers" && preference !== "view/top_layer_count" && ! preference.match("layerview/"))
                {
                    return;
                }
                playButton.pauseSimulation()
            }
        }
        anchors
        {
            right: pathSlider.left
            verticalCenter: pathSlider.verticalCenter
        }
        onClicked:
        {
            if(is_simulation_playing)
            {
                pauseSimulation()
            }
            else
            {
                resumeSimulation()
            }
        }
        function pauseSimulation()
        {
            UM.SimulationView.setSimulationRunning(false)
            simulationTimer.stop()
            is_simulation_playing = false
            layerSlider.manuallyChanged = true
            pathSlider.manuallyChanged = true
        }
        function resumeSimulation()
        {
            UM.SimulationView.setSimulationRunning(true)
            simulationTimer.start()
            layerSlider.manuallyChanged = false
            pathSlider.manuallyChanged = false
        }
    }
    /*
    Speed control slider
    */
    TimerSliderSpeed
    {
        id: timerSliderSpeed
        width: UM.Theme.getSize("slider_handle").width
        height:100//UM.Theme.getSize("slider_layerview_size").height
        anchors
        {
            left: pathSlider.right
            verticalCenter: pathSlider.verticalCenter
            //rightMargin: UM.Theme.getSize("default_margin").width
            //top:parent.top
            //bottom:pathSlider.bottom
            /*bottomMargin:150
            rightMargin:200*/
        }
        // Custom properties
        //upperValue:UM.SimulationView.simulationSpeed
        lowerValue: 0
        maximumValue:300
        // Update values when layer data changes
        Connections
        {
            target: UM.SimulationView
            onSimSpeedChanged: timerSliderSpeed.setUpperValue(UM.SimulationView.simulationSpeed)
            //onMinimumLayerChanged: layerSlider.setLowerValue(UM.SimulationView.minimumLayer)
            /*onCurrentLayerChanged:
            {
                //playButton.pauseSimulation()
                timerSliderSpeed.setUpperValue(UM.SimulationView.simulationSpeed)
            }*/
        }
        // Make sure the slider handlers show the correct value after switching views
        Component.onCompleted:
        {
          //  layerSlider.setLowerValue(UM.SimulationView.minimumLayer)
           timerSliderSpeed.setUpperValue(UM.SimulationView.simulationSpeed)
        }
    }
    Timer
    {
        id: simulationTimer
        interval: UM.SimulationView.simulationSpeed
        running: false
        repeat: true
        onTriggered:
        {
            simulationTimer.interval=UM.SimulationView.simulationSpeed
            var currentPath = UM.SimulationView.currentPath
            var numPaths = UM.SimulationView.numPaths
            var currentLayer = UM.SimulationView.currentLayer
            var numLayers = UM.SimulationView.numLayers
            // When the user plays the simulation, if the path slider is at the end of this layer, we start
            // the simulation at the beginning of the current layer.
            if (!is_simulation_playing)
            {
                if (currentPath >= numPaths)
                {
                    UM.SimulationView.setCurrentPath(0)
                }
                else
                {
                    UM.SimulationView.setCurrentPath(currentPath + 1)
                }
            }
            // If the simulation is already playing and we reach the end of a layer, then it automatically
            // starts at the beginning of the next layer.
            else
            {
                if (currentPath >= numPaths)
                {
                    // At the end of the model, the simulation stops
                    if (currentLayer >= numLayers)
                    {
                        playButton.pauseSimulation()
                    }
                    else
                    {
                        UM.SimulationView.setCurrentLayer(currentLayer + 1)
                        UM.SimulationView.setCurrentPath(0)
                    }
                }
                else
                {
                    UM.SimulationView.setCurrentPath(currentPath + 1)
                }
            }
            // The status must be set here instead of in the resumeSimulation function otherwise it won't work
            // correctly, because part of the logic is in this trigger function.
            is_simulation_playing = true
        }
    }
    LayerSlider
    {
        id: layerSlider
        width: UM.Theme.getSize("slider_handle").width
        height: UM.Theme.getSize("slider_layerview_size").height
        anchors
        {
            right: parent.right
            //verticalCenter: parent.verticalCenter          
            //rightMargin: UM.Theme.getSize("default_margin").width
            //top:parent.top
            bottom:parent.bottom
            bottomMargin:150
            rightMargin:10
        }
        // Custom properties
        upperValue: UM.SimulationView.currentLayer
        lowerValue: UM.SimulationView.minimumLayer
        maximumValue: UM.SimulationView.numLayers
        // Update values when layer data changes
        Connections
        {
            target: UM.SimulationView
            onMaxLayersChanged: layerSlider.setUpperValue(UM.SimulationView.currentLayer)
            onMinimumLayerChanged: layerSlider.setLowerValue(UM.SimulationView.minimumLayer)
            onCurrentLayerChanged:
            { 
                // Only pause the simulation when the layer was changed manually, not when the simulation is running
                if (layerSlider.manuallyChanged)
                {
                    playButton.pauseSimulation()
                }
                layerSlider.setUpperValue(UM.SimulationView.currentLayer)
            }
        }
        // Make sure the slider handlers show the correct value after switching views
        Component.onCompleted:
        {
            layerSlider.setLowerValue(UM.SimulationView.minimumLayer)
            layerSlider.setUpperValue(UM.SimulationView.currentLayer)
        }
    }
       /* Column
    {
        id: viewSettings 
        property var extruder_opacities: UM.Preferences.getValue("layerview/extruder_opacities").split("|")
        property bool show_travel_moves: UM.Preferences.getValue("layerview/show_travel_moves")
        property bool show_helpers: UM.Preferences.getValue("layerview/show_helpers")
        property bool show_skin: UM.Preferences.getValue("layerview/show_skin")
        property bool show_infill: UM.Preferences.getValue("layerview/show_infill")
        // If we are in compatibility mode, we only show the "line type"
        property bool show_legend: UM.SimulationView.compatibilityMode ? true : UM.Preferences.getValue("layerview/layer_view_type") == 1
        property bool show_gradient: UM.SimulationView.compatibilityMode ? false : UM.Preferences.getValue("layerview/layer_view_type") == 2 || UM.Preferences.getValue("layerview/layer_view_type") == 3
        property bool show_feedrate_gradient: show_gradient && UM.Preferences.getValue("layerview/layer_view_type") == 2
        property bool show_thickness_gradient: show_gradient && UM.Preferences.getValue("layerview/layer_view_type") == 3
        property bool show_extruders_gradient: show_gradient && UM.Preferences.getValue("layerview/layer_view_type") == 4
        property bool only_show_top_layers: UM.Preferences.getValue("view/only_show_top_layers")
        property int top_layer_count: UM.Preferences.getValue("view/top_layer_count")
        width: UM.Theme.getSize("layerview_menu_size").width - 2 * UM.Theme.getSize("default_margin").width
        height: implicitHeight
        spacing: UM.Theme.getSize("layerview_row_spacing").height
        anchors
        {
            left:layerSlider.right
            top:layerSlider.top
        }
        ListModel  // matches SimulationView.py
        {
            id: layerViewTypes
        }
        Component.onCompleted:
        {
            layerViewTypes.append({
                text: catalog.i18nc("@label:listbox", "Material Color"),
                type_id: 0
            })
            layerViewTypes.append({
                text: catalog.i18nc("@label:listbox", "Line Type"),
                type_id: 1
            })
            layerViewTypes.append({
                text: catalog.i18nc("@label:listbox", "Feedrate"),
                type_id: 2
            })
            layerViewTypes.append({
                text: catalog.i18nc("@label:listbox", "Layer thickness"),
                type_id: 3  // these ids match the switching in the shader
            })
            layerViewTypes.append({
                text: catalog.i18nc("@label:listbox", "Extruders Colors"),
                type_id: 4  // these ids match the switching in the shader
            })
        }
        ComboBox
        {
            id: layerTypeCombobox
            width: parent.width
            model: layerViewTypes
            visible: !UM.SimulationView.compatibilityMode
            style: UM.Theme.styles.combobox
            onActivated:
            {
                UM.Preferences.setValue("layerview/layer_view_type", index);
            }
            Component.onCompleted:
            {
                currentIndex = UM.SimulationView.compatibilityMode ? 1 : UM.Preferences.getValue("layerview/layer_view_type");
                updateLegends(currentIndex);
            }
            function updateLegends(type_id)
            {
                // Update the visibility of the legends.
                viewSettings.show_legend = UM.SimulationView.compatibilityMode || (type_id == 1);
                viewSettings.show_gradient = !UM.SimulationView.compatibilityMode && (type_id == 2 || type_id == 3);
                viewSettings.show_feedrate_gradient = viewSettings.show_gradient && (type_id == 2);
                viewSettings.show_thickness_gradient = viewSettings.show_gradient && (type_id == 3);
                viewSettings.show_extruders_gradient = viewSettings.show_gradient && (type_id == 4);
                
            }
        }
        Label
        {
            id: compatibilityModeLabel
            text: catalog.i18nc("@label", "Compatibility Mode")
            font: UM.Theme.getFont("default")
            color: UM.Theme.getColor("text")
            visible: UM.SimulationView.compatibilityMode
            height: UM.Theme.getSize("layerview_row").height
            width: parent.width
            renderType: Text.NativeRendering
        }
        Item  // Spacer
        {
            height: UM.Theme.getSize("narrow_margin").width
            width: width
        }
        Repeater
        {
            model: CuraApplication.getExtrudersModel()
            CheckBox
            {
                id: extrudersModelCheckBox
                checked: viewSettings.extruder_opacities[index] > 0.5 || viewSettings.extruder_opacities[index] == undefined || viewSettings.extruder_opacities[index] == ""
                height: UM.Theme.getSize("layerview_row").height + UM.Theme.getSize("default_lining").height
                width: parent.width
                visible: !UM.SimulationView.compatibilityMode
                onClicked:
                {
                    viewSettings.extruder_opacities[index] = checked ? 1.0 : 0.0
                    UM.Preferences.setValue("layerview/extruder_opacities", viewSettings.extruder_opacities.join("|"));
                }
                style: UM.Theme.styles.checkbox
                UM.RecolorImage
                {
                    id: swatch
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: extrudersModelCheckBox.right
                    width: UM.Theme.getSize("layerview_legend_size").width
                    height: UM.Theme.getSize("layerview_legend_size").height
                    source: UM.Theme.getIcon("extruder_button")
                    color:model.color
                }
                Label
                {
                    text: model.name
                    elide: Text.ElideRight
                    color: UM.Theme.getColor("setting_control_text")
                    font: UM.Theme.getFont("default")
                    anchors
                    {
                        verticalCenter: parent.verticalCenter
                        left: extrudersModelCheckBox.left
                        right: extrudersModelCheckBox.right
                        leftMargin: UM.Theme.getSize("checkbox").width + Math.round(UM.Theme.getSize("default_margin").width / 2)
                        rightMargin: UM.Theme.getSize("default_margin").width * 2
                    }
                    renderType: Text.NativeRendering
                }
            }
        }

        Repeater
        {
            model: ListModel
            {
                id: typesLegendModel
                Component.onCompleted:
                {
                    typesLegendModel.append({
                        label: catalog.i18nc("@label", "Travels"),
                        initialValue: viewSettings.show_travel_moves,
                        preference: "layerview/show_travel_moves",
                        colorId:  "layerview_move_combing"
                    });
                    typesLegendModel.append({
                        label: catalog.i18nc("@label", "Helpers"),
                        initialValue: viewSettings.show_helpers,
                        preference: "layerview/show_helpers",
                        colorId:  "layerview_support"
                    });
                    typesLegendModel.append({
                        label: catalog.i18nc("@label", "Shell"),
                        initialValue: viewSettings.show_skin,
                        preference: "layerview/show_skin",
                        colorId:  "layerview_inset_0"
                    });
                    typesLegendModel.append({
                        label: catalog.i18nc("@label", "Infill"),
                        initialValue: viewSettings.show_infill,
                        preference: "layerview/show_infill",
                        colorId:  "layerview_infill"
                    });
                }
            }

            CheckBox
            {
                id: legendModelCheckBox
                checked: model.initialValue
                onClicked: UM.Preferences.setValue(model.preference, checked)
                height: UM.Theme.getSize("layerview_row").height + UM.Theme.getSize("default_lining").height
                width: parent.width

                style: UM.Theme.styles.checkbox

                Rectangle
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: legendModelCheckBox.right
                    width: UM.Theme.getSize("layerview_legend_size").width
                    height: UM.Theme.getSize("layerview_legend_size").height
                    color: UM.Theme.getColor(model.colorId)
                    border.width: UM.Theme.getSize("default_lining").width
                    border.color: UM.Theme.getColor("lining")
                    visible: viewSettings.show_legend
                }
                Label
                {
                    text: label
                    font: UM.Theme.getFont("default")
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                    color: UM.Theme.getColor("setting_control_text")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: legendModelCheckBox.left
                    anchors.right: legendModelCheckBox.right
                    anchors.leftMargin: UM.Theme.getSize("checkbox").width + Math.round(UM.Theme.getSize("default_margin").width / 2)
                    anchors.rightMargin: UM.Theme.getSize("default_margin").width * 2
                }
            }
        }

        CheckBox
        {
            checked: viewSettings.only_show_top_layers
            onClicked: UM.Preferences.setValue("view/only_show_top_layers", checked ? 1.0 : 0.0)
            text: catalog.i18nc("@label", "Only Show Top Layers")
            visible: UM.SimulationView.compatibilityMode
            style: UM.Theme.styles.checkbox
            width: parent.width
        }

        CheckBox
        {
            checked: viewSettings.top_layer_count == 5
            onClicked: UM.Preferences.setValue("view/top_layer_count", checked ? 5 : 1)
            text: catalog.i18nc("@label", "Show 5 Detailed Layers On Top")
            width: parent.width
            visible: UM.SimulationView.compatibilityMode
            style: UM.Theme.styles.checkbox
        }
        Repeater
        {
            model: ListModel
            {
                id: typesLegendModelNoCheck
                Component.onCompleted:
                {
                    typesLegendModelNoCheck.append({
                        label: catalog.i18nc("@label", "Top / Bottom"),
                        colorId: "layerview_skin",
                    });
                    typesLegendModelNoCheck.append({
                        label: catalog.i18nc("@label", "Inner Wall"),
                        colorId: "layerview_inset_x",
                    });
                }
            }
            Label
            {
                text: label
                visible: viewSettings.show_legend
                id: typesLegendModelLabel
                height: UM.Theme.getSize("layerview_row").height + UM.Theme.getSize("default_lining").height
                width: parent.width
                color: UM.Theme.getColor("setting_control_text")
                font: UM.Theme.getFont("default")
                renderType: Text.NativeRendering
                Rectangle
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: typesLegendModelLabel.right
                    width: UM.Theme.getSize("layerview_legend_size").width
                    height: UM.Theme.getSize("layerview_legend_size").height
                    color: UM.Theme.getColor(model.colorId)
                    border.width: UM.Theme.getSize("default_lining").width
                    border.color: UM.Theme.getColor("lining")
                }
            }
        }

        // Text for the minimum, maximum and units for the feedrates and layer thickness
        Item
        {
            id: gradientLegend
            visible: viewSettings.show_gradient
            width: parent.width
            height: UM.Theme.getSize("layerview_row").height

            Label //Minimum value.
            {
                text:
                {
                    if (UM.SimulationView.layerActivity && CuraApplication.platformActivity)
                    {
                        // Feedrate selected
                        if (UM.Preferences.getValue("layerview/layer_view_type") == 2)
                        {
                            return parseFloat(UM.SimulationView.getMinFeedrate()).toFixed(2)
                        }
                        // Layer thickness selected
                        if (UM.Preferences.getValue("layerview/layer_view_type") == 3)
                        {
                            return parseFloat(UM.SimulationView.getMinThickness()).toFixed(2)
                        }
                    }
                    return catalog.i18nc("@label","min")
                }
                anchors.left: parent.left
                color: UM.Theme.getColor("setting_control_text")
                font: UM.Theme.getFont("default")
                renderType: Text.NativeRendering
            }

            Label //Unit in the middle.
            {
                text:
                {
                    if (UM.SimulationView.layerActivity && CuraApplication.platformActivity)
                    {
                        // Feedrate selected
                        if (UM.Preferences.getValue("layerview/layer_view_type") == 2)
                        {
                            return "mm/s"
                        }
                        // Layer thickness selected
                        if (UM.Preferences.getValue("layerview/layer_view_type") == 3)
                        {
                            return "mm"
                        }
                    }
                    return ""
                }

                anchors.horizontalCenter: parent.horizontalCenter
                color: UM.Theme.getColor("setting_control_text")
                font: UM.Theme.getFont("default")
            }
            Label //Maximum value.
            {
                text: {
                    if (UM.SimulationView.layerActivity && CuraApplication.platformActivity)
                    {
                        // Feedrate selected
                        if (UM.Preferences.getValue("layerview/layer_view_type") == 2)
                        {
                            return parseFloat(UM.SimulationView.getMaxFeedrate()).toFixed(2)
                        }
                        // Layer thickness selected
                        if (UM.Preferences.getValue("layerview/layer_view_type") == 3)
                        {
                            return parseFloat(UM.SimulationView.getMaxThickness()).toFixed(2)
                        }
                    }
                    return catalog.i18nc("@label","max")
                }
                anchors.right: parent.right
                color: UM.Theme.getColor("setting_control_text")
                font: UM.Theme.getFont("default")
            }
        }
        // Gradient colors for feedrate
        Rectangle
        {
            id: feedrateGradient
            visible: viewSettings.show_feedrate_gradient
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.round(UM.Theme.getSize("layerview_row").height * 1.5)
            border.width: UM.Theme.getSize("default_lining").width
            border.color: UM.Theme.getColor("lining")
            LinearGradient
            {
                anchors
                {
                    left: parent.left
                    leftMargin: UM.Theme.getSize("default_lining").width
                    right: parent.right
                    rightMargin: UM.Theme.getSize("default_lining").width
                    top: parent.top
                    topMargin: UM.Theme.getSize("default_lining").width
                    bottom: parent.bottom
                    bottomMargin: UM.Theme.getSize("default_lining").width
                }
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                gradient: Gradient
                {
                    GradientStop
                    {
                        position: 0.000
                        color: Qt.rgba(0, 0, 1, 1)
                    }
                    GradientStop
                    {
                        position: 0.25
                        color: Qt.rgba(0.25, 1, 0, 1)
                    }
                    GradientStop
                    {
                        position: 0.375
                        color: Qt.rgba(0.375, 0.5, 0, 1)
                    }
                    GradientStop
                    {
                        position: 1.0
                        color: Qt.rgba(1, 0.5, 0, 1)
                    }
                }
            }
        }
        // Gradient colors for layer thickness (similar to parula colormap)
        Rectangle
        {
            id: thicknessGradient
            visible: viewSettings.show_thickness_gradient
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.round(UM.Theme.getSize("layerview_row").height * 1.5)
            border.width: UM.Theme.getSize("default_lining").width
            border.color: UM.Theme.getColor("lining")
            LinearGradient
            {
                anchors
                {
                    left: parent.left
                    leftMargin: UM.Theme.getSize("default_lining").width
                    right: parent.right
                    rightMargin: UM.Theme.getSize("default_lining").width
                    top: parent.top
                    topMargin: UM.Theme.getSize("default_lining").width
                    bottom: parent.bottom
                    bottomMargin: UM.Theme.getSize("default_lining").width
                }
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                gradient: Gradient
                {
                    GradientStop
                    {
                        position: 0.000
                        color: Qt.rgba(0, 0, 0.5, 1)
                    }
                    GradientStop
                    {
                        position: 0.25
                        color: Qt.rgba(0, 0.375, 0.75, 1)
                    }
                    GradientStop
                    {
                        position: 0.5
                        color: Qt.rgba(0, 0.75, 0.5, 1)
                    }
                    GradientStop
                    {
                        position: 0.75
                        color: Qt.rgba(1, 0.75, 0.25, 1)
                    }
                    GradientStop
                    {
                        position: 1.0
                        color: Qt.rgba(1, 1, 0, 1)
                    }
                }
            }
        }
          Rectangle
        {
            id: extrudersGradient
            visible: viewSettings.show_extruders_gradient
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.round(UM.Theme.getSize("layerview_row").height * 1.5)
            border.width: UM.Theme.getSize("default_lining").width
            border.color: UM.Theme.getColor("lining")
            LinearGradient
            {
                anchors
                {
                    left: parent.left
                    leftMargin: UM.Theme.getSize("default_lining").width
                    right: parent.right
                    rightMargin: UM.Theme.getSize("default_lining").width
                    top: parent.top
                    topMargin: UM.Theme.getSize("default_lining").width
                    bottom: parent.bottom
                    bottomMargin: UM.Theme.getSize("default_lining").width
                }
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                gradient: Gradient
                {
                    GradientStop
                    {
                        position: 0.000
                        color: Qt.rgba(0, 0, 0.5, 1)
                    }
                    GradientStop
                    {
                        position: 0.25
                        color: Qt.rgba(0, 0.375, 0.75, 1)
                    }
                    GradientStop
                    {
                        position: 0.5
                        color: Qt.rgba(0, 0.75, 0.5, 1)
                    }
                    GradientStop
                    {
                        position: 0.75
                        color: Qt.rgba(1, 0.75, 0.25, 1)
                    }
                    GradientStop
                    {
                        position: 1.0
                        color: Qt.rgba(1, 1, 0, 1)
                    }
                }
            }
        }


    }*/

}