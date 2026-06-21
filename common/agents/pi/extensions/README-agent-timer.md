# Agent Timer Extension

Displays the elapsed time an agent has been running in the status bar, with additional commands for viewing statistics.

## Features

- **Real-time timer**: Shows elapsed time in the status bar (footer) during agent execution, updating every second
- **Persistent duration**: Shows the last agent's duration until the next agent starts
- **Statistics tracking**: Tracks all agent runs in the current session
- **Turn counting**: Also tracks the number of turns in each agent run

## Commands

- `/agent-time` - Shows detailed statistics for all agent runs in the current session
- `/agent-time-reset` - Resets all statistics for the current session

## Installation

The extension is automatically discovered when placed in:
- `~/.pi/agent/extensions/agent-timer.ts` (global, all projects)
- `.pi/extensions/agent-timer.ts` (project-local)

Or use it temporarily with:
```bash
pi -e ~/.pi/agent/extensions/agent-timer.ts
```

## Usage

1. Start pi with the extension loaded (it's auto-discovered from the extensions directory)
2. Ask the agent to do something
3. Watch the timer appear in the status bar (⏱️ XX:XX or ⏱️ Xs)
4. Use `/agent-time` to see detailed statistics about all agent runs in the session

## Example Output

When you run `/agent-time`, you'll see something like:

```
=== Agent Time Statistics ===

✅ Completed runs:
  Run 1: 5s (1 turns)
  Run 2: 1:23 (3 turns)
  Run 3: 2:45 (2 turns)

📊 Total: 4:13 across 3 runs
   Average: 1:24 per run
   Total turns: 6
```

If an agent is currently running, you'll also see:
```
🔄 Current run: 0:15 (1 turns)
```

## Implementation Details

The extension tracks:
- `agent_start` - Starts the timer
- `turn_start` - Increments turn counter
- `turn_end` - Updates the display
- `agent_end` - Finalizes the run and stores statistics
- `session_start` - Resets all tracking
- `session_shutdown` - Cleans up

The timer updates on each turn to provide near real-time feedback.
