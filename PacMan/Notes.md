Pac-Man
=======

Development started: 2020-05-08
First version complete: 2020-05-11


## The Ghosts' AI

Of course no Pac-Man program discussion is complete without a mention of the
ghosts' AI, or the sorry excuse for it that a BASIC program allows.

First, it should be said that the ghosts' movement in a Pac-Man game is
traditionally constrained by two principles:

- A ghost must keep moving at all times
- A ghost cannot change direction by 180 degrees unless there is no other
  choice.

What this implies in practice is that a ghost will only change direction at
T-junctions or intersections (ideally towards the player). At all other times,
the ghost can only follow whatever tunnel it is in until it reaches the next
branch.

Thus, the AI simply has to answer the question, "the ghost is at a junction
now; which of the 2 or 3 choices of direction are better for heading towards
the player?".

BASIC is far too slow to make a breadth-first search for Pac-Man whenever a
ghost meets a junction (not sure even machine code would cut it). We could do
a Floyd-Warshall to build a lookup table of the optimal direction for all
possible (ghost_x, ghost_y, pac_x, pac_y) combinations; but this will not fit
in memory without using several tricks that ultimately slow down the array
access far too much for it to be worth it.

In the end I went with a trivial algorithm that just chooses whichever
direction results in a smaller Manhattan distance vs the player, and this
works well enough. Note that the architecture of the maze seems specifically
designed to help ghosts with poor AIs appear intelligent enough.


## Optimizations

I had a lot of trouble getting this to run fast enough. Even with the trivial
algorithm, it is still impossible to animate four ghosts at every turn. In the
end I reduced the ghosts to three and made it so that the ghosts move in
rotation, one per turn.

Since this effectively makes the ghosts only 1/3 as fast as Pac-Man, I decided
to compensate by allowing ghosts to move 2 squares per turn as long as the way
is clear. Specifically, they can do this only if a) there are no obstacles in
the way and b) doing this would not cause them to jump over an intersection and
thus miss an opportunity for steering towards the player.

This seems to work pretty well in practice, actually. The game is just barely
fast enough to be playable, and the ghosts offer a reasonable challenge.

Other optimizations and tricks used:

- BASIC does not have short-circuit boolean evaluation, which would help a lot
  given how even trivial checks take up a perceptible amount of time. I
  simulate it by constructs like:
  
      IF (quick_test) THEN: IF (more_expensive_test) THEN: IF (even_more_expensive) ...
  
  and this seems to work very well. Skipping the rest of the line if any
  condition fails seems to be reasonably fast in BASIC.

- I use `ATTR` and intelligent color selection to test for the existence of
  walls, ghosts or the player at a given location. This is because `ATTR` tests
  are MUCH faster than array lookups (they ultimately are just a fancier `PEEK`
  call).
