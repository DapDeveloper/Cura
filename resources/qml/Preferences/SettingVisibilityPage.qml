// Copyright (c) 2016 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import UM 1.2 as UM
import Cura 1.0 as Cura

UM.PreferencesPage
{
    title: catalog.i18nc("@title:tab", "Setting Visibility");
    property QtObject settingVisibilityPresetsModel: CuraApplication.getSettingVisibilityPresetsModel()
    property int scrollToIndex: 0
    signal scrollToSection( string key )
    onScrollToSection:
    {
        settingsListView.positionViewAtIndex(definitionsModel.getIndex(key), ListView.Beginning)
    }
    function reset()
    {
        settingVisibilityPresetsModel.setActivePreset("basic")
    }
    resetEnabled: true;
    Label
    {
        id:lblSubtitle
        text:catalog.i18nc("@info","You will need to restart Cura before changes in packages have effect.")
        anchors
        {
            left:parent.left
            top:parent.top
        }
    }
    Item
    {
        id: base;
        anchors.fill: parent;
        Button
        {
            id:btnBasic
            text: catalog.i18nc("@action:button", "Basic")
            height:250*screenScaleFactor
            width:150*screenScaleFactor
            iconName: "list-activate"
            anchors.topMargin:50
            anchors.top:btnTecAdv1.bottom
            anchors.left:parent.left
            anchors.leftMargin:btnTecnical.visible ? "20":"140" 
            style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: settingVisibilityPresetsModel.items[1].presetId == settingVisibilityPresetsModel.activePreset ? "#A8A8A8" : "#DBDBDB"
                        //border.color: control.activeFocus ? "yellow" : "#242424"
                        //border.width: 1
                        radius: 4

                    }
                      label: Text {
                            renderType: Text.NativeRendering
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "Candara"
                            font.pointSize: 20
                            color: "black"
                            text: control.text
                        }
            }
            onClicked: {
                  settingVisibilityPresetsModel.setActivePreset( settingVisibilityPresetsModel.items[1].presetId)
            }
        }
         Button
        {
            id:btnTecAdv1
            height:50
            width:60
            anchors.left:parent.left
            anchors.top:parent.top
            text: catalog.i18nc("@action:button", "")
            iconName: "list-activate"
            enabled: true
            opacity:0
            onClicked: {
                //btnTecAdv2.opacity=0.1
                btnTecAdv2.enabled=true
            }
        }
         Button
        {
            id:btnTecAdv2
            height:50
            width:60
            anchors.left:btnTecAdv1.right
            anchors.top:parent.top
            anchors.leftMargin:10
            text: catalog.i18nc("@action:button", "")
            iconName: "list-activate"
            enabled: false
            opacity:0
            onClicked: {
                
                //btnTecAdv3.opacity=0.3
                btnTecAdv3.enabled=true
            }
        }
         Button
        {
            id:btnTecAdv3
            height:50
            width:60
            anchors.left:btnTecAdv2.right
            anchors.top:parent.top
            anchors.leftMargin:10
            text: catalog.i18nc("@action:button", "")
            iconName: "list-activate"
            enabled: false
            opacity:0
            onClicked: {
              btnTecAdv4.opacity=0.4
              btnTecAdv4.enabled=true
            }
        }
         Button
        {
            id:btnTecAdv4
            height:50
            width:60
            anchors.left:btnTecAdv3.right
            anchors.top:parent.top
            anchors.leftMargin:10
            text: catalog.i18nc("@action:button", "TEC")
            iconName: "list-activate"
            enabled: false
            opacity:0
            onClicked: {
                if(btnTecnical.visible)
                {
                      btnTecnical.visible=false
                }else
                {
                      btnTecnical.visible=true
                }
            }
        }
        Button
        {
            id:btnAdvanced
            height:250
            width:150
            anchors.left:btnBasic.right
            anchors.leftMargin:50
            anchors.topMargin:50
            anchors.top:btnTecAdv1.bottom
             style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: settingVisibilityPresetsModel.items[2].presetId == settingVisibilityPresetsModel.activePreset ? "#A8A8A8" : "#DBDBDB"
                        //border.color: control.activeFocus ? "yellow" : "#242424"
                        //border.width: 1
                        radius: 4
                    }
                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: "Candara"
                        font.pointSize: 20
                        color: "black"
                        text: control.text
                    }
            }
            text: catalog.i18nc("@action:button", "Advanced")
            iconName: "list-activate"
            enabled: true
            onClicked: {
                  settingVisibilityPresetsModel.setActivePreset( settingVisibilityPresetsModel.items[2].presetId)
            }
        }
         Button
        {
            id:btnTecnical
            anchors.left:btnAdvanced.right
            anchors.leftMargin:50
            anchors.topMargin:50
            anchors.top:btnTecAdv1.bottom
            height:250
            width:150
            isDefault:false
            visible:false
            text: catalog.i18nc("@action:button", "Technical")
            style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: settingVisibilityPresetsModel.items[3].presetId == settingVisibilityPresetsModel.activePreset ? "#A8A8A8" : "#DBDBDB"
                        //border.color: control.activeFocus ? "yellow" : "#242424"
                        //border.width: 1
                        radius: 4
                     }
                        label: Text {
                            renderType: Text.NativeRendering
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "Candara"
                            font.pointSize: 20
                            color: "black"
                            text: control.text
                        }
            }
            iconName: "list-activate"
            enabled: true
            onClicked: {
                  settingVisibilityPresetsModel.setActivePreset( settingVisibilityPresetsModel.items[3].presetId)
            }
        }


        /*CheckBox
        {
            id: toggleVisibleSettings
            anchors
            {
                verticalCenter: filter.verticalCenter;
                left: parent.left;
                leftMargin: UM.Theme.getSize("default_margin").width
            }
            text: catalog.i18nc("@label:textbox", "Check all")
            checkedState:
            {
                if(definitionsModel.visibleCount == definitionsModel.categoryCount)
                {
                    return Qt.Unchecked
                }
                else if(definitionsModel.visibleCount == definitionsModel.count)
                {
                    return Qt.Checked
                }
                else
                {
                    return Qt.PartiallyChecked
                }
            }
            partiallyCheckedEnabled: false

            MouseArea
            {
                anchors.fill: parent;
                onClicked:
                {
                    if(parent.checkedState == Qt.Unchecked || parent.checkedState == Qt.PartiallyChecked)
                    {
                        definitionsModel.setAllExpandedVisible(true)
                    }
                    else
                    {
                        definitionsModel.setAllExpandedVisible(false)
                    }
                }
            }
        }*/
