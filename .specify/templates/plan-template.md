# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Godot 4.6 (GDScript)]

**Primary Dependencies**: [e.g., Godot Engine]

**Storage**: [if applicable, e.g., ConfigFile (.cfg), JSON, Resources (.tres)]

**Testing**: [e.g., GUT, Manual Verification Scripts]

**Target Platform**: [e.g., Desktop (Windows/macOS/Linux), Web (HTML5), Mobile (Android/iOS)]

**Project Type**: [e.g., Godot Game / Tool]

**Performance Goals**: [domain-specific, e.g., Stable 60 FPS, <100MB RAM]

**Constraints**: [domain-specific, e.g., 10x10 Grid limitation, drag-and-drop input]

**Scale/Scope**: [domain-specific, e.g., Single-player, Infinite loop]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
scenes/
├── main/
├── ui/
└── game_objects/

scripts/
├── autoload/
├── ui/
└── logic/

resources/
├── blocks/
├── themes/
└── data/

tests/
├── unit/
├── integration/
└── functional/
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
