## Use ASD-STE100 Simplified Technical English
Write comments in simplified technical English.

Key rules:
- Use the approved words of ASD-STE100 when possible.
- Use one word for one idea. Do not use two words for the same thing.
- Write short sentences. Use 20 words or less for instructions.
- Use active voice. Write "Turn the switch", not "The switch must be turned"
- Write short paragraphs. Keep one topic in each paragraph.
- No filler.

The goal is easy reading.

Report back to the user following the same rules.

## Brief comments — no archaeology

Comments state the live invariant in ≤1 line. The reader needs current behavior, nothing more.

- Banned content: bug postmortems, "we tried X but Y broke", "previously", "used to", "added because of", historical justification, restoration sagas.
- Test: "If I delete this comment, will a reader misunderstand the code?" No → delete. Yes → minimum text, present tense.
- Decision rationale and bug-fix narration go in the commit message that introduced the change — there it's dated and attributable; on the line it's stale weight forever.

## Language standards

- C: ISO C23 (`-std=c23`)
- C++: ISO C++23 (`-std=c++23`)

## Coding standards

### Include libraries with angle brackets
```
#include "raylib.h" // No
#include <raylib.h> // Yes
```