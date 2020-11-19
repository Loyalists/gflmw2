#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\invasion_anim;

main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;

	setsaveddvar( "r_specularcolorscale", "2.3" );

	level.min_time_between_uav_launches = 4 * 1000;
	level.obj_direction = undefined;
	level.min_btr_fighting_range = 400;
	level.attackheliRange = 7000;
	level.redshirts = [];
	level.goodFriendlyDistanceFromPlayerSquared = 300 * 300;
	level.cosine[ "90" ] = cos( 90 );
	level.cosine[ "60" ] = cos( 60 );
	level.cosine[ "25" ] = cos( 25 );
	level.droppers = 0;
	level.dropped = 0;
	level.bmps_from_north_dead = 0;
	level.bcs_maxThreatDistFromPlayer = 3500;
	level.no_remote_missile_reminders = true;

	PreCacheItem( "remote_missile_invasion" );
	level.remote_missile_invasion = true;

	
	precacheString( &"INVASION_LINE1" );
	precacheString( &"INVASION_LINE2" );
	precacheString( &"INVASION_LINE3" );
	precacheString( &"INVASION_LINE4" );
	precacheString( &"INVASION_LINE5" );
	
level.weaponClipModels = [];
level.weaponClipModels[0] = "weapon_scar_h_clip";
level.weaponClipModels[1] = "weapon_ak47_clip";
level.weaponClipModels[2] = "weapon_ump45_clip";
level.weaponClipModels[3] = "weapon_fn2000_clip";
level.weaponClipModels[4] = "weapon_mp5_clip";
level.weaponClipModels[5] = "weapon_saw_clip";
level.weaponClipModels[6] = "weapon_mp44_clip";
level.weaponClipModels[7] = "weapon_m16_clip";
	
	build_light_override( "btr80", "vehicle_btr80", "spotlight", 		"TAG_FRONT_LIGHT_RIGHT", "misc/spotlight_btr80_daytime", 	"spotlight", 			0.2 );
	build_light_override( "btr80", "vehicle_btr80", "spotlight_turret", "TAG_TURRET_LIGHT", "misc/spotlight_btr80_daytime", 	"spotlight_turret", 	0.0 );
	
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
	
	default_start( ::start_humvee );
	add_start( "humvee", 	::start_humvee );
	add_start( "yards", 	::start_yards );
	add_start( "bmp", 	::start_bmp );
	add_start( "pizza", ::start_pizza );
	add_start( "gas_station", ::start_gas_station );
	add_start( "crash", ::start_crash );
	add_start( "nates_roof", ::start_nates_roof );
	//add_start( "northside", ::start_roof_northside );
	add_start( "attack_diner", ::start_attack_diner );
	add_start( "defend_diner", ::start_diner_defend );
	add_start( "diner", ::start_diner );
	add_start( "burgertown", ::start_burgertown );
	add_start( "vip_escort", ::start_vip_escort );
	add_start( "defend_BT", ::start_defend_BT );
	add_start( "helis", ::start_helis );
	add_start( "convoy", ::start_convoy );
	//add_start( "surprized_parachute_moment", ::start_surprized_parachute_moment );
	//add_start( "police_car_cover_moment", ::start_police_car_cover_moment );
	//add_start( "BT_roof", ::start_BT_roof );
	//add_start( "bmp_paradrop", 	::start_bmp_paradrop );
	//add_start( "animated_humvee", 	::start_animated_humvee );
	add_start( "start_btr80_smash", 	::start_btr80_smash );
	
	maps\_attack_heli::preLoad();
	maps\_drone_ai::init();
	//maps\_juggernaut::main();
	maps\_load::main();
	maps\_carry_ai::initCarry();
	thread maps\invasion_amb::main();
	common_scripts\_sentry::main();
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	//array_thread( getentarray( "magic_glass_breaker", "targetname" ), ::magic_glass_breaker );
	maps\_stinger::init();
	
	maps\invasion_anim::main_anim();
	
	maps\_remotemissile::init();
	
	thread setup_stingers();
	
	thread setup_nates_kitchen_ladder_clip();
	thread setup_bt_ktichen_ladder_clip();
	
	level.bcs_maxTalkingDistFromPlayer = 1500;  // default = 1500
	level.bcs_maxThreatDistFromPlayer = 5000;  // default = 2500

	//level.player thread playerunlimitedammothread();
	
//	/#
//	while(1)
//	{
//		file = OpenFile( "test.txt", "write" );
//		fprintln(file, level.player.origin );
//		closefile( file );
//		wait .05;
//	}
//	#/
	
	
	
	if( level.start_point == "no_game" )
		return;
		
		
	flag_init( "notetrack_gimmesitrep" );
	flag_init( "notetrack_status" );
	flag_init( "notetrack_whatelse" );
	flag_init( "notetrack_sentrygunsouth" );
	flag_init( "notetrack_checkout" );
	flag_init( "notetrack_meatlocker" );
	flag_init( "notetrack_unconscious" );
	flag_init( "notetrack_supplydrop" );
	
	flag_init( "house_destroyer_moving_back" );
	flag_init( "btr_backed_away" );
	flag_init( "btr_smoke_starting" );
	flag_init( "btr_smoked" );
	flag_init( "follow_foley" );
	flag_init( "northside_roof" );
	flag_init( "smoke_screen_starting" );
	flag_init( "bmp_out_of_sight" );
	flag_init( "player_goto_roof" );
	flag_init( "wells_intro_done" );
	flag_init( "truck_guys_retreat" );
	flag_init( "diner_attack" );
	flag_init( "time_to_go_get_UAV_control" );
	flag_init( "time_to_clear_burgertown" );
	flag_init( "time_to_destroy_bmps" );
	flag_init( "taco_goes_to_roof" );
	flag_init( "player_defended_burgertown" );
	flag_init( "player_at_convoy" );
	flag_init( "bmp_north_left_dead" );
	flag_init( "bmp_north_mid_dead" );
	flag_init( "move_president_to_prep" );
	flag_init( "bmp1_spotted_player" );
	flag_init( "bmp2_spotted_player" );
	flag_init( "juggernaut_dead" );
	flag_init( "nates_bomb_incoming" );
	flag_init( "nates_bombed" );
	flag_init( "bank_guys_retreat" );
	flag_init( "back_door_attack_start" );
	
	flag_init( "bmps_from_north_dead" );
	thread bmps_from_north_dead();

	maps\_compass::setupMiniMap("compass_map_invasion");
	
	flag_init( "player_in_pos_to_cover_vip" );
	flag_init( "convoy_is_here" );
	flag_init( "threw_semtex" );
	flag_init( "threw_smoke" );
	
	flag_init( "first_attack_heli_spawned" );
	flag_init( "second_attack_heli_spawned" );
	
	flag_init( "first_attack_heli_dead" );
	flag_init( "second_attack_heli_dead" );
	flag_init( "time_to_goto_convoy" );
	
	flag_init("bmp_has_spotted_player" );
	
	//NOT SPAWNERS, start out spawned
	
	//SPAWNERS
	yards_roof_parachute_guy = getent( "roof_parachute_landing_guy_yards", "targetname" );
	humvee_roof_parachute_guy = getent( "humvee_ride_roof_landing", "targetname" );
	
	yards_roof_parachute_guy add_spawn_function( ::setup_roof_parachute_guy );
	humvee_roof_parachute_guy add_spawn_function( ::setup_roof_parachute_guy, "humvee_guy" );
	
	array_thread( getentarray( "commander", "script_noteworthy" ), ::add_spawn_function, ::setup_raptor );
	array_thread( getentarray( "taco", "script_noteworthy" ), ::add_spawn_function, ::setup_taco );
	array_thread( getentarray( "worm", "script_noteworthy" ), ::add_spawn_function, ::setup_worm );
	
	array_thread( getentarray( "alley_nates_attackers", "script_noteworthy" ), ::add_spawn_function, ::alley_nates_attackers_setup );
	array_thread( getentarray( "wells", "script_noteworthy" ), ::add_spawn_function, ::setup_wells );
	array_thread( getentarray( "BT_nates_attackers", "script_noteworthy" ), ::add_spawn_function, ::BT_nates_attackers_setup );

	wounded_carry_attackers = getentarray( "wounded_carry_attackers", "script_noteworthy" );
	array_thread( wounded_carry_attackers, ::add_spawn_function, ::setup_wounded_carry_attackers );
	
	BT_enemy_defenders = getentarray( "BT_enemy_defenders", "script_noteworthy" );
	array_thread( BT_enemy_defenders, ::add_spawn_function, ::setup_BT_enemy_defenders );

	nates_defenders = getentarray( "nates_defenders", "script_noteworthy" );
	array_thread( nates_defenders, ::add_spawn_function, ::nates_defenders_setup );
	array_thread( nates_defenders, ::add_spawn_function, ::set_threatbias_group, "nates_defenders" );
	
//	ramirez = getentarray( "ramirez", "script_noteworthy" );
//	array_thread( ramirez, ::add_spawn_function, ::setup_ramirez );
//	array_thread( ramirez, ::add_spawn_function, ::set_threatbias_group, "nates_defenders" );
//	
//	collins = getentarray( "collins", "script_noteworthy" );
//	array_thread( collins, ::add_spawn_function, ::setup_collins );
//	array_thread( collins, ::add_spawn_function, ::set_threatbias_group, "nates_defenders" );
	
	president = getentarray( "president", "script_noteworthy" );
	array_thread( president, ::add_spawn_function, ::setup_president );
	
	truck_group_enemies = getentarray( "truck_group_enemies", "script_noteworthy" );
	array_thread( truck_group_enemies, ::add_spawn_function, ::truck_group_enemies_setup );
	array_thread( truck_group_enemies, ::add_spawn_function, ::truck_group_enemies_setup_retreat );
	array_thread( truck_group_enemies, ::add_spawn_function, ::truck_group_enemies_count_deaths );
	
	bank_nates_attackers = getentarray( "bank_nates_attackers", "targetname" );
	array_thread ( bank_nates_attackers, ::add_spawn_function, ::bank_enemies_setup_retreat );
	
	spawners = getentarray( "diner_enemy_defenders_mobile", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::setup_diner_backdoor_attackers );
	
	gas_station_truck_guys = getentarray( "gas_station_truck_guys", "targetname" );
	array_thread( gas_station_truck_guys, ::add_spawn_function, ::set_threatbias_group, "gas_station_truck_enemies" );
	
	array_thread( getentarray( "tangled_parachute_guy", "script_noteworthy" ), ::add_spawn_function, maps\invasion_anim::tangled_parachute_guy );
	
	add_global_spawn_function( "axis", ::setup_count_predator_infantry_kills );
	add_global_spawn_function( "axis", ::setup_remote_missile_target_guy );
	
	flag_init( "player_has_predator_drones" );
	predator_drone_control = getent( "predator_drone_control", "targetname" );
	predator_drone_control hide();
	
	thread bt_locker_door_open();
	thread nates_locker_door_open();
	
	
	level.paradropper_left = getent("paradrop_guy_left", "script_noteworthy" );
	level.paradropper_right = getent("paradrop_guy_right", "script_noteworthy" );
	
	paradrop_plane_triggers = getentarray( "paradrop_plane_trigger", "targetname" );
	array_thread( paradrop_plane_triggers, ::paradrop_vehicle );
	
	thread paradrops_ambient();
	
	//array_thread( getvehiclenodearray( "start_drop", "script_noteworthy" ), ::plane_start_drop );
	//array_thread( getvehiclenodearray( "stop_drop", "script_noteworthy" ), ::plane_stop_drop );

	level.uav = spawn_vehicle_from_targetname_and_drive( "uav" );
	level.uav playLoopSound( "uav_engine_loop" );
	level.uavRig = spawn( "script_model", level.uav.origin );
	level.uavRig setmodel( "tag_origin" );
	thread UAVRigAiming();
	
	//keep before objectives
	flag_init ( "sentry_in_position" );
	level.obj_sentry = getent( "obj_sentry", "script_noteworthy" );
	level.obj_sentry thread sentry_init_owner();
	//level.obj_sentry.maxrange = 1500;//does nothing
	//level.obj_sentry thread waittill_sentry_moved();
	thread diner_window_traverses();
	
	//createThreatBiasGroup( "rpg_friendlies" );
	//createThreatBiasGroup( "attack_helis" );
	createThreatBiasGroup( "nates_defenders" );
	createThreatBiasGroup( "gas_station_truck_enemies" );
	createThreatBiasGroup( "players_group" );
	level.player setthreatbiasgroup( "players_group" );
	//SetIgnoreMeGroup( "nates_defenders", "gas_station_truck_enemies" );
	ignoreEachOther( "nates_defenders", "gas_station_truck_enemies" );
	
	//attack_helis = getentarray( "kill_heli", "targetname" );
	//array_thread( attack_helis, ::add_spawn_function, ::set_threatbias_group, "attack_helis" );
	
	
	friendly_redshirt_rpg = getentarray( "friendly_redshirt_rpg", "script_noteworthy" );
	array_thread( friendly_redshirt_rpg, ::add_spawn_function, ::setup_rpg_redshirts );
	//array_thread( attack_helis, ::add_spawn_function, ::set_threatbias_group, "rpg_friendlies" );
	
	// These hints are set in _remotemissile.gscs
//	add_hint_string( "hint_predator_drone_4", 			&"HELLFIRE_USE_DRONE", 			::should_break_use_drone );
//	add_hint_string( "hint_predator_drone_2", 			&"HELLFIRE_USE_DRONE_2", 		::should_break_use_drone );
	add_hint_string( "hint_predator_drone_vs_bmps_4", 	&"HELLFIRE_USE_DRONE", 			::should_break_use_drone_vs_bmps );
	add_hint_string( "hint_predator_drone_vs_bmps_2", 	&"HELLFIRE_USE_DRONE_2", 		::should_break_use_drone_vs_bmps );
	add_hint_string( "hint_steer_drone", 				&"SCRIPT_PLATFORM_STEER_DRONE", ::should_break_steer_drone );
	//add_hint_string( "hint_throw_semtex", 			&"INVASION_THROW_SEMTEX", 		::should_break_throw_semtex );
	//add_hint_string( "hint_get_semtex", 				&"INVASION_GET_SEMTEX", 		::should_break_get_semtex );
	add_hint_string( "hint_throw_smoke", 				&"INVASION_THROW_SMOKE", 		::should_break_throw_smoke );
	add_hint_string( "hint_get_smoke", 					&"INVASION_GET_SMOKE", 			::should_break_get_smoke );
	
	add_hint_string( "hint_smoke_too_far", &"INVASION_SMOKE_TOO_FAR", ::should_break_smoke_too_far );
	add_hint_string( "hint_ads_with_stinger", &"INVASION_ADS_WITH_STINGER", ::should_break_ads_with_stinger );
	add_hint_string( "hint_toggle_ads_with_stinger", &"INVASION_TOGGLE_ADS_WITH_STINGER", ::should_break_ads_with_stinger );
	/*
	flag_init( "got_stinger" );
	stingers = getEntArray( "stingers", "targetname" );
	foreach ( stinger in stingers )
	{
		stinger thread Ammorespawnthink( undefined, "stinger", "got_stinger" );
	}
	*/
	
	
	//start everything after the first frame so that level.start_point can be
	//initialized - this is a bad way of doing things...if people are initilizing
	//things before they want their start to start, then they should wait on a flag
	waittillframeend;
	
	
	setsaveddvar( "ai_busyEventDistDeath", "400" );
	setsaveddvar( "ai_busyEventDistGunShot", "800" );
	
	thread objective_main();
	thread spawn_nates_defenders();
}

sentry_init_owner()
{
	wait .5;
	owner = spawn( "script_origin", self.origin );
	owner.targetname = "fake_sentry_owner";
	
//	owner.debug_sentry			 = self;// for debug
	self.owner 					 = owner;
//	self SetSentryOwner( owner );	

	while( 1 )
	{
		self waittill( "trigger", ent );
	
		if( isplayer( ent ) )
			break;
	}
	
	self.owner = ent;
}


turret_spotlight()
{
	vehicle_lights_on( "spotlight spotlight_turret" );
}

//#using_animtree( "vehicles" );
//animate_btr80( humvee_opening_node )
//{
//	humvee_opening_node anim_single_solo( level.humvee_destroyer, "invasion_opening_BTR" );
//	level.humvee_destroyer anim_stopanimscripted();
//	//level.humvee_destroyer ClearAnim( %invasion_opening_BTR, 0);
//	level.humvee_destroyer thread humvee_destroyer_fires_at_pillars_and_player();
//}

start_humvee()
{
	
	thread handler_humvee_to_yards();
}

//start_paradrop()
//{
//	start = getent( "start_yards", "targetname" );
//	level.player setOrigin( start.origin );
//	level.player setPlayerAngles( start.angles );
//	
//	//thread test_paradrop();
//	paradrop_plane_triggers = getentarray( "paradrop_plane_trigger", "targetname" );
//	array_thread( paradrop_plane_triggers, ::paradrop_vehicle );
//}

