// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0

import UM 1.0 as UM
import Cura 1.0 as Cura

Item
{
    id:Item
    anchors.left:parent.left
    anchors.top:parent.top
    UM.SimpleButton
    {
        id:simpleButton1
        anchors.left:parent.left
        anchors.top:parent.top
        text:"TEST1"
    }
}