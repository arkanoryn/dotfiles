---
tags:
  - moc
---
# Context
In order to visualize the different shortcuts directly on the keyboard, I'm using [keymap drawer](https://github.com/caksoylar/keymap-drawer/tree/v0.19.0). This allows me to have an "easy to understand" image of the keyboard.

To make it easy (on me) I will write a script for each tool and layer with which I want to have a visualization for.
To do that, I created under `/assets/scripts/` different files:
- **raw_sweep.yaml**: this is my raw configuration for my current keyboard. I steal it from my keyboard configuration directly where it is automatically generated, so updating it on demand should not be too hard. Furthermore, since I'm using Graphite, it should not change anyway.
- ***.py **:  each of the python file will generate the yaml file that can then be used in keymap drawer.

# Running the script

```sh
cd <root>/docs/assets/scripts
python3 main.py  # will generate the yaml that can then be put in keymap drawer
```