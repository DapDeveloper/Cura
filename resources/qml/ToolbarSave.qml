// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura

Item
{
    id: base
    property int backendState: UM.Backend.state
     property real progress: UM.Backend.progress
    width: buttons.width
    height: buttons.height
    property int activeY

    function sliceOrStopSlicing()
    {
        if (backendState == UM.Backend.NotStarted)
        {
            CuraApplication.backend.forceSlice()
        }
        else
        {
            CuraApplication.backend.stopSlicing()
        }
    }
    
    Item
    {
        id: buttons
        width: parent.visible ? toolButtons.width : 0
        height: childrenRect.height
        Behavior on width { NumberAnimation { duration: 100 } }
        // Used to create a rounded rectangle behind the toolButtons
        
         Column
        {
            id: saveButtons
            anchors.top: parent.bottom
            anchors.left: parent.left
            width: childrenRect.width
            height: childrenRect.height
            Cura.OutputDevicesActionButton
            {
                id: outputDevicesButton
                width: 200
                height: 50  
                visible: base.backendState==UM.Backend.Done
            }
              UM.ProgressBar
                {
                    id: progressBar
                    width: 300
                    height: UM.Theme.getSize("progressbar").height
                    value: base.progress
                    indeterminate: widget.backendState == UM.Backend.NotStarted
                    visible: base.backendState!=UM.Backend.Done && sliceButton.visible==false//true//base.backendState!=UM.Backend.Done && outputDevicesButton.visible==false
                    /*anchors
                    {
                        left:parent.left
                        bottom:parent.bottom
                    }*/
                }

        }
         

    }
    property var extrudersModel: CuraApplication.getExtrudersModel()
    UM.PointingRectangle
    {
        id: panelBorder
        anchors.left: parent.right
        anchors.leftMargin: UM.Theme.getSize("default_margin").width
        anchors.top: base.top
        anchors.topMargin: base.activeY
        z: buttons.z - 1
        target: Qt.point(parent.right, base.activeY +  Math.round(UM.Theme.getSize("button").height/2))
        arrowSize: UM.Theme.getSize("default_arrow").width
        width:
        {
            if (panel.item && panel.width > 0)
            {
                 return Math.max(panel.width + 2 * UM.Theme.getSize("default_margin").width)
            }
            else
            {
                return 0;
            }
        }
        height: panel.item ? panel.height + 2 * UM.Theme.getSize("default_margin").height : 0

        opacity: panel.item && panel.width > 0 ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        color: UM.Theme.getColor("tool_panel_background")
        borderColor: UM.Theme.getColor("lining")
        borderWidth: UM.Theme.getSize("default_lining").width
        MouseArea //Catch all mouse events (so scene doesnt handle them)
        {
            anchors.fill: parent
        }
        Loader
        {
            id: panel
            x: UM.Theme.getSize("default_margin").width
            y: UM.Theme.getSize("default_margin").height
            source: UM.ActiveTool.valid ? UM.ActiveTool.activeToolPanel : ""
            enabled: UM.Controller.toolsEnabled
        }
    }
    // This rectangle displays the information about the current angle etc. when
    // dragging a tool handle.
    Rectangle
    {
        x: -base.x + base.mouseX + UM.Theme.getSize("default_margin").width
        y: -base.y + base.mouseY + UM.Theme.getSize("default_margin").height
        width: toolHint.width + UM.Theme.getSize("default_margin").width
        height: toolHint.height;
        color: UM.Theme.getColor("tooltip")
        Label
        {
            id: toolHint
            text: UM.ActiveTool.properties.getValue("ToolHint") != undefined ? UM.ActiveTool.properties.getValue("ToolHint") : ""
            color: UM.Theme.getColor("tooltip_text")
            font: UM.Theme.getFont("default")
            anchors.horizontalCenter: parent.horizontalCenter
        }
        visible: toolHint.text != ""
    }
}
