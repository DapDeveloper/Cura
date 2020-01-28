// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura


//
// This component contains the content for the "Add a printer" (network) page of the welcome on-boarding process.
//
Item
{
    UM.I18nCatalog { id: catalog; name: "cura" }
    Label
    {
        id: titleLabel
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        text: catalog.i18nc("@label", "Add a printer")
        color: UM.Theme.getColor("primary_button")
        font: UM.Theme.getFont("huge")
        renderType: Text.NativeRendering
    }
    DropDownWidget2
    {
        id: addLocalPrinterDropDown
        anchors.top: titleLabel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: UM.Theme.getSize("wide_margin").height
        title: catalog.i18nc("@label", "Select a printer")
        contentComponent: localPrinterListComponent
        Component
        {
            id: localPrinterListComponent
            AddLocalPrinterScrollView
            {
                id: localPrinterView
            }   
        }
    }
    Cura.PrimaryButton
    {
        id: nextButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        enabled:
        {
            // Printer name cannot be empty
            const localPrinterItem = addLocalPrinterDropDown.contentItem.currentItem
            const isPrinterNameValid = addLocalPrinterDropDown.contentItem.isPrinterNameValid
            return localPrinterItem != null && isPrinterNameValid
        }
        text: base.currentItem.next_page_button_text
        onClicked:
        {
                // Create a local printer
                const localPrinterItem = addLocalPrinterDropDown.contentItem.currentItem
                const printerName = addLocalPrinterDropDown.contentItem.printerName
                Cura.MachineManager.addMachine(localPrinterItem.id, printerName)
                base.showNextPage()
        }
    }
}
