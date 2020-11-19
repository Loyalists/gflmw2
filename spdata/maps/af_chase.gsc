#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_spline_zodiac;
#include maps\_vehicle;
#include maps\af_chase_code;
#include maps\af_chase_zodiac;
#include maps\_hud_util;

main()
{
	maps\af_chase_knife_fight_code::timescale_does_not_effect_sound();

	level.ambience_timescale = 0;

	precachestring( &"AF_CHASE_PURSUE" );
	precachestring( &"AF_CHASE_MISSION_FAILED_IN_THE_OPEN" );
	precachestring( &"AF_CHASE_MISSION_FAILED_KEEP_UP" );
	precachestring( &"AF_CHASE_FAILED_TO_SHOOT_DOWN" );
	precachestring( &"AF_CHASE_PRESS_USE" );
	precachestring( &"AF_CHASE_HINT_CRAWL_RIGHT" );
	precachestring( &"AF_CHASE_HINT_CRAWL_LEFT" );
	precachestring( &"AF_CHASE_KILL_SHEPHERD" );
	precachestring( &"SCRIPT_WAYPOINT_SHEPHERD" );
	precachestring( &"AF_CHASE_FAILED_TO_CRAWL" );
	precachestring( &"AF_CHASE_FAILED_TO_PULL_KNIFE" );
		
//	PreCacheItem( "cheytac" );

	PreCacheItem( "m203" );
	PreCacheRumble( "steady_rumble" );
	PreCacheRumble( "smg_fire" );
	PreCacheItem( "m16_grenadier" );
	PreCacheItem( "rpg_straight_af_chase" );
	PreCacheItem( "rpg_af_chase" );
	PreCacheItem( "rpd" );
	PreCacheItem( "uzi" );
	PreCacheItem( "littlebird_FFAR" );
	PreCacheModel( "weapon_commando_knife" );
	PreCacheModel( "weapon_commando_knife_bloody" );
	PreCacheModel( "viewmodel_commando_knife" );
	PreCacheModel( "viewmodel_commando_knife_bloody" );
	PreCacheModel( "zodiac_head_roller" );
	PreCacheModel( "weapon_colt_anaconda" );
	PreCacheModel( "vehicle_pickup_destroyed" );
	PreCacheModel( "weapon_colt_anaconda_animated" );
	PreCacheModel( "fx_rifle_shell" );
//	PreCacheModel( "body_desert_tf141_zodiac" );
//	PreCacheModel( "viewhands_player_tf141_bloody" );
//	precachemodel( "head_hero_price_desert_beaten" );
//	precachemodel( "head_vil_shepherd_damaged" );
	PreCacheModel( "ch_viewhands_player_gk_m4_sopmod_ii" );
	PreCacheModel( "ch_viewhands_gk_m4_sopmod_ii" );
	precachemodel( "vehicle_little_bird_bench_afghan" );
	
	PreCacheRumble( "heavy_1s" );
	PreCacheRumble( "heavy_2s" );
	PreCacheRumble( "heavy_3s" );

	PreCacheRumble( "light_1s" );
	PreCacheRumble( "light_2s" );
	PreCacheRumble( "light_3s" );

//	precachemodel( "body_vil_shepherd_no_gun" );

	PreCacheModel( "prop_misc_literock_small_01" );
	PreCacheModel( "prop_misc_literock_small_02" );
	PreCacheModel( "prop_misc_literock_small_03" );
	PreCacheModel( "prop_misc_literock_small_04" );
	PreCacheModel( "prop_misc_literock_small_05" );
	PreCacheModel( "prop_misc_literock_small_06" );
	PreCacheModel( "prop_misc_literock_small_07" );
	PreCacheModel( "prop_misc_literock_small_08" );
	
	
	PreCacheShellShock( "af_chase_under_water" );
	PreCacheShellShock( "af_chase_turn_buckle_slam" );
	PreCacheShellShock( "af_chase_ending_wounded" );
	PreCacheShellShock( "af_chase_ending_pulling_knife_later" );
	PreCacheShellShock( "af_chase_ending_no_control" );
	PreCacheShellShock( "af_chase_ending_no_control_lowkick" );
	PreCacheShellShock( "af_chase_ending_wakeup" );
	PreCacheShellShock( "af_chase_ending_wakeup_nomove" );
	
	PreCacheShellShock( "af_chase_boatdrive_end" );

	PreCacheShader( "overlay_hunted_black" );
	precacheItem( "ending_knife" );
//	precacheItem( "ending_knife_silent" );
	
	precacheShader( "hud_icon_commando_knife" );
	precacheShader( "reticle_center_throwingknife" );
	precacherumble( "tank_rumble" );
	precacherumble( "damage_light" );
	precacherumble( "damage_heavy" );
	
	level.next_rpg_firetime = GetTime();

	maps\af_chase_precache::main();
//	maps\_patrol_anims::main();
	maps\af_chase_fx::main();

	//original worldspawn values;
	// sunlight 1.5;
	//	0.960784 0.827451 0.647059

	SetSunLight( 1.441176, 1.2411765, 0.9705885 );
	SetSavedDvar( "r_specularcolorscale", "3" );

	
	add_start( "boatdrive_nofail", 		::start_boatdrive_nofail, "", 					::empty );
	add_start( "boatdrive_begin", 		::start_boatdrive_begin, "", 						::empty );
	add_start( "boatdrive_lake", 		::start_boatdrive_lake, "", 						::empty );
	add_start( "boatdrive_lake_mid", 	::start_boatdrive_lake_mid, "", 					::empty );
	add_start( "boatdrive_rapids", 		::start_boatdrive_rapids, "", 					::empty );
	add_start( "boatdrive_below_rapids",::start_boatdrive_river_below_rapids, "", 		::empty );
	add_start( "boatdrive_end", 		::start_boatdrive_end, "", 						maps\af_chase_knife_fight::wakeup_after_crash );
	maps\af_chase_knife_fight::add_knife_fight_starts();
	add_start( "debug_boatdrive", 	::start_debug_boatdrive, "", 							::empty );

/*
	add_start( "wakeup", 		 		::start_wakeup_after_crash, "", 					::wakeup_after_crash );
	add_start( "wakefast", 		 		::start_wakeup_after_crash, "", 					::wakeup_after_crash );
	add_start( "turnbuckle", 			::start_turnbuckle, "", 							::fight_turnbuckle );
	add_start( "gloat", 				::start_shepherd_gloats, "", 						::shepherd_gloats );
	add_start( "gun_drop", 	 			::start_gun_drop, "", 								::gun_drop );
	add_start( "crawl", 				::start_gun_crawl, "", 								::gun_crawl );
	add_start( "gun_kick", 				::start_gun_kick, "", 								::gun_kick );
	add_start( "wounded", 				::start_wounded_show, "Watch Price/Shep fight",		::wounded_show );
	add_start( "pullout", 				::start_knife_pullout, "", 	 						::knife_pullout );
	add_start( "kill", 				::start_knife_pullout, "", 	 						::knife_pullout );
	add_start( "price_wakeup", 			::start_price_wakeup, "", 							::price_wakeup );
	add_start( "walkoff", 				::start_walkoff, "", 								::walkoff );
*/

	default_start( ::start_default );

	maps\af_chase_knife_fight::init_ending();
	


	init_flags_here();

	maps\_load::main();

	thread start_point_catchup_thread();

	maps\af_chase_anim::main_anim();

	thread maps\af_chase_knife_fight::init_main_and_ending_common_stuff();

	maps\_zodiac_drive::zodiac_preLoad( "ch_viewhands_player_gk_m4_sopmod_ii" );
	maps\_zodiac_ai::main();
	
	//add_hint_string( "btobackup" , &"SCRIPT_PLATFORM_ZODIAC_STEADY", ::hint_test );

	/#
	SetDevDvarIfUninitialized( "scr_zodiac_test", 0 );
	#/

//	SetExpFog( 1000, 8000, 0.60, 0.50, 0.40, 0.8, 0 );

/* - Some temp stuff for messing with level fog and vision sets.
	maps\_utility::set_vision_set( "af_chase_outdoors_2", 0 );
	Start Fog - 1000, 8000, 0.60, 0.50, 0.40, 0.8, 0
	Caves fog - 1000, 8000, 0.60, 0.50, 0.40, 0.45, 0
	resevoir fog 1 -  8000, 45000, 0.60, 0.50, 0.40, 0.3, 0
	reveoir 2 - 2000, 20000, 0.60, 0.50, 0.40, 0.2, 0
	rapids - 1000, 11000, 0.60, 0.50, 0.40, 0.55, 0
	gorge - 1500, 15000, 0.60, 0.50, 0.40, 0.45, 0
	waterfall - 10000, 50000, 0.60, 0.50, 0.40, 0.75, 0  */


	script_vehicle_zodiac_players = GetEntArray( "script_vehicle_zodiac_player", "classname" );
	array_thread( script_vehicle_zodiac_players, ::add_spawn_function, maps\_zodiac_drive::drive_vehicle );
	array_thread( script_vehicle_zodiac_players, ::add_spawn_function, ::setup_boat_for_drive );
	array_thread( script_vehicle_zodiac_players, ::add_spawn_function, ::zodiac_physics );

	rpg_bridge_guy = GetEntArray( "rpg_bridge_guy", "script_noteworthy" );
	array_thread( rpg_bridge_guy, ::add_spawn_function, ::rpg_bridge_guy );

	actor_enemy_afghan_RPG = GetEntArray( "actor_enemy_afghan_RPG", "classname" );
	array_thread( actor_enemy_afghan_RPG, ::add_spawn_function, ::rpg_bridge_guy_target );
	sight_range = 3000 * 3000;
	foreach ( object in actor_enemy_afghan_RPG )
	{
		object.script_sightrange = sight_range;
	}


//	thread_the_needle = GetEntArray( "thread_the_needle", "targetname" );
//	array_thread( thread_the_needle, ::trigger_thread_the_needle );

	rope_splashers = GetEntArray( "rope_splashers", "script_noteworthy" );
	array_thread( rope_splashers, ::add_spawn_function, ::rope_splashers );

	GetEnt( "enemy_chase_boat", "targetname" ) add_spawn_function( ::enemy_chase_boat );

	rapids_trigger = GetEnt( "rapids_trigger", "targetname" );
	rapids_trigger thread autosave_boat_chase();
	rapids_trigger thread	trigger_set_water_sheating_time( "bump_small_after_rapids", "bump_big_after_rapids" );
	rapids_trigger thread trigger_rapids();

	on_river_trigger = GetEnt( "on_river_trigger", "targetname" );
	on_river_trigger thread trigger_on_river();
	
	boat_mount = GetEnt( "boat_mount", "targetname" );
	boat_mount thread trigger_boat_mount();

	increase_enemy_boats_mid_lake = GetEnt( "increase_enemy_boats_mid_lake", "script_noteworthy" );
	increase_enemy_boats_mid_lake thread trigger_set_max_zodiacs( 2 );

	trigger_multiple_speeds = GetEntArray( "trigger_multiple_speed", "classname" );
	array_thread( trigger_multiple_speeds, ::trigger_multiple_speed_think );

	script_vehicle_littlebird_armed = GetEntArray( "script_vehicle_littlebird_armed", "classname" );
	array_thread( script_vehicle_littlebird_armed, ::add_spawn_function, ::godon );

	script_vehicle_zodiacs = GetEntArray( "script_vehicle_zodiac", "classname" );
	script_vehicle_zodiac_physics = GetEntArray( "script_vehicle_zodiac_physics", "classname" ) ;
	array_thread( script_vehicle_zodiac_physics, ::add_spawn_function, ::zodiac_physics );

	all_zodicas = array_combine( script_vehicle_zodiacs, script_vehicle_zodiac_physics );
	array_thread( all_zodicas, ::add_spawn_function, ::zodiac_treadfx );
	array_thread( all_zodicas, ::add_spawn_function, ::zodiac_enemy_setup );

//	foreach ( zodiac in script_vehicle_zodiac_physics )
//		zodiac.origin += ( 0, 0, 64 );// bump them up because they were previously not physics and placed below the surface

	script_vehicle_pavelow = GetEntArray( "script_vehicle_pavelow", "classname" );
	array_thread( script_vehicle_pavelow, ::add_spawn_function, ::disable_origin_offset );

	add_global_spawn_function( "axis", ::set_fixed_node_after_seeing_player_spawn_func );
	add_global_spawn_function( "axis", ::lower_accuracy_behind_player );
	add_global_spawn_function( "axis", ::boatsquish );
	
	thread remove_global_spawn_funcs();

	destructible_fake = GetEntArray( "destructible_fake", "script_noteworthy" );
	array_thread( destructible_fake, ::destructible_fake );

	thread afchase_objectives();

	end_caves_trigger = GetEnt( "end_caves_trigger", "targetname" );
	end_caves_trigger thread trigger_end_caves();
	end_caves_trigger thread autosave_boat_chase();

//	price_tells_player_go_right = GetEnt( "price_tells_player_go_right", "targetname" );
//	price_tells_player_go_right thread trigger_price_tells_player_go_right();


	heli_attack_player_idle = getstructarray( "heli_attack_player_idle", "script_noteworthy" );
	array_thread( heli_attack_player_idle, ::heli_attack_player_idle );

	heli_attack_player_idle = GetEntArray( "heli_attack_player_idle", "script_noteworthy" );
	array_thread( heli_attack_player_idle, ::heli_attack_player_idle );

	kill_destructibles_and_barrels_in_volume = GetEntArray( "kill_destructibles_and_barrels_in_volume", "targetname" );
	array_thread( kill_destructibles_and_barrels_in_volume, ::kill_destructibles_and_barrels_in_volume );

	add_extra_autosave_check( "boat_check_trailing", ::autosave_boat_check_trailing, "trailing too far behind the enemy boat." );


	thread river_current( "river_flow" );


	thread maps\af_chase_zodiac::zodiac_main();

	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );// this might bite me later.

	price_position_switch = GetEntArray( "price_position_switch", "targetname" );
	array_thread( price_position_switch, ::price_position_switch );

	bobbing_boat = GetEntArray( "bobbing_boat", "script_noteworthy" );
	array_thread( bobbing_boat, ::add_spawn_function, ::bobbing_boat_spawn );

	crashable_whizby_boats = GetEntArray( "crashable_whizby_boats", "script_noteworthy" );
	array_thread( crashable_whizby_boats, ::add_spawn_function, ::crashable_whizby_boats );

	enemy_zodiacs_wipe_out = GetEnt( "enemy_zodiacs_wipe_out", "targetname" );
	enemy_zodiacs_wipe_out thread trigger_enemy_zodiacs_wipe_out();

	neutral_enemies = GetEntArray( "neutral_enemies", "targetname" );
	array_thread( neutral_enemies, ::trigger_neutral_enemies );

	dialog_cave = GetEnt( "dialog_cave", "targetname" );
