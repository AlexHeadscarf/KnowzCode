# Changelog

All notable changes to KnowzCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.6] - 2025-12-29

### Changed
- All 32 agents now use `model: opus` instead of `model: sonnet`
- Opus 4.5 offers better quality (80.9% vs 77.2% on SWE-bench)
- With prompt caching, Opus 4.5 is cost-comparable or cheaper than Sonnet (90% cache read savings)

### Notes
- This change affects all agents in both `.claude/agents/` and `agents/` directories
- No breaking changes - agents work identically, just with higher quality model

---

## [2.0.5] - 2025-01-XX

### Added
- Automatic `.gitignore` creation in `knowzcode/` directory for environment protection
- Interactive user preferences capture during `/kc:init` with optional configuration
- Enhanced test verification guidance in implementation-lead agent with:
  - Test infrastructure requirements checking
  - Integration test patterns and examples
  - E2E test patterns with Playwright examples
  - Task breakdown guidance for verification loops
- Test framework detection in environment_context.md template
- User preferences integration in environment_context.md template
- `knowzcode/user_preferences.md` template for capturing development preferences
- Helpful error messages when test infrastructure is missing (e.g., Playwright)

### Changed
- Init command now includes interactive prompt for user preferences (optional, can skip)
- Init command creates `.gitignore` automatically to prevent accidental env commits
- Environment context template includes test framework detection in discovery sequence
- Success message updated to reflect new files created during initialization

### Fixed
- None

### For Existing Projects
Run `/kc:init` and choose "Merge" option to add new features without affecting existing files.
This will:
- Add `knowzcode/.gitignore` (if missing)
- Prompt for user preferences (optional)
- Update to latest templates

### Breaking Changes
None - all changes are additive and backward compatible.

### Notes
- Version detection system and proactive upgrade prompts planned for v2.1.0
- Template files in existing projects won't auto-upgrade; use merge mode to opt-in
- Agents gracefully handle missing new features for backward compatibility

---

## [2.0.4] - 2024-12-XX

### Fixed
- Added explicit commands/agents arrays to marketplace.json for proper registration

---

## [2.0.3] - 2024-12-XX

### Fixed
- Changed plugin name from 'knowzcode' to 'kc' for namespace to work correctly

---

## [2.0.2] - 2024-12-XX

### Changed
- Renamed command namespace from `/knowzcode:*` to `/kc:*` for better UX
- All 27 files updated with 221 occurrences
- Commands now use shorter format: `/kc:work`, `/kc:init`, `/kc:step`, etc.

---

## [2.0.1] - 2024-12-XX

### Fixed
- Enforced orchestration and verification loops in workflow

---

## [2.0.0] - 2024-12-XX

### Added
- Initial release as Claude Code marketplace plugin
- Hybrid plugin architecture with global commands/agents
- Visible `knowzcode/` project directory structure
- All core workflow commands: work, init, step, audit, plan, fix, resolve-conflicts
- Multi-agent orchestration system
- TDD-enforced implementation workflow
- Quality gates and verification loops
- Living documentation system
- MCP server integration support

---

[2.0.6]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.5...v2.0.6
[2.0.5]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.4...v2.0.5
[2.0.4]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.3...v2.0.4
[2.0.3]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/AlexHeadscarf/KnowzCode/releases/tag/v2.0.0
