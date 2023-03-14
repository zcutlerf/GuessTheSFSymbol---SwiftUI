#  Guess the SF Symbol (SFGuess)
## This is the repository for a game where designers and developers can compete to guess the names of SF Symbols as fast as possible.

Some of these symbol names are easy, and some are hard. Some examples:
* tortoise
* info.square
* heart.circle.fill
* rectangle.and.arrow.up.right.and.arrow.down.left.slash

But they often follow a pattern that can be learned and guessed!

**This game has multiple modes.**

### Single Player Mode
* Player guesses the names of SF Symbols as fast as possible, racing against the clock.
* Leaderboards are available for each competition category.

### Multi Player Mode
* 2-4 players compete to guess symbols faster than their opponents.
* Players can automatch or invite Game Center friends.

### Technologies Used
* **SwiftUI**, using **MVVM** with a **Service** layer
* Some fun Swift stuff
 * Modern concurrency with **async / await**
 * A **singleton**, even though I know they are controversial 🫢
 * Custom **protocols** to organize my growing ViewModels
 * Unit Tests! So fun...
* **GameKit** (Game Center)
 * **Leaderboards** for Single Player mode
 * Multi Player mode is a real-time **GKMatch**
* And I'm always thinking about accessibility!
 * Dark mode
 * Text resizes to fit user's preference
 * Colors with high-contrast available
