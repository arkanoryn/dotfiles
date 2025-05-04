import utils
import aerospace_main_mode
import aerospace_selection_mode
import aerospace_workspace_mode
import aerospace_layout_mode


def generate_aerospace_keymaps(layer, file):
    file.write(aerospace_main_mode.meh_mods(layer.copy()))
    file.write(aerospace_selection_mode.no_mods(layer.copy()))
    file.write(aerospace_selection_mode.meh_mods(layer.copy()))
    file.write(aerospace_selection_mode.alt_mods(layer.copy()))
    file.write(aerospace_workspace_mode.no_mods(layer.copy()))
    file.write(aerospace_workspace_mode.meh_mods(layer.copy()))
    file.write(aerospace_workspace_mode.alt_mods(layer.copy()))
    file.write(aerospace_layout_mode.no_mods(layer.copy()))
    file.write(aerospace_layout_mode.meh_mods(layer.copy()))


with open(utils.RAW_FILEPATH, "r") as raw_file:
    layer = raw_file.readlines()

HEADER = """layout:
  { qmk_keyboard: splitkb/aurora/sweep/rev1, layout_name: LAYOUT_split_3x5_2 }
layers:
"""

with open(utils.OUTPUT_FILEPATH, "w") as file:
    file.write(HEADER)
    generate_aerospace_keymaps(layer, file)
