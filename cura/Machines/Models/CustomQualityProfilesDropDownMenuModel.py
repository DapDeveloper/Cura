# Copyright (c) 2018 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.

from UM.Logger import Logger
from cura.Machines.Models.QualityProfilesDropDownMenuModel import QualityProfilesDropDownMenuModel
#
# This model is used for the custom profile items in the profile drop down menu.
#
class CustomQualityProfilesDropDownMenuModel(QualityProfilesDropDownMenuModel):
    def _update(self):
        Logger.log("d", "Updating {model_class_name}.".format(model_class_name = self.__class__.__name__))
        print("CUSTOMQUALITYPROFILESDROPDOWNMENUMODEL CALLED")
        active_global_stack = self._machine_manager.activeMachine
        if active_global_stack is None:
            self.setItems([])
            Logger.log("d", "No active GlobalStack, set %s as empty.", self.__class__.__name__)
            return
        quality_changes_group_dict = self._quality_manager.getQualityChangesGroups(active_global_stack)
        item_list = []
        for key in sorted(quality_changes_group_dict, key = lambda name: name.upper()):
            quality_changes_group = quality_changes_group_dict[key]
            toShow=True
            name=quality_changes_group.name
            if(len(quality_changes_group.name)>10):
                #print("LUNGHEZZA:"+str(len(quality_changes_group.name)))            
                #print("QUALITY:"+quality_changes_group.name[0:8])
                if(quality_changes_group.name[0:9]=='*AUTOSAVE'):
                    name=quality_changes_group.name[9:]
                    toShow=False
            item = {"name": name,
                    "layer_height": "",
                    "layer_height_without_unit": "",
                    "available": quality_changes_group.is_available,
                    "quality_changes_group": quality_changes_group}
            if(toShow):
                item_list.append(item)
        self.setItems(item_list)