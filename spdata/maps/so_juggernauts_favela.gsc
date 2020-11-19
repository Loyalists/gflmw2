#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.so_compass_zoom = "close";

	// settings for this challenge
	level.pmc_gametype = "mode_elimination";
	level.pmc_enemies = 10;
	level.pmc_alljuggernauts = true;
	level.pmc_enemies_alive = 1;
	level.pmc_low_enemy_count = 3; // Used for pulsing the hud
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	array_call( getentarray( "placed_weapon", "script_noteworthy" ), ::delete );
	
	level.disable_interactive_tv_use_triggers = true;
	
	array_call( getentarray( "hiding_door_part", "script_noteworthy" ), ::delete );
	array_thread( getentarray( "hiding_door_part_disconnect", "script_noteworthy" ), ::delete_hiding_door_disconnect );
	
	maps\createart\favela_fog::main();
	maps\createart\favela_art::main();
	maps\createfx\favela_audio::main();
	maps\favela_precache::main();
	maps\favela_fx::main();
	maps\_compass::setupMiniMap( "compass_map_favela" );
	maps\_pmc::preLoad();
	maps\_load::main();
	thread enable_escape_warning();
	thread enable_escape_failure();
	maps\_pmc::main();
	thread maps\favela_amb::main();
	thread scale_juggernaut_enemies();
	
	music_loop( "so_juggernauts_favela_music", 198 );

	activate_trigger( "vision_shanty", "script_noteworthy" );
}

delete_hiding_door_disconnect()
{
	self connectPaths();
	self delete();
}

scale_juggernaut_enemies()
{
	for(;;)
	{
		level waittill( "update_enemies_remaining_count" );
		
		if ( level.pmc.enemies_remaining >= 9 )
			level.pmc.max_ai_alive = 1;
		else if ( level.pmc.enemies_remaining >= 7 )
			level.pmc.max_ai_alive = 2;
		else
			level.pmc.max_ai_alive = 3;
	}
}