## Required

Use the skills:

- `/skill:orchestrating-delegated-work `
- `/skill:writing-plans`
- `/skill:writing-clearly-and-concisely `
- `/skill:brainstorming`

## Task

- Write the plan based on the informations you have collected.
- Each tasks must contain a maximum of informations so that an intern/agents with `thinking: off` can implement the task
- `thinking` level must be `off` by default, and increased only if needed
- GPT 5.5 is used for review ONLY with thinking `high`
- You can run in parallel:
  - 4 minimax
  - 3 mistral
  - 1 GPT
- Optimize the tasks and pipeline so that a maximum of task can be ran asynchroniously in parallel
- Mistral can be call with one of the two option below. Note: Vibe thinking level can not be changed via CLI. So it's set to `off` by default. Prefer to use the vibe snippet when calling vibe, as it has better results than Pi. Use Pi only if you want to use Mistral with medium or high thinking level.

```sh snippet
provider_mistral_pi() {
  pi --provider mistral --model mistral-medium-3.5 \
    --thinking "${THINKING_LEVEL:-off}" \
    -p "@$1" -p "@$2" -p "$3"
}

provider_mistral_vibe() {
  local combined
  combined="$(printf '%s\n\n%s\n\n%s\n\n%s\n' \
    'You are running inside Vibe in non-interactive automation mode. Use Vibe native tools when you need to inspect, edit, or run commands. Do not print pseudo tool calls like read(file_path=...) or bash(command=...); execute the tools instead.' \
    "$(cat "$2")" \
    "$(cat "$1")" \
    "$3")"
  vibe --agent auto-approve --trust --workdir "$(pwd)" --max-turns 40 -p "$combined"
}

```

- Ensure that each agent's prompts contain the relevant instructions from `@.agents/instructions/*.md`

## Critical: Saving Path

Save the tasks in the same folder as the `prompt.md` you received in the first message, within an `executions/` folder.

```bash
$> $PROJECT_DIR/.agent/process/NN-TaskTitle/prompt.md # save your tasks in $PROJECT_DIR/.agent/process/NN-TaskTitle/executions/NN-agent-id.md
$> $PROJECT_DIR/.agent/NN-TaskTitle/prompt.md # save your tasks in $PROJECT_DIR/.agent/NN-TaskTitle/executions/NN-agent-id.md
```

## Critical: Naming Session

It is now possible to name sessions when starting a pi session with `--name {session-name}`
So adapt the pipeline to name the sessions. If we take the example from above:

```sh
provider_mistral_pi() {
  pi --provider mistral --model mistral-medium-3.5 \
    --thinking "${THINKING_LEVEL:-off}" \
    --name "${feature-name}-${agent-id}" \
    -p "@$1" -p "@$2" -p "$3"
}
```

where `${feature-name}` would be for example `NN-TaskTitle`.
