# Create worthy documentation

## Context

This is my dotfiles, containing all my configurations, for both my Mac and my Arch Linux setup.
However, I never really took the time to keep my @docs up to date.

We are going to correct that.
Read the ENTIRE file in full BEFORE starting any task.

## Critical

- Read the .gitignore file.
- NEVER read a file included in the .gitignore
- NEVER read a file containing `env`, `priv` or `private`
- Delegate to other Agents when relevant
  - If you delegate, ALWAYS share this "CRITICAL" section with them.

## Structure

The repository is split in 3 main folders:

- archlinux: the configurations dedicated to my linux system
- common: the configurations that are shared between both my linux and macos systems
- macOS: the configurations dedicated to my macOS system

## Step 0:

Status: Done

- [x] create a new branch `documentation`
- [x] Update the current step Status to Done

## Step 1: Arch Linux

Status: Done

- [x] Explore the code base in archlinux/
- [x] Once done exploring archlinux/
- [x] Document all your exploration from the code under @docs/archlinux
- [x] commit the work with a relevant commit message
- [x] Once done, update the current step Status to Done

## Step 2: MacOS

Status: Done

- [x] Explore the code base in macOS/
- [x] Once done exploring, tell it to read all the files in docs/
- [x] Document all your exploration from the code under @docs/macos
- [x] commit the work with a relevant commit message
- [x] Once done, update the current step Status to Done

## Step 3: common

Status: Done

- [x] Explore the code base in @common/
- [x] Once done exploring, tell it to read all the files in @docs/
- [x] Document all your exploration from the code under @docs/common: The goal is to have a humanly readable documentation of what is done in the repositiory for both my Arch Linux and my MacOS setup, and how it can be used to its fullest. You will see that some configurations are similar : that's because I use 2 keyboards: one QWERTY and one Graphite, depending on my mood.
- [x] If some parts from @docs/macos or @docs/archlinux must be updated to match, update them.

If you have questions, ask me BEFORE starting to write the documentation.
If you are duplicating existing documentation in @docs: remove the old version for the new one.

- [x] commit the work with a relevant commit message
- [x] Once done, update the current step Status to "Done"

## Step 4: Review

Status: Done

- [x] Spawn a separate and clear Agent to REVIEW all the work that has been done.
- [x] Give it the proper instructions so that it can make the best review possible.
- [x] Give it the CRITICAL section from this document
- [x] Ask it to compile a review document "./review-feedback.md" for me to review, including an improvement plan if he believes any is necessary.

