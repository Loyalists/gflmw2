#include common_scripts\utility;
#include maps\_utility;
#include maps\_specialops;
#include maps\so_escape_airport_code;
#include maps\airport_code;

/*------------------- tweakables -------------------*/

CONST_regular_obj	= &"SO_ESCAPE_AIRPORT_OBJ_REGULAR";
CONST_hardened_obj	= &"SO_ESCAPE_AIRPORT_OBJ_HARDENED";
CONST_veteran_obj	= &"SO_ESCAPE_AIRPORT_OBJ_VETERAN";

/*------------------- tweakables -------------------*/

main()
{
	level.so_compass_zoom = "close";
	level.friendlyfire_warnings = true;
	
	// Special Op mode deleting all original spawn triggers, vehicles and spawners
	//	::type_script_model_civilian
	//	::type_spawners
	//	::type_vehicle
	//	::type_spawn_trigger
	//	::type_trigger
	
	so_delete_all_by_type( ::type_spawn_trigger, ::type_vehicle, ::type_spawners, ::type_script_model_civilian );
	
	default_start( ::start_so_escape );
	add_start( "so_escape", ::start_so_escape );
	
	maps\createart\airport_art::main();
	maps\createfx\airport_audio::main();
	maps\createfx\airport_fx::main();
	maps\airport_fx::main();
	
	common_scripts\_destructible_types_anim_light_fluo_on::main();
	
	maps\_load::main();
	
	maps\airport_amb::main();
	maps\_utility::set_ambient( "airport_terminal0" );

	maps\_compass::setupMiniMap( "compass_map_airport" );

	disable_elevators();
}

disable_elevators()
{
	// Connect the top floor paths for the elevator that doesn't crash.
	elevator = level.elevators[ 0 ];
	left_door = elevator common_scripts\_elevator::get_outer_leftdoor( 1 );
	right_door = elevator common_scripts\_elevator::get_outer_rightdoor( 1 );
	left_door ConnectPaths();
	right_door ConnectPaths();
	
	// Just remove the triggers in the elevator
	housings = GetEntArray( "elevator_housing", "targetname" );

	foreach ( housing in housings )
	{
		housing disable_elevator_internal();
	}

	buttons = GetEntArray( "elevator_call", "targetname" );
	foreach ( button in buttons )
	{
		button.origin = ( 0, 0, -50000 );
	}

}

disable_elevator_internal()
{
	ent = self;
	num = 0;
	while ( 1 )
	{
		if ( !IsDefined( ent.target ) )
		{
			return;
		}

		ent = GetEnt( ent.target, "targetname" );
		switch ( num )
		{
			case 2:
			case 3:
				ent.origin = ( 0, 0, -50000 );
		}

		num++;
	}
}

start_so_escape()
{
	so_escape_airport_init();

	foreach( enemy_group, delete_num in level.enemy_remove_trigs )
		thread past_enemy_remove( enemy_group, delete_num );
	
	music_loop( "so_escape_airport_music", 148 );
	
	thread fade_challenge_in();
	thread fade_challenge_out( "escaped_terminal" );
	thread enable_triggered_start( "start_terminal" );
	thread enable_triggered_complete( "escaped_trigger", "escaped_terminal", "all" );
	thread enable_challenge_timer( "start_terminal", "escaped_terminal" );
}

#using_animtree( "generic_human" );
so_escape_airport_init()
{
	// Will create an _anim file if we get more.
	level.scr_anim[ "generic" ][ "pronehide_dive" ]					 = %hunted_dive_2_pronehide_v1;
	
	flag_init( "escaped_terminal" );
	flag_init( "start_terminal" );
	flag_init( "challenge_success" );
	
	/*dummy*/flag_init( "escaped_trigger" );

	thread shoot_out_glass();
	thread glass_elevator_setup();
	thread sign_departure_status_init();
	thread sign_departure_status_eratic();

	level.enemy_remove_trigs = [];
	
	add_global_spawn_function( "axis", ::enemy_register );

	thread spawn_smoke( "smoke_escalators_first", "enemy_waiting_area_above_movein_trig" );
	thread spawn_smoke( "smoke_escalators_ending", "enemy_security_area_final_movein_trig", 0.0 );
	thread crash_elevator();
	array_thread( GetEntArray( "glass_delete", "targetname" ), ::delete_glass );

	// enemy_move_to_struct( move trigger, seek_goalradius, stay, duration of stay before seeking )
	
	// First round of guys to the right of the entrance. Should pull player away from obvious escalator target.
	array_spawn_function_noteworthy( "enemy_waiting_area_intro", 	::enemy_move_to_struct, "enemy_waiting_area_intro", 384 );
	level.enemy_remove_trigs[ "enemy_waiting_area_intro" ] 			= 0;

	// Surround the player now that they've gone into the exposed area
	array_spawn_function_noteworthy( "enemy_waiting_area_above", 	::enemy_move_to_struct, "enemy_waiting_area_above", 384, true, randomintrange( 20, 30 ) );
	array_spawn_function_noteworthy( "enemy_waiting_area_above", 	::enemy_ignore_cover );
	level.enemy_remove_trigs[ "enemy_waiting_area_above" ] 			= 0;
	
	// Urban ghillie up into view.
	array_spawn_function_noteworthy( "enemy_dining_area_prone", 	::enemy_prone_to_stand, "enemy_dining_area_riot", 512 );
	array_spawn_function_noteworthy( "enemy_dining_area_riot", 		::enemy_move_to_struct, "enemy_dining_area_riot", 512, true, randomintrange( 10, 15 ) );
	level.enemy_remove_trigs[ "enemy_dining_area_prone" ] 			= 0;

	// Hitting hard with shield guys now
	array_spawn_function_noteworthy( "enemy_store_area_prone", 		::enemy_prone_to_stand, "enemy_store_area_start", 512 );
	array_spawn_function_noteworthy( "enemy_store_area_start", 		::enemy_move_to_struct, "enemy_store_area_start", 512, true, randomintrange( 10, 15 ) );
	level.enemy_remove_trigs[ "enemy_store_area_start" ] 			= 0;

	// Hitting hard with shield guys now
	array_spawn_function_noteworthy( "enemy_security_area_top", 	::enemy_move_to_struct, "enemy_security_area_final", 1024 );
	array_spawn_function_noteworthy( "enemy_security_area_bottom", 	::enemy_move_to_struct, "enemy_security_area_final", 1024, true, randomintrange( 30, 45 ) );
	array_spawn_function_noteworthy( "enemy_security_area_final", 	::enemy_move_to_struct, "enemy_security_area_final", 1024, true, randomintrange( 45, 135 ) );
	level.enemy_remove_trigs[ "enemy_security_area_final" ] 		= 0;

	hide_destroyed_parts();
	
	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_setup_regular();		break;	// Regular
		case 2:	so_setup_hardened();	break;	// Hardened
		case 3:	so_setup_veteran();		break;	// Veteran
	}

	thread objective_breadcrumb();
}

so_setup_regular()
{
	level.challenge_objective 	= CONST_regular_obj;
}

so_setup_hardened()
{
	level.challenge_objective 	= CONST_hardened_obj;
}

so_setup_veteran()
{
	level.challenge_objective 	= CONST_veteran_obj;
}