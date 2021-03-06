// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0  // For the DropShadow
import UM 1.3 as UM
import Cura 1.1 as Cura
//
// This is an Item that tries to mimic a dialog for showing the welcome process.
//
Item
{
    UM.I18nCatalog { id: catalog; name: "cura" }
    id: dialog
    //color: UM.Theme.getColor("first_run_shadow")
    anchors.centerIn: parent
    width: parent.width/1.7//1200 * screenScaleFactor
    height: 500 * screenScaleFactor
    property int shadowOffset: 1 * screenScaleFactor
    property alias progressBarVisible: wizardPanel.progressBarVisible
    property var model: CuraApplication.getWelcomeWizardPagesModel()
    onVisibleChanged:
    {
        if (visible)
        {
            model.resetState()
        }
    }
    WizardPanel
    {
        id: wizardPanel
        anchors.fill: parent
        model: dialog.model
    }
    // Drop shadow around the panel
    DropShadow
    {
        id: shadow
        radius: UM.Theme.getSize("first_run_shadow_radius").width
        anchors.fill: wizardPanel
        source: wizardPanel
        horizontalOffset: shadowOffset
        verticalOffset: shadowOffset
        color: UM.Theme.getColor("first_run_shadow")
        transparentBorder: true
        visible:false
    }
    // Close this dialog when there's no more page to show
    Connections
    {
        target: model
        onAllFinished: dialog.visible = false
    }
}
