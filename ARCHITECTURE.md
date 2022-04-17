## Networking

FGDC at ICU uses rollback netcode as provided through the Snopek Godot Rollback Addon. This lets us not worry about implenting networking, and only focus on making sure the game is determinsitic so that it can work with rollback.

We do that by making the physics fixed point, since floats are non deterministic. If this all sounds like nonsense, read this article for more information. Thankfully, the custom build of Godot we are using has 2D fixed point physics built in. Hopefully when Godot 4 comes out, we can use a GDExtension for custom physics instead, since having a custom build is some added complexity to setting up the developmental space.

## Fighters

TODO: Explain the state machine, and how a default fighter works/how to implement a new fighter

To make a new fighter:
We have a base scene for the default Fighter (Fighter.tscn), that we can duplicate to make another one
There are a couple of important data attacted to it that we have to change.

For the animation player, you will probably have to delete and recreate it to have the correct animations.

### the fighter moveset
This is a Godot resource (.tres file). (For more information, https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html)We do this by creating by making a default Godot resource file, and then set the script variable as Moveset.gd
The resulting moveset resource has all the moves as resources as well, which you have to set.
To make a move resource, you create a new default Godot resource, and set the script variable to the move state you want.
(later on, you wont need to do this, and you can just create a new MovesetResource/MoveResource)

## Frame Data

TODO: Explain the custom data types and resources used to implement attacks.

## Game

TODO: Explain the core game systems and how they all interact and programmed.

## Stages

TODO: Explain the basics of how stages work, and how the 2D camera system is set up.