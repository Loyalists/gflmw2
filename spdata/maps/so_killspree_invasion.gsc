#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\so_killspree_invasion_code;

// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	maps\invasion_precache::main();
	maps\invasion_fx::main();
	maps\createart\invasion_art::main();
	
	precacheItem( "smoke_grenade_american" );
	precacheItem( "remote_missile_not_player_invasion" );
	precacheModel( "weapon_stinger_obj" );
	precacheModel( "weapon_uav_control_unit_obj" );
	precacheItem( "flash_grenade" );
	
	precacheItem( "zippy_rockets" );
	precacheItem( "stinger_speedy" );

	precachestring( &"SO_KILLSPREE_INVASION_OBJ_REGULAR" );
	precachestring( &"SO_KILLSPREE_INVASION_OBJ_HARDENED" );
	precachestring( &"SO_KILLSPREE_INVASION_OBJ_VETERAN" );
	precachestring( &"SO_KILLSPREE_INVASION_SCORE_ASSIST" );
	precachestring( &"SO_KILLSPREE_INVASION_SCORE_KILL" );
	precachestring( &"SO_KILLSPREE_INVASION_SCORE_BTR80" );
	precachestring( &"SO_KILLSPREE_INVASION_SPLASH_COMBO" );
	precachestring( &"SO_KILLSPREE_INVASION_SPLASH_BONUS" );
	precachestring( &"SO_KILLSPREE_INVASION_HUD_REMAINING" );
	precachestring( &"SO_KILLSPREE_INVASION_SCORE_BRUTAL" );
	precachestring( &"SO_KILLSPREE_INVASION_SCORE_DOWNED" );
	precachestring( &"SO_KILLSPREE_INVASION_SCORE_FINISHED" );
	precachestring( &"SO_KILLSPREE_INVASION_DEADQUOTE_HINT1" );
	precachestring( &"SO_KILLSPREE_INVASION_DEADQUOTE_HINT2" );
	precachestring( &"SO_KILLSPREE_INVASION_DEADQUOTE_HINT3" );
	precachestring( &"SO_KILLSPREE_INVASION_DEADQUOTE_HINT4" );
	precachestring( &"SO_KILLSPREE_INVASION_DEADQUOTE_HINT5" );
	precachestring( &"SO_KILLSPREE_INVASION_EOG_SOLID" );
	precachestring( &"SO_KILLSPREE_INVASION_EOG_HEARTLESS" );
	precachestring( &"SO_KILLSPREE_INVASION_EOG_COMBOS" );
	precachestring( &"SO_KILLSPREE_INVASION_EOG_SCORE" );
	precachestring( &"SO_KILLSPREE_INVASION_EOG_COMBOS_X" );
	
	add_start( "so_killspree", ::start_so_killspree );
	
	maps\_load::main();

	thread maps\invasion_amb::main();
	maps\invasion_anim::main_anim();

	maps\_compass::setupMiniMap( "compass_map_invasion" );
}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------
start_so_killspree()
{
	so_killspree_init();
	
	thread music_loop( "so_killspree_invasion_music", 124 );
	thread enable_nates_exploders();
	thread fade_challenge_in();
	thread fade_challenge_out( "challenge_success" );
	thread enable_challenge_timer( "challenge_start", "challenge_success" );
	thread enable_kill_counter_hud();
	flag_wait( "challenge_start" );

	thread enable_hunter_enemy_group_gas_station( 10 );
	thread enable_btr80_circling_street();
	thread enable_btr80_circling_parking_lot();
	thread enable_hunter_truck_enemies_bank(); 
	thread enable_hunter_enemy_refill( 10, 4, 8 );
}

