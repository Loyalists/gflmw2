#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_blizzard;
#include maps\_vehicle;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;
#include maps\contingency_anim;

main()
{	
	level.price_destroys_btr = false;
	setsaveddvar( "sm_sunShadowScale", 0.5 );// optimization
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.24 );
	setsaveddvar( "r_lightGridContrast", 0 );
	
	//level.ai_dont_glow_in_thermal = true;
	level.min_btr_fighting_range = 400;
	level.explosion_dist_sense = 1500;
	level.default_goalradius = 7200;
	level.goodFriendlyDistanceFromPlayerSquared = 250 * 250;
	level.corpse_behavior_doesnt_require_player_sight = true;
	level.attackheliRange = 7000;
	level.min_time_between_uav_launches = 24 * 1000;
	level.dont_use_global_uav_kill_dialog = true;
	PreCacheItem( "remote_missile_snow" );
	level.remote_missile_snow = true;
	
	level.bcs_maxTalkingDistFromPlayer = 5000;  // default = 1500
	
	level.visionThermalDefault = "contingency_thermal_inverted";
	level.VISION_UAV = "contingency_thermal_inverted";
	level.cosine[ "60" ] = cos( 60 );
	level.cosine[ "70" ] = cos( 70 );
	
	//thermal fx overrides
	SetThermalBodyMaterial( "thermalbody_snowlevel" );
	level.friendly_thermal_Reflector_Effect = loadfx( "misc/thermal_tapereflect" );

	PreCacheRumble( "tank_rumble" );
	precacheItem( "remote_missile_not_player" );
	precacheModel( "com_computer_keyboard_obj" );
	PrecacheNightVisionCodeAssets();

	PreCacheModel( "ch_viewhands_player_gk_ar15" );
	PreCacheModel( "ch_viewhands_gk_ar15" );

	default_start( ::start_start );
	add_start( "start", ::start_start, "Start" );
	//add_start( "bridge", ::start_bridge, "Bridge" );
	add_start( "slide", ::start_slide, "Slide" );
	add_start( "woods", ::start_woods, "Woods" );
	add_start( "midwoods", ::start_midwoods, "mid woods" );
	add_start( "ridge", ::start_ridge, "ridge" );
	//add_start( "village", ::start_village, "village" );
	add_start( "base", ::start_base, "Base" );
	add_start( "defend_sub", ::start_defend_sub, "defend_sub" );
	
	//add_start( "sub", ::start_sub, "Submarine" );
	//add_start( "exit_sub", ::start_exit_sub, "Exit Submarine" );
	//add_start( "sub_gas_mask", ::start_sub_gas_mask, "Sub w/ gas mask" );
	
	maps\contingency_precache::main();
	maps\createart\contingency_fog::main();
	maps\contingency_fx::main();
	maps\contingency_anim::main_anim();
	
	maps\_attack_heli::preLoad();
	
	build_light_override( "btr80", "vehicle_btr80", "spotlight", 		"TAG_FRONT_LIGHT_RIGHT", "misc/spotlight_btr80_daytime", 	"spotlight", 			0.2 );
	build_light_override( "btr80", "vehicle_btr80", "spotlight_turret", "TAG_TURRET_LIGHT", "misc/spotlight_btr80_daytime", 	"spotlight_turret", 	0.0 );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_m16_clip";
	level.weaponClipModels[1] = "weapon_kriss_clip";
	level.weaponClipModels[2] = "weapon_ak47_tactical_clip";
	level.weaponClipModels[3] = "weapon_m4_clip";
	level.weaponClipModels[4] = "weapon_magpul_masada_clip";
	level.weaponClipModels[5] = "weapon_dragunov_clip";
	level.weaponClipModels[6] = "weapon_famas_clip";

	level.dead_vehicles = [];
	
	precacheString( &"CONTINGENCY_TIME_TO_ENTER_SUB" );
	precacheString( &"CONTINGENCY_LINE1" );
	precacheString( &"CONTINGENCY_LINE2" );
	precacheString( &"CONTINGENCY_LINE3" );
	precacheString( &"CONTINGENCY_LINE4" );
	precacheString( &"CONTINGENCY_LINE5" );
	
	
	precacheString( &"CONTINGENCY_OBJ_DEFEND_SUB" );
	precacheString( &"CONTINGENCY_OBJ_ENTER_SUB" );
	precacheString( &"CONTINGENCY_OBJ_CONTROL_SUB" );
	precacheString( &"CONTINGENCY_OBJ_TURN_KEY" );
	precacheString( &"CONTINGENCY_OBJ_EXIT_SUB" );
	precacheString( &"CONTINGENCY_OBJ_DEFEND" );
	precacheString( &"CONTINGENCY_SUB_TIMER_EXPIRED" );
	precacheString( &"CONTINGENCY_OBJ_ENTER_BASE" );
	precacheString( &"CONTINGENCY_OBJ_PRICE" );
	precacheString( &"CONTINGENCY_USE_DRONE" );
	precacheString( &"CONTINGENCY_TURN_KEY" );
	precacheString( &"CONTINGENCY_DONT_LEAVE" );
	precacheString( &"CONTINGENCY_DONT_LEAVE_FAILURE" );
	
	
	
	
	maps\_load::main();
	maps\_load::set_player_viewhand_model( "ch_viewhands_player_gk_ar15" );
	thread maps\contingency_amb::main();
	//maps\_blizzard::blizzard_main();
	maps\createart\contingency_art::main();
	//maps\_utility::set_vision_set( "contingency", 0 );
	//snow_fx();
	
	maps\_remotemissile::init();
//	maps\_remotemissile::init_radio_dialogue();
	
	maps\_compass::setupMiniMap("compass_map_contingency");
	
	createThreatBiasGroup( "bridge_guys" );
	createThreatBiasGroup( "truck_guys" );
	createThreatBiasGroup( "bridge_stealth_guys" );
	createThreatBiasGroup( "dogs" );
	createThreatBiasGroup( "price" );
	createThreatBiasGroup( "player" );
	createThreatBiasGroup( "end_patrol" );
	level.player setthreatbiasgroup( "player" );
	//Make first group ignored by second group
	SetIgnoreMeGroup( "price", "dogs" );
	//ignoreEachOther( "left_rooftop_enemies", "players_group" );
	//Set threat bias of first group against second group
	setthreatbias( "player", "bridge_stealth_guys", 1000 );
	setthreatbias( "player", "truck_guys", 1000 );
	//setthreatbias( "end_patrol", "price", 1000 );
	
	precacheItem( "at4_straight" );
	precacheItem( "rpg_straight" );
	precacheItem( "zippy_rockets" );
	precacheItem( "zippy_rockets_inverted" );
	precacheItem( "semtex_grenade" );
	precacheItem( "facemask" );
	
	
	flag_init( "saying_base_on_alert" );
	flag_init( "said_second_uav_in_position" );
	flag_init( "everyone_set_green" );
	flag_init( "said_convoy_coming" );
	flag_init( "saying_patience" );
	flag_init( "stop_stealth_music" );
	flag_init( "price_starts_moving" );
	
	flag_init( "all_bridge_guys_dead" );
	thread flag_when_all_bridge_guys_dead();
	thread flag_when_second_group_of_stragglers_are_dead();
	flag_init( "second_group_of_stragglers_are_dead" );
	flag_init( "saying_contact" );
	flag_init( "said_follow_me" );
	flag_init( "someone_became_alert" );
	flag_init( "price_is_hiding" );
	flag_init( "truck_guys_alerted" );
	flag_init( "jeep_stopped" );
	flag_init( "convoy_hide_section_complete" );
	
	flag_init( "attach_rocket" );
	flag_init( "fire_rocket" );
	flag_init( "drop_rocket" );
	
	flag_init( "done_with_exploding_trees" );
	
	flag_init( "first_uav_spawned" );
	flag_init( "first_uav_destroyed" );
	flag_init( "second_uav_in_position" );
	flag_init( "rasta_and_bricktop_dialog_done" );
	flag_init( "player_turned_key" );
	flag_init( "player_in_uaz" );
	
	//flag_init( "dialog_woods_first_patrol" );
	//flag_init( "dialog_woods_first_dog_patrol" );
	//flag_init( "dialog_woods_second_dog_patrol" );
	//flag_init( "dialog_woods_first_stationary" );
	//flag_init( "dialog_woods_blocking_stationary" );
	
	flag_init( "time_to_use_UAV" );
	flag_init( "both_gauntlets_destroyed" );
	flag_init( "time_to_race_to_submarine" );
	flag_init( "player_key_rdy" );
	flag_init( "close_sub_hatch" );
	
	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	
	animscripts\dog\dog_init::initDogAnimations();
	maps\_patrol_anims::main();
	
	maps\_dynamic_run_speed::main();
	maps\_stealth::main();
	stealth_settings();
	thread stealth_music_control();
	
	//thread dialog_theyre_looking_for_you();
	thread dialog_we_are_spotted();
	thread dialog_stealth_recovery();
	thread dialog_price_kill();
	thread dialog_price_kill_dog();
	thread dialog_player_kill_master();
	thread dialog_enemy_saw_corpse();

	// Remote Missile
	level.player.remotemissile_actionslot = 4;
	level.player thread maps\_remotemissile::RemoteMissileDetonatorNotify();
	
	
	level.player stealth_plugin_basic();
	level.player thread playerSnowFootsteps();
	player_speed_percent( 90 );
	
	destroyable_trees = getentarray( "trigger_tree_explosion", "targetname" );
	foreach( trigger in destroyable_trees )
		trigger thread setup_destroyable_tree();
		
	//tree_destruction_chain = getstruct( "tree_destruction_chain", "targetname" );
	//thread destroy_chain( tree_destruction_chain );
	
	//thread spawn_bridge_trucks();
	truck_patrol_vehicles = getentarray( "truck_patrol", "targetname" );
	array_thread( truck_patrol_vehicles, ::add_spawn_function, ::setup_bridge_trucks );
	truck_guys = getentarray( "truck_guys", "script_noteworthy" );
 	array_thread( truck_guys, ::add_spawn_function, ::base_truck_guys_think );
 	
	rasta_spawners = getentarray( "rasta", "script_noteworthy" );
	array_thread( rasta_spawners, ::add_spawn_function, ::setup_rasta );
	
	bricktop_spawners = getentarray( "bricktop", "script_noteworthy" );
	array_thread( bricktop_spawners, ::add_spawn_function, ::setup_bricktop );
	
	village_redshirt = getentarray( "village_redshirt", "script_noteworthy" );
	if( isdefined( village_redshirt ) )
		array_thread( village_redshirt, ::add_spawn_function, ::setup_village_redshirt );
	
	
	start_of_base_redshirt = getentarray( "start_of_base_redshirt", "script_noteworthy" );
	if( isdefined( start_of_base_redshirt ) )
		array_thread( start_of_base_redshirt, ::add_spawn_function, ::setup_base_redshirt );
	
	level.village_defenders_dead = 0;
	village_defenders = getentarray( "village_defenders", "targetname" );
	array_thread( village_defenders, ::add_spawn_function, ::setup_village_defenders );
	
	base_starting_guys = getentarray( "base_starting_guys", "script_noteworthy" );
	array_thread( base_starting_guys, ::add_spawn_function, ::setup_base_starting_guys );
	
	base_vehicles = getentarray( "base_vehicles", "script_noteworthy" );
	array_thread( base_vehicles, ::add_spawn_function, ::setup_base_vehicles );
	
	base_troop_transport1 = getent( "base_troop_transport1", "targetname" );
	base_troop_transport1 add_spawn_function( ::unload_when_close_to_player );
	base_troop_transport1 add_spawn_function( ::dialog_destroyed_vehicle, "cont_cmt_goodkilltruck" );
	
	
	base_troop_transport2 = getent( "base_troop_transport2", "targetname" );
	base_troop_transport2 add_spawn_function( ::unload_when_close_to_player );
	base_troop_transport2 add_spawn_function( ::dialog_destroyed_vehicle, "cont_cmt_goodkilltruck" );
	
	base_truck2 = getent( "base_truck2", "targetname" );
	base_truck2 add_spawn_function( ::unload_when_close_to_player );
	base_truck2 add_spawn_function( ::dialog_destroyed_vehicle, "cont_cmt_directhitjeep" );
	
		
 	price_spawner = getent( "price", "script_noteworthy" );
 	price_spawner add_spawn_function( ::setup_price );
	price_spawner add_spawn_function( ::set_threatbias_group, "price" );


	//base_truck_guys = getentarray( "base_truck_guys", "script_noteworthy" );
	//array_thread( base_truck_guys, ::add_spawn_function, ::setup_remote_missile_target_rider );
	//defend_sub_vehicle_guys = getentarray( "defend_sub_vehicle_guys", "script_noteworthy" );
	//array_thread( defend_sub_vehicle_guys, ::add_spawn_function, ::setup_remote_missile_target_rider );
	//base_starting_guys_truckriders = getentarray( "base_starting_guys_truckriders", "targetname" );
	//array_thread( base_starting_guys_truckriders, ::add_spawn_function, ::setup_remote_missile_target_rider );
	

	//defend_sub_final_guys = getentarray( "defend_sub_final_guys", "targetname" );
	//array_thread( defend_sub_final_guys, ::add_spawn_function, maps\_remotemissile::setup_remote_missile_target );
	//base_defenders = getentarray( "base_defenders", "script_noteworthy" );
	//array_thread( base_defenders, ::add_spawn_function, maps\_remotemissile::setup_remote_missile_target );
	//base_starting_guys = getentarray( "base_starting_guys", "targetname" );
	//array_thread( base_starting_guys, ::add_spawn_function, maps\_remotemissile::setup_remote_missile_target );

	add_global_spawn_function( "axis", ::setup_remote_missile_target_guy );
	
	add_global_spawn_function( "axis", ::setup_count_predator_infantry_kills );
	//add_global_spawn_function( "axis", ::tons_of_health );
	thread dialog_handle_predator_infantry_kills();
	
	flag_init( "base_troop_transport2_spawned" );
	base_troop_transport2 = getent( "base_troop_transport2", "targetname" );
 	base_troop_transport2 add_spawn_function( ::flag_set, "base_troop_transport2_spawned" );
	
	village_truck_guys = getentarray( "village_truck_guys", "script_noteworthy" );
	array_thread( village_truck_guys, ::add_spawn_function, ::village_truck_guys_setup );
	
	//end_patrol = getentarray( "end_patrol", "targetname" );
 	//array_thread( end_patrol, ::add_spawn_function, ::set_threatbias_group, "end_patrol" );
 	
 	
	sub_ladder = getent( "sub_ladder", "targetname" );
	sub_ladder.realOrigin = sub_ladder.origin;
	sub_ladder.origin += ( 0, 0, -10000 );
 	
	thread setup_sub_hatch();
 	
	thread setup_dont_leave_failure();
	thread setup_dont_leave_hint();
	add_hint_string( "hint_dont_leave_price", &"CONTINGENCY_DONT_LEAVE", ::should_break_dont_leave );
	add_hint_string( "hint_predator_drone", &"HELLFIRE_USE_DRONE", ::should_break_use_drone );
	add_hint_string( "hint_steer_drone", &"SCRIPT_PLATFORM_STEER_DRONE", ::should_break_steer_drone );
 	
	thread objective_main();
}

tons_of_health()
{
	self.health = 100000;
}



start_start()
{
	thread handle_start();
}


