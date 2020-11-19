// ---------------------------------------------------------------------------------
//	Special Ops Script Structure
// ---------------------------------------------------------------------------------
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\so_bridge_code;
#include maps\_specialops;

// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	default_start( ::start_so_crossing_timed );
	add_start( "so_crossing",		::start_so_crossing_timed,	"Special Op: Crossing" );

	maps\so_bridge_fx::main();
	maps\so_crossing_so_bridge_fx::main();
	maps\createart\so_bridge_art::main();
	maps\so_bridge_anim::main();
	maps\so_bridge_precache::main();
	
	maps\_attack_heli::preLoad();

	maps\_load::main();

	maps\_compass::setupMiniMap("compass_map_so_bridge");

	thread maps\so_bridge_amb::main();
}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------
start_so_crossing_timed()
{
	flag_init( "so_obj_crossing_start" );
	flag_init( "so_obj_crossing_complete" );

	level.challenge_objective = &"SO_CROSSING_SO_BRIDGE_OBJECTIVE";

	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_crossing_timed_setup_regular();	break;	// Regular
		case 2:	so_crossing_timed_setup_hardened();	break;	// Hardened
		case 3:	so_crossing_timed_setup_veteran();	break;	// Veteran
	}

	thread music_loop( "so_crossing_so_bridge_music", 256 );

	thread enable_escape_warning();
	thread enable_escape_failure();
	
	objective_marker = getent( "so_obj_crossing", "targetname" );
	objective_add( 1, "current", level.challenge_objective, objective_marker.origin );

	enable_uav_resources();
	enable_ambient_uavs();
	
	enable_rappel_bridge();
	enable_rappel_bridge_seek();

	thread enable_bridge_collapse();
	enable_missile_attack_taxi();

	enable_troop_flood();
	enable_attack_heli();
	
	enable_rappel_heli_close();
	enable_rappel_heli_far();

	thread fade_challenge_in();
	thread fade_challenge_out( "so_obj_crossing_complete" );
	thread enable_triggered_start( "so_obj_crossing_start" );
	thread enable_triggered_complete( "so_obj_crossing", "so_obj_crossing_complete", "all" );
	thread enable_challenge_timer( "so_obj_crossing_start", "so_obj_crossing_complete" );
}

so_crossing_timed_setup_regular()
{
//	level.challenge_objective = &"SO_CROSSING_SO_BRIDGE_OBJ_REGULAR";

	enemies = getentarray( "upper_level_enemies", "script_noteworthy" );
	remove_enemies_with_weapons( "actor_enemy_airborne_RPG", enemies );
	remove_enemies_with_weapons( "actor_enemy_airborne_SHOTGUNAUTO", enemies );
	remove_enemies_with_weapons( "actor_enemy_airborne_AR", enemies, 6 );
}

so_crossing_timed_setup_hardened()
{
//	level.challenge_objective = &"SO_CROSSING_SO_BRIDGE_OBJ_HARDENED";

	enemies = getentarray( "upper_level_enemies", "script_noteworthy" );
	remove_enemies_with_weapons( "actor_enemy_airborne_RPG", enemies );
	remove_enemies_with_weapons( "actor_enemy_airborne_AR", enemies, 3 );
}

so_crossing_timed_setup_veteran()
{
//	level.challenge_objective = &"SO_CROSSING_SO_BRIDGE_OBJ_VETERAN";
}

remove_enemies_with_weapons( class, enemies, remove_count )
{
	// Assume we want to remove them all if undefined.
	if ( !isdefined( remove_count ) )
		remove_count = 999;
		
	foreach( guy in enemies )
	{
		if ( ( remove_count > 0 ) && ( guy.classname == class ) )
		{
			guy.count = 0;
			remove_count--;
		}
	}
}

// ---------------------------------------------------------------------------------
//	Enable/Disable events
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------
enable_uav_resources()
{
	array_thread( getvehiclenodearray( "uav_sound", "script_noteworthy" ), maps\_ucav::plane_sound_node );
	array_thread( getvehiclenodearray( "fire_missile", "script_noteworthy" ), maps\_ucav::fire_missile_node );
}

enable_ambient_uavs()
{
	flag_set( "so_ambient_uavs" );

	thread delayThread( 2, ::spawn_vehicle_from_targetname_and_drive, "ucav_flyover_01" );
	thread delayThread( 8, ::spawn_vehicle_from_targetname_and_drive, "ucav_flyover_02" );
	thread delayThread( 20, ::spawn_vehicle_from_targetname_and_drive, "ucav_flyover_03" );
}

// ---------------------------------------------------------------------------------
enable_rappel_bridge()
{
	flag_set( "so_rappel_bridge" );
	array_spawn_function_noteworthy( "rappel_bridge" , ::ai_rappel_think );
}

// ---------------------------------------------------------------------------------
enable_rappel_bridge_seek()
{
	flag_set( "so_rappel_bridge_seek" );
	array_spawn_function_noteworthy( "rappel_bridge_seek" , ::ai_rappel_think, true );
}

// ---------------------------------------------------------------------------------
// Must be a thread due to the waittill
enable_bridge_collapse()
{
	flag_set( "so_bridge_collapse" );

	precacheModel( "vehicle_coupe_gold" );

	thread collapsed_section_shakes();
	thread bridge_collapse_prep();

	trigger = GetEnt( "bridge_collapse", "targetname" );

	if ( GetDvar( "test_bridge_collapse" ) == "1" )
	{	
		trigger thread notify_delay( "trigger", 10 );
	}

	trigger waittill( "trigger" );

	// Reduce speed until collapse is done, view_tilt resets this
	foreach ( player in level.players )
	{
		player AllowSprint( false );
		player blend_movespeedscale( 0.7, 2 );
	}

	dmg_trigger = GetEnt( "so_bridge_damage_trigger", "targetname" );

	count = 0;
	while ( 1 )
	{
		dmg_trigger waittill( "trigger", other );

		if ( other.code_classname == "script_vehicle" )
		{
			count++;

			if ( count == 1 )
			{
				thread bridge_collapse_earthquake();
				exploder( 2 );
			}

			if ( count == 2 )
			{
				level notify( "bridge_collapse" );
				return;
			}
		}
	}
}

// ---------------------------------------------------------------------------------
enable_missile_attack_taxi()
{
	flag_set( "so_missile_attack_taxi" );
	thread missile_taxi_moves();
}

// ---------------------------------------------------------------------------------
enable_attack_heli()
{
	flag_set( "so_attack_heli" );
	thread attack_heli();
}

// ---------------------------------------------------------------------------------
enable_troop_flood()
{
	flag_set( "so_flood_spawner" );
}

// ---------------------------------------------------------------------------------
enable_rappel_heli_close()
{
	flag_set( "so_rappel_heli_close" );
}

// ---------------------------------------------------------------------------------
enable_rappel_heli_far()
{
	flag_set( "so_rappel_heli_far" );
}