/*
        TextField
        {
            id: filter;

            anchors
            {
                top: parent.top
                left: toggleVisibleSettings.right
                leftMargin: UM.Theme.getSize("default_margin").width
                right: visibilityPreset.left
                rightMargin: UM.Theme.getSize("default_margin").width
            }

            placeholderText: catalog.i18nc("@label:textbox", "Filter...")

            onTextChanged: definitionsModel.filter = {"i18n_label": "*" + text}
        }*/

      /*  ComboBox
        {
            id: visibilityPreset
            width: 150 * screenScaleFactor
            anchors
            {
                top: parent.top
                right: parent.right
            }

            model: settingVisibilityPresetsModel.items
            textRole: "name"

            currentIndex:
            {
                var idx = -1;
                for(var i = 0; i < settingVisibilityPresetsModel.items.length; ++i)
                {
                    if(settingVisibilityPresetsModel.items[i].presetId == settingVisibilityPresetsModel.activePreset)
                    {
                        idx = i;
                        break;
                    }
                }
                return idx;
            }

            onActivated:
            {
                var preset_id = settingVisibilityPresetsModel.items[index].presetId
                settingVisibilityPresetsModel.setActivePreset(preset_id)
            }
        }
*/
        /*ScrollView
        {
            id: scrollView

            frameVisible: true

            anchors
            {
                top: filter.bottom;
                topMargin: UM.Theme.getSize("default_margin").height
                left: parent.left;
                right: parent.right;
                bottom: parent.bottom;
            }
            ListView
            {
                id: settingsListView

                model: UM.SettingDefinitionsModel
                {
                    id: definitionsModel
                    containerId: Cura.MachineManager.activeDefinitionId
                    showAll: true
                    exclude: ["machine_settings", "command_line_settings"]
                    showAncestors: true
                    expanded: ["*"]
                    visibilityHandler: UM.SettingPreferenceVisibilityHandler {}
                }

                delegate: Loader
                {
                    id: loader

                    width: parent.width
                    height: model.type != undefined ? UM.Theme.getSize("section").height : 0

                    property var definition: model
                    property var settingDefinitionsModel: definitionsModel

                    asynchronous: true
                    active: model.type != undefined
                    sourceComponent:
                    {
                        switch(model.type)
                        {
                            case "category":
                                return settingVisibilityCategory
                            default:
                                return settingVisibilityItem
                        }
                    }
                }
            }
        }*/
/*
        UM.I18nCatalog { name: "cura"; }
        SystemPalette { id: palette; }

        Component
        {
            id: settingVisibilityCategory;

            UM.SettingVisibilityCategory { }
        }

        Component
        {
            id: settingVisibilityItem;

            UM.SettingVisibilityItem { }
        }*/
    }
}