# Session Feedback: hyprwhspr three-bug recovery

**Date:** 2026-06-24
**Task:** Restore hyprwhspr dictation after Arch + AUR update broke recording, transcription, and injection. Identified and patched 3 upstream bugs in `/usr/lib/hyprwhspr/`.
**Files Changed:** +1 created (`/tmp/hyprwhspr-fix/apply.py`), ~2 patched (`audio_capture.py`, `whisper_manager.py`, `main.py`)
**No commits** — patches live in `/tmp/hyprwhspr-fix/`, not yet surviving `yay -Syu`.

## ✅ What Went Well

- **Layered diagnosis over multiple turns.** Each turn peeled one layer: symptom → config drift → missing overlay → wrong mic → wrong ASR sample rate → silent mic input → broken sample-rate chain. Pacing each diagnosis separately kept the user oriented.
- **`ydotool type` self-test in the chat** proved text injection was fine (the user's "hello test" reply was the ydotool output) — instantly eliminated one wrong theory.
- **Direct `parec` + spectral analysis** (`fft`, voice-active frames) gave objective audio-level evidence instead of guessing about "is the mic capturing". Spectrum showing 73% sub-bass + 0% voice frames made the no-voice hypothesis falsifiable.
- **Idempotent patcher script** (`apply.py`) with backups and skip-if-applied. The user re-ran it three times across turns without me worrying about double-patching.

## ⚠️ Areas for Improvement

- **First wrong root cause, second wrong too.** I initially claimed `sample_rate` was a config field; the user pushed back, and only then I `grep`ped the source and found it was hardcoded. The lesson: when the first fix has zero effect, immediately grep the source instead of refining the config.
- **Missed the second bug for one round.** Even after finding `self.sample_rate = 16000`, I declared victory. The empty-transcription symptom persisted because `_transcribe_onnx_asr` accepts `sample_rate` but never passes it. Should have traced the *full* call chain (`audio_capture` → `main.py` → `whisper_manager.py` → `onnx_asr.recognize`) on the same grep pass.
- **Did not proactively set up a `pacman` hook.** The patches are in `/tmp/hyprwhspr-fix/` and `/usr/lib/`. Next `yay -Syu hyprwhspr` will wipe them. Should have offered the hook alongside the patch, not as a follow-up.
- **Long tool output dumps** (the `pw-top` invocation spewed binary escape sequences into chat). Should have piped through `col -b` or `script -qc` or just not run `pw-top` interactively.

## 🎯 Lessons Learned

- **hyprwhspr 1.32.1 has at least three upstream bugs** that combine to break a standard Arch setup:
  1. `audio_capture.py:29` — `self.sample_rate = 16000` hardcoded; aborts on 48 kHz-only devices (Scarlett via PipeWire) with `PaErrorCode -9997`.
  2. `whisper_manager.py:1288` — `_transcribe_onnx_asr(audio_data, sample_rate=16000)` accepts `sample_rate` but `model.recognize(audio_data)` doesn't pass it. onnx-asr defaults to 16 kHz; with patch #1 the audio is 48 kHz, so the model gets 3× time-stretched garbage → empty result.
  3. `main.py` lines 816/1041/1548 — three `transcribe_audio(audio_data, language_override=...)` call sites don't pass `sample_rate` at all, so the default 16000 propagates.
- **Focusrite Scarlett Solo 3rd Gen exposes**: USB ID `1235:8211`, ALSA node `pro-input-0` (stereo s32le 48 kHz), Mic1 XLR = LEFT channel, Mic2/Inst = RIGHT channel. PipeWire default device may be Aukey webcam; pin via `audio_device_name` + `audio_device_vendor_id` + `audio_device_model_id` in `~/.config/hyprwhspr/config.json`.
- **Captured-audio diagnostics recipe** that worked:
  ```bash
  timeout 6 parec --device=alsa_input.usb-...pro-input-0 \
    --format=s32le --channels=2 --rate=48000 \
    --file-format=wav /tmp/test.wav
  python3 -c "<RMS/peak/spectral analysis + voice-active frames>"
  ```
  Speech target: peak > -15 dBFS, rms > -25 dBFS, ≥20% voice-active frames, ≥50% energy in 100-4000 Hz band.
- **`onnx-asr.recognize(waveform, *, sample_rate=16000, channel=None)`** — `sample_rate` defaults to 16000 and is a keyword-only argument. Always pass it explicitly.
- **hyprwhspr `setup` rewrites `~/.config/hyprwhspr/config.json`** — it stomps `model`, `transcription_backend`, `audio_device_*` fields. Always check the config after running `setup`, and back it up first (`cp config.json config.json.bak`).

## 🚀 Advice for Future Self

- **For hyprwhspr issues, run this triage in order** instead of guessing:
  1. `systemctl --user status hyprwhspr.service` (active? recent restart?)
  2. `journalctl --user -u hyprwhspr.service -n 50` (look for `PaErrorCode`, `No transcription generated`, `[INJECT]`, `[ERROR]`)
  3. `pactl get-default-source` and `pactl list sources short | grep -iE "scarlett|focusrite"` — confirm correct mic is bound
  4. `timeout 5 parec --device=<node> ...` + RMS analysis to confirm signal level
  5. If empty transcription: check whether `_transcribe_onnx_asr` passes `sample_rate` to `model.recognize` (this is the silent bug)
- **When the user says "X used to work before update", run `git log -- /usr/lib/...` or check pacman log** for the package that bumped — that's the regression source. Don't assume the user's config is intact; `setup` rewrites it.
- **For any third-party package with `/usr/lib/...` patches, propose a `pacman` hook** at the same time as the patch. Don't leave durability as an afterthought.
- **The patcher template that worked** (`/tmp/hyprwhspr-fix/apply.py`) — supports multiple files via `apply_text_patch()`, auto-backups via `.bak`, idempotent via "already patched" check. Reuse this pattern.
- **Don't run interactive TUIs (`pw-top`, `alsamixer`) from bash tool calls** — they spew escape sequences into chat. Use `pw-cli ls Node` or query PulseAudio sources via `pactl list` instead.
