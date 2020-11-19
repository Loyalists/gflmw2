#include maps\_utility;
#include common_scripts\utility;
#include maps\_riotshield;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;

#include maps\airport_code;

CONST_SPEEDELEVATOR = 20;// 19
CONST_SPEEDLOBBY0 	 = 26;// 25
CONST_SPEEDLOBBY 	 = 26;// 45
CONST_SPEEDLOBBY2 	 = 25;// 30
CONST_SPEEDSTAIRS	 = 42;
CONST_SPEEDUPPER	 = 35;// 42
CONST_SPEEDSECURITY	 = 33;// 55
CONST_TARMAC		 = 27;// 60
CONST_TARMACSTAIRS	 = 38;
CONST_SPEEDBASEMENT = 42;
CONST_SPEEDTARMAC2	 = 68;
CONST_SPEEDTARMAC3	 = 80;
CONST_SPEEDCATCHUP	 = 80;

main()
{
	flags();

	channels = maps\_equalizer::get_all_channels();
	foreach ( channel, _ in channels )
	{
		SoundSetTimeScaleFactor( channel, 0 );
	}
	level.ambience_timescale = 0;
	
	//STARTS
	default_start( ::start_intro );
//	set_default_start( "intro" );
	add_start( "intro", 	::start_intro, 		"[intro] -> assault the security checkpoint", 	::intro_main );
	add_start( "stairs", 	::start_stairs, 	"[stairs] -> proceed up the escalaters", 		::stairs_main );
	add_start( "massacre", 	::start_massacre, 	"[massacre] -> massacre the remaing civilians", 	::massacre_main );
	add_start( "gate", 		::start_gate, 		"[gate] -> walk through the sea of dead bodies", ::gate_main );
	add_start( "basement", 	::start_basement, 	"[basement] -> move through the basement", 		::basement_main );
	add_start( "tarmac", 	::start_tarmac, 	"[tarmac] -> assault the tarmac", 				::tarmac_main );
	add_start( "escape", 	::start_escape, 	"[escape] -> escape from the airport", 			::escape_main );

	//test starts
	add_start( "grigs", 		::start_grigs, 		"[grigsby test]" );

	//MUST COME BEFORE LOAD
	maps\airport_challenge::ap_ch_main();
		
	global_inits();
	maps\_compass::setupMiniMap( "compass_map_airport" );
}

flags()
{
	flag_init( "do_not_save" );
	flag_init( "friendly_fire_good_kill_line" );
	flag_init( "friendly_fire_good_kill_line2" );
	flag_init( "friendly_fire_no_kill_line" );
	flag_init( "friendly_fire_checkfire_line" );
	flag_init( "friendly_fire_dist_check" );
	flag_init( "friendly_fire_kill_check" );
	flag_init( "friendly_fire_pause_flash" );
	flag_init( "friendly_fire_pause_fire" );

	flag_init( "player_dynamic_move_speed" );
	flag_init( "player_DMS_allow_sprint" );
	flag_init( "team_initialized" );
	flag_init( "elevator_up_done" );
	flag_init( "lobby_scene_animate" );
	flag_init( "lobby_scene_pre_animate" );
	flag_init( "intro_slowmo_start" );
	flag_init( "lobby_open_fire" );
	flag_init( "lobby_to_stairs_go" );

	flag_init( "stairs_go_up" );
	flag_init( "lobby_cleanup_spray" );
	flag_init( "lobby_cleanup" );
	flag_init( "lobby_to_stairs_flow" );
	flag_init( "lobby_ai_peeps_dead" );

	//flag_init( "stairs_top_open_fire" );
	flag_init( "stairs_upperdeck_civs_dead" );
	flag_init( "upperdeck_flow1" );
	flag_init( "upperdeck_flow1b" );
	flag_init( "upperdeck_flow1c" );
	flag_init( "upperdeck_flow3" );
	flag_init( "upperdeck_flow4" );
	flag_init( "massacre_play_sounds" );
	flag_init( "massacre_rentacop_stop" );
	flag_init( "massacre_rentacop_stop_dead" );
	flag_init( "massacre_rentacop_rush" );
	flag_init( "massacre_kill_rush" );
	flag_init( "massacre_rentacop_runaway_go" );
//	flag_init( "massacre_rentacop_runaway_dead" );
	flag_init( "massacre_rentacop_row1_fighter_go" );
//	flag_init( "massacre_rentacop_row1_fighter_dead" );
	flag_init( "massacre_rentacop_row1_runner_go" );
//	flag_init( "massacre_rentacop_row1_runner_dead" );
	flag_init( "massacre_rentacop_rambo" );
	flag_init( "massacre_rentacop_rambo_dead" );

	flag_init( "massacre_runners1_dead" );
	flag_init( "massacre_runners2_dead" );
	flag_init( "massacre_runners3_dead" );

	flag_init( "massacre_rentacops_rear_dead" );
	//flag_init( "massacre_rentacops_stairs_dead" );
	flag_init( "massacre_nadethrow" );
	flag_init( "massacre_decided_nader" );
	flag_init( "massacre_makarov_point_at_rambo" );

	flag_init( "massacre_elevator_start" );
	flag_init( "massacre_elevator_down" );
	flag_init( "massacre_elevator_up" );
	flag_init( "massacre_eleveator_should_come_up" );
	flag_init( "massacre_elevator_prepare_nade" );
	flag_init( "massacre_elevator_at_top" );
	flag_init( "massacre_elevator_guys_ready" );
	flag_init( "massacre_elevator_grenade_ready" );
	flag_init( "massacre_elevator_grenade_throw" );
	flag_init( "massacre_elevator_grenade_exp" );
	flag_init( "massacre_line_of_fire_done" );

	flag_init( "gate_main" );
	flag_init( "gate_canned_deaths" );
	flag_init( "gate_heli_moveon" );

	//flag_init( "basement_moveout" );
	flag_init( "basement_mak_speach" );
	flag_init( "basement_moveout2" );
	flag_init( "basement_mak_saw_riot" );
	flag_init( "basement_near_entrance" );

	//flag_init( "tarmac_moveout" );

	flag_init( "tarmac_pre_heat_fight" );
	flag_init( "tarmac_too_far" );
	flag_init( "tarmac_killed_security" );

	flag_init( "tarmac_open_fire" );
	flag_init( "tarmac_retreat1" );
	flag_init( "tarmac_retreat2" );
	flag_init( "tarmac_retreat3" );
	flag_init( "tarmac_advance4" );
	flag_init( "tarmac_retreat4" );
	flag_init( "tarmac_advance6" );
	flag_init( "tarmac_retreat5" );
	flag_init( "tarmac_retreat6" );
	flag_init( "tarmac_advance8" );
	flag_init( "tarmac_bcs" );
	flag_init( "tarmac_kill_friendly_bsc" );
	flag_init( "tarmac_2ndfloor_move_back" );
	
	
	//tarmac_enemies_wave1_dead
	//tarmac_enemies_wave2_dead
	//tarmac_enemies_2ndfloor_dead
	//tarmac_van_guys_dead
	//tarmac_van_guys2_dead
	flag_init( "tarmac_van_guys_far_enough" );
	flag_init( "tarmac_van_guys_spawn" );
	flag_init( "tarmac_van_guys2_spawn" );

	flag_init( "tarmac_van_mid_path" );
	flag_init( "tarmac_van_almost_end_path" );
	flag_init( "tarmac_van_end_path" );

	flag_init( "tarmac_clear_out_2nd_floor" );
	flag_init( "tarmac_enemies_2ndfloor" );
	
	flag_init( "escape_van_ready" );
	flag_init( "escape_doorkick" );
	flag_init( "escape_sequence_reach" );
	flag_init( "escape_hold_your_fire" );
	flag_init( "escape_main" );
	flag_init( "escape_sequence_go" );
	flag_init( "escape_player_get_in" );
	flag_init( "escape_player_is_in" );

	flag_init( "escape_sequence_over" );
	flag_init( "escape_player_shot" );
	flag_init( "escape_player_realdeath" );
	flag_init( "end_player_ready" );
	flag_init( "end_makarov_in_place" );
	flag_init( "player_ready_for_proper_ending" );
}

global_inits()
{
	level.CONST_WAIT_TARMAC_BSC = 1.5;
	SetDvar( "scr_elevator_speed", "64" );
	SetSavedDvar( "ai_friendlyFireBlockDuration", 0 );

	maps\createart\airport_art::main();
	maps\createfx\airport_audio::main();
	maps\createfx\airport_fx::main();

	maps\airport_precache::main();
	maps\airport_fx::main();
	maps\_load::main();
	maps\_dynamic_run_speed::main();
	maps\airport_anim::main();

	maps\_drone_civilian::init();
	maps\_drone_ai::init();
	level.drone_lookAhead_value = 60;
	level.nadethrow_mak_time	 = 2.75;

	maps\airport_amb::main();
	
	thread airport_music();
	
	thread glass_elevator_setup();

	array_thread( GetEntArray( "glass_delete", "targetname" ), ::delete_glass );

	PreCacheModel( "projectile_us_smoke_grenade" );
	PreCacheModel( "com_cellphone_on" );
	PreCacheModel( "com_metal_briefcase" );
	PreCacheModel( "electronics_pda" );
	PreCacheModel( "tag_origin" );

	PreCacheItem( "usp_airport" );
	PreCacheItem( "m4_grunt_airport" );
	PreCacheItem( "saw_airport" );
	PreCacheItem( "rpg_straight" );

	PreCacheRumble( "tank_rumble" );
	PreCacheRumble( "damage_heavy" );
	PreCacheShader( "hint_mantle" );
	PreCacheShader( "overlay_airport_death" );
	PreCacheShader( "white" );
	PreCacheShellShock( "airport" );
	// The police barricade has too much fire power to confront.
	PreCacheString( &"AIRPORT_FAIL_POLICE_BARRICADE" );
	
	PreCacheMenu( "offensive_skip" );
	
	thread jet_engine_death_print();
	array_thread( GetEntArray( "jet_engine", "targetname" ), ::jet_engine );

	level.default_goalheight = 128;
	
	// Press^3 [{+actionslot 3}] ^7to use\nthe M203 Grenade Launcher.
	add_hint_string( "grenade_launcher", &"SCRIPT_LEARN_GRENADE_LAUNCHER", ::should_break_m203_hint );
}

