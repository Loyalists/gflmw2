#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\so_defense_invasion_code;

// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	maps\invasion_precache::main();
	maps\invasion_fx::main();
	maps\createart\invasion_art::main();
	
	precachestring( &"SO_DEFENSE_INVASION_OBJ_REGULAR" );
	precachestring( &"SO_DEFENSE_INVASION_OBJ_HARDENED" );
	precachestring( &"SO_DEFENSE_INVASION_OBJ_VETERAN" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_1" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_2" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_3" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_4" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_5" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_20" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_30" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_30_SKILLED" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_40" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_40_SKILLED" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_HELLFIRE" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_BTR80" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_HELI" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_HELIS" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_BLANK" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_COMING" );
	precachestring( &"SO_DEFENSE_INVASION_HUNTERS" );
	precachestring( &"SO_DEFENSE_INVASION_BTR80" );
	precachestring( &"SO_DEFENSE_INVASION_HELICOPTERS" );
	precachestring( &"SO_DEFENSE_INVASION_UAV_SPOTTED" );
	precachestring( &"SO_DEFENSE_INVASION_UAV_TARGETTING" );
	precachestring( &"SO_DEFENSE_INVASION_KILLS_TURRET" );
	precachestring( &"SO_DEFENSE_INVASION_KILLS_BTR80" );
	precachestring( &"SO_DEFENSE_INVASION_KILLS_HELI" );
	
	precacheItem( "smoke_grenade_american" );
	precacheItem( "remote_missile_not_player_invasion" );
	precacheModel( "weapon_stinger_obj" );
	precacheModel( "weapon_uav_control_unit_obj" );
	precacheItem( "flash_grenade" );
	
	precacheItem( "zippy_rockets" );
	precacheItem( "stinger_speedy" );
	
	add_start( "so_defense", ::start_so_defense );

	maps\_attack_heli::preLoad();

	maps\_load::main();

	thread maps\invasion_amb::main();
	maps\invasion_anim::main_anim();

	maps\_compass::setupMiniMap( "compass_map_invasion" );
}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------
start_so_defense()
{
	so_defense_init();
	so_defense_challenge_prep();
	so_defense_wave_1();
	so_defense_wave_2();
	so_defense_wave_3();
	so_defense_wave_4( true );
	so_defense_wave_5( true );
	so_defense_challenge_complete();		
}

so_defense_init()
{
	flag_init( "challenge_start" );
	flag_init( "challenge_success" );

	so_defense_setup_radio_dialog();
	
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_defense_setup_Regular();		break;	// Regular
		case 2:	so_defense_setup_hardened();	break;	// Hardened
		case 3:	so_defense_setup_veteran();		break;	// Veteran
	}

	// Smoke chance when spawning bank, burgertown, or taco enemies.
	level.smoke_chance = 0.33;
	level.smoke_throttle = 60000;

	level.btr80_alert_throttle = 10000;

	// Put a clamp on how often the player is alerted to hunter spawn points.
	level.hunter_dialog_throttle = 20000;

	// Remove unwanted sentries
	sentries = getentarray( "misc_turret", "classname" );
	foreach ( sentry in sentries )
		sentry Delete();
	common_scripts\_sentry::main();

	// Attacker Accuracy modifiers for sentry turrets.
	level.aamod_sentry_kill	= 2.0;
	// harder difficulties a bit more forgiving on turret usage.
	switch( level.gameskill )
	{
		case 2:	level.aamod_sentry_kill	= 1.75; break;
		case 3:	level.aamod_sentry_kill	= 1.25; break;
	}
	level.aamod_player_kill	= -8.0;
	level.aamod_btr80_kill	= -12.0;
	level.aamod_heli_kill	= -16.0;
	
	// Access the stingers before the player has a chance to take them
	level.stingers = [];
	thread stinger_maintain_spawn( "diner" );
	thread stinger_maintain_spawn( "nates_stinger" );
