#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\so_bridge_code;
#include maps\so_demo_so_bridge_code;
#include maps\_specialops;

// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	default_start( ::start_so_demoman );
	add_start( "so_demoman", ::start_so_demoman, "Demolition Man" );

	precachestring( &"SO_DEMO_SO_BRIDGE_VEHICLES" );
	precachestring( &"SO_DEMO_SO_BRIDGE_WRECKAGE_IN" );
	precachestring( &"SO_DEMO_SO_BRIDGE_WRECKAGE_ACTIVE" );
	precachestring( &"SO_DEMO_SO_BRIDGE_INFINITE_AMMO" );
	precachestring( &"SO_DEMO_SO_BRIDGE_INFINITE_AMMO_AMOUNT" );
	precachestring( &"SO_DEMO_SO_BRIDGE_OBJ_REGULAR" );
	precachestring( &"SO_DEMO_SO_BRIDGE_OBJ_HARDENED" );
	precachestring( &"SO_DEMO_SO_BRIDGE_OBJ_VETERAN" );
	precachestring( &"SO_DEMO_SO_BRIDGE_STAT_OTHER" );
	precachestring( &"SO_DEMO_SO_BRIDGE_STAT_PARTNER" );
	precachestring( &"SO_DEMO_SO_BRIDGE_STAT_YOU" );
	
	PreCacheShader( "waypoint_targetneutral" );

	maps\so_bridge_fx::main();
	maps\createart\so_bridge_art::main();
	maps\so_bridge_anim::main();
	maps\so_bridge_precache::main();
	
	maps\_attack_heli::preLoad();
	maps\_load::main();

	common_scripts\_sentry::main();

	maps\_compass::setupMiniMap("compass_map_so_bridge");

	thread maps\so_bridge_amb::main();
}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------
start_so_demoman()
{
	so_demoman_init();

	thread music_loop( "so_demo_so_bridge_music", 344 );

	thread enable_escape_warning();
	thread enable_escape_failure();
	
	thread enable_challenge_timer( "so_demoman_start", "so_demoman_complete" );

	thread fade_challenge_in();
	thread fade_challenge_out( "so_demoman_complete" );

	array_thread( level.players, ::hud_display_cars_remaining );
	array_thread( level.players, ::hud_display_wreckage_count );
	array_thread( level.players, ::hud_display_cars_hint );
		
	enable_uav_resources();
	enable_ambient_uavs();
	
	thread track_infinite_ammo_time();
	thread enable_bridge_collapse();
	enable_missile_attack_taxi();

	enable_rappel_bridge();
	enable_rappel_bridge_seek();

	enable_troop_flood();
	enable_attack_heli();
	
	enable_rappel_heli_close();
	enable_rappel_heli_far();
}