so_killspree_init()
{
	flag_init( "challenge_start" );
	flag_init( "challenge_success" );

	so_killspree_setup_radio_dialog();
	
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_killspree_setup_Regular();	break;	// Regular
		case 2:	so_killspree_setup_hardened();	break;	// Hardened
		case 3:	so_killspree_setup_veteran();	break;	// Veteran
	}

	Objective_Add( 1, "current", level.challenge_objective );

	// Remove unwanted weapons
	sentries = getentarray( "misc_turret", "classname" );
	foreach ( sentry in sentries )
		sentry Delete();
	stingers = getentarray( "weapon_stinger", "classname" );
	foreach ( stinger in stingers )
		stinger Delete();
	
	// Initialize Scoring
	level.points_p1 = 0;
	level.points_p1_display = level.points_p1;
	level.points_p2 = 0;
	level.points_p2_display = level.points_p2;
	level.points_counter = scale_value( level.points_goal );
	level.points_counter_display = level.points_counter;
	level.points_base_flash = scale_value( 10 );
	level.points_combo_base = scale_value( 0.25 );
	foreach ( player in level.players )
		player.points_combo_unused = 0;

	level.points_max = level.points_counter;

	// Put a clamp on how often the player is alerted to hunter spawn points.
	level.hunter_dialog_throttle = 20000;

	// Smoke chance when spawning bank or taco enemies.
	level.smoke_chance = 0.33;
	level.smoke_throttle = 60000;
	
	level.btr80_alert_throttle = 10000;
	
	// Amount enemies give for score.
	level.btr_kill_value		= scale_value( 40 );
	level.hunter_kill_value		= scale_value( 10 );
	level.hunter_finish_value	= scale_value( 5 );
	level.hunter_brutal_value	= scale_value( 20 );
	level.combo_time_window		= 4;
	// Prevent player from leaving the valid play space.
	thread enable_escape_warning();
	thread enable_escape_failure();

	// Open doors around the map.
	door_diner_open();
	//door_nates_locker_open();
	//door_bt_locker_open();
	
	// Remove ladder clips that are there to help the player in SP.
	ladder_clip = getent( "nates_kitchen_ladder_clip", "targetname" );
	ladder_clip Delete();
	ladder_clip = getent( "bt_ktichen_ladder_clip", "targetname" );
	ladder_clip Delete();

	// Remove ladders entirely
	ladder_ents = getentarray( "inv_ladders", "script_noteworthy" );
	foreach ( ent in ladder_ents )
		ent Delete();
	ladder_ents = getentarray( "inv_ladders_pathblocker", "script_noteworthy" );
	foreach ( ent in ladder_ents )
		ent disconnectpaths();
	
	// Remove the Predator Control Unit
	ent = GetEnt( "predator_drone_control", "targetname" );
	ent Delete();
	
	level.custom_eog_no_kills = true;
	level.custom_eog_no_partner = true;
	level.eog_summary_callback = ::custom_eog_summary;
	foreach ( player in level.players )
	{
		player.solid_kills = 0;
		player.heartless_kills = 0;
		player.highest_combo = 0;
		player.total_score = 0;
	}

	// Hack for SP because we don't track the upwards counting score in SP.
	if ( !is_coop() )
		level.player.total_score = scale_value( level.points_goal );
	
	deadquotes = [];
	deadquotes[ deadquotes.size ] = "@SO_KILLSPREE_INVASION_DEADQUOTE_HINT1";
	deadquotes[ deadquotes.size ] = "@SO_KILLSPREE_INVASION_DEADQUOTE_HINT2";
	deadquotes[ deadquotes.size ] = "@SO_KILLSPREE_INVASION_DEADQUOTE_HINT3";
	deadquotes[ deadquotes.size ] = "@SO_KILLSPREE_INVASION_DEADQUOTE_HINT4";
	deadquotes[ deadquotes.size ] = "@SO_KILLSPREE_INVASION_DEADQUOTE_HINT5";

	so_include_deadquote_array( deadquotes );
	
	// Clear out some flags on enemies being used in the level.
	// Enable when burger_town enemies are brought over, and spawn function updated
	// to send back how many were *actually* spawned so refill can work properly.
/*	convert_enemies = getentarray( "gas_station_enemies", "targetname" );
	convert_enemies = array_merge( convert_enemies, getentarray( "bank_enemies", "targetname" ) );
	convert_enemies = array_merge( convert_enemies, getentarray( "taco_enemies", "targetname" ) );
	convert_enemies = array_merge( convert_enemies, getentarray( "burger_town_enemies", "targetname" ) );
	foreach ( guy in convert_enemies )
	{
		if ( isdefined( guy.script_goalvolume ) )
			guy.script_goalvolume = undefined;
		if ( isdefined( guy.script_forcespawn ) )
			guy.script_forcespawn = undefined;
	}*/
}

