---
name: tdd
description: Test-driven development. Use when implementing any feature or bugfix, before writing implementation code; also when the user mentions "red-green-refactor" or test-first.
---

# Test-Driven Development

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write the test, **watch it fail**, then write minimal code to pass. If you didn't watch the test fail, you don't know it tests the right thing. Wrote code before the test? Delete it and start over — don't keep it as "reference", don't "adapt" it while writing tests. Thinking "skip TDD just this once" is rationalization.

Exceptions (confirm with the user first): throwaway prototypes, generated code, configuration files.

## What to test

**Test behavior through public interfaces, not implementation details.** Code can change entirely; tests shouldn't.

- Good tests exercise real code paths through public APIs and read like a specification: "user can checkout with valid cart".
- Bad tests mock internal collaborators, test private methods, or verify through side channels (querying the DB directly instead of using the interface).
- The warning sign: your test breaks when you refactor but behavior hasn't changed. That test was testing implementation.

See [tests.md](tests.md) for examples, [mocking.md](mocking.md) for mocking rules, and [testing-anti-patterns.md](testing-anti-patterns.md) for the full rogues' gallery.

## Anti-pattern: horizontal slicing

**DO NOT write all tests first, then all implementation.** Tests written in bulk test *imagined* behavior — they end up asserting the shape of data structures instead of user-facing behavior, pass when behavior breaks, and fail when it's fine.

```
WRONG (horizontal):           RIGHT (vertical, tracer bullets):
  RED:   test1..test5           RED→GREEN: test1→impl1
  GREEN: impl1..impl5           RED→GREEN: test2→impl2
                                RED→GREEN: test3→impl3 ...
```

One test → minimal implementation → repeat. Each test responds to what the previous cycle taught you.

## The loop

1. **Plan** — read `CONTEXT.md` (if present) so test names match the domain language; respect ADRs in `docs/adr/`. List the behaviors to test (not implementation steps) and confirm the priorities with the user or the task's acceptance criteria. You can't test everything — cover critical paths and complex logic, not every conceivable edge.
2. **RED** — write ONE minimal test for the next behavior. Run it. Verify it fails *for the right reason* (a wrong failure means the test is broken).
3. **GREEN** — write the minimal code to pass. No speculative features, no anticipating future tests. Run it; all tests green.
4. **REFACTOR** — only while green: extract duplication, deepen modules, apply what the new code reveals about existing code (see [refactoring.md](refactoring.md)). Re-run tests after each step. **Never refactor while RED.**
5. Repeat from 2 for the next behavior.

## Checklist per cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses the public interface only
[ ] Test would survive an internal refactor
[ ] I watched it fail, and it failed for the right reason
[ ] Code is minimal for this test; nothing speculative
```
