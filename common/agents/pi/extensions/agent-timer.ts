/**
 * Agent Timer Extension
 *
 * Displays the elapsed time an agent has been running, plus a 5-minute
 * countdown that starts the moment the agent finishes its job. The
 * countdown is meant as a heads-up: once it hits 0, the provider's
 * prompt cache is likely to evict and your next prompt will pay the
 * full re-processing cost.
 *
 * Status bar composition:
 *   - Running:        ⏱️ 0:30
 *   - Idle, armed:    ⏹️ 0:30 · 14:32:05 ↻ 4:30
 *   - Idle, expired:  ⏹️ 0:30 · 14:32:05 ↻ 0:00   (warning color)
 *
 * Features:
 * - Real-time elapsed timer updating every second during agent execution
 * - 5-minute cache-window countdown, armed on agent_end and disarmed on agent_start
 * - Countdown keeps draining while idle so the cache window is always visible
 * - Shows final duration AND the finish clock time persistently until next agent starts
 * - Command: /agent-time - Shows current session's agent execution times
 *
 * Usage: pi -e ~/.pi/agent/extensions/agent-timer.ts
 */

const COUNTDOWN_MS = 5 * 60 * 1000;

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

interface AgentRun {
	startTime: number;
	endTime: number | null;
	turnCount: number;
}