start_base()
{
	start = getstruct( "base_start_player", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	friendlies = getentarray( "start_friendly", "targetname" );
	friendlies2 = getentarray( "rasta_and_bricktop", "targetname" );
	friendlies = array_combine( friendlies, friendlies2 );
	
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "base_start_friendly", "targetname" );
	
	for ( i = 0 ; i < friendlies.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	wait .1;	

	level.price.colornode_func = ::dialog_moving_to_new_position_in_village;
	level.price forceUseWeapon( "aug_scope", "primary" );
	//disable_stealth_system();
	thread spawn_second_uav();
	flag_set( "player_on_ridge" );
	flag_set( "leaving_village" );
	thread handle_base();
}




start_defend_sub()
{
	start = getstruct( "defend_sub_start_player", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	friendlies = getentarray( "start_friendly", "targetname" );
	friendlies2 = getentarray( "rasta_and_bricktop", "targetname" );
	friendlies = array_combine( friendlies, friendlies2 );
	
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "defend_sub_start_friendly", "targetname" );
	
	for ( i = 0 ; i < friendlies.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	flag_set( "stop_stealth_music" );
	music_stop();
	
	level.player takeallweapons();
	level.player giveWeapon( "aa12" );
	level.player giveWeapon( "m240_heartbeat_reflex_arctic" );
	level.player switchToWeapon( "m240_heartbeat_reflex_arctic" );

	level.player giveWeapon( "fraggrenade" );
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon( "flash_grenade" );
		
	
	wait .1;	
	
	level.rasta set_force_color( "g" );
	level.rasta enable_ai_color();
	level.bricktop set_force_color( "g" );
	level.bricktop enable_ai_color();
	level.price set_force_color( "g" );
	level.price enable_ai_color();
	
	level.price forceUseWeapon( "aug_scope", "primary" );
	
	disable_stealth_system();
	
	friendlies = getaiarray( "allies" );
		foreach( g in friendlies )
			g thread turn_off_stealth_settings();
			
	thread spawn_second_uav();
	flag_set( "player_on_ridge" );
	flag_set( "leaving_village" );
	flag_set( "base_alerted" );

	//flag_set( "price_splits_off" );
	
	thread base_arrival_music();
	
	thread handle_defend_sub();
}

dialog_i_cant_see_roach()
{
	wait 4;
	//Price, I can barely see Roach's chute on my satellite feed.  Too much interference. Do you see him, over?
	thread radio_dialogue( "cont_cmt_barelysee" );
		
}
	
handle_start()
{
	thread dialog_i_cant_see_roach();
	
 	maps\_introscreen::contingency_black_screen_intro();
 	
	price_spawner = getent( "price", "script_noteworthy" );
	price_spawner spawn_ai();
	//price_intro_talk_pos = getnode( "price_intro_talk_pos", "script_noteworthy" );
	//level.price setgoalnode( price_intro_talk_pos );
	//level.price.goalradius = 64;
	
	thread cargo_choppers();
	thread price_intro_anim();
	
	//wait .2;
	
	//thread dialog_intro();
	
	//flag_wait_either ( "price_goes_to_road", "said_follow_me" );
	
	//level.price SetLookAtEntity();// clears it
	
	thread dialog_lets_follow_quietly();
	
	flag_wait ( "start_first_patrol" );
	
	autosave_by_name( "start_first_patrol" );
	first_patrol = getentarray( "first_patrol", "targetname" );
	foreach( guy in first_patrol )
	{
		guy thread spawn_with_delays();
	}
	
	flag_wait( "price_starts_moving" );
	flag_wait( "patrol_in_sight" );
	
	thread hide_and_kill_first_stragglers();
	thread hide_and_kill_everyone();
	
	
	thread dialog_first_patrol_spotted();
	
	
	//flag_wait( "cross_bridge_patrol_dead" );//guy and dog that look over the bridge
	//flag_wait( "rightside_patrol_dead" );
	
	flag_wait( "start_truck_patrol" );
	
	
	if( !flag( "cross_bridge_patrol_dead" ) && !flag( "first_stragglers_dead" ) && !flag( "rightside_patrol_dead" ) )
		thread autosave_stealth();
	
	level.price.ignoreall = true;
	
	thread spawn_vehicles_from_targetname_and_drive( "truck_patrol" );
	
	wait 1;
	
	//level.price thread disable_cqbwalk();
	//level.price thread hide_from_bridge_convoy();
	
	thread dialog_convoy_coming();
	
	flag_wait_any( "last_truck_left", "player_is_crossing_bridge", "all_bridge_guys_dead" );
	
	//thread autosave_stealth();
	 
	level.price notify( "stop_smart_path_following" );
	price_rdy_vs_stragglers = getnode( "price_rdy_vs_stragglers", "targetname" );
	level.price thread price_smart_path_following( price_rdy_vs_stragglers );
	
	
	level.price thread friendly_adjust_movement_speed();
	
	flag_wait( "price_slide_prep" );
	
	level.price.ignoreall = false;
	thread handle_slide();
}

start_slide()
{
	start = getstruct( "slide_start_player", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	friendlies = getentarray( "start_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "slide_start_friendly", "targetname" );
	
	for ( i = 0 ; i < friendlies.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	wait .1;
	
	level.price enable_cqbwalk();
	//price_pre_slide_node = getnode( "price_pre_slide", "targetname" );
	//price_pre_slide_node = getnode( "price_fire_loc", "targetname" );
	//level.price setgoalnode( price_pre_slide_node );
	//level.price.goalradius = 64;
	
	//flag_set( "start_btr_slide" );
	
	thread handle_slide();
}



//#using_animtree( "generic_human" );
handle_slide()
{
	price_destroys_btr = level.price_destroys_btr;
	thread cargo_choppers2();
	

	
	level.price notify( "stop_smart_path_following" );
	
	//if( !price_destroys_btr )
	//{
		price_pre_slide_node = getnode( "price_fire_loc", "targetname" );
		
		price_pre_slide_node thread Price_Caution_Stop();
		
		//level.price setgoalnode( price_pre_slide_node );
		//level.price.goalradius = 64;
	//	wait 2.5;
	//}
		
	
	flag_wait( "start_btr_slide" );
	autosave_stealth();
	println( "hit flag" );
	println( "anim starting" );
	
	level.price notify( "stop_adjust_movement_speed" );
	
	//second btr is the one with the script to kill the player.
	//if( price_destroys_btr )
		thread setup_tree_destroyer();
	
	level.btr_slider = spawn_vehicle_from_targetname( "btr_slider" );
	level.btr_slider thread vehicle_lights_on( "spotlight spotlight_turret" );
	level.btr_slider  thread maps\_vehicle::damage_hints();
	
	level.btr_slider thread fake_treads();
	
	//thread debug_timer();
	//level.btr_slider = spawn_anim_model( "contingency_btr_slide" );
	
	//wait 1;
	
	level.btr_slider.animname = "contingency_btr_slide";
	
	btr81_slide_node = getstruct("btr81_slide_node", "targetname" );
	//thread draw_line_for_time ( btr81_slide_node.origin, btr81_slide_node.origin + (0,0,32), 0, 1, 1, 999);
	
	btr81_slide_node thread anim_single_solo( level.btr_slider, "contingency_btr_slide" );
	level.btr_slider playsound( "scn_con_bmp_skid" );
	
	//thread dialog_btr_incoming();
	//thread debug_timer();
		
		
	//if( price_destroys_btr )
	//{
	//	price_fire_loc = getent( "price_fire_loc_new", "targetname" );
	//	level.price notify( "stop_smart_path_following" );
	//	
	//	
	//	wait 1.3;
	//	
	//	level.price thread disable_cqbwalk();
	//	level.price pushplayer( true );
	//	
	//	
	//	fire_pos_ent = price_fire_loc;
	//	thing = level.btr_slider;
	//	thing_offset = (0,0,0);
	//	level.price destroy_thing_with_at4( fire_pos_ent, thing, thing_offset, true );
	//}
	//else
	//{
		//thread end_btr_slide();
		wait_to_hide = 2.8;
		wait wait_to_hide;
		
		level notify( "run_to_woods" );
		level.price anim_stopanimscripted();
		level.price thread dialogue_queue( "cont_pri_incoming" );
		
		//level.price disable_cqbwalk();
		//price_quick_hide_loc = getnode( "price_into_the_woods_path", "targetname" );
		//level.price setgoalnode( price_quick_hide_loc );
		
		
		//wait (5.45 - wait_to_hide);
	//}

	thread stealth_ai_ignore_tree_explosions();

	thread dialog_into_the_woods();
	
	thread end_of_tree_explosions();
	
	level.price pushplayer( true );
	//this is price running fast into the woods
	level.price thread disable_cqbwalk();
	//level.price set_generic_run_anim( "sprint", true );
	level.price.sprint = true;
	level.price.moveplaybackrate = .9;
	level.price thread faster_price_if_player_close();
	price_into_the_woods_path = getnode( "price_into_the_woods_path", "targetname" );
	level.price thread follow_path( price_into_the_woods_path );
	
	thread handle_woods();
}



start_woods()
{
	start = getstruct( "woods_start_player", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	friendlies = getentarray( "start_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "woods_start_friendly", "targetname" );
	
	for ( i = 0 ; i < friendlies.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	wait .1;	
	
	level.price thread disable_cqbwalk();
	level.price.moveplaybackrate = 1.2;
	level.price.goalradius = 64;
	level.price setgoalpos( ( -28257.9, -8877.1, 840.5 ) );
	
	thread handle_woods();
}


start_midwoods()
{
	start = getstruct( "midwoods_start_player", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	friendlies = getentarray( "start_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "midwoods_start_friendly", "targetname" );
	
	for ( i = 0 ; i < friendlies.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	wait .1;	
	
	
	flag_set( "safe_from_btrs" );
	level.price thread enable_cqbwalk();
	woods_stealth_path_start = getnode( "price_overlook_stream", "targetname" );
	level.price thread price_smart_path_following( woods_stealth_path_start );
	
	thread dialog_russians_looking_for_you();
	thread handle_midwoods();
}


handle_woods()
{
	flag_wait( "safe_from_btrs" );
	
	thread monitor_player_returns_to_btrs();

	enemies = GetAISpeciesArray( "axis", "all" );
	foreach( guy in enemies )
	{
		if( distance( level.player.origin, guy.origin ) > 1500 )
			guy delete();
	}
	
	
	
	thread dialog_russians_looking_for_you();
	
	level.price notify( "_utility::follow_path" );
	level.price notify( "stop_going_to_node" );// kills the last call to go_to_node
	
	level.price.moveplaybackrate = 1;
	//level.price clear_run_anim();
	level.price pushplayer( true );//so he doesnt stop when the player is in front
	sight_ranges_foggy_woods();
	level.price_maxsightdistsqrd_woods = 40*40;
	level.price.maxsightdistsqrd = level.price_maxsightdistsqrd_woods;//keeps him from being jumpy at cover nodes
	
	//aiarray = GetAIArray( "axis" );
	//foreach( ai in aiarray )
	//	ai delete();
	
	//Slow down. They cant follow us this far.	
	//iprintlnbold( "Slow down. Their vehicles cant follow us this far." );
	//level.price thread radio_dialogue( "cont_pri_slowdown" );
	level.price thread dialogue_queue( "cont_pri_slowdown" );
	
	autosave_stealth();
	
	//level.price stealth_fog_smart_stance();
	
	//woods_guys = getentarray( "woods_guys", "targetname" );
	//foreach( guy in woods_guys )
	//	guy spawn_ai();
	
	level.price.sprint = undefined;
	level.price thread enable_cqbwalk();
	woods_stealth_path_start = getnode( "price_woods_path_start", "targetname" );
	level.price thread price_smart_path_following( woods_stealth_path_start );
	
	thread handle_midwoods();
}
	
handle_midwoods()
{
	sight_ranges_foggy_woods();
	thread dialog_looking_for_us();
	thread dialog_woods_first_patrol();
	thread dialog_woods_first_dog_patrol();
	thread dialog_woods_second_dog_patrol();
	thread dialog_woods_first_stationary();
	thread dialog_woods_blocking_stationary();
	
	//level.price thread price_move_speed_think();
	//level.price enable_stealth_smart_stance();
	//level.price enable_dynamic_run_speed();
	//enable_dynamic_run_speed( pushdist, sprintdist, stopdist, jogdist, group, dontChangeMovePlaybackRate )
	
	//level.price thread follow_path( woods_stealth_path_start );
	
	thread handle_ridge();
}


start_ridge()
{
	start = getstruct( "ridge_start_player", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	friendlies = getentarray( "start_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "ridge_start_friendly", "targetname" );
	
	for ( i = 0 ; i < friendlies.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	wait .1;	
	
	thread handle_ridge();
}

first_uav_sequence()
{
	
	//because of stealth clean up
	//rasta and bricktop could destroy the gauntlets beofre the UAV shows
	if( ( isalive( level.gauntlet_east ) ) && ( isalive( level.gauntlet_west ) ) )
	{
		//ambient_villagers = getentarray( "ambient_villagers", "targetname" );
		//foreach( guy in ambient_villagers )
		//	guy spawn_ai();
		
		flag_set( "first_uav_spawned" );
		thread dialog_approaching_ridge();
	
	
		level.uav = spawn_vehicle_from_targetname_and_drive( "first_uav" );
		level.uav playLoopSound( "uav_engine_loop" );
		level.uavRig = spawn( "script_model", level.uav.origin );
		level.uavRig setmodel( "tag_origin" );
		thread UAVRigAiming();
	

	}
	flag_wait( "player_on_ridge" );
	
	
	if( stealth_is_everything_normal() )
	{
		enemies = GetAISpeciesArray( "axis", "all" );
		foreach( mf in enemies )
		{
			if( !( mf cansee( level.player ) ) )
				mf delete();
		}
		disable_stealth_system();
	}
	else
	{
		disable_stealth_system();
		enemies = GetAISpeciesArray( "axis", "all" );
		foreach( mf in enemies )
		{
			if( distance( mf.origin, level.player.origin ) > 2300 )
				mf delete();
			else
				mf thread setup_stealth_enemy_cleanup();
		}
			
		enemies = GetAISpeciesArray( "axis", "all" );
		level.stealth_enemies_remaining = enemies.size;
		while( level.stealth_enemies_remaining > 0 )
			wait 1;
	}
	level.price thread disable_cqbwalk();
	
	flag_wait( "price_on_ridge" );
	
	if( ( isalive( level.gauntlet_east ) ) && ( isalive( level.gauntlet_west ) ) )
	{
		
		level.last_uav_launch_time = gettime();

		level.player.has_remote_detonator = true;
		level.player giveWeapon( "remote_missile_detonator" );
		level.player SetActionSlot( 4, "weapon", "remote_missile_detonator" );
		
		if( !flag( "player_slid_down" ) )
		{
			//This ridge is perfect.	
			level.price dialogue_queue( "cont_pri_ridgeisperfect" );
			//radio_dialogue( "cont_pri_ridgeisperfect" );
			
			//Roach take control of the UAV.	
			level.price dialogue_queue( "cont_pri_controluav" );
			//radio_dialogue( "cont_pri_controluav" );
		
			level.player thread display_hint( "hint_predator_drone" );
		}
		
		if( !flag( "going_down_ridge" ) )
			wait 3;
			
		if( !flag( "going_down_ridge" ) && ( !isdefined( level.player.is_controlling_UAV ) ) )
			wait 3;
	}
	else
	{
		level.last_uav_launch_time = gettime();
		level.player.has_remote_detonator = true;
		level.player giveWeapon( "remote_missile_detonator" );
		level.player SetActionSlot( 4, "weapon", "remote_missile_detonator" );
	}
		
	if( ( isalive( level.gauntlet_east ) ) && ( isalive( level.gauntlet_west ) ) )
	{
		flag_set( "first_uav_destroyed" );
		
		gauntlet_west = getent( "gauntlet_west", "targetname" );
		stinger_source = spawn( "script_origin", gauntlet_west.origin + (0,0,220) );
		//thread maps\_debug::drawArrowForever ( stinger_source, gauntlet_west.angles );
		
		fire_stinger_at_uav( stinger_source );
	
		//waht happened?
		dialog_gauntlet_surprise_reaction();
	}
	
	if( !flag ( "going_down_ridge" ) )
	{
		//Roach - let's go.	
		level.price thread dialogue_queue( "cont_pri_roachletsgo" );
		//thread radio_dialogue( "cont_pri_roachletsgo" );
	}
	
	//price moves
	flag_set( "going_down_ridge" );
}

handle_ridge()
{
	rasta_spawners = getentarray( "rasta", "script_noteworthy" );
	array_thread( rasta_spawners, ::add_spawn_function, ::setup_rasta_village );
	
	bricktop_spawners = getentarray( "bricktop", "script_noteworthy" );
	array_thread( bricktop_spawners, ::add_spawn_function, ::setup_bricktop_village );
	
	
	thread price_slides_down_the_ridge();
	//thread village_spawners();
	
	
	level.price thread enable_cqbwalk();
	
	flag_wait( "approaching_ridge" );
	
	level notify( "stop_snow" );
	
	//thread village_enemies();
	
	level.gauntlet_east	= spawn_vehicle_from_targetname( "gauntlet_east" );
	level.gauntlet_west	= spawn_vehicle_from_targetname( "gauntlet_west" );
	
	level.price disable_ai_color();
	level.price notify( "stop_smart_path_following" );
	ridge_price_overlook = getnode( "ridge_price_overlook", "targetname" );
	level.price setgoalnode( ridge_price_overlook );
	level.price.goalradius = 64;
	level.price notify( "stop_dynamic_run_speed" );
	
	
	thread first_uav_sequence();
	
	flag_wait( "player_slid_down" );
	flag_set( "stop_stealth_music" );
	
	thread dialog_roach_change_guns();
	
	if( isalive( level.btr_slider ) )
		level.btr_slider delete();
	if( isalive( level.btr_tree_destroyer ) )
		level.btr_tree_destroyer delete();
	
	thread price_changes_weapons();
	
	autosave_by_name( "village_fight" );
	
	thread save_when_x_are_killed();
	
	first_villagers = getentarray( "first_villagers", "targetname" );
	foreach( guy in first_villagers )
		guy spawn_ai();
		
	//must kill stealth before base
	//flag_wait_either( "first_villagers_dead", "start_village_fight" );
	
	disable_stealth_system();
	flag_clear( "_stealth_spotted" );
	
	thread spawn_ghosts_team();
	
	//thread spawn_village_trucks_at_right_time();
	
	
	if( isalive( level.gauntlet_east ) )
		level.gauntlet_east waittill( "death" );
		
	if( isalive( level.gauntlet_west ) )
		level.gauntlet_west waittill( "death" );
	
	//change obj:
	flag_set( "both_gauntlets_destroyed" );
	
	add_wait( ::flag_wait, "second_uav_in_position" );
	add_func( ::spawn_second_uav );
	thread do_wait();
	
	//timeout the dialog if the player doesnt get close to the guys
	add_wait( ::_wait, 30 );
	add_func( ::flag_set, "start_village_fight" );
	thread do_wait();
	
	dialog_rasta_and_bricktop();
	
	flag_set( "rasta_and_bricktop_dialog_done" );
	flag_set( "second_uav_in_position" );
	flag_set( "start_village_fight" );
	
	autosave_by_name( "village_fight2" );
	
	wait 1;
	
	level.price thread turn_off_stealth_settings();
	//level.price.colornode_func = ::dialog_moving_to_new_position_in_village;
	
	village_defenders = getentarray( "village_defenders", "targetname" );
	foreach( guy in village_defenders )
		guy spawn_ai();
	
	//add_wait( ::flag_wait, "second_uav_in_position" );
	//add_func( ::display_hint, "hint_predator_drone" );
	//thread do_wait();
	
	//level.player thread display_hint( "hint_predator_drone" );	
	
	flag_wait( "leaving_village" );
	thread handle_base();
}


handle_base()
{
	// MikeD: Disable radio in _remotemissile until the dialog for the base is complete.
	level.uav_radio_disabled = true;

	level.price thread dead_vehicle_blocking_path();
	level.rasta thread dead_vehicle_blocking_path();

	alive = 0;
	f_guys = getaiarray( "allies" );
	{
		foreach( f in f_guys )
		{
			if( ( f == level.rasta ) || ( f == level.price ) )
				continue;
			alive++;
			f thread replace_on_death();
		}
	}
	
	desired = 3 - alive;
	start_of_base_redshirt = getentarray( "start_of_base_redshirt", "targetname" );
	for( i = 0 ; i < desired ; i++ )
	{
		start_of_base_redshirt[ i ] spawn_ai();
	}
	
	thread dialog_second_uav_in_position();
	
	thread base_autosave_logic();
	level notify( "stop_snow" );
	//stealth + color node system
	thread setup_friendlies_for_base();
	
	//get rid of village enemies
	retreat_pos = getstruct( "village_enemies_retreat_pos", "targetname" ).origin;
	enemies = getaiarray( "axis" );
		foreach( mf in enemies )
			mf thread village_enemies_setup_retreat( retreat_pos );
	
	//spawn stuff thats unaware:
	
	sight_ranges_foggy_woods();
	
	base_starting_guys = getentarray( "base_starting_guys", "targetname" );
	foreach( guy in base_starting_guys )
	{
		guy spawn_ai();
	}
	
	thread setup_base_idling_vehicles();
	thread nag_player_to_destroy_btr();
	
	add_wait( ::waittill_base_alerted );
	add_func( ::flag_set, "base_alerted" );
	thread do_wait();
	
	
	thread dialog_sub_spotted();

	flag_wait( "base_alerted" );
	
	thread base_arrival_music();
	
	disable_stealth_system();
	
	
	thread base_alarm_sound();
	
	wait 1;
	
	thread dialog_base_on_alert();
	thread dialog_progress_through_base();
	activate_trigger_with_targetname( "friendlies_enter_base" );
	thread timer_start();
	
	
	friendlies = getaiarray( "allies" );
		foreach( g in friendlies )
			g thread turn_off_stealth_settings();
	
	if( isalive( level.base_btr2 ) )
	{
		end_if_cant_see = false;
		no_misses = false;
		level.base_btr2 thread bmp_turret_attack_player( end_if_cant_see, no_misses );
	}
	
	if( isalive( level.base_truck1 ) )
	{
		level.base_truck1 thread unload_base_truck();
	}
	
	wait 2;
	
	if( isalive( level.base_heli ) )
	{
		thread gopath( level.base_heli );
		level.base_heli.circling = true;
		level.base_heli.no_attractor = true;
		level.base_heli = thread maps\_attack_heli::begin_attack_heli_behavior( level.base_heli );
	}
	
	//flag_wait( "player_is_halfway_to_sub" );
	
	
	thread handle_defend_sub();
}




handle_defend_sub()
{
	flag_wait( "price_splits_off" );
	
	
	thread kill_helicopter_fail_safe();
	
	if( isalive( level.base_btr2 ) )
	{
		level.base_btr2 kill();
		wait 3;
	}
	
	flag_clear( "respawn_friendlies" );
	autosave_by_name( "defend" );
	
	//obj_guard_house
	thread setup_vehicle_gate( "gate1" );
	thread setup_vehicle_gate( "gate2" );
	
	level.price.colornode_func = undefined;

	killTimer();
	
	thread dialog_price_splits_off();
	
	level.price disable_ai_color();
	price_key_pos = getent( "price_key_pos", "targetname" );
	level.price setgoalpos( price_key_pos.origin );
	level.price.goalradius = 64;
	
	wait 4;
	
	greens = get_force_color_guys( "allies", "g" );
	array_thread( greens, ::set_force_color, "b" );
	
	activate_trigger_with_targetname( "friendlies_go_to_guardhouse" );
	
	thread setup_defend_sub_vehicles();
	
	
	enemies = getaiarray( "axis" );
	foreach( guy in enemies )
	{
		guy.combatmode = "cover";
		guy setgoalpos( level.player.origin );
	}
	
	flag_wait( "price_inside_sub" );
	
	//All right, I'm inside the sub! Cover me, I need a few minutes!	
	radio_dialogue( "cont_pri_insidesub" );
	
	//Alert! The use of nuclear weapons has been authorized.	
	
	//Launch codes verified authentic. Launch codes accepted. 	
	//Set condition one-SQ. Nuclear missile launch authorized.	
	//Now spinning up missiles 1 through 4 and 8 through 12 for strategic missile launch�	
	//Target package 572 has been authorized. Standing by for target confirmation and launch order.	
	
	flag_wait_or_timeout( "defend_sub_vehicle_guys_dead", 50 );
	flag_wait( "player_on_guardhouse" );
	
	flee_pos = getstruct( "sub_obj_enemies_flee", "targetname" ).origin;
	enemies = getaiarray( "axis" );
	foreach( guy in enemies )
		guy thread enemies_flee( flee_pos );
	
	
	stinger_source = getent( "defend_sub_stinger_source", "targetname" );
	//thread maps\_debug::drawArrowForever ( stinger_source, gauntlet_west.angles );
	fire_stinger_at_uav( stinger_source );
	
	thread breakforsub_music();
	println( "^3z:              thread breakforsub_music();   " );
	//thread debug_timer();
	
	wait 1;
	
	autosave_by_name( "defend2" );
	
	defend_sub_final_guys = getentarray( "defend_sub_final_guys", "targetname" );
	foreach( guy in defend_sub_final_guys )
		guy spawn_ai();
	
	wait 5;
	activate_trigger_with_targetname( "contacts_south" );
	
	
	//Contact to the south, on the dock next to the sub!	
	level.rasta dialogue_queue( "cont_gst_nexttosub" );
	
	flag_set( "close_sub_hatch" );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	wait 10;

	thread open_sub_missile_doors();
	
	wait 4;
	
	flee_pos = getstruct( "contacts_south_flee_pos", "targetname" ).origin;
	enemies = getaiarray( "axis" );
	foreach( guy in enemies )
	{
		//if( !isdefined( guy.targetname ) )
		//	continue;
		//if( guy.targetname == "defend_sub_final_guys" )
			guy thread enemies_flee( flee_pos );
	}
	
	ai = getaiarray();
	foreach( guy in ai )
		guy.dontevershoot = true;
	
	//Price, are you there? The silo doors are opening on the sub, I repeat, the silo doors are opening on the sub!	
	level.rasta dialogue_queue( "cont_gst_youthere" );
	
	wait 2.4;
	
	//Price, come in!! They're opening the silo doors on the sub!!! Hurry!!!	
	level.rasta dialogue_queue( "cont_gst_comein" );
	
	wait 2;
	
	//Price, do you copy??? The silo doors are open, I repeat, the silo doors are open!!	
	level.rasta dialogue_queue( "cont_gst_doyoucopy" );
	
	wait 1;
	
	//Good.	
	radio_dialogue( "cont_pri_good2" );
	
	thread launch_nuke();
	
	
	//What�? Wait...wait, Price - no!!!	
	level.rasta dialogue_queue( "cont_gst_whatwait" );
	
	wait 2;
	
	//We have a nuclear missile launch, missile in the air missile in the air!! Code black code black!!	
	level.rasta dialogue_queue( "cont_gst_codeblack" );
	
	//Price what have you done???	
	//level.rasta dialogue_queue( "cont_gst_whathaveyoudone" );
	wait 1;
	
	
	//flee_pos = getstruct( "dock_enemies_flee", "targetname" ).origin;
	//enemies = getaiarray( "axis" );
	//foreach( guy in enemies )
	//	guy thread enemies_flee( flee_pos );
		
	
	//wait 15;
	
	
	//iprintlnbold( "Next Mission" );
	nextmission();
}

//debug_timer()
//{
//	time = 0;
//	while( 1 )
//	{
//		println( "time   " + time );
//		time++;
//		wait 1;
//	}	
//}


//
//
//start_sub()
//{
//	start = getstruct( "sub_start_player", "targetname" );
//	level.player setOrigin( start.origin );
//	level.player setPlayerAngles( start.angles );
//	
//	friendlies = getentarray( "start_friendly", "targetname" );
//	friendlies2 = getentarray( "rasta_and_bricktop", "targetname" );
//	friendlies = array_combine( friendlies, friendlies2 );
//	
//	//array_thread( friendlies, ::spawn_ai );
//	friendly_starts = getstructarray( "sub_start_friendly", "targetname" );
//	
//	for ( i = 0 ; i < friendlies.size ; i++ )
//	{
//		friendlies[ i ].origin = friendly_starts[ i ].origin;
//		friendlies[ i ].angles = friendly_starts[ i ].angles;
//		friendlies[ i ] spawn_ai();
//	}
//	flag_set( "stop_stealth_music" );
//	music_stop();
//	
//	level.player takeallweapons();
//	level.player giveWeapon( "aa12" );
//	level.player giveWeapon( "m240_heartbeat_reflex_arctic" );
//	level.player switchToWeapon( "m240_heartbeat_reflex_arctic" );
//
//	level.player giveWeapon( "fraggrenade" );
//	level.player setOffhandSecondaryClass( "flash" );
//	level.player giveWeapon( "flash_grenade" );
//		
//	
//	wait .1;	
//	
//	level.rasta set_force_color( "g" );
//	level.rasta enable_ai_color();
//	level.bricktop set_force_color( "g" );
//	level.bricktop enable_ai_color();
//	level.price set_force_color( "g" );
//	level.price enable_ai_color();
//	
//	level.price forceUseWeapon( "aug_scope", "primary" );
//	
//	disable_stealth_system();
//	
//	friendlies = getaiarray( "allies" );
//		foreach( g in friendlies )
//			g thread turn_off_stealth_settings();
//			
//	thread spawn_second_uav();
//	flag_set( "player_on_ridge" );
//	flag_set( "leaving_village" );
//	
//	thread handle_sub();
//}
//
//start_sub_gas_mask()
//{
//	start_sub();
//	
//	wait 2;
//	
//	thread put_on_player_gas_mask();
//}
//
//
//handle_sub()
//{
//	level notify( "stop_snow" );
//	thread start_tear_gas_fx();
//	thread start_tear_gas_guys();
//	thread sub_ladder();
//	flag_wait( "friendlies_or_player_at_sub" );
//	
//	flee_pos = getstruct( "sub_obj_enemies_flee", "targetname" ).origin;
//	enemies = getaiarray( "axis" );
//	foreach( guy in enemies )
//		guy thread enemies_flee( flee_pos );
//	
//	
//	level.price.colornode_func = undefined;
//	thread dialog_at_sub();
//	
//	flag_wait( "obj_sub_entrance" );//player at sub
//	
//	
//	level.price disable_ai_color();
//	price_on_sub = getnode( "price_on_sub", "targetname" );
//	level.price setgoalnode( price_on_sub );
//	
//	flag_wait( "player_on_sub" );
//	
//	//Roach! Get your mask on!	
//	level.price dialogue_queue( "cont_pri_getmaskon" );
//	thread put_on_player_gas_mask();
//	
//	if( !flag( "player_dropping_into_sub" ) )
//	{
//		//Down the hatch, lets go!	
//		level.price thread dialogue_queue( "cont_pri_downthehatch" );
//	}
//
//	flag_wait( "player_dropping_into_sub" );
//	
//	if( isalive( level.rasta ) )
//		level.rasta kill();
//	if( isalive( level.bricktop ) )
//		level.bricktop kill();
//	level.price set_battlechatter( false );
//	
//	killTimer();
//	
//	
//	flag_wait( "player_is_clear_of_ladder" );
//	
//	price_drop_pos = getent( "price_drop_pos", "targetname" );
//	
//	price_drop_kill_pos = getent( "price_drop_kill_pos", "targetname" );
//	level.price setgoalpos( price_drop_kill_pos.origin );
//	
//	price_drop_bottom_pos = getent( "price_drop_bottom_pos", "targetname" );
//	
//	level.price forceteleport( price_drop_bottom_pos.origin, price_drop_bottom_pos.angles );
//	
//	level.price.goalradius = 64;
//	level.price.baseaccuracy = 500000;
//	//level.price.shootstyleoverride = "single";
//	level.price.a.specialShootBehavior = ::single_shots;
//	
//	flag_wait( "tear_gas_guys_dead" );
//	
//	thread spawn_sub_enemies();
//	
//	price_key_pos = getent( "price_key_pos", "targetname" );
//	level.price setgoalpos( price_key_pos.origin );
//	level.price.goalradius = 64;
//	level.price.ignoreall = true;
//	level.price.ignoreme = true;
//	
//	//Roach! I need a few minutes! Cover me!	
//	level.price dialogue_queue( "cont_pri_needfewminutes" );
//	
//	//Alert! The use of nuclear weapons has been authorized.	
//	
//	//Price! I'm on my way to the east gate with our transport, over!	
//	radio_dialogue( "cont_cmt_eastgate" );
//	
//	//Copy that Soap! 	
//	level.price dialogue_queue( "cont_pri_copythatsoap" );
//	
//	//Launch codes verified authentic. Launch codes accepted. 	
//	//Set condition one-SQ. Nuclear missile launch authorized.	
//	//Now spinning up missiles 1 through 4 and 8 through 12 for strategic missile launch�	
//	//Target package 572 has been authorized. Standing by for target confirmation and launch order.	
//	
//	//Roach! I'm almost done! Hold your ground!!	
//	level.price dialogue_queue( "cont_pri_almostdone" );
//	
//	//Price! How much longer do you need to sink the sub? We're almost at the gate!	
//	radio_dialogue( "cont_cmt_muchlonger" );
//	
//	//Soap, I'm not sinking the sub - I'm launching the nukes.	
//	level.price dialogue_queue( "cont_pri_notsinking" );
//	
//	//The bloody hell you are!!!!	
//	radio_dialogue( "cont_cmt_bloodyhell" );
//	
//	thread activate_players_key();
//	
//	//There's no time to explain! Roach! Turn that key over there! Hurry! They've scrambled MiGs to take us out!
//	level.price dialogue_queue( "cont_pri_notime" );	
//	
//	level notify( "stop_sub_enemies" );
//	thread dialog_turn_key_nags();
//	
//	flag_wait( "player_turned_key" );
//	thread handle_exit_sub();
//	
//	//Missiles are ready for launch. Ten�Nine�Eight�Seven�Six...Five�Four�Three�Two�One�ignition on missiles 1 through 4 and 8 through 12 for strategic missile launch.	
//}	
//
//
//start_exit_sub()
//{
//	start = getstruct( "exit_sub_start_player", "targetname" );
//	level.player setOrigin( start.origin );
//	level.player setPlayerAngles( start.angles );
//	
//	friendlies = getentarray( "start_friendly", "targetname" );
//	//friendlies2 = getentarray( "rasta_and_bricktop", "targetname" );
//	//friendlies = array_combine( friendlies, friendlies2 );
//	
//	//array_thread( friendlies, ::spawn_ai );
//	friendly_starts = getstructarray( "exit_sub_start_friendly", "targetname" );
//	
//	for ( i = 0 ; i < friendlies.size ; i++ )
//	{
//		friendlies[ i ].origin = friendly_starts[ i ].origin;
//		friendlies[ i ].angles = friendly_starts[ i ].angles;
//		friendlies[ i ] spawn_ai();
//	}
//	flag_set( "stop_stealth_music" );
//	music_stop();
//	
//	level.player takeallweapons();
//	level.player giveWeapon( "aa12" );
//	level.player giveWeapon( "m240_heartbeat_reflex_arctic" );
//	level.player switchToWeapon( "m240_heartbeat_reflex_arctic" );
//
//	level.player giveWeapon( "fraggrenade" );
//	level.player setOffhandSecondaryClass( "flash" );
//	level.player giveWeapon( "flash_grenade" );
//		
//	
//	wait .1;
//	
//	//level.rasta set_force_color( "g" );
//	//level.rasta enable_ai_color();
//	//level.bricktop set_force_color( "g" );
//	//level.bricktop enable_ai_color();
//	//level.price set_force_color( "g" );
//	//level.price enable_ai_color();
//	
//	level.price forceUseWeapon( "aug_scope", "primary" );
//	
//	disable_stealth_system();
//	
//	friendlies = getaiarray( "allies" );
//		foreach( g in friendlies )
//			g thread turn_off_stealth_settings();
//			
//	thread spawn_second_uav();
//	flag_set( "player_on_ridge" );
//	flag_set( "leaving_village" );
//	
//	thread handle_exit_sub();
//}
//
//handle_exit_sub()
//{
//	level notify( "stop_snow" );
//	level.soap_truck = spawn_vehicle_from_targetname( "soap_truck" );
//	level.soap_truck.dontunloadonend = true;
//	
//	
//	price_wait_for_truck_node = getnode( "price_wait_for_truck_node", "targetname" );
//	level.price setgoalnode( price_wait_for_truck_node );
//	
//	//We're done here! Let's go!	
//	level.price thread dialogue_queue( "cont_pri_donehereletsgo" );
//	
//	
//	flag_wait( "player_on_sub" );
//	
//	flee_pos = getstruct( "exit_sub_start_player", "targetname" ).origin;
//	enemies = getaiarray( "axis" );
//	foreach( guy in enemies )
//		guy thread enemies_flee( flee_pos );
//	
//	thread gopath( level.soap_truck );
//	
//	level.uaz = level.soap_truck;
//	level.uaz thread uaz_control();
//	
//	//Roach! Get to the truck! Move! Move!!	
//	level.price thread dialogue_queue( "cont_pri_gettotruck" );
//	
//	flag_wait( "soap_truck_arrived" );
//	
//	friendlies = [];
//	friendlies[ friendlies.size ] = level.price;
//	level.soap_truck thread vehicle_load_ai( friendlies );
//	
//	
//	flag_wait( "player_in_uaz" );
//	
//	soap_truck_reverse_path = getvehiclenode( "soap_truck_reverse_path", "targetname" );
//	soap_truck_exit_path = getvehiclenode( "soap_truck_exit_path", "targetname" );
//	
//	
//	
//	level.soap_truck StartPath( soap_truck_reverse_path );
//	//soap_truck thread maps\_vehicle::vehicle_paths( soap_truck_reverse_path );
//	//soap_truck.veh_pathdir = "reverse";
//	//soap_truck.veh_transmission = "reverse";
//	
//	wait 6;
//	
//	thread launch_nuke();
//	
//	//flag_wait( "soap_truck_finished_reverse" );
//	
//	//Sometimes you can't end a war with a bullet, Soap.	
//	level.price dialogue_queue( "cont_pri_endawar" );
//	
//	wait 2;
//	
//	level.soap_truck StartPath( soap_truck_exit_path );
//	//soap_truck thread maps\_vehicle::vehicle_paths( soap_truck_exit_path );
//	//soap_truck.veh_pathdir = "forward";
//	//soap_truck.veh_transmission = "forward";
//	
//	
//	
//	//level waittill( "forever" );
//	
//	
//	//iprintlnbold( "end of scripting" );
//	
//	wait 4;
//	
//	nextmission();
//}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
////***********************************************************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

base_arrival_music()
{
	flag_set( "stop_stealth_music" );
	music_stop( .5 );
	wait 1;
	
	level endon( "stop_base_arrival_music" );
	music_TIME = musicLength( "contingency_base_arrival" );
		
	while( 1 )
	{
		MusicPlayWrapper( "contingency_base_arrival" );
		wait music_TIME;
	}
}

breakforsub_music()
{
	flag_set( "stop_stealth_music" );
	level notify( "stop_base_arrival_music" );
	music_stop( 1 );
	//wait .1;
	//MusicPlayWrapper( "contingency_breakforsub" );
	level.player playsound( "contingency_breakforsub" );
}

save_when_x_are_killed()
{
	start_amount = level.enemies_killed;
	needed = 20 + start_amount;
	
	while( level.enemies_killed < needed )
		wait 1;
	
	autosave_by_name( "x_killed" );
}


magic_break_stealth()
{
	flag_wait( "magic_break_stealth" );	
	enemies = GetAISpeciesArray( "axis", "all" );
	if( enemies.size > 0 )
		enemies[0].favoriteenemy = level.player;
}

dialog_roach_change_guns()
{
	wait 4;
	weap = level.player getcurrentweapon();
	if( ( weap == level.starting_sidearm ) || ( weap == level.starting_rifle ) )
	{
		//Roach, they know we're here. You might want to grab a different weapon.	
		level.price dialogue_queue( "cont_pri_grabweapon" );
	}
}

spawn_ghosts_team()
{
	bricktop_spawner = getent( "bricktop", "script_noteworthy" );
	bricktop_spawner spawn_ai();
	rasta_spawner = getent( "rasta", "script_noteworthy" );
	rasta_spawner spawn_ai();
	
	if( isalive( level.gauntlet_east ) )
		level.gauntlet_east waittill( "death" );
		
	other_guys = getentarray( "village_redshirt", "script_noteworthy" );
	foreach( guy in other_guys )
		guy spawn_ai();
}

dialog_second_uav_in_position()
{
	//Soap - Rasta and Bricktop are here. 	
	level.price dialogue_queue( "cont_pri_rastaandbricktop" );
	
	//Roger that. The second UAV is almost in position.	
	radio_dialogue( "cont_cmt_2nduav" );
	
	flag_set( "said_second_uav_in_position" );
}

fake_treads()
{
	self thread maps\_vehicle::tread( "tag_wheel_back_left", "back_left", undefined, undefined, 25 );
	self thread maps\_vehicle::tread( "tag_wheel_back_right", "back_right", undefined, undefined, 25 );
	wait 8;
	self notify( "kill_treads_forever" );
}

faster_price_if_player_close()
{
	level.player endon( "death" );
	level endon( "safe_from_btrs" );
	while( 1 )
	{
		wait .1;
		
		if( distance( level.player.origin, level.price.origin ) < 400 )
		{
			level.price.moveplaybackrate = 1;
		}
		else
		{
			vec2 = VectorNormalize( ( level.player.origin - level.price.origin ) );
			vec = anglestoforward( level.price.angles );
			vecdot = vectordot( vec, vec2 );//dot of my angle vs player position
		
			//vecdot > 0 means in 180 in front
			if( vecdot > 0 )// player is in front of me
				level.price.moveplaybackrate = 1;
			else
				level.price.moveplaybackrate = .9;
		}
	}
}

dialog_price_splits_off()
{
	//I'm going for the sub!	
	level.price dialogue_queue( "cont_pri_goingforsub" );	
	//Cover me from that guardhouse by the west gate!	
	level.price dialogue_queue( "cont_pri_coverme" );
	//Roger that!	
	level.rasta dialogue_queue( "cont_gst_rogerthat" );
	//Roach, we have to get to that guardhouse by the west gate to cover Price! Follow me!	
	level.rasta dialogue_queue( "cont_gst_guardhouse" );
	
	while( !flag( "player_on_guardhouse" ) )
	{ 
		wait 20;
		if( flag( "player_on_guardhouse" ) )
			return;
		//Cover me from that guardhouse by the west gate!	
		level.price dialogue_queue( "cont_pri_coverme" );
	
		wait 20;
		
		if( flag( "player_on_guardhouse" ) )
			return;
		//Roach, we have to get to that guardhouse by the west gate to cover Price! Follow me!	
		level.rasta dialogue_queue( "cont_gst_guardhouse" );
	}
}

setup_defend_sub_vehicles()
{
	wait 24;
	
	level.defend_sub_truck2 = spawn_vehicle_from_targetname_and_drive( "defend_sub_truck2" );
	level.defend_sub_truck2 thread friendlies_shoot_at_truck_until_its_unloads();
	level.defend_sub_truck2 thread dialog_destroyed_vehicle( "cont_cmt_goodkilltruck" );
	wait 1;
	level.defend_sub_truck3 = spawn_vehicle_from_targetname_and_drive( "defend_sub_truck3" );
	level.defend_sub_truck3 thread friendlies_shoot_at_truck_until_its_unloads();
	level.defend_sub_truck3 thread dialog_destroyed_vehicle( "cont_cmt_goodkilltruck" );
	wait 3;
	
	
	//Incoming! Two trucks to the east!	
	level.rasta thread dialogue_queue( "cont_gst_twotruckseast" );
	
	
	wait 15;
	
	level.defend_sub_truck1 = spawn_vehicle_from_targetname_and_drive( "defend_sub_truck1" );
	level.defend_sub_truck1 thread friendlies_shoot_at_truck_until_its_unloads();
	level.defend_sub_truck1 thread dialog_destroyed_vehicle( "cont_cmt_goodkilltruck" );
	wait 2;
	level.defend_sub_jeep1 = spawn_vehicle_from_targetname_and_drive( "defend_sub_jeep1" );
	level.defend_sub_jeep1 thread friendlies_shoot_at_truck_until_its_unloads();
	level.defend_sub_jeep1 thread dialog_destroyed_vehicle( "cont_cmt_goodkilltruck" );
	
	//level.defend_sub_btr1 = spawn_vehicle_from_targetname_and_drive( "defend_sub_btr1" );
	//level.defend_sub_btr1 thread friendlies_shoot_at_truck_until_its_unloads();
	//level.defend_sub_btr1 thread vehicle_lights_on( "spotlight spotlight_turret" );
	wait 3;
	
	//More vehicles to the east! Use the Hellfires!	
	level.rasta thread dialogue_queue( "cont_gst_morevehicleseast" );
	
	//wait 8;
	//if( isalive( level.defend_sub_btr1 ) )
	//{
	//	end_if_cant_see = false;
	//	no_misses = false;
	//	level.defend_sub_btr1 thread bmp_turret_attack_player( end_if_cant_see, no_misses );
	//}
}

setup_vehicle_gate( stringname )
{
	flag_wait( stringname );
	gates = getentarray( stringname, "targetname" );
	foreach( gate in gates )
	{
		dir = -160;
		if( gate.script_noteworthy == "left" )
			dir = 160;
		
		gate movex( dir, 2, 1, 0 );
	}
	
	while( 1 )
	{
		flag_clear( stringname );
		wait .2;
		if( !flag( stringname ) )
			break;
	}
	
	
	foreach( gate in gates )
	{
		dir = 160;
		if( gate.script_noteworthy == "left" )
			dir = -160;
		
		gate movex( dir, 2, 1, 0 );
	}
}

setup_sub_hatch()
{
	sub_hatch_th = getent( "sub_hatch_th", "targetname" );
	sub_hatch_th trigger_off();
	hatch_model = getent( "hatch_model", "targetname" );
	hatch_model_collision = getent( "hatch_model_collision", "targetname" );
	hatch_model_collision linkto( hatch_model );
	hatch_model rotatepitch( 120, .05 );
	
	flag_wait( "close_sub_hatch" );
	hatch_model rotatepitch( -120, 5 );
	wait 2;
	sub_hatch_th trigger_on();
	wait 4;
	sub_hatch_th trigger_off();
}

	
open_sub_missile_doors()
{
	sub_missile_doors = getentarray( "sub_missile_door", "targetname" );
	
	current_side = "left";
	current_num = 1;
	open_time = 2;
	shake_time = .1;
	time_between_doors = 1.6;
	
	while( 1 )
	{
		foreach( door in sub_missile_doors )
		{
			if( ( door.script_noteworthy == current_side ) && ( int( door.script_namenumber ) == current_num ) )
			{
				door thread open_sub_missile_door_action( open_time, shake_time );
				
				if( current_side == "left" )
				{
					current_side = "right";
				}
				else
				{
					current_side = "left";
					current_num++;
				}
				if( current_num > 4 )
					return;
				wait time_between_doors;
				break;
			}
		}
	}
}

open_sub_missile_door_action( open_time, shake_time )
{
	org = Spawn( "script_origin", ( 0, 0, 1 ) );
	org.origin = self.origin;
	org PlaySound( "missile_hatch_slams_open", "sounddone" );
	
	door = self;
	if( door.script_noteworthy == "left" )
		door rotateroll( -60, open_time, .2 );
	else
		door rotateroll( 60, open_time, .2 );
		
	wait open_time;
	door rotateroll( -1, shake_time );
	wait shake_time;
	door rotateroll( 1, shake_time );
	wait shake_time;
	
	wait 1;
	org stopsounds();
	wait 1;
	org delete();
}

dialog_looking_for_us()
{
	flag_wait( "first_patrol_cqb" );
	first_patrol_cqb = getentarray( "first_patrol_cqb", "targetname" );
	foreach( guy in first_patrol_cqb )
		guy spawn_ai();
	
	wait 6;
	
	//Looks like they're searching for us.	
	radio_dialogue( "cont_pri_searchingforus" );
}

launch_nuke()
{
	//level.player playsound( "scn_icbm_missile_launch" );
	//icbm_missile01 thread play_loop_sound_on_entity( "scn_icbm_missile2_loop" );
	
	
	icbm_missile01 = getent( "icbm_missile01", "targetname" );
	missile01_start = getent( "missile01_start", "targetname" );
	missile01_end = getent( "missile01_end", "targetname" );
	
	//PlayFX( getfx("icbm_launch") , icbm_missile01.origin );

	//Earthquake( <scale>, <duration>, <source>, <radius> )
	earthquake( 0.3, 12, icbm_missile01.origin, 8000 );

	level.player PlayRumbleLoopOnEntity( "tank_rumble" );
	level.player delaycall( 8.0, ::stopRumble, "tank_rumble" );

	icbm_missile01 playsound( "scn_con_icbm_ignition" );

	icbm_missile01 linkto( missile01_start );
	//point, time, accel time, decel time
	missile01_start moveto( missile01_end.origin, 50, 10, 0 );
	// icbm_missile thread maps\_utility::playSoundOnTag( "parachute_land_player" );
	playfxontag( level._effect[ "smoke_geotrail_icbm" ], icbm_missile01, "TAG_NOZZLE" );
	exploder( "icbm_launch" );
	//playfxontag( level._effect[ "smoke_geotrail_icbm" ], icbm_missile01, "tag_origin" );
	
	wait 1; 
	
	if( distance( level.player.origin, missile01_start.origin ) < 600 )
		level.player dodamage( ( level.player.health + 1000 ), missile01_start.origin );
	
	icbm_missile01 playloopsound( "scn_con_icbm_rocket_loop" );
	
	missile01_start waittill( "movedone" );
	icbm_missile01 delete();
}


uaz_control()
{
	trigger = spawn( "trigger_radius", self gettagorigin( "tag_passenger" ) + (0,0,-48), 0, 72, 72);
	trigger enablelinkto();
	trigger linkto( self );
	trigger waittill( "trigger" );

	level.player allowProne( false );
	level.player allowCrouch( false );
	level.player allowStand( true );

	enablePlayerWeapons( false );
	level.player.rig = spawn_anim_model( "player_rig" );
	level.player.rig hide();

	level.player.rig linkto( self, "tag_body" );
	self thread anim_single_solo( level.player.rig, "boneyard_uaz_mount" , "tag_body" );
	self thread ride_uaz_door();

	level.player PlayerLinkToBlend( level.player.rig, "tag_player", 0.5 );
	wait 0.5;
	level.player.rig show();
	level.player PlayerLinkToDelta( level.player.rig, "tag_player", 0.5, 180, 180, 75, 25, true );

	self waittill( "boneyard_uaz_mount" );

//	self thread player_rig_adjust_height();

	level.player.rig hide();
	//enablePlayerWeapons( true );
	level.player LerpViewAngleClamp( 0.5, 0.5, 0, 180, 180, 75, 35 );
	
	flag_set( "player_in_uaz" );
}


spawn_sub_enemies()
{
	level endon( "stop_sub_enemies" );
	sub_enemies = getentarray( "sub_enemies", "targetname" );//6 total
	while( 1 )
	{
		desired = 1 + randomint( 3 );
		while( desired > 0 )
		{
			sub_enemies[ (desired-1) ] spawn_ai();
			desired--;
		}
		wait randomintrange( 4, 14 );
	}
}

sub_ladder()
{
	flag_wait( "player_on_sub" );
	sub_ladder = getent( "sub_ladder", "targetname" );
	
	sub_ladder.realOrigin = sub_ladder.origin;
	sub_ladder.origin += ( 0, 0, -10000 );
	
	flag_wait( "player_turned_key" );
	
	sub_ladder.origin = sub_ladder.realOrigin;
}

single_shots()
{
	self.shootstyle = "single";
}

activate_players_key()
{
	flag_set( "player_key_rdy" );
	players_key = getent( "players_key", "targetname" );
	players_key glow();
	
	players_key setCursorHint( "HINT_NOICON" );
	// Press and hold ^3&&1^7 to pick up the turret.
	players_key setHintString( &"CONTINGENCY_TURN_KEY" );
	players_key makeUsable();
	
	players_key waittill( "trigger", player );
	
	//predator_drone_control playsound( "scn_invasion_controlrig_pickup" );
	flag_set( "player_turned_key" );
	players_key stopGlow();
	players_key makeUnusable();
	
}

dialog_turn_key_nags()
{
	wait 10;
	first_line = true;
	while( !flag( "player_turned_key" ) )
	{
		if( first_line )
		{
			//Roach! We're running out of time! Turn the key!!!	
			level.price dialogue_queue( "cont_pri_runningout" );
			first_line = false;
		}
		else
		{
			//Roach! Trust me! Turn - your - key!!!	
			level.price dialogue_queue( "cont_pri_trustme" );
			first_line = true;
		}
		wait 10;
	}
}

start_tear_gas_guys()
{
	flag_wait( "player_dropping_into_sub" );
	tear_gas_nodes = getentarray( "tear_gas_nodes", "script_noteworthy" );
	foreach( anode in tear_gas_nodes )
	{
		spawner = getent( anode.target, "targetname" );
		anim_name = anode.script_animation;
		spawner add_spawn_function( ::setup_tear_gas_guy, anim_name, anode );
		spawner spawn_ai();
	}
}

start_tear_gas_fx()
{
	flag_wait( "player_dropping_into_sub" );
	exploder( "tear_gas_submarine" );
}

setup_tear_gas_guy( anim_name, anode )
{
	self.health = 1;
	//self gun_remove();
	self.allowdeath = true;	
	self.ragdoll_immediate = true;
	anode thread anim_generic( self, anim_name );
}

debug_timer()
{
	time_past = 0;
	while( time_past < 70 )
	{	
		wait .05;
		time_past = time_past + .05;
		println( "time past: " + time_past );
	}
}

put_on_player_gas_mask()
{
	//thread debug_timer();
	//orig_nightVisionFadeInOutTime = GetDvar( "nightVisionFadeInOutTime" );
	//orig_nightVisionPowerOnTime = GetDvar( "nightVisionPowerOnTime" );
	//SetSavedDvar( "nightVisionPowerOnTime", 0.5 );
	//SetSavedDvar( "nightVisionFadeInOutTime", 0.5 );
	//SetSavedDvar( "overrideNVGModelWithKnife", 1 );
	//SetSavedDvar( "nightVisionDisableEffects", 1 );

	level.player disableweapons();
	//level.player takeallweapons();
	level.player giveweapon( "facemask" );
	level.player switchtoWeapon( "facemask" );

	//wait( 0.01 );// give the knife override a frame to catch up
	level.player ForceViewmodelAnimation( "facemask", "nvg_down" );
	wait( 2.0 );
	level.player thread play_loop_sound_on_tag( "gas_mask_breath" );
	SetSavedDvar( "hud_gasMaskOverlay", 1 );
	wait( 2.5 );
	level.player takeweapon( "facemask" );
	level.player enableweapons();
	//level.player playloopsound( "gas_mask_breath" );
	//SetSavedDvar( "nightVisionDisableEffects", 0 );
	//SetSavedDvar( "overrideNVGModelWithKnife", 0 );
	//SetSavedDvar( "nightVisionPowerOnTime", orig_nightVisionPowerOnTime );
	//SetSavedDvar( "nightVisionFadeInOutTime", orig_nightVisionFadeInOutTime );
}


nag_player_to_destroy_btr()
{
	level endon( "base_btr2_dead" );
	while( 1 )
	{
		flag_wait( "nag_player_to_destroy_btr" );	
		
		//Destroy that armored vehicle!	
		level.price dialogue_queue( "cont_pri_armoredvehicle" );	
		
		wait 10;
	}
}

//spawn_village_trucks_at_right_time()
//{
//	while( level.village_defenders_dead < 6 )
//		wait 1;
//		
//	level.village_troop_transport = spawn_vehicle_from_targetname_and_drive( "village_troop_transport" );
//	level.village_troop_transport thread friendlies_shoot_at_truck_until_its_unloads();
//	level.village_troop_transport thread maps\_remotemissile::setup_remote_missile_target();
//	
//	wait 1;
//	
//	level.village_troop_transport2 = spawn_vehicle_from_targetname_and_drive( "village_troop_transport2" );
//	level.village_troop_transport2 thread maps\_remotemissile::setup_remote_missile_target();
//	level.village_troop_transport2 thread friendlies_shoot_at_truck_until_its_unloads();
//}


unload_base_truck()
{
	level.base_truck1 endon( "death" );
	level.base_truck1 Vehicle_SetSpeed( 0, 15 );
	//wait .1;
	level.base_truck1 maps\_vehicle::vehicle_unload();
	
	wait 1;
	
	
	if( isdefined( level.base_truck1.has_target_shader ) )
	{
		level.base_truck1.has_target_shader = undefined;
		Target_Remove( level.base_truck1 );
	}
	
	if( isdefined( level.remote_missile_targets  ) )
		level.remote_missile_targets = array_remove( level.remote_missile_targets, level.base_truck1 );
}

turn_off_stealth_settings()
{
	self disable_stealth_for_ai();
	self.no_pistol_switch = undefined;
	self.ignoreall = false;
	self.fixednode = true;
	self thread set_battlechatter( true );
	self set_friendlyfire_warnings( true );
	self.dontEverShoot 	= undefined;
	self.grenadeammo 	= 3;
	self.ignoreme 	 	= false;
	self pushplayer( false );
	self.ignoresuppression = false;
}

base_alarm_sound()
{
	dialog = [];
	//The base is under attack! I repeat, the base is under attack! Alert! Alert! They may be trying to reach the Kamarov!	
	dialog[dialog.size] = "cont_bpa_underattack";
	//Terminate enemy forces with extreme prejudice! Do not allow them to sink the Kamarov!
	dialog[dialog.size] = "cont_bpa_prejudice";
	//2nd Platoon, reinforce submarine pens two, five, and seven! Establish blocking positions to the east and west of the mess hall to stop the intruders!	
	dialog[dialog.size] = "cont_bpa_2ndplatoon";
	//Alert! Enemy forces have penetrated the perimeter and are making their way towards the submarines! 
	dialog[dialog.size] = "cont_bpa_alert";
	//All submarine maintenance crews, get to your battlestation and prepare to dive immediately! I repeat, all submarine maintenance crews, get to your battlestations and prepare to dive immediately!	
	dialog[dialog.size] = "cont_bpa_battlestations";
	current = 0;
	
	base_pa = getent( "base_pa", "targetname" );
	base_alarm_sound = getent( "base_alarm_sound", "targetname" );
	while( !flag( "price_splits_off" ) )
	while( 1 )
	{
		base_alarm_sound playloopsound( "emt_alarm_base_alert" );
		base_alarm_sound.playing = true;
		wait 8;
		base_alarm_sound StopLoopSound();
		base_alarm_sound.playing = undefined;
		
		wait 1;
		
		base_pa playsound( dialog[ current ] );
		current++;
		if( current >= dialog.size )
			current = 0;
		
		wait 12;
	}
	if( isdefined( base_alarm_sound.playing ) )
		base_alarm_sound StopLoopSound();
}

waittill_base_alerted()
{
	level endon( "base_alerted" );
	level endon( "_stealth_spotted" );
	level.player waittill( "projectile_impact", weaponName, position, radius );
}

setup_remote_missile_target_guy()
{
	if( isdefined( self.ridingvehicle ) )
	{
		self endon( "death" );
		self waittill( "jumpedout" );
		
	}
	self thread maps\_remotemissile::setup_remote_missile_target();
}


dialog_destroyed_vehicle( dialog )
{
	self endon( "unloaded" );
	self waittill( "death" );
	
	wait .05;//so that old_veh_num is accurate
	
	if( !isdefined( level.vehicles_killed ) )
		level.vehicles_killed = 1;
	else
		level.vehicles_killed++;
		
	level.veh_type = dialog;
}


setup_count_predator_infantry_kills()
{
	self waittill( "death" );
	
	if( isdefined( self.ridingvehicle ) )
		return;
		
	wait .05;
	
	if( !isdefined( level.enemies_killed ) )
		level.enemies_killed = 1;
	else
		level.enemies_killed++;
}


dialog_handle_predator_infantry_kills()
{
	dialog = [];
	dialog[dialog.size] = "cont_cmt_mutlipleconfirmed";
	dialog[dialog.size] = "cont_cmt_3kills";
	dialog[dialog.size] = "cont_cmt_theyredown";
	
	last_line = 0;
	said_direct_hit = false;
	level.enemies_killed = 0;
	level.vehicles_killed = 0;
	said_good_effect = false;
	kills = 0;
	
	while( 1 )
	{
		level waittill( "remote_missile_exploded" );
		old_num = level.enemies_killed;
		old_veh_num = level.vehicles_killed;
		
		wait .3;
		
		veh_kills = level.vehicles_killed - old_veh_num;
		
		if( isdefined( level.uav_killstats[ "ai" ] ) )
			kills = level.uav_killstats[ "ai" ];
		
		//wait a bit before saying the line
		wait 1.2;
		
		if( flag( "saying_base_on_alert" ) )
			continue;
		
		if( veh_kills == 1 )
		{
			radio_dialogue( level.veh_type );
			continue;
		}
		if( veh_kills > 1 )
		{
			
			if( said_good_effect )
			{
				//Good hit. Multiple vehicles destroyed.	
				radio_dialogue( "cont_cmt_goodhitvehicles" );
				said_good_effect = false;
			}
			else
			{
				//Good effect on target. Multiple enemy vehicles KIA.	
				radio_dialogue( "cont_cmt_goodeffectkia" );
				said_good_effect = true;
			}
			continue;
		}
		
		if( kills == 0 )
		{
			continue;
		}
		if( kills == 1 )
		{
			if( said_direct_hit )
			{
				radio_dialogue( "cont_cmt_hesdown" );
				said_direct_hit = false;
			}
			else
			{
				radio_dialogue( "cont_cmt_directhit" );
				said_direct_hit = true;
			}
			continue;	
		}
		if( kills > 5 )
		{
			radio_dialogue( "cont_cmt_fivepluskias" );
			continue;
		}
		else
		{
			radio_dialogue( dialog[last_line] );
			last_line++;
			if( last_line >= dialog.size )
				last_line = 0;
			continue;
		}
	}
}

setup_base_vehicles()
{
//	self.free_on_death = true;

	self endon( "death" );
	self thread vehicle_death_paths();
	self thread unload_when_stuck();
	self thread maps\_remotemissile::setup_remote_missile_target();
	
	self waittill( "unloaded" );
	
	if( isdefined( self.has_target_shader ) )
	{
		self.has_target_shader = undefined;
		Target_Remove( self );
	}
		
	level.remote_missile_targets = array_remove( level.remote_missile_targets, self );
}

dead_vehicle_blocking_path()
{
	count = 0;
	last_bad_path_time = -10000;
	while( 1 )
	{
		// bad_path nofies are every 0.5 seconds
		self waittill( "bad_path" );

		if ( GetTime() - last_bad_path_time < 5000 )
		{
			count++;
		}
		else
		{
			count = 0;
			last_bad_path_time = GetTime();
		}

		// We sat here too long with a bad path, see if there are any dead script vehicles blocking us
		if ( count >= 9 ) // 9 to be safe, since bad_paths are notified every 0.5 seconds... Meaning 10 notifies every 5 seconds.
		{
			count = 0;
			foreach ( vehicle in level.dead_vehicles )
			{
				if ( IsDefined( vehicle ) && !IsAlive( vehicle ) && DistanceSquared( vehicle.origin, self.origin ) < 300 * 300 )
				{
					vehicle thread dead_vehicle_enable_paths_thread();
				}
			}
		}
	}
}

dead_vehicle_enable_paths_thread()
{
	self notify( "stop_vehicle_enabled_paths" );
	self endon( "stop_vehicle_enabled_paths" );

	self.dead_vehicle_enable_paths = true;
	self ConnectPaths();

	wait( 5 );

	self DisconnectPaths();
	self.dead_vehicle_enable_paths = undefined;
}

vehicle_death_paths()
{
	self endon( "delete" );

	// Notify from _vehicle::vehicle_kill, after the phys vehicle is blown up and disconnectpaths
	self waittill( "kill_badplace_forever" );

	level.dead_vehicles[ level.dead_vehicles.size ] = self;

	min_dist = 50 * 50;
	death_origin = self.origin;
	
	while ( IsDefined( self ) )
	{
		if ( IsDefined( self.dead_vehicle_enable_paths ) )
		{
			wait( 0.5 );
			continue;
		}

		if ( DistanceSquared( self.origin, death_origin ) > min_dist )
		{
			death_origin = self.origin;

			// Connect the paths before we get to far away from the death_origin
			self ConnectPaths();

			// Don't disconnectpaths until we're done moving.
			while ( 1 )
			{
				if ( IsDefined( self.dead_vehicle_enable_paths ) )
				{
					wait( 0.5 );
					continue;
				}

				wait( 0.05 );
				if ( !IsDefined( self ) )
				{
					return;
				}

				if ( DistanceSquared( self.origin, death_origin ) < 1 )
				{
					break;
				}

				death_origin = self.origin;
			}

			// Now disconnectpaths after we have settled
			self DisconnectPaths();
		}

		wait( 0.05 );
	}
}

unload_when_stuck()
{
	self endon( "unloading" );
	self endon( "death" );
	while( 1 )
	{
		wait 2;
		if( self Vehicle_GetSpeed() < 2 )
		{
			self Vehicle_SetSpeed( 0, 15 );
			self.dontunloadonend = true;
			self thread maps\_vehicle::vehicle_unload();
			return;
		}
	}
}

unload_when_close_to_player()
{
	self endon( "unloading" );
	self endon( "death" );
		
	self waittill_entity_in_range( level.player, 1000 );
	
	self Vehicle_SetSpeed( 0, 15 );
	self.dontunloadonend = true;
	self thread maps\_vehicle::vehicle_unload();
}

setup_base_idling_vehicles()
{
	//Direct hit on the enemy helo. Nice shot Roach.	
	//level.scr_radio[ "cont_cmt_directhitshelo" ]					 = "cont_cmt_directhitshelo";
	//Good effect on target. BTR destroyed.	
	//level.scr_radio[ "cont_cmt_btrdestroyed" ]					 = "cont_cmt_btrdestroyed";
	//Direct hit on that jeep.	
	//level.scr_radio[ "cont_cmt_directhitjeep" ]					 = "cont_cmt_directhitjeep";
	//Good kill. Truck destroyed.	
	//level.scr_radio[ "cont_cmt_goodkilltruck" ]					 = "cont_cmt_goodkilltruck";
	
	level.base_heli = spawn_vehicle_from_targetname( "base_heli" );
	level.base_heli.helicopter_predator_target_shader = true;
	level.base_heli.enableRocketDeath = true;
	level.base_heli thread maps\_remotemissile::setup_remote_missile_target();
	level.base_heli thread maps\_vehicle::damage_hint_bullet_only();
	level.base_heli thread dialog_destroyed_vehicle( "cont_cmt_directhitshelo" );
	
	level.base_btr2 = spawn_vehicle_from_targetname( "base_btr2" );
	level.base_btr2 thread maps\_remotemissile::setup_remote_missile_target();
	level.base_btr2 thread vehicle_lights_on( "spotlight spotlight_turret" );
	level.base_btr2 thread dialog_destroyed_vehicle( "cont_cmt_btrdestroyed" );
//	level.base_btr2.free_on_death = true;
	
	level.base_truck1 = spawn_vehicle_from_targetname( "base_truck1" );
	level.base_truck1 thread maps\_remotemissile::setup_remote_missile_target();
	level.base_truck1 thread dialog_destroyed_vehicle( "cont_cmt_directhitjeep" );
//	level.base_truck1.free_on_death = true;
	
	thread vehicles_move_when_player_can_see_them();
}

setup_friendlies_for_base()
{
	friendlies = getaiarray( "allies" );
	foreach( guy in friendlies )
	{
		guy enable_ai_color();
		guy set_force_color( "g" );
		guy.pathrandompercent = 200;
		guy.dontevershoot = true;
		guy set_battlechatter( false );
		guy set_friendlyfire_warnings( false );
	}
	
	level.price set_force_color( "r" );
	
	flag_wait( "obj_base_entrance" );
	
	flag_set( "everyone_set_green" );
	level.price set_force_color( "g" );
	
	flag_wait( "base_alerted" );
	
	friendlies = getaiarray( "allies" );
	foreach( guy in friendlies )
	{
		guy.dontevershoot = undefined;
		guy set_battlechatter( true );
		guy set_friendlyfire_warnings( true );
	}
}

vehicles_move_when_player_can_see_them()
{
	while( ( !isdefined( level.player.is_controlling_UAV ) ) && !flag( "obj_base_entrance" ) )
		wait .05;
		
	thread gopath( level.base_btr2 );
	thread gopath( level.base_truck1 );
}

stealth_ai_ignore_tree_explosions()
{
	ai_event[ "ai_eventDistExplosion" ] = [];
	ai_event[ "ai_eventDistExplosion" ][ "spotted" ]	 = 0;
	ai_event[ "ai_eventDistExplosion" ][ "hidden" ] 	 = 0;
	stealth_ai_event_dist_custom( ai_event );
	
	
	flag_wait( "done_with_exploding_trees" );
	wait 1;
	
	ai_event[ "ai_eventDistExplosion" ] = [];
	ai_event[ "ai_eventDistExplosion" ][ "spotted" ]	 = level.explosion_dist_sense;
	ai_event[ "ai_eventDistExplosion" ][ "hidden" ] 	 = level.explosion_dist_sense;
	stealth_ai_event_dist_custom( ai_event );
}

dialog_moving_to_new_position_in_village( p_node )
{
	if( !isdefined( level.dialog_moving_to_new_position_time ) )
	{
		level.dialog_moving_to_new_position_time = gettime();
	}
	else
	{
		if( gettime() < ( level.dialog_moving_to_new_position_time + ( 15 * 1000 ) ) )
			return;
	}
	level.dialog_moving_to_new_position_time = gettime();
	
	friendlies = getaiarray( "allies" );
	
	friendlies[ randomint( friendlies.size ) ] custom_battlechatter( "order_move_combat" );
}


enemies_flee( flee_pos )
{
	self endon ( "death" );
	
	self setgoalpos( flee_pos );
	
	self.ignoreme = true;
	self.goalradius = 96;
	self waittill( "goal" );
	while( self cansee ( level.player ) )
		wait 1;
	self kill();
}

village_enemies_setup_retreat( retreat_pos )
{
	self endon ( "death" );
	flag_wait( "leaving_village" );
	
	self setgoalpos( retreat_pos );
	
	self.ignoreme = true;
	self.goalradius = 32;
	self waittill( "goal" );
	while( self cansee ( level.player ) )
		wait 1;
	self kill();
}

smart_barney( end_flag, end_goal, end_volume )
{
	self notify( "stop_barney" );
	self endon( "stop_barney" );
	self endon( "death" );
	self ClearGoalVolume();
	self thread friendly_adjust_movement_speed();
	self.goalheight = 200;
	self.goalradius = 300;
	//level.taco setgoalentity( level.player );
	self.fixednode = false;
		
	while( !flag( end_flag ) )
	{
		player = level.player.origin;
		vec = VectorNormalize( end_goal - player );
		forward = vector_multiply( vec, 400 );
		goal = forward + player;
		self setgoalpos( goal );
		//println(" player " + level.player.origin + " goal " + forward );
		
		//if( !isdefined( self.favoriteenemy ) )
		//{
		//	goal_enemies = end_volume get_ai_touching_volume( "axis" );
		//	if( goal_enemies.size )
		//		self.favoriteenemy = goal_enemies[0];
		//}
		//check for nearby BMPs
		wait .5;
	}
	self notify( "stop_adjust_movement_speed" );
	self.moveplaybackrate = 1.0;
		
	self setgoalpos( end_goal );
	if( isdefined( end_volume ) )
		self setgoalvolume( end_volume );
}



price_changes_weapons()
{
	flag_wait( "going_down_ridge" );
	count = 3 * 20;
	base_time = count;
	dot = .9;
	dot_only = true;
			
	for ( ;; )
	{
		org = level.price GetEye();

		if ( !player_looking_at( org, dot, dot_only ) )
		{
			count--;
			if ( count <= 0 )
				break;
		}
		else
		{
			count = base_time;
		}
		wait( 0.05 );
	}
	
	level.price forceUseWeapon( "aug_scope", "primary" );
	//level.price forceUseWeapon( "ak47_arctic_acog", "primary" );
	
}

village_enemies()
{
}

friendlies_shoot_at_truck_until_its_unloads()
{
	//self endon( "death" );
	self MakeEntitySentient( "axis" );
	self waittill_either( "unloaded", "death" );
	self.ignoreme = true;
}



//kill_all_enemies_when_going_down_ridge()
//{
//	flag_wait ( "going_down_ridge" );
//	
//	if( !flag( "_stealth_spotted" ) )
//	{
//		enemies = getaiarray( "axis" );
//		foreach( mf in enemies )
//			mf delete();
//	}
//	disable_stealth_system();
//}

handle_stealth_spotted()
{
	level endon( "price_starts_moving" );
	flag_wait( "_stealth_spotted" );	
	level.price anim_stopanimscripted();
}

price_intro_anim()
{
	spot = getstruct( "price_intro_talk_struct", "script_noteworthy" );
	spot thread handle_stealth_spotted();
	spot anim_reach_solo( level.price, "intro" );
	spot anim_single_solo( level.price, "intro" );
	
	flag_set( "price_starts_moving" );
	
	level.price notify( "_utility::follow_path" );
	level.price notify( "stop_going_to_node" );// kills the last call to go_to_node
	level.price disable_ai_color();
	level.price thread enable_cqbwalk();
	price_smart_path_to_road = getnode( "price_smart_path_to_road", "targetname" );
	level.price thread price_smart_path_following( price_smart_path_to_road );
}

price_slides_down_the_ridge()
{
	flag_wait( "price_on_ridge" );
	wait 3;
	flag_wait( "going_down_ridge" );
	
	//level.price allowedstances( "stand" );
	
	buddy_slide_node = getent( "ridge_price_overlook_org", "targetname" );
	//buddy_slide_node = getstruct( "buddy_slide_node", "targetname" );
	//buddy_slide_node anim_reach_solo( level.price, "slide" );
	buddy_slide_node anim_single_solo( level.price, "slide" );
	//level.price allowedstances( "stand", "crouch", "prone" );
	
	level.price thread disable_cqbwalk();
	if( !flag( "everyone_set_green" ) )
		level.price set_force_color( "r" );
	level.price enable_ai_color();
	
	activate_trigger_with_targetname( "price_in_village_start" );
}


kill_helicopter_fail_safe()
{
	flag_wait( "price_splits_off" );
	wait 2;
	if( !isalive( level.base_heli ) )
		return;
	
	origin = ( -13500.0, 876.0, 749.0 );
		
	kill_heli_fail_safe = getstruct( "kill_heli_fail_safe", "targetname" );
	if( isdefined( kill_heli_fail_safe ) )
		origin = kill_heli_fail_safe.origin;
	newMissile = MagicBullet( "zippy_rockets", origin, level.base_heli.origin );

	newMissile Missile_SetTargetEnt( level.base_heli ); 
}

fire_stinger( stinger_source )
{
	forward = AnglesToForward( level.uav.angles );
	forwardfar = vector_multiply( forward, 10000 );
	end = forwardfar + level.uav.origin;


	if( isdefined( level.player.is_controlling_UAV ) )
	{
		//muzzlflash
		PlayFX( getfx( "thermal_missle_flash_inverted" ), stinger_source );
		newMissile = MagicBullet( "zippy_rockets_inverted", stinger_source, end );
	}
	else
	{
		PlayFX( getfx( "missle_flash" ), stinger_source );
		newMissile = MagicBullet( "zippy_rockets", stinger_source, end );
	}
	
	newMissile Missile_SetTargetEnt( level.uav ); 
	
	return newMissile;
}


setup_dont_leave_hint()
{
	while( 1 )
	{
		//player_returning_to_map
		flag_wait( "player_leaving_map" );
	
		display_hint_timeout( "hint_dont_leave_price", 5 );
		
		wait 5;
	}
}

setup_dont_leave_failure()
{
	flag_wait( "player_left_map" );
	
	level notify ( "mission failed" );
	setDvar( "ui_deadquote", &"CONTINGENCY_DONT_LEAVE_FAILURE");	
	maps\_utility::missionFailedWrapper();	
}

flag_when_all_bridge_guys_dead()	
{	
	flag_wait( "truckguys_dead" );
	flag_wait( "cross_bridge_patrol_dead" );
	flag_wait( "first_stragglers_dead" );
	flag_wait( "rightside_patrol_dead" );
	flag_set( "all_bridge_guys_dead" );
}

should_break_dont_leave()
{
	if( flag( "player_returning_to_map" ) )
		return true;
	else
		return false;	
}

should_break_use_drone()
{
	break_hint = false;
	if( isdefined( level.uav_is_destroyed ) )
		break_hint = true;
	if( !isalive( level.uav ) )
		break_hint = true;
	if( isdefined( level.player.is_flying_missile ) )
		break_hint = true;
	if( flag( "base_alerted" ) )
		break_hint = true;
	if( level.player getCurrentWeapon() == "remote_missile_detonator" )
		break_hint = true;
	
	return break_hint;	
}

should_break_steer_drone()
{
	break_hint = false;
	if( level.player getCurrentWeapon() == "remote_missile_detonator" )
		break_hint = true;
	if( ( level.hint_steer_drone_time + 5000 ) < gettime() )
		break_hint = true;
	
	return break_hint;	
}



fire_stinger_at_uav( stinger_source )
{
	level.uav maps\_vehicle::godoff();
	level.uav.health = 400;
	
	attractor = Missile_CreateAttractorEnt( level.uav, 100000, 60000 );
	
	
	stinger_source playsound( "gauntlet_fires" );
	stinger_source playsound( "gauntlet_ignition" );

	newMissile = fire_stinger( stinger_source.origin );
	
	
	old_org = level.uav.origin;
	old_dist = 9999999999;
	while ( IsDefined( newMissile ) )
	{
		if( !isalive( level.uav ) )
			break;
		dist = Distance( newMissile.origin, level.uav.origin );
		if ( dist <= 200 )
			break;
		if( dist > old_dist )
			break;
		old_dist = dist;
		old_org = level.uav.origin;
		wait .05;
	}
	
	if( IsDefined( newMissile ) )
		newMissile delete();
	playfx( getfx( "uav_explosion" ), old_org );
	level.uav thread play_sound_on_tag( "uav_explode" );
	level.uav_is_destroyed = true;
	level.player maps\_remotemissile::disable_uav( false, true );

	level notify( "uav_destroyed" );
	
	if( isdefined( level.uav ) )
		level.uav delete();
}

UAVRigAiming()
{
	if( !isalive( level.uav ) )
		return;
	if( isdefined( level.uav_is_destroyed ) )
		return;
	
	focus_points = getentarray( "uav_focus_point", "targetname" );
	village_focus_point = getent( "village_focus_point", "script_noteworthy" );
	
	
	level endon( "uav_destroyed" );
	level.uav endon ( "death" );
	for ( ;; )
	{
		//if ( IsDefined( level.uavTargetEnt ) )
		//{
		//	targetPos = level.uavTargetEnt.origin;
		//}
		//else 
		if( flag( "leaving_village" ) )
		{
			closest_focus = getclosest( level.player.origin, focus_points );
			targetPos = closest_focus.origin;
		}
		else
		{
			targetPos = village_focus_point.origin;
		}
		//else if ( IsDefined( level.uavTargetPos ) )
		//	targetPos = level.uavTargetPos;
		//else
		//	targetpos = ( -17052.6, -4000.98, 696.409 );
			

		angles = VectorToAngles( targetPos - level.uav.origin );

		level.uavRig MoveTo( level.uav.origin, 0.10, 0, 0 );
		level.uavRig RotateTo( ANGLES, 0.10, 0, 0 );
		wait 0.05;
	}
}


spawn_second_uav()
{
	level.uav_is_destroyed = undefined;
	level.player maps\_remotemissile::enable_uav( false, "remote_missile_detonator" );
		
	
	restart_rig = false;
	if( !isalive( level.uav ) )
	{
		restart_rig = true;
		level.uav = spawn_vehicle_from_targetname_and_drive( "second_uav" );
		level.uav playLoopSound( "uav_engine_loop" );
	}
	
	if( !isdefined( level.uavRig ) )
	{
		level.uavRig = spawn( "script_model", level.uav.origin );
		level.uavRig setmodel( "tag_origin" );
	}
	
	if( restart_rig )
		thread UAVRigAiming();
	
	weapList = level.player GetWeaponsListAll();
	has_remote = false;
	foreach( weap in weapList )
		if( weap == "remote_missile_detonator" )
			has_remote = true;
	
	if( !has_remote )
	{
		level.player giveWeapon( "remote_missile_detonator" );
		level.player SetActionSlot( 4, "weapon", "remote_missile_detonator" );
	}
}


dialog_russians_looking_for_you()
{
	dialog = [];
	dialog[dialog.size ] = "cont_ru0_woods";
	dialog[dialog.size ] = "cont_ru1_woods";
	dialog[dialog.size ] = "cont_ru2_woods";
	dialog[dialog.size ] = "cont_ru3_woods";
	dialog[dialog.size ] = "cont_ru4_woods";
	
	
	while( !flag( "approaching_ridge" ) )
	{	
		wait ( randomfloatrange( 2, 4 ) );
		
		guys = getentarray( "cqb_patrol", "script_noteworthy" );
		guys = array_randomize( guys );
		foreach( guy in guys )
		{
			if( isalive( guy ) )
			{
				selection = dialog[ randomint( dialog.size ) ];
				println( "guy.export " + guy.export + " sound " + selection );
				guy playsound( selection );
				break;
			}
		}
	}
}

dialog_approaching_ridge()
{	
	if( !stealth_is_everything_normal() )
		return;
	level endon( "someone_became_alert" );	
		
	//Soap, what's the status of our air support?
	level.price dialogue_queue( "cont_pri_airsupport" );
	//radio_dialogue( "cont_pri_airsupport" );
	wait 1;
	
	//The UAV is almost in position.	
	radio_dialogue( "cont_cmt_almostinpos" );
	
	//Roger that. 	
	level.price dialogue_queue( "cont_pri_rogerthat" );
	//radio_dialogue( "cont_pri_rogerthat" );
}


dialog_gauntlet_surprise_reaction()
{	
	// Diable the _remotemissile dialogue until this sequence is done
	level.uav_radio_disabled = true;

	wait 2;
	//Bollocks!	
	level.price dialogue_queue( "cont_pri_bollocks" );
	//radio_dialogue( "cont_pri_bollocks" );	
	
	//What just happened?	
	radio_dialogue( "cont_cmt_whathappened" );
	
	//There's a mobile SAM site in the village. It just took out our UAV.	
	level.price dialogue_queue( "cont_pri_mobilesaminvillage" );
	//radio_dialogue( "cont_pri_mobilesaminvillage" );
	
	//Soap, we need another UAV, sharpish!	
	level.price dialogue_queue( "cont_pri_uavsharpish" );
	//radio_dialogue( "cont_pri_uavsharpish" );

	// Re-enable the _remotemissile dialogue until this sequence is done	
	level.uav_radio_disabled = undefined;
}
	
//dialog_rasta_destroys_gauntlets()
//{
//	//Stand back!	
//	dialogue_queue( "cont_rst_standback" );
//	
//	//Get back!	
//	dialogue_queue( "cont_rst_getback" );
//}	

dialog_rasta_and_bricktop()
{	
	if( flag( "start_village_fight" ) )
		return;
	level endon( "start_village_fight" );
	
	while( !isalive( level.rasta ) )
		wait 1;
	
	level.price waittill_entity_in_range( level.rasta, 300 );
	level.price waittill_entity_in_range( level.player, 600 );

	//Nice work on that SAM site.	
	level.price dialogue_queue( "cont_pri_nicework" );
	
	//Thanks, but we better get moving - those explosions are gonna attract a lot of attention.	
	level.rasta dialogue_queue( "cont_rst_getmoving" );
	
	
	//wait 1;
	
}

village_truck_guys_setup()
{
	self endon( "death" );	
	self waittill( "jumpedout" );
	self.goalradius = 8000;
}

price_smart_path_following( first_node )
{
	self endon( "stop_smart_path_following" );
	self.smart_path_following_node = first_node;
	self setgoalnode( first_node );
	
	if( !isdefined( first_node.target ) )
		return;
	
	next_node = getnode( first_node.target, "targetname" );
	while( 1 )
	{
		trigger = undefined;
		volume = undefined;
				
		links = getentarray( next_node.script_linkto, "script_linkname" );
		//get the flag trigger linked to the next_node
		foreach( link in links )
		{
			if( link.classname == "trigger_multiple_flag_set" )
				trigger = link;
			if( link.classname == "info_volume" )
				volume = link;
		}
		
		assert( isdefined( trigger ) );
		assert( isdefined( trigger.script_flag ) );
		assert( isdefined( volume ) );
		
		// a flag trigger the player passes through
		flag_wait( trigger.script_flag );
		
		
		// the volume linked to the flag trigger
		volume waittill_volume_dead();
	
		level notify( next_node.targetname );//so we can react to price deciding to move

		if( flag( "_stealth_spotted" ) )
			flag_waitopen( "_stealth_spotted" );

		// volume is clear, trigger is hit, go to the node
		self setgoalnode( next_node );
		self.smart_path_following_node = next_node;
		
		if( !isdefined( next_node.target ) )
			break;
			
		//get the next node
		next_node = getnode( next_node.target, "targetname" );
		
	}
}

destroy_chain( start_ent )
{
	current_target = start_ent;
	while( 1 )
	{
		if( isdefined( current_target.script_linkTo ) )
		{
			tree = getent( current_target.script_linkTo, "script_linkname" );
			tree notify ( "explode" );
		}
				
		wait .2;
		
		if( isdefined( current_target.script_delay ) )
			wait current_target.script_delay;
		
		if( isdefined( current_target.target ) )
		{
			next_target = getstruct( current_target.target, "targetname" );
			assert( isdefined( next_target ) );
			current_target = next_target;
		}
		else
			break;
	}
}


setup_tree_destroyer()
{
	wait 3;
	level.btr_tree_destroyer = spawn_vehicle_from_targetname_and_drive( "btr_tree_destroyer" );
	level.btr_tree_destroyer vehicle_lights_on( "spotlight spotlight_turret" );
	level.btr_tree_destroyer thread monitor_distance_player_vs_price();
	
	level.btr_tree_destroyer  thread maps\_vehicle::damage_hints();
}


friendly_adjust_movement_speed()
{
	self notify( "stop_adjust_movement_speed" );
	self endon( "death" );
	self endon( "stop_adjust_movement_speed" );
	
	for(;;)
	{
		wait randomfloatrange( .5, 1.5 );
		
		while( friendly_should_speed_up() )
		{
			//iPrintLnBold( "friendlies speeding up" );
			self.moveplaybackrate = 2.5;
			wait 0.05;
		}
		
		self.moveplaybackrate = 1.0;
	}
}

friendly_should_speed_up()
{
	prof_begin( "friendly_movement_rate_math" );
	
	if ( distanceSquared( self.origin, self.goalpos ) <= level.goodFriendlyDistanceFromPlayerSquared )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	// check if AI is visible in player's FOV
	if ( within_fov( level.player.origin, level.player getPlayerAngles(), self.origin, level.cosine[ "70" ] ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	prof_end( "friendly_movement_rate_math" );
	
	return true;
}


monitor_player_returns_to_btrs()
{
	level endon( "player_slid_down" );
	flag_wait( "returning_to_btrs" );
	//level.player waittill_entity_in_range( level.btr_slider, 2200 );

	level.btr_tree_destroyer setturrettargetent( level.player );
	
	shots = randomintrange( 2, 5 );
	for ( i = 0; i < shots; i++ )
	{
		level.btr_tree_destroyer fireWeapon();
		wait( 0.35 );
	}
	level.btr_slider setturrettargetent( level.player );
	wait( randomfloatrange( .2, .5 ) );
	
	shots = randomintrange( 2, 4 );
	for ( i = 0; i < shots; i++ )
	{
		level.btr_slider fireWeapon();
		level.btr_tree_destroyer fireWeapon();
		wait( 0.35 );
	}
	level.player dodamage( ( level.player.health + 1000 ), level.btr_tree_destroyer.origin );
}

monitor_distance_player_vs_price()
{
	wait 10;
	
	
	level endon( "safe_from_btrs" );
	
	while( 1 )
	{
		level.player waittill_entity_out_of_range( level.price, 1000 );
		
		vec2 = VectorNormalize( ( level.player.origin - level.price.origin ) );
		
		//vec_goal = VectorNormalize( ( level.price.goalpos - level.price.origin ) );//angle of where I'm supposed to go
		//vecdot = vectordot( vec_goal, vec2 );//dot my my goal dir vs player position
		
		vec = anglestoforward( level.price.angles );
		vecdot = vectordot( vec, vec2 );//dot of my angle vs player position
		
		//vecdot > 0 means in 180 in front
		if( vecdot < 0 )// player is behind my goal dir
			break;
			
		wait .1;
	}
	
	level notify( "shoot_at_player" );//stops the scripted tree destruction
	
	
	self setturrettargetent( level.player );
	
	shots = randomintrange( 2, 5 );
	for ( i = 0; i < shots; i++ )
	{
		self fireWeapon();
		wait( 0.35 );
	}
	level.btr_slider setturrettargetent( level.player );
	wait( randomfloatrange( .2, .5 ) );
	
	shots = randomintrange( 2, 4 );
	for ( i = 0; i < shots; i++ )
	{
		level.btr_slider fireWeapon();
		self fireWeapon();
		wait( 0.35 );
	}
	level.player dodamage( ( level.player.health + 1000 ), self.origin );
}

end_of_tree_explosions()
{
	level endon( "shoot_at_player" );//stops the scripted tree destruction
	flag_wait( "end_of_tree_explosions" );	
	wait 2;
	
	destroyable_trees = getentarray( "trigger_tree_explosion", "targetname" );
	
	thread random_tree_impact_sounds( destroyable_trees );
	level.btr_tree_destroyer fireWeapon();
	wait .2;
	thread random_tree_impact_sounds( destroyable_trees );
	level.btr_tree_destroyer fireWeapon();
	wait .2;
	thread random_tree_impact_sounds( destroyable_trees );
	level.btr_tree_destroyer fireWeapon();
	
	
	wait 1;
	thread random_tree_impact_sounds( destroyable_trees );
	level.btr_tree_destroyer fireWeapon();
	wait .5;
	level.btr_tree_destroyer fireWeapon();
	
	wait 1;
	
	thread random_tree_impact_sounds( destroyable_trees );
	level.btr_tree_destroyer fireWeapon();
	wait .2;
	thread random_tree_impact_sounds( destroyable_trees );
	level.btr_tree_destroyer fireWeapon();
	wait .2;
	level.btr_tree_destroyer fireWeapon();
	
	
	wait .5;
	thread random_tree_impact_sounds( destroyable_trees );
	level.btr_tree_destroyer fireWeapon();
	wait .8;
	level.btr_tree_destroyer fireWeapon();
	
	wait 1;
	level.btr_tree_destroyer fireWeapon();
	
	wait 1;
	level.btr_tree_destroyer fireWeapon();
	
	wait 2;
	level.btr_tree_destroyer fireWeapon();
	
	flag_set( "done_with_exploding_trees" );
}

random_tree_impact_sounds( destroyable_trees )
{
	loc = destroyable_trees[ randomint( destroyable_trees.size ) ];
	loc playsound( "contingency_tree_impact" );
	loc playsound( "contingency_tree_fall" );
}

setup_destroyable_tree()
{
	//level._effect[ "tree_snow_dump_fast" ]		 = loadfx( "snow/tree_snow_dump_fast" );
	//level._effect[ "tree_snow_dump_fast_small" ]		 = loadfx( "snow/tree_snow_dump_fast_small" );
	//level._effect[ "tree_snow_fallen" ]		 = loadfx( "snow/tree_snow_fallen" );
	//level._effect[ "tree_snow_fallen_small" ]		 = loadfx( "snow/tree_snow_fallen_small" );
	
	level endon( "shoot_at_player" );
	
	small_tree = false;
	tree_base = getent( self.target, "targetname" );
	destroyed_top = undefined;
	clip_brush = undefined;
	if( tree_base.model == "foliage_tree_pine_snow_tall_b_broken_btm" )
	{
		small_tree = true;
		tree_base.endmodel = tree_base.model;
		tree_base setmodel( "foliage_tree_pine_snow_tall_b" );
	}
	else
	{
		tree_base.endmodel = tree_base.model;
		tree_base setmodel( "foliage_tree_pine_snow_tall_c" );
	}
	parts = getentarray( tree_base.target, "targetname" );
	foreach( part in parts )
	{
		if( part.classname == "script_model" )
			destroyed_top = part;
		if( part.classname == "script_brushmodel" )
			clip_brush = part;
	}
	assert( isdefined( destroyed_top ) );
	destroyed_top.goalangles = destroyed_top.angles;
	//destroyed_top.angles = (0, tree_base.angles[1], 0);
	destroyed_top.angles = tree_base.angles;
	destroyed_top hide();
	
	
	hits_ground = false;
	if( ( isdefined( destroyed_top.script_noteworthy ) ) && ( destroyed_top.script_noteworthy == "hits_the_ground" ) )
		hits_ground = true;
	if( hits_ground )
		assert( isdefined( clip_brush ) );
	if( isdefined( clip_brush ) )
	{
		assert( hits_ground );
		clip_brush notsolid();
	}
	
	
	self waittill( "trigger" );
	//while( !isdefined( level.price ) )
	//	wait 1;
		
	if( isalive( level.btr_slider ) )
	{
		level.btr_slider setturrettargetvec( destroyed_top.origin );
		level.btr_slider fireWeapon();
	}
	
	if( isalive( level.btr_tree_destroyer ) )
	{
		level.btr_tree_destroyer setturrettargetvec( destroyed_top.origin );
		level.btr_tree_destroyer fireWeapon();
	}
	
	destroyed_top playsound( "contingency_tree_impact" );
	tree_base playsound( "contingency_tree_fall" );
	
	tree_base setmodel( tree_base.endmodel );
	forward = AnglesToForward( destroyed_top.angles );
	up = AnglesToUp( destroyed_top.angles );
	if( small_tree )
	{
		playfx( getfx( "tree_snow_dump_fast_small" ), destroyed_top.origin, up , forward   );
	}
	else
	{
		playfx( getfx( "tree_snow_dump_fast" ), destroyed_top.origin, up , forward );
	}

	destroyed_top show();
	//drop_time = randomfloatrange( .6, 1.4 );
	
	//if( isdefined( destroyed_top.script_duration ) )
	//	drop_time = destroyed_top.script_duration;
	//else
	//{
	//	drop_time = 1;
	//}
		

	pre_hit_fx_time = .25;
	
	if( small_tree )
	{
		pre_hit_fx_time = pre_hit_fx_time - .25;
	}
	
	drop_time = 2;
	//drop_time = drop_time * 2;
	accel_time = drop_time;
	//destroyed_top rotatepitch( 90, drop_time, accel_time, 0);
	//destroyed_top thread maps\_debug::drawOrgForever();
	destroyed_top RotateTo( destroyed_top.goalangles, drop_time, accel_time, 0 );
	
	wait ( drop_time - pre_hit_fx_time );
	
	if( hits_ground )
	{
		forward = AnglesToForward( destroyed_top.angles );
		up = AnglesToUp( destroyed_top.angles );
    	
		if( small_tree )
		{
			//destroyed_top thread maps\_debug::drawOrgForever();
			playfx( getfx( "tree_snow_fallen_small" ), destroyed_top.origin , up , forward );
		}
		else
		{
			//destroyed_top thread maps\_debug::drawOrgForever();
			playfx( getfx( "tree_snow_fallen_heavy" ), destroyed_top.origin , up , forward );
		}
	}
	wait pre_hit_fx_time;
	
	//tree has stopped falling
	if( hits_ground )
	{
		if( level.player istouching( clip_brush ) )
			level.player kill();
		clip_brush solid();
	}
	
	if( ( hits_ground ) && ( !small_tree ) )
	{
		if( level.player point_in_fov( destroyed_top.origin ) )
			Earthquake( 0.3, .3, destroyed_top.origin, 2000 );
		destroyed_top playsound( "contingency_tree_ground" );
	}
	
	if( !hits_ground )
	{
		forward = AnglesToForward( destroyed_top.angles );
		up = AnglesToUp( destroyed_top.angles );
    	
		if( small_tree )
		{
			//destroyed_top thread maps\_debug::drawOrgForever();
			playfx( getfx( "tree_snow_fallen_small" ), destroyed_top.origin , up , forward );
		}
		else
		{
			//destroyed_top thread maps\_debug::drawOrgForever();
			playfx( getfx( "tree_snow_fallen" ), destroyed_top.origin , up , forward );
		}
	}
	
	//if( !isdefined( destroyed_top.script_duration ) )
	//{
		shake_time = .2;
		
		destroyed_top movez( 4, shake_time, 0, shake_time );
		wait shake_time;
		
		destroyed_top movez( -3, shake_time, 0, shake_time );
		wait shake_time;
		
		destroyed_top movez( 2, shake_time, 0, shake_time );
		wait shake_time;
		
		destroyed_top movez( -1, shake_time, 0, shake_time );
		wait shake_time;	
	//}
	
	/*
	shake_time = .2;
	destroyed_top rotatepitch( 3, shake_time, shake_time, 0);
	
	wait shake_time;
	
	destroyed_top rotatepitch( -2, shake_time, shake_time, 0);
	
	wait shake_time;
	
	destroyed_top rotatepitch( 1, shake_time, shake_time, 0);
	
	wait shake_time;
	*/
}


dialog_enemy_saw_corpse()
{
	first_line = true;
	
	while( 1 )
	{
		level waittill( "_stealth_saw_corpse" );
		
		wait 2;
		
		if(	flag( "_stealth_spotted" ) )
			continue;
	}
	
	if( first_line )
	{
		//Looks like they found a body.	
		radio_dialogue( "cont_pri_foundabody" );
		first_line = false;
	}
	else
	{
		//They found a body.	
		radio_dialogue( "cont_pri_foundabody2" );
		first_line = true;
	}

	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	wait 10;
	
	
	//kill at same time
	radio_dialogue( "cont_pri_sametime" );
	
/*
	wait 3;
	
	level.price.ignoreall = false;
	level.price.dontevershoot = undefined;
	level.price.baseaccuracy = 5000000;
	
	
	ai = GetAIspeciesArray( "axis", "all" );
	foreach ( actor in ai )
	{
		actor.no_price_kill_callout = true;
		actor.dontattackme = undefined;
		//level.price.favoriteenemy = actor;
	}
*/
}

dialog_player_kill()
{
	if( flag( "_stealth_spotted" ) )
		return;
	
	wait 3;
	
	if( !stealth_is_everything_normal() )
		return;
	if( !isdefined( level.good_kill_dialog_time ) )
	{
		level.good_kill_dialog_time = gettime();
	}
	else
	{
		if( gettime() < ( level.good_kill_dialog_time + ( 15 * 1000 ) ) )
			return;
	}
	level.good_kill_dialog_time = gettime();
	
	level notify( "player kill dialog" );
}


dialog_player_kill_master()
{	
	dialog = [];
	
	//Good.	
	dialog[ dialog.size ] = "cont_pri_good";
	//beautiful
	dialog[ dialog.size ] = "cont_pri_beautiful";
	//Not bad, but I've seen better.	
	//dialog[ dialog.size ] = "cont_pri_seenbetter";
	//Nicely done.	
	dialog[ dialog.size ] = "cont_pri_nicelydone";
	//Well done.	
	dialog[ dialog.size ] = "cont_pri_welldone";
	//Good work.	
	dialog[ dialog.size ] = "cont_pri_goodwork";
	//Impressive.	
	dialog[ dialog.size ] = "cont_pri_impressive";


	line = 0;
	
	while( 1 )
	{
		level waittill( "player kill dialog" );
		
		radio_dialogue( dialog[ line ] );
		line++;
		if( line >= dialog.size )
			line = 0;
	}
}

dialog_price_kill()
{
	current_line = 0;
	dialog = [];
	
	//Got one.	
	dialog[ dialog.size ] = "cont_pri_gotone";
	//He's down. 	
	dialog[ dialog.size ] = "cont_pri_hesdown2";
	//Tango down.	
	dialog[ dialog.size ] = "cont_pri_tangodown";
	//Good night.	
	dialog[ dialog.size ] = "cont_pri_goodnight";
	//Target eliminated.	
	dialog[ dialog.size ] = "cont_pri_targeteliminated";
	//Target down.	
	dialog[ dialog.size ] = "cont_pri_targetdown";
	

	while( 1 )
	{
		level waittill( "dialog_price_kill" );
		
		wait 1.5;
			
		if( isdefined( level.dont_brag_when_following_your_own_orders_time ) )
		{
			if( gettime() < ( level.dont_brag_when_following_your_own_orders_time + ( 15 * 1000 ) ) )
				continue;
		}
		
		if( !isdefined( level.good_kill_dialog_time ) )
		{
			level.good_kill_dialog_time = gettime();
		}
		else
		{
			if( gettime() < ( level.good_kill_dialog_time + ( 3 * 1000 ) ) )
				continue;
		}
		level.good_kill_dialog_time = gettime();
		
		
		dialog_line = dialog[ current_line ];
		radio_dialogue( dialog_line );//dont cut off the other line but clear the que
		current_line++;
		if( current_line >= dialog.size )
			current_line = 0;
		
	}
}


dialog_price_kill_dog()
{
	current_line = 0;
	
	dialog_dog = [];
	
	//Nap time.	
	dialog_dog[ dialog_dog.size ] = "cont_pri_naptime";
	//Down boy.	
	dialog_dog[ dialog_dog.size ] = "cont_pri_downboy";

	while( 1 )
	{
		level waittill( "dialog_price_kill_dog" );
		
		wait 1.5;
			
		if( isdefined( level.dont_brag_when_following_your_own_orders_time ) )
		{
			if( gettime() < ( level.dont_brag_when_following_your_own_orders_time + ( 15 * 1000 ) ) )
				continue;
		}
		
		if( !isdefined( level.good_kill_dialog_time ) )
		{
			level.good_kill_dialog_time = gettime();
		}
		else
		{
			if( gettime() < ( level.good_kill_dialog_time + ( 3 * 1000 ) ) )
				continue;
		}
		level.good_kill_dialog_time = gettime();
		
		dialog_line = dialog_dog[ current_line ];
		radio_dialogue( dialog_line );//dont cut off the other line but clear the que
		current_line++;
		if( current_line >= dialog_dog.size )
			current_line = 0;
		
	}
}

monitor_stealth_pain()
{
	self waittill( "damage", damage, attacker );
	
	if ( !isdefined( attacker ) )
		return;
	
	if ( ( isplayer( attacker ) ) && ( isdefined( self.script_deathflag ) ) )
	{
		if( self.script_deathflag != "blocking_stationary_dead" )
			thread price_helps_kill_group( self.script_deathflag );
	}
}


monitor_stealth_kills()
{
	self waittill( "death", killer );
	
	if ( !isdefined( killer ) )
		return;
		
	if ( isplayer( killer ) )
	{
		thread dialog_player_kill();
		return;
	}
		
	if( ( level.price == killer ) && ( !isdefined( self.no_price_kill_callout ) ) )
	{
		if( self.type == "dog" )
			level notify( "dialog_price_kill_dog" );
		else
			level notify( "dialog_price_kill" );
	}
}

dialog_stealth_recovery()
{	
	if( flag( "player_on_ridge" ) )
		return;
	level endon( "player_on_ridge" );
	failure = [];

	//Don't give away our position, Roach. This is only going to get harder.	
	failure[ failure.size ] = "cont_pri_giveawayposition";
	//Roach, we can't afford to keep giving away our position like that. Maintain a low profile!	
	failure[ failure.size ] = "cont_pri_lowprofile";
	//What the hell was that? You trying to get us killed?	
	failure[ failure.size ] = "cont_pri_getuskilled";
	//Does the word stealth mean anything to you?	
	failure[ failure.size ] = "cont_pri_thewordstealth";

	line = 0;
	
	while( 1 )
	{
		flag_wait( "_stealth_spotted" );
		wait 1;
		flag_waitopen( "_stealth_spotted" );
		wait 1;
		
		radio_dialogue( failure[ line ] );
		line++;
		if( line >= failure.size )
			line = 0;
	}
}


dialog_we_are_spotted()
{
	failure = [];
	
	//We're spotted! Go loud! Take them out! 	
	failure[ failure.size ] = "cont_pri_goloud";
	//They're on to us! Open fire!	
	failure[ failure.size ] = "cont_pri_ontous";
	//We're spotted! Take them out!	
	failure[ failure.size ] = "cont_pri_werespotted";
	
	failure = array_randomize( failure );
	line = 0;
	
	while( 1 )
	{
		flag_wait( "_stealth_spotted" );
		
		radio_dialogue_stop();//kills current line
		radio_dialogue(  failure[ line ] );
		line++;
		if( line >= failure.size )
			line = 0;
		
		wait 1;
		flag_waitopen( "_stealth_spotted" );
		wait 1;
		//dialog_check_path_clear();
	}
}



dialog_first_patrol_spotted()
{
	level.price thread disable_cqbwalk();
	level.price SetLookAtEntity();// clears it
	if( flag( "someone_became_alert" ) )
		return;
	level endon( "someone_became_alert" );
	if( flag( "saying_patience" ) )
		return;
	level endon( "saying_patience" );
	flag_set( "saying_contact" );
	//Contact.  Enemy patrol 30 meters to our front.	
	radio_dialogue( "cont_pri_30metersfront" );
	
	wait 2;
	
	//Five men, automatic rifles, frag grenades. One German Shepherd.	
	radio_dialogue( "cont_pri_fivemen" );
	
	wait .1;
	
	//Dogs... I hate dogs.		
	radio_dialogue( "cont_cmt_hatedogs" );
	
	wait .4;
	
	//These Russian dogs are like pussycats compared to the ones in Pripyat.	
	radio_dialogue( "cont_pri_russiandogs" );
	
	//wait .3;
	//Its good to have you back, old man.	
	radio_dialogue( "cont_cmt_haveyouback" );
	
	//wait .3;
	//Roger that. 	
	radio_dialogue( "cont_pri_rogerthat2" );
	flag_clear( "saying_contact" );
	
	//wait 3;
	
	level.price thread enable_cqbwalk();
}


dialog_russians_have_sams()
{	
	wait 6;
	
	if( flag( "_stealth_spotted" ) )
		return;
	if( flag( "someone_became_alert" ) )
		return;
	level endon( "someone_became_alert" );
	//Soap, our intel was off. The Russians have mobile SAMs.	
	level.price dialogue_queue( "cont_pri_intelwasoff" );
	
	//Roger that.	
	radio_dialogue( "cont_cmt_rogerthat" );
	
	//Have you found us some transport?	
	level.price dialogue_queue( "cont_pri_foundtransport" );
	//radio_dialogue( "cont_pri_foundtransport" );
	
	//I'm working on it. Out.	
	radio_dialogue( "cont_cmt_workingonit" );
}

dialog_lets_follow_quietly()
{
	level endon( "_stealth_spotted" );
	level endon( "someone_became_alert" );
	level waittill( "price_starts_following" );
	if( flag( "saying_contact" ) )
		flag_waitopen( "saying_contact" );
	
	if( flag( "said_convoy_coming" ) )
		return;
		
	//Let's follow them quietly, and pick off any stragglers.	
	radio_dialogue( "cont_pri_pickoffstragglers" );
}


flag_when_second_group_of_stragglers_are_dead()
{
	flag_wait( "cross_bridge_patrol_dead" );
	flag_wait( "rightside_patrol_dead" );
	flag_set( "second_group_of_stragglers_are_dead" );
}


hide_and_kill_everyone()
{
	if( flag( "second_group_of_stragglers_are_dead" ) )
		return;
	level endon( "second_group_of_stragglers_are_dead" );
	
	level endon( "_stealth_spotted" );
	flag_wait( "price_in_position_remaining_group" );
	//wait_till_every_thing_stealth_normal_for( 1 );
	thread price_is_ready_vs_everyone();
	//level endon( "someone_became_alert" );
	
	//I'm ready. Lets take them all out at once.	
	radio_dialogue( "cont_pri_imready" );

	if( flag( "cross_bridge_patrol_dead" ) || flag( "rightside_patrol_dead" ) )
		return;

	//You handle the two on the left.	
	radio_dialogue( "cont_pri_twoonleft" );
}

spawn_with_delays()
{
	if( isdefined( self.script_delay ) )
		wait self.script_delay;
		
	self spawn_ai();
}

hide_and_kill_first_stragglers()
{
	//level.price.dontevershoot = undefined;
	//thread price_takes_next_path_when_they_are_dead();
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	flag_wait( "patience" );
	
	flag_set( "saying_patience" );
	level notify( "saying_patience" );
	level.price thread enable_cqbwalk();
	//Patience�don't do anything stupid.	
	radio_dialogue( "cont_pri_patience" );
	wait .5;
	
	if( !flag( "start_truck_patrol" ) )
	{
		//We'll have to take 'em out at the same time.	
		radio_dialogue( "cont_pri_sametime" );
	}
	
	flag_wait( "price_in_position_first_group" );
	flag_wait( "first_stragglers_stopped" );
	flag_wait( "last_truck_left" );
	
	wait_till_every_thing_stealth_normal_for( 1 );
	
	autosave_by_name( "first_stragglers" );
	
	if( flag( "someone_became_alert" ) )
		return;
	level endon( "someone_became_alert" );
	
	if( flag( "first_stragglers_dead" ) )
		return;
	level endon( "first_stragglers_dead" );
	
	thread price_is_ready_vs_first_stragglers();
	
	wait 1;
	flag_wait( "they_have_split_up" );
	
	//Now's your chance. Take one of 'em out. 	
	//radio_dialogue( "cont_pri_yourchance" );
	//iprintlnbold( "Two of them have stopped for a smoke. Take one and I'll take out the other." );
	radio_dialogue( "cont_pri_forasmoke" );
}




price_is_ready_vs_everyone()
{	
	ai = GetAIspeciesArray( "axis", "all" );
	foreach ( actor in ai )
	{
		if( ( isdefined( actor.script_noteworthy ) ) && ( actor.script_noteworthy == "rightside_patrol" ) )
			actor.threatbias = 20000;
	}
	
	level.price.ignoreall = false;
	level.player waittill( "weapon_fired" );
	
	wait .2; //give enemy chance to die and price chance to pick other target
	
	level.price.dontevershoot = undefined;
	level.price.baseaccuracy = 5000000;
	
	//ai = getentarray( "first_stragglers", "script_noteworthy" );
	//foreach ( actor in ai )
	//{
	//	self.dontattackme = undefined;
	//	level.price.favoriteenemy = self;
	//	level.price.baseaccuracy = 5000000;
	//	self.health = 1;
	//}
	
	ai = GetAIspeciesArray( "axis", "all" );
	foreach ( actor in ai )
	{
		actor.no_price_kill_callout = true;
		actor.dontattackme = undefined;
		//level.price.favoriteenemy = actor;
		actor.health = 1;
	}
	
	flag_wait( "second_group_of_stragglers_are_dead" );
	
	bridge_reset_price_to_stealth();
}

price_is_ready_vs_first_stragglers()
{	
	level.price.ignoreall = false;
	level.player waittill( "weapon_fired" );
	
	wait .2; //give enemy chance to die and price chance to pick other target
	
	level.price.dontevershoot = undefined;
	level.price.baseaccuracy = 5000000;
	
	//ai = getentarray( "first_stragglers", "script_noteworthy" );
	//foreach ( actor in ai )
	//{
	//	self.dontattackme = undefined;
	//	level.price.favoriteenemy = self;
	//	level.price.baseaccuracy = 5000000;
	//	self.health = 1;
	//}
	
	ai = GetAIspeciesArray( "axis", "all" );
	foreach ( actor in ai )
	{
		if( ( isdefined( actor.script_noteworthy ) ) && ( actor.script_noteworthy == "first_stragglers" ) )
		{
			actor.no_price_kill_callout = true;
			actor.dontattackme = undefined;
			level.price.favoriteenemy = actor;
			actor.health = 1;
		}
	}
	flag_wait( "first_stragglers_dead" );
	
	bridge_reset_price_to_stealth();
}


bridge_reset_price_to_stealth()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level.price.dontevershoot = true;
	level.price.baseaccuracy = 1;
	level.price.ignoreall = true;
}


price_helps_kill_group( script_deathflag )
{
	level endon( "_stealth_spotted" );
	level.price.maxsightdistsqrd = 8000*8000;
	wait .2;
	
	level.price.dontevershoot = undefined;
	level.price.baseaccuracy = 5000000;
	
	//ai = getentarray( "first_stragglers", "script_noteworthy" );
	//foreach ( actor in ai )
	//{
	//	self.dontattackme = undefined;
	//	level.price.favoriteenemy = self;
	//	level.price.baseaccuracy = 5000000;
	//	self.health = 1;
	//}
	
	ai = GetAIspeciesArray( "axis", "all" );
	while( !flag( script_deathflag ) )
	{
		foreach ( actor in ai )
		{
			if( !isalive( actor ) )
				continue;
			if( ( isdefined( actor.script_deathflag ) ) && ( actor.script_deathflag == script_deathflag ) )
			{
				//actor.no_price_kill_callout = true;
				actor.dontattackme = undefined;
				actor.threatbias = 5000;
				if( !isalive( level.price.enemy ) )
					level.price.favoriteenemy = actor;
				actor.health = 1;
			}
		}
		wait .1;
	}
	//foreach ( actor in ai )
	//{
	//	if( ( isdefined( actor.script_deathflag ) ) && ( actor.script_deathflag == script_deathflag ) )
	//	{
	//		actor.no_price_kill_callout = true;
	//		actor.dontattackme = undefined;
	//		level.price.favoriteenemy = actor;
	//		actor.health = 1;
	//	}
	//}
	//flag_wait( script_deathflag );
	
	woods_reset_price_to_stealth();
}

woods_reset_price_to_stealth()
{
	if( flag( "player_on_ridge" ) )
		return;
	if( flag( "_stealth_spotted" ) )
		return;
	level.price.dontevershoot = true;
	level.price.baseaccuracy = 1;
	level.price.maxsightdistsqrd = level.price_maxsightdistsqrd_woods;
}

//price_takes_next_path_when_they_are_dead()
//{
//	flag_wait( "first_stragglers_dead" );
//	
//	//clean up
//	if( !flag( "_stealth_spotted" ) )
//	{
//		level.price.dontevershoot = true;
//		ai = GetAIspeciesArray( "axis", "all" );
//		foreach ( actor in ai )
//			self.ignoreme = false;
//	}
//	level.price.baseaccuracy = 1;
//	
//	if( flag( "price_is_hiding" ) )
//		return;
//		
//	price_path_side_of_road = getent( "price_path_side_of_road", "targetname" );
//	level.price thread follow_path( price_path_side_of_road );
//}




hide_from_bridge_convoy()
{
	//if( flag( "price_is_hiding" ) )
	//	return;
	
	
	thread price_takes_next_path_if_stealth_is_broken();
	//flag_set( "price_is_hiding" );
	//level.price notify( "stop_going_to_node" );
	//level.price disable_dynamic_run_speed();
	//level.price disable_stealth_smart_stance();
	
	//level.price notify( "stop_dynamic_run_speed" );
	
	//level.price notify( "stop_going_to_node" );//end follow_path
	
	//level.price  enable_ai_color();
	//level.price  set_force_color( "y" );
	
	//price_hides_from_convoy = getnode( "price_hides_from_convoy", "targetname" );
	//level.price setgoalnode( price_hides_from_convoy );
	
	level.price.ignoreall = true;
	
	level endon( "_stealth_spotted" );
	
	flag_wait_or_timeout( "last_jeep_arrived", 20 );
	
	wait 4;

	wait_till_every_thing_stealth_normal_for( 1 );
	
	//Looks like they saw your parachute. 	
	radio_dialogue( "cont_pri_yourparachute" );
	
	//hide_from_right_side_of_bridge_patrol();
		
	//hide_from_cross_bridge_patrol();
	
	flag_set( "convoy_hide_section_complete" );
	autosave_stealth();
	
	thread dialog_lets_keep_moving();
	
	level.price.ignoreall = false;
	level.price thread enable_cqbwalk();
	price_goes_halfway_across_bridge = getnode( "price_goes_halfway_across_bridge", "targetname" );
	level.price thread price_smart_path_following( price_goes_halfway_across_bridge );
	
	
	
	//level.price thread price_move_speed_think();
	//level.price enable_stealth_smart_stance();
	//level.price enable_dynamic_run_speed();
	
	//path_start_cross_bridge = getent( "path_start_cross_bridge", "targetname" );
	//level.price thread follow_path( path_start_cross_bridge );
	//level.price.ignoreall = false;
}




dialog_lets_keep_moving()
{
	//level endon( "someone_became_alert" );
	//level waittill( "price_goes_halfway_across_bridge" );
	
	//Let's keep moving. 	
	thread radio_dialogue( "cont_pri_keepmoving" );
}

price_takes_next_path_if_stealth_is_broken()
{
	level endon( "convoy_hide_section_complete" );
	flag_wait( "_stealth_spotted" );
	wait 1;
	flag_waitopen( "_stealth_spotted" );
	wait 2;
	
	//Let's keep moving. 	
	//thread radio_dialogue( "cont_pri_keepmoving" );
	
	
	//level.price thread price_move_speed_think();
	//level.price enable_stealth_smart_stance();
	//level.price enable_dynamic_run_speed();
	
	level.price thread enable_cqbwalk();
	price_goes_halfway_across_bridge = getnode( "price_goes_halfway_across_bridge", "targetname" );
	level.price thread price_smart_path_following( price_goes_halfway_across_bridge );
	
	
	//path_start_cross_bridge = getent( "path_start_cross_bridge", "targetname" );
	//level.price thread follow_path( path_start_cross_bridge );
	//level.price.ignoreall = false;
}

dialog_wait_for_me_to_get_into_position()
{
	//Wait for me to get into position.	
	radio_dialogue( "cont_pri_waitposition" );
}

//hide_from_right_side_of_bridge_patrol()
//{
//	if( flag( "rightside_patrol_dead" ) )
//		return;   //skips the autosave
//	wait_till_every_thing_stealth_normal_for( 2 );
//	
//	//iprintlnbold( "Take out the two in the woods on the otherside of the bridge" );
//	if( !flag( "rightside_patrol_dead" ) )
//		radio_dialogue( "cont_pri_twoinwoods" );
//	
//	flag_wait( "rightside_patrol_dead" );
//	
//	autosave_stealth();
//}
//
//hide_from_cross_bridge_patrol()
//{
//	if( flag( "cross_bridge_patrol_dead" ) )
//		return;   //skips the autosave
//	wait 2;
//	wait_till_every_thing_stealth_normal_for( 2 );
//	
//	if( !flag( "cross_bridge_patrol_dead" ) )
//	{
//		ai = GetAIspeciesArray( "axis", "all" );
//		foreach ( actor in ai )
//		{
//			if( ( isdefined( actor.script_noteworthy ) ) && ( actor.script_noteworthy == "cross_bridge_patrol" ) )
//				actor SetThreatBiasGroup( "bridge_guys" );
//		}
//		SetThreatBiasAgainstAll( "bridge_guys", 2000 );
//		
//		price_targets_bridge_patrol = getnode( "price_targets_bridge_patrol", "targetname" );
//		level.price setgoalnode( price_targets_bridge_patrol );
//		
//		thread dialog_wait_for_me_to_get_into_position();
//		//level.price.ignoreall = false;
//		
//		//thread price_ignores_truck_guys_momentarily();
//		
//		flag_wait( "price_in_position_vs_bridge" );
//		
//		thread price_is_ready_vs_bridge_patrol();
//		
//		wait 2;
//		
//		//iprintlnbold( "I'm ready. Lets take them all out at once." );
//		radio_dialogue( "cont_pri_imready" );
//	}
//	
//	flag_wait( "cross_bridge_patrol_dead" );
//	
//	autosave_stealth();
//}

//price_ignores_truck_guys_momentarily()
//{
//	//Make first group ignored by second group
//	SetIgnoreMeGroup( "truck_guys", "price" );
//	level.price.ignoreall = false;
//		
//	flag_wait_either( "cross_bridge_patrol_dead", "_stealth_spotted" );
//	
//	//SetThreatBias( "truck_guys", "price", 0 );
//	SetThreatBias( "price", "truck_guys", 0 );
//}


price_is_ready_vs_bridge_patrol()
{	
	level.player waittill( "weapon_fired" );
	
	wait .2; //give enemy chance to die and price chance to pick other target
	
	level.price.dontevershoot = undefined;
	level.price.baseaccuracy = 5000000;
	level.price.ignoreall = false;
	
	//ai = getentarray( "first_stragglers", "script_noteworthy" );
	//foreach ( actor in ai )
	//{
	//	self.dontattackme = undefined;
	//	level.price.favoriteenemy = self;
	//	level.price.baseaccuracy = 5000000;
	//	self.health = 1;
	//}
	
	ai = GetAIspeciesArray( "axis", "all" );
	foreach ( actor in ai )
	{
		if( ( isdefined( actor.script_noteworthy ) ) && ( actor.script_noteworthy == "cross_bridge_patrol" ) )
		{
			actor.no_price_kill_callout = true;
			actor.dontattackme = undefined;
			level.price.favoriteenemy = actor;
			actor.health = 1;
		}
	}	
}

dialog_woods_first_patrol()
{
	level.player endon( "weapon_fired" );
	flag_wait( "dialog_woods_first_patrol" );
	
	//wait 6;
	
	if( flag( "someone_became_alert" ) )
		return;
		
	//iprintlnbold( "let them pass" );
	//Let them pass.	
	level.price radio_dialogue( "cont_pri_letpass" );
}

dialog_woods_first_dog_patrol()
{
	flag_wait( "dialog_woods_first_dog_patrol" );
	
	if( flag( "someone_became_alert" ) )
		return;
		
	autosave_stealth();
	//Dog patrol.	
	level.price radio_dialogue( "cont_pri_dogpatrol" );
}

	
dialog_woods_first_stationary()
{
	flag_wait( "dialog_woods_first_stationary" );
	
	if( flag( "someone_became_alert" ) )
		return;
		
	if( flag( "first_stationary_dead" ) )
		return;
		
	autosave_stealth();
	level endon( "someone_became_alert" );
	//Three man patrol dead ahead.	
	level.price radio_dialogue( "cont_pri_3manpatrol" );
	
	weap = level.player getcurrentweapon();
	if( ( weap != level.starting_sidearm ) && ( weap != level.starting_rifle ) )
	{
		//Firing an unsuppressed weapon is going to alert a lot of enemies, Roach.	
		level.price radio_dialogue( "cont_pri_alertenemies" );
	}
	
	//Take them out or leave them be. It's your call.	
	level.price radio_dialogue( "cont_pri_yourcall" );
	
	level.dont_brag_when_following_your_own_orders_time = gettime();
}


price_is_ready_vs_blocking_stationary()
{	
	ai = GetAIspeciesArray( "axis", "all" );
	foreach ( actor in ai )
	{
		if( !isdefined( actor.script_noteworthy ) )
			continue;
		if( actor.script_noteworthy == "blocking_group_left_two" )
			actor.threatbias = 20000;
	}
	
	
	level.player waittill( "weapon_fired" );
	level.price.maxsightdistsqrd = 8000*8000;
	
	wait .2; //give enemy chance to die and price chance to pick other target
	
	level.price.dontevershoot = undefined;
	level.price.baseaccuracy = 5000000;
	
	//ai = getentarray( "first_stragglers", "script_noteworthy" );
	//foreach ( actor in ai )
	//{
	//	self.dontattackme = undefined;
	//	level.price.favoriteenemy = self;
	//	level.price.baseaccuracy = 5000000;
	//	self.health = 1;
	//}
	
	
	
	ai = GetAIspeciesArray( "axis", "all" );
	while( !flag( "blocking_stationary_dead" ) )
	{
		foreach ( actor in ai )
		{
			if( !isalive( actor ) )
				continue;
			if( !isdefined( actor.script_noteworthy ) )
				continue;
			if( actor.script_noteworthy == "blocking_group_left_two" )
			{
				if( !isalive( level.price.enemy ) )
					level.price.favoriteenemy = actor;
				//actor.no_price_kill_callout = true;
				actor.dontattackme = undefined;
				//level.price.favoriteenemy = actor;
				actor.health = 1;
			}
		}
		
		foreach ( actor in ai )
		{
			if( !isalive( actor ) )
				continue;
			if( !isdefined( actor.script_noteworthy ) )
				continue;
			if( actor.script_noteworthy == "two_on_right" )
			{
				//actor.no_price_kill_callout = true;
				actor.dontattackme = undefined;
				//level.price.favoriteenemy = actor;
				actor.health = 1;
			}
		}
		wait .1;
	}
	woods_reset_price_to_stealth();
	
	//ai = GetAIspeciesArray( "axis", "all" );
	//foreach ( actor in ai )
	//{
	//	if( isdefined( actor.script_noteworthy ) )
	//	{
	//		if( ( actor.script_noteworthy == "two_on_right" ) || ( actor.script_noteworthy == "blocking_group_right_two" ) )
	//		{
	//			if( actor.script_noteworthy == "two_on_right" )
	//				actor.threatbias = 2000;
	//			actor.no_price_kill_callout = true;
	//			actor.dontattackme = undefined;
	//			//level.price.favoriteenemy = actor;
	//			actor.health = 1;
	//		}
	//	}
	//}
}


dialog_woods_blocking_stationary()
{
	flag_wait( "dialog_woods_blocking_stationary" );
	
	if( flag( "someone_became_alert" ) )
		return;
		
	if( flag( "blocking_stationary_dead" ) )
		return;
		
	autosave_stealth();
	level endon( "someone_became_alert" );
	
	thread price_is_ready_vs_blocking_stationary();
	
	//Large patrol at 12 o'clock.	
	level.price radio_dialogue( "cont_pri_largepatrol12" );
	
	//We can't slip by them. Get ready to take them out quickly.	
	level.price radio_dialogue( "cont_pri_cantslipby" );
	
	level.price radio_dialogue( "cont_pri_twoonright" );

	//level.price thread add_dialogue_line( "Price", "Take the two on the right." );
	//iprintlnbold( "You handle the two on the left" );
	//level.price radio_dialogue( "cont_pri_twoonleft" );
	
	level.dont_brag_when_following_your_own_orders_time = gettime();
	
	//two_on_right
}

dialog_woods_second_dog_patrol()
{
	flag_wait( "dialog_woods_second_dog_patrol" );
	
	if( flag( "someone_became_alert" ) )
		return;
		
	autosave_stealth();
	
	end_patrol = getentarray( "end_patrol", "targetname" );
	foreach( guy in end_patrol )
	{
		if( isalive( guy ) )
			guy.threatbias = 10000;
	}
	//We got another dog patrol.
	level.price radio_dialogue( "cont_pri_anotherdogpatrol" );
	
	//iprintlnbold( "Take them out or try to slip past. Your call." );
	level.price radio_dialogue( "cont_pri_slippast" );
	
}


dialog_convoy_coming()
{
	level endon( "_stealth_spotted" );
	level endon( "someone_became_alert" );
	
	flag_set( "said_convoy_coming" );
	level notify( "said_convoy_coming" );
	//Convoy coming, get out of sight.	
	//level.price dialogue_queue( "cont_pri_convoycoming" );
	level.price radio_dialogue( "cont_pri_convoycoming" );
	
	//wait 13;
	
	wait 2;
	
	//Let them pass.	
	//level.price dialogue_queue( "cont_pri_letthempass" );
	level.price radio_dialogue( "cont_pri_letthempass" );
}



dialog_theyre_looking_for_you()
{
	current_line = 0;
	dialog = [];
	
	//Quick! Hide in the woods! You alerted one of them!	
	dialog[ dialog.size ] = "cont_pri_hideinwoods";
	//Get into the woods! Hide!	
	dialog[ dialog.size ] = "cont_pri_getintowoods";
	//They're alerted! Hide in the woods! Move!	
	dialog[ dialog.size ] = "cont_pri_theyrealerted";

	while( 1 )
	{
		level waittill( "dialog_someone_is_alert" );
		
		dialog_line = dialog[ current_line ];
		radio_dialogue_clear_stack();
		radio_dialogue( dialog_line );//dont cut off the other line but clear the que
		if( current_line >= dialog.size )
			current_line = 0;
		
	}
}


monitor_price_hides_on_alerts()
{
	while( 1 )
	{
		flag_wait( "someone_became_alert" );
		if( !flag( "price_is_hiding" ) )
		{
			level.price.fixednode = true;
			level.price enable_ai_color();
			level.price set_force_color( "y" );
			
			flag_set( "price_is_hiding" );
		}
		flag_waitopen( "someone_became_alert" );
	}
}

monitor_someone_became_alert()
{
	self endon( "death" );
	
	self ent_flag_waitopen( "_stealth_normal" );
	
	self.ignoreme = false;
	
	if( flag( "someone_became_alert" ) )
		return;
	
	flag_set( "someone_became_alert" );
	thread monitor_waittill_stealth_normal();
	
	wait 1;//gives player a chance to kill the guy before warning dialog
	
	if( flag( "_stealth_spotted" ) )
		return;
	
	level notify( "dialog_someone_is_alert" );
}

monitor_waittill_stealth_normal()
{
	wait_till_every_thing_stealth_normal_for( 3 );
	
	flag_clear( "someone_became_alert" );
}


wait_till_every_thing_stealth_normal_for( time )
{
	while( 1 )
	{
		if( stealth_is_everything_normal() )
		{
			wait time;	
			if( stealth_is_everything_normal() )
				return;
		}
		wait 1;
	}
}



dialog_into_the_woods()
{
	//FOLLOW ME!	
	level.price dialogue_queue( "cont_pri_followme" );
	//level.price radio_dialogue( "cont_pri_followme" );
	
	wait 2;
	
	//INTO THE WOODS! LETS GO! LETS GO!	
	level.price dialogue_queue( "cont_pri_intothewoods" );
	//level.price radio_dialogue( "cont_pri_intothewoods" );
}

dialog_sub_spotted()
{
	level endon( "base_alerted" );
	flag_wait( "said_second_uav_in_position" );
	wait 1;
	
	flag_wait( "obj_base_entrance" );
	//There's the submarine! Right below that crane!	
	level.price dialogue_queue( "cont_pri_belowcrane" );
	
	//Roach, soften up their defenses with the Hellfires!	
	level.price dialogue_queue( "cont_pri_softendefenses" );
	
	autosave_by_name( "base" );
	
	wait 1;
	
	level.player thread display_hint_timeout( "hint_predator_drone", 6 );	
	
	//Watch for the blinking strobes. That�s us.	
	level.price dialogue_queue( "cont_pri_strobes" );
}

dialog_base_on_alert()
{
	flag_set( "saying_base_on_alert" );
	
	//That got their attention!	
	radio_dialogue( "cont_cmt_gotattention" );
	
	//The whole base has gone on alert!	
	radio_dialogue( "cont_cmt_baseonalert" );
	
	//You'd better hurry. You've only got a couple of minutes before that submarine dives.	
	radio_dialogue( "cont_cmt_betterhurry" );

	// MikeD: Restore uav radio in _remotemissile, and let the player know if the the uav is 'reloading'
	level.uav_radio_disabled = undefined;
	
	//We're moving!	
	level.price dialogue_queue( "cont_pri_weremoving" );
	
	flag_clear( "saying_base_on_alert" );
}



dialog_progress_through_base()
{
	flag_wait( "player_is_halfway_to_sub" );
	//You're halfway there!	
	radio_dialogue( "cont_cmt_halwaythere" );
	
	
	if( isalive( level.base_heli ) )
	{
		//Take out that helicopter!	
		level.price dialogue_queue( "cont_pri_takeoutheli" );
		level.base_heli MakeEntitySentient( "axis" );
	}
	
	flag_wait( "base_troop_transport2_spawned" );
	
	wait 2;
	
	//Use a Hellfire on that truck!	
	level.price dialogue_queue( "cont_pri_usehellfire" );
}

dialog_time_nags( total_time )
{
	time_past = 0;
	
	dialog = [];
	//We've got to hurry! That sub isn't going to wait for us!	
	dialog[ dialog.size ] = "cont_pri_subwontwait";
	//Go go go! 	
	dialog[ dialog.size ] = "cont_pri_gogogo";
	//Get to the sub! Hurry!	
	dialog[ dialog.size ] = "cont_pri_gettosub";
	dialog = array_randomize( dialog );
	current = 0;
	
	while( 1 )
	{
		wait 30;
		time_past = time_past + 30;
		time_remaining = total_time - time_past;
		
		if( time_remaining == 90 )
		{
			//90 seconds!	
			radio_dialogue( "cont_cmt_90secs" );
			continue;
		}
		
		if( time_remaining == 60 )
		{
			//60 seconds!	
			radio_dialogue( "cont_cmt_60secs" );
			continue;
		}
				
		if( time_remaining == 30 )
		{
			//30 seconds! Move!	
			radio_dialogue( "cont_cmt_30secs" );
			continue;
		}
		if( time_remaining == 0 )
		{
			break;
		}
		if( cointoss() )
		{
			level.price dialogue_queue( dialog[current] );
			current++;
			if( current >= dialog.size )
				current = 0;
		}
	}
}

dialog_at_sub()
{
	//Soap, we've reached the sub!	
	level.price dialogue_queue( "cont_pri_reachedsub" );
	
	//Roger that!	
	radio_dialogue( "cont_cmt_rogerthat2" );
}

kill_btr_slider( newMissile )
{
	fire_time = gettime();
	newMissile waittill( "death" );
	if( gettime() > fire_time + 2000 )
		return;//we missed
	
	self setmodel( "vehicle_btr80_snow_d" );
	playfx( getfx( "btr_explosion" ), self.origin );
	StopFXOnTag( getfx( "btr_spotlight" ), self, "TAG_FRONT_LIGHT_RIGHT" );
	StopFXOnTag( getfx( "btr_spotlight" ), self, "TAG_TURRET_LIGHT" );
}


dialog_intro()
{
	level endon( "saying_contact" );
	
	level.price SetLookAtEntity( level.player );
	
	//wait 5;
	

	//Price, I can barely see Roach's chute on my satellite feed.  Too much interference. Do you see him, over?
	radio_dialogue( "cont_cmt_barelysee" );

	level.price SetLookAtEntity();// clears it
	
	//Soap, I found Roach. He appears to be intact.	
	//level.price dialogue_queue( "cont_pri_foundroach" );
	level.price radio_dialogue( "cont_pri_foundroach" );
	
	//We're going to head northwest to the sub base, over.	
	//level.price dialogue_queue( "cont_pri_headnw" );
	level.price radio_dialogue( "cont_pri_headnw" );
	
	wait 1;
	
	//Copy that. I've located Rasta and Alpha, they landed pretty far to the east, over.	
	radio_dialogue( "cont_cmt_fareast" );
	
	//Tell them to proceed with the mission, we'll regroup if possible. 	
	//level.price dialogue_queue( "cont_pri_proceed" );
	level.price radio_dialogue( "cont_pri_proceed" );
	
	//wait 1;
	//
	////Have you found us some transport, over?	
	//level.price radio_dialogue( "cont_pri_foundtransport" );
	//
	////I'm working on it. Out.	
	//radio_dialogue( "cont_cmt_workingonit" );
	
	//level.price SetLookAtEntity( level.player );
	
	wait 1;
	
	flag_set( "said_follow_me" );
	
	//Roach, follow me and stay out of sight.	
	radio_dialogue( "cont_pri_outofsight" );
	
	//level.price SetLookAtEntity();// clears it
}


stealth_music_control()
{
	//DEFINE_BASE_MUSIC_TIME 		 = 143.5;
	//DEFINE_ESCAPE_MUSIC_TIME 	 = 136;
	//DEFINE_SPOTTED_MUSIC_TIME 	 = 117;
	
	if( flag( "stop_stealth_music" ) )
		return;
	level endon ( "stop_stealth_music" );
	
	//flag_wait( "first_two_guys_in_sight" );
	
	while( 1 )
	{
		thread stealth_music_hidden_loop();
	
		flag_wait( "_stealth_spotted" );
	
		music_stop( .2 );
		wait .5;
		thread stealth_music_busted_loop();
	
		flag_waitopen( "_stealth_spotted" );
	
		music_stop( 3 );
		wait 3.25;
	}
}


stealth_music_hidden_loop()
{
	music_TIME = musicLength( "contingency_stealth" );
	//music_TIME 		 		 = 528;
	//level endon( "player_in_hanger" );
	level endon( "_stealth_spotted" );
	
	if( flag( "stop_stealth_music" ) )
		return;
	level endon ( "stop_stealth_music" );
	
	while( 1 )
	{
		MusicPlayWrapper( "contingency_stealth" );
		
		wait music_TIME;
		
		wait 10;
	}
}

stealth_music_busted_loop()
{
	music_TIME = musicLength( "contingency_stealth_busted" );
	//music_TIME 		 = 154;
	//level endon( "player_in_hanger" );
	level endon( "_stealth_spotted" );
	if( flag( "stop_stealth_music" ) )
		return;
	level endon ( "stop_stealth_music" );
	while( 1 )
	{
		MusicPlayWrapper( "contingency_stealth_busted" );
		
		wait music_TIME;
		
		wait 3;
	}
}


cargo_choppers2()
{
	cargo_heli_spawners = getentarray( "cargo_heli_group2", "targetname" );
	foreach ( spawner in cargo_heli_spawners )
	{
		Cargo_item_spawners = getentarray( spawner.script_noteworthy, "targetname" );
		foreach ( ent in cargo_item_spawners )
			ent Hide();
		spawner.cargo_item_spawners = cargo_item_spawners;
	}
	
	flag_wait( "cargo_choppers_2" );
	
	thread dialog_russians_have_sams();
	
	current_spawner = 0;
	num_of_groups = 1;
	while( num_of_groups > 0 )
	{
		//group = randomintrange( 2, 4 );
		group = cargo_heli_spawners.size;
		
		while( group > 0 )
		{
			if( current_spawner >= cargo_heli_spawners.size )
				current_spawner = 0;
			thread spawn_cargo_chopper( cargo_heli_spawners[current_spawner] );
			current_spawner++;
			wait ( randomfloatrange(1.3, 1.8 ) );
			group--;
		}
		num_of_groups--;
		//flag_wait( "second_heli_group" );
		//wait( randomintrange( 15, 24 ) );
	}
}

cargo_choppers()
{
	cargo_heli_spawners = getentarray( "cargo_heli", "targetname" );
	foreach ( spawner in cargo_heli_spawners )
	{
		Cargo_item_spawners = getentarray( spawner.script_noteworthy, "targetname" );
		foreach ( ent in cargo_item_spawners )
			ent Hide();
		spawner.cargo_item_spawners = cargo_item_spawners;
	}
	
	current_spawner = 0;
	num_of_groups = 1;
	while( num_of_groups > 0 )
	{
		//group = randomintrange( 2, 4 );
		group = cargo_heli_spawners.size;
		
		while( group > 0 )
		{
			if( current_spawner >= cargo_heli_spawners.size )
				current_spawner = 0;
			thread spawn_cargo_chopper( cargo_heli_spawners[current_spawner] );
			current_spawner++;
			wait ( randomfloatrange(1.3, 1.8 ) );
			group--;
		}
		num_of_groups--;
		//flag_wait( "second_heli_group" );
		//wait( randomintrange( 15, 24 ) );
	}
}

spawn_cargo_chopper( cargo_heli_spawner )
{
	cargo_heli =  vehicle_spawn( cargo_heli_spawner );
	//cargo_heli = spawn_vehicle_from_targetname( "cargo_heli" );
	wait .1;//vehicle spawns in one place and then moves on the first frame
	cargo_item_spawners = cargo_heli_spawner.cargo_item_spawners;
	new_cargo = [];
	for( i = 0 ; i < cargo_item_spawners.size ; i++ )
	{
		new_cargo[i] = spawn( cargo_item_spawners[i].classname, cargo_item_spawners[i].origin );
		new_cargo[i].angles = cargo_item_spawners[i].angles;
		if( new_cargo[i].classname == "script_model" )
			new_cargo[i] setmodel( cargo_item_spawners[i].model );
		new_cargo[i] linkto( cargo_heli );
	}
	
	wait .1;
	
	thread gopath( cargo_heli );
	
	cargo_heli waittill( "death" );

	foreach ( ent in new_cargo )
		ent Delete();
}


destroy_thing_with_at4( fire_pos_ent, thing, thing_offset, missile_func )
{
	tag = "TAG_WEAPON_CHEST";
	guys = [];
	guys[ guys.size ] = self;
	
	fire_pos_ent anim_reach_and_plant( guys, "at4_fire" );
	self.allowPain = false;
	self notify( "finished_anim_reach" );

	fire_pos_ent thread anim_custom_animmode( guys, "gravity", "at4_fire" );
	
	//price_fire_loc anim_reach_solo( level.price, "at4_fire" );
	//price_fire_loc thread anim_single_solo( level.price, "at4_fire" );
	
	self waittill( "attach rocket" );//notetrack
	
	self place_weapon_on( "at4", "chest" );
	//self detach( "weapon_AT4", "TAG_STOWED_BACK" );
	//self attach( "weapon_AT4", tag );
	
	self waittill( "fire rocket" );//notetrack
	
	gun = self gettagorigin( tag );
	newMissile = MagicBullet( "at4_straight", gun, ( thing.origin + thing_offset ) );
	//if( isdefined( missile_func ) )
	//	level.btr_slider thread kill_btr_slider( newMissile );
	
	self waittill( "drop rocket" );//notetrack
	
	org_hand = self gettagorigin( tag );
	angles_hand = self gettagangles( tag );

	self place_weapon_on( "at4", "none" );
	
	model_at4 = spawn( "script_model", org_hand );
	model_at4 setmodel( "weapon_at4" );
	model_at4.angles = angles_hand;
	
	fire_pos_ent waittill( "at4_fire" );
	self.allowPain = true;
}

setup_village_defenders()
{
	self waittill( "death" );
	level.village_defenders_dead++;
}

setup_bricktop()
{
	level.bricktop = self;
	self.animname = "bricktop";
	//self thread magic_bullet_shield();
	
	//flag_wait( "base_alerted" );
	
	//self thread stop_magic_bullet_shield();
	//self thread replace_on_death();
}

setup_base_redshirt()
{
	self thread replace_on_death();
}

setup_village_redshirt()
{
	//self thread magic_bullet_shield();
	
	//flag_wait( "base_alerted" );
	
	//self thread stop_magic_bullet_shield();
	//self thread replace_on_death();
}
	
setup_bricktop_village()
{	
	self thread magic_bullet_shield();
	
	if( isalive( level.gauntlet_east ) )
	{
		self place_weapon_on( "at4", "back" );
		
		
		fire_pos_ent = getent( self.target, "targetname" );
		thing = level.gauntlet_east;
		thing_offset = (0,0,64);
		self thread destroy_thing_with_at4( fire_pos_ent, thing, thing_offset );
		
		self waittill( "finished_anim_reach" );
		
		//Stand back!	
		level.rasta dialogue_queue( "cont_rst_standback" );
		
		
		fire_pos_ent waittill( "at4_fire" );
	}
	self thread stop_magic_bullet_shield();

	self set_force_color( "g" );
	self enable_ai_color();
}

setup_rasta()
{
	self.animname = "rasta";
	level.rasta = self;
	self thread magic_bullet_shield();
}

setup_rasta_village()
{	
	
	if( isalive( level.gauntlet_west ) )
	{
		self place_weapon_on( "at4", "back" );
			
		
		fire_pos_ent = getent( self.target, "targetname" );
		thing = level.gauntlet_west;
		thing_offset = (0,0,64);
		self thread destroy_thing_with_at4( fire_pos_ent, thing, thing_offset );
		
		self waittill( "finished_anim_reach" );
		
		//Get back!	
		level.rasta dialogue_queue( "cont_rst_getback" );
		
		
		fire_pos_ent waittill( "at4_fire" );
	}

	self set_force_color( "g" );
	self enable_ai_color();
	
	
	
	//Check your fire! Check your fire! Friendlies coming in at your 12!	
	level.rasta dialogue_queue( "cont_rst_checkfire" );
}
/*	
	self.goalradius = 32;
	start = getent( "rasta_start", "targetname" );
	
	self setgoalpos ( start.origin );
	self waittill( "goal" );
	
	first_grenade_target = getent( start.target, "targetname" );
	target_org = first_grenade_target.origin;
	org = self gettagorigin( "TAG_INHAND" );
	
	vec = VectorNormalize( target_org - org );
	forward = vector_multiply( vec, 30 );
	pos = forward + org;
	
	self.grenadeawareness = 0;
	//draw_line_for_time( <org1> , <org2> , <r> , <g> , <b> , <timer> )
	//thread draw_line_for_time( pos , target_org , 1 , 0, 0 , 3 );
	grenade = MagicGrenade( "semtex_grenade", pos, target_org );
	grenade thread maps\_detonategrenades::semtex_sticky_handle( self );
	
	//Stand back!	
	thread dialogue_queue( "cont_rst_standback" );
	
	wait 1;
	
	second_grenade_throw_position = getent( first_grenade_target.target, "targetname" );
	
	self setgoalpos ( second_grenade_throw_position.origin );
	self waittill( "goal" );
	
	second_grenade_target = getent( second_grenade_throw_position.target, "targetname" );
	target_org = second_grenade_target.origin;
	org = self gettagorigin( "TAG_INHAND" );
	
	vec = VectorNormalize( target_org - org );
	forward = vector_multiply( vec, 30 );
	pos = forward + org;
	
	//draw_line_for_time( <org1> , <org2> , <r> , <g> , <b> , <timer> )
	//thread draw_line_for_time( pos , target_org , 1 , 0, 0 , 3 );
	grenade = MagicGrenade( "semtex_grenade", pos, target_org );
	grenade thread maps\_detonategrenades::semtex_sticky_handle( self );
	//Get back!	
	thread dialogue_queue( "cont_rst_getback" );
	
	
	self.grenadeawareness = 1;
	
	//wait 1;
	//
	//done_with_throwing_position = getent( second_grenade_target.target, "targetname" );
	//
	//self setgoalpos ( done_with_throwing_position.origin );
	//self waittill( "goal" );
	//
	//if( isalive( level.gauntlet_east ) )
	//	level.gauntlet_east waittill( "death" );
	//	
	//if( isalive( level.gauntlet_west ) )
	//	level.gauntlet_west waittill( "death" );
	//	
	self.goalradius = 2000;
*/	


setup_price()
{
	level.price = self;
	level.price.animname = "price";
	
	if( level.price_destroys_btr )
		level.price place_weapon_on( "at4", "back" );
	//level.price thread disable_ai_color();
//	level.price stealth_plugin_aicolor();
//	array = [];
//	array[ "hidden" ] = ::do_nothing;
//	array[ "spotted" ] = ::do_nothing;
//	level.price stealth_color_state_custom( array );

	level.price enable_ai_color();
	level.price.pathRandomPercent = 0;
	
	level.price thread magic_bullet_shield();
	//level.price thread price_bullet_sheild(); //disables bullet shield if player is too far
	//level.price thread price_handle_death();  //mission fail if price dies
	level.price make_hero();
	level.price.allowdeath = false;
	//level.price.dontshootwhilemoving = true;//tried it and it looks bad.
	
	//level.price thread stealth_price_accuracy_control();

	//level.price.baseaccuracy = 5000000;

	//all stuff from scoutsniper that might be a good idea
//	level.price thread price_death();
//	level.price setthreatbiasgroup( "price" );

	self thread animscripts\utility::PersonalColdBreath();
}

stealth_settings()
{
	stealth_set_default_stealth_function( "bridge_area", ::stealth_bridge_area );
	stealth_set_default_stealth_function( "woods", ::stealth_woods );
	stealth_set_default_stealth_function( "base", ::stealth_base );

	ai_event = [];
	ai_event[ "ai_eventDistNewEnemy" ] = [];
	ai_event[ "ai_eventDistNewEnemy" ][ "spotted" ]		 = 512;
	ai_event[ "ai_eventDistNewEnemy" ][ "hidden" ] 		 = 256;

	ai_event[ "ai_eventDistExplosion" ] = [];
	ai_event[ "ai_eventDistExplosion" ][ "spotted" ]	 = level.explosion_dist_sense;
	ai_event[ "ai_eventDistExplosion" ][ "hidden" ] 	 = level.explosion_dist_sense;

	ai_event[ "ai_eventDistDeath" ] = [];
	ai_event[ "ai_eventDistDeath" ][ "spotted" ] 		 = 512;
	ai_event[ "ai_eventDistDeath" ][ "hidden" ] 		 = 512; // used to be 256
	
	ai_event[ "ai_eventDistPain" ] = [];
	ai_event[ "ai_eventDistPain" ][ "spotted" ] 		 = 256;
	ai_event[ "ai_eventDistPain" ][ "hidden" ] 		 = 256; // used to be 256
	
	ai_event[ "ai_eventDistBullet" ] = [];
	ai_event[ "ai_eventDistBullet" ][ "spotted" ]		 = 96;
	ai_event[ "ai_eventDistBullet" ][ "hidden" ] 		 = 96;
	
	
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 300;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 300;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 300;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 300;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;

	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 800;
	rangesHidden[ "crouch" ]	= 1200;
	rangesHidden[ "stand" ]		= 1600;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 8192;
	rangesSpotted[ "crouch" ]	= 8192;
	rangesSpotted[ "stand" ]	= 8192;

	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	
	stealth_alert_level_duration( 0.5 );	

	stealth_ai_event_dist_custom( ai_event );

	array = [];
	array[ "sight_dist" ]	 = 400;
	array[ "detect_dist" ]	 = 200;
	stealth_corpse_ranges_custom( array );
}


sight_ranges_foggy_woods()
{
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 120;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 120;
		
	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 60;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 60;
	
	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;
	
	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 250;
	rangesHidden[ "crouch" ]	= 450;
	rangesHidden[ "stand" ]		= 500;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 500;
	rangesSpotted[ "crouch" ]	= 500;
	rangesSpotted[ "stand" ]	= 600;
		
	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	
	alert_duration = [];
	alert_duration[0] = 1;
	alert_duration[1] = 1;
	alert_duration[2] = 1;
	alert_duration[3] = 0.75;

	// easy and normal have 2 alert levels so the above times are effectively doubled
	stealth_alert_level_duration( alert_duration[ level.gameskill ] );	
}

woods_prespotted_func()
{
	wait 3;//default is 2.25
}



stealth_woods()
{
	self stealth_plugin_basic();

	if ( isplayer( self ) )
		return;

	//threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;

			
	switch( self.team )
	{
		case "axis":
			if( self.type == "dog" )
			{
				self thread dogs_have_small_fovs_when_stopped();
				self set_threatbias_group( "dogs" );
			}
			else
			{
				self thread attach_flashlight();
			}
			self.pathrandompercent = 0;
			self stealth_plugin_threat();
			self stealth_pre_spotted_function_custom( ::woods_prespotted_func );
			//self stealth_threat_behavior_custom( threat_array );
			
			threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			threat_array[ "attack" ] = ::small_goal_attack_behavior;//default
			self stealth_threat_behavior_custom( threat_array );
			
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			self.baseaccuracy = 2;
			self.fovcosine = .5;	
			self.fovcosinebusy = .1;
			
			self thread monitor_someone_became_alert();
			self thread monitor_stealth_kills();
			self thread monitor_stealth_pain();
			self init_cold_patrol_anims();
			
			if( isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "cqb_patrol" ) )
			{
				if( isdefined( self.script_patroller ) )
				{
					wait .05;
					self clear_run_anim();
				}
				self thread enable_cqbwalk();
				self.alertlevel = "alert";
				self.disablearrivals = undefined;
				self.disableexits = undefined;
				//if( isdefined( self.script_pet ) )
				//	self.moveplaybackrate = .4;
				//else
					self.moveplaybackrate = .8;
				thread scan_when_idle();
			}
			
			break;

		case "allies":
			//use the bridge area settings!
	}
}

scan_when_idle()
{
	self endon( "death" );
	while( 1 )
	{
		self set_generic_idle_anim( "cqb_stand_idle_scan" );
		
		self waittill( "clearing_specialIdleAnim" );
	}
}
	

stealth_bridge_area()
{
	self stealth_plugin_basic();

	if ( isplayer( self ) )
		return;

			
	switch( self.team )
	{
		case "axis":
			if( self.type == "dog" )
			{
				self thread dogs_have_small_fovs_when_stopped();
				self set_threatbias_group( "dogs" );
			}
			//self thread flashlight_when_alerted();
			if( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "truck_guys" ) )
				self set_threatbias_group( "truck_guys" );
			else
				self set_threatbias_group( "bridge_stealth_guys" );
					
			self stealth_plugin_threat();
			//self stealth_pre_spotted_function_custom( ::clifftop_prespotted_func );
			
			self.pathrandompercent = 0;
			threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			threat_array[ "attack" ] = ::small_goal_attack_behavior;//default
			self stealth_threat_behavior_custom( threat_array );
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			self.baseaccuracy = 3;
			self.fovcosine = .86;	// for the 2nd group -z
			self.fovcosinebusy = .1;
			//self thread dialog_price_kill();

			self thread monitor_stealth_kills();//price and player kill dialog
			self thread monitor_someone_became_alert();
			
			if( ( isdefined ( self.script_type ) ) && ( self.script_type == "cold_patrol" ) )
				self init_cold_patrol_anims();
			break;

		case "allies":
			//self.grenadeawareness = 0;//dont chase grenades
			//self._stealth.behavior.no_prone = true;
			//self._stealth.behavior.wait_resume_path = 4;
			//self._stealth_move_detection_cap = 0;
			
			//dynamic_run_speed settings:
			//self.drs_pushdist = 250;
			//self.drs_sprintdist = 0;//was 60
			//self.drs_stopdist = 400;
			
			//self thread stealth_plugin_smart_stance();
			//self thread stealth_no_fog_smart_stance();
			
			//self.dynamic_run_response_time = 1;
			
			array = [];
			array[ "hidden" ] = ::stealth_friendly_state_hidden;
			array[ "spotted" ] = ::stealth_friendly_state_spotted;
			stealth_basic_states_custom( array );
	}
}

stealth_base()
{
	self stealth_plugin_basic();

	if ( isplayer( self ) )
		return;
			
	switch( self.team )
	{
		case "axis":
			//self thread flashlight_when_alerted();

			self stealth_plugin_threat();
			//self stealth_pre_spotted_function_custom( ::clifftop_prespotted_func );
			
			self.pathrandompercent = 0;
			//threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			threat_array[ "attack" ] = ::large_goal_ambush_attack_behavior;//default
			self stealth_threat_behavior_custom( threat_array );
			//self stealth_enable_seek_player_on_spotted();
			//self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			//self.baseaccuracy = 3;
			self.fovcosine = .76;	// for the 2nd group -z
			self.fovcosinebusy = .1;
			//self thread dialog_price_kill();

			//self thread monitor_stealth_kills();//price and player kill dialog
			//self thread monitor_someone_became_alert();
			
			if( ( isdefined ( self.script_type ) ) && ( self.script_type == "cold_patrol" ) )
				self init_cold_patrol_anims();
			break;

		case "allies":
			//self.grenadeawareness = 0;//dont chase grenades
			//self._stealth.behavior.no_prone = true;
			//self._stealth.behavior.wait_resume_path = 4;
			//self._stealth_move_detection_cap = 0;
			
			//dynamic_run_speed settings:
			//self.drs_pushdist = 250;
			//self.drs_sprintdist = 0;//was 60
			//self.drs_stopdist = 400;
			
			//self thread stealth_plugin_smart_stance();
			//self thread stealth_no_fog_smart_stance();
			
			//self.dynamic_run_response_time = 1;
			
			array = [];
			array[ "hidden" ] = ::stealth_friendly_state_hidden;
			array[ "spotted" ] = ::stealth_friendly_state_spotted;
			stealth_basic_states_custom( array );
	}
}

///////////////////////////////////////////
//price_move_speed_think()
//{
//	self notify( "start_dynamic_run_speed" );
//
//	self endon( "death" );
//	self endon( "stop_dynamic_run_speed" );
//	self endon( "start_dynamic_run_speed" );
//
//	if ( !isdefined( self.ent_flag[ "dynamic_run_speed_stopped" ] ) )
//	{
//		self ent_flag_init( "dynamic_run_speed_stopped" );
//		self ent_flag_init( "dynamic_run_speed_stopping" );         
//	}                          
//	else                          
//	{                          
//		self ent_flag_clear( "dynamic_run_speed_stopping" );        
//		self ent_flag_clear( "dynamic_run_speed_stopped" );         
//	}                          
//	                          
//	self thread price_move_speed_handle_cleanup();                  
//                              
//	self.run_speed_state = "";                          
//                              
//	fardist_min = 500 * 500;
//	fardist_max = 600 * 600;
//	stopdist_min = 250 * 250;
//	stopdist_max = 400 * 400;
//	ai_slow_dist = 1400 * 1400;
//	ai_stop_dist_min = 850 * 850;
//	ai_stop_dist_max = 950 * 950;//tweaking these breaks hide and kill stragglers
//	                          
//	responsiveness_ai = .2;
//	//responsiveness_player_loc = 4;                          
//	//player_loc_count = responsiveness_player_loc / responsiveness_ai;
//	//ticks = 0;                          
//                              
//                              
//	while ( 1 )                          
//	{                          
//		closest_dist = self GetClosestEnemySqDist();                
//		if( !isdefined( closest_dist ) )                          
//			closest_dist = 99999999;                          
//		//enemies = GetAISpeciesArray( "axis", "all" );             
//        //                          
//		//if ( enemies.size == 0 )                          
//		//	closest_dist = 99999999;                          
//		//else                          
//		//	closest_dist = distance ( level.player.origin, ( getClosest( level.player.origin, enemies ) ).origin );
//                              
//		if ( ( closest_dist < ai_stop_dist_min ) )                      
//		{                          
//			/#                          
//			println( "price_dynamic:   enemy close. stopping (min). " + closest_dist/closest_dist );
//			#/                          
//			price_dynamic_run_set( "stop" );                        
//			wait responsiveness_ai;                          
//			continue;
//		}
//		
//		if ( ( closest_dist < ai_stop_dist_max ) && ( self.run_speed_state == "stop" ) )
//		{                          
//			println( "price_dynamic:   enemy close. stopping (max). " + closest_dist/closest_dist );
//			price_dynamic_run_set( "stop" );
//			wait responsiveness_ai;
//			continue;
//		}
//		
//		//how far is the player from price                          
//		dist = DistanceSquared( self.origin, level.player.origin ); 
//		  
//		/*                        
//		angles1 = vectortoangles( self.goalpos - self.origin );
//		forward1 = anglestoforward( angles1 );
//		                          
//		angles2 = vectortoangles( level.player.origin - self.origin );
//		forward2 = anglestoforward( angles2 );
//		
//		vectordor( forward1, forward2 );
//		*/
//				
//		//normal = VectorNormalize( end_origin - start_origin );
//		//forward = AnglesToForward( start_angles );
//		//dot = VectorDot( forward, normal );
//			                          
//		//vec = anglestoforward( self.angles );
//		vec_goal = VectorNormalize( ( self.goalpos - self.origin ) );//angle of where I'm supposed to go
//		vec2 = VectorNormalize( ( level.player.origin - self.origin ) );
//		//vecdot = vectordot( vec, vec2 );//dot of my angle vs player position
//		vecdot = vectordot( vec_goal, vec2 );//dot my my goal dir vs player position
//		//level.g = vecdot;
//		                          
//		if ( ( dist > stopdist_max ) && ( vecdot < 0 ) )//vecdot > 0 means in 180 in front
//		{                          
//			println( "price_dynamic:   price too far in front (max). stopping. " + vecdot );
//			price_dynamic_run_set( "stop" );                        
//			wait responsiveness_ai;                          
//			continue;                          
//		}
//		                          
//		if ( ( dist > stopdist_min ) && ( self.run_speed_state == "stop" ) && ( vecdot < 0 ) )
//		{                          
//			println( "price_dynamic:   price too far in front (min). stopping. " + vecdot );
//			price_dynamic_run_set( "stop" );                        
//			wait responsiveness_ai;                          
//			continue;
//		}
//		                          
//		if ( ( closest_dist < ai_slow_dist ) )                      
//		{                          
//			/#                          
//			println( "price_dynamic:   enemy close. crouch. " + closest_dist/closest_dist );
//			#/                          
//			price_dynamic_run_set( "crouch" );                      
//			wait responsiveness_ai;                          
//			continue;
//		}
//		                          
//		                          
//		if ( ( vecdot > - .25 ) && ( dist > fardist_max ) )         
//		{                          
//			println( "price_dynamic:   player in front (max). running. " );
//			price_dynamic_run_set( "run" );                         
//			wait responsiveness_ai;                          
//			continue;                          
//		}                          
//		                          
//		if ( ( vecdot > - .25 ) && ( dist > fardist_min ) && ( self.run_speed_state == "run" ) )
//		{                          
//			println( "price_dynamic:   player in front (min). running. " );
//			price_dynamic_run_set( "run" );                         
//			wait responsiveness_ai;                          
//			continue;                          
//		}                          
//		                          
//		//otherwise cqb                          
//		println( "price_dynamic:   cqb " );                         
//		price_dynamic_run_set( "cqb" );                          
//		wait responsiveness_ai;                          
//	}
//}
//
//
//                              
//price_dynamic_run_set( speed )                          
//{                             
//	if ( self.run_speed_state == speed )                          
//		return;                          
//	self notify( "dynamic_run_speed_changing" );                    
//	self.run_speed_state = speed;                          
//                              
//	switch( speed )                          
//	{                          
//		case "cqb":                          
//			self.pathenemyfightdist = 192;                          
//			self.pathenemylookahead = 192;                          
//			self enable_cqbwalk();                          
//			self allowedstances( "stand", "crouch", "prone" );
//			
//			self notify( "stop_loop" );
//			self anim_stopanimscripted();
//			self ent_flag_clear( "dynamic_run_speed_stopped" );
//			break;                          
//		case "run":                          
//			self.pathenemyfightdist = 192;                          
//			self.pathenemylookahead = 192;                          
//			self disable_cqbwalk();                          
//			self allowedstances( "stand", "crouch", "prone" );
//			
//			self notify( "stop_loop" );
//			self anim_stopanimscripted();
//			self ent_flag_clear( "dynamic_run_speed_stopped" );
//			break;                          
//		case "stop":                          
//			self thread price_dynamic_run_stop();
//			break;                          
//		case "crouch":                          
//			self.pathenemyfightdist = 192;                          
//			self.pathenemylookahead = 192;                          
//			self allowedstances( "crouch" );                        
//			self disable_cqbwalk();
//			
//			self notify( "stop_loop" );
//			self anim_stopanimscripted();
//			self ent_flag_clear( "dynamic_run_speed_stopped" );
//			break;                          
//	}                          
//}
//
//
//price_move_speed_handle_cleanup()                          
//{                   
//	self endon( "start_dynamic_run_speed" );
//	self endon( "death" );
//
//	self price_dynamic_run_speed_cleanup_wait();
//                              
//	self disable_cqbwalk();                          
//	self allowedstances( "stand", "crouch", "prone" );              
//	self.pathenemyfightdist = 192;                          
//	self.pathenemylookahead = 192;          
//	self notify( "stop_loop" );     
//	self anim_stopanimscripted(); 
//	self ent_flag_clear( "dynamic_run_speed_stopping" );
//	self ent_flag_clear( "dynamic_run_speed_stopped" );     
//}
//
//price_dynamic_run_speed_cleanup_wait()
//{
//	level endon( "_stealth_spotted" );
//	self waittill( "stop_dynamic_run_speed" );
//}
                              
//price_dynamic_run_stop()                          
//{                           
//	self notify( "stop_going_to_node" );                          
//	wait 1;                          
//	                          
//	self.oldgoal = self.goalpos;                          
//	self.oldradius = self.goalradius;                          
//                            
//	self setgoalpos( self.origin );                          
//	self.goalradius = 90;                          
//	                          
//	self waittill( "dynamic_run_speed_changing" );                  
//	                          
//	self.goalradius = self.oldradius;                          
//	if( isdefined( self.last_set_goalent ) )                        
//	{                          
//		self thread follow_path( self.last_set_goalent );           
//	}                          
//	else                          
//	{                          
//		self setgoalpos( self.oldradius );                          
//	}                         
//}                           
                              
//price_dynamic_run_set( speed )
//{
//	if ( self.run_speed_state == speed )
//		return;
//
//	self.run_speed_state = speed;
//
//	switch( speed )
//	{
//		case "cqb":
//			self.moveplaybackrate = 1;
//
//			self enable_cqbwalk();
//			self allowedstances( "stand", "crouch", "prone" );
//
//			self notify( "stop_loop" );
//			self ent_flag_clear( "dynamic_run_speed_stopped" );
//			break;
//		case "run":
//
//			self disable_cqbwalk();
//			if ( IsDefined( level.scr_anim[ "generic" ][ "DRS_run" ] ) )
//			{
//				if ( IsArray( level.scr_anim[ "generic" ][ "DRS_run" ] ) )
//					self set_generic_run_anim_array( "DRS_run" );
//				else
//					self set_generic_run_anim( "DRS_run" );
//			}
//			else
//				self clear_run_anim();
//			//self AllowedStances( "stand", "crouch", "prone" );
//
//			self notify( "stop_loop" );
//			self anim_stopanimscripted();
//			self ent_flag_clear( "dynamic_run_speed_stopped" );
//			break;
//		case "stop":
//			self thread price_dynamic_move_speed_stop();
//			break;
//		case "crouch":
//			self.moveplaybackrate = 1;
//
//			self clear_run_anim();
//			self allowedstances( "crouch" );
//
//			self disable_cqbwalk();
//			self notify( "stop_loop" );
//			self ent_flag_clear( "dynamic_run_speed_stopped" );
//			break;
//	}
//}

//stop_dynamic_price_speed()
//{
//	self endon( "start_dynamic_run_speed" );
//	self endon( "death" );
//
//	self.moveplaybackrate = 1;
//	self clear_run_anim();
//	self allowedstances( "stand", "crouch", "prone" );
//
//	self notify( "stop_loop" );
//	self ent_flag_clear( "dynamic_run_speed_stopping" );
//	self ent_flag_clear( "dynamic_run_speed_stopped" );
//}


price_dynamic_run_stop()
{
	self endon( "death" );

	if ( self ent_flag( "dynamic_run_speed_stopped" ) )
		return;
	if ( self ent_flag( "dynamic_run_speed_stopping" ) )
		return;

	self endon( "stop_dynamic_run_speed" );

	self ent_flag_set( "dynamic_run_speed_stopping" );
	self ent_flag_set( "dynamic_run_speed_stopped" );

	//->turned this off because I think checking the current movement would fix whatever this was trying to
	//if( self ent_flag_exist( "_stealth_stance_handler" ) )
	//	self ent_flag_waitopen( "_stealth_stance_handler" );

	stop = "DRS_run_2_stop";
	self maps\_anim::anim_generic_custom_animmode( self, "gravity", stop );
	self ent_flag_clear( "dynamic_run_speed_stopping" );// this flag gets cleared if we endon
	
	//moved this line below clearing the stopping flag so we make sure that clears before this function has a chance to end.
	if( !self ent_flag( "dynamic_run_speed_stopped" ) )
		return;
	self endon( "dynamic_run_speed_stopped" );
	
	//if he's already playing a looping animation - we can assume its part of level logic and 
	//it makes sense not to play a stopping animation or play dialogue to tell you to catch up
	if ( IsDefined( self.loops ) && self.loops > 0 )
		return;

	while ( self ent_flag( "dynamic_run_speed_stopped" ) )
	{
		//->turned this off because I think checking the current movement would fix whatever this was trying to
		//if( self ent_flag_exist( "_stealth_stance_handler" ) )
		//	self ent_flag_waitopen( "_stealth_stance_handler" ); 

		idle = "DRS_stop_idle";
		self thread maps\_anim::anim_generic_loop( self, idle );

		if ( IsDefined( level.scr_anim[ "generic" ][ "signal_go" ] ) )
			self handsignal( "go" );

		wait RandomFloatRange( 12, 20 );

		if ( self ent_flag_exist( "_stealth_stance_handler" ) )
			self ent_flag_waitopen( "_stealth_stance_handler" );

		self notify( "stop_loop" );

		if ( !self ent_flag( "dynamic_run_speed_stopped" ) )
			return;

		if ( IsDefined( level.dynamic_run_speed_dialogue ) )
		{
			string = random( level.dynamic_run_speed_dialogue );
			level thread radio_dialogue_queue( string );
		}

		if ( IsDefined( level.scr_anim[ "generic" ][ "signal_go" ] ) )
			self handsignal( "go" );
	}
}




dogs_have_small_fovs_when_stopped()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "master_reached_patrol_end" );
		self.fovcosine = .99;
		self notify( "end_patrol" );
		
		self waittill( "_stealth_normal" );//be came alert
		self.fovcosine = .76;
	}
}

setup_stealth_enemy_cleanup()
{
	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	if( isdefined( self.script_stealthgroup ) )
		self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	
	self.goalradius = 400;
	self.favoriteenemy = level.player;
	self setgoalentity( level.player );

	self waittill( "death" );
	level.stealth_enemies_remaining--;
}

Small_Goal_Attack_Behavior()
{
	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	

	self.goalradius = 400;

	self endon( "death" );

	self ent_flag_set( "_stealth_override_goalpos" );

	while ( isdefined( self.enemy ) && self ent_flag( "_stealth_enabled" ) )
	{
		self setgoalpos( self.enemy.origin );

		wait 4;
	}
}



setup_base_starting_guys()
{
	self endon( "death" );
	self.ignoreme = true;
	self.maxsightdistsqrd = 600*600;
	
	flag_wait( "base_alerted" );
	
	self.ignoreme = false;
	self.maxsightdistsqrd = 8000*8000;
//	if( isdefined( self._stealth ) )
//	{
//		self ent_flag_clear( "_stealth_normal" );
//		self stealth_ai_clear_custom_idle_and_react();
//	}
	
//	self stopanimscripted();
//	self notify( "killanimscripts" );
	
	self.favoriteenemy = level.player;
	//self.ignoreme = false;
	//self notify( "end_patrol" );
	wait 1;
	
	self.favoriteenemy = undefined;
	
	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	self.combatmode = "ambush";
	self setgoalpos( self.origin );
	self.goalradius = 4000;
	self.maxsightdistsqrd = 8000*8000;	
}


large_goal_ambush_attack_behavior()
{
}

//stealth_no_fog_smart_stance()
//{
//	self._stealth.behavior.No_Prone = true;
//	
//	// i do this because the player doesn't look as bad sneaking up on the enemies
//	// friendlies however don't look as good getting so close
//	looking_away = [];
//	looking_away[ "stand" ] 	 = 0;
//	looking_away[ "crouch" ] 	 = -800;
//	looking_away[ "prone" ] 	 = -800;//was -800
//	
//	neutral = [];
//	neutral[ "stand" ] 			 = 200;
//	neutral[ "crouch" ] 		 = 0;
//	neutral[ "prone" ] 			 = 0;
//	
//	looking_towards = [];
//	looking_towards[ "stand" ] 	 = 200;
//	looking_towards[ "crouch" ]  = 0;
//	looking_towards[ "prone" ] 	 = 0;
//	
//	
//	stealth_friendly_stance_handler_distances_set( looking_away, neutral, looking_towards );
//}
//
//stealth_fog_smart_stance()
//{
//	self._stealth.behavior.No_Prone = true;
//	
//	// i do this because the player doesn't look as bad sneaking up on the enemies
//	// friendlies however don't look as good getting so close
//	looking_away = [];
//	looking_away[ "stand" ] 	 = -700;
//	looking_away[ "crouch" ] 	 = -700;
//	looking_away[ "prone" ] 	 = -700;
//	
//	neutral = [];
//	neutral[ "stand" ] 			 = -500;
//	neutral[ "crouch" ] 		 = -700;
//	neutral[ "prone" ] 			 = -700;
//	
//	looking_towards = [];
//	looking_towards[ "stand" ] 	 = -100;
//	looking_towards[ "crouch" ]  = -200;
//	looking_towards[ "prone" ] 	 = -200;
//	
//	stealth_friendly_stance_handler_distances_set( looking_away, neutral, looking_towards );
//}




stealth_friendly_state_hidden()
{	
	flag_clear( "price_is_hiding" );
	self.no_pistol_switch = true;
	
	//dont aim at dudes in the woods
	if( ( !flag( "player_on_ridge" ) ) && flag( "safe_from_btrs" ) )
		self.maxsightdistsqrd = level.price_maxsightdistsqrd_woods;
	
	self.ignoreCloseFoliage = true;
	
	
	//dont run to color nodes before village
	if( !flag( "approaching_ridge" ) )
	{
		self disable_ai_color();
		

		if( isdefined( self.smart_path_following_node ) )
		{
			self thread enable_cqbwalk();
			self thread price_smart_path_following( self.smart_path_following_node );
		}
	}
	
	self pushplayer( true );
	self.fixednode = true;
	//self set_force_color( "r" );
	self thread set_battlechatter( false );
	self set_friendlyfire_warnings( false );
	self.dontEverShoot 	= true;
		
	self.grenadeammo	 = 0;
	
	self.forceSideArm 	= undefined;
	//used to be ignore all - but that makes him not aim at enemies when exposed - which isn't good...also 
	//after stealth groups were created we want to differentiate between who should be shot at and who shouldn't
	//so we don't all of a sudden alert another stealth group by shooting at them
	//self.dontEverShoot 	= true; 
	self.ignoreme 		= true;
	//self enable_ai_color();
	self.ignoresuppression = true;
	setsaveddvar( "ai_friendlyfireblockduration", 0 );
	setsaveddvar( "ai_friendlysuppression", 0 );
}

stealth_friendly_state_spotted()
{	
	self notify( "stop_dynamic_run_speed" );
	self.no_pistol_switch = undefined;
	self.ignoreall = false;
	self.fixednode = true;
	self.ignoreCloseFoliage = true;
	
	//dont run to color nodes if in the woods
	if( ( !flag( "approaching_ridge" ) ) && !flag( "safe_from_btrs" ) )
	{
		self enable_ai_color();
		self set_force_color( "y" );
	}
	
	self thread set_battlechatter( false );//BCS sounds bad in combat right now
	self set_friendlyfire_warnings( true );
	self.dontEverShoot 	= undefined;
	//self thread set_battlechatter( true );
	
	self.maxsightdistsqrd = 8000*8000;
	self.grenadeammo 	= 0;
	//used to be ignore all - but that makes him not aim at enemies when exposed - which isn't good...also 
	//after stealth groups were created we want to differentiate between who should be shot at and who shouldn't
	//so we don't all of a sudden alert another stealth group by shooting at them	
	//self.dontEverShoot 	= false;//self.ignoreall 	 = false;
	self.ignoreme 	 	= false;
			
	//self.disablearrivals 	 = true;
	//self.disableeXits 	 = true;
	
	self pushplayer( false );
	//self disable_cqbwalk();
	
	//self thread maps\_stealth_behavior_friendly::friendly_spotted_getup_from_prone();		
	//self allowedstances( "prone", "crouch", "stand" );
	//self anim_stopanimscripted();
	
	//self disable_ai_color();
	//self setgoalpos( self.origin );
	self.ignoresuppression = false;
	setsaveddvar( "ai_friendlyfireblockduration", 2000 );
	setsaveddvar( "ai_friendlysuppression", 1 );
}


init_cold_patrol_anims()
{
	// make sure we alternate instead of doing a random selection
	if( !IsDefined( level.lastColdPatrolAnimSetAssigned ) )
	{
		level.lastColdPatrolAnimSetAssigned = "none";
	}
	
	if( level.lastColdPatrolAnimSetAssigned != "huddle" )
	{
		self.patrol_walk_anim = "patrol_cold_huddle";
		self.patrol_walk_twitch = "patrol_twitch_weights";
		
		self.patrol_scriptedanim[ "pause" ][ 0 ] = "patrol_cold_huddle_pause";
		self.patrol_stop[ "pause" ] = "patrol_cold_huddle_stop";
		self.patrol_start[ "pause" ] = "patrol_cold_huddle_start";
		
		self.patrol_stop[ "path_end_idle" ] = "patrol_cold_huddle_stop";
		self.patrol_end_idle[ 0 ] = "patrol_cold_huddle_pause";
		
		level.lastColdPatrolAnimSetAssigned = "huddle";
	}
	else
	{
		self.patrol_walk_anim = "patrol_cold_crossed";
		self.patrol_walk_twitch = "patrol_twitch_weights";
		
		self.patrol_scriptedanim[ "pause" ][ 0 ] = "patrol_cold_crossed_pause";
		self.patrol_stop[ "pause" ] = "patrol_cold_crossed_stop";
		self.patrol_start[ "pause" ] = "patrol_cold_crossed_start";
		
		self.patrol_stop[ "path_end_idle" ] = "patrol_cold_crossed_stop";
		self.patrol_end_idle[ 0 ] = "patrol_cold_crossed_pause";
		
		level.lastColdPatrolAnimSetAssigned = "crossed";
	}
}


setup_bridge_trucks()
{
	
	self endon( "death" );
	
	flag_wait( "truck_guys_alerted" );
	println( "truck_guys_alerted" );
	
	flag_wait( "convoy_half_way_across_bridge" );

	guys = get_living_ai_array( "truck_guys", "script_noteworthy" );
	
	if( guys.size == 0 )
	{
		self Vehicle_SetSpeed( 0, 15 );
		return;
	}
	
	screamer = random( guys );
	screamer maps\_stealth_shared_utilities::enemy_announce_wtf();

	//wait .5;
	//self waittill( "safe_to_unload" );

	self Vehicle_SetSpeed( 0, 15 );
	wait 1;
	self maps\_vehicle::vehicle_unload();
	
	flag_set( "jeep_stopped" );
}

base_truck_guys_think()
{
	self endon( "death" );

	//if ( flag( "_stealth_spotted" ) || self ent_flag( "_stealth_attack" ) )
	//	return;
		
	level endon( "_stealth_spotted" );
	self endon( "_stealth_attack" );

	self ent_flag_init( "jumped_out" );
	self ent_flag_init( "not_first_attack" );
	self thread truck_guys_think_jumpout();

	self maps\_stealth_shared_utilities::ai_create_behavior_function( "animation", "wrapper", ::truck_animation_wrapper );
	
	//corpse_array = [];
	//corpse_array[ "saw" ] 	 = ::truck_guys_reaction_behavior;
	//corpse_array[ "found" ] = ::truck_guys_reaction_behavior;
	//self stealth_corpse_behavior_custom( corpse_array );

	alert_array = [];
	//alert_array[ "warning1" ] = ::truck_guys_reaction_behavior;
	//alert_array[ "warning2" ] = ::truck_guys_reaction_behavior;
	alert_array[ "attack" ] = ::truck_alert_level_attack;//default
	self stealth_threat_behavior_custom( alert_array );

	awareness_array = [];
	awareness_array[ "explode" ] = ::truck_guys_no_enemy_reaction_behavior;
	awareness_array[ "heard_scream" ] = ::truck_guys_no_enemy_reaction_behavior;
	awareness_array[ "doFlashBanged" ] = ::truck_guys_no_enemy_reaction_behavior;

	foreach ( key, value in awareness_array )
		self maps\_stealth_event_enemy::stealth_event_mod( key, value );

	self ent_flag_set( "_stealth_behavior_reaction_anim" );
}


base_truck_guys_attacked_again()
{
	self endon( "death" );
	self endon( "_stealth_attack" );
	level endon( "_stealth_spotted" );
		
	wait 2;
		
	self waittill( "_stealth_bad_event_listener" );
	
	self maps\_stealth_shared_utilities::enemy_reaction_state_alert();

	self ent_flag_set( "not_first_attack" );
}

truck_guys_base_search_behavior( node )
{
	self endon( "_stealth_enemy_alert_level_change" );
	level endon( "_stealth_spotted" );
	self endon( "_stealth_attack" );
	self endon( "death" );
	self endon( "pain_death" );

	self thread base_truck_guys_attacked_again();

	self.disablearrivals = false;
	self.disableexits = false;

	distance = distance( node.origin, self.origin );

	self setgoalnode( node );
	self.goalradius = distance * .5;

	wait 0.05;	// because stealth system keeps clearing run anim on every enemy_animation_wrapper
	self set_generic_run_anim( "_stealth_patrol_cqb" );
	self waittill( "goal" );

	self set_generic_run_anim( "patrol_cold_gunup_search", true );

	self.disablearrivals = true;
	self.disableexits = true;
	self maps\_stealth_shared_utilities::enemy_runto_and_lookaround( node );
}


truck_guys_think_jumpout()
{
	self endon( "death" );
	self endon( "pain_death" );

	while ( 1 )
	{
		self waittill( "jumpedout" );
		self._stealth.behavior.last_spot = self.origin;
		//self enemy_set_original_goal( self.origin );
		self.got_off_truck_origin = self.origin;
		self ent_flag_set( "jumped_out" );

		self waittill( "enteredvehicle" );
		wait .15;
		self ent_flag_clear( "jumped_out" );
		self ent_flag_set( "_stealth_behavior_reaction_anim" );
	}
}

truck_animation_wrapper( type )
{
	self endon( "death" );
	self endon( "pain_death" );

	flag_set( "truck_guys_alerted" );

	self ent_flag_wait( "jumped_out" );

	self maps\_stealth_shared_utilities::enemy_animation_wrapper( type );
}

truck_guys_reaction_behavior( type )
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_spotted" );	
	self endon( "_stealth_attack" );

	flag_set( "truck_guys_alerted" );
	
	self ent_flag_wait( "jumped_out" );

	if ( !flag( "truck_guys_alerted" ) )
		return;
	if ( flag_exist( "truck_guys_not_going_back" ) && flag( "truck_guys_not_going_back" ) )
		return;

	if ( !flag( "_stealth_spotted" ) && !self ent_flag( "_stealth_attack" ) )
	{
		player = get_closest_player( self.origin );
		node = maps\_stealth_shared_utilities::enemy_find_free_pathnode_near( player.origin, 1500, 128 );

		if ( isdefined( node ) )
			self thread truck_guys_base_search_behavior( node );
	}

	spotted_flag = self group_get_flagname( "_stealth_spotted" );
	if ( flag( spotted_flag ) )
		self flag_waitopen( spotted_flag );
	else
		self waittill( "normal" );		
}


truck_guys_no_enemy_reaction_behavior( type )
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_spotted" );	
	self endon( "_stealth_attack" );

	flag_set( "truck_guys_alerted" );
	
	self ent_flag_wait( "jumped_out" );

	if ( !flag( "truck_guys_alerted" ) )
		return;
	if ( flag_exist( "truck_guys_not_going_back" ) && flag( "truck_guys_not_going_back" ) )
		return;

	if ( !flag( "_stealth_spotted" ) && !self ent_flag( "_stealth_attack" ) )
	{
		origin = self._stealth.logic.event.awareness_param[ type ];

		node = self maps\_stealth_shared_utilities::enemy_find_free_pathnode_near( origin, 300, 40 );

		self thread maps\_stealth_shared_utilities::enemy_announce_wtf();

		if ( isdefined( node ) )
			self thread truck_guys_base_search_behavior( node );
	}

	spotted_flag = self group_get_flagname( "_stealth_spotted" );
	if ( flag( spotted_flag ) )
		self flag_waitopen( spotted_flag );
	else
		self waittill( "normal" );		
}

truck_alert_level_attack( enemy )
{
	self endon( "death" );
	self endon( "pain_death" );

	flag_set( "truck_guys_alerted" );
	self ent_flag_wait( "jumped_out" );

	self small_goal_attack_behavior();
	//self maps\_stealth_threat_enemy::enemy_close_in_on_target();
	
	//self cliffhanger_enemy_attack_behavior();
}


setObjectiveWaypoint( objName, text )
{
	objective = level.objectives[objName];
	if( isdefined( text ) )
		Objective_SetPointerTextOverride( objective.id, text );
	else
		Objective_SetPointerTextOverride( objective.id );
}

registerObjective( objName, objText, objOrigin )
{
	flag_init( objName );
	if( !isdefined( level.objectives ) )
		level.objectives = [];
	objID = level.objectives.size;

	newObjective = spawnStruct();
	newObjective.name = objName;
	newObjective.id = objID;
	newObjective.state = "invisible";
	newObjective.text = objText;
	newObjective.origin = objOrigin;
	newObjective.added = false;

	level.objectives[objName] = newObjective;

	return newObjective;
}


setObjectiveState( objName, objState )
{
	assert( isDefined( level.objectives[objName] ) );

	objective = level.objectives[objName];
	objective.state = objState;

	if ( !objective.added )
	{
		objective_add( objective.id, objective.state, objective.text, objective.origin );
		objective.added = true;
	}
	else
	{
		objective_state( objective.id, objective.State );
	}

	if ( objective.state == "done" )
		flag_set( objName );
}


setObjectiveString( objName, objString )
{
	objective = level.objectives[objName];
	objective.text = objString;

	objective_string( objective.id, objString );
}

setObjectiveLocation( objName, objLoc )
{
	objective = level.objectives[objName];
	objective.loc = objLoc;

	objective_position( objective.id, objective.loc );
}

setObjectiveLocationMoving( objName, objEnt, offset )
{
	level notify( "moving " + objName );
	level endon( "moving " + objName );
	objective = level.objectives[objName];
	
	Objective_OnEntity( objective.id, objEnt, offset );
	
	//while( objective.state != "done" )
	//{
	//	if( !isdefined( objEnt ) )
	//		break;
	//	objective_position( objective.id, objEnt.origin + (0,0,64) );
	//	wait .05;
	//}
}

setObjectiveRemaining( objName, objString, objRemaining )
{
	assert( isDefined( level.objectives[objName] ) );

	objective = level.objectives[objName];

	if ( !objRemaining )
		objective_string( objective.id, objString );
	else
		objective_string( objective.id, objString, objRemaining );
}


//default_start( ::start_start );
//add_start( "start", ::start_start, "Start" );
////add_start( "bridge", ::start_bridge, "Bridge" );
//add_start( "slide", ::start_slide, "Slide" );
//add_start( "woods", ::start_woods, "Woods" );
//add_start( "ridge", ::start_ridge, "ridge" );
//add_start( "village", ::start_village, "village" );
//add_start( "base", ::start_base, "Base" );
//add_start( "dock", ::start_dock, "Dock" );
//add_start( "sub", ::start_sub, "Submarine" );


objective_main()
{
	switch( level.start_point )
	{
		case "default":
		case "start":
			delay_first_obj();
		case "slide":
		case "woods":
		case "midwoods":
		case "ridge":
		case "village":
			//objective_enter_base();
		case "base":
			objective_price();
			objective_get_to_sub();
		case "defend_sub":
			objective_defend_sub();
		//case "exit_sub":
		//	objective_exit_sub();
	}
}

delay_first_obj()
{
	flag_wait( "price_starts_moving" );
}

objective_price()
{
	while( !isdefined( level.price ) )
		wait .1;
	registerObjective( "obj_price", &"CONTINGENCY_OBJ_PRICE", level.price.origin );
	setObjectiveState( "obj_price", "current" );
	thread setObjectiveLocationMoving( "obj_price", level.price, (0,0,70) );
	
	//flag_wait( "time_to_use_UAV" );
	if( level.gameSkill > 1 )
	{
		flag_wait( "base_alerted" );
	}
	else
	{ 
		flag_wait( "price_splits_off" );
	}
	//flag_wait( "both_gauntlets_destroyed" );
	
	setObjectiveState( "obj_price", "done" );
}

//objective_enter_base()
//{
//	obj_base_entrance = getent( "obj_base_entrance", "targetname" );
//	registerObjective( "obj_enter", &"CONTINGENCY_OBJ_ENTER_BASE", obj_base_entrance.origin );
//	setObjectiveState( "obj_enter", "current" );
//	
//	flag_wait( "obj_base_entrance" );
//	
//	setObjectiveState( "obj_enter", "done" );
//}


objective_get_to_sub()
{
	if( level.gameSkill <= 1 )
		return;
	
	origin = ( -11742.0, 2368.0, 643.0 );
	
	obj_reach_split_off = getstruct( "obj_reach_split_off", "targetname" );
	if( isdefined( obj_reach_split_off ) )
		origin = obj_reach_split_off.origin;
	registerObjective( "obj_reach", &"CONTINGENCY_OBJ_ENTER_SUB", origin );
	setObjectiveState( "obj_reach", "current" );
	
	flag_wait( "price_splits_off" );
	
	setObjectiveState( "obj_reach", "done" );
}


objective_defend_sub()
{
	
	//obj_sub_entrance = getent( "obj_sub_entrance", "targetname" );
	//registerObjective( "obj_sub", &"CONTINGENCY_OBJ_ENTER_SUB", obj_sub_entrance.origin );
	//setObjectiveState( "obj_sub", "current" );
	
	flag_wait( "price_splits_off" );
	
	origin = getstruct( "obj_guard_house", "targetname" ).origin;
	registerObjective( "obj_sub", &"CONTINGENCY_OBJ_DEFEND_SUB", origin + (0,0,48) );
	setObjectiveState( "obj_sub", "current" );
	setObjectiveWaypoint( "obj_sub", &"CONTINGENCY_OBJ_DEFEND" );
	//setObjectiveString( "obj_sub", &"CONTINGENCY_OBJ_DEFEND_SUB" );
	//setObjectiveLocation( "obj_sub", origin + (0,0,48) );
	
	
	flag_wait( "close_sub_hatch" );
	
	setObjectiveState( "obj_sub", "done" );
}
	
	
//	flag_wait( "obj_sub_entrance" );
//	
//	origin = getstruct( "control_sub_obj_pos", "targetname" ).origin;
//	setObjectiveString( "obj_sub", &"CONTINGENCY_OBJ_CONTROL_SUB" );
//	setObjectiveLocation( "obj_sub", origin );
//	
//	flag_wait( "player_key_rdy" );
//	
//	origin = getent( "players_key", "targetname" ).origin;
//	setObjectiveString( "obj_sub", &"CONTINGENCY_OBJ_TURN_KEY" );
//	setObjectiveLocation( "obj_sub", origin );
//
//	flag_wait( "player_turned_key" );
//	
//	setObjectiveState( "obj_sub", "done" );
//}
//
//
//
//objective_exit_sub()
//{	
//	while( !isdefined( level.soap_truck ) )
//		wait .1;
//	registerObjective( "obj_exit", &"CONTINGENCY_OBJ_EXIT_SUB", level.soap_truck.origin );
//	setObjectiveState( "obj_exit", "current" );
//	thread setObjectiveLocationMoving( "obj_exit", level.soap_truck );
//	
//	flag_wait( "player_in_uaz" );
//	
//	setObjectiveState( "obj_exit", "done" );
//}



base_autosave_logic()
{
	save = true;
	flag_wait( "base_entrance" );
	
	if( isdefined( level.timer_allowed_time ) )
	{
		time_passed = ( gettime() - level.timer_start_time ) / 1000;
		println( "time passed " + time_passed );
		time_left = level.timer_allowed_time - time_passed;
		println( "time left " + time_left );
		if( time_left < 90 )
			save = false;
		else
			save = true;
	}
	if( save )
		autosave_by_name( "partway1" );
	
	flag_wait( "player_is_halfway_to_sub" );
	
	if( isdefined( level.timer_allowed_time ) )
	{
		time_passed = ( gettime() - level.timer_start_time ) / 1000;
		println( "time passed " + time_passed );
		time_left = level.timer_allowed_time - time_passed;
		println( "time left " + time_left );
		if( time_left < 80 )
			save = false;
		else
			save = true;
	}
	if( save )
		autosave_by_name( "partway2" );
	
	flag_wait( "base_ending" );
	
	if( isdefined( level.timer_allowed_time ) )
	{
		time_passed = ( gettime() - level.timer_start_time ) / 1000;
		println( "time passed " + time_passed );
		time_left = level.timer_allowed_time - time_passed;
		println( "time left " + time_left );
		if( time_left < 40 )
			save = false;
		else
			save = true;
	}
	if( save )
		autosave_by_name( "partway3" );
}


timer_start()
{
	if ( getdvar( "notimer" ) == "1" )
		return;
	dialogue_line = undefined;
	level.timer_allowed_time = undefined;
	switch( level.gameSkill )
	{
		case 0:// easy
			//iSeconds = 240;
			//break;
			return;
		case 1:// regular
			//iSeconds = 240;
			//break;
			return;
		case 2:// hardened
			level.timer_allowed_time = 180;
			break;
		case 3:// veteran
			level.timer_allowed_time = 120;
			break;
	}
	assert( isdefined( level.timer_allowed_time ) );

	thread dialog_time_nags( level.timer_allowed_time );
	
	level thread timer_logic( level.timer_allowed_time, &"CONTINGENCY_TIME_TO_ENTER_SUB" );
	level.timer_start_time = gettime();
}

timer_logic( iSeconds, sLabel, bUseTick )
{

	if ( getdvar( "notimer" ) == "1" )
		return;

	if ( !isdefined( bUseTick ) )
		bUseTick = false;
	// destroy any previous timer just in case
	killTimer();
	level endon( "kill_timer" );

	/*-----------------------
	TIMER SETUP
	-------------------------*/		
	level.hudTimerIndex = 20;
	level.timer = maps\_hud_util::get_countdown_hud( -250 );
	level.timer SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.timer.label = sLabel;
	level.timer settenthstimer( iSeconds );
	level.start_time = gettime();

	/*-----------------------
	TIMER EXPIRED
	-------------------------*/	
	if ( bUseTick == true )
		thread timer_tick();
	wait( iSeconds );

	//flag_set( "timer_expired" );
	level.timer destroy();
	// Mission failed. The objective was not completed in time.
	level thread mission_failed_out_of_time( &"CONTINGENCY_SUB_TIMER_EXPIRED" );
}

killTimer()
{
	level notify( "kill_timer" );
	if ( isdefined( level.timer ) )
		level.timer destroy();
}

timer_tick()
{
	level endon( "stop_timer_tick" );
	level endon( "kill_timer" );
	while ( true )
	{
		wait( 1 );
		level.player thread play_sound_on_entity( "countdown_beep" );
		level notify( "timer_tick" );
	}
}

mission_failed_out_of_time( deadquote )
{
	level.player endon( "death" );
	level endon( "kill_timer" );
	level notify( "mission failed" );
	level.player freezeControls( true );
	//level.player thread player_death_effect();
	//level.player thread play_sound_on_entity( "airplane_final_explosion" );
	musicstop( 1 );
	setDvar( "ui_deadquote", deadquote );
	maps\_utility::missionFailedWrapper();
	level notify( "kill_timer" );
}

set_threatbias_group( group )
{
	assert( threatbiasgroupexists( group ) );
	self setthreatbiasgroup( group );
}

flashlight_when_alerted()
{
	self endon( "death" );
	self ent_flag_waitopen( "_stealth_normal" );
	
	wait randomfloatrange( .2, .8 );
	
	PlayFXOnTag( level._effect[ "flashlight" ], self, "tag_flash" );
	self.have_flashlight = true;
}

attach_flashlight()
{
	PlayFXOnTag( level._effect[ "flashlight" ], self, "tag_flash" );
	self.have_flashlight = true;
}

bmp_turret_attack_player( end_if_cant_see, no_misses )
{
	if( !isdefined( end_if_cant_see ) )
		end_if_cant_see = false;
		
	if( !isdefined( no_misses ) )
		no_misses = false;
		
	//self thread debug_bmp_hit_player();
	self endon( "stop_shooting" );
	self endon( "death" );
	while ( 1 )
	{
		//choose our target based on distance and visibility
		player = get_closest_player( self.origin );
		/*
		if ( ! can_see_player( player ) )
		{
			dif_player = get_different_player( player );
			if ( can_see_player( dif_player ) )
				player = dif_player;
		}
		*/
		wait( randomfloatrange( 0.8, 1.3 ) );

		// don't try to shoot a player with an RPG or Stinger
		//if ( player usingAntiAirWeapon() )
		//	continue;
		
		//dont try to shoot a player who is hiding a safe volume
		//if ( player is_hidden_from_heli( self ) )
		//	continue;
			
		//wait for player to be visible
		while ( !can_see_player( player ) )
			wait( randomfloatrange( 0.2, 0.6 ) );//was .8 1.3

		if( !no_misses )
		{
			//saw player, now miss for 2 bursts
			miss_player( player );
			wait( randomfloatrange( 0.8, 2.4 ) );

			miss_player( player );
			wait( randomfloatrange( 0.8, 2.4 ) );
		}

		//if player is still exposed then hit him
		while ( can_see_player( player ) )
		{
			fire_at_player( player );
			wait( randomfloatrange( 2, 3 ) );
		}
		//player is hidden, now will suppress/hit him for 1 burst if he tries to peek out
		//fire_at_player( player );
		//wait( randomfloatrange( .3, 1 ) );
		
		if( end_if_cant_see )
		{
			if( !can_see_player( player ) )
			{
				self clearturrettarget();
				self.turret_busy = false;
				//self ent_flag_clear( "spotted_player" );
				//flag_clear ("bmp_has_spotted_player" );
				self notify( "stop_shooting" );
			}
		}
		
		//fire_at_player( player );
	}
}


can_see_player( player )
{	
	if( distance( self.origin, level.player.origin ) < level.min_btr_fighting_range )
		return false;
	
	tag_flash_loc = self getTagOrigin( "tag_flash" );
	//BulletTracePassed( <start>, <end>, <hit characters>, <ignore entity> );
	player_eye = player geteye();
	if ( SightTracePassed( tag_flash_loc, player_eye, false, self ) )
	{
		if( isdefined( level.debug ) )
			line( tag_flash_loc, player_eye, ( 0.2, 0.5, 0.8 ), 0.5, false, 60 );
		return true;
	}
	else
	{
		//println( "        ---trace failed" );
		return false;
	}
}


fire_at_player( player )
{
	burstsize = randomintrange( 3, 5 );
	//println("         **HITTING PLAYER, burst: " + burstsize );
	fireTime = .2;
	for ( i = 0; i < burstsize; i++ )
	{
		self setturrettargetent( player, randomvector( 20 ) + ( 0, 0, 32 ) );//randomvec was 50
		self fireweapon();
		wait fireTime;
	}
}

miss_player( player )
{
	//println("           missing player" );
	//miss_vec = randomvector( 100 );
	//miss_vec = randomvectorrange( 40, 100 );
	

	//point in front of player
	forward = AnglesToForward( level.player.angles );
	forwardfar = vector_multiply( forward, 100 );
	miss_vec = forwardfar + randomvector( 50 );
	
	
	burstsize = randomintrange( 4, 6 );
	fireTime = .2;
	for ( i = 0; i < burstsize; i++ )
	{
		offset = randomvector( 15 ) + miss_vec + (0,0,64);
		//println( "           offset: " + offset );
		//thread draw_line_for_time( self.origin+(0,0,128), player.origin+offset, 0, 0, 1, 2 );
		//thread draw_line_for_time( player.origin+offset+(0,0,4), player.origin+offset, 0, 0, 1, 2 );
		self setturrettargetent( player, offset );
		self fireweapon();
		wait fireTime;
	}
}