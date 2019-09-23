# Copyright (c) 2017 Ultimaker B.V.
# Cura is released under the terms of the LGPLv3 or higher.

import UM.Settings.Models.SettingVisibilityHandler

class MaterialSettingsVisibilityHandler(UM.Settings.Models.SettingVisibilityHandler.SettingVisibilityHandler):
    def __init__(self, parent = None, *args, **kwargs):
        super().__init__(parent = parent, *args, **kwargs)
        material_settings = {
            "default_material_print_temperature",
            "material_print_temperature",
            "material_initial_print_temperature",
            "material_final_print_temperature",
            "material_extrusion_cool_down_speed",
            "default_material_bed_temperature",
            "default_material_chamber_temperature",
            "material_bed_temperature",
            "material_bed_temperature_layer_0",
            "material_adhesion_tendency",
            "material_surface_energy",
            "material_standby_temperature",
            #"material_flow_temp_graph",
            "retraction_amount",
            "retraction_speed",
            "material_print_temperature_layer_0",
            "material_flow",
            "material_flow_layer_0",
            #"retraction_enable",
            #"retract_at_layer_change",
            "retraction_amount",
            "retraction_speed",
            "retraction_retract_speed",
            "retraction_prime_speed",
            "retraction_extra_prime_amount",
            "retraction_min_travel",
            "retraction_count_max",
            "retraction_extrusion_window",
            "limit_support_retraction",
            "switch_extruder_retraction_amount",
            "switch_extruder_retraction_speeds",
            "switch_extruder_prime_speed",
            #"cool_fan_enabled",
            #○"cool_fan_speed",
            "cool_min_layer_time_fan_speed_max",
            "cool_min_speed",
            "cool_lift_head",
       
            "cool_fan_full_at_height",
            "cool_fan_full_layer",
            "cool_fan_speed_min",
            "cool_fan_speed_max",
            "cool_fan_speed_0",
            "raft_fan_speed",
            "raft_surface_fan_speed",
            "raft_interface_fan_speed",
            "raft_base_fan_speed",
            '''"default_material_print_temperature",
            "default_material_bed_temperature",
            "material_standby_temperature",
            #"material_flow_temp_graph",
            "cool_fan_speed",
            "retraction_amount",
            "retraction_speed",'''
        }
        self.setVisible(material_settings)