scale_value( value )
{
	return int( value * 100 );
}

so_killspree_setup_regular()
{
	level.points_goal = 300;
	level.challenge_objective = &"SO_KILLSPREE_INVASION_OBJ_REGULAR";
}

so_killspree_setup_hardened()
{
	level.points_goal = 300;
	level.challenge_objective = &"SO_KILLSPREE_INVASION_OBJ_HARDENED";
}

so_killspree_setup_veteran()
{
	level.points_goal = 300;
	level.challenge_objective = &"SO_KILLSPREE_INVASION_OBJ_VETERAN";
}

so_killspree_setup_radio_dialog()
{
	level.scr_radio[ "so_def_inv_thermaloptics" ]	= "so_def_inv_thermaloptics";
	level.scr_radio[ "so_def_inv_bmpspottedyou" ]	= "so_def_inv_bmpspottedyou";
}

// ---------------------------------------------------------------------------------
//	Enable/Disable events
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------

custom_eog_summary()
{
	foreach ( player in level.players )
	{
		player add_custom_eog_summary_line( "@SO_KILLSPREE_INVASION_EOG_SOLID",		player.solid_kills );
		player add_custom_eog_summary_line( "@SO_KILLSPREE_INVASION_EOG_HEARTLESS",	player.heartless_kills );
		player add_custom_eog_summary_line( "@SO_KILLSPREE_INVASION_EOG_COMBOS",	player.highest_combo );
		player add_custom_eog_summary_line( "@SO_KILLSPREE_INVASION_EOG_SCORE",		hud_convert_to_points( player.total_score ) );
	}
}

// ---------------------------------------------------------------------------------

enable_kill_counter_hud()
{
	level.pulse_requests = [];
	level.pulse_requests_p1 = [];
	level.pulse_requests_p2 = [];
	foreach ( player in level.players )
		player thread hud_splash_destroy();

	array_thread( level.players, ::hud_create_kill_counter );
}

// ---------------------------------------------------------------------------------

enable_nates_exploders()
{
	thread fire_off_exploder( getent( "north_side_low", "targetname" ) );
	thread fire_off_exploder( getent( "north_side_high", "targetname" ) );
	thread fire_off_exploder( getent( "west_side", "targetname" ) );
}

// ---------------------------------------------------------------------------------

enable_smoke_wave_north( dialog_wait, flag_start )
{
	create_smoke_wave( "magic_smoke_grenade_north", flag_start, dialog_wait );
}

enable_smoke_wave_south( dialog_wait, flag_start  )
{
	create_smoke_wave( "magic_smoke_grenade", flag_start, dialog_wait );
}

// ---------------------------------------------------------------------------------

enable_hunter_truck_enemies_bank( flag_start )
{
	create_hunter_truck_enemies( "truck_north_right", flag_start );
}

enable_hunter_truck_enemies_road( flag_start )
{
	create_hunter_truck_enemies( "truck_north_left", flag_start );
}

// ---------------------------------------------------------------------------------

enable_btr80_circling_street( flag_start )
{
	create_btr80( "nate_attacker_left", flag_start );
}

enable_btr80_circling_parking_lot( flag_start )
{
	create_btr80( "nate_attacker_mid", flag_start );
}

// ---------------------------------------------------------------------------------

enable_hunter_enemy_refill( refill_at, min_fill, max_fill )
{
	hunter_enemies_refill( refill_at, min_fill, max_fill );
}

enable_hunter_enemy_group_bank( enemy_count, flag_start )
{
	create_hunter_enemy_group( "bank_enemies", flag_start, enemy_count );
}

enable_hunter_enemy_group_gas_station( enemy_count, flag_start )
{
	create_hunter_enemy_group( "gas_station_enemies", flag_start, enemy_count );
}

enable_hunter_enemy_group_taco( enemy_count, flag_start )
{
	create_hunter_enemy_group( "taco_enemies", flag_start, enemy_count );
}

// ---------------------------------------------------------------------------------