//	dialog_cave = Spawn( "trigger_radius", (-18968, -18324, 0), 0, 730.399, 1000 );
	dialog_cave thread dialog_cave();

	thread dialog_boat_battlechatter();

	thread sunsample_after_caves();

	thread dvar_warn();

	thread set_price_autoswitch_after_caves();

	thread search_the_scrash_site();

	if ( is_default_start() || issubstr( level.start_point, "boat" ) )
		thread maps\af_chase_waterfall::main();

	trigger_out_of_caves = GetEnt( "trigger_out_of_caves", "targetname" );
	if ( IsDefined( trigger_out_of_caves ) )
		trigger_out_of_caves thread trigger_out_of_caves();
		
	open_area = getentarray( "open_area", "targetname" );
	array_thread( open_area, ::trigger_open_area );	
	battlechatter_off( "allies" );
//	thread dump_on_command();

	sentry_technicals = getentarray( "sentry_technical", "script_noteworthy" );
	array_thread( sentry_technicals, ::add_spawn_function, ::sentry_technical_think );	
	
//	thread dialog_radio();
	explode_barrels_in_radiuss = getentarray( "explode_barrels_in_radius", "targetname" );
	array_thread( explode_barrels_in_radiuss, ::explode_barrels_in_radius_think );
	thread af_chase_music();

}

