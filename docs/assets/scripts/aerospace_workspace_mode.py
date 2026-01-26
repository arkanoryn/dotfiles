import utils

no_mods_replacements = {
    "L0:": "'Aerospace | Workspace Mode | No Mods':",
    # Default Graphite
    ## First Row - Left
    "GRAPHITE_B": utils.NO_ACTION,
    "CTL_L": utils.NO_ACTION,
    "ALT_D": utils.NO_ACTION,
    "GUI_W": utils.NO_ACTION,
    "GRAPHITE_Z": utils.NO_ACTION,
    ## 2nd row - Left
    "L4_N": utils.NO_ACTION,
    "L3_R": utils.NO_ACTION,
    "L2_T": utils.NO_ACTION,
    "L1_S": utils.NO_ACTION,
    "GRAPHITE_G": utils.NO_ACTION,
    ## 3rd Row - Left
    "SFT_Q": utils.NO_ACTION,
    "GRAPHITE_X": utils.NO_ACTION,
    "GRAPHITE_M": utils.NO_ACTION,
    "GRAPHITE_C": utils.NO_ACTION,
    "GRAPHITE_V": utils.NO_ACTION,
    # Right
    ## First Row - Right
    "QUOT_UNDS": utils.NO_ACTION,
    "GUI_F": f"{{ t: {utils.ICON_WORKSPACE}, s: 'Swap Space', h: 'back-forth' }}",
    "ALT_O": utils.NO_ACTION,
    "CTL_U": utils.NO_ACTION,
    "GRAPHITE_J": utils.NO_ACTION,
    ## 2nd row - Right
    "GRAPHITE_Y": utils.NO_ACTION,
    "L1_H": f"{{ {utils.ACTION_WORKSPACE}, h: '1' }}",
    "L2_A": f"{{ {utils.ACTION_WORKSPACE}, h: '2' }}",
    "L3_E": f"{{ {utils.ACTION_WORKSPACE}, h: '3' }}",
    "L4_I": f"{{ {utils.ACTION_WORKSPACE}, h: '4' }}",
    ## 3rd Row - Right
    "GRAPHITE_K": utils.NO_ACTION,
    "GRAPHITE_P": utils.NO_ACTION,
    "DOT_EXLM": utils.NO_ACTION,
    "COMM": utils.NO_ACTION,
    "SFT_SLSH": utils.NO_ACTION,
    # Thumbs
    ## Thumbs Left
    "MEH_SPC": utils.KEY_MODE_MAIN,
    "MAGIC": utils.KEY_MAGIC,
    ## Thumbs Right
    "BSPC": utils.KEY_FLATTEN_WORKSPACE,
    "ENT": utils.KEY_SWAP_TILING_FLOATING,
}

