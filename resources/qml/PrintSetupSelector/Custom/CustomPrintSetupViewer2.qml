// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.7
import QtQuick.Controls 2.0
import UM 1.3 as UM
import Cura 1.0 as Cura
Item
{
    id: customPrintSetup
    property real padding: UM.Theme.getSize("default_margin").width
    property bool multipleExtruders: extrudersModel.count > 1
    property var extrudersModel: CuraApplication.getExtrudersModel()
    // Profile selector row
    UM.TabRow
    {
        id: tabBar
        visible: multipleExtruders 
        height:60
        anchors
        {
            top: parent.top
            topMargin: UM.Theme.getSize("default_margin").height
            left: parent.left
            leftMargin: parent.padding
            right: parent.right
            rightMargin: parent.padding
        }
        //Extruder selector
        Repeater
        {
            id: repeater
            model: extrudersModel
            delegate: UM.TabRowButton
            {
                contentItem: Item
                {
                    Cura.ExtruderIcon
                    {
                        anchors.horizontalCenter: parent.horizontalCenter
                        materialColor: model.color
                        extruderEnabled: model.enabled
                        id:extLabel
                    }
                      Label
                    {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:model.material_brand + " " + model.material
                        anchors.top:extLabel.bottom
                    }
                }
                onClicked:
                {
                    Cura.ExtruderManager.setActiveExtruderIndex(tabBar.currentIndex)
                }
            }
        }
        Connections
        {
            target: Cura.ExtruderManager
            onActiveExtruderChanged:
            {
                tabBar.setCurrentIndex(Cura.ExtruderManager.activeExtruderIndex);
            }
        }
        Connections
        {
            target: repeater.model
            onModelChanged:
            {
                tabBar.setCurrentIndex(Cura.ExtruderManager.activeExtruderIndex)
            }
        }
    }
    Rectangle
    {
        anchors
        {
            top: tabBar.visible ? tabBar.bottom : parent.top
            topMargin: tabBar.visible ? -UM.Theme.getSize("default_lining").width : 20
            left: parent.left
            leftMargin: parent.padding
            right: parent.right
            rightMargin: parent.padding
            bottom: parent.bottom
        }
        z: tabBar.z - 1
        border.color: tabBar.visible ? UM.Theme.getColor("lining") : "transparent"
        border.width: UM.Theme.getSize("default_lining").width
        color: UM.Theme.getColor("psColor2")
        Cura.SettingViewViewer
        {
            anchors
            {
                fill: parent
                topMargin: UM.Theme.getSize("default_margin").height
                leftMargin: UM.Theme.getSize("default_margin").width
                rightMargin: UM.Theme.getSize("narrow_margin").width
                bottomMargin: UM.Theme.getSize("default_lining").width
            }
        }
    }
}