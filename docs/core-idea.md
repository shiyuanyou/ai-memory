Memory System – Core Concept

Problem
AI coding tools only know the current repo and short conversation context. They do not know the developer’s long-term environment, preferences, infrastructure, or existing projects. This causes repeated explanations, incorrect assumptions (e.g. editor choice, lack of servers), and redundant system design.

Goal
Create a minimal “developer memory layer” that provides persistent context across:

* projects
* AI tools
* coding sessions

The system should allow AI to treat the developer as an existing technical system with capabilities, infrastructure, and preferences.

Design Principles

1. Extremely simple
   Small script + plain text files. Avoid complex frameworks, databases, or heavy infrastructure.

2. UNIX-style design
   One responsibility: provide developer context.
   Use CLI + text interfaces so any AI or tool can call it.

3. Cross-tool compatibility
   Must work with different AI coding tools (e.g. OpenCode, other editors, agents) without integration work.

4. Low friction adoption
   Should be usable via a simple shell command or prompt injection.

Minimal Architecture

ai-memory (CLI)
→ reads developer knowledge files
→ outputs structured text context for AI

Data location:

~/.memory/
profile.md
infra.md
preferences.md
projects/ <project>.md

Core Commands

ai-memory context
return developer profile + preferences + infra + project summaries

ai-memory projects
list existing projects

ai-memory project <name>
show project description and capabilities

ai-memory search <keyword>
search developer knowledge

Purpose of Each Data Type

profile
Developer identity and technical environment.

preferences
Coding habits and constraints (e.g. editor, architecture preferences).

infra
Servers, domains, local environment, deployed services.

projects
Existing tools and capabilities that can be reused.
Projects are the single source of truth for project-specific memory.

Usage in AI Coding Workflow

Before planning solutions, AI should read developer memory:

ai-memory context

Use ai-memory project <name> when full project details are needed.

Then incorporate this information when proposing architectures or tools.

Optimization Direction

1. Capability awareness
   Automatically summarize developer capabilities based on projects so AI avoids reinventing tools.

2. Context compression
   Return concise summaries instead of raw files to reduce prompt tokens.

Data Model Rule

- `profile.md`, `preferences.md`, and `infra.md` store developer-wide facts only.
- `projects/*.md` stores all project-specific facts, status, capabilities, and roadmaps.
- `ai-memory context` is the default AI entrypoint and should aggregate both layers.

3. Cross-tool interoperability
   Provide a universal CLI interface so any AI tool can consume the same developer memory.

4. Optional tool interface
   Expose the same functionality through tool protocols (e.g. MCP) for automatic AI access.

5. Zero-dependency design
   Keep the system lightweight (<500 lines), text-based, and scriptable.

Conceptual Architecture

developer memory layer
↓
AI reasoning layer
↓
agent runtime / tools

ai-memory → who the developer is
AI → reasoning and planning
agents/tools → execution