init_flags_here()
{
	
	flag_init( "no_more_physics_effects" );
	flag_init( "player_in_open" );
	flag_init( "zodiac_catchup" );
	flag_init( "player_in_sight_of_boarding" );
	flag_init( "player_on_boat" );
	flag_init( "exit_caves" );
	flag_init( "enemy_zodiacs_wipe_out" );
	flag_init( "on_river" );
	flag_init( "zodiac_boarding" );
	flag_init( "enemy_heli_takes_off" );
	flag_init( "price_anim_on_boat" );
	flag_init( "rapids_head_bobbing" );
	flag_init( "heli_firing" );


	/#
	flag_init( "debug_crumbs" );
	#/
	
}

empty()
{
}


music_start()
{
	level endon ( "stop_music_at_splash" );
	
	MusicStop( .4 );
	wait 1.5;
	
	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	level.music_emitter = org;
	
	while( 1 )
	{
		org playsound( "af_chase_startinboat", "sounddone" );
		org waittill ( "sounddone" );
	}
}

start_default()
{
	boat_common();
	level.price thread animate_price_into_boat();
	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );
	thread enable_bread_crumb_chase();
	thread set_breadcrumb_fail_time( 15 );
	objective_onentity( obj( "pursue" ), enemy_boat );
	
	thread dialog_start();

	thread maps\_introscreen::af_chase_intro();

	wait 3;
