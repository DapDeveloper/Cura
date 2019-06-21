// Copyright (c) 2019 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.
import QtQuick 2.10
import QtQuick.Controls 2.3
import UM 1.3 as UM
import Cura 1.1 as Cura
//
// This component contains the content for the "Welcome" page of the welcome on-boarding process.
//
Item
{
    UM.I18nCatalog { id: catalog; name: "cura" }
    Column  // Arrange the items vertically and put everything in the center
    {
        //anchors.centerIn: parent
        anchors
        {
            horizontalCenter:parent.horizontalCenter
            top:parent.top
            bottom:parent.bottom
        }
        width: parent.width
        spacing: UM.Theme.getSize("wide_margin").height
        Label
        {
            id: titleLabel
            //anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors
            {
                horizontalCenter:parent.horizontalCenter
                top:parent.top
            }
            text: catalog.i18nc("@label", "Welcome to Mtc Slicer")
            color: UM.Theme.getColor("primary_button")
            font: UM.Theme.getFont("huge")
            renderType: Text.NativeRendering
        }
        Image
        {
            id: curaImage
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors
            {
                horizontalCenter:parent.horizontalCenter
                top:titleLabel.bottom
                topMargin:50
            }
            source: UM.Theme.getImage("first_run_welcome_cura")
        }
        /*   Cura.MessageDialog
        {
            id: infoMultipleFilesWithGcodeDialog
            /* title: catalog.i18nc("@title:window", "Open File(s)")
            icon: StandardIcon.Information
            /*standardButtons: StandardButton.Ok
            text: catalog.i18nc("@text:window", "We have found one or more G-Code files within the files you have selected. You can only open one G-Code file at a time. If you want to open a G-Code file, please just select only one.")
            property var selectedMultipleFiles
            property var hasProjectFile
            property var fileUrls
            property var projectFileUrlList
            onAccepted:
            {
                openDialog.handleOpenFiles(selectedMultipleFiles, hasProjectFile, fileUrls, projectFileUrlList);
            }*/
        //}
        Label
        {
            id: wantAddModel
            width:300
            //anchors.horizontalCenter: parent.horizontalCenter
           // horizontalAlignment: Text.AlignHCenter
            anchors
            {
                left:parent.left
                top:curaImage.bottom
                topMargin:10
                leftMargin:10
            }
            text: catalog.i18nc("@label", "Want to add 3d Models?")
            color: UM.Theme.getColor("primary_button")
            font: UM.Theme.getFont("huge")
            renderType: Text.NativeRendering
        }
        Cura.PrimaryButton
        {
            id: btnAddFile
            anchors
            {
                //left:parent.left
                left:wantAddModel.left
                top:wantAddModel.bottom
                topMargin:10
                
            }
            text: catalog.i18nc("@button", "Add model")
            onClicked: Cura.Actions.open.trigger()//base.showNextPage()
        }
        Label
        {
            id: choosePrinter
            width:300
            //anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignRight
            anchors
            {
                right:parent.right
                top:curaImage.bottom
                topMargin:10
                rightMargin:10
            }
            text: catalog.i18nc("@label", "Choose your printer")
            color: UM.Theme.getColor("primary_button")
            font: UM.Theme.getFont("huge")
            renderType: Text.NativeRendering
        }
      /*  Cura.MachineSelector
        {
            id:machineSelID
            width:parent.width/2
            height:lblTitle.height*3
            anchors
            {
                horizontalCenter:choosePrinter.horizontalCenter
                top:choosePrinter.bottom
                topMargin:10
            }
            anchors.topMargin:10
        }*/
           Cura.SettingViewViewerWizardWelcome
        {
            id:choosePrinterID
            width:200
            height:50
            anchors
            {
                //horizontalCenter:choosePrinter.horizontalCenter
                right:parent.right
                top:choosePrinter.bottom
                topMargin:10
                rightMargin:10
            }
        }
        Label
        {
            id: chooseMaterial
            width:300
            //anchors.horizontalCenter: parent.horizontalCenter
            //horizontalAlignment: Text.AlignHCenter

            anchors
            {
                left:parent.left
                top:btnAddFile.bottom
                topMargin:30
                leftMargin:10
            }
            text: catalog.i18nc("@label", "Choose your material")
            color: UM.Theme.getColor("primary_button")
            font: UM.Theme.getFont("huge")
            renderType: Text.NativeRendering
        }
        Cura.SettingViewViewerWizardWelcomeMat
        {
            width:300
            height:50
            anchors
            {
                //horizontalCenter:choosePrinter.horizontalCenter
                left:parent.left
                top:chooseMaterial.bottom
                topMargin:10
                rightMargin:10
                leftMargin:10
            }
        }
        Label
        {
            id: selectProfile
            width:300
            horizontalAlignment: Text.AlignRight
            anchors
            {
                right:parent.right
                top:choosePrinterID.bottom
                topMargin:10
                rightMargin:10
            }
            text: catalog.i18nc("@label", "Select your profile")
            color: UM.Theme.getColor("primary_button")
            font: UM.Theme.getFont("huge")
            renderType: Text.NativeRendering
        }
        Cura.SettingViewViewerWizardWelcomeProfile
        {
            width:300
            height:50
            anchors
            {
                right:parent.right
                top:selectProfile.bottom
                topMargin:10
                //rightMargin:10
            }
        }
        Cura.PrimaryButton
        {
            id: getStartedButton
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.margins: UM.Theme.getSize("wide_margin").width
            anchors
            {
                right:parent.right
                bottom:parent.bottom
            }
            text: catalog.i18nc("@button", "Get started")
            onClicked: Cura.Actions.closeWelcomeWindow.trigger()//base.showNextPage()
        }
    }
}