start_bmp_paradrop()
{
	start = getstruct( "start_yards", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	level.bmp_paradrop = true;

/*
	yards_flight2 = getentarray( "yards_flight2", "targetname" );
	while( 1 )
	{
		array_thread( yards_flight2, ::paradrop_bmp );
		wait 5;
	}
*/
//	//thread test_paradrop();
//	paradrop_plane_triggers = getentarray( "paradrop_plane_trigger", "targetname" );
//	array_thread( paradrop_plane_triggers, ::paradrop_vehicle );
}

start_yards()
{
	start = getstruct( "start_yards", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_yards_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	
	//array_thread( getentarray( "ammo_crate_guy", "script_noteworthy" ), ::add_spawn_function, ::ammo_cache_guy_setup );
	thread handler_yards_to_house_destroyer();
}

start_bmp()
{
	start_bmp = getstruct( "start_bmp", "targetname" );
	level.player setOrigin( start_bmp.origin );
	level.player setPlayerAngles( start_bmp.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_bmp_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	
	//array_thread( getentarray( "ammo_crate_guy", "script_noteworthy" ), ::add_spawn_function, ::ammo_cache_guy_setup );
	thread handler_house_destroyer_to_pizza();
}

start_pizza()
{
	start_pizza = getstruct( "start_pizza", "targetname" );
	level.player setOrigin( start_pizza.origin );
	level.player setPlayerAngles( start_pizza.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_pizza_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	
	//activate_trigger_with_targetname( "ambient_battle_trigger" );
	flag_set( "spawn_nates_attackers_in_alley" );
	thread spawn_nates_attackers_in_alley();
	
	thread handler_pizza_to_gas_station();
}

start_gas_station()
{
	player_start = getstruct( "start_gas_station", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_gas_station_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
		
	//activate_trigger_with_targetname( "ambient_battle_trigger" );
	activate_trigger_with_targetname( "BT_attackers_trigger" );
	
	thread handler_gas_station_to_crash();
}

start_crash()
{
	player_start = getstruct( "start_crash", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_crash_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
		
	thread spawn_president();
		
	level.taco set_force_color( "g" );
	level.raptor set_force_color( "y" );
	//activate_trigger_with_targetname( "ambient_battle_trigger" );
	activate_trigger_with_targetname( "move_to_wells_intro" );
	
	flag_set( "leaving_gas_station" );//spawns_nates_defenders
		
		wait 1;
		
	thread handler_crash();
}

start_nates_roof()
{
	player_start = getstruct( "start_nates_roof", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	flag_set( "leaving_gas_station" );//spawns_nates_defenders
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	thread spawn_president();
	thread spawn_wells();
		
	thread handler_crash_to_roof();
}

start_roof_northside()
{
	player_start = getstruct( "start_nates_roof", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	
	flag_set( "leaving_gas_station" );//spawns_nates_defenders
	flag_set ( "sentry_in_position" );
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	thread spawn_president();
	thread spawn_wells();
	magic_smoke_grenades = getentarray( "magic_smoke_grenade", "targetname" );
	array_thread( magic_smoke_grenades, ::enemy_uses_smoke );
	thread wait_to_spawn_diner_defenders();
		
	thread handler_roof_north_side();
}


start_attack_diner()
{
	player_start = getstruct( "start_nates_roof", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	flag_set( "leaving_gas_station" );//spawns_nates_defenders
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	thread spawn_president();
	thread spawn_wells();
		
	flag_set( "sentry_in_position" );
	thread wait_to_spawn_diner_defenders();
	
	wait .1;
	
	thread handler_roof_to_diner();
}

start_btr80_smash()
{
	player_start = getstruct( "start_nates_roof", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	friendlies = getentarray( "secretservice_friendly", "targetname" );
	//array_thread( friendlies, ::spawn_ai );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	
	for ( i = 0 ; i < friendly_starts.size ; i++ )
	{
		friendlies[ i ].origin = friendly_starts[ i ].origin;
		friendlies[ i ].angles = friendly_starts[ i ].angles;
		friendlies[ i ] spawn_ai();
	}
	flag_set( "leaving_gas_station" );//spawns_nates_defenders
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	thread spawn_president();
	thread spawn_wells();
	level.obj_sentry kill();
	
	level.btr80_smash = true;
	flag_set( "sentry_in_position" );
	thread wait_to_spawn_diner_defenders();
	thread handler_roof_to_diner();
}

start_diner_defend()
{
	player_start = getstruct( "start_diner", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	taco_spawner = getent( "taco", "script_noteworthy" );
	friendly_start = getstruct( "start_diner_taco", "targetname" );
	taco_spawner.origin = friendly_start.origin;
	taco_spawner.angles = friendly_start.angles;
	taco_spawner spawn_ai();
	
	
	raptor_spawner = getent( "commander", "script_noteworthy" );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	raptor_spawner.origin = friendly_starts[ 0 ].origin;
	raptor_spawner.angles = friendly_starts[ 0 ].angles;
	raptor_spawner spawn_ai();
		
	thread spawn_president();
	thread spawn_wells();
	flag_set( "leaving_gas_station" );//spawns_nates_defenders
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	flag_set( "sentry_in_position" );
	thread give_player_predator_drone();
	level.obj_sentry kill();
	
	wait .1;
	
	thread two_bmps_from_north();
	
	thread handler_diner_defend();
}

start_diner()
{
	player_start = getstruct( "start_diner", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	taco_spawner = getent( "taco", "script_noteworthy" );
	friendly_start = getstruct( "start_diner_taco", "targetname" );
	taco_spawner.origin = friendly_start.origin;
	taco_spawner.angles = friendly_start.angles;
	taco_spawner spawn_ai();
	
	
	raptor_spawner = getent( "commander", "script_noteworthy" );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	raptor_spawner.origin = friendly_starts[ 0 ].origin;
	raptor_spawner.angles = friendly_starts[ 0 ].angles;
	raptor_spawner spawn_ai();
		
	thread spawn_president();
	thread spawn_wells();
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	flag_set( "sentry_in_position" );
	thread give_player_predator_drone();
	//thread two_bmps_from_north();
	//thread dialog_time_to_destroy_BMPS();
	
	thread diner_back_door_open();
	level.obj_sentry kill();
	
	flag_set( "nates_bomb_incoming" );//prevents nates defenders from spawning
	
	activate_trigger_with_targetname( "burger_town_enemy_defenders_trigger" );
	thread taco_goes_to_BT();
	
	thread handler_diner_to_burgertown();
}

start_burgertown()
{
	player_start = getstruct( "start_BT", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	  
	taco_spawner = getent( "taco", "script_noteworthy" );
	friendly_start = getstruct( "start_BT_taco", "targetname" );
	taco_spawner.origin = friendly_start.origin;
	taco_spawner.angles = friendly_start.angles;
	taco_spawner spawn_ai();  
		  
	raptor_spawner = getent( "commander", "script_noteworthy" );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	raptor_spawner.origin = friendly_starts[ 0 ].origin;
	raptor_spawner.angles = friendly_starts[ 0 ].angles;
	raptor_spawner spawn_ai();  
	  
	thread spawn_president();  
	thread spawn_wells();  
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	flag_set( "sentry_in_position" );
	thread give_player_predator_drone();
	//thread two_bmps_from_north();
	
	flag_set( "nates_bomb_incoming" );//prevents nates defenders from spawning
	
	thread diner_back_door_open();
	level.obj_sentry kill();
	  
	remove_tvs();
	exploder( 333 );

	thread handler_burgertown();  
}

start_vip_escort()
{
	player_start = getstruct( "start_vip_escort", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	  
	taco_spawner = getent( "taco", "script_noteworthy" );
	friendly_start = getstruct( "start_BT_taco", "targetname" );
	taco_spawner.origin = friendly_start.origin;
	taco_spawner.angles = friendly_start.angles;
	taco_spawner spawn_ai();  
		  
	raptor_spawner = getent( "commander", "script_noteworthy" );
	friendly_starts = getstructarray( "start_roof_friendly", "targetname" );
	raptor_spawner.origin = friendly_starts[ 0 ].origin;
	raptor_spawner.angles = friendly_starts[ 0 ].angles;
	raptor_spawner spawn_ai();  
	  
	thread spawn_president();  
	thread spawn_wells();  
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	flag_set( "sentry_in_position" );
	thread give_player_predator_drone();
	//thread two_bmps_from_north();
	 
	remove_tvs();
	exploder( 333 );
		
	thread taco_goes_to_BT_roof();
	flag_set( "taco_goes_to_roof" );
	
	wells_in_bushes = getnode( "wells_in_bushes", "targetname" );
	level.wells setgoalnode( wells_in_bushes );
	
	flag_set( "nates_bomb_incoming" );//prevents nates defenders from spawning
	
	thread diner_back_door_open();
	level.obj_sentry kill();
	  
	thread handler_vip_escort();  
}


start_defend_BT()
{
	player_start = getstruct( "start_BT", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	  
	taco_spawner = getent( "taco", "script_noteworthy" );
	friendly_start = getstruct( "start_BT_taco", "targetname" );
	taco_spawner.origin = friendly_start.origin;
	taco_spawner.angles = friendly_start.angles;
	taco_spawner spawn_ai();  
	
	  
	raptor_spawner = getent( "commander", "script_noteworthy" );
	raptor_start = getent( "president_in_burgertown_meat_locker", "targetname" );
	raptor_spawner.origin = raptor_start.origin;
	raptor_spawner.angles = raptor_start.angles;
	raptor_spawner spawn_ai();  
	
	  
	//thread spawn_president();  
	//thread spawn_wells();  
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	flag_set( "sentry_in_position" );
	thread give_player_predator_drone();
	//thread two_bmps_from_north();
	
	remove_tvs();
	exploder( 333 );  
		
	thread taco_goes_to_BT_roof();
	flag_set( "taco_goes_to_roof" );
	
	flag_set( "nates_bomb_incoming" );//prevents nates defenders from spawning
	
	thread diner_back_door_open();
	level.obj_sentry kill();
	flag_set( "president_in_BT_meat_locker" );
	  
	thread handler_defend_BT();
}

start_helis()
{
	player_start = getstruct( "start_nates_roof", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	  
	taco_spawner = getent( "taco", "script_noteworthy" );
	friendly_start = getstruct( "start_BT_taco", "targetname" );
	taco_spawner.origin = friendly_start.origin;
	taco_spawner.angles = friendly_start.angles;
	taco_spawner spawn_ai();  
	
	  
	raptor_spawner = getent( "commander", "script_noteworthy" );
	raptor_start = getent( "president_in_burgertown_meat_locker", "targetname" );
	raptor_spawner.origin = raptor_start.origin;
	raptor_spawner.angles = raptor_start.angles;
	raptor_spawner spawn_ai();  
	
	  
	//thread spawn_president();  
	//thread spawn_wells();  
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	flag_set( "sentry_in_position" );
	thread give_player_predator_drone();

	  
	remove_tvs();
	exploder( 333 ); 
		
	thread taco_goes_to_BT_roof();
	flag_set( "taco_goes_to_roof" );
	
	flag_set( "nates_bomb_incoming" );//prevents nates defenders from spawning
	
	thread diner_back_door_open();
	level.obj_sentry kill();
	flag_set( "president_in_BT_meat_locker" );
	 
	level.num_of_enemy_forces_spawned = 3;
	flag_set( "first_attack_heli_spawned" );
	 
	thread handler_defend_BT();
}

start_convoy()
{
	player_start = getstruct( "start_nates_roof", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	flag_set( "crash_objective" );//turn off bullet shield on defenders
	flag_set( "sentry_in_position" );
	
	remove_tvs();
	exploder( 333 );  
	//thread taco_goes_to_BT_roof();
	flag_set( "taco_goes_to_roof" );
	
	flag_set( "nates_bomb_incoming" );//prevents nates defenders from spawning
	
	thread diner_back_door_open();
	level.obj_sentry kill();
	flag_set( "president_in_BT_meat_locker" );
	
	thread handler_convoy();
}

//start_BT_roof()
//{
//	thread spawn_president();
//	wells_start = getent( "wells_in_nates_prep", "targetname" );
//	thread spawn_wells( wells_start );
//	
//	player_start = getent( "start_BT_roof", "targetname" );
//	level.player setOrigin( player_start.origin );
//	level.player setPlayerAngles( player_start.angles );
//	
//	
//	taco_spawner = getent( "taco", "script_noteworthy" );
//	friendly_start = getent( "start_BT_roof_taco", "targetname" );
//	taco_spawner.origin = friendly_start.origin;
//	taco_spawner.angles = friendly_start.angles;
//	taco_spawner spawn_ai();
//	
//	raptor_spawner = getent( "commander", "script_noteworthy" );
//	raptor_start = getentarray( "raptor_in_nates_prep", "targetname" );
//	raptor_spawner.origin = raptor_start.origin;
//	raptor_spawner.angles = raptor_start.angles;
//	raptor_spawner spawn_ai();
//	
//	flag_set( "move_president_to_prep" );
//	
//
//	flag_set( "crash_objective" );//turn off bullet shield on defenders
//	flag_set( "sentry_in_position" );
//	thread give_player_predator_drone();
//	
//	exploder( 333 );
//	
//	thread handler_vip_escort();
//}


/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////


black_screen_intro()
{
	setSavedDvar( "hud_drawhud", "0" );
	level.player freezeControls( true );

	//thread maps\_introscreen::introscreen_generic_black_fade_in( 3.5, 1 );
	thread maps\_introscreen::introscreen_generic_black_fade_in( 5.3, 1 );

	lines = [];
	// wolverines
	lines[ lines.size ] = &"INVASION_LINE1";	//
	// Day 2 - 13:45:[{FAKE_INTRO_SECONDS:4}]
	lines[ "date" ] = &"INVASION_LINE2";
	//pvt ramerez
	lines[ lines.size ] = &"INVASION_LINE3";
	//virginia
	lines[ lines.size ] = &"INVASION_LINE4";
	lines[ lines.size ] = &"INVASION_LINE5";

	maps\_introscreen::introscreen_feed_lines( lines );

	wait 5;
	level.player setplayerangles( ( 0, 180, 0 ) );

	level.player freezeControls( false );

	wait 1.8;// wait for date stamp
	


	level notify( "introscreen_complete" );// Do final notify when player controls have been restored

	wait( 2 );

	autosave_by_name( "levelstart" );
}

//test_escort()
//{
//	while( 1 )
//	{
//		wait 3;
//		paradrop_escort = spawn_vehicle_from_targetname_and_drive( "paradrop_escort" );
//	}
//}

handler_humvee_to_yards()
{
	level.vtmodel = "vehicle_hummer_viewmodel";
	level.vttype = "humvee";
	build_radiusdamage( ( 0, 0, 53 ), 512, 90, 20, false );
	
	//setculldist( 8000 );
	//thread test_escort();
	thread black_screen_intro();
	battlechatter_off( "allies" );
	
	thread dialog_intro();
	
	thread MusicPlayWrapper( "invasion_intro" );
	
	wait 2.5;
	
	first_planes = getent( "first_flight", "script_noteworthy" );
	first_planes notify( "trigger" );
	first_planes trigger_off();
	
	wait 1.5;
	
	level.player disableweapons();
	level.humvee_front = spawn_vehicle_from_targetname_and_drive( "humvee_front" );
	level.humvee_front.dontunloadonend = true;
	
	shotgun_guy = getent( "shotgun", "script_noteworthy" );
	shotgun_guy add_spawn_function( ::setup_shotgun_guy );
	backseat_right_guy = getent( "backseat_right", "script_noteworthy" );
	backseat_right_guy add_spawn_function( ::setup_backseat_right_guy );
		
	humvee_blows_up_riders = getentarray( "humvee_blows_up_riders", "targetname" );
	array_thread( humvee_blows_up_riders, ::spawn_ai );
	
	level.humvee_player = spawn_vehicle_from_targetname_and_drive( "humvee_player" );
	level.humvee_player playsound( "scn_invasion_humvee_ridein" );
	level.humvee_player.dontunloadonend = true;
	
	
	org = level.humvee_player player_rides_shotgun_in_humvee();

	flag_wait( "humvee_ride_roof_landing" );

	thread roof_parachute_landing_guy_humvee();

	flag_wait( "start_humvee_destroyer" );
	
	level.raptor pushplayer( true );
	level.taco pushplayer( true );
	level.worm pushplayer( true );
	level.worm thread magic_bullet_shield();
	
	level.humvee_destroyer = spawn_vehicle_from_targetname_and_drive( "humvee_destroyer" );
	//level.humvee_destroyer.veh_pathtype = "follow";
	level.humvee_destroyer.veh_pathtype = "constrained";
	level.humvee_destroyer thread humvee_destroyer_action();

	wait 2;
	//Seal Six-One:	We got a BMP! Get out, get out!	
	level.raptor thread dialogue_queue( "inv_six_gotbmp" );
	//wait 1;
	
	level.humvee_player Vehicle_SetSpeed( 0, 10 );
	
	//level.humvee_player waittill( "reached_end_node" );
	wait 1;

	level.humvee_player thread vehicle_unload();
	activate_trigger_with_targetname( "flee_humvee" );
	wait 1;
	
	level.raptor pushplayer( true );
	level.taco pushplayer( true );
	level.worm pushplayer( true );
	
	org player_leaves_humvee();
	
	thread dialog_go_to_yards();
	
	wait 1;
	setSavedDvar( "hud_drawhud", "1" );
	
	level.raptor pushplayer( true );
	level.taco pushplayer( true );
	level.worm pushplayer( true );
	
	//level.humvee_player notify( "death" );
	
	thread handler_yards_to_house_destroyer();
}



handler_yards_to_house_destroyer()
{
	battlechatter_off( "allies" );
	//parachute_landing = getent( "parachute_landing", "targetname" );
	spawner = getent( "roof_parachute_landing_guy_yards", "targetname" );
	
	flag_wait( "entering_yards" );
	
	autosave_by_name( "yards" );
	
	if( isalive( level.worm ) )
	{
		if( isdefined( level.worm.magic_bullet_shield ) )
			level.worm thread stop_magic_bullet_shield();
	}
	level.raptor pushplayer( false );
	level.taco pushplayer( false );
	if( isalive( level.worm ) )
		level.worm pushplayer( false );
	
	thread enable_water_fx();
	
	//thread friendlies_start_ignoreall();
	//friendly_at_fence_corner = getent( "friendly_at_fence_corner", "targetname" );
	//friendly_at_fence_corner thread activate_this_friendly();
	
	level.roof_paratrooper = spawner spawn_ai();
	level.roof_paratrooper.ignoreme = true;
	
	//Russian paratrooper coming down at our 12 o'clock.	
	//level.raptor dialogue_queue( level.raptor, "inv_six_rusptroop" );
	//radio_dialogue( "inv_six_rusptroop" );
	
	//friendly = get_closest_ai( level.roof_paratrooper.origin, "allies" );
	//friendly.ignoreall = false;
	
	//Taco:	Roger that.	
	//level.taco dialogue_queue( level.taco, "inv_tco_rogerthat" );
	//radio_dialogue( "inv_tco_rogerthat" );
	
	thread dialog_yards_story();
	
	//wait 3;
	//thread dialog_yards_objective();
	
	thread handler_house_destroyer_to_pizza();
}


handler_house_destroyer_to_pizza()
{
	//flag_init( "start_house_destroyer" );
	flag_wait( "start_house_destroyer" );
	
	autosave_by_name( "hd" );
	
	thread spawn_nates_attackers_in_alley();
	
	flag_init( "house_destroyer_unloading" );
	level.house_destroyer = spawn_vehicle_from_targetname( "house_destroyer" );
	level.house_destroyer thread setup_house_destroyer();
	//thread friendlies_duck_from_house_destroyer();
	thread dialog_bmp_hasnt_spotted_us();
	//level.house_destroyer thread dialog_house_destroyer_destroyed();
	
	//thread save_when_btr_and_riders_are_dead();
	
	flag_wait( "got_visual_on_crash" );
	
	//Seal Six-One:	I got a visual on smoke coming from the crash site.	
	level.raptor dialogue_queue( "inv_six_viscrashsite" );
	
	battlechatter_on( "allies" );
	
	
	thread dialog_house_destroyer_unloading();
	thread flag_save( "house_destroyer_unloading" );
	//thread friendlies_stop_ignoring_when_flag( "house_destroyer_unloading" );
	
	thread wait_till_btr_smoked();
	thread watch_for_smoke_throws();
	thread dialog_semtex_that_bmp();
	//thread dialog_take_point();
	thread btr_backed_off();
	
	thread handler_pizza_to_gas_station();
}


handler_pizza_to_gas_station()
{
	thread spawn_tangled_chute_struggler();
	
	flag_wait( "gas_station_truck_spawned" );
	thread maps\_utility::set_ambient( "invasion_ext3" );
	thread setup_gas_station_truck();
	//thread friendlies_peal_back();
	thread flag_save( "leaving_gas_station" );
	
	//thread dialog_juggernaut_attack();
	
	
	thread handler_gas_station_to_crash();
}

handler_gas_station_to_crash()
{
	flag_wait( "leaving_gas_station" );

	burning_tree = getent( "burning_tree", "script_noteworthy" );
	burning_tree notify( "stop_burning_tree" );
	
	level.obj_direction = "north";//not enough time for drop to the east
	thread dialog_going_to_crash_site();
	thread one_bmp_from_south();
	thread dialog_dont_engage_that_APC();
	thread dialog_waiting_at_crash_site();
	thread player_shooting_nates();
	thread spawn_president();
	
	if( !isdefined( level.wells ) )
	{
		wells_spawner = getent( "wells", "script_noteworthy" );
		wells_spawner spawn_ai();
	}
	
	activate_trigger_with_targetname( "advance_towards_nates" );
	
	flag_wait( "goto_wells_intro" );
	thread mig_fly_overs();
	
	thread handler_crash();
}

handler_crash()
{
	if( !isdefined( level.wells ) )
	{
		wells_spawner = getent( "wells", "script_noteworthy" );
		wells_spawner spawn_ai();
	}
	
	thread police_car_cover_moment();
	level.taco set_force_color( "g" );
	//level.raptor set_force_color( "b" );
	activate_trigger_with_targetname( "move_to_wells_intro" );//moves worm and taco
	
	bank_nates_attackers = getentarray( "bank_nates_attackers", "targetname" );
	foreach( spawner in bank_nates_attackers )
		guy = spawner spawn_ai();	
	
	flag_wait( "crash_objective" );
	autosave_by_name( "crash_site" );
	level.obj_direction = "north";
	thread cleanse_the_world();
	
	thread handler_crash_to_roof();
}



police_car_cover_moment()
{
	anim_node = getstruct("police_car_moment","script_noteworthy" );
	
	BadPlace_Cylinder( "police_car_moment", -1, anim_node.origin, 600, 300, "axis" );
	
	anim_node thread anim_generic_loop( level.wells, "invasion_vehicle_cover_dialogue_guy1_idle", "stop_invasion_vehicle_cover_dialogue_guy1_idle" );
	
	level.raptor disable_ai_color();
	anim_node anim_generic_reach( level.raptor, "invasion_vehicle_cover_dialogue_guy2" );
		
	flag_wait( "crash_objective" );
	
	thread dialog_wells_intro();
	
	anim_node notify( "stop_invasion_vehicle_cover_dialogue_guy1_idle" );
	
	anim_node thread anim_generic( level.wells, "invasion_vehicle_cover_dialogue_guy1" );
	anim_node anim_generic( level.raptor, "invasion_vehicle_cover_dialogue_guy2" );
	
	thread move_raptor_wells_and_worm();
	
	BadPlace_Delete( "police_car_moment" );

	//level.raptor enable_ai_color();
	//level.wells enable_ai_color();
}


dialog_wells_intro()
{
	if( flag( "player_on_roof" ) )
		return;
	level endon ( "player_on_roof" );
	
	thread battlechatter_off( "allies" );
	
	flag_wait( "notetrack_gimmesitrep" );
	//Seal Six-One:	Marine! Gimme a sitrep! Where's the President?	
	level.raptor playsound( "inv_six_gimmesitrep" );
	
	flag_wait( "notetrack_meatlocker" );
	
	//Sgt Wells:	We moved him to the meat locker, it's practically bulletproof!	
	level.wells playsound( "inv_sgw_meatlocker" );
	
	flag_wait( "notetrack_status" );
	
	//Seal Six-One:	What's his status?	
	level.raptor playsound( "inv_six_status" );
	
	flag_wait( "notetrack_unconscious" );
	
	//Sgt Wells:	He's still unconscious, you got a corpsman?	
	level.wells playsound( "inv_sgw_unconscious" );
	
	flag_wait( "notetrack_whatelse" );
	
	//Seal Six-One:	(aside) Taco, check it out! (back to Marine) What else?	
	level.raptor playsound( "inv_six_whatelse" );
	
	flag_wait( "notetrack_checkout" );
	
	thread taco_to_meat_locker();
	
	flag_wait( "notetrack_supplydrop" );
	
	//Sgt Wells:	We got a supply drop on the roof with an M-5 sentry gun!	
	level.wells playsound( "inv_sgw_supplydrop" );
	
	flag_wait( "notetrack_sentrygunsouth" );
	
	
	//Seal Six-One:	Roach - get to the roof and get that sentry gun pointed south!	
	level.raptor playsound( "inv_six_sentrygunsouth" );
	
	wait 3;
	
	flag_set( "player_goto_roof" );
	thread battlechatter_on( "allies" );
	
/*	
	//Seal Six-One:	Marine! Gimme a sitrep! Where's the President?	
	level.raptor dialogue_queue( "inv_six_gimmesitrep" );
	
	wait .5;
	
	//Sgt Wells:	We moved him to the meat locker, it's practically bulletproof!	
	level.wells dialogue_queue( "inv_sgw_meatlocker" );
	
	//Seal Six-One:	What's his status?	
	level.raptor dialogue_queue( "inv_six_status" );
	
	wait .5;
	
	//Sgt Wells:	He's still unconscious, you got a corpsman?	
	level.wells dialogue_queue( "inv_sgw_unconscious" );
	
	//Seal Six-One:	(aside) Taco, check it out! (back to Marine) What else?	
	level.raptor dialogue_queue( "inv_six_whatelse" );

	thread taco_to_meat_locker();
	
	wait 1;
	
	//Sgt Wells:	We got a supply drop on the roof with an M-5 sentry gun!	
	level.wells dialogue_queue( "inv_sgw_supplydrop" );
	
	flag_set( "player_goto_roof" );
	
	//Seal Six-One:	Roach - get to the roof and get that sentry gun pointed south!	
	level.raptor dialogue_queue( "inv_six_sentrygunsouth" );
*/

	wait 12;
	
	//Seal Six-One:	What about anti-tank weapons, air support?	
	level.raptor dialogue_queue( "inv_six_antitank" );
	
	//Sgt Wells:	We're all out! It's just Ramirez, Collins and myself sir!	
	level.wells dialogue_queue( "inv_sgw_allout" );
	
	wait 1;
	
	//Seal Six-One:	Roger that!	
	level.raptor dialogue_queue( "inv_six_rogerthat" );
	

	flag_set( "wells_intro_done" );
}



handler_crash_to_roof()
{
	thread kill_friendlies_on_roof();
	thread dialog_sentry_nags();
	thread dialog_enemies_on_roof();
	
	flag_wait( "player_on_roof" );
	
	thread battlechatter_on( "allies" );
	
	level.obj_direction = "south";
	
	nates_roof_volume_south = getent( "nates_roof_volume_south", "targetname" );
	friendlies = getaiarray( "allies" );
	for( i = 0 ; i < friendlies.size ; i++ )
	{
		if( i == 5 )
			break;
		friendlies[i].goalheight = 80;
		friendlies[i].goalradius = 500;
		friendlies[i].fixednode = false;
		friendlies[i] setgoalpos( nates_roof_volume_south.origin );
		friendlies[i] setgoalvolume( nates_roof_volume_south );
	}
	level.raptor.goalheight = 80;
	level.raptor.goalradius = 500;
	level.raptor.fixednode = false;
	level.raptor setgoalpos( nates_roof_volume_south.origin );
	level.raptor setgoalvolume( nates_roof_volume_south );
	
	level.taco.goalheight = 80;
	level.taco.goalradius = 500;
	level.taco.fixednode = false;
	level.taco setgoalpos( nates_roof_volume_south.origin );
	level.taco setgoalvolume( nates_roof_volume_south );
	
	//flag_wait( "sentry_in_position" );
	autosave_by_name( "sentry_in_position" );
	
	flag_set( "bank_guys_retreat" );
	
	wait 3;
	
	enemies = getaiarray( "axis" );
	foreach( guy in enemies )
		guy thread rush_restaurant_enemies_setup();
	
	level.truck_group_enemies_count_lives = 0;
	level.truck_group_enemies_alive = 0;
	level.truck_group_enemies_count_deaths = 0;
	truck1 = thread spawn_vehicle_from_targetname_and_drive( "truck_group_left" );
	truck1.veh_pathtype = "constrained";
	wait .1;//easier on spawn code
	//thread spawn_vehicle_from_targetname_and_drive( "truck_group_mid" );
	truck2 = thread spawn_vehicle_from_targetname_and_drive( "truck_group_right" );
	truck2.veh_pathtype = "constrained";
	
	magic_smoke_grenades = getentarray( "magic_smoke_grenade", "targetname" );
	array_thread( magic_smoke_grenades, ::enemy_uses_smoke );
	thread dialog_they_are_using_smoke();
	
	//Seal Six-One:	Heads up ladies, we got trucks to the south.	
	radio_dialogue( "inv_six_headsupladies" );
	thread dialog_foot_mobiles();
	
	wait 1;//let them spawn
	while( level.truck_group_enemies_alive > 5 )
		wait 1;
	//while( level.truck_group_enemies_count_deaths < 14 )
	//	wait 1;
	//e = getaiarray( "allies" );
	//f = getaiarray( "axis" );
	//println( "enemies " + e.size );
	//println( "friendlies " + f.size );
	autosave_by_name( "trucks_to_north" );
	thread handler_roof_north_side();
}


	
handler_roof_north_side()
{
	level.obj_direction = "north";
	magic_smoke_grenades = getentarray( "magic_smoke_grenade_north", "targetname" );
	array_thread( magic_smoke_grenades, ::enemy_uses_smoke );
	
	level.truck_group_enemies_count_lives = 0;
	//level.truck_group_enemies_alive = 0;
	level.truck_group_enemies_count_deaths = 0;//reset counter
	
	truck3 = thread spawn_vehicle_from_targetname_and_drive( "truck_north_right" );
	truck3.veh_pathtype = "constrained";
	wait .1;
	truck4 = thread spawn_vehicle_from_targetname_and_drive( "truck_north_left" );//actually second
	truck4.veh_pathtype = "constrained";
	
	thread dialog_smoke_to_north();
	//while( 1 )
	//{
	//	level waittill ( "truck_guy_died" );
	//	ratio = level.truck_group_enemies_count_deaths / level.truck_group_enemies_count_lives;
	//	println( " ratio:    " + ratio );
	//	if( ratio > .7 )
	//		break;
	//}
	
	//Taco:	Incoming, north side!	
	radio_dialogue( "inv_tco_incomingnorth" );
	
	//Seal Six-One:	Roger that!	
	radio_dialogue( "inv_six_rogerthat" );
	
	thread friendlies_shift_north();
	flag_set( "northside_roof" );
	
	wait 6;

	
	//Taco:	Contact to the north!	
	radio_dialogue( "inv_tco_contactnorth" );
	
	//Team, we got contacts to the north.	
	radio_dialogue( "inv_six_contactsn" );
	
	//Team, shift your fire north.	
	radio_dialogue( "inv_six_shiftfiren" );
	
	thread wait_to_spawn_diner_defenders();
	
	//while( level.truck_group_enemies_count_deaths < 13 )
	while( level.truck_group_enemies_alive > 5 )
		wait 1;
	
	level.obj_direction = "west";
	
	flag_set( "truck_guys_retreat" );
	
	wait 6;
	autosave_by_name( "truck_retreat" );
	
	south_side_nodes = getnodearray( "south_side_nodes", "targetname" );
	n = 0;
	nates_roof_volume_south = getent( "nates_roof_volume_south", "targetname" );
	friendlies = getaiarray( "allies" );
	for( i = 0 ; i < friendlies.size ; i++ )
	{
		if( cointoss() )
		{
			if( n >= south_side_nodes.size )
				break;
			//friend.goalheight = 80;
			//friend.goalradius = 500;
			friendlies[i].fixednode = false;
			friendlies[i] setgoalnode( south_side_nodes[n] );
			friendlies[i] setgoalvolume( nates_roof_volume_south );
			n++;
		}
	}
	
	//Seal Six-One:	Looks like Ivan's had enough.	
	radio_dialogue( "inv_six_hadenough" );
	
	//Corporal Dunn, give me a sitrep on Raptor, over.	
	radio_dialogue( "inv_six_sitreponraptor" );	
	
	//Raptor is secure and stable.	
	radio_dialogue( "inv_tco_secureandstable" );	
	
	//Seal Six-One:	Team, check weapons and ammo. They'll be back.	
	radio_dialogue( "inv_six_checkammo" );
	
	
	dialog_two_bmps_from_north();
	
	thread handler_roof_to_diner();
}

handler_roof_to_diner()
{
	level.obj_direction = "west";
	if ( isdefined( level.btr80_smash ) )
		thread btr80_smash();
	
	thread set_up_predator_drone_control_pickup();
	thread hellfire_attacks();
	
	friendlies = getaiarray( "allies" );
	foreach( friend in friendlies )
		friend cleargoalvolume();
		
	thread friendlies_try_to_get_off_roof();
	
	taco_scopes_diner = getnode( "taco_scopes_diner", "targetname" );
	if( isdefined( taco_scopes_diner ) )
		level.taco SetGoalNode( taco_scopes_diner );
	
	thread dialog_hellfire_attack_reaction();
	
	flag_waitopen( "player_on_roof" );
	
	flag_set( "diner_attack" );//activates player half way to diner trigger for autosave
	
	bmps = two_bmps_from_north();
	
	//thread save_halfway_to_diner( bmps );
	
	thread dialog_taco_sees_uav_op();
	
	thread taco_goes_to_diner();
	
	//flag_clear( "player_inside_nates" );
	level add_wait( ::flag_wait, "player_inside_nates" );
	level add_func( ::autosave_by_name, "go_to_diner" );
	level thread do_wait();
	
	thread dialog_pickup_drone_control_nag();
	thread diner_backdoor_attack();
	
	thread handler_diner_defend();
}


handler_diner_defend()
{
	flag_wait( "player_has_predator_drones" );
	level.obj_direction = "east";
	thread get_friendlies_away_from_nates_destruction();
	autosave_by_name( "has_drones" );
	
	activate_trigger_with_targetname( "burger_town_enemy_defenders_trigger" );//spawn enemies in the BT
	thread taco_goes_to_BT();
	
	thread dialog_time_to_destroy_BMPS();
	
	thread spawn_battle_when_in_uav();

	flag_wait( "bmp_north_left_dead" );
	flag_wait( "bmp_north_mid_dead" );
	
	autosave_by_name( "bmps_destroyed" );
	
	thread dialog_regroup_at_nates_nag();
	
	thread handler_diner_to_burgertown();
}


handler_diner_to_burgertown()
{

	flag_wait( "leaving_diner" );
	//autosave_by_name( "leaving_diner" );
	flag_set( "nates_bomb_incoming" );
	bomb_nates();
	
	level.obj_direction = "south";
	
	BT_goal = getnode( "taco_in_BT", "script_noteworthy" );
	BT_org = BT_goal.origin;
	BT_goal_volume = getent( "BT_goal_volume", "targetname" );
	
	redshirts_desired = 3;
	level.redshirts = redshirts_respawn( redshirts_desired );
	foreach( redshirt in level.redshirts )
		redshirt thread smart_barney( "player_in_burgertown", BT_org, BT_goal_volume );
	
	
	flag_set( "move_president_to_prep" );
	
	thread dialog_nates_bombing_reaction();
	
	thread dialog_clear_burgertown_nag();
	
	level add_wait( ::flag_wait, "player_in_burgertown" );
	level add_func( ::autosave_by_name, "player_in_burgertown" );
	level thread do_wait();
	
	
	flag_wait( "burger_town_lower_cleared" );
	
	autosave_by_name( "burgertown_cleared" );
	thread handler_burgertown();
}


handler_burgertown()
{
	flag_set( "move_president_to_prep" );
	//thread dialog_time_to_destroy_BMPS();

	//flag_wait( "bmp_north_left_dead" );
	//flag_wait( "bmp_north_mid_dead" );
	
	
	//flag_wait( "player_on_burgertown_roof" );
	
	level.obj_direction = undefined;
	
	wait 3;
	
	//thread dialog_come_cover_us_nag();
	
	//Seal Six-One:	Alright, stay on the roof and cover us! We got the President and we're movin' out now.	
	//thread radio_dialogue( "inv_six_gotpresident" );
	
	thread taco_goes_to_BT_roof();
	flag_set( "taco_goes_to_roof" );
	flag_set( "time_to_clear_burgertown" );
	
	wells_in_bushes = getnode( "wells_in_bushes", "targetname" );
	level.wells setgoalnode( wells_in_bushes );
	
	nates_regroup_enemies = getentarray( "nates_regroup_enemies", "targetname" );
	array_thread( nates_regroup_enemies, ::spawn_ai );
	
	thread handler_vip_escort();
}


handler_vip_escort()	
{
	flag_set( "move_president_to_prep" );
	
	end_volume = getent("BT_goal_volume", "targetname" );
	end_goal = getent( "president_in_burgertown_meat_locker", "targetname" ).origin;
	
	redshirts_desired = 3;
	level.redshirts = redshirts_respawn( redshirts_desired );
	foreach( redshirt in level.redshirts )
		redshirt thread smart_barney_on_raptor( end_goal, end_volume );
	
	//level.player waittill_entity_in_range( level.wells, 400 );
	//waittill_player_lookat_for_time( timer, dot, dot_only )
	//level.wells waittill_player_lookat_for_time( 0.1, .99 );
	
	//flag_set( "player_in_pos_to_cover_vip" );
	autosave_by_name( "defend_prez" );
	
	//level.wounded_carry_attackers_dead = 0;
	//wounded_carry_attackers_TC = getentarray( "wounded_carry_attackers_TC", "targetname" );
	//array_thread( wounded_carry_attackers_TC, ::spawn_ai );
	
	wait 1;
	
	//Everyone lock and load! We're going to move from here to the Burger Town as a group, hua?	
	radio_dialogue( "inv_six_lockandload" );
	
	wait 5;
	
	flag_waitopen_or_timeout( "player_in_burgertown", 6 );
	
	
	thread wells_cover_path();
	
	//thread raptor_can_die();
	bt_locker = getent( "president_in_burgertown_meat_locker", "targetname" );
	//level.raptor thread maps\_carry_ai::move_president_to_node( level.president, bt_locker );
	level.president invisibleNotSolid();
	level.raptor pushplayer( true );
	level.raptor.dontchangepushplayer = true;
	wounded_carry_path = getent( "wounded_carry_path", "targetname" );
	//level.raptor thread maps\_carry_ai::move_president_to_node_nopickup( level.president, wounded_carry_path );
	level.raptor thread maps\_carry_ai::move_president_to_node( level.president, wounded_carry_path );
	
	//On three!	
	radio_dialogue( "inv_six_onthree" );
	
	wait 1;
	
	//One!	
	radio_dialogue( "inv_six_one" );
	
	wait 1;
	
	//Two!	
	radio_dialogue( "inv_six_two" );
	
	wait 1;
	
	//Three!!	
	radio_dialogue( "inv_six_three" );
	
	wait 1;
	
	//Go go go! 	
	radio_dialogue( "inv_six_gogogo2" );
	
	
	level.wells thread stop_magic_bullet_shield();
	level.raptor thread keep_enemies_away();
	thread dialog_keep_guys_off_me();
	thread wounded_carry_attackers();
	
	
	flag_wait( "president_in_BT_meat_locker" );
	
	//level.raptor.dontchangepushplayer = undefined;
	//level.raptor pushplayer( false );
	
	thread dialog_team_were_inside();
	
	//thread end_of_script();
	
	thread handler_defend_BT();
}



handler_defend_BT()
{
	thread stinger_hint();
	thread bt_locker_door_close();
	setup_hunter_enemies();
	thread enemy_monitor();
	thread spawn_redshirts_during_BT_defend();
	//bank_enemies = getentarray( "bank_enemies", "targetname" );
	//array_thread( bank_enemies, ::spawn_ai );
	
	//thread dialog_stay_near_BT_nags();
	//thread mission_fail_if_leaves_BT();
	
	//while( level.num_of_enemy_forces_spawned < 3 )
	//	wait 1;
		
	//wait 10;
	
	flag_wait( "first_attack_heli_spawned" );
	eHeli = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "kill_heli" );
	eHeli.circling = true;
	eHeli.no_attractor = true;
	level.attack_heli = thread maps\_attack_heli::begin_attack_heli_behavior( eHeli );
	//level.attack_heli MakeEntitySentient( "axis" );
	thread dialog_first_attack_heli();
	//thread dialog_attack_heli_nags();//does both
	
	thread spawn_rpg_redshirts();
	
	attacker = undefined;
	if( isalive( level.attack_heli ) )
		level.attack_heli waittill( "death", attacker );
	flag_set( "first_attack_heli_dead" );
	
	if(  isdefined( attacker ) && isplayer( attacker ) )
		thread dialog_shot_down_heli();
	thread autosave_by_name( "heli_death" );
		
		
	flag_wait( "second_attack_heli_spawned" );
	eHeli = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "kill_heli" );
	eHeli.circling = true;
	eHeli.no_attractor = true;
	level.attack_heli = thread maps\_attack_heli::begin_attack_heli_behavior( eHeli );
	//level.attack_heli MakeEntitySentient( "axis" );
	
	thread spawn_rpg_redshirts();
	thread dialog_second_attack_heli();
		
	attacker = undefined;
	if( isalive( level.attack_heli ) )
		level.attack_heli waittill( "death", attacker );
	flag_set( "second_attack_heli_dead" );
		
	if( isdefined( attacker ) && isplayer( attacker ) )
		thread dialog_shot_down_heli();
	thread autosave_by_name( "heli_death" );
	
	wait 12;
	thread handler_convoy();
}


music_invasion_regroup_and_end()
{
	thread music_regroup();
	
	flag_wait( "player_at_convoy" );
	
	music_stop( 3 );
	
	level.player playsound( "invasion_ending" );
	//MusicPlayWrapper( "invasion_ending" );
}


music_regroup()
{
	if( flag( "player_at_convoy" ) )
		return;
		
		
	music_TIME = musicLength( "invasion_regroup" );
	//music_TIME 		 		 = 86;
	level endon( "player_at_convoy" );
	
	
	while( 1 )
	{
		MusicPlayWrapper( "invasion_regroup" );
		
		wait music_TIME;
	}
}

handler_convoy()
{
	//nodes = getvehiclenodes( "apply_brakes", "script_noteworthy" );
	//foreach( n in nodes )
	//	n thread setup_brakes();
	
	wait 1;
	
	level.obj_direction = "south";
	center_spawner = undefined;
	convoy = getentarray( "convoy", "targetname" );
	foreach( member in convoy )
	{
		if( !isdefined( member.script_noteworthy ) )
			continue;
		if( member.script_noteworthy == "obj_vehicle" )
			center_spawner = member;
	}
			
	if( isdefined( center_spawner ) )
	{
		while( player_looking_at( center_spawner.origin, 0, true ) && flag( "player_on_roof" ) )
			wait 1;
	}
	
	thread music_invasion_regroup_and_end();
			
	targets = getstructarray( "convoy_targets", "targetname" );
	humvees = [];
	
	
	thread dialog_come_to_convoy();
	foreach( member in convoy )
	{
		vehicle = member thread maps\_vehicle::spawn_vehicle_and_gopath();
		//vehicle.veh_pathtype = "constrained";
		vehicle.dontunloadonend = true;
		//vehicle.script_keepdriver = true;
		vehicle thread convoy_targets( targets );
		vehicle thread setup_brakes();
		if( isdefined( member.script_noteworthy ) )
		{
			humvees[humvees.size] = vehicle;
			if( member.script_noteworthy == "obj_vehicle" )
				level.convoy = vehicle;
		}
		//wait .05;//so the spawners arent used more than once per frame
	}
	flag_set( "time_to_goto_convoy" );
	
	enemies = getaiarray( "axis" );
	total = enemies.size;
	
	if( total < 12 )
	{
		//4 guys:
		wounded_carry_attackers_TC = getentarray( "wounded_carry_attackers_TC", "targetname" );
		array_thread( wounded_carry_attackers_TC, ::spawn_ai );	
	}
	
	if( total < 6 )
	{
		//6 guys
		wounded_carry_attackers_gas = getentarray( "wounded_carry_attackers_gas", "targetname" );
		array_thread( wounded_carry_attackers_gas, ::spawn_ai );	
	}
	
	//convoy = maps\_vehicle::spawn_vehicles_from_targetname_and_drive( "convoy" );
	
	//iprintlnbold( "convoy is here" );
	flag_wait( "convoy_has_arrived" );//vehicle node sets this
	//convoy[0] waittill( "reached_path_end" );
	
	if( !isdefined( level.convoy.usedPositions ) )
	{
		level.convoy.usedPositions = [];
	}
	level.convoy.usedPositions[ 3 ] = true;
	
	//level.player waittill_entity_in_range( level.convoy, 4000 );
	
	
	flag_set( "convoy_in_position" );
	
	flag_wait( "player_at_convoy" );
	thread friendlies_enter_humvees( humvees );
	thread player_enters_convoy_humvee();
	set_vision_set( "invasion_near_convoy", 3 );
	
	//Radio HQ Voice 1: 	Seal Six-One, this is Overlord, gimme a sitrep over.	
	radio_dialogue( "inv_hqr_sitrep" );

	//Seal Six-One:	Overlord, Six-One Actual. Be advised: precious cargo is secure, repeat, precious cargo is secure. We're oscar mike.	
	radio_dialogue( "inv_six_cargosecure" );
	
	//Radio HQ Voice 1: 	Overlord copies all. Good job. Out.	
	radio_dialogue( "inv_hqr_goodjob" );
	
	wait 1;
	
	//Squad, we still got 2,000 civvies in Arcadia! If you got family there it's your lucky day - we're gonna go save their lives!
	radio_dialogue( "inv_fly_2kcivvies" );
	
	//iprintlnbold( "end" );
	nextmission();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


stinger_hint()
{
	flag_wait( "first_attack_heli_spawned" );

	while ( 1 )
	{
		level.player waittill( "begin_firing" );
		weap = level.player GetCurrentWeapon();
		if ( weap == "stinger" )
		{
			if( level.player playerads() == 1.0 )
				return;
			else
			{
				if ( is_command_bound( "+toggleads_throw" ) )
					display_hint_timeout( "hint_toggle_ads_with_stinger", 5 );
				else
					display_hint_timeout( "hint_ads_with_stinger", 5 );
			}
		}
	}
}

should_break_ads_with_stinger()
{
	weap = level.player GetCurrentWeapon();
	if ( weap == "stinger" )
	{
		if( level.player playerads() == 1.0 )
			return true;
		else
			return false;
	}
	else
	{
		return true;
	}
}

player_enters_convoy_humvee()
{	
	humvee = level.convoy;
	while ( 1 )
	{
		if( humvee.veh_speed == 0 )
			break;
		wait .5;
	}
	goal_pos = humvee gettagorigin( "tag_guy1" );
	//humvee_end_pos =(-4692,-4529,2310);
	
	//thread maps\_debug::drawArrowForever( goal_pos, (0,0,0) );
	while ( 1 )
	{
		d = Distance( goal_pos, level.player.origin );
		if ( d <= 70 )
			break;
		wait .5;
	}
	move_time = 0.6;
	
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player DisableWeapons();
	
	org = spawn_tag_origin();
	org.origin = level.player.origin;
	org.angles = level.player.angles;
	level.player PlayerLinkTo( org, "tag_origin", 0.8, 180, 180, 40, 40 );
	
	goal_pos = humvee gettagorigin( "tag_guy1" );
	org MoveTo( goal_pos+(0,0,-30), move_time, move_time * 0.5, move_time * 0.5 );
	
	wait( move_time );
	
	//wait 2;
	
	//iprintlnbold( "nextmission" );
}


setup_brakes()
{
	self ent_flag_init( "apply_brakes" );
	//if( self.classname == "script_vehicle_bradley" )
	//	return;
	self ent_flag_wait( "apply_brakes" );
	
	//print3d( self.origin + (0,0,100), "brake", (1,1,1), 1, 1, 60 );
	//self waitill( "trigger", vehicle );
	self.veh_brake = 1;
}

friendlies_enter_humvees( humvees )
{
	friendly_redshirts = getentarray( "friendly_redshirt", "script_noteworthy" );
	foreach( thing in friendly_redshirts )
	{
		if( !isai( thing ) )
		{
			if( isspawner( thing ) )
			{
				thing remove_spawn_function( ::keep_red_shirts_alive_until_close );
				thing remove_spawn_function( ::smart_roaming_barney );
			}
		}
	}
	
	humvees_left = humvees.size;
	while( humvees_left )
	{
		new_guys = spawn_humvee_boarders();
		foreach( guy in new_guys )
			thread guy_runtovehicle_load( guy, humvees[humvees_left-1] );
		humvees_left--;
		wait 3;
	}
}


spawn_humvee_boarders()
{
	group = "redshirt_spawn_group_BT";
		
	redshirt_spawn_groups = getstructarray( group, "targetname" );
	farthest = getfarthest( level.player.origin, redshirt_spawn_groups );
	spawners = getentarray( farthest.target, "targetname" );
	println( " selected redshirt group: " + farthest.script_noteworthy );
	
	//closest = getclosest( level.player.origin, redshirt_spawn_groups );
	//redshirt_spawn_groups = array_remove( redshirt_spawn_groups, closest );
	//second_closest = getclosest( level.player.origin, redshirt_spawn_groups );
	//spawners = getentarray( second_closest.target, "targetname" );
	
	guys = [];
	foreach( spawner in spawners )
	{
		if( guys.size < 3 )
		{
			spawner.count = 1;
			guys[guys.size] = spawner spawn_ai();
		}
	}
	return guys;
}

dialog_enemies_on_roof()
{
	flag_wait( "player_on_roof" );
	level endon( "diner_attack" );
	
	dialog = [];
	//Tangos on the roof behind us!	
	dialog[dialog.size] = "inv_six_roofbehind";
	//Our perimeter is breached! Enemies on the roof! 	
	dialog[dialog.size] = "inv_six_enemiesonroof";
	//Contact! Hostiles are on our roof! Inside our perimeter!	
	dialog[dialog.size] = "inv_six_insideperim";
	//Squad! Hostiles on the roof! Turn around!	
	dialog[dialog.size] = "inv_six_turnaround";
	
	current_line = 0;
	
	trig = getent( "enemies_on_roof", "targetname" );
	while( 1 )
	{
		trig waittill( "trigger", other );	
		
		println( other.classname + "    " + other.origin );
		level.raptor dialogue_queue( dialog[current_line] );
		current_line++;
		if( current_line >= dialog.size )
			current_line = 0;
			
		wait 10;
	}
}

wait_to_spawn_diner_defenders()
{
	flag_wait( "player_on_roof" );
	flag_waitopen( "player_on_roof" );

	activate_trigger_with_targetname( "diner_enemy_defenders_trigger" );
}

setup_remote_missile_target_guy()
{
	if( isdefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "paradrop_guy_left" )
			return;
		if( self.script_noteworthy == "paradrop_guy_right" )
			return;
	}
	if( isdefined( self.ridingvehicle ) )
	{
		self endon( "death" );
		self waittill( "jumpedout" );
		
	}
	self maps\_remotemissile::setup_remote_missile_target();
}


//save_when_btr_and_riders_are_dead()
//{
//	flag_wait( "house_destroyer_dead" );
//	if( flag( "house_destroyer_unloading" ) )
//		flag_wait( "house_destroyer_riders_dead" );
//	
//	autosave_by_name( "save_when_btr_and_riders_are_dead" );
//}

get_friendlies_away_from_nates_destruction()
{
	nates_roof_volume_south = getent( "nates_roof_volume_south", "targetname" );
	destroyed_nates_inaccessable_volume = getent( "destroyed_nates_inaccessable_volume", "targetname" );
	
	destroyed_nates_safe_volume = getent( "destroyed_nates_safe_volume", "targetname" );
	destroyed_nates_safe_goal = getent( "raptor_in_nates_prep", "targetname" );
	
	friendlies = getaiarray( "allies" );
	foreach( friend in friendlies )
	{
		if( ( friend istouching( destroyed_nates_inaccessable_volume ) ) || ( friend istouching( nates_roof_volume_south ) ) )
		{
			friend.goalradius = 500;
			friend setgoalpos( destroyed_nates_safe_goal.origin );
			friend setgoalvolume( destroyed_nates_safe_volume );
			friend.fixednode = false;
		}
	}
	
	BadPlace_Brush( "destroyed_nates_inaccessable_volume", -1, destroyed_nates_inaccessable_volume, "allies", "axis" );
	BadPlace_Brush( "nates_roof_volume_south", -1, nates_roof_volume_south, "allies", "axis" );
	
	flag_wait ( "nates_bomb_incoming" );
	
	BadPlace_Delete( "destroyed_nates_inaccessable_volume" );
	BadPlace_Delete( "nates_roof_volume_south" );
}

kill_friendlies_on_roof()
{
	level endon( "player_on_roof" );
	roof_volume = getent( "roof_volume", "targetname" );
	friendlies = getaiarray( "allies" );
	foreach( friend in friendlies )
	{
		if( friend istouching( roof_volume ) )
		{
			if( isdefined( friend.magic_bullet_shield ) )
				friend stop_magic_bullet_shield();
			friend kill();
			wait .5;
		}
	}
}

btr80_smash()
{
	
	scripted_node = getent( "btr80_smash", "targetname" );
	//scripted_node.origin = ( -1571.2, -3374.1, 2357.7 );
	scripted_node.origin = ( 805.9, -1688.8, 2309.7 );
	//s_angles[0] = 0;
	//s_angles[1] = 149;
	//s_angles[2] = 0;
	//scripted_node.angles = s_angles;
	scripted_node.angles = (0,149,0);
	level.player waittill_in_range( scripted_node.origin, 1350 );
	//iprintlnbold( "now" );
	
	btr = spawn_anim_model( "btr_ground_smash" );
	car = spawn_anim_model( "btr_squashedcar" );
	
	btr playsound( "scn_invasion_btr_drop" );
	scripted_node thread anim_single_solo( car, "btr_squashedcar" );
	scripted_node thread anim_single_solo( btr, "btr_ground_smash" );
}

friendlies_shift_north()
{
	north_side_nodes = getnodearray( "north_side_nodes", "targetname" );
	nates_roof_volume_north = getent( "nates_roof_volume_north", "targetname" );
	friendlies = getaiarray( "allies" );
	
	level.raptor.goalheight = 80;
	level.raptor.goalradius = 500;
	level.raptor.fixednode = false;
	level.raptor setgoalnode( north_side_nodes[0] );
	level.raptor setgoalvolume( nates_roof_volume_north );
	
	num = 1;
	
	for( i = 0 ; i < friendlies.size ; i++ )
	{
		if( num >= north_side_nodes.size )
			break;
		if( !isalive( friendlies[i] ) )
		{
			continue;
		}
		else
		{
			friendlies[i].goalheight = 80;
			friendlies[i].goalradius = 500;
			friendlies[i].fixednode = false;
			friendlies[i] setgoalnode( north_side_nodes[num] );
			friendlies[i] setgoalvolume( nates_roof_volume_north );
			num++;
			wait 1;
		}
	}
}

spawn_nates_defenders()
{
	flag_wait( "leaving_gas_station" );
	//wait .05;//wait for flag
	if( flag ( "nates_bomb_incoming" ) )
		return;
	nates_defenders = getentarray( "nates_defenders", "script_noteworthy" );
	foreach( guy in nates_defenders )
		guy spawn_ai();
}


spawn_nates_attackers_in_alley()
{
	flag_wait( "spawn_nates_attackers_in_alley" );
	alley_nates_attackers = getentarray( "alley_nates_attackers", "script_noteworthy" );
	foreach( guy in alley_nates_attackers )
		guy spawn_ai();
}

spawn_battle_when_in_uav()
{
	//level endon ( "bmps_from_north_dead" );
	//while( 1 )
	//{
		level waittill( "player_is_controlling_UAV" );
	
		//wounded_carry_attackers_TC = getentarray( "wounded_carry_attackers_TC", "targetname" );
		//array_thread( wounded_carry_attackers_TC, ::spawn_ai );	
		
		uav_ambient_battle = getentarray( "uav_ambient_battle", "targetname" );
		array_thread( uav_ambient_battle, ::spawn_ai );	
	
		//bank_nates_attackers = getentarray( "bank_nates_attackers", "targetname" );
		//array_thread( bank_nates_attackers, ::spawn_ai );
	
		//burger_town_nates_attackers = getentarray( "burger_town_nates_attackers", "targetname" );
		//array_thread( burger_town_nates_attackers, ::spawn_ai );
	
		//wounded_carry_attackers_bus = getentarray( "wounded_carry_attackers_bus", "targetname" );
		//array_thread( wounded_carry_attackers_bus, ::spawn_ai );
	//}
}


convoy_targets( targets )
{
	if( self.classname == "script_vehicle_hummer_minigun" )
	{
		//get the vehicle first, then...
		turret = self.mgturret[0];
		turret waittill( "turret_ready" );  // if you grab the vehicle right when it spawns, wait for this, otherwise don't (I will make this an ent flag when P4 unlocks)
		mg_guy = turret getturretowner();
		
		mg_guy.ignoreall = true;  // this makes him not shoot when we run set_manual_target
		turret thread animscripts\hummer_turret\common::set_manual_target( level.player, 1, 6 );  // 3 = minFireTime, 6 = maxFireTime
		mg_guy.ignoreall = false;  // now he'll shoot at enemies he sees again
	}
	else
	{
		while ( !flag( "player_at_convoy" ) )
		{
			targets = array_randomize( targets );
			foreach( tgt in targets )
			{
				self setturrettargetvec( tgt.origin );
				self waittill( "turret_on_target" );
				self fireweapon();
				wait ( randomfloatrange( .2, .6 ) );
			}
		}
	}
}

dialog_shot_down_heli()
{
	wait 3;
	//Nice one Roach. 	
	radio_dialogue( "inv_six_niceoneheli" );
}

dialog_come_to_convoy()
{
	level endon ( "player_at_convoy" );
	
	wait 10;
	
	
	//The convoy's here! Everyone on me! We're getting the hell outta here! Let's go, let's go!!	
	radio_dialogue( "inv_six_convoyshere" );
	
	wait 4;
	
	//Ramirez! The convoy is just south of Burgertown, get your ass over here! Move!	
	radio_dialogue( "inv_six_southofbtown" );
	
	wait 4;
	
	//Ramirez! We gotta get back to the convoy! Let's go!	
	radio_dialogue( "inv_tco_backtoconvoy" );
	
	
	while ( 1 )
	{
		wait 15;
	
		//The convoy's here! Everyone on me! We're getting the hell outta here! Let's go, let's go!!	
		radio_dialogue( "inv_six_convoyshere" );
		
		wait 15;
		
		//Ramirez! The convoy is just south of Burgertown, get your ass over here! Move!	
		radio_dialogue( "inv_six_southofbtown" );
		
		wait 15;
		
		//Ramirez! We gotta get back to the convoy! Let's go!	
		radio_dialogue( "inv_tco_backtoconvoy" );
	}
}



dialog_uav_the_infantry()
{
	wait 8;
	
	if( isdefined( level.player.is_controlling_UAV ) )
		return;
	level endon( "player_is_controlling_UAV" );
	

	
	if( cointoss() )
	{
		//Ramirez, use the UAV on the infantry!	
		radio_dialogue( "inv_six_theinfantry" );
	}
	else
	{
		//Ramirez, use the UAV! We got incoming infantry!
		radio_dialogue( "inv_six_theinfantry2" );
	}
	
	wait 5;
	
	// get_remotemissile_hint_string() Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
	level.player thread display_hint( level.player get_remotemissile_hint_string( "hint_predator_drone" ) );
}

dialog_first_attack_heli()
{
//INTRO
	//Hunter Two-One this is Overlord. We got a visual on an enemy attack helicopter headed for your area, over.	
	radio_dialogue( "inv_hqr_enemyhelo" );
	
	//Hunter Two-One, be advised, enemy helo approaching your sector. CAP is unavailable at this time, good luck, over.	
	//radio_dialogue( "inv_hqr_capunavail" );
	
	//Solid copy Overlord. Ramirez! Take down that helicopter! Go!	
	radio_dialogue( "inv_six_takedown" );
	
	thread dialog_get_stinger();
}

	
dialog_get_stinger()
{
	level.attack_heli endon( "death" );
	wait 3;

	nates_dialog_current = 0;
	nates_dialog = [];
	
//Ramirez! I saw a couple Stingers on the roof of Nate's! 	
	nates_dialog[ nates_dialog.size ] = "inv_tco_roofofnates";
//Use 'em to take down that sonofabitch! Go!	inv_tco_roofofnates2";
//Ramirez! There's Stingers on the roof of Nate's restaurant! 	
	nates_dialog[ nates_dialog.size ] = "inv_tco_killthathelo";
//Use 'em to kill that helo! Go! Go!	inv_tco_killthathelo2";
//Ramirez! Check the roof of Nate's restaurant! I saw some Stingers up there!	
	nates_dialog[ nates_dialog.size ] = "inv_six_checktheroof";
//Ramirez! There's some Stingers by the supply drop on the roof of Nate's!	
	nates_dialog[ nates_dialog.size ] = "inv_six_supplydroponroof";

	diner_dialog_current = 0;
	diner_dialog = [];


//Ramirez! I saw a Stinger missile in that diner to the west! 	
	diner_dialog[ diner_dialog.size ] = "inv_tco_dispatchchopper";
//Use it to to dispatch that chopper! I'll cover you! Go!	inv_tco_dispatchchopper2";
//Ramirez! There's a Stinger missile in that stockpile to the west! 	
	diner_dialog[ diner_dialog.size ] = "inv_tco_insidediner";
//It's inside the diner! Move! I got ya covered!	inv_tco_insidediner2";
//Ramirez! Next to the gas station to the west is a diner! Check there for a Stinger missile!	
	diner_dialog[ diner_dialog.size ] = "inv_tco_nexttostation";
//Ramirez! I saw a Stinger missile in the diner where we got the UAV control rig! 	
	diner_dialog[ diner_dialog.size ] = "inv_tco_dineruav";

		
		
	//stingers = getentarray( "stinger", "targetname" );
	//closest_stinger = getClosest( level.player.origin, stingers );
	
	while( 1 )
	{	
		needs_stinger = true;
		weapons = level.player GetWeaponsListAll();
		foreach( weap in weapons )
		if( weap == "stinger" )
			needs_stinger = false;
		
		if( !needs_stinger )
		{
			wait 3;
			continue;
		}
		
		
		diner_stinger = getent( "diner", "script_noteworthy" );
		if( isdefined( diner_stinger ) )
		{
			selected_line = diner_dialog[ diner_dialog_current ];
			radio_dialogue( selected_line );
			
			if( selected_line == "inv_tco_roofofnates" )
				radio_dialogue( "inv_tco_roofofnates2" );
				
			if( selected_line == "inv_tco_killthathelo" )
				radio_dialogue( "inv_tco_killthathelo2" );
				
			diner_dialog_current++;
			if( diner_dialog_current >= diner_dialog.size )
				diner_dialog_current = 0;
		}
		else
		{
				
			selected_line = nates_dialog[ nates_dialog_current ];
				
			radio_dialogue( selected_line );
			
			if( selected_line == "inv_tco_dispatchchopper" )
				radio_dialogue( "inv_tco_dispatchchopper2" );
				
			if( selected_line == "inv_tco_insidediner" )
				radio_dialogue( "inv_tco_insidediner2" );
			
			nates_dialog_current++;
			if( nates_dialog_current >= nates_dialog.size )
				nates_dialog_current = 0;
		}
		wait 50;
	}
}

//dialog_second_get_stinger()
//{
//	level.attack_heli endon( "death" );
//	wait 3;
//	
//	if( level.first_stinger == "diner" )
//	{
//		//Ramirez! I saw some Stinger missiles in that diner to the west! Use them to to dispatch that chopper! I'll cover you! Go!	
//		radio_dialogue( "inv_tco_dispatchchopper" );
//	
//		wait 12;
//	
//		//Ramirez! There's Stinger missiles in that stockpile to the west, inside the diner! Move! I got ya covered!	
//		radio_dialogue( "inv_tco_insidediner" );
//		
//		wait 20;
//		
//		//Ramirez! I saw some Stinger missiles in that diner to the west! Use them to to dispatch that chopper! I'll cover you! Go!	
//		radio_dialogue( "inv_tco_dispatchchopper" );
//	}
//	else
//	{
//		//Ramirez! I saw a couple Stingers on the roof of Nate's! Use 'em to take down that sonofabitch! Go!	
//		radio_dialogue( "inv_tco_roofofnates" );
//	
//		wait 12;
//	
//		//Ramirez! There's Stingers on the roof of Nate's restaurant! Use 'em to kill that helo! Go! Go!	
//		radio_dialogue( "inv_tco_killthathelo" );
//		
//		wait 20;
//		
//		//Ramirez! I saw a couple Stingers on the roof of Nate's! Use 'em to take down that sonofabitch! Go!	
//		radio_dialogue( "inv_tco_roofofnates" );
//	}	
//}

dialog_destroyed_btr_with_uav()
{
	level waittill( "bmp_died" );
	
	if( isdefined( level.player.fired_hellfire_missile ) )
	{	
		wait 3;
		if( flag( "bmps_from_north_dead" ) )//both are dead
			return;
		//Good effect on target. That's a kill. One more to go.
		radio_dialogue( "inv_six_onemore" );
	}
}
	
dialog_second_attack_heli()
{	
//SECOND
	//Hunter Two-One, relay from Goliath One: you got an enemy helicopter loaded for bear, approaching your area, over.	
	radio_dialogue( "inv_hqr_relaygol1" );
	
	//Eyes up!!! Enemy gunship comin' in hot!!!	
	radio_dialogue( "inv_tco_eyesup" );
	
	//Roger Overlord, Hunter copies all. Ramirez, we've got another enemy helo, take it out!!	
	radio_dialogue( "inv_six_anotherhelo" );
	
	thread dialog_get_stinger();
}
	
//dialog_attack_heli_nags()
//{
//	dialog = [];
//	//Ramirez, take out that helicopter before the convoy arrives!! Move!!	
//	dialog[dialog.size] = "inv_six_beforeconvoy";
//	
//	//Ramirez, find an anti-aircraft weapon and take out the gunship!!	
//	dialog[dialog.size] = "inv_six_antiaircraft";
//	
//	//Ramirez! Take out that gunship before the convoy arrives! Go! Go!	
//	dialog[dialog.size] = "inv_six_takegunship";
//	start = 0;
//	
//	while( 1 )
//	{
//		wait 60;
//		if( isalive( level.attack_heli ) )
//		{
//			radio_dialogue( dialog[start] );
//			start++;
//			if( start >= dialog.size )
//				start = 0;
//		}
//	}
//}


fire_stinger_at_uav()
{
	if( isdefined( level.uav_is_destroyed ) )
		return;
//	thread uav_forward();
	level.uav maps\_vehicle::godoff();
	level.uav.health = 400;
		
	level waittill( "player_is_controlling_UAV" );
	
	wait 2;
	
	//enemies = getaiarray( "axis" );
	//stinger_source = get_closest_to_player_view( enemies );
	//	if( !isdefined( stinger_source ) )
	//		continue;
	
	thread dialog_missile_fired_at_stinger();
	
	forward = AnglesToForward( level.uav.angles );
	forwardfar = vector_multiply( forward, 10000 );
	end = forwardfar + level.uav.origin;

	attractor = Missile_CreateAttractorEnt( level.uav, 100000, 60000 );
	
	newMissile = MagicBullet( "zippy_rockets", ( 497.8, -3564.4, 2346 ), end );
	newMissile Missile_SetTargetEnt( level.uav ); 
	
	old_org = level.uav.origin;
	old_dist = 9999999999;
	while ( IsDefined( newMissile ) )
	{
		if( !isalive( level.uav ) )
			break;
		dist = Distance( newMissile.origin, level.uav.origin );
		if ( dist <= 200 )
			break;
		if( dist > ( old_dist + 100 ) )
			break;
		old_dist = dist;
		old_org = level.uav.origin;
		wait .05;
	}
	Missile_DeleteAttractor( attractor );
	
	if( IsDefined( newMissile ) )
		newMissile delete();
	playfx( getfx( "uav_explosion" ), old_org );

	level.uav_is_destroyed = true;
	level.player maps\_remotemissile::remove_uav_weapon();

	if( isdefined( level.uav ) )
		level.uav delete();
	level notify( "uav_destroyed" );
	
	
	wait 2;
	radio_dialogue_clear_stack();
	//Be advised, the UAV is offline I repeat, the UAV is offline!! <Garble!>	
	radio_dialogue( "inv_tco_uavoffline" );
}

dialog_missile_fired_at_stinger()
{
	wait 2;
	radio_dialogue_clear_stack();
	//<Garble!> Someone just fired a missile at the UAV!	
	radio_dialogue( "inv_tco_firedmissile" );
}

//uav_forward()
//{
//	while( 1 )
//	{
//		forward = AnglesToForward( level.uav.angles );
//		forwardfar = vector_multiply( forward, 10000 );
//		end = forwardfar + level.uav.origin;
//	
//		maps\_debug::drawArrow( end, level.uav.angles );
//		wait .05;
//	}
//}

dialog_enemy_attack_heli()
{
	//Hunter Two-One this is Overlord. We got a visual on an enemy attack helicopter headed for your area, over.	
	radio_dialogue( "inv_hqr_enemyhelo" );
	
	//Hunter Two-One, relay from Goliath One: you got an enemy helicopter loaded for bear, approaching your area, over.	
	radio_dialogue( "inv_hqr_relaygol1" );
	
	//Hunter Two-One, be advised, enemy helo approaching your sector. CAP is unavailable at this time, good luck, over.	
	radio_dialogue( "inv_hqr_capunavail" );
	
	//Eyes up!!! Enemy gunship comin' in hot!!!	
	radio_dialogue( "inv_tco_eyesup" );
}

spawn_redshirts_during_BT_defend()
{
	friendly_redshirts = getentarray( "friendly_redshirt", "script_noteworthy" );
	foreach( thing in friendly_redshirts )
	{
		if( isai( thing ) )
		{
			if( isalive( thing ) )
			{
				thing thread keep_red_shirts_alive_until_close();
				thing thread smart_roaming_barney();
			}		
		}
		else
		{
			if( isspawner( thing ) )
			{
				thing add_spawn_function( ::keep_red_shirts_alive_until_close );
				thing add_spawn_function( ::smart_roaming_barney );
			}
		}
	}
	
	if( !isdefined( level.redshirts ) )
		level.redshirts = [];
	//final_goal = getent( "convoy_obj", "targetname" ).origin;
	//previous_goal = final_goal;
	
	level endon ( "time_to_goto_convoy" );
	
	while( 1 )
	{
		//while( level.redshirts.size > 0 )
		//{
		//	wait 1;
		//	new_array = [];
		//	foreach( redshirt in level.redshirts )
		//	{
		//		if( isalive( redshirt ) )
		//			new_array[new_array.size] = redshirt;
		//	}
		//	level.redshirts = new_array;
		//}
		wait 1;
		
		//get goal
		//stingers = getentarray( "stinger", "targetname" );
		//goal = final_goal;
		//if( ( isdefined( stingers ) ) && ( stingers.size > 0 ) )
		//{
		//	if( stingers.size > 1 )
		//		goal = ( getfarthest( level.player.origin, stingers ) ).origin;
		//	else
		//		goal = stingers[0].origin;
		//}
		//else
		//{
		//	goal = final_goal;
		//}
		
		
		
		redshirts_desired = 3;
		
		level.redshirts = redshirts_respawn( redshirts_desired );
		
		//foreach( redshirt in level.redshirts )
		//{
		//}
		
		//assign new goal to all redshirts
		//if( previous_goal != goal )
		
	}
}

keep_red_shirts_alive_until_close()
{
	self.ignored_by_attack_heli = true;
	self thread magic_bullet_shield();
	
	self waittill_entity_in_range( level.player, 600 );
	
	self.ignored_by_attack_heli = undefined;
	self thread stop_magic_bullet_shield();
}


smart_barney( end_flag, end_goal, end_volume )
{
	self endon( "stop_barney" );
	self endon( "death" );
	self ClearGoalVolume();
	self thread friendly_adjust_movement_speed();
	self.goalheight = 80;
	self.goalradius = 500;
	self.useChokePoints = false;
	//level.taco setgoalentity( level.player );
	self.fixednode = false;
	
	nates_roof_goal_volume = getent( "nates_roof_goal_volume", "targetname" );
	BT_roof_goal_volume = getent( "BT_roof_goal_volume", "targetname" );
	
	if( !isdefined( self.favoriteenemy ) )
	{
		goal_enemies = end_volume get_ai_touching_volume( "axis" );
		if( goal_enemies.size )
			self.favoriteenemy = goal_enemies[0];
	}
		
	while( !flag( end_flag ) )
	{
		if( flag( "player_on_burgertown_roof" ) )
		{
			self setgoalpos( BT_roof_goal_volume.origin );
			self setgoalvolume( BT_roof_goal_volume );
		}
		else if( flag( "player_on_roof" ) )
		{
			self setgoalpos( nates_roof_goal_volume.origin );
			self setgoalvolume( nates_roof_goal_volume );
		}
		else
		{
			self cleargoalvolume();
			player = level.player.origin;
			vec = VectorNormalize( end_goal - player );
			forward = vector_multiply( vec, 400 );
			goal = forward + player;
			self setgoalpos( goal );
		}
		
		//check for nearby BMPs
		wait 2;
		self.favoriteenemy = undefined;
	}
	self notify( "stop_adjust_movement_speed" );
	self.moveplaybackrate = 1.0;
		
	self setgoalpos( end_goal );
	self setgoalvolume( end_volume );
}

smart_roaming_barney()
{
	self notify( "stop_barney" );
	self endon( "stop_barney" );
	self endon( "death" );
	self ClearGoalVolume();
	self thread friendly_adjust_movement_speed();
	self.goalheight = 80;
	self.useChokePoints = false;
	if( !isdefined( self.big_goal ) )
		self.goalradius = 500;
	else
		self.goalradius = 1000;
	self.fixednode = false;
	
	nates_roof_goal_volume = getent( "nates_roof_goal_volume", "targetname" );
	BT_roof_goal_volume = getent( "BT_roof_goal_volume", "targetname" );
		
	while( 1 )
	{
		if( flag( "player_on_burgertown_roof" ) )
		{
			self setgoalpos( BT_roof_goal_volume.origin );
			self setgoalvolume( BT_roof_goal_volume );
		}
		else if( flag( "player_on_roof" ) )
		{
			self setgoalpos( nates_roof_goal_volume.origin );
			self setgoalvolume( nates_roof_goal_volume );
		}
		else
		{
			self cleargoalvolume();
			if( isdefined( level.obj_pos ) )
			{
				end_goal = level.obj_pos;
				player = level.player.origin;
				vec = VectorNormalize( end_goal - player );
				forward = vector_multiply( vec, 400 );
				
				my_origin = self.origin;
				forward = (forward[0], forward[1], 0);//keeep z goal same as player position
				goal = forward + player;
				//goal = (goal[0], goal[1], my_origin[2] );//keep z goal the same as where you are
			}
			else
			{
				goal = level.player.origin;
			}	
			self setgoalpos( goal );
		}
		
		wait 2;
	}
	self notify( "stop_adjust_movement_speed" );
	self.moveplaybackrate = 1.0;
}



enemy_monitor()
{
	if( !isdefined( level.num_of_enemy_forces_spawned ) )
		level.num_of_enemy_forces_spawned = 0;
	
	
	level.enemy_force[ 0 ] = "taco_enemies";
	level.enemy_force[ 1 ] = "gas_station_enemies";
	level.enemy_force[ 2 ] = "bank_enemies";
	//level.enemy_force[ 3 ] = "spawners_exit";
	//level.enemy_force[ 4 ] = "30_seconds_pause";
	//level.enemy_force[ 5 ] = "40_seconds_pause";
	//level.enemy_force[ 6 ] = "enemy_heli_attack";

	level.dialog = [];
	
	//Hunter Two-One this is Overlord Actual, we're seeing enemy reinforcements to your north, over.	
	level.dialog[ "bank_enemies" ][ 0 ] = "inv_hqr_enemynorth";
	//Be advised Hunter Two-One, you got enemy infantry by that bank to the north, over.	
	level.dialog[ "bank_enemies" ][ 1 ] = "inv_hqr_banktonorth";
	//Hunter Two-One, be advised, enemy foot-mobiles approaching north of your location, over.	
	level.dialog[ "bank_enemies" ][ 2 ] = "inv_hqr_footmobiles";
	
	//Hunter Two-One, Overlord. Enemy foot-mobiles approaching you from the southeast, over.	
	level.dialog[ "taco_enemies" ][ 0 ] = "inv_hqr_southeast";
	//Hunter Two-One, Goliath One has a visual on hostiles coming from the southeast, over.	
	level.dialog[ "taco_enemies" ][ 1 ] = "inv_hqr_visualse";
	//Hunter Two-One, be advised, enemy foot-mobiles have been sighted near the taco joint, over.	
	level.dialog[ "taco_enemies" ][ 2 ] = "inv_hqr_tacojoint";
	
	//Hunter Two-One, Hunter Four has a visual on hostiles near the Nova gas station, over.	
	level.dialog[ "gas_station_enemies" ][ 0 ] = "inv_hqr_novagasstation";
	//Hunter Two-One, relay from Goliath Two, enemy reinforcements approaching from the west, over.	
	level.dialog[ "gas_station_enemies" ][ 1 ] = "inv_hqr_enemywest";
	//Hunter Two-One, tangos approaching near the diner to the west, over.	
	level.dialog[ "gas_station_enemies" ][ 2 ] = "inv_hqr_dinerwest";
	


	level.enemy_heli_attacking = false;
	level.enemy_force = array_randomize( level.enemy_force );
	level.selection = 0;

	level.enemy_groups = getentarray( "enemy_groups", "targetname" );
			
	//level.enemy_force[ 0 ] = "enemy_heli_attack";//TEMP DEBUG

	while ( true )
	{
		enemies = getaiarray( "axis" );
		total = enemies.size;
		roaming = total;
		println ( "             total: " + total );

/*
		for ( i = 0 ; i < enemies.size ; i++ )
			if ( isdefined( enemies[ i ].script_noteworthy ) )
				if ( enemies[ i ].script_noteworthy == "defender" )
					roaming -- ;
*/

		//println( "                roaming/total: " + roaming + "/" + total );
		//if ( ( level.enemy_heli_attacking ) && ( roaming < 1 ) )
		//	spawn_enemy_group();
		//else 
		if ( roaming < 7 )
		{
			if( flag( "first_attack_heli_dead" ) )
			{
				level.num_of_enemy_forces_spawned++;
				level notify( "enemy_group_spawning" );
				println ( "   level.num_of_enemy_forces_spawned: " + level.num_of_enemy_forces_spawned );
				spawn_enemy_group();
				
				wait 9;
				
				flag_set( "second_attack_heli_spawned" );
				thread autosave_by_name( "reinforcements" );
				
				flag_wait( "second_attack_heli_dead" );
				thread autosave_by_name( "reinforcements" );
				return;
			}
			
			if( ( level.num_of_enemy_forces_spawned == 3 ) && !flag( "first_attack_heli_spawned" ) )
			{
				wait 12;
				thread autosave_by_name( "reinforcements" );
				flag_set( "first_attack_heli_spawned" );
				flag_wait( "first_attack_heli_dead" );
				
				wait 5;
				continue;
			}
			
			if( level.num_of_enemy_forces_spawned >= 2 )
				thread fire_stinger_at_uav();
			
				
			level.num_of_enemy_forces_spawned++;
			level notify( "enemy_group_spawning" );
			println ( "   level.num_of_enemy_forces_spawned: " + level.num_of_enemy_forces_spawned );
			if( level.num_of_enemy_forces_spawned == 1 )
				thread dialog_uav_the_infantry();
			if( level.num_of_enemy_forces_spawned == 2 )
				thread dialog_uav_the_infantry();
			
			spawn_enemy_group();
		}
		wait 1;
	}
}

spawn_enemy_group()
{
	closest = getclosest( level.player.origin, level.enemy_groups );
	
	if( closest.target == level.enemy_force[ level.selection ] )
		level.selection++;
	if ( level.selection >= level.enemy_force.size )
		level.selection = 0;
	
	selection = level.enemy_force[ level.selection ];
	
	level.selection++ ;
	if ( level.selection >= level.enemy_force.size )
		level.selection = 0;
	
	if( selection == "bank_enemies" )
		level.obj_direction = "north";
	if( selection == "gas_station_enemies" )
		level.obj_direction = "west";
	if( selection == "taco_enemies" )
		level.obj_direction = "east";
		
				
	wait 1;

	thread autosave_by_name( "reinforcements" );

	wait 3;

	enemy_spawners = getentarray( selection, "targetname" );
	for ( i = 0 ; i < enemy_spawners.size ; i++ )
	{
		enemy_spawners[ i ].count = 1;
		guy = enemy_spawners[ i ] spawn_ai();
		wait .1;
	}
	wait 1;// make sure the spawning is done before checking to see how many are spawned
	
	//iprintlnbold ( dialog[ selection ][ randomint ( dialog[ selection ].size ) ] );
	//iprintlnbold ( "Danger enemies coming from " + selection );
	sound_selection = randomint( level.dialog[ selection ].size );
	thread radio_dialogue( level.dialog[ selection ][ sound_selection ] );
	
	wait 3;
	
	if( !isdefined( level.uavTargetPos ) )
	{
		if( level.num_of_enemy_forces_spawned < 3 )
		{
			foreach( group in level.enemy_groups )
				if( group.target == selection )
					level.uavTargetPos = group.origin;
		}
	}
}


dialog_team_were_inside()
{
	//Team, we're inside, we've got the President!	
	radio_dialogue( "inv_six_gotthepresident" );
	
	//Friendly convoy is oscar mike.	
	radio_dialogue( "inv_six_friedlyconvoy" );

}

mission_fail_if_leaves_BT()
{
	level endon( "convoy_is_here" );
	while( 1 )
	{
		flag_waitopen ( "player_is_close_to_BT" );
		thread mission_fail_if_leaves_BT_waiter();
		
		flag_wait ( "player_is_close_to_BT" );
	}
}

mission_fail_if_leaves_BT_waiter()
{
	level endon( "convoy_is_here" );
	level endon ( "player_is_close_to_BT" );
	level notify( "warning_player_is_leaving_BT" );
	
	wait 2;
	
	level notify( "warning_player_is_leaving_BT" );
	
	wait 2;
	
	level notify( "warning_player_is_leaving_BT" );
	
	wait 1;
	
	setDvar( "ui_deadquote", &"INVASION_FAIL_ABANDONED" );
	maps\_utility::missionFailedWrapper();
}

//dialog_stay_near_BT_nags()
//{
//	while( 1 )
//	{
//		level waittill( "warning_player_is_leaving_BT" );
//		
//		//Stay with us Roach! 	
//		thread radio_dialogue( "inv_six_staywithus" );
//		
//		level waittill( "warning_player_is_leaving_BT" );
//		
//		//Get over here! 	
//		thread radio_dialogue( "inv_six_getoverhere" );
//		
//		level waittill( "warning_player_is_leaving_BT" );
//		
//		//Roach, on me! Regroup with the squad!		
//		thread radio_dialogue( "inv_six_roachonme" );
//	}
//}

nates_locker_door_open()
{
	nates_meat_locker_door = getent( "nates_meat_locker_door", "targetname" );
	nates_meat_locker_door_model = getent( nates_meat_locker_door.target, "targetname" );
	nates_meat_locker_door_model LinkTo( nates_meat_locker_door );
	nates_meat_locker_door rotateyaw( -82, .1, 0, 0  );
	nates_meat_locker_door connectpaths();
	
	flag_wait( "player_on_roof" );
	
	wait 3;
	
	flag_wait( "player_on_roof" );
	
	nates_meat_locker_door rotateyaw( 82, .1, 0, 0 );
	nates_meat_locker_door disconnectpaths();
}



bt_locker_door_open()
{
	BT_locker_door = getent( "BT_locker_door", "targetname" );
	BT_locker_door rotateyaw( -172, .1, 0, 0  );
	BT_locker_door connectpaths();
}

bt_locker_door_close()
{
	wait 1;
	flag_waitopen( "player_is_near_BT_locker_door" );
	
	BT_locker_door = getent( "BT_locker_door", "targetname" );
	BT_locker_door rotateyaw( 172, .1, 0, 0 );
	BT_locker_door disconnectpaths();
	
	//The door is shut - you guys keep Ivan out.
	thread radio_dialogue( "inv_six_gotthepresident2" );
	
	
	if( isalive( level.president ) )
	{
		if( isdefined( level.president.being_carried ) )
			level.president waittill( "stop_putdown" );
		
		level.president stop_magic_bullet_shield();
		level.president delete();
	}
	level.raptor stop_magic_bullet_shield();
	level.raptor delete();
}

keep_enemies_away()
{

	vip_escort_bad_place1 = getent( "vip_escort_bad_place1", "targetname" );
	vip_escort_bad_place2 = getent( "vip_escort_bad_place2", "targetname" );
	vip_escort_bad_place3 = getent( "vip_escort_bad_place3", "targetname" );
	//BadPlace_Brush( <name>, <duration>, <brush entity>, <team>, ... )
	BadPlace_Brush( "vip_escort_bad_place1", -1, vip_escort_bad_place1, "axis" );
	BadPlace_Brush( "vip_escort_bad_place2", -1, vip_escort_bad_place2, "axis" );
	BadPlace_Brush( "vip_escort_bad_place3", -1, vip_escort_bad_place3, "axis" );
	flag_wait ( "president_in_BT_meat_locker" );
	BadPlace_Delete( "vip_escort_bad_place1" );
	BadPlace_Delete( "vip_escort_bad_place2" );
	BadPlace_Delete( "vip_escort_bad_place3" );

/*
	node = getent( "wounded_carry_path", "targetname" );
	BadPlace_Cylinder( "", 20, node.origin, 400, 300, "axis" );
	
	while( isdefined ( node.target ) )
	{
		node = getent( node.target, "targetname" );
		BadPlace_Cylinder( "", 20, node.origin, 400, 300, "axis" );
	}
*/
	//flag_wait ( "president_in_BT_meat_locker" );
	//BadPlace_Delete( "raptor" );
}


dialog_go_to_yards()
{
	wait 2;
	flag_set( "follow_foley" );
	//Seal Six-One:	Team, this way! Let's go let's go!	
	level.raptor dialogue_queue( "inv_six_teamthisway" );
}

dialog_yards_story()
{
	level endon( "dialog_bmp_hasnt_spotted_us" );

	//Overlord this is Raptor Six requesting air support, over!	
	level.raptor dialogue_queue( "inv_six_reqairsupport" );
	
	//Raptor Six, all air support is already engaged. 
	level.raptor dialogue_queue( "inv_hqr_engaged" );
	//Additional ground support is enroute to your position but has encountered heavy resistance, over.	
	level.raptor dialogue_queue( "inv_hqr_engaged2" );
	
	
	//Roger that Overlord. 
	level.raptor dialogue_queue( "inv_six_onfoot" );
	//Be advised, we have encountered enemy armor and are proceeding on foot, over.
	level.raptor dialogue_queue( "inv_six_onfoot2" );
	
	//Overlord copies all. Good luck. Out.	
	level.raptor dialogue_queue( "inv_hqr_goodluck" );
	
	wait 2;
	
	//Sarge, did HQ just tell us to 'F' ourselves?
	level.raptor dialogue_queue( "inv_tco_fourselves" );	
	//Pretty much, Corporal!
	level.taco dialogue_queue( "inv_six_prettymuch" );
	
	
	wait 4;
	
	//Seal Six-One:	I got a fix on the package. 300 meters east. 	
	level.raptor dialogue_queue( "inv_six_300meast" );
	
	//Taco:	Roger that.	
	level.taco dialogue_queue( "inv_tco_rogerthat" );
	//radio_dialogue( "inv_tco_rogerthat" );
}

//dialog_yards_objective()
//{
//	//Seal Six-One:	I got a fix on the package. 300 meters east. 	
//	level.raptor dialogue_queue( level.raptor, "inv_six_300meast" );
//}


bomb_nates()
{
	migs = spawn_vehicles_from_targetname_and_drive( "bomb_nates" );
	
	//Seal Six-One:	Enemy fast moverrrs!!! Take coverr!!!	
	thread radio_dialogue( "inv_six_fastmovers" );
	
	wait 3.5;
	
	remove_tvs();
	exploder( 333 );
	
	bomb_center = (257.2, -4669.1, 2381);
	if( distance( level.player.origin, bomb_center ) < 500 )
		level.player dodamage( ( level.player.health + 1000 ), bomb_center );
	
	delaythread( 2, ::falling_debri_on_player );
		
	//Earthquake( <scale>, <duration>, <source>, <radius> )
	earthquake( .4, 3, level.player.origin, 8000 );
}

falling_debri_on_player()
{
	player = getentarray( "player", "classname" )[ 0 ];
	numLoops = 30;

	for ( i = 0 ; i < numLoops ; i++ )
	{
		playfx( level._effect[ "falling_debris_player" ], player.origin + ( 0, 0, 500 ) );
		wait( 0.25 );
	}
}

remove_tvs()
{
	// delete destructible TVs where the explosion takes place
	destructible_tvs = getentarray( "exploder_tv_333", "script_noteworthy" );
	foreach ( tvi, tv in destructible_tvs )
		tv Delete(); 
}


enable_water_fx()
{
	friendlies = getaiarray( "allies" );
//	foreach( friend in friendlies )
//		friend thread waterfx( "start_house_destroyer" );
//	level.player thread waterfx( "start_house_destroyer" );
}

friendlies_try_to_get_off_roof()
{
	wait 5;
	off_roof_array = getnodearray( "off_roof", "targetname" );
	pos = 0;
	roof_volume = getent( "roof_volume", "targetname" );
	friendlies = getaiarray( "allies" );
	foreach( friend in friendlies )
	{
		if( friend == level.taco )
			continue;
		if( friend istouching( roof_volume ) )
		{
			friend setgoalnode( off_roof_array[ pos ] );
			pos++;
			friend.goalradius = 96;
			friend.goalheight = 64;
		}
	}
}


setup_count_predator_infantry_kills()
{
	self waittill( "death" );
		
	wait .05;
	
	if( !isdefined( level.enemies_killed ) )
		level.enemies_killed = 1;
	else
		level.enemies_killed++;
}


dialog_handle_predator_infantry_kills()
{
	dialog10 = [];
	//Ten plus KIAs. Good hit. Good hit.	
	dialog10[dialog10.size] = "inv_hqr_tenpluskia";
	//Oh man. Thats at least ten more confirms hunter two one. Good shooting.	
	dialog10[dialog10.size] = "inv_hqr_tenmoreconfirms";	
	//That looks to be at least five no, ten kills, hunter two one. Keep it up.	
	dialog10[dialog10.size] = "inv_hqr_fivenotenkills";	
	current_dialog10 = 0;
	
	dialog5 = [];
	//Five plus confirmed kills. Nice work. Hunter two one.	
	dialog5[dialog5.size] = "inv_hqr_fiveplus";	
	//Hunter two one, thats another five plus confirmed. 	
	dialog5[dialog5.size] = "inv_hqr_another5plus";	
	//Good hit. More than five KIAs.	
	dialog5[dialog5.size] = "inv_hqr_morethanfive";	
	current_dialog5 = 0;
	
	said_hes_down = false;
	said_direct_hit = false;
	level.enemies_killed = 0;
	kills = 0;
	
	while( 1 )
	{
		level waittill( "remote_missile_exploded" );
		old_num = level.enemies_killed;
		
		wait .1;
		
		if( isdefined( level.uav_killstats[ "ai" ] ) )
			kills = level.uav_killstats[ "ai" ];
		
		if( kills == 0 )
		{
			continue;
		}
		wait .5;
		
		if( isdefined( level.uav_is_destroyed ) )
			return;
		
		if( kills == 1 )
		{
			if( said_hes_down )
			{
				//You got 'em. Good kill.	
				radio_dialogue( "inv_hqr_yougotem" );
				said_hes_down = false;
			}
			else
			{
				//He's down.
				radio_dialogue( "inv_hqr_hesdown" );
				said_hes_down = true;
			}
			continue;	
		}
		if( kills >= 10 )
		{
			radio_dialogue( dialog10[current_dialog10] );
			current_dialog10++;
			if( current_dialog10 >= dialog10.size )
				current_dialog10 = 0;
			continue;
		}
		if( kills >= 5 )
		{
			radio_dialogue( dialog5[current_dialog5] );
			current_dialog5++;
			if( current_dialog5 >= dialog5.size )
				current_dialog5 = 0;
			continue;
		}
		else
		{
			if( said_direct_hit )
			{
				//Good kills hunter two one. Good kills.	
				radio_dialogue( "inv_hqr_goodkills" );
				said_direct_hit = false;
			}
			else
			{
				//Thats a direct hit hunter two one, keep up the fire.	
				radio_dialogue( "inv_hqr_directhit" );
				said_direct_hit = true;
			}
			continue;
		}
	}
}

//friendlies_stop_ignoring_when_flag( msg )
//{
//	flag_wait( msg );
//	friendlies = getaiarray( "allies" );
//	foreach( friend in friendlies )
//		friend.ignoreall = false;
//}
//
//friendlies_start_ignoreall()
//{
//	friendlies = getaiarray( "allies" );
//	foreach( friend in friendlies )
//		friend.ignoreall = true;
//}

//activate_this_friendly()
//{
//	self waittill( "trigger", other );
//	other.fixednode = false;
//	other.ignoreall = false;
//	other.pathenemyfightdist = 4000;
//	other.pathenemylookahead = 4000;
//	
//	wait 10;
//	
//	other.fixednode = true;
//	other.ignoreall = true;
//	other.pathenemyfightdist = 128;
//	other.pathenemylookahead = 128;
//}

diner_backdoor_attack()
{
	flag_wait( "player_in_diner" );
	autosave_by_name( "at_diner" );
	wait 2;
	flag_wait( "player_in_diner" );
	
	
	//Taco:	Incoming!	
	level.taco dialogue_queue( "inv_tco_incoming" );
	
	thread diner_back_door_open();

	trigger = getent( "diner_enemy_counter_attack_trigger", "targetname" );
	spawners = getentarray( trigger.target, "targetname" );
	array_thread( spawners, ::add_spawn_function, ::setup_diner_backdoor_attackers );
	activate_trigger_with_targetname( "diner_enemy_counter_attack_trigger" );
	flag_set( "back_door_attack_start" );
	
	//Taco:	Back door!	
	level.taco dialogue_queue( "inv_tco_backdoor" );
}

diner_back_door_open()
{
	diner_back_door = getent( "diner_back_door", "targetname" );
	diner_back_door rotateyaw( 85, .3 );//counter clockwise
	diner_back_door playsound( "diner_backdoor_slams_open" );
	diner_back_door connectpaths();
}

dialog_smoke_to_north()
{
	flag_clear( "smoke_screen_starting" );
	
	flag_wait( "smoke_screen_starting" );
	wait 4;
	
	//They're layin' down a smokescreen to the north.	
	radio_dialogue( "inv_tco_smokescrnth" );
	
	//Roger. Switch to thermal if you got it.	
	radio_dialogue( "inv_six_switchthermal" );
}

//dialog_come_cover_us_nag()
//{
//	level endon( "player_in_pos_to_cover_vip" );
//	
//	//Taco, get on the roof of Burger Town and provide overwatch! Roach, regroup on me! We're gonna move the package!	
//	radio_dialogue( "inv_six_overwatch" );
//		
//	wait 25;
//	
//	while( 1 )
//	{
//		//Roach, Taco's got the roof covered! We need you back here! Move!		
//		radio_dialogue( "inv_six_backhere" );
//		
//		//Roger that! Moving! Roach - regroup with the squad, go!	
//		//radio_dialogue( "inv_tco_regroupsquad" );	
//		
//		wait 25;
//	
//		//Roach, on me! Regroup with the squad!		
//		radio_dialogue( "inv_six_roachonme" );
//		
//		wait 25;
//	
//		
//		//wait 15;
//		
//		/*
//		//Seal Six-One:	Taco, Roach! Clear the Burgertown roof asap!	
//		radio_dialogue( "inv_six_clearbtroof" );
//		
//		wait 15;
//		
//		//Roach, get on the roof of that Burger Town and get ready to cover us.	
//		radio_dialogue( "inv_six_readytocover" );
//		
//		wait 15;
//		
//		//Taco, Roach - cover us from the Burger Town roof. Go!	
//		radio_dialogue( "inv_six_coverusgo" );
//		
//		wait 15;
//		*/
//	}
//}



prep_prez_for_run()
{
	wells_in_nates_prep = getent( "wells_in_nates_prep", "targetname" );
	level.wells setgoalpos( wells_in_nates_prep.origin );
	
	raptor_prep = getent( "raptor_in_nates_prep", "targetname" );
	level.raptor maps\_carry_ai::move_president_to_node( level.president, raptor_prep );
}

//raptor_can_die()
//{
//	level.raptor thread stop_magic_bullet_shield();
//	level.raptor.health = 1000;
//	level.raptor thread mission_fail_if_prez_dies();
//	
//	flag_wait( "president_in_BT_meat_locker" );
//	
//	level.raptor thread magic_bullet_shield();
//	
//}

//mission_fail_if_prez_dies()
//{
//	level endon ( "president_in_BT_meat_locker" );
//	while( 1 )
//	{
//		self waittill ( "damage" );
//		if( self.health < 800 )
//			break;
//	}
//	
//	setDvar( "ui_deadquote", &"INVASION_FAIL_PREZ" );
//	maps\_utility::missionFailedWrapper();
//}

wounded_carry_attackers()
{
	//level.wounded_carry_attackers_dead = 0;
	
	//set up all spawners
	//wounded_carry_attackers = getentarray( "wounded_carry_attackers", "script_noteworthy" );
	//array_thread( wounded_carry_attackers, ::add_spawn_function, ::wounded_carry_attackers_counter );
	
	while( ( getaiarray( "axis" ) ).size > 4 )
		wait 1;
		
	wounded_carry_attackers_gas = getentarray( "wounded_carry_attackers_gas", "targetname" );
	array_thread( wounded_carry_attackers_gas, ::spawn_ai );
	
	while( ( getaiarray( "axis" ) ).size > 4 )
		wait 1;
	
	wounded_carry_attackers = getentarray( "wounded_carry_attackers_bus", "targetname" );
	array_thread( wounded_carry_attackers, ::spawn_ai );
	
	
	while( ( getaiarray( "axis" ) ).size > 4 )
		wait 1;
	
	//while( level.wounded_carry_attackers_dead < 6 )
	//	wait 1;
		
	wounded_carry_attackers_TC = getentarray( "wounded_carry_attackers_TC", "targetname" );
	array_thread( wounded_carry_attackers_TC, ::spawn_ai );
	
	//while( level.wounded_carry_attackers_dead < 12 )
	//	wait 1;
		
	//array_thread( wounded_carry_attackers_TC, ::spawn_ai );
}

wells_cover_path()
{
	level.raptor endon ( "death" );
	level.wells endon ( "death" );
	wells_cover_path = getnode( "wells_cover_path", "script_noteworthy" );
	level.wells SetGoalNode( wells_cover_path );
	level.wells waittill( "goal" );
		
	current_node = wells_cover_path;
	while( 1 )
	{
		while( distance( level.wells.origin, level.raptor.origin ) > 300 )
			wait .1;
		
		if( !isdefined( current_node.target ) )
			break;
		new_goal = getnode( current_node.target, "targetname" );
			
		level.wells SetGoalNode( new_goal );
		current_node = new_goal;
		level.wells waittill( "goal" );
	}
}

dialog_keep_guys_off_me()
{
	level endon( "president_in_BT_meat_locker" );
	level.raptor endon( "death" );
	//24 seconds
	wait 6;
	
	//Seal Six-One:	Team, this way! Let's go let's go!	
	level.raptor dialogue_queue( "inv_six_teamthisway" );
	
	wait 5;
	
	//Seal Six-One:	Keep these guys off me!	
	level.raptor dialogue_queue( "inv_six_keepoffme" );
	
	wait 1;
	
	//He's down! 	
	level.taco dialogue_queue( "inv_tco_hesdown" );
	
	wait 5;
	//On me! 	
	level.raptor dialogue_queue( "inv_six_onme" );
	//Go go go! 	
	level.raptor dialogue_queue( "inv_six_gogogo" );
	
	wait 4;
	
	//Stay with us Roach! 	
	//level.raptor dialogue_queue( level.raptor, "inv_six_staywithus" );
}

dialog_regroup_at_nates_nag()
{
	
	flag_wait( "bmp_north_left_dead" );
	flag_wait( "bmp_north_mid_dead" );
	
	diner_backdoor_fight_area = getent( "diner_backdoor_fight_area", "targetname" );
	diner_backdoor_fight_area waittill_volume_dead();
	
	//flag_wait( "diner_enemies_dead" );
	if( flag( "leaving_diner" ) )
		return;
	level endon( "leaving_diner" );
	
	//flag_wait( "diner_enemies_dead" );
	while( 1 )
	{
		wait 2;
		
		//Nice work team. Regroup over here.	
		radio_dialogue( "inv_six_regroup" );
		
		wait 15;
		
		//Taco, Roach, regroup in the restaurant.
		radio_dialogue( "inv_six_regroupinrest" );
		
		wait 15;
	}
}



spawn_wells( start_ent)
{
	if( isdefined( level.wells ) )
		return;
	spawner = getent( "wells", "script_noteworthy" );
	level.wells = spawner spawn_ai();
	
	if( isdefined( start_ent ) )
	{
		wait .5;
	
		level.wells teleport_ent( start_ent );
		level.wells setgoalpos( start_ent.origin );
	}
}

spawn_president()
{
	if( isdefined( level.president ) )
		return;
	president_spawner = getent( "president", "script_noteworthy" );
	level.president = president_spawner spawn_ai();
}

setup_president()
{
	self.has_no_ir = true;
	level.president = self;
	self thread magic_bullet_shield();
	//president = getent( "president", "targetname" );
	
	president_start_node = getent( "president_in_nates_meat_locker", "targetname" );
	self thread maps\_carry_ai::setWounded( president_start_node );

	flag_wait( "move_president_to_prep" );
	president_start_node notify( "stop_wounded_idle" );
	
	president_start_node = getent( "president_in_nates_prep", "targetname" );
	self maps\_carry_ai::setWounded( president_start_node );
}

dialog_house_destroyer_unloading()
{
	flag_wait( "house_destroyer_unloading" );
	autosave_by_name( "unloading" );
	
	//Seal Six-One:	We're spotted! Roach - grab that RPG! Taco, Worm - cover him!	
	level.raptor dialogue_queue( "inv_six_grabrpg" );
}

//dialog_house_destroyer_destroyed()
//{
//	self waittill( "death" );
//	if( !isdefined( self ) )
//		return;
//	//Nice one Roach. 	
//	level.raptor dialogue_queue( "inv_six_niceone" );
//	//level.scr_radio[ "inv_six_niceone" ]					 = "inv_six_niceone";
//}

dialog_incoming_south_side()
{
	//Taco:	Incoming, north side!	
	radio_dialogue( "inv_tco_incomingnorth" );

	//Taco:	Contact to the north!	
	radio_dialogue( "inv_tco_contactnorth" );
}

dialog_incoming_northside()
{
	//Taco:	Incoming, south side!	
	radio_dialogue( "inv_tco_incomingsouth" );

	//Taco:	Contact to the south!	
	radio_dialogue( "inv_tco_contactsouth" );
}

dialog_foot_mobiles()
{
	wait 12;
	//Incoming from the south! Two dozen plus foot mobiles! 	
	radio_dialogue("inv_six_2dozen" );
}

dialog_intro()
{
	//The Russians have everything east of I-95! My sector's gonna fall within the hour! 	
	radio_dialogue("inv_gm1_eastof95" );
	
	//We've lost contact with Annapolis, where is the air support!	
	radio_dialogue("inv_gm2_airsupport" );
	
	//Counterbattery fire is unable to engage! Enemy paratroopers have infiltrated their positions, we are cut off, I repeat we are cut off!	
	radio_dialogue("inv_gm3_cutoff" );
	
	//Broken arrow broken arrow! Drop that thousand pounder on the red smoke, now!	
	radio_dialogue("inv_gm4_brokenarrow" );
	
	//Interrogative, can your Harriers take out the interchange at I-495 and US-50 over?	
	radio_dialogue("inv_gm1_495and50" );
}

player_shooting_nates()
{
	level endon( "player_on_roof" );
	level endon( "crash_objective" );
	flag_wait( "player_shooting_nates" );	
	
	//Seal Six-One:	Check your fire check your fire! Friendlies at 10 o'clock in the purple building.	
	level.raptor thread dialogue_queue( "inv_six_purplebuilding" );
}


dialog_going_to_crash_site()
{
	//On me! 	
	radio_dialogue( "inv_six_onme" );
	
	//Go go go! 	
	radio_dialogue( "inv_six_gogogo" );
}


dialog_waiting_at_crash_site()
{
	last_line = true;
	level endon( "crash_objective" );
	flag_wait( "raptor_at_crash_site" );
	//Get over here! 	
	//radio_dialogue( "inv_six_getoverhere" );
	
	while( 1 )
	{
		wait 10;
		
		if( last_line )
		{
			//Roach, we're at the crash site get over here. 	
			radio_dialogue( "inv_six_crashsite" );
			last_line = false;
		}
		else
		{
			//The crash site is on the north side of Nate's restaurant. 	
			radio_dialogue( "inv_six_northofnates" );
			last_line = true;
		}
	}
}

friendlies_duck_from_house_destroyer()
{
	//pos = getvehiclenode( "get_down", "script_noteworthy" );
	//pos waittill( "trigger" );
	wait 1;
	
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] thread prone_till_flag( "bmp_out_of_sight" );
	}
	
	
	//pos = getvehiclenode( "bmp_out_of_sight", "script_noteworthy" );
	//pos waittill( "trigger" );
	wait 5;
	
	flag_set( "bmp_out_of_sight" );
}


prone_till_flag( msg )
{
	self endon( "death" );
	wait( randomfloatrange( 0, .5 ) );
	self allowedstances( "prone" );
	old_goal = self.goalpos;
	self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	//self setgoalpos( self.origin );
	//self.goalradius = 4;

	flag_wait( msg );

	wait( randomfloatrange( 0, .5 ) );

	self allowedstances( "stand", "prone", "crouch" );
	//self setgoalpos( old_goal );
}

btr_backed_off()
{
	pos = getvehiclenode( "friendlies_move_to_alley", "script_noteworthy" );
	pos waittill( "trigger" );
	
	flag_set( "btr_backed_away" );
	level.house_destroyer notify ( "backed_away" );
	//if( !flag( "entered_alley" ) )
	activate_trigger_with_targetname( "friendlies_hide_in_alley" );
}

hint_drone_steering()
{
	while( !flag( "bmps_from_north_dead" ) )
	{
		level waittill( "player_fired_remote_missile" );
		num = level.bmps_from_north_dead;
		level waittill( "remote_missile_exploded" );
		wait 1;
		if( !( level.bmps_from_north_dead > num ) )
		{
			level.hint_steer_drone_time = gettime();
			level.player thread display_hint( "hint_steer_drone" );
		}
	}
}

wait_till_time_to_destroy_BMPS()
{
	level endon( "leaving_diner" );
	//flag_wait( "diner_enemies_dead" );
	//flag_wait( "diner_enemy_counter_attack_dead" );
	
	diner_backdoor_fight_area = getent( "diner_backdoor_fight_area", "targetname" );
	diner_backdoor_fight_area waittill_volume_dead();
	
	wait 2;//dont nag immediately after picking up control rig
}

dialog_time_to_destroy_BMPS()
{
	level endon ( "bmps_from_north_dead" );
	wait_till_time_to_destroy_BMPS();
	
	if( flag( "bmps_from_north_dead" ) )
		return;
	
	//if( ( flag( "bmp_north_left_dead" ) ) && ( flag( "bmp_north_mid_dead" ) ) )
	//	return;
	
	//Roach, neutralize that enemy armor.	
	radio_dialogue( "inv_six_neutralizearmor" );	

	// get_remotemissile_hint_string() Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
	level.player thread display_hint( level.player get_remotemissile_hint_string( "hint_predator_drone_vs_bmps" ) );

	thread hint_drone_steering();
	
	wait 25;
	
	while( 1 )
	{
		//if( ( flag( "bmp_north_left_dead" ) ) && ( flag( "bmp_north_mid_dead" ) ) )
		//	return;
			
		if( ( flag( "bmp_north_left_dead" ) ) || ( flag( "bmp_north_mid_dead" ) ) )
		{
			r = randomint( 3 );
			if( r == 0 )
			{
				//There's still one BMP left!	
				dialog_time_to_destroy_BMPS_action( "inv_six_stillonebmp" );	

				// get_remotemissile_hint_string() Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
				level.player thread display_hint( level.player get_remotemissile_hint_string( "hint_predator_drone_vs_bmps" ) );
			}
			else if( r == 1 )
			{
				//Waste that BMP now!	
				dialog_time_to_destroy_BMPS_action( "inv_six_wastethatbmpnow" );	

				// get_remotemissile_hint_string() Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
				level.player thread display_hint( level.player get_remotemissile_hint_string( "hint_predator_drone_vs_bmps" ) );
			}
			else
			{
				//Roach, neutralize that enemy armor.	
				dialog_time_to_destroy_BMPS_action( "inv_six_neutralizearmor" );

				// get_remotemissile_hint_string() Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
				level.player thread display_hint( level.player get_remotemissile_hint_string( "hint_predator_drone_vs_bmps" ) );
			}
		}
		else
		{
			if( cointoss() )
			{
				//Seal Six-One:	Roach! Waste those BMPs! Now!	
				dialog_time_to_destroy_BMPS_action( "inv_six_wastebmpsnow" );

				// get_remotemissile_hint_string() Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
				level.player thread display_hint( level.player get_remotemissile_hint_string( "hint_predator_drone_vs_bmps" ) );
			}
			else
			{
				//Destroy those APCs!	
				dialog_time_to_destroy_BMPS_action( "inv_six_destroyapcs" );	

				// get_remotemissile_hint_string() Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
				level.player thread display_hint( level.player get_remotemissile_hint_string( "hint_predator_drone_vs_bmps" ) );
			}
		}
		wait 25;
	}
}

dialog_time_to_destroy_BMPS_action( dialog )
{
	if( flag( "nates_bomb_incoming" ) && !flag( "nates_bombed" ) )
		return;

	radio_dialogue( dialog );
}

dialog_dont_engage_that_APC()
{
	level endon ( "crash_objective" );
	
	pos = getvehiclenode( "dont_engage_dialog", "script_noteworthy" );
	pos waittill( "trigger", apc );
	
	apc waittill_player_lookat_for_time( .4, .99 );
	
	//Seal Six-One:	Team, don’t engage that APC - our objective is the crash site.	
	level.raptor thread dialogue_queue( "inv_six_dontengageapc" );
}

dialog_two_bmps_from_north()
{
	//Seal Six-One:	Taco, be advised, two BMPs coming in from the north.	
	radio_dialogue( "inv_six_bmpsfromnorth" );
	
	//Taco:	Roger that.	
	radio_dialogue( "inv_tco_rogerthat" );
}


dialog_clear_burgertown_nag()
{
	if( flag( "burger_town_lower_cleared" ) )
		return;
	level endon ( "burger_town_lower_cleared" );
	wait 60;
	while( 1 )
	{
		flag_waitopen( "player_in_burgertown" );
		
		//Seal Six-One:	Taco, Roach, we still got hostiles in the Burgertown, move it!	
		radio_dialogue( "inv_six_hostilesinbt" );
		wait 20;
		
		flag_waitopen( "player_in_burgertown" );
		
		//Taco, Roach, we need to move ASAP! Clear that restaurant!	
		radio_dialogue( "inv_six_needtomove" );
		wait 20;
	
		flag_waitopen( "player_in_burgertown" );
		
		//Team, what's the hold up? Secure that restaurant!	
		radio_dialogue( "inv_six_whatsholdup" );
		wait 20;
	}
}
		
//		wait 45;
//		if( !flag( "burger_town_lower_cleared" ) )
//		{
//			//Seal Six-One:	Taco, Roach, we still got hostiles in the Burgertown, move it!	
//			radio_dialogue( "inv_six_hostilesinbt" );
//		}
//		else
//		{
//			if( !flag( "burger_town_roof_cleared" ) )
//			{
//				//Seal Six-One:	Taco, Roach! Clear the Burgertown roof asap!	
//				radio_dialogue("inv_six_clearbtroof" );
//			}
//			else
//				break;
//		}
//	}
//}


spawn_rpg_redshirts()
{
	//if( flag( "president_in_BT_meat_locker" ) )
		group = "friendly_redshirt_rpg_BT_spawners";
	//else
	//	group = "friendly_redshirt_rpg_NATES_spawners";
		
	redshirt_spawn_groups = getentarray( group, "targetname" );
	
	respawns = 5;
	
	while( respawns > 0 )
	{
		farthest_spawner = getfarthest( level.player.origin, redshirt_spawn_groups );
		farthest_spawner.count = 1;
		guy = farthest_spawner spawn_ai();
		respawns--;
		
		if( isalive( guy ) )
			guy waittill( "death" );
		else
			wait 1;
	}
}

setup_rpg_redshirts()
{
	self.big_goal = true;
	//self thread maps\_debug::drawOriginForever();
	self thread smart_roaming_barney();
	//SetThreatBias( "rpg_friendlies", "attack_helis", 10000 );

	self.ignored_by_attack_heli = true;
	self thread magic_bullet_shield();
	
	self waittill_entity_in_range( level.player, 600 );
	
	self.ignored_by_attack_heli = undefined;
	self thread stop_magic_bullet_shield();

	self endon( "death" );
	while( !isalive( level.attack_heli ) )
		wait 1;
	self.combatmode = "no_cover";
	self setentitytarget( level.attack_heli );
	wait 1;
	self.combatmode = "no_cover";
	
	while( isalive( level.attack_heli ) )
		wait 1;
	//wait 5;
	self clearentitytarget();
}

spawn_redshirts( desired_num )
{
	if( !isdefined( desired_num ) )
		desired_num = 3;
	if( flag( "president_in_BT_meat_locker" ) )
		group = "redshirt_spawn_group_BT";
	else
		group = "redshirt_spawn_group";
		
	redshirt_spawn_groups = getstructarray( group, "targetname" );
	farthest = getfarthest( level.player.origin, redshirt_spawn_groups );
	spawners = getentarray( farthest.target, "targetname" );
	println( " selected redshirt group: " + farthest.script_noteworthy );
	
	//closest = getclosest( level.player.origin, redshirt_spawn_groups );
	//redshirt_spawn_groups = array_remove( redshirt_spawn_groups, closest );
	//second_closest = getclosest( level.player.origin, redshirt_spawn_groups );
	//spawners = getentarray( second_closest.target, "targetname" );
	
	guys = [];
	foreach( spawner in spawners )
	{
		if( guys.size < desired_num )
		{
			spawner.count = 1;
			guys[guys.size] = spawner spawn_ai();
		}
	}
	return guys;
}

redshirts_respawn( redshirts_desired )
{
	current_redshirts = [];
	foreach( redshirt in level.redshirts )
	{
		if( isalive( redshirt ) )
			current_redshirts[current_redshirts.size] = redshirt;
	}
	num_desired = redshirts_desired - current_redshirts.size;
	new_guys = [];
	if( num_desired > 0 )
		new_guys = spawn_redshirts( num_desired );
		
	guys = array_merge( current_redshirts, new_guys );
	return guys;
}


taco_goes_to_BT()
{
	flag_wait( "leaving_diner" );
	
	BT_goal = getnode( "taco_in_BT", "script_noteworthy" );
	BT_org = BT_goal.origin;
	BT_goal_volume = getent( "BT_goal_volume", "targetname" );
	
	
	//guy smart_barney( end_flag, end_goal, end_volume );
	level.taco thread smart_barney( "player_in_burgertown", BT_org, BT_goal_volume );
	
	redshirts_desired = 3;
	
	level.redshirts = redshirts_respawn( redshirts_desired );
	
	foreach( redshirt in level.redshirts )
		redshirt thread smart_barney( "player_in_burgertown", BT_org, BT_goal_volume );
}

taco_goes_to_diner()
{
	flag_waitopen( "player_on_roof" );
	wait 2;
	flag_waitopen( "player_inside_nates" );
	
	diner_goal_volume = getent( "diner_goal_volume", "targetname" );
	diner_org = getent( "predator_drone_control", "targetname" ).origin;
	
	//guy smart_barney( end_flag, end_goal, end_volume );
	level.taco thread smart_barney( "player_in_diner", diner_org, diner_goal_volume );
	level.redshirts = spawn_redshirts( 3 );
	foreach( redshirt in level.redshirts )
		redshirt thread smart_barney( "player_in_diner", diner_org, diner_goal_volume );
}



smart_barney_on_raptor( end_goal, end_volume )
{
	self endon( "stop_barney" );
	self endon( "death" );
	self ClearGoalVolume();
	//self thread friendly_adjust_movement_speed();
	self.goalheight = 80;
	self.goalradius = 500;
	//level.taco setgoalentity( level.player );
	self.fixednode = false;
		
	while( !flag( "president_in_BT_meat_locker" ) )
	{
		leader = level.raptor.origin;
		vec = VectorNormalize( end_goal - leader );
		forward = vector_multiply( vec, 400 );
		goal = forward + leader;
		self setgoalpos( goal );
		//println(" player " + level.player.origin + " goal " + forward );
		
		if( !isdefined( self.favoriteenemy ) )
		{
			self.favoriteenemy = get_closest_ai( self.origin, "axis" );
		}
		//check for nearby BMPs
		wait .5;
	}
	//self notify( "stop_adjust_movement_speed" );
	//self.moveplaybackrate = 1.0;
		
	self setgoalpos( end_goal );
	self setgoalvolume( end_volume );
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
	if ( within_fov( level.player.origin, level.player getPlayerAngles(), self.origin, level.cosine[ "60" ] ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	prof_end( "friendly_movement_rate_math" );
	
	return true;
}


taco_goes_to_BT_roof()
{
	level.taco.goalradius = 128;
	level.taco.goalheight = 64;
	level.taco SetGoalNode( getnode( "taco_on_BT_roof", "script_noteworthy" ) );
	
	flag_wait( "president_in_BT_meat_locker" );
	
	level.taco.goalradius = 1024;
}

//set_ammo()
//{
//	if ( (self.classname == "weapon_fraggrenade") || (self.classname == "weapon_flash_grenade") )
//		self ItemWeaponSetAmmo( 1, 0 );
//	else
//		self ItemWeaponSetAmmo( 999, 999 );
//}
//
//delete_if_obj_complete( obj_flag )
//{
//	self endon ( "death" );
//	flag_wait ( obj_flag );
//	self delete();
//}
//
//ammoRespawnThink( flag, type, obj_flag )
//{
//	wait .2; //timing 
//	weapon = self;
//	ammoItemClass = weapon.classname;
//	ammoItemOrigin = ( weapon.origin + (0,0,8) ); //wont spawn if inside something
//	ammoItemAngles = weapon.angles;
//	weapon set_ammo();
//	
//	obj_model = undefined;
//	if ( isdefined ( weapon.target ) )
//	{
//		obj_model = getent ( weapon.target, "targetname" );
//		obj_model.origin = weapon.origin;
//		obj_model.angles = weapon.angles;
//	}
//	
//	if ( type == "flash_grenade" )
//		ammo_fraction_required = 1;
//	else 
//		ammo_fraction_required = .2;
//		
//	if ( isdefined ( flag ) )
//	{
//		//self delete();
//		self.origin = self.origin + (0, 0, -10000);
//		if ( isdefined ( obj_model ) )
//			obj_model hide();
//		
//		flag_wait ( flag );
//		
//		if ( isdefined ( obj_model ) )
//			obj_model show();
//		self.origin = self.origin + (0, 0, 10000);
//		//weapon = spawn ( ammoItemClass, ammoItemOrigin );
//		//weapon.angles = ammoItemAngles;
//		weapon set_ammo();
//	}
//	
//	//if ( isdefined ( obj_model ) )
//	//	obj_model hide();//temp hiding of glowing weapons
//	
//	if ( ( isdefined ( obj_model ) ) && ( isdefined ( obj_flag ) ) )
//		obj_model thread delete_if_obj_complete( obj_flag );
//	
//	weapon waittill ( "trigger" );
//	
//	if ( isdefined ( obj_model ) )
//		obj_model delete();
//	
//	while ( 1 )
//	{
//		wait 1;
//
//		if ( ( level.player GetFractionMaxAmmo( type ) ) < ammo_fraction_required )
//		{
//			while ( distance( level.player.origin, ammoItemOrigin ) < 160 )
//				wait 1;
//	
//			//if ( level.player pointInFov( ammoItemOrigin ) )
//			//	continue;
//	
//			weapon = spawn ( ammoItemClass, ammoItemOrigin, 1 ); //suspended bit flag
//			//weapon = spawn ( "weapon_mp5", ammoItemOrigin );
//			weapon.angles = ammoItemAngles;
//			weapon set_ammo();
//			wait .2;
//			weapon.origin = ( ammoItemOrigin + (0,0,-8) );
//			//weapon.angles = ammoItemAngles;
//			
//			//weapon waittill ( "trigger" );
//			while ( isdefined ( weapon ) )
//				wait 1;
//		}
//	}
//}

set_up_predator_drone_control_pickup()
{
	predator_drone_control = getent( "predator_drone_control", "targetname" );
	predator_drone_control show();
	predator_drone_control glow();
	
	predator_drone_control setCursorHint( "HINT_NOICON" );
	// Press and hold ^3&&1^7 to pick up the turret.
	predator_drone_control setHintString( &"INVASION_DRONE_PICKUP" );
	predator_drone_control makeUsable();
	
	predator_drone_control waittill( "trigger", player );
	
	predator_drone_control playsound( "scn_invasion_controlrig_pickup" );
	thread give_player_predator_drone();
	predator_drone_control stopGlow();
}
	
give_player_predator_drone()
{
	flag_set( "player_has_predator_drones" );
	
	thread dialog_handle_predator_infantry_kills();
//	level.player giveWeapon( "remote_missile_detonator" );
//	level.player SetActionSlot( 4, "weapon", "remote_missile_detonator" );
	level.player maps\_remotemissile::give_remotemissile_weapon( "remote_missile_detonator" );

	predator_drone_control = getent( "predator_drone_control", "targetname" );
	predator_drone_control hide();
	predator_drone_control makeUnusable();	
}

enemy_uses_smoke()
{
	self waittill( "trigger" );
	
	flag_set( "smoke_screen_starting" );
	playfx( getfx( "smokescreen" ), self.origin );
	self thread play_sound_in_space( "smokegrenade_explode_default" );
	//MagicGrenade( "smoke_grenade_american", ( self.origin + (0,0,32) ), self.origin, .1 );
}


dialog_they_are_using_smoke()
{	
	flag_wait( "smoke_screen_starting" );
	wait 7;
	
	//They're using smoke to cover their advance! 	
	radio_dialogue( "inv_tco_usingsmoke" );
	wait 1;
	
	//Seal Six-One:	Team, this is raptor. Switch to thermal optics if you got 'em.	
	radio_dialogue( "inv_six_thermaloptics" );
}



dialog_pickup_drone_control_nag()
{
	last_line = true;
	flag_wait( "player_in_diner" );
	flag_wait( "back_door_attack_start" );
	wait 4;
	//flag_wait( "diner_enemies_dead" );
	//flag_wait( "diner_enemy_counter_attack_dead" );
	diner_backdoor_fight_area = getent( "diner_backdoor_fight_area", "targetname" );
	diner_backdoor_fight_area waittill_volume_dead();
	
	wait 4;
	
	while( !flag( "player_has_predator_drones" ) )
	{
		if( last_line )
		{
			//Taco:	Roach - get the control rig for the UAV!	
			level.taco dialogue_queue( "inv_tco_controlrig" );
			last_line = false;
		}
		else
		{
			//Taco:	Roach - I got you covered! Pick up the control rig! 	
			level.taco dialogue_queue( "inv_tco_pickupcontrolrig" );
			last_line = true;
		}
		wait 15;
	}
}	


dialog_nates_bombing_reaction()
{
	if( flag( "taco_goes_to_roof" ) )
		return;
	level endon( "taco_goes_to_roof" );
	wait 3;
	//Taco:	raptor you still there?	
	radio_dialogue( "inv_tco_stillthere" );
	wait 1;

	//Seal Six-One:	<cough> Taco, Roach, new plan.	
	radio_dialogue( "inv_six_newplan" );

	//Seal Six-One:	Secure the Burgertown and get on the <cough> roof.	
	radio_dialogue( "inv_six_secureburgertown" );
	
	flag_set( "time_to_clear_burgertown" );

	//Seal Six-One:	Everyone on this net, listen up, we're moving the package asap.	
	radio_dialogue("inv_six_listenup" );

	//Seal Six-One:	We need to get the hell out of this building before those fast movers make another pass.	
	radio_dialogue( "inv_six_anotherpass" );
	
	flag_set( "nates_bombed" );
}

dialog_hellfire_attack_reaction()
{
	wait 4.5;
	if( flag( "player_on_roof" ) )
	{
		//Worm:	What the hell was that?!	
		radio_dialogue( "inv_wrm_whatwasthat" );
	}
	wait 1;
	
	while( flag( "player_on_roof" ) )
	{
		r = randomint( 3 );
		if( r == 0 )
		{
			//Seal Six-One:	Roach! Get the <garble> off the roof!	
			radio_dialogue( "inv_six_offtheroof" );
		}
		if( r == 1 )
		{
			//Get off the roof! 	
			radio_dialogue( "inv_six_getoffroof2" );
		}
		if( r == 2 )
		{
			//Get down from the roof now! 	
			radio_dialogue( "inv_six_getoffroofnow" );
		}
		
		wait( randomfloatrange( 1, 2 ) );
	}
}

hellfire_attacks()
{
	thread hellfire_attacks_after_player_got_off_roof();
	level endon ( "player_on_roof" );
	level.player endon ( "death" );
	targets = getentarray( "hellfire_attack_target", "targetname" );
	
	//first in front
	first_tgt = get_closest_to_player_view( targets );
	rocket = MagicBullet( "remote_missile_not_player_invasion", ( level.uav.origin + (0,0,-128) ), first_tgt.origin );
	wait ( randomfloatrange( 3, 5 ) );
	
	//second closest to view but not the same, & diff
	remainingtargets = array_remove( targets, first_tgt );
	targetpos = get_closest_to_player_view( remainingtargets );
	//targetpos = remainingtargets[ randomint( remainingtargets.size ) ];
	rocket = MagicBullet( "remote_missile_not_player_invasion", ( level.uav.origin + (0,0,-128) ), targetpos.origin );
	wait ( randomfloatrange( 3, 5 ) );
	
	//third random & diff
	remainingtargets = array_remove( targets, targetpos );
	targetpos = remainingtargets[ randomint( remainingtargets.size ) ];
	rocket = MagicBullet( "remote_missile_not_player_invasion", ( level.uav.origin + (0,0,-128) ), targetpos.origin );
	wait ( randomfloatrange( 3, 5 ) );
	
	
	//forth random & diff
	remainingtargets = array_remove( targets, targetpos );
	targetpos = remainingtargets[ randomint( remainingtargets.size ) ];
	rocket = MagicBullet( "remote_missile_not_player_invasion", ( level.uav.origin + (0,0,-128) ), targetpos.origin );
	wait ( randomfloatrange( 3, 5 ) );
	
	//fifth kills player or hits roof
	//if( !flag( "player_inside_nates" ) )
	if( flag( "player_on_roof" ) )
	{
		rocket_target = level.player.origin;
		rocket = MagicBullet( "remote_missile_not_player_invasion", ( level.uav.origin + (0,0,-128) ), rocket_target );
		while( isdefined( rocket ) )
			wait .05;
		if( flag( "player_on_roof" ) )
			level.player dodamage( ( level.player.health + 1000 ), rocket_target );
	}
}

hellfire_attacks_after_player_got_off_roof()
{
	wait .2;//timing issue with start point
	flag_waitopen ( "player_on_roof" );
	
	//sixth kill sentry
	ceiling_dust = getentarray( "ceiling_dust", "targetname" );
	if( sentry_is_on_roof() )
	{
		level waittill( "hellfire" );
		rocket_target = level.obj_sentry.origin;
		rocket = MagicBullet( "remote_missile_not_player_invasion", ( level.uav.origin + (0,0,-128) ), rocket_target );
		array_thread( ceiling_dust, ::drop_dust );
		while( isdefined( rocket ) )
			wait .05;
		level.obj_sentry notify ( "deleted" );
		level.obj_sentry delete();
		//level.obj_sentry dodamage( ( level.obj_sentry.health + 1000 ), rocket_target );
	}
	
	//remainder hit roof (add ceiling dust)
	targets = getentarray( "hellfire_attack_target_roof", "targetname" );
	while( 1 )
	{
		level waittill( "hellfire" );
		targetpos = targets[ randomint( targets.size ) ];
		target_org = targetpos.origin;
		//println( " origin " + target_org );
		rocket = MagicBullet( "remote_missile_not_player_invasion", ( level.uav.origin + (0,0,-128) ), target_org );
		array_thread( ceiling_dust, ::drop_dust );
	}
}


sentry_is_on_roof()
{
	if( isdefined( level.player.placingSentry ) )
		return false;
	if( !isdefined( level.obj_sentry ) )
		return false;
	//if( level.obj_sentry.health <= 0 )
	//	return false;
	roof_volume = getent( "roof_volume", "targetname" );
	if( level.obj_sentry isTouching( roof_volume ) )
		return true;
	else
		return false;
}

drop_dust()
{
	wait 3;
	playfx( getfx( "ceiling_dust" ), self.origin );
}


dialog_taco_sees_uav_op()
{
	level notify( "hellfire" );
	wait 4;
	
//I have a visual on an enemy UAV operator remote-piloting those missiles!	
	radio_dialogue( "inv_tco_uavop" );
	
//He's inside that diner to the west, over!	
	radio_dialogue( "inv_tco_uavop2" );
	
//Ramirez! Get over there, and kill that SOB!	
	radio_dialogue( "inv_six_killthatsob" );
	
//I'm sending part of the squad to help you out! Go!	
	radio_dialogue( "inv_six_killthatsob2" );

	level notify( "hellfire" );

	
	flag_set( "time_to_go_get_UAV_control" );
	
	if( flag( "player_inside_nates" ) )
		autosave_by_name( "go_to_diner2" );
		
	wait 3;
	
	level notify( "hellfire" );
	
	wait 4;
	
	//if( flag( "player_inside_nates" ) )
	//{
	//	//I have a visual on an enemy UAV operator remote-piloting those missiles!	
	//	radio_dialogue( "inv_tco_uavop" );
	//
	//	//He's inside that diner to the west, over!	
	//	radio_dialogue( "inv_tco_uavop2" );
	//
	//	//Ramirez! Get over there, and kill that SOB!	
	//	radio_dialogue( "inv_six_killthatsob" );
	//
	//	//I'm sending part of the squad to help you out! Go!	
	//	radio_dialogue( "inv_six_killthatsob2" );
	//}
}

setup_gas_station_truck()
{
	gas_station_truck = spawn_vehicle_from_targetname_and_drive( "gas_station_truck" );
	
	wait 4;
	//Seal Six-One:	Incoming! Truck 12 o’clock!
	level.raptor dialogue_queue( "inv_six_truck12" );
}

//friendlies_peal_back()
//{
//	wait 8; 
//	friendlies = get_force_color_guys( "allies", "r" );
//	foreach( friend in friendlies )
//	{
//		if( isalive( friend ) )
//		{
//			friend set_force_color( "o" );
//			wait 2;
//		}
//	}
//	
//	flag_wait( "juggernaut_dead" );
//	
//	foreach( friend in friendlies )
//	{
//		if( isalive( friend ) )
//		{
//			friend set_force_color( "r" );
//		}
//	}
//	
//	//He's down! 	
//	radio_dialogue( "inv_tco_hesdown" );
//	
//	//Nice one guys. 	
//	radio_dialogue( "inv_six_niceoneguys" );
//}

dialog_bmp_hasnt_spotted_us()
{
	wait 2;
	
	if( isalive( level.house_destroyer ) )
	{
		level notify( "dialog_bmp_hasnt_spotted_us" );
		//Seal Six-One:	That BMP hasn’t spotted us! Hang to the right and stay behind it!	
		level.raptor dialogue_queue( "inv_six_hangright" );
	}
	
	
	if( isalive( level.house_destroyer ) )
	{
		//Hang right and stay behind it!	
		level.raptor dialogue_queue( "inv_six_staybehind" );
	}
}


spawn_tangled_chute_struggler()
{
	flag_wait( "take_point" );
	
	tangled_parachute_guy = getent( "tangled_parachute_guy", "script_noteworthy" );
	guy = tangled_parachute_guy spawn_ai();
}


//dialog_take_point()
//{
//	level endon ( "entered_alley" );
//	level.house_destroyer waittill_either ( "death", "backed_away" );
//	
//	flag_wait( "take_point" );
//	
//	//Team the crashed heli at 12 o'clock is our objective. 	
//	level.raptor dialogue_queue( "inv_six_ourobjective" );
//	
//	//Seal Six-One:	Roach, take point - we're cuttin' to the right.	
//	level.raptor dialogue_queue( "inv_six_takepoint" );
//}





dialog_sentry_nags()
{
	//level endon ( "sentry_in_position" );
	flag_wait( "wells_intro_done" );
	level endon ( "player_on_roof" );
	
	
	wait 5;
	
	while( ! flag( "player_on_roof" ) )
	{
		if( flag( "truck_guys_retreat" ) )
			return;
		
		
		if( cointoss() )
		{
			//Seal Six-One:	Roach, use the ladder in the kitchen and get to the roof.	
			radio_dialogue( "inv_six_ladderinkitchen" );
		}
		else
		{
			//Seal Six-One:	Roach this is raptor. Get to the roof, there's a maintenance ladder in the kitchen.	
			radio_dialogue( "inv_six_gettoroof" );
		}
		wait 15;
	}
/*	
	while( ! flag( "sentry_in_position" ) )
	{
		//Seal Six-One:	Roach, you on the roof yet? Get that sentry gun online and make sure its pointed south.	
		radio_dialogue( "inv_six_onroofyet" );
		
		wait 15;
	}
*/
}

taco_to_meat_locker()
{	
	meat_locker_taco = getnode( "meat_locker_taco", "script_noteworthy" );
	level.taco disable_ai_color();
	level.taco setgoalnode ( meat_locker_taco );
	level.taco.goalradius = 16;	
}


move_raptor_wells_and_worm()
{
	//wells_inside = getnode( "wells_inside", "script_noteworthy" );
	wells_inside = getnode( "wells_kitchen", "targetname" );
	if( isalive( level.wells ) ) 
	{
		level.wells disable_ai_color();
		level.wells setgoalnode ( wells_inside );
		level.wells.goalradius = 64;
		level.wells.fixednode = true;
		//level.wells.goalradius = 190;
		//level.wells.fixednode = false;
	}
	
	//wait 2;
	
	//flag_wait( "wells_intro_done" );
	//raptor_inside = getnode( "raptor_inside", "script_noteworthy" );
	raptor_inside = getnode( "raptor_kitchen", "targetname" );
	level.raptor disable_ai_color();
	level.raptor setgoalnode ( raptor_inside );
	level.raptor.goalradius = 64;
	level.raptor.fixednode = true;
	//level.raptor.goalradius = 190;
	//level.raptor.fixednode = false;
	
	//wait 2;
	
	if( isalive( level.worm ) ) 
	{
		worm_inside = getnode( "worm_inside", "script_noteworthy" );
		level.worm disable_ai_color();
		level.worm setgoalnode ( worm_inside );
		level.worm.goalradius = 190;
		level.worm.fixednode = false;
	}
}



should_break_get_smoke()
{
	clipCount = level.player GetWeaponAmmoStock( "smoke_grenade_american" );
	if( clipCount < 1 )
		return false;
	else
		return true;
}

should_break_throw_smoke()
{
	if( flag( "threw_smoke" ) )
		return true;
	else
		return false;
}

//should_break_get_semtex()
//{
//	clipCount = level.player GetWeaponAmmoStock( "semtex_grenade" );
//	if( clipCount < 1 )
//		return false;
//	else
//		return true;
//}
//
//should_break_throw_semtex()
//{
//	if( flag( "threw_semtex" ) )
//		return true;
//	else
//		return false;
//}

//	level.player thread display_hint( "hint_throw_semtex" );
//	level.player thread display_hint( "hint_get_semtex" );
//watch_for_semtex_throws()

dialog_semtex_that_bmp()
{
	level endon( "btr_smoke_starting" );
	//level.house_destroyer endon( "death" );
	level endon ( "entered_alley" );
	
	dialog = [];
		//We're spotted! Roach - grab those Semtex explosives! Taco, Worm - cover him!	
	//dialog[dialog.size] = "inv_six_grabrpg";
		//Roach - there’s explosives by that supply drop! Move!   	
	dialog[dialog.size] = "inv_six_rpgsupplydrop";
		//Pick up the explosives by the supply drop!      
	dialog[dialog.size] = "inv_six_pickup";
		//Roach get more explosives from the supply drop!	
	dialog[dialog.size] = "inv_six_getmore";
	dialog_start = 0;
	
	
	throw_dialog = [];
	//Ramirez, throw some Semtex on that BMP!
	throw_dialog[throw_dialog.size] = "inv_six_throwsemtex";		
	//Ramirez, get some Semtex on that BMP!
	throw_dialog[throw_dialog.size] = "inv_six_getsemtex";
	//Ramirez, destroy that BMP with Semtex!
	throw_dialog[throw_dialog.size] = "inv_six_destroy";	
	throw_dialog_start = 0;
	
	flag_wait( "house_destroyer_unloading" );
	
	wait 4;
	
	
	level.house_destroyer endon ( "backed_away" );
	while( 1 )
	{
		//if( distance ( level.house_destroyer.origin, level.player.origin ) > 2000 )
		//	break;
			
		//player_has_semtex = level.player GetWeaponAmmoStock( "semtex_grenade" );
		player_has_semtex = level.player GetWeaponAmmoStock( "smoke_grenade_american" );
		if( player_has_semtex )
		{
			if( !flag( "threw_smoke" ) )
			{
				thread watch_for_smoke_throws();
				
				level.raptor dialogue_queue( throw_dialog[throw_dialog_start] );
				throw_dialog_start++;
				if( throw_dialog_start >= throw_dialog.size )
					throw_dialog_start = 0;
					
				level.player thread display_hint_timeout( "hint_throw_smoke", 5 );
			}
		}
		else
		{
			level.player thread display_hint_timeout( "hint_get_smoke", 5 );
			level.raptor dialogue_queue( dialog[dialog_start] );
			dialog_start++;
			if( dialog_start >= dialog.size )
				dialog_start = 0;
		}
			
		wait 10;
	}
}


watch_for_smoke_throws()
{
	flag_clear( "threw_smoke" );
	while( 1 )
	{
		level.player waittill ( "grenade_fire", grenade, weaponName );
		if ( weaponname == "smoke_grenade_american" )
		{
			break;
		}
	}
	flag_set( "threw_smoke" );
	wait 5;
	flag_clear( "threw_smoke" );
}


wait_till_btr_smoked()
{	
	level endon( "btr_smoke_starting" );
	thread hint_if_smoke_too_far();
	smoke_position = getvehiclenode( "house_destroyer_backwards_path", "targetname" ).origin;	

	while ( 1 )
	{
		level.player waittill ( "grenade_fire", grenade, weaponName );
		if ( weaponname == "smoke_grenade_american" )
		{
			tracker = spawn ("script_origin", (0,0,0));
			grenade thread track_grenade_origin( tracker );
			grenade thread flag_if_close_to_btr( tracker, smoke_position );
		}
	}
}


track_grenade_origin( tracker )
{
	level endon ( "btr_smoked" );
	self endon ( "death" );
	while ( 1 )
	{
		tracker.origin = self.origin;
		wait .05;
	}
}

flag_if_close_to_btr( tracker, smoke_position )
{
	level endon ( "btr_smoke_starting" );
	
	self waittill( "death" );
	
	if( distance( tracker.origin, smoke_position ) < 400 )
		thread dialog_goto_alley();
	else
		level notify( "btr_smoke_too_far" );
}

hint_if_smoke_too_far()
{
	if( flag( "house_destroyer_moving_back" ) )
		return;
	level endon ( "house_destroyer_moving_back" );
	
	//while( !flag( "btr_smoke_starting" ) )
	//{
		level waittill( "btr_smoke_too_far" );
		if( !flag( "btr_smoke_starting" ) )
			display_hint_timeout( "hint_smoke_too_far", 5 );
		
	//	wait 10;
	//}
}

should_break_smoke_too_far()
{
	if( flag( "btr_smoke_starting" ) )
		return true;
	else
		return false;
}

dialog_goto_alley()
{
	flag_set( "btr_smoke_starting" );
	
	wait 10;
	
	autosave_by_name( "btr_smoked" );
	flag_set( "btr_smoked" );
	activate_trigger_with_targetname( "friendlies_hide_in_alley" );
	//Use the cover of the smoke to run past the BTR into the alley!	
	level.raptor dialogue_queue( "inv_six_coverofsmoke" );
	
	wait 5;
	
	if( flag( "entered_alley" ) )
		return;
	
	//Ramirez! Come to alley!	
	level.raptor dialogue_queue( "inv_six_cometoalley" );
}


diner_window_traverses()
{
	diner_window_traverses = getent( "diner_window_traverses", "targetname" );
	if( !isdefined( diner_window_traverses ) )
		return;
	diner_window_traverses disconnectpaths();
	
	flag_wait( "crash_objective" );
	
	diner_window_traverses MoveZ( -1000, .1, 0, 0 );
	
	diner_window_traverses connectpaths();
}

truck_group_enemies_count_deaths()
{
	level.truck_group_enemies_count_lives++;
	level.truck_group_enemies_alive++;
	self waittill( "death" );
	level.truck_group_enemies_count_deaths++;
	level.truck_group_enemies_alive--;
	level notify ( "truck_guy_died" );
}

truck_group_enemies_setup_retreat()
{
	self endon ( "death" );
	flag_wait( "truck_guys_retreat" );
	
	if( isdefined( self.target ) )
		self setgoalpos( getent( self.target, "targetname" ).origin );
	else
		self setgoalpos( getent( "truck_guy_retreat_goal", "targetname" ).origin );
		
	self.goalradius = 32;
	self waittill( "goal" );
	while( self cansee ( level.player ) )
		wait 1;
	self kill();
}


bank_enemies_setup_retreat()
{
	self endon ( "death" );
	flag_wait( "bank_guys_retreat" );
	
	self setgoalpos( getent( "north_trucks_retreat_point", "targetname" ).origin );
	
	self.ignoreme = true;
	self.goalradius = 32;
	self waittill( "goal" );
	while( self cansee ( level.player ) )
		wait 1;
	self kill();
}

//waittill_sentry_moved()
//{
//	self thread mission_fail_if_sentry_dies();
//	
//	south_side_of_roof = getent( "south_side_of_roof", "targetname" );
//	while( 1 )
//	{
//		if( self isTouching( south_side_of_roof ) )
//			break;
//		wait .5;
//	}
//	
//	flag_set ( "sentry_in_position" );
//}

mission_fail_if_sentry_dies()
{
	level endon ( "sentry_in_position" );
	self waittill ( "death" );
	
	setDvar( "ui_deadquote", &"INVASION_FAIL_SENTRY" );
	maps\_utility::missionFailedWrapper();
}


mig_fly_overs()
{
		migs = spawn_vehicles_from_targetname_and_drive( "first_fast_movers" );
		
		wait 7;
		
		//Seal Six-One:	Team be advised, enemy has close air support operating in our AO.	
		//level.raptor dialogue_queue( "inv_six_closeairsupport" );
	
		//wait 3;
		
		flag_wait( "wells_intro_done" );
		
		migs = spawn_vehicles_from_targetname_and_drive( "first_fast_movers" );
}



one_bmp_from_south()
{
	bmp = thread spawn_vehicle_from_targetname_and_drive( "crash_objective_bmp" );
	bmp thread turret_spotlight();
	bmp thread maps\_vehicle::damage_hints();
	
	bmp endon ( "death" );
	
	
	current = getent( "west_side", "targetname" );
	bmp SetTurretTargetVec( current.origin );

	pos = getvehiclenode( "first_volley_at_nates", "script_noteworthy" );
	pos waittill( "trigger" );
	
	bmp bmp_fires_first_volley_at_nates();

	pos = getvehiclenode( "crash_obj_bmp_in_pos", "script_noteworthy" );
	pos waittill( "trigger" );

	bmp vehicle_setspeed( 0, 15, 15 );

	bmp bmp_fires_at_nates();
	//array_thread( getvehiclenodearray( "new_target", "script_noteworthy" ), ::new_target_think );

	bmp vehicle_setspeed( 10, 3, 3 );
	
	bmp thread bmp_fires_more_volleys_at_nates();
	
	bmp waittill( "reached_end_node" );
	
	//end_if_cant_see, no_misses 
	bmp thread bmp_turret_attack_player( false, false );
	
	flag_wait( "crash_objective" );
	bmp delete();
}

two_bmps_from_north()
{
	level.bmp_north_mid = spawn_vehicle_from_targetname_and_drive( "nate_attacker_mid" );
	level.bmp_north_left = spawn_vehicle_from_targetname_and_drive( "nate_attacker_left" );
	array_thread( getvehiclenodearray( "new_target", "script_noteworthy" ), ::new_target_think );
	
	bmps = [];
	bmps[ bmps.size ] = level.bmp_north_mid;
	bmps[ bmps.size ] = level.bmp_north_left;
	
	thread aim_predator_drone_at_btrs();
	thread dialog_bmp_spotted_you();
	thread dialog_destroyed_btr_with_uav();
	//thread dialog_bmp_lost_you();
	
	foreach( vehicle in bmps )
	{
		vehicle thread watch_for_player();
		vehicle thread maps\_remotemissile::setup_remote_missile_target();
		vehicle thread save_on_death();
		vehicle thread ent_flag_init( "spotted_player" );
		vehicle thread turret_spotlight();
		vehicle thread maps\_vehicle::damage_hints();
	}

	
	//bmps[ 0 ] thread dialog_bmp_lost_you( bmps[ 1 ] );//one thread for both
	//bmps[ 1 ] thread dialog_bmp_lost_you( bmps[ 0 ] );
	
	return bmps;
}

aim_predator_drone_at_btrs()
{
	while( 1 )
	{
		level waittill( "starting_predator_drone_control" );
	
		bmps = [];
		if( isalive( level.bmp_north_mid ) )
			bmps[ bmps.size ] = level.bmp_north_mid;
		if( isalive( level.bmp_north_left ) )
			bmps[ bmps.size ] = level.bmp_north_left;
	
		if( bmps.size == 0 )
		{
			level.uavTargetEnt = undefined;
			return;
		}
	
		if( bmps.size > 1 )
			level.uavTargetEnt = ( get_closest_to_player_view( bmps ) );
		else
			level.uavTargetEnt = bmps[0];
	}
}

save_on_death()
{
	self waittill( "death" );
	
	//level.cansave = undefined;
	if( self ent_flag( "spotted_player" ) )
		flag_clear ("bmp_has_spotted_player" );
	//thread autosave_by_name( "go_to_diner" );
	
	level notify( "bmp_died" );
	level.bmps_from_north_dead++;
}


dialog_bmp_spotted_you()
{
	level endon ( "player_has_predator_drones" );
	num = randomint( 3 );
	while( 1 )
	{
		flag_wait ("bmp_has_spotted_player" );
		//self ent_flag_wait( "spotted_player" );
		
		switch( num )
		{
			case 0:
				//Roach take cover! That BMP's spotted you!	
				dialog_bmp_spotted_you_action( "inv_six_bmpspottedyou" );
				break;
			case 1:
				//Roach take cover! One of the BMPs has a visual on you!	
				dialog_bmp_spotted_you_action( "inv_six_bmphasavisual" );
				break;
			case 2:
				//Get behind something solid! That BMP's got you in his sights!	
				dialog_bmp_spotted_you_action( "inv_six_behindsolid" );
				break;
		}
		num++;
		if( num > 2 )
			num = 0;
			
			
		wait 10;
	}
}

dialog_bmp_spotted_you_action( dialog )
{
	if( flag( "player_in_diner" ) )
		return;
	if( flag( "player_in_burgertown" ) )
		return;
	if( flag( "player_on_burgertown_roof" ) )
		return;
		
	radio_dialogue( dialog );
}



//save_halfway_to_diner( bmps )
//{
//	flag_wait( "player_halfway_to_diner" );
//	
//	if( 
//	( !bmps[1] ent_flag( "spotted_player" ) || !isalive( bmps[1] ) ) 
//	&& ( !bmps[0] ent_flag( "spotted_player" ) || !isalive( bmps[0] ) ) 
//	)
//	{
//		autosave_by_name( "halfway_to_diner" );
//		return;
//	}
//	
//	if( bmps[0] ent_flag( "spotted_player" ) && isalive( bmps[0] ) )
//	{
//			bmps[0] add_wait( ::ent_flag_wait, "spotted_player" );
//			bmps[0] add_endon( "death" );
//			do_wait_any();
//			
//			if( !bmps[1] ent_flag( "spotted_player" ) || !isalive( bmps[1] )  )
//			{
//				autosave_by_name( "halfway_to_diner" );
//				return;
//			}
//	}
//	
//	
//	if( bmps[1] ent_flag( "spotted_player" ) && isalive( bmps[1] ) )
//	{
//			bmps[1] add_wait( ::ent_flag_wait, "spotted_player" );
//			bmps[1] add_endon( "death" );
//			do_wait_any();
//			
//			if( !bmps[0] ent_flag( "spotted_player" ) || !isalive( bmps[0] ) )
//			{
//				autosave_by_name( "halfway_to_diner" );
//				return;
//			}
//	}
//}

dialog_bmp_lost_you()
{
	level endon ( "player_has_predator_drones" );
	level.player endon( "death" );
	min_time_between = 10;//was 5
	
		
	while( 1 )
	{
		flag_wait ("bmp_has_spotted_player" );
		dialog_on_clear( "inv_six_bmplostyou" );
		
		wait min_time_between;
		
		flag_wait ("bmp_has_spotted_player" );
		dialog_on_clear( "inv_six_bmplostyoumove" );
	
		wait min_time_between;
		
		flag_wait ("bmp_has_spotted_player" );
		dialog_on_clear( "inv_six_bmplostyougo" );
		
		wait min_time_between;
	}
}

dialog_on_clear( dialog )
{
	level endon( "bmp_died" );
	flag_waitopen ("bmp_has_spotted_player" );
	wait 4;
	flag_waitopen ("bmp_has_spotted_player" );
	
	radio_dialogue( dialog );
}

watch_for_player()
{
	self endon( "death" );
	self.turret_busy = false;
	
	while( 1 )
	{
		wait .05;
		if( flag ( "player_inside_nates" ) )
			continue;
		if( flag ( "player_in_diner" ) )
			continue;
		if( flag ("bmp_has_spotted_player" ) )
			continue;
		if( distance( self.origin, level.player.origin ) > 2400 )
			continue;
		if( distance( self.origin, level.player.origin ) < level.min_btr_fighting_range )
			continue;
		tag_flash_angles = self getTagAngles( "tag_flash" );
		if( !within_fov( self.origin, tag_flash_angles, level.player.origin, level.cosine[ "25" ] ) )
			continue;
		if( !can_see_player( level.player ) )
			continue;

		//thread draw_line_for_time( self.origin, level.player.origin, 1, 0, 0, 1 );
		flag_set ("bmp_has_spotted_player" );//level flag for both btrs
		self notify( "new_target" );//clears ambient target shooting
		self.turret_busy = true;
		self ent_flag_set( "spotted_player" );
		//self Vehicle_SetSpeed( 0, 10 );
		
		//saw player, now miss for 2 bursts
		miss_player( level.player );
		wait( randomfloatrange( 0.8, 2.4 ) );
    	
		miss_player( level.player );
		wait( randomfloatrange( 0.8, 2.4 ) );
    	
		//if player is still exposed then hit him
		while ( can_see_player( level.player ) )
		{
			fire_at_player( level.player );
			wait( randomfloatrange( 2, 3 ) );
		}
			
		self clearturrettarget();
		self.turret_busy = false;
		self ent_flag_clear( "spotted_player" );
		//self Vehicle_SetSpeed( 10, 1 );
		flag_clear ("bmp_has_spotted_player" );//level flag for both btrs
	}
}


new_target_think()
{
	level endon( "bmps_from_north_dead" );
	targets = getentarray( self.script_linkto, "script_linkname" );
	while( 1 )
	{
		//self waittillmatch( "trigger", vehicle );
		self waittill( "trigger", vehicle );
		
		if( !isalive( vehicle ) )
			return;
		if( vehicle.turret_busy )
			continue;
		
		vehicle notify( "new_target" );
		
		vehicle setturrettargetent( targets[0] );
		
		thread btr_fire_at_targets( vehicle );
	}
	//vehicle clearturrettarget();
}

btr_fire_at_targets( vehicle )
{
	vehicle endon( "new_target" );
	//vehicle endon( "unload" );
	vehicle endon( "death" );
	
	vehicle waittill( "turret_on_target" );
		
	while( 1 )
	{
		s = randomintrange( 4, 6 );
		for ( j = 0; j < s; j++ )
		{
				vehicle fireWeapon();
				wait .2;
		}
		wait( randomfloatrange( 1, 2 ) );
	}
}

/*
bmp_target_think()
{
	while( 1 )
	{
			
		//targets = get_array_of_closest( org, array, excluders, max, maxdist, mindist )
		if( level.bmp_targets.size < 1 )
			break;
		bmp = level.bmps [ randomint( level.bmps.size ) ];
		turret_angle = bmp getTagAngles( "tag_flash" );
		vec = anglestoforward( turret_angle );
		vec *= 100;
		pos = vec + bmp.origin;
		
		target = get_highest_dot( bmp.origin, pos, level.bmp_targets );
		//closest_index = get_closest_index( bmp.origin, level.bmp_targets, undefined );
		
		bmp setturrettargetent( target );
		level.bmp_targets = array_remove( level.bmp_targets, target );
		//level.bmp_targets = array_remove_index( level.bmp_targets, closest_index );
		bmp waittill( "turret_on_target" );
		//wait( randomfloatrange( 1, 2 ) );
		
		s = randomintrange( 4, 6 );
		for ( j = 0; j < s; j++ )
		{
				bmp fireWeapon();
				wait .2;
		}
		bmp clearturrettarget();
	}
}
*/



rush_restaurant_enemies_setup()
{
	self endon( "death" );
	nates_restaurant_goal = getent( "nates_restaurant_goal", "targetname" );
	self ClearGoalVolume();
	self.goalheight = 100;//was 800
	
	self enable_danger_react( 5 );
	self setgoalpos ( nates_restaurant_goal.origin );
	self.goalradius = 4000;
	self.aggressivemode = true;
	
	
	flag_wait( "truck_guys_retreat" );
	
	self setgoalpos( getent( "truck_guy_retreat_goal", "targetname" ).origin );
		
	self.goalradius = 32;
	self waittill( "goal" );
	while( self cansee ( level.player ) )
		wait 1;
	self kill();
}

truck_group_enemies_setup()
{
	self waittill( "jumpedout" );
	level endon( "truck_guys_retreat" );
	self endon( "death" );
	nates_restaurant_goal = getent( "nates_restaurant_goal", "targetname" );
	self.goalheight = 100;//was 800
	
	self enable_danger_react( 5 );
	
	
	if( randomint( 3 ) > 0 )
	{
		self setgoalpos ( nates_restaurant_goal.origin );
		self.goalradius = nates_restaurant_goal.radius;
		
		cover_time = randomintrange( 1, 22 );
		wait cover_time;
		self setgoalpos ( self.origin );
		self.goalradius = 900;
		wait randomfloatrange( 2, 4 );
		
		self setgoalpos ( nates_restaurant_goal.origin );
		self.goalradius = nates_restaurant_goal.radius;
	}
	else
	{
		self setgoalpos ( nates_restaurant_goal.origin );
		self.goalradius = 4000;
		//self.aggressivemode = true;//too easy
	}
}


BT_nates_attackers_setup()
{
	while( 1 )
	{
		self waittill( "enemy" );
		if( isplayer( self.enemy ) )
		{
			self.goalradius = 3000;
			break;
		}
	}
}

alley_nates_attackers_setup()
{		
	while( 1 )
	{
		self waittill( "enemy" );
		if( isplayer( self.enemy ) )
		{
			self.goalradius = 3000;
			break;
		}
	}
}


setup_hunter_enemies()
{
	goals = getentarray( "closest_goal_radius", "targetname" );
	level.current_goal = getclosest( level.player.origin, goals );

	level.hunter_enemies = [];
	
	current_enemies = getaiarray( "axis" );
	array_thread( current_enemies, ::create_hunter_enemy );
	
	bank_enemies = getentarray( "bank_enemies", "targetname" );
	gas_station_enemies = getentarray( "gas_station_enemies", "targetname" );
	taco_enemies = getentarray( "taco_enemies", "targetname" );
	array_thread( bank_enemies, ::add_spawn_function, ::create_hunter_enemy );
	array_thread( gas_station_enemies, ::add_spawn_function, ::create_hunter_enemy );
	array_thread( taco_enemies, ::add_spawn_function, ::create_hunter_enemy );
	
	
	array_thread( bank_enemies, ::add_spawn_function, ::setup_predator_deaths );
	array_thread( gas_station_enemies, ::add_spawn_function, ::setup_predator_deaths );
	array_thread( taco_enemies, ::add_spawn_function, ::setup_predator_deaths );
	
	thread maintain_closest_goal( goals );
}


predator_death_func()
{
	if ( isdefined( self.damageMod ) && self.damageMod == "MOD_PROJECTILE_SPLASH" &&
		 isdefined( self.lastAttacker ) && isdefined( self.lastAttacker.fired_hellfire_missile ) )
		self.skipDeathAnim = true;
		
	return false;
}


setup_predator_deaths()
{
	self.deathFunction = ::predator_death_func;
}

maintain_closest_goal( goals )
{
	while ( 1 )
	{
		closest_goal = getclosest( level.player.origin, goals );
		//only goal enemies to one of the players and assume they stay together
		//also its cool for player2 to feel hidden from the hunters
		if ( level.current_goal != closest_goal )
		{
			level.current_goal = closest_goal;
			move_hunters_to_new_goal( closest_goal );
		}
		wait 1;
	}
}

create_hunter_enemy()
{
	self.goalradius = 2048;
	self.goalheight = 512;
	level.hunter_enemies[ self.unique_id ] = self;
	self setgoalpos( level.current_goal.origin );
	self.pathrandompercent = 200;
	self enable_danger_react( 5 );

	self waittill( "death" );

	level.hunter_enemies[ self.unique_id ] = undefined;
}

move_hunters_to_new_goal( closest_goal )
{
	waittillframeend;
	//waittillframeend because you may be in the part of the frame that is before 
	//the script has received the "death" notify but after the AI has died.

	foreach ( enemy in level.hunter_enemies )
		enemy setgoalpos( closest_goal.origin );
}



wounded_carry_attackers_counter()
{
	self waittill ( "death" );
	level.wounded_carry_attackers_dead++;
}

setup_wounded_carry_attackers()
{
	self endon ( "death" );
	self.aggressivemode = true;
	self.useChokePoints = false;
	
	self waittill( "goal" );
	self.goalradius = 2000;
	self waittill( "goal" );
	self.goalradius = 2000;
}

setup_diner_backdoor_attackers()
{
	self endon( "death" );
	self.aggressivemode = true;
	self.useChokePoints = false;
	
	wait 12;
	
	self.goalradius = 100;
	self.favoriteenemy = level.player;
	self setgoalentity( level.player );
	
	//wait 8;
	//self.goalradius = 100;
}

setup_BT_enemy_defenders()
{
	self endon ( "death" );
	self.combatMode = "ambush";
	self.grenadeawareness = .9;
	flag_wait( "player_in_burgertown" );
	wait 8;
	self.combatMode = "cover";
	self setgoalentity( level.player );
	self.goalradius = 100;
}

nates_defenders_setup()
{
	self endon( "death" );
	//self.threatbias = 3000;
	self thread magic_bullet_shield();
	
	flag_wait( "player_on_roof" );
	self stop_magic_bullet_shield();
	//wait 1;
	//self kill();
}


//setup_ramirez()
//{
//	//self.threatbias = 3000;
//	self thread magic_bullet_shield();
//	
//	flag_wait( "player_on_roof" );
//	self stop_magic_bullet_shield();
//	self.goalradius = 1500;
//}
//
//setup_collins()
//{
//	//self.threatbias = 3000;
//	self thread magic_bullet_shield();
//	
//	flag_wait( "player_on_roof" );
//	self stop_magic_bullet_shield();
//	self.goalradius = 1500;
//}

setup_wells()
{
	level.wells = self;
	self.animname = "wells";
	self thread magic_bullet_shield();
	
	//flag_wait( "wells_intro_done" );
	//self thread stop_magic_bullet_shield();
	
	level.wells setgoalnode( getnode( "wells_intro_node", "targetname" ) );
	level.wells.goalradius = 16;
	
	flag_wait( "move_president_to_prep" );
	
	wells_in_nates_prep = getent( "wells_in_nates_prep", "targetname" );
	level.wells setgoalpos( wells_in_nates_prep.origin );
}

setup_worm()
{
	level.worm = self;
	self.animname = "worm";
}

setup_taco()
{
	level.taco = self;
	self.animname = "taco";
	self thread magic_bullet_shield();
}

setup_raptor()
{
	level.raptor = self;
	self.animname = "raptor";
	self thread magic_bullet_shield();
	
	flag_wait( "move_president_to_prep" );
	
	level.raptor.goalradius = 64;
	raptor_prep = getent( "raptor_in_nates_prep", "targetname" );
	level.raptor setgoalpos( raptor_prep.origin );
}


//plane_start_drop()
//{
//	self waittill( "trigger", other );
//	other notify( "start_drop" );
//}
//
//plane_stop_drop()
//{
//	self waittill( "trigger", other );
//	other notify( "stop_drop" );
//}


is_west_group( group_name )
{
	if( group_name == "ambient_paradrop3" )
		return true;
	if( group_name == "ambient_west_group3" )
		return true;
	if( group_name == "ambient_west_group2" )
		return true;
	return false;
}

paradrops_ambient()
{
	flag_wait_either( "leaving_gas_station", "crash_objective" );
	
	drop_groups = [];
	drop_groups[drop_groups.size] = "ambient_paradrop1";
	drop_groups[drop_groups.size] = "ambient_paradrop2";
	drop_groups[drop_groups.size] = "ambient_paradrop3";
	drop_groups[drop_groups.size] = "ambient_west_group3";
	drop_groups[drop_groups.size] = "ambient_west_group2";
	drop_groups[drop_groups.size] = "ambient_south_group2";
	drop_groups[drop_groups.size] = "ambient_south_group3";
	drop_groups[drop_groups.size] = "ambient_east_group2";
	drop_groups[drop_groups.size] = "ambient_east_group3";
	drop_groups[drop_groups.size] = "ambient_north_group1";
	drop_groups[drop_groups.size] = "ambient_north_group2";
	drop_groups[drop_groups.size] = "ambient_north_group3";
	drop_groups[drop_groups.size] = "curved_mig_flight1";
	//drop_groups[drop_groups.size] = "first_fast_movers";
	drop_groups[drop_groups.size] = "paradrop_escort";
	
	drop_groups = array_randomize( drop_groups );
	selected = 0;

	
	north_groups = [];//towards bank
	north_groups[north_groups.size] = "ambient_north_group1";
	north_groups[north_groups.size] = "ambient_north_group2";
	north_groups[north_groups.size] = "ambient_north_group3";
	
	south_groups = [];//towards BT
	south_groups[south_groups.size] = "ambient_paradrop2";
	south_groups[south_groups.size] = "ambient_south_group2";
	south_groups[south_groups.size] = "ambient_south_group3";
	
	west_groups = [];//towards diner
	west_groups[west_groups.size] = "ambient_paradrop3";
	west_groups[west_groups.size] = "ambient_west_group3";
	west_groups[west_groups.size] = "ambient_west_group2";
	
	
	east_groups = [];//towards nates
	east_groups[east_groups.size] = "ambient_paradrop1";
	east_groups[east_groups.size] = "ambient_east_group2";
	east_groups[east_groups.size] = "ambient_east_group3";
	
	
	while( 1 )
	{
		planes = undefined;
		dir_selection = undefined;
		old_selection = undefined;
		
		if( isdefined( level.obj_direction ) )
		{
			if( level.obj_direction == "east" )
				dir_selection = east_groups[ randomint( east_groups.size ) ];
			if( level.obj_direction == "north" )
				dir_selection = north_groups[ randomint( north_groups.size ) ];
			if( level.obj_direction == "south" )
				dir_selection = south_groups[ randomint( south_groups.size ) ];
			if( ( level.obj_direction == "west" ) && !flag( "player_is_near_houses" ) )
				dir_selection = west_groups[ randomint( west_groups.size ) ];
			
			if( isdefined( dir_selection ) )
			{
				planes = getentarray( dir_selection, "targetname" );
				println( "     z: ambient paradrop: " + dir_selection );
			}
		}
		if( !isdefined( planes ) )//no obj direction
		{
			if( selected >= drop_groups.size )
				selected = 0;
			
			group_name = drop_groups[selected];
			
			if( flag( "player_is_near_houses" ) && is_west_group( group_name ) )
			{
				selected++;
				continue;
			}
			println( "     %%%% ambient paradrop: " + group_name );
			
			planes = getentarray( drop_groups[selected], "targetname" );
			old_selection = selected;
			
			selected++;
		}
		
		first_plane = true;
		antonov = false;
		foreach( plane in planes )
		{
			if( plane.classname == "script_vehicle_antonov" )
				antonov = true;
				
			if( antonov )
			{
				//only the first of the antonovs plays the sound.
				if( first_plane )
				{
					plane thread paradrop( first_plane );
					first_plane = false;
				}
				else
				{
					plane thread paradrop();
				}
			}
			else
			{
				plane thread maps\_vehicle::spawn_vehicle_and_gopath();
			}
		}
		if( !antonov )//jets only fly over once
		{
			drop_groups = array_remove( drop_groups, drop_groups[old_selection] );
		}
		
		wait 20;//was 30
		
		if ( GetDvar( "invasion_minspec" ) == "1" )
			wait 80;
	}
}

paradrop_vehicle()
{
	airplane_spawner = undefined;
			
	self waittill( "trigger" );
	targets = getentarray( self.target, "targetname" );
	for( i = 0 ; i < targets.size ; i++ )
	{
		//if( !isdefined ( tgt.script_noteworthy ) )
		//	continue;
		//if( tgt.script_noteworthy == "airplane" )
		if( i == 0 )
		{
			first_plane = true;
			targets[i] thread paradrop( first_plane );
		}
		else
		{
			targets[i] thread paradrop();
		}
	}
}

//paradrop_bmp()
//{
//	airplane = self thread maps\_vehicle::spawn_vehicle_and_gopath();
//	airplane ent_flag_init( "start_drop" );
//	airplane ent_flag_init( "stop_drop" );
//
//	airplane ent_flag_wait( "start_drop" );
//	println( "do BMP drop " );
//	thread drop_bmp();
//}

drop_bmp()
{
	chute = spawn_anim_model( "bmp_chute_paradrop" );
	chuteA = spawn_anim_model( "paradrop_cargo_tank_chuteA" );
	chuteB = spawn_anim_model( "paradrop_cargo_tank_chuteB" );
	chuteC = spawn_anim_model( "paradrop_cargo_tank_chuteC" );
	bmp = spawn_anim_model( "bmp_paradrop" );
	
	bmp linkto( self );
	chute linkto( self );
	chuteA linkto( self );
	chuteB linkto( self );
	chuteC linkto( self );
	
	self thread anim_single_solo( chute, "bmp_chute_paradrop" );
	self thread anim_single_solo( chuteA, "paradrop_cargo_tank_chuteA" );
	self thread anim_single_solo( chuteB, "paradrop_cargo_tank_chuteB" );
	self thread anim_single_solo( chuteC, "paradrop_cargo_tank_chuteC" );
	self anim_single_solo( bmp, "bmp_paradrop" );
	
	chute delete();
	chuteA delete();
	chuteB delete();
	chuteC delete();
	bmp delete();
}

paradrop( first_plane )
{
	/*
	spawner_right = undefined;
	spawner_left = undefined;
	links = self get_links();
	targets = getentarray( links[ 0 ], "script_linkname" );
	foreach( tgt in targets )
	{
		if( !isdefined ( tgt.script_noteworthy ) )
			continue;
		if( tgt.script_noteworthy == "paradrop_guy_right" )
			spawner_right = tgt;
		if( tgt.script_noteworthy == "paradrop_guy_left" )
			spawner_left = tgt;
	}
	*/
	
	assert( isdefined( level.paradropper_left ) );
	assert( isdefined( level.paradropper_right ) );
	
	airplane = self thread maps\_vehicle::spawn_vehicle_and_gopath();
	if( isdefined ( first_plane ) )
		airplane playloopsound( "veh_jet_passenger_slow" );
	airplane.script_vehicle_selfremove = 1;
	airplane ent_flag_init( "start_drop" );
	airplane ent_flag_init( "stop_drop" );
	
	airplane endon( "stop_drop" );
	
	drop_time = 16;
	if( isdefined ( self.script_duration ) )
		drop_time = self.script_duration;
	
	airplane ent_flag_wait( "start_drop" );
	//println( "start drop, airplane num: " + links[0] );
	println( "start drop, airplane num: " );
	
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "drop_bmp" )
	{
		airplane thread drop_bmp();
		wait 2;
	}
	
	while( 1 )
	{
		level.paradropper_right.count = 1;
		level.paradropper_left.count = 1;
		paradrop_guy_left = level.paradropper_left spawn_ai();
		paradrop_guy_left thread setup_paradrop_guy_left ( airplane, drop_time );
		
		paradrop_guy_right = level.paradropper_right spawn_ai();
		paradrop_guy_right thread setup_paradrop_guy_right ( airplane, drop_time );
		
		wait ( randomfloatrange( .4, .8 ) );
	}
}


setup_paradrop_guy_left( paradrop_airplane, drop_time )
{
	//time = gettime();
	level.droppers++;
	//println("    droppers = " + level.droppers );
	self.health = 1;
	self.ignoreme = true;
	chute = spawn_anim_model( "distant_parachute_guy" );
	self linkto( paradrop_airplane );
	chute linkto( paradrop_airplane );
	if( cointoss() )
	{
		paradrop_airplane thread anim_single_solo( chute, "distant_parachute_guy_left1" );
		paradrop_airplane thread anim_generic( self, "distant_parachute_guy_left1" );
	}
	else
	{
		paradrop_airplane thread anim_single_solo( chute, "distant_parachute_guy_left2" );
		paradrop_airplane thread anim_generic( self, "distant_parachute_guy_left2" );
	}
	wait drop_time;//anim time is 16.9
	chute delete();
	if( isalive ( self ) )
		self delete();
	level.droppers--;
	level.dropped++;
	//drop_time = ( gettime() - time );
	//println("    DROPPED = " + level.dropped + " time: " + drop_time );
}

setup_paradrop_guy_right( paradrop_airplane, drop_time )
{
	//time = gettime();
	level.droppers++;
	//println("    droppers = " + level.droppers );
	self.health = 1;
	self.ignoreme = true;
	chute = spawn_anim_model( "distant_parachute_guy" );
	self linkto( paradrop_airplane );
	chute linkto( paradrop_airplane );
	if( cointoss() )
	{
		paradrop_airplane thread anim_single_solo( chute, "distant_parachute_guy_right1" );
		paradrop_airplane thread anim_generic( self, "distant_parachute_guy_right1" );
	}
	else
	{
		paradrop_airplane thread anim_single_solo( chute, "distant_parachute_guy_right2" );
		paradrop_airplane thread anim_generic( self, "distant_parachute_guy_right2" );
	}
	wait drop_time;//anim time is 16.9
	chute delete();
	if( isalive ( self ) )
		self delete();
	level.droppers--;
	level.dropped++;
	//drop_time = ( gettime() - time );
	//println("    DROPPED = " + level.dropped + " time: " + drop_time );
}


setup_shotgun_guy2()
{
	humvee_opening_node = getent("humvee_opening", "targetname" );
	humvee_opening_node anim_generic( self, "invasion_opening_hummer1_soldier2" );

	self.allowdeath = true;
	self.a.nodeath = true;
	self kill();
}

setup_backseat_right_guy2()
{
	humvee_opening_node = getent("humvee_opening", "targetname" );
	humvee_opening_node anim_generic( self, "invasion_opening_hummer1_soldier1" );

	self.allowdeath = true;
	self.a.nodeath = true;
	self kill();
}


setup_player_humvee_driver()
{
	humvee_opening_node = getent("humvee_opening", "targetname" );
	humvee_opening_node anim_generic( self, "invasion_opening_hummer2_soldier1" );
	//println( "worm done" );
}

btr80_notetrack_fire( guy )
{
	level.humvee_destroyer fireWeapon();
	//println( "fire" );
	level notify ( "humvee_destroyer_fired" );
}

//ammo_cache_guy_setup()
//{
//	using_supply_crate = getent ( "using_supply_crate", "targetname" );
//	self.animname = "generic";
//	self.allowdeath = true;
//	self.health = 1;
//	//chair_guy teleport ( chair_guy_origin.origin );
//	//anim_loop_solo( guy, anime, ender, tag )
//	using_supply_crate thread anim_loop_solo(self, "airdrop_idles", "stop_idle", undefined);
//	
//	level.player waittill_entity_in_range( self, 800 );
//	using_supply_crate notify ( "stop_idle" );
//}

fire_at_chain( current )
{
	self endon( "death" );
	while( 1 )
	{
		self SetTurretTargetVec( current.origin );

		house_destroyer_fire( current.origin );
		exploder( current.script_prefab_exploder );
	
		if( !isdefined( current.target ) )
			break;
		next = getent( current.target, "targetname" );
		if( !isdefined( next ) )
			break;
		current = next;
	}
}

bmp_fires_first_volley_at_nates()
{
	self endon( "death" );
	current = getent( "north_side_low", "targetname" );
	
	self SetTurretTargetVec( current.origin );
	self waittill( "turret_on_target" );
	
	self fire_at_chain( current );

	//wait 2;
	
	current = getent( "north_side_high", "targetname" );
	
	self SetTurretTargetVec( current.origin );
	self waittill( "turret_on_target" );
	
	self fire_at_chain( current );
}

bmp_fires_more_volleys_at_nates()
{
	self endon( "reached_end_node" );
	self endon( "death" );
	targets = getentarray( "hellfire_attack_target_roof", "targetname" );
	while( 1 )
	{
		wait randomfloatrange( 1, 3 );
		target_origin = targets[ randomint ( targets.size ) ];
		self SetTurretTargetVec( target_origin.origin );
		shots = randomintrange( 3, 6 );
		for( i = 0 ; i < shots ; i++ )
		{
			self fireWeapon();
			wait .2;
		}
	}
}

setup_nates_kitchen_ladder_clip()
{
	nates_kitchen_ladder_clip = getent( "nates_kitchen_ladder_clip", "targetname" );
	
	
	while( 1 )
	{
		//ladder works
		nates_kitchen_ladder_clip notsolid();
		
		flag_wait( "player_on_roof" );
		while( level.player istouching( nates_kitchen_ladder_clip ) )
			wait 1;
		
		//ladder blocked
		nates_kitchen_ladder_clip solid();
		
		flag_waitopen( "player_on_roof" );
	}
}

setup_bt_ktichen_ladder_clip()
{
	bt_ktichen_ladder_clip = getent( "bt_ktichen_ladder_clip", "targetname" );

	while( 1 )
	{
		//ladder works
		bt_ktichen_ladder_clip notsolid();
		
		flag_wait( "player_on_burgertown_roof" );
		while( level.player istouching( bt_ktichen_ladder_clip ) )
			wait 1;
		
		//ladder blocked
		bt_ktichen_ladder_clip solid();
		
		flag_waitopen( "player_on_burgertown_roof" );
	}
}

bmp_fires_at_nates()
{
	current = getent( "west_side", "targetname" );
	
	self SetTurretTargetVec( current.origin );
	self waittill( "turret_on_target" );
	self fire_at_chain( current );

	//wait 2;
}

add_org_to_tank_targets( ent, org, exploder )
{
	array = [];
	array[ "exploder" ] = exploder;
	array[ "origin" ] = org;
	ent.targets[ ent.targets.size ] = array;
}


roof_parachute_landing_guy_humvee()
{
	roof_parachute_landing_guy_humvee = getent( "humvee_ride_roof_landing", "targetname" );
	level.roof_parachute_landing_guy_humvee = roof_parachute_landing_guy_humvee spawn_ai();
	if( isdefined( level.animated_ride_in ) )
		level.roof_parachute_landing_guy_humvee.ignoreme = true;
	level.roof_parachute_landing_guy_humvee waittill( "death" );
	
	//println( "re aim" );
	if( isdefined( level.animated_ride_in ) )
		return;
	turret = level.humvee_front.mgturret[ 0 ];
	target = getent( "humvee_destroyer_init_target", "targetname" );
	turret_guy = turret getTurretOwner();
	turret_guy.ignoreall = true;
	turret thread animscripts\hummer_turret\common::set_manual_target( target );
	
	level waittill ( "humvee_destroyer_fired" );
	
	turret_guy kill();
}

humvee_explosion1( guy )
{
	playfx( getfx( "humvee_explosion" ), level.humvee_front.origin );
}

humvee_explosion2( guy )
{
	//playfx( getfx( "humvee_explosion" ), level.humvee_front.origin );
	
	level.humvee_front maps\_vehicle::godoff();
	level.humvee_front kill();
}

humvee_destroyer_action()
{
	self endon( "death" );
	self thread turret_spotlight();
	self thread maps\_vehicle::damage_hints();
	
	//humvee_destroyer_init_target = getent( "humvee_destroyer_init_target", "targetname" );
	//self setturrettargetvec( humvee_destroyer_init_target.origin );
	
	//self waittill( "reached_end_node" );
	//level.humvee_front maps\_vehicle::godon();
	//level.humvee_player maps\_vehicle::godon();
	
	level.humvee_front.health = 30000;
	level.humvee_player.health = 30000;
	//self thread impact_causes_physics();
	
	self setturrettargetent( level.humvee_front, (0,0,40) );
	
	wait 1.5;
	
	level notify( "humvee_blows_up" );//starts animation
	
	
	//self waittill( "turret_on_target" );
	wait 2.5;
	
	turret_guys = getentarray( "turret_guy", "script_noteworthy" );
	foreach( guy in turret_guys )
	{
		if( isalive( guy ) )
			guy kill();
	}
	
	for ( j = 0; j < 2; j++ )
	{
		physicsSphere( level.humvee_front.origin );
		self fireWeapon();
		wait .2;
	}
	//level.humvee_front maps\_vehicle::godoff();
	//level.humvee_front kill();
	
	self setturrettargetent( level.humvee_player, (0,0,40) );
	wait 1;
	
	
	//self waittill( "turret_on_target" );
	//wait 1;
	
	for ( j = 0; j < 3; j++ )
	{
		self fireWeapon();
		wait .2;
	}
	
	level.humvee_player maps\_vehicle::godoff();
	level.humvee_player kill();
	//playfx( getfx( "humvee_explosion" ), level.humvee_player.origin );
	
	self setturrettargetent( level.humvee_front, (0,0,40) );
	wait 1;
	
	for ( j = 0; j < 5; j++ )
	{
		self fireWeapon();
		wait .2;
	}
	
	//this vehicle is killed via notetrack function humvee_explosion2()
	//level.humvee_front playfx( getfx( "humvee_explosion" ), self );
	
	humvee_destroyer_fires_at_pillars_and_player();
}

humvee_destroyer_fires_at_pillars_and_player()
{
	self endon( "death" );
	ent = spawnstruct();
	ent.targets = [];
	org = getstruct( "pillar1", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 9990 );
	org = getstruct( "pillar2", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 9991 );
	org = getstruct( "pillar3", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 9992 );
	
	self setturrettargetvec( ent.targets[ 0 ][ "origin" ] );
	wait 1.5;
	
	for ( i = 0; i < ent.targets.size; i++ )
	{
		self setturrettargetvec( ent.targets[ i ][ "origin" ] );
		//self waittill( "turret_on_target" );
	
		house_destroyer_fire( ent.targets[ i ][ "origin" ] );
		Earthquake( 0.3, .3, ent.targets[ i ][ "origin" ], 850 );
		
		if( ent.targets[ i ][ "exploder" ] > 0 )
			exploder( ent.targets[ i ][ "exploder" ] );
		//wait .1;
	}
	
	wait 1;
	
	self ent_flag_init( "spotted_player" );
	thread bmp_turret_attack_player( false, true );
	
	flag_wait( "start_house_destroyer" );
	self delete();
}

setup_house_destroyer()
{
	self thread turret_spotlight();
	self thread maps\_vehicle::damage_hints();
	self thread house_destroyer_move();
	self.damageIsFromPlayer = true;
	//self thread impact_causes_physics();
	self endon( "death" );
	
	ent = spawnstruct();
	ent.targets = [];
	org = getstruct( "bh_roof", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 12 );
	org = getstruct( "bh_corner", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 13 );
	org = getstruct( "bh_garage_left", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 10 );
	org = getstruct( "bh_garage_right", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 11 );
	
	
	for ( i = 0; i < ent.targets.size; i++ )
	{
		self setturrettargetvec( ent.targets[ i ][ "origin" ] );
		//self waittill( "turret_on_target" );
	
		house_destroyer_fire( ent.targets[ i ][ "origin" ] );
		
		if( ent.targets[ i ][ "exploder" ] > 0 )
			exploder( ent.targets[ i ][ "exploder" ] );
	}
	
	//targets[ 4 ] = spawnstruct();
	//targets[ 4 ].pos = getent( "cop_car", "targetname" );
	//targets[ 4 ].num = -1;
	
	t = getstruct( "cop_car", "targetname" );
	self setturrettargetvec( t.origin );
	self waittill( "turret_on_target" );
	
	while( !flag( "house_destroyer_stage2" ) )
	{
		s = randomintrange( 4, 6 );
		for ( j = 0; j < s; j++ )
		{
			self fireWeapon();
			wait .2;
		}
		delay = ( randomintrange( 40, 60 ) );
		for ( d = 0; d < delay; d++ )
		{
			if( flag( "house_destroyer_stage2" ) )
				break;
			wait ( .05 );
		}
	}
	
	
	ent = spawnstruct();
	ent.targets = [];
	org = getstruct( "roof_corner", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 4 );
	org = getstruct( "bh_corner", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 2 );
	org = getstruct( "big_windows", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 1 );
	org = getstruct( "back_windows", "targetname" ).origin;
	add_org_to_tank_targets( ent, org, 3 );
	
	thread animate_burning_tree();
	thread maps\invasion_fx::tree_fire_light();
	for ( i = 0; i < ent.targets.size; i++ )
	{
		self setturrettargetvec( ent.targets[ i ][ "origin" ] );
		//self waittill( "turret_on_target" );
	
		house_destroyer_fire( ent.targets[ i ][ "origin" ] );
		
		if( ent.targets[ i ][ "exploder" ] > 0 )
			exploder( ent.targets[ i ][ "exploder" ] );
	}
	
	self endon( "stop_shooting" );
	thread house_destroyer_shoot_agro_player();
	
	t = getstruct( "beemer", "targetname" );
	self setturrettargetvec( t.origin );
	self waittill( "turret_on_target" );
	
	s = randomintrange( 4, 6 );
	for ( j = 0; j < s; j++ )
	{
		self fireWeapon();
		wait .2;
	}
	
	t = getstruct( "barrier_car", "targetname" );
	self setturrettargetvec( t.origin );
	self waittill( "turret_on_target" );
	
	for ( i = 0; i < 3; i++ )
	{
		s = randomintrange( 4, 6 );
		for ( j = 0; j < s; j++ )
		{
			self fireWeapon();
			wait .2;
		}
	}
	
	
	
	//targets[ 4 ].pos = getent( "driveway_car", "targetname" );
	//targets[ 4 ].pos = getent( "barrier_car", "targetname" );
	
	/*
	while( 1 )
	{
		t = randomint( targets.size );
		self setturrettargetent( targets[ t ].pos );
		self waittill( "turret_on_target" );
	
		house_destroyer_fire( targets[ t ].pos.origin );
			
		wait( .7 );
	}
	*/
}

house_destroyer_shoot_agro_player()
{
	self endon( "death" );
	self endon( "stop_shooting" );
	
	while( 1 )
	{		
		if( within_fov( self.origin, self.angles, level.player.origin, level.cosine[ "60" ] ) )
			if ( SightTracePassed( ( self.origin + (0,0,64) ), level.player geteye(), false, self ) )
				break;
		wait 1;
	}
	
	thread bmp_turret_attack_player();
}

house_destroyer_move()
{
	self endon( "death" );
	self ent_flag_init( "spotted_player" );
	
	house_destroyer_first_path = getVehicleNode( "house_destroyer_first_path", "targetname" );
	self startPath( house_destroyer_first_path );
	//self waittill( "reached_end_node" );
	
	flag_wait( "house_destroyer_stage2" );
	
	house_destroyer_path = getVehicleNode( "house_destroyer_path", "targetname" );
	self startPath( house_destroyer_path );
	self waittill( "reached_end_node" );
	
	level.player waittill_entity_in_range_or_timeout( self, 950, 4 );
	//level.player waittill_entity_in_range( self, 950 );
	
	flag_set( "house_destroyer_unloading" );
	
	self thread vehicle_unload();
	
	//add get down dialog
	//self setturrettargetent( level.player );
	
	
	wait 6;
	//self waittill( "turret_on_target" );
	
	//self thread bmp_door_close();
	
	thread bmp_turret_attack_player();
	
	wait 16;
	flag_wait( "take_point" );
	
	
	bmp_bad_places = getentarray( "bmp_bad_places", "script_noteworthy" );
	foreach( place in bmp_bad_places )
	{
		BadPlace_Cylinder( "", 20, place.origin, place.radius, 300 );
		
	}
	
	flag_set( "house_destroyer_moving_back" );
	house_destroyer_backwards_path = getVehicleNode( "house_destroyer_backwards_path", "targetname" );
	self startPath( house_destroyer_backwards_path );
	self vehicle_wheels_backward();
	
	flag_wait( "leaving_gas_station" );
	self notify( "stop_shooting" );
	
	self delete();
}

house_destroyer_fire( center )
{
	//self fireWeapon();
	physicsSphere( center );
	self fireWeapon();
	wait .2;
	
//	s = randomintrange( 1, 2 );
//	for ( j = 0; j < s; j++ )
//	{
//		self fireWeapon();
//		wait .2;
//	}
}

//impact_causes_physics()
//{
//	for( ;; )
//	{
//		self waittill( "projectile_impact", weaponName, position, radius );
//		thread physicsSphere( position );
//	}
//}

physicsSphere( center )
{
	assert( isdefined( center ) );
	wait 0.1;
	//PhysicsExplosionSphere( <position>, <outer radius>, <inner radius>, <magnitude> )
	physicsExplosionSphere( center, 200, 100, 4.0 );
}


bmp_turret_attack_player( end_if_cant_see, no_misses )
{
	if( !isdefined( end_if_cant_see ) )
		end_if_cant_see = false;
		
	if( !isdefined( no_misses ) )
		no_misses = false;
	
	self notify( "stop_shooting" );
	//self thread debug_bmp_hit_player();
	self endon( "stop_shooting" );
	self endon( "death" );
	self endon( "delete" );
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
				self ent_flag_clear( "spotted_player" );
				flag_clear ("bmp_has_spotted_player" );
				self notify( "stop_shooting" );
			}
		}
		
		//fire_at_player( player );
	}
}

debug_bmp_hit_player()
{
	self endon ( "death" );
	while( 1 )
	{
		level.player waittill( "damage", amount, who );
		if( who == self )
			println( "         bmp damaged player" );
	}
}

fire_at_player( player )
{
	//level.cansave = false;
	burstsize = randomintrange( 3, 5 );
	println("         **HITTING PLAYER, burst: " + burstsize );
	fireTime = .2;
	for ( i = 0; i < burstsize; i++ )
	{
		self setturrettargetent( player, randomvector( 20 ) + ( 0, 0, 32 ) );//randomvec was 50
		self fireweapon();
		wait fireTime;
	}
	//level.cansave = undefined;
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

can_see_player( player )
{
	if( flag( "player_inside_nates" ) )
		return false;
	
	if( flag( "player_in_diner" ) )
		return false;
	
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


end_of_script()
{

	// End of current level.
	iprintlnbold( &"SCRIPT_DEBUG_LEVEL_END" );
}

flag_save( _flag )
{
	flag_wait( _flag );
	
	autosave_by_name( "hello" );;
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
	level notify( "moving " + objName );
	level endon( "moving " + objName );
	
	objective = level.objectives[objName];
	objective.loc = objLoc;
	level.obj_pos = objLoc;
	objective_position( objective.id, level.obj_pos );
}


setObjectiveLocation_nearest_enemy( objName )
{
	level notify( "moving " + objName );
	level endon( "moving " + objName );
	objective = level.objectives[objName];
	closest_enemy = undefined;
	setObjectiveWaypoint( objName, &"INVASION_WAYPOINT_HOSTILES" );
	north_trucks_retreat_point = getent( "north_trucks_retreat_point", "targetname" );
	
	while( objective.state != "done" )
	{
		enemies = getaiarray( "axis" );
		if( enemies.size < 1 )
		{
			level.obj_pos = north_trucks_retreat_point.origin;
			objective_position( objective.id, level.obj_pos );
			wait 3;
		}
		else
		{
			enemy_positions = [];
			foreach( guy in enemies )
				enemy_positions[ enemy_positions.size ] = guy.origin;
			level.obj_pos = AveragePoint( enemy_positions );
			objective_position( objective.id, level.obj_pos + (0,0,70) );

			//closest_enemy = getclosest( level.player.origin, enemies );
			//level.obj_pos = closest_enemy.origin + (0,0,70);
			//Objective_OnEntity( objective.id, closest_enemy, (0,0,70) );
			//closest_enemy waittill( "death" );
			
			wait 2.2;
		}
		//if( isalive( closest_enemy ) )
		//	closest_enemy waittill( "death" );
	}
}

setObjectiveWaypoint( objName, text )
{
	objective = level.objectives[objName];
	if( isdefined( text ) )
		Objective_SetPointerTextOverride( objective.id, text );
	else
		Objective_SetPointerTextOverride( objective.id );
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
	//	level.obj_pos = objEnt.origin;
	//	objective_position( objective.id, level.obj_pos );
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

set_threatbias_group( group )
{
	assert( threatbiasgroupexists( group ) );
	self setthreatbiasgroup( group );
}


bmps_from_north_dead()
{
	flag_wait( "bmp_north_left_dead" );
	flag_wait( "bmp_north_mid_dead" );
	
	flag_set( "bmps_from_north_dead" );
	level notify ( "bmps_from_north_dead" );
}

//drone_hint()
//{
//	if( !flag( "diner_enemies_dead" ) && !flag( "leaving_diner" ) )
//		level waittill_either ( "leaving_diner", "diner_enemies_dead" );
//	
//	wait 2;
//	
//	if( flag( "bmps_from_north_dead" ) )
//		return;
//	level.player thread display_hint( "hint_predator_drone" );
//	
//	while( !flag( "bmps_from_north_dead" ) )
//	{
//		level waittill( "player_fired_remote_missile" );
//		num = level.bmps_from_north_dead;
//		level waittill( "remote_missile_exploded" );
//		wait 1;
//		if( !( level.bmps_from_north_dead > num ) )
//			level.player thread display_hint( "hint_steer_drone" );
//	}
//}

should_break_use_drone_vs_bmps()
{
	break_hint = false;
	if( isdefined( level.player.is_flying_missile ) )
		break_hint = true;
	if( level.player getCurrentWeapon() == "remote_missile_detonator" )
		break_hint = true;
	if( flag ( "bmps_from_north_dead" ) )
		break_hint = true;
	
	return break_hint;	
}

should_break_use_drone()
{
	break_hint = false;
	if( isdefined( level.player.is_flying_missile ) )
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

magic_glass_breaker()
{
	toweaken = getdvarfloat( "glass_damageToWeaken" );
	todestroy = getdvarfloat( "glass_damageToDestroy" );
	bullets = ( toweaken + todestroy ) / 100;
	trgt = getent( self.target, "targetname" );
	for( i = 0; i < bullets; i++ )
	{
		magicbullet( "nosound_magicbullet", self.origin, trgt.origin );
	}
}


UAVRigAiming()
{
	level.uav endon ( "death" );
	for ( ;; )
	{
		if ( IsDefined( level.uavTargetEnt ) )
			targetPos = level.uavTargetEnt.origin;
		else if ( IsDefined( level.uavTargetPos ) )
			targetPos = level.uavTargetPos;
		else
			targetpos = ( -553.753, -2970, 2369.84 );  // you could put this in invasion.map if you'd like.
			

		angles = VectorToAngles( targetPos - level.uav.origin );

		level.uavRig MoveTo( level.uav.origin, 0.10, 0, 0 );
		level.uavRig RotateTo( ANGLES, 0.10, 0, 0 );
		wait 0.05;
	}
}


cleanse_the_world()
{
	volume = getent( "house_area_volume", "targetname" );
	
	entities = getentarray();
	
	ignore_classnames = [];
	ignore_classnames[ "script_vehicle_corpse" ] = true;
	ignore_classnames[ "script_model" ] = true;
	ignore_classnames[ "script_brushmodel" ] = true;
	//ignore_classnames[ "choose_light" ] = true;
	ignore_classnames[ "script_vehicle_collmap" ] = true;
	ignore_classnames[ "info_volume_breachroom" ] = true;
	ignore_classnames[ "actor_ally_hero_foley" ] = true;
	ignore_classnames[ "actor_ally_hero_dunn" ] = true;
	ignore_classnames[ "stage" ] = true;
	
	
	foreach ( ent in entities )
	{
		if ( isalive( ent ) )
			continue;
			
		// keep these
		//if ( isdefined( ent.script_ghettotag ) )
		//	continue;
			
		//if ( ent.origin[ 2 ] < 1850 )
		//	continue;

		if ( !isdefined( ent.classname ) )
		{
			if ( ent istouching( volume ) )
			{
				// looper that should be off anyway
				ent delete();
			}
			
			continue;
		}
			
		if ( isdefined( ignore_classnames[ ent.classname ] ) )
			continue;	

		if ( isdefined( ignore_classnames[ ent.code_classname ] ) )
			continue;	
		
		if( ent == volume )
			continue;
			
		if ( ent needs_ent_testing() )
		{
			// triggers must have their center in the vol to survive
			org = spawn( "script_origin", ent.origin );
			if ( org istouching( volume ) )
			{
				ent delete();
			}
			org delete();
			
			continue;
		}
		
		if ( ent istouching( volume ) )
			ent delete();
	}
}

needs_ent_testing()
{
	if ( issubstr( self.code_classname, "script_vehicle" ) )
		return true;
	if ( issubstr( self.code_classname, "script_vehicle_corpse" ) )
		return true;
	if ( issubstr( self.code_classname, "script_brushmodel" ) )
		return true;
	if ( issubstr( self.code_classname, "trigger" ) )
		return true;
	return self.code_classname == "info_volume";
}



delete_house_area_entities()
{
	house_area_volume = getent( "house_area_volume", "targetname" );
	ents = getentarray();
	foreach( thing in ents )
	{
		if( !isdefined( thing ) )
			continue;
		if( thing istouching( house_area_volume ) )
			thing delete();
	}
}



////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

	
	
objective_main()
{
	switch( level.start_point )
	{
		case "default":
		case "humvee":
			wait_for_yards();
		case "yards":
		case "bmp":
		case "pizza":
		case "gas_station":
		case "crash":
			objective_crash();
		case "nates_roof":
			objective_roof();
			//objective_sentry();
			objective_defend_roof();
		case "attack_diner":
			objective_predator();
		case "defend_diner":
			objective_BMPs();
		case "diner":
			objective_burgertown();
		case "burgertown":
		case "vip_escort":
			//objective_regroup_at_nates();
		case "defend_bt":
		case "helis":
			objective_defend_raptor();
			objective_destroy_helicopter();
			objective_defend_raptor2();
			objective_destroy_helicopter2();
			objective_defend_raptor3();
		case "convoy":
			objective_convoy();
	}
}

wait_for_yards()
{
	flag_wait_either( "follow_foley", "entering_yards" );
}

objective_crash()
{
	//obj = getEntWithFlag( "crash_objective" );
	obj = getstruct( "police_car_moment", "script_noteworthy" );
	origin = obj.origin;
	
	registerObjective( "obj_crash", &"INVASION_OBJ_FOLEY", level.raptor.origin );
	setObjectiveState( "obj_crash", "current" );
	thread setObjectiveLocationMoving( "obj_crash", level.raptor, (0,0,70) );
	
	flag_wait( "crash_objective" );
	flag_wait_either( "player_goto_roof", "player_on_roof" );
	
	setObjectiveState( "obj_crash", "done" );
}

objective_roof()
{
	if( !flag( "player_on_roof" ) )
	{
		origin = level.obj_sentry.origin;
		
		registerObjective( "obj_roof", &"INVASION_OBJ_ROOF", origin );
		setObjectiveState( "obj_roof", "current" );
    	
		flag_wait( "player_on_roof" );
		
		setObjectiveState( "obj_roof", "done" );
	}
}

//objective_sentry()
//{
//	origin = level.obj_sentry.origin;
//	
//	registerObjective( "obj_sentry", &"INVASION_OBJ_SENTRY", origin );
//	setObjectiveState( "obj_sentry", "current" );
//
//	flag_wait( "sentry_in_position" );
//	
//	setObjectiveState( "obj_sentry", "done" );
//}

objective_defend_roof()
{
	south_side_of_roof = getstruct( "south_side_of_roof_obj_loc", "targetname" );
	origin = south_side_of_roof.origin;
	
	registerObjective( "obj_defend", &"INVASION_OBJ_DEFEND", origin );
	setObjectiveState( "obj_defend", "current" );
	setObjectiveWaypoint( "obj_defend", &"INVASION_WAYPOINT_DEFEND" );
		
	flag_wait( "northside_roof" );
	
	northside_roof = getstruct( "northside_roof", "targetname" );
	setObjectiveLocation( "obj_defend", northside_roof.origin );
	setObjectiveWaypoint( "obj_defend", &"INVASION_WAYPOINT_DEFEND" );

	flag_wait( "truck_guys_retreat" );
	
	off_the_roof = getstruct( "off_the_roof", "targetname" );
	setObjectiveLocation( "obj_defend", off_the_roof.origin );
	setObjectiveWaypoint( "obj_defend" );//clear it
	
	flag_wait( "time_to_go_get_UAV_control" );
	
	setObjectiveState( "obj_defend", "done" );
}

objective_predator()
{
	predator_drone_control = getent( "predator_drone_control", "targetname" );
	origin = predator_drone_control.origin;
	
	registerObjective( "obj_predator", &"INVASION_OBJ_PREDATOR", origin );
	setObjectiveState( "obj_predator", "current" );

	flag_wait( "player_has_predator_drones" );
	
	setObjectiveState( "obj_predator", "done" );
}


objective_burgertown()
{
	nates_restaurant_goal = getent( "nates_restaurant_goal", "targetname" );
	origin = nates_restaurant_goal.origin;
	
	registerObjective( "obj_burgertown", &"INVASION_OBJ_REGROUP", origin );
	setObjectiveState( "obj_burgertown", "current" );
	
	flag_wait( "time_to_clear_burgertown" );
	
	objective_burgertown_groundfloor = getent( "objective_burgertown_groundfloor", "targetname" );
	origin = objective_burgertown_groundfloor.origin;
	
	setObjectiveString( "obj_burgertown", &"INVASION_OBJ_BURGERTOWN" );
	setObjectiveLocation( "obj_burgertown", origin );

	flag_wait( "burger_town_lower_cleared" );
	wait 2;
	
	setObjectiveState( "obj_burgertown", "done" );
}

objective_BMPs()
{
	wait .2;
	if( !flag( "bmp_north_left_dead" ) )
	{
		registerObjective( "obj_bmps", &"INVASION_OBJ_BMPS", level.bmp_north_left.origin );
		setObjectiveState( "obj_bmps", "current" );
		thread setObjectiveLocationMoving( "obj_bmps", level.bmp_north_left, (0,0,96) );
		//setObjectiveWaypoint( "obj_bmps", &"INVASION_WAYPOINT_HOSTILES" );
	}
	else
	{
		if( !flag( "bmp_north_mid_dead" ) )
		{
			registerObjective( "obj_bmps", &"INVASION_OBJ_BMPS", level.bmp_north_mid.origin );
			setObjectiveState( "obj_bmps", "current" );
			thread setObjectiveLocationMoving( "obj_bmps", level.bmp_north_mid, (0,0,96) );
			//setObjectiveWaypoint( "obj_bmps", &"INVASION_WAYPOINT_HOSTILES" );
		}
		else
			return;
	}
	flag_wait( "bmp_north_left_dead" );
	if( !flag( "bmp_north_mid_dead" ) )
	{
		thread setObjectiveLocationMoving( "obj_bmps", level.bmp_north_mid, (0,0,96) );
		//setObjectiveWaypoint( "obj_bmps", &"INVASION_WAYPOINT_HOSTILES" );
	}
	
	flag_wait( "bmp_north_mid_dead" );
	
	setObjectiveState( "obj_bmps", "done" );
}

objective_regroup_at_nates()
{
	
	objective = getent( "raptor_in_nates_prep", "targetname" );
	origin = objective.origin;
	
	registerObjective( "obj_nates_regroup", &"INVASION_OBJ_NATES_REGROUP", origin );
	setObjectiveState( "obj_nates_regroup", "current" );
	
	flag_wait( "player_in_pos_to_cover_vip" );
	
	setObjectiveState( "obj_nates_regroup", "done" );
}

objective_defend_raptor()
{
	
	//objective_burgertown_groundfloor = getent( "objective_burgertown_groundfloor", "targetname" );
	origin = level.raptor.origin;
	
	registerObjective( "obj_raptor_defend", &"INVASION_OBJ_VIP_ESCORT", origin );
	setObjectiveState( "obj_raptor_defend", "current" );
	
	thread setObjectiveLocationMoving( "obj_raptor_defend", level.raptor, (0,0,70) );
	setObjectiveWaypoint( "obj_raptor_defend", &"INVASION_WAYPOINT_PROTECT" );
	
	flag_wait( "president_in_BT_meat_locker" );
	
	setObjectiveString( "obj_raptor_defend", &"INVASION_OBJ_BURGERTOWN_DEFEND" );
	thread setObjectiveLocation_nearest_enemy( "obj_raptor_defend" );
	
	flag_wait( "first_attack_heli_spawned" );
	wait 9;
	
	//setObjectiveState( "obj_raptor_defend", "done" );
}


setup_stingers()
{
	level.nates_stinger = [];
	nates_stinger = getent( "nates_stinger", "script_noteworthy" );
	level.nates_stinger["origin"] = nates_stinger.origin;
	level.nates_stinger["angles"] = nates_stinger.angles;
	level.nates_stinger["classname"] = nates_stinger.classname;
	
	
	level waittill( "attack_heli_spawned" );
	
	diner_stinger = getent( "diner", "script_noteworthy" );
	if( isdefined( diner_stinger ) )
		diner_stinger SetModel( "weapon_stinger_obj" );
	
	if( isdefined( nates_stinger ) )
		nates_stinger SetModel( "weapon_stinger_obj" );
	
	while( 1 )
	{
		wait 2;
		if( !isalive( level.attack_heli ) )
			continue;
		
		needs_stinger = true;
		weapons = level.player GetWeaponsListAll();
		foreach( weap in weapons )
		if( weap == "stinger" )
			needs_stinger = false;
			
		if( !needs_stinger )
			continue;
		
		nates_stinger = getent( "nates_stinger", "script_noteworthy" );
		if( !isdefined( nates_stinger ) )
		{
			weapon = spawn ( level.nates_stinger["classname"], level.nates_stinger["origin"], 1 );
			weapon.angles = level.nates_stinger["angles"];
			weapon ItemWeaponSetAmmo( 1, 0 );
			weapon.script_noteworthy = "nates_stinger";
			weapon setmodel( "weapon_stinger_obj" );
		}
	}
}


objective_destroy_helicopter( second_heli )
{
	level notify( "attack_heli_spawned" );
	needs_stinger = true;
	weapons = level.player GetWeaponsListAll();
	foreach( weap in weapons )
	if( weap == "stinger" )
		needs_stinger = false;
	
	if( needs_stinger )
	{
		stinger_loc = level.nates_stinger["origin"];
		
		diner_stinger = getent( "diner", "script_noteworthy" );
		if( isdefined( diner_stinger ) )
		{
			stinger_loc = diner_stinger.origin;
			level.obj_direction = "west";
		}
		else
		{
			level.obj_direction = "east";
		}
		origin = stinger_loc;
	}
	else
	{
		origin = level.attack_heli.origin;
	}
	
	//if( !isdefined( second_heli ) )
	//{
		level notify( "moving obj_raptor_defend" );
		setObjectiveString( "obj_raptor_defend", &"INVASION_OBJ_ATTACK_HELI" );
		setObjectiveLocation( "obj_raptor_defend", origin );
		setObjectiveWaypoint( "obj_raptor_defend" );
		//registerObjective( "obj_destroy_helicopter", &"INVASION_OBJ_ATTACK_HELI", origin );
	//}
	//else
	//{
	//	setObjectiveLocation( "obj_raptor_defend", origin );
	//}
	//setObjectiveState( "obj_destroy_helicopter", "current" );
	
	if( needs_stinger )
		level.attack_heli waittill_death_or_stinger();
	
	if( isalive( level.attack_heli ) )
	{
		//objective_burgertown_groundfloor = getent( "objective_burgertown_groundfloor", "targetname" );
		//thread setObjectiveLocationMoving( "obj_destroy_helicopter", level.attack_heli );
		level notify( "moving obj_raptor_defend" );
		thread setObjectiveLocationMoving( "obj_raptor_defend", level.attack_heli, (0,0,128) );
	
		level.attack_heli waittill( "death" );
	}
	
	//setObjectiveState( "obj_destroy_helicopter", "done" );
}

waittill_death_or_stinger()
{
	self endon ( "death" );	

	while( 1 )
	{
		level.player waittill( "weapon_change" );
	
		weap = level.player getCurrentWeapon();
		if ( weap == "stinger" )
		{
			autosave_by_name( "got_stinger" );
			break;
		}
	}	
}

objective_defend_raptor2()
{
	//meat_locker = getent( "president_in_burgertown_meat_locker", "targetname" );
	//origin = meat_locker.origin;
	
//	registerObjective( "obj_raptor_defend", &"INVASION_OBJ_BURGERTOWN_DEFEND", origin );

	level notify( "moving obj_raptor_defend" );
	setObjectiveString( "obj_raptor_defend", &"INVASION_OBJ_BURGERTOWN_DEFEND" );
	
	thread setObjectiveLocation_nearest_enemy( "obj_raptor_defend" );
	//setObjectiveLocation( "obj_raptor_defend", origin );
	//setObjectiveState( "obj_raptor_defend", "current" );
	
	flag_wait( "second_attack_heli_spawned" );
	wait 9;
	
	//setObjectiveState( "obj_raptor_defend", "done" );
}

objective_destroy_helicopter2()
{
	second_heli = true;
	objective_destroy_helicopter( second_heli );
}

objective_defend_raptor3()
{
	//meat_locker = getent( "president_in_burgertown_meat_locker", "targetname" );
	//origin = meat_locker.origin;
	
	level notify( "moving obj_raptor_defend" );
//	registerObjective( "obj_raptor_defend", &"INVASION_OBJ_BURGERTOWN_DEFEND", origin );
	setObjectiveString( "obj_raptor_defend", &"INVASION_OBJ_BURGERTOWN_DEFEND" );
	//setObjectiveLocation( "obj_raptor_defend", origin );
	
	thread setObjectiveLocation_nearest_enemy( "obj_raptor_defend" );
	//setObjectiveState( "obj_raptor_defend", "current" );
	
	flag_wait( "time_to_goto_convoy" );
	
	setObjectiveState( "obj_raptor_defend", "done" );
}

objective_convoy()
{
	flag_wait( "time_to_goto_convoy" );
	
	if( !isdefined( level.convoy ) )
		level.convoy = getent( "convoy_obj", "targetname" );
	//origin = convoy_obj.origin;
	
	
	registerObjective( "obj_convoy", &"INVASION_OBJ_CONVOY", level.convoy.origin );
	thread setObjectiveLocationMoving( "obj_convoy", level.convoy, (0,0,128) );
	setObjectiveState( "obj_convoy", "current" );

	//flag_wait( "player_at_convoy" );
	
	//setObjectiveState( "obj_convoy", "done" );
}

// Concatenates the proper hint string to use depending which weapon (claymore or remotemissile) is equipped first
get_remotemissile_hint_string( str )
{
	if ( IsDefined( self.remotemissile_actionslot ) )
	{
		return str + "_" + self.remotemissile_actionslot;
	}
	else
	{
		return str + "_4";
	}
}