//	vehicle_dump();

	flag_wait( "player_on_boat" );
	maps\_friendlyfire::TurnOff();

	thread set_breadcrumb_fail_time( 10, 30 );
}



start_boatdrive_begin()
{
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_boatdrive_begin" );
	boat_common();
	vision_set_fog_changes( "afch_fog_caves", 0 );

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.

	friendly_boat UseBy( level.player );
	level.player.drivingVehicle = friendly_boat;
//	friendly_boat Vehicle_SetSpeedImmediate( 33,90,90 );

	thread enable_bread_crumb_chase();
}


start_debug_boatdrive()
{
	boat_common();
	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	friendly_boat UseBy( level.player );
	level.player.drivingVehicle = friendly_boat;
	array_thread( GetEntArray( "trigger_multiple", "code_classname" ), ::trigger_off );
}

start_boatdrive_lake_mid()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_mid_lake" );
	boat_common();
	flag_set( "exit_caves" );
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "lake_mid_start_pose", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.

	friendly_boat UseBy( level.player );
	level.player.drivingVehicle = friendly_boat;
	
	friendly_boat Vehicle_SetSpeedImmediate( 60, 90, 90 );// last two params don't do anything but are required for the boat.

	thread enable_bread_crumb_chase();

	thread river_current( 	"river_current_start_boatdrive_lake" );

}

