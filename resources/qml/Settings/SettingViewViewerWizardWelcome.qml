// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.2
import UM 1.2 as UM
import Cura 1.1 as Cura
import "../Menus"

Item
{
    id: settingsView
    property QtObject settingVisibilityPresetsModel: CuraApplication.getSettingVisibilityPresetsModel()
    property Action configureSettings
    property bool findingSettings

  
   Cura.MachineSelector
        {
            id:machineSelID
            height:50
            width:200
            anchors
            {
                horizontalCenter:parent.horizontalCenter
                top:parent.top

            }
        }
  
}
