Fun in BASIC
============

This is a collection of BASIC (usually Sinclair Basic) programs I made from
time to time to relax with some light coding and indulge my nostalgia in the
process. It is also a fun exercise in working with the immense limitations of
dubiously designed BASIC variants for machines from nearly 40 years ago (see
the sections below for details).


## Running

Most programs are for the Sinclair ZX Spectrum and its Sinclair BASIC variant,
and are provided as `tap` files that can be loaded in any Spectrum emulator. A
good one that runs direcly in the browser: https://torinak.com/qaop - click on
the sides of the screen for a menu.

The programs are also provided in text form as `bas` files. Note that in order
to convert these to and from a `z80`, `sna`, `tap` etc. format accepted by
emulators, you need a special utility such as Paul Dunn's BASin. A version of
it can be found here: https://arda.kisafilm.org/blog/?page_id=848&lang=en .


## Purity Principles

As part of the nostalgia/challenge theme, while writing these I adhered to a
set of guidelines (these apply to Sinclair BASIC unless otherwise noted):

- The program must be pure BASIC. No use of machine code subroutines (not even
  those in the ROM).

- No use of `PEEK` and `POKE`, except for:
  - Setting up UDGs
  - Manipulating the keyboard-related sysvars such as `LASTK`, `REPPER` and
    `REPDEL`, if this significantly improves the game's playability.

- Programs should be made for the 48K Spectrum unless there is some 128K
  feature I really need (`PLAY`, ramdisk etc)


## Challenges

Writing action games for Sinclair BASIC is quite an interesting challenge. The
machine itself is fast enough when programmed in machine code (as proven by the
vast library of games for it), but the added overhead of the interpreter, and
especially the impact of several design decisions, slows down things massively.
Even the simultaneous animation of more than 2 or 3 independent figures is quite
difficult.

One of the most, if not the most, impactful design limitation of Sinclair BASIC
is the way variable access is implemented. Whenever the interpreter encounters
a variable reference, it will look up the variable by name in a linear list of
all current variables with their values. An O(N) search. Every. Single. Time.
Compare this to a machine code program that knows exactly where each of its
"variables" is located and can access it instantly. On the 4MHz Z80 CPU (which
is effectively 1MHz since each instruction uses at least 4 cycles), the linear
search takes up a perceptible amount of time given how often it needs to be
executed, and thus you will find yourself needing to resort to all sorts of
tricks that would be inconceivable in a modern program: placing your most often
used variables first, using short variable names, reusing variables as much as
possible, avoiding temporary assignments etc. All to avoid slowing down the
action so much so that the game becomes unplayable.

A similar design limitation refers to how the lines of BASIC code are stored
and accessed. Whenever the program flow is disrupted by issuing a `GO TO` or
`GO SUB` or `RETURN`, the interpreter will do a linear search for the line
(heh) where program execution is to be continued. This means that a `GO TO`
gets slower (and perceptibly so, in a tight loop) with every line that exists
before the destination. Thus, a fast program needs to be organized such that
its main loop occurs as early as possible. `GO TO`s, both forward and back,
must be avoided as much as possible (use `IF`s instead), and certainly don't
call any subroutines in any tight loops.

Memory is also relatively scarce (only about 15K of data in practice) and not
very efficiently used (any numeric value uses at least 5 bytes). For action
games, this means you can't use very large look-up tables, not that you could
overuse them anyway, since array access and initialization is itself pretty
slow.
