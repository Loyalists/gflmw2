#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

main()
{
	maps\so_bridge_fx::main();
	maps\createart\so_bridge_art::main();
	maps\so_bridge_anim::main();
	maps\so_bridge_precache::main();
	
	maps\_attack_heli::preLoad();

	maps\_load::main();

	thread maps\so_bridge_amb::main();
}
