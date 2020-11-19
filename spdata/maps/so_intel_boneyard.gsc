#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.so_compass_zoom = "far";
	
	// settings for this challenge
	level.pmc_gametype = "mode_objective";
	level.pmc_enemies = 50;
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_breach_ents();
	
	maps\boneyard_precache::main();
	maps\createart\boneyard_fog::main();
	maps\createfx\boneyard_audio::main();
	maps\boneyard_fx::main();
	
	maps\_pmc::preLoad();
	maps\_load::main();

	level thread enable_escape_warning();
	level thread enable_escape_failure();

	maps\boneyard_amb::main();
	maps\_pmc::main(); // this doesn't return directly?


	maps\_compass::setupMiniMap( "compass_map_boneyard" );

	music_loop( "so_intel_boneyard_music", 190 );
}