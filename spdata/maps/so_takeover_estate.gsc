#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	level.so_compass_zoom = "far";
	
	no_prone_water = getentarray( "no_prone_water", "targetname" );
	foreach( trigger in no_prone_water )
		trigger.script_specialops = 1;
	
	// settings for this challenge
	level.pmc_gametype = "mode_elimination";
	level.pmc_enemies = 40;
	level.pmc_low_enemy_count = 5; // Used for pulsing the hud
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_breach_ents();
	
	maps\estate_precache::main();
	maps\createart\estate_art::main();
	maps\createfx\estate_audio::main();
	maps\estate_fx::main();
	maps\_pmc::preLoad();
    maps\_load::main();
    maps\_pmc::main();
    thread maps\estate_amb::main();
	thread remove_sp_elements();
	
	maps\_compass::setupMiniMap("compass_map_estate");
	
	music_loop( "so_takeover_estate_music", 124 );

	deadquotes = [];
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_CLAYMORE_POINT_ENEMY";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_CLAYMORE_ENEMIES_SHOOT";
	so_include_deadquote_array( deadquotes );
	level.so_deadquotes_chance = 0.33;
}

remove_sp_elements()
{
	getent( "fake_backwards_door", "targetname" ) delete();
	getent( "fake_backwards_door_clip", "targetname" ) delete();
	getent( "recroom_closed_doors", "targetname" ) delete();
	getent( "dsm", "targetname" ) delete();
	getent( "dsm_obj", "targetname" ) delete();
	
	array_call( getentarray( "window_newspaper", "targetname" ), ::delete );
	array_call( getentarray( "window_pane", "targetname" ), ::delete );
	array_call( getentarray( "window_brokenglass", "targetname" ), ::delete );
	array_call( getentarray( "window_blinds", "targetname" ), ::delete );
	array_call( getentarray( "paper_window_sightblocker", "targetname" ), ::delete );
	array_call( getentarray( "sp_claymore_pickups", "targetname" ), ::delete );
}