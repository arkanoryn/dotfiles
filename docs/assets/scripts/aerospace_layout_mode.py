import utils

no_mods_replacements = {
    "L0:": "'Aerospace | Layout Mode | No Mods':",
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
    "GUI_F": utils.KEY_SWAP_TILING_FLOATING,
    "ALT_O": f"{{ t: {utils.ICON_RESET}, s: 'reload config' }}",
    "CTL_U": utils.NO_ACTION,
    "GRAPHITE_J": f"{{ t: {utils.ICON_BALANCE}, s: 'Balance Win' }}",
    ## 2nd row - Right
    "GRAPHITE_Y": utils.NO_ACTION,
    "L1_H": f"{{ {utils.ACTION_LAYOUT}, h: 'acc. vert.' }}",
    "L2_A": f"{{ {utils.ACTION_LAYOUT}, h: 'til. vert.' }}",
    "L3_E": f"{{ {utils.ACTION_LAYOUT}, h: 'til. horz.' }}",
    "L4_I": f"{{ {utils.ACTION_LAYOUT}, h: 'acc. horz.' }}",
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
    "L0:": "'Aerospace | Layout Mode | Meh Mods':",
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
    "GUI_F": f"{{ {utils.ACTION_DOWNSIZE}, h: '' }}",
    "ALT_O": f"{{ {utils.ACTION_DOWNSIZE}, h: '' }}",
    "CTL_U": f"{{ {utils.ACTION_UPSIZE}, h: '' }}",
    "GRAPHITE_J": f"{{ {utils.ACTION_UPSIZE}, h: '' }}",
    ## 2nd row - Right
    "GRAPHITE_Y": utils.NO_ACTION,
    "L1_H": f"{{ {utils.ACTION_JOIN}, h: 'left' }}",
    "L2_A": f"{{ {utils.ACTION_JOIN}, h: 'down' }}",
    "L3_E": f"{{ {utils.ACTION_JOIN}, h: 'up' }}",
    "L4_I": f"{{ {utils.ACTION_JOIN}, h: 'right' }}",
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
    "BSPC": f"{{ t: {utils.ICON_CLOSE}, s: 'Close all win', h: 'but curr.' }}",
    "ENT": utils.NO_ACTION,
}


def no_mods(content):
    return "".join(utils.replace(content, no_mods_replacements))


def meh_mods(content):
    return "".join(utils.replace(content, meh_mods_replacements))
