RAW_FILEPATH = "./raw_sweep.yaml"
OUTPUT_FILEPATH = "./keymap_output.yaml"

# raw special key
ICON_CTL = "$$phosphor:bold/control$$"
ICON_CMD = "$$phosphor:bold/command$$"
ICON_ALT = "$$phosphor:bold/option$$"
ICON_ENTER = "⏎"
ICON_TAB = "$$mdi:keyboard-tab$$"
ICON_CAPS_LOCK = "$$material:keyboard_capslock$$"
ICON_SHIFT = "$$tabler:arrow-big-up$$"
ICON_OPT = "$$phosphor:bold/option$$"
ICON_DELETE = "⌦"
ICON_BSPC = "$$tabler:backspace$$"
ICON_MEH = "$$tabler:sparkles$$"
ICON_SPACE = "$$tabler:space$$"
ICON_ESCAPE = "$$mdi:keyboard-esc$$"
ICON_MAGIC = "$$tabler:topology-star-3$$"

# Tools
ICON_VS_CODE = "$$tabler:brand-vscode$$"
ICON_MAIL = "$$tabler:mail$$"
ICON_TERMINAL = "$$tabler:terminal-2$$"
ICON_TASK = "$$tabler:checklist$$"
ICON_TIME_TRACKING = "$$tabler:alarm-average$$"
ICON_SLACK = "$$tabler:brand-slack$$"
ICON_CHROME = "$$tabler:brand-chrome$$"
ICON_BRAVE = "$$tabler:brand-firefox$$"
ICON_ZOOM = "$$tabler:video$$"
ICON_OBSIDIAN = "$$tabler:brand-notion$$"
ICON_ALFRED = "$$tabler:zoom-code$$"
ICON_ONE_PWD = "$$tabler:lock-password$$"
ICON_HAZE_OVER = "$$tabler:eye-bolt$$"

ICON_WORKSPACE = "$$tabler:brand-asana$$"
ICON_WORKSPACE_MOVE_TO = "$$material:automation$$"
ICON_JOIN = "$$tabler:arrow-merge$$"
ICON_MOVE = "$$tabler:arrow-bar-to-right$$"
ICON_SELECT = "$$tabler:select$$"
ICON_MODE = "$$tabler:box-model$$"
ICON_RESET = "$$tabler:restore$$"
ICON_SWAP = "$$tabler:transfer$$"
ICON_BALANCE = "$$tabler:scale$$"
ICON_LAYOUT = "$$tabler:layout$$"
ICON_DOWNSIZE = "$$tabler:window-minimize$$"
ICON_UPSIZE = "$$tabler:window-maximize$$"
ICON_CLOSE = "$$tabler:circle-dashed-x$$"

# key replacement
NO_ACTION = "''"
ACTION_SELECT = f"t: '{ICON_SELECT}', s: 'Select'"
ACTION_WORKSPACE = f"t: '{ICON_WORKSPACE}', s: 'Go to Space'"
ACTION_MODE = f"t: '{ICON_MODE}', s: 'Change Mode'"
ACTION_MOVE = f"t: '{ICON_MOVE}', s: 'Move Win.'"
ACTION_MOVE_TO_WORKSPACE = f"t: '{ICON_MOVE}', s: 'Win to Space'"
ACTION_JOIN = f"t: '{ICON_JOIN}', s: 'Join With'"
ACTION_LAYOUT = f"t: '{ICON_LAYOUT}', s: 'Layout'"
ACTION_DOWNSIZE = f"t: '{ICON_DOWNSIZE}', s: 'Downsize'"
ACTION_UPSIZE = f"t: '{ICON_UPSIZE}', s: 'Upsize'"

KEY_MAGIC = f"{{t: '{ICON_MAGIC}', h: '', s: ''}}"
KEY_MODE_MAIN = f"{{ {ACTION_MODE}, h: 'main' }}"
KEY_MODE_SELECTION = f"{{ {ACTION_MODE}, h: 'selection' }}"
KEY_MODE_WORKSPACE = f"{{ {ACTION_MODE}, h: 'workspace' }}"
KEY_MODE_LAYOUT = f"{{ {ACTION_MODE}, h: 'layout' }}"
KEY_SWAP_TILING_FLOATING = f"{{t: '{ICON_SWAP}', h: 'tiling / floating', s: ''}}"
KEY_FLATTEN_WORKSPACE = f"{{t: '{ICON_RESET}', s: '', h: 'flatten workspace'}}"
KEY_MEH_HELD = f"{{t: '{ICON_MEH}', h: '{ICON_SPACE}', s: '', type: 'held' }}"


def replace(content, arr):
    for i, line in enumerate(content):
        for old, new in arr.items():
            line = line.replace(old, new)

        if "layers:" in line:
            content[i] = ""
        else:
            content[i] = line

    return content