/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/
intro_main()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	array_thread( GetEntArray( "intro_security_run_die", "targetname" ), ::add_spawn_function, ::intro_security_run_die );
	array_thread( GetEntArray( "lobby_to_stairs_flow", "targetname" ), ::add_spawn_function, ::lobby_to_stairs_flow );
	array_thread( GetEntArray( "lobby_to_stairs_flow", "targetname" ), ::lobby_to_stairs_flow_spawner );
	array_thread( GetEntArray( "intro_security_lobby", "targetname" ), ::add_spawn_function, ::lobby_security_intro );

	activate_trigger( "intro_security_lobby", "target" );
	
	thread flag_clear_delayed( "_escalator_on", 1 );
	
	thread airport_vision_elevator();
	thread airport_vision_intro();
	thread intro_dead_bodies();
	thread intro_stairs_handle_player_speed();
	//handle civilians in lobby
	thread intro_civilians();
	thread stair_top_terror();

	thread lobby_to_stairs_flow_snd_scape( "scn_airport_running_screams2" );

	skip_airport_popup();
	
	add_wait( ::flag_wait, "lobby_to_stairs_flow" );
	add_func( ::delaythread, 2, ::lobby_to_stairs_flow_snd_scape, "scn_airport_running_screams1" );
	thread do_wait();

	flag_wait( "team_initialized" );
		
	thread elevator_scene();
	
	flag_wait( "elevator_up_done" );

	lobby_scene();

	flag_wait( "lobby_to_stairs_go" );

	activate_trigger( "lobby_to_stairs_flow", "target" );

	level notify( "stop_explode_targets" );
	if ( !flag( "do_not_save" ) )
		thread autosave_by_name( "lobby_to_stairs" );

	nodes = GetNodeArray( "lobby_moveup_nodes", "targetname" );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread lobby_moveout_to_stairs( node );

	nodes = GetNodeArray( "prestairs_nodes", "targetname" );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread lobby_prestairs_nodes_behavior( node );
}

skip_airport_popup()
{
	thread skip_airport_listener();
	
	// ui_offensive_skip is temp until code provides us with profile variable
	if ( level.player GetLocalPlayerProfileData( "canSkipOffensiveMissions" ) != 1 )
		return;

	level.player openpopupMenu( "offensive_skip" ); // this menu pauses the script
}

skip_airport_listener()
{
	setdvar( "ui_skip_airport", "" );
	while ( true )
	{
		wait 1;
		if ( getdvar( "ui_skip_airport" ) == "1" )
		{
			nextmission();
			return;
		}
	}	
}

intro_stairs_handle_player_speed()
{
	flag_wait( "elevator_up_done" );
	delayThread( 1, ::blend_movespeedscale_custom, CONST_SPEEDELEVATOR, .25 );

	flag_wait( "lobby_open_fire" );
	blend_movespeedscale_custom( CONST_SPEEDLOBBY0, .5 );

	flag_wait( "lobby_to_stairs_go" );
	delayThread( 1.5, ::blend_movespeedscale_custom, CONST_SPEEDLOBBY, 2 );

	flag_wait( "player_set_speed_lobby" );
	blend_movespeedscale_custom( CONST_SPEEDLOBBY2, 1.5 );

	flag_wait( "player_set_speed_stairs" );
	blend_movespeedscale_custom( CONST_SPEEDSTAIRS, .25 );

	flag_wait( "player_set_speed_upperstairs" );
	blend_movespeedscale_custom( CONST_SPEEDUPPER, 1 );
}

intro_dead_bodies()
{
	array = intro_setup_dead_bodies();

	foreach ( model in array )
		model Hide();

	flag_wait( "lobby_open_fire" );

	wait 7;
	array[ "stairs_dead_body3" ] Show();
	wait 1;
	array[ "stairs_dead_body2" ] Show();
	wait 1;
	array[ "stairs_dead_body" ] Show();

	flag_wait( "player_set_speed_stairs" );
	foreach ( model in array )
		model Show();
}

#using_animtree( "generic_human" );
intro_setup_dead_bodies()
{
	models = GetEntArray( "upperdeck_dead_body", "targetname" );

	array = [];
	foreach ( key, model in models )
		array[ "upperdeck_dead_body" + key ] = model;

	array[ "stairs_dead_body" ] 	 = GetEnt( "stairs_dead_body", "targetname" );
	array[ "stairs_dead_body2" ] 	 = GetEnt( "stairs_dead_body2", "targetname" );
	array[ "stairs_dead_body3" ] 	 = GetEnt( "stairs_dead_body3", "targetname" );

	foreach ( model in array )
	{
		model UseAnimTree( #animtree );
		model thread anim_generic( model, model.script_animation );
		model SetAnimTime( getanim_generic( model.script_animation ), 1 );
	}

	return array;
}

intro_civilians()
{	
	wait 21.5 + 2;
	
	data = maps\airport_anim::lobby_people_data();
	blood = GetEnt( "lobby_blood", "targetname" );
	rope = GetEnt( "intro_rope", "targetname" );
	rope Delete();
	blood Hide();

	for ( i = 1; i <= 14; i++ )
	{
		node = getstruct( "intro_lobby_anim_group_" + i, "targetname" );
		if( isdefined( node ) )
			node thread lobby_people_create( data );
	}

	drones = GetEntArray( "intro_lobby_crowd_2", "targetname" );

	foreach ( drone in drones )
		delayThread( 1, ::dronespawn, drone );

	array_thread( GetEntArray( "lobby_people", "targetname" ), ::add_spawn_function, ::lobby_ai_logic );
	array_thread( GetEntArray( "intro_lobby_crowd_2", "targetname" ), ::add_spawn_function, ::lobby_drone_logic );

	delayThread( 1, ::activate_trigger, "lobby_people_spawner", "targetname" );

	
	wait 3;
	wait 5.5;
	flag_set( "lobby_scene_pre_animate" );
	wait 1.0;
	flag_set( "lobby_scene_animate" );	
	delayThread( 7, ::flag_set, "lobby_open_fire" );
		

	wait 3.25;

	flag_wait( "lobby_open_fire" );
	trig = GetEnt( "intro_line_of_fire_trig", "targetname" );
	trig thread player_line_of_fire( "lobby_to_stairs_go", level.team );

	add_wait( ::trigger_wait_targetname, "intro_line_of_fire_trig_final" );
	add_abort( ::flag_wait, "lobby_to_stairs_go" );
	level.player add_call( ::Kill );
	thread do_wait();

	array_thread( GetEntArray( "intro_bank_poll", "targetname" ), ::intro_phys_push );
	blood delayCall( 4, ::Show );
	wait 1;	
}

elevator_scene()
{
	//do player weapon stuff
	thread elevator_player();

	//do cool stuff with the floor indicator
	thread elevator_floor_indicator();

	//handle team animations in elevator
	node = getstruct( "intro_elevator_anim_node", "targetname" );
	team = [];
	foreach ( member in level.team )
		member thread elevator_scene_guy( node );

	
	origin = GetEnt( "snd_origin_intro_crowd", "targetname" );
	origin delayCall( 7.5 + 5 + 5.5, ::playsound, "scn_airport_crowd_opening" );	
}

elevator_scene_guy( node )
{	
	node thread anim_single_solo( self, "elevator_scene" );
	
	wait 5;
	wait 5.5;
	
	node thread anim_single_solo( self, "elevator_scene" );
}

lobby_scene()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	nodes = GetNodeArray( "intro_initial_firing_positions", "targetname" );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread lobby_moveout( node );

	flag_wait( "lobby_open_fire" );

	foreach ( actor in level.team )
		actor.ignoreall = false;

	origin = GetEnt( "snd_origin_intro_crowd", "targetname" );
	origin PlaySound( "scn_airport_crowd_opening_terror" );

	node = getstruct( "lobby_scream_track", "targetname" );
	thread scream_track( node, "scn_airport_crowd_opening_running", 150 );

	delayThread( 5, ::lobby_sign );

	wait .5;
	thread explode_targets( getstructarray( "lobby_dyn_targets", "targetname" ) );

	wait 2;
	thread explode_targets( getstructarray( "lobby_dyn_targets_lights", "targetname" ), 96, 3.5 );

	wait 5.35;
	thread explode_targets( getstructarray( "lobby_dyn_targets_last", "targetname" ) );
}

/************************************************************************************************************/
/*												UPPERDECK													*/
/************************************************************************************************************/
stairs_main()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

