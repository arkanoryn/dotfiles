import utils

replacements = {
    "L0:": "'Aerospace | Main Mode':",
    # Default Graphite
    ## First Row - Left
    "GRAPHITE_B": f"{{ t: '{utils.ICON_ONE_PWD}', h: '', s: '' }}",
    "CTL_L": f"{{ t: '{utils.ICON_BRAVE}', h: 'Brave', s: '' }}",
    "ALT_D": f"{{ t: '{utils.ICON_OBSIDIAN}', h: '', s: '' }}",
    "GUI_W": f"{{ t: '{utils.ICON_ALFRED}', h: '', s: '' }}",
    "GRAPHITE_Z": f"{{ t: '{utils.ICON_ZOOM}', h: '', s: '' }}",
    ## 2nd row - Left
    "L4_N": f"{{ t: '{utils.ICON_TIME_TRACKING}', h: 'Harvest', s: '' }}",
    "L3_R": f"{{ t: '{utils.ICON_TASK}', h: 'Things3', s: '' }}",
    "L2_T": f"{{ t: '{utils.ICON_TERMINAL}', h: '', s: '' }}",
    "L1_S": f"{{ t: '{utils.ICON_SLACK}', h: '', s: '' }}",
    "GRAPHITE_G": f"{{ t: '{utils.ICON_CHROME}', h: '', s: '' }}",
    ## 3rd Row - Left
    "SFT_Q": f"{{ t: '{utils.ICON_TERMINAL}', h: 'WezTerm', s: '' }}",
    "GRAPHITE_X": f"{{ t: '{utils.ICON_HAZE_OVER}', h: 'HazeOver', s: '' }}",
    "GRAPHITE_M": f"{{ t: '{utils.ICON_MAIL}', h: '', s: '' }}",
    "GRAPHITE_C": f"{{ t: '{utils.ICON_VS_CODE}', h: '', s: '' }}",
    "GRAPHITE_V": utils.NO_ACTION,
    # Right
    ## First Row - Right
    "QUOT_UNDS": utils.NO_ACTION,
    "GUI_F": f"{{ {utils.ACTION_WORKSPACE}, h: '' }}",
    "ALT_O": f"{{ {utils.ACTION_WORKSPACE}, h: '' }}",
    "CTL_U": f"{{ {utils.ACTION_WORKSPACE}, h: '' }}",
    "GRAPHITE_J": f"{{ {utils.ACTION_WORKSPACE}, h: '' }}",
    ## 2nd row - Right
    "GRAPHITE_Y": utils.NO_ACTION,
    "L1_H": f"{{ {utils.ACTION_SELECT}, h: 'left' }}",
    "L2_A": f"{{ {utils.ACTION_SELECT}, h: 'down' }}",
    "L3_E": f"{{ {utils.ACTION_SELECT}, h: 'up' }}",
    "L4_I": f"{{ {utils.ACTION_SELECT}, h: 'right' }}",
    ## 3rd Row - Right
    "GRAPHITE_K": utils.NO_ACTION,
    "GRAPHITE_P": utils.KEY_MODE_SELECTION,
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


def replace(content, arr):
    for i, line in enumerate(content):
        for old, new in arr.items():
            line = line.replace(old, new)
        content[i] = line

    return content


def meh_mods(content):
    return "".join(utils.replace(content, replacements))
