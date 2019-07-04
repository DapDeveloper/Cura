// Copyright (c) 2017 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import UM 1.0 as UM
import Cura 1.0 as Cura
Item
{
    id: sliderRoot2
    // Handle properties
    property real handleSize: UM.Theme.getSize("slider_handle").width
    property real handleRadius: handleSize / 2
    property real minimumRangeHandleSize: handleSize / 2-20
    property color upperHandleColor: UM.Theme.getColor("slider_handle")
    property color lowerHandleColor: UM.Theme.getColor("slider_handle")
    property color rangeHandleColor: UM.Theme.getColor("slider_groove_fill")
    property color handleActiveColor: UM.Theme.getColor("slider_handle_active")
    property var activeHandle: upperHandle
    // Track properties
    property real trackThickness: UM.Theme.getSize("slider_groove").width // width of the slider track
    property real trackRadius: UM.Theme.getSize("slider_groove_radius").width
    property color trackColor: UM.Theme.getColor("slider_groove")
    // value properties
    property real maximumValue: 300
    property real minimumValue: 1
    property real minimumRange: 1 // minimum range allowed between min and max values
    property bool roundValues: true
    property real upperValue: maximumValue
    property real lowerValue: minimumValue
    property bool layersVisible: true
    property bool manuallyChanged: true     // Indicates whether the value was changed manually or during simulation

    function getUpperValueFromSliderHandle()
    {
        return upperHandle.getValue()
    }
    function setUpperValue(value)
    {
        upperHandle.setValue(value)
        updateRangeHandle()
    }
    function getLowerValueFromSliderHandle()
    {
        return lowerHandle.getValue()
    }
    function setLowerValue(value)
    {
        lowerHandle.setValue(value)
        updateRangeHandle()
    }
    function updateRangeHandle()
    {
        rangeHandle.height = lowerHandle.y - (upperHandle.y + upperHandle.height)
    }
    // set the active handle to show only one label at a time
    function setActiveHandle(handle)
    {
        activeHandle = handle
    }
    function normalizeValue(value)
    {
        return Math.min(Math.max(value, sliderRoot2.minimumValue), sliderRoot2.maximumValue)
    }
    Label
    {
        id:lblTitleSlider
        text:"Speed"
        anchors
        {
            horizontalCenter:parent.horizontalCenter
            bottom:track.top
            bottomMargin:10
        }
    }
    // Slider track
    Rectangle
    {
        id: track
        width: sliderRoot2.trackThickness
        height: sliderRoot2.height - sliderRoot2.handleSize
        radius: sliderRoot2.trackRadius
        anchors.centerIn: sliderRoot2
        color: sliderRoot2.trackColor
        visible: sliderRoot2.layersVisible
    }
    // Range handle
    Item
    {
        id: rangeHandle
        y: upperHandle.y + upperHandle.height
        width: sliderRoot2.handleSize
        height: sliderRoot2.minimumRangeHandleSize
        anchors.horizontalCenter: sliderRoot2.horizontalCenter
        visible: sliderRoot2.layersVisible
        // Set the new value when dragging
        function onHandleDragged()
        {
            sliderRoot2.manuallyChanged = true
            upperHandle.y = y - upperHandle.height
            lowerHandle.y = y + height
            var upperValue = sliderRoot2.getUpperValueFromSliderHandle()
            var lowerValue = sliderRoot2.getLowerValueFromSliderHandle()
            // set both values after moving the handle position
           lblTitleSlider.text(upperValue)
            //UM.SimulationView.setCurrentLayer2(upperValue)
            UM.SimulationView.setMinimumLayer(lowerValue)
        }
        function setValueManually(value)
        {
            sliderRoot2.manuallyChanged = true
            upperHandle.setValue(value)
        }
        function setValue(value)
        {
            var range = sliderRoot2.upperValue - sliderRoot2.lowerValue
            value = Math.min(value, sliderRoot2.maximumValue)
            value = Math.max(value, sliderRoot2.minimumValue + range)
            //UM.SimulationView.setCurrentLayer2(value)
            UM.SimulationView.setMinimumLayer(value - range)
        }
        Rectangle
        {
            width: sliderRoot2.trackThickness
            height: parent.height + sliderRoot2.handleSize
            anchors.centerIn: parent
            radius: sliderRoot2.trackRadius
            color: sliderRoot2.rangeHandleColor
        }
        MouseArea
        {
            anchors.fill: parent
            drag
            {
                target: parent
                axis: Drag.YAxis
                minimumY: upperHandle.height
                maximumY: sliderRoot2.height - (rangeHandle.height + lowerHandle.height)
            }
            onPositionChanged: parent.onHandleDragged()
            onPressed: sliderRoot2.setActiveHandle(rangeHandle)
        }
        SimulationSliderLabel
        {
            id: rangleHandleLabel
            height: sliderRoot2.handleSize + UM.Theme.getSize("default_margin").height
            x: parent.x - width - UM.Theme.getSize("default_margin").width
            anchors.verticalCenter: parent.verticalCenter
            target: Qt.point(sliderRoot2.width, y + height / 2)
            visible: sliderRoot2.activeHandle == parent
            // custom properties
            maximumValue: sliderRoot2.maximumValue
            value: sliderRoot2.upperValue
            busy: UM.SimulationView.busy
            setValue: rangeHandle.setValueManually // connect callback functions
        }
    }
    // Upper handle
    Rectangle
    {
        id: upperHandle
        y: sliderRoot2.height - (sliderRoot2.minimumRangeHandleSize + 2 * sliderRoot2.handleSize)
        width: sliderRoot2.handleSize
        height: sliderRoot2.handleSize
        anchors.horizontalCenter: sliderRoot2.horizontalCenter
        radius: sliderRoot2.handleRadius
        color: upperHandleLabel.activeFocus ? sliderRoot2.handleActiveColor : sliderRoot2.upperHandleColor
        visible: sliderRoot2.layersVisible
        function onHandleDragged()
        {
            sliderRoot2.manuallyChanged = true
            // don't allow the lower handle to be heigher than the upper handle
            if (lowerHandle.y - (y + height) < sliderRoot2.minimumRangeHandleSize)
            {
                lowerHandle.y = y + height + sliderRoot2.minimumRangeHandleSize
            }
            // update the range handle
            sliderRoot2.updateRangeHandle()
            // set the new value after moving the handle position
            UM.SimulationView.setCurrentLayer2(getValue())
            sliderRoot2.upperValue=getValue()
        }
        // get the upper value based on the slider position
        function getValue()
        {
            var result = y / (sliderRoot2.height - (2 * sliderRoot2.handleSize + sliderRoot2.minimumRangeHandleSize))
            result = sliderRoot2.maximumValue + result * (sliderRoot2.minimumValue - (sliderRoot2.maximumValue - sliderRoot2.minimumValue))
            result = sliderRoot2.roundValues ? Math.round(result) : result
            return result
        }
        function setValueManually(value)
        {
            sliderRoot2.manuallyChanged = true
            upperHandle.setValue(value)
        }
        // set the slider position based on the upper value
        function setValue(value)
        {
            // Normalize values between range, since using arrow keys will create out-of-the-range values
            value = sliderRoot2.normalizeValue(value)
            UM.SimulationView.setCurrentLayer2(value)
            var diff = (value - sliderRoot2.maximumValue) / (sliderRoot2.minimumValue - sliderRoot2.maximumValue)
            // In case there is only one layer, the diff value results in a NaN, so this is for catching this specific case
            if (isNaN(diff))
            {
                diff = 0
            }
            var newUpperYPosition = Math.round(diff * (sliderRoot2.height - (2 * sliderRoot2.handleSize + sliderRoot2.minimumRangeHandleSize)))
            y = newUpperYPosition
            // update the range handle
            sliderRoot2.updateRangeHandle()
        }
        Keys.onUpPressed: upperHandleLabel.setValue(upperHandleLabel.value + ((event.modifiers & Qt.ShiftModifier) ? 10 : 1))
        Keys.onDownPressed: upperHandleLabel.setValue(upperHandleLabel.value - ((event.modifiers & Qt.ShiftModifier) ? 10 : 1))
        // dragging
        MouseArea
        {
            anchors.fill: parent
            drag
            {
                target: parent
                axis: Drag.YAxis
                minimumY: 0
                maximumY: sliderRoot2.height - (2 * sliderRoot2.handleSize + sliderRoot2.minimumRangeHandleSize)
            }
            onPositionChanged: parent.onHandleDragged()
            onPressed:
            {
                sliderRoot2.setActiveHandle(upperHandle)
                upperHandleLabel.forceActiveFocus()
            }
        }
        SimulationSliderLabel
        {
            id: upperHandleLabel
            height: sliderRoot2.handleSize + UM.Theme.getSize("default_margin").height
            x: parent.x - parent.width - width
            anchors.verticalCenter: parent.verticalCenter
            target: Qt.point(sliderRoot2.width, y + height / 2)
            visible: false//sliderRoot2.activeHandle == parent
            // custom properties
            maximumValue: sliderRoot2.maximumValue
            value: sliderRoot2.upperValue
            busy: UM.SimulationView.busy
            setValue: upperHandle.setValueManually // connect callback functions
        }
    }
    // Lower handle
    Rectangle
    {
        id: lowerHandle
        visible:false
        y: sliderRoot2.height - sliderRoot2.handleSize
        width: parent.handleSize
        height: parent.handleSize
        anchors.horizontalCenter: parent.horizontalCenter
        radius: sliderRoot2.handleRadius
        color: lowerHandleLabel.activeFocus ? sliderRoot2.handleActiveColor : sliderRoot2.lowerHandleColor
        //        visible: sliderRoot2.layersVisible
        function onHandleDragged()
        {
            sliderRoot2.manuallyChanged = true
            // don't allow the upper handle to be lower than the lower handle
            if (y - (upperHandle.y + upperHandle.height) < sliderRoot2.minimumRangeHandleSize)
            {
                upperHandle.y = y - (upperHandle.heigth + sliderRoot2.minimumRangeHandleSize)
            }

            // update the range handle
            sliderRoot2.updateRangeHandle()
            // set the new value after moving the handle position
            UM.SimulationView.setMinimumLayer(getValue())
        }
        // get the lower value from the current slider position
        function getValue()
        {
            var result = (y - (sliderRoot2.handleSize + sliderRoot2.minimumRangeHandleSize)) / (sliderRoot2.height - (2 * sliderRoot2.handleSize + sliderRoot2.minimumRangeHandleSize));
            result = sliderRoot2.maximumValue - sliderRoot2.minimumRange + result * (sliderRoot2.minimumValue - (sliderRoot2.maximumValue - sliderRoot2.minimumRange))
            result = sliderRoot2.roundValues ? Math.round(result) : result
            return result
        }
        function setValueManually(value)
        {
            sliderRoot2.manuallyChanged = true
            lowerHandle.setValue(value)
        }
        // set the slider position based on the lower value
        function setValue(value)
        {
            // Normalize values between range, since using arrow keys will create out-of-the-range values
            value = sliderRoot2.normalizeValue(value)
            UM.SimulationView.setMinimumLayer(value)
            var diff = (value - sliderRoot2.maximumValue) / (sliderRoot2.minimumValue - sliderRoot2.maximumValue)
            // In case there is only one layer, the diff value results in a NaN, so this is for catching this specific case
            if (isNaN(diff))
            {
                diff = 0
            }
            var newLowerYPosition = Math.round((sliderRoot2.handleSize + sliderRoot2.minimumRangeHandleSize) + diff * (sliderRoot2.height - (2 * sliderRoot2.handleSize + sliderRoot2.minimumRangeHandleSize)))
            y = newLowerYPosition
            // update the range handle
            sliderRoot2.updateRangeHandle()
        }
        Keys.onUpPressed: lowerHandleLabel.setValue(lowerHandleLabel.value + ((event.modifiers & Qt.ShiftModifier) ? 10 : 1))
        Keys.onDownPressed: lowerHandleLabel.setValue(lowerHandleLabel.value - ((event.modifiers & Qt.ShiftModifier) ? 10 : 1))
        // dragging
        MouseArea
        {
            anchors.fill: parent
            drag
            {
                target: parent
                axis: Drag.YAxis
                minimumY: upperHandle.height + sliderRoot2.minimumRangeHandleSize
                maximumY: sliderRoot2.height - parent.height
            }
            onPositionChanged: parent.onHandleDragged()
            onPressed:
            {
                sliderRoot2.setActiveHandle(lowerHandle)
                lowerHandleLabel.forceActiveFocus()
            }
        }
        SimulationSliderLabel
        {
            id: lowerHandleLabel
            height: sliderRoot2.handleSize + UM.Theme.getSize("default_margin").height
            x: parent.x - parent.width - width
            anchors.verticalCenter: parent.verticalCenter
            target: Qt.point(sliderRoot2.width + width, y + height / 2)
            visible: sliderRoot2.activeHandle == parent
            // custom properties
            maximumValue: sliderRoot2.maximumValue
            value: sliderRoot2.lowerValue
            busy: UM.SimulationView.busy
            setValue: lowerHandle.setValueManually // connect callback functions
        }
    }
}