start_boatdrive_lake()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_lake" );
	boat_common();
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "lake_start_pose", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.

	friendly_boat UseBy( level.player );
	level.player.drivingVehicle = friendly_boat;
	
	friendly_boat Vehicle_SetSpeedImmediate( 48, 90, 90 );// last two params don't do anything but are required for the boat.

	thread enable_bread_crumb_chase();

	thread river_current( 	"river_current_start_boatdrive_lake" );

}




start_boatdrive_rapids()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_rapids" );

	change_target_ent_on_vehicle_spawner( "seaknight_fly_over", "enemy_heli_pos_rapids" );

	boat_common();
	flag_set( "exit_caves" );

	//af_chase_outdoors_2
	//set vision set so the water thing can work
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "rapids_start_position", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );
	enemy_pickup_heli = spawn_vehicle_from_targetname_and_drive( "seaknight_fly_over" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.

	friendly_boat UseBy( level.player );
	level.player.drivingVehicle = friendly_boat;
	
	friendly_boat Vehicle_SetSpeedImmediate( 78, 90, 90 );// last two params don't do anything but are required. not optional for boats I guess.

	thread enable_bread_crumb_chase();

	//catch up the current
	thread river_current( 	"river_current_start_rapids" );

}

start_boatdrive_river_below_rapids()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_below_rapids" );
	change_target_ent_on_vehicle_spawner( "seaknight_fly_over", "enemy_heli_pos_rapids" );

	boat_common();
	flag_set( "exit_caves" );
	flag_set( "on_river" );

	//af_chase_outdoors_2
	//set vision set so the water thing can work
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "below_rapids_start_position", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.

	friendly_boat UseBy( level.player );
	level.player.drivingVehicle = friendly_boat;
	
	friendly_boat Vehicle_SetSpeedImmediate( 78, 90, 90 );// last two params don't do anything but are required. not optional for boats I guess.

	thread enable_bread_crumb_chase();

	//catch up the current
	thread river_current( 	"river_current_start_rapids" );

}

