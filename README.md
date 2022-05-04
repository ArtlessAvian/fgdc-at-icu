# fgdc-at-icu
Fighting Game dedicated to my last quarter at UCI. Aiming for intentional kusoge.

Releases can be found here: https://artlessavian.itch.io/fighting-game-development-club-icu

## Dependencies
This game uses the custom SG physics build for godot made by Snopek Games. As of this writing, we are on v1.0.0-alpha8. 
We use this addon because it incorporates fixed-point deterministic physics, which is important for the rollback netcode to function properly.
Releases for the custom build can be found here: https://gitlab.com/snopek-games/sg-physics-2d/-/releases

Additionally, this project incorporates Snopek Games Rollback Networking addon for the netcode portion of this project. 
The repo for that can be found here: https://gitlab.com/snopek-games/godot-rollback-netcode/
