# WorkGroup State Files

Each active WorkGroupID maintains a dedicated todo log in this directory. Commands and subagents update these files so task state persists across sessions.

- File name: `<WorkGroupID>.md`
- Format: Markdown list where each line starts with `KnowzCode: `
- Purpose: Prevent the active Change Set todos from getting lost during research or context switches.
