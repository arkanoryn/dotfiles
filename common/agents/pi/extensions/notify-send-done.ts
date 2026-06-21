/**
 * Desktop notification on agent completion.
 * Fires `notify-send` (libnotify) when the agent finishes a turn.
 *
 * Hook: `agent_end` — emitted once per user prompt, after the model has
 * responded and all tool calls have settled. Use this rather than
 * `turn_end` (which fires for every LLM turn inside a single prompt).
 */
import { execFile } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function notifySend(title: string, body: string): void {
	// Fire and forget. notify-send can fail (no D-Bus, no libnotify, headless
	// session, etc.) and we never want to disturb the agent loop because of it.
	execFile("notify-send", ["-a", "Pi", "-u", "low", title, body], () => {});
}

export default function (pi: ExtensionAPI) {
	pi.on("agent_end", () => {
		// notify-send is a Linux thing; on macOS/Windows the user can swap in
		// `osascript` or the OSC 777 path used by the bundled notify.ts example.
		if (process.platform !== "linux") return;
		notifySend("Pi agent is done", "Ready for input");
	});
}