meh_mods_replacements = {
    "L0:": "'Aerospace | Workspace Mode | Meh Mods':",
    # Default Graphite
    ## First Row - Left
    "GRAPHITE_B": utils.NO_ACTION,
    "CTL_L": utils.NO_ACTION,
    "ALT_D": utils.NO_ACTION,
    "GUI_W": utils.NO_ACTION,
    "GRAPHITE_Z": utils.NO_ACTION,
    ## 2nd row - Left
    "L4_N": utils.NO_ACTION,
    "L3_R": utils.NO_ACTION,
    "L2_T": utils.NO_ACTION,
    "L1_S": utils.NO_ACTION,
    "GRAPHITE_G": utils.NO_ACTION,
    ## 3rd Row - Left
    "SFT_Q": utils.NO_ACTION,
    "GRAPHITE_X": utils.NO_ACTION,
    "GRAPHITE_M": utils.NO_ACTION,
    "GRAPHITE_C": utils.NO_ACTION,
    "GRAPHITE_V": utils.NO_ACTION,
    # Right
    ## First Row - Right
    "QUOT_UNDS": utils.NO_ACTION,
    "GUI_F": f"{{ {utils.ACTION_JOIN}, h: '' }}",
    "ALT_O": f"{{ {utils.ACTION_JOIN}, h: '' }}",
    "CTL_U": f"{{ {utils.ACTION_JOIN}, h: '' }}",
    "GRAPHITE_J": f"{{ {utils.ACTION_JOIN}, h: '' }}",
    ## 2nd row - Right
    "GRAPHITE_Y": utils.NO_ACTION,
    "L1_H": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: 'and follow' }}",
    "L2_A": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: 'and follow' }}",
    "L3_E": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: 'and follow' }}",
    "L4_I": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: 'and follow' }}",
    ## 3rd Row - Right
    "GRAPHITE_K": utils.NO_ACTION,
    "GRAPHITE_P": utils.KEY_MODE_MAIN,
    "DOT_EXLM": utils.KEY_MODE_WORKSPACE,
    "COMM": utils.KEY_MODE_LAYOUT,
    "SFT_SLSH": utils.NO_ACTION,
    # Thumbs
    ## Thumbs Left
    "MEH_SPC": utils.KEY_MEH_HELD,
    "MAGIC": utils.NO_ACTION,
    ## Thumbs Right
    "BSPC": utils.NO_ACTION,
    "ENT": utils.NO_ACTION,
}

alt_mods_replacements = {
    "L0:": "'Aerospace | Workspace Mode | ALT Mod':",
    # Default Graphite
    ## First Row - Left
    "GRAPHITE_B": utils.NO_ACTION,
    "CTL_L": utils.NO_ACTION,
    "ALT_D": f"{{ t: '{utils.ICON_ALT}', h: 'alt', s: '', type: 'held' }}",
    "GUI_W": utils.NO_ACTION,
    "GRAPHITE_Z": utils.NO_ACTION,
    ## 2nd row - Left
    "L4_N": utils.NO_ACTION,
    "L3_R": utils.NO_ACTION,
    "L2_T": utils.NO_ACTION,
    "L1_S": utils.NO_ACTION,
    "GRAPHITE_G": utils.NO_ACTION,
    ## 3rd Row - Left
    "SFT_Q": utils.NO_ACTION,
    "GRAPHITE_X": utils.NO_ACTION,
    "GRAPHITE_M": utils.NO_ACTION,
    "GRAPHITE_C": utils.NO_ACTION,
    "GRAPHITE_V": utils.NO_ACTION,
    # Right
    ## First Row - Right
    "QUOT_UNDS": utils.NO_ACTION,
    "GUI_F": utils.NO_ACTION,
    "ALT_O": utils.NO_ACTION,
    "CTL_U": utils.NO_ACTION,
    "GRAPHITE_J": utils.NO_ACTION,
    ## 2nd row - Right
    "GRAPHITE_Y": utils.NO_ACTION,
    "L1_H": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: '' }}",
    "L2_A": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: '' }}",
    "L3_E": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: '' }}",
    "L4_I": f"{{ {utils.ACTION_MOVE_TO_WORKSPACE}, h: '' }}",
    ## 3rd Row - Right
    "GRAPHITE_K": utils.NO_ACTION,
    "GRAPHITE_P": utils.NO_ACTION,
    "DOT_EXLM": utils.NO_ACTION,
    "COMM": utils.NO_ACTION,
    "SFT_SLSH": utils.NO_ACTION,
    # Thumbs
    ## Thumbs Left
    "MEH_SPC": utils.NO_ACTION,
    "MAGIC": utils.NO_ACTION,
    ## Thumbs Right
    "BSPC": utils.NO_ACTION,
    "ENT": utils.NO_ACTION,
}


def no_mods(content):
    return "".join(utils.replace(content, no_mods_replacements))


def meh_mods(content):
    return "".join(utils.replace(content, meh_mods_replacements))


def alt_mods(content):
    return "".join(utils.replace(content, alt_mods_replacements))
