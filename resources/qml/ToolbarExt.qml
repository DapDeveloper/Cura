// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.2
import QtQuick.Controls 2.3
import UM 1.2 as UM
import Cura 1.0 as Cura
Item
{
    id: base
    width: buttons.width
    height: buttons.height
    property int activeY
    Item
    {
        id: buttons
        width: parent.visible ? toolButtons.width : 0
        height: childrenRect.height
        Behavior on width { NumberAnimation { duration: 100 } }
        // Used to create a rounded rectangle behind the toolButtons
        Rectangle
        {
            anchors
            {
                fill: toolButtons
                leftMargin: -radius - border.width
                rightMargin: -border.width
                topMargin: -border.width
                bottomMargin: -border.width
            }
            radius: UM.Theme.getSize("default_radius").width
            color: UM.Theme.getColor("lining")
        }
        // Used to create a rounded rectangle behind the extruderButtons
        Rectangle
        {
            anchors
            {
                fill: extruderButtons
                leftMargin: -radius - border.width
                rightMargin: -border.width
                topMargin: -border.width
                bottomMargin: -border.width
            }
            radius: UM.Theme.getSize("default_radius").width
            color: UM.Theme.getColor("lining")
            visible: extrudersModel.items.length > 1
        }//Print Selected Model With:
        Column
        {
            id: extruderButtons
            anchors.topMargin: UM.Theme.getSize("default_margin").height
            anchors.top: toolButtons.bottom
            anchors.right: parent.right
            spacing: UM.Theme.getSize("default_lining").height
            Repeater
            {
                id: extruders
                width: childrenRect.width
                height: childrenRect.height
                model: extrudersModel.items.length > 1 ? extrudersModel : 0
                delegate: ExtruderButton
                {
                    extruder: model
                    isTopElement: extrudersModel.getItem(0).id == model.id
                    isBottomElement: extrudersModel.getItem(extrudersModel.rowCount() - 1).id == model.id
                }
            }
        }
    }
    property var extrudersModel: CuraApplication.getExtrudersModel()
   /* UM.PointingRectangle
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
    }*/

   
}
