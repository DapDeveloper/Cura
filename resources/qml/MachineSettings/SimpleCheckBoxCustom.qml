// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import UM 1.3 as UM
import Cura 1.1 as Cura

//
// CheckBox widget for the on/off or true/false settings in the Machine Settings Dialog.
//
UM.TooltipArea
{
    id: simpleCheckBox
    UM.I18nCatalog { id: catalog; name: "cura"; }
    property int controlHeight: UM.Theme.getSize("setting_control").height
    height: childrenRect.height
    width: childrenRect.width
    text: tooltip
    property alias containerStackId: propertyProvider.containerStackId
    property alias settingKey: propertyProvider.key
    property alias settingStoreIndex: propertyProvider.storeIndex
    property alias labelText: fieldLabel.text
    property alias labelFont: fieldLabel.font
    property alias labelWidth: fieldLabel.width
    property string tooltip: propertyProvider.properties.description
    property var editable:true
    property var forceUpdateOnChangeFunction: dummy_func
    function dummy_func() {}
    UM.SettingPropertyProvider
    {
        id: propertyProvider
        watchedProperties: [ "value", "description" ]
    }
    Label
    {
        id: fieldLabel
        anchors.left: parent.left
        anchors.verticalCenter: checkBox.verticalCenter
        visible: text != ""
        font: UM.Theme.getFont("medium")
        renderType: Text.NativeRendering
        width:100
    }
    SwitchCustom
    {
        id: checkBox
        width:100
        anchors.left: fieldLabel.right
        anchors.leftMargin: UM.Theme.getSize("default_margin").width
        checked:String(propertyProvider.properties.value).toLowerCase() != 'false'
        height:simpleCheckBox.controlHeight
        enabled:editable
        onClicked:
        {
            propertyProvider.setPropertyValue("value", checked)
            forceUpdateOnChangeFunction()
        }
    }
}