so_demoman_init()
{
	level.custom_eog_no_partner = true;
	level.eog_summary_callback = ::custom_eog_summary;
	
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_demoman_setup_regular();		break;	// Regular
		case 2:	so_demoman_setup_hardened();	break;	// Hardened
		case 3:	so_demoman_setup_veteran();		break;	// Veteran
	}

	enemy_list = getentarray( "player_seek_stages", "script_noteworthy" );
	enemy_list = array_merge( enemy_list, getentarray( "upper_level_enemies", "script_noteworthy" ) );
	enemy_list = array_merge( enemy_list, getentarray( "rappel_bridge_seek", "script_noteworthy" ) );
	enemy_list = array_merge( enemy_list, getentarray( "rappel_bridge", "script_noteworthy" ) );
	enemy_list = array_add( enemy_list, getent( "kill_heli", "targetname" ) );
	array_thread( enemy_list, ::add_spawn_function, ::register_bridge_enemy );
	
	level.vehicle_list = getentarray( "vehicle_undestroyed", "script_noteworthy" );
	level.vehicle_list = array_add( level.vehicle_list, vehicle_get_slide_car( "missile_taxi" ) );
	level.vehicle_list = array_add( level.vehicle_list, vehicle_get_slide_car( "slide_car_1" ) );
	level.vehicle_list = array_add( level.vehicle_list, vehicle_get_slide_car( "slide_car_3" ) );
	level.vehicle_list = array_add( level.vehicle_list, vehicle_get_slide_car( "slide_car_4" ) );
	foreach ( vehicle in level.vehicle_list )
	{
		if ( vehicle.classname != "script_model" )
			level.vehicle_list = array_remove( level.vehicle_list, vehicle );
	}
	array_thread( level.vehicle_list, ::vehicle_alive_think );

	level.bonus_time_amount = 30;
	level.bonus_count_goal = 5;
	level.vehicle_damage = 0;
	
	level.default_sprint = getdvar( "player_sprintSpeedScale" );
	level.player_sprint_scale = 2;
	setSavedDvar( "player_sprintUnlimited", "1" );
	setSavedDvar( "player_sprintSpeedScale", level.player_sprint_scale );

	foreach ( player in level.players )
	{
		player.vehicle_damage = 0;
		player thread player_wait_for_fire();
	}

	deadquotes = [];
	deadquotes[ deadquotes.size ] = "@SO_DEMO_SO_BRIDGE_DEADQUOTE_HINT1";
	deadquotes[ deadquotes.size ] = "@SO_DEMO_SO_BRIDGE_DEADQUOTE_HINT2";
	deadquotes[ deadquotes.size ] = "@SO_DEMO_SO_BRIDGE_DEADQUOTE_HINT3";
	deadquotes[ deadquotes.size ] = "@SO_DEMO_SO_BRIDGE_DEADQUOTE_HINT4";
	deadquotes[ deadquotes.size ] = "@SO_DEMO_SO_BRIDGE_DEADQUOTE_HINT5";
	so_include_deadquote_array( deadquotes );
}

so_demoman_setup_regular()
{
	objective_add( 1, "current", &"SO_DEMO_SO_BRIDGE_OBJ_REGULAR" );
}

so_demoman_setup_hardened()
{
	objective_add( 1, "current", &"SO_DEMO_SO_BRIDGE_OBJ_HARDENED" );
}

so_demoman_setup_veteran()
{
	objective_add( 1, "current", &"SO_DEMO_SO_BRIDGE_OBJ_VETERAN" );
}

// ---------------------------------------------------------------------------------
//	Enable/Disable events
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------

custom_eog_summary()
{
	// Give the players some slight fudge at the start of the map. Planting C4 on the cars before the timer starts
	// still winds up with about half a second of "normal" time before IA is engaged making it impossible to get 100%.
	level.normal_time = max( level.normal_time - 1.0, 0.0 );
	total_time = level.normal_time + level.infinite_time;
	
	infinite_percent = 0;
	if ( total_time > 0 )
		infinite_percent = int( ( level.infinite_time / total_time ) * 100 );
	foreach ( player in level.players )
		player add_custom_eog_summary_line( "@SO_DEMO_SO_BRIDGE_INFINITE_AMMO_PERCENT",	infinite_percent + "%" );
	
	if ( !is_coop() )
		return;
			
	total_damage = 0;
	foreach ( player in level.players )
		total_damage += player.vehicle_damage;

	p1_percent = 0;
	p2_percent = 0;
	if ( total_damage > 0 )
	{
		p1_percent = int( ( level.player.vehicle_damage / total_damage ) * 100 );
		p2_percent = int( ( level.player2.vehicle_damage / total_damage ) * 100 );

		// If we don't get 100% total, go ahead and give the person with the lower percent a tiny moral boost.
		if ( p1_percent + p2_percent < 100 )
		{
			if ( p1_percent < p2_percent )
				p1_percent++;
			else
				p2_percent++;
		}
	}
	
	level.player add_custom_eog_summary_line( "@SO_DEMO_SO_BRIDGE_STAT_YOU",	p1_percent + "%" );
	level.player2 add_custom_eog_summary_line( "@SO_DEMO_SO_BRIDGE_STAT_YOU",	p2_percent + "%" );

	if ( is_coop_online() )
	{
		level.player2 add_custom_eog_summary_line( "@SO_DEMO_SO_BRIDGE_STAT_PARTNER",	p1_percent + "%" );
		level.player add_custom_eog_summary_line( "@SO_DEMO_SO_BRIDGE_STAT_PARTNER",	p2_percent + "%" );
	}
}

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

// ---------------------------------------------------------------------------------