start_boatdrive_end()
{
	//fast forward to new location. speed is approximated based on pretend playthrough.
	
//	thread music_start();
	change_target_on_vehicle_spawner( "enemy_chase_boat", "enemy_boat_pos_end" );

	seaknight_pickup_boat_spot = GetEnt( "seaknight_pickup_boat_spot", "script_noteworthy" );
	
	thread kill_all_the_ai_and_fx_from_boatride();


	boat_common();
	flag_set( "exit_caves" );
	flag_set( "enemy_zodiacs_wipe_out" );

	//af_chase_outdoors_2
	//set vision set so the water thing can work
	vision_set_fog_changes( "af_chase_outdoors_2", 0 );

	// move player boat to new position
	player_boat_spawner = GetEnt( "players_boat", "targetname" );
	player_boat_spawner_position = getstruct( "end_start_position", "targetname" );
	player_boat_spawner.origin = player_boat_spawner_position.origin;
	player_boat_spawner.angles = player_boat_spawner_position.angles;

	friendly_boat = spawn_vehicle_from_targetname( "players_boat" );
	enemy_boat = spawn_vehicle_from_targetname_and_drive( "enemy_chase_boat" );
	enemy_pickup_heli = spawn_vehicle_from_targetname( "enemy_pickup_heli" );

	waittillframeend;// let the spawned vehicle run its spawn_func to catch this useby notify.

	level.player PlayerLinkToBlend( friendly_boat, "tag_player", .2, .1, .1);
	friendly_boat UseBy( level.player );
	level.player.drivingVehicle = friendly_boat;

	friendly_boat Vehicle_SetSpeedImmediate( 57, 90, 90 );// last two params don't do anything but are required. not optional for boats I guess.

	thread enable_bread_crumb_chase();
	thread river_current( 	"river_current_start_boatdrive_end" );
	
}


start_boatdrive_nofail()
{
	SetDvar( "scr_zodiac_test", 1 );
	level.player EnableInvulnerability();
	thread start_default();
}

afchase_objectives()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{

		case "default":
		case "boatdrive_nofail": 		
		case "boatdrive_begin": 		
		case "boatdrive_lake": 		
		case "boatdrive_lake_mid": 	
		case "boatdrive_rapids": 		
		case "boatdrive_below_rapids":
		case "boatdrive_end": 		
		case "boatdrive_end_test": 		
			// Don't let Shepherd get away.
			Objective_Add( obj( "pursue" ), "current", &"AF_CHASE_PURSUE" );
			objective_onentity( obj( "pursue" ), level.enemy_boat, (0,0,160) );
			
			flag_wait( "player_in_sight_of_boarding" );
			Objective_State( obj( "pursue" ), "done" );
		
		case "wakeup": 		 	
		case "wakefast":
		case "turnbuckle": 		
		case "gloat": 			
		case "wounded":
		case "pullout":
		case "kill":
		case "gun_drop":	 		
		case "crawl":	 		
		case "gun_kick": 			
		case "knife_fight": 		
		case "price_wakeup":
		case "knife_moment":		
		case "walkoff":		
		case "end": 				
		case "scene_fight_loop_B":
		case "scene_fight_loop_C":
		case "scene_fight_loop_D2":
		case "scene_fight_loop_D3":
		case "scene_fight_loop_E":
		case "on_foot_art_tweak": 
		case "debug_boatdrive":
			thread maps\af_chase_knife_fight::knife_fight_objectives();
			break;
		
		default:
			assertmsg( "Start point " + level.start_point + " isn't handled by afchase_objectives" );
	}
}