//	thread dialog_get_stinger();

	// Custom end of game summary info.	
	level.custom_eog_no_partner = true;
	level.eog_summary_callback = ::custom_eog_summary;
	foreach ( player in level.players )
	{
		player.turret_kills = 0;
		player.btr80_kills = 0;
		player.helicopter_kills = 0;
	}
	
	// Prevent player from leaving the valid play space.
	thread enable_escape_warning();
	thread enable_escape_failure();
	thread enable_challenge_timer( "challenge_start", "challenge_success" );

	// Remove ladder clips that are there to help the player in SP.
	ladder = getent( "nates_kitchen_ladder_clip", "targetname" );
	ladder Delete();
	ladder = getent( "bt_ktichen_ladder_clip", "targetname" );
	ladder Delete();

	// Remove the Predator Control Unit
	ent = GetEnt( "predator_drone_control", "targetname" );
	ent Delete();
	
	// Update the enemies so they can be used properly.
	so_defense_convert_enemies();
	so_defense_set_enemy_spawner_flags();

	// Open doors around the map.
	door_diner_open();
	//door_nates_locker_open();
	//door_bt_locker_open();
	
	deadquotes = [];
	deadquotes[ deadquotes.size ] = "@SO_DEFENSE_INVASION_DEADQUOTE_HINT1";
	deadquotes[ deadquotes.size ] = "@SO_DEFENSE_INVASION_DEADQUOTE_HINT2";
	deadquotes[ deadquotes.size ] = "@SO_DEFENSE_INVASION_DEADQUOTE_HINT3";
	deadquotes[ deadquotes.size ] = "@SO_DEFENSE_INVASION_DEADQUOTE_HINT4";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_CLAYMORE_POINT_ENEMY";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_CLAYMORE_ENEMIES_SHOOT";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_TURRET_PLACEMENT";
	so_include_deadquote_array( deadquotes );

	// HOLD HERE TILL PLAYERS READY IN ONLINE COOP
	so_wait_for_players_ready();

	// Todo: Convert the individual wave items into objectives
	Objective_Add( 1, "current", level.challenge_objective );
}

so_defense_setup_regular()
{
	level.challenge_objective = &"SO_DEFENSE_INVASION_OBJ_REGULAR";
}

so_defense_setup_hardened()
{
	level.challenge_objective = &"SO_DEFENSE_INVASION_OBJ_HARDENED";
}

so_defense_setup_veteran()
{
	level.challenge_objective = &"SO_DEFENSE_INVASION_OBJ_VETERAN";
}

so_defense_setup_radio_dialog()
{
	level.scr_radio[ "so_def_inv_thermaloptics" ]	= "so_def_inv_thermaloptics";
	level.scr_radio[ "so_def_inv_bmpspottedyou" ]	= "so_def_inv_bmpspottedyou";
	level.scr_radio[ "so_def_inv_niceone" ]			= "so_def_inv_niceone";
	level.scr_radio[ "so_def_inv_stingerdiner" ]	= "so_def_inv_stingerdiner";
	level.scr_radio[ "so_def_inv_stingernates" ]	= "so_def_inv_stingernates";
}

// ---------------------------------------------------------------------------------
//	Challenge Waves
// ---------------------------------------------------------------------------------
so_defense_challenge_prep()
{
	thread enable_hellfire_attack();
	pause_hellfire_attack();
	
	thread enable_nates_exploders();

	thread fade_challenge_in();
	
	wait so_standard_wait();
}

so_defense_wave_1( force_wave )
{
	if ( !so_defense_can_do_wave( 1, force_wave ) )
		return;

	so_defense_announce_wave_start( "SO_DEFENSE_INVASION_WAVE_1", 10, true );
	thread hud_display_wavecount( 1 );

	flag_set( "challenge_start" );
	
	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_HUNTERS", 20, "hunter_death" );
	thread enable_hunter_enemy_refill( 10, 10, 10, 20 );

	level waittill( "hunters_all_down" );
	so_defense_announce_wave_complete();
}