//	flag_wait( "player_set_speed_lobby" );

	//array_thread( GetEntArray( "upperdeck_civ", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_civ );

	array_thread( GetEntArray( "upperdeck_crawler", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_crawler );
	array_thread( GetEntArray( "upperdeck_crawlers_1", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_crawler );
	array_thread( GetEntArray( "upperdeck_crawlers2", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_crawler );
	array_thread( GetEntArray( "upperdeck_crawlers_wait", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_crawler );

	array_thread( GetEntArray( "upperdeck_initial_runners", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_initial_runners );
	array_thread( GetEntArray( "upperdeck_runners4", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_runners_more, "upperdeck_flow4" );
	array_thread( GetEntArray( "upperdeck_runners3", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_runners3 );
	array_thread( GetEntArray( "upperdeck_runners2", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_runners_more, "upperdeck_flow2" );
	array_thread( GetEntArray( "upperdeck_runners1b", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_runners_more, "upperdeck_flow1b" );
	array_thread( GetEntArray( "upperdeck_runners1c", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_runners_more, "upperdeck_flow1c" );
	array_thread( GetEntArray( "upperdeck_canned_deaths", "targetname" ), ::upperdeck_canned_deaths_setup, "stairs_top_open_fire" );
	array_thread( GetEntArray( "upperdeck_fakesound", "targetname" ), ::upperdeck_fakesound );
	array_thread( getstructarray( "upperdeck_turn_on_arrival", "script_noteworthy" ), ::upperdeck_turn_on_arrival );

	GetEnt( "stairs_cop", "targetname" ) add_spawn_function( ::stairs_cop );

	thread massacre_team_dialogue();
	thread airport_vision_stairs();

	trigL = GetEnt( "stairs_line_of_fire_trig_l", "targetname" );
	teamL = [];
	teamL[ teamL.size ] = level.team[ "makarov" ];
	teamL[ teamL.size ] = level.team[ "m4" ];

	trigR = GetEnt( "stairs_line_of_fire_trig_r", "targetname" );
	teamR = [];
	teamR[ teamR.size ] = level.team[ "saw" ];
	teamR[ teamR.size ] = level.team[ "shotgun" ];

	teamL[ 0 ] add_wait( ::ent_flag_wait, "stairs_at_top" );
	teamL[ 1 ] add_wait( ::ent_flag_wait, "stairs_at_top" );
	trigL add_func( ::player_line_of_fire, "stairs_upperdeck_civs_dead", teamL );
	thread do_wait_any();

	teamR[ 0 ] add_wait( ::ent_flag_wait, "stairs_at_top" );
	teamR[ 1 ] add_wait( ::ent_flag_wait, "stairs_at_top" );
	trigR add_func( ::player_line_of_fire, "stairs_upperdeck_civs_dead", teamR );
	thread do_wait_any();

	node1 = getstruct( "upperdeck_scream_track", "targetname" );
	node2 = getstruct( "upperdeck_scream_track2", "targetname" );
	node1b = getstruct( "upperdeck_scream_track1b", "targetname" );
	node1c = getstruct( "upperdeck_scream_track1c", "targetname" );

	add_wait( ::flag_wait, "upperdeck_flow1" );
	add_func( ::scream_track, node1, "scn_airport_running_screams1", 150 );
	thread do_wait();

	add_wait( ::flag_wait, "upperdeck_flow1b" );
	add_func( ::scream_track, node1b, "scn_airport_running_screams2", 150 );
	thread do_wait();

	add_wait( ::flag_wait, "upperdeck_flow1c" );
	add_func( ::scream_track, node1c, "scn_airport_running_screams3", 150 );
	thread do_wait();

	add_wait( ::flag_wait, "upperdeck_flow2" );
	add_func( ::scream_track, node2, "scn_airport_running_screams1", 150 );
	thread do_wait();

	add_wait( ::flag_wait, "upperdeck_flow4" );
	add_func( ::scream_track, node2, "scn_airport_running_screams2", 150 );
	thread do_wait();
	
	add_wait( ::flag_wait, "stairs_go_up" );
	add_func( ::delaythread, .5, ::exploder, "anc_stairs" );
	thread do_wait();
	
	thread stairs_saves();
	
	add_wait( ::flag_wait, "stairs_go_up" );
	add_abort( ::flag_wait, "player_set_speed_stairs" );
	add_func( ::blend_movespeedscale_custom, CONST_SPEEDSTAIRS, .25 );
	thread do_wait();

	nodes = GetNodeArray( "upperdeck_start_nodes", "targetname" );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread stairs_team_at_top( node );

	flag_wait( "stairs_upperdeck_civs_dead" );
	flag_wait( "player_set_speed_stairs" );

	nodes = getstructarray( "upperdeck_team_path", "targetname" );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread upperdeck_team_moveup( node );

	flag_wait( "upperdeck_save" );
	if ( !flag( "do_not_save" ) )
		thread autosave_by_name( "upperdeck_flow2" );
}

stairs_saves()
{
	flag_wait( "player_set_speed_lobby" );
	if ( !flag( "do_not_save" ) )
		thread autosave_by_name( "stair_bottom" );
	
	flag_wait( "player_set_speed_upperstairs" );
	if ( !flag( "do_not_save" ) )
		thread autosave_by_name( "stair_top" );
}
/************************************************************************************************************/
/*													MASSACRE												*/
/************************************************************************************************************/
massacre_main()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	thread massacre_restaurant_destroy();

	nodes = getstructarray( "massacre_nodes", "targetname" );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread massacre_killers( node );

	trigger = GetEnt( "massacre_rentacop_rush_guy", "target" );
	trigger.origin += ( 0, 0, -10000 );

	array_thread( GetEntArray( "massacre_dummy", "targetname" ), ::massacre_civ_setup );
	GetEnt( "massacre_snd", "targetname" ) thread massacre_play_sounds();
	array_thread( GetEntArray( "massacre_rentacop_stop", "script_noteworthy" ), ::add_spawn_function, ::massacre_rentacop_stop );
	array_thread( GetEntArray( "massacre_rentacop_rush_guy", "targetname" ), ::add_spawn_function, ::massacre_rentacop_rush_guy );
	array_thread( GetEntArray( "massacre_rentacop_runaway_guy", "script_noteworthy" ), ::add_spawn_function, ::massacre_rentacop_runaway_guy );
	array_thread( GetEntArray( "massacre_rentacop_row1_runner", "script_noteworthy" ), ::add_spawn_function, ::massacre_rentacop_row1_runner );
	array_thread( GetEntArray( "massacre_rentacop_row1_fighter", "script_noteworthy" ), ::add_spawn_function, ::massacre_rentacop_row1_fighter );
	array_thread( GetEntArray( "massacre_rentacop_row1_defender", "script_noteworthy" ), ::add_spawn_function, ::massacre_rentacop_row1_defender );
	array_thread( GetEntArray( "massacre_rentacops_rambo", "script_noteworthy" ), ::add_spawn_function, ::massacre_rentacops_rambo );
	array_thread( GetEntArray( "massacre_rentacops_rear", "targetname" ), ::add_spawn_function, ::massacre_rentacops_rear );
	array_thread( GetEntArray( "massacre_rentacops_stairs", "targetname" ), ::add_spawn_function, ::massacre_rentacops_stairs );

	array_thread( GetEntArray( "massacre_runners1", "script_noteworthy" ), ::add_spawn_function, ::massacre_runners1 );
	array_thread( GetEntArray( "massacre_runners2", "script_noteworthy" ), ::add_spawn_function, ::massacre_runners2, "scn_airport_running_screams1" );
	array_thread( GetEntArray( "massacre_runners3", "script_noteworthy" ), ::add_spawn_function, ::massacre_runners2, "scn_airport_running_screams2" );
	array_thread( GetEntArray( "massacre_crawler", "script_noteworthy" ), ::add_spawn_function, ::massacre_crawler );

	//gate stuff
	array_thread( GetEntArray( "tarmac_littlebird_sniper", "script_noteworthy" ), ::add_spawn_function, ::tarmac_littlebird_sniper );
	array_thread( GetEntArray( "tarmac_littlebird_sniper2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_littlebird_sniper );
	array_thread( GetEntArray( "tarmac_littlebird_pilot", "script_noteworthy" ), ::add_spawn_function, ::set_ignoreme, true );
	
	array_thread( GetEntArray( "tarmac_littlebird_sniper", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	array_thread( GetEntArray( "tarmac_littlebird_sniper2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	array_thread( GetEntArray( "tarmac_littlebird_pilot", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );

	thread massacre_handle_player_speed();
	thread massacre_elevator();
	thread massacre_rentacop_rush_main();

	thread massacre_handle_death_flag( "massacre_runners1", "massacre_runners1_dead" );
	thread massacre_handle_death_flag( "massacre_runners2", "massacre_runners2_dead" );
	thread massacre_handle_death_flag( "massacre_runners3", "massacre_runners3_dead" );

	foreach ( trigger in GetEntArray( "massacre_rentacop_stop_trigs", "targetname" ) )
	{
		trigger add_wait( ::waittill_msg, "trigger" );
		add_func( ::trigger_off, "massacre_rentacop_stop_trigs", "targetname" );
		thread do_wait();
	}
	foreach ( trigger in GetEntArray( "massacre_rentacops_rambo_trigs", "targetname" ) )
	{
		trigger add_wait( ::waittill_msg, "trigger" );
		add_func( ::trigger_off, "massacre_rentacops_rambo_trigs", "targetname" );
		thread do_wait();
	}

	spawners = GetEntArray( "massacre_rentacop_extras", "targetname" );
	level add_wait( ::flag_wait, "massacre_rentacop_rush" );
	add_func( ::array_thread, spawners, ::spawn_ai, true );
	thread do_wait();

	level.team[ "m4" ] add_wait( ::ent_flag_wait, "massacre_firing_into_crowd" );
	add_func( ::flag_set_delayed, "massacre_play_sounds", 1.25 );
	thread do_wait_any();

	level.team[ "m4" ] add_wait( ::ent_flag_wait, "massacre_firing_into_crowd" );
	add_func( ::flag_set_delayed, "massacre_civ_animate", 10 );
	thread do_wait_any();

	trigger_wait( "massacre_rentacops_rear", "target" );

	wait .1;

	add_wait( ::flag_wait, "massacre_rentacop_stop" );
	add_func( ::flag_set, "friendly_fire_pause_flash" );
	thread do_wait();

	ai = get_living_ai_array( "massacre_rentacops_rear", "script_noteworthy" );
	add_wait( ::waittill_dead_or_dying, ai );
	add_func( ::flag_set, "massacre_rentacops_rear_dead" );
	thread do_wait();

	foreach ( actor in ai )
	{
		level add_wait( ::trigger_wait, "massacre_player_too_far", "targetname" );
		actor add_func( ::send_notify, "stop_blindfire" );
		actor add_func( ::anim_stopanimscripted );
		actor add_func( ::set_ignoreall, false );
		actor add_func( ::set_favoriteenemy, level.player );
		actor add_abort( ::waittill_msg, "death" );
		level add_abort( ::flag_wait, "massacre_nadethrow" );
		thread do_wait();
	}

	add_wait( ::flag_wait, "massacre_rentacops_stairs_dead" );
	add_wait( ::flag_wait, "massacre_rentacops_rear_dead" );
	level add_abort( ::flag_wait, "do_not_save" );
	add_func( ::autosave_by_name, "massacre" );
	thread do_wait();

	add_wait( ::flag_wait, "massacre_rentacops_stairs_dead" );
	add_wait( ::flag_wait, "massacre_rentacops_rear_dead" );
	add_wait( ::flag_wait, "massacre_rentacop_runaway_dead" );
	add_wait( ::flag_wait, "massacre_rentacop_row1_fighter_dead" );
	add_wait( ::flag_wait, "massacre_rentacop_row1_runner_dead" );
	add_wait( ::flag_wait, "massacre_rentacop_rambo_dead" );
	add_wait( ::flag_wait, "massacre_runners1_dead" );
	add_wait( ::flag_wait, "massacre_runners2_dead" );
	add_wait( ::flag_wait, "massacre_runners3_dead" );
	add_func( ::flag_set, "gate_main" );
	add_func( ::flag_clear, "friendly_fire_pause_flash" );
	add_func( ::flag_clear, "friendly_fire_pause_fire" );
	thread do_wait();
}

massacre_handle_death_flag( name, _flag )
{
	trigger_wait( name, "target" );

	wait .1;

	ai = get_living_ai_array( name, "script_noteworthy" );

	if ( ai.size )
		waittill_dead_or_dying( ai );

	flag_set( _flag );
}

massacre_handle_player_speed()
{
	flag_wait( "massacre_rentacop_stop_dead" );
	blend_movespeedscale_custom( CONST_SPEEDSECURITY, 1 );

	flag_wait( "massacre_rentacops_rear_dead" );
	blend_movespeedscale_custom( CONST_SPEEDUPPER, 1 );
}

massacre_play_sounds()
{
	flag_wait( "massacre_play_sounds" );

	self PlayLoopSound( "scn_airport_crowd_terminal_loop" );
	flag_wait( "massacre_civ_animate" );

	self StopLoopSound();
	self PlaySound( "scn_airport_crowd_terminal_end" );
}

/************************************************************************************************************/
/*													GATE													*/
/************************************************************************************************************/
gate_main()
{
	add_wait( ::flag_wait, "gate_main" );
	add_func( ::blend_movespeedscale_custom, CONST_TARMAC, 2 );
	thread do_wait();

	add_wait( ::flag_wait, "gate_heli_moveon" );
	add_func( ::delaythread, 1, ::blend_movespeedscale_custom, CONST_TARMACSTAIRS, 2 );
	thread do_wait();

	add_wait( ::flag_wait, "gate_player_off_stairs" );
	add_func( ::blend_movespeedscale_custom, CONST_TARMAC, .5 );
	thread do_wait();

	add_wait( ::trigger_wait, "gate_crawler", "target" );
	add_func( ::flag_set, "gate_canned_deaths" );
	thread do_wait();

	nodes = GetNodeArray( "gate_moveup_nodes", "targetname" );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread gate_moveout( node );

	array_thread( GetEntArray( "gate_canned_deaths", "targetname" ), ::upperdeck_canned_deaths_setup, "gate_canned_deaths" );
	array_thread( GetEntArray( "gate_crawler", "targetname" ), ::add_spawn_function, ::gate_crawler );
	array_thread( GetEntArray( "gate_runners1", "script_noteworthy" ), ::add_spawn_function, ::gate_runners1 );
	array_thread( GetEntArray( "gate_sliders", "script_noteworthy" ), ::add_spawn_function, ::gate_sliders );

	//moved from tarmac
	array_thread( GetEntArray( "tarmac_van_guys", "targetname" ), ::add_spawn_function, ::tarmac_van_guys, "tarmac_van_guys_spawn" );
	array_thread( GetEntArray( "tarmac_van_guys2", "targetname" ), ::add_spawn_function, ::tarmac_van_guys, "tarmac_van_guys2_spawn" );
	GetEnt( "tarmac_swat_van", "targetname" ) add_spawn_function( ::tarmac_van_logic );
	GetEnt( "tarmac_swat_van", "targetname" ) add_spawn_function( ::tarmac_van_stuff, "scn_airport_police_van_arrive1", "tarmac_swat_van" );
	GetEnt( "tarmac_swat_van2", "targetname" ) add_spawn_function( ::tarmac_van_stuff, "scn_airport_police_van_arrive2", "tarmac_swat_van2" );
	GetEnt( "tarmac_swat_van", "targetname" ) thread tarmac_van_fake( "tarmac_swat_van" );
	GetEnt( "tarmac_swat_van2", "targetname" ) thread tarmac_van_fake( "tarmac_swat_van2" );
	
	array_thread( GetEntArray( "gate_convoy_delete", "script_noteworthy" ), ::add_spawn_function, ::gate_convoy_delete );

	//klaxon and gate
	thread gate_events();
	thread gate_departures_status();

	flag_wait( "massacre_rentacops_stairs_dead" );

	level.drs_ahead_test = ::gate_drs_ahead_test;

	//music_stop( 5 );

	level.scr_anim[ "generic" ][ "DRS_run" ]			 = %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "DRS_sprint" ] 		 = %run_lowready_F;
	level.scr_anim[ "generic" ][ "DRS_combat_jog" ]		 = %casual_killer_jog_A;
}

gate_events()
{
	array_thread( GetEntArray( "gate_emerg_lights", "targetname" ), ::gate_klaxon_rotate );
	gate_open_gate();

	flag_wait( "gate_close_gate" );

	activate_trigger( "gate_runners1", "target" );

	gate1 = GetEnt( "gate_gate_closing", "targetname" );
	gate1 delayCall( 5.75, ::playsound, "scn_airport_sec_gate_buzzer" );
	wait 7.75;

	gate_close_gate();
}

/************************************************************************************************************/
/*												BASEMENT													*/
/************************************************************************************************************/
basement_main()
{
	light = GetEnt( "basement_door_light", "targetname" );
	lightintensity = light GetLightIntensity();
	light SetLightIntensity( 0 );

	array_thread( GetEntArray( "gate_drop_chop_guys", "script_noteworthy" ), ::add_spawn_function, ::basement_drop_chop_guys );
	array_thread( GetEntArray( "basement_sec_runner", "targetname" ), ::add_spawn_function, ::basement_sec_runner );
	array_thread( GetEntArray( "basement_flicker_light", "targetname" ), ::basement_flicker_light );

	foreach ( member in level.team )
		member thread basement_pre_moveout();

	flag_wait( "basement_near_entrance" );

	flag_clear( "player_dynamic_move_speed" );
	delayThread( 1, ::blend_movespeedscale_custom, CONST_SPEEDBASEMENT, 1.5 );
	wait 1;
	level.player AllowSprint( true );
	
	struct = getstruct( "scn_airport_emergency_arriving", "targetname" );
	thread play_sound_in_space( "scn_airport_emergency_arriving", struct.origin );
	
	flag_wait( "basement_moveout" );

	level.drs_ahead_test = maps\_utility_code::dynamic_run_ahead_test;
	level.scr_anim[ "generic" ][ "DRS_run" ]			 = undefined;
	
	//level.makarov thread anim_generic( level.makarov, "CornerStndR_alert_signal_stopstay_down" );
	
	wait .5;
	level.makarov dialogue_queue( "airport_mkv_ontime" );
	thread basement_ammo_stuff();
	level.makarov dialogue_queue( "airport_mkv_checkammo" );
	
	wait 1;
	
	level.team[ "m4" ] dialogue_queue( "airport_vkt_beenwaiting" );
	level.makarov thread dialogue_queue( "airport_mkv_haventweall" );	
	
	wait .5;
	
	//basement_makarov_speach();

	thread player_dynamic_move_speed();
	thread blend_movespeedscale_custom( CONST_SPEEDTARMAC2, 1 );

	basement_door_kick( light, lightintensity );

	flag_set( "basement_moveout2" );
	thread airport_vision_basement();

	basement_moveup();
}

basement_ammo_stuff()
{
	wait .5;
	level.makarov.bulletsinclip = 0;
	wait 1;
	level.team[ "saw" ].bulletsinclip = 0;
	wait .5;
	level.team[ "m4" ].bulletsinclip = 0;
	wait .25;
	level.team[ "shotgun" ].bulletsinclip = 0;
}

/************************************************************************************************************/
/*													TARMAC													*/
/************************************************************************************************************/
#using_animtree( "generic_human" );
tarmac_main()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	add_global_spawn_function( "axis", ::tarmac_difficulty_mod );
	//remove_global_spawn_function( "axis", ::disable_blood_pool );
	//remove_global_spawn_function( "neutral", ::disable_blood_pool );
	
	array_thread( GetEntArray( "tarmac_enemies_wave1", "targetname" ), ::add_spawn_function, ::tarmac_enemies_wave1 );
	array_thread( GetEntArray( "tarmac_enemies_wave2", "targetname" ), ::add_spawn_function, ::enable_teamflashbangImmunity );
	array_thread( GetEntArray( "tarmac_enemies_wave2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_enemies_wave2 );
	array_thread( GetEntArray( "tarmac_enemies_runners", "targetname" ), ::add_spawn_function, ::tarmac_enemies_runners );
	array_thread( GetEntArray( "tarmac_enemies_2ndfloor", "targetname" ), ::add_spawn_function, ::tarmac_enemies_2ndfloor );

	array_thread( GetEntArray( "riotshield_group_1", "script_noteworthy" ), ::add_spawn_function, ::tarmac_move_through_smoke );
	array_thread( GetEntArray( "riotshield_group_2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_move_through_smoke );
	array_thread( GetEntArray( "tarmac_wave1_moveoverride", "script_noteworthy" ), ::add_spawn_function, ::tarmac_move_through_smoke );


	array_thread( GetEntArray( "tarmac_security", "targetname" ), ::add_spawn_function, ::tarmac_security );
	array_thread( GetEntArray( "tarmac_security_backup", "script_noteworthy" ), ::tarmac_security_backup );

	thread tarmac_handle_player_too_far();
	thread airport_vision_exterior();

	thread tarmac_riotshield_group( "riotshield_group_1" );
	thread tarmac_riotshield_group( "riotshield_group_2" );
	thread tarmac_riotshield_group_3();
	thread tarmac_riotshield_group_van( "tarmac_van_guys_spawn", "tarmac_swat_van", "tarmac_van_riotshield_guys" );
	thread tarmac_riotshield_group_van( "tarmac_van_guys2_spawn", "tarmac_swat_van2", "tarmac_van_riotshield_guys2" );
	thread tarmac_riotshield_group_van_combine();
	thread tarmac_riotshield_group_last_stand();

	add_wait( ::trigger_wait_targetname, "tarmac_advance3" );
	level.team[ "saw" ] add_func( ::tarmac_kill_friendly );
	thread do_wait();

	add_wait( ::trigger_wait_targetname, "tarmac_advance4" );
	level.team[ "shotgun" ] add_func( ::tarmac_kill_friendly );
	thread do_wait();

	add_wait( ::trigger_wait_targetname, "tarmac_advance8" );
	add_func( ::flag_set, "tarmac_advance8" );
	thread do_wait();

	add_wait( ::flag_wait, "tarmac_moveout" );
	add_func( ::array_thread, getstructarray( "tarmac_smoke_nodes", "targetname" ), ::tarmac_smoke_nodes );
	thread do_wait();

	add_wait( ::flag_wait, "tarmac_hear_fsb" );
	add_func( ::flag_set_delayed, "tarmac_heat_fight", 5 );
	thread do_wait();

	add_wait( ::flag_wait, "tarmac_open_fire" );
	add_func( ::m203_hint );
	thread do_wait();

//	add_wait( ::trigger_wait_targetname, "tarmac_advance1" );
//	add_func( ::music_stop, 15 );
//	thread do_wait();

	add_wait( ::flag_wait, "tarmac_enemies_2ndfloor" );
	add_func( ::tarmac_bsc_2ndfloor );
	add_func( ::tarmac_2ndfloor_group_think );
	thread do_wait();
	
	flag_wait( "tarmac_moveout" );

	if ( !flag( "do_not_save" ) )
		thread autosave_by_name( "tarmac_moveout" );

	nodes = getstructarray( "tarmac_moveout_nodes", "targetname" );
	nodes = array_merge( nodes, GetNodeArray( "tarmac_moveout_nodes", "targetname" ) );
	foreach ( node in nodes )
		level.team[ node.script_noteworthy ] thread tarmac_moveout( node );

	thread tarmac_hide_elevator();
	thread handle_threat_bias_stuff();
	thread tarmac_team_settings();
	thread handle_chatter();

	flag_wait( "tarmac_heat_fight" );
	
	array_thread( level.team, ::GrenadeDangerbsc );
	array_thread( getentarray( "tarmac_bcs_enemy", "targetname" ), ::tarmac_bcs_enemy );
	thread handle_flags_to_advance();
	thread handle_kill_advance();
	thread handle_advance_retreat();
	//thread tarmac_makarov_last_node();
	thread tarmac_escape_music();

	tarmac_autosaves_wait();
}

tarmac_2ndfloor_group_think()
{
	wait .1;
	ai = get_living_ai_array( "tarmac_enemies_2ndfloor", "script_noteworthy" );	
	
	waittill_dead_or_dying( ai, ai.size - 3 );
	
	flag_set( "tarmac_2ndfloor_move_back" );
}


handle_flags_to_advance()
{
	for ( i = 1; i <= 10; i++ )
	{
		name = "tarmac_advance" + i + "_flag";
		trigger = GetEnt( name, "targetname" );
		trigger = GetEnt( trigger.target, "targetname" );

		flag_wait( name );

		//retreat trigger for other team
		if ( IsDefined( trigger.target ) )
			activate_trigger_with_targetname( trigger.target );

		volume = trigger get_color_volume_from_trigger();
		volume waittill_volume_dead_or_dying();

		trigger activate_trigger();
	}
}

handle_chatter()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	flag_wait( "tarmac_hear_fsb" );
	node = getstruct( "tarmac_riot_node_retreat1_group1", "targetname" );

	level thread function_stack( ::play_sound_in_space, "airport_fsb1_moveingo", node.origin );
	level thread function_stack( ::play_sound_in_space, "airport_fsbr_servicetunnels", node.origin );

	flag_wait( "tarmac_heat_fight" );

	//for zakhaev
	if ( !flag( "tarmac_open_fire" ) )
		level.makarov thread dialogue_queue( "airport_mkv_forzakhaev" );

	flag_wait_or_timeout( "tarmac_open_fire", 1 );

	if ( !flag( "tarmac_open_fire" ) )
		tarmac_retreat_dialogue( "airport_fsb2_fsb" );

	flag_wait_or_timeout( "tarmac_open_fire", 5.0 );

	//F.S.B. - Take 'em out.
	if ( !flag( "tarmac_open_fire" ) )
		level.makarov radio_dialogue( "airport_mkv_fsb" );

	flag_wait( "tarmac_open_fire" );

	tarmac_retreat_dialogue( "airport_fsb3_openfire" );

	//battlechatter_on( "allies" );
	battlechatter_on( "axis" );
		
	trigger_wait_targetname( "tarmac_advance1" );
	thread tarmac_bsc_move1();
	
	trigger_wait_targetname( "tarmac_advance2" );
	thread tarmac_bsc_move2();
	
	trigger_wait_targetname( "tarmac_advance3" );
	thread tarmac_bsc_move3();
	
	trigger_wait_targetname( "tarmac_advance4" );
	thread tarmac_bsc_move4();
	
	trigger_wait_targetname( "tarmac_advance5" );
	thread tarmac_bsc_move5();
	
	trigger_wait_targetname( "tarmac_advance6" );
	thread tarmac_bsc_move6();
	
	trigger_wait_targetname( "tarmac_advance7" );
	thread tarmac_bsc_move1();
	
	trigger_wait_targetname( "tarmac_advance8" );
	thread tarmac_bsc_move2();
	
	trigger_wait_targetname( "tarmac_advance9" );
	thread tarmac_bsc_move3b();
	
	trigger_wait_targetname( "tarmac_advance10" );
	thread tarmac_bsc_move4();
}

tarmac_bsc_2ndfloor()
{
	wait 3;
	flag_waitopen( "tarmac_bcs" );
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
	
	flag_set( "tarmac_bcs" );
		makarov dialogue_queue( "contact_2nd_floor" );
		victor dialogue_queue( "contact_2nd_floor" );
	flag_clear( "tarmac_bcs" );		
}

tarmac_bcs_van()
{
	flag_waitopen( "tarmac_bcs" );
	
	makarov = level.makarov;
		
	flag_set( "tarmac_bcs" );
		makarov dialogue_queue( "van_left" );
	flag_clear( "tarmac_bcs" );		
}


tarmac_bsc_move1()
{
	flag_waitopen_or_timeout( "tarmac_bcs", level.CONST_WAIT_TARMAC_BSC );
	if( flag( "tarmac_bcs" ) )
		return;
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
		
	flag_set( "tarmac_bcs" );
		makarov dialogue_queue( "go1" );
		victor dialogue_queue( "moving1" );
	flag_clear( "tarmac_bcs" );	
}

tarmac_bsc_move2()
{
	flag_waitopen_or_timeout( "tarmac_bcs", level.CONST_WAIT_TARMAC_BSC );
	if( flag( "tarmac_bcs" ) )
		return;
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
		
	flag_set( "tarmac_bcs" );
		makarov dialogue_queue( "ready1" );
		victor dialogue_queue( "go2" );
		makarov dialogue_queue( "moving3" );
	flag_clear( "tarmac_bcs" );	
}

tarmac_bsc_move3()
{
	flag_waitopen_or_timeout( "tarmac_bcs", level.CONST_WAIT_TARMAC_BSC );
	if( flag( "tarmac_bcs" ) )
		return;
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
		
	flag_set( "tarmac_bcs" );
		victor dialogue_queue( "ready1" );
		makarov dialogue_queue( "go2" );
		victor dialogue_queue( "moving2" );
	flag_clear( "tarmac_bcs" );	
}

tarmac_bsc_move3b()
{
	flag_waitopen_or_timeout( "tarmac_bcs", level.CONST_WAIT_TARMAC_BSC );
	if( flag( "tarmac_bcs" ) )
		return;
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
		
	flag_set( "tarmac_bcs" );
		victor dialogue_queue( "ready1" );
		makarov dialogue_queue( "go2" );
		victor dialogue_queue( "moving2" );
		
		if( !flag( "tarmac_enemies_2ndfloor_dead" ) && !flag( "tarmac_clear_out_2nd_floor" ) )
			makarov dialogue_queue( "airport_mkv_behindus" );
	flag_clear( "tarmac_bcs" );	
}

tarmac_bsc_move4()
{
	flag_waitopen_or_timeout( "tarmac_bcs", level.CONST_WAIT_TARMAC_BSC );
	if( flag( "tarmac_bcs" ) )
		return;
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
		
	flag_set( "tarmac_bcs" );
		victor dialogue_queue( "go3" );
		makarov dialogue_queue( "moving1" );
	flag_clear( "tarmac_bcs" );	
}

tarmac_bsc_move5()
{
	flag_waitopen_or_timeout( "tarmac_bcs", level.CONST_WAIT_TARMAC_BSC );
	if( flag( "tarmac_bcs" ) )
		return;
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
		
	flag_set( "tarmac_bcs" );
		makarov dialogue_queue( "go3" );
		victor dialogue_queue( "moving3" );
	flag_clear( "tarmac_bcs" );	
	
	level endon( "tarmac_bcs" );
	
	victor waittill( "goal" );
	
	thread tarmac_bsc_move5b();
}

tarmac_bsc_move5b()
{
	makarov = level.makarov;
	victor = level.team[ "m4" ];
	
	flag_set( "tarmac_bcs" );
		victor dialogue_queue( "ready2" );	
	flag_clear( "tarmac_bcs" );
}

tarmac_bsc_move6()
{
	flag_waitopen_or_timeout( "tarmac_bcs", level.CONST_WAIT_TARMAC_BSC );
	if( flag( "tarmac_bcs" ) )
		return;
	
	makarov = level.makarov;
	victor = level.team[ "m4" ];
	
	flag_set( "tarmac_bcs" );
		makarov dialogue_queue( "ready2" );
		victor dialogue_queue( "go1" );
		makarov dialogue_queue( "moving2" );
	flag_clear( "tarmac_bcs" );	
}

handle_kill_advance()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	flag_init( "tarmac_enemies_wave2" );
	trigger = GetEnt( "tarmac_enemies_wave2", "target" );
	thread set_flag_on_trigger( trigger, "tarmac_enemies_wave2" );

	wait .5;

	ai = tarmac_get_enemies();
	add_wait( ::waittill_dead_or_dying, ai, 4 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance1_flag" );
	add_wait( ::flag_wait, "tarmac_enemies_wave2" );
	do_wait_any();

	activate_trigger_with_targetname( "tarmac_advance1_flag" );

	ai = tarmac_get_enemies();
	add_wait( ::waittill_dead_or_dying, ai, 3 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance2_flag" );
	add_wait( ::flag_wait, "tarmac_enemies_wave2" );
	do_wait_any();

	activate_trigger_with_targetname( "tarmac_advance2_flag" );

	ai = tarmac_get_enemies();
	add_wait( ::waittill_dead_or_dying, ai, 3 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance3_flag" );
	add_wait( ::flag_wait, "tarmac_enemies_wave2" );
	do_wait_any();

	activate_trigger_with_targetname( "tarmac_advance3_flag" );

	flag_wait( "tarmac_enemies_wave2" );
	wait .5;

	ai = tarmac_get_enemies();
	add_wait( ::waittill_dead_or_dying, ai, 3 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance4_flag" );
	do_wait_any();

	//this moves them up to the windows
	activate_trigger_with_targetname( "tarmac_advance4_flag" );

	flag_wait( "tarmac_van_guys2_spawn" );

	ai = tarmac_get_enemies();
	num = 3;
	if ( ai.size > 13 )
		num = ai.size - 10;

	add_wait( ::waittill_dead_or_dying, ai, num );
	add_wait( ::trigger_wait_targetname, "tarmac_advance6_flag" );
	do_wait_any();

	//this moves them up to the otherside of the underpass
	activate_trigger_with_targetname( "tarmac_advance6_flag" );

	ai = tarmac_get_enemies();
	add_wait( ::waittill_dead_or_dying, ai, 3 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance7_flag" );
	do_wait_any();

	//this moves them up a little past the underpass
	activate_trigger_with_targetname( "tarmac_advance7_flag" );

	ai = tarmac_get_enemies();
	add_wait( ::waittill_dead_or_dying, ai, 3 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance8_flag" );
	do_wait_any();

	activate_trigger_with_targetname( "tarmac_advance8_flag" );

	ai = array_removeDead( ai );
	add_wait( ::waittill_dead_or_dying, ai, 3 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance9_flag" );
	do_wait_any();

	activate_trigger_with_targetname( "tarmac_advance9_flag" );

	ai = array_removeDead( ai );
	add_wait( ::waittill_dead_or_dying, ai, 3 );
	add_wait( ::trigger_wait_targetname, "tarmac_advance10_flag" );
	do_wait_any();

	activate_trigger_with_targetname( "tarmac_advance10_flag" );
}

handle_advance_retreat()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	trigger = GetEnt( "tarmac_advance6", "targetname" );
	thread set_flag_on_trigger( trigger, "tarmac_advance6" );

	trigger_wait( "tarmac_retreat1", "targetname" );
	flag_set( "tarmac_retreat1" );

	tarmac_retreat_dialogue( "airport_fsb2_aimforhead" );

	trigger_wait( "tarmac_retreat2", "targetname" );
	flag_set( "tarmac_retreat2" );

	tarmac_retreat_dialogue( "airport_fsb3_aimforheads" );

	trigger_wait( "tarmac_retreat3", "targetname" );
	flag_set( "tarmac_retreat3" );

	tarmac_retreat_dialogue( "airport_fsbr_sendingtruck" );

	trigger_wait( "tarmac_retreat4", "targetname" );
	flag_set( "tarmac_retreat4" );
	flag_set( "tarmac_advance4" );

	trigger_wait( "tarmac_retreat5", "targetname" );
	flag_set( "tarmac_retreat5" );

	trigger_wait( "tarmac_retreat6", "targetname" );
	flag_set( "tarmac_retreat6" );
}

tarmac_retreat_dialogue( alias )
{
	array = tarmac_get_enemies();
	if ( !array.size )
		return;

	guy = random( array );
	guy.animname = "generic";
	guy thread dialogue_queue( alias );
}

tarmac_team_settings()
{
	delayThread( 1, ::blend_movespeedscale_custom, CONST_SPEEDTARMAC2, 1 );

	add_wait( ::flag_wait, "tarmac_pre_heat_fight" );
	level.player add_call( ::allowsprint, true );
	level.player add_call( ::allowjump, true );
	add_func( ::delaythread, .1, ::blend_movespeedscale_custom, CONST_SPEEDTARMAC3, 1 );
	add_func( ::flag_clear, "player_dynamic_move_speed" );
	add_abort( ::flag_wait, "tarmac_heat_fight" );
	thread do_wait();

	flag_wait( "tarmac_heat_fight" );

	thread blend_movespeedscale_custom( 100, 5 );
	level.player AllowSprint( true );
	flag_clear( "player_dynamic_move_speed" );
	thread flag_set_delayed( "tarmac_open_fire", 8 );

	SetSavedDvar( "ai_friendlyFireBlockDuration", 2000 );

	flag_set( "friendly_fire_pause_flash" );
	flag_set( "friendly_fire_pause_fire" );
}

/************************************************************************************************************/
/*													ESCAPE													*/
/************************************************************************************************************/
escape_main()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );

	GetEnt( "escape_van_dummy", "targetname" ) add_spawn_function( ::escape_van_setup, "escape_van" );
	GetEnt( "escape_van_driver", "script_noteworthy" ) add_spawn_function( ::escape_van_driver );
	GetEnt( "escape_van_mate", "script_noteworthy" ) add_spawn_function( ::escape_van_mate );

	array_thread( GetEntArray( "escape_final_guys", "targetname" ), ::add_spawn_function, ::escape_final_guys );
	array_thread( GetEntArray( "escape_final_guys2", "targetname" ), ::add_spawn_function, ::escape_final_guys2 );
	array_thread( GetEntArray( "escape_police_car_guys", "script_noteworthy" ), ::add_spawn_function, ::escape_police_car_guys );


	trigger_off( "escape_get_in_trig", "targetname" );

	flag_wait( "tarmac_enemies_wave1_dead" );
	flag_wait( "tarmac_enemies_wave2_dead" );
	flag_wait( "tarmac_van_guys_dead" );
	flag_wait( "tarmac_van_guys2_dead" );

	activate_trigger( "escape_van_spawn", "targetname" );
	delayThread( .05, ::activate_trigger, "escape_van_guy", "target" );

	thread airport_vision_escape();

	wait .5;

	flag_set( "escape_main" );
	thread battlechatter_off();
	
	escape_setup_variables();

	escape_create_survivors();

	foreach ( member in level.survivors )
	{
		member disable_heat_behavior();
		member disable_ai_color();
		member.ignoreall = true;
		member.ignoreme = true;
		member.fixednode = 0;
		member.fixednodewason = 0;
	}
	level.makarov PushPlayer( true );

	thread radio_dialogue( "airport_mkv_30secs" );

	nodes = GetNodeArray( "escape_start_nodes", "targetname" );
	escape_survivors_follow_path( nodes, 325 );

	level.makarov waittill( "reached_path_end" );

	thread radio_dialogue( "airport_mkv_thisway" );
	nodes = GetNodeArray( "escape_moveup_1", "targetname" );
	escape_survivors_follow_path( nodes, 300 );

	if ( level.survivors.size > 1 )
	{
		level.comrad = level.survivors[ "1" ];
		actor = level.survivors[ "1" ];
		actor add_wait( ::waittill_msg, "reached_path_end" );
		level add_abort( ::flag_wait, "escape_sequence_reach" );
		actor add_func( ::delaythread, .5, ::anim_generic, actor, "CornerStndR_alert_signal_move_out" );
		thread do_wait();
	}

	level.makarov waittill( "reached_path_end" );

	foreach ( member in level.survivors )
		member PushPlayer( true );

	node = undefined;
	foreach ( part in nodes )
	{
		if ( part.script_noteworthy != "makarov" )
			continue;
		node = part;
		break;
	}

	door = GetEnt( "escape_door", "targetname" );
	door thread escape_palm_style_door_open( "door_wood_slow_creaky_open" );
//	door thread palm_style_door_open( "door_wood_slow_creaky_open" );
	node = getstruct( "escape_slow_open_node", "targetname" );
	level.makarov enable_cqbwalk();
	level.makarov disable_exits();
	node anim_generic_run( level.makarov, "hunted_open_barndoor_flathand" );

	level.makarov delayThread( 1, ::disable_cqbwalk );
	level.makarov delayThread( 1, ::enable_exits );

	flag_set( "escape_doorkick" );

	node = GetNode( "escape_moveup_1b", "targetname" );
	level.makarov follow_path( node, 260 );
	
	
					
	array_thread( level.team, ::enable_cqbwalk );
	array_thread( level.team, ::delaythread, 4, ::disable_cqbwalk );
	level.makarov delaythread( 3.5, ::dialogue_queue, "airport_mkv_hallway" );

	
		
		
	escape_end_sequence();

	wait 2;
	activate_trigger( "escape_final_guys", "target" );
	delayThread( 1.5, ::activate_trigger, "escape_police_trig", "targetname" );

	thread escape_set_end_vision();

	wait 10;

	if ( is_default_start() )
		nextmission();
	else
		IPrintLnBold( "DEVELOPER: END OF SCRIPTED LEVEL" );
}

escape_palm_style_door_open( soundalias )
{
	/*wait( 1.35 );

	if ( IsDefined( soundalias ) )
		self PlaySound( soundalias );
	else
		self PlaySound( "door_wood_slow_open" );

	self RotateTo( self.angles + ( 0, 70, 0 ), 2, .5, 0 );
	self ConnectPaths();
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 30, 0 ), 1.5, 0, 1.5 );*/
	wait( 1.35 );

	if ( IsDefined( soundalias ) )
		self PlaySound( soundalias );
	else
		self PlaySound( "door_wood_slow_open" );

	self RotateTo( self.angles + ( 0, 70, 0 ), 2, .5, 0 );
	self ConnectPaths();
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 40, 0 ), 1.5, 0, 1.5 );
}

escape_end_sequence()
{
	flag_waitopen( "friendly_fire_warning" );
	level endon( "friendly_fire_warning" );
	level notify( "friendly_fire_stop_checking_for_player_dist" );

	flag_set( "escape_sequence_reach" );
	thread airport_vision_makarov();
	
	level.comrad.animname = "comrad";
	team = [];
	team[ team.size ] = level.makarov;
	team[ team.size ] = level.comrad;

	//makarov putting his "hold" hand signal up
	level.makarov add_wait( ::waittill_msg, "goal" );
	level.makarov add_func( ::anim_single_solo, level.makarov, "stand_exposed_wave_halt_v2" );
	level.makarov add_func( ::delaythread, .05, ::dialogue_queue, "airport_mkv_holdfire" );
	add_func( ::flag_set, "escape_hold_your_fire" );
	add_abort( ::flag_wait, "friendly_fire_warning" );
	thread do_wait();

	array_thread( team, ::escape_relax );

	//wait for both guys to reach their spot	
	level.makarov.moveplaybackrate = 1.0;
	level.comrad.moveplaybackrate = 1.0;

	node = getstruct( "escape_ending_node", "targetname" );
	node anim_reach_and_approach( team, "end_get_in" );

	level.makarov.moveplaybackrate = 1.0;
	level.comrad.moveplaybackrate = 1.0;
	//wait for player to be in place

	escape_end_wait_until_player_is_in_position();

	backdoor = GetEnt( "escape_door_behind", "targetname" );
	backdoor RotateYaw( 90, 3, 0, 3 );

	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	thread lerp_savedDvar( "r_lightGridIntensity", .75, 2.0 );
		
	flag_set( "escape_sequence_go" );
	trigger = GetEnt( "escape_nojump", "targetname" );
	trigger thread escape_player_disable_jump_n_weapon();

	//get the van
	van = level.escape_van_dummy;
		
	//get guys in van
	van notify( "stop_loop" );
	array_thread( team, ::anim_stopanimscripted );

	//setup idles to play once guy's are in
	level.comrad add_wait( ::_waittillmatch, "single anim", "end" );
	van add_func( ::anim_loop_solo, level.comrad, "end_get_in_idle", "stop_loop", "origin_animate_jnt" );
	thread do_wait();
	waittillframeend;

//	thread music_stop( 7 );
	
	level.vanmate thread end_vanmate_dialogue();
	
	//Van Terrorist	Good, you made it! Get in.	
	foreach ( member in team )
		member LinkTo( van, "tag_body" );
	team[ team.size ] = level.vanmate;
		
	van thread anim_single( team, "end_get_in" );
	van thread van_opendoors();
	
	
//	gun = spawn_anim_model( "ending_weap" );
//	van thread anim_single_solo( gun, "end_get_in" );
			
	delay = 0.25;
	length = GetAnimLength( level.vanmate getanim( "end_get_in" ) );
	flag_wait( "end_player_ready" );
	flag_set( "escape_player_get_in" );

//	delayThread( delay, ::music_doublecross );
	
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player setstance( "stand" );
	
	thread escape_slow_mo();
	
	//GET THE PLAYER IN	
	thread grab_player_if_he_gets_close();
	flag_wait( "end_makarov_in_place" );
	
	if ( flag( "player_ready_for_proper_ending" ) )
		escape_animate_player_death();
	else
		escape_animate_player_death2();
	
	//level.makarov delayThread( 1, ::dialogue_queue, "airport_mkv_thiswill" );
	
	node = GetVehicleNode( "escape_van_leave_node", "targetname" );

	thread escape_van_drive_away( node );

	if ( !flag( "escape_player_realdeath" ) )
		level.makarov SetLookAtEntity( level.player );
	else 
		level.makarov SetLookAtEntity();
		
	delayThread( GetAnimLength( level.makarov getanim( "end_drive_away" ) ) - 2.0, ::activate_trigger, "escape_final_guys2", "target" );

	van thread anim_loop_solo( level.vanmate, "end_get_in_idle", "stop_loop", "origin_animate_jnt" );
	van thread van_closedoors();
	
	time = GetAnimLength( level.makarov getanim( "end_drive_away" ) );
	delaythread( time - 1, ::radio_dialogue, "airport_mkv_allofrussia" );
	
	van anim_single_solo( level.makarov, "end_drive_away", "origin_animate_jnt" );
		
	level.makarov stop_magic_bullet_shield();
	level.makarov Delete();
}

escape_slow_mo()
{
	flag_wait( "end_player_ready" );
		
	wait 1.25;
		
	slowmo_start();
		slowmo_setspeed_slow( .85 );
		slowmo_setlerptime_in( 0 );
		slowmo_lerp_in();
		
		wait 3;	

		slowmo_setlerptime_out( 0 );
		slowmo_lerp_out();
	slowmo_end();
}

end_vanmate_dialogue()
{
	self waittillmatch( "single anim", "dialog" );
	self playsound( "airport_vt_madeit" );
	
	self waittillmatch( "single anim", "dialog" );
	self playsound( "airport_vt_beenough" );
}

escape_van_drive_away( node )
{
	//get the van
	van = level.escape_van_dummy;
	
	level.escape_van_dummy delayCall( 3, ::playsound, "scn_ambulance_start_away" );
	wait 5.0;

	level.escape_van_dummy delayCall( 0, ::attachPath, node );
	level.escape_van_dummy delayCall( 0, ::StartPath );
}

escape_kill_player( guy )
{
	if ( level.start_point == "grigs" )
		return;
	if( flag( "escape_player_shot" ) )
		return;

	flag_set( "escape_player_shot" );

	time_hit_ground = .5;
	white_out_time = 6;
	//breathing
	level.player delayThread( .1, 	::play_sound_on_entity, "breathing_hurt_start" );
	level.player delayThread( time_hit_ground, 	::play_sound_on_entity, "breathing_hurt" );
	level.player delayThread( 3, 	::play_sound_on_entity, "breathing_hurt" );
	level.player delayThread( 6, 	::play_sound_on_entity, "breathing_hurt" );
	level.player delayThread( 9, 	::play_sound_on_entity, "breathing_hurt" );

	//heartbeat	
	level.player delayThread( 1.5, 	::play_sound_on_entity, "breathing_heartbeat" );
	level.player delayThread( 3, 	::play_sound_on_entity, "breathing_heartbeat" );
	level.player delayThread( 5, 	::play_sound_on_entity, "breathing_heartbeat" );
	level.player delayThread( 8, 	::play_sound_on_entity, "breathing_heartbeat" );
	level.player delayThread( 12, 	::play_sound_on_entity, "breathing_heartbeat" );
	level.player delayThread( 17, 	::play_sound_on_entity, "breathing_heartbeat" );

	//sound ducking
	//level.player delayCall( white_out_time, ::shellshock, "airport", 10, true );

	//rumble
//	level.player delayCall( .05, 	::PlayRumbleOnEntity, "damage_heavy" );
//	level.player delayCall( time_hit_ground, 		::PlayRumbleOnEntity, "tank_rumble" );

	level.player.health = 100;
	level.player DoDamage( 90, level.makarov GetTagOrigin( "tag_flash" ), level.makarov );

	white 	 = create_client_overlay( "white", 1 );
	white thread fade_over_time( 0, .5 );

	set_vision_set( "airport_death", 10 );
}

escape_set_end_vision( guy )
{
	white 	 = create_client_overlay( "white", 0 );
	white fade_over_time( 1, 9.75 );
}

/************************************************************************************************************/
/*												INITIALIZATIONS												*/
/************************************************************************************************************/

start_intro()
{
	start_common_airport();
	thread battlechatter_off( "allies" );
}

start_stairs()
{
	start_common_airport();
	intro_setup_dead_bodies();
	thread battlechatter_off( "allies" );
	trigger_off( "lobby_to_stairs_flow", "target" );

	nodes = GetNodeArray( "prestairs_nodes", "targetname" );
	ap_teleport_player();
	ap_teleport_team( nodes );
	thread airport_vision_intro( true );

	thread blend_movespeedscale_custom( CONST_SPEEDLOBBY2 );

	add_wait( ::flag_wait, "player_set_speed_stairs" );
	add_func( ::blend_movespeedscale_custom, CONST_SPEEDSTAIRS, .25 );
	thread do_wait();

	add_wait( ::flag_wait, "player_set_speed_upperstairs" );
	add_func( ::blend_movespeedscale_custom, CONST_SPEEDUPPER, 1 );
	thread do_wait();

	foreach ( node in nodes )
	{
		level.team[ node.script_noteworthy ] OrientMode( "face angle", node.angles[ 1 ] );
		level.team[ node.script_noteworthy ] enable_calm_combat();
		level.team[ node.script_noteworthy ].ignoreall = false;
		level.team[ node.script_noteworthy ] thread ent_flag_set_delayed( "prestairs_nodes", .5 );
		level.team[ node.script_noteworthy ] thread lobby_prestairs_nodes_behavior( node );
	}
	thread flag_set_delayed( "player_set_speed_lobby", .5 );
	thread flag_set_delayed( "stairs_go_up", 1 );
	thread flag_clear_delayed( "_escalator_on", 1 );
//	music_stalk();
	music_alternate();
}

glass_break_snds()
{
	glassID = getglass( self.targetname );
	
	level waittillmatch( "glass_destroyed", glassID );
	
	play_sound_in_space( "scn_airport_skylight_glass", self.origin );
}

escalator_sounds()
{
	snds = [];
	snds[ snds.size ] = spawn( "script_origin", ( 5462.39, 2109.26, 76.125 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 5462.84, 2213.88, 160.665 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 5460.75, 2403.88, 314.567 ) );
	
	snds[ snds.size ] = spawn( "script_origin", ( 5287.93, 2410.17, 316.125 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 5288.17, 2243.88, 184.175 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 5284.99, 2103.88, 68.6544 ) );
	
	snds[ snds.size ] = spawn( "script_origin", ( 5104.29, 2009.68, 68.125 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 5009.83, 2106.67, 180.125 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 4889.42, 2225.57, 308.96 ) );
	
	snds[ snds.size ] = spawn( "script_origin", ( 4766.84, 2102.98, 310.171 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 4871.84, 1995.85, 195.639 ) );
	snds[ snds.size ] = spawn( "script_origin", ( 4987.36, 1885.09, 64.9956 ) );
	
	foreach( snd in snds )
		snd thread play_loop_sound_on_entity( "emt_airport_escalator" );
	
	flag_waitopen( "_escalator_on" );
	
	foreach( snd in snds )
		snd stop_loop_sound_on_entity( "emt_airport_escalator" );
	foreach( snd in snds )
		snd thread play_sound_on_entity( "emt_airport_escalator_stop" );
}

start_massacre()
{
	start_common_airport();
	intro_setup_dead_bodies();
	thread massacre_team_dialogue();
	thread airport_vision_stairs( true );
	trigger_off( "upperdeck_runners2", "target" );
	trigger_off( "upperdeck_runners4", "target" );
	trigger_off( "upperdeck_runners1b", "target" );
	trigger_off( "upperdeck_runners1c", "target" );
	array_thread( GetEntArray( "upperdeck_runners3", "script_noteworthy" ), ::add_spawn_function, ::upperdeck_runners3 );

	thread battlechatter_off( "allies" );

	ap_teleport_player();
	ap_teleport_team( getstructarray( "massacre_start_nodes", "targetname" ) );

	thread blend_movespeedscale_custom( CONST_SPEEDUPPER );

	foreach ( actor in level.team )
	{
		actor thread ent_flag_set_delayed( "massacre_ready", .5 );
		actor.goalradius = 8;
		actor.moveplaybackrate = 1.3;
		actor.ignoreall = false;
		actor enable_calm_combat();
	}
	//music_stalk();
	music_alternate();
}

start_gate()
{
	start_common_airport();
	intro_setup_dead_bodies();
	trigger_off( "massacre_rentacops_rear", "target" );
	trigger_off( "massacre_rentacops_stairs", "target" );
	trigger_off( "massacre_runners1", "target" );
	trigger_off( "massacre_runners2", "target" );
	trigger_off( "massacre_runners3", "target" );
	trigger_off( "upperdeck_runners3", "target" );
	trigger_off( "upperdeck_runners4", "target" );
	trigger_off( "upperdeck_runners2", "target" );
	trigger_off( "upperdeck_runners1b", "target" );
	trigger_off( "upperdeck_runners1c", "target" );

	flag_set( "massacre_rentacops_stairs_dead" );
	flag_set( "massacre_rentacops_rear_dead" );

	thread battlechatter_off( "allies" );
	ap_teleport_player();
	ap_teleport_team( getstructarray( "gate_start_nodes", "targetname" ) );

	flag_set( "gate_main" );
	foreach ( actor in level.team )
	{
		actor thread ent_flag_set_delayed( "gate_ready_to_go", .5 );
	}
	//music_stalk();
	//music_stop( 5 );
	//music_HZ_airport();
}

start_basement()
{
	start_common_airport();
	thread battlechatter_off( "allies" );

	array_thread( GetEntArray( "tarmac_littlebird_sniper", "script_noteworthy" ), ::add_spawn_function, ::tarmac_littlebird_sniper );
	array_thread( GetEntArray( "tarmac_littlebird_sniper2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_littlebird_sniper );
	array_thread( GetEntArray( "tarmac_littlebird_pilot", "script_noteworthy" ), ::add_spawn_function, ::set_ignoreme, true );
	
	array_thread( GetEntArray( "tarmac_littlebird_sniper", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	array_thread( GetEntArray( "tarmac_littlebird_sniper2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	array_thread( GetEntArray( "tarmac_littlebird_pilot", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	
	array_thread( GetEntArray( "gate_convoy_delete", "script_noteworthy" ), ::add_spawn_function, ::gate_convoy_delete );

	//moved from tarmac
	array_thread( GetEntArray( "tarmac_van_guys", "targetname" ), ::add_spawn_function, ::tarmac_van_guys, "tarmac_van_guys_spawn" );
	array_thread( GetEntArray( "tarmac_van_guys2", "targetname" ), ::add_spawn_function, ::tarmac_van_guys, "tarmac_van_guys2_spawn" );
	GetEnt( "tarmac_swat_van", "targetname" ) add_spawn_function( ::tarmac_van_logic );
	GetEnt( "tarmac_swat_van", "targetname" ) add_spawn_function( ::tarmac_van_stuff, "scn_airport_police_van_arrive1", "tarmac_swat_van" );
	GetEnt( "tarmac_swat_van2", "targetname" ) add_spawn_function( ::tarmac_van_stuff, "scn_airport_police_van_arrive2", "tarmac_swat_van2" );
	GetEnt( "tarmac_swat_van", "targetname" ) thread tarmac_van_fake( "tarmac_swat_van" );
	GetEnt( "tarmac_swat_van2", "targetname" ) thread tarmac_van_fake( "tarmac_swat_van2" );

	ap_teleport_player();
	ap_teleport_team( getstructarray( "basement_start_nodes", "targetname" ) );

	thread blend_movespeedscale_custom( CONST_TARMAC );
	level.drs_ahead_test = ::gate_drs_ahead_test;

	flag_set( "gate_main" );
	flag_set( "gate_heli_moveon" );

	music_anticipation();

	activate_trigger_with_targetname( "gate_heli_1" );

	flag_wait( "team_initialized" );

	array = [];
	array[ array.size ] = GetNode( "basement_start_makarov", "targetname" );
	array[ array.size ] = GetNode( "basement_start_shotgun", "targetname" );
	array[ array.size ] = GetNode( "basement_start_saw", "targetname" );
	array[ array.size ] = GetNode( "basement_start_m4", "targetname" );

	wait .2;

	foreach ( member in level.team )
	{
		member enable_calm_combat();
		member.ignoreall = true;
		member.ignoreme = true;
		member.moveplaybackrate = 1.2;
		member disable_arrivals();
		member disable_exits();
		member thread gate_do_jog2();
		member.goalradius = 16;
	}

	foreach ( node in array )
		level.team[ node.script_noteworthy ] thread follow_path( node );
}

start_tarmac()
{
	start_common_airport();
	intro_setup_dead_bodies();
	thread battlechatter_off( "allies" );

	array_thread( GetEntArray( "tarmac_littlebird_sniper", "script_noteworthy" ), ::add_spawn_function, ::tarmac_littlebird_sniper );
	array_thread( GetEntArray( "tarmac_littlebird_sniper2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_littlebird_sniper );
	array_thread( GetEntArray( "tarmac_littlebird_pilot", "script_noteworthy" ), ::add_spawn_function, ::set_ignoreme, true );
	
	array_thread( GetEntArray( "tarmac_littlebird_sniper", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	array_thread( GetEntArray( "tarmac_littlebird_sniper2", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	array_thread( GetEntArray( "tarmac_littlebird_pilot", "script_noteworthy" ), ::add_spawn_function, ::tarmac_heli_bc_off );
	

	//moved from tarmac
	array_thread( GetEntArray( "tarmac_van_guys", "targetname" ), ::add_spawn_function, ::tarmac_van_guys, "tarmac_van_guys_spawn" );
	array_thread( GetEntArray( "tarmac_van_guys2", "targetname" ), ::add_spawn_function, ::tarmac_van_guys, "tarmac_van_guys2_spawn" );
	GetEnt( "tarmac_swat_van", "targetname" ) add_spawn_function( ::tarmac_van_logic );
	GetEnt( "tarmac_swat_van", "targetname" ) add_spawn_function( ::tarmac_van_stuff, "scn_airport_police_van_arrive1", "tarmac_swat_van" );
	GetEnt( "tarmac_swat_van2", "targetname" ) add_spawn_function( ::tarmac_van_stuff, "scn_airport_police_van_arrive2", "tarmac_swat_van2" );
	GetEnt( "tarmac_swat_van", "targetname" ) thread tarmac_van_fake( "tarmac_swat_van" );
	GetEnt( "tarmac_swat_van2", "targetname" ) thread tarmac_van_fake( "tarmac_swat_van2" );
	
	ap_teleport_player();
	ap_teleport_team( getstructarray( "tarmac_start_nodes", "targetname" ) );

	thread blend_movespeedscale_custom( CONST_TARMAC );

	flag_set_delayed( "tarmac_moveout", .1 );
	flag_set( "gate_main" );
	flag_set( "gate_heli_moveon" );
	flag_set( "basement_moveout" );

	music_anticipation();

	activate_trigger_with_targetname( "gate_heli_1" );
	activate_trigger_with_targetname( "basement_heli_1" );

	activate_trigger_with_targetname( "tarmac_van_dummy_spawn_trig" );
	delayThread( .2, ::activate_trigger, "tarmac_security", "target" );

}

start_escape()
{
	start_common_airport();
	intro_setup_dead_bodies();

	thread battlechatter_off( "allies" );
	thread airport_vision_exterior( true );

	flag_wait( "team_initialized" );

	foreach ( member in level.team )
	{
		member enable_heat_behavior();
		member PushPlayer( false );
	}
	level.team[ "saw" ] stop_magic_bullet_shield();
	level.team[ "shotgun" ] stop_magic_bullet_shield();
	level.team[ "saw" ] Kill();
	level.team[ "shotgun" ] Kill();
	level.team = array_removeDead_keepkeys( level.team );

	ap_teleport_player();
	ap_teleport_team( getstructarray( "escape_start_nodes", "targetname" ) );

	level.player AllowSprint( true );
	thread blend_movespeedscale_custom( 100 );

	music_escape();

	flag_set( "tarmac_enemies_wave1_dead" );
	flag_set( "tarmac_enemies_wave2_dead" );
	flag_set( "tarmac_van_guys_dead" );
	flag_set( "tarmac_van_guys2_dead" );
	
	level.player allowjump( true );
	level.player allowsprint( true );
}

start_grigs()
{
	start_common_airport();
	thread battlechatter_off( "allies" );
	thread airport_vision_exterior( true );

	wait .1;

	grigs_test();
}

grigs_test()
{
	list = [];

	list[ list.size ] = "m4_grunt";
	list[ list.size ] = "saw_reflex";
	list[ list.size ] = "saw";
	list[ list.size ] = "saw_acog";
	list[ list.size ] = "mp5";
	list[ list.size ] = "ump45";
	list[ list.size ] = "g36c";
	list[ list.size ] = "g36c_acog";
	list[ list.size ] = "g36c_grenadier";
	list[ list.size ] = "g36c_reflex";
	list[ list.size ] = "striker";

	node = getstruct( "escape_ending_node", "targetname" );
	level.escape_van_dummy = Spawn( "script_model", node.origin );
	level.escape_van_dummy.angles = node.angles;
	level.escape_van_dummy SetModel( "vehicle_ambulance_swat" );
	level.vanmate = level.team[ "saw" ];
	level.vanmate.animname = "van_mate";
	level.comrad = level.team[ "m4" ];
	level.comrad.animname = "comrad";

	level.player enablePlayerWeapons( false );

	while ( 1 )
	{
		foreach ( weapon in list )
		{
			store_current_weapon( weapon );
			escape_animate_player_death();
			wait 4;
		}
	}
}

start_common_airport()
{
	thread escalator_sounds();
	array_thread( getstructarray( "glass_break_snd", "script_noteworthy" ), ::glass_break_snds );
//	add_global_spawn_function( "axis", ::disable_blood_pool );
//	add_global_spawn_function( "neutral", ::disable_blood_pool );

	array_thread( GetEntArray( "team", "targetname" ), ::add_spawn_function, ::team_init );
	activate_trigger( "team", "target" );
	thread flag_set_delayed( "team_initialized", .05 );

	thread player_init();

	ai = GetAIArray( "allies" );
	foreach ( actor in ai )
	{
		if ( actor is_hero() )
			continue;
		actor Delete();
	}

	thread battlechatter_off( "axis" );

	array = GetEntArray( "massacre_dummy", "targetname" );
	foreach ( obj in array )
		obj Hide();

	array = GetEntArray( "gate_canned_deaths", "targetname" );
	foreach ( obj in array )
		obj Hide();

	array = GetEntArray( "upperdeck_canned_deaths", "targetname" );
	foreach ( obj in array )
	{
		obj Hide();
		if ( IsDefined( obj.target ) )
		{
			temp = GetEnt( obj.target, "targetname" );
			temp Hide();
		}
	}

	thread objective();
	thread friendly_fire();
	
	flag_init( "trigger_kill_player" );
	trigs = getentarray( "kill_player", "targetname" );
	
	foreach( trig in trigs )
		thread set_flag_on_trigger( trig, "trigger_kill_player" );
	
	thread kill_player();
	thread good_save_handler();

	delayThread( .5, ::player_dynamic_move_speed );

	sign_departure_status_init();

	array = array_randomize( level.departure_status_array );
	array[ 0 ] thread sign_departure_status_flip_to( "arriving" );
	array[ 1 ] thread sign_departure_status_flip_to( "arriving" );
	array[ 2 ] thread sign_departure_status_flip_to( "arriving" );
	array[ 3 ] thread sign_departure_status_flip_to( "boarding" );
	array[ 4 ] thread sign_departure_status_flip_to( "boarding" );
}

objective()
{
			// Don't blow your cover.
	level.strings[ "OBJ_COVER" ]		 = &"AIRPORT_OBJ_COVER";
		// Don't blow your cover... at any cost.
	level.strings[ "OBJ_COVER_COST" ]	 = &"AIRPORT_OBJ_COVER_COST";
		// Don't blow your cover and earn Makarov's trust.
	level.strings[ "OBJ_COVER_TRUST" ]	 = &"AIRPORT_OBJ_COVER_TRUST";
			// Earn Makarov's trust.
	level.strings[ "OBJ_TRUST" ]		 = &"AIRPORT_OBJ_TRUST";
		// Follow Makarov's lead.
	level.strings[ "OBJ_TRUST_COST" ]	 = &"AIRPORT_OBJ_TRUST_COST";
		// Get in the van.
	level.strings[ "OBJ_GET_IN_VAN" ]	 = &"AIRPORT_OBJ_GET_IN_VAN";

				// Press ^3[{+gostand}]^7 to 
	level.strings[ "mantle" ]			 = &"SCRIPT_MANTLE";

	foreach ( string in level.strings )
		PreCacheString( string );

	if ( is_default_start() )
		wait 24 + 5.5;
	else
		wait .05;

	Objective_Add( 1, "active", level.strings[ "OBJ_TRUST_COST" ] );
	Objective_Current( 1 );

	objective_get_pos();

	/*trigger = GetEnt( "escape_nojump", "targetname" );
	Objective_Add( 2, "active", level.strings[ "OBJ_GET_IN_VAN" ], trigger.origin );
	Objective_Current( 2 );

	flag_wait( "escape_player_is_in" );

	Objective_State( 1, "done" );
	Objective_State( 2, "done" );*/
}

objective_get_pos()
{
	level endon( "escape_player_get_in" );

	objective_onentity( 1, level.makarov, ( 0,0,80 ) );
	
	flag_wait( "end_get_in_the_van" );
}

airport_music()
{
	flag_init( "airport_alternate" );
	flag_init( "airport_anticipation" );
	flag_init( "airport_escape" );	
	
	switch ( level.start_point )
	{
		case "default":
		case "start_intro":
		case "stairs":
		case "massacre":
			flag_wait( "airport_alternate" );
			music_loop( "airport_alternate", 212 );
			/#
			println( " *** MUSIC: airport_alternate *** " );
			#/
		case "gate":
		case "basement":
		case "tarmac":
			flag_wait( "airport_anticipation" );
			thread music_stop( 1 );
			thread music_sfx_to_music( "airport_anticipation", 308, undefined, 306 );
			/#
			println( " *** MUSIC: airport_anticipation *** " );
			#/
		case "escape":
			flag_wait( "airport_escape" );
			music_loop( "airport_escape", 150 );
			/#
			println( " *** MUSIC: airport_escape *** " );
			#/
			
			flag_wait( "escape_hold_your_fire" );
			thread music_stop( 2 );
			
			snd = spawn( "script_origin", level.player.origin );
			snd linkto( level.player );
			snd playsound( "airport_doublecross_sfx" );
			/#
			println( " *** MUSIC: airport_doublecross *** " );
			#/
		
		break;

		default:
			AssertMsg( "Unhandled start point " + level.start_point );
			break;
	}
}