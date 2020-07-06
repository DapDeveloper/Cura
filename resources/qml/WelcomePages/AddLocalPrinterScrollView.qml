// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.0 as Cura


//
// This is the scroll view widget for adding a (local) printer. This scroll view shows a list view with printers
// categorized into 3 categories: "Ultimaker", "Custom", and "Other".
//
Item
{
    UM.I18nCatalog { id: catalog; name: "cura" }
    id: base
    height: childrenRect.height
    // The currently selected machine item in the local machine list.
    property var currentItem: (machineList.currentIndex >= 0)
                              ? machineList.model.getItem(machineList.currentIndex)
                              : null
    // The currently active (expanded) section/category, where section/category is the grouping of local machine items.
    property string currentSection: preferredCategory
    // By default (when this list shows up) we always expand the "Ultimaker" section.
    property string preferredCategory: "Meccatronicore"
    property int maxItemCountAtOnce: 10  // show at max 10 items at once, otherwise you need to scroll.
    // User-editable printer name
    property alias printerName: printerNameTextField.text
    property alias isPrinterNameValid: printerNameTextField.acceptableInput
    onCurrentItemChanged:
    {
        printerName = currentItem == null ? "" : currentItem.name
    }
    function updateCurrentItemUponSectionChange()
    {
        // Find the first machine from this section
        for (var i = 0; i < machineList.count; i++)
        {
            var item = machineList.model.getItem(i)
            if (item.section == base.currentSection)
            {
                machineList.currentIndex = i
                break
            }
        }
    }
    Component.onCompleted:
    {
        updateCurrentItemUponSectionChange()
    }
    
    Item
    {
        id: localPrinterSelectionItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: childrenRect.height
        // ScrollView + ListView for selecting a local printer to add
        ScrollView
        {
            id: scrollView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 500//maxItemCountAtOnce * UM.Theme.getSize("action_button").height
            width:parent.width
            ScrollBar.horizontal.policy: ScrollBar.always
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            clip: true
            ListView
            {
                id: machineList
                model: UM.DefinitionContainersModel
                {
                    id: machineDefinitionsModel
                    filter: { "visible": true }
                    sectionProperty: "category"
                    preferredSectionValue: preferredCategory
                }
                section.property: "section"
                section.delegate: sectionHeader
                orientation:ListView.Horizontal
                delegate: machineButton
            }
            Component
            {
                id: sectionHeader
                Button
                {
                    id: button
                    width: ListView.view.width
                    height: UM.Theme.getSize("action_button").height
                    text: section
                    property bool isActive: base.currentSection == section
                    background: Rectangle
                    {
                        anchors.fill: parent
                        color: isActive ? UM.Theme.getColor("setting_control_highlight") : "transparent"
                    }
                    contentItem: Item
                    {
                        width: childrenRect.width
                        height: UM.Theme.getSize("action_button").height

                       /* UM.RecolorImage
                        {
                            id: arrow
                            anchors.left: parent.left
                            width: UM.Theme.getSize("standard_arrow").width
                            height: UM.Theme.getSize("standard_arrow").height
                            sourceSize.width: width
                            sourceSize.height: height
                            color: UM.Theme.getColor("text")
                            source: base.currentSection == section ? UM.Theme.getIcon("arrow_bottom") : UM.Theme.getIcon("arrow_right")
                        }*/
                        Label
                        {
                            id: label
                            anchors.left: arrow.right
                            anchors.leftMargin: UM.Theme.getSize("default_margin").width
                            anchors.bottomMargin:10
                            verticalAlignment: Text.AlignVCenter
                            text: button.text
                            font: UM.Theme.getFont("default_bold")
                            renderType: Text.NativeRendering
                        }
                    }
                    onClicked:
                    {
                        base.currentSection = section
                        base.updateCurrentItemUponSectionChange()
                    }
                }
            }

          /*  Item
            {
                id: machineButtonb
                Label
                {
                    id:lblButton
                    text:"LBLTest"
                    width:100
                    height:30
                    anchors.top:sectionHeader.bottom
                }*/

                 Component
                {
                    id: machineButton
                    Cura.RadioButtonWithImage
                    {
                        id: machineButton
                        anchors.top:parent.top
                        anchors.topMargin:-150
                        anchors.left: parent.left
                        textV:
                        {
                            if(name=="Leonardo Revo")
                            {
                               "Leonardo Revo     "
                            }else if(name=="Studio 300")
                            {
                               "Studio 300"
                            }else if(name=="Studio 300Plus")
                            {
                               "Studio 300Plus"
                            }else if(name=="Studio 200")
                            {
                                "Studio 200"
                            }       
                        }
                    
                        anchors.leftMargin: 
                        {
                               if(name=="Leonardo Revo")
                            {
                                450
                            }else if(name=="Studio 300")
                            {
                               850
                            }else if(name=="Studio 300Plus")
                            {
                               1250
                            }else if(name=="Studio 200")
                            {
                                50
                            }
                        }
                        //anchors.right: parent.right
                        //anchors.rightMargin: UM.Theme.getSize("default_margin").width
                        //anchors.top:machineList.bottom
                        //anchors.topMargin:400
                        //anchors.rightMargin:400
                        //height: visible ? UM.Theme.getSize("standard_list_lineheight").height : 0
                        width:400
                        height:400
                        imgH:
                        {
                            if(name=="Leonardo Revo")
                            {
                               400
                            }else if(name=="Studio 300")
                            {
                              300
                            }else if(name=="Studio 300Plus")
                            {
                              300
                            }else if(name=="Studio 200")
                            {
                                300
                            }


                        }
                        imageSRC:
                        {
                            if(name=="Leonardo Revo")
                            {
                                if(ListView.view.currentIndex == index)
                                {
                                        "../images/printers/leonardo.png"   
                                }else
                                {
                                        "../images/printers/leonardoNE.png"    
                                }
                            }else if(name=="Studio 300")
                            {
                                 if(ListView.view.currentIndex == index)
                                {
                                        "../images/printers/s300.png"   
                                }else
                                {
                                       "../images/printers/s300NE.png"   
                                }
                               
                            }else if(name=="Studio 300Plus")
                            {
                                 if(ListView.view.currentIndex == index)
                                {
                                        "../images/printers/s300.png"   
                                }else
                                {
                                       "../images/printers/s300NE.png"   
                                }
                               
                            }else if(name=="Studio 200")
                            {
                                 if(ListView.view.currentIndex == index)
                                {
                                        "../images/printers/s200.png"   
                                }else
                                {
                                        "../images/printers/s200NE.png"   
                                }
                              
                            }
                        }
                        checked: ListView.view.currentIndex == index
                        text: ""//name
                        visible: base.currentSection == section
                        onClicked: ListView.view.currentIndex = index
                    }
                }
           // }
          /*  Component
            {
                id:cmp2
                 /*UM.RecolorImage
                {
                    id: printerImage
                    anchors.top:machineButton.bottom
                    width: 100
                    height: 100
                    sourceSize.width: width
                    sourceSize.height: height
                    color: UM.Theme.getColor("text")
                    source: "../images/printers/leonardo.png"
                }
                Label
                {
                    id:lblbl
                    text:"Label1"
                      anchors.top:machineButton.bottom
                }

            }*/
        }
    }
    // Horizontal line
   /* Rectangle
    {
        id: horizontalLine
        anchors.top: localPrinterSelectionItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: UM.Theme.getSize("default_lining").height
        color: UM.Theme.getColor("lining")
    }*/
    // User-editable printer name row
    Row
    {
        anchors.top: horizontalLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: UM.Theme.getSize("default_lining").height
        anchors.leftMargin: UM.Theme.getSize("default_margin").width
        spacing: UM.Theme.getSize("default_margin").width
        visible:false
        Label
        {
            text: catalog.i18nc("@label", "Printer Name")
            anchors.verticalCenter: parent.verticalCenter
            font: UM.Theme.getFont("medium")
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
        }
        Cura.TextField
        {
            id: printerNameTextField
            anchors.verticalCenter: parent.verticalCenter
            width: (parent.width / 2) | 0
            placeholderText: catalog.i18nc("@text", "Please give your printer a name")

            // Make sure that the fill is not empty
            validator: RegExpValidator { regExp: /.+/ }
        }
    }
}