so_defense_wave_2( force_wave )
{
	if ( !so_defense_can_do_wave( 1, force_wave ) )
		return;

	so_defense_announce_wave_start( "SO_DEFENSE_INVASION_WAVE_2", 10 );
	thread hud_display_wavecount( 2 );

	thread unpause_hellfire_attack();

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_HUNTERS", 30, "hunter_death" );
	thread enable_hunter_truck_enemies_road();
	thread enable_hunter_enemy_refill( 10, 10, 10, 20 );

	level waittill( "hunters_all_down" );
	so_defense_announce_wave_complete();
}

so_defense_wave_3( force_wave )
{
	if ( !so_defense_can_do_wave( 1, force_wave ) )
		return;

	so_defense_announce_wave_start( "SO_DEFENSE_INVASION_WAVE_3", 10 );
	thread hud_display_wavecount( 3 );

	thread unpause_hellfire_attack();

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_HUNTERS", 40, "hunter_death" );
	thread enable_hunter_enemy_refill( 15, 15, 15, 40 );

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_HELICOPTERS", 1, "attack_heli_death" );
	thread enable_attack_heli_everywhere();
	
	waittill_multiple( "hunters_all_down", "attack_helis_all_down" );
	so_defense_announce_wave_complete();
}

so_defense_wave_4( force_wave )
{
	if ( !so_defense_can_do_wave( 2, force_wave ) )
		return;

	so_defense_announce_wave_start( "SO_DEFENSE_INVASION_WAVE_4", 10 );
	thread hud_display_wavecount( 4 );

	thread unpause_hellfire_attack();

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_HUNTERS", 30, "hunter_death" );
	thread enable_hunter_enemy_refill( 15, 15, 15, 30 );

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_BTR80", 1, "btr80_death" );
	thread enable_btr80_circling_street();

	waittill_multiple( "hunters_all_down", "btr80s_all_down" );
	so_defense_announce_wave_complete();
}

so_defense_wave_5( force_wave )
{
	if ( !so_defense_can_do_wave( 3, force_wave ) )
		return;
		
	so_defense_announce_wave_start( "SO_DEFENSE_INVASION_WAVE_5", 10 );
	thread hud_display_wavecount( 5 );

	thread unpause_hellfire_attack();

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_HUNTERS", 40, "hunter_death" );
	thread enable_hunter_truck_enemies_bank();
	thread enable_hunter_enemy_refill( 15, 15, 15, 30 );

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_BTR80", 1, "btr80_death" );
	thread enable_btr80_circling_parking_lot();

	thread hud_display_enemies_active( &"SO_DEFENSE_INVASION_HELICOPTERS", 2, "attack_heli_death" );
	thread enable_attack_heli_north();
	thread enable_attack_heli_south( 15 );

	waittill_multiple( "hunters_all_down", "btr80s_all_down", "attack_helis_all_down" );
	so_defense_announce_wave_complete();
}

so_defense_announce_wave_start( wave, timer, set_start_time )
{
	thread enable_countdown_timer( timer, set_start_time );

	wait 2;
	hud_display_wave( wave, timer - 2 );

	thread so_defense_announce_start_music( wave );
		
	// Reset the progress status so it can give appropriate updates each wave.
	level.so_progress_goal_status = "none";

	// Reset the hunter dialog throttle so that it will happen on the first wave again.
	if ( isdefined( level.hunter_dialog_throttle ) )
		level.hunter_dialog_time = gettime() - level.hunter_dialog_throttle - 1;
	
	// Reset the stinger missile dialog throttle so that it will wait a while before activating.
	stringer_dialog_throttle_reset();
}

so_defense_announce_start_music( wave )
{
	// Gives time for the snare drum SFX to complete.
	wait 0.75;
	
	if ( wave == "SO_DEFENSE_INVASION_WAVE_5" )
		thread music_loop( "so_defense_invasion_finalwave_music", 114 );
	else
		thread music_loop( "so_defense_invasion_music", 191 );
}