dialog_radio()
{
	
	level.scr_radio[ "afchase_shp_stillincaves" ] = "afchase_shp_stillincaves";
	level.scr_radio[ "afchase_shp_observe" ] = "afchase_shp_observe";
	level.scr_radio[ "afchase_shp_uavsupport" ] = "afchase_shp_uavsupport";
	wait 1;
	flag_wait( "player_on_boat" );
	wait 10;
	level.player radio_dialogue( "afchase_shp_stillincaves" );
	
	wait 10;
	
	level.player radio_dialogue( "afchase_shp_observe" );
	
	
//"afchase_shp_uavsupport"                                 
//"afchase_shp_dangerclose"
//"afchase_shp_clearedhot"
//"afchase_shp_takeem"
//"afchase_shp_tryagain"

	flag_wait ( "exit_caves" );
	
	wait 4;
	level.player radio_dialogue( "afchase_shp_uavsupport" );
}



start_point_catchup_thread()
{
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	if ( is_default_start() )
		return;
	if ( start == "boatdrive_nofail" )
		return;
	if ( start == "boatdrive_begin" )
		return;
	if ( start == "boatdrive_lake" )
		return;
	if ( start == "boatdrive_lake_mid" )
		return;
	if ( start == "boatdrive_rapids" )
		return;
	if ( start == "boatdrive_below_rapids" )
		return;
	
	remove_global_spawn_function( "axis", ::set_fixed_node_after_seeing_player_spawn_func );
	remove_global_spawn_function( "axis", ::lower_accuracy_behind_player );

	flag_set( "stop_boat_dialogue" );
	if ( start == "boatdrive_end" )
		return;
	if ( start == "boatdrive_end_test" )
		return;

	thread maps\af_chase_knife_fight::startpoint_catchup();
}


af_chase_music()
{
	switch ( level.start_point )
	{
		case "default":
		case "debug_boatdrive":
		case "boatdrive_begin":
		case "boatdrive_nofail":
			thread maps\_utility::set_ambient( "af_chase_caves" );
		case "boatdrive_lake":
		case "boatdrive_lake_mid":
		case "boatdrive_rapids":
		case "boatdrive_below_rapids":
		case "boatdrive_end":
		thread MusicLoop( "af_chase_startinboat" ); // 3 minutes 21 seconds
		
		flag_wait( "test_boat_is_on_spline" );
		level notify( "stop_music" );
		MusicStop( 4 );
		level.player thread play_sound_on_entity( "af_chase_waterfall" );
		case "wakeup":
		case "wakefast":
		case "turnbuckle":
		case "gloat":
		flag_wait( "af_chase_final_fight" );
		case "gun_drop":
		musicplaywrapper( "af_chase_final_fight" ); // becomes ~1 second desynced but I don't care.
		case "crawl":
		case "gun_kick":
		case "wounded":
		case "pullout":
		case "kill":
		case "price_wakeup":
		case "walkoff":
		
		flag_wait( "af_chase_final_ending" );
		musicplaywrapper( "af_chase_final_ending" );
		flag_wait( "af_chase_ending_credits" );
		music_loop( "af_chase_ending_credits" , 90, 1 );
		
		break;

		default:
			AssertMsg( "Unhandled start point " + level.start_point );
			break;
	}
	
}