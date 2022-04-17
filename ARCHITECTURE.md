## Networking

FGDC at ICU uses rollback netcode as provided through the Snopek Godot Rollback Addon. This lets us not worry about implenting networking, and only focus on making sure the game is determinsitic so that it can work with rollback.

We do that by making the physics fixed point, since floats are non deterministic. If this all sounds like nonsense, read this article for more information. Thankfully, the custom build of Godot we are using has 2D fixed point physics built in. Hopefully when Godot 4 comes out, we can use a GDExtension for custom physics instead, since having a custom build is some added complexity to setting up the developmental space.

## Fighters

TODO: Explain the state machine, and how a default fighter works/how to implement a new fighter

## Frame Data

TODO: Explain the custom data types and resources used to implement attacks.

## Game

TODO: Explain the core game systems and how they all interact and programmed.

## Stages

TODO: Explain the basics of how stages work, and how the 2D camera system is set up.