so_defense_announce_wave_complete()
{
	hud_display_wavecount_remove();

	pause_hellfire_attack();
	level.player PlaySound( "arcademode_kill_streak_won" );
	music_stop( 2 );
	
	// Give all other notifies a chance to catch up.
	wait 0.05;
	level notify( "wave_complete" );
	level.hud_display_enemies = undefined;
}

so_defense_challenge_complete()
{
	flag_set( "challenge_success" );
	thread fade_challenge_out();
}

so_defense_can_do_wave( skill, force_wave )
{
	if ( isdefined( force_wave ) && force_wave )
		return true;
		
	return level.gameSkill >= skill;
}

custom_eog_summary()
{
	foreach ( player in level.players )
	{
		player add_custom_eog_summary_line( "@SO_DEFENSE_INVASION_KILLS_TURRET",	player.turret_kills );
		player add_custom_eog_summary_line( "@SO_DEFENSE_INVASION_KILLS_BTR80",		player.btr80_kills );
		player add_custom_eog_summary_line( "@SO_DEFENSE_INVASION_KILLS_HELI",		player.helicopter_kills );
	}
}

// ---------------------------------------------------------------------------------
//	Enable/Disable events
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------

enable_nates_exploders()
{
	thread fire_off_exploder( getent( "north_side_low", "targetname" ) );
	thread fire_off_exploder( getent( "north_side_high", "targetname" ) );
	thread fire_off_exploder( getent( "west_side", "targetname" ) );
}

// ---------------------------------------------------------------------------------

enable_smoke_wave_north( dialog_wait )
{
	create_smoke_wave( "magic_smoke_grenade_north", dialog_wait );
}

enable_smoke_wave_south( dialog_wait  )
{
	create_smoke_wave( "magic_smoke_grenade", dialog_wait );
}

// ---------------------------------------------------------------------------------

enable_hunter_truck_enemies_bank()
{
	create_hunter_truck_enemies( "truck_north_right" );
}

enable_hunter_truck_enemies_road()
{
	create_hunter_truck_enemies( "truck_north_left" );
}

// ---------------------------------------------------------------------------------

enable_btr80_circling_street()
{
	create_btr80( "nate_attacker_left" );
}

enable_btr80_circling_parking_lot()
{
	create_btr80( "nate_attacker_mid" );
}

// ---------------------------------------------------------------------------------

enable_hunter_enemy_refill( refill_at, min_fill, max_fill, refill_total )
{
	hunter_enemies_refill( refill_at, min_fill, max_fill, refill_total );
}

enable_hunter_enemy_group_bank( enemy_count )
{
	create_hunter_enemy_group( "bank_enemies", enemy_count );
}

enable_hunter_enemy_group_gas_station( enemy_count )
{
	create_hunter_enemy_group( "gas_station_enemies", enemy_count );
}

enable_hunter_enemy_group_taco( enemy_count )
{
	create_hunter_enemy_group( "taco_enemies", enemy_count );
}

enable_hunter_enemy_group_burger_town( enemy_count )
{
	create_hunter_enemy_group( "burger_town_enemies", enemy_count );
}

// ---------------------------------------------------------------------------------

enable_hellfire_attack()
{
	hellfire_attack_start();
}

disable_hellfire_attack()
{
	hellfire_attack_stop();
}

pause_hellfire_attack()
{
	hellfire_attack_pause();
}

unpause_hellfire_attack()
{
	hellfire_attack_unpause();
}

// ---------------------------------------------------------------------------------

enable_attack_heli_everywhere( wait_time )
{	
	create_attack_heli( "kill_heli", "attack_heli_circle_node", wait_time );
}

enable_attack_heli_north( wait_time )
{	
	create_attack_heli( "kill_heli", "attack_heli_north_circle_node", wait_time );
}

enable_attack_heli_south( wait_time )
{	
	create_attack_heli( "kill_heli", "attack_heli_south_circle_node", wait_time );
}

// ---------------------------------------------------------------------------------