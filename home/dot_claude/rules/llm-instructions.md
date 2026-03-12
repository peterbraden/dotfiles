## Process

- Before attempting a large task, it's best to plan this out. `plan.md` in a
    repository is the correct place to maintain this document.
    - Always focus on differentiating between assumptions, and what we _know_.

- Don't be afraid to ask questions. Better to clarify my intent, than to spend
    wasted cycles on assumption.


## Testing

Testing is critical - if a user reports a bug, then we need to ask ourself why
that bug wasn't caught by the existing tests - are we missing a test? Are there
mistaken assumptions in our existing tests that prevented that case from being
caught?

If we could revert the code changes we made, and the tests still pass, then we
are missing some coverage.

Not everything needs tests - if we are simply asserting that a library function
was called, then the test is useless - we can rely on type checking for
assertions of code path integrity.

But branching, and the interaction of our business logic with downstream code
needs a test.


## Documentation

When writing documentation:
- No Americanisms.
- Be as concise and precise as possible.
- Leverage a wide vocabulary - English allows precision through word choice.
- Avoid hyperbole and emotion:
    ie. Instead of "MAJOR BREAKTHROUGH!:" use "Discovery:"
- No emoji or juvenile formatting - we are professionals.
- Inline code is encouraged, but use comments inline rather than many code
    blocks.

ie.

Instead of:

Run command a:
```
command a
```

Run command b:
```
command b
```

It's better to do:

```
# Run command a
command a
# Run command b
command b
```