export default function (pi: ExtensionAPI) {
	let currentRun: AgentRun | null = null;
	let lastRunDuration: number | null = null;
	let lastRunEndTime: number | null = null;
	// Wall-clock instant at which the cache-window countdown hits 0.
	// Armed on agent_end (when the agent finishes its job) and disarmed
	// on agent_start (when the user has sent a new prompt and the cache
	// is being refreshed by the new request).
	let countdownEndAt: number | null = null;
	const runs: AgentRun[] = [];
	const statusKey = "agent-timer";
	let updateInterval: NodeJS.Timeout | null = null;
	let idleCountdownInterval: NodeJS.Timeout | null = null;

	/**
	 * Format duration in a human-readable format
	 * - < 60s: "Xs"
	 * - < 60min: "X:XX"
	 * - >= 60min: "X:XX:XX"
	 */
	const formatDuration = (ms: number): string => {
		const totalSeconds = Math.floor(ms / 1000);
		const minutes = Math.floor(totalSeconds / 60);
		const hours = Math.floor(minutes / 60);
		
		const seconds = totalSeconds % 60;
		const remainingMinutes = minutes % 60;
		
		const pad = (num: number) => num.toString().padStart(2, "0");
		
		if (hours > 0) {
			return `${pad(hours)}:${pad(remainingMinutes)}:${pad(seconds)}`;
		} else if (minutes > 0) {
			return `${pad(minutes)}:${pad(seconds)}`;
		} else {
			return `${seconds}s`;
		}
	};

	/**
	 * Format a wall-clock timestamp as HH:MM:SS in local time
	 */
	const formatClockTime = (ms: number): string => {
		const d = new Date(ms);
		const pad = (n: number) => n.toString().padStart(2, "0");
		return `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
	};

	/**
	 * Format a millisecond duration as M:SS for the countdown
	 */
	const formatCountdown = (ms: number): string => {
		const total = Math.max(0, Math.floor(ms / 1000));
		const minutes = Math.floor(total / 60);
		const seconds = total % 60;
		const pad = (n: number) => n.toString().padStart(2, "0");
		return `${minutes}:${pad(seconds)}`;
	};

	/**
	 * Render the cache-window countdown suffix, or "" if no countdown is active.
	 * Returns { text, warning } so the caller can pick the color.
	 */
	const renderCountdown = (): { text: string; warning: boolean } | null => {
		if (countdownEndAt === null) return null;
		const remaining = countdownEndAt - Date.now();
		return { text: `↻ ${formatCountdown(remaining)}`, warning: remaining <= 0 };
	};

	/**
	 * Update the status bar with current elapsed time, last-run info, and countdown.
	 * While the agent is running the countdown is hidden (it only makes sense
	 * after the agent has finished its work). Once the run ends the countdown
	 * is shown alongside the finished-run indicators until the next agent_start.
	 */
	const updateStatus = (ctx: any) => {
		const theme = ctx.ui.theme;

		if (currentRun) {
			// Agent is running - show live timer only; the cache window is being
			// refreshed by each request, so the countdown is not relevant here.
			const elapsed = Date.now() - currentRun.startTime;
			ctx.ui.setStatus(statusKey, theme.fg("accent", `⏱️ ${formatDuration(elapsed)}`));
		} else {
			const cd = renderCountdown();
			if (lastRunDuration !== null && lastRunEndTime !== null) {
				// Agent finished - show last duration, finish clock, and the
				// 5-minute cache-window countdown (armed at agent_end).
				const base = `⏹️ ${formatDuration(lastRunDuration)} · ${formatClockTime(lastRunEndTime)}`;
				const color = cd?.warning ? "warning" : "dim";
				const suffix = cd ? ` ${cd.text}` : "";
				ctx.ui.setStatus(statusKey, theme.fg(color, `${base}${suffix}`));
			} else if (cd) {
				// No completed run yet, but a countdown is somehow armed.
				const color = cd.warning ? "warning" : "dim";
				ctx.ui.setStatus(statusKey, theme.fg(color, cd.text));
			} else {
				ctx.ui.setStatus(statusKey, "");
			}
		}
	};

	/**
	 * Start the update interval for live timer
	 */
	const startUpdateInterval = (ctx: any) => {
		// Clear any existing interval
		if (updateInterval) {
			clearInterval(updateInterval);
		}
		// Update every second
		updateInterval = setInterval(() => {
			updateStatus(ctx);
		}, 1000);
	};

	/**
	 * Stop the update interval
	 */
	const stopUpdateInterval = () => {
		if (updateInterval) {
			clearInterval(updateInterval);
			updateInterval = null;
		}
	};

	/**
	 * Keep ticking the status bar at a low rate while the agent is idle, so
	 * the cache-window countdown keeps draining toward zero instead of
	 * freezing at whatever value it had when the run ended.
	 */
	const startIdleCountdownTicker = (ctx: any) => {
		stopIdleCountdownTicker();
		if (countdownEndAt === null) return;
		idleCountdownInterval = setInterval(() => {
			// If the countdown has fully expired, stop ticking.
			if (countdownEndAt !== null && Date.now() >= countdownEndAt) {
				updateStatus(ctx);
				stopIdleCountdownTicker();
				return;
			}
			updateStatus(ctx);
		}, 1000);
	};

	const stopIdleCountdownTicker = () => {
		if (idleCountdownInterval) {
			clearInterval(idleCountdownInterval);
			idleCountdownInterval = null;
		}
	};

	/**
	 * Reset the 5-minute cache-window countdown to start fresh from now.
	 */
	const resetCountdown = () => {
		countdownEndAt = Date.now() + COUNTDOWN_MS;
	};

	/**
	 * Start a new agent run
	 */
	const startRun = (ctx: any) => {
		// Clear last run duration display when new run starts
		lastRunDuration = null;
		lastRunEndTime = null;

		// The user has just sent a new prompt: the provider's cache is being
		// refreshed by this request, so the previous cache-window countdown
		// no longer applies. Disarm it; it will be re-armed on agent_end.
		countdownEndAt = null;
		stopIdleCountdownTicker();

		currentRun = {
			startTime: Date.now(),
			endTime: null,
			turnCount: 0,
		};

		startUpdateInterval(ctx);
		updateStatus(ctx);
	};

	/**
	 * End the current agent run
	 */
	const endRun = (ctx: any) => {
		stopUpdateInterval();

		if (currentRun) {
			currentRun.endTime = Date.now();
			lastRunDuration = currentRun.endTime - currentRun.startTime;
			lastRunEndTime = currentRun.endTime;
			runs.push(currentRun);
			currentRun = null;

			// The agent is done with its job: this is the moment the provider's
			// 5-minute prompt-cache window begins. Arm the countdown now.
			resetCountdown();
			updateStatus(ctx);
			startIdleCountdownTicker(ctx);
		}
	};

	/**
	 * Clear all tracking
	 */
	const clearTracking = () => {
		stopUpdateInterval();
		stopIdleCountdownTicker();
		currentRun = null;
		lastRunDuration = null;
		lastRunEndTime = null;
		countdownEndAt = null;
		runs.length = 0;
	};

	// Session start - initialize
	pi.on("session_start", async (_event, ctx) => {
		clearTracking();
		ctx.ui.setStatus(statusKey, "");
	});

	// Agent start - begin tracking time
	pi.on("agent_start", async (_event, ctx) => {
		startRun(ctx);
	});

	// Turn start - increment turn counter
	pi.on("turn_start", async (_event, ctx) => {
		if (currentRun) {
			currentRun.turnCount++;
		}
		// No countdown reset here: the window is armed at agent_end, not on
		// turn boundaries.
	});

	// Agent end - finalize run
	pi.on("agent_end", async (_event, ctx) => {
		endRun(ctx);
	});

	// Session shutdown - cleanup
	pi.on("session_shutdown", async () => {
		clearTracking();
	});

	// Command to show agent time statistics
	pi.registerCommand("agent-time", {
		description: "Show agent execution time statistics for current session",
		handler: async (_args, ctx) => {
			if (runs.length === 0 && !currentRun) {
				ctx.ui.notify("No agent runs recorded in this session", "info");
				return;
			}

			const lines: string[] = ["=== Agent Time Statistics ==="];
			
			// Current run
			if (currentRun) {
				const elapsed = Date.now() - currentRun.startTime;
				lines.push(`\n🔄 Current run: ${formatDuration(elapsed)} (${currentRun.turnCount} turns)`);
			}

			// Last run
			if (lastRunDuration !== null && (!currentRun || runs.length > 0)) {
				const finishedAt = lastRunEndTime !== null ? formatClockTime(lastRunEndTime) : "?";
				lines.push(`\n⏹️  Last run: ${formatDuration(lastRunDuration)} (finished at ${finishedAt})`);
			}

			// Cache-window countdown
			if (countdownEndAt !== null) {
				const remaining = countdownEndAt - Date.now();
				const warn = remaining <= 0 ? " ⚠️ expired" : "";
				lines.push(`\n↻  Cache window: ${formatCountdown(remaining)} remaining${warn}`);
			}

			// Completed runs
			if (runs.length > 0) {
				lines.push("\n✅ Completed runs:");
				
				let totalTime = 0;
				let totalTurns = 0;
				
				for (let i = 0; i < runs.length; i++) {
					const run = runs[i];
					const duration = run.endTime! - run.startTime;
					totalTime += duration;
					totalTurns += run.turnCount;
					lines.push(`  Run ${i + 1}: ${formatDuration(duration)} (${run.turnCount} turns)`);
				}
				
				const avgTime = totalTime / runs.length;
				lines.push(`\n📊 Total: ${formatDuration(totalTime)} across ${runs.length} runs`);
				lines.push(`   Average: ${formatDuration(avgTime)} per run`);
				lines.push(`   Total turns: ${totalTurns}`);
			}

			// Show in a custom UI
			ctx.ui.custom({
				title: "Agent Time Statistics",
				content: lines.join("\n"),
				width: 60,
				height: Math.min(20, lines.length + 2),
			});
		},
	});

	// Command to reset statistics
	pi.registerCommand("agent-time-reset", {
		description: "Reset agent time statistics",
		handler: async (_args, ctx) => {
			clearTracking();
			ctx.ui.notify("Agent time statistics reset", "info");
		},
	});
}
