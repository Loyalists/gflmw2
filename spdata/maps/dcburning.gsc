#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_hud_util;
#include common_scripts\utility;

main()
{
	setDvarIfUninitialized( "cheap_spot", "1" );
	initPrecache();
	maps\dcburning_precache::main();
	/*-----------------------
	LEVEL VARIABLES
	-------------------------*/
	level.c4_models = [];
	level.chattertrigsinterior = getentarray( "interior_bcs", "targetname" );
	level.chattertrigsexteriror = getentarray( "exterior_bcs", "targetname" );
	array_thread( level.chattertrigsexteriror,::trigger_off );
	array_thread( level.chattertrigsinterior,::trigger_off );
	level.monument_target = getent( "monument_target", "targetname" );
	level.sniperOrgs = getentarray( "humvee_spotlight_targets", "targetname" );
	level.crowsArmor = [];
	level.snipeEnemies = 4;
	level.onHeli = false;
	level.CannonRange = 6000;
	level.CannonRangeSquared = level.CannonRange * level.CannonRange;
	//setsaveddvar( "thermalBlurFactorScope", 300 );
	level.firemagicRPGs = true;
	level.squadsize = 3;
	level.mortarDamageRadius = 100;
	level.goodFriendlyDistanceFromPlayerSquared = 300 * 300;
	level.friendliesCanHelpCrowsnest = false;
	level.canTalk = true;
	level.evacSitePercentDestroyed = 0;
	level.targetsScriptedJavStinger = [];
	level.tempDialogueTime = 3;
	level.evacSiteEnemies = [];
	level.evacSiteVehicles = [];
	level.evacSiteEnemyVehicles = [];
	setDvarIfUninitialized( "bog_camerashake", "1" );
	level.spawnerCallbackThread = ::AI_think;
	level.droneCallbackThread = ::AI_drone_think;
	level.stealthDistanceSquared = 512 * 512;
	setDvarIfUninitialized( "dc_debug", "0" );
	setDvarIfUninitialized( "dc_dialog", "1" );
	level.cosine[ "25" ] = cos( 25 );
	level.cosine[ "35" ] = cos( 35 );
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "60" ] = cos( 60 );
	level.cosine[ "90" ] = cos( 90 );
	level.cosine[ "180" ] = cos( 180 );
	level.mortarWithinFOV = level.cosine[ "35" ];
	trigs = getentarray( "trigger_multiple", "classname" );
	level.aColornodeTriggers = [];
	foreach ( trigger in trigs )
	{
		if ( ( isdefined( trigger.script_noteworthy ) ) && ( getsubstr( trigger.script_noteworthy, 0, 10 ) == "colornodes" ) )
			level.aColornodeTriggers = array_add( level.aColornodeTriggers, trigger );
	}
	//level.motiontrackergun_off = "masada_dcburn_mt_black_off";
	//level.motiontrackergun_on = "masada_dcburn_mt_black_on";
	disable_color_trigs();

	/*-----------------------
	STARTS
	-------------------------*/
	add_start( "debug", ::start_debug, "debug" );
	add_start( "elevator_bottom", ::start_elevator_bottom, "elevator_bottom" );
	add_start( "elevator_top", ::start_elevator_top, "elevator_top" );
	add_start( "crows_nest", ::start_crows_nest, "crows_nest" );
	add_start( "crows_nest_armor", ::start_crows_nest_armor, "crows_nest_armor" );
	add_start( "barrett", ::start_barrett, "barrett" );
	add_start( "to_roof", ::start_to_roof, "to_roof" );
	add_start( "roof", ::start_roof, "roof" );
	add_start( "heliride2", ::start_heli_ride2, "heliride2" );
	add_start( "crash", ::start_crash, "crash" );
	
	default_start( ::start_default );
	
	/*-----------------------
	SUPPORT SCRIPTS
	-------------------------*/	
	maps\dc_crashsite::main();
	maps\_breach_hinges_left::main();
	maps\_breach::main();
	maps\_drone_ai::init();
	maps\createart\dcburning_fog::main();
	maps\dcburning_fx::main();
	maps\createfx\dcburning_audio::main();
	maps\_minigun::main();
	maps\_blackhawk_minigun::main( "vehicle_blackhawk_minigun_hero" );
	maps\_hiding_door_anims::main();
	maps\_c4::main();
	maps\_load::main();
	maps\_nightvision::main();
	maps\_javelin::init();
	maps\_stinger::init();
	thread maps\dcburning_amb::main();
	thread maps\_barrett::barrett_init();
	maps\dcburning_anim::main();
	thread maps\_mortar::bunker_style_mortar();
	thread maps\_mortar::bog_style_mortar();
	array_thread( getentarray( "animated_vehicle", "script_noteworthy" ),::vehicle_animated_think );
	// --> moved to dc_crashsite.gsc   |||||  array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	array_thread( getvehiclenodearray( "plane_bomb", "script_noteworthy" ), maps\_mig29::plane_bomb_cluster );
	
	/*-----------------------
	FLAGS
	-------------------------*/	
	
	//misc
	flag_init( "slamraam_c4_detonated" );
	flag_init( "stop_elevator_doors" );
	flag_init( "difficulty_initialized" );
	flag_init( "can_talk" );
	flag_set( "can_talk" );
	
	maps\_compass::setupMiniMap("compass_map_dcburning");
	
	//objectives
	flag_init( "obj_follow_sgt_macey_given" );
	flag_init( "obj_follow_sgt_macey_complete" );
	flag_init( "obj_commerce_given" );
	flag_init( "obj_commerce_complete" );
	flag_init( "obj_commerce_defend_snipe_given" );
	flag_init( "obj_commerce_defend_snipe_complete" );
	flag_init( "obj_commerce_defend_crow_given" );
	flag_init( "obj_commerce_defend_crow_complete" );
	flag_init( "obj_commerce_defend_javelin_given" );
	flag_init( "obj_commerce_defend_javelin_complete" );
	flag_init( "obj_rooftop_given" );
	flag_init( "obj_rooftop_complete" );
	flag_init( "obj_heli_mount_given" );
	flag_init( "obj_heli_mount_complete" );
	flag_init( "obj_heli_ride_given" );
	
	//bunker
	flag_init( "bunker_door_closed" );
	flag_init( "delete_bunker_mortars" );
	
	//trenches
	flag_init( "seaknight_drones_loaded" );
	flag_init( "seaknight_drones2_loaded" );
	flag_init( "bradley_can_start_firing" );
	flag_init( "humvee_commerce_left_done_with_spotlight" );
	flag_init( "javelin_is_owning_fools" );
	flag_init( "second_abrams_killed" );
	flag_init( "commerce_rappelers_inserting" );
	flag_init( "commerce_rappelers_rappeling" );
	flag_init( "commerce_rappelers_done" );
	flag_init( "trenches_dialogue_done" );
	flag_init( "lav_is_suppressing" );
	flag_init( "leader_orders_everyone_across_street" );
	
	//elevator_bottom
	flag_init( "atrium_guys_at_end_of_anim" );
	flag_init( "commerce_first_floor_enemies_dead" );
	flag_init( "courtyard_has_been_cleared" );
	flag_init( "ask_bradley_to_stop_firing" );
	flag_init( "mezzanine_top_has_been_cleared" );
	flag_init( "floor_four_has_been_cleared" );
	flag_init( "player_shot_at_samsite_guys" );
	flag_init( "commerce_samsite_revealed" );

	//elevator_top
	flag_init( "fifth_floor_guys_damaged" );
	flag_init( "start_music_to_crowsnest" );
	flag_init( "macey_tells_you_to_move_to_crows" );
	
	//crows nest - snipe
	flag_init( "player_shot_at_crowsnest_guys" );
	flag_init( "crowsnest_has_been_cleared" );
	flag_init( "make_seaknights_take_off" );
	flag_init( "can_start_crow_nags" );
	flag_init( "only_2_sniper_enemies_remaining" );
	
	//wave of enemies after snipe
	flag_init( "player_killed_enough" );
	flag_init( "humvee_spotlight_deleted" );
	flag_init( "perimeter_enemies_have_retreated" );
	
	//crows nest - armor
	flag_init( "start_crow_armor_sequence" );
	flag_init( "only_1_javelin_enemies_remaining" );
	flag_init( "only_2_javelin_enemies_remaining" );
	flag_init( "monument_dummy_target_setup" );
	flag_init( "crowsnest_sequence_finished" );
	flag_init( "player_has_killed_at_least_one_javelin_target" );
	
	
	//roof
	flag_init( "roof_breach_complete" );
	flag_init( "roof_littlebird_lifted_off" );
	flag_init( "player_heli_spawned" );
	flag_init( "player_heli_ready_to_take_off" );
	flag_init( "roof_heli_about_to_be_owned" );
	flag_init( "roof_heli_owned" );
	flag_init( "player_getting_on_minigun" );
	flag_init( "player_has_used_minigun" );
	flag_init( "blackhawk_landed" );
	flag_init( "rooftop_run_dialogue_finished" );
	
	flag_init( "littlebird_crash_path_end" );
	flag_init( "littlebird_crash_path_end2" );
	
	//lincoln
	flag_init( "player_starting_fastrope" );
	flag_init( "player_fastroped_out" );
	flag_init( "player_facing_blackhawk" );
	
	//player crash and crash site
	flag_init( "player_crash_starting" );
	

	/*-----------------------
	GLOBAL THREADS
	-------------------------*/	
	//setsaveddvar( "sm_sunSampleSizeNear", 0.125 );// 0.25 by default...higher value makes shadows look longer (inc size)
	setsaveddvar( "sm_sunShadowScale", 0.5 );// 1 by default...lower values is better performance
	
	// Press^3 [{+actionslot 3}] ^7to use\nthe M203 Grenade Launcher.
	add_hint_string( "grenade_launcher", &"SCRIPT_LEARN_GRENADE_LAUNCHER", ::should_break_m203_hint );
	add_hint_string( "javelin_pickup", &"DCBURNING_HINT_JAVELIN_PICKUP", ::should_break_javelin_pickup_hint );
	add_hint_string( "javelin_switch", &"DCBURNING_HINT_JAVELIN_SWITCH", ::should_break_javelin_switch_hint );
	add_hint_string( "javelin_shoot", &"DCBURNING_HINT_JAVELIN_FIRE", ::should_break_javelin_fire_hint );
	
	// Press^3 [{+actionslot 3}] ^7to activate heartbeat sensor.
	//add_hint_string( "hint_heartbeat_sensor", &"DCBURNING_SWITCH_HEARTBEAT", ::should_break_activate_heartbeat );
	array_thread( getentarray( "destructible_trigger", "targetname" ),::destructible_trigger_think );
	thread AA_global();
	hideAll();
	fx_management();
	//setSavedDvar( "r_specularColorScale", "6.25" );
	setsaveddvar( "r_lightGridEnableTweaks", 0 );
	setsaveddvar( "r_lightGridIntensity", 1.2 );
	setsaveddvar( "r_lightGridContrast", 0 );
	//thread destructibles_think();
	thread init_difficulty();
	thread lights();
	init_air_vehicle_flags();
	//thread player_death();
	array_thread( getentarray( "ai_cleanup_trigger", "targetname" ), ::ai_cleanup_trigger_think );
	array_thread( getentarray( "redshirt_trigger", "targetname" ), ::redshirt_trigger_think );
	array_thread( getentarray( "rpg_targets", "targetname" ), ::rpg_targets_think );
	array_thread( getentarray( "dest_cheap", "targetname" ), ::cheap_destructibles_think );
	
	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "ignored" );
	createthreatbiasgroup( "oblivious" );
	level.player setthreatbiasgroup( "player" );
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious
	
	/*-----------------------
	SPAWNER THREADS
	-------------------------*/	
	aVehicleSpawners = maps\_vehicle::_getvehiclespawnerarray();
	array_thread( aVehicleSpawners, ::add_spawn_function, ::vehicle_think );
	array_thread( getentarray( "ai_ambient", "script_noteworthy" ), ::add_spawn_function, ::ai_ambient_noprop_think );
	array_thread( getentarray( "ai_ambient_prop", "script_noteworthy" ), ::add_spawn_function, ::ai_ambient_prop_think );
	
	array_spawn_function_noteworthy( "door_breaker", ::AI_door_breaker_think );
	array_spawn_function_targetname( "hostiles_commerce_samsite", ::AI_hostiles_commerce_samsite_think );
	array_spawn_function_targetname( "commerce_sector_2_guys", ::AI_commerce_sector_2_guys_think );
	array_spawn_function_targetname( "crowsnest_assault_guys_wave1", ::AI_crowsnest_assault_guys_wave1_think );
	array_spawn_function_targetname( "commerce_flare_guys", ::AI_commerce_flare_guys_think );
	array_spawn_function_targetname( "ww2_heli", ::vehicle_ww2_enemy_helis_think );
	array_spawn_function_noteworthy( "no_suppress", ::ai_no_suppress_think );
	array_spawn_function_noteworthy( "friendly_fodder", ::AI_friendly_fodder_think );
	array_spawn_function_noteworthy( "enemy_spotter_prone", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "enemy_spotter_crouched", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "enemy_javelin", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "enemy_stinger", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "waittill_damaged_and_set_flag", ::AI_waittill_damaged_and_set_flag_think );
	array_spawn_function_noteworthy( "invisible_patrol_fodder", ::AI_invisible_patrol_fodder_think );
	array_spawn_function_noteworthy( "at4_friendly", ::AI_at4_friendly_think );
	array_spawn_function_noteworthy( "player_seek", ::AI_player_seek );
	array_spawn_function_noteworthy( "roof_escape_redshirts", ::AI_roof_escape_redshirts_think );
	array_spawn_function_noteworthy( "redshirt", ::AI_redshirt_think );
	array_spawn_function_noteworthy( "glass_building_enemies", ::AI_glass_building_enemies_think );
	array_spawn_function_noteworthy( "ambush", ::AI_ambush_behavior );
	array_spawn_function_noteworthy( "hummer_gunner", ::AI_hummer_gunner_think );
	array_spawn_function_targetname( "commerce_rpg_upper", ::AI_commerce_rpg_upper_think );
	
	//array_spawn_function_targetname( "friendlies_pavlov_street", ::AI_ambient_combat_think );
	
	setsaveddvar( "r_spotlightbrightness", "6" );
	setsaveddvar( "r_spotlightstartradius", "50" );
	setsaveddvar( "r_spotlightEndradius", "250" );
	setsaveddvar( "r_spotlightfovinnerfraction", "0" );
	setsaveddvar( "r_spotlightexponent", "2" );

	//flag_wait( "player_crash_done" );
	//wait( 2 );
	//iPrintlnbold( &"SCRIPT_DEBUG_LEVEL_END" );

}

init_air_vehicle_flags()
{
	array1 = getentarray( "script_origin", "classname" );
	aAirNodes = array_merge( array1, level.struct );
	array_thread( aAirNodes,::air_nodes_think );
}

air_nodes_think()
{
	if ( !isdefined( self.script_flag ) )
		return;
	flag_init( self.script_flag );
	if ( getdvar( "dc_debug" ) == "1" )
		self thread debug_message( self.script_flag , self.origin, 9999 );
	self waittill( "trigger" );
	flag_set( self.script_flag );
	if ( getdvar( "dc_debug" ) == "1" )
		iPrintlnbold( "flag: " + self.script_flag + " has been set" );
}

/****************************************************************************
    START FUNCTIONS
****************************************************************************/ 
start_default()
{
	AA_bunker_init();
	//start_debug();
	//start_roof();
}

start_debug()
{
	initFriendlies( "elevator_bottom" );

}

start_elevator_bottom()
{
	maps\_utility::vision_set_fog_changes( "dcburning_commerce", 0 );
	initFriendlies( "elevator_bottom" );
	thread obj_commerce();
	flag_set( "obj_commerce_given" );
	array_thread( level.squad, ::cqb_walk, "on" );
	triggersEnable( "colornodes_commerce_bot_to_top", "script_noteworthy", true );
	AA_elevator_bottom_init();
}

start_elevator_top()
{
	maps\_utility::vision_set_fog_changes( "dcburning_commerce", 0 );
	initFriendlies( "elevator_top" );
	battlechatter_off( "allies" );
	array_thread( level.squad, ::cqb_walk, "on" );
	flag_set( "player_at_commerce_crows_floor" );
	AA_elevator_top_init();
}

start_crows_nest()
{
	maps\_utility::vision_set_fog_changes( "dcburning_commerce", 0 );
	initFriendlies( "crows_nest" );
	battlechatter_off( "allies" );
	array_thread( level.squad, ::cqb_walk, "on" );
	flag_set( "player_approaching_crowsnest" );
	flag_set( "player_approaching_crowsnest2" );
	AA_crows_nest_snipe_init();
}

start_crows_nest_armor()
{
	maps\_utility::vision_set_fog_changes( "dcburning_commerce", 0 );
	initFriendlies( "crows_nest" );
	battlechatter_off( "allies" );
	array_thread( level.squad, ::cqb_walk, "on" );
	flag_set( "start_crow_armor_sequence" );
	flag_set( "player_approaching_crowsnest" );
	flag_set( "player_approaching_crowsnest2" );
	AA_crows_nest_armor_init();
}

start_barrett()
{
	maps\_utility::vision_set_fog_changes( "dcburning_commerce", 0 );
	initFriendlies( "crows_nest" );
	battlechatter_off( "allies" );
	array_thread( level.squad, ::cqb_walk, "on" );
}

start_to_roof()
{
	maps\_utility::vision_set_fog_changes( "dcburning_commerce", 0 );
	initFriendlies( "to_roof" );
	battlechatter_on( "allies" );
	array_thread( level.squad, ::cqb_walk, "on" );
	flag_set( "only_2_javelin_enemies_remaining" );
	flag_set( "crowsnest_sequence_finished" );
	thread AA_commerce_to_roof_init();
}

start_roof()
{
	maps\_utility::vision_set_fog_changes( "dcburning_commerce", 0 );
	initFriendlies( "Roof" );
	array_thread( level.squad, ::cqb_walk, "off" );
	flag_set( "player_headed_to_roof" );
	flag_set( "player_approaching_outer_balcony" );
	//thread music_loop( "dcburning_stairway_escape_loop", 40.96 );
	dummy_trigger( "trigger_dummy_roof_colornode" );
	AA_roof_init();
}

start_heli_ride2()
{
	maps\_utility::vision_set_fog_changes( "dcburning_heliride", 0 );
	heliNode = getstruct( "player_heli_ww2_end", "script_noteworthy" );
	player_blackhawk_setup( heliNode );

	level.blackhawk.minigunUser = level.player;

	level.blackhawk thread maps\_minigun::minigun_think();
	//thread maps\_minigun::minigun_hints_on();
	thread AA_heli_ride2();
}

start_crash()
{
	thread maps\dc_crashsite::AA_crash_site_init();
	wait( .1 );
	flag_set( "player_crash_done" );
}

/****************************************************************************
    BUNKER
****************************************************************************/ 
AA_bunker_init()
{
	initFriendlies( "Bunker" );
	thread bunker_mortars();
	thread music_bunker();
	thread commerce_flyby();
	//thread commerce_lasers();
	thread AAA_sequence_bunker_to_commerce();
	thread obj_follow_sgt_macey();
	thread obj_commerce();
	thread dialogue_bunker();
	thread dialogue_trenches();
	thread javelins_trench();
	thread humvee_commerce_left();
	thread humvee_commerce();
	thread bradley_commerce();
	thread humvee_convoy();
	thread helis_monument();
	thread helis_monument_ground();
	thread helis_monument_cargo();
	thread commerce_rappelers();
	thread capitol_trench();
	
	flag_wait( "player_commerce_trench_02" );
	thread AA_elevator_bottom_init();
}

music_bunker()
{
	thread music_loop( "dcburning_intropad", 87 );
	flag_wait( "player_bunker_walk_03" );
	music_stop( 5 );
	wait( 5.1 );
	musicPlayWrapper( "dcburning_intropeak" );
}

commerce_flyby()
{
	flag_wait( "player_commerce_past_desks" );
	level.vehicles_commerce_ambient = spawn_vehicles_from_targetname_and_drive( "vehicles_commerce_ambient" );
}

AAA_sequence_bunker_to_commerce()
{
	if ( getdvarint( "r_dcburning_culldist" ) == 1 )
	{
		setculldist( 28500 );
	}
	/*-----------------------
	PLAYER AND SQUAD IGNORED
	-------------------------*/	
	thread ignoreme_on_squad_and_player();
	
	flavorbursts_off( "allies" );
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	/*-----------------------
	PLAYER SQUAD
	-------------------------*/	
	level.teamLeader thread make_ambient_ai( "bunker_radio_door_guy" );
	level.friendly02 thread make_ambient_ai( "gun_toss_guy2" );
	level.friendly03 thread make_ambient_ai( "gun_toss_guy1" );
	
	//laptop_light_org = getent( "laptop_light_org", "targetname" );
	//laptop_light_model = spawn_tag_origin();
	//laptop_light_model.origin = laptop_light_org.origin;
	//laptop_light_org delete();
	//playfxontag( getfx( "dlight_laptop" ), laptop_light_model, "tag_origin" );
	
	/*-----------------------
	AMBIENT DRONES
	-------------------------*/	
	bunker_laptop_guys = array_spawn( getentarray( "bunker_laptop_guys", "targetname" ) );
	thread bunker_radio_chatter();
	bunker_hallway_injured_guys = array_spawn( getentarray( "bunker_hallway_injured_guys", "targetname" ) );
	bunker_hallway_injured_guys2 = array_spawn( getentarray( "bunker_hallway_injured_guys2", "targetname" ) );
	bunker_sleeping_guys = array_spawn( getentarray( "bunker_sleeping_guys", "targetname" ) );
	bunker_doctor_and_patient = array_spawn( getentarray( "bunker_doctor_and_patient", "targetname" ) );
	spawner = getent( "bunker_hallway_injured_carrier", "targetname" );
	bunker_hallway_injured_carrier = spawner spawn_ai();
	bunker_sitting_guys = array_spawn( getentarray( "bunker_sitting_guys", "targetname" ) );
	
	flag_wait( "introscreen_complete" );
	
	flag_wait( "player_bunker_comm_room" );
	triggersEnable( "colornodes_trenches", "script_noteworthy", true );
	
	/*-----------------------
	EXTERIOR MORTARS ON, DRONES
	-------------------------*/	
	flag_wait( "player_approaching_bunker_exit_hall" );
	

	
	drones_flood_monument = getentarray( "drones_flood_monument", "targetname" );
	thread drone_flood_start( drones_flood_monument, "drones_flood_monument" );
	thread drones_trenches();
	
	if ( getdvarint( "r_dcburning_culldist" ) != 1 )
	{
		level.helis_ambient_trenches = spawn_vehicles_from_targetname_and_drive( "helis_ambient_trenches" );
		level.helis_ambient_capitol = spawn_vehicles_from_targetname_and_drive( "helis_ambient_capitol" );
	}
	delaythread( 0, maps\_mortar::bog_style_mortar_on, 2 );

	drone_warrior_hydrant = dronespawn( getent( "drone_warrior_hydrant", "targetname" ) );
	drone_warrior_hydrant thread drone_warrior_hydrant_think();


	/*-----------------------
	LITTLEBIRD AND SEAKNIGHT BY MONUMENT
	-------------------------*/	
	seaknight_loader_start = getent( "seaknight_loader_start", "targetname" );
	seaknight_loader_start notify( "spawn" );

	seaknight_loader_start2 = getent( "seaknight_loader_start2", "targetname" );
	seaknight_loader_start2 notify( "spawn" );
	
	littlebird_monument = spawn_vehicle_from_targetname_and_drive( "littlebird_monument" );
	littlebird_monument_riders_left = array_spawn( getentarray( "littlebird_monument_riders_left", "targetname" ) );
	array_thread( littlebird_monument_riders_left,::AI_ignored_and_oblivious_on );
	array_thread( littlebird_monument_riders_left,::magic_bullet_shield );
	littlebird_monument_riders_right = array_spawn( getentarray( "littlebird_monument_riders_right", "targetname" ) );
	array_thread( littlebird_monument_riders_right,::AI_ignored_and_oblivious_on );
	array_thread( littlebird_monument_riders_right,::magic_bullet_shield );
	// you'll send this node off to some commands to get the nodes contained in the stage prefab
	pickup_node_before_stage_monument = getstruct( "pickup_node_before_stage_monument", "script_noteworthy" );
	littlebird_monument set_stage( pickup_node_before_stage_monument, littlebird_monument_riders_left, "left" );
	littlebird_monument set_stage( pickup_node_before_stage_monument, littlebird_monument_riders_right, "right" );
	
	aTrenchAIToDelete = [];
	spawners = getentarray( "monument_spotters", "targetname" );
	monument_spotters = array_spawn( spawners, true );
	aTrenchAIToDelete = array_merge( aTrenchAIToDelete, monument_spotters );
	
	/*-----------------------
	LITTLEBIRD LOADS UP
	-------------------------*/	
	flag_wait( "player_approaching_monument" );
	
	/*-----------------------
	DRONES LOADING INTO SEAKNIGHT
	-------------------------*/	
	spawner = getent( "drones_seaknight", "targetname" );
	thread seaknight_drone_loaders( spawner, "seaknight_drones_loaded", "player_exiting_start_trench2" );	//load drones then set flag when loaded

	spawner = getent( "drones_seaknight2", "targetname" );
	thread seaknight_drone_loaders( spawner, "seaknight_drones2_loaded", "player_exiting_start_trench" );	//load drones then set flag when loaded
	
	/*-----------------------
	FIRE HYDRANT DRONE
	-------------------------*/	
	flag_wait( "player_exiting_start_trench" );
	
	//thread friendly_speed_adjustment_on();
	
	/*-----------------------
	SEAKNIGHT DEFENDERS LOAD UP AFTER DRONES, THEN FLY OFF
	-------------------------*/	
	seaknight_loader_start thread waittill_flag_then_notify( "seaknight_drones_loaded", "load_riders" );
	seaknight_loader_start thread waittill_notify_then_notify( "riders_loaded", "play_anim" );

	seaknight_loader_start2 thread waittill_flag_then_notify( "seaknight_drones2_loaded", "load_riders" );
	seaknight_loader_start2 thread waittill_notify_then_notify( "riders_loaded", "play_anim" );
	
	/*-----------------------
	SPOTLIGHT DEFAULT TARGETS MOVE A LITTLE
	-------------------------*/	
	spot_targets = getentarray( "spot_targets", "script_noteworthy" );
	array_thread( spot_targets,::spot_targets_think );
	
	/*-----------------------
	CLOSE BUNKER AND DELETE FRIENDLIES THERE
	-------------------------*/	
	bunker_doorup = getent( "bunker_door_up", "targetname" );
	bunker_doorup hide_entity();
	bunker_door = getentarray( "bunker_door", "targetname" );
	array_thread( bunker_door,:: show_entity );
	flag_set( "bunker_door_closed" );
	
	//stopfxontag( getfx( "dlight_laptop" ), laptop_light_model, "tag_origin" );
	//laptop_light_model delete();
	
	mortar_bunker = getstructarray( "mortar_bunker", "targetname" );
	mortar_bunker_radius_triggers = getentarray( "mortar_bunker", "targetname" );
	array_call( mortar_bunker_radius_triggers,::delete );
	thread struct_delete( mortar_bunker,"delete_bunker_mortars" );
	bunker_radio_org_room2 = getent( "bunker_radio_org_room2", "targetname" );
	bunker_radio_org_room2 delete();
	volume_bunker = getent( "volume_bunker", "targetname" );
	aAI = volume_bunker get_ai_touching_volume_non_squad();
	aDrones = volume_bunker get_drones_touching_volume( "allies" );
	aAI = array_merge( aAI, aDrones );
	array_thread( aAI,::AI_delete );
	array_thread( level.effects_bunker, ::pauseEffect );
	
	/*-----------------------
	COMMERCE WALL/STREET FRIENDLIES
	-------------------------*/	
	spawner = getent( "monument_waver", "targetname" );
	monument_waver = spawner spawn_ai( true );
	spawners = getentarray( "friendlies_commerce_street", "targetname" );
	friendlies_commerce_street = [];
	foreach( spawner in spawners )
	{
		friendlies_commerce_street[ friendlies_commerce_street.size ] = spawner spawn_ai( true );
	}
	//wall_death_nodes = getnodearray( "wall_death_nodes", "script_noteworthy" );
	array_thread( friendlies_commerce_street,::try_to_magic_bullet_shield );
	//array_thread( friendlies_commerce_street,::AI_try_to_hang_and_die_near_player, wall_death_nodes );
	
	spawners = getentarray( "friendlies_commerce_wall", "targetname" );
	friendlies_commerce_wall = [];
	foreach( spawner in spawners )
	{
		friendlies_commerce_wall[ friendlies_commerce_wall.size ] = spawner spawn_ai( true );
	}
	
	/*-----------------------
	MONUMENT MORTAR GUYS
	-------------------------*/	
	flag_wait( "player_exiting_start_trench2" );
	spawners = getentarray( "monument_mortarguys", "targetname" );
	monument_mortarguy = array_spawn( spawners, true );
	//array_spawn( getentarray( "trench_mortarguys", "targetname" ), true );

	/*-----------------------
	JAVELIN MOMENT
	-------------------------*/	
	flag_wait( "commerce_enemy_javeling_failsafe" );
	
	aTrenchAIToDelete = array_add( aTrenchAIToDelete, monument_waver );
	thread AI_delete_when_out_of_sight( aTrenchAIToDelete, 1024 );
	
	littlebird_monument thread load_side( "left", littlebird_monument_riders_left );
	littlebird_monument thread load_side( "right", littlebird_monument_riders_right );
	littlebird_monument_path = getstruct( "littlebird_monument_path", "targetname" );
	littlebird_monument thread vehicle_littlebird_gopath_when_loaded_and_flag_set( "player_exiting_start_trench", littlebird_monument_path );
	
	drones_flood_monument2 = getentarray( "drones_flood_monument2", "targetname" );
	thread drone_flood_start( drones_flood_monument2, "drones_flood_monument2" );
	
	/*-----------------------
	BUNKER MORTARS OFF
	-------------------------*/	
	flag_wait( "player_trench_capitol_failsafe" );

	heli_trench = spawn_vehicle_from_targetname_and_drive( "heli_trench" );
	heli_commerce_front = spawn_vehicle_from_targetname_and_drive( "heli_commerce_front" );
	
	//heli_trench maxPitch
	/*-----------------------
	PLAYER IS FAIR GAME
	-------------------------*/	
	flag_wait( "player_commerce_trench_01" );
	level.player.ignoreme = false;
	level.player set_threatbias( 1500 );

	/*-----------------------
	GET RID OF AI ON 4th FLOOR NOW
	-------------------------*/	
	flag_wait( "player_commerce_trench_03" );
	//thread AI_cleanup_volume( "volume_commerce_fouth_floor", "axis" );
	
	/*-----------------------
	PLAYER AND TEAM NOT IGNORED
	-------------------------*/	
	flag_wait_either( "player_touching_commerce_wall_left", "player_touching_commerce_wall_right" );
	thread autosave_by_name( "commerce_wall" );
	thread ignoreme_off_squad_and_player();

	/*-----------------------
	BRADLEY NOW FIRING AT REAL TARGETS
	-------------------------*/	
	level.bradley_commerce.fireAtDefaultTargets = false;
	
	/*-----------------------
	COMMERCE WALL FRIENDLIES CAN DIE
	-------------------------*/	
	array_thread( friendlies_commerce_street,::stop_magic_bullet_shield );
	array_thread( friendlies_commerce_street,::AI_redshirt_think );
	
	/*-----------------------
	PLAYER TEAM MOVES UP
	-------------------------*/	
	flag_wait_or_timeout( "player_approaching_commerce", 5 );
	triggersEnable( "colornodes_commerce_approach", "script_noteworthy", true );
	colornodes_commerce_approach = getentarray( "colornodes_commerce_approach", "script_noteworthy" );


	thread dialogue_nag_cross_the_street();
	
	flag_set( "lav_is_suppressing" );
	
	hostiles = getaiarray( "axis" );
	foreach( guy in hostiles )
	{
		if ( !isdefined( guy ) )
			continue;
		guy.ignoresuppression = false;
		guy.aggressivemode = false;	//dont linger at cover when you cant see your enemy
	}

	flag_wait_any( "leader_orders_everyone_across_street", "player_entered_commerce_right", "player_entered_commerce_left" );
	
	if ( !flag( "player_crossing_street" ) )
	{
		trig_colornode = getclosest( level.player.origin, colornodes_commerce_approach );
		trig_colornode notify( "trigger", level.player );
	}

	
	level.squad = remove_dead_from_array( level.squad );
	array_thread( level.squad,::AI_ignored_and_oblivious_on );

	/*-----------------------
	PLAYER AT COMMERCE STAIRS...BLOCK OTHER ENTRANCE SO AI GO TO PLAYER DOOR
	-------------------------*/	
	flag_wait( "player_entering_commerce" );
	
	//make AI aware of enemies and not ignored
	level.squad = remove_dead_from_array( level.squad );
	array_thread( level.squad,::AI_ignored_and_oblivious_off );
	
	commerce_blocker_right = getent( "commerce_blocker_right", "targetname" );
	commerce_blocker_left = getent( "commerce_blocker_left", "targetname" );
	aBlockers = [];
	aBlockers[ 0 ] = commerce_blocker_right;
	aBlockers[ 1 ] = commerce_blocker_left;
	blocker = getfarthest( level.player.origin, aBlockers );
	blocker show();
	blocker solid();
	blocker disconnectpaths();
	
	/*-----------------------
	PLAYER INSIDE LOBBY
	-------------------------*/	
	flag_wait_either( "player_entered_commerce_left", "player_entered_commerce_right" );
	thread drone_flood_stop( "drones_flood_monument" );
	thread drone_flood_stop( "drones_flood_monument2" );
	
	
	array_thread( level.chattertrigsexteriror,::trigger_off );
	array_thread( level.chattertrigsinterior,::trigger_on );
	triggersEnable( "colornodes_commerce_bot_to_top", "script_noteworthy", true );
	
	flag_clear( "lav_is_suppressing" );
	hostiles = getaiarray( "axis" );
	foreach( guy in hostiles )
	{
		if ( !isdefined( guy ) )
			continue;
		guy.ignoresuppression = true;
		guy.aggressivemode = true;	//dont linger at cover when you cant see your enemy
	}
	
	thread autosave_by_name( "commerce_entered" );

	flag_set( "obj_follow_sgt_macey_complete" );
	triggersEnable( "colornodes_elevators", "script_noteworthy", true );

	thread AI_delete_when_out_of_sight( friendlies_commerce_street, 1024 );
	
	thread dialogue_nag_get_to_elevator();
	
	/*-----------------------
	DEAL WITH FRIENDLIES ON OPPOSITE SIDE
	-------------------------*/	
	//array_thread( level.squad,::disable_ai_color );
	//TODO
	
	/*-----------------------
	BRADLEY OWNS REMAINING ENEMIES
	-------------------------*/	
	volume_commerce_lobby_upper = getent( "volume_commerce_lobby_upper", "targetname" );
	upper_floor_enemies = volume_commerce_lobby_upper get_ai_touching_volume( "axis" );
	
	if ( ( isdefined( upper_floor_enemies ) ) && ( upper_floor_enemies.size > 0 ) )
		level.bradleyPreferredTargets = upper_floor_enemies;
	
	wait( 1 );
	thread commerce_first_floor_enemies_dead_monitor();
	
	level.bradley_commerce.firing = false;
	
	delaythread( 4,::m203_hint );


	
	flag_wait_either( "commerce_first_floor_enemies_dead", "player_middle_commerce_first_floor" );
	//thread friendly_speed_adjustment_off();
	
	level.player reset_threatbias();
	
	//friendlies move to elevator...if not done already
	if ( !flag( "player_middle_commerce_first_floor" ) )
	{
		trig_colornode = getent( "colornodes_elevators", "script_noteworthy" );
		trig_colornode notify( "trigger", level.player );
	}
	
	/*-----------------------
	BRADLEY FIRING AGAIN, RANDOMLY
	-------------------------*/	
	flag_wait( "player_heading_up_to_mezzanine" );
	thread AI_drone_cleanup( "all", 1024, true );
	level.bradleyPreferredTargets = undefined;
	level.bradley_commerce.fireAtDefaultTargets = true;
	level.bradley_commerce.firing = true;

	/*-----------------------
	MEZZANINE BLOCKERS TO GUIDE PLAYER
	-------------------------*/	
	mezzanine_blockers = getentarray( "mezzanine_blockers", "targetname" );
	array_thread( mezzanine_blockers,::show_entity );
	
	/*-----------------------
	BRADLEY STOPS FIRING AS PLAYER ENTERS TOP MEZZ
	-------------------------*/	
	flag_wait( "ask_bradley_to_stop_firing" );
	level.bradley_commerce.firing = false;
	
	/*-----------------------
	CLEANUP TRENCHES AND CLOSE DOOR TO MEZZANINE
	-------------------------*/	
	flag_wait( "player_entering_top_elevator_area" );
	//thread drone_flood_stop( "drone_flood_pavlov" );
	
	thread AI_cleanup_non_squad( "all", 128 );
	
	
	//close door back to mezzanine only if friendlies are close to player
	//mezzanine_door = getent( "mezzanine_door", "targetname" );
	//mezzanine_door show_entity();
	
	//delaythread( 2, maps\_mortar::bog_style_mortar_off, 2 );
}

AI_commerce_rpg_upper_think()
{
	self endon( "death" );
	self.a.disableLongDeath = true;// no long death on these guys
	level endon( "player_approaching_commerce" );
	flag_wait( "player_commerce_trench_03" );
	
	//teleport to closest commerce door and kill self when player too near
	aNodes = getnodearray( "commerce_lobby_teleport_nodes", "targetname" );
	eNode = getClosest( level.player.origin, aNodes );
	self forceTeleport( eNode.origin, eNode.angles );
	self setgoalpos( self.origin );
	self.attackeraccuracy = 0;
	volume_commerce_front = getent( "volume_commerce_front", "targetname" );
	self setgoalvolumeauto( volume_commerce_front ); 
	flag_wait_either( "player_crossing_street", "leader_orders_everyone_across_street" );
	wait( randomfloatrange( 0, 1 ) );
	thread ambient_mortar_explosion( self.origin );
	self kill();
}


m203_hint()
{
	//level.grenadeHint_timeout = gettime() + 8000;
	//level.player thread display_hint( "grenade_launcher" );
	
	//TODO...use dialogue hint instead
	//Sgt. Foley	Use your grenade launchers!	
	//dcburn_mcy_grenadelaunch
}

seaknight_drone_loaders( spawner, sFlagToSetWhenLoaded, sFlagToStop )
{
	i = 1;
	while( !flag( sFlagToStop ) )
	{
		dude = spawner dronespawn();
		//dude.runcycle = level.scr_anim[ "generic" ][ "wounded_walkcycle" ];
		//self.moveplaybackrate = .5;
		wait( randomfloatrange( 1, 2.5 ) );
	}
	seaknight_drone_loaders = get_drones_with_targetname( spawner.targetname );
	seaknight_drone_loaders = remove_dead_from_array( seaknight_drone_loaders );
	waittill_dead( seaknight_drone_loaders );
	flag_set( sFlagToSetWhenLoaded );
}

vehicle_littlebird_gopath_when_loaded_and_flag_set( sFlag, pathStart )
{
	while ( self.riders.size < 6 )
		wait( .1 );
	
//	newArray = [];
//	foreach( guy in self.riders )
//	{
//		if( isdefined( guy.magic_bullet_shield ) )
//			guy stop_magic_bullet_shield();
//		dude = maps\_vehicle_aianim::convert_guy_to_drone( guy );
//		dude setcontents( 0 );
//	}
//	self.riders = newArray;
	flag_wait( sFlag );
	
	/*-----------------------
	LITTLEBIRD TAKES OFF
	-------------------------*/
	//self thread vehicle_liftoff( 3 );
	//wait( 1 );
	
	self thread vehicle_paths( pathStart );
	self setmaxpitchroll( 20, 50 );
	wait( 2 );
	self vehicle_ai_event( "idle_alert_to_casual" );
	self Vehicle_SetSpeed( 25 );
	self.script_vehicle_selfremove = 1;
	wait( 5 );
	array_thread( self.riders,::stop_magic_bullet_shield );
	self thread vehicle_delete_when_out_of_sight();
}

drone_warrior_hydrant_think()
{
	self endon( "death" );

	flag_wait( "player_mid_trench" );

	play_sound_in_space( "mortar_incoming", self.origin );
	playfx( level._effect[ "mortar" ][ "dirt" ], self.origin );
	earthquake( 0.25, 0.75, self.origin, 1250 );
	thread play_sound_in_space( level.scr_sound[ "mortar" ][ "dirt" ], self.origin );
	self notify( "stop_drone_fighting" );
	thread play_sound_in_space( "generic_death_american_1", self.origin );
	self.deathanim = level.scr_anim[ "generic" ][ "deathanim_mortar_00" ];
	self kill();
	
}

spot_targets_think()
{
	movetime = 2.4;
	moveDistVert = 50;
	moveDistHor = 50;
	//self thread debug_message( "ORG", undefined, 9999, self );
	wait( movetime );
	while( !flag( "obj_commerce_defend_snipe_given" ) )
	{
		//up
		self moveTo( self.origin + ( 0, 0, moveDistVert ), movetime, 1, 1 );
		wait( movetime );
		//right
		self moveTo( self.origin + ( moveDistHor, 0, 0 ), movetime, 1, 1 );
		wait( movetime );
		//down
		self moveTo( self.origin + ( 0, 0, moveDistVert * ( -1 ) ), movetime, 1, 1 );
		wait( movetime );
		//left
		self moveTo( self.origin + (  moveDistHor * ( -1 ), 0, 0 ), movetime, 1, 1 );
		wait( movetime );
	}
	
	self delete();
}

bunker_mortars()
{
	bunker_mortars = false;
	while( !flag( "bunker_door_closed" ) )
	{
		if ( !flag( "player_inside_bunker" ) )
		{
			maps\_mortar::bunker_style_mortar_off_nowait( 0 );
			bunker_mortars = false;
		}
		else if ( bunker_mortars == false )
		{
			maps\_mortar::bunker_style_mortar_on( 0 );
			bunker_mortars = true;
		}
		wait( 3 );
	}
	maps\_mortar::bunker_style_mortar_off_nowait( 0 );
	flag_set( "delete_bunker_mortars" );
}

bunker_radio_chatter()
{
	level.bunker_radio_org = spawn( "script_origin", level.player.origin );
	level.bunker_radio_org linkto( level.player );
	level.bunker_radio_org.linked = true;
	
	level endon( "javelin_is_owning_fools" );
	
	//Goliath, Goliath, this is Stalker Two-One, standby for report one-dash-three over.	
	bunker_radio( "dcburn_rm1_report1dash3" );
	
	//Stalker Two-One this is Goliath, send your traffic, over. 	
	bunker_radio( "dcburn_rm2_sendtraffic" );
	
	//Line Whiskey - four zero personnel... Line X-Ray, three columns of mechanized infantry, break. 	
	bunker_radio( "dcburn_rm1_40personnel" );
	
	//Line Yankee, two-zero Bravo-Tango-Romeos, five two five, six three niner. 	
	bunker_radio( "dcburn_rm1_lineyankee" );
	
	//Line Zulu, Russian paratroopers, break. 	
	bunker_radio( "dcburn_rm1_linezulu" );
	
	//Line Alpha, one niner one five Zulu, Line Echo, AK47s and RPGs. How copy so far, over?	
	bunker_radio( "dcburn_rm1_linealpha" );
	
	//Yeah, say again, Line Yankee, over.	
	bunker_radio( "dcburn_rm2_sayagain" );
	
	//Roger, I say again Line Yankee, Line Yankee, two-zero Bravo-Tango-Romeos, five two five, six three niner, how copy?	
	bunker_radio( "dcburn_rm1_sayagain" );
	
	//Solid copy. Do you have any remarks, over?	
	bunker_radio( "dcburn_rm2_remarks" );
	
	//Negative, no further remarks at this time, over.	
	bunker_radio( "dcburn_rm1_noremarks" );
	
	//Roger, solid copy on all. Stalker, do not engage unless compromised, and continue to report every ten mikes on enemy disposition. We need as all the intel we can get on any grid north of the White House. Goliath out.	
	bunker_radio( "dcburn_rm2_needintel" );
	
	//Grizzly Actual, this is Wolverine Two, we are diverting to engage enemy paratroopers, how copy, over?	
	bunker_radio( "dcburn_rm3_engparatroop" );
	
	//This is Grizzly, solid copy. All Grizzly teams, be advised, Wolverine is now engaged with foot-mobiles to our nine o'clock.	
	bunker_radio( "dcburn_rm4_footmobiles" );
	
	//Grizzly, this is Grizzly Two, interrogative - are we cleared to use our thermobaric LAWs, over?	
	bunker_radio( "dcburn_rm5_thermlaws" );
	
	//Two-Three, what's your target?	
	bunker_radio( "dcburn_rm4_whattarget" );
	
	//Snipers confirmed on the Boomerang in Building Alpha-Two-Five. It'll be easier if we drop the whole building, over.	
	bunker_radio( "dcburn_rm5_dropbuilding" );
	
	//Two-Three, confirm Alpha-Two-Five is the Federal Reserve Building, over.	
	bunker_radio( "dcburn_rm4_fedresbuild" );
	
	//Two, Two-Three, roger that, they're all over the top floor.	
	bunker_radio( "dcburn_rm5_allover" );
	
	//I'm going to have to check in with Overlord. Standby.	
	bunker_radio( "dcburn_rm4_checkin" );
	
	//Two-Three. Roger.	
	bunker_radio( "dcburn_rm5_roger" );
	
	//Overlord, Overlord, this is Grizzly Actual. Grizzly Two has confirmed enemy snipers in Building Alpha-Two-Five and is requesting permission to engage with thermobaric LAWs over.	
	bunker_radio( "dcburn_rm4_thermlaws" );
	
	//Overlord copies all. Standby.	
	bunker_radio( "dcburn_rm6_copiesall" );
	
	//Roger, standing by.	
	bunker_radio( "dcburn_rm4_stndingby" );
	
	//Grizzly this is Overlord. The use of thermobaric weapons is now authorized. Go ahead and level the building. Out.	
	bunker_radio( "dcburn_rm6_thermlawsauth" );
	
	//Grizzly Two, this is Grizzly Actual. You are approved to level the building, over.	
	bunker_radio( "dcburn_rm4_approved" );
	
	//Solid copy.	
	bunker_radio( "dcburn_rm5_solidcopy" );
	
	//Grizzly Two-Two, Echo Five Kilo, this is Grizzly Two, you are approved to engage the snipers in Building Alpha-Two-Five.	
	bunker_radio( "dcburn_rm5_apprengage" );
	
	//Roger that. Engaging targets with thermobaric LAWs.	
	bunker_radio( "dcburn_rm1_engagingtarg" );
	
	//Grizzly Two, target has been suppressed.	
	bunker_radio( "dcburn_rm1_targetsupp" );
	
	//All Grizzly personnel, this is Grizzly Actual. We have neutralized the snipers in Building Alpha-Two-Five. Saddle up - we're oscar mike. Out.	
	bunker_radio( "dcburn_rm4_saddleup" );
	
	//Three-One this is Three-Three, BTR-60 at your two o'clock!	
	bunker_radio( "dcburn_rm5_btr60" );
	
	//Roger, engaging with LAW rocket!	
	bunker_radio( "dcburn_rm6_lawrocket" );
	
	//Hunter Two-One this is Two Two, we have engaged the enemy at Logan Circle Park!	
	bunker_radio( "dcburn_rm1_logancircpark" );
	
	//Two-One Two Three! Two-Two is down, repeat two-two is down! 	
	bunker_radio( "dcburn_rm2_22isdown" );
	
	//Three-Three this is Three-One, interrogative: where is the air support! Over!	
	bunker_radio( "dcburn_rm3_airsupport" );
	
	//One-Three, One-Two, be advised, our Mark-19 is down, I repeat our Mark-19 is down, over!	
	bunker_radio( "dcburn_rm5_mark19down" );
	
	//All Hunter teams, Two-Bravo is in contact with Overlord FAC! Break, retrograde to Franklin Square but continue to delay the enemy in your sectors!! Out!	
	bunker_radio( "dcburn_rm4_retrograde" );
	
	//Two, Two-Three! Be advised, we have visual on enemy paratroopers at grid Papa Uniform 2 5 niner, 1 1 niner! We are low on ammo and have sustained major casualties! 	
	bunker_radio( "dcburn_rm3_lowammo" );
	
	//One-Zero-Zero enemy foot-mobiles and one column of five BTR-60s will be on top of us in less than two minutes, break! Enemy is unaware of our presence at this time, how copy, over?	
	bunker_radio( "dcburn_rm3_5btr60s" );
	
	//Solid copy on all. Two-Three standby, I'm calling it in. Warhammer this is Two-Bravo, standby for fire mission.	
	bunker_radio( "dcburn_rm2_callingitin" );
	
	//Wolverine Two, this is Warhammer, standing by for fire mission.	
	bunker_radio( "dcburn_ra2_standingby" );
	
	//Grid to suppress: Golf Foxtrot 2 7 niner, 3 1 6. Grid to mark, Golf Foxtrot, 2 7 8, 5 6 niner, over!	
	bunker_radio( "dcburn_rm2_gridtomark" );
	
	//Grid to suppress: Golf Foxtrot 2 7 niner, 3 1 6. Grid to mark, Golf Foxtrot, 2 7 8, 5 6 niner, out.	
	bunker_radio( "dcburn_ra2_gridtosuppress" );
	
	//Column of BTR-60s with attached infantry, request splash, danger close, over.	
	bunker_radio( "dcburn_rm2_reqsplash" );
	
	//Column of BTR-60s with attached infantry, request splash, danger close, out.	
	bunker_radio( "dcburn_ra2_dangerclose" );
	
	//Message to observer - Bravo, two rounds. Two guns in effect. Target number Alpha Whiskey, 3 2 3, over.	
	bunker_radio( "dcburn_ra2_mess2ob" );
	
	//Message to observer - Bravo, two rounds. Two guns in effect. Target number Alpha Whiskey, 3 2 3, out.	
	bunker_radio( "dcburn_rm2_2gunseffect" );
	
	//Shot - over.	
	bunker_radio( "dcburn_ra2_shot" );
	
	//Shot - out.	
	bunker_radio( "dcburn_rm2_shot" );
	
	//Splash - over.	
	bunker_radio( "dcburn_rm2_splash" );
	
	//Splash - out.	
	bunker_radio( "dcburn_ra2_splash" );
	
	//Two, Two-Three, target is partially suppressed but moving in quickly! (off mike) Hit that BTR with the LAW! Take it out! Take it out!	
	bunker_radio( "dcburn_rm3_takeitout" );
	
	//Wolverine One-Two, this is Wolverine Two-Actual. Gimme a sitrep. How far are you from Two-Three's position, over.	
	bunker_radio( "dcburn_rm2_linkup" );
	
	//Two-Actual, One-Two! We're dug in by the Capitol Building and are taking heavy fire from the east! Two-Three is about six-hundred meters to the south of us, over!	
	bunker_radio( "dcburn_rm4_dugin" );
	
	//One-Two, can you link up with Two-Three from where you are, over?	
	bunker_radio( "dcburn_rm2_sitrep" );
	
	//Negative negative! (off mike) Gray, get the two-forty Golf setup on our right flank move move! (on mike) They're rollin' us with a couple platoons of T-80s! Request Broken Arrow! Repeat - Broken Arrow!	
	bunker_radio( "dcburn_rm4_brokenarrow" );
	
	//Roger that! Solid copy on Broken Arrow! Major, it's been an honor! Out.	
	bunker_radio( "dcburn_rm2_brokearrow" );
	
	//Viper Three Actual, this is Viper Actual, gimme a sitrep over!	
	bunker_radio( "dcburn_rm5_sitrep" );
	
	//Viper Actual this is Three-Bravo, Echo Four Sierra! Three-Bravo-Actual is KIA! Repeat, Three-Bravo-Actual is KIA!! Break! We are down to three men, I repeat, we are down to three men how copy over!!	
	bunker_radio( "dcburn_rm6_kia" );
	
	//Solid copy Three-Bravo, be advised, I have Warhammer standing by, switch to tac freq 1 7 niner and go to town, over.	
	bunker_radio( "dcburn_rm5_tacfreq" );
	
	//Roger that! Switching to 1 7 niner!! Out!	
	bunker_radio( "dcburn_rm6_switching" );
	
	//Warpig Two, this is Warpig Two-One, I have visual on enemy armor closing twelve klicks due north of the Washington Monument, supported by infantry, APCs and attack helos, how copy over!	
	bunker_radio( "dcburn_rm1_12klicksnorth" );
	
	//Contact left contact left!!	
	bunker_radio( "dcburn_rm2_contactleft" );
	
	//Taking fire, eleven o'clock, one hundred meters!	
	bunker_radio( "dcburn_rm3_takingfire" );
	
	//Two-One-Alpha, Two-Two-Alpha - one of Warpig Two's victors just took a hit!!! Repeat, one of Warpig Two's victors has been hit!!!	
	bunker_radio( "dcburn_rm4_tookahit" );
	
	//Warpig Two, this is Wolverine Two, what's your status over!!!	
	bunker_radio( "dcburn_rm5_status" );
	
	//Wolverine Two this is Warpig Two-One!! We are taking heavy fire along the Potomac! Break! Two-Two-Echo's victor is gone - they took a direct hit from a Hind -	
	bunker_radio( "dcburn_rm1_heavyfire" );
	
	//Ambush!!!! Left side left side!!!	
	bunker_radio( "dcburn_rm2_ambush" );
	
	//Contact left! Contact left!!	
	bunker_radio( "dcburn_rm3_contactleft" );
	
	//Two-Three! RPG at your three o'clock!!	
	bunker_radio( "dcburn_rm4_rpg" );
	
	//Get the Mark 19 on that sector, cover that sector!!!	
	bunker_radio( "dcburn_rm5_coversector" );
	
	//Overlord, this is War Horse Five-One checking in with you, flight of two A-10s, holding area Lima, angels ten. Four by BLU-97s, two thousand rounds for the section. Ready for tasking.	
	bunker_radio( "dcburn_rp1_tasking" );
	
	//Roger War Horse Five-One, I have Stalker Two on the ground requesting immediate CAS at map grid Charlie Alpha, 3 1 5, niner niner 2, break. Push to IP Buick, how copy over?	
	bunker_radio( "dcburn_fac_pushtoipbuick" );
	
	//Solid copy. Map grid Charlie Alpha, 3 1 5, niner niner 2, pushing to IP Cadillac.	
	bunker_radio( "dcburn_rp1_mapgrid" );
	
	//Stalker Two, you have War Horse Five-One, flight of two A-10s at angels ten, pushing to IP Cadillac.	
	bunker_radio( "dcburn_fac_2a10s" );
	
	//Stalker copies all. Out.	
	bunker_radio( "dcburn_rm2_stalkercopies" );
	
	//War Horse Five-One, this is Stalker, standby for information!	
	bunker_radio( "dcburn_rm2_standby" );
	
	//War Horse standing by. 	
	bunker_radio( "dcburn_rp1_stndingby" );
	
	//TOT two zero! Close-in-fire-support, non standard, minus one to minus one two, then plus four to plus two. Gun target line, zero five zero. I'm gonna talk you onto the target, how copy over?	
	bunker_radio( "dcburn_rm2_talktotarg" );
	
	//Solid copy on all. Go ahead, over.	
	bunker_radio( "dcburn_rp1_goahead" );
	
	//North-northwest of Union Station, about 800 metres, there is an oval track! Call contact!	
	bunker_radio( "dcburn_rm2_ovaltrack" );
	
	//Contact.	
	bunker_radio( "dcburn_rp1_contact" );
	
	//At the south edge of that oval track is a road running along an east-west axis to the White House. Call contact!	
	bunker_radio( "dcburn_rm2_ewaxis" );
	
	//Contact.	
	bunker_radio( "dcburn_rp1_contact" );
	
	//We are observing from a position 200 metres south of Logan Circle Park, looking east down that road. Call contact!	
	bunker_radio( "dcburn_rm2_logancircpark" );
	
	//Contact.	
	bunker_radio( "dcburn_rp1_contact" );
	
	//Your target is a column of six enemy T-72s moving from east to west along that road. The convention center is about halfway between our OP and the oval track, be advised, major civvies are packed into that convention center, awaiting evac. 	
	bunker_radio( "dcburn_rm2_yourtarget" );
	
	//War Horse has contact on all. We are passing IP Cadillac, rolling in to heading zero-nine-zero.	
	bunker_radio( "dcburn_rp1_rollingin" );
	
	//Roger that. Bring the rain.	
	bunker_radio( "dcburn_rm2_bringrain" );
	
	//War Horse off safe. Guns guns guns. 	
	bunker_radio( "dcburn_rp1_offsafe" );
	
	//Guns guns guns.	
	bunker_radio( "dcburn_rp1_guns" );
	
	//Dash two off safe. Rollin' in. 	
	bunker_radio( "dcburn_rp2_offsafe" );
	
	//Apex inbound! Break right break right!...I'm hit! Ejecting!	
	bunker_radio( "dcburn_rp1_ejecting" );
	
	//I can't see it I can't see - (static burst)	
	bunker_radio( "dcburn_rp2_cantseeit" );
	
	//Overlord, this is Stalker Two, War Horse Five-One, flight of two A-10s is down, I see only one chute deploying. BDA is 80 over 15. Convention center is taking HEAT rounds from T-72s, it uh, doesn't look good from where we are, how copy over?	
	bunker_radio( "dcburn_rm2_onechute" );
	
	//Stalker Two, this is Overlord. Solid copy on all. We do not have any other close-air support in the area at this time. Displace to a more secure location south of K Street and await further instructions. Out. 	
	bunker_radio( "dcburn_fac_southkstreet" );
}

dialogue_bunker()
{
	level endon( "bunker_door_closed" );
	flag_wait( "player_bunker_walk_01" );
	
	bunker_radio_org_room2 = getent( "bunker_radio_org_room2", "targetname" );
	bunker_radio_org_room1 = getstruct( "bunker_radio_org_room1", "targetname" );
	bunker_radio_org_room2 endon( "death" );
	bunker_radio_org_room1 endon( "death" );
	
	//Marine 5	We've got wounded!	
	bunker_radio_org_room2  play_sound_in_space( "dcburn_gm5_gotwounded" );
	wait( 1 );
	//Marine 3	He's all yours doc.	
	bunker_radio_org_room1 play_sound_in_space( "dcburn_gm3_allyoursdoc" );	
	
	flag_wait( "player_bunker_walk_01a" );
	
	//Marine 1	Give him some water and keep him still.	
	bunker_radio_org_room2 play_sound_in_space( "dcburn_gm1_keepstill" );
	
	//Marine 1	Corporal, where's your Canteen?
	bunker_radio_org_room2 play_sound_in_space( "dcburn_gm1_wherescanteen" );
	
	wait( 1 );
	
	//Marine 2	Right here, L-T.	
	bunker_radio_org_room2 play_sound_in_space( "dcburn_gm2_righthere" );

	wait( 2 );
	//Marine 6	He's stable for now. Get him to the evac site.	
	bunker_radio_org_room1 play_sound_in_space( "dcburn_gm6_stablefornow" );

	//Marine 4	Christenson, two stretchers to Rajan.
	bunker_radio_org_room1 play_sound_in_space( "dcburn_gm4_2stretchers" );	



}

bunker_radio( sLine )
{
	if ( !isdefined( level.bunker_radio_org ) )
		return;
	if ( isdefined( level.bunker_radio_org.deleteme ) )
	{
		level.bunker_radio_org delete();
	}
	
	level.bunker_radio_org playsound( sLine, "done" );
	level.bunker_radio_org waittill( "done" );
}

dialogue_nag_cross_the_street()
{
	level endon( "player_entered_commerce_right" );
	level endon( "player_entered_commerce_left" );
	
	flag_wait( "trenches_dialogue_done" );
	
	while( true )
	{
		if ( !flag( "player_crossing_street" ) )
		{
			//Sgt. Macey	All right! RCT One's LAV has them suppressed! Get ready to move on my mark!
			level.teamleader dialogue_execute( "dcburn_mcy_humveesupp" );
		}



		if ( !flag( "player_crossing_street" ) )
		{
			//Sgt. Macey	Ready�.!	
			level.teamleader dialogue_execute( "dcburn_mcy_ready" );
	
			//Sgt. Macey	Go go go!!! Move up! Move up!	
			level.teamleader dialogue_execute( "dcburn_mcy_gomoveup" );
		}

		flag_set( "leader_orders_everyone_across_street" );
		
		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_entering_commerce" ) )
			break;
		
		//Sgt. Macey	Move up and stay out of that Humvee's line of fire!	
		radio_dialogue("dcburn_mcy_lineoffire");

		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_entering_commerce" ) )
			break;
			
		//Sgt. Macey	Move! Move!	
		radio_dialogue("dcburn_mcy_movemove");

		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_entering_commerce" ) )
			break;
		//Sgt. Macey	The 50cal has them suppressed! Move in! Move in!	
		radio_dialogue("dcburn_mcy_50calsupp");

		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_entering_commerce" ) )
			break;
		//Sgt. Macey	Push, push, push! We're sitting ducks out here!	
		radio_dialogue("dcburn_mcy_sittingducks");
		
		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_entering_commerce" ) )
			break;
		//Sgt. Macey	Get out of the killzone before you get your ass blown off! Move up!	
		radio_dialogue("dcburn_mcy_blownoff");

		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_entering_commerce" ) )
			break;
		//Sgt. Macey	Move up, get out of the killzone!	
		radio_dialogue("dcburn_mcy_moveup");

		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_entering_commerce" ) )
			break;
		//Sgt. Macey	Get your ass out of the killzone and into the target building, NOW!	
		radio_dialogue( "dcburn_mcy_intotargbuilding" );
		
	}
}

dialogue_nag_get_to_elevator()
{
	grenadeHintGiven = false;
	//Sgt. Macey: Move up! Go! Go!
	level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_00" );
	flag_set( "obj_commerce_given" );
	
	level endon( "player_approaching_bottom_elevators" );
	
	
	while( !flag( "player_approaching_bottom_elevators" ) )
	{

		wait( randomintrange( 5, 8 ) );

		if ( flag( "player_approaching_bottom_elevators" ) )
			break;
		
		if ( grenadeHintGiven == false )
		{
			//Sgt. Foley	Use your grenade launchers!	
			level.teamleader dialogue_execute( "dcburn_mcy_grenadelaunch" );
			grenadeHintGiven = true;
			wait( randomintrange( 7, 11 ) );
		}

		if ( flag( "player_approaching_bottom_elevators" ) )
			break;
		//Sgt. Macey: Move in!
		level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_01" );
		
		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_approaching_bottom_elevators" ) )
			break;
		//Sgt. Macey: Push forward! Move! Move!
		level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_02" );
		
		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_approaching_bottom_elevators" ) )
			break;
		//Sgt. Macey: Keep moving forward!
		level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_03" );
		
		wait( randomintrange( 7, 11 ) );
		if ( flag( "player_approaching_bottom_elevators" ) )
			break;
		//Sgt. Macey: Move up! Move up!
		level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_04" );
		wait( randomintrange( 7, 11 ) );
	}
}

commerce_first_floor_enemies_dead_monitor()
{
	volume_commerce_lobby_lower = getent( "volume_commerce_lobby_lower", "targetname" );
	enemies = volume_commerce_lobby_lower get_ai_touching_volume( "axis" );
	
	while( enemies.size > 0 )
	{
		wait( .5 );
		enemies = volume_commerce_lobby_lower get_ai_touching_volume( "axis" );
	}
	flag_set( "commerce_first_floor_enemies_dead" );
}

dialogue_trenches()
{
	
	bunker_radio_org_room2 = getent( "bunker_radio_org_room2", "targetname" );
	
	flag_wait( "player_bunker_walk_02" );
	
	//Overlord Radio Voice	Ensure all weapons are condition-one and get topside to provide support. Casevac birds are under heavy fire.	
	bunker_radio_org_room2 thread play_sound_on_entity( "dcburn_hqr_ensureweapons" );
	
	flag_wait( "player_bunker_walk_03" );
	
	//Ranger 1: On your feet. We're Oscar Mike
	level.friendly03 thread dialogue_execute( "dcburn_gr1_onyourfeet" );
	
	flag_wait( "player_approaching_bunker_exit_hall" );
	
	//Sgt. Macey   Roger, Two-One out.
	level.teamleader dialogue_execute( "dcburn_mcy_rogerout" );
	
	//Sgt. Macey: Listen up! This evac site is getting hit hard and we need to buy 'em some time. Hooah?
	level.teamleader dialogue_execute( "dcburn_mcy_evachithard" );
	
	flag_set( "obj_follow_sgt_macey_given" );
	
	level.friendly03 thread play_sound_on_entity( "dcburn_hoh_1" );
	
	flag_wait( "player_leaving_bunker" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	array_thread( level.chattertrigsexteriror,::trigger_on );

	//Overlord HQ Radio Voice	All callsigns, the LZ is under heavy fire. Uncover enemy positions and engage potential targets.	
	radio_dialogue("dcburn_hqr_uncoverengage");
	
	flag_wait( "javelin_is_owning_fools" );


	
	//Cpl. Dunn	They've got optics on us..snipers, rpg teams and heavy arms fire, all floors...12 o'clock due west of our position.	
	thread radio_dialogue( "dcburn_cpd_opticsonus" );
	
	flavorbursts_on( "allies" );
	level.bunker_radio_org.deleteme = true;
	
	wait( 4 );
	thread dialogue_random_incoming_javelins();
	
	wait( .75 );

	//Sgt. Macey	Overlord, this is Hunter 2-1. Requesting airstrike, over.	
	level.teamleader dialogue_execute( "dcburn_mcy_reqairstrike" );

	//Overlord HQ Radio Voice	Uh, negative Two-One, all available air units are currently tasked with multiple casevacs along the Potomac. Proceed west to the target building and provide support, out.	
	radio_dialogue("dcburn_hqr_alongpotomac");
	
	thread autosave_by_name( "trench_start" );
	
	//Sgt. Macey	Everyone move up, get out of the killzone. We gotta buy some time for those casevac birds.	
	level.teamleader dialogue_execute("dcburn_mcy_buytime");

	flag_wait( "player_trench_capitol_failsafe" );
	
	//Sgt. Macey	Overlord this is Hunter Two-One. We're screening west with no adjacent support, and friendly victors from RCT One are hauling ass past us, over.	
	level.teamleader dialogue_execute("dcburn_mcy_haulingpastus");
	
	//Overlord HQ Radio Voice: Roger. RCT One has already peeled off an LAV to provide suppression, over."
	thread radio_dialogue("dcburn_hqr_humvee");
	
	wait( 3 );
	flag_set( "bradley_can_start_firing" );
	
	//Sgt. Macey	Copy that.	
	//radio_dialogue("dcburn_mcy_copythat");
	
	//Cpl. Dunn	We're running the gauntlet with no armor or air and they give us one Humvee�	
	//radio_dialogue("dcburn_cpd_gauntlet");
	
	//Marine 3	Welcome to the suck.	
	//radio_dialogue("dcburn_gm3_welcometosuck");
	
	//Sgt. Macey	Hey - no more talking. Stay frosty.	
	//radio_dialogue("dcburn_mcy_stayfrosty");
	
	flag_wait( "commerce_rappelers_inserting" );
	wait( 1 );

	if (  !flag( "player_commerce_trench_03" ) )
	{
		//Overlord HQ Radio Voice	Hunter Two-One, this is Overlord. SEAL Team Six is maneuvering into position on the northwest corner of the target building. Link up with them on the top floor and eliminate enemy fire teams, over.	
		radio_dialogue("dcburn_hqr_linkup");
		
		//Sgt. Macey	Roger solid copy on all.	
		//radio_dialogue("dcburn_mcy_solidcopyonall");
	}

	if (  !flag( "player_commerce_trench_03" ) )
	{
		//Sgt. Macey	Keep your fire low...we got friendlies inserting up there.	
		level.teamleader dialogue_execute("dcburn_mcy_firelow");
	}

	//Cpl. Dunn	I see foot mobiles...12 o'clock, 100 meters!	
	//radio_dialogue("dcburn_cpd_footmobiles");
	
	flag_set( "trenches_dialogue_done" );
	
}

javelins_trench()
{
	flag_wait( "player_approaching_bunker_exit" );
	thread autosave_by_name( "javelins_trench" );
	
	m1a1_trench = spawn_vehicle_from_targetname( "m1a1_trench" );
	
	flag_wait( "player_leaving_bunker" );
	
	//helicopter_crash_apache_01 = getent( "helicopter_crash_apache_01", "targetname" );
	spawn_vehicles_from_targetname_and_drive( "apache_01" );
	//apache.perferred_crash_location = helicopter_crash_apache_01;
	//apache thread apache_think();
	
	javelin_source_org = getent( "javelin_source_org", "targetname" );
	monument_heli_owned = spawn_vehicle_from_targetname( "monument_heli_owned" );
	//monument_heli_owned Vehicle_TurnEngineOff();
	
	m1a1_owned = spawn_vehicle_from_targetname( "m1a1_owned" );
	m1a1_owned2 = spawn_vehicle_from_targetname( "m1a1_owned2" );
	m1a1_owned2 maps\_vehicle::godon();
	javelin_vehicle_targets = getentarray( "javelin_vehicle_targets", "targetname" );
	array_thread( javelin_vehicle_targets,:: vehicles_cheap_waittill_destroyed_think );
	
	flag_wait( "player_exiting_start_trench" );
	
	spawn_vehicles_from_targetname_and_drive( "jets_monument_01" );
	
	wait( 2 );
	thread gopath( m1a1_owned );
	
	/*-----------------------
	HELI OWNED BY ENEMY JAV
	-------------------------*/	
	flag_wait_either( "looking_commerce_enemy_javelin", "commerce_enemy_javeling_failsafe" );
	
	/*-----------------------
	SPAWN SOME FRIENDLY FODDER TO SHOOT AT
	-------------------------*/	
	spawner = getent( "commerce_friendly_fodder", "targetname" );
	spawner spawn_ai( true );

	/*-----------------------
	HELI OWNED BY JAV
	-------------------------*/	
	newMissile = MagicBullet( "javelin_noimpact", javelin_source_org.origin, monument_heli_owned.origin );
	playfx( getfx( "javelin_muzzle" ), javelin_source_org.origin );
	newMissile thread javelin_earthquake();	//custom function to ensure an earthquake on impact
	newMissile Missile_SetTargetPos( monument_heli_owned.origin ); 
	newMissile Missile_SetFlightmodeTop();	//Code added this command so we could make the Javelin do an arc instead of a straight line
	
	/*-----------------------
	SEAKNIGHT TAKES OFF
	-------------------------*/	
	seaknight_monument_takeoff_01 = get_vehicle( "seaknight_monument_takeoff_01", "script_noteworthy" );
	heli_monument_path_01 = getstruct( "heli_monument_path_01", "targetname" );
	seaknight_monument_takeoff_01 thread vehicle_paths( heli_monument_path_01 );
	
	thread flag_set_delayed( "javelin_is_owning_fools", 1 );
	wait( 2.5 );
	thread gopath( m1a1_owned2 );
	m1a1_owned2 maps\_vehicle::godoff();
	
	/*-----------------------
	M1A1 #1 AND SEAKNIGHT OWNED BY JAV
	-------------------------*/	
	m1a1_owned setturrettargetent( javelin_source_org );
	m1a1_owned thread vehicle_tank_fire_turret( javelin_source_org );
	m1a1_owned thread m1a1_owned_think();
	
	while( true )
	{
		monument_heli_owned waittill( "damage", amount, attacker );
		if ( ( isdefined( attacker ) ) && ( !isplayer( attacker ) ) )
			break;
	}

	thread maps\dcburning_fx::monument_heli_destroyed( monument_heli_owned );
	
	/*-----------------------
	OTHER TARGETS GET HIT BY JAVELINS
	-------------------------*/	
	wait( 10 );
	m1a1_owned2 setturrettargetent( javelin_source_org );
	m1a1_owned2 thread vehicle_tank_fire_turret( javelin_source_org );
	m1a1_owned2 delaythread( 0,::vehicle_owned_by_javelin, javelin_source_org );
	
	wait( 8 );
	m1a1_trench delaythread( 0,::vehicle_owned_by_javelin, javelin_source_org  );

	flag_set( "second_abrams_killed" );
	wait( 8 );
	
	javelin_targets_trench = getstructarray( "javelin_targets_trench", "targetname" );
	javelin_vehicle_target_array = javelin_vehicle_targets;
	eTargetVehicle = undefined;
	eTargetTrenchOrg = undefined;
	toggle = 1;
	dummy = spawn( "script_origin", ( 0, 0, 0 ) );
	while ( !flag( "player_entering_top_elevator_area" ) )
	{
		wait( randomfloatrange( 5, 8 ) );
		//alternate javelin targets between vehicles and trenches
		
//		if( ( toggle == 1 ) && ( isdefined( javelin_vehicle_target_array ) ) && ( javelin_vehicle_target_array.size > 0 ) )
//		{
//			eTargetVehicle = getclosest( level.player.origin, javelin_vehicle_target_array );
//			javelin_vehicle_target_array = array_remove( javelin_vehicle_target_array, eTargetVehicle );
//			eTargetVehicle vehicle_owned_by_javelin( javelin_source_org );
//			toggle = 0;
//		}
//		else
//		{
			iRand = randomint( javelin_targets_trench.size );
			eTargetTrenchOrg = javelin_targets_trench[ iRand ];
			dummy.origin = eTargetTrenchOrg.origin;
			newMissile = MagicBullet( "javelin_dcburn", javelin_source_org.origin, dummy.origin );
			Playfx( getfx( "javelin_muzzle" ), javelin_source_org.origin );
			newMissile thread javelin_earthquake();	
			newMissile Missile_SetTargetEnt( dummy ); 
			newMissile Missile_SetFlightmodeTop();	
			toggle = 1;
//		}
		wait( randomfloatrange( 5, 10 ) );
		
	}
	
	dummy delete();


}

m1a1_owned_think()
{
	wait( 2 );
	eTarget = getent( "javelin_source_org", "targetname" );
	self setTurretTargetEnt( eTarget, ( 0, 0, -60 ) );
	self waittill_notify_or_timeout( "turret_rotate_stopped", 1.0 );
	self notify( "turret_fire" );
	
	flag_wait_either( "player_trench_capitol_failsafe", "blow_up_abrams" );
	self thread radius_damage_m1a1_owned();
	self delaythread( 0,::vehicle_owned_by_javelin, eTarget );
}

radius_damage_m1a1_owned()
{
	self waittill( "death" );
	if ( distance( self.origin, level.player.origin ) < 1024 )
	{
		level.player DoDamage( 50 / level.player.damageMultiplier, level.player.origin );
	}
}

apache_think()
{
//	self endon( "death" );
//	flag_wait( "apache_commerce" );
//	javelin_source_org = getent( "javelin_source_org", "targetname" );
//	attractor = Missile_CreateAttractorEnt( self, 100000, 100000 );
//	MagicBullet( "rpg", javelin_source_org.origin, self.origin );
//	while( isdefined( self ) )
//	{
//		self waittill( "damage", amount, attacker );
//		if ( !isdefined ( attacker ) )
//				continue;
//		if ( isplayer( attacker ) )
//			continue;
//		break;
//	}
//	self notify( "death" );
}

vehicle_tank_fire_turret( eTarget )
{
	self endon( "death" );
	tank_50cal = self.mgturret[ 0 ];	
	while ( isdefined( self ) )
	{
		tank_50cal settargetentity( eTarget );
		iBurstNumber = randomfloatrange( 1.5, 3 );
		tank_50cal startfiring();
		wait( iBurstNumber );
		tank_50cal stopfiring();
		wait( randomfloatrange( 3, 6 ) );
	}
}

vehicle_heli_fire_turret( eTarget )
{
	self endon( "death" );
	self notify( "stop_firing_turret" );
	self endon( "stop_firing_turret" );
	fireTime = .1;
	while ( isdefined( self ) )
	{
		burstsize = randomintrange( 10, 20 );
		if ( !self.firingMissiles )
		{
			for ( i = 0; i < burstsize; i++ )
			{
				self setturrettargetent( eTarget, randomvector( 50 ) + ( 0, 0, 32 ) );
				self fireweapon();
				wait fireTime;
			}
		}
		else
			wait( .5 );
			
		wait( randomfloatrange( 2, 3 ) );
	}
}

helis_monument()
{
	flag_wait( "player_leaving_bunker" );
	helis_monument = spawn_vehicles_from_targetname( "helisquad_monument" );
	//array_call( helis_monument,::Vehicle_TurnEngineOff );
	flag_wait( "player_approaching_monument" );
	array_call( helis_monument,::Vehicle_SetSpeed, 100 );
	array_thread( helis_monument,::gopath );
}

helis_monument_ground()
{
	flag_wait( "player_leaving_bunker" );
	helis_monument = spawn_vehicles_from_targetname( "helisquad_monument_ground" );
//	foreach( heli in helis_monument )
//	{
//		if ( ( isdefined( heli.script_noteworthy ) ) && ( heli.script_noteworthy == "seaknight_monument_takeoff_01" ) )
//			heli Vehicle_TurnEngineOff();
//	}
	array_thread( helis_monument, maps\_vehicle::godon );
}

helis_monument_cargo()
{
	flag_wait( "player_leaving_bunker" );
	helis_monument_cargo = spawn_vehicles_from_targetname( "helis_monument_cargo" );
	helis_monument_cargo_noliftoff = spawn_vehicles_from_targetname( "helis_monument_cargo_noliftoff" );
	//array_call( helis_monument_cargo_noliftoff,::Vehicle_TurnEngineOff );
	flag_wait( "player_approaching_monument" );
	array_thread( helis_monument_cargo,:: heli_cargo_liftoff_and_go );
	array_thread( helis_monument_cargo_noliftoff,::gopath );
}

capitol_trench()
{
	flag_wait_either( "player_trench_looking_capitol", "player_trench_capitol_failsafe" );
	jets = spawn_vehicles_from_targetname_and_drive( "jets_capitol_01" );
}

//commerce_lasers()
//{
//	laser_orgs = getentarray( "laser_orgs", "targetname" );
//	flag_wait( "javelin_is_owning_fools" );
//	aTargets = getentarray( "target_crowsnest", "targetname" );
//	array_thread( laser_orgs,::commerce_lasers_think, aTargets );
//}

//commerce_lasers_think( aTargets )
//{
//	while( !flag( "second_abrams_killed" ) )
//	{
//		iRand = randomint( aTargets.size );
//		wait( randomfloatrange( 1.2, 3.4 ) );
//	}
//}


humvee_commerce_left()
{
	flag_wait( "player_approaching_bunker_exit" );

	humvee_spotlight_left = spawn_vehicle_from_targetname( "humvee_spotlight_left" ); 

	/*-----------------------
	HUMVEE SPOTLIGHT SETUP
	-------------------------*/	
	humvee_spotlight_left humvee_spotlight_setup();

	flag_wait( "javelin_is_owning_fools" );
	
	aTargets = getentarray( "target_crowsnest", "targetname" );
	humvee_spotlight_left.turret settargetentity( aTargets[ randomint( aTargets.size )  ] );
	wait( 1.5 );
	playfxontag( getfx( "_attack_heli_spotlight" ), humvee_spotlight_left.turret, "tag_flash" );
	while( !flag( "second_abrams_killed" ) )
	{
		humvee_spotlight_left.turret settargetentity( aTargets[ randomint( aTargets.size )  ] );
		wait( randomfloatrange( 1.2, 3.4 ) );
	}
	target_for_humvee_left = getent( "target_for_humvee_left", "targetname" );
	humvee_spotlight_left.turret settargetentity( target_for_humvee_left );
	wait( .5 );
	humvee_spotlight_left.spotlight_org delete();
	humvee_spotlight_left.turret delete();
	
	flag_set( "humvee_commerce_left_done_with_spotlight" );
	humvee_spotlight_left thread gopath();
	humvee_spotlight_left waittill( "reached_end_node" );
	/*-----------------------
	CLEANUP
	-------------------------*/	
	humvee_spotlight_left vehicle_delete();
}


humvee_commerce()
{
	flag_wait( "player_approaching_bunker_exit" );
	humvee_spotlight = spawn_vehicle_from_targetname( "humvee_spotlight" ); 
	humvee_spotlight maps\_vehicle::godon();
	HummerTurret = humvee_spotlight.mgturret[ 0 ];
	
	/*-----------------------
	HUMVEE SPOTLIGHT SETUP
	-------------------------*/	
	humvee_spotlight humvee_spotlight_setup();

	flag_wait( "humvee_commerce_left_done_with_spotlight" );
	
	humvee_spotlight.turret thread humvee_spotlight_think( humvee_spotlight, HummerTurret );
	

	/*-----------------------
	HUMVEE SPOTLIGHT TARGETS RAPPELERS FOR A WHILE
	-------------------------*/
	flag_wait( "commerce_rappelers_rappeling" );
	
	
	if ( isdefined( level.commercerappelers ) )
	{
		while( level.commercerappelers.size > 0 )
		{
			wait( 0.05 );
			if ( flag( "commerce_rappelers_done" ) )
				break;
			iRand = randomint( level.commercerappelers.size );
			level.commercerappelers = remove_dead_from_array( level.commercerappelers );
			eTarget = level.commercerappelers[ iRand ];
			if ( isdefined( eTarget ) )
			{
				humvee_spotlight.eTarget = eTarget;
				wait( randomfloatrange( 2.2, 4.4 ) );
			}
		}	
	}

	
	/*-----------------------
	CLEANUP
	-------------------------*/	
	flag_wait( "player_entering_top_elevator_area" );

	
	/*-----------------------
	CLEANUP
	-------------------------*/	
	flag_wait( "player_in_crowsnest_room" );

	humvee_spotlight.spotlight_org delete();
	humvee_spotlight.turret delete();
	aRiders = humvee_spotlight.riders;
	array_thread( aRiders, ::AI_delete );
	humvee_spotlight vehicle_delete();
	flag_set( "humvee_spotlight_deleted" );

}

bradley_commerce()
{
	flag_wait( "player_approaching_bunker_exit" );
	level.bradley_commerce = spawn_vehicle_from_targetname( "bradley_commerce" );
	level.bradley_commerce maps\_vehicle::godon();
	flag_wait( "bradley_can_start_firing" );
	iFireTime = weaponfiretime( "bradley_turret" );
	aDefaultTargets = getentarray( "humvee_spotlight_targets", "targetname" );
	targetLoc = undefined;
	level.bradley_commerce.weaponrange = 6000;
	bradleyDefaultTargets = getentarray( "bradley_default_targets", "targetname" );
	level.bradley_commerce.fireAtDefaultTargets = true;
	level.bradley_commerce.firing = true;
	while( !flag( "player_entering_top_elevator_area" ) )
	{
		wait( 0.05 );
		/*-----------------------
		KILL ANY PREFERRED TARGETS
		-------------------------*/	
		if ( level.bradley_commerce.firing == false ) 
		{
			wait( 1 );
			continue;
		}
			
		if ( ( isdefined( level.bradleyPreferredTargets ) ) && ( level.bradleyPreferredTargets.size > 0 ) )
		{
			level.bradleyPreferredTargets = remove_dead_from_array( level.bradleyPreferredTargets );
			if ( level.bradleyPreferredTargets.size == 0 )
				continue;
			iRand = randomInt( level.bradleyPreferredTargets.size );
			eTarget = level.bradleyPreferredTargets[ iRand ];
			eTarget.health = 1;
		}
		else if ( level.bradley_commerce.fireAtDefaultTargets )
		{
			iRand = randomInt( bradleyDefaultTargets.size );
			eTarget = bradleyDefaultTargets[ iRand ];
		}
		/*-----------------------
		OTHERWISE JUST GET A TARGET
		-------------------------*/	
		else
			eTarget = level.bradley_commerce vehicle_get_target();
		if ( !isdefined( eTarget ) )
		{
			wait( randomfloatrange( 2, 4 ) );
			continue;
		}
		
		/*-----------------------
		SHOOT AT THE TARGET
		-------------------------*/	
		//targetLoc = eTarget gettagorigin( "tag_eye" );
		level.bradley_commerce setturrettargetent( eTarget );
		level.bradley_commerce waittill_notify_or_timeout( "turret_rotate_stopped", 1 );
		iBurstNumber = randomfloatrange( 2, 6 );
		i = 0;
		while ( i < iBurstNumber )
		{
			i++ ;
			iFireTime = weaponfiretime( "bradley_turret" );
			wait( iFireTime );
			level.bradley_commerce fireWeapon();
			earthquake( 0.25, .13, level.bradley_commerce.origin, 1024 );
		}
		wait( randomfloatrange( 1.5, 5 ) );
	}
	
	level.bradley_commerce vehicle_delete();
}

humvee_magically_kill_dude( eTarget )
{
	eTarget endon( "death" );
	if ( ( !isdefined( eTarget) ) || ( !isalive( eTarget ) ) )
		return;
	targetTagOrigin = eTarget gettagorigin( "tag_eye" );
	magicbullet( "m14_scoped", self.origin, targetTagOrigin );
	bullettracer( self.origin, targetTagOrigin, true );
	playfxontag( getfx( "headshot" ), eTarget, "tag_eye" );
}

vehicle_get_target()
{
	eTarget = undefined;
	switch( self.vehicletype )
	{
		case "zpu_antiair":
			eTarget = self.defaultTargets[ randomint( self.defaultTargets.size ) ];
			break;
		case "bradley":
													//  getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
			eTarget = maps\_helicopter_globals::getEnemyTarget( self.weaponrange, level.cosine[ "180" ], true, false, false, true );
			break;
		case "btr80":
												//  getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
			eTarget = maps\_helicopter_globals::getEnemyTarget( level.CannonRange, level.cosine[ "180" ], true, true, false, true );
			break;
	}
	if ( isdefined( eTarget ) )
		return eTarget;
}

commerce_rappelers()
{
	flag_wait( "player_commerce_trench_01" );
	if ( getdvarint( "r_dcburning_culldist" ) == 1 )
	{
		flag_set( "commerce_rappelers_inserting" );
		flag_set( "commerce_rappelers_rappeling" );
		flag_set( "commerce_rappelers_done" );
	}
	else
	{
		blackhawk_commerce_rappel = spawn_vehicle_from_targetname_and_drive( "blackhawk_commerce_rappel" );
		level.commercerappelers = blackhawk_commerce_rappel.riders; 
		array_thread( level.commercerappelers,::commerce_rappelers_think );
		flag_set( "commerce_rappelers_inserting" );
		
		flag_wait( "commerce_rappelers_rappeling" );
		wait( 6 );
		flag_set( "commerce_rappelers_done" );
	}
}

commerce_rappelers_think()
{
	self endon( "death" );
	self setthreatbiasgroup( "oblivious" );
	eAnimEnt = getent( self.target, "targetname" );
	sRappelAnim = eAnimEnt.animation;
	self.eExploder = undefined;
	if ( isdefined( eAnimEnt.target ) )
	{
		aExploderArray = getentarray( eAnimEnt.target, "targetname" );
		foreach ( exploderpiece in aExploderArray )
		{
			if ( isdefined( exploderpiece.script_exploder ) )
			{
				self.iExploderNum = exploderpiece.script_exploder;
				self.ExploderOrg = exploderpiece.origin;
				break;
			}
		}
	}
	self waittill( "jumpedout" );
	eAnimEnt anim_generic_first_frame( self, sRappelAnim );
	if ( !flag( "commerce_rappelers_rappeling" ) )
		flag_set( "commerce_rappelers_rappeling" );
	eAnimEnt anim_generic( self, sRappelAnim );
	self delete();
}

rappel_window_exploder( guy )
{
	assertex( isdefined( guy.iExploderNum ), "AI with export " + guy.export + " needs his target to target a window exploder" );
	fxOrg = guy.ExploderOrg;
	exploder( guy.iExploderNum );
	thread play_sound_in_space( "glass_break", fxOrg );
	playfx( getfx( "commerce_window_shatter" ), fxOrg );
}

humvee_spotlight_think( humvee, HummerTurret )
{
	//self ==> spotlight turret
	humvee endon( "death" );
	self endon( "death" );

	targets = getentarray( "humvee_spotlight_targets", "targetname" );
	self.defaultTarget = targets[0];
	self thread humvee_default_targets_think( targets, self );
	
	self settargetentity( targets[ 0 ] );
	
	wait( .5 );
	HummerTurret setmode( "manual" );
	HummerTurret StopFiring();
	HummerTurret SetTargetEntity( targets[ 0 ] );
	HummerTurret.dontshoot = true;
	
	if ( getdvarint( "sm_enable" ) )
	{
		playfxontag( getfx( "_attack_heli_spotlight" ), self, "tag_flash" );
	}
	
	self thread spotlight_preferred_targets();
	
	offset = ( 0, 0, 32 );
	while ( isdefined( self ) )
	{
		if ( isdefined( self.spotlightPreferredTarget ) )
		{
			self settargetentity( self.spotlightPreferredTarget, offset );
			if ( isdefined( HummerTurret ) )
				HummerTurret SetTargetEntity( self.spotlightPreferredTarget, offset );
		}
			
		else if ( isdefined( humvee.eTarget ) )
		{
			self settargetentity( humvee.eTarget, offset );
			if ( isdefined( HummerTurret ) )
				HummerTurret SetTargetEntity( humvee.eTarget, offset );
		}
		else
		{
			if ( isdefined( self.defaultTarget ) )
			{
				self settargetentity( self.defaultTarget );
				if ( isdefined( HummerTurret ) )
					HummerTurret SetTargetEntity( self.defaultTarget );
			}

		}
			
		wait( 0.05 );
	}
}

spotlight_preferred_targets()
{
	self endon( "death" );
	self.spotlightPreferredTarget = undefined;
	self thread find_player_attacker_for_spotlight( self );
	
	flag_wait_either( "player_touching_commerce_lobby_right", "player_touching_commerce_lobby_left" );
	/*-----------------------
	POINT SPOTLIGHT AT ENEMIES NEAR PLAYER, OR ONES DAMAGING PLAYER
	-------------------------*/	
	volume_commerce_lobby_lower = getent( "volume_commerce_lobby_lower", "targetname" );
	volume_commerce_lobby_upper = getent( "volume_commerce_lobby_upper", "targetname" );
	enemies1 = volume_commerce_lobby_lower get_ai_touching_volume( "axis" );
	enemies2 = volume_commerce_lobby_upper get_ai_touching_volume( "axis" );
	aAI = undefined;
	while ( ( isdefined( self ) ) && ( !flag( "player_entering_top_elevator_area" ) ) )
	{
		aAI = array_merge( enemies1, enemies2 );
		aAI = remove_dead_from_array( aAI );
		if ( ( isdefined( level.playerAttacker ) ) && ( is_in_array( aAI, level.playerAttacker ) ) )
			self.spotlightPreferredTarget = level.playerAttacker;
		else
		{
			if ( aAI.size > 0 )
				self.spotlightPreferredTarget = getClosest( level.player.origin, aAI );
		}
			
		if ( isdefined( self.spotlightPreferredTarget ) )
			wait( randomfloatrange( 3, 5 ) );
		else
			wait( .5 );
		enemies1 = volume_commerce_lobby_lower get_ai_touching_volume( "axis" );	//want to get these guys again in case more spawned in
	}
	
	/*-----------------------
	FIFTH FLOOR - POINT SPOTLIGHT AT ENEMY WINDOWS NEAREST PLAYER
	-------------------------*/	
	flag_wait( "player_entering_top_elevator_area" );
	humvee_spotlight_targets_upper = getentarray( "humvee_spotlight_targets_upper", "targetname" );
	aAI = undefined;
	
	while ( isdefined( self ) )
	{
		wait( randomfloatrange( 2, 4 ) );
//		aAI = getaiarray( "axis" );
//		if ( aAI.size == 0 )
//			continue;
//		guy = getClosest( level.player.origin, aAI );
//		self.spotlightPreferredTarget = getClosest( guy.origin, humvee_spotlight_targets_upper );
		self.spotlightPreferredTarget = humvee_spotlight_targets_upper[ randomint( humvee_spotlight_targets_upper.size ) ];
	}
	
	
	
}

find_player_attacker_for_spotlight( spotlight_turret )
{
	self endon( "death" );
	level.playerAttacker = undefined;
	while( isdefined( self ) )
	{
		level.player waittill( "damage", amount, attacker );
		if ( !isdefined ( attacker ) )
			continue;
		if ( ( isdefined ( attacker.team ) ) && ( attacker.team == "axis" ) )
		{
			level.playerAttacker = attacker;
			self waittill_death_or_timeout( 4 );
			if ( level.playerAttacker == self )
				level.playerAttacker = undefined;
		}
			
	}
}

humvee_default_targets_think( targets, turret )
{
	self endon( "death" );
	while ( isdefined( turret ) )
	{
		foreach( target in targets )
		{
			turret.defaultTarget = target;
			wait( randomfloatrange( 3, 6 ) );
		}
	}
	
	//cleanup
	foreach( target in targets )
		target delete();
}

humvee_convoy()
{
	flag_wait( "player_approaching_bunker_exit" );
	humvee_convoy_00 = getentarray( "humvee_convoy_00", "targetname" );
	
	if ( getdvarint( "r_dcburning_culldist" ) == 1 )
	{
		//make vehicle convoy a bit thinner on minspec
		thread drone_vehicle_flood_start( humvee_convoy_00, "humvee_convoy_00", 7, 10, true );
	}
	else
	{
		thread drone_vehicle_flood_start( humvee_convoy_00, "humvee_convoy_00", 3.1, 4.8, true );
	}
	
	flag_wait( "player_at_top_of_pavlovs_ramp" );

	drone_vehicle_flood_stop( "humvee_convoy_00" );
}


/****************************************************************************
    COMMERCE BUILDING - ELEVATOR_BOTTOM
****************************************************************************/ 
AA_elevator_bottom_init()
{
	thread atrium_guys();
	thread dialogue_elevator_bottom_to_top();
	thread samsite_flyby();
	thread AAA_sequence_elevator_bottom_to_top();
	flag_wait( "player_entering_top_elevator_area" );
	thread AA_elevator_top_init();
}



samsite_flyby()
{
	level endon( "player_entering_top_elevator_area" );
	flag_wait( "player_near_samsite" );
	spawn_vehicles_from_targetname_and_drive( "jets_samsite" );
}

AAA_sequence_elevator_bottom_to_top()
{
	flag_wait_either( "player_touching_commerce_lobby_right", "player_touching_commerce_lobby_left" );
	
	thread AI_squad_fixed_node_interior();
	
	aFodder_friendlies = [];
	aSpawners = undefined;
	if( flag( "player_touching_commerce_lobby_left" ) )
	{
		aSpawners = getentarray( "friendlies_commerce_lobby_left", "targetname" );
	}
		
	else
	{
		aSpawners = getentarray( "friendlies_commerce_lobby_right", "targetname" );
	}
	
	foreach( spawner in aSpawners )
	{
		guy = spawner spawn_ai( true );
		if ( isdefined( guy ) )
		{
			aFodder_friendlies = array_add( aFodder_friendlies, guy );
		}
	}
	array_thread( aFodder_friendlies, ::AI_fixednode_off );
	array_thread( aFodder_friendlies, ::try_to_magic_bullet_shield );
	foreach( guy in aFodder_friendlies )
	{
		if( !isdefined( guy ) )
			continue;
		guy.attackeraccuracy = 0;
		//guy.useChokePoints = true;
	}
	
	thread elevator_start();
	
	flag_wait( "player_approaching_bottom_elevators" );
	thread autosave_by_name( "bottom_elevators" );
	array_thread( aFodder_friendlies, ::stop_magic_bullet_shield );
	foreach( guy in aFodder_friendlies )
	{
		if( !isdefined( guy ) )
			continue;
		guy.attackeraccuracy = .1;
	}
	array_thread( aFodder_friendlies, ::AI_redshirt_think );

	/*-----------------------
	PLAYER ENTERING COURTYARD
	-------------------------*/	
	flag_wait( "player_entering_courtyard" );
	
	
	if ( getdvarint( "r_dcburning_culldist" ) == 1 )
	{
		setculldist( 0 );
	}
	
	/*-----------------------
	TRY TO THIN OUT LOBBY ENEMIES
	-------------------------*/	
	thread AI_cleanup_volume( "volume_commerce_lobby_upper", "axis" );
	thread AI_cleanup_volume( "volume_commerce_lobby_lower", "axis" );


	/*-----------------------
	ALL ATRIUM ENEMIES GO INTO AMBUSH MODE
	-------------------------*/	
	flag_wait( "player_headed_to_atrium_side_hall" );
	aAI = getaiarray( "axis" );
	array_thread( aAI,::AI_ambush_behavior );
	
	/*-----------------------
	PLAYER ENTERING COURTYARD SIDE HALL
	-------------------------*/	
	flag_wait( "player_entering_commerce_side_hall" );
	
	flag_set( "stop_elevator_doors" );
	
	wait( 8 );
	thread waittill_targetname_volume_dead_then_set_flag( "volume_courtyard_windows", "courtyard_has_been_cleared");
	
	
	
	flag_wait( "player_heading_up_to_mezzanine" );

	/*-----------------------
	PAVLOV STREET DRONES
	-------------------------*/	
	//pavlov_ai = [];
	//drone_warriors_pavlov = getentarray( "drone_warriors_pavlov", "targetname" );
	//friendlies_pavlov_street = getentarray( "friendlies_pavlov_street", "targetname" );
	//hostiles_pavlov_street = getentarray( "hostiles_pavlov_street", "targetname" );
	//spawners = array_merge( friendlies_pavlov_street, drone_warriors_pavlov );
	//spawners = array_merge( spawners, hostiles_pavlov_street );
	//foreach( spawner in spawners )
	//{
	//	pavlov_ai[ pavlov_ai.size ] = spawner spawn_ai( true );
	//}
	
	//drone_flood_pavlov = getentarray( "drone_flood_pavlov", "targetname" );
	//thread drone_flood_start( drone_flood_pavlov, "drone_flood_pavlov" );
	
	/*-----------------------
	MEZZANINE
	-------------------------*/	
	flag_wait( "player_entering_mezzanine_top" );
	thread waittill_targetname_volume_dead_then_set_flag( "volume_commerce_lobby_upper", "mezzanine_top_has_been_cleared" );
	spawn_vehicles_from_targetname_and_drive( "jets_mezz_01" );
	
	flag_wait( "player_approaching_pavlov_hole" );
	delaythread( 0, ::spawn_vehicles_from_targetname_and_drive, "helis_mezzanine" );

	
	/*-----------------------
	HEADED TO FOURTH FLOOR
	-------------------------*/	
	flag_wait( "player_at_bottom_of_pavlovs_ramp" );
	thread AI_cleanup( "axis" );

	/*-----------------------
	SPAWN SAM SITE HOSTILES AND FRIENDLY FODDER
	-------------------------*/	
	thread samsite_enemy_chatter();
	
	battlechatter_off( "allies" );
	commerce_allied_fodder_4 = array_spawn( getentarray( "commerce_allied_fodder_4", "targetname" ), true );
	hostiles_commerce_samsite = array_spawn( getentarray( "hostiles_commerce_samsite", "targetname" ), true );
	samsite = samsite_setup( "samsite_commerce_01", "player_at_top_of_pavlovs_ramp", "commerce_samsite_revealed" );
	commerce_samsite_nodes = getnodearray( "commerce_samsite_nodes", "targetname" );
	eNode = getclosest( samsite.operator.origin, commerce_samsite_nodes );
	commerce_samsite_nodes = array_remove( commerce_samsite_nodes, eNode );
	samsite.operator thread samsite_ai_think( eNode );
	samsite.puller thread samsite_ai_think( commerce_samsite_nodes[ 0 ] );
	samsite.turret thread samsite_turret_think();
	samsite thread samsite_c4_think();
	/*-----------------------
	SAM SITE HOSTILES ALERTED!
	-------------------------*/	
	flag_wait_any( "player_entering_fourth_floor", "player_shot_at_samsite_guys", "player_gawking_at_fourth_floor_guys" );
	flag_set( "player_shot_at_samsite_guys" );
	battlechatter_on( "allies" );
	
	if( !flag( "player_entering_fourth_floor" ) )
	{
		thread dummy_trigger( "dummy_colornodes_pavlov_end" );	//make friendlies move up
		activate_trigger( "spawner_hostiles_commerce_floor4", "targetname", level.player );	 //spawn enemies across balcony, etc
	}
	
	array_thread( commerce_allied_fodder_4,::AI_delete );
	
	wait( 4 );
	thread waittill_targetname_volume_dead_then_set_flag( "volume_commerce_fourth_floor", "floor_four_has_been_cleared" );
	flag_wait_either( "floor_four_has_been_cleared", "player_headed_to_fifth_floor" );

	/*-----------------------
	HEADED TO FIFTH FLOOR
	-------------------------*/	
	flag_wait( "player_headed_to_fifth_floor" );
	battlechatter_off( "allies" );
	
	//array_thread( pavlov_ai,::AI_delete );
	
	thread AI_cleanup_non_squad( "all" );
}

samsite_c4_think()
{
	//self ==> the samsite struct
	c4_locations = getstructarray( "c4_slamraam", "script_noteworthy" );
	foreach( c4_location in c4_locations )
	{
																//c4_location( tag, origin_offset, angles_offset, org )
		level.c4_models[ level.c4_models.size ] = self.base maps\_c4::c4_location( undefined, undefined, undefined, c4_location.origin );
	}
	
	self.base waittill( "c4_detonation" );
	self.base notify( "death" );
	flag_set( "slamraam_c4_detonated" );
	
	self.base setmodel( "vehicle_slamraam_destroyed" );
	//playfx( getfx( "vehicle_explosion_slamraam" ), self.base.origin );
	playfx( getfx( "large_vehicle_explosion" ), self.base.origin );
	thread play_sound_in_space( "exp_slamraam_destroyed", self.base.origin );
	self.turret delete();
	radiusDamage( self.base.origin + ( 0, 0, 96 ), 180, 1000, 50 );
	fx = spawnFx( getFx( "thin_black_smoke_L" ), self.base.origin );
	triggerFx( fx );
	earthquake( 0.6, 1.2, self.base.origin, 1600 );
	if ( distance( self.base.origin, level.player.origin ) < 2048 )
		level.player PlayRumbleOnEntity( "damage_heavy" );
	flag_wait( "player_entering_top_elevator_area" );
	fx delete();
}

atrium_guys()
{
	flag_wait( "player_approaching_bottom_elevators" );
	spawners = getentarray( "atrium_guys", "targetname" );
	atrium_guys = [];
	guy = undefined;
	puller = undefined;
	foreach ( spawner in spawners )
	{
		guy = spawner dronespawn();
		guy setcontents( 0 );
		guy.noragdoll = true;
		guy.nocorpsedelete = true;
		guy.ignoreme = true;
		guy.reference = spawner;
		guy.dontDoNotetracks = true;	//allows using of ai _anim functons without getting errors
		guy.script_looping = 0;		//will force drone to scip default idle behavior
		guy gun_remove();
		guy.deathanim = level.scr_anim[ "generic" ][ spawner.animation + "_death" ];
		assert( isdefined( guy.deathanim ) );		
		atrium_guys[ atrium_guys.size ] = guy;
		guy.puller = false;
		if ( spawner.animation == "airport_civ_dying_groupB_pull" )
			puller = guy;
		guy.animation = spawner.animation;
		guy.reference anim_generic_first_frame( guy, guy.animation );
	}
	
	flag_wait( "player_entering_courtyard" );
	
	atrium_guys[ 0 ].reference thread anim_generic( atrium_guys[ 0 ], atrium_guys[ 0 ].animation );
	atrium_guys[ 1 ].reference thread anim_generic( atrium_guys[ 1 ], atrium_guys[ 1 ].animation );
	wait( 0.05 );
	
	atrium_guys[ 0 ] setAnimTime( level.scr_anim[ "generic" ][ atrium_guys[ 0 ].animation ], .5 );
	atrium_guys[ 1 ] setAnimTime( level.scr_anim[ "generic" ][ atrium_guys[ 1 ].animation ], .5 );
	
	array_thread( atrium_guys,::atrium_guys_end_of_anim );
	
	flag_wait_either( "atrium_guys_at_end_of_anim", "player_entering_courtyard2" );
	
	atrium_bullet = getent( "atrium_bullet", "targetname" );
	headOrigin = puller gettagorigin( "tag_eye" );
	vec = vectornormalize( headOrigin - atrium_bullet.origin );
	thread play_sound_in_space( "weap_deserteagle_fire_npc", atrium_bullet.origin );
	PlayFX( getfx( "headshot" ), headOrigin, vec );
	magicbullet( "m14_scoped", atrium_bullet.origin, headOrigin );
	bullettracer( atrium_bullet.origin, headOrigin, true );
	foreach( guy in atrium_guys )
	{
		guy kill();
	}
	atrium_drag_blocker = getent( "atrium_drag_blocker", "targetname" );
	atrium_drag_blocker hide_entity();
}


atrium_guys_end_of_anim()
{
	level endon( "player_entering_courtyard2" );
	level endon( "atrium_guys_at_end_of_anim" );
	self waittillmatch( "single anim", "end" );
	flag_set( "atrium_guys_at_end_of_anim" );
	
}

samsite_enemy_chatter()
{
	samsite_chater_org = getent( "samsite_chater_org", "targetname" );
	origin = samsite_chater_org.origin;
	sFlagToKillDialogue = "player_shot_at_samsite_guys";
	level endon( sFlagToKillDialogue );
	
	while( !flag( sFlagToKillDialogue ) )
	{
		//	Russian Airborne 1	Lieutenant Gureyvich, we have acquired two enemy aircrafts approaching, airspeed 500 knots, altitude 320 metres!	
		play_sound_then_kill_on_flag( "dcburn_ra1_acquiredtwo", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 2	Good! Lock on and engage the targets!	
		play_sound_then_kill_on_flag( "dcburn_ra2_lockon", origin, sFlagToKillDialogue );
		
		wait( 1 );
		//	Russian Airborne 3	Missile locked on and ready to fire!	
		play_sound_then_kill_on_flag( "dcburn_ra3_missilelocked", origin, sFlagToKillDialogue );
		
		wait( .5 );
		//	Russian Airborne 1	Two more southbound aircrafts, airspeed 620 knots, altitude 400 metres!	
		play_sound_then_kill_on_flag( "dcburn_ra1_2moresouthbound", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 2	Fire missile!	
		play_sound_then_kill_on_flag( "dcburn_ra2_firemissile", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 3	Yes sir! Firing missile!	
		play_sound_then_kill_on_flag( "dcburn_ra3_firingmissile", origin, sFlagToKillDialogue );
		
		wait( 1.5 );
		//	Russian Airborne 1	2 targets, moving north, 500 meters!	
		play_sound_then_kill_on_flag( "dcburn_ra1_movingnorth", origin, sFlagToKillDialogue );
		
		wait( 1 );
		//	Russian Airborne 2	Left, 10 degrees!	
		play_sound_then_kill_on_flag( "dcburn_ra2_10degrees", origin, sFlagToKillDialogue );
	}
}

samsite_ai_think( eNode )
{
	self endon( "death" );
	self.ignorerandombulletdamage = true;
	self thread AI_hostiles_commerce_samsite_think();

	self waittill_either( "damage", "alerted" );

		
//		if ( !isdefined( attacker ) )
//			continue;
//		if ( isPlayer( attacker ) )
//		{
//			self thread stop_magic_bullet_shield();
//			self.allowdeath = true;
//			self stopanimscripted();
//			self notify( "alerted" );
//			self.ignoreme = false;
//			if ( isdefined( type ) )
//			{
//				if ( ( type == "MOD_PROJECTILE" ) || ( type == "MOD_PROJECTILE_SPLASH" ) || ( type == "MOD_GRENADE_SPLASH" ) || ( type == "MOD_GRENADE" ) )
//					self kill();
//			}
//			break;
//		}

	self anim_stopanimscripted();
	self.ignorerandombulletdamage = false;
	self.ignoreme = false;
	self.ignoreme = false;
	self notify( "alerted" );
	self setgoalnode( eNode );
	
}

samsite_turret_think()
{
	self endon( "death" );
	flag_wait( "commerce_samsite_revealed" );
	time = 4.5;
	self rotateto( self.angles + ( 0, -50 , 0 ), time, 2, 2 );
	wait( time / 2 );
	
	targetOrg = getent( "slamraam_missile_target", "targetname" );
	while( !flag( "player_approaching_fourth_floor_sam" ) )
	{
		self detach( "projectile_slamraam_missile", self.missileTags[ 0 ] );
		earthquake( .3, .5, self.origin, 1600 );
		magicBullet( "slamraam_missile_dcburning", self gettagorigin( self.missileTags[ 0 ] ), targetOrg.origin );
		self.missileTags = array_remove( self.missileTags, self.missileTags[ 0 ] );
		if ( self.missileTags.size < 1 )
			break;
		wait( randomfloatrange( .3, 2 ) );
	}
}

samsite_setup( targetname, sFlagToStart, sFlagToSetWhenDone )
{
	/*-----------------------
	SETUP SAMSITE AI AND RETURN TO CALLER
	-------------------------*/	
	aSamsiteComponents = getentarray( targetname, "targetname" );
	eSamsiteBase = undefined;
	eSamsiteTarp = undefined;
	eSamsiteTurret = undefined;
	aSpawners = [];
	foreach( thing in aSamsiteComponents )
	{
		if( isspawner( thing ) )
		{
			aSpawners[ aSpawners.size ] = thing;
			continue;
		}
		if ( thing.code_classname == "script_model" )
		{
			switch ( thing.model )
			{
				case "slamraam_tarp":
					eSamsiteTarp = thing;
					break;
				case "vehicle_slamraam_launcher_no_spike":
					eSamsiteTurret = thing;
					break;
				case "vehicle_slamraam_base":
					eSamsiteBase = thing;
					break;
			}
		}
	}

	aAI_samsite = array_spawn( aSpawners, true );
	foreach( guy in aAI_samsite )
	{
		//guy.allowdeath = false;
		guy.ignoreme = true;
		guy.ignoreall = true;
		//guy thread magic_bullet_shield();
	}
	
	assertex( aAI_samsite.size == 2, "Need exactly 2 AI for the sam site" );
	assert( isdefined( eSamsiteTarp ) );
	assert( isdefined( eSamsiteTurret ) );
	assert( isdefined( eSamsiteBase ) );
	
	eSamsiteTarp.animname = "tarp";
	eSamsiteTarp assign_animtree();
	aAI_samsite[ 0 ].animname = "operator";
	aAI_samsite[ 1 ].animname = "puller";
	aSamSiteActors = aAI_samsite;
	aSamSiteActors = array_add( aSamSiteActors, eSamsiteTarp ) ;
	
	eSamsiteTurret.missileTags = [];
	eSamsiteTurret.missileTags[ 0 ] = "tag_missle1";
	eSamsiteTurret.missileTags[ 1 ] = "tag_missle2";
	eSamsiteTurret.missileTags[ 2 ] = "tag_missle3";
	eSamsiteTurret.missileTags[ 3 ] = "tag_missle4";
	eSamsiteTurret.missileTags[ 4 ] = "tag_missle5";
	eSamsiteTurret.missileTags[ 5 ] = "tag_missle6";
	eSamsiteTurret.missileTags[ 6 ] = "tag_missle7";
	eSamsiteTurret.missileTags[ 7 ] = "tag_missle8";
	
	foreach( tag in eSamsiteTurret.missileTags )
	{
		eSamsiteTurret Attach( "projectile_slamraam_missile", tag, true );
	}

	samsite = spawnstruct();
	samsite.operator = aAI_samsite[ 0 ];
	samsite.puller = aAI_samsite[ 1 ];
	samsite.turret = eSamsiteTurret;
	samsite.base = eSamsiteBase;
	
	/*-----------------------
	MAKE SAMSITE GO ONCE FLAG SET
	-------------------------*/	
	eSamsiteBase thread samsite_tarp_think( aSamSiteActors, sFlagToStart, sFlagToSetWhenDone );
	
	/*-----------------------
	RETURN SAMSITE AI TO CALLER
	-------------------------*/	
	return samsite;
}

samsite_tarp_think( aSamSiteActors, sFlagToStart, sFlagToSetWhenDone )
{
	//self ==> the samsite base
	self anim_first_frame( aSamSiteActors, "pulldown" );
	flag_wait( sFlagToStart );
	self anim_single( aSamSiteActors, "pulldown" );
	flag_set( sFlagToSetWhenDone );
}

AI_hostiles_commerce_samsite_think()
{
	self endon( "death" );
	self.ignoreme = true;
	self.ignoreall = true;
	self.old_goalradius = self.goalradius;
	self.goalradius = 16;
	self thread AI_sneak_monitor( "player_shot_at_samsite_guys" );
	self thread AI_samsite_player_too_close();
	
	self waittill( "alerted" );
	
	self.goalradius = self.old_goalradius;
	self.combatMode = "ambush";
	self.ignoreall = false;
	self.ignoreme = false;
}

AI_samsite_player_too_close()
{
	self endon( "death" );
	self endon( "alerted" );
	flag_wait_any( "player_entering_fourth_floor", "player_shot_at_samsite_guys", "player_gawking_at_fourth_floor_guys" );
	flag_set( "player_shot_at_samsite_guys" );
	self thread AI_become_alerted();
}

elevator_dude_think( spawner )
{
	sLoop = "dcburning_elevator_corpse_idle_A";
	sNudge = "dcburning_elevator_corpse_bump_A";
	self.allowdeath = false;
	self.dontDoNotetracks = true;	//allows using of ai _anim functons without getting errors
	self.script_looping = 0;	
	self gun_remove();
	self setcontents( 0 );
	self.ignoreme = true;
	self setlookattext( "", &"" );
	reference = spawner;
	iAnimSwitched = 0;
	elevator_clip = getent( "elevator_clip", "targetname" );
	elevator_clip.origin = elevator_clip.origin + ( 0, 0, 32 );
	self stopanimscripted();
	while( !flag( "stop_elevator_doors" ) )
	{
		reference thread anim_generic_loop( self, sLoop, "stop_idle" );
		self waittill( "doors_closing" );
		reference notify( "stop_idle" );
		if ( ( flag( "player_looking_at_elevator" ) ) && ( isdefined( iAnimSwitched ) ) )
		{
			iAnimSwitched = undefined;
			reference anim_generic( self, "dcburning_elevator_corpse_trans_A_2_B" );
			
			sLoop = "dcburning_elevator_corpse_idle_B";
			sNudge = "dcburning_elevator_corpse_bump_B";
		}
		reference anim_generic( self, sNudge );
	}
	self delete();
}

elevator_start()
{
	spawner = getent( "elevator_dude", "targetname" );
	elevator_dude = spawner dronespawn();
	elevator_dude thread elevator_dude_think( spawner );
	elevator_door_left = getent( "elevator_door_left", "targetname" );
	elevator_door_right = getent( "elevator_door_right", "targetname" );
	elevator_door_left.startPos = elevator_door_left.origin;
	elevator_door_right.startPos = elevator_door_right.origin;
	
	movedistLeft = 28;
	movedistRight = -28;
	movetime = 2;
	
	musak_org = getent( "musak_org", "targetname" );
	musak_org playloopsound( "elev_musak_loop" );
	
	while( !flag( "stop_elevator_doors" ) )
	{
		thread play_sound_in_space( "elev_bell_ding", elevator_door_left.origin );
		thread play_sound_in_space( "elev_door_close", elevator_door_left.origin );
		elevator_door_left movey( movedistLeft, movetime, movetime / 2 );
		elevator_door_right movey( movedistRight, movetime, movetime / 2 );
		
		wait( movetime - .25 );
		elevator_dude notify( "doors_closing" );
		wait( .25 );
		
		thread play_sound_in_space( "elev_door_open", elevator_door_left.origin );
		elevator_door_left moveto( elevator_door_left.startPos, movetime, movetime / 2, movetime / 2 );
		elevator_door_right moveto( elevator_door_right.startPos, movetime, movetime / 2, movetime / 2 );
		
		wait( movetime );
		
		wait( 1.25 );
	}
	musak_org stoploopsound();
	musak_org delete();
}

dialogue_elevator_bottom_to_top()
{
	flag_wait( "player_approaching_bottom_elevators" );
	
	//Sgt. Macey	Overlord, this is Hunter Two-One, be advised, we're inside and proceeding to the upper floors.	
	radio_dialogue( "dcburn_mcy_upperfloors" );
	
	//Overlord HQ Radio Voice	Roger, Overlord copies all.	
	radio_dialogue("dcburn_hqr_copiesall");
	
	/*-----------------------
	HEADED TO COURTYARD
	-------------------------*/	
	flag_wait_either( "courtyard_has_been_cleared", "player_heading_up_to_mezzanine" );
	
	if ( flag( "courtyard_has_been_cleared" ) )
	{
		//****Sgt. Macey: Hostiles suppressed in Section Two-Echo.   
		radio_dialogue( "dcburn_mcy_alldeadcourtyard" );
		
		//Overlord HQ Radio Voice: Solid copy, Two-One.	
		radio_dialogue( "dcburn_hqr_solidcopy" );
		
	}
	
	thread autosave_by_name( "courtyard_has_been_cleared" );
	
	/*-----------------------
	UP TO MEZZANINE
	-------------------------*/	
	flag_wait( "player_heading_up_to_mezzanine" );
	//***Sgt. Macey: Overlord this is Hunter Two-One. Proceeding to the mezzanine. Tell the LAV from RCT One to hold their fire, over.
	radio_dialogue( "dcburn_mcy_tomezzanine" );
	
	//****Overlord HQ Radio Voice: Copy that, Two One, good hunting.
	radio_dialogue( "dcburn_hqr_goodhunt" );
	flag_set( "ask_bradley_to_stop_firing" );
	
	flag_wait( "player_entering_mezzanine_top" );
	
	flag_wait_either( "mezzanine_top_has_been_cleared", "player_at_bottom_of_pavlovs_ramp" );
	if ( flag( "mezzanine_top_has_been_cleared" ) )
	{
		//****Sgt. Macey: Hostiles suppressed in Section Two-Echo.   
		radio_dialogue( "dcburn_mcy_alldeadmezzanine" );
		
		//Overlord HQ Radio Voice: Roger that, Two-One.	
		radio_dialogue( "dcburn_hqr_rogerthat" );
		
	}
	flavorbursts_off( "allies" );
	
	//Ranger 1	This is Delta Four-One at the Lincoln Memorial!!! We are taking heavy fire, request arty and airstrike on our position!!! Send whatever you got! Broken arrow broken arrow!!!	
	level.player thread play_sound_on_entity( "dcburn_ar1_lincolnmemorial" );
	
	flavorbursts_on( "allies" );

	flag_wait( "player_at_bottom_of_pavlovs_ramp" );


	
	
//	if ( player_has_motiontracker() )
//	{
//		if ( !motiontracker_enabled() )
//		{
//			//Sgt. Macey	15	3	Let's get the drop on them...Ramirez, activate your heartbeat sensor.
//			radio_dialogue( "dcburn_mcy_droponthem" );
//			level.heartbeat_timeout = gettime() + 15000;
//			level.player thread display_hint( "hint_heartbeat_sensor" );//it will endon this thread if not threaded
//		}
//		else
//		{
//			//Sgt. Macey	15	4	Keep an eye on your heartbeat sensor Ramirez. I wanna hit 'em fast and hard.
//			radio_dialogue( "dcburn_mcy_hitemfast" );
//		}
//	}

	//That's the frickin' Capitol Building!	
	level.friendly02 dialogue_execute( "dcburn_cpd_capitolbuild" );
	
	//****Overlord HQ Radio Voice: Hunter Two-One be advised, hostiles on the southwest corner of the fifth floor are hammering the evac site, over.
	radio_dialogue( "dcburn_hqr_crownag" );
	
	//****Sgt. Macey: Solid copy Overlord. We are Oscar Mike to the fifth floor. Out.
	radio_dialogue( "dcburn_mcy_omwtofifth" );

	
	//Sgt. Macey	Outlaw Two-Three this is Two-One-Actual. Interrogative - what are you seeing from your position over?	
	//radio_dialogue( "dcburn_mcy_whatseeing_r" );
	
	//Marine 5	The LZ is still receiving heavy fire from the target building, break - I see RPG teams on the upper floors, and medium caliber fire coming from the southwest corner over.	
	//radio_dialogue("dcburn_gm5_lzheavyfire");
	
	//Sgt. Macey	Solid copy, Two-One out.	
	//radio_dialogue("dcburn_mcy_solidcopy_r");

	flag_wait( "player_at_top_of_pavlovs_ramp" );

	if ( !flag( "player_shot_at_samsite_guys" ) )
	{
		thread autosave_by_name( "crow_sneak" );
		//Sgt. Macey: Standby to engage.
		radio_dialogue("dcburn_mcy_sby2engage");
	}
	
	flag_wait_either( "floor_four_has_been_cleared", "player_headed_to_fifth_floor" );
	if ( flag( "floor_four_has_been_cleared" ) )
	{
		//****Sgt. Macey: Enemy fire team eliminated in Section Four-Charlie.
		radio_dialogue( "dcburn_mcy_alldeadfourth" );
		
		//Overlord HQ Radio Voice	Copy that, Two-One.	
		radio_dialogue( "dcburn_hqr_copythat" );
		
	}
	
	flavorbursts_off( "allies" );

	//Ranger 2	Gator Two-Six, Gator Two-Five, be advised, we are pulling out of D.C.!! BCT Four has taken 90 percent losses! Our position is untenable, we are out of here! I repeat, we are getting the f*** outta dodge!	
	level.player play_sound_on_entity( "dcburn_ar2_pullingout" );
	
	//Ranger 3	All Goliath victors, pull back from the MSR!! Delta Four-One is calling in a Broken Arrow!!! Pull back from the MSR now!!! We are leaving!!!	
	level.player play_sound_on_entity( "dcburn_ar3_pullback" );
	
	flavorbursts_on( "allies" );
	

	
	
}

/****************************************************************************
    GLOBAL
****************************************************************************/ 
AA_global()
{
	thread commerce_top_drone_flood();
}

commerce_top_drone_flood()
{
	/*-----------------------
	DRONES FLOOD TOWARDS COMMERCE FROM THE SOUTH
	-------------------------*/

	flag_wait( "obj_commerce_defend_snipe_complete" );
	/*-----------------------
	BTR80s AND DRONES FLOOD TOWARDS COMMERCE FROM THE SOUTH
	-------------------------*/	
	//hostiles_drones_comm_south = getentarray( "hostiles_drones_comm_south", "targetname" );
	//thread drone_flood_start( hostiles_drones_comm_south, "hostiles_drones_comm_south" );
	
	bmp_flood_south = getentarray( "bmp_flood_south", "targetname" );
	thread crows_nest_bmp_flood( bmp_flood_south );
	
	flag_wait( "obj_commerce_defend_javelin_complete" );
	//thread drone_flood_stop( "hostiles_drones_comm_south" );
}

crows_nest_bmp_flood( aSpawners )
{
	level endon( "obj_commerce_defend_javelin_complete" );
	while( true )
	{
		foreach( spawner in aSpawners )
		{
			thread crows_nest_bmp_flood_think( spawner );
			
		}
		wait( randomfloatrange( 40, 41 ) );
	}
}

crows_nest_bmp_flood_think( spawner )
{
	if( !flag( "obj_commerce_defend_javelin_complete" ) )
		return;
	level endon( "obj_commerce_defend_javelin_complete" );
	wait( randomfloatrange( 40, 41 ) );
	bmp = spawner spawn_vehicle_and_gopath();
	target_set( bmp, ( 0, 0, 0 ) );
	target_setJavelinOnly( bmp, true );
	Target_SetAttackMode( bmp, "top" );
	bmp thread obj_commerce_defend_javelin_enemies_think();
	bmp endon( "death" );
	
	//if reaches end node, kill it, but don't let it cound as an obj
	
	bmp waittill( "reached_end_node" );
	bmp notify( "deleted_through_script" );
	bmp delete();
}

/****************************************************************************
    COMMERCE BUILDING - ELEVATOR_TOP
****************************************************************************/ 
AA_elevator_top_init()
{
	thread music_to_crowsnest();
	thread dialogue_to_crowsnest();
	thread AAA_sequence_elevator_top_2_crowsnest();
	flag_wait( "player_approaching_crowsnest" );
	thread AA_crows_nest_snipe_init();
}

music_to_crowsnest()
{
	flag_wait( "start_music_to_crowsnest" );
	thread music_loop( "dcburning_evilcrowsnest_approach", 198 );
}

AAA_sequence_elevator_top_2_crowsnest()
{
	
	flag_wait( "player_at_commerce_crows_floor" );
	triggersEnable( "colornodes_commerce_to_crowsnest", "script_noteworthy", true );
	
	flag_wait( "player_entering_top_elevator_area" );
	thread autosave_by_name( "elevator_top" );
	thread AI_cleanup_non_squad( "all" );
	if( isdefined( level.helis_ambient_trenches ) )
		array_thread( level.helis_ambient_trenches,::vehicle_delete );
	if( isdefined( level.vehicles_commerce_ambient ) )
		array_thread( level.vehicles_commerce_ambient,::vehicle_delete );
		
	/*-----------------------
	SETUP
	-------------------------*/	
	volume_commerce_sector_2 = getent( "volume_commerce_sector_2", "targetname" );
	volume_commerce_sector_3 = getent( "volume_commerce_sector_3", "targetname" );
	flare_dynamic_01 = getent( "flare_dynamic_01", "targetname" );
	dynamicLight = getent( flare_dynamic_01.target, "targetname" );
	dynamicLight setLightIntensity( 0 );
	/*-----------------------
	ENEMY FLARE MOMENT
	-------------------------*/
	flag_wait_either( "player_approaching_flare_moment", "player_looking_at_flare_moment" );
	//thread AI_drone_cleanup( "all", 1024, true );
	flare_dynamic_01 thread flare_burst_on_and_flicker( 4, 4, 10 );
	commerce_flare_guys = array_spawn( getentarray( "commerce_flare_guys", "targetname" ), true );
	
	/*-----------------------
	ENEMY FIRE TEAMS FIGHTING OTHER ALLIES
	-------------------------*/	
	//Done through spawn triggers now

	flag_wait( "player_approaching_crowsnest" );

	thread crows_nest_enemy_chatter();
	helis_ambient_crowsnest = spawn_vehicles_from_targetname_and_drive( "helis_ambient_crowsnest" );
	helis_crows_snipe = spawn_vehicles_from_targetname_and_drive( "helis_crows_snipe" );
	array_thread( helis_crows_snipe,::helis_crows_snipe_think );
	if( isdefined( level.helis_ambient_capitol ) )
		array_thread( level.helis_ambient_capitol,::helis_ambient_capitol_think );
	thread AI_cleanup_non_squad( "allies", 128 );

}

helis_crows_snipe_think()
{
	self endon( "death" );	
	
	flag_wait( "obj_commerce_defend_crow_given" );
	self thread vehicle_delete_when_hit_script_noteworthy( "start" );
	
	/*-----------------------
	MAKE ANY AMBIENT VEHICLES COUNT AS OBJECTIVES WHILE ALIVE
	-------------------------*/	
	flag_wait( "obj_commerce_defend_javelin_given" );
	self thread helis_crowsnest_think();
	
	
}

helis_ambient_capitol_think()
{
	self endon( "death" );	
	
	flag_wait( "player_shot_at_crowsnest_guys" );
	self thread vehicle_delete_when_hit_script_noteworthy( "start" );

}

crows_nest_enemy_chatter()
{
	obj_commerce_sector_3 = getstruct( "obj_commerce_sector_3", "targetname" );
	origin = obj_commerce_sector_3.origin;
	sFlagToKillDialogue = "player_shot_at_crowsnest_guys";
	level endon( sFlagToKillDialogue );
	
	while( !flag( sFlagToKillDialogue ) )
	{
		//	Russian Airborne 3	2 transports attempting to evac at grid square 253221!	
		play_sound_then_kill_on_flag( "dcburn_ra3_gridsquare", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 1	Don't worry, they're not going to get very far.	
		play_sound_then_kill_on_flag( "dcburn_ra1_dontworry", origin, sFlagToKillDialogue );
		
		wait( .5 );
		
		//	Russian Airborne 2	Target detected. Armored personnel carrier, moving northwest at 60 kilometres per hour. 20 degrees left of the Washington Monument.	
		play_sound_then_kill_on_flag( "dcburn_ra2_60kph", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 3	I see it. Locking onto target. Standby for launch.	
		play_sound_then_kill_on_flag( "dcburn_ra3_standbyforlaunch", origin, sFlagToKillDialogue );
		
		wait( .5 );
		
		//	Russian Airborne 1	Tank, range two miles. Speed, 20 kilometres per hour, moving left to right by the green car.	
		play_sound_then_kill_on_flag( "dcburn_ra1_bygreencar", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 2	I have the tank in my sights and I'm tracking it now. 	
		play_sound_then_kill_on_flag( "dcburn_ra2_trackingitnow", origin, sFlagToKillDialogue );
		
		wait( .75 );
		
		//	Russian Airborne 3	This is too easy. I thought the Americans would fight harder than this!	
		play_sound_then_kill_on_flag( "dcburn_ra3_tooeasy", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 1	Armored personnel carrier, range four miles. I confirm target is hostile.	
		play_sound_then_kill_on_flag( "dcburn_ra1_confirmhostile", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 2	Locking onto target. Standby. They've increased speed to 25 kilometres per hour.	
		play_sound_then_kill_on_flag( "dcburn_ra2_25kph", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 3	Enemy tank moving east, range 572 metres, bearing 172 degrees! Request permission to engage!	
		play_sound_then_kill_on_flag( "dcburn_ra3_range572meters", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 1	Armored personnel carrier has stopped, they're loading passengers. Destroy it.	
		play_sound_then_kill_on_flag( "dcburn_ra1_destroyit", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 2	Tank moving east, range 572 metres, acknowledged. You are cleared to engage the target.	
		play_sound_then_kill_on_flag( "dcburn_ra2_clearedtoengage", origin, sFlagToKillDialogue );
		
		//	Russian Airborne 3	I bet you never thought you'd see the day the Americans would run from us on the battlefield!	
		play_sound_then_kill_on_flag( "dcburn_ra3_runfromus", origin, sFlagToKillDialogue );

	}
}


AI_commerce_sector_2_guys_think()
{
	self endon( "death" );
	flag_wait( "fifth_floor_guys_damaged" );
	self.combatMode = "ambush";
}

dialogue_to_crowsnest()
{
	flag_wait( "player_entering_top_elevator_area" );
	
	flag_set( "start_music_to_crowsnest" );
	//****Sgt. Macey: Overlord, We're on the fifth floor, proceeding to the southwest corner.
	radio_dialogue( "dcburn_mcy_onfifth" );
	
	
	if ( ( flag( "player_approaching_flare_moment" ) ) || ( flag( "player_approaching_flare_moment" ) ) )
	{
		//alt dialogue pending
	}
	else
	{
		//Overlord HQ Radio Voice: Copy that, Two-One.
		radio_dialogue( "dcburn_hqr_copy21" );
	}

	flag_wait_either( "player_approaching_flare_moment", "player_looking_at_flare_moment" );
	
	wait( .2 );
	//****Cpl. Dunn: I got movement.
	radio_dialogue( "dcburn_cdn_movement" );
	
	wait( 1 );
	
	if ( !flag( "fifth_floor_guys_damaged" ) )
	{
		//Sgt. Macey	Watch your sectors.	
		radio_dialogue("dcburn_mcy_watchsectors");
	}
	wait( 3 );
	if ( !flag( "fifth_floor_guys_damaged" ) )
	{
		//Sgt. Macey	Check those corners.	
		radio_dialogue("dcburn_mcy_checkcorners");
	}
	flag_wait( "player_approaching_crowsnest2" );
	
	//Sgt. Macey: All Hunter units, I have a visual on the enemy crow's nest at the southwest corner. Move forward and clear it out.
	radio_dialogue( "dcburn_mcy_visoncrow" );

	flavorbursts_off( "allies" );
	//Ranger 4	Mystic Two-One, CENTCOM just gave the order to abandon all evac sites to the east of the Potomac!!! Get your ass outta there!!! 	
	level.player play_sound_on_entity( "dcburn_ar4_centcom" );
	flavorbursts_on( "allies" );
	
	flag_set( "macey_tells_you_to_move_to_crows" );
	wait(.5);
	

	if ( !flag( "player_shot_at_crowsnest_guys" ) )
	{
		thread autosave_by_name( "crow_sneak" );
		//Sgt. Macey: Standby to engage.
		radio_dialogue("dcburn_mcy_sby2engage");
	}
	
	flavorbursts_off( "allies" );
	//Ranger 1	Darkstar One-Three, we do not have enough shells remaning in the battery to provide effective supporting fire to your position! We are pullin' outta D.C. in five mikes!! Out!!	
	level.player play_sound_on_entity( "dcburn_ar1_fivemikes" );
		
	//Ranger 2	Rhino Two-One, get your team outta there pronto!!! We cannot hold this position any longer!! We are leaving D.C.!! I repeat, we are leaving D.C.!!! 	
	level.player play_sound_on_entity( "dcburn_ar2_outtathere" );
	flavorbursts_on( "allies" );

}

/****************************************************************************
    COMMERCE BUILDING - CROWS_NEST SNIPE
****************************************************************************/ 
AA_crows_nest_snipe_init()
{
	thread AAA_sequence_crowsnest();
	thread AAA_sequence_crowsnest_snipe();
	thread obj_commerce_defend_snipe();
	thread obj_commerce_defend_crow();
	thread dialogue_crowsnest();
	flag_wait( "start_crow_armor_sequence" );
	thread AA_crows_nest_armor_init();
	
}

AAA_sequence_crowsnest()
{

	/*-----------------------
	SEQUENCE SETUP
	-------------------------*/	
	triggersEnable( "colornodes_crowsnest", "script_noteworthy", true );
	volume_crowsnest = getent( "volume_crowsnest", "targetname" );
	
	flag_wait( "player_approaching_crowsnest" );
	
	/*-----------------------
	SPAWN CROWSNEST TEAMS
	-------------------------*/	
	hostiles_crowsnest = array_spawn( getentarray( "hostiles_crowsnest", "targetname" ), true );
	thread waittill_dead_then_set_flag( hostiles_crowsnest, "crowsnest_has_been_cleared" );
	array_thread( hostiles_crowsnest, ::AI_sneak_monitor, "player_shot_at_crowsnest_guys" );
	array_thread( hostiles_crowsnest, ::AI_crowsnest_player_too_close );
	
	array_thread( level.squad,::crowsnest_friendlies_inside );
	
	/*-----------------------
	CROWSNEST CLEARED
	-------------------------*/	
	flag_wait( "player_shot_at_crowsnest_guys" );
	
	tanks_crowsnest_wave1 = spawn_vehicles_from_targetname( "tanks_crowsnest_wave1" );
	thread tanks_crowsnest_wave1_gopath( tanks_crowsnest_wave1 );
	array_thread( tanks_crowsnest_wave1,:: tanks_crowsnest_wave1_think );
	
	array_thread( level.squad,::AI_awesome_accuracy_untill_flag, "crowsnest_has_been_cleared"  );
	
	flag_wait( "crowsnest_has_been_cleared" );
	
	thread flag_set_delayed( "obj_commerce_complete", 1 );
	
	/*-----------------------
	FRIENDLIES INTO CROWNEST IF NOT THERE ALREADY
	-------------------------*/	
	colornodes_crowsnest = getent( "colornodes_crowsnest", "script_noteworthy" );
	colornodes_crowsnest notify( "trigger", level.player );
	thread dummy_trigger( "dummy_colornodes_crows1" );	//make friendlies move up
	thread dummy_trigger( "dummy_colornodes_crows2" );	//make friendlies move up
	
	flag_wait( "humvee_spotlight_deleted" );
	
	flag_wait( "obj_commerce_defend_snipe_given" );
	jets_crow_01 = spawn_vehicles_from_targetname_and_drive( "jets_crow_01" );


}

crowsnest_friendlies_inside()
{
	self endon( "death" );
	level endon( "player_shot_at_crowsnest_guys" );
	flag_wait( "player_approaching_crowsnest_door" );
	player_in_crowsnest_room = getent( "player_in_crowsnest_room", "targetname" );
	while( !flag( "player_shot_at_crowsnest_guys" ) )
	{
		wait( .1 );
		if ( !isdefined( self ) )
			return;
		if( self istouching( player_in_crowsnest_room ) )
			break;
	}
	
	thread axis_not_ignored();
	flag_set( "player_shot_at_crowsnest_guys" );

}

axis_not_ignored()
{
	ai = getaiarray( "axis" );
	foreach( guy in ai )
	{
		if ( !isdefined( guy ) )
			continue;
		guy.ignoreme = false;
	}
}

AAA_sequence_crowsnest_snipe()
{
	flag_wait( "player_approaching_crowsnest2" );
	thread crowsnest_ambient_vehicles();
	
	model_barrett = getent( "model_barrett", "targetname" );
	model_barrett_glow = spawn( "script_model", model_barrett.origin );
	model_barrett_glow setModel( "weapon_m82_MG_Setup_obj" );
	model_barrett_glow.origin = model_barrett.origin;
	model_barrett_glow.angles = model_barrett.angles ;
	model_barrett_glow hide();
	
	/*-----------------------
	SPAWN FRIENDLY VEHICLES THAT PLAYER HAS TO KEEP ALIVE
	-------------------------*/	
	level.evacSiteVehicles = getentarray( "vehicles_crowsnest_defend", "targetname" );
	array_thread( level.evacSiteVehicles,::vehicles_crowsnest_defend_think );
	thread crowsnest_defend_failure();

	/*-----------------------
	SPAWN WW2 MEMORIAL GUYS
	-------------------------*/	
	level.evacSiteEnemies = array_spawn( getentarray( "hostiles_ww2_barret", "targetname" ), true );
	array_thread( level.evacSiteEnemies, ::obj_commerce_defend_snipe_enemies_think );
	array_thread( level.evacSiteEnemies, ::AI_blood_spatter_when_sniped );
	array_thread( level.evacSiteEnemies,::magic_bullet_shield );
	
	/*-----------------------
	CROWSNEST CLEARED, GET ON BARRET
	-------------------------*/	
	flag_wait( "crowsnest_has_been_cleared" );
	
	array_thread( level.evacSiteEnemies,::stop_magic_bullet_shield );
	
	flag_wait( "obj_commerce_defend_snipe_given" );
	
	/*-----------------------
	FRIENDLIES START SHOOTING TOWARDS DRONES BELOW
	-------------------------*/	
	thread friendlies_shoot_at_crows_drones_start();
	
	
	/*-----------------------
	MAKE BARRET GLOW IF PLAYER NOT ON IT
	-------------------------*/	
	thread crowsnest_barret_glow( model_barrett, model_barrett_glow );
	thread crowsnest_nags_snipe();
	/*-----------------------
	MAKE ENEMIES START TO OWN EVAC SITE
	EITHER WHEN PLAYER GETS ON GUN, OR TIMEOUT
	-------------------------*/	
	flag_wait_or_timeout( "player_is_on_turret", 5 );
	
	/*-----------------------
	GRADUALLY MAKE ENEMIES FIRE AT LIVE TARGETS
	-------------------------*/	
	thread evac_site_enemies_fire_live();
	
	/*-----------------------
	PREP ENEMIES COME UP BEHIND PLAYER
	-------------------------*/	
	flag_wait( "only_2_sniper_enemies_remaining" );
	
	thread player_fails_if_abandons_crowsnest();
	
	//Overlord (HQ Radio) Hunter Two-One be advised, you have enemy foot mobiles converging on your position...stay frosty.	
	flag_clear( "can_talk" );	
	radio_dialogue( "dcburn_hqr_stayfrosty" );
	flag_set( "can_talk" );	
	
	/*-----------------------
	BARRETT GAMEPLAY DONE...ENEMIES INSIDE!
	-------------------------*/	
	flag_wait( "obj_commerce_defend_snipe_complete" );
	
	/*-----------------------
	FRIENDLIES STOP OWNING DRONES
	-------------------------*/	
	thread friendlies_shoot_at_crows_drones_stop();
	
	thread autosave_now( true );
	
	thread flag_set_delayed( "obj_commerce_defend_crow_given", 3 );
	array_thread( level.squad,::AI_awesome_accuracy_untill_flag, "perimeter_enemies_have_retreated"  );
	
	battlechatter_on( "allies" );
	thread spawn_trigger_dummy( "dummy_spawner_crowsnest_assault_guys_wave1" );
	thread dialogue_nag_hostiles_at_crows();
	thread player_barrett_damage();
	level.guysKilled = 0;
	
	/*-----------------------
	FRIENDLIES TAKE UP DEFENSIVE POSITIONS
	-------------------------*/	
	triggersEnable( "colornodes_crowsnest_surrounded", "script_noteworthy", true );
	trig_colornode = getent( "colornodes_crowsnest_surrounded", "script_noteworthy" );
	trig_colornode notify( "trigger", level.player );
	
	/*-----------------------
	SURROUNDING ENEMIES KILLED
	-------------------------*/	
	flag_wait( "player_killed_enough" );
	flag_set( "start_crow_armor_sequence" );
	
	flag_set( "obj_commerce_defend_crow_complete" );
	thread autosave_by_name( "defend_crow_complete" );
	killspawner( 12 );
	crowsnest_assault_guys_wave1 = getaiarray( "axis" );
	thread AI_delete_when_out_of_sight( crowsnest_assault_guys_wave1, 512 );
	array_thread( crowsnest_assault_guys_wave1,::retreat_to_elevators );

}

player_fails_if_abandons_crowsnest()
{
	level endon( "player_getting_on_minigun" );
	flag_wait( "player_abandoning_crowsnest" );
	
	//"Mission Failed.\nThe evac site was destroyed."
	setDvar( "ui_deadquote", &"DCBURNING_MISSIONFAIL_CROWSNEST_SNIPE" );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}

player_barrett_damage()
{
	wait( 3 );
	
	//give player some clues that he is getting lit up
	iLoveTaps = 0;
	while ( flag( "player_is_on_turret" ) )
	{
		level.player DoDamage( 20 / level.player.damageMultiplier, level.player.origin );
		level.player viewkick( 127, level.player.origin );
		wait( randomfloatrange( 1, 2 ) );
		iLoveTaps++;
		if ( iLoveTaps > 3 )
			break;
	}
	
	//Player can't take a hint, throw a nade at his ass
	if ( flag( "player_is_on_turret" ) )
	{
		obj_commerce_defend_javelin = getstruct( "obj_commerce_defend_javelin", "targetname" );
		MagicGrenade( "fraggrenade", obj_commerce_defend_javelin.origin + ( 0, 0, 144 ), obj_commerce_defend_javelin.origin + ( 0, 0, 32 ) );
	}
	
}

retreat_to_elevators()
{
	self endon( "death" );
	if ( !isdefined( self ) )
		return;
	self notify( "stop_seeking" );
	position = getstruct( "obj_commerce_sector_1d", "targetname" );
	self setgoalpos( position.origin );
}

AI_crowsnest_assault_guys_wave1_think()
{
	level endon( "player_killed_enough" );
	if( !isalive( self ) )
		return;
	while( isalive( self ) )
	{
		self waittill( "death", attacker );
		if ( ( isdefined( attacker ) )&& ( isplayer( attacker ) ) )
		{
			level.guysKilled++;
			if ( level.guysKilled > 3 )
			{
				flag_set( "player_killed_enough" );
			}
			else
				break;
				
		}
	}
}

friendlies_shoot_stingers_start()
{
	aFriendlies = [];
	aFriendlies[ 0 ] = level.teamleader;
	aFriendlies[ 1 ] = level.friendly02;
	
	friendlies_crowsnest_stage = getentarray( "friendlies_crowsnest_stage", "targetname" );
	aFriendlies[ 0 ] thread friendly_shoot_stingers_and_jav_think( friendlies_crowsnest_stage [ 0 ] );
	aFriendlies[ 1 ] thread friendly_shoot_stingers_and_jav_think( friendlies_crowsnest_stage [ 1 ] );
}

friendly_shoot_stingers_and_jav_think( stingerJavNode )
{
	self.scriptedTargets = [];
	aDummyTargets = stingerJavNode get_linked_ents();
	aTargetHeliNodes = stingerJavNode get_linked_structs();
	array_thread( aTargetHeliNodes, ::friendly_stinger_target_nodes_think, self );
	isJavelin = false;
	
	
	/*-----------------------
	DON'T TELEPORT TILL OUT OF SIGHT
	-------------------------*/	
	while( !flag( "only_1_javelin_enemies_remaining" ) )
	{
		wait( 1 );
		if ( within_fov( level.player.origin, level.player.angles, stingerJavNode.origin + ( 0, 0, 32 ), level.cosine[ "90" ] ) )
			continue;
		if ( within_fov( level.player.origin, level.player.angles, self.origin + ( 0, 0, 32 ), level.cosine[ "90" ] ) )
			continue;
		break;
	}
	self friendly_shoot_at_crows_drones_stop();
	
	if ( flag( "only_1_javelin_enemies_remaining" ) )
		return;
	
	/*-----------------------
	FRIENDLY IDLES WITH WEAPON
	-------------------------*/	
	playerBadPlace = undefined;
	self.reference = stingerJavNode;
	magicBulletType = "stinger";
	weapon = "weapon_stinger";
	muzzleFlash = "javelin_muzzle";
	if ( stingerJavNode.animation == "stinger_idle" )
	{
		playerBadPlace = getent( "volume_stinger_safezone", "targetname" );
		self get_stinger_anims();
	}
		
	else
	{
		playerBadPlace = getent( "volume_javelin_safezone", "targetname" );
		isJavelin = true;
		self.animation = stingerJavNode.animation;
		self get_javelin_anims();
		magicBulletType = "javelin_dcburn";
		muzzleFlash = "javelin_muzzle";
		weapon = "weapon_javelin_sp";
	}
	self hide();
	self.reference anim_generic_first_frame( self, self.sAnimIdleStart );
	self show();
	eTarget = undefined;
	newMissile = undefined;
	stinger_source_org = undefined;
	
	self attach( weapon, "TAG_INHAND", 1 );
	
	randomWait = 8;
	/*-----------------------
	SHOOT AT TARGETS
	-------------------------*/	
	self.ignoreme = true;
	while( !flag( "only_1_javelin_enemies_remaining" ) )
	{
		randomWait = randomfloatrange( 6, 9 );
		self.reference thread anim_generic_loop( self, self.sAnimIdle, "stop_idle" );
		self waittill_notify_or_timeout( "new_target", randomWait );
		self.reference notify( "stop_idle" );
		self.reference thread anim_generic( self, self.sAnimFire );
		self waittillmatch( "single anim", "fire_weapon" );
		eTarget = self friendly_shoot_stingers_get_target( aDummyTargets );
		if ( ( isdefined( eTarget ) ) && ( !level.player istouching( playerBadPlace ) ) )
		{
			stinger_source_org = self gettagorigin( "tag_inhand" );
			newMissile = MagicBullet( magicBulletType, stinger_source_org, eTarget.origin );
			newMissile Missile_SetTargetEnt( eTarget );
			if ( isJavelin )
			{
				newMissile Missile_SetFlightmodeTop();
				Playfx( getfx( muzzleFlash ), stinger_source_org );
			}
		}
		self waittillmatch( "single anim", "end" );
		if ( ( flag( "only_1_javelin_enemies_remaining" ) ) || ( flag( "obj_commerce_defend_javelin_complete" ) ) )
			break;
	}
	self.ignoreme = false;
	self notify( "stop_shooting_stingers_and_javs" );
	self notify( "stop_first_frame" );
	self.reference notify( "stop_idle" );
	self anim_stopanimscripted();
	self detach( weapon, "TAG_INHAND" );
	self.reference = undefined;
	self.scriptedTargets = undefined;
}

player_is_not_in_the_way( playerBadPlace )
{
	if ( distance( playerBadPlace, level.player.origin ) > 64 )
		return true;
	else
		return false;
}

friendly_shoot_stingers_stop()
{
	
}

friendly_shoot_stingers_get_target( aDummyTargets )
{
	if ( !isdefined( self.scriptedTargets ) )
		return aDummyTargets[ randomint( aDummyTargets.size ) ];

	if ( self.scriptedTargets.size == 0 )
		return aDummyTargets[ randomint( aDummyTargets.size ) ];
		
	self.scriptedTargets = remove_dead_from_array( self.scriptedTargets );
		
	if ( ( level.friendlyArmorTargets > 0 ) && ( level.friendliesCanHelpCrowsnest ) && ( self.scriptedTargets.size > 0 ) )
	{
		return( self.scriptedTargets[ 0 ] );
	}
	else
		return aDummyTargets[ randomint( aDummyTargets.size ) ];
}

friendly_stinger_target_nodes_think( guy )
{
	level endon( "obj_commerce_defend_javelin_complete" );
	guy endon( "stop_shooting_stingers_and_javs" );
	self endon( "death" );
	//self ==> the node the heli target will trigger to show its in a good place to be shot
	while ( ( !flag( "only_1_javelin_enemies_remaining" ) ) && ( isdefined( guy.scriptedTargets ) ) )
	{
		self waittill( "trigger", heli );
		if ( !isdefined( heli ) )
			break;
		if ( !isdefined( guy.scriptedTargets ) )
			break;
		guy.scriptedTargets = array_add( guy.scriptedTargets, heli );
		guy notify( "new_target" );
		wait( 2 );
		if ( isdefined( heli ) )
			guy.scriptedTargets = array_remove( guy.scriptedTargets, heli );
		
		if ( ( flag( "only_1_javelin_enemies_remaining" ) ) || ( flag( "obj_commerce_defend_javelin_complete" ) ) )
			break;
	}
}

friendlies_shoot_at_crows_drones_start()
{
	aNodes = getnodearray( "crow_nodes_drone_fire", "targetname" );
	spawner = getent( "hostiles_fodder_crowsnest", "targetname" );
	level.hostiles_fodder_crowsnest = spawner spawn_ai();
	aFriendlies = [];
	aFriendlies[ 0 ] = level.teamleader;
	aFriendlies[ 1 ] = level.friendly02;
	
	foreach( guy in aFriendlies )
	{
		guy disable_ai_color();
		eNode = getfarthest( level.player.origin, aNodes );
		aNodes = array_remove( aNodes, eNode );
		guy.fixednode = false;
		guy.goalradius = 16;
		guy setGoalNode( eNode );
	}
	array_thread( aFriendlies,::friendlies_shoot_at_crows_drones_think );
	
}
friendlies_shoot_at_crows_drones_think()
{
	self endon( "stop_shooting_at_drones" );
	while ( true )
	{
		wait( randomfloatrange( 3, 6 ) );
		self.ignoreall = true;
		wait( randomfloatrange( 3, 6 ) );
		self.ignoreall = false;
	}
}

friendlies_shoot_at_crows_drones_stop()
{
	
	if ( isdefined( level.hostiles_fodder_crowsnest ) )
		level.hostiles_fodder_crowsnest AI_delete();
	aFriendlies = [];
	aFriendlies[ 0 ] = level.teamleader;
	aFriendlies[ 1 ] = level.friendly02;
	array_thread( aFriendlies,::friendly_shoot_at_crows_drones_stop );
}

friendly_shoot_at_crows_drones_stop()
{
	self notify ( "stop_shooting_at_drones" );
	wait( 0.05 );
	self enable_ai_color();
	self.fixednode = true;
	self.ignoreall = false;
}

dialogue_nag_hostiles_at_crows()
{
	level endon( "player_killed_enough" );
	while ( !flag( "player_killed_enough" ) )
	{
		if ( flag( "player_killed_enough" ) )
			break;
		//Cpl. Dunn	22	2	Hostiles inside the perimeter! Open fire! Open fire!	
		level.friendly02 dialogue_execute( "dcburn_cpd_inperimeter" );
		wait( randomfloatrange( 8, 14 ) );
		
		if ( flag( "player_killed_enough" ) )
			break;
		//Cpl. Dunn	22	4	Taking fire! Taking fire! Foot mobiles inside the perimeter! 	
		level.friendly02 dialogue_execute( "dcburn_cpd_takingfire" );
		wait( randomfloatrange( 8, 14 ) );

		if ( flag( "player_killed_enough" ) )
			break;
		//Cpl. Dunn	22	3	Eyes up! Hostiles on our six!!!	
		level.friendly02 dialogue_execute( "dcburn_cpd_hostatsix" );
		wait( randomfloatrange( 8, 14 ) );

	}
}

AI_sneak_monitor( sFlagToSet )
{
	self endon( "alerted" );
	self thread AI_player_gunshot_monitor();
	wait( .5 );
	//self waittill_any( "grenade danger", "damage", "gunshot", "death" );
	self waittill_any( "damage", "death", "shot_at" );
	flag_set( sFlagToSet );
	if( isdefined( self ) )
		self thread AI_become_alerted();
}

AI_player_gunshot_monitor()
{
	distSquared = 512 * 512;
	self endon( "death" );
	self endon( "alerted" );
	self addAIEventListener( "grenade danger" );
	self addAIEventListener( "gunshot" );
	self addAIEventListener( "silenced_shot" );
	self addAIEventListener( "bulletwhizby" );
	self addAIEventListener( "projectile_impact" );
	
	wait( .5 );
	while( isalive( self ) )
	{
		self waittill( "ai_event", eventtype );
		if ( ( eventtype == "grenade danger" ) || ( eventtype == "damage" ) || ( eventtype == "projectile_impact" ) || ( eventtype == "explode" ) )
			break;
		if ( distancesquared( self.origin, level.player.origin ) > distSquared )
			continue;
		if ( ( eventtype == "grenade danger" ) || ( eventtype == "damage" ) || ( eventtype == "gunshot" ) || ( eventtype == "bulletwhizby" ) || ( eventtype == "projectile_impact" ) || ( eventtype == "explode" ) )
			break;
	}
	self notify( "shot_at" );
}

AI_crowsnest_player_too_close()
{
	self endon( "death" );
	self endon( "alerted" );
	flag_wait_any( "player_entering_wall_hole", "player_shot_at_crowsnest_guys", "player_gawking_at_crowsnest_guys" );
	flag_set( "player_shot_at_crowsnest_guys" );
	self thread AI_become_alerted();
}

evac_site_enemies_fire_live()
{
	level endon ( "obj_commerce_defend_snipe_complete" );
	/*-----------------------
	GRADUALLY MAKE ENEMIES FIRE AT LIVE TARGETS (BUT NOT FOR VET/HARDENED)
	-------------------------*/	
	iRampInterval = 4;
	if ( ( level.gameskill == 2 ) || ( level.gameskill == 3 ) )
		iRampInterval = 0.1;

	foreach( guy in level.evacSiteEnemies )
	{
		if ( isalive( guy ) )
		{
			guy.fireAtLiveTargets = true;
			wait( iRampInterval );
		}
	}
}

crowsnest_nags_snipe()
{
	
	volume_crowsnest = getent( "volume_crowsnest", "targetname" );
	level.lasttimePlayerKilledEnemy = getTime();
	
	barret_nag_number = 0;
	barret_nag_number_max = 2;
	
	stay_in_nest_nag_number = 0;
	stay_in_nest_nag_number_max = 2;
	
	barret_shoot_nag_number = 0;
	barret_shoot_nag_number_max = 1;
	wait( .5 );
	
	while( !flag( "obj_commerce_defend_snipe_complete" ) )
	{
		//reset nag numbers
		if ( barret_nag_number > barret_nag_number_max )
			barret_nag_number = 0;
		if ( stay_in_nest_nag_number > stay_in_nest_nag_number_max )
			stay_in_nest_nag_number = 0;
		if ( barret_shoot_nag_number > barret_shoot_nag_number_max )
			barret_shoot_nag_number = 0;
			
		nag_wait();
		flag_wait( "can_start_crow_nags" );
		if ( flag( "obj_commerce_defend_snipe_complete" ) )
			break;
			
		if ( ( !level.player istouching( volume_crowsnest ) ) && ( flag( "can_talk" ) ) )
		{
			flag_clear( "can_talk" );
			level.teamleader dialogue_execute( "stay_in_nest_nag_" + stay_in_nest_nag_number );
			stay_in_nest_nag_number++;
			flag_set( "can_talk" );

		}
		
		else if( ( !flag( "player_is_on_turret" ) ) && ( flag( "can_talk" ) ) )
		{
			flag_clear( "can_talk" );
			level.teamleader dialogue_execute( "barret_nag_" + barret_nag_number );
			barret_nag_number++;
			flag_set( "can_talk" );
		}
		
		else if( ( !player_killing_crow_targets_at_a_good_pace() ) && ( flag( "can_talk" ) ) )
		{
			flag_clear( "can_talk" );
			level.teamleader dialogue_execute( "barret_shoot_nag_" + barret_shoot_nag_number );
			barret_shoot_nag_number++;
			flag_set( "can_talk" );
		}
	}
}

crowsnest_ambient_vehicles()
{
	/*-----------------------
	GET SCRIPTED EVAC SITE VEHICLES READY
	-------------------------*/	
	crowsnest_seaknight_01 = getent( "crowsnest_seaknight_01", "targetname" );
	crowsnest_seaknight_02 = getent( "crowsnest_seaknight_02", "targetname" );
	crowsnest_seaknight_01 notify( "spawn" );
	crowsnest_seaknight_02 notify( "spawn" );
	
	flag_wait( "player_in_crowsnest_room" );
	flag_wait( "make_seaknights_take_off" );
	
	crowsnest_seaknight_01 notify( "play_anim" );
	wait( 3 );
	crowsnest_seaknight_02 notify( "play_anim" );
}

crowsnest_defend_failure()
{
	percentDestroyed = undefined;
	color = ( 1, 1, 0 );
	
	level.evacSiteVehiclesStartNumber = level.evacSiteVehicles.size;
	HUDdefendStatus = createFontString( "default", 1.5 );
	HUDdefendStatus setPoint( "TOP", undefined, -41, 30 );
	HUDdefendStatus.color = color;
	HUDdefendStatus.alpha = 0;

	flag_wait( "obj_commerce_defend_snipe_given" );
	HUDdefendStatus setText( &"DCBURNING_INFO_EVAC_SITE_HEALTH" );
	

	HUDpercentage = createFontString( "default", 1.5 );
	HUDpercentage setPoint( "TOP", undefined, 45, 30 );
	HUDpercentage.color = color;
	HUDpercentage.alpha = 0;
	
	if ( getdvar( "dc_debug" ) == "1" )
	{
		HUDpercentage fadeOverTime( 1 );
		HUDdefendStatus fadeOverTime( 1 );
		HUDdefendStatus.alpha = 1;
		HUDpercentage.alpha = 1;
	}
	
	thread evac_site_damage_nags_snipe();
	
	while ( !flag( "obj_commerce_defend_snipe_complete" ) )
	{
		//HUDpercentage setText( get_evac_site_percent_destroyed() );
		percentDestroyed = get_evac_site_percent_destroyed();
		if ( flag( "obj_commerce_defend_snipe_complete" ) )
			break;
		level waittill_either( "evac_vehicle_owned", "obj_commerce_defend_snipe_complete" );
		if ( flag( "obj_commerce_defend_snipe_complete" ) )
			break;
		if ( level.evacSiteVehicles.size < 2 )
		{
			thread crowsnest_failure_check();
		}
			
	}
	HUDdefendStatus fadeOverTime( 1 );
	HUDpercentage fadeOverTime( 1 );
	HUDdefendStatus.alpha = 0;
	HUDpercentage.alpha = 0;
	HUDdefendStatus destroyElem();
	HUDpercentage destroyElem();
}

evac_site_damage_nags_snipe()
{
	percentDestoyedAtLeast = 0;
	
	flag_wait( "can_start_crow_nags" );
	while ( !flag( "obj_commerce_defend_snipe_complete" ) )
	{
		flag_wait( "can_talk" );
		level waittill( "evac_vehicle_owned" );
		if ( level.evacSitePercentDestroyed == 100 )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	All callsigns, this is the Washington Monument evac site!!! Be advised, our situation is critical!!! We can't take much more of this!!! We need more time to get these civvies outta here!!!	
			radio_dialogue( "dcburn_evc_damage_fail" );
			flag_set( "can_talk" );
			return;
		}
		else if ( ( level.evacSitePercentDestroyed > 25 ) && ( level.evacSitePercentDestroyed < 50 ) && ( percentDestoyedAtLeast < 25 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	We're taking fire at the Washington Monument! We are down to 80 percent combat effectiveness! Request immediate sniper fire on targets west of the Monument, over!	
			radio_dialogue( "dcburn_evc_damage_00" );
			percentDestoyedAtLeast = 25;
			flag_set( "can_talk" );
		}
		else if ( ( level.evacSitePercentDestroyed > 50 ) && ( level.evacSitePercentDestroyed < 75 ) && ( percentDestoyedAtLeast < 50 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	All callsigns, be advised, enemies to the west are attempting a force-in-detail assault on the Washington Monument evac site! 	
			radio_dialogue( "dcburn_evc_damage_01" );
			percentDestoyedAtLeast = 50;
			flag_set( "can_talk" );
		}
		else if ( ( level.evacSitePercentDestroyed > 75 ) && ( level.evacSitePercentDestroyed < 90 ) && ( percentDestoyedAtLeast < 75 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	Washington Monument evac site to all callsigns!! Enemy fire from the west is threatening to destroy our position!! We can't take much more of this!!	
			radio_dialogue( "dcburn_evc_damage_02" );
			percentDestoyedAtLeast = 75;
			flag_set( "can_talk" );
		}
		else if ( ( level.evacSitePercentDestroyed > 90 ) && ( level.evacSitePercentDestroyed < 100 ) && ( percentDestoyedAtLeast < 90 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	Washington Monument evac site taking heavy fire!!! We're down to 50 percent combat effectiveness!!! We gotta get more fire support or this evac site is gonna fall!!! Over!!!	
			radio_dialogue( "dcburn_evc_damage_03" );
			percentDestoyedAtLeast = 90;
			flag_set( "can_talk" );
		}
	}
}

crowsnest_failure_check()
{
	level.evacSiteVehicles = remove_dead_from_array( level.evacSiteVehicles );
	if ( ( level.evacSiteVehicles.size == 0 ) && ( !flag( "obj_commerce_defend_snipe_complete" ) ) )
	{
		crowsnest_mission_fail_snipe();
	}
}

crowsnest_mission_fail_snipe()
{
	setDvar( "ui_deadquote", &"DCBURNING_MISSIONFAIL_CROWSNEST_SNIPE" );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}

crowsnest_mission_fail_armor()
{
	setDvar( "ui_deadquote", &"DCBURNING_MISSIONFAIL_CROWSNEST_SNIPE" );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}


get_evac_site_percent_destroyed()
{
	fPercentRemaining = ( level.evacSiteVehicles.size / level.evacSiteVehiclesStartNumber ) * 100;
	fPercentRemaining = roundDecimalPlaces( fPercentRemaining, 0 );
	fPercentDestroyed = 100 - fPercentRemaining;
	level.evacSitePercentDestroyed = fPercentDestroyed;
	sNumber = string( fPercentDestroyed ) + " percent";
	return sNumber;
}

roundDecimalPlaces( value, places, style )
{
	if ( !isdefined( style ) )
		style = "nearest";
	
	modifier = 1;
	for ( i = 0; i < places; i++ )
		modifier *= 10;
	
	newValue = value * modifier;
	
	if ( style == "up" )
		roundedValue = ceil( newValue );
	else if ( style == "down" )
		roundedValue = floor( newValue ); 	
	else
		roundedValue = newvalue + 0.5;	
		
	newvalue = Int( roundedValue );
	newvalue = newvalue / modifier;
	
	return newvalue;
}

crowsnest_barret_glow( model_barrett, model_barrett_glow )
{
	if ( !flag( "player_is_on_turret" ) )
	{
		model_barrett hide();
		model_barrett_glow show();
	}
	flag_wait( "player_is_on_turret" );
	model_barrett_glow hide();
	flag_waitopen( "player_is_on_turret" );
	model_barrett show();
}

dialogue_crowsnest()
{
	flag_wait( "crowsnest_has_been_cleared" );
	
	thread autosave_by_name( "crowsnest_cleared" );
	
	wait( 1 );
	flag_set( "make_seaknights_take_off" );
	
	//Sgt. Macey: Overlord this is Hunter Two-One. We've secured the enemy crow's nest on the southwest corner.
	level.teamleader dialogue_execute( "dcburn_mcy_seccrowsnest" );
	
	//Overlord HQ Radio Voice: Overlord copies all. Evac site reports several transports away, but they are still vulnerable. Can you provide support from your position, over?
	radio_dialogue( "dcburn_hqr_canyousupport" );
	
	//Sgt. Macey: Roger that. We're sittin' on a stockpile of enemy munitions. We'll dig in and burn through their ammo. Out.
	level.teamleader dialogue_execute( "dcburn_mcy_stockpile" );
	
	
	
	if ( !flag( "player_is_on_turret" ) )
	{
		//Sgt. Macey	21	1	Ramirez, get on that sniper rifle! Scan for targets to the south of the Washington Monument.	
		level.teamleader thread dialogue_execute( "dcburn_mcy_sniperrifle" );
	}
	else
	{
		//Sgt. Macey	Ramirez, scan for targets to the south of the Washington Monument!	
		level.teamleader thread dialogue_execute( "dcburn_mcy_scanfortargets" );
		
	}
	
	wait( 2 );
	flag_set( "obj_commerce_defend_snipe_given" );

	if ( !flag( "player_is_on_turret" ) )
	{
		wait( 4 );
	}

	//Evac Site Radio Voice	All callsigns on this net, this is the Washington Monument Evac Site! We're holding our own but have glassed enemies to the west and are taking fire from that direction!	
	radio_dialogue( "dcburn_evc_glassedenemieswest" );
	flag_set( "can_start_crow_nags" );
}

vehicles_crowsnest_defend_think()
{
	level endon( "obj_commerce_defend_snipe_complete" );
	/*-----------------------
	MAKE DAMAGEABLE/INVULNERABLE
	-------------------------*/	
	self setcandamage( true );
	origin = self.origin;
	/*-----------------------
	WAIT TILL DAMAGED
	-------------------------*/	
	while( isdefined( self ) )
	{
		self waittill( "damage", amount, attacker, enemy_org, impact_org, type );
		if ( !isdefined( type ) )
			continue;
		if ( !isdefined( attacker ) )
			continue;
		if ( ( isdefined( attacker.code_classname ) ) && ( attacker.code_classname == "misc_turret" ) )			//don't blow up if using barrett
			continue;
		if ( !isdefined( amount ) )
			continue;
		if ( isplayer( attacker ) )
			continue;
		if ( ( isdefined( attacker.team ) ) && ( attacker.team != "axis" ) )
			continue;
		if ( ( type == "MOD_PROJECTILE" ) && ( amount > 999 ) )
			break;
		if ( ( type == "MOD_PROJECTILE_SPLASH" ) && ( amount == 4000 ) )
			break;
	}
	
	/*-----------------------
	REMOVE FROM POOL OF TARGETS/VEHICLES
	-------------------------*/	
	if ( is_in_array( level.evacSiteVehicles, self ) )
		level.evacSiteVehicles = array_remove( level.evacSiteVehicles, self );
	if ( is_in_array( level.targetsScriptedJavStinger, self ) )
		level.targetsScriptedJavStinger = array_remove( level.targetsScriptedJavStinger, self );
	self.dead = true;
	level notify( "evac_vehicle_owned" );
	
	/*-----------------------
	IF A SCRIPT_MODEL, DELETE AND SWAP
	-------------------------*/	
	eDeathModel = undefined;
	effect = "large_vehicle_explosion";
	sound = "exp_tanker_vehicle";
	
	if ( isdefined( self.script_linkTo ) )
	{
		eDeathModel = getent( self.script_linkto, "script_linkname" );
		eDeathModel show();	
		self delete();

	}
	else
	{
		switch( self.model )
		{
			case "vehicle_hummer": 
				eDeathModel = "vehicle_hummer_destroyed";
				sound = "exp_armor_vehicle";
				break;
			case "vehicle_bradley_static": 
				eDeathModel = "vehicle_bradley_destroyed";
				sound = "exp_armor_vehicle";
				break;
			default:
				assertmsg( "no destroyed model defined for " + self.model + " at " + self.origin );
		}
		
		
		self setModel( eDeathModel );
	}
	/*-----------------------
	PLAY FX AND EXPLOSION
	-------------------------*/	
	playfx( getfx( effect ), origin );
	thread play_sound_in_space( sound, origin );

}

vehicles_cheap_waittill_destroyed_think()
{
	self endon( "death" );
	/*-----------------------
	MAKE DAMAGEABLE/INVULNERABLE
	-------------------------*/	
	self setcandamage( true );

	/*-----------------------
	WAIT TILL DAMAGED
	-------------------------*/	
	while( isdefined( self ) )
	{
		self waittill( "damage", amount, attacker, enemy_org, impact_org, type );
		if ( !isdefined( type ) )
			continue;
		if ( !isdefined( attacker ) )
			continue;
		if ( !isdefined( amount ) )
			continue;
		if ( isplayer( attacker ) )
			continue;
		if ( ( type == "MOD_PROJECTILE" ) && ( amount > 999 ) )
			break;
		if ( ( type == "MOD_PROJECTILE_SPLASH" ) && ( amount == 4000 ) )
			break;
	}

	/*-----------------------
	IF A SCRIPT_MODEL, DELETE AND SWAP
	-------------------------*/	
	eDeathModel = undefined;
	effect = "large_vehicle_explosion";
	sound = "exp_tanker_vehicle";
	fireFx = "tanker_fire";
	onFire = false;
	
	if ( isdefined( self.script_linkTo ) )
	{
		eDeathModel = getent( self.script_linkto, "script_linkname" );
		eDeathModel show();	
		self delete();
	}
	else
	{
		switch( self.model )
		{
			case "vehicle_hummer": 
				eDeathModel = "vehicle_hummer_destroyed";
				sound = "exp_armor_vehicle";
				fireFx = undefined;
				break;
			case "vehicle_bradley": 
				eDeathModel = "vehicle_bradley";
				sound = "exp_armor_vehicle";
				fireFx = undefined;
				break;
			case "vehicle_m1a1_abrams": 
				eDeathModel = "vehicle_m1a1_abrams_dmg";
				sound = "exp_armor_vehicle";
				fireFx = undefined;
				break;
			default:
				assertmsg( "no destroyed model defined for " + self.model + " at " + self.origin );
		}
		
		
		self setModel( eDeathModel );
	}
	/*-----------------------
	PLAY FX AND EXPLOSION
	-------------------------*/	
	playfx( getfx( effect ), self.origin );
	self thread play_sound_in_space( sound );
	if ( isDefined( fireFx ) )
	{
		dummy = spawn( "script_origin", self.origin + ( 0, 0, 0 ) );
		dummy.angles = self.angles;
		fx = spawnFx( getFx( fireFx ), dummy.origin );
		triggerFx( fx );
		flag_wait( "player_heli_19" );
		fx delete();
		dummy delete();
	}
}


/****************************************************************************
    COMMERCE BUILDING - CROWS_NEST ARMOR
****************************************************************************/ 
AA_crows_nest_armor_init()
{
	thread AAA_sequence_crowsnest_armor();
	thread javelin_hints();
	thread backup_enemies_for_javelin_sequence();
	thread music_crowsnest_armor();
	thread obj_commerce_defend_javelin();
	thread dialogue_crow_armor();
	flag_wait( "crowsnest_sequence_finished" );
	thread AA_commerce_to_roof_init();
	
}

javelin_hints()
{
	flag_wait( "obj_commerce_defend_javelin_given" );
	
	wait ( 5 );
	
	if ( flag( "player_has_killed_at_least_one_javelin_target" ) )
		return;
	
	while( !flag( "player_has_killed_at_least_one_javelin_target" ) )
	{
		wait( 20 );
		
		if ( player_has_javelin() )
			wait( 10 );
		
		if ( flag( "player_has_killed_at_least_one_javelin_target" ) )
			return;
			
		if ( !player_has_javelin() )
		{
			level.player thread display_hint( "javelin_pickup" );//it will endon this thread if not threaded
		}
		else if ( ( player_has_javelin() ) && ( javelin_equipped() ) )
		{
			level.player thread display_hint( "javelin_shoot" );//it will endon this thread if not threaded
		}
		else
		{
			level.player thread display_hint( "javelin_switch" );//it will endon this thread if not threaded
		}
	}
}


should_break_javelin_fire_hint()
{
	if ( flag( "player_has_killed_at_least_one_javelin_target" ) )
		return true;
	if ( !player_has_javelin() )
		return true;
	if ( !javelin_equipped() )
		return true;
	return maps\_javelin::PlayerJavelinAds();
}

should_break_javelin_switch_hint()
{
	if ( flag( "player_has_killed_at_least_one_javelin_target" ) )
		return true;
	return javelin_equipped();
}

should_break_javelin_pickup_hint()
{
	if ( flag( "player_has_killed_at_least_one_javelin_target" ) )
		return true;
		
	assert( isplayer( self ) );
	
	//if ( gettime() > level.heartbeat_timeout )
		//return true;
	
	if ( javelin_equipped() )
		return true;
	
	weapons = level.player getweaponslistprimaries();
	has_javelin = false;
	
	return player_has_javelin();
}

player_has_javelin()
{
	weapons = level.player GetWeaponsListAll();
	if ( !isdefined( weapons ) )
		return false;
	foreach ( weapon in weapons )
	{
		if ( IsSubStr( weapon, "javelin" ) )
			return true;
	}
	return false;
}

javelin_equipped()
{
	weapon = level.player getCurrentWeapon();
	if ( IsSubStr( weapon, "javelin" ) )
		return true;
	else
		return false;
}

music_crowsnest_armor()
{
	flag_wait( "obj_commerce_defend_javelin_given" );
	music_stop();
	wait( .1 );
	thread music_loop( "dcburning_ordnance_and_run", 140 );
}

backup_enemies_for_javelin_sequence()
{
	flag_wait( "obj_commerce_defend_javelin_given" );
	
	thread player_invulnerable_till_one_javelin_target_killed();
	
	wait( 1 );
	
	
	//spawn a few more tanks in case the player already went nuts during the javelin sequence
	if ( level.crowsarmor.size < 5 )
	{
		tanks_crowsnest_wave2 = spawn_vehicles_from_targetname_and_drive( "tanks_crowsnest_wave2" );
		array_thread( tanks_crowsnest_wave2,::tanks_crowsnest_wave2_think );
	}
	
//	wait( .5 );
//	
//	if ( level.crowsarmor.size < level.requiredJavTargets )
//	{
//		level.requiredJavTargets = level.crowsarmor.size;
//	}

}

player_invulnerable_till_one_javelin_target_killed()
{
	if ( level.gameskill > 1 )
		return;
	
	level.player enableinvulnerability();
	flag_wait( "player_has_killed_at_least_one_javelin_target" );
	level.player disableinvulnerability();
}

AAA_sequence_crowsnest_armor()
{
	flag_wait( "start_crow_armor_sequence" );
	
	barrett_trigger = getent( "barrett_trigger", "targetname" );
	barrett_trigger.origin = barrett_trigger.origin + ( 0, 0, -20 );
	barrett_trigger usetriggerrequirelookat();
	
	/*-----------------------
	ENEMY ARMOR ROLLS IN
	-------------------------*/	
	level.monument_target thread monument_target_think();
	helis_crowsnest = spawn_vehicles_from_targetname_and_drive( "helis_crowsnest" );
	helis_crowsnest_respawners = spawn_vehicles_from_targetname_and_drive( "helis_crowsnest_respawners" );
	array_thread( helis_crowsnest,:: helis_crowsnest_think );
	array_thread( helis_crowsnest_respawners,:: helis_crowsnest_think );
	
	/*-----------------------
	FRIENDLIES START SHOOTING AT DRONES, THEN STINGERS AT DUMMIES
	-------------------------*/	
	thread make_friendlies_shoot_stingers_and_javs();
	
	volume = getent( "perimeter_enemies", "targetname" );
	thread flag_set_when_volume_cleared_of_bad_guys( volume, "perimeter_enemies_have_retreated" );
	
	/*-----------------------
	FRIENDLIES CAN HIT LIVE TARGETS NOW
	-------------------------*/	
	wait( 25 );
	level.friendliesCanHelpCrowsnest = true;
	
	/*-----------------------
	ONLY 2 ARMOR/HELIS REMAINING
	-------------------------*/	
	flag_wait( "only_2_javelin_enemies_remaining" );

	/*-----------------------
	DONE
	-------------------------*/	
	flag_wait( "obj_commerce_defend_javelin_complete" );
	
	thread autosave_now();
	
	flag_set( "crowsnest_sequence_finished" );
	
	javelin_weapon_switch();
}

make_friendlies_shoot_stingers_and_javs()
{
	flag_wait( "perimeter_enemies_have_retreated" );
	thread friendlies_shoot_at_crows_drones_start();
	thread friendlies_shoot_stingers_start();
}

javelin_weapon_switch()
{
	/*-----------------------
	SWITCH OUT JAVELIN, GIVE EOTECH IF PLAYER DOES NOT HAVE
	-------------------------*/	
	if ( !player_has_javelin() )
		return;

	hasGren = false;
	tookWeapon = false;
	weaponList = level.player GetWeaponsListPrimaries();
	tookMainWeapon = false;

	foreach ( weapon in weaponList )
	{
		if ( issubstr( weapon, "avelin" ) )
		{
			tookWeapon = true;
			if ( issubstr( level.player GetCurrentWeapon(), "avelin" ) )
			{
				tookMainWeapon = true;
			    level.player DisableWeapons();
			    wait( 1.5 );
			}
			level.player takeweapon( weapon );
			continue;
		}

		if ( weapon == "m4m203_eotech" )
		{
			hasGren = true;
		}
	}

	if ( !tookWeapon )
	{
		return;
	}

    level.player EnableWeapons();

	if ( !hasGren )
	{
		level.player giveWeapon( "m4m203_eotech" );
	}

	if ( tookMainWeapon )
		level.player switchToWeapon( "m4m203_eotech" );
	

}






dialogue_crow_armor()
{
	flag_wait( "start_crow_armor_sequence" );
	
	//Overlord (HQ Radio) Hunter Two-One, recommend you clear outta there...I see a mass of foot-mobiles converging on your position�		
	radio_dialogue( "dcburn_hqr_clearout" );
	
	//Sgt. Macey	23	2	Negative negative. I have eyes on enemy armor and helicopters advancing on the evac site from the south and southwest! 	
	level.teamleader dialogue_execute( "dcburn_mcy_negative" );
	
	flag_set( "obj_commerce_defend_javelin_given" );
	
	//Ramirez, use some of this ordnance to take out the enemy vehicles! Move!
	level.teamleader dialogue_execute( "dcburn_mcy_useordnance" );

	thread crowsnest_nags_armor();
	thread evac_site_damage_nags_armor();
	
}

crowsnest_nags_armor()
{
	
	volume_crowsnest = getent( "volume_crowsnest", "targetname" );
	level.lasttimePlayerKilledEnemy = getTime();
	
	rocket_nag_number = 0;
	rocket_nag_number_max = 3;
	
	stay_in_nest_nag_number = 0;
	stay_in_nest_nag_number_max = 2;
	
	rocket_shoot_nag_number = 0;
	rocket_shoot_nag_number_max = 2;
	wait( .5 );
	
	while( !flag( "obj_commerce_defend_javelin_complete" ) )
	{
		//reset nag numbers
		if ( rocket_nag_number > rocket_nag_number_max )
			rocket_nag_number = 0;
		if ( stay_in_nest_nag_number > stay_in_nest_nag_number_max )
			stay_in_nest_nag_number = 0;
		if ( rocket_shoot_nag_number > rocket_shoot_nag_number_max )
			rocket_shoot_nag_number = 0;
			
		nag_wait();

		if ( flag( "obj_commerce_defend_javelin_complete" ) )
			break;
			
		if ( ( !level.player istouching( volume_crowsnest ) ) && ( flag( "can_talk" ) ) )
		{
			flag_clear( "can_talk" );
			level.teamleader dialogue_execute( "stay_in_nest_nag_" + stay_in_nest_nag_number );
			stay_in_nest_nag_number++;
			flag_set( "can_talk" );

		}
		else if( ( !level.player player_using_missile() ) && ( flag( "can_talk" ) ) )
		{
			flag_clear( "can_talk" );
			level.teamleader dialogue_execute( "rocket_nag_" + rocket_nag_number );
			rocket_nag_number++;
			flag_set( "can_talk" );
		}
		
		else if( ( !player_killing_crow_targets_at_a_good_pace() ) && ( flag( "can_talk" ) ) )
		{
			flag_clear( "can_talk" );
			level.teamleader dialogue_execute( "rocket_shoot_nag_" + rocket_shoot_nag_number );
			rocket_shoot_nag_number++;
			flag_set( "can_talk" );
		}
	}
}

monument_target_think()
{
	level.evacSitePercentDestroyed = 0;
	/*-----------------------
	USE DUMMY SCRIPT MODEL TO DETERMINE DAMAGE DONE BY ENEMY ARMOR, HELIS
	-------------------------*/	
	level endon( "mission failed" );
	level endon( "missionfailed" );
	self setcandamage( true );
	//determine barrel hitpoints based on difficulty
	self.hitpoints = undefined;
	switch( level.gameSkill )
	{
		case 0:// easy
			self.hitpoints = 5000;
			break;
		case 1:// regular
			self.hitpoints = 5000;
			break;
		case 2:// hardened
			self.hitpoints = 5000;
			break;
		case 3:// veteran
			self.hitpoints = 5000;
			break;
	}
	self.baseHitpoints = self.hitpoints;
	flag_set( "monument_dummy_target_setup" );
	while( !flag( "obj_commerce_defend_javelin_complete" ) )
	{
		self waittill( "damage", amount, attacker, enemy_org, impact_org, type );
		if ( !isdefined( attacker ) )
			continue;
		if ( !isdefined( amount ) )
			continue;
		if ( isplayer( attacker ) )
			continue;
		if ( ( isdefined( attacker.team ) ) && ( attacker.team != "axis" ) )
			continue;
		if ( !isdefined( type ) )
			continue;
		if ( type == "MOD_PROJECTILE" ) 
		{
			self reduce_monument_hitpoints( 100 );
			if ( self.hitpoints < 1 )
				break;
		}

		if ( type == "MOD_PROJECTILE_SPLASH" )
		{
			self reduce_monument_hitpoints( 50 );
			if ( self.hitpoints < 1 )
				break;
		}
	}
	if( !flag( "obj_commerce_defend_javelin_complete" ) )
		thread crowsnest_mission_fail_armor();
}

reduce_monument_hitpoints( hitpoints )
{
	self.hitpoints = self.hitpoints - hitpoints;
	fPercentRemaining = ( self.hitpoints / self.baseHitpoints ) * 100;
	fPercentRemaining = roundDecimalPlaces( fPercentRemaining, 0 );
	fPercentDestroyed = 100 - fPercentRemaining;
	level.evacSitePercentDestroyed = fPercentDestroyed;
	level notify( "monument_dummy_hit" );
	if ( getdvar( "dc_debug" ) == "1" )
		println( "evac damage = " + level.evacSitePercentDestroyed ); 
}

evac_site_damage_nags_armor()
{
	
	flag_wait( "monument_dummy_target_setup" );
	percentDestoyedAtLeast = 0;
	baseHitpoints = level.monument_target.hitpoints;

	
	while ( !flag( "obj_commerce_defend_javelin_complete" ) )
	{
		flag_wait( "can_talk" );
		level waittill( "monument_dummy_hit" );
		if ( level.evacSitePercentDestroyed == 100 )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	All callsigns, this is the Washington Monument evac site!!! Be advised, our situation is critical!!! We can't take much more of this!!! We need more time to get these civvies outta here!!!	
			radio_dialogue( "dcburn_evc_damage_fail" );
			flag_set( "can_talk" );
			return;
		}
		else if ( ( level.evacSitePercentDestroyed > 25 ) && ( level.evacSitePercentDestroyed < 50 ) && ( percentDestoyedAtLeast < 25 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	We're taking fire at the Washington Monument! We are down to 80 percent combat effectiveness! Request immediate sniper fire on targets west of the Monument, over!	
			radio_dialogue( "dcburn_evc_damage_00" );
			percentDestoyedAtLeast = 25;
			flag_set( "can_talk" );
		}
		else if ( ( level.evacSitePercentDestroyed > 50 ) && ( level.evacSitePercentDestroyed < 75 ) && ( percentDestoyedAtLeast < 50 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	All callsigns, be advised, enemies to the west are attempting a force-in-detail assault on the Washington Monument evac site! 	
			radio_dialogue( "dcburn_evc_damage_01" );
			percentDestoyedAtLeast = 50;
			flag_set( "can_talk" );
		}
		else if ( ( level.evacSitePercentDestroyed > 75 ) && ( level.evacSitePercentDestroyed < 90 ) && ( percentDestoyedAtLeast < 75 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	Washington Monument evac site to all callsigns!! Enemy fire from the west is threatening to destroy our position!! We can't take much more of this!!	
			radio_dialogue( "dcburn_evc_damage_02" );
			percentDestoyedAtLeast = 75;
			flag_set( "can_talk" );
		}
		else if ( ( level.evacSitePercentDestroyed > 90 ) && ( level.evacSitePercentDestroyed < 100 ) && ( percentDestoyedAtLeast < 90 ) )
		{
			flag_clear( "can_talk" );
			//Evac Site Radio Voice	Washington Monument evac site taking heavy fire!!! We're down to 50 percent combat effectiveness!!! We gotta get more fire support or this evac site is gonna fall!!! Over!!!	
			radio_dialogue( "dcburn_evc_damage_03" );
			percentDestoyedAtLeast = 90;
			flag_set( "can_talk" );
		}
	}
}

tanks_crowsnest_wave1_gopath( aTanks )
{
	foreach( tank in aTanks )
	{
		wait( 5 );
		thread gopath( tank );
	}
}

helis_crowsnest_think()
{
	self endon( "death" );
	self thread heli_crowsnest_respawn();
	self thread obj_commerce_defend_javelin_enemies_think();
	aPathNodes = vehicle_get_path_array();
	array_thread( aPathNodes, ::heli_pathnodes_think, self );
}

heli_crowsnest_respawn()
{
	if ( ( isdefined( self.script_noteworthy ) ) && ( issubstr( self.script_noteworthy, "crow_heli_respawner_" ) ) )
	{
		noteworthyName = self.script_noteworthy;
		self waittill( "death" );
		
		wait( 1 );
		spawner = getent( noteworthyName, "script_noteworthy" );
		assert( isdefined( spawner ) );
		if ( !flag( "obj_commerce_defend_javelin_complete" ) )
		{
			heli = vehicle_spawn( spawner );
			thread gopath( heli );
			heli thread helis_crowsnest_think();
		}
	}
}

heli_pathnodes_think( heli )
{
	heli endon( "death" );
	if ( !isdefined( self.script_noteworthy ) )
		return;
	eTarget = undefined;
	bGunTarget = undefined;
	switch( self.script_noteworthy )
	{
		case "target_nothing":
			eTarget = undefined;
			break;
		case "target_evac":
			eTarget = getent( "monument_target", "targetname" );
			bGunTarget = eTarget;
			break;
		case "target_crowsnest":
			eTarget = getent( "javelin_source_org", "targetname" );
			bGunTarget = level.player;
			break;
		default:
			return;
	}
	while( isdefined( heli ) )
	{
		self waittill( "trigger" );
		if ( !isdefined( eTarget ) )
			heli clearLookAtEnt();
		else
			heli SetLookAtEnt( eTarget );
		if( isdefined( bGunTarget ) )
		{
			heli thread vehicle_heli_fire_turret( bGunTarget );
		}
		else
			heli notify( "stop_firing_turret" );
	}
}

tanks_crowsnest_wave1_think()
{
	self endon( "death" );
	self ent_flag_init( "start_firing" );
	self  ent_flag_wait( "start_firing" );
	self thread tank_fire_at_evac_site();
	
	
	flag_wait( "obj_commerce_defend_javelin_given" );
	
	self thread obj_commerce_defend_javelin_enemies_think();
}

tanks_crowsnest_wave2_think()
{
	self endon( "death" );
	self ent_flag_init( "start_firing" );
	flag_wait( "obj_commerce_defend_javelin_given" );
	self thread obj_commerce_defend_javelin_enemies_think();
	self  ent_flag_wait( "start_firing" );
	self thread tank_fire_at_evac_site();

}

tank_fire_at_evac_site()
{
	self endon( "death" );
	self vehicle_turret_scan_off();
	self thread vehicle_tank_fire_turret( level.monument_target );
	while( isdefined( self ) )
	{
		self setTurretTargetEnt( level.monument_target );
		wait( randomfloatrange( 3, 6 ) );
		self fireWeapon();
		
	}
}


/****************************************************************************
    COMMERCE TO ROOFTOP
****************************************************************************/ 
AA_commerce_to_roof_init()
{
	thread AAA_sequence_get_to_roof();
	thread dialogue_get_to_roof();
	thread obj_rooftop();
	//thread music_to_roof();
	flag_wait( "player_approaching_outer_balcony" );
	thread AA_roof_init();
}

breach_double_door_swings_open()
{
	flag_wait( "roof_door_kicked" );
	door_to_roof_swing = getent( "door_to_roof_swing", "targetname" );
	door_to_roof_swing.startingpos = self.origin;
	door_to_roof_swing.startingangles = self.angles;
	door_to_roof_swing rotateyaw( -170, 0.5 );
	door_to_roof_swing moveto ( door_to_roof_swing.origin + ( 11, 0, 0), 0.1 );
	door_to_roof_swing connectpaths();
}

AI_breach_defenders_think()
{
	//friendlies_breach_defend keep player company till he goes up the stairs
	self endon( "death" );
	self thread try_to_magic_bullet_shield();
	self.neverEnableCQB = true;
	//self.fixednode = false;
	self.goalradius = 16;
	self.baseaccuracy = 1000;
	self.attackeraccuracy = 0;	//makes any AI attacking him have shitty accuracy
	
	flag_wait( "player_roof_stairs_00" );
	
	//player heading up stairs...kill these guys
	self.health = 1;
	self.baseaccuracy = .01;
	self.attackeraccuracy = 10;	//makes any AI attacking him have awesome accuracy
	self thread stop_magic_bullet_shield();
}

AAA_sequence_get_to_roof()
{
	/*-----------------------
	SETUP FRIENDLIES TO BREACH DOOR
	-------------------------*/	
	flag_wait( "only_2_javelin_enemies_remaining" );
	
	trigger_volume_breach_stairwell = getent( "trigger_volume_breach_stairwell", "targetname" );
	trigger_volume_breach_stairwell trigger_off();
	volume_breach_stairwell = getent( "volume_breach_stairwell", "targetname" );
	thread roof_breach_monitor( volume_breach_stairwell );
	aBreachers = array_spawn( getentarray( "crowsnest_breachers", "targetname" ) );
	aBreachDefenders = array_spawn( getentarray( "friendlies_breach_defend", "targetname" ) );
	array_thread( aBreachDefenders,::AI_breach_defenders_think );
	sBreachType = "shotgunhinges_breach_left";
	volume_breach_stairwell thread maps\_breach::breach_think( aBreachers, sBreachType );
	
	foreach ( guy in aBreachers )
	{
		guy.eNode = getnode( guy.target, "targetname" );
		guy thread AI_ignored_and_oblivious_on();
	}
	
	/*-----------------------
	PLAYER SQUAD HEADS TO ROOF DOOR
	-------------------------*/	
	flag_wait( "crowsnest_sequence_finished" );
	triggersEnable( "colornodes_start_to_roof", "script_noteworthy", true );
	trig_colornode = getent( "colornodes_start_to_roof", "script_noteworthy" );
	trig_colornode notify( "trigger", level.player );
	level.squad = remove_dead_from_array( level.squad );

	thread breach_double_door_swings_open();
	trigger_volume_breach_stairwell trigger_on();
	
	delaythread( 3,::spawn_trigger_dummy, "dummy_spawner_roof_wave_01" );
	
	/*-----------------------
	ENEMIES START TO OVERRUN, DOOR BREACHED
	-------------------------*/	
	flag_wait( "obj_rooftop_given" );
	

	if ( ( isdefined( level.crowsArmor ) ) && ( level.crowsArmor.size > 0 ) )
		array_thread( level.crowsArmor,::crows_armor_cleanup );
	
	//thread friendly_speed_adjustment_on();
	friendlies = getaiarray( "allies" );
	array_thread( friendlies,::cqb_walk, "off" );
	foreach( guy in friendlies )
		guy.neverEnableCQB = true;
	
	//wait( 2 );
	
	
	flag_wait( "roof_breach_complete" );
	
	/*-----------------------
	BREACHERS COVER PLAYER EXIT
	-------------------------*/	
	foreach ( guy in aBreachers )
	{
		guy setgoalnode( guy.eNode );
		//guy.fixednode = true;
		guy.goalradius = 64;
	}

	/*-----------------------
	SQUAD HEADS TO THE ROOF
	-------------------------*/	
	triggersEnable( "colornodes_to_roof", "script_noteworthy", true );

	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );	//ai won't stop in front of player line of fire
	foreach( guy in level.squad )
	{
		if ( !isalive( guy ) )
			continue;
		//guy.fixednode = true; 
		//guy.ignoreall = true;
		guy.a.disablePain = true;
		guy.ignoresuppression = true;
		guy.disableDamageShieldPain = true;
		guy.grenadeawareness = 0;
		guy.goalradius = 32;
		
		//make Dunn and Macey have better accuracy than attackers
		if ( ( guy == level.teamleader ) || ( guy == level.friendly02 ) )
		{
			self.attackeraccuracy = .01;	//makes any AI attacking him miss a lot
			self.baseaccuracy = 1000;	//excellent accuracy
		}
		
	}

	wait( 2 );
	array_thread( aBreachers, ::AI_roof_escape_redshirts_think );
	foreach ( guy in aBreachers )
	{
		guy thread AI_ignored_and_oblivious_off();
	}
	
	



	/*-----------------------
	MORE ENEMIES
	-------------------------*/	
	spawn_trigger_dummy( "dummy_spawner_roof_wave_02" );
	
	/*-----------------------
	MAIN SQUAD HEADS TO THE ROOF IF PLAYER NOT ON HIS WAY
	-------------------------*/	
	if ( !flag( "player_roof_stairs_00" ) )
		thread dummy_trigger( "dummy_colornodes_to_roof" );
		
		
	/*-----------------------
	CLEANUP
	-------------------------*/	
	flag_wait( "player_roof_stairs_01" );
	if ( ( isdefined( level.evacSiteEnemies ) ) && ( level.evacSiteEnemies.size > 0 ) )
		array_thread( level.evacSiteEnemies,:: AI_delete );
	thread drone_flood_stop( "hostiles_drones_comm_south" );
	thread vehicle_delete_all();
	thread AI_drone_cleanup( "all", 1024, true );

	flag_wait( "player_roof_stairs_02" );
	jets_tenches_01 = spawn_vehicles_from_targetname_and_drive( "jets_tenches_01" );

	/*-----------------------
	TRY TO TELEPORT KEY FRIENDLIES TO ROOF
	-------------------------*/
	eNodeLeader = getnode( "node_roof_leader", "targetname" );
	eNodeFriendly02 = getnode( "node_roof_friendly02", "targetname" );
	level.teamleader thread try_to_teleport_friendlies_to_roof( eNodeLeader );
	level.friendly02 thread try_to_teleport_friendlies_to_roof( eNodeFriendly02 );
	
	
	/*-----------------------
	ENEMY JETS DROPPING CLUSTER BOMBS
	-------------------------*/	
	flag_wait( "player_top_floor_commerce" );
	jets_tenches_02 = spawn_vehicles_from_targetname_and_drive( "jets_tenches_02" );
	
	flag_wait( "player_outer_balcony_top_commerce" );
	eHeli = spawn_vehicle_from_targetname( "heli_deck2" );
	thread maps\_vehicle::gopath( eHeli );
	//eHeli.dontWaitForPathEnd = true;
	eHeli thread heli_balcony_think();
	//eHeli = maps\_attack_heli::begin_attack_heli_behavior( eHeli );
	
	flag_wait( "player_at_commerce_rooftop" );

	if ( isdefined( eHeli ) )
		eHeli delete();
		
	flag_set( "obj_rooftop_complete" );
	
	
	thread kill_timer();
	thread autosave_by_name( "rooftop" );
	//eHeli Vehicle_SetSpeed( 10 );
	
	//music_stop( 5 );
}

heli_balcony_think()
{
	self endon( "death" );
	self SetLookAtEnt( level.player );
	flag_wait( "balcony_heli_raised_up" );
	self ClearLookAtEnt();
	flag_wait( "player_at_commerce_rooftop" );
	if ( isdefined( self ) )
		self delete();
}

crows_armor_cleanup()
{
	self endon( "death" );
	flag_wait( "player_roof_stairs_01" );	
	if( isdefined( self ) )
		self vehicle_delete();
}

AI_roof_escape_redshirts_think()
{
	self endon( "death" );
	self.neverEnableCQB = true;
	self.health = 1;
	//self.fixednode = false;
	self.goalradius = 32;
	self.baseaccuracy = .01;
//	while( isalive( self ) )
//	{
//		wait( 1 );
//		self.ignoreall = true;
//		wait( 1 );
//		self.ignoreall = false;
//	}
}

dummy_trigger( dummyName )
{
	dummy = getent( dummyName, "targetname" );
	trigger = getEnt( dummy.script_LinkTo, "script_linkname" );
	if ( isdefined( trigger ) )
		trigger notify( "trigger", level.player );
}

roof_breach_monitor( eVoloume )
{
	eVoloume waittill( "breach_complete" );
	flag_set( "roof_breach_complete" );
}

//music_to_roof()
//{
//	flag_wait( "roof_door_kicked" );
//	
//	MusicPlay( "dcburning_stairway_escape_header" );
//	wait( 40.978 );
//	music_stop();
//	thread music_loop( "dcburning_stairway_escape_loop", 40.96 );
//
//}

dialogue_get_to_roof()
{
	flag_wait( "crowsnest_sequence_finished" );
	
	//Overlord (HQ Radio) Outstanding work, Hunter Two-One, all transports are away. Now get your ass to the roof ASAP...you are in danger of being overrun.	
	radio_dialogue( "dcburn_hqr_roofasap" );
	
	flag_set( "obj_rooftop_given" );
	
	//Sgt. Macey	Roger that, we're headed to the rooftop! Everyone, move out!		
	level.teamleader dialogue_execute( "dcburn_mcy_rooftop" );
	
	thread escape_timer( 90 );
	
	//Overlord (HQ Radio)	32	7	Atlas Two-Six is now away. All remaining evacuation units, execute level three evacuation protocols. Urgent surgicals only.	
	radio_dialogue( "dcburn_hqr_urgentsurgicals" );
	
	//nag player to get to breach door
	while ( !flag( "roof_breach_complete" ) )
	{
		//Sgt. Macey	Get to the roof and RV with the SEAL Team! Move! Move!		
		level.teamleader dialogue_execute( "dcburn_mcy_rvwithseals" );
		
		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "roof_breach_complete" ) )
			break;
			
		//Sgt. Macey	26	3	Keep moving! This sector's gonna be crawlin' with hostiles! We gotta go, NOW!!
		level.teamleader dialogue_execute( "dcburn_mcy_crawlin" );

		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "roof_breach_complete" ) )
			break;
			
		//Sgt. Macey	Ramirez! Let's move out!	
		level.teamleader dialogue_execute( "dcburn_mcy_letsmoveout" );

		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "roof_breach_complete" ) )
			break;
			
		//Sgt. Macey	Ramirez! Move your ass! We've gotta get to the roof, NOW!	
		level.teamleader dialogue_execute( "dcburn_mcy_gettoroofnow" );

		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "roof_breach_complete" ) )
			break;
			
		//Sgt. Macey	Ramirez, let's go! Hostiles are overrunning this position!	
		level.teamleader dialogue_execute( "dcburn_mcy_overrunningpos" );
		
		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "roof_breach_complete" ) )
			break;
		
	}

	//**Ranger 5	32	8	We just lost Atlas Two-Three to triple-A from the Capitol Building!!!	
	radio_dialogue( "dcburn_ar5_triplea" );
	
	//**Ranger 2	32	9	Get those civvies back in their seats!!!!	
	radio_dialogue( "dcburn_ar2_backinseats" );
	
	//nag player to get up stairs after roof breached
	while ( !flag( "player_roof_stairs_00" ) )
	{
		//Sgt. Macey	26	5	We're outnumbered - we need to get to the roof ASAP!!!! Go! Go! Go!	
		level.teamleader dialogue_execute( "dcburn_mcy_outnumbered" );	
		
		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "player_roof_stairs_00" ) )
			break;
			
		//Sgt. Macey	Ramirez! Up the stairs! Let's go!	
		level.teamleader dialogue_execute( "dcburn_mcy_upthestairsgo" );
		
		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "player_roof_stairs_00" ) )
			break;
		
		//Sgt. Macey	Ramirez! Get up the stairs to the roof ASAP�our evac choppers aren't going to wait all day!	
		level.teamleader dialogue_execute( "dcburn_mcy_waitallday" );
		
		wait( randomfloatrange( 8, 12 ) );
		if ( flag( "player_roof_stairs_00" ) )
			break;
		
		//Sgt. Macey	We're getting overrun! Everyone to the roof! Now!	
		level.teamleader dialogue_execute( "dcburn_mcy_gettingoverrun" );

	}
	
	
	wait( 2 );
	//Sgt. Foley   We're out of time! Go!	
	level.teamleader dialogue_execute( "dcburn_mcy_outoftimego" );
	wait( 2 );
	//Cpl. Dunn		Hostiles closing in!!!	
	level.friendly02 dialogue_execute( "dcburn_cpd_closingin" );
	
	flag_wait( "player_roof_stairs_02" );
	//Sgt. Macey: Move up! Go! Go!
	level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_00" );

	flavorbursts_off( "allies" );
	//Ranger 3	32	5	I've got a major hydraulic leak! We're barely gonna make it over the MSR! We gotta touch down - we gotta (static)!	
	level.player play_sound_on_entity( "dcburn_ar3_gottatouchdown" );
	flavorbursts_on( "allies" );
	
	flag_wait( "player_outer_balcony_top_commerce" );
	
	while( !flag( "player_headed_to_roof" ) )
	{
		//Sgt. Macey: Push forward! Move! Move!
		level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_02" );
		wait( 2 );
		//Sgt. Foley   There's no time! Keep moving!
		level.teamleader dialogue_execute( "dcburn_mcy_notime" );
		
		if ( flag( "player_headed_to_roof" ) )
			break;
			
		wait( 2 );

		if ( flag( "player_headed_to_roof" ) )
			break;

		//Sgt. Foley   We have to keep moving! Go! Go! Go!	
		level.teamleader dialogue_execute( "dcburn_mcy_keepmoving" );
		wait( 2 );
		
	}
	
	flag_wait( "player_headed_to_roof" );
	radio_dialogue( "dcburn_bhp_whatsyourstatus" );
	//Black Hawk Pilot	Hunter, this is Dagger Two-One. We are in position at the LZ on the rooftop, what's your status?	

	//Sgt. Macey	We're on our way! Hostiles following close behind!	
	level.teamleader dialogue_execute( "dcburn_mcy_hostilesclose" );

	while( !flag( "player_at_commerce_rooftop" ) )
	{
		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;

		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;
			
		//Sgt. Foley   We're getting overrun! Move! Move! Move!	
		level.teamleader dialogue_execute( "dcburn_mcy_overrun" );

		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;

		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;
		//Sgt. Macey: Move up! Go! Go!
		level.teamleader dialogue_execute( "dcburn_mcy_lobby_move_nag_00" );
		
		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;

		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;
			
		//Sgt. Foley   We're out of time! Go!	
		level.teamleader dialogue_execute( "dcburn_mcy_outoftimego" );
		
		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;

		wait( 1 );

		if ( flag( "player_at_commerce_rooftop" ) )
			break;
		
		//Sgt. Macey	26	5	We're outnumbered - we need to get to the roof ASAP!!!! Go! Go! Go!	
		level.teamleader dialogue_execute( "dcburn_mcy_outnumbered" );	
		
	}
	flag_set( "rooftop_run_dialogue_finished" );
}

/****************************************************************************
    ROOF/HELI RIDE
****************************************************************************/ 
AA_roof_init()
{
	thread obj_heli_mount();
	thread dialogue_roof();
	thread music_heli_ride();
	thread heli_at4_sequence();
	thread AAA_sequence_heli_ride();
	thread littlebird_wingman_02_think();
	thread littlebird_wingman_armed_think();
	thread obj_heli_ride();
	
	flag_wait( "player_heli_18" );
	AA_heli_ride2();
}

music_heli_ride()
{
	flag_wait( "roof_heli_about_to_be_owned" );
	flag_wait_or_timeout( "roof_heli_owned", 1.65 );
	MusicPlayWrapper( "dcburning_heli_ride3" );
}

dialogue_roof()
{
	flag_wait( "player_at_commerce_rooftop" );
	
	flag_wait( "blackhawk_landed" );
	//wait( 3 );
	
	flag_set( "obj_heli_mount_given" );
	thread dialogue_nag_minigun();
	
	flag_wait( "player_getting_on_minigun" );

	level.player SetActionSlot( 1, "" );
	level.player NightVisionForceOff();

	while( !flag( "can_talk" ) )
		wait( .5 );
		
	//Sgt. Macey Overlord, we've linked up with the SEALs on the rooftop and are heading out. Interrogative - has the bunker been evacuated, over?	
	radio_dialogue( "dcburn_mcy_bunkerevac" );
	
	//Overlord (HQ Radio)	27	2	Negative Two-One, they're still pinned down by infantry and light armor. Doesn't look good from here, over.		
	radio_dialogue( "dcburn_hqr_stillpinned" );
	
	//Sgt. Macey	27	3	Copy Overlord, we'll do what we can from the air, out.	
	radio_dialogue( "dcburn_mcy_fromtheair" );	
	
	//wait( 4 );
	
	//Sgt. Macey	28	1	This is Hunter Two-One Actual. We have eyes on multiple hostile victors and foot mobiles....request permission to engage, over.	
	//radio_dialogue( "dcburn_mcy_permission" );	
	
	//Overlord (HQ Radio)	28	2	Your call, Two-One. Outlaw is pinned down at the bunkers. You're cleared hot along the MSR, over.		
	//radio_dialogue( "dcburn_hqr_clearedhot" );
	
	flag_set( "obj_heli_ride_given" );
	thread autosave_now( true );
	
	//Overlord (HQ Radio)	32	1	First wave of civilian transports is away. Reaver Two, proceed with second stage evacation. Litter urgent personnel only.	
	thread radio_dialogue( "dcburn_hqr_firstwave" );	
	
	//Sgt. Macey	28	3	Squad, we're engaging all targets of opportunity to buy Outlaw some time to get out! This may be a one way trip. Hooah?		
	//radio_dialogue( "dcburn_mcy_onewaytrip" );

	//Cpl. Dunn Hooah. Rangers lead the way!
	//radio_dialogue( "dcburn_cpd_leadtheway" );

	//Sgt. Macey All the way.		
	//radio_dialogue( "dcburn_mcy_alltheway" );
	
	//SEAL Team Leader  We're with you, Two-One. Let's do this.		
	//radio_dialogue( "dcburn_sll_withyou" );
	
	flag_wait( "player_heli_05" );

	//Little Bird Pilot 1	Dagger Two, SAM launch! Break left break left!!!	
	radio_dialogue_overlap( "dcburn_lbp1_breakleftbreakleft" );
	
	flag_wait( "player_heli_07" );
	
	//Sgt. Foley   Overlord, Dagger Two-Two is hit and going down!
	radio_dialogue( "dcburn_mcy_hitgoingdown" );
	
	flag_wait( "player_heli_09" );
	wait( 1 );
	//Black Hawk Pilot	RPG teams in sight...I want you to pull that trigger till they don't get up.	
	radio_dialogue( "dcburn_bhp_dontgetup" );	
	
	//Overlord (HQ Radio)	32	3	Atlas Two-Three, Two-Four and Two-Five are all away. Ground units at LZ 4, fall back now.
	radio_dialogue( "dcburn_hqr_fallbacknow" );	
	
	
	//Little Bird Pilot 1	Ramirez, we got foot mobiles and light armor down there. You're cleared hot.
	//radio_dialogue( "dcburn_lbp1_clearedhot" );	
	
	flag_set( "player_has_used_minigun" );	//**TODO, check to see if player has used gun to blow shit up yet
	if ( !flag( "player_has_used_minigun" ) )
	{
		//Sgt. Macey	Ramirez, spin her up and let her rip!!!	dcburn_mcy_spinherup
		radio_dialogue( "dcburn_mcy_spinherup" );	
	}
	
	flag_wait( "player_heli_10c" );
	//Little Bird Pilot 1	Enemy gunship lifting off at your twelve o'clock.	
	radio_dialogue( "dcburn_lbp1_gunshipliftingoff" );	

	//Ranger 2	32	4	This is Atlas Two-Five at LZ 1! Engines are at 30 percent! I can't carry any more people! We're gonna have to leave some of them behind!!	
	radio_dialogue( "dcburn_ar2_leavebehind" );
		
	//Little Bird Pilot 1	Light armor rolling in.	
	//radio_dialogue( "dcburn_lbp1_armorrollingin" );	
	
	flag_wait( "player_heli_14" );
	//Evac Site Radio Voice	Dagger Two, the evac site is taking fire from the main road!	
	radio_dialogue( "dcburn_evc_mainroad" );	
	
	//Little Bird Pilot 1	Copy that, we're on it.	
	//radio_dialogue( "dcburn_lbp1_wereonit" );	

	//**Overlord (HQ Radio)	32	10	Overlord to all units, evacuation order Irene, I repeat, evacuation order Irene. Everyone get the hell outta there.	
	radio_dialogue( "dcburn_hqr_orderirene" );
	
	//Ranger 1	32	11	Get your men on that transport now, WE ARE LEAVING!!!	
	radio_dialogue( "dcburn_ar1_weareleaving" );	
	
	//Little Bird Pilot 1	Foot mobiles...take em out.	
	//radio_dialogue( "dcburn_lbp1_footmobiles" );	
	
	//Ranger 4	32	6	This is Atlas One-One, civilian transport going down two klicks west of Dupont Circle! We are- (static) (screaming women and children on board in background)	
	radio_dialogue( "dcburn_ar4_wearegoingdown" );	
}

dialogue_nag_minigun()
{
	flag_wait( "rooftop_run_dialogue_finished" );
	
	flag_set( "can_talk" );
	
	while( !flag( "player_getting_on_minigun" ) )
	{
		//Sgt. Macey We've gotta move! Ramirez, get on that minigun!
		flag_clear( "can_talk" );
		level.teamleader dialogue_execute( "dcburn_mcy_moveminigun" );
		flag_set( "can_talk" );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		wait( 30 );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
		
		flag_clear( "can_talk" );
		//Sgt. Macey Ramirez, get on the minigun!!!	
		level.teamleader dialogue_execute( "dcburn_mcy_getonminigun" );
		flag_set( "can_talk" );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		wait( 30 );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
		
		flag_clear( "can_talk" );
		//Sgt. Macey	Ramirez!!! Get in the chopper!!!	
		level.teamleader dialogue_execute( "dcburn_mcy_getinchopper" );
		flag_set( "can_talk" );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		wait( 30 );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		flag_clear( "can_talk" );
		//Sgt. Macey	Ramirez!!! We are way outnumbered! Get on board!! Move!!!	
		level.teamleader dialogue_execute( "dcburn_mcy_wayoutnumbered" );
		flag_set( "can_talk" );
		
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		wait( 30 );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		flag_clear( "can_talk" );
		//Sgt. Macey	Ramirez!! Forget about it! We got a minigun on board! Get on the helicopter! Let's go!!!	
		level.teamleader dialogue_execute( "dcburn_mcy_forgetaboutit" );
		flag_set( "can_talk" );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		wait( 30 );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
		
		flag_clear( "can_talk" );
		//Sgt. Macey	Ramirez!!! You're polishing brass on the Titanic! Get on the minigun, let's go!!!	
		level.teamleader dialogue_execute( "dcburn_mcy_brassontitanic" );
		flag_set( "can_talk" );
		
		if( flag( "player_getting_on_minigun" ) )
			break;
			
		wait( 30 );
		
		if( flag( "player_getting_on_minigun" ) )
			break;

	}
}

AI_awesome_accuracy_untill_flag( sFlag )
{
	self endon( "death" );
	if( !isdefined( self ) )
		return;
	self.old_baseaccuracy = self.baseaccuracy;
	self.baseaccuracy = 1000;
	
	flag_wait( sFlag );
	
	if( isdefined( self ) )
		self.baseaccuracy = self.old_baseaccuracy;
}

AI_roof_defenders_think()
{
	//rooftop_defender defend chokepoint till player on heli
	self endon( "death" );
	self thread try_to_magic_bullet_shield();
	self.neverEnableCQB = true;
	//self.fixednode = false;
	self.goalradius = 16;
	self.baseaccuracy = 1000;
	self.attackeraccuracy = 0;	//makes any AI attacking him have shitty accuracy
	
	flag_wait( "player_getting_on_minigun" );
	
	//player on minigun...this guy gets overrun
	self.health = 1;
	self.baseaccuracy = .01;
	self.attackeraccuracy = 10;	//makes any AI attacking him have awesome accuracy
	self thread stop_magic_bullet_shield();
}

AAA_sequence_heli_ride()
{
	flag_wait( "player_headed_to_roof" );

	/*-----------------------
	BLACKHAWK RIDER TO LEAD PLAYER
	-------------------------*/
	level.AIdeleteExcluders = [];
	spawner = getent( "rooftop_helirider", "targetname" );
	rooftop_helirider = spawner spawn_ai();
	if ( isdefined( rooftop_helirider ) )
	{
		rooftop_helirider thread AI_rooftop_helirider_think();
	}
	
	/*-----------------------
	INVINCIBLE DUDE THAT WILL GUARD ROOFTOP CHOKEPOINT
	-------------------------*/
	spawner = getent( "rooftop_defender", "targetname" );
	defender = spawner spawn_ai();
	if ( isdefined( defender ) )
		defender thread AI_roof_defenders_think();
	
	turret2 = getent( "turret2", "targetname" );
	if ( isdefined( turret2 ) )
		turret2 delete();
	
	//thread autosave_by_name( "headed_to_roof" );
	triggersEnable( "colornodes_roof", "script_noteworthy", true );

	/*-----------------------
	TRENCH AMBIENT - FRIENDLY DRONES
	-------------------------*/
	allied_drones_heliride_01 = getentarray( "allied_drones_heliride_01", "targetname" );
	allied_drones_heliride_02 = getentarray( "allied_drones_heliride_02", "targetname" );
	allied_drones_heliride_03 = getentarray( "allied_drones_heliride_03", "targetname" );
	allied_drones_heliride_03 = getentarray( "allied_drones_heliride_04", "targetname" );
	thread drone_flood_start( allied_drones_heliride_01, "allied_drones_heliride_01" );
	thread drone_flood_start( allied_drones_heliride_02, "allied_drones_heliride_02" );
	thread drone_flood_start( allied_drones_heliride_03, "allied_drones_heliride_03" );
	thread drone_flood_start( allied_drones_heliride_03, "allied_drones_heliride_04" );
	
	/*-----------------------
	SPAWN AND SETUP PLAYER BLACKHAWK
	-------------------------*/
	player_blackhawk_setup();
	level.blackhawk Vehicle_SetSpeed( 5 );
	heli_roof_approach_01_end = getent( "heli_roof_approach_01_end", "targetname" );
	level.blackhawk SetLookAtEnt( heli_roof_approach_01_end );
	//level.blackhawk.animname = "blackhawk";
	//level.blackhawk assign_animtree();

	/*-----------------------
	PLAYER BLACKHAWK LANDS
	-------------------------*/	
	flag_wait( "roof_littlebird_lifted_off" );
	level.blackhawk clearlookatent();
	heli_roof_approach_01 = getent( "heli_roof_approach_01", "targetname" );
	level.blackhawk thread vehicle_paths( heli_roof_approach_01 );
	level.blackhawk Vehicle_SetSpeed( 100 );
	level.blackhawk thread vehicle_heli_land( getent( "heli_roof_land_01", "script_noteworthy" ) );
	level.blackhawk waittill( "landed" );
	flag_set( "blackhawk_landed" );
	
	trigger_origin = level.blackhawk gettagorigin( "tag_player" );
	trigger_radius = 160;
	trigger_height = 100;
	trigger_spawnflags = 0;// player only
	triggerApproach = spawn( "trigger_radius", trigger_origin, trigger_spawnflags, trigger_radius, trigger_height );
	thread team_leader_gets_on_blackhawk( triggerApproach );
	

	/*-----------------------
	WAIT FOR PLAYER TO APPROACH GUN...MUST BE FACING CHOPPER
	-------------------------*/
	trigger_origin = level.blackhawk gettagorigin( "tag_player" );
	trigger_radius = 40;
	trigger_height = 100;
	trigger_spawnflags = 0;// player only
	level.blackhawk.trigger = spawn( "trigger_radius", trigger_origin, trigger_spawnflags, trigger_radius, trigger_height );
	
	balackHawkOrigin = level.blackhawk gettagorigin( "TAG_ORIGIN" );
	while( true )
	{
		level.blackhawk.trigger waittill( "trigger" );
		if ( within_fov( level.player geteye(), level.player getPlayerAngles(), balackHawkOrigin, level.cosine[ "90" ] ) )
			break;
			
	}
	
	flag_set( "player_getting_on_minigun" );
	
	if ( getdvarint( "r_dcburning_culldist" ) == 1 )
	{
		setculldist( 20000 );
	}
		
	flag_set( "obj_heli_mount_complete" );
	
	thread player_blackhawk_health_tweaks();
	
	maps\_friendlyfire::TurnOff();
	level.disable_destructible_bad_places = true; //disables all badplaces for destructibles so AI won't wig out while player is lighting shit up
	
	/*-----------------------
	KILLSPAWNERS
	-------------------------*/	
	killSpawner( 7 );
	killSpawner( 8 );
	killSpawner( 10 );

	//level.player enableinvulnerability();
	volume_roof = getent( "volume_roof", "targetname" );
	aAI_to_delete = volume_roof get_ai_touching_volume( "axis" );
	array_thread( aAI_to_delete, ::AI_delete );
	delaythread( 1.5,::delete_squad );

	/*-----------------------
	SEAKNIGHTS FLY FROM EVAC SITE
	-------------------------*/	
	roof_seaknight_01 = getent( "roof_seaknight_01", "targetname" );
	roof_seaknight_02 = getent( "roof_seaknight_02", "targetname" );
	roof_seaknight_01 notify( "spawn" );
	roof_seaknight_02 notify( "spawn" );
	
	roof_seaknight_01 thread notify_delay( "play_anim", 1 );
	roof_seaknight_02 thread notify_delay( "play_anim", 1 );
	
	/*-----------------------
	PLAYER LERPED ONTO MINIGUN
	-------------------------*/
	player_lerped_onto_minigun();
	music_stop( 5 );
	flag_wait( "roof_heli_about_to_be_owned" );
	flag_set( "player_heli_ready_to_take_off" );
	
	thread autosave_by_name( "heli_ride_01" );
	/*-----------------------
	WW2 MEMORIAL HELIS SPAWNED
	-------------------------*/
	ww2_heli = spawn_vehicle_from_targetname( "ww2_heli" );
	//ww2_trucks = spawn_vehicles_from_targetname( "ww2_trucks" );


	/*-----------------------
	START HELI RIDE
	-------------------------*/
	path_player_heli = getstruct( "path_player_heli", "targetname" );
	level.blackhawk vehicle_liftoff( 76 );
	level.blackhawk player_blackhawk_default_params();
	level.blackhawk thread player_blackhawk_default_params();
	level.blackhawk thread vehicle_paths( path_player_heli );

	/*-----------------------
	TRENCH AMBIENT - ABRAMS DESTROYED
	-------------------------*/
	abrams_street = getent( "abrams_street", "targetname" );
	abrams_street delete();
	m1a1_heliride_01 = spawn_vehicle_from_targetname_and_drive( "m1a1_heliride_01" );
	m1a1_heliride_02 = spawn_vehicle_from_targetname_and_drive( "m1a1_heliride_02" );
	javelin_source_org = getent( m1a1_heliride_01.script_linkto, "script_linkname" );
	newMissile = MagicBullet( "javelin_dcburn", javelin_source_org.origin, m1a1_heliride_01.origin );
	newMissile thread javelin_earthquake();	//custom function to ensure an earthquake on impact
	newMissile Missile_SetTargetEnt( m1a1_heliride_01 ); 
	newMissile Missile_SetFlightmodeTop();	//Code added this command so we could make the Javelin do an arc instead of a straight line
	
	humvee_heliride_01 = spawn_vehicle_from_targetname( "humvee_heliride_01" );
	
	/*-----------------------
	FLYING OVER TRENCHES AND WASH MONUMNET
	-------------------------*/
	flag_wait( "player_heli_02" );
	level.blackhawk Vehicle_SetSpeed( 75 );
	level.littlebird_wingman_02 vehicle_setSpeed( 70 );

	array_thread( level.effects_commerce, ::pauseEffect );
	array_thread( level.effects_bunker, ::pauseEffect );
	
	/*-----------------------
	ARMED LITTLEBIRD SWITCHES PATH
	-------------------------*/
	eNode = getstruct( "helipath_to_ww2_littlebird_wingman_armed", "targetname" );
	sSpawnerTargetname = "littlebird_wingman_armed";
	level.littlebird_wingman_armed = level.littlebird_wingman_armed heli_teleport_to_newpath( sSpawnerTargetname, eNode );
	level.littlebird_wingman_armed Vehicle_SetSpeed( 100 );
	
	/*-----------------------
	WINGMEN LITTLEBIRDS SWITCH PATHS
	-------------------------*/
	level.littlebird_wingman_02 vehicle_delete();
	level.littlebird_wingman_02 = spawn_vehicle_from_targetname_and_drive( "littlebird_wingman_02_drone_roof" );
	
	eNode = getstruct( "helipath_to_ww2_littlebird_wingman_01", "targetname" );
	sSpawnerTargetname = "littlebird_wingman_01";
	level.littlebird_wingman_01 = level.littlebird_wingman_01 heli_teleport_to_newpath( sSpawnerTargetname, eNode );
	level.littlebird_wingman_01 Vehicle_SetSpeed( 55 );
	
	/*-----------------------
	AXIS DRONES NEAR WW2
	-------------------------*/
	axis_ww2_drones_01 = getentarray( "axis_ww2_drones_01", "targetname" );
	axis_ww2_drones_02 = getentarray( "axis_ww2_drones_02", "targetname" );
	axis_ww2_drones_03 = getentarray( "axis_ww2_drones_03", "targetname" );
	axis_ww2_drones_04 = getentarray( "axis_ww2_drones_04", "targetname" );
	thread drone_flood_start( axis_ww2_drones_01, "axis_ww2_drones_01" );
	thread drone_flood_start( axis_ww2_drones_02, "axis_ww2_drones_02" );
	thread drone_flood_start( axis_ww2_drones_03, "axis_ww2_drones_03" );
	thread drone_flood_start( axis_ww2_drones_04, "axis_ww2_drones_04" );

	/*-----------------------
	DELETE ALL AI
	-------------------------*/
	waittillframeend;
	aAI = getaiarray();
	assertex( level.littlebird_wingman_02.riders.size > 0, "the riders for level.littlebird_wingman_02 are not in level.littlebird_wingman_02.riders" );
	excluders = level.littlebird_wingman_02.riders;
	array_thread( aAI,::AI_delete, excluders );
	
	/*-----------------------
	SPAWN WW2 ENEMIES
	-------------------------*/
	activate_trigger( "spawner_ww2_guys", "targetname", level.player );
	spawn_trigger_dummy( "dummy_spawner_ww2_street_guys" );	//flood spawner of guys near cars

	/*-----------------------
	MORTARS/ARTY
	-------------------------*/
	level.noMaxMortarDist = true;
	level.playerMortarFovOffset = ( 0, 40, 0 );
	level._effect[ "mortar" ][ "dirt" ]					 = loadfx( "explosions/artilleryExp_dirt_brown_2" ); //swap out trenches mortar effect with bigger one
	delaythread( 3, maps\_mortar::bog_style_mortar_on, 2 );		//same trenches mortars, but with bigger explosions
	
	flag_wait( "player_heli_03a" );
	newMissile = MagicBullet( "javelin_dcburn", javelin_source_org.origin, humvee_heliride_01.origin );
	newMissile thread javelin_earthquake();	//custom function to ensure an earthquake on impact
	newMissile Missile_SetTargetEnt( humvee_heliride_01 ); 
	newMissile Missile_SetFlightmodeTop();	//Code added this command so we could make the Javelin do an arc instead of a straight line
	
	sam_launch_ww2 = getstruct( "sam_launch_ww2", "targetname" );
	delaythread( 1.5,::sam_launch, 8, sam_launch_ww2, level.littlebird_wingman_02 );
	
	//flag_wait( "player_heli_04" );
	

	
	/*-----------------------
	FLYING PAST MONUMENT
	-------------------------*/
	flag_wait( "player_heli_05" );
	level.blackhawk Vehicle_SetSpeed( 90 );
	thread gopath( humvee_heliride_01 );
	level.littlebird_wingman_01 Vehicle_SetSpeed( 100 );
	level.littlebird_wingman_02 Vehicle_SetSpeed( 100 );

	level.littlebird_wingman_armed Vehicle_SetSpeed( 150 );
	
	/*-----------------------
	LITTLEBIRD SHOT DOWN
	-------------------------*/
	javelin_littlebird_monument = getstruct( "javelin_littlebird_monument", "targetname" );
	newMissile2 = MagicBullet( "javelin_dcburn", javelin_littlebird_monument.origin, level.littlebird_wingman_02.origin );
	newMissile2 Missile_SetTargetEnt( level.littlebird_wingman_02 ); 
	littlebird_monument_crash = getstruct( "littlebird_monument_crash", "targetname" );
	level.littlebird_wingman_02 thread maps\dcburning_fx::littlebird_monument_crash( littlebird_monument_crash );
	
	/*-----------------------
	STRAFING RUN PATH TO WW2 MEMORIAL
	-------------------------*/
	eNode = getstruct( "helipath_to_ww2_strafing_littlebird_wingman_armed", "targetname" );
	sSpawnerTargetname = "littlebird_wingman_armed";
	level.littlebird_wingman_armed = level.littlebird_wingman_armed heli_teleport_to_newpath( sSpawnerTargetname, eNode );
	level.littlebird_wingman_armed Vehicle_SetSpeed( 90 );
	
	flag_wait( "player_heli_06" );
	thread drone_flood_stop( "allied_drones_heliride_01" );
	thread drone_flood_stop( "allied_drones_heliride_02" );
	thread drone_flood_stop( "allied_drones_heliride_03" );
	thread drone_flood_stop( "allied_drones_heliride_04" );
	
	
	/*-----------------------
	WW2 MEMORIAL
	-------------------------*/
	flag_wait( "player_heli_10" );
	level.player.ignoreme = true;
	level.blackhawk Vehicle_SetSpeed( 25 );
	activate_trigger( "spawner_ww2_guys_middle", "targetname", level.player );
	level.littlebird_wingman_armed Vehicle_SetSpeed( 120 );
	
	/*-----------------------
	PASSING THROUGH SMOKE
	-------------------------*/
	flag_wait( "player_heli_10a" );
	level.createRpgRepulsors = false;	//don't allow AI to miss on the first shot like they do on the ground
	
	bmps_heli_ride_ww2_02 = spawn_vehicles_from_targetname_and_drive( "bmps_heli_ride_ww2_02" );
	activate_trigger( "spawner_ww2_guys_end", "targetname", level.player );
	
	flag_wait( "player_heli_10b" );
	//level.player disableinvulnerability();
	level.player.ignoreme = false;
	
	flag_wait( "player_heli_10c" );
	
	
	array_thread( level.effects_trenches, ::pauseEffect );
	
	/*-----------------------
	WW2 HELI LIFT OFF
	-------------------------*/
	if ( isdefined( ww2_heli ) )
		ww2_heli thread notify_delay( "liftoff", 3 );

	/*-----------------------
	BTR80s
	-------------------------*/
	flag_wait( "player_heli_14" );
	//bmps_heli_ride_ww2_01 = spawn_vehicles_from_targetname_and_drive( "bmps_heli_ride_ww2_01" );
	wait( .5 );
	level.blackhawk Vehicle_SetSpeed( 50 );
	
	//bmps_heli_ride_ww2_03 = spawn_vehicles_from_targetname_and_drive( "bmps_heli_ride_ww2_03" );
	/*-----------------------
	WW2 MEMORIAL STREET - STOP FLOODSPAWNER AND AXIS DRONES
	-------------------------*/
	crows_nest_bmps = get_vehicle_array( "crows_nest_bmps", "script_noteworthy" );
	foreach( vehicle in crows_nest_bmps )
	{
		if ( isdefined( vehicle ) )
		{
			vehicle maps\_vehicle::godoff();
			vehicle vehicle_delete();
		}
	}
		
	flag_wait( "player_heli_15" );
	level.blackhawk Vehicle_SetSpeed( 30 );
	killspawner( 11 );
	thread drone_flood_stop( "axis_ww2_drones_01" );
	thread drone_flood_stop( "axis_ww2_drones_02" );
	thread drone_flood_stop( "axis_ww2_drones_03" );
	thread drone_flood_stop( "axis_ww2_drones_04" );
	
	flag_wait( "player_heli_16" );
	level.blackhawk Vehicle_SetSpeed( 20 );

}

sam_launch( iNum, sourceEnt, destEnt )
{
	destEnt endon( "death" );
	targetOffset = ( 0, 0, 250 ); 
	targetOrg = spawn( "script_origin", destEnt.origin );
	destEnt thread delete_on_death( targetOrg );
	targetOrg.origin = destEnt.origin;
	targetOrg.angles = destEnt.angles;
	targetOrg linkTo( destEnt, "tag_origin", targetOffset, ( 0, 0, 0 ) );
	targetOrg thread ent_cleanup( destEnt );
	attractor = Missile_CreateAttractorEnt( targetOrg, 8000, 3000 );

	while( iNum > 0 )
	{
		magicBullet( "slamraam_missile_dcburning", sourceEnt.origin, destEnt.origin );
		wait( .25 );
		iNum--;
	}
	
	if( isdefined( targetOrg ) )
		targetOrg delete();

}

delete_squad()
{
	array_thread( level.squad, ::AI_delete );
}

team_leader_gets_on_blackhawk( triggerApproach )
{
	level.teamleader endon( "death" );
	wait( 2 );
	animEnt = spawn( "script_origin", level.blackhawk.origin );
	animEnt.origin = level.blackhawk.origin;
	animEnt.angles = level.blackhawk.angles;
	//thread debug_message( "org", animEnt.origin, 9999, animEnt );
	ent = spawnstruct();
	ent.entity = animEnt;
	ent.up = -100;
	ent.right = -72;
	ent.forward = -50;
	ent.yaw = 180;
	ent translate_local();
	animEnt linkto( level.blackhawk );
	
	level.teamleader notify( "stop_teleport_hack" );
	
	animEnt anim_generic_reach( level.teamleader, "leader_blackhawk_getin" );	
	level.teamleader setGoalPos( level.teamleader.origin );
	level.teamleader.goalradius = 16;
	
	triggerApproach waittill( "trigger" );
	
	animEnt anim_generic_reach( level.teamleader, "leader_blackhawk_getin" );
	level.teamleader linkto( animEnt );
	animEnt anim_generic( level.teamleader, "leader_blackhawk_getin" );
	animEnt thread anim_generic_loop( level.teamleader, "leader_blackhawk_idle", "stop_idle" );
	
}

AI_rooftop_helirider_think()
{
	self endon( "death" );
	
	self thread try_to_magic_bullet_shield();
	self.neverEnableCQB = true;
	//self.fixednode = false;
	self.goalradius = 16;
	self.baseaccuracy = 1000;
	self.attackeraccuracy = 0;	//makes any AI attacking him have shitty accuracy
	
	flag_wait( "blackhawk_landed" );
	
	wait( 1 );
	animEnt = spawn( "script_origin", level.blackhawk.origin );
	animEnt.origin = level.blackhawk.origin;
	animEnt.angles = level.blackhawk.angles;
	//thread debug_message( "org", animEnt.origin, 9999, animEnt );
	ent = spawnstruct();
	ent.entity = animEnt;
	ent.up = -100;
	ent.right = 78;
	ent.forward = 21;
	//ent.yaw = 180;
	ent translate_local();
	animEnt linkto( level.blackhawk );
	
	animEnt anim_generic_reach( self, "redshirt_blackhawk_getin" );	
	self linkto( animEnt );
	animEnt anim_generic( self, "redshirt_blackhawk_getin" );
	animEnt thread anim_generic_loop( self, "redshirt_blackhawk_idle", "stop_idle" );
	
}

player_lerped_onto_minigun( nolerp )
{
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player allowsprint( false );
	level.player allowjump( false );
	level.blackhawk maps\_blackhawk_minigun::player_mount_blackhawk_gun( nolerp );
	level.onHeli = true;
	//setsaveddvar( "sm_sunSampleSizeNear", 1 );// air
	//setsaveddvar( "sm_sunShadowScale", 0.5 );// optimized for air
}

try_to_teleport_friendlies_to_roof( eNode )
{
	assert( isdefined( eNode ) );
	//in case key friendlies got left behind
	level endon( "player_getting_on_minigun" );
	self endon( "death" );
	self endon( "stop_teleport_hack" );
	fDistSquared = 300 * 300;
	while( isdefined( self ) )
	{
		wait( .1 );
		if ( distancesquared( level.player.origin, self.origin ) < fDistSquared )
			continue;
		playerEye = level.player getEye();
		if ( within_fov( playerEye, level.player.angles, self.origin + ( 0, 0, 32 ), level.cosine[ "90" ] ) )
			continue;
		else
			break;
	}
	self forceTeleport( eNode.origin, eNode.angles );
	self notify( "end_melee" );
	self disable_ai_color();
	self setgoalnode( eNode );
}

player_blackhawk_setup( heliNode )
{
	level.blackhawk = spawn_vehicle_from_targetname_and_drive( "heli_player" );
	level.blackhawk thread player_blackhawk_think();
	if ( isdefined( heliNode ) )
	{
		level.blackhawk Vehicle_Teleport( heliNode.origin, heliNode.angles );
		level.blackhawk thread vehicle_paths( heliNode );
		////level.player.origin = level.blackhawk.origin;
		level.blackhawk useby( level.player );
		level.blackhawk player_blackhawk_default_params();
		//level.blackhawk maps\_blackhawk_minigun::player_mount_blackhawk_gun();
	}
}

player_blackhawk_default_params()
{
	level.blackhawk cleargoalyaw();
	level.blackhawk Vehicle_SetSpeed( 30 );
	level.blackhawk sethoverparams( 32, 10, 3 );
	level.blackhawk setmaxpitchroll( 5, 10 );
}

vehicle_ww2_enemy_helis_think()
{
	//Called from spawn_func
	self endon( "death" );
	/*-----------------------
	HELI SETUP
	-------------------------*/
	//move closest crash location to the heli's origin so it doesn't clip into the ground
	aCrashLocations = maps\_vehicle::get_unused_crash_locations();
	eCrashLoc = getClosest( self.origin, aCrashLocations );
	eCrashLoc.origin = self.origin;
	self.perferred_crash_location = eCrashLoc;
	
	/*-----------------------
	HELI LIFTOFF
	-------------------------*/
	self waittill( "liftoff" );
	self thread ground_heli_kill_player();
	ePath = getstruct( self.script_Linkto, "script_linkname" );
	dist = distance( self.origin, ePath.origin );
	self Vehicle_SetSpeed( 10 );
	self vehicle_liftoff( dist );
	self Vehicle_SetSpeed( 50 );
	self thread vehicle_paths( ePath );
	
}

ground_heli_kill_player()
{
	self endon( "death" );
	level.player endon( "death" );
	self ent_flag_init( "stop_firing" );
	while ( ( isalive( self ) ) && ( !ent_flag( "stop_firing" ) ) )
	{
		wait( .5 );
		self SetLookAtEnt( level.player );
		if ( !within_fov( self.origin, self.angles, level.player.origin + ( 0, 0, 32 ), level.cosine[ "35" ] ) )
		{
			self notify( "stop_firing_turret" );
			continue;
		}

		self thread vehicle_heli_fire_turret( level.player );
	}
	self notify( "stop_firing_turret" );
	self clearLookAtEnt();
	
}

heli_at4_sequence()
{
	flag_wait( "player_getting_on_minigun" );
	
	spawner = getent( "roof_rocket_guy", "targetname" );
	roof_rocket_guy = spawner spawn_ai( true );
	roof_rocket_guy thread AI_ignored_and_oblivious_on();
	roof_rocket_guy thread try_to_magic_bullet_shield();
	reference = spawner;
	reference anim_generic_first_frame( roof_rocket_guy, roof_rocket_guy.animation );
	roof_rocket_guy attach( "weapon_stinger", "TAG_INHAND" );
	reference thread anim_generic( roof_rocket_guy, roof_rocket_guy.animation );
	roof_rocket_guy setAnimTime( level.scr_anim[ "generic" ][ roof_rocket_guy.animation ], .6 );
	
	heli_roof = spawn_vehicle_from_targetname_and_drive ( "heli_roof" );
	heli_roof thread heli_roof_think();
	heli_roof SetLookAtEnt( level.player );
	org = spawn( "script_origin",  heli_roof.origin + ( 0, 0, -20 ) );
	org linkto( heli_roof );
	org thread ent_cleanup( heli_roof );
	attractor = Missile_CreateAttractorEnt( org, 2000, 10000, roof_rocket_guy );
	
	roof_rocket_guy waittillmatch( "single anim", "fire" );
	earthquake( .3, .5, level.player.origin, 1600 );
	org_hand = roof_rocket_guy gettagorigin( "TAG_INHAND" );
	magicbullet( "stinger", org_hand, org.origin );
	flag_set( "roof_heli_about_to_be_owned" );
	heli_roof thread heli_roof_death_failsafe();
	
	roof_rocket_guy waittillmatch( "single anim", "end" );
	org_hand = roof_rocket_guy gettagorigin( "TAG_INHAND" );
	angles_hand = roof_rocket_guy gettagangles( "TAG_INHAND" );
	roof_rocket_guy detach( "weapon_stinger", "TAG_INHAND" );
	model_at4 = spawn( "script_model", org_hand );
	model_at4 setmodel( "weapon_stinger" );
	roof_rocket_guy thread delete_on_death( model_at4 ); 
	model_at4.angles = angles_hand;
	//reference thread anim_generic_loop( roof_rocket_guy, "AT4_idle", "stop_idle" );
	
	eNode = getnode( "at4_guy_retreat", "targetname" );
	roof_rocket_guy setgoalnode( eNode );
	roof_rocket_guy thread stop_magic_bullet_shield();
	roof_rocket_guy thread AI_ignored_and_oblivious_off();
	roof_rocket_guy.health = 1;
}

heli_roof_think()
{
	self.immuneToBlackhawk = true;
	self waittill( "death" );
	flag_set( "roof_heli_owned" );
	earthquake( 0.6, 1.2, level.player.origin, 1600 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

heli_roof_death_failsafe()
{
	self endon( "death" );
	wait( 1.8 );
	self notify( "damage", 5000, level.player, undefined, undefined, "MOD_PROJECTILE" );
}

player_blackhawk_think()
{
	flag_set( "player_heli_spawned" );
	self maps\_vehicle::godon();
}

littlebird_wingman_02_think()
{
	flag_wait( "player_approaching_outer_balcony" );
	
	/*-----------------------
	SPAWN LITTLEBIRD AND RIDERS TO NODES
	-------------------------*/
	aRoof_riders_left = array_spawn( getentarray( "littlebird_roof_riders_left", "targetname" ) );
	array_thread( aRoof_riders_left,::AI_ignored_and_oblivious_on );
	array_thread( aRoof_riders_left,::magic_bullet_shield );
	aRoof_riders_right = array_spawn( getentarray( "littlebird_roof_riders_right", "targetname" ) );
	array_thread( aRoof_riders_right,::AI_ignored_and_oblivious_on );
	array_thread( aRoof_riders_right,::magic_bullet_shield );
	level.littlebird_wingman_02 = spawn_vehicle_from_targetname( "littlebird_wingman_02" );
	level.littlebird_wingman_02 thread gopath();

	// you'll send this node off to some commands to get the nodes contained in the stage prefab
	pickup_node_before_stage = getstruct( "pickup_node_before_stage", "script_noteworthy" );
	level.littlebird_wingman_02 set_stage( pickup_node_before_stage, aRoof_riders_left, "left" );
	level.littlebird_wingman_02 set_stage( pickup_node_before_stage, aRoof_riders_right, "right" );

	/*-----------------------
	LITTLEBIRD LANDS BEFORE PLAYER GETS THERE
	-------------------------*/
	//touch_down happens when the vehicle paths into the vehicle node contained in the  prefabs/script_gags/littlebird_stage_load.map prefab
	level.littlebird_wingman_02 waittill( "touch_down" );
	
	/*-----------------------
	MAKE LEFT RIDERS GET ON BEFORE PLAYER GETS THERE
	-------------------------*/
	level.littlebird_wingman_02 thread load_side( "left", aRoof_riders_left );
	level.littlebird_wingman_02 thread load_side( "right", aRoof_riders_right );

	/*-----------------------
	SETUP HELI AND HAVE IT CIRCLE PLAYER BLACKHAWK
	-------------------------*/
	flag_wait( "player_approach_commerce_roof_01" );
	level.littlebird_wingman_01 = spawn_vehicle_from_targetname( "littlebird_wingman_01" );
	level.littlebird_wingman_01 thread vehicle_ai_event( "idle_alert_to_casual" );
	thread gopath( level.littlebird_wingman_01 );

	/*-----------------------
	MAKE RIGHT RIDERS GET ON WHEN PLAYER ARRIVES 
	-------------------------*/
	while ( level.littlebird_wingman_02.riders.size < 6 )
		wait( .1 );
	
	thread flag_set( "roof_littlebird_lifted_off" );
	/*-----------------------
	LITTLEBIRD TAKES OFF AND CIRCLES
	-------------------------*/
	//wait( .5 );
	//level.littlebird_wingman_02 vehicle_ai_event( "idle_alert" );
	level.littlebird_wingman_02 thread vehicle_liftoff( 3 );
	//level.littlebird_wingman_02 vehicle_ai_event( "idle_alert_to_casual" );
	heli_roof_loop_01 = getstruct( "heli_roof_loop_01", "targetname" );
	wait( 1 );
	level.littlebird_wingman_02 thread vehicle_paths( heli_roof_loop_01 );
	level.littlebird_wingman_02 setmaxpitchroll( 20, 50 );
	wait( 2 );
	level.littlebird_wingman_02 vehicle_ai_event( "idle_alert_to_casual" );
	level.littlebird_wingman_02 Vehicle_SetSpeed( 25 );

}

littlebird_wingman_armed_think()
{
	flag_wait( "player_approach_commerce_roof_02" );
	
	level.littlebird_wingman_armed = spawn_vehicle_from_targetname_and_drive( "littlebird_wingman_armed" );
	level.littlebird_wingman_armed Vehicle_SetSpeed( 25 );
	//littlebird_wingman_armed thread maps\_attack_heli::heli_spotlight_on();
	//littlebird_wingman_armed thread maps\_attack_heli::heli_spotlight_random_targets_on();
	
	wingman_roof_node_01 = getstruct( "wingman_roof_node_01", "script_noteworthy" );
	wingman_roof_node_01 waittill( "trigger" );
	//littlebird_wingman_armed SetLookAtEnt( level.blackhawk );
	roof_target_for_helis = getent( "roof_target_for_helis", "targetname" );
	level.littlebird_wingman_armed SetLookAtEnt( roof_target_for_helis );
	level.littlebird_wingman_armed Vehicle_SetSpeed( 10 );
	
	/*-----------------------
	SWITCH PATH WHEN PLAYER GETS ON BLACKHAWK
	-------------------------*/
	waittillframeend;
	foreach ( turret in level.littlebird_wingman_armed.mgturret )
	{
		turret SetMode( "auto_nonai" );
		//turret StartFiring();
	}
	
	flag_wait( "player_getting_on_minigun" );
	
	//littlebird_wingman_armed mgoff();
	foreach ( turret in level.littlebird_wingman_armed.mgturret )
	{
		turret SetMode( "manual" );
		turret StopFiring();
	}
}

/****************************************************************************
    HELI RIDE 2
****************************************************************************/ 
AA_heli_ride2()
{
	thread AAA_sequence_heli_ride2();
	thread dialogue_heli_ride2();
	
	flag_wait( "player_crash_starting" );
	thread maps\dc_crashsite::AA_crash_site_init();
	
	flag_wait( "player_crash_done" );
	level.player setViewmodel( "ch_viewhands_gk_ump9" );
}

dialogue_heli_ride2()
{
	//flag_wait( "player_heli_18" );
	//Little Bird Pilot 1	Overlord, this is Dagger Two-One. We've taken some of the heat off the evac site -	
	//radio_dialogue( "dcburn_lbp1_takenheatoff" );
	
	flag_wait( "player_heli_18a" );
	//Black Hawk Pilot	Incoming! Incoming!	
	radio_dialogue_overlap( "dcburn_bhp_incoming" );
	
	//flag_wait( "littlebird_wingman_02_crash_start" );

	//Little Bird Pilot 1	Dagger Two, SAM launch! Break left break left!!!	
	//radio_dialogue( "dcburn_lbp1_breakleftbreakleft" );
	
	flag_wait( "player_heli_18d" );

	//Sgt. Foley	Overlord, we're hit, but still in the air. We've got a massive SAM battery dead ahead...we're going in!!
	radio_dialogue( "dcburn_mcy_stillintheair" );
	
	flag_wait( "player_heli_19" );
	//Black Hawk Pilot	RPG teams! 12 o'clock!!!
	//radio_dialogue( "dcburn_bhp_rpgteams" );

	//Black Hawk Pilot	We're losing attitude control�!!!
	radio_dialogue( "dcburn_bhp_attitudecontrol" );

	//Ranger 2	32	2	We're bleeding hydraulic fluid, I'm losin' the tail rotor!	
	//radio_dialogue( "dcburn_ar2_hydraulicfluid" );
	
	//Sgt. Foley	Take us up!!! If we're goin' down we're taking those SAM sites with us!!!
	radio_dialogue( "dcburn_mcy_takeusup" );
	
	flag_wait( "player_heli_20" );
	//Black Hawk Pilot	Multiple fire teams spotted!		struggling with the controls, keeping it aloft, still flying	helicopter radio
	//radio_dialogue( "dcburn_bhp_fireteams" );
	
	//Little Bird Pilot 1	Overlord, Dagger Two-two and Two-three are down. I repeat, Dagger Two-Two and Two-Three are down, over.	
	//radio_dialogue( "dcburn_lbp1_22and23aredown" );
	
	//Little Bird Pilot 1	Foot mobiles...take em out.	
	//radio_dialogue( "dcburn_lbp1_footmobiles" );	
	
	//Black Hawk Pilot	RPG teams in sight...I want you to pull that trigger till they don't get up.	
	//radio_dialogue( "dcburn_bhp_dontgetup" );	
	
	//Little Bird Pilot 1	SAM launch! Hang on!!	
	radio_dialogue( "dcburn_lbp1_samlaunch" );
	
	flag_wait( "player_crash_starting" );
	wait ( .3 );
	
	//Little Bird Pilot 1	We're hit! Mayday mayday, this is Dagger Two-One, we are going down at grid square Papa Bravo, 2 niner 2, 1 7 8. I repeat, we are going down.
	soundOrg = spawn_tag_origin();
	soundOrg linkTo( level.player );
	soundOrg thread play_sound_on_tag_endon_death( "dcburn_lbp1_maydaymayday", "tag_origin" );
	
	flag_wait( "player_heli_crash" );
	soundOrg notify( "death" );
	soundOrg delete();
	
	
	//Little Bird Pilot 1	Brace for impact!	
	//radio_dialogue( "dcburn_lbp1_braceforimpact" );
}

AAA_sequence_heli_ride2()
{

	flag_wait( "player_heli_18" );
	thread autosave_now();
	//level.player enableinvulnerability();
	level.blackhawk Vehicle_SetSpeed( 70 );
	
	if ( isdefined( level.littlebird_wingman_armed ) )
		level.littlebird_wingman_armed vehicle_delete();
	if ( isdefined( level.littlebird_wingman_01 ) )
		level.littlebird_wingman_01 vehicle_delete();
	if ( isdefined( level.littlebird_wingman_02 ) )
		level.littlebird_wingman_02 vehicle_delete();

	/*-----------------------
	CLEANUP AI
	-------------------------*/
	vehicles_to_delete = getentarray( "vehicles_crowsnest_defend", "targetname" );
	foreach( vehicle in vehicles_to_delete )
	{
		if ( isdefined( vehicle ) )
		{
			vehicle delete();
		}
	}
	
	/*-----------------------
	LITTLEBIRD CRASH SETUP
	-------------------------*/
	littlebird_wingman_02_drone_crash = spawn_vehicle_from_targetname_and_drive( "littlebird_wingman_02_drone_crash" );
	littlebird_wingman_02_drone_crash Vehicle_SetSpeed( 70 );
	//littlebird_wingman_02_drone_crash SetAcceleration( 100 );
	targetOffset = ( 0, 0, 250 ); 
	targetOrg = spawn( "script_origin", littlebird_wingman_02_drone_crash.origin );
	targetOrg.origin = littlebird_wingman_02_drone_crash.origin;
	targetOrg.angles = littlebird_wingman_02_drone_crash.angles;
	targetOrg linkTo( littlebird_wingman_02_drone_crash, "tag_origin", targetOffset, ( 0, 0, 0 ) );
	targetOrg thread ent_cleanup( littlebird_wingman_02_drone_crash );
	attractor = Missile_CreateAttractorEnt( targetOrg, 8000, 3000 );
	
	/*-----------------------
	LITTLEBIRD CRASHES
	-------------------------*/
	missile_org_lincoln = getent( "missile_org_lincoln", "targetname" );
	//flag_wait( "littlebird_wingman_02_crash_start" );

				//LerpViewAngleClamp( <time>, <accel time>, <decel time>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	//level.player lerpViewAngleClamp( 0.5, 0, 0, 10, 10, 10, 10 );
	eMissile1 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
	wait( .5 );
	eMissile2 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
	wait( .5 );
	eMissile3 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
	wait( .5 );
	eMissile4 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
	wait( .5 );
	eMissile5 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
	
	newMissile2 = MagicBullet( "javelin_dcburn", missile_org_lincoln.origin, littlebird_wingman_02_drone_crash.origin );
	newMissile2 Missile_SetTargetEnt( littlebird_wingman_02_drone_crash ); 
	littlebird_crash_ww2 = getstruct( "littlebird_crash_ww2", "targetname" );
	littlebird_wingman_02_drone_crash thread maps\dcburning_fx::littlebird_monument_crash( littlebird_crash_ww2 );
	
	/*-----------------------
	PLAYER HELI HIT
	-------------------------*/
	flag_wait( "player_heli_18b" );
	wait( 2 );
	earthquake( .5, 1.5, level.player.origin, 1600 );
	//level.player disableinvulnerability();
	level.blackhawk thread play_sound_in_space( "blackhawk_down_missile_impact" );
	level.player thread play_sound_in_space( "blackhawk_helicopter_secondary_exp" );
	playfx( level._effect[ "player_death_explosion" ], level.player.origin + ( 0, 0, 50 ) );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	level.player dodamage( 10, level.player.origin );
	thread player_heli_damaged_think();
	thread player_heli_damaged_earthquake();
	level.player thread play_loop_sound_on_entity( "dcburning_heli_alarm" );
	
	SetBlur( 3, .1 );
	level.blackhawk thread blackhawk_smoke_fx();
	wait( .5 );
	
	SetBlur( 1, .6 );

	
	/*-----------------------
	2ND LITTLEBIRD CRASHES
	-------------------------*/
	//littlebird_wingman_01_drone_crash = spawn_vehicle_from_targetname_and_drive( "littlebird_wingman_01_drone_crash" );
	//littlebird_wingman_01_drone_crash Vehicle_SetSpeed( 80 );
	//littlebird_wingman_01_drone_crash SetDeceleration( 100 );
	//littlebird_wingman_01_drone_crash delaythread( 7, maps\dcburning_fx::littlebird_crash2 );
	//littlebird_wingman_01_drone_crash SetAcceleration( 100 );
	//littlebrid_crash_02_start
	//littlebrid_crash_02_end
	
	//wait( 3.5 );
	
	//littlebird_wingman_02_drone_crash thread maps\dcburning_fx::littlebird_crash();

	
	//thread littlebird_wingman_01_crash( littlebird_wingman_01_drone_crash, targetOrg, missile_org_lincoln );

	/*-----------------------
	WINDOW FIGHT - START
	-------------------------*/
	flag_wait( "player_heli_18d" );
	level.blackhawk Vehicle_SetSpeed( 25, 60, 60 );
	array_thread( level.effects_ww2, ::pauseEffect );
	thread AI_drone_cleanup( "axis", undefined, true );
	thread AI_cleanup( "axis", undefined, true );
	
	aSpawners = getentarray( "axis_window_drones_01", "targetname" );
	thread drone_flood_start( aSpawners, "axis_window_drones_01" );
	aSpawners = getentarray( "axis_window_drones_02", "targetname" );
	thread drone_flood_start( aSpawners, "axis_window_drones_02" );
	activate_trigger( "spawner_enemies_glass_02", "targetname", level.player );
	activate_trigger( "spawner_enemies_glass_03", "targetname", level.player );


	aSpawners = getentarray( "axis_lincoln_drones_01", "targetname" );
	thread drone_flood_start( aSpawners, "axis_lincoln_drones_01" );
	aSpawners = getentarray( "axis_lincoln_drones_02", "targetname" );
	thread drone_flood_start( aSpawners, "axis_lincoln_drones_02" );
	aSpawners = getentarray( "axis_lincoln_drones_03", "targetname" );
	thread drone_flood_start( aSpawners, "axis_lincoln_drones_03" );
	aSpawners = getentarray( "axis_lincoln_drones_04", "targetname" );
	thread drone_flood_start( aSpawners, "axis_lincoln_drones_04" );


	/*-----------------------
	WINDOW FIGHT - CORNER
	-------------------------*/
	flag_wait( "player_heli_19a" );
	vehicle_delete_non_squad();
	thread AI_cleanup_volume( "volume_enemies_glass_02", "axis" );
	thread drone_flood_stop( "axis_window_drones_01" );
	activate_trigger( "spawner_enemies_glass_04", "targetname", level.player );
	
	flag_wait( "player_heli_19b" );
	thread AI_cleanup_volume( "volume_enemies_glass_03", "axis" );
	
	/*-----------------------
	WINDOW FIGHT - ROOFTOP REVEAL
	-------------------------*/
	flag_wait( "player_heli_19c" );
	
	littlebird_wingman_armed_lincoln = spawn_vehicle_from_targetname_and_drive( "littlebird_wingman_armed_lincoln" );
	littlebird_wingman_armed_lincoln Vehicle_SetSpeed( 90 );
	
	thread AI_cleanup_volume( "volume_enemies_glass_04a", "axis" );
	thread AI_cleanup_volume( "volume_enemies_glass_04", "axis" );
	activate_trigger( "spawner_enemies_balcony_01", "targetname", level.player );
	slamraam_lincoln = spawn_vehicles_from_targetname( "slamraam_lincoln" );
	activate_trigger( "spawner_axis_lincoln_01", "targetname", level.player );
	//drone_flood_stop( "axis_lincoln_drones_01" );
	//drone_flood_stop( "axis_lincoln_drones_02" );
	//drone_flood_stop( "axis_lincoln_drones_03" );
	//drone_flood_stop( "axis_lincoln_drones_04" );
	
	flag_wait( "player_heli_19d" );
	level.blackhawk Vehicle_SetSpeed( 80, 20, 20 );

	flag_wait( "player_heli_20" );
	slamraam_lincoln = get_array_of_closest( level.player.origin, slamraam_lincoln );
	delay = 0;
	foreach( slamraam in slamraam_lincoln )
	{
		if ( isdefined( slamraam ) )
		{
			slamraam thread notify_delay( "fire", delay );
			delay = delay + .25;
		}
	}
	
	flag_wait( "player_heli_21" );
	slamraam_lincoln = get_array_of_closest( level.player.origin, slamraam_lincoln );
	delay = 0;
	foreach( slamraam in slamraam_lincoln )
	{
		if ( isdefined( slamraam ) )
		{
			slamraam thread notify_delay( "fire", delay );
			delay = delay + .25;
		}
	}
	
	
	/*-----------------------
	CLEANUP AND CRASH
	-------------------------*/
	flag_wait( "player_heli_22" );
	drone_flood_stop( "axis_lincoln_drones_01" );
	drone_flood_stop( "axis_lincoln_drones_02" );
	drone_flood_stop( "axis_lincoln_drones_03" );
	drone_flood_stop( "axis_lincoln_drones_04" );
	
	/*-----------------------
	BLACKHAWK CRASHES
	-------------------------*/

	//thread maps\_minigun::minigun_hints_off();
	flag_set( "player_crash_starting" );
	level.blackhawk thread play_sound_in_space( "blackhawk_down_missile_impact" );
	level.player thread play_sound_in_space( "blackhawk_helicopter_hit" );
	level.blackhawk Vehicle_TurnEngineOff();
	level.blackhawk thread play_loop_sound_on_entity( "blackhawk_helicopter_dying_loop" );
	
	//level.player enableInvulnerability();
	level.blackhawk Vehicle_SetSpeed( 150, 50, 50 );
	playfx( level._effect[ "player_death_explosion" ], level.player.origin );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	level.blackhawk useby( level.player );
	level.player unlink();
	level.player disableWeapons();
	level.blackhawk MakeUnusable();
	flag_clear( "player_on_minigun" );
	flag_set( "player_off_minigun" );
	level notify( "player_off_blackhawk_gun" );
	//thread notify_hack();

	level.player playerLinkToBlend( level.blackhawk, "tag_player", .5 );
				//PlayerLinkToDelta( <linkto entity>, <tag>, <viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc>, <use tag angles> )
	level.player playerlinkToDelta( level.blackhawk, "tag_player", 1, 20, 20, 10, 10 );
	SetBlur( 3, .1 );
	level.blackhawk thread player_crash_fx();
	earthquake( .7, 2.5, level.player.origin, 1600 );
	level.blackhawk thread player_spinout();
	wait 1;
	//level.blackhawk stopSounds();
	//level.blackhawk StopLoopSound();
	flavorbursts_off( "allies" );
	SetBlur( 0, .5 );
	
	thread AI_cleanup( "all", undefined, true );
	thread AI_drone_cleanup( "axis", undefined, true );
	
	
	//level.player thread play_loop_sound_on_entity( "dcburning_heli_alarm" );
	
	flag_wait( "player_heli_crash" );
	
	earthquake( .7, 2.5, level.player.origin, 1600 );
	playfx( level._effect[ "player_death_explosion" ], level.player.origin );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	level.player notify( "stop sound" + "dcburning_heli_alarm" );
	level.blackhawk notify( "stop sound" + "blackhawk_helicopter_dying_loop" );
	wait( .1 );
	level.player thread play_sound_on_entity( "blackhawk_helicopter_crash" );
	littlebird_wingman_armed_lincoln vehicle_delete();
	wait( .3 );
	music_stop();
	SetBlur( 3, .1 );
	level.black_overlay = create_client_overlay( "black", 1 );
	level.player unlink();
	wait( .1 );
	level.blackhawk vehicle_delete();

	wait( 2 );
	
	SetBlur( 0, .5 );
	flag_set( "player_crash_done" );
	level.player SetActionSlot( 1, "nightvision" );
	
	//reset hunted spotlight to dynamic version
	if ( GetDvarInt( "sm_enable" ) && GetDvar( "r_zfeather" ) != "0" )
		level._effect[ "_attack_heli_spotlight" ]	 = LoadFX( "misc/hunted_spotlight_model_dim" );
	else
		level._effect[ "_attack_heli_spotlight" ]	 = LoadFX( "misc/spotlight_large" );
	
}

player_heli_damaged_think()
{
	dummy = spawn_tag_origin();
	dummy linkto( level.blackhawk, "tag_guy5", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	while ( !flag( "player_crash_done" ) )
	{
		playfxontag( getfx( "dlight_red" ), dummy, "tag_origin" );
		wait( 1 );
		stopfxontag( getfx( "dlight_red" ), dummy, "tag_origin" );
		wait( .5 );
	}
	dummy unlink();
	dummy delete();
}

player_heli_damaged_earthquake()
{
	while ( !flag( "player_crash_starting" ) )
	{
		earthquake( .1, .05, level.player.origin, 80000 );
		wait( .05 );
	}
}

//littlebird_wingman_01_crash( littlebird_wingman_01_drone_crash, targetOrg, missile_org_lincoln )
//{
//	targetOffset = ( 0, 0, 0 );
//	targetOrg unlink();
//	targetOrg.origin = littlebird_wingman_01_drone_crash.origin;
//	targetOrg linkTo( littlebird_wingman_01_drone_crash, "tag_origin", targetOffset, ( 0, 0, 0 ) );
//	wait( .5 );
//	eMissile6 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
//	wait( .5 );
//	eMissile7 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
//	wait( .1 );
//	eMissile8 = magicBullet( "slamraam_missile_dcburning", missile_org_lincoln.origin, targetOrg.origin );
//
//}


//notify_hack()
//{
//	level.blackhawk endon( "death" );
//	while( isdefined( level.blackhawk ) )
//	{
//		wait( 0.05 );
//		level.blackhawk stopSounds();
//		level.blackhawk notify( "stop sound" + "Minigun_gatling_fire" );
//		level notify( "stopMinigunSound" );
//	}
//
//}
//slamraam_think()
//{
//	//self ==> slamraam base
//	slamraam_launcher = spawn( "script_model", self.origin );
//	slamraam_launcher= "vehicle_slamraam_launcher";
//	self.missileModel = "projectile_slamraam_missile";
//	self.missileTags = [];
//	self.missileTags[ 0 ] = "tag_missle1";
//	self.missileTags[ 1 ] = "tag_missle2";
//	self.missileTags[ 2 ] = "tag_missle3";
//	self.missileTags[ 3 ] = "tag_missle4";
//	self.missileTags[ 4 ] = "tag_missle5";
//	self.missileTags[ 5 ] = "tag_missle6";
//	self.missileTags[ 6 ] = "tag_missle7";
//	self.missileTags[ 7 ] = "tag_missle8";
//}

blackhawk_smoke_fx()
{
	self endon( "death" );
	for ( ;; )
	{
		//playfxOnTag( getfx( "chopper_smoke_trail" ), level.blackhawk, "tag_guy0" );
		playfxOnTag( getfx( "smoke_trail_black_heli" ), level.blackhawk, "tag_gun_r" );
		//playfxOnTag( getfx( "turret_overheat_haze" ), level.blackhawk, "tag_flash" );
		//playfxOnTag( getfx( "turret_overheat_smoke" ), level.blackhawk, "tag_flash" );
		wait .05;
	}
}

player_crash_fx()
{
	while ( !flag( "player_heli_crash") )
	{
		playfxOnTag( getfx( "heat_shimmer_door" ), self, "tag_player" );
		wait( .1 );
	}
}

player_spinout()
{
	self SetMaxPitchRoll( 50, 100 );
	self setturningability( 1 );
	yawspeed = 1400;
	yawaccel = 200;
	targetyaw = undefined;

	while ( isdefined( self ) )
	{
		targetyaw = self.angles[ 1 ] + 100;
		self setyawspeed( yawspeed, yawaccel );
		self settargetyaw( targetyaw );
		wait 0.1;
	}
}



AI_ambush_behavior()
{
	// drone?
	if ( !issentient( self ) )
		return; 

	self.combatMode = "ambush";
}

AI_hummer_gunner_think()
{
	self endon( "death" );
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.ignoreall = true;
	self.maxsightdistsqrd = 0;
	
	wait( 0.2 );
	//turret = self getTurret();
	//turret setmode( "manual" );
	//turret SetTargetEntity( ent );
	//turret.dontshoot = true;
}

AI_glass_building_enemies_think()
{
	self.interval = 0;
	self.neverEnableCQB = true;
	self.grenadeawareness = 0;
	self.ignoresuppression = true;
	self.aggressivemode = true;	//dont linger at cover when you cant see your enemy
}


/****************************************************************************
    OBJECTIVE FUNCTIONS
****************************************************************************/ 
obj_follow_sgt_macey()
{
	flag_wait( "obj_follow_sgt_macey_given" );
	objective_number = 1;
	obj_position = level.teamleader;
	objective_add( objective_number, "active", &"DCBURNING_OBJ_FOLLOW_SGT_MACEY" );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.teamleader, ( 0, 0, 70 ) );
	flag_wait( "obj_follow_sgt_macey_complete" );
	objective_state( objective_number, "done" );
}

obj_commerce()
{
	flag_wait( "obj_commerce_given" );
	objective_number = 2;
	obj_position = getstruct( "obj_commerce_sector_1", "targetname" );

	objective_add( objective_number, "active", &"DCBURNING_OBJ_COMMERCE" );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.teamleader, ( 0, 0, 70 ) );
	
//	flag_wait( "player_approaching_bottom_elevators" );
//	thread autosave_by_name( "player_approaching_bottom_elevators" );
//	obj_position = getstruct( "obj_commerce_sector_1a", "targetname" );
//	Objective_Position( objective_number, obj_position.origin );
//	
//	flag_wait( "player_entering_commerce_side_hall" );
//	thread autosave_by_name( "player_entering_commerce_side_hall" );
//	obj_position = getstruct( "obj_commerce_sector_1b", "targetname" );
//	Objective_Position( objective_number, obj_position.origin );
//	
//	flag_wait( "player_entering_mezzanine" );
//	obj_position = getstruct( "obj_commerce_sector_1c", "targetname" );
//	Objective_Position( objective_number, obj_position.origin );
//
//	flag_wait( "player_at_top_of_pavlovs_ramp" );
//	obj_position = getstruct( "obj_commerce_sector_1d", "targetname" );
//	Objective_Position( objective_number, obj_position.origin );
//	
//	flag_wait( "player_entering_top_elevator_area" );
//	obj_position = getstruct( "obj_commerce_sector_2", "targetname" );
//	Objective_Position( objective_number, obj_position.origin );
//	
	flag_wait( "player_around_corner_to_crows_nest" );
	//flag_wait( "macey_tells_you_to_move_to_crows" );
	
	objective_position( objective_number, ( 0, 0, 0 ) );
	obj_position = getstruct( "obj_commerce_sector_3", "targetname" );
	Objective_Position( objective_number, obj_position.origin );
	
	flag_wait( "obj_commerce_complete" );

	objective_state( objective_number, "done" );
}

obj_commerce_defend_snipe()
{
	flag_wait( "obj_commerce_defend_snipe_given" );
	objective_number = 3;
	obj_position = getstruct( "obj_commerce_defend_snipe", "targetname" );

	objective_add( objective_number, "active", &"DCBURNING_OBJ_COMMERCE_DEFEND_SNIPE", obj_position.origin );
	objective_current( objective_number );

	flag_wait( "obj_commerce_defend_snipe_complete" );

	objective_state( objective_number, "done" );
}

//obj_commerce_defend_snipe()
//{
//	flag_wait( "obj_commerce_defend_snipe_given" );
//	//level.evacSiteEnemies = [];
//	//level.evacSiteVehicles = [];
//	//level.evacSiteEnemyVehicles = [];
//	objective_number = 3;
//	obj_position = getstruct( "obj_commerce_defend_snipe", "targetname" );
//	objective_add( objective_number, "invisible", &"DCBURNING_OBJ_COMMERCE_DEFEND_SNIPE", obj_position.origin );
//	objective_state( objective_number, "current" );
//	//"empty", "active", "invisible", "done", "current" and "failed"
//	Objective_String( objective_number, &"DCBURNING_OBJ_COMMERCE_DEFEND_SNIPE" );
//	objective_current( objective_number );
//
//	flag_wait( "obj_commerce_defend_snipe_complete" );
//
//	objective_state( objective_number, "done" );
//}

obj_commerce_defend_snipe_enemies_think()
{
	level endon( "obj_commerce_defend_snipe_complete" );
	self waittill( "death" );
	level.lasttimePlayerKilledEnemy = getTime();
	//level.evacSiteEnemies = remove_dead_from_array( level.evacSiteEnemies );
	level.snipeEnemies = ( level.snipeEnemies - 1 );
	//Objective_String( 3, &"DCBURNING_OBJ_COMMERCE_DEFEND_SNIPE", level.evacSiteEnemies.size );
	
	if ( level.snipeEnemies < 3 )
		flag_set( "only_2_sniper_enemies_remaining" );
	if ( level.snipeEnemies == 0 )
		flag_set( "obj_commerce_defend_snipe_complete" );
		
//	if ( level.evacSiteEnemies.size < 3 )
//		flag_set( "only_2_sniper_enemies_remaining" );
//	if ( level.evacSiteEnemies.size == 0 )
//		flag_set( "obj_commerce_defend_snipe_complete" );
}

obj_commerce_defend_crow()
{
	flag_wait( "obj_commerce_defend_crow_given" );
	objective_number = 4;
	//obj_position = getstruct( "obj_commerce_sector_3", "targetname" );
	
	objective_add( objective_number, "invisible", &"DCBURNING_OBJ_COMMERCE_DEFEND_CROW" );
	crow_defend_obj1 = getent( "crow_defend_obj1", "targetname" );
	crow_defend_obj2 = getent( "crow_defend_obj2", "targetname" );
	objective_additionalposition( objective_number, 0, crow_defend_obj1.origin );
	objective_additionalposition( objective_number, 1, crow_defend_obj2.origin );
	Objective_SetPointerTextOverride( objective_number, &"DCBURNING_OBJ_TEXT_DEFEND" );
	objective_state( objective_number, "current" );

	flag_wait( "obj_commerce_defend_crow_complete" );

	objective_state( objective_number, "done" );
}


obj_commerce_defend_javelin()
{
	flag_wait( "obj_commerce_defend_javelin_given" );
	wait( .5 );
	objective_number = 5;
	obj_position = getstruct( "obj_jav_defend2", "targetname" );

	objective_add( objective_number, "active", &"DCBURNING_OBJ_COMMERCE_DEFEND_JAVELIN" );
	objective_current( objective_number );

	flag_wait( "obj_commerce_defend_javelin_complete" );

	objective_state( objective_number, "done" );
}

//obj_commerce_defend_javelin()
//{
//	flag_wait( "obj_commerce_defend_javelin_given" );
//	wait( .5 );
//	objective_number = 4;
//	obj_position = getstruct( "obj_commerce_defend_javelin", "targetname" );
//	objective_add( objective_number, "invisible", &"DCBURNING_OBJ_COMMERCE_DEFEND_JAVELIN", obj_position.origin );
//	objective_state( objective_number, "current" );
//	Objective_String( objective_number, &"DCBURNING_OBJ_COMMERCE_DEFEND_JAVELIN", level.requiredJavTargets );
//	objective_current( objective_number );
//
//	flag_wait( "obj_commerce_defend_javelin_complete" );
//
//	objective_state( objective_number, "done" );
//}

obj_commerce_defend_javelin_enemies_think()
{
	level endon( "obj_commerce_defend_javelin_complete" );
	self endon( "deleted_through_script" );
	self endon( "killed_by_friendly" );
	self endon( "deleted_through_script" );
	
	flag_wait( "obj_commerce_defend_javelin_given" );
	
	level.crowsArmor = array_add( level.crowsArmor, self );
	self waittill( "death", attacker );

	if ( ( isdefined( attacker ) ) && ( isplayer( attacker ) ) )
	{
		level.lasttimePlayerKilledEnemy = getTime();
		
		if ( !flag( "player_has_killed_at_least_one_javelin_target" ) )
			flag_set( "player_has_killed_at_least_one_javelin_target" );
		
		level.requiredJavTargets = level.requiredJavTargets - 1;
		
		//Objective_String( 4, &"DCBURNING_OBJ_COMMERCE_DEFEND_JAVELIN", level.requiredJavTargets );
		
		if ( level.requiredJavTargets < 3 )
			flag_set( "only_2_javelin_enemies_remaining" );
		if ( level.requiredJavTargets < 2 )
			flag_set( "only_1_javelin_enemies_remaining" );
		if ( level.requiredJavTargets == 0 )
			flag_set( "obj_commerce_defend_javelin_complete" );
	}
	level.crowsArmor = array_remove( level.crowsArmor, self );
	level.crowsArmor = remove_dead_from_array( level.crowsArmor );
}

obj_rooftop()
{
	flag_wait( "obj_rooftop_given" );
	objective_number = 6;

	obj_position = getstruct( "obj_commerce_roof", "targetname" );
	
	objective_add( objective_number, "active", &"DCBURNING_OBJ_ROOFTOP", obj_position.origin );
	objective_current( objective_number );
	//Objective_OnEntity( objective_number, level.teamleader, ( 0, 0, 70 ) );

	flag_wait( "player_roof_stairs_00" );
	obj_position = getstruct( "obj_commerce_roof02", "targetname" );
	Objective_Position( objective_number, obj_position.origin );

	flag_wait( "player_roof_stairs_01" );
	obj_position = getstruct( "obj_commerce_roof03", "targetname" );
	Objective_Position( objective_number, obj_position.origin );

	flag_wait( "player_roof_stairs_02" );
	obj_position = getstruct( "obj_commerce_roof03a", "targetname" );
	Objective_Position( objective_number, obj_position.origin );
	
	flag_wait( "player_outer_balcony_top_commerce" );
	obj_position = getstruct( "obj_commerce_roof03b", "targetname" );
	Objective_Position( objective_number, obj_position.origin );	
	
	flag_wait( "player_headed_to_roof" );
	obj_position = getstruct( "obj_commerce_roof03c", "targetname" );
	Objective_Position( objective_number, obj_position.origin );		

	flag_wait( "player_approach_commerce_roof_01" );
	obj_position = getstruct( "obj_commerce_roof03d", "targetname" );
	Objective_Position( objective_number, obj_position.origin );		
	
	flag_wait( "player_approach_commerce_roof_02" );
	obj_position = getstruct( "obj_commerce_roof04", "targetname" );
	Objective_Position( objective_number, obj_position.origin );		
	
	flag_wait( "obj_rooftop_complete" );

	objective_state( objective_number, "done" );
}

obj_heli_mount()
{
	flag_wait( "obj_rooftop_complete" );
	objective_number = 7;

	//obj_position = getstruct( "obj_commerce_roof", "targetname" );
	obj_org = spawn( "script_origin", ( 0, 0, 0 ) );
	obj_org.origin = level.blackhawk gettagorigin( "tag_player" );
	obj_org linkto( level.blackhawk, "tag_player", ( 0, 0, 25 ), ( 0, 0, 0 ) );
	objective_add( objective_number, "active", &"DCBURNING_OBJ_HELI_MOUNT", obj_org.origin );
	objective_current( objective_number );
	
	while( !flag( "blackhawk_landed" ) )
	{
		objective_position( objective_number, obj_org.origin );
		wait( 0.05 );
	}
	objective_position( objective_number, obj_org.origin );
	
	flag_wait( "obj_heli_mount_complete" );
	
	objective_state( objective_number, "done" );
}

obj_heli_ride()
{
	flag_wait( "obj_heli_ride_given" );
	objective_number = 8;
	
	objective_add( objective_number, "active", &"DCBURNING_OBJ_HELI_RIDE", level.player.origin );
	objective_current( objective_number );

	flag_wait( "obj_heli_ride_complete" );

	//objective_state( objective_number, "done" );
}

/****************************************************************************
    MUSIC
****************************************************************************/ 
AA_music_init()
{
	
}

/****************************************************************************
    UTILITY FUNCTIONS
****************************************************************************/ 
AA_utility()
{

}

AI_think( guy )
{
	if ( guy.team == "axis" )
		guy thread AI_axis_think();

	if ( guy.team == "allies" )
		guy thread AI_allies_think();
}

AI_allies_think()
{

}

AI_axis_think()
{

	/*-----------------------
	IF YOUR ENEMY IS A REDSHIRT, HAVE BETTER ACCURACY
	-------------------------*/
//	self.old_baseaccuracy = self.baseaccuracy;
//	while( isalive( self ) )
//	{
//		self.baseaccuracy = self.old_baseaccuracy;
//		wait( 1 );
//		self waittill( "enemy" );
//		prof_begin( "AI_axis_accuracy" );
//		if( !isdefined( self.enemy ) )
//		{
//			prof_end( "AI_axis_accuracy" );
//			continue;
//		}
//		if ( isplayer( self.enemy ) )
//		{
//			prof_end( "AI_axis_accuracy" );
//			continue;
//		}
//		if ( isdefined( self.enemy.redshirt ) )
//		{
//			self.baseaccuracy = 5000;
//			prof_end( "AI_axis_accuracy" );
//			wait( 1 );
//			
//		}
//	}
}

AI_blood_spatter_when_sniped()
{
	while( isalive( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, impact_org );

		if ( ( isdefined( attacker ) ) && ( isdefined( attacker.classname ) && ( attacker.classname == "misc_turret" ) ) )
		{
			if ( !isdefined( impact_org ) )
				break;
			if ( !isdefined( direction_vec ) )
				direction_vec = ( 0, 0, 1 );
			
			//playfx( getfx( "headshot" ), impact_org, direction_vec );
			playfx( getfx( "thermal_body_gib" ), impact_org );
			//playfx( getfx( "headshot3" ), impact_org );
			//playfx( getfx( "headshot4" ), impact_org );
			//PlayFX( <effect id >, <position of effect>, <forward vector>, <up vector> )
		}
	}
}

ai_no_suppress_think()
{
	self endon( "death" );
	if ( flag( "lav_is_suppressing" ) )
		return;
	self.ignoresuppression = true;
	self.aggressivemode = true;	//dont linger at cover when you cant see your enemy
}

AI_redshirt_think()
{
	self endon( "death" );
	
	if ( !isdefined( self ) ) 
		return;
	self thread try_to_magic_bullet_shield( true );
	self.baseaccuracy = .01;	//lousy shot
	self.attackeraccuracy = 10;	//makes any AI attacking him have super high accuracy
	self.aggressivemode = true;	//dont linger at cover when you cant see your enemy
	/*-----------------------
	KILL REDSHIRT WHEN PLAYER SEES
	-------------------------*/
	attacker = undefined;
	impact_org = undefined;
	
	while( isalive( self ) )
	{
		self waittill( "damage", amount, attacker, enemy_org, impact_org, type, modelName );
		if ( ( isdefined( attacker ) ) && ( isplayer( attacker ) ) )
		{
			continue;
		}
		if ( within_fov( level.player.origin, level.player.angles, self.origin + ( 0, 0, 32 ), level.cosine[ "90" ] ) )
		{
			break;
		}
			
	}
	if( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self kill( impact_org, attacker );
}

try_to_magic_bullet_shield( no_death_detection )
{
	self endon( "death" );
	//make sure he's not in the process of melee
	while( isdefined( self.melee ) )
		wait( .1 );
	self thread magic_bullet_shield( no_death_detection );
}


AI_ignored_and_oblivious_on()
{
	self endon( "death" );
	if ( !isdefined( self ) ) 
		return;
	if ( ( isdefined( self.code_classname ) ) && ( self.code_classname == "script_model" ) )
		return;
	self setFlashbangImmunity( true );
	self.ignoreme = true;
	self.ignoreall = true;
	self.grenadeawareness = 0;
	self setthreatbiasgroup( "oblivious" );
}

AI_ignored_and_oblivious_off()
{
	if ( !isdefined( self ) ) 
		return;
	if ( ( isdefined( self.code_classname ) ) && ( self.code_classname == "script_model" ) )
		return;
	self endon( "death" );
	self setFlashbangImmunity( false );
	self.ignoreme = false;
	self.ignoreall = false;
	self.grenadeawareness = 1;
	self setthreatbiasgroup( "allies" );
}

AI_fixednode_off()
{
	if ( !isdefined( self ) )
		return;
	self.fixednode = false; 
}

AI_fixednode_on()
{
	if ( !isdefined( self ) )
		return;
	self.fixednode = true; 
}
AI_commerce_flare_guys_think()
{
	self endon( "death" );
	self.ignoreme = true;
	self.disableexits = true;
	//self setthreatbiasgroup( "oblivious" );
	self cqb_walk( "on" );
	eNode = getnode( self.target, "targetname" );
	self.goalradius = 16; 
	self setgoalnode( eNode );
	wait( 1 );
	self waittill_either( "goal", "damage" );
	//self setthreatbiasgroup( "axis" );
	self.ignoreme = false;
	self.disableexits = false;
	self thread AI_ambush_behavior();
	temp = [];
	temp[ 0 ] = self;
	thread AI_delete_when_out_of_sight( temp, 512 );
}


AI_jav_sting_spot_think()
{
	/*-----------------------
	SETUP FOR JAVELIN, STINGER AND SPOTTER ENEMIES
	-------------------------*/	
	self endon( "death" );
	self.allowdeath = true;
	self.ignoreme = true;
	self.reference = self.spawner;
	self.sAnimIdleStart = undefined;
	self.sAnimIdle = undefined;
	self.sAnimFire = undefined;
	self.sAnimFireConceal = undefined;
	self.sAnimReload = undefined;
	self.sAnimReact = undefined;
	self.fireAtLiveTargets = false;		//by default, will only fire at script_origins till you tell otherwise
	self.iTargetToggle = 0;			//used to toggle back and forth between scripted "live" targets and default script_origins
	self.fireNodes = undefined;
	self.old_goalradius = self.goalradius;
	self.goalradius = 16;
	aTargets = undefined;
	nextNode = undefined;
	/*-----------------------
	SETUP DEFAULT TARGETS AND SCRIPTED TARGETS
	-------------------------*/	
	if ( isdefined( self.target ) )
	{
		self.grenadeawareness = 0;
		self.ignoreall = true;
		self.fireNodes = [];
		self.fireNodes[ 0 ] = getnode( self.target, "targetname" );
		assertex( isdefined( self.fireNodes[ 0 ] ), "Javelin enemy with export " + self.export + " needs to be targeting a node." );
		aTargets = self.fireNodes[ 0 ] get_linked_ents();
		assertex( isdefined( aTargets ), "Javelin enemy with export " + self.export + " needs to have its first targeted node linked to targets to fire at." );
		iCounter = 1;
		while( true )
		{
			if ( isdefined( self.fireNodes[ iCounter - 1 ].target ) )
			{
				nextNode = getnode( self.fireNodes[ iCounter - 1 ].target, "targetname" );
				self.fireNodes[ iCounter ] = nextNode;
				iCounter++;
			}
			else
				break;
		}
		assertex( self.fireNodes.size >= 3 , "Javelin enemy with export " + self.export + " needs to be targeting a chain of at least 3 cover nodes." );
	}
	else
	{
		aTargets = self get_linked_ents();
		assertex( isdefined( aTargets ), "Javelin enemy with export " + self.export + " needs to be linked to targets to fire at." );
	}
	self.targetsScripted = aTargets;	//vehicles, people, whatever
	self.targetsDefault = [];			//script_origins that are just fired at by default
	foreach( target in aTargets )
	{
		//assertex( !isspawner( target ), "Javelin/Stinger AI with export " + self.export + " is script_Linked to an entity that hasn't spawned yet." );
		if ( target.code_classname == "script_origin" )
		{
			self.targetsScripted = array_remove( self.targetsScripted, target );
			self.targetsDefault = array_add( self.targetsDefault, target );
		}
	}

	/*-----------------------
	ADD SCRIPTED TARGETS TO THE POOL FOR OTHERS TO USE IF THEY RUN OUT
	-------------------------*/	
	if ( self.targetsScripted.size > 0 )
		level.targetsScriptedJavStinger = array_merge( level.targetsScriptedJavStinger, self.targetsScripted );
	
	/*-----------------------
	SETUP ANIMS FOR THIS GUY AND THREAD OFF
	-------------------------*/	
	switch( self.script_noteworthy )
	{
		case "enemy_javelin":
			self gun_remove();
			self get_javelin_anims();
			self thread AI_javelin_think();
			break;
		case "enemy_stinger":
			self get_stinger_anims();
			self thread AI_stinger_think();
			break;
		case "enemy_spotter_prone":
			self gun_remove();
			self.sAnimIdle = "enemy_spotter_prone_idle";
			self.sAnimReact = "enemy_spotter_prone_react";
			//self.deathanim = getAnim_generic( "enemy_spotter_prone_death" );
			self thread AI_spotter_think();
			break;
		case "enemy_spotter_crouched":
			self gun_remove();
			self.sAnimIdle = "enemy_spotter_crouched_idle";
			self.sAnimReact = "enemy_spotter_crouched_react";
			//self.deathanim = getAnim_generic( "enemy_spotter_crouched_death" );
			self thread AI_spotter_think();
			break;
	}
	
}

get_stinger_anims()
{
	self.sAnimIdleStart = "stinger_idle_start";
	self.sAnimIdle = "stinger_idle";
	self.sAnimFire = "stinger_fire";
	self.sAnimReact = "stinger_react_stand";
}

get_javelin_anims()
{
	variation = "";
	if ( self.animation == "javelin_idle_B" )
	{
		variation = "2";
	}
	self.sAnimIdleStart = "javelin_idle_start" + variation;
	self.sAnimIdle = "javelin_idle" + variation;
	self.sAnimFire = "javelin_fire" + variation;
	self.sAnimReact = "javelin_react" + variation;

	self.deathanimIdle = level.scr_anim[ "generic" ][ "javelin_death" + variation ];
	self.deathanimReload = level.scr_anim[ "generic" ][ "javelin_death_reloading" + variation ];
	
	if ( isdefined( self.firenodes ) )
	{
		self.sAnimFire = "javelin_fire_short";
		self.deathanimIdle = level.scr_anim[ "generic" ][ "javelin_death_barrett" ];
		self.deathanimReload = level.scr_anim[ "generic" ][ "javelin_death_barrett" ];
	}
}

AI_stinger_think()
{
	self endon( "death" );
	self thread AI_jav_sting_spot_react();
	self thread AI_jav_sting_spot_death();
	self endon( "alerted" );
	self.reference anim_generic_first_frame( self, self.sAnimIdleStart );
	eTarget = undefined;
	newMissile = undefined;
	stinger_source_org = undefined;
	self attach( "weapon_stinger", "TAG_INHAND", 1 );
	self.stinger = true;

	/*-----------------------
	SHOOT AT TARGETS WHILE ALIVE AND UNALERTED
	-------------------------*/	
	while( isalive( self ) )
	{
		self.reference thread anim_generic_loop( self, self.sAnimIdle, "stop_idle" );
		wait( randomfloatrange( 2, 5 ) );
		self.reference notify( "stop_idle" );
		self.reference thread anim_generic( self, self.sAnimFire );
		self waittillmatch( "single anim", "fire_weapon" );
		eTarget = self AI_jav_sting_get_target();
		if ( isdefined( eTarget ) )
		{
			stinger_source_org = self gettagorigin( "tag_inhand" );
			newMissile = MagicBullet( "stinger", stinger_source_org, eTarget.origin );
			newMissile Missile_SetTargetEnt( eTarget );
		}
		self waittillmatch( "single anim", "end" );
	}
}

AI_jav_sting_spot_death()
{
	self waittill( "death" );
	self endon( "weapon_detached" );
	if ( ( isdefined( self.javelin ) ) && ( !isdefined( self.dk ) ) )
		self waittill_match_or_timeout( "deathanim", "end", 4 );
	if ( !isdefined( self ) )
		return;
	if ( isdefined( self.stinger ) )
	{
		if ( isdefined( self ) )
		{
			self detach( "weapon_stinger", "TAG_INHAND" );
			self.stinger = undefined;
		}
	}
	else if ( isdefined( self.javelin ) )
	{
		if ( isdefined( self ) )
		{
			self detach( "weapon_javelin_sp", "TAG_INHAND" );
			self.javelin = undefined;
		}
	}
}

AI_javelin_think()
{
	self endon( "death" );
	self thread AI_jav_sting_spot_react();
	self thread AI_jav_sting_spot_death();
	self endon( "alerted" );
	javelin_death_nodes = getnodearray( "javelin_death_node", "targetname" );
	if ( !isdefined( self.firenodes ) )
		self.reference anim_generic_first_frame( self, self.sAnimIdleStart );
	eTarget = undefined;
	newMissile = undefined;
	self attach( "weapon_javelin_sp", "TAG_INHAND", 1 );
	self.javelin = true;
	iFireNodeCounter = 0;
	/*-----------------------
	SHOOT AT TARGETS WHILE ALIVE AND UNALERTED
	-------------------------*/	
	while( isalive( self ) )
	{
		if ( isdefined( self.firenodes ) )
		{
			self.deathanim = undefined;
			if ( iFireNodeCounter + 1 > self.firenodes.size )
				iFireNodeCounter = 0;
			self.goalradius = 16;
			
			//retreat and delete, if objective completed
			if ( ( flag( "obj_commerce_defend_snipe_complete" ) ) && ( !isdefined( self.script_parameters ) ) )
			{
				eNode = getClosest( self.origin, javelin_death_nodes );
				self setgoalnode( eNode );
				self waittill( "goal" );
				self delete();
				return;
			}
			self setgoalnode( self.firenodes[ iFireNodeCounter ] );
			self.reference = self.firenodes[ iFireNodeCounter ];
			iFireNodeCounter++;
			self waittill( "goal" );
		}
		if ( ( flag( "obj_commerce_defend_snipe_complete" ) ) && ( isdefined( self.script_parameters ) ) )
		{
			array = [];
			array[ 0 ] = self;
			thread AI_delete_when_out_of_sight( array, 512 );
		}
		self.reference thread anim_generic_loop( self, self.sAnimIdle, "stop_idle" );
		self.deathanim = self.deathanimIdle;
		if ( isdefined( self.firenodes ) )
		{
			wait( .25 );
		}
		else
		{
			wait( randomfloatrange( 2, 7 ) );
		}
		self.reference notify( "stop_idle" );
		self thread anim_generic( self, self.sAnimFire );
		self waittillmatch( "single anim", "fire_weapon" );
		eTarget = self AI_jav_sting_get_target();
		if ( isdefined( eTarget ) )
		{
			newMissile = MagicBullet( "javelin_dcburn", self gettagorigin( "tag_inhand" ), eTarget.origin );
			playfxontag( getfx( "javelin_muzzle" ), self, "TAG_FLASH" );
			newMissile Missile_SetTargetEnt( eTarget );
			newMissile Missile_SetFlightmodeTop();
		}
		self waittillmatch( "single anim", "end" );
	}
}

AI_jav_sting_get_target()
{
	self endon( "death" );
	self endon( "alerted" );
	
	self.targetsScripted = remove_dead_targets_from_array( self.targetsScripted );
	level.targetsScriptedJavStinger = remove_dead_targets_from_array( level.targetsScriptedJavStinger );
	
	eTarget = undefined;
	/*-----------------------
	TOGGLE BACK AND FORTH BETWEEN SCRIPTED AND DEFAULT TARGETS...UNLESS HARDENED/VETERAN
	-------------------------*/	
	//if ( ( level.gameskill == 2 ) || ( level.gameskill == 3 ) )
		//self.iTargetToggle = 1;		//always fire at live targets
	
	/*-----------------------
	FIRE AT SCRIPTED SCRIPTED TARGETS
	-------------------------*/	
	if ( ( self.iTargetToggle == 1 ) && ( self.fireAtLiveTargets == true ) )
	{
		//try to fire at my own scripted targets
		if ( self.targetsScripted.size > 0 )
		{
			eTarget = self.targetsScripted[ randomint ( self.targetsScripted.size ) ];
		}
		
		//if no more targets, fire at the pool of targets available
		else if ( level.targetsScriptedJavStinger.size > 0 )
		{
			eTarget = level.targetsScriptedJavStinger[ randomint ( level.targetsScriptedJavStinger.size ) ];
		}
		//if no more scripted or level targets, fire at default
		else
		{
			eTarget = self.targetsDefault[ randomint ( self.targetsDefault.size ) ];
		}
		self.iTargetToggle = 0;
	}
	/*-----------------------
	OR FIRE AT DEFAULT NULL TARGETS
	-------------------------*/	
	else
	{
		eTarget = self.targetsDefault[ randomint ( self.targetsDefault.size ) ];
		self.iTargetToggle = 1;
	}
	
	return eTarget;
}

AI_spotter_think()
{
	self endon( "death" );
	self thread AI_jav_sting_spot_react();
	self endon( "alerted" );
	self.reference anim_generic_loop( self, self.sAnimIdle, "stop_idle" );
}

AI_jav_sting_spot_react()
{

	if ( ( isdefined( self.team ) ) && ( self.team == "allies" ) )
		return;
	self endon( "death" );
	self waittill( "alerted" );
	self.goalradius = self.old_goalradius;
	
	//get stinger reaction anim depending on pose
	if( isdefined( self.stinger ) )
	{
		if ( ( isdefined( self.a.pose ) ) && ( self.a.pose == "crouch" ) )
			self.sAnimReact = "stinger_react_crouch";
	}
	if ( isdefined( self.reference ) )
		self.reference notify( "stop_idle" );
	self notify( "stop_idle" );
	self anim_stopanimscripted();
	anim_generic( self, self.sAnimReact );
	self.deathanim = undefined;	//reset after reaction complete
	
	if ( isdefined( self.stinger ) )
	{
		self detach( "weapon_stinger", "TAG_INHAND" );
		self notify( "weapon_detached" );
		self.stinger = undefined;
	}
	else if ( isdefined( self.javelin ) )
	{
		self detach( "weapon_javelin_sp", "TAG_INHAND" );
		self notify( "weapon_detached" );
		self.javelin = undefined;
	}
	self gun_recall();
}

AI_become_alerted()
{
	self endon( "death" );
	if ( ( isdefined( self ) ) && ( isalive( self ) ) && ( !isdefined( self.scriptedDying ) ) ) 
	{
		self notify( "alerted" );
		wait( 1 );
		self.ignoreme = false;
	}
}

AI_waittill_damaged_and_set_flag_think()
{
	self endon( "death" );
	level endon( self.script_flag );
	if ( !flag_exist( self.script_flag ) )
		flag_init( self.script_flag );
	while( isalive( self ) )
	{
		if( flag( self.script_flag ) )
			break;
		self waittill( "damage" );
		if( !flag( self.script_flag ) )
		{
			flag_set( self.script_flag );
			break;
		}
	}
}

//AI_try_to_hang_and_die_near_player( death_nodes )
//{
//	self endon( "death" );
//	self.goalradius = 1024;
//	eNode = undefined;
//	/*-----------------------
//	TRY TO HANG AROUND NEAR THE PLAYER SO HE CAN SEE YOUR ASS DIE
//	-------------------------*/	
//	while( isdefined( self ) )
//	{
//		eNode = getclosest( level.player.origin, death_nodes );
//		self setgoalnode( eNode );
//		wait( 4 );
//	}
//}


//AI_player_distance_monitor()
//{
//	self endon( "death" );
//	self endon( "alerted" );
//	while( isdefined( self ) )
//	{
//		wait( 1 );
//		if ( !within_fov( self.origin, self.angles, level.player.origin + ( 0, 0, 32), level.cosine[ "45" ] ) )
//			continue;
//		if ( !sighttracepassed( self.origin + ( 0, 0, 32 ), level.player.origin + ( 0, 0, 32 ), false, self ) )
//			continue;
//		if ( distancesquared( self.origin, level.player.origin ) < level.stealthDistanceSquared )
//			break;
//	}
//	self thread AI_become_alerted();
//
//}
	

AI_drone_think()
{
	self endon( "death" );
	self thread AI_ragdoll( true );
	self endon( "stop_default_drone_mi" );
	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "drone_warrior_fodder" ) )
	{
		self.nocorpsedelete = true;
	}
	
	if( isdefined( self.nocorpsedelete ) )
		self thread AI_drone_corpse_delete();
	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "ai_ambient" ) )
	{
		self.dontDoNotetracks = true;	//allows using of ai _anim functons without getting errors
		self.script_looping = 0;		//will force drone to scip default idle behavior
	}
	
	self waittill( "goal" );
	if ( isdefined( self.script_noteworthy ) )
	{
		switch( self.script_noteworthy )
		{
			case "death_by_mortar":
				self thread AI_drone_mortar_death();
				break;
			case "drone_warrior":
				self thread AI_drone_warrior_think();
				break;
			case "drone_warrior_fodder":
				self thread AI_drone_warrior_fodder_think();
				break;
			default:
				self delete();
		}
	}
	else
		self delete();
}

AI_drone_corpse_delete()
{
	if ( !isdefined( self ) )
		return;
	
	self thread maps\_drone::drone_drop_real_weapon_on_death();
	self waittill( "death" );
	
	wait( 10 );
	
	while ( isdefined( self ) )
	{
		if ( !within_fov( level.player geteye(), level.player getPlayerAngles(), self.origin, level.cosine[ "90" ] ) )
			break;
		wait( 5 );
	}
	
	if ( isdefined( self ) )
		self delete();
}


AI_drone_warrior_think()
{
	
}

AI_drone_warrior_fodder_think()
{
	self endon( "death" );
	trigger_origin = self.origin;
	trigger_height = 100;
	trigger_spawnflags = 0;// player only
	trigger = undefined;
	if ( cointoss() )
	{
		trigger_radius = 720;
		trigger = spawn( "trigger_radius", trigger_origin, trigger_spawnflags, trigger_radius, trigger_height );
		self thread AI_drone_mortar_death( trigger );
	}
	else
	{
		trigger_radius = randomintrange( 400, 512 );
		trigger = spawn( "trigger_radius", trigger_origin, trigger_spawnflags, trigger_radius, trigger_height );
		self thread AI_drone_headshot_death( trigger );
	}
		
}

AI_drone_headshot_death( trigger )
{
	self endon( "death" );
	
	if( isdefined( trigger ) )
		trigger waittill( "trigger" );
		
	origin = random( level.sniperOrgs ).origin;
	
	thread play_sound_in_space( "weap_deserteagle_fire_npc", self.origin );
	thread play_sound_in_space( "bullet_large_flesh", self.origin );
	headOrigin = self gettagorigin( "tag_eye" );
	vec = vectornormalize( headOrigin - origin );
	PlayFX( getfx( "headshot" ), headOrigin, vec );
	PlayFXOnTag( getfx( "bodyshot" ), self, "tag_eye" );
	//magicbullet( "m14_scoped", origin, headOrigin );
	//bullettracer( origin, headOrigin, true );
	self notify( "stop_drone_fighting" );
	if ( cointoss() )
		thread play_sound_in_space( "generic_death_american_1", self.origin );
	self kill();
}

AI_drone_mortar_death( trigger )
{
	self endon( "death" );

	if( isdefined( trigger ) )
		trigger waittill( "trigger" );
	
	if ( !level.onHeli )
		play_sound_in_space( "mortar_incoming", self.origin );
	thread ambient_mortar_explosion( self.origin );
	self notify( "stop_drone_fighting" );
	if ( cointoss() )
		thread play_sound_in_space( "generic_death_american_1", self.origin );
	
	
	//Pick a death anim....either the mortar-specific ones or just the default deathanim
	if ( !isdefined( self.animset ) )
	{
		sAnim = level.scr_anim[ "generic" ][ "deathanim_mortar_0" + randomint( 2 ) ];	//random between fall to knees and blowback
	}
	else if ( ( isSubStr( self.animset, "stand" ) ) || ( isSubStr( self.animset, "crouch" ) ) )
	{
		sAnim = level.scr_anim[ "generic" ][ "deathanim_mortar_01" ];	//don't do fall to knees anim if against a wall...will clip through
	}
	else
	{
		sAnim = level.scr_anim[ "generic" ][ "deathanim_mortar_0" + randomint( 2 ) ];	//random between fall to knees and blowback
	}
	
	if ( isdefined( self.deathanim ) )
	{
		if ( cointoss() )
			sAnim = self.deathanim;
	}
	
	self.deathanim = sAnim;
	self kill();
}

AI_ragdoll( bIsDrone )
{
	self waittill( "death", attacker, cause );

	if ( !isdefined( attacker ) )
		return;

	if ( ( isdefined( attacker.targetname ) ) && ( attacker.targetname == "heli_player" ) && ( flag( "player_on_minigun" ) ) )
	{
		self.skipDeathAnim = true;
		if ( ( isdefined( bIsDrone ) ) && ( bIsDrone == true ) )
			arcadeMode_kill( self.origin, "explosive", 50 );
	}
}

AI_ambient_combat_think()
{
	self.ignoreme = true;
	self.goalradius = 16;
	self thread magic_bullet_shield();
	self.battlechatter = true;
}

initPrecache()
{
	precacherumble( "crash_heli_rumble" );
	PreCacheItem( "missile_attackheli_dcburn" );
	PreCacheModel( "ch_viewhands_gk_ump9" );
	PreCacheItem( "slamraam_missile_dcburning" );
	precacheModel( "vehicle_slamraam_destroyed" );
	precacheModel( "vehicle_bradley_destroyed" );
	precacheModel( "mil_mre_chocolate01" );
	precacheModel( "weapon_binocular" );
	PreCacheItem( "slamraam_missile_dcburning" );
	precacheModel( "weapon_bullet_02" );
	precacheModel( "weapon_m82_MG_Setup_obj" );
	preCacheModel( "projectile_cbu97_clusterbomb" );
	preCacheModel( "weapon_m4m203_acog" );
	precacheModel( "weapon_stinger" );
	precacheModel( "weapon_javelin_sp" );
	
	precacheshader( "splatter" );
	//precacheShader( "waypoint_targetneutral" );
	precacheModel( "com_blackhawk_spotlight_on_mg_setup" );
	precachestring( &"DCBURNING_INFO_EVAC_SITE_HEALTH" );
	precachestring( &"DCBURNING_OBJ_COMMERCE" );
	precachestring( &"DCBURNING_OBJ_ROOFTOP" );
	precachestring( &"DCBURNING_OBJ_HELI_RIDE" );
	precachestring( &"DCBURNING_OBJ_LINCOLN" );
	precachestring( &"DCBURNINGINFO_EVAC_SITE_HEALTH" );
	precachestring( &"DCBURNING_MISSIONFAIL_LEFT_CHOPPER" );
	//precachestring( &"DCBURNING_SWITCH_HEARTBEAT" );
	precachestring( &"DCBURNING_RAN_OUT_OF_TIME" );
	precachestring( &"DCBURNING_TIME_REMAINING" );
	


	//precacheShader( "white" );
	//precacheShader( "black" );
	precachemodel( "adrenaline_syringe_animated" );
	precachemodel( "clotting_powder_animated" );
	precachemodel( "com_folding_chair" );
	precachemodel( "com_laptop_rugged_open" );
	precachemodel( "vehicle_mack_truck_short_destroy" );
	precachemodel( "vehicle_uaz_fabric_dsr" );
	precachemodel( "vehicle_luxurysedan_2008_destroy" );
	precachemodel( "vehicle_pickup_technical_destroyed" );
	precacheItem( "javelin_dcburn" );
	precacheItem( "javelin_noimpact" );
	PreCacheItem( "stinger" );
}

init_difficulty()
{

	level.friendlyArmorTargets = undefined;
	level.requiredJavTargets = undefined;
	switch( level.gameSkill )
	{
		case 0:// easy
			level.requiredJavTargets = 3;
			level.friendlyArmorTargets = 1;
			break;
		case 1:// regular
			level.requiredJavTargets = 4;
			level.friendlyArmorTargets = 1;
			break;
		case 2:// hardened
			level.requiredJavTargets = 4;
			level.friendlyArmorTargets = 1;
			break;
		case 3:// veteran
			level.requiredJavTargets = 4;
			level.friendlyArmorTargets = 1;
			break;
	}
	flag_set( "difficulty_initialized" );
}


disable_color_trigs()
{
	array_thread( level.aColornodeTriggers, ::trigger_off );
}



fluorescentFlicker()
{
	for ( ;; )
	{
		wait( randomfloatrange( .05, .1 ) );
		
		self setLightIntensity( randomfloatrange( 1, 1.5 ) );
	}
}

fluorescentFlickerBig()
{
	for ( ;; )
	{
		wait( randomfloatrange( .05, .1 ) );
		
		self setLightIntensity( randomfloatrange( 0.8, 1.1 ) );
	}
}

emergencyStrobe()
{
	for ( ;; )
	{
		self setLightIntensity( 0 );
		
		wait 1;
		
		self setLightIntensity( 1.4 );
		
		wait .1;
	}
}

lights()
{
	fires = getentarray( "firelight_flicker", "targetname" );
	array_thread( fires,::flicker_fire );
	
	flares = getentarray( "flickerlight1", "targetname" );
	foreach( flare in flares )
		flare thread flareFlicker();
		
	fluorescents = getentarray( "fluorescentFlicker", "targetname" );
	foreach( fluorescent in fluorescents )
		fluorescent thread fluorescentFlicker();

	fluorescents = getentarray( "fluorescentFlickerBig", "targetname" );
	foreach( fluorescent in fluorescents )
		fluorescent thread fluorescentFlickerBig();
		

	strobes = getentarray( "strobe1", "targetname" );
	foreach( strobe in strobes )
		strobe thread emergencyStrobe();
}



initFriendlies( sStartPoint, bDontSpawnFriendlies, bWarpPlayer )
{
	if ( !isdefined( bWarpPlayer ) )
		bWarpPlayer = true;
	
	if ( !isdefined( bDontSpawnFriendlies ) )
		bDontSpawnFriendlies = false;
		
	waittillframeend;
	assert( isdefined( sStartPoint ) );

	/*-----------------------																								
	SPAWN KEY FRIENDLIES
	-------------------------*/		
	if ( ( isdefined( bDontSpawnFriendlies ) ) && ( bDontSpawnFriendlies != true ) )
	{
		level.squad = [];
		level.teamleader = spawn_targetname( "teamLeader" );
		level.friendly02 = spawn_targetname( "friendly02" );
		level.friendly03 = spawn_targetname( "friendly03" );
		level.squad[ 0 ] = level.teamleader;
		level.squad[ 1 ] = level.friendly02;
		level.squad[ 2 ] = level.friendly03;
		array_thread( level.squad, :: friendly_squad_think );
		level.excludedAi = [];
		level.excludedAi[ 0 ] = level.teamleader;
	}
	
	level.mortarExcluders = level.squad;

	/*-----------------------
	END HERE IF THIS IS THE BUNKER
	-------------------------*/	
	if ( sStartPoint == "Bunker" )
		return;
	
	/*-----------------------
	TELEPORT PLAYERS
	-------------------------*/	
	if ( ( isdefined( bWarpPlayer ) ) && ( bWarpPlayer == true ) )
	{
		aPlayerNodes = getnodearray( "playerStart" + sStartPoint, "targetname" );
		teleport_players( aPlayerNodes );
	}
	
	
	/*-----------------------
	TELEPORT FRIENDLIES
	-------------------------*/
	aFriendlies = level.squad;
	warpNodes = getnodearray( "friendlyStart" + sStartPoint, "targetname" );
	assertEx( warpNodes.size == 3, "Need exactly 3 nodes with targetname: nodeStart" + sStartPoint );
	while ( aFriendlies.size > 0 )
	{
		wait( 0.05 );
		for ( i = 0;i < warpNodes.size;i++ )
		{
			if ( isdefined( warpNodes[ i ].script_noteworthy ) )
			{
				switch( warpNodes[ i ].script_noteworthy )
				{
					case "nodeLeader":
						level.teamleader teleport_ai( warpNodes[ i ] );
						aFriendlies = array_remove( aFriendlies, level.teamleader );
						warpNodes = array_remove( warpNodes, warpNodes[ i ] );
						break;
					case "nodeFriendly02":
						level.friendly02 teleport_ai( warpNodes[ i ] );
						aFriendlies = array_remove( aFriendlies, level.friendly02 );
						warpNodes = array_remove( warpNodes, warpNodes[ i ] );
						break;
					case "nodeFriendly03":
						level.friendly03 teleport_ai( warpNodes[ i ] );
						aFriendlies = array_remove( aFriendlies, level.friendly03 );
						warpNodes = array_remove( warpNodes, warpNodes[ i ] );
						break;
					default:
						assertmsg( "node has invalid name for initFriendlies() function: " + warpNodes[ i ].script_noteworthy );
						break;
				}
			}
		}
	}
}

friendly_squad_think()
{
	self.animname = "generic";
	if ( ( self == level.teamleader )	|| ( self == level.friendly02 ) )
	{
		self thread magic_bullet_shield();
		self setFlashbangImmunity( true );
	}
}

AI_squad_fixed_node_interior()
{
	level.fixednodesaferadius_default = 128;
	foreach( guy in level.squad )
	{
		if( isdefined( self ) )
			self.fixedNodeSafeRadius = level.fixednodesaferadius_default;
	}
}

AI_squad_fixed_node_default()
{
	level.fixednodesaferadius_default = undefined;
	foreach( guy in level.squad )
	{
		if( isdefined( self ) )
			self.fixedNodeSafeRadius = 64;
	}
}

vehicle_heli_land( eNode )
{
	self endon( "death" );
	eNode waittill( "trigger" );
	self notify( "landing" );
	self vehicle_detachfrompath();
	self setgoalyaw( eNode.angles[ 1 ] );
	vehicle_land_beneath_node( undefined, eNode );
	self notify( "landed" );
}


heli_cargo_liftoff_and_go()
{
	//Self ==> a spawned helicopter
	// NOTE: spawned heli needs to have a script_noteworthy that matches the script_noteworthy of a path struct that it will attach to after liftoff
	
	assertex( isdefined( self.script_noteworthy ), "Heli at " + self.origin + " needs to have a script_noteworthy that matches the script_noteworthy of the path you will attach it to." );
	ePath = getstruct( self.script_noteworthy, "script_noteworthy" );
	assertex( isdefined( ePath ), "Heli at " + self.origin + " needs to have a script_noteworthy that matches the script_noteworthy of the path you will attach it to." );
	dist = distance( self.origin, ePath.origin );
	self vehicle_liftoff( dist );
	//self cleargoalyaw();
	//self Vehicle_SetSpeed( 30, 10, 10 );
	//self sethoverparams( 32, 10, 3 );
	//self setmaxpitchroll( 5, 10 );
	self thread vehicle_paths( ePath );
}

heli_teleport_to_newpath( sSpawnerTargetname, eNode )
{
	// self ==> the spawned heli you will delete and respawn
	self vehicle_delete();
	assertex( isdefined( eNode.targetname ), "The node you are respawning the heli at needs to have a targetname." );
	spawner = getvehiclespawner( sSpawnerTargetname );
	assertex( isdefined( spawner ), "No helicopter spawner with the targetname: " + sSpawnerTargetname );
	spawner.target = eNode.targetname;
	spawner.origin = eNode.origin;
	if ( isdefined( eNode.angles ) )
		spawner.angles = ( eNode.angles[ 0 ], eNode.angles[ 1 ], spawner.angles[ 2 ] ); 
	eHeli = spawn_vehicle_from_targetname( sSpawnerTargetname );
	eHeli thread vehicle_paths( eNode );
	eHeli vehicle_ai_event( "idle_alert_to_casual" );
	return eHeli;
	
}

vehicle_think()
{
	if ( ( getdvar( "dc_debug" ) == "1" ) && ( isdefined( self.spawner.targetname ) ) )
		self thread debug_message( self.spawner.targetname , self.origin, 9999, self );
	
	if ( self maps\_vehicle::isCheap() )
	{
		self thread maps\_vehicle::friendlyfire_shield();
	}
	
	switch( self.vehicletype )
    {
		case "humvee":
		case "hummer_minigun":
		case "hummer":
   			self thread vehicle_humvee_think();
    		break;
    	case "mi17":
    		self thread vehicle_mi17_think();
    		break;
    	case "littlebird":
    		self thread vehicle_littlebird_think();
			break;
    	case "m1a1":
    		self thread vehicle_m1a1_think();
    		break;
    	case "btr80":
    		self thread vehicle_btr80_think();
    		break;
    	case "cobra":
    		self thread vehicle_cobra_think();
    		break;
     	case "mi28":
     		self thread vehicle_mi28_think();
    		break;
    	case "slamraam":
    		self thread vehicle_slamraam_think();
    		break;
    }
}

vehicle_slamraam_think()
{
	self endon( "death" );
	self setturrettargetent( level.player );
	foreach( tag in self.missileTags )
	{
		self attach( self.missileModel, tag );
	}
	self.hitsRemaining = 3;
	self thread vehicle_damage_think();
	eMissile = undefined;
	tag = undefined;
	targetOrg = level.player;
	while ( ( isdefined( self ) ) && ( self.missileTags.size > 0 ) )
	{
		self waittill( "fire" );
		tag = random( self.missileTags );
		self.missileTags = array_remove( self.missileTags, tag );
		self detach( self.missileModel, tag );
		eMissile = magicBullet( "slamraam_missile_dcburning", self gettagorigin( tag ), targetOrg.origin );
		if ( self.missileTags.size < 1 ) 
			break;
	}
	self clearturrettarget();
}

custom_rumble()
{
	org = spawn( "script_origin", self.origin + ( 0, 0, 0 ) );
	org linkto( self );
	while( isdefined( self ) )
	{
		org PlayRumbleOnEntity( "crash_heli_rumble" );
		wait( .4 );
	}
	org delete();
}

vehicle_mi28_think()
{
	//self setyawspeed( 90, 30, 20 );
	self setmaxpitchroll( 20, 40 );
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "custom_rumble" ) )
	{
		self thread custom_rumble();
	}
	if ( ( isdefined( self.targetname ) ) && ( isSubStr( self.targetname, "ambient" ) ) )
	{
		self thread vehicle_ambient_heli_think();
		return;
	}
	self.firingMissiles = false;
	self.enableRocketDeath = true;
	self.defaultWeapon = "havoc_turret";
	self.hitsRemaining = 3;
	self thread maps\_attack_heli::heli_default_missiles_on( "missile_attackheli_dcburn" );
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "ambient" ) )
	{
		//do ambient vehicle stuff
	}
	else if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "ambient_attacker" ) )
	{
		//self thread vehicle_turret_think();
	}
	else
	{
		target_set( self, ( 0, 0, -80 ) );
		target_setJavelinOnly( self, true );
		//Target_SetAttackMode( self, "direct" );
		//Target_SetAttackMode( self, "top" );
	}
	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "regular" ) )
		return;
		
	self thread vehicle_damage_think();
}

vehicle_ambient_heli_think()
{
	self.firingMissiles = false;
	self.defaultWeapon = "havoc_turret";
	self thread maps\_attack_heli::heli_default_missiles_on( "missile_attackheli_dcburn" );
}

vehicle_humvee_think()
{
	self endon( "death" );

}

vehicle_mi17_think()
{
	self endon( "death" );
}

vehicle_littlebird_think()
{
	self endon( "death" );
	self maps\_vehicle::godon();
	if ( self.classname == "script_vehicle_littlebird_armed" )
	{
		self thread maps\_attack_heli::heli_default_missiles_on( "missile_attackheli_dcburn" );
		waittillframeend;
		foreach ( turret in self.mgturret )
		{
			turret SetMode( "manual" );
			turret StopFiring();
		}
	}
}

vehicle_delete()
{
	if ( !isdefined( self ) )
		return;
	self endon ( "death" );
	//cleanly delete riders even if magic_bullet_shielded
	if ( ( isdefined( self.riders ) ) && ( self.riders.size ) )
		array_thread( self.riders, ::AI_delete );
	
	//delete any attached turrets
	if ( isdefined( self.mgturret ) )
	{
		foreach( turret in self.mgturret )
		{
			if ( isdefined( turret ) )
				turret delete();
		}

	}
	self maps\_vehicle::godoff();
	self delete();
}

vehicle_m1a1_think()
{
	self endon( "death" );
}

vehicle_btr80_think()
{
	if ( ( isdefined( self.targetname ) ) && ( self.targetname == "btr80s_end" ) )
		return;
		
	self.hitsRemaining = 3;
	//self SetDeceleration( 1 );
	target_set( self, ( 0, 0, 0 ) );
	target_setJavelinOnly( self, true );
	Target_SetAttackMode( self, "top" );
	self thread vehicle_damage_think();
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "no_ai" ) )
		return;
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "crows_nest_bmps" ) )
		return;
	if ( !level.onHeli )
		return;
	else
	{
		self thread vehicle_turret_think();
	}
}

vehicle_cobra_think()
{
	self endon( "death" );
}

vehicle_bm21_troops_think()
{
	self endon( "death" );
}

vehicle_damage_think()
{
	self endon( "death" );
	self maps\_vehicle::godon();
	attacker = undefined;
	killedByPlayerJavelin = undefined;
	while ( isdefined( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if ( !isdefined( attacker ) )
			continue;
		if ( IsString( attacker ) )
			continue;
		if ( ( isdefined( attacker.code_classname ) ) && ( attacker.code_classname == "misc_turret" ) )			//don't blow up if using barrett
			continue;
		if ( ( isdefined( attacker.script_team ) ) && ( attacker.script_team == "axis" ) )
			continue;
		if ( ( isdefined( attacker.team ) ) && ( attacker.team == "axis" ) )
			continue;
		if ( ( isdefined( level.blackhawk ) ) && ( attacker == level.blackhawk ) )
		{
			if( isdefined( self.immuneToBlackhawk ) )
				continue;
			assertex( isdefined( self.hitsRemaining ), "Need to have 'self.hitsRemaining' defined for vehicles for heli ride!" );
			self.hitsRemaining--;
			if ( self.hitsRemaining <= 0 )
				break;
			else
				continue;
		}
		if ( !isdefined( type ) )
			continue;
		if ( ( type == "MOD_PROJECTILE" ) && ( amount > 399 ) )
		{
			if ( isplayer( attacker ) )
			{
				killedByPlayerJavelin = true;
			}
			break;
		}
			
	}
	
	if ( ( isdefined( level.blackhawk ) ) && ( attacker == level.blackhawk ) )
	{
		//
	}
	else if ( !isplayer( attacker ) )
	{
		self notify( "killed_by_friendly" );
		if ( getdvar( "dc_debug" ) == "1" )
			iprintlnbold( "friendly just owned a vehicle" );
		level.friendlyArmorTargets--;
		//assertex( level.friendlyArmorTargets > -1, "Friendlies have killed more vehicles than they should have" );
		thread friendly_crows_help_cooldown();
	}
	
	self thread vehicle_death( killedByPlayerJavelin );
}

vehicle_turret_think()
{
	self endon( "death" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;
	while ( isdefined( self ) )
	{
		if ( level.player.ignoreme )
		{
			wait ( 1 );
			continue;
		}
		wait( 0.05 );
		/*-----------------------
		DISTANCE CHECK TO PLAYER
		-------------------------*/	
		if ( distancesquared( level.player.origin, self.origin ) > level.CannonRangeSquared )
			eTarget = undefined;
		else
			eTarget = level.player;

		/*-----------------------
		IF CURRENT IS PLAYER, DO SIGHT TRACE
		-------------------------*/		
		if ( ( isdefined( eTarget ) ) && ( isplayer( eTarget ) ) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 0 ), false, self );
			/*-----------------------
			IF CURRENT IS PLAYER BUT CAN'T SEE HIM, GET ANOTHER TARGET
			-------------------------*/		
			if ( !sightTracePassed )
			{
				eTarget = undefined;
			}
		}

		/*-----------------------
		IF PLAYER ISN'T CURRENT TARGET, GET ANOTHER
		-------------------------*/	
		if ( !isdefined( eTarget ) )
			eTarget = self vehicle_get_target();


		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( ( isdefined( eTarget ) ) && ( isalive( eTarget ) ) )
		{
			targetLoc = eTarget.origin + ( 0, 0, 32 );
			self setTurretTargetVec( targetLoc );
			fRand = ( randomfloatrange( 2, 3 ) );
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON IF WITHIN **PLAYER** FOV (NO CHEAP SHOTS)
			-------------------------*/
			if ( ( isdefined( eTarget ) ) && ( isplayer( eTarget ) ) )
			{
				playerEye = level.player getEye();
				bInFOV = within_fov( playerEye, level.blackhawk.angles + ( 0, -90, 0 ), self.origin, level.cosine[ "45" ] );
				if ( bInFOV )
				{
					if ( !self.turretFiring )
						self thread vehicle_fire_main_cannon();
				}

			}
			if ( ( isdefined( eTarget ) ) && ( !isplayer( eTarget ) ) )
			{
				if ( !self.turretFiring )
					self thread vehicle_fire_main_cannon();
			}

		}
	}
}



vehicle_fire_main_cannon()
{
	self endon( "death" );
	iFireTime = undefined;
	iBurstNumber = undefined;
	
	switch( self.vehicletype )
	{

		case "btr80":
			iFireTime = .5;
			//iFireTime = weaponfiretime( "bmp_turret" );
			iBurstNumber = randomintrange( 3, 6 );
			break;
		default:
			assertmsg( "need to define a case statement for " + self.vehicletype );
	}

	assert( isdefined( iFireTime ) );
	self.turretFiring = true;
	i = 0;
	while ( i < iBurstNumber )
	{
		i++ ;
		wait( iFireTime );
		self fireWeapon();
	}
	self.turretFiring = false;
}


friendly_crows_help_cooldown()
{
	//If friendly just owned a vehicle, cool down a bit before letting him kill another one
	if ( flag( "obj_commerce_defend_javelin_complete" ) )
	{
		level.friendliesCanHelpCrowsnest = undefined;
		return;
	}
		
	self notify( "cooldown_started" );
	self endon( "cooldown_started" );
	level.friendliesCanHelpCrowsnest = false;
	wait( 10 );
	level.friendliesCanHelpCrowsnest = true;
}


vehicle_death( killedByPlayerJavelin )
{
	if ( !level.onHeli )
	{
		if ( Target_IsTarget( self ) )
			Target_Remove( self );
	}
		
	self maps\_vehicle::godoff();
	self notify( "death", level.player, "MOD_PROJECTILE" );
	if ( isdefined( killedByPlayerJavelin ) )
	{
		earthquake( 0.25, 0.75, level.player.origin, 1250 );
		level.player PlayRumbleOnEntity( "damage_light" );
	}
}

ai_ambient_prop_think()
{
	self endon( "death" );
	eProp = getent( self.target, "targetname" ); 
	self thread delete_on_death( eProp );
	sAnim = self.animation;
	assert( isdefined( eProp ) );
	assert( isdefined( sAnim ) );
	self.eAnimEnt = spawn( "script_origin", eProp.origin );
	self thread delete_on_death( self.eAnimEnt );
	sFailSafeFlag = undefined;
	
	switch( eProp.model )
	{
		case "com_folding_table":
			if ( isdefined( self.script_parameters ) )
			{
				self.eAnimEnt.origin = self.eAnimEnt.origin + ( 0, -40, 0 );
			}
			self.eAnimEnt.angles = eProp.angles + ( 0, 0, 0 );
			self.eAnimEnt anim_generic_first_frame( self, sAnim + "_start" );
			laptop = spawn( "script_model", self.origin );
			laptop setmodel( "weapon_uav_control_unit" );
			self thread delete_on_death( laptop );
			laptop.angles = self.angles + ( 0, 0, 0 );
			ent = spawnstruct();
			ent.entity = laptop;
			ent.forward = 23;
			ent.up = 33.5;
			ent.right = 1;
			ent.yaw = 0;
			ent translate_local();
			chair = spawn( "script_model", self.origin );
			chair setmodel( "com_folding_chair" );
			chair.angles = self.angles + ( 0, 0, 0 );
			self thread delete_on_death( chair );
			ent = spawnstruct();
			ent.entity = chair;
			ent.forward = -5;
			ent translate_local();
			if ( sAnim == "laptop_officer_idle" )
			{
				chair delete();
				laptop delete();
			}
			break;
		case "mil_bunker_bed2":
			self gun_remove();
			self.eAnimEnt.angles = eProp.angles + ( 0, 90, 0 );
			ent = spawnstruct();
			ent.entity = self.eAnimEnt;
			ent.up = 28;
			ent translate_local();
			self.eAnimEnt anim_generic_first_frame( self, sAnim + "_start" );
			break;
		case "bc_cot":
			self gun_remove();
			ent = spawnstruct();
			ent.entity = self.eAnimEnt;
			if ( ( sAnim == "cargoship_sleeping_guy_idle_1" ) || ( sAnim == "cargoship_sleeping_guy_idle_2" ) )
			{
				ent.up = 22;
				ent.yaw = 180;
				ent.forward = 4;
				ent translate_local();
			}
			else if ( sAnim == "afgan_caves_sleeping_guard_idle" ) 
			{
				//ent.up = 0;
				ent.yaw = 180;
				//ent.forward = 0;
				ent translate_local();
			}
			else if ( ( sAnim == "DC_Burning_CPR_wounded" ) || ( sAnim == "DC_Burning_CPR_medic" ) )
			{
				sFailSafeFlag = "player_bunker_walk_01";
				ent.yaw = 195;
				ent translate_local();
			}
			else
			{
				ent.yaw = 90;
				ent translate_local();
			}
			break;
		case "stretcher_animated":
			self gun_remove();
			self.eAnimEnt.angles = eProp.angles + ( 0, 90, 0 );
			ent = spawnstruct();
			ent.entity = self.eAnimEnt;
			ent.up = -1;
			ent translate_local();
			self.eAnimEnt anim_generic_first_frame( self, sAnim + "_start" );
			break;
		case "bc_stretcher":
			self gun_remove();
			self.eAnimEnt.angles = eProp.angles + ( 0, 0, 0 );
			if ( sAnim == "afgan_caves_sleeping_guard_idle" ) 
			{
				ent = spawnstruct();
				ent.entity = self.eAnimEnt;
				ent.up = -12;
				//ent.yaw = 180;
				ent.right = 2;
				ent translate_local();
			}
			else
			{
				ent = spawnstruct();
				ent.entity = self.eAnimEnt;
				ent.up = 8;
				ent translate_local();
			}
			self.eAnimEnt anim_generic_first_frame( self, sAnim + "_start" );
			break;
		default:
			self gun_remove();
			self.eAnimEnt.angles = eProp.angles;
			break;		
	}
	
	self thread ai_ambient_think( sAnim, sFailSafeFlag );
}

ai_ambient_cleanup()
{
	self waittill( "death" );
	if ( ( isdefined( self.eAnimEnt ) ) && ( !isspawner( self.eAnimEnt ) ) )
		self.eAnimEnt delete();
			
}

make_ambient_ai( targetname )	
{
	//used to make one of your special squad friendlies into one of the pre-placed ambient bunker guys
	spawner = getent( targetname, "targetname" );	
	self.script_flag = spawner.script_flag;
	self.animation = spawner.animation;
	self.eAnimEnt = spawner;
	self.target = spawner.target;
	sAnim = self.animation;
	sFailSafeFlag = undefined;
	self thread ai_ambient_think( sAnim, sFailSafeFlag );
}

ai_ambient_noprop_think()
{
	/*-----------------------
	GLOBAL SCRIPT TO HANDLE ALL AMMBIENT GUYS
	-------------------------*/	
	self endon( "death" );
	assert( isdefined( self.animation ) );	//must be defined in the spawner
	sAnim = self.animation;
	bSpecial = false;
	if ( !isdefined( self.eAnimEnt ) )
		self.eAnimEnt = self.spawner;
	
	sFailSafeFlag = undefined;
	/*-----------------------
	SPECIAL CASES
	-------------------------*/	
	switch( sAnim )
	{
		case "death_explosion_run_F_v1":
		case "civilian_run_2_crawldeath":
			self gun_remove();
			self.skipDeathAnim = true;
			self.noragdoll = true;
			break;
		case "DC_Burning_artillery_reaction_v1_idle":
		case "DC_Burning_artillery_reaction_v2_idle":
		case "DC_Burning_artillery_reaction_v3_idle":
		case "DC_Burning_artillery_reaction_v4_idle":
		case "DC_Burning_bunker_stumble":
		case "training_humvee_wounded":
		case "training_humvee_soldier":
			sFailSafeFlag = "player_bunker_walk_01";
			self gun_remove();
			break;
		case "bunker_toss_idle_guy1":
			self cqb_walk( "on" );
			break;
		case "unarmed_panickedrun_loop_V2":
			self set_generic_run_anim( "unarmed_panickedrun_loop_V2" );
			self gun_remove();
			self.disablearrivals = true;
			self.disableexits = true;
			self.goalradius = 16;
			self waittill( "goal" );
			self clear_run_anim();
			wait( 1 );
			self gun_recall();
			bSpecial = true;
			return;
		case "wounded_carry_fastwalk_carrier":
			spawner = getent( self.target, "targetname" );
			eBuddy = spawner spawn_ai();
			self.eAnimEnt anim_generic_first_frame( self, sAnim );
			self.eAnimEnt anim_generic_first_frame( eBuddy, "wounded_carry_fastwalk_wounded" );
			//self gun_remove();
			eBuddy gun_remove();
			bSpecial = true;
			eEndOrg = getent( self.script_Linkto, "script_linkname" );
			if ( isdefined( self.script_flag ) )
				flag_wait( self.script_flag );
			
			while ( distance( eEndOrg.origin, self.origin ) > 128 )
			{
				thread anim_generic( self, sAnim );
				anim_generic( eBuddy, "wounded_carry_fastwalk_wounded" );
			}
			self.eAnimEnt = spawn( "script_origin", ( 0, 0, 0 ) );
			self.eAnimEnt.origin = self.origin;
			self.eAnimEnt.angles = self.angles;
			self.eAnimEnt thread ent_cleanup( self );
			self.eAnimEnt thread anim_generic( self, "DC_Burning_wounded_carry_putdown_carrier" );
			self.eAnimEnt anim_generic( eBuddy, "DC_Burning_wounded_carry_putdown_wounded" );
			self thread anim_sound_loop( "scn_dcburn_carry_wounded_loop" );
			self.eAnimEnt thread anim_generic_loop( eBuddy, "DC_Burning_wounded_carry_idle_wounded" );
			self.eAnimEnt thread anim_generic_loop( self, "DC_Burning_wounded_carry_idle_carrier" );
			return;
		case "roadkill_cover_radio_soldier2":
			break;
		case "roadkill_cover_spotter":
			self attach( "weapon_binocular", "TAG_INHAND", 1 );
			break;
		case "roadkill_cover_radio_soldier3":
			self.eAnimEnt.origin = self.eAnimEnt.origin + ( 0, 0, 8 );
			self attach( "mil_mre_chocolate01", "TAG_INHAND", 1 );
			break;
		case "favela_run_and_wave":
			break;
		default:
			self gun_remove();
			break;
	}
	
	self thread ai_ambient_think( sAnim, sFailSafeFlag );

}

anim_sound_loop( alias )
{
	self endon( "death" );
	while( true )
	{
		self thread play_sound_in_space( alias );
		self waittillmatch( "looping anim", "end" );
	}
}

ai_ambient_think( sAnim, sFailSafeFlag )
{	
	self endon( "death" );
	self AI_ignored_and_oblivious_on(); 
	eGoal = undefined;
	sAnimGo = undefined;
	looping = false;
	/*-----------------------
	DOES AI HAVE A GOAL NODE?
	-------------------------*/	
	if ( isdefined( self.target ) )
		eGoal = getnode( self.target, "targetname" );
	
	/*-----------------------
	CLEANUP PROPS AND ANIMATION NODE WHEN DEAD
	-------------------------*/	
	self thread ai_ambient_cleanup();

	/*-----------------------
	GO AHEAD AND PLAY LOOPING IDLE (IF ANIM IS LOOPING)
	-------------------------*/	
	if ( isarray( level.scr_anim[ "generic" ][ sAnim ] ) )
	{
		looping = true;
		self.eAnimEnt thread anim_generic_loop( self, sAnim, "stop_idle" );
		sAnimGo = sAnim + "_go";	//This will be the next animation to play after the loop (if defined)
		if ( anim_exists( sAnimGo ) )
			sAnim = sAnimGo;
		else
			sAnimGo = undefined;
	}
	/*-----------------------
	FREEZE FRAME AT START OF ANIM (IF IT'S NOT A LOOP)
	-------------------------*/	
	else
		self.eAnimEnt anim_generic_first_frame( self, sAnim );

	/*-----------------------
	WAIT FOR A FLAG (IF DEFINED IN THE SPAWNER) THEN PLAY ANIM
	-------------------------*/	
	if ( isdefined( self.script_flag ) )
	{
		if ( isdefined( sFailSafeFlag ) )
			flag_wait_either( self.script_flag, sFailSafeFlag );
		else
			flag_wait( self.script_flag );
		
	}
	
	/*-----------------------
	DO CUSTOM SHIT BASED ON ANIMNAME
	-------------------------*/	
	switch( sAnim )
	{
		case "death_explosion_run_F_v1":
		case "civilian_run_2_crawldeath":
			thread ambient_mortar_explosion( self.origin );
			break;
	}
	
	/*-----------------------
	IF HEADED TO A GOAL NODE LATER....
	-------------------------*/	
	if ( isdefined( eGoal ) )
	{
		self.disablearrivals = true;
		self.disableexits = true;
	}
	
	if ( !looping ) 
		self.eAnimEnt anim_generic( self, sAnim );
		
	if ( isdefined( sAnimGo ) )
	{
		self.eAnimEnt notify( "stop_idle" );
		self.eAnimEnt anim_generic( self, sAnimGo );
	}

	/*-----------------------
	DO CUSTOM SHIT BASED ON ANIMNAME
	-------------------------*/	
	switch( sAnim )
	{
		case "civilian_run_2_crawldeath":
			self kill();
			break;
	}
	
	/*-----------------------
	FINISH ANIM THEN RUN TO A NODE
	-------------------------*/	
	if ( isdefined( eGoal ) )
	{
		self setgoalnode( eGoal );
		wait( 1 );
		self.disablearrivals = false;
		self.disableexits = false;
		self waittill( "goal" );
		if ( isdefined( self.cqbwalking ) && self.cqbwalking )
			self cqb_walk( "off" );
	}
	
	/*-----------------------
	FINISH ANIM THEN PLAY LOOPING IDLE
	-------------------------*/	
	else if ( isdefined( level.scr_anim[ "generic" ][ sAnim + "_idle" ] ) )
		self.eAnimEnt thread anim_generic_loop( self, sAnim + "_idle", "stop_idle" );
		
	/*-----------------------
	PLAY MORTAR REACTIONS IF AVAILABLE
	-------------------------*/	
	if ( anim_exists( sAnim + "_react" ) )
	{
		if ( !looping )
			sAnim = sAnim + "_idle";
		sAnimReact = sAnim + "_react";
		
		if ( anim_exists( sAnim + "_react2" ) )
			sAnimReact2 = sAnim + "_react2";
		else
			sAnimReact2 = sAnimReact;
		while( isdefined( self ) )
		{
			level waittill( "mortar_hit" );
			self.eAnimEnt notify( "stop_idle" );
			self notify ( "stop_idle" );
			waittillframeend;
			if ( RandomInt( 100 ) > 50 )
				self.eAnimEnt anim_generic( self, sAnimReact );
			else
				self.eAnimEnt anim_generic( self, sAnimReact2 );
			self.eAnimEnt thread anim_generic_loop( self, sAnim, "stop_idle" );
		}
	}
}

ambient_mortar_explosion( org )
{
	playfx( level._effect[ "mortar" ][ "dirt" ], org );
	thread play_sound_in_space( level.scr_sound[ "mortar" ][ "dirt" ], org );
	earthquake( 0.25, 0.75, org, 1250 );
}


dialogue_random_incoming_javelins()
{
	iRand = randomint( 2 );
	dialouge_random_friendly( "dcburn_javelins_incoming_0" + iRand );

}


//destructibles_think()
//{
//	/*-----------------------
//	DESTRUCTIBLES THAT SHOULD BE TRIGGERED WHEN AN ARTY ROUND HITS AND PLAYER IS LOOKING
//	-------------------------*/	
//	mortar_destructibles = [];
//	trigger_bunker_prop_damage = getentarray( "trigger_bunker_prop_damage", "targetname" );
//	mortar_destructibles = array_merge( trigger_bunker_prop_damage, mortar_destructibles );
//	if ( mortar_destructibles.size > 0 )
//		array_thread( mortar_destructibles,::destructibles_mortar_think );
//
//	/*-----------------------
//	DESTRUCTIBLES THAT SHOULD BE TRIGGERED BY PLAYER MINIGUN
//	-------------------------*/	
//}
//
//destructibles_mortar_think()
//{
//	//self==> the trigger_radius surrounding the destructible we want to trigger if the player is looking
//	while( isdefined( self ) )
//	{
//		level waittill( "mortar_hit" );
//		if ( level.player istouching( self ) )
//			continue;
//		bInFOV = within_fov( level.player geteye(), level.player getPlayerAngles(), self.origin, level.cosine[ "35" ] );
//		if ( bInFOV )
//		{
//			RadiusDamage( self.origin, self.radius, 500, 500 );
//			self delete();
//			break;
//		}
//	}
//}

javelin_earthquake()
{
	dummy = spawn( "script_origin", self.origin );
	dummy linkto( self );
	self waittill( "death" );
	earthquake( 1.2, 1.5, dummy.origin, 1600 );
	wait( 0.05 );
	dummy delete();
}

vehicle_owned_by_javelin( javelin_source_org )
{
	newMissile = MagicBullet( "javelin_noimpact", javelin_source_org.origin, self.origin );
	playfx( getfx( "javelin_muzzle" ), javelin_source_org.origin );
	newMissile thread javelin_earthquake();	
	newMissile Missile_SetTargetEnt( self ); 
	newMissile Missile_SetFlightmodeTop();	
	while( true )
	{
		self waittill( "damage", amount, attacker, enemy_org, impact_org, type );
		if ( ( isdefined( attacker.classname ) ) && ( attacker.classname == "worldspawn" ) && ( isdefined( amount ) ) && ( amount > 24 ) )
			break;
	}
	if ( isdefined( self ) ) 
		self notify( "death" );
}

ignoreme_on_squad_and_player()
{
	level.player.ignoreme = true;
	level.squad = remove_dead_from_array( level.squad );
	for ( i = 0;i < level.squad.size;i++ )
	{
		if ( !isdefined( level.squad[ i ] ) )
			continue;
		level.squad[ i ].ignoreme = true;
		level.squad[ i ] setthreatbiasgroup( "oblivious" );
	}
}

ignoreme_off_squad_and_player()
{

	level.player.ignoreme = false;
	level.squad = remove_dead_from_array( level.squad );
	for ( i = 0;i < level.squad.size;i++ )
	{
		if ( !isdefined( level.squad[ i ] ) )
			continue;
		level.squad[ i ].ignoreme = false;
		level.squad[ i ] setthreatbiasgroup( "allies" );
	}
}


AI_friendly_fodder_think()
{
	self thread try_to_magic_bullet_shield();
	self setFlashbangImmunity( true );
	self.baseaccuracy = .1;
	self.ignoreall = true;
	eGoal = getnode( self.target, "targetname" );
	if ( isdefined( eGoal ) )
	{
		self setgoalnode( eGoal );
		self.goalradius = 16;
	}
}


//seaknight_take_off()
//{
//	
//	eAnimEnt = spawn( "script_origin", self.origin );
//	eAnimEnt.origin = self.model gettagorigin( "tag_origin" );
//	eAnimEnt.angles = self.model gettagangles( "tag_origin" );
//
//	dummy = self vehicle_to_dummy();
//	dummy.animname = "seaknight";
//	dummy assign_animtree();
//	//eAnimEnt = spawn( "script_origin", dummy.origin );
//	//eAnimEnt.origin = dummy gettagorigin( "tag_origin" );
//	//eAnimEnt.angles = dummy gettagangles( "tag_origin" );
//		
//	//eAnimEnt.origin = dummy.origin;
//	//eAnimEnt.angles = dummy.angles;
//	//dummy thread vehicle_seaknight_rotors();
//	eAnimEnt anim_single_solo( dummy, "take_off" );
//}
//
//vehicle_seaknight_rotors()
//{
//	self endon( "death" );
//	xanim = self getanim( "rotors" );
//	length = getanimlength( xanim );
//
//	while ( true )
//	{
//		if ( !isdefined( self ) )
//			break;
//		self setanim( xanim );
//		wait length;
//	}
//}

flareFlicker()
{
	while( isdefined( self ) )
	{
		wait( randomfloatrange( .05, .1 ) );
		self setLightIntensity( randomfloatrange( 0.6, 1.8 ) );
	}
}


flicker_fire()
{
	while( isdefined( self ) )
	{
		wait( randomfloatrange( .05, .1 ) );
		self setLightIntensity( randomfloatrange( 1.2, 2.2 ) );
	}
}

flare_burst_on_and_flicker( rampUpTime, rampDownTime, intensity )
{
	//self ==> the script_model of the flare
	assertex( self.classname == "script_model", "This function can only be called on a script_model. Preferably mil_emergency_flare" );
	dynamicLight = getent( self.target, "targetname" );
	assertex( maps\_lights::is_light_entity( dynamicLight ), "The flare script_model must be targeting a scriptable primary light" );
	
	//ramp up flare light from zero and play sfx and fx
	playfxontag( getfx( "flare_ambient" ), self, "TAG_FIRE_FX" );
	thread play_sound_in_space( "flare_ignite", self.origin );
	dynamicLight flare_ramp_up( rampUpTime, intensity );
	
	//ramp down light to normal flicker
	dynamicLight flare_ramp_down( rampDownTime );
	
	//play flicker and looping sound and effect
	self thread flare_flicker();
}

flare_ramp_up( transitionTime, intensity )
{
	self setLightIntensity( 0 );
	curr = 0;
	increment_on = ( intensity - 0 ) / ( transitionTime / .05 );

	//ramp up
	time = 0;
	randomFlicker = undefined;
	while ( time < transitionTime )
	{
		curr += increment_on;
		randomFlicker = randomfloatrange( -.05, .05  );
		curr = curr + randomFlicker;
		if ( curr < 0 )
			break;
		self setLightIntensity( curr );
		time += .05;
		wait( .05 );
	}
}

flare_ramp_down( transitionTime )
{
	curr = self getLightIntensity();
	increment = ( curr - 0 ) / ( transitionTime / .05 );
	
	//ramp down
	time = 0;
	randomFlicker = undefined;
	while ( time < transitionTime )
	{
		curr -= increment;
		randomFlicker = randomfloatrange( -.05, .05  );
		curr = curr + randomFlicker;
		if ( curr < 2 )
			break;
		self setLightIntensity( curr );
		time += .05;
		wait( .05 );
	}
}


flare_flicker( minIntensity, maxIntensity )
{
	//self ==> the script_model of the flare
	assertex( self.classname == "script_model", "This function can only be called on a script_model. Preferably mil_emergency_flare" );
	dynamicLight = getent( self.target, "targetname" );
	assertex( maps\_lights::is_light_entity( dynamicLight ), "The flare script_model must be targeting a scriptable primary light" );
	
	if ( !isdefined( minIntensity ) ) 
		minIntensity = 0.6;
	if ( !isdefined( maxIntensity ) ) 
		maxIntensity = 1.8;
	
	self thread play_loop_sound_on_entity( "flare_burn_loop" );
	
	while( isdefined( self ) )
	{
		wait( randomfloatrange( .05, .1 ) );
		dynamicLight setLightIntensity( randomfloatrange( minIntensity, maxIntensity ) );
	}
}

anim_exists( sAnim, animname )
{
	if ( !isdefined( animname ) )
		animname = "generic";
	if ( isDefined( level.scr_anim[ animname ][ sAnim ] ) )
		return true;
	else
		return false;
}

dialouge_random_friendly( sLine )
{
	guy = get_closest_ai_exclude( level.player.origin, "allies", level.excludedAi );
	if ( isdefined( guy ) )
		guy play_sound_in_space( level.scr_sound[ sLine ] );
	else
		iprintln( "unable to play random friendly dialogue " + sLine + " because couldn't find an AI" ); 
}

triggersEnable( triggerName, noteworthyOrTargetname, bool )
{
	assertEX( isdefined( bool ), "Must specify true/false parameter for triggersEnable() function" );
	aTriggers = getentarray( triggername, noteworthyOrTargetname );
	assertEx( isDefined( aTriggers ), triggerName + " does not exist" );
	if ( bool == true )
		array_thread( aTriggers, ::trigger_on );
	else
		array_thread( aTriggers, ::trigger_off );
}

hideAll( stuffToHide )
{
	if ( !isdefined( stuffToHide ) )
		stuffToHide = getentarray( "hide", "script_noteworthy" );
	array_thread( stuffToHide, ::hide_entity );
}

AI_delete( excluders )
{
	self endon( "death" );
	if ( !isdefined( self ))
		return;
	if ( ( isdefined( excluders ) ) && ( excluders.size > 0 ) )
	{
		if ( is_in_array( excluders, self ) )
			return;
	}
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	if ( !isSentient ( self) )
	{
//		self notify( "death" );
//		waittillframeend;
	}
		
	self delete();
}


set_threatbias( iValue )
{
	self.oldthreatbias = level.player.threatbias;
	self.threatbias = iValue;
}

reset_threatbias()
{
	if ( isdefined( self.oldthreatbias ) )
		self.threatbias = self.oldthreatbias;
	
}

humvee_spotlight_setup()
{
	self.spotlight_org = spawn( "script_origin", self.origin );
	self.spotlight_org.angles = self.angles;
	self.spotlight_org.origin = self gettagorigin( "tag_walker3" );
	self.spotlight_org.origin = self.spotlight_org.origin + ( 0, 0, 0 );
	ent = spawnstruct();
	ent.entity = self.spotlight_org;
	ent.forward = 0;
	ent.up = 30;
	ent.right = 0;
	ent translate_local();
	self.turret = spawnturret( "misc_turret", self.spotlight_org.origin, "heli_spotlight" );
	self.turret.angles = self.spotlight_org.angles;
	self.turret setmode( "manual" );
	self.turret setmodel( "com_blackhawk_spotlight_on_mg_setup" );
}

waittill_dead_then_set_flag( aGuys, sFlag )
{
	waittill_dead_or_dying( aGuys );
	flag_set( sFlag );
}

dialogue_execute( sLineToExecute )
{
	if ( !isdefined( self ) )
		return;
	self endon( "death" );
	self dialogue_queue( sLineToExecute );

}

play_sound_on_entity_temp( sLineToExecute )
{
	if ( getdvar( "dc_dialog" ) == "1" )
	{
		hint_temp( level.scr_sound[ sLineToExecute ], level.tempDialogueTime );
	}

}

hint_temp( string, timeOut )
{
	hintfade = 0.5;

	level endon( "clearing_hints" );

	if ( isDefined( level.tempHint ) )
		level.tempHint destroyElem();

	level.tempHint = createFontString( "default", 1.5 );
	level.tempHint setPoint( "BOTTOM", undefined, 0, -40 );
	level.tempHint.color = ( 1, 1, 1 );
	level.tempHint setText( string );
	level.tempHint.alpha = 0;
	level.tempHint fadeOverTime( 0.5 );
	level.tempHint.alpha = 1;
	level.tempHint.sort = 1;
	wait( 0.5 );
	level.tempHint endon( "death" );

	if ( isDefined( timeOut ) )
		wait( timeOut );
	else
		return;

	level.tempHint fadeOverTime( hintfade );
	level.tempHint.alpha = 0;
	wait( hintfade );

	level.tempHint destroyElem();
}

vehicle_animated_think()
{
	self hide();
	aRideSpawners = undefined;
	if ( isdefined( self.target ) )
		aRideSpawners = getentarray( self.target, "targetname" );
	reference = spawn( "script_origin", self.origin );
	self thread delete_on_death( reference );
	reference.origin = self.origin;
	reference.angles = self.angles;
	attachedEffects = undefined;
	sAnimIdle = self.animation + "_idle";
	eOrgFx = spawn( "script_origin", self.origin );
	reference thread ent_cleanup( self );
	eOrgFx thread ent_cleanup( self );
	loop = undefined;
	groundFx = undefined;
	bHasRotors = false;
	switch( self.animation )
	{
		case "sniper_escape_ch46_take_off":
			self.animname = "seaknight";
			loop = "seaknight_idle_high";
			groundFx = "heli_dust_default";
			bHasRotors = true; 
			break;
	}
	self assign_animtree( self.animname );
	reference anim_first_frame_solo( self, self.animation );

	self waittill( "spawn" );
	if ( isdefined( aRideSpawners ) )
	{
		aRiders = [];
		foreach( spawner in aRideSpawners )
		{
			aRiders[ aRiders.size ] = thread dronespawn( spawner );
		}
		self delaythread( .05, ::animated_seaknight_riders_think, aRiders );
	}
	
	self show();
	if ( anim_exists( sAnimIdle, self.animname ) )
		reference thread anim_loop_solo( self, sAnimIdle, "stop_idle" );
	if ( bHasRotors )
		self thread vehicle_animated_rotors();
	if ( isdefined( loop ) )
		self thread play_loop_sound_on_entity( loop );
	if ( isdefined( groundFx ) )
		self thread vehicle_animated_ground_fx( eOrgFx, groundFx );
	self waittill( "play_anim" );
	self notify_delay( "taking_off", 4 );
	reference notify( "stop_idle" );
	if ( ( isdefined( self.targetname ) ) && ( self.targetname == "seaknight_loader_start2" ) )
	{
		self linkTo( reference );
		reference thread hack_height_for_seaknight();
	}

	reference anim_single_solo( self, self.animation );
	self delete();
}
hack_height_for_seaknight()
{
	wait( 5 );
	self moveto( self.origin + ( 0, 0, 550 ), 10 );
}

animated_seaknight_riders_think( aRiders )
{
	//self ==> the animated seaknight
	
	//put guys into position
	i = 0;
	foreach( rider in aRiders )
	{
		i++;
		rider.dontDoNotetracks = true;
		rider.anim_variation = i;
		self anim_generic_first_frame( rider, "ch46_load_" + rider.anim_variation, "tag_detach" );
		//self anim_generic_loop( rider, "ch46_unload_idle", "stop_rider_idle" );
	}
	
	assertex( i < 5, "Too many riders...can't have more than 4" );
	
	self waittill( "load_riders" );
	
	lastAnimPlayed = undefined;
	
	self notify( "stop_rider_idle" );
	foreach( rider in aRiders )
	{
		self thread anim_generic( rider, "ch46_load_" + rider.anim_variation, "tag_detach" );
		rider thread delete_at_end_of_anim();
		lastAnimPlayed = "ch46_load_" + rider.anim_variation;
		
	}
	time = getanimlength( level.scr_anim[ "generic" ][ lastAnimPlayed ] );
	wait( time - 2 );
	self notify( "riders_loaded" );
}

delete_at_end_of_anim()
{
	self endon( "death" );
	self waittillmatch( "single anim", "end" );
	self AI_delete();
}

vehicle_animated_ground_fx( eOrgFx, groundFx )
{
	self endon( "death" );
	self endon( "taking_off" );
	while ( isdefined( eOrgFx ) )
	{
		playfx( getfx( groundFx ), eOrgFx.origin );
		wait( 0.1 );
	}
}

vehicle_animated_rotors()
{
	self endon( "death" );
	xanim = self getanim( "rotors" );
	length = getanimlength( xanim );

	while ( true )
	{
		if ( !isdefined( self ) )
			break;
		self setanim( xanim );
		wait length;
	}
}

waittill_death_or_timeout( timeout )
{
	self endon( "death" );
	wait( timeout );
}

AI_cleanup( sTeam, dist, bImmediate )
{
	aAI_to_delete = undefined;
	if ( sTeam == "all" )
		aAI_to_delete = getaiarray();
	else
		aAI_to_delete = getaiarray( sTeam );
	if ( isdefined( bImmediate ) )
		array_thread( aAI_to_delete,::AI_delete );
	else
	{
		if ( !isdefined( dist ) )
			dist = 1024;
		thread AI_delete_when_out_of_sight( aAI_to_delete, dist );
	}
	
}

AI_drone_cleanup( sTeam, dist, bImmediate )
{
	if ( !isdefined( sTeam ) )
		sTeam = "all";
		
	aDrones = [];
	if ( sTeam == "all" )
	{
		aDrones = array_merge( level.drones[ "allies" ].array, level.drones[ "axis" ].array );
		aDrones = array_merge( aDrones, level.drones[ "neutral" ].array );
	}
	else
		aDrones = level.drones[ sTeam ].array;
		
	if ( isdefined( bImmediate ) )
		array_thread( aDrones,::AI_delete );
	else
	{
		if ( !isdefined( dist ) )
			dist = 1024;
		thread AI_delete_when_out_of_sight( aDrones, dist );
	}
	
}

AI_door_breaker_think()
{
	self endon( "death" );
	self thread magic_bullet_shield();
	self setgoalpos( self.origin );
	door_actors = getentarray( "roof_door", "targetname" );
	trigger = undefined;
	org = undefined;
	door = undefined;
	eNode = getnode( self.target, "targetname" );
	
	//setup door
	foreach( ent in door_actors )
	{
		if ( ent.code_classname == "script_origin" )
		{
			org = ent;
			continue;
		}
		else if ( ent.code_classname == "trigger_multiple" )
		{
			trigger = ent;
			continue;
		}
		else if ( ent.code_classname == "script_brushmodel" )
		{
			door = ent;
			continue;
		}
		else
			eNode = ent;
	}
	
	//waittill door clear
	while( true )
	{
		wait( 0.05 );
		if ( level.player istouching( trigger ) )
			continue;
		if ( flag( "door_being_blocked" ) )
			continue;
		break;
	}
	
	door thread door_fall_over( org );
	//go to node and seek player
	self thread stop_magic_bullet_shield();

	//wait( .5 );
	self.goalradius = 16;
	self setgoalnode( eNode );
	
	wait( 4 );
	self thread AI_player_seek();
}

door_fall_over( org )
{
	forward = anglestoforward( org.angles );
	self thread play_sound_in_space( "door_wood_double_kick" );
	playfx( getfx( "door_kick_dust" ), org.origin, forward );
	earthquake( .2, .75, self.origin, 1024 );
	self connectpaths();
	self notsolid();
	self moveto( self.origin + ( 0, 0, 2 ), .5, 0, .5 );
	self rotatepitch( -90, 0.45, 0.40 );
	wait 0.449;
	self rotateroll( 4, 0.2, 0, 0.2 );
	wait 0.2;
	self rotateroll( -4, 0.15, 0.15 );
}

AI_player_seek()
{
	self endon( "death" );
	self endon( "stop_seeking" );
	self enable_danger_react( 3 );
	//self.fixednode = false;
	//self.ignoresuppression = true;
	//self.goalradius = 800;
	//self.interval = 0;
	//self.baseaccuracy = 5;
	self.neverEnableCQB = true;
	self.grenadeawareness = 0;
	self.ignoresuppression = true;
	self.goalheight = 100;
	self.aggressivemode = true;	//dont linger at cover when you cant see your enemy
	newGoalRadius = distance( self.origin, level.player.origin );
	while( isalive( self ) )
	{
		wait 1;
		self.goalradius = newGoalRadius;
		//self setgoalpos( self lastKnownPos( level.player ) );
		self setgoalentity( level.player );
		//self setgoalpos( level.player.origin );
		newGoalRadius -= 175;
		if ( newGoalRadius < 512 )
		{
			newGoalRadius = 512;
			return;
		}
	}
}

AI_cleanup_non_squad( sTeam, dist )
{
	if ( !isdefined( dist ) )
		dist = 1024;
	if ( sTeam == "all" )
		aAI = getaiarray();
	else
		aAI = getaiarray( sTeam );
	if ( ( sTeam == "allies" ) || ( sTeam == "all" ) )
	{
		foreach( guy in level.squad )
		{
			if( is_in_array( aAI, guy ) )
				aAI = array_remove( aAI, guy );
		}
	}

	thread AI_delete_when_out_of_sight( aAI, dist );
}

AI_cleanup_volume( sVolume, sTeam, dist )
{
	if ( !isdefined( dist ) )
		dist = 1024;
	eVolume = getent( sVolume, "targetname" );
	aAI_to_delete = eVolume get_ai_touching_volume( sTeam );
	
	if ( sTeam != "axis" )
	{
		level.squad = remove_dead_from_array( level.squad );
		foreach( guy in level.squad )
		{
			if( is_in_array( aAI_to_delete, guy ) )
				aAI_to_delete = array_remove( aAI_to_delete, guy );
		}
	}
	thread AI_delete_when_out_of_sight( aAI_to_delete, dist );
}

ent_cleanup( owner )
{
	owner waittill( "death" );
	owner endon( "death" );
	if ( isdefined( self ) )
		self delete();
}

nag_wait()
{
	wait( randomfloatrange( 13, 19 ) );
}

player_killing_crow_targets_at_a_good_pace()
{
	currentTime = getTime();
	timeElapsed = currentTime - level.lasttimePlayerKilledEnemy;
	if ( currentTime == level.lasttimePlayerKilledEnemy )
		return true;
	else if ( timeElapsed > 10000 )
		return false;
	else
		return true;
}

drone_flood_start( aSpawners, groupName )
{
	level endon( "stop_drone_flood" + groupName );
	while( true )
	{
		foreach( spawner in aSpawners )
		{
			delaythread( randomfloatrange( 5, 6 ), ::dronespawn, spawner );
		}
		wait( randomfloatrange( 5, 6 ) );
	}
}

drone_flood_stop( groupName )
{
	level notify( "stop_drone_flood" + groupName );
}

drone_vehicle_flood_start( aSpawners, groupName, minWait, maxWait, noSound )
{
	level endon( "stop_drone_vehicle_flood" + groupName );
	vehicle = undefined;
	while( true )
	{
		foreach( spawner in aSpawners )
		{
			vehicle = spawner thread spawn_vehicle_and_gopath();
			//if ( isdefined( noSound ) )
			//	vehicle Vehicle_TurnEngineOff();
			vehicle = undefined;
			wait( randomfloatrange( minWait, maxWait ) );
		}
		aSpawners = array_randomize( aSpawners );
	}
}

drone_vehicle_flood_stop( groupName )
{
	level notify( "stop_drone_vehicle_flood" + groupName );
}

AI_invisible_patrol_fodder_think()
{
	self endon( "death" );
	self hide();
	self thread magic_bullet_shield();
	self.a.disablePain = true;
	self.ignoreall = true;
	//self setthreatbiasgroup( "oblivious" );
	self.walkdist = 1000;
	self.disablearrivals = true;
	self clearEnemy();
	wait( 0.1 );
	self thread maps\_patrol::patrol();

}

AI_at4_friendly_think()
{
	
}

spawn_trigger_dummy( sDummyTargetname )
{
	//triggers a spawner trig through convoluted means 
	//since I can't use a unique targetname or script_noteworthy
	ent = getent( sDummyTargetname, "targetname" );
	assert( isdefined( ent ) );
	assert( isdefined( ent.script_linkTo ) );
	trig = getent( ent.script_linkTo, "script_linkname" );
	assert( isdefined( trig ) );
	trig notify( "trigger", level.player );
}

friendly_speed_adjustment_on()
{
	level.squad = remove_dead_from_array( level.squad );
	array_thread( level.squad, ::friendly_adjust_movement_speed );
}

friendly_speed_adjustment_off()
{
	level.squad = remove_dead_from_array( level.squad );
	foreach( guy in level.squad )
	{
		guy notify( "stop_adjust_movement_speed" );
		guy.moveplaybackrate = 1.0;
	}
}

friendly_adjust_movement_speed()
{
	self notify( "stop_adjust_movement_speed" );
	self endon( "death" );
	self endon( "stop_adjust_movement_speed" );
	
	while( isalive( self ) )
	{
		wait randomfloatrange( .5, 1.5 );
		
		while( friendly_should_speed_up() )
		{
			//iPrintLnBold( "friendlies speeding up" );
			self.moveplaybackrate = 3.5;
			wait 0.05;
		}
		
		self.moveplaybackrate = 1.0;
	}
}

friendly_should_speed_up()
{
	self endon( "death" );
	prof_begin( "friendly_movement_rate_math" );
	
	if ( !isdefined( self.goalpos ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	if ( distanceSquared( self.origin, self.goalpos ) <= level.goodFriendlyDistanceFromPlayerSquared )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	// check if AI is visible in player's FOV
	if ( within_fov( level.player.origin, level.player getPlayerAngles(), self.origin, level.cosine[ "90" ] ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	prof_end( "friendly_movement_rate_math" );
	
	return true;
}


get_ai_touching_volume_non_squad()
{
	aAI = self get_ai_touching_volume();
	foreach( guy in level.squad )
	{
		if( is_in_array( aAI, guy ) )
			aAI = array_remove( aAI, guy );
	}
	return aAI;
}


ai_cleanup_trigger_think()
{
	aLinkedVolumes = get_linked_ents();
	self waittill( "trigger" );
	aAI = undefined;
	foreach( volume in aLinkedVolumes )
	{
		aAI = volume get_ai_touching_volume ( "axis" );
		if ( !aAI.size )
			continue;
		array_call( aAI, ::delete );
	}
	self delete();
}

redshirt_trigger_think()
{
	while( true )
	{
		self waittill( "trigger" );
		iRedshirtsToSpawn = undefined;
		aSpawners = undefined;
		level.squad = remove_dead_from_array( level.squad );
		guy = undefined;
		if ( level.squad.size < level.squadsize )
		{
			aSpawners = getentarray( self.target, "targetname" );
			assertex( aSpawners.size > 1, "Redshirt_trigger at " + self.origin + " needs to target at least 2 spawners" );
			iRedshirtsToSpawn = ( level.squadsize - level.squad.size );
			for ( i = 0; i < iRedshirtsToSpawn; i++ )
			{
				guy = aSpawners[ i ] spawn_ai();
				if ( isdefined( guy ) )
				{
					guy set_force_color( "p" );
					level.squad = array_add( level.squad, guy );
					guy thread friendly_squad_think();
				}
			}			
		}
		wait( 10 );
	}
}

killSpawner( num )
{
	thread maps\_spawner::kill_spawnerNum( num );
}

rpg_targets_think()
{
	/*-----------------------
	SHOOT MAGIC RPGS AT THIS TARGET IF PLAYER NEAR
	-------------------------*/	
	eTrigger = getent( self.script_Linkto, "script_linkname" );
	eRPGsource = getent( self.target, "targetname" );
	sFlagToEnd = self.script_flag;
	level endon( sFlagToEnd );
	assert( isdefined( eTrigger ) );
	assert( isdefined( eRPGsource ) );
	while( !flag( sFlagToEnd ) )
	{
		eTrigger waittill( "trigger" );
		if ( level.firemagicRPGs == false )
			wait( 1 ); 
		else if ( within_fov( level.player geteye(), level.player getPlayerAngles(), self.origin, level.cosine[ "60" ] ) )
		{
			MagicBullet( "rpg", eRPGsource.origin, self.origin );
			level.firemagicRPGs = false;
			wait( 4 );
			level.firemagicRPGs = true;
			break;
		}
		else
			wait( 1 );
	}

}



//player_death()
//{
//	level.player waittill( "death" );
//	if ( !level.onHeli )
//		return;
//
//	/*-----------------------
//	MAKE SURE PLAYER STAYS ATTACHED
//	-------------------------*/		
//	level.player playerLinkToBlend( level.blackhawk, "tag_player", .5 );
//	level.player playerlinkTo( level.blackhawk, "tag_player" );
//}


fx_management()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;
	/*-----------------------
	CREATE ARRAYS OF FX FOR THE LEVEL
	-------------------------*/	
	level.effects_commerce = [];
	level.effects_trenches = [];
	level.effects_bunker = [];
	level.effects_ww2 = [];
	level.effects_lincoln = [];


	/*-----------------------
	GET ANY VOLUMES YOU WANT TRIGGERED DIRECTLY IN GAME (EX: FLARES THAT GO THROUGH FLOORS)
	-------------------------*/	
	triggered_fx_volumes = getentarray( "triggered_fx_volumes", "targetname" );
	foreach( volume in triggered_fx_volumes )
	{
		volume.fx = [];
	}
	
	/*-----------------------
	GET MAJOR VOLUMES THAT ENCOMPASS EFFECTS 
	-------------------------*/	
	effects_commerce = getent( "effects_commerce", "script_noteworthy" );
	effects_trenches = getent( "effects_trenches", "script_noteworthy" );
	effects_bunker = getent( "effects_bunker", "script_noteworthy" );
	effects_ww2 = getent( "effects_ww2", "script_noteworthy" );
	effects_lincoln = getent( "effects_lincoln", "script_noteworthy" );
	
	/*-----------------------
	CATALOG ALL FX BY VOLUME
	-------------------------*/	
	dummy = spawn( "script_origin", ( 0, 0, 0 ) );
	for ( i = 0;i < level.createfxent.size;i++ )
	{
		EntFx = level.createfxent[ i ];
		dummy.origin = EntFx.v[ "origin" ];
	
		/*-----------------------
		ASSIGN FX TO TRIGGERED VOLUMES (EX: FLARES THAT GO THROUGH FLOORS)
		-------------------------*/	
		foreach( volume in triggered_fx_volumes )
		{
			if ( dummy istouching( volume ) )
				volume.fx [ volume.fx.size ] = EntFx;
		}

		/*-----------------------
		ASSIGN MAJOR VOLUME FX TO LEVEL VARIABLES
		-------------------------*/	
		if ( dummy istouching( effects_commerce ) )
		{
			level.effects_commerce[ level.effects_commerce.size ] = EntFx;
			continue;
		}
		if ( dummy istouching( effects_trenches ) )
		{
			level.effects_trenches[ level.effects_trenches.size ] = EntFx;
			continue;
		}
		if ( dummy istouching( effects_bunker ) )
		{
			level.effects_bunker[ level.effects_bunker.size ] = EntFx;
			continue;
		}
		if ( dummy istouching( effects_ww2 ) )
		{
			level.effects_ww2[ level.effects_ww2.size ] = EntFx;
			continue;
		}
		if ( dummy istouching( effects_lincoln ) )
		{
			level.effects_lincoln[ level.effects_lincoln.size ] = EntFx;
			continue;
		}
	}
	
	dummy delete();


	/*-----------------------
	VOLUMES CONTROLED BY LEVEL TRIGGERS (EX: FLARES THAT GO THROUGH FLOORS)
	-------------------------*/	
	foreach( volume in triggered_fx_volumes )
	{
		triggers = getentarray( volume.target, "targetname" );
		assertex( triggers.size == 2, "Volume at " + volume.origin + "needs to target 2 triggers" );
		if ( triggers[ 0 ].script_noteworthy == "stopFx" )
		{
			triggers[ 0 ] thread fx_trigger_off_think( volume );
			triggers[ 1 ] thread fx_trigger_on_think( volume );
		}
		else
		{
			triggers[ 1 ] thread fx_trigger_off_think( volume );
			triggers[ 0 ] thread fx_trigger_on_think( volume );
		}
		
	}
}

fx_trigger_on_think( volume )
{
	while( true )
	{
		self waittill( "trigger" );
		array_thread( volume.fx, ::restartEffect );
		wait( 1 );
	}
}

fx_trigger_off_think( volume )
{
	wait( 1 );
	array_thread( volume.fx, ::pauseEffect );
	
	while( true )
	{
		self waittill( "trigger" );
		array_thread( volume.fx, ::pauseEffect );
		wait( 1 );
	}
}

cheap_destructibles_think()
{
	flag_wait( "player_heli_10a" );
	
	self setCanDamage( true );
	
	//hitsRemaining = randomintrange( 5, 10 );
	hitsRemaining = 5;
	
	effect = "cheap_vehicle_explosion";
	destroyedModel = undefined;
	bEarthquake = false;
	sound = "car_explode";
	fireFx = undefined;
	fireOffset = ( 0, 0, 0 );
	onFire = false;
	switch( self.model )
	{
		case "vehicle_mack_truck_short_green":
			hitsRemaining = 10;
			destroyedModel = "vehicle_mack_truck_short_destroy";
			effect = "cheap_mack_truck_explosion";
			//sound = "ffar_impact_armor_vehicle";
			sound = "exp_tanker_vehicle";
			fireFx = "tanker_fire";
			fireOffset = ( 0, 0, 110 );
			bEarthquake = true;
			break;
		case "vehicle_uaz_fabric_static":
			destroyedModel = "vehicle_uaz_fabric_dsr";
			break;
		case "vehicle_luxurysedan_2008_destructible":
			destroyedModel = "vehicle_luxurysedan_2008_destroy";
			break;
		case "vehicle_pickup_technical":
			destroyedModel = "vehicle_pickup_technical_destroyed";
			break;
	}
	
	while( true )
	{
		self waittill( "damage", damage, attacker );
		
		if ( !isdefined( attacker ) )
			continue;
		if ( ( isdefined( level.blackhawk ) ) && ( attacker != level.blackhawk ) )
			continue;
		
		hitsRemaining--;
		
		if ( hitsRemaining <= 0 )
			break;
	}
	
	// blows up
	playfx( getfx( effect ), self.origin );
	self thread play_sound_in_space( sound );
	if ( bEarthquake )
		earthquake( .4, 1.53, self.origin, 1024 );
	
	if ( isdefined( destroyedModel ) )
		self setModel( destroyedModel );
	else
		self delete();
	
	if ( isDefined( fireFx ) )
	{
		dummy = spawn( "script_origin", self.origin + fireOffset );
		dummy.angles = self.angles;
		fx = spawnFx( getFx( fireFx ), dummy.origin );
		triggerFx( fx );
		flag_wait( "player_heli_19" );
		fx delete();
		dummy delete();
	}

}

vehicle_delete_non_squad()
{
	
	vehicles_to_delete1 = level.vehicles[ "axis" ];
	vehicles_to_delete2 = level.vehicles[ "allies" ];
	vehicles_to_delete2 = array_remove( vehicles_to_delete2, level.blackhawk );
	foreach( vehicle in vehicles_to_delete2 )
	{
		if ( !isdefined( vehicle ) )
			continue;
		if ( ( isdefined( vehicle.vehicletype ) ) && ( GetSubStr(  vehicle.vehicletype, 0 ) == "littlebird" ) )
			vehicles_to_delete2 = array_remove( vehicles_to_delete2, vehicle );
			
	}
	vehicles_to_delete = array_merge( vehicles_to_delete1, vehicles_to_delete2 );
	vehicles_to_delete = remove_dead_from_array( vehicles_to_delete );
	foreach( vehicle in vehicles_to_delete )
	{
		if ( !isdefined( vehicle ) )
			continue;
		vehicle maps\_vehicle::godoff();
		vehicle delete();
	}

}

vehicle_delete_all()
{
	
	vehicles_to_delete1 = level.vehicles[ "axis" ];
	vehicles_to_delete2 = level.vehicles[ "allies" ];
	vehicles_to_delete = array_merge( vehicles_to_delete1, vehicles_to_delete2 );
	foreach( vehicle in vehicles_to_delete )
	{
		if ( !isdefined( vehicle ) )
			continue;
		vehicle maps\_vehicle::godoff();
		vehicle vehicle_delete();
	}
}

vehicle_delete_all_axis()
{
	
	vehicles_to_delete  = level.vehicles[ "axis" ];
	foreach( vehicle in vehicles_to_delete )
	{
		if ( !isdefined( vehicle ) )
			continue;
		vehicle maps\_vehicle::godoff();
		vehicle vehicle_delete();
	}
}

should_break_m203_hint( nothing )
{
	player = get_player_from_self();
	assert( isplayer( player ) );

	if ( gettime() > level.grenadeHint_timeout )
		return true;

	// am I using my m203 weapon?
	weapon = player getcurrentweapon();
	prefix = getsubstr( weapon, 0, 4 );
	if ( prefix == "m203" )
		return true;

	// do I have any m203 ammo to switch to?
	heldweapons = player GetWeaponsListAll();
	foreach ( weapon in heldweapons )
	{
		prefix = getsubstr( weapon, 0, 4 );
		if ( prefix != "m203" )
			continue;
		ammo = player getWeaponAmmoClip( weapon );
		if ( ammo > 0 )
			return false;
	}
	
	//no m203 being used, no m203 ammo to switch to....stop the hint
	return true;
}

drones_trenches()
{
	drone_warriors_trenches = getentarray( "drone_warriors_trenches", "targetname" );
	foreach( drone in drone_warriors_trenches )
		thread dronespawn( drone );
}


struct_delete( array, sFlag )
{
	flag_wait( sFlag );
	foreach( member in array )
	{
		member = undefined;
	}
}




	
//should_break_activate_heartbeat()
//{
//	assert( isplayer( self ) );
//
//	if ( gettime() > level.heartbeat_timeout )
//		return true;
//	
//	weapons = level.player getweaponslistprimaries();
//	has_motiontracker = false;
//	foreach ( weapon in weapons )
//	{
//		if ( weapon == level.motiontrackergun_on )
//		{
//			has_motiontracker = true;
//			break;
//		}
//	}
//	
//	return level.player getCurrentWeapon() == level.motiontrackergun_on || !has_motiontracker;
//}

//player_has_motiontracker()
//{
//	weapons = level.player GetWeaponsListAll();
//	if ( !isdefined( weapons ) )
//		return false;
//	foreach ( weapon in weapons )
//	{
//		if ( IsSubStr( weapon, "_mt_" ) )
//			return true;
//	}
//	return false;
//}

//motiontracker_enabled()
//{
//	return level.player getCurrentWeapon() == level.motiontrackergun_on;
//}
//

play_sound_then_kill_on_flag( sLine, origin, sFlag )
{
	soundOrg = spawn_tag_origin();
	soundOrg.origin = origin;
	soundOrg thread kill_me_on_flag( sFlag );
	soundOrg play_sound_on_tag_endon_death( sLine, "tag_origin" );
	if ( isdefined( soundOrg ) )
		soundOrg delete();
}

kill_me_on_flag( sFlag )
{
	self endon( "death" );
	flag_wait( sFlag );
	if ( isdefined( self ) )
		self delete();
}


remove_dead_targets_from_array( array )
{
	newArray = [];
	foreach( ent in array )
	{
		if ( !isdefined( ent ) )
			continue;
		if ( !isdefined( ent.dead ) )
			newArray[ newArray.size ] = ent;
	}
	return newArray;
}


destructible_trigger_think()
{
	//triggered by player, then does damage to its fixedNodeSafeRadius by a mortar)
	self waittill( "trigger" );
	
	playfx( level._effect[ "mortar" ][ "dirt" ], self.origin );
	earthquake( 0.25, 0.75, self.origin, 1250 );
	thread play_sound_in_space( level.scr_sound[ "mortar" ][ "dirt" ], self.origin );
	radiusDamage( self.origin, self.fixedNodeSafeRadius, 1000, 1000 );
}

escape_timer( iSeconds )
{
	level endon( "obj_rooftop_complete" );
	level endon( "kill_timer" );

	/*-----------------------
	TIMER SETUP
	-------------------------*/		
	level.hudTimerIndex = 20;
	level.timer = maps\_hud_util::get_countdown_hud();
	level.timer SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	// Retrieve pilot in: 
	level.timer.label = &"DCBURNING_TIME_REMAINING";
	level.timer settenthstimer( iSeconds );

	/*-----------------------
	TIMER EXPIRED
	-------------------------*/	
	thread timer_tick();
	wait( iSeconds );
	level.timer destroy();
	level thread mission_failed_out_of_time();
}

timer_tick()
{
	level endon( "obj_rooftop_complete" );
	level endon( "kill_timer" );
	while ( true )
	{
		wait( 1 );
		level.player thread play_sound_on_entity( "countdown_beep" );
	}
}

mission_failed_out_of_time()
{
	level.player endon( "death" );
	level endon( "kill_timer" );
	level notify( "mission failed" );
	musicstop( 1 );
	// Mission failed.
	setDvar( "ui_deadquote", &"DCBURNING_RAN_OUT_OF_TIME" );
	maps\_utility::missionFailedWrapper();
	level notify( "kill_timer" );
}

kill_timer()
{
	level notify( "kill_timer" );
	if ( isdefined( level.timer ) )
		level.timer destroy();
}


vehicle_delete_when_hit_script_noteworthy( script_noteworthy )
{
	self endon( "death" );
	aPathNodes = vehicle_get_path_array();
	deleteNode = undefined;
	foreach( node in aPathNodes )
	{
		if ( ( isdefined( node.script_noteworthy ) ) && ( node.script_noteworthy == script_noteworthy ) )
		{
			deleteNode = node;
			break;
		}
	}
	assertex( isdefined( deleteNode ), "Vehicle at " + self.origin + " has no node in its chain with the script_noteworthy: " + script_noteworthy );
	deleteNode waittill( "trigger" );
	self notify( "deleted_through_script" );
	wait( 0.05 );
	self thread vehicle_delete();
}

vehicle_delete_when_out_of_sight()
{
	if ( !isdefined( self ) )
		return;
	self endon( "death" );
	while( isdefined( self ) )
	{
		wait( 2 );
		if ( within_fov( level.player.origin, level.player.angles, self.origin, level.cosine[ "90" ] ) )
			continue;
			
		break;
	}
	self thread vehicle_delete();
}

waittill_notify_then_notify( notifyToWaitFor, notifyToNotify )
{
	self endon( "death" );
	self waittill( notifyToWaitFor );
	self notify( notifyToNotify );
}

waittill_flag_then_notify( flagToWaitFor, notifyToNotify )
{
	self endon( "death" );
	flag_wait( flagToWaitFor );
	self notify( notifyToNotify );
}

player_blackhawk_health_tweaks()
{
	//thread player_heli_damage_ramp();
	
	level.player enableinvulnerability();
	
	
//	old_longRegenTime = level.player.gs.longRegenTime;	
//	old_deathInvulnerableTime = level.player.deathInvulnerableTime;				//2500
//	old_bg_viewKickScale = getdvar( "bg_viewKickScale" ); 						// 0.8
//	old_bg_viewKickMax = getdvar( "bg_viewKickMax" );							// 90
//	old_bg_viewKickMin = getdvar( "bg_viewKickMin" );							// 5
//	level.player ent_flag_clear( "near_death_vision_enabled" );
//	
//	level.player.gs.longRegenTime = 500;	
//	level.player.baseIgnoreRandomBulletDamage = true;
//	level.ignoreRandomBulletDamage = true;
//	level.player.deathInvulnerableTime = 7000;
//	setsaveddvar( "bg_viewKickScale", 0.1 );
//	setsaveddvar( "bg_viewKickMax", "5" );
//	setsaveddvar( "bg_viewKickMin", "1" );
//	
//	flag_wait( "player_crash_done" );
//	
//	level.player.gs.longRegenTime = old_longRegenTime;
//	level.player.deathInvulnerableTime = old_deathInvulnerableTime;
//	setsaveddvar( "bg_viewKickScale", old_bg_viewKickScale );
//	setsaveddvar( "bg_viewKickMax", old_bg_viewKickMax );
//	setsaveddvar( "bg_viewKickMin", old_bg_viewKickMin );
//	level.player ent_flag_set( "near_death_vision_enabled" );

}

//player_heli_damage_ramp()
//{
//	flag_wait( "player_heli_14" );
//	while ( !flag( "player_crash_done" ) )
//	{
//		level.player waittill( "damage" );
//		level.player enableInvulnerability();
//		wait( .5 );
//		level.player disableInvulnerability();
//	}
//}


flag_set_when_volume_cleared_of_bad_guys( volume, sFlagToSet )
{
	while( true )
	{
		wait( 1 );
		ai = volume get_ai_touching_volume( "axis" );
		if ( !isdefined( ai ) )
			break;
		if ( ai.size )
			continue;
		else
			break;
	}
	flag_set( sFlagToSet );
}

