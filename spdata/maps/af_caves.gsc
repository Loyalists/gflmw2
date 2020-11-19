#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\_slowmo_breach;
#include maps\af_caves_code;

#using_animtree( "generic_human" );

// got two tangos down below, do it!
DO_IT_TIME = 4;

main()
{
	set_console_status();
	
	af_caves_firsthalf_init_flags();
	
	default_start( ::start_default );
	add_start( "road", ::start_road );
	add_start( "rappel", ::start_rappel );
	add_start( "barracks", ::start_barracks, "barracks (cave entrance)" );
	add_start( "steamroom", ::start_steamroom );
	add_start( "ledge", ::start_ledge );
	add_start( "overlook", ::start_overlook );
	add_start( "control", ::start_control_room );
	add_start( "airstrip", ::start_airstrip );
	
	level.primaryWeapon = "cheytac_silencer";
	level.secondaryWeapon = "kriss_acog_silencer";
	
	PrecacheModel( "com_flashlight_on" );
	PrecacheModel( "weapon_parabolic_knife" );
	PrecacheModel( "com_cellphone_on_anim" );
	PrecacheItem( "scar_h_thermal_silencer" );
	PrecacheItem( "usp_silencer" );
	PrecacheItem( "rappel_knife" );
	PrecacheItem( "rpg_straight" );
	PrecacheItem( "hellfire_missile_af_caves" );
	PrecacheRumble( "damage_heavy" );
	PrecacheString( &"AF_CAVES_HINT_C4_SWITCH" );
	
	PreCacheModel( "ch_viewhands_player_gk_m4_sopmod_ii" );
	PreCacheModel( "ch_viewhands_gk_m4_sopmod_ii" );

	level.mortarNoIncomingSound = true;
	level.mortarNoQuake = true;
	
	maps\af_caves_fx::main();
	maps\af_caves_precache::main();
	
	//JK - Fog and vision are now set in af_caves_fog.gsc
	//VisionSetNaked( "af_caves_outdoors", 0 );
	//setExpFog( 3764.17, 19391, 0.661137, 0.554261, 0.454014, 0.7, 0 );

	level.goodFriendlyDistanceFromPlayerSquared = 250 * 250;
	level.cosine[ "70" ] = cos( 70 );
	level.cosine[ "45" ] = cos( 45 );
	
	maps\af_caves_backhalf::main_af_caves_backhalf_preload();
	maps\_attack_heli::preLoad();
	maps\_breach::main();
	maps\_hand_signals::initHandSignals();
	
	maps\_c4::main();
	
	maps\af_caves_anim::main(); 
	maps\createart\af_caves_fog::main();
	maps\_load::main();
	
	array_thread( GetEntArray( "steamroom_c4", "targetname" ), maps\_load::ammo_pickup, "c4" );
	
	maps\af_caves_backhalf::main_af_caves_backhalf_postload();
	maps\_load::set_player_viewhand_model( "ch_viewhands_player_gk_m4_sopmod_ii" );

	maps\_drone_ai::init();
	maps\_slowmo_breach::slowmo_breach_init();
	maps\_nightvision::main();
	
	maps\_stealth::main();
	level.price_stealth_road_sightDistSqrd = 40 * 40;
	level.price_weaponsfree_sightDistSqrd = 8000 * 8000;
	
	maps\_patrol_anims::main();
	
	animscripts\dog\dog_init::initDogAnimations();
	maps\_idle::idle_main();
	maps\_idle_phone::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_coffee::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	
	thread maps\_mortar::bunker_style_mortar();
	level thread maps\af_caves_amb::main();
	
	add_hint_string( "begin_descent", &"AF_CAVES_DESCEND", ::should_stop_descend_hint );
	
	// Press^3 [{+actionslot 1}] ^7to use Night Vision Goggles.
	add_hint_string( "nvg", &"SCRIPT_NIGHTVISION_USE", maps\_nightvision::ShouldBreakNVGHintPrint );
	add_hint_string( "rappel_melee", &"SCRIPT_PLATFORM_OILRIG_HINT_STEALTH_KILL", ::should_not_do_melee_rappel_hint );
	

	maps\_compass::setupMiniMap( "compass_map_afghan_caves" );
	
	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "price" );
	//createthreatbiasgroup( "dogs" );
	//createthreatbiasgroup( "airstrip_tower_enemy" );

	//setignoremegroup( "price", "airstrip_tower_enemy" );// airstrip_tower_enemy will ignore price
	//setignoremegroup( "airstrip_tower_enemy", "price" );// price will ignore airstrip_tower_enemy

	level.player setthreatbiasgroup( "player" );
	
	//airstrip_tower_enemy = getentarray( "tower_gunners", "script_noteworthy" );
	//array_thread( airstrip_tower_enemy, ::add_spawn_function, ::set_threatbiasgroup, "airstrip_tower_enemy" );
	
	road_dogs = GetEntArray( "enemy_road_patrollers_dogs", "script_noteworthy" );
	array_thread( road_dogs, ::add_spawn_function, ::road_dog_think );
	
	road_patrollers = GetEntArray( "enemy_road_patrollers", "targetname" );
	array_thread( road_patrollers, ::add_spawn_function, ::road_patroller_spawnfunc );
	
	// spawn and setup Price
	price_spawner = getent( "price_spawner", "targetname" );
	price_spawner add_spawn_function( ::price_spawn );
	price_spawner add_spawn_function( ::set_threatbiasgroup, "price" );
	price_spawner spawn_ai();
	
	// price won't stop in front of the player's gun until later
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );

	//	Misc
	array_thread( getentarray( "clip_nosight", "targetname" ), ::clip_nosight_logic );

	player_rope = getent( "player_rope", "targetname" );
	player_rope hide();
	
	price_new_rope = getent( "soldier_rope", "targetname" );
	price_new_rope hide();

	rappel_railing_glowing = getent( "rappel_hookup_glowing", "targetname" );
	rappel_railing_glowing hide();
	
	thread steamroom_gate_setup();
   	
	level.mortarNoIncomingSound = true;
	level.mortarNoQuake = true;
	
	thread rappel_setup();
	thread barracks_setup();
	thread steamroom_setup();
	thread player_falling_kill_trigger();
	thread player_falling_to_death();
	thread setup_barrel_earthquake();
	
	thread maps\af_caves_backhalf::AA_backhalf_init();
	
	thread tv_cinematic_think();
	
	steamroom_door_closed = getent( "steamroom_door_closed", "targetname" );
	steamroom_door_closed hide_entity();
}

steamroom_gate_setup()
{
	level.steamroom_gate_open = GetEnt( "steamroom_door_open", "targetname" );
	level.steamroom_gate_closed = GetEnt( "steamroom_door_closed", "targetname" );
	
	level.steamroom_gate_closed hide_entity();
}

af_caves_firsthalf_init_flags()
{
	// global
	flag_init( "scripted_dialogue" );
	flag_init( "stealth_kill_dialogue_running" );
	flag_init( "unsuppressed_weapon_warning_played" );
	flag_init( "player_falling_kill_in_progress" );
	
	//  intro
	flag_init( "intro_dialogue_start" );
	flag_init( "intro_fade_in" );
	flag_init( "intro_faded_in" );
	flag_init( "player_intro_unlock" );
	flag_init( "intro_player_moved" );
	flag_init( "introscreen_feed_lines" );
	flag_init( "introscreen_feed_lines_done" );
	flag_init( "price_rise_up" );
	flag_init( "price_abort_intro_stop" );
	flag_init( "intro_player_past_starting_area" );
	flag_init( "intro_price_sent_to_post_getup_node" );
	flag_init( "intro_price_reached_post_getup_node" );
   	
	// road patrol
	flag_init( "price_at_hillside" );
	flag_init( "price_hillside_dialogue_done" );
	flag_init( "road_enemy_wiretap_dialogue_done" );
	flag_init( "road_group1_countdown_kill_aborted" );
	flag_init( "group1_countdown_kill_done" );
	flag_init( "road_group1_killed_without_stealthbreak" );
	flag_init( "road_group2_alerted" );
	flag_init( "road_group2_startmoving" );
	flag_init( "road_group2_walked_away" );
	flag_init( "road_group2_coming_back" );
	flag_init( "road_group2_lastchance" );
	flag_init( "road_player_broke_stealth" );
	flag_init( "road_uav_inbound" );
	flag_init( "player_shot_someone" );
	flag_init( "price_done_moving_to_road" );
	flag_init( "road_patrol_humans_cleared" );
	flag_init( "road_patrol_cleared" );
	
	// rappel
	flag_init( "descending" );
	flag_init( "rappel_threads" );
	flag_init( "price_at_rappel" );
	flag_init( "price_hooksup" );
	flag_init( "player_hooking_up" );
	flag_init( "player_hooked_up" );
	flag_init( "player_failed_rappel" );
	flag_init( "player_braked" );   	
	flag_init( "guard_2_exposing_himself" );
	flag_init( "player_killing_guard" );
	flag_init( "player_rappeled" );
	flag_init( "rappel_guards_react" );
	flag_init( "rappel_end" );
	flag_init( "end_of_rappel_scene" );

	// barracks
	flag_init( "barracks_price_ready_to_dodge_biggroup" );
	flag_init( "barracks_biggroup_passingby" );
	flag_init( "barracks_biggroup_gone" );
	flag_init( "barracks_stairguys_countdown_dialogue_done" );
	flag_init( "barracks_stairguys_spawned" );
	flag_init( "barracks_stairguys_countdown_kill_done" );
	flag_init( "barracks_stairguys_countdown_kill_aborted" );
	flag_init( "barracks_stealth_broken" );
	flag_init( "barracks_stealthbreak_survived" );
	flag_init( "destroy_tv" );
	flag_init( "barracks_follow_price" );

	// steam room
	flag_init( "steamroom_start" );
	flag_init( "steamroom_knifekill_setup_done" );
	flag_init( "steamroom_price_knifekill_sequencestart" );
	flag_init( "steamroom_price_knifekill_abort" );
	flag_init( "steamroom_price_knifekill_started" );
	flag_init( "steamroom_price_knifekill_walkup_abort" );
	flag_init( "steamroom_price_knifekill_committed" );
	flag_init( "steamroom_price_knifekill_done" );
	flag_init( "steamroom_halfway_point" );
	flag_init( "steamroom_door_preblow" );
	flag_init( "steamroom_door_blown" );
	flag_init( "steamroom_ambush_started" );
	flag_init( "steamroom_player_spotted" );
	flag_init( "steamroom_patrollers_protect_door" );
	flag_init( "steamroom_ambush_done" );
	flag_init( "steamroom_going_dark" );
	flag_init( "steamroom_lights_out" );
	flag_init( "steamroom_ambush_finish_dialogue_ended" );
	flag_init( "steamroom_done" );
}

//	****** Starts ****** //
start_default()
{
	level.player stealth_default();
	thread player_unsuppressed_weapon_warning();
	
	thread intro_setup();
}

start_road()
{
	level.player stealth_default();
	thread player_unsuppressed_weapon_warning();
	
	// warp player and price
	playerstruct = GetStruct( "road_player", "targetname" );
	pricestruct = GetStruct( "road_price", "targetname" );
	level.player teleport_to_node( playerstruct );
	level.price teleport_to_node( pricestruct );
	
	// stuff that would have been done already
	thread half_particles_setup();
	thread intro_music();
	
	flag_set( "price_goto_hillside" );
	flag_set( "intro_price_reached_post_getup_node" );
	
	thread objective_follow_price();
	thread road_setup();
	
	SoundSetTimeScaleFactor( "Music", 1 );
	SoundSetTimeScaleFactor( "Menu", 1 );
	SoundSetTimeScaleFactor( "Bulletimpact", 1 );
	SoundSetTimeScaleFactor( "Voice", 1 );
	SoundSetTimeScaleFactor( "effects2", 1 );
	SoundSetTimeScaleFactor( "Mission", 1 );
	SoundSetTimeScaleFactor( "Announcer", 1 );
	SoundSetTimeScaleFactor( "local", 1 );
	SoundSetTimeScaleFactor( "physics", 1 );
	SoundSetTimeScaleFactor( "ambient", 1 );
	SoundSetTimeScaleFactor( "auto", 1 );
}

start_rappel()
{
	level.player stealth_default();
	thread player_unsuppressed_weapon_warning();

	thread objective_follow_price();
	
	rappel_player = GetEnt( "rappel_player", "targetname" );
	rappel_price = GetEnt( "rappel_price", "targetname" );
	level.player teleport_to_node( rappel_player );
	level.price teleport_to_node( rappel_price );
	
	level.price AllowedStances( "stand", "crouch", "prone" );
	level.price ForceUseWeapon( "scar_h_thermal_silencer", "primary" );
	
	flag_set( "rappel_threads" );
	thread intro_music();
	
	wait( .5 );
	thread autosave_by_name( "rappel" );
}

start_barracks()
{
	thread rappel_price_setup_at_cave();
	
	cave_entrance_player = getent( "cave_entrance_player", "targetname" );
	cave_entrance_price = getent( "cave_entrance_price", "targetname" );
	level.player teleport_to_node( cave_entrance_player );
	level.price teleport_to_node( cave_entrance_price );
	
	level.player SwitchToWeapon( level.secondaryWeapon );

	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	level.price set_force_color( "r" );
	level.price allowedstances( "crouch" );
	
	level.player stealth_default();
	thread player_unsuppressed_weapon_warning();
	
	flag_set( "end_of_rappel_scene" );
	flag_set( "player_killing_guard" );
	
	thread stealth_music();

	wait .5;
	thread autosave_by_name( "cave_entrance" );
}

start_steamroom() //Starts at the bottom of the stairs just before the steamroom area.
{
	flag_set( "barracks_follow_price" );
	thread objective_follow_price_again();
	
	activate_trigger_with_targetname( "control_room_visionset_indoors" );
	
	steamroom_player = GetEnt( "steamroom_player", "targetname" );
	level.player teleport_to_node( steamroom_player );

	level.player stealth_default();
	thread player_unsuppressed_weapon_warning();
	
	level.player SwitchToWeapon( level.secondaryWeapon );
		
	steamroom_price = GetEnt( "steamroom_price", "targetname" );
	level.price teleport_to_node( steamroom_price );
	
	level.price AllowedStances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	
	//level.price enable_ai_color();
	//level.price set_force_color( "r" );

	//thread turn_off_stealth();
	
	flag_set( "steamroom_start" );
	
	wait( 0.5 );
	thread autosave_by_name( "steamroom" );
}

start_ledge()
{
	level notify( "start_ledge" );
	
	steamroom_door_setup();
	thread steamroom_door_full_open();
	
	level.player stealth_default();
	thread turn_off_stealth();
	
	flag_set( "steamroom_halfway_point" );
	
	ledge_player = getent( "ledge_player", "targetname" );
	level.player setorigin( ledge_player.origin );
	level.player setplayerangles( ledge_player.angles );
	thread maps\af_caves_backhalf::backhalf_loadout();
	ledge_price = getent( "ledge_price", "targetname" );
	level.price teleport( ledge_price.origin, ledge_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "scar_h_thermal_silencer", "primary" );
	
	wait( 0.1 ); // SRS hacky, let stealth set up on price so we can turn it off in the event thread
	flag_set( "steamroom_done" ); // SRS triggered at the end of the steamroom scripting, normally
	flag_set( "steamroom_ambush_finish_dialogue_ended" );
	
	wait .5;
	thread autosave_by_name( "ledge" );
}


start_overlook()
{
	overlook_player = getent( "overlook_player", "targetname" );
	level.player setorigin( overlook_player.origin );
	level.player setplayerangles( overlook_player.angles );
	thread maps\af_caves_backhalf::backhalf_loadout();
	overlook_price = getent( "overlook_price", "targetname" );
	level.price teleport( overlook_price.origin, overlook_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "m4_grenadier", "primary" );
	
	thread turn_off_stealth();
	
	
	flag_set( "player_crossed_bridge" );
	activate_trigger_with_targetname( "player_passed_bridge" );	
	
	wait .5;
	thread autosave_by_name( "overlook" );
}

start_control_room()
{

	control_room_player = getent( "control_room_player", "targetname" );
	level.player setorigin( control_room_player.origin );
	level.player setplayerangles( control_room_player.angles );
	thread maps\af_caves_backhalf::backhalf_loadout();
	control_room_price = getent( "control_room_price", "targetname" );
	level.price teleport( control_room_price.origin, control_room_price.angles );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "m4_grenadier", "primary" );
	level.price set_ignoreme( false );
	
//	thread kill_sentry_minigun();
	thread turn_off_stealth();
	
	thread maps\af_caves_backhalf::AA_breach_init();

	
	flag_set( "player_right_near_breach" );
	flag_set( "player_right_near_breach" );
	
	wait( 0.05 );
	level.price enable_ai_color();  // SRS override stealth defaults
	level.price AllowedStances( "stand", "crouch", "prone" );
}

start_airstrip()
{
	airstrip_player = getent( "airstrip_player", "targetname" );
	level.player setorigin( airstrip_player.origin );
	level.player setplayerangles( airstrip_player.angles );
	thread maps\af_caves_backhalf::backhalf_loadout();
	airstrip_price = getnode( "node_price_escape_cover", "targetname" );
	level.price teleport( airstrip_price.origin, airstrip_price.angles );
	level.price setgoalnode( airstrip_price );
	
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price forceUseWeapon( "m4_grenadier", "primary" );
	level.price set_ignoreme( false );
	
	thread turn_off_stealth();

	flag_set( "location_change_control_room" );
	
	flag_set( "obj_escape_complete" );
	
	wait( 1 );
	thread maps\af_caves_backhalf::AA_airstrip_init();
}

// ****** OBJECTIVES ****** // 

// ****** 1st Objective, Follow Cpt. Price ****** //
objective_follow_price()
{
	objective_number = 0;
	obj_position = level.price.origin;

	objective_add( objective_number, "active", &"AF_CAVES_FOLLOW_PRICE", obj_position );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, (0, 0, 70) );

	flag_wait( "price_hooksup" );

	wait .5;
	objective_state( objective_number, "done" );
	
	thread objective_rappel();
}

// ****** 2nd Objective, Rappel ****** //
objective_rappel()
{
	objective_number = 1;
	
	objective_add( objective_number, "active", &"AF_CAVES_RAPPEL", ( 3006, 11756, -1834 ) );
	objective_current( objective_number );
	
	flag_wait( "player_hooking_up" );

	wait 1;
	objective_state( objective_number, "done" );
}

// ****** 3rd Objective, Follow Cpt. Price ****** //
objective_follow_price_again()
{
	flag_wait( "barracks_follow_price" );
	
	Objective_State( 0, "active" );
	Objective_Current( 0 );
	Objective_OnEntity( 0, level.price );
	
	flag_wait( "steamroom_ambush_started" );
	
	Objective_String( 0, &"AF_CAVES_SUPPORT_PRICE" );
	Objective_SetPointerTextOverride( 0, &"AF_CAVES_OBJ_MARKER_SUPPORT" );
	
	flag_wait( "steamroom_ambush_done" );
	
	Objective_String( 0, &"AF_CAVES_FOLLOW_PRICE" );
	Objective_SetPointerTextOverride( 0, "" );
	
	flag_wait( "obj_ledge_traverse_given" );
	
	Objective_State( 0, "done" );
	
	/*
	objective_number = 2;
	obj_position = level.price.origin;

	objective_add( objective_number, "active", &"AF_CAVES_FOLLOW_PRICE", obj_position );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, (0, 0, 70) );

	wait .5;
	objective_state( objective_number, "done" );
	*/
}

objective_regroup_on_price()
{
	objective_number = 4;
	obj_position = level.price.origin;

	objective_add( objective_number, "active", &"AF_CAVES_REGROUP_WITH_PRICE", obj_position );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, (0, 0, 70) );

	flag_wait( "level_exit" );

	objective_state( objective_number, "done" );
}

// -------------
// --- INTRO ---
// -------------
intro_setup()
{
	thread half_particles_setup();
	
	thread intro_player();
	thread intro_catch_player_running_ahead();
	thread intro_music();
	thread intro_dialogue();
	thread intro_price_rise_out_of_sand();
	
	// level progression
	thread road_setup();
}

intro_catch_player_running_ahead()
{
	trigger_wait_targetname( "trig_intro_past_starting_area" );
	flag_set( "intro_player_past_starting_area" );
}

intro_player()
{
	playerstruct = GetStruct( "player_intro_spot", "targetname" );
	level.player teleport_to_node( playerstruct );
	level.player AllowCrouch( false );
	level.player AllowStand( false );
	level.player SetStance( "prone" );
	level.player DisableWeapons();
	
	wait( 0.2 );  // this is so the player drops to the ground before we freezecontrols
	level.player FreezeControls( true );  // just during black screen
	
	level.player.levelStartPos = level.player.origin;
	
	flag_wait( "player_intro_unlock" );
	level.player FreezeControls( false );
	level.player AllowCrouch( true );
	level.player AllowStand( true );
	level.player EnableWeapons();
	
	thread intro_player_catch_movement();
	
	player_speed_percent( 90 );
}

intro_player_catch_movement()
{
	// waittill after the player moves
	distsqrd = 15 * 15;
	while( DistanceSquared( level.player.origin, level.player.levelStartPos ) < distsqrd )
	{
		wait( 0.05 );
	}
	
	flag_set( "intro_player_moved" );
}

intro_dialogue()
{
	flag_wait( "intro_dialogue_start" );
	
	// "I'll wait for you at the exfil point. Three hours."
	radio_dialogue( "afcaves_nkl_waitforyou" );
	
	// "Don't bother. This was a one-way flight, mate."
	radio_dialogue( "afcaves_pri_dontbother" );
	
	thread intro_sandstorm_and_fadein_flag();

	// "Then good luck, my friend."
	radio_dialogue( "afcaves_nkl_goodluck" );
	
	flag_set( "price_rise_up" );
	
	flag_wait( "intro_faded_in" );
	
	thread intro_follow_objective();
	flag_set( "introscreen_feed_lines" );
	wait( 9.5 );
	flag_set( "introscreen_feed_lines_done" );
	
	if( !flag( "intro_player_moved" ) )
	{
		// "Move out."
		radio_dialogue( "afcaves_pri_moveout" );
	}
}

intro_follow_objective()
{
	flag_wait( "player_intro_unlock" );
	
	thread objective_follow_price();
}

intro_sandstorm_and_fadein_flag()
{
	thread maps\af_caves_fx::introSandStorm();
	wait( 0.25 );  // need to start the sandstorm before the blackscreen fades up
	flag_set( "intro_fade_in" );
}

intro_price_rise_out_of_sand()
{
	level.price PushPlayer( true );
		
	anim_ent = GetNode( "price_get_up", "targetname" );
	tarp = spawn_anim_model( "tarp", anim_ent.origin );
	
	price_and_tarp[ 0 ] = level.price;
	price_and_tarp[ 1 ] = tarp;
	
	// he waits to get up
	anim_ent anim_first_frame( price_and_tarp, "rise_up" );
	
	flag_wait( "price_rise_up" );
	
	delaythread( 4, ::flag_set, "player_intro_unlock" );
	
	// now he gets up
	anim_ent anim_single( price_and_tarp, "rise_up" );
	
	level.price.moveplaybackrate = 1.2;
	
	level.price AllowedStances( "stand", "crouch", "prone" );
	level.price.goalradius = 128;
	
	node = GetNode( "node_intro_price_postgetup", "targetname" );
	level.price SetGoalNode( node );
	if( !flag( "price_goto_hillside" ) )
	{
		level.price waittill( "goal" );
	}
	flag_set( "intro_price_reached_post_getup_node" );
}


// -------------------
// --- ROAD PATROL ---
// -------------------
road_setup()
{
	level.price PushPlayer( true );
	price_be_stealthy();
	
	road_stealth_settings();
	
	// deactivate trigger at bottom of hill so price doesn't prematurely move up to its corresponding color node when stealth is broken
	colortrig = GetEnt( "trig_script_color_allies_r5", "targetname" );
	colortrig trigger_off();
	
	thread road_price_to_hillside();
	
	thread road_ambient_action();
	thread road_autosave();
	
	//thread road_price_hillside_nag();
	thread road_price_hillside_dialogue();
	thread road_enemy_wiretap_dialogue();
	
	thread road_humans_cleared_tracker();
	thread road_stealthbreak_tracker();
	thread road_playerslide_stealthbreak();
	thread road_stealthbreak_price_dialogue();
	
	thread road_price_stealthbreak_think();
	
	thread road_group2_moveout();
	
	thread road_group1_countdown_kill();
	
	thread road_moveup_to_kill_group2();
	
	// level progression
	thread road_clear();
}



road_stealth_settings()
{	
	// whizby type stuff
	ai_event = [];
	ai_event[ "ai_eventDistBullet" ][ "hidden" ] = 256;
	
	// distance within which two AIs can instantly tell each other about new enemies
	ai_event[ "ai_eventDistNewEnemy" ][ "spotted" ]		 = 750;
	ai_event[ "ai_eventDistNewEnemy" ][ "hidden" ] 	 = 512;
	
	thread stealth_ai_event_dist_custom( ai_event );
	
	level.corpse_behavior_doesnt_require_player_sight = true;
}

road_ambient_action()
{
	level thread convoy_loop( "intro_ambient_canyonroad_convoy_vehicle", "player_hooked_up", 12, 25 );
	level thread convoy_loop( "intro_ambient_canyonroad_convoy_vehicle_lower", "player_hooked_up", 12, 25 );
	
	flag_wait( "road_group2_startmoving" );
	
	wait( 5.5 );
	
	air_convoy_road = maps\_vehicle::spawn_vehicles_from_targetname_and_drive( "air_convoy_road" );
}

road_autosave()
{
	flag_wait( "player_at_overlook" );
	
	thread autosave_stealth();
}

road_patroller_spawnfunc()
{
	corpse_array = [];
	corpse_array[ "found" ] = ::road_patroller_event_override_func;
	self stealth_corpse_behavior_custom( corpse_array );
	
	awareness_array = [];
	awareness_array[ "explode" ] = ::road_patroller_event_override_func;
	awareness_array[ "heard_scream" ] = ::road_patroller_event_override_func;
	awareness_array[ "doFlashBanged" ] = ::road_patroller_event_override_func;

	foreach ( key, value in awareness_array )
	{
		self maps\_stealth_event_enemy::stealth_event_mod( key, value );
	}
	
	if( IsDefined( self.script_parameters ) && IsSubStr( self.script_parameters, "group2" ) )
	{
		self thread road_group2_member_alerted_tracker();
	}
	
	if( self is_dog() )
	{
		return;
	}
	
	self.a.disableLongDeath = true;
	
	arr[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;  // escalate to searching immediately
	arr[ "attack" ] = ::small_goal_attack_behavior;
	self stealth_threat_behavior_replace( arr );
}

road_group2_member_alerted_tracker()
{
	level endon( "road_group2_alerted" );
	
	self thread road_group2_member_catch_stealth_not_normal();
	self waittill_any( "death", "group2_guy_alerted" );
	
	flag_set( "road_group2_alerted" );
}

road_group2_member_catch_stealth_not_normal()
{
	self endon( "death" );
	
	while( self ent_flag( "_stealth_normal" ) )
	{
		wait( 0.05 );
	}
	
	self notify( "group2_guy_alerted" );
}

road_patroller_event_override_func( type )
{
	self.favoriteenemy = level.player;
	wait( 1 );
}

/* fix for flashbanged guys sometimes doing the "radio back into base" animation - shut down by leads as NWF, keeping in case we need the fix later after all
road_patroller_event_override_func( type )
{
	self endon( "death" );
	
	self.favoriteenemy = level.player;
	wait( 1 );
	
	// if he's flashed, we need to wait until after he's recovered so he has a chance to see the player
	while( 1 )
	{
		if( self IsFlashed() )
		{
			wait( 0.25 );
		}
		
		wait( 0.5 );
		
		if( !self IsFlashed() )
		{
			break;
		}
	}	
}
*/

small_goal_attack_behavior()
{
	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );

	self.goalradius = 1024;
	minGoalRadius = 256;
	timeInc = 2;

	self endon( "death" );

	self ent_flag_set( "_stealth_override_goalpos" );

	while ( IsDefined( self.enemy ) && self ent_flag( "_stealth_enabled" ) )
	{
		gr = self.goalradius - 150;
		if( gr < minGoalRadius )
		{
			gr = minGoalRadius;
		}
		self.goalradius = gr;
		
		self SetGoalPos( self.enemy.origin );

		wait( timeInc );
	}
}

road_dog_think()
{
	arr[ "attack" ] = ::road_dog_attack_func;
	self stealth_threat_behavior_custom( arr );
	
	self stealth_pre_spotted_function_custom( ::road_dog_prespotted_func );
}

road_dog_attack_func()
{
	self endon( "death" );
	
	self clear_run_anim();
	
	// delay before attacking
	wait( 5 );
	self.goalradius = 6800;
	self SetGoalEntity( level.player );
}

road_human_prespotted_func_easier()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	wait( 4 );  // default is 2.25
}

road_human_prespotted_func_harder()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	wait( 3 );
}

road_dog_prespotted_func()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	// delay before telling other guys you noticed something
	wait( 5 );
}

road_price_to_hillside()
{
	flag_wait( "intro_price_reached_post_getup_node" );
	flag_wait( "price_goto_hillside" );
	
	thread intro_price_to_hillside_abort_notify( "player_moving_to_road" );
	thread intro_price_to_hillside_abort_notify( "_stealth_spotted" );
	thread intro_price_to_hillside_abort_notify( "player_shot_someone_in_group1" );
	
	level.price AllowedStances( "crouch" );
	
	node = getnode( "intro_price_hold_up_node", "targetname" );
  	node anim_reach_solo( level.price, "intro_stop" );
  	
  	flag_set( "price_at_hillside" );
    
	if ( flag( "price_abort_intro_stop" ) )
	{
		return;
	}
	
	node anim_single_solo( level.price, "intro_stop" );
	
	level.price.og_goalradius = level.price.goalradius;
	level.price.goalradius = 96;
	level.price PushPlayer( true );
	level.price SetGoalPos( level.price.origin );
}

intro_price_to_hillside_abort_notify( sNotifyString )
{
	level endon( "price_abort_intro_stop" );
	level waittill( sNotifyString );
	flag_set( "price_abort_intro_stop" );
}

/*
road_price_hillside_nag()
{
	level endon( "player_at_overlook" );
	
	wait 30;
	
	while ( !flag( "player_at_overlook" ) )
	{
		wait( randomintrange( 25, 35 ) );
		if ( flag( "player_at_overlook" ) )
			break;
			
		//Price: "Soap, over here."
		radio_dialogue( "pri_overhere" );
	}
}
*/

road_price_hillside_dialogue()
{
	level endon ( "player_moving_to_road" );
	level endon( "_stealth_spotted" );
	level endon( "player_shot_someone_in_group1" );
	level endon( "road_patrol_group1" );
	
	thread road_price_hillside_dialogue_stopper();
	level endon( "hillside_dialogue_stop" );
	
	flag_wait( "price_goto_hillside" );
	//Price: "Soap, I'm picking up a thermal spike up ahead. The cave must be somewhere over the edge"
	radio_dialogue( "pri_thermalspike" );
	
	//flag_wait( "price_at_hillside" );
	flag_wait( "player_at_overlook" );
	
	// "Hold up."
	radio_dialogue( "pri_holdup" );
	
	// "Enemy patrol."
	radio_dialogue( "pri_enemypatrol" );
	
	// "Hold your fire."
	radio_dialogue( "afcaves_pri_holdyourfire" );
	
	// Looks like Makarov's intel was solid. This is it.
	radio_dialogue( "afcaves_pri_intelwassolid" );
	
	// half the guys start moving down the road
	flag_set( "road_group2_startmoving" );
	
	wait( 3.5 );
	
	// "Good, they're splitting up. Let them separate."
	radio_dialogue( "afcaves_pri_splittingup" );
	
	wait( 1.5 );
	
	// "This decryption code better be worth the price we paid..."
	radio_dialogue( "afcaves_pri_decryptioncode" );
	
	flag_set( "price_hillside_dialogue_done" );
}

road_price_hillside_dialogue_stopper()
{
	level endon( "price_hillside_dialogue_done" );
	
	while( stealth_is_everything_normal() )
	{
		wait( 0.05 );
	}
	
	level notify( "hillside_dialogue_stop" );
}

road_enemy_wiretap_dialogue()
{
	level endon( "road_player_broke_stealth" );
	
	flag_wait( "price_hillside_dialogue_done" );
	
	wiretap_dialogue_wait();
	// "...(go) ahead Alpha?"
	radio_dialogue( "afcaves_schq_goahead" );
	
	wiretap_dialogue_wait();
	// "Riverbed all clear, over."
	radio_dialogue( "afcaves_sc1_riverbedclear" );
	
	wiretap_dialogue_wait();
	// "Bravo?"
	radio_dialogue( "afcaves_schq_bravo" );
	
	//wiretap_dialogue_wait();
	// "Catwalk all clear... visibility 100%, over."
	//radio_dialogue( "afcaves_sc2_catwalkclear" );/
	
	wiretap_dialogue_wait();
	// "Sandstorm. Not much to see right now, over."
	radio_dialogue( "afcaves_sc3_sandstorm" );
	
	wiretap_dialogue_wait();
	// "Zulu?"
	radio_dialogue( "afcaves_schq_zulu" );
	
	wiretap_dialogue_wait();
	// "...uh, we're starting our patrol east along the canyon, north side access road, over."
	radio_dialogue( "afcaves_sc1_startingpatrol" );
	
	//wiretap_dialogue_wait();
	// "Copy that, Disciple Four.  Finish your sweep and get back inside. Zulu team report's a heavy sandstorm on the way. Oxide out."
	//radio_dialogue( "afcaves_schq_finishsweep" );
	
	flag_set( "road_enemy_wiretap_dialogue_done" );
}

wiretap_dialogue_wait()
{
	while( 1 )
	{
		startTime = GetTime();
		
		flag_waitopen( "scripted_dialogue" );
		flag_waitopen( "stealth_kill_dialogue_running" );
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "_stealth_event" );
	
		if( GetTime() > startTime )
		{
			// let everything cool out for a moment
			wait( 5 );
		}
		else
		{
			break;
		}
	}
}

road_humans_cleared_tracker()
{
	flag_wait( "player_at_overlook" );
	
	group1 = get_ai_group_ai( "road_patrol_enemies_group1" );
	group2 = get_ai_group_ai( "road_patrol_enemies_group2" );
	
	allguys = array_combine( group1, group2 );
	
	while( group_has_live_human( allguys ) )
	{
		wait( 0.05 );
	}
	
	flag_set( "road_patrol_humans_cleared" );
}

road_stealthbreak_tracker()
{
	level endon( "player_hooked_up" );
	
	flag_wait( "_stealth_spotted" );
	
	thread road_remove_hillside_clip();
	thread road_remove_hillside_aiclip();
	
	flag_set( "road_player_broke_stealth" );
}

road_remove_hillside_aiclip()
{
	level endon( "player_hooked_up" );
	
	flag_wait( "_stealth_spotted" );
	clip = GetEnt( "sbmodel_hillside_brush_aiclip", "targetname" );
	
	clip hide_entity();
}

road_playerslide_stealthbreak()
{
	level endon( "road_player_broke_stealth" );
	
	flag_wait( "player_slid_downhill" );
	
	vol = GetEnt( "vol_player_slidedown_axis_stealthbreak", "targetname" );
	
	axis = vol get_ai_touching_volume( "axis" );
	axis = array_removedead( axis );
	axis = array_removeundefined( axis );
	axis = get_array_of_closest( level.player.origin, axis );
	
	if( !axis.size )
	{
		return;
	}
	
	alerter = undefined;
	foreach( guy in axis )
	{
		if( IsAlive( guy ) )
		{
			alerter = guy;
			break;
		}
	}
	
	if( !IsDefined( alerter ) )
	{
		return;
	}
	
	alerter.favoriteenemy = level.player;
	wait( 2 );
	
	if( IsAlive( alerter ) )
	{
		alerter.favoriteenemy = undefined;
	}
}

road_stealthbreak_price_dialogue()
{
	level endon( "road_patrol_cleared" );
	level endon( "road_patrol_humans_cleared" );
	
	lines = [];
	// "They're onto us - go loud."
	lines[ 0 ] = "afcaves_pri_ontousgoloud";
	// "We're compromised - go loud."
	lines[ 1 ] = "afcaves_pri_compromisedgoloud";
	
	while( !flag( "road_patrol_cleared" ) )
	{
		flag_wait( "_stealth_spotted" );
		
		if( flag( "road_patrol_humans_cleared" ) )
		{
			return;
		}
		
		radio_dialogue( random( lines ) );
		
		flag_waitopen( "_stealth_spotted" );
	}
}

road_price_stealthbreak_think()
{
	flag_wait( "price_at_hillside" );
	flag_wait( "road_player_broke_stealth" );
	
	battlechatter_off( "allies" );  // don't start chattering right now
	
	wait( 0.5 );
	
	level.price PushPlayer( false );
    level.price.dontEverShoot = undefined;
    level.price.maxsightdistsqrd = level.price_weaponsfree_sightDistSqrd;
	level.price set_ignoreme( true );
	
	thread road_price_stealthbreak_adjust_behavior();
	level.price thread force_weapon_when_player_not_looking( "scar_h_thermal_silencer" );
	
	if( IsDefined( level.price.og_goalradius ) )
	{
		while( level.price._animActive > 0 )
		{
			wait( 0.05 );
		}
		level.price.goalradius = level.price.og_goalradius;
		level.price.og_goalradius = undefined;
	}
}

road_price_stealthbreak_adjust_behavior()
{
	og_threatbias = level.price.threatbias;
	level.price.threatbias = -350;
	
	og_baseaccuracy = level.price.baseaccuracy;
	level.price.baseaccuracy = 100;
	
	while( !stealth_is_everything_normal() )
	{
		wait( 0.05 );
	}
	
	level.price.threatbias = og_threatbias;
	level.price.baseaccuracy = og_baseaccuracy;
}

road_group2_moveout()
{
	level endon( "_stealth_spotted" );
	
	flag_wait( "road_group2_startmoving" );
	
	group2 = get_ai_group_ai( "road_patrol_enemies_group2" );
	array_thread( group2, ::road_group2_moveout_aithink, group2 );		
}

force_180turn()
{
	self anim_generic_run( self, "patrol_turn180" );
}

road_group2_moveout_aithink( group2 )
{
	self endon( "death" );
	self endon( "_stealth_spotted" );
	
	level.road_group2_newgroup = 0;
	self thread road_group2_monitor_distance();
	level thread road_group2_walkaway_wait( group2 );
	
	if( !self is_dog() )
	{
		// dog handler should go immediately
		if( !IsDefined( self.script_pet ) )
		{
			wait( RandomFloatRange( 2, 3.5 ) );
			self notify( "end_patrol" );
			self force_180turn();
		}
		else
		{
			self notify( "end_patrol" );
			wait( 0.05 );
		}
		self thread maps\_patrol::patrol( self.script_noteworthy );
		
		// walk faster
		thread road_group2_moveout_adjust_movespeed();
	}
	// dog #2 needs to start later so he doesn't run into his master when trying to heel during the 180 turn
	else if( self.script_pet == 2 )
	{
		self.script_pet = -1;
		handler = undefined;
		foreach( guy in group2 )
		{
			if( !guy is_dog() && IsDefined( guy.script_pet ) && guy.script_pet == 2 )
			{
				handler = guy;
				break;
			}
		}
		
		if( !IsDefined( handler ) )
		{
			// player killed handler - dog will bark
			return;
		}
		
		handler endon( "death" );
		
		waitNode = GetStruct( "relink_pet", "script_noteworthy" );
		waitNode waittill( "trigger" );
		
		self.script_pet = 2;
		handler maps\_patrol::linkPet();
	}
	
	// wait to hit the trigger twice before registering that we're coming back
	trig = GetEnt( "trig_road_group2_nearendpath", "targetname" );
	numReqHits = 2;
	numHits = 0;
	while( numHits < numReqHits )
	{
		trig waittill( "trigger", other );
		
		if( other == self )
		{
			numHits++;
			
			while( self IsTouching( trig ) )
			{
				wait( 0.1 );
			}
		}
	}
	
	if( !flag( "road_group2_coming_back" ) )
	{
		flag_set( "road_group2_coming_back" );
	}
	
	self thread road_group2_ai_alert_when_find_bodies();
	
	// getting close to where they can see the bodies
	trigger_wait_targetname( "trig_road_group2_midpath" );
	if( !flag( "road_group2_lastchance" ) )
	{
		flag_set( "road_group2_lastchance" );
	}
}

road_group2_ai_alert_when_find_bodies()
{
	self endon( "death" );
	
	while( !self ent_flag( "_stealth_found_corpse" ) )
	{
		wait( 0.1 );
	}
	
	self.favoriteenemy = level.player;
	wait( 2 );
	self.favoriteenemy = undefined;
}

road_group2_moveout_adjust_movespeed()
{
	self.moveplaybackrate = 1.25;
	self waittill( "_stealth_spotted" );
	self.moveplaybackrate = 1;
}

road_group2_monitor_distance()
{
	self endon( "death" );
	self endon( "_stealth_spotted" );
	
	dist = 500;
	org = ( 2408, 13424, -1840 );
	
	while( Distance2D( self.origin, org ) < dist )
	{
		wait( 0.05 );
	}
	
	level.road_group2_newgroup++;
}

road_group2_walkaway_wait( group2 )
{
	numGuys = group2.size;
	
	while( group2.size > level.road_group2_newgroup )
	{
		wait( 0.05 );
	}
	
	flag_set( "road_group2_walked_away" );
}

// handles coop shooting the first group of guys on the road patrol
road_group1_countdown_kill()
{
	level thread road_group1_countdown_kill_spottedflag();
	level thread road_group1_countdown_kill_alldead_flag();
	level endon( "_stealth_spotted" );
	
	flag_wait( "road_group2_walked_away" );
	flag_wait( "road_enemy_wiretap_dialogue_done" );
	
	while( !stealth_is_everything_normal() )
	{
		wait( 0.1 );
	}
	
	thread autosave_stealth();
	
	level notify( "road_group1_countdown_kill_alldead_flag_stop" );
	
	group1 = get_ai_group_ai( "road_patrol_enemies_group1" );
	left = [];
	right = [];
	dog = undefined;
	
	foreach( guy in group1 )
	{
		self.dontattackme = true;
		
		if( guy is_dog() )
		{
			dog = guy;
			continue;
		}
		else
		{
			// player only gets extra time on normal and easy
			if( level.gameskill < 2 )
			{
				guy stealth_pre_spotted_function_custom( ::road_human_prespotted_func_easier );
			}
			else
			{
				// increasing a bit for all difficulties since Price was having trouble reliably shooting both targets within the default prespotted time (2.25 seconds)
				guy stealth_pre_spotted_function_custom( ::road_human_prespotted_func_harder );
			}
		}
		
		if( IsDefined( guy.script_parameters ) )
		{
			if( guy.script_parameters == "leftside" )
			{
				left[ left.size ] = guy;
			}
			else if( guy.script_parameters == "rightside" )
			{
				right[ right.size ] = guy;
			}
		}
	}
	
	ASSERT( left.size == 2, right.size == 2, IsDefined( dog ) );
	
	priceVictims = left;
	playerVictims = right;
	
	array_thread( group1, ::road_group1_countdown_kill_trackdamage, playerVictims );
	level thread road_group1_countdown_kill_dialogue();
	
	msg = level waittill_any_return( "player_shot_someone_in_group1", "countdown_kill_dialogue_done" );
	
	playerTimedOut = false;
	if( IsDefined( msg ) && msg == "countdown_kill_dialogue_done" )
	{
		playerTimedOut = true;
	}
	
	// trade target groups if the player shot the "wrong" guy
	if( IsDefined( level.playerShotCorrectVictim ) && !level.playerShotCorrectVictim )
	{
		temp = priceVictims;
		priceVictims = playerVictims;
		playerVictims = temp;
	}
	
	price_be_lethal();
	level.price ClearEnemy();
	
	while( !all_dead( priceVictims ) )
	{
		foreach( guy in priceVictims )
		{
			if( !IsAlive( guy ) )
			{
				wait( 0.05 );
				continue;
			}
			
			if( !IsAlive( level.price.enemy ) )
			{
				price_kill( guy );
				guy waittill( "death" );
			}
			
			wait( 0.05 );
		}
	}
	
	if( IsAlive( dog ) )
	{
		// give player a chance to get the dog
		wait( 1.5 );
	}
	
	playerKilledDog = true;
	if( IsAlive( dog ) )
	{
		price_kill( dog );
		dog waittill( "death", attacker );
		
		if( attacker == level.price )
		{
			playerKilledDog = false;
		}
	}
	
	flag_wait( "road_patrol_group1" ); // deathflag
	
	// wait so Price has non-superhuman reaction time
	wait( 1 );
	
	// congratulate the player if stealth wasn't broken
	if( !flag( "road_player_broke_stealth" ) )
	{
		// player didn't shoot when Price said to
		if( playerTimedOut )
		{
			// "We have to work together, Soap - stick to the plan next time."
			radio_dialogue( "afcaves_pri_sticktoplan" );
		}
		// player kinda messed up and shot a different guy than Price said
		else if( !level.playerShotCorrectVictim )
		{
			// "Close enough."
			radio_dialogue( "afcaves_pri_closeenough" );
		}
		// player got his, plus the dog
		else if( playerKilledDog )
		{
			// "Just like old times."
			radio_dialogue( "afcaves_pri_justlikeoldtimes" );
		}
		// player just got his, price got the dog
		else
		{
			// "Dog neutralized, I count five tangos down."
			radio_dialogue( "afcaves_pri_dogneutralized" );
		}
		
		flag_set( "road_group1_killed_without_stealthbreak" );
	}
	
	flag_set( "group1_countdown_kill_done" );
}

road_group1_countdown_kill_spottedflag()
{
	level endon( "group1_countdown_kill_done" );
	level endon( "road_group1_countdown_kill_aborted" );
	
	level waittill( "_stealth_spotted" );
	
	flag_set( "road_group1_countdown_kill_aborted" );
}

road_group1_countdown_kill_alldead_flag()
{
	level endon( "group1_countdown_kill_done" );
	level endon( "road_group1_countdown_kill_alldead_flag_stop" );
	level endon( "road_group1_countdown_kill_aborted" );
	
	flag_wait( "road_patrol_group1" );
	
	flag_set( "road_group1_countdown_kill_aborted" );
}

road_group1_countdown_kill_dialogue()
{
	level endon( "_stealth_spotted" );
	level endon( "road_group2_alerted" );
	level endon( "player_shot_someone_in_group1" );
	
	flag_set( "stealth_kill_dialogue_running" );
	
	// "Focus on the group on the right, directly beneath us. Let's take them out first."
	radio_dialogue( "afcaves_pri_grouponright" );
	
	// "I'll take the two on the left."
	radio_dialogue( "afcaves_pri_twoonleft" );
	
	// "On my mark."
	radio_dialogue( "afcaves_pri_onmymark" );
	
	// "Three..."
	radio_dialogue( "afcaves_pri_three" );
	
	// "Two..."
	radio_dialogue( "afcaves_pri_two" );
	
	// "One..."
	radio_dialogue( "afcaves_pri_one" );
	
	// "Mark."
	radio_dialogue( "afcaves_pri_mark" );
	
	flag_clear( "stealth_kill_dialogue_running" );
	
	wait( 1 );  // delay to let the player shoot before we chastize him for not shooting
	level notify( "countdown_kill_dialogue_done" );
}

all_dead( arr )
{
	foreach( guy in arr )
	{
		if( IsAlive( guy ) )
		{
			return false;
		}
	}
	
	return true;
}

road_group1_countdown_kill_trackdamage( playerVictims )
{
	level endon( "player_shot_someone_in_group1" );
	
	self waittill( "damage", damage, attacker );
	
	if( attacker == level.player )
	{
		level.playerShotCorrectVictim = false;
		
		if( array_contains( playerVictims, self ) )
		{
			level.playerShotCorrectVictim = true;
		}
		
		level notify( "player_shot_someone_in_group1" );
	}
}

road_price_group2_warnings()
{
	level endon( "road_patrol_group2" );
	level endon( "road_group2_alerted" );
	
	flag_wait( "road_group2_lastchance" );
	// "Soap, they're about to find the bodies! We need to take them out!"
	radio_dialogue( "afcaves_pri_findthebodies" );
}

road_moveup_to_kill_group2()
{
	// Price only moves up when the first group is dead
	flag_wait( "road_patrol_group1" );
	
	// if we didn't skip the countdown...
	if( !flag( "road_group1_countdown_kill_aborted" ) )
	{
		// wait for it to finish, or for it to abort
		if( !flag( "group1_countdown_kill_done" ) )
		{
			flag_wait_any( "group1_countdown_kill_done", "road_group1_countdown_kill_aborted" );
		}
	}
	
	while( !stealth_is_everything_normal() )
	{
		wait( 0.05 );
	}
	
	// make sure everyone in group2 isn't dead already or that they weren't alerted
	if( !flag( "road_patrol_group2" ) && !flag( "road_group2_alerted" ) )
	{
		thread road_price_group2_warnings();
		
		wait( 0.5 );  // human reaction time
		
		if( !flag( "road_patrol_group2" ) && !flag( "road_group2_alerted" ) )
		{
			// "All right, we've got to take out the other group before they come back. Move."
			thread radio_dialogue( "afcaves_pri_beforecomeback" );
		}
	}
	
	level.price thread force_weapon_when_player_not_looking( "scar_h_thermal_silencer" );
	
	price_be_stealthy();
   	
	level.price set_ignoreme( true );
	
	thread road_remove_hillside_clip();
	
	// activate trigger now that price can move up
	colortrig = GetEnt( "trig_script_color_allies_r5", "targetname" );
	colortrig trigger_on();
	colortrig notify( "trigger" );
	
	anim_ent = getent( "price_slide_animent", "targetname" );
	level.price.goalradius = 24;
	anim_ent anim_reach_solo( level.price, "price_slide" );
	
	//if( !flag( "road_group2_alerted" ) )
	//{
		anim_ent anim_single_solo( level.price, "price_slide" );
	//}
	
	if( !flag( "road_group2_alerted" ) )
	{
		level.price disable_ai_color();
		level.price.goalradius = 256;
	}
	
	// first spot on road to move to
	node1 = GetNode( "node_price_roadspot_1", "targetname" );
	level.price SetGoalNode( node1 );
	level.price waittill( "goal" );
	
	if( !flag( "player_slid_downhill" ) && !flag( "road_patrol_group2" ) )
	{
		// nag player to come down the hill
		thread road_moveup_to_kill_group2_nag_player();
	}
	
	// make sure player is down on the road
	flag_wait( "player_slid_downhill" );
	
	level.price AllowedStances( "stand", "crouch", "prone" );
	
	if( !flag( "road_group2_alerted" ) )
	{
		// "Quickly, let's move up and take the others."
		thread radio_dialogue( "afcaves_pri_taketheothers" );
	}
	
	level.price disable_ai_color();
	level.price.goalradius = 64;
	
	// next spot on road
	node2 = GetNode( "node_price_roadspot_2", "targetname" );
	level.price SetGoalNode( node2 );
	level.price waittill( "goal" );
	
	// price can be seen by enemies now
	level.price set_ignoreme( false );
	
	flag_set( "price_done_moving_to_road" );
	
	if( !flag( "road_group2_alerted" ) )
	{
		thread road_group2_coop_kill();
	}
}

road_moveup_to_kill_group2_nag_player()
{
	level endon( "player_slid_downhill" );
	level endon( "road_group2_coming_back" );
	level endon( "road_group2_alerted" );
	level endon( "road_patrol_group2" );
	
	lines = [];
	// Soap! Down here, let's go!
	lines[ lines.size ] = "afcaves_pri_downhere";
	// Move up! The other group's coming back!
	lines[ lines.size ] = "afcaves_pri_groupsback";
	
	while( !flag( "player_slid_downhill" ) )
	{
		foreach( line in lines )
		{
			wait( 10 );
			
			if( !flag( "player_slid_downhill" ) )
			{
				radio_dialogue( line );
			}
		}
	}
}

road_remove_hillside_clip()
{
	if( IsDefined( level.removed_hillside_clip ) )
	{
		return;
	}
	else
	{
		level.removed_hillside_clip = true;
	}
	
	clip = GetEnt( "price_hillside_clip", "targetname" );  // so price doesn't fall down the cliff if the dogs attack him
	clip ConnectPaths();
	clip NotSolid();
}

road_group2_coop_kill()
{
	level endon( "_stealth_spotted" );
	
	group2 = get_ai_group_ai( "road_patrol_enemies_group2" );
	
	// figure out who's actually there (should be everybody)
	alive = [];
	foreach( ai in group2 )
	{
		if( IsAlive( ai ) )
		{
			alive[ alive.size ] = ai;
		}
	}
	ASSERT( alive.size == 3 );
	
	// "I'm in position - take the shot."
	thread radio_dialogue( "afcaves_pri_taketheshot" );
	
	thread road_group2_price_shoot_with_player( group2 );
	
	// wait for guys to turn around
	msg = "";
	if( !flag( "road_group2_coming_back" ) )
	{
		msg = level waittill_any_return( "player_shot_someone_in_group1", "road_group2_coming_back" );
	}
	
	if( msg == "road_group2_coming_back" || flag( "road_group2_coming_back" ) )
	{
		level notify( "price_shoot_abort" );
	
		// send Price back up the road a bit	
		thread road_group2_price_reposition();
	}
	else
	{
		// otherwise we're done since the player engaged these guys
		return;
	}
	
	msg = level waittill_any_return( "price_repositioned", "road_group2_alerted" );
	
	if( msg == "price_repositioned" )
	{
		// "I'm in position, ready to shoot."
		thread radio_dialogue( "afcaves_pri_readytoshoot" );
		
		// wait to shoot again
		thread road_group2_price_shoot_with_player( group2 );
	}
	else
	{
		// player engaged enemies or they were alerted somehow
		return;
	}
	
	//flag_wait( "road_group2_lastchance" );
	
	// "Soap, they're about to find the bodies! We need to take them out!"
	//radio_dialogue( "afcaves_pri_findthebodies" );
}

road_group2_price_reposition()
{
	// "Soap, they're coming back -  I'm repositioning to get out of sight."
	thread radio_dialogue( "afcaves_pri_repositioning" );
	
	level.price.goalradius = 96;
		
	node = GetNode( "node_price_roadspot_1", "targetname" );
	level.price SetGoalNode( node );
	level.price waittill( "goal" );
	
	level notify( "price_repositioned" );
}

road_group2_price_shoot_with_player( group2 )
{
	level endon( "price_shoot_abort" );
	
	// sort humans into the first slot
	arr = [];
	foreach( guy in group2 )
	{
		if( IsAlive( guy ) && !guy is_dog() )
		{
			arr[ arr.size ] = guy;
		}
	}
	
	foreach( guy in group2 )
	{
		if( IsAlive( guy ) && !array_contains( arr, guy ) )
		{
			arr[ arr.size ] = guy;
		}
	}
	
	group2 = arr;
	
	// wait for the player to shoot
	array_thread( group2, ::road_group2_coop_kill_trackdamage );
	level waittill( "player_shot_someone_in_group2", victim );
	
	price_be_lethal();
	level.price ClearEnemy();
	
	// Price shoots with the player
	while( !all_dead( group2 ) )
	{
		foreach( ai in group2 )
		{
			if( !IsAlive( ai ) )
			{
				wait( 0.05 );
				continue;
			}
			
			if( !IsAlive( level.price.enemy ) )
			{
				price_kill( ai );
				ai waittill( "death" );
			}
			
			wait( 0.5 );
		}
	}
}

road_group2_coop_kill_trackdamage()
{
	level endon( "player_shot_someone_in_group2" );
	
	self waittill( "damage", damage, attacker );
	
	if( attacker == level.player )
	{
		level notify( "player_shot_someone_in_group2", self );
	}
}

road_clear()
{
	level endon( "road_uav_inbound" );
	
	// deathflags
	flag_wait( "road_patrol_group1" );
	flag_wait( "road_patrol_group2" );
	
	flag_set( "road_patrol_cleared" );
	
	price_be_stealthy();
	
	wait( 1.25 );  // human reaction time
	
	if( !flag( "road_player_broke_stealth" ) || ( flag( "road_player_broke_stealth" ) && flag( "road_group1_killed_without_stealthbreak" ) ) )
	{
		// "We don't have much time before they find the bodies. Let's keep moving."
		thread radio_dialogue( "afcaves_pri_muchtime" );
	}
	else
	{
		// don't chastize for group2 stealthbreak because that encounter is pretty easy if player breaks stealth
		if( !flag( "road_group1_killed_without_stealthbreak" ) )
		{
			// "Soap, these aren't your average muppets. No more mistakes, let's go."
			radio_dialogue( "afcaves_pri_nomistakes" );
		}
	}
	
	flag_wait( "price_done_moving_to_road" );
	
	//thread road_price_sees_thermalspike();
	
	flag_set( "rappel_threads" );
}

road_price_sees_thermalspike()
{
	flag_wait( "price_dialogue_thermalspike" ); // flag triggered by price or player which ever hits it first

	//Price: "Soap, I'm picking up a thermal spike up ahead. The cave must be somewhere over the edge"
	radio_dialogue( "pri_thermalspike" );
}


// ---------------------
// --- AUSSIE RAPPEL ---
// ---------------------
rappel_setup()
{
	flag_wait( "rappel_threads" );
	
	thread rappel_guard_weapons();
	thread rappel_effects();
	thread rappel_kill_enemy_hint();
	thread rappel_price_hookup_nag();
	thread rappel_prices_rappel_start();
	thread rappel_show_objective_railing();
	thread rappel_player_rappel_setup();
	thread rappel_zodiacs();
	thread rappel_dialogue();
	thread rappel_ropes();
	thread rappel_price_setup_at_cave();
	thread stealth_music();
}

rappel_zodiacs()
{
	flag_wait( "player_hooking_up" );
	zodiacs = maps\_vehicle::spawn_vehicles_from_targetname_and_drive( "veh_rappel_zodiac" );
}

rappel_guard_weapons()//
{
	guards_guns = getentarray( "guard_weapons", "targetname" );
	foreach ( gun in guards_guns )
	{
		gun makeunusable();
		gun hide();
	}

	flag_wait( "player_killing_guard" );
	
	wait 1.75;
	guards_guns = getentarray( "guard_weapons", "targetname" );
	foreach ( gun in guards_guns )
	{
		gun show();
	}
	
	flag_wait( "end_of_rappel_scene" );

	wait 1;
	guards_guns = getentarray( "guard_weapons", "targetname" );
	foreach ( gun in guards_guns )
	{
		gun makeusable();
	}
}

rappel_player_rappel_setup()
{
	flag_wait( "price_hooksup" );

	wait( 0.5 );
	
	rappel_trigger = getent( "player_rappel_trigger", "targetname" );
	rappel_trigger sethintstring( &"AF_CAVES_RAPPEL_HINT" );	// Press and hold^3 &&1 ^7to rappel
	
	for ( ;; )
	{
		rappel_trigger waittill( "trigger" );
		if ( level.player isthrowinggrenade() )
			continue;
		if ( level.player isswitchingweapon() )
			continue;
		break;
	}
	rappel_trigger delete();

	af_caves_rappel_behavior();
}

rappel_effects()
{
	flag_wait( "rappel_end" );
	
	// done in guard react now
	//exploder( "rappel_disturbance" );
}

rappel_prices_rappel_start()
{
   	level.price allowedstances( "stand" );
 	level.price cqb_walk( "off" );
 	
	level.price.anim_ent = getent( "rappel_animent", "targetname" );
	level thread rappel_price_rappel( level.price.anim_ent );

	level.price.anim_ent anim_reach_solo( level.price, "pri_rappel_setup" );
	level.price.anim_ent anim_single_solo( level.price, "pri_rappel_setup" );

	if ( !flag( "player_hooking_up" ) )
		level.price.anim_ent thread anim_loop_solo( level.price, "pri_rappel_idle" );	
}

// a notetrack in the pri_rappel_setup animation calls this
price_rope_hookup( guy )
{
	level.price_rope = spawn_anim_model( "rope_price", level.price.anim_ent.origin );
	level.price.anim_ent thread anim_single_solo( level.price_rope, "rope_hookup" );
	
	flag_set( "price_hooksup" );
}

rappel_price_rappel( anim_ent )
{
	flag_wait( "player_hooking_up" );
	
	thread rappel_price_kill( anim_ent );
	level endon( "player_killing_guard" );
	
	level.price set_ignoreme( true );
	level.price set_ignoreme( true );
		
	// price is hooked up, now switch to the other rope model.	
	level.price_rope Delete();
	level.price_rope = spawn_anim_model( "rappel_rope_price", level.price.anim_ent.origin );
	
	price_and_rope[ 0 ] = level.price;
	price_and_rope[ 1 ] = level.price_rope;
	
	anim_ent anim_stopanimscripted();
	anim_ent anim_single( price_and_rope, "pri_rappel_jump" );
	
	anim_ent thread anim_loop( price_and_rope, "pri_hanging_idle", "stop_hang_idle" );
}

rappel_price_kill( anim_ent )
{
	flag_wait( "player_killing_guard" );
	
	wait 1;

	anim_ent notify( "stop_hang_idle" );
	anim_ent anim_stopanimscripted();
	level.price attach_model_if_not_attached( "weapon_parabolic_knife", "TAG_INHAND" );
	anim_ent thread anim_single_solo( level.price, "pri_rappel_kill" );
}

rappel_kill_enemy_hint()
{
	flag_wait( "rappel_end" );
	level.player enableweapons();

	cone = 8;
	// lerp view back to 0 fov
	level.player LerpViewAngleClamp( 0.5, 0.2, 0.2, cone, cone, cone, cone );//( 0.5, 0.2, 0.2, 0, 0, 0, 0 )

	wait( DO_IT_TIME );

	display_hint( "rappel_melee" );
}

rappel_guards_think()
{
	self endon( "death" );
	
	self.battlechatter = false;
	self set_ignoreall( true );
	self set_ignoreme( true );
}

rappel_guard2_patrol()// this is the guard below the price
{
	level endon( "player_killing_guard" );
	
	anim_ent = getent( "flick_animent", "targetname" );
	self.animname = "guard_2";
	
	wait 2.75;
	anim_ent anim_single_solo( self, "flick" );
	
	anim_ent thread anim_loop_solo( self, "guardB_idle", "stop_guardB_idle" );
}

rappel_guard2_death()// this is the guard below the price
{
	anim_ent = getent( "rappel_animent", "targetname" );
	self.animname = "guard_2";
	
	flag_wait( "player_killing_guard" );
	
	wait 1;
	self thread gun_Remove();
	anim_ent anim_single_solo( self, "guard_2_death" );	
	
	self.a.nodeath = true;
	self.allowdeath = true;
	self.diequietly = true;
	self kill();
}

rappel_guard2_kill_player()// this is the guard below the price
{
	level endon( "player_killing_guard" );
	
	anim_ent = getent( "flick_animent", "targetname" );
	self.animname = "guard_2";
	
	flag_wait( "rappel_end" );
	flag_wait( "rappel_guards_react" );
	
	anim_ent notify( "stop_guardB_idle" );
	anim_ent thread anim_single_solo( self, "guardB_react" );
}

rappel_guard1_kill_player()// this is the guard below the player
{
	level endon( "player_killing_guard" );
	
	anim_ent = getent( "players_rappel_guard", "targetname" );
	self.animname = "guard_1";
	
	anim_ent thread anim_loop_solo( self, "guardA_idle", "stop_guardA_idle" );
	
	flag_wait( "rappel_end" );
	wait( 7.2 );
	exploder( "rappel_disturbance" );
	wait( 0.5 );
	flag_set( "rappel_guards_react" );
	
	anim_ent notify( "stop_guardA_idle" );
	anim_ent thread anim_single_solo( self, "guardA_react" );
	
	wait 2;
	thread hint_fade();
	
	level.player EnableDeathShield( false );
	level.player EnableHealthShield( false );

	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	wait .2;
	magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player.origin + (0,0,64) );
	
	level.player kill();
	
	flag_set( "player_failed_rappel" );
}

rappel_show_objective_railing()
{
	flag_wait( "price_hooksup" );
	
	wait( 0.5 );
	rappel_railing = getent( "rappel_hookup", "targetname" );
	rappel_railing hide();

	rappel_railing_glowing = getent( "rappel_hookup_glowing", "targetname" );
	rappel_railing_glowing show();

	flag_wait( "player_hooking_up" );

	rappel_railing = getent( "rappel_hookup", "targetname" );
	rappel_railing show();

	rappel_railing_glowing = getent( "rappel_hookup_glowing", "targetname" );
	rappel_railing_glowing hide();
}

rappel_dialogue()
{
	flag_wait( "pri_hook_up" );
	
	flavorbursts_off( "axis" );
	
	//Price: "Here we go - hook up here."
	radio_dialogue( "pri_hookup" );
	
	// "Disciple Four, Oxide. What's your status, over?"
	thread radio_dialogue( "afcaves_schq_d4whatsyourstatus" );
	
	flag_wait( "player_hooking_up" );
	
	// "Disciple Four, Oxide, do you copy, over?"
	thread radio_dialogue( "afcaves_schq_d4doyoucopy" );
	
	wait 5.5;
	thread autosave_by_name( "rappeling" );
	
	//Price: "Go."
	radio_dialogue_overlap( "pri_go" );
	
	// "Hey, I'm not gettin' anything from Disciple Four at the north ridge road. Could be a bad transmitter."
	thread radio_dialogue( "afcaves_schq_badtransmitter" );
	
 	level.price thread play_sound_on_entity( "scn_afcaves_rappel_start_npc" );
	wait 5.3;
	//Price: "Got two tangos down below."
	radio_dialogue( "pri_2inthechest" );
	
	flag_wait( "rappel_end" );
	
	if( !flag( "player_killing_guard" ) )
	{
		endTime = GetTime() + milliseconds( DO_IT_TIME );
		while( GetTime() < endTime && !flag( "player_killing_guard" ) )
		{
			wait( 0.05 );
		}
	}

	if( !flag( "player_killing_guard" ) )
	{
		//Price: "Do it."
		radio_dialogue( "pri_doit" );
	}
}

rappel_price_hookup_nag()
{
	flag_wait( "price_hooksup" );
	level endon( "player_hooking_up" );
	
	while ( !flag( "player_hooking_up" ) )
	{
		wait( randomintrange( 24, 34 ) );
		if ( flag( "player_hooking_up" ) )
			break;
			
	//* Price: "Soap, hook up."                                                                                    
		radio_dialogue( "pri_soaphookup" );
	
		wait( randomintrange( 20, 30 ) );
		if ( flag( "player_hooking_up" ) )
			break;

	//* Price: "Soap, what's the problem? Hook up to the railing."                                                                                    
		radio_dialogue( "pri_whatstheproblem" );
			
		wait( randomintrange( 20, 30 ) );
		if ( flag( "player_hooking_up" ) )
			break;

	//* Price: "Soap, hook up, let's go."
		radio_dialogue( "pri_hookupletsgo" );
	}	
}

rappel_ropes()
{
	flag_wait( "player_killing_guard" );
	
	wait( 5 );
	
	player_rope = getent( "player_rope", "targetname" );
	player_rope show();
	
	level.price_rope delete();

	price_new_rope = getent( "soldier_rope", "targetname" );
	price_new_rope show();
}

rappel_price_setup_at_cave()
{	
	flag_wait( "end_of_rappel_scene" );
	
	level.default_goalradius = 2048;
	level.price disable_surprise();
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price set_ignoreall( true );
	level.price set_ignoreme( true );
	level.price.dontshootwhilemoving = undefined;
	level.price.baseAccuracy = 25; // I want him to take out a some enemies, but not all of them. 
}


// -------------------------
// --- CAVE 1 (BARRACKS) ---
// -------------------------
barracks_setup()
{
	// SPAWNFUNCS
	first_patroller = GetEnt( "backdoor_barracks_patroller_guy1", "targetname" );
	first_patroller thread add_spawn_function( ::barracks_firstpatroller_spawnfunc );
	first_patroller thread add_spawn_function( ::barracks_stealthsettings_spawnfunc );
	
	biggroup = GetEntArray( "barracks_biggroup", "targetname" );
	array_thread( biggroup, ::add_spawn_function, ::barracks_biggroup_spawnfunc );
	array_thread( biggroup, ::add_spawn_function, ::barracks_stealthsettings_spawnfunc );
	
	centerstanders = GetEntArray( "barracks_center_stander", "targetname" );
	array_thread( centerstanders, ::add_spawn_function, ::restrict_fov_until_stealth_broken );
	array_thread( centerstanders, ::add_spawn_function, ::barracks_stealthsettings_spawnfunc );
	
	chessplayers = GetEntArray( "backdoor_barracks_chess_player", "targetname" );
	array_thread( chessplayers, ::add_spawn_function, ::restrict_fov_until_stealth_broken );
	array_thread( chessplayers, ::add_spawn_function, ::barracks_stealthsettings_spawnfunc );
	
	pacingguy = GetEnt( "barracks_center_pacing_guy", "script_noteworthy" );
	pacingguy thread add_spawn_function( ::barracks_stealthsettings_spawnfunc );
	
	fridgeguy = GetEnt( "barracks_center_standing_fridge", "targetname" );
	fridgeguy thread add_spawn_function( ::barracks_stealthsettings_spawnfunc );
	
	nearleftguys = GetEntArray( "barracks_nearleft_guy", "targetname" );
	array_thread( nearleftguys, ::add_spawn_function, ::barracks_nearleftguy_spawnfunc );
	array_thread( nearleftguys, ::add_spawn_function, ::barracks_stealthsettings_spawnfunc );
	
	stairguys = GetEntArray( "barracks_stairguys", "targetname" );
	array_thread( stairguys, ::add_spawn_function, ::barracks_stairguys_spawnfunc );
	//array_thread( stairguys, ::add_spawn_function, ::barracks_stealthsettings_spawnfunc );
	// END SPAWNFUNCS
	
	// wait for rappel to end before starting these threads
	flag_wait( "end_of_rappel_scene" );
	
	flavorbursts_on( "axis" );
	
	level.corpse_behavior_doesnt_require_player_sight = undefined;
	
	thread barracks_player_and_price_setup();
	thread player_unsuppressed_weapon_warning();
	thread objective_follow_price_again();
	
	thread barracks_action();
	thread barracks_stealthbreak_action();
	thread barracks_stealthbreak_dialogue();
	thread barracks_center_group();
	thread barracks_chess_players();
	thread barracks_fridge_guy();
	thread barracks_enemy_cleanup_prethink();
	
	thread barracks_backdoor_radio();
	thread barracks_tv_light();
	thread barracks_destroy_tv();
}

barracks_stealthsettings_spawnfunc()
{
	corpse_array = [];
	corpse_array[ "found" ] = ::barracks_enemy_event_override_func;
	self stealth_corpse_behavior_custom( corpse_array );
	
	self stealth_pre_spotted_function_custom( ::barracks_prespotted_func );
	
	awareness_array = [];
	awareness_array[ "explode" ] = ::barracks_enemy_event_override_func;
	awareness_array[ "heard_scream" ] = ::barracks_enemy_event_override_func;
	awareness_array[ "doFlashBanged" ] = ::barracks_enemy_event_override_func;

	foreach ( key, value in awareness_array )
	{
		self maps\_stealth_event_enemy::stealth_event_mod( key, value );
	}
	
	self.a.disableLongDeath = true;
	
	arr[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;  // escalate to searching immediately
	arr[ "attack" ] = ::small_goal_attack_behavior;
	self stealth_threat_behavior_replace( arr );
}

// guys wait less time before telling others about where the player is
barracks_prespotted_func()
{
	wait( 0.5 );
}

barracks_enemy_event_override_func( type )
{
	self.favoriteenemy = level.player;
	wait( 3 );
	self.favoriteenemy = undefined;
}

barracks_nearleftguy_spawnfunc()
{
	// player is sprinting the level
	if( !flag( "barracks_biggroup_gone" ) )
	{
		wait( 0.1 );
		self notify( "end_patrol" );
		self.baseaccuracy = 500;
		self playerseek();
	}
	else
	{
		// need to detect the player shooting one of them to make it look like they're visible by the center group
		self thread barracks_nearleftguy_alertondeath();
	}
}

barracks_nearleftguy_alertondeath()
{
	level endon( "_stealth_spotted" );
	level endon( "steamroom_entrance" );
	
	self waittill( "death" );
	
	axis = GetAiArray( "axis" );
	axis = get_array_of_closest( self.origin, axis );
	
	notified = 0;
	numToNotify = 3;
	foreach( guy in axis )
	{
		if( IsAlive( guy ) && IsDefined( guy._stealth ) )
		{
			guy notify( "heard_scream", level.player.origin );
			notified++;
			
			if( notified >= numToNotify )
			{
				break;
			}
		}
	}
}

barracks_player_and_price_setup()
{
	player_speed_percent( 90 );
	
	level.price cqb_walk( "on" );
	level.price.moveplaybackrate = 1.2;
	level.price PushPlayer( true );
	level.price.pathrandompercent = 0;
	
	level.price disable_ai_color();
}

barracks_firstpatroller_spawnfunc()
{
	self.moveplaybackrate = 1.4;
	self.dieQuietly = true;
	
	level.barracks_firstpatroller = self;
	
	// catch player trying to skirt around to the left of where this guy pauses
	self thread barracks_firstpatroller_catch_player_sneaking_left();
}

barracks_biggroup_spawnfunc()
{
	parameters = self.script_parameters;
	
	if( RandomInt( 100 ) < 25 || ( IsDefined( parameters ) && IsSubStr( parameters, "flashlight" ) ) )
	{
		self thread give_flashlight();
	}
	
	if( IsDefined( parameters ) )
	{
		if( IsSubStr( parameters, "flashlight" ) && RandomInt( 100 ) < 25 )
		{
			self thread give_flashlight();
		}
		
		if( IsSubStr( parameters, "handsignal" ) )
		{
			self thread barracks_biggroup_leader_handsignal();
		}
		
		if( IsSubStr( parameters, "hallway_guard" ) )
		{
			self thread barracks_biggroup_guy_cqb_disable();
		}
	}
	
	self.interval = 60;
	self thread patroller_do_cqbwalk();
}

barracks_biggroup_guy_cqb_disable()
{
	self endon( "death" );
	self endon( "_stealth_spotted" );
	
	self ent_flag_init( "patroller_stop_cqbwalking" );
	self ent_flag_wait( "patroller_stop_cqbwalking" );
	
	self notify( "end_scan_when_idle" );
	
	self clear_generic_idle_anim();
	self thread disable_cqbwalk();
	self.moveplaybackrate = 1;
	maps\_patrol::set_patrol_run_anim_array();
}

barracks_biggroup_leader_handsignal()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	self waittill( "goal" );
	self handsignal( "onme", true, "_stealth_spotted" );
}

barracks_biggroup_hallway_guard()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	self waittill( "_patrol_reached_path_end" );
}

barracks_action()
{
	level endon( "_stealth_spotted" );
	
	thread barracks_rightside_warning();
	
	//Price: "Let's go." 
	thread radio_dialogue( "pri_letsgo" );
	flag_set( "barracks_follow_price" );
	
	thread autosave_stealth();
	
	thread price_goto_node( "node_backdoor_start_price" );
	flag_wait( "player_entered_barracks_backdoor_hallway" );
	
	thread price_goto_node( "node_backdoor_midpoint_price" );
	flag_wait( "backdoor_hallway_midpoint" );
	
	barracks_backdoor_stealth_settings();
	SetSavedDvar( "aim_aimAssistRangeScale", "0" );  // no aim assist right here so we don't auto track the big group
	
	thread barracks_price_biggroup_dodgeflag_set();
	thread price_goto_node( "price_easynow_node" );
	
	// first guy walking by
	thread activate_trigger_with_targetname( "spawn_patroller_guy1" );
	// "Tango up ahead. Do not engage."
	thread radio_dialogue( "afcaves_pri_tangoupahead" );
	
	// wait for the first patroller to get to his idle spot, or die, before spawning the other group
	flag_wait_any( "backdoor_firstpatroller_idlespot_reached", "backdoor_firstpatroller_deathflag" );
	
	if( !flag( "backdoor_firstpatroller_deathflag" ) )
	{
		flag_wait( "barracks_price_ready_to_dodge_biggroup" );
		flag_wait( "backdoor_hallway_biggroup" );
	}
	
	if( flag( "backdoor_firstpatroller_deathflag" ) )
	{
		// human reaction time
		wait( 1 );
	}
	
	// "Patrol coming our way - go left, quickly!"
	thread radio_dialogue( "afcaves_pri_patrolcoming" );
	
	thread price_goto_node( "node_barracks_price_biggroup_spotted" );
	
	if( flag( "backdoor_firstpatroller_deathflag" ) )
	{
		// add spawnfunc to have them look for the player if he killed the first guard
		biggroupSpawners = GetEntArray( "barracks_biggroup", "targetname" );
		array_thread( biggroupSpawners, ::add_spawn_function, ::alert_heard_scream );
		
		// "The guards know something's not right. Get out of sight and stay quiet."
		thread radio_dialogue( "afcaves_pri_guardsknow" );
	}
	
	thread activate_trigger_with_targetname( "trig_barracks_biggroup_spawn" );
	
	og_moveplaybackrate = level.price.moveplaybackrate;
	level.price.moveplaybackrate = 1;
	level.price cqb_walk( "off" );
	level.price.neverEnableCQB = true;
	//level.price AllowedStances( "crouch" );
	
	level.price waittill_any_timeout( 7.5, "goal" );  // timeout in case Price gets hung up on something... this has never actually happened in my testing though
	
	wait( 3.5 );  // let them start passing
	
	flag_set( "barracks_biggroup_passingby" );
	
	if( !flag( "backdoor_firstpatroller_deathflag" ) )
	{
		// "Let them pass."
		radio_dialogue( "afcaves_pri_letthempass" );
		thread barracks_biggroup_wiretap_dialogue();
	}
	
	// wait till all guys have passed
	thread barracks_biggroup_waittill_gone();
	flag_wait( "barracks_biggroup_gone" );
	
	barracks_waittill_stealth_normal();
	
	// take out the smoking guy if he's still around
	firstPatrollerWasAround = false;
	if( !flag( "backdoor_firstpatroller_deathflag" ) && !flag( "backdoor_firstpatroller_left_idle_area" ) )
	{
		firstPatrollerWasAround = true;
		
		level.barracks_firstpatroller.health = 5;
		
		// "Take out the guard having a smoke, or wait for him to move along."
		thread radio_dialogue( "afcaves_pri_havingasmoke" );
	}
	
	msg = flag_wait_any_return( "backdoor_firstpatroller_deathflag", "backdoor_firstpatroller_left_idle_area" );
	level notify( "barracks_firstpatroller_catch_player_abort" );
	
	barracks_waittill_stealth_normal();
	
	if( firstPatrollerWasAround && msg == "backdoor_firstpatroller_deathflag" )
	{
		// "Good night."
		radio_dialogue_stop();
		wait( 0.35 );
		thread radio_dialogue( "pri_goodnight" );
		wait( 1 );  // non superhuman reaction time before moving
	}
	
	thread autosave_stealth();
	
	SetSavedDvar( "aim_aimAssistRangeScale", "1" );
	
	//Price: "Let's go." 
	thread radio_dialogue( "pri_letsgo" );
	
	thread barracks_nearleft_dialogue();
	
	level.price.moveplaybackrate = 1;
	level.price cqb_walk( "on" );
	level.price.neverEnableCQB = false;
	level.price AllowedStances( "prone", "crouch", "stand" );
	
	// move up to the broken wall
	if( !flag( "player_near_price_shuffle_start" ) && !flag( "player_near_price_at_broken_wall" ) )
	{
		thread price_goto_node( "price_smoker_node" );
		flag_wait_any( "player_near_price_shuffle_start", "player_near_price_at_broken_wall" );
	}
	
	// move to the broken covercrouch wall right next to the center area
	thread price_goto_node( "node_price_shuffle_start" );
	level.price waittill( "goal" );
	
	flag_wait( "player_near_price_shuffle_start" );
	
	if( Distance( level.player.origin, level.price.origin ) <= 256 )
	{
		// "Easy now."
		delaythread( 0.5, ::radio_dialogue, "afcaves_pri_easynow" );
	}
	
	// make sure the player hasn't run way ahead, otherwise the flag has already been set and
	//  won't kill the scripted shuffle in time
	if( !flag( "barracks_player_near_stair_shooting_spot" ) )
	{
		// scripted shuffle!  price shuffles down the wall to the left
		node = GetNode( "node_price_barracks_near_center_2", "targetname" );
		level.price.scripted_shuffleNode = node;
		level.price AnimCustom( ::scripted_covercrouch_shuffle_left );
		level.price waittill( "scripted_shuffle_done" );
	}
	
	// move to the left of the barracks area
	thread barracks_nearleft_patrollers_watchsix();
	
	thread price_goto_node( "price_going_left_node" );
	
	flag_wait( "price_dialogue_stayleft" );
	
	if( !flag( "nearleft_guys_turnaround" ) )
	{
		node = GetNode( "price_going_left_node", "targetname" );
		price_wait_for_player( 240, node );
	}
	
	// move up near the end of the left path
	thread price_goto_node( "node_barracks_price_countdown_kill" );
	
	flag_wait( "barracks_player_near_stair_shooting_spot" );
	
	thread autosave_stealth();
	
	// guys come down the stairs for a coop kill
	thread barracks_stair_guys_coop_kill();
	flag_wait_any( "barracks_stairguys_countdown_kill_done", "barracks_stairguys_countdown_kill_aborted" );
	
	barracks_waittill_stealth_normal();
	
	level.price PushPlayer( true );
	thread price_goto_node( "node_barracks_price_before_stairs" );
	
	if( !flag( "barracks_player_past_price_near_steamroomdoor_spot" ) )
	{
		node = GetNode( "node_barracks_price_before_stairs", "targetname" );
		price_wait_for_player( 240, node );
	}
	
	// level progression
	flag_set( "steamroom_start" );
}

barracks_firstpatroller_catch_player_sneaking_left()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	level endon( "barracks_firstpatroller_catch_player_abort" );
	
	// wait for flag trigger - player is trying to sneak around the left side
	flag_wait( "player_near_price_shuffle_start" );
	
	// alert if alive
	if( IsAlive( self ) )
	{
		self.health = 150;
		self.favoriteenemy = level.player;
	}
}

alert_heard_scream()
{
	wait( 0.1 );  // let stealth initialize
	self notify( "heard_scream", level.player.origin );
}

barracks_waittill_stealth_normal()
{
	if( !stealth_is_everything_normal() )
	{
		// "The guards know something's not right. Get out of sight and stay quiet."
		thread radio_dialogue( "afcaves_pri_guardsknow" );
		
		while( !stealth_is_everything_normal() )
		{
			wait( 0.05 );
		}
	}
}

barracks_nearleft_dialogue()
{
	level endon( "steamroom_start" );
	level endon( "_stealth_spotted" );
		
	flag_wait( "price_dialogue_stayleft" );
	
	// "Two tangos in this corridor - hold your fire and stay to the left."
	radio_dialogue( "afcaves_pri_incorridor" );
	
	thread barracks_wiretap_dialogue();
}

barracks_rightside_warning()
{
	level endon( "steamroom_start" );
	level endon( "_stealth_spotted" );
	
	trig = GetEnt( "trig_script_color_alies_r18", "targetname" );
	
	while( 1 )
	{
		while( !stealth_is_everything_normal() )
		{
			wait( 0.05 );
		}
		
		wait( 0.1 );
		
		trig waittill( "trigger", other );
		if( !IsPlayer( other ) )
		{
			continue;
		}
		
		if( !stealth_is_everything_normal() )
		{
			continue;
		}
		
		// "Soap, that area's full of hostiles. We should keep to the left to avoid being spotted."
		radio_dialogue( "afcaves_pri_avoidbeingspotted" );
		break;
	}
}

barracks_backdoor_stealth_settings()
{
	stealth_ai_event_dist_default();
	
	ai_event = [];
	ai_event[ "ai_eventDistDeath" ][ "hidden" ] = 256;
	
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] = 100;
	
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 300;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 100;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 300;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 100;
	
	thread stealth_ai_event_dist_custom( ai_event );
	
	hidden = [];
	hidden[ "prone" ]	 = 300;
	hidden[ "crouch" ]	 = 600;
	hidden[ "stand" ]	 = 600;
	stealth_detect_ranges_set( hidden );
	
	corpseDists = [];
	corpseDists[ "player_dist" ]	= 725;  // if the player is farther than this away from a corpse, and level.corpse_behavior_doesnt_require_player_sight isn't set, the AI won't see the corpse
	corpseDists[ "sight_dist" ]		= 400;  // how far away AIs will spot a corpse
	stealth_corpse_ranges_custom( corpseDists );
	
	// reset from the road event where we needed this set
	level.corpse_behavior_doesnt_require_player_sight = undefined;
}

barracks_price_biggroup_dodgeflag_set()
{
	level waittill( "price_at_node" );
	wait( 1 );
	flag_set( "barracks_price_ready_to_dodge_biggroup" );
}

barracks_nearleft_patrollers_watchsix()
{
	level endon( "steamroom_start" );
	level endon( "barracks_player_near_stair_shooting_spot" );
	
	// the first flag gets set when the patrollers hit a node on their patrol path,
	//  the second flag gets set whenever the player is touching a trigger
	flag_wait_all( "barracks_nearleft_patroller_comingback", "barracks_player_farleft_back_area" );
	
	// "Tangos on our six."
	radio_dialogue( "afcaves_pri_tangosonsix" );
}

barracks_wiretap_dialogue()
{
	flavorbursts_off( "axis" );
	
	if( !flag( "nearleft_guys_turnaround" ) )
	{
		// "Disciple Five, Oxide. Gimme a sitrep over."
		radio_dialogue( "afcaves_schq_sitrep" );
		wait( 2 );
	}
	
	if( !flag( "nearleft_guys_turnaround" ) )
	{
		// "Disciple Five, Oxide. Gimme a sitrep over. [second time]"
		radio_dialogue( "afcaves_schq_sitrepover" );
	}
	
	flag_wait( "barracks_stairguys_countdown_kill_done" );
	
	flavorbursts_on( "axis" );
}

barracks_stair_guys_coop_kill()
{
	if( Distance2D( level.player.origin, level.price.origin ) > 670 )
	{
		// we need to warp price up behind the player cause he's too far behind
		level.price notify( "stop_going_to_node" );
		level.price thread waittill_goal_stealthspotted_interrupt();
		
		teleportOrg = ( 5184, 11394, -3735 );
		teleportAng = ( 0, 20.7, 0 );
		level.price ForceTeleport( teleportOrg, teleportAng );
		
		thread price_goto_node( "node_barracks_price_countdown_kill" );
		level.price thread move_fast_til_goal();
	}	
	
	spawners = GetEntArray( "barracks_stairguys", "targetname" );
	guys = spawn_ai_group( spawners, true );
	ASSERT( guys.size == 2 );
	
	flag_set( "barracks_stairguys_spawned" );
	
	// figure out the guy the player is supposed to kill
	playerVictim = undefined;
	priceVictim = undefined;
	foreach( guy in guys )
	{
		ASSERT( IsDefined( guy.script_parameters ) );
		
		if( guy.script_parameters == "left" )
		{
			playerVictim = guy;
		}
		else
		{
			priceVictim = guy;
		}
	}
	ASSERT( IsDefined( playerVictim ), IsDefined( priceVictim ) );
	
	level endon( "_stealth_spotted" );  // end if we're not stealthy anymore
	thread barracks_stairguys_countdown_kill_spottedflag();
	
	level.playerShotCorrectVictim = undefined;
	level.player.stealthkills = 0;
	array_thread( guys, ::barracks_stairguys_countdown_kill_trackdamage, playerVictim );
	thread barracks_stair_guys_coop_kill_countdown_dialogue();
	
	msg = level waittill_any_return( "player_shot_someone_on_stairs", "barracks_stairguys_countdown_dialogue_done" );
	
	playerTimedOut = false;
	if( IsDefined( msg ) && msg == "barracks_stairguys_countdown_dialogue_done" )
	{
		playerTimedOut = true;
	}
	
	// trade target groups if the player shot the "wrong" guy
	if( IsDefined( level.playerShotCorrectVictim ) && !level.playerShotCorrectVictim )
	{
		temp = priceVictim;
		priceVictim = playerVictim;
		playerVictim = temp;
	}
	
	level.price.ignoreall = false;
	price_be_lethal();
	level.price ClearEnemy();
	
	if( IsAlive( priceVictim ) )
	{
		price_kill( priceVictim );
		priceVictim waittill( "death" );
	}
	
	flag_wait( "barracks_stairguys_deathflag" );
	
	// wait so Price has non-superhuman reaction time
	wait( 1 );
	
	sayMove = false;
	// congratulate the player if stealth wasn't broken
	if( !flag( "barracks_stairguys_countdown_kill_aborted" ) )
	{
		// player killed them both
		if( level.player.stealthkills == 2 )
		{
			// "Impressive."
			radio_dialogue( "afcaves_pri_impressive" );
		}
		// player kinda messed up and shot a different guy than Price said
		else if( !level.playerShotCorrectVictim )
		{
			// "Close enough."
			radio_dialogue( "afcaves_pri_closeenough" );
			
			sayMove = true;
		}
	}
	else
	{
		sayMove = true;
	}
	
	if( sayMove )
	{
		// "Move."
		thread radio_dialogue( "afcaves_pri_move2" );
	}
	else
	{
		// "Clear. Go."
		thread radio_dialogue( "afcaves_pri_cleargo" );
	}
	
	price_be_stealthy();
	
	flag_set( "barracks_stairguys_countdown_kill_done" );
}

waittill_goal_stealthspotted_interrupt()
{
	self endon( "goal" );
	level waittill( "_stealth_spotted" );
	self notify( "level_stealth_spotted" );
}

move_fast_til_goal()
{
	og_moveplaybackrate = self.moveplaybackrate;
	self.moveplaybackrate = 1.3;
	self waittill_any( "goal", "level_stealth_spotted" );
	self.moveplaybackrate = og_moveplaybackrate;
}

barracks_stairguys_countdown_kill_spottedflag()
{
	level endon( "barracks_stairguys_countdown_kill_done" );
	
	level waittill( "_stealth_spotted" );
	
	flag_set( "barracks_stairguys_countdown_kill_aborted" );
}

barracks_stairguys_countdown_kill_trackdamage( playerVictim )
{
	self waittill( "damage", damage, attacker );
	
	if( attacker == level.player )
	{
		level.playerShotCorrectVictim = false;
		
		if( self == playerVictim )
		{
			level.playerShotCorrectVictim = true;
		}
		
		level.player.stealthkills++;
		
		level notify( "player_shot_someone_on_stairs" );
	}
}

barracks_stair_guys_coop_kill_countdown_dialogue()
{
	level endon( "_stealth_spotted" );
	level endon( "player_shot_someone_on_stairs" );
	level endon( "barracks_stairguys_countdown_aborted" );
	
	// "Soap, we've got two tangos with taclights coming down the stairs under that red light, dead ahead. We've got to take 'em out before they find us."
	radio_dialogue( "afcaves_pri_tangoswithtaclights" );
	
	// "I'll take the one on the right. On my mark."
	radio_dialogue( "afcaves_pri_takeoneright" );
	
	// "Three..."
	radio_dialogue( "afcaves_pri_three" );
	
	// "Two..."
	radio_dialogue( "afcaves_pri_two" );
	
	// "One..."
	radio_dialogue( "afcaves_pri_one" );
	
	// "Mark."
	radio_dialogue( "afcaves_pri_mark" );
	
	wait( 0.5 );  // lets the player shoot before we set the flag
	flag_set( "barracks_stairguys_countdown_dialogue_done" );
}

barracks_stairguys_spawnfunc()
{
	self thread give_flashlight();
	self.interval = 60;
	self thread patroller_do_cqbwalk();
	
	self.health = 5;
	self.moveplaybackrate = 0.75;
	
	self thread barracks_stairguy_see_price();
}

barracks_stairguy_see_price()
{
	self endon( "death" );
	
	trig = GetEnt( "trig_barracks_stairguy_seeprice", "targetname" );
	
	while( !trig IsTouching( self ) )
	{
		wait( 0.05 );
	}
	
	self.favoriteenemy = level.player;
}

barracks_biggroup_wiretap_dialogue()
{
	level endon( "_stealth_spotted" );
	
	flavorbursts_off( "axis" );
	
	// "Butcher Seven, Oxide. We've lost contact with Disciple Four uh...probably just the sandstorm that's rollin' in or a bad transmitter. Send a team to check it out, over."
	//radio_dialogue( "afcaves_schq_sendateam" );
	
	// "Butcher Seven, Oxide. We've lost contact with Disciple Four."
	radio_dialogue( "afcaves_schq_lostcontact2" );
	
	// "Probably just the sandstorm that's rollin' in or a bad transmitter."
	radio_dialogue( "afcaves_schq_badtransmitter2" );
	
	// "Send a team to check it out, over."
	radio_dialogue( "afcaves_schq_sendateam2" );
	
	// "Roger that Oxide, I'll send Vinson and Lambert. Butcher Seven out."
	radio_dialogue( "afcaves_sc2_sendvinson" );
	
	flavorbursts_on( "axis" );
}

barracks_biggroup_waittill_gone()
{
	areatrig = GetEnt( "trig_barracks_biggroup_pathstart_area", "targetname" );
	
	// the guys spawn in staggered so we have to account for them not all being there at the start
	aigroup = "barracks_biggroup";
	guys = [];
	while( !guys.size )
	{
		wait( 0.1 );
		guys = get_ai_group_ai( aigroup );
	}
	
	while( guys.size )
	{
		guys = get_ai_group_ai( aigroup );
		
		foundOne = false;
		foreach( guy in guys )
		{
			if( guy IsTouching( areatrig ) )
			{
				foundOne = true;
				break;
			}
		}
		
		if( !foundOne )
		{
			break;
		}
		else
		{
			wait( 0.05 );
		}
	}
	
	flag_set( "barracks_biggroup_gone" );
}

barracks_stealthbreak_action()
{
	level endon( "steamroom_start" );
	
	flag_wait( "_stealth_spotted" );
	
	flag_set( "barracks_stealth_broken" );
	
	// reset things that may have been set during stealth
	SetSavedDvar( "aim_aimAssistRangeScale", "1" );
	
	// clean up triggers we don't want anymore, and kill their spawners
	delete_and_kill_targeted_spawners_by_targetname_safe( "trig_barracks_centergroup_walker_spawn" );
	delete_and_kill_targeted_spawners_by_targetname_safe( "trig_barracks_nearleft_guys_spawn" );
	delete_and_kill_targeted_spawners_by_targetname_safe( "spawn_patroller_guy1" );
	
	level.price.ignoreall = false;
	level.price.dontEverShoot = undefined;
	level.price.maxsightdistsqrd = level.price_weaponsfree_sightDistSqrd;
	level.price.baseaccuracy = 50;
	
	wait( 2 );  // give player and price a chance to react
	
	// spawn enemies to defend steamroom entrance (or delete the spawners, if we're too close)
	thread barracks_stealthbreak_steamroom_defenders();
	
	// alert everyone
	axis = GetAiArray( "axis" );
	closest = get_array_of_closest( level.player.origin, axis );
	foreach( guy in axis )
	{
		if( IsAlive( guy ) && IsDefined( guy._stealth ) )
		{
			wait( 0.5 );
			guy notify( "heard_scream", level.player.origin );
			break;
		}
	}
	
	thread barracks_stealthbreak_abandoned_price_watcher();
	
	// enemies search out player after some time passes
	thread barracks_stealthbreak_delayed_playerseek();
	
	thread barracks_stealthbreak_enemies_cleanup();
	
	// wait for guys to die off
	flag_wait_all( "backdoor_firstpatroller_deathflag", "barracks_centergroup_deathflag", "barracks_nearleft_guys_deathflag" );
	
	if( !flag( "player_at_stairs_before_steamroom" ) )
	{
		// price move up to near the steamroom stairs
		thread price_goto_node( "node_barracks_stealthbreak_price_nearexit" );
	}
	
	// wait for door guards to die
	flag_wait( "barracks_steamroom_defenders_deathflag" );
	
	flag_set( "barracks_stealthbreak_survived" );
	
	// "Keep moving."
	radio_dialogue( "pri_keepmoving" );
	
	spot = GetEnt( "steamroom_price", "targetname" );
	level.price notify( "price_goto_node" );
	level.price SetGoalPos( groundpos( spot.origin ) );
	
	thread autosave_by_name( "barracks_stealthbreak_survived" );
	
	// alternate level progression
	flag_set( "steamroom_start" );
}

barracks_stealthbreak_steamroom_defenders()
{
	spawners = GetEntArray( "barracks_steamroom_defenders", "targetname" );
	if( !flag( "player_pre_steamroom_stairs" ) )
	{
		guys = spawn_ai_group( spawners );
	}
	else
	{
		array_call( spawners, ::Delete );
	}
}

barracks_stealthbreak_abandoned_price_watcher()
{
	level endon( "barracks_stealthbreak_survived" );
	
	trig = GetEnt( "trig_player_on_backdoor_ledge", "targetname" );
	
	warnTime = GetTime() + 5000;
	failTime = GetTime() + 12000;
	
	playerWarned = false;
	
	while( 1 )
	{
		trig waittill( "trigger", other );
		
		if( !IsPlayer( other ) )
		{
			wait( 0.05 );
			continue;
		}
		
		// wait until warning time
		while( level.player IsTouching( trig ) && !flag( "barracks_stealthbreak_survived" ) && GetTime() < warnTime )
		{
			wait( 0.05 );
		}
		
		// check if we can still do the warning
		if( !level.player IsTouching( trig ) || flag( "barracks_stealthbreak_survived" ) )
		{
			wait( 0.05 );
			continue;
		}
		
		if( !playerWarned )
		{
			// warn player
			// "Soap, where are you? Get back here!"
			radio_dialogue( "afcaves_pri_getbackhere" );
			playerWarned = true;
		}
		
		// wait until ending time
		while( level.player IsTouching( trig ) && !flag( "barracks_stealthbreak_survived" ) && GetTime() < failTime )
		{
			wait( 0.05 );
		}
		
		// check if we can still fail the player
		if( !level.player IsTouching( trig ) || flag( "barracks_stealthbreak_survived" ) )
		{
			wait( 0.05 );
			continue;
		}
		
		SetDvar( "ui_deadquote", "@AF_CAVES_DEADQUOTE_ABANDONED_PRICE" );
		maps\_utility::missionFailedWrapper();
	}
}

barracks_stealthbreak_delayed_playerseek()
{
	level endon( "_stealth_normal" );
	level endon( "steamroom_start" );
	
	wait( 20 );
	
	axis = GetAiArray( "axis" );
	array_thread( axis, ::be_aggressive );  // don't use cover, use flashbangs a bit more
	array_thread( axis, ::playerseek );  // go find the player
}

barracks_stealthbreak_enemies_cleanup()
{
	numRemaining = 3;
	
	axis = GetAiArray( "axis" );
	
	while( axis.size > numRemaining && !flag( "player_at_stairs_before_steamroom" ) )
	{
		wait( 0.1 );
		axis = GetAiArray( "axis" );
		axis = array_removedead( axis );
		axis = array_removeundefined( axis );
		
		foundNum = 0;
		foreach( guy in axis )
		{
			if( !IsAlive( guy ) )
			{
				continue;
			}
			
			if( guy doingLongDeath() )
			{
				continue;
			}
			
			foundNum++;
		}
		
		if( foundNum <= numRemaining )
		{
			break;
		}
	}
	
	axis = array_removedead( axis );
	axis = array_removeundefined( axis );
	array_thread( axis, ::make_easier_to_kill );
	array_thread( axis, ::barracks_kill_when_player_not_looking );
}

barracks_kill_when_player_not_looking()
{
	if( !IsAlive( self ) )
	{
		return;
	}
	
	self endon( "death" );
	
	minDistSqrd = 256 * 256;
	
	//while( within_fov( level.player.origin, level.player GetPlayerAngles(), self.origin, level.cosine[ "45" ] ) )
	while ( players_looking_at( self.origin + ( 0, 0, 48 ), undefined, true ) || DistanceSquared( level.player.origin, self.origin ) <= minDistSqrd )
	{
		if( !flag( "steamroom_entrance" ) )
		{
			wait( RandomFloatRange( 0.5, 2 ) );
		}
		else
		{
			wait( 0.05 );
		}
	}
	
	if( !flag( "steamroom_entrance" ) )
	{
		self.dieQuietly = true;
		self Kill();
	}
	else
	{
		self Delete();
	}
}

barracks_stealthbreak_dialogue()
{
	level endon( "steamroom_start" );
	level.player endon( "death" );
	
	broken = [];
	// "They're onto us - go loud."
	broken[ 0 ] = "afcaves_pri_ontousgoloud";
	// "We're compromised - go loud."
	broken[ 1 ] = "afcaves_pri_compromisedgoloud";
	
	recover = [];
	// "We got lucky that time."
	recover[ 0 ] = "afcaves_pri_gotlucky";
	// "That was close."
	recover[ 1 ] = "afcaves_pri_thatwasclose";
	
	while( !flag( "steamroom_start" ) )
	{
		flag_wait( "_stealth_spotted" );
		
		barracks_stealthbreak_enemy_dialogue();
		
		if( flag( "_stealth_spotted" ) )
		{
			radio_dialogue( random( broken ) );
			flag_waitopen( "_stealth_spotted" );
		}
		
		if( level.player.health > 0 )
		{
			radio_dialogue( random( recover ) );
		}
	}
}

barracks_stealthbreak_enemy_dialogue()
{
	lines = [];
	// "I see him, he's over here!"
	lines[ 0 ] = "afcaves_sc1_iseehim";
	// "Intruder spotted!"
	lines[ 1 ] = "afcaves_sc1_spotted";
	// "Hostile at my location!"
	lines[ 2 ] = "afcaves_sc1_hostilemyloc";
	
	radio_dialogue_stop();
	
	axis = GetAiArray( "axis" );
	closest = get_array_of_closest( level.player.origin, axis );
	foreach( guy in axis )
	{
		if( IsAlive( guy ) && IsDefined( guy._stealth ) )
		{
			guy thread radio_dialogue( random( lines ) );
			wait( 0.05 );  // let the dialogue get into the queue before anything after this returns
			break;
		}
	}
}

barracks_center_group()
{
	activate_trigger_with_targetname( "trig_backdoor_barracks_center_group_spawn" );
}

barracks_fridge_guy()
{
	spawner = GetEnt( "barracks_center_standing_fridge", "targetname" );
	guy = spawner spawn_ai();
	guy.ignoreall = true;
	
	guy endon( "death" );
	
	node = GetStruct( spawner.target, "targetname" );
	node stealth_ai_idle_and_react( guy, "fridge_idle", "fridge_react" );
	
	if( IsAlive( guy ) )
	{
		guy.ignoreall = false;
	}
}

barracks_chess_players()
{
	guy1 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_1" );
	guy2 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_2" );
	
	guys = [];
	guys[ guys.size ] = guy1;
	guys[ guys.size ] = guy2;
	
	guy1.animname = "chess_guy1";
	guy2.animname = "chess_guy2";
	guy1.deathanim = guy1 getanim( "chess_death_1" );
	guy2.deathanim = guy2 getanim( "chess_death_2" );
	
	array_thread( guys, ::barracks_chess_player_notify_when_broken, "chess_players_broken" );
	array_thread( guys, ::set_allowdeath, true );
	//array_thread( guys, ::set_ignoreall, true );

	node = GetEnt( "chess_ent", "targetname" );
	node2 = spawn( "script_origin", node.origin );
	node2.angles = node.angles;
	
	node thread stealth_ai_idle_and_react( guy1, "chess_idle_1", "chess_surprise_1" );
	node2 thread stealth_ai_idle_and_react( guy2, "chess_idle_2", "chess_surprise_2" );

	array_thread( guys, ::barracks_chess_players_alert );
}

barracks_chess_player_notify_when_broken( notifyStr )
{
	self endon( "death" );
	level endon( notifyStr );
	
	self ent_flag_waitopen( "_stealth_normal" );
	level notify( notifyStr );
}

barracks_chess_players_alert()
{
	self stealth_enemy_waittill_alert();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted_bring_group( level.player.origin );
	self set_ignoreall( false );
	self.deathanim = undefined;
}

barracks_backdoor_radio()
{
	emitter = GetEnt( "radio_backdoor_emitter", "targetname" );
	alias = "emt_afcaves_radio_music1";
	
	emitter thread play_loop_sound_on_entity( alias );
	
	trigger_wait_targetname( "trig_radio_damage_backdoor" );
	
	emitter stop_loop_sound_on_entity( alias );
	emitter Delete();
}

barracks_enemy_cleanup_prethink()
{
	flag_wait( "steamroom_entrance" );
	
	barracks_enemy_cleanup();
}

barracks_enemy_cleanup()
{
	guys = [];
	
	guys = get_ai_group_ai( "backdoor_firstpatroller" );
	guys = array_combine( guys, get_ai_group_ai( "barracks_centergroup" ) );
	guys = array_combine( guys, get_ai_group_ai( "barracks_biggroup" ) );
	guys = array_combine( guys, get_ai_group_ai( "barracks_nearleft_guys" ) );
	guys = array_combine( guys, get_ai_group_ai( "barracks_stairguys" ) );
	
	if( !guys.size )
	{
		return;
	}
	
	thread AI_delete_when_out_of_sight( guys, 256 );
}


// -----------------
// --- STEAMROOM ---
// -----------------
steamroom_setup()
{
	thread steamroom_before_player_gets_there_setup();
	
	// wait for level progression
	flag_wait( "steamroom_start" );
	
	if( !flag( "barracks_stealth_broken" ) && !flag( "player_pre_steamroom_stairs" ) )
	{
		thread steamroom_knifekill_setup();
		thread steamroom_price_knifekill();
	}
	
	thread steamroom_price_setup();
	thread steamroom_action();
}

steamroom_before_player_gets_there_setup()
{
	// wait for player to get close
	flag_wait( "player_at_stairs_before_steamroom" );
	exploder( "steamroom_steamclouds" );
	thread steamroom_lighting_setup();
	thread steamroom_door_setup();
	thread steamroom_c4_hide();
}

steamroom_gate_swap()
{
	yLimit = 9200;
	distSqrd = 512;
	
	while( 1 )
	{
		wait( 0.05 );
		
		if( level.player.origin[ 1 ] > yLimit )
		{
			continue;
		}
		
		if( level.price.origin[ 1 ] > yLimit )
		{
			continue;
		}
		
		/*
		if( DistanceSquared( level.player.origin, level.steamroom_gate_closed.origin ) < distSqrd )
		{
			continue;
		}
		
		if( within_fov( level.player.origin, level.player GetPlayerAngles(), level.steamroom_gate_closed.origin, level.cosine[ "45" ] ) )
		{
			continue;
		}
		*/
		
		break;
	}
	
	level.steamroom_gate_open hide_entity();
	level.steamroom_gate_closed PlaySound( "gate_iron_open" );
	level.steamroom_gate_closed show_entity();
}

steamroom_c4_hide()
{
	c4 = GetEnt( "smodel_steamroom_c4_plant", "targetname" );
	c4 Hide();
}

steamroom_price_setup()
{
	level.price disable_ai_color();
	price_be_stealthy();
	
	//flag_wait( "player_at_stairs_before_steamroom" );
	flag_wait( "steamroom_door_blown" );
	level.price cqb_walk( "off" );
	level.price.neverEnableCQB = true;
	
	level.price thread force_weapon_when_player_not_looking( "masada_eotech" );
}

steamroom_action()
{
	thread steamroom_dialogue();
	thread steamroom_price_movement();
	thread steamroom_patrollers();
	
	flag_wait( "steamroom_going_dark" );
	
	thread steamroom_lights_go_out();
	
	flag_wait( "steamroom_price_moveup_2" );
	
	thread autosave_by_name( "barracks_doorbreach" );
	steamroom_price_teleport();  // teleport him forward if he's still in the barracks
	thread steamroom_blow_door();
	
	//thread vision_set_fog_changes( "af_caves_indoors_steamroom_dark", 2.25 );
	thread vision_set_fog_changes( "af_caves_indoors_steamroom", 2.25 );
	delaythread( 2, ::steamroom_price_start_ambush );
	
	// wait for ambush
	flag_wait_any( "steamroom_ambush_started", "steamroom_player_spotted" );
	
	if( !flag( "steamroom_ambush_started" ) )
	{
		flag_set( "steamroom_ambush_started" );
	}
	
	thread turn_off_stealth();
	thread steamroom_price_combat_think();
	thread steamroom_patrollers_protect_door();
	thread steamroom_enemies_cleanup();
	
	// wait for guys to die off
	flag_wait_all( "steamroom_patrollers_deathflag", "steamroom_patrollers_group2_deathflag" );
	
	if( !flag( "player_clear_steamroom" ) )
	{
		// price move up to near the door
		thread price_goto_node( "node_steamroom_price_near_door" );
	}
	
	// wait for door guards to die
	flag_wait( "steamroom_patrollers_doorguard_deathflag" );
	
	thread steamroom_ambush_finish_dialogue();
	
	flag_set( "steamroom_ambush_done" );
	
	if( !flag( "player_clear_steamroom" ) )
	{
		price_goto_node_and_wait_for_player( "node_steamroom_price_exit_bodyup", 320 );
	}
	
	// level progression
	flag_set( "steamroom_done" );
}

steamroom_patrollers_protect_door()
{
	trigger_wait_targetname( "trig_steamroom_near_door" );
	flag_set( "steamroom_patrollers_protect_door" );
}

steamroom_enemies_cleanup()
{
	numRemaining = 3;
	
	flag_wait( "steamroom_door_blown" );
	wait( 1 );
	
	axis = GetAiArray( "axis" );
	
	while( axis.size > numRemaining && !flag( "steamroom_exit" ) )
	{
		wait( 0.1 );
		axis = GetAiArray( "axis" );
		axis = array_removedead( axis );
		axis = array_removeundefined( axis );
		
		foundNum = 0;
		foreach( guy in axis )
		{
			if( !IsAlive( guy ) )
			{
				continue;
			}
			
			if( guy doingLongDeath() )
			{
				continue;
			}
			
			foundNum++;
		}
		
		if( foundNum <= numRemaining )
		{
			break;
		}
	}
	
	axis = array_removedead( axis );
	axis = array_removeundefined( axis );
	array_thread( axis, ::make_easier_to_kill );
	array_thread( axis, ::steamroom_kill_when_player_not_looking );
}

make_easier_to_kill()
{
	if( !IsAlive( self ) )
	{
		return;
	}
	
	self.health = 1;
	self.attackeraccuracy = 1;
}

steamroom_kill_when_player_not_looking()
{
	if( !IsAlive( self ) )
	{
		return;
	}
	
	self endon( "death" );
	
	minDistSqrd = 256 * 256;
	
	//while( within_fov( level.player.origin, level.player GetPlayerAngles(), self.origin, level.cosine[ "45" ] ) )
	while ( players_looking_at( self.origin + ( 0, 0, 48 ), undefined, true ) || DistanceSquared( level.player.origin, self.origin ) <= minDistSqrd )
	{
		if( !flag( "steamroom_exit" ) )
		{
			wait( RandomFloatRange( 0.5, 2 ) );
		}
		else
		{
			wait( 0.05 );
		}
	}
	
	if( !flag( "steamroom_exit" ) )
	{
		self.dieQuietly = true;
		self Kill();
	}
	else
	{
		self Delete();
	}
}

steamroom_price_combat_think()
{
	level.price.ignoreall = false;
	level.price.dontEverShoot = undefined;
	level.price.baseaccuracy = 2;
	level.price.maxsightdistsqrd = level.price_weaponsfree_sightDistSqrd;
	
	level.price.ignoresuppression = true;
	level.price.ignoreme = true;
	
	flag_wait_or_timeout( "steamroom_ambush_done", 5 );
	
	level.price.ignoresuppression = false;
	level.price.ignoreme = false;
	
	if( !flag( "steamroom_ambush_done" ) )
	{
		level.price thread enable_ai_color();
	}
	
	flag_wait( "steamroom_ambush_done" );
	
	level.price disable_ai_color();
	
	colortrigs = GetEntArray( "trig_steamroom_allies_color", "script_noteworthy" );
	array_call( colortrigs, ::Delete );
}

steamroom_price_cqb_at_stairs()
{
	flag_wait( "price_at_steamroom_stairs" );
	level.price cqb_walk( "on" );
}

steamroom_price_movement()
{
	level endon( "steamroom_ambush_started" );
	
	thread steamroom_price_cqb_at_stairs();
	
	if( !flag( "barracks_stealth_broken" ) )
	{
		flag_set( "steamroom_price_knifekill_sequencestart" );
		flag_wait( "steamroom_price_knifekill_done" );
	}
	
	thread price_goto_node( "node_steamroom_price_1" );
	flag_wait( "steamroom_price_moveup_1" );
	
	thread price_goto_node( "node_steamroom_price_2" );
	flag_wait( "steamroom_price_moveup_2" );
	
	thread price_goto_node( "node_steamroom_price_3" );
}

steamroom_price_teleport()
{
	if( level.price.origin[ 1 ] < 9750 )
	{
		return;
	}
	
	pos = groundpos( ( 4563, 9222, -3565 ) );
	angles = ( 5207, 9566, -3499 );
	
	level.price notify( "scripted_teleport" );
	level.price ForceTeleport( pos, angles );
}

// --- KNIFE KILL SEQUENCE --
steamroom_knifekill_setup()
{
	animref = GetEnt( "steamroom_price_stealthkill_animref", "targetname" );
	
	spawner = GetEnt( animref.target, "targetname" );
	guy = spawner spawn_ai( true );
	ASSERT( IsDefined( guy ) );
	
	guy.ignoreme = false;
	guy.ignoreall = true;
	guy.allowDeath = false;
	guy.grenadeAmmo = 0;
	
	guy AnimMode( "gravity" );
	guy SetGoalPos( guy.origin );
	
	level.knifekill_animref = animref;
	level.knifekill_guard = guy;
	
	flag_set( "steamroom_knifekill_setup_done" );
}

steamroom_price_knifekill()
{
	flag_wait_all( "steamroom_knifekill_setup_done", "steamroom_price_knifekill_sequencestart" );
	
	guard = level.knifekill_guard;
	if( !IsAlive( guard ) )
	{
		flag_set( "steamroom_price_knifekill_done" );
		return;
	}
	
	// "Top of the staircase - he's mine."
	thread radio_dialogue( "afcaves_pri_topofstairs" );
	
	guard.ignoreall = false;
	guard.allowDeath = true;
	guard.health = 5;
	
	animref = level.knifekill_animref;
	price = level.price;
	
	priceAnime		= "steamroom_knifekill_price";
	guardAnime		= "steamroom_knifekill_guard";
	guardIdleAnime	= "steamroom_knifekill_guard_idle";
	guardReactAnime	= "steamroom_knifekill_guard_reaction";
	
	// guard interruptible idle
	guard thread steamroom_price_knifekill_guard_handlephone( guardReactAnime );
	guard AnimMode( "gravity" );
	animref thread anim_generic_loop( guard, guardIdleAnime );
	guard thread steamroom_price_knifekill_guard_idleinterrupt( animref, guardReactAnime );
	level thread steamroom_price_knifekill_guard_fake_dropweapon( guard );
	
	price_goto_node_and_wait_for_player( "node_steamroom_price_mid_stairs", 300 );
	
	price.dontEverShoot = true;
	price.ignoreall = true;
	price setFlashbangImmunity( true );
	price disable_surprise();
	
	animref thread anim_generic_reach( price, priceAnime );
	steamroom_price_knifekill_waitfor_price_reach();
	
	if( IsAlive( guard ) && !flag( "steamroom_price_knifekill_abort" ) )
	{
		flag_set( "steamroom_price_knifekill_started" );
		
		guard thread steamroom_price_knifekill_guard_handle_death_during_walkup( animref );
		
		thread steamroom_price_knifekill_point_of_no_return( priceAnime, guard );
		price thread steamroom_price_knifekill_handleknife( priceAnime );
		
		price.anim_start_at_groundpos = true;
		
		price thread steamroom_price_knifekill_foley();
		
		price delaycall( 0.1, ::PushPlayer, true );
		guard delaycall( 0.1, ::PushPlayer, true );
		
		animref thread anim_generic( guard, guardAnime );
		animref anim_generic_gravity( price, priceAnime );
		
		price.anim_start_at_groundpos = undefined;
	}
	else
	{
		if( IsAlive( guard ) )
		{
			// price stop where you are until things calm down
			price notify( "new_anim_reach" );  // cancel anim_reach movement
			price SetGoalPos( price.origin );
			price thread steamroom_price_knifekill_aborted_movement();
			
			guard PushPlayer( false );
		}
		else
		{
			if( !flag( "steamroom_price_moveup_1" ) )
			{
				thread steamroom_price_knifekill_aborted_dialogue();
			}
		}
	}
	
	price.dontEverShoot = undefined;
	price.ignoreall = false;
	price setFlashbangImmunity( false );
	price delaythread( 5, ::enable_surprise );
	price PushPlayer( false );
	
	if( flag( "steamroom_price_knifekill_abort" ) && IsAlive( guard ) )
	{
		price.favoriteenemy = guard;
		guard waittill( "death" );
		price.favoriteenemy = undefined;
	}
	
	flag_set( "steamroom_price_knifekill_done" );
}

steamroom_price_knifekill_foley()
{
	ent = Spawn( "script_origin", level.price.origin );
	ent LinkTo( level.price );
	
	ent PlaySound( "scn_afcaves_knife_kill_behind" );
	
	flag_wait_any( "steamroom_price_knifekill_abort", "steamroom_price_knifekill_walkup_abort", "steamroom_price_knifekill_done" );
	
	ent StopSounds();
	wait( 0.05 );  // or else the sound won't stop
	ent Delete();
}

steamroom_price_knifekill_aborted_dialogue()
{
	// "Never mind, then."
	thread radio_dialogue( "afcaves_pri_nevermind" );
}

steamroom_price_knifekill_guard_handle_death_during_walkup( animref )
{
	level endon( "steamroom_price_knifekill_committed" );
	
	self waittill( "death" );
	
	flag_set( "steamroom_price_knifekill_walkup_abort" );
	level.price notify( "stop_animmode" );
	level.price anim_stopanimscripted();
	animref anim_stopanimscripted();
	
	thread steamroom_price_knifekill_aborted_dialogue();
}

steamroom_price_knifekill_waitfor_price_reach()
{
	level endon( "steamroom_price_knifekill_abort" );
	level.price waittill( "anim_reach_complete" );
}

steamroom_price_knifekill_aborted_movement()
{
	level endon( "steamroom_price_knifekill_done" );
	level.price endon( "scripted_teleport" );
	
	wait( 5 );
	// move up to the doorway
	level.price SetGoalPos( groundpos( ( 5207, 9566, -3499 ) ) );
}

steamroom_price_knifekill_guard_fake_dropweapon( guard )
{
	level endon( "steamroom_price_knifekill_abort" );
	
	weapon = guard.a.weaponPos[ "right" ];
	
	flag_wait( "steamroom_price_knifekill_started" );
	
	wait( 3 );
	
	classname = "weapon_" + weapon;
	Spawn( classname, groundpos( level.price GetTagOrigin( "tag_inhand" ) ) );
}	

steamroom_price_knifekill_guard_handlephone( guardReactAnime )
{
	phoneModel = "com_cellphone_on_anim";
	linkTag = "tag_inhand";
	
	self Attach( phoneModel, linkTag );
	
	msg = flag_wait_any_return( "steamroom_price_knifekill_abort", "steamroom_price_knifekill_started" );
	
	if( msg == "steamroom_price_knifekill_abort" )
	{
		animTime = GetAnimLength( getanim_generic( guardReactAnime ) );
		waitTime = animTime * 0.04;  // 4% of the way through
		wait( waitTime );
	}
	else
	{
		self waittillmatch( "single anim", "end_reaction" );
	}
	
	self Detach( phoneModel, linkTag );
	
}

steamroom_price_knifekill_guard_idleinterrupt( animref, guardReactAnime )
{
	self endon( "death" );
	level endon( "steamroom_price_knifekill_started" );
	
	self thread steamroom_price_knifekill_catch_player_movement_nearby();
	self thread steamroom_price_knifekill_guard_catch_playerclose();
	self thread steamroom_price_knifekill_guard_catch_gunshot();
	self waittill_any( "playerclose", "bulletwhizby", "bullethit", "damage", "flashbang", "grenade danger", "explode" );
	
	flag_set( "steamroom_price_knifekill_abort" );
	animref anim_stopanimscripted();
	
	self.health = 150;
	self.ignoreall = false;
	self.favoriteenemy = level.player;
	self disable_surprise();
	animref anim_generic_gravity( self, guardReactAnime );
	
	wait( 2 );
	
	self.favoriteenemy = undefined;
	
	wait( 3 );
	
	if( IsAlive( self ) )
	{
		vol = GetEnt( "goalvolume_steamroom_patrollers", "targetname" );
		self SetGoalVolumeAuto( vol );
	}
}

steamroom_price_knifekill_guard_catch_gunshot()
{
	level endon( "steamroom_price_knifekill_abort" );
	level endon( "steamroom_price_knifekill_started" );
	
	self addAIEventListener( "gunshot" );
	
	while( 1 )
	{
		self waittill( "ai_event", msg );
		
		if( msg == "gunshot" )
		{
			self notify( "playerclose" );
			break;
		}
	}
}

steamroom_price_knifekill_guard_catch_playerclose()
{
	level endon( "steamroom_price_knifekill_abort" );
	level endon( "steamroom_price_knifekill_started" );
	
	flag_wait( "steamroom_knifekill_guard_playerclose" );
	
	self notify( "playerclose" );
}

steamroom_price_knifekill_catch_player_movement_nearby()
{
	level endon( "steamroom_price_knifekill_abort" );
	level endon( "steamroom_price_knifekill_started" );
	
	flag_init( "player_jumping" );
	thread player_jump_watcher();
	thread player_jump_watcher_ender();
	
	while( 1 )
	{
		wait( 0.05 );
		
		if( !flag( "steamroom_stealthkill_player_in_awareness_zone" ) )
		{
			continue;
		}
		
		if( flag( "player_jumping" ) )
		{
			self notify( "playerclose" );
		}
		
		speed = get_player_speed();
		
		if( speed > 200 )  // sprinting or doing weird stuff
		{
			self notify( "playerclose" );
		}
	}
}

player_jump_watcher()
{
	level endon( "player_jump_watcher_stop" );
	
	jumpflag = "player_jumping";
	if( !flag_exist( jumpflag ) )
	{
		flag_init( jumpflag );
	}
	else
	{
		flag_clear( jumpflag );
	}
	
	NotifyOnCommand( "playerjump", "+gostand" );
	NotifyOnCommand( "playerjump", "+moveup" );
	
	while( 1 )
	{
		level.player waittill( "playerjump" );
		wait( 0.1 );  // jumps don't happen immediately
		
		if( !level.player IsOnGround() )
		{
			flag_set( jumpflag );
			println( "jumping" );
		}
		
		while( !level.player IsOnGround() )
		{
			wait( 0.05 );
		}
		flag_clear( jumpflag );
		println( "not jumping" );
	}
}

player_jump_watcher_ender()
{
	level waittill_any( "steamroom_price_knifekill_abort", "steamroom_price_knifekill_started" );
	level notify( "player_jump_watcher_stop" );
}

get_player_speed()
{
	vel = level.player GetVelocity();
	// figure out the length of the vector to get the speed (distance from world center = length)
	speed = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
	
	return speed;
}

steamroom_price_knifekill_point_of_no_return( priceAnime, guard )
{
	animTime = GetAnimLength( getanim_generic( priceAnime ) );
	committedWait = animTime * 0.31;
	
	wait( committedWait );
	
	flag_set( "steamroom_price_knifekill_committed" );

	if( IsAlive( guard ) )
	{
		guard.allowDeath = true;
		guard.a.nodeath = true;
		guard set_battlechatter( false );
		guard kill();
	}
}

steamroom_price_knifekill_handleknife( priceAnime )
{
	knifemodel = "weapon_parabolic_knife";
	linktag = "tag_inhand";
	
	animTime = GetAnimLength( getanim_generic( priceAnime ) );
	stabWait = animTime * 0.48;
	detachWait = animTime * 0.78;
	
	startTime = GetTime();
	
	self thread steamroom_price_knifekill_bloodfx( stabWait );
	
	self waittillmatch( "custom_animmode", "knife pullout" );
	self Attach( knifemodel, linktag );
	
	waitTime = detachWait - seconds( GetTime() - startTime );
	flag_wait_or_timeout( "steamroom_price_knifekill_walkup_abort", waitTime );
	
	self Detach( knifemodel, linktag );
}

steamroom_price_knifekill_bloodfx( stabWaitTime )
{
	level endon( "steamroom_price_knifekill_walkup_abort" );
	
	bloodfx = getfx( "knife_stab" );
	fxTag = "tag_knife_fx";
	
	wait( stabWaitTime );
	PlayFX( bloodfx, level.price GetTagOrigin( fxTag ) );
}
// --- END KNIFE KILL SEQUENCE --

steamroom_dialogue()
{
	// "Disciple Six, we've lost all contact with Disciple Five. Check it out over."
	radio_dialogue( "afcaves_schq_lostcontact" );
	
	if( !flag( "steamroom_entrance" ) )
	{
		// "Roger that Oxide, we're on the catwalk, heading to the steam room. Standby."
		radio_dialogue( "afcaves_sc3_oncatwalk" );
	}
	
	flag_wait( "steamroom_entrance" );
	
	// "Oxide, Disciple Six at the steam room. No sign of Five, over."
	//radio_dialogue( "afcaves_sc3_atsteamroom" );
	
	// "Sounds like we're gonna meet 'em head on, Soap."
	//radio_dialogue( "afcaves_pri_meetemheadon" );
	
	if( !flag( "steamroom_price_moveup_1" ) )
	{
		// "Disciple Six, go dark, breach and clear."
		radio_dialogue( "afcaves_schq_godark" );
		
		// "Here we go - get ready."
		thread radio_dialogue( "afcaves_pri_getready" );
	}
	
	flag_set( "steamroom_going_dark" );
	
	if( !flag( "steamroom_price_moveup_2" ) )
	{
		// "Door charge planted. Ready to breach."
		radio_dialogue( "afcaves_sc3_chargeplanted" );
	}
}

steamroom_blow_door()
{
	flag_set( "steamroom_door_preblow" );
	
	// "Hit it."
	radio_dialogue( "afcaves_scl_hitit" );
	
	// "Breaching, breaching!"
	thread radio_dialogue( "afcaves_sc3_breaching" );
	wait( 0.8 );
	
	exploder( 200 );
	
	delaythread( 0.5, ::steamroom_gate_swap );
	
	org = GetEnt( "smodel_steamroom_c4_plant", "targetname" );
	
	thread play_sound_in_space( "af_caves_selfdestruct", org.origin );
	Earthquake( .2, 1.75, level.player.origin, 350 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	SetBlur( 3, .1 );
	
	spots = [];
	spots[ 0 ] = org;
	spots = array_combine( spots, GetEntArray( "steamroom_fake_c4_spot", "targetname" ) );
	foreach( spot in spots )
	{
		PlayFX( level._effect[ "c4_explosion" ], spot.origin );
		spot RadiusDamage( spot.origin, 256, 200, 50 );
	}
	
	flag_set( "steamroom_door_blown" );
	
	wait( 1 );
	SetBlur( 0, 3 );
}

steamroom_ambush_finish_dialogue()
{
	if( !flag( "steamroom_exit" ) )
	{
		// "Move."
		radio_dialogue( "afcaves_pri_move2" );
	}
	
	if( !flag( "steamroom_exit" ) )
	{
		// "Disciple Nine, your rear guard just flatlined!"
		radio_dialogue( "afcaves_schq_flatlined" );
	}
	
	if( !flag( "steamroom_exit" ) )
	{
		// "Not possible. We just cleared that area. (snort) Nobody's that good Oxi-"
		thread radio_dialogue( "afcaves_sc3_notpossible" );
		
		wait( 2.75 );  // the next line needs to cut this one off a bit to sound right
		
		// "It's Price."
		radio_dialogue_overlap( "afcaves_shp_itsprice" );
	}
	
	// don't play if we're close to where we have to give the next objective
	if( flag( "player_awayfrom_steamroom_exit" ) )
	{
		// "Backup priority items and burn the rest. Fire teams - just delay 'em until we're ready to pull out."
		radio_dialogue( "afcaves_shp_burntherest" );
	}
	
	flag_set( "steamroom_ambush_finish_dialogue_ended" );
}

steamroom_price_start_ambush()
{
	level endon( "steamroom_ambush_started" );
	
	wait( 8 );
	
	/*
	vol = GetEnt( "goalvolume_steamroom_patrollers", "targetname" );
	numGuysNeeded = 7;
	
	guys = get_ai_group_ai( "steamroom_patrollers" );
	while( guys.size && !all_dead( guys ) )
	{
		numFound = 0;
		foreach( guy in guys )
		{
			if( vol IsTouching( guy ) )
			{
				numFound++;
			}
		}
		
		if( numFound >= numGuysNeeded )
		{
			break;
		}
		
		wait( 0.1 );
		
		guys = get_ai_group_ai( "steamroom_patrollers" );
	}
	*/
	
	// "Go loud! Open fire!"
	thread radio_dialogue( "afcaves_pri_goloud" );
	
	flag_set( "steamroom_ambush_started" );
}

steamroom_patrollers()
{
	flag_wait( "steamroom_door_preblow" );
	
	spawnersExtra = GetEntArray( "steamroom_patroller_extraguy", "targetname" );
	guysExtra = spawn_ai_group( spawnersExtra, true );
	array_thread( guysExtra, ::steamroom_patroller_think );
	
	flag_wait( "steamroom_door_blown" );
	
	spawners = [];
	guys = [];
	spawners = GetEntArray( "steamroom_patroller", "targetname" );
	guys = spawn_ai_group( spawners, true );
	array_thread( guys, ::steamroom_patroller_think );
	
	if( !flag( "steamroom_ambush_started" ) )
	{
		thread steamroom_patrollers_pre_ambush_dialogue();
	}
	
	spawners2 = GetEntArray( "steamroom_patroller_group2", "targetname" );
	ASSERT( spawners2.size );
	guys2 = spawn_ai_group( spawners2, true );
	array_thread( guys2, ::steamroom_patroller_group2_wait );
	
	spawners3 = GetEntArray( "steamroom_patroller_doorguard", "targetname" );
	ASSERT( spawners3.size );
	guys3 = spawn_ai_group( spawners3, true );
	array_call( guys3, ::LaserForceOn );
	array_thread( guys3, ::steamroom_patroller_baseaccuracy );
	
	flag_wait_any( "steamroom_ambush_started", "steamroom_patrollers_deathflag" );
	
	// spot the player if one of the patrollers dies
	if( !flag( "steamroom_ambush_started" ) )
	{
		flag_set( "steamroom_player_spotted" );
	}
	
	thread steamroom_patrollers_post_ambush_dialogue();
}

steamroom_patroller_group2_wait()
{
	self endon( "death" );
	
	og_goalradius = self.goalradius;
	self SetGoalPos( self.origin );
	flag_wait_any( "steamroom_ambush_started", "steamroom_patrollers_deathflag" );
	
	self.goalradius = og_goalradius;
	vol = GetEnt( "goalvolume_steamroom_patrollers", "targetname" );
	self SetGoalVolumeAuto( vol );
	
	self thread steamroom_patroller_think();
}

steamroom_patrollers_pre_ambush_dialogue()
{
	level endon( "steamroom_ambush_started" );
	
	// "Move in."
	radio_dialogue( "scl_movein" );
	
	// "Foxtrot element, sweep left."
	radio_dialogue( "afcaves_scl_foxtrotelement" );
	
	// "Search pattern Echo Charlie. Go."
	radio_dialogue( "afcaves_scl_patternecho" );
	
	// "Door area clear."
	radio_dialogue( "afcaves_sc3_areaclear" );
	
	// "Check your corners."
	radio_dialogue( "afcaves_scl_checkcorners" );
}

steamroom_patrollers_post_ambush_dialogue()
{
	level endon( "steamroom_patrollers_group2_deathflag" );
	
	// "They're here! Open fire!"
	radio_dialogue( "afcaves_scl_theyrehere" );
	
	wait( 5 );
	
	// "Stay frosty, hunt them down!"
	radio_dialogue( "afcaves_scl_huntthemdown" );
}

steamroom_patroller_think()
{
	if( !flag( "steamroom_ambush_started" ) )
	{
		self thread steamroom_patroller_deathwait();
	}
	
	self thread steamroom_patroller_notify_on_player_spotted();
	
	self endon( "death" );
	
	self LaserForceOn();
	
	self steamroom_patroller_baseaccuracy();
	
	if( !flag( "steamroom_ambush_started" ) )
	{
		og_sightdist = self.maxsightdistsqrd;
		self.maxsightdistsqrd = 500 * 500;
		og_goalradius = self.goalradius;
		self.goalradius = 64;
		
		flag_wait( "steamroom_door_blown" );
		
		self thread maps\_patrol::patrol( self.target );
		wait( 0.1 );
		self thread patroller_do_cqbwalk();
		//self.script_idlereach = true;
		//self thread maps\_idle::idle();
		
		flag_wait( "steamroom_ambush_started" );
		
		wait( 0.05 );
		self notify( "end_patrol" );
		self clear_generic_idle_anim();
		self.goalradius = og_goalradius;
		self.maxsightdistsqrd = og_sightdist;
	}
	
	//self be_aggressive();
	
	flag_wait( "steamroom_patrollers_protect_door" );
	self delaythread( 0.1, ::playerseek );
}

steamroom_patroller_baseaccuracy()
{
	switch( level.gameskill )
	{
		case 0:
			self.baseaccuracy = 0.9;  // hard to see in here, frustrating for a noob
			break;
		case 1:
			self.baseaccuracy = 1.1;
			break;
		case 2:
			self.baseaccuracy = 1.25;
			break;
		case 3:
			self.baseaccuracy = 1.5;
			break;
	}
}

steamroom_patroller_notify_on_player_spotted()
{
	flagstr = "steamroom_player_spotted";
	level endon( flagstr );
	
	self endon( "death" );
	
	self waittill( "enemy" );
	
	if( !flag( flagstr ) )
	{
		flag_set( flagstr );
	}
}

steamroom_patroller_deathwait()
{
	level endon( "steamroom_ambush_started" );
	self waittill( "death" );
	
	flag_set( "steamroom_ambush_started" );	
}

steamroom_lighting_setup()
{
	//group 1
	lights_out_grp1 = getentarray( "lights_off_grp1", "targetname" );
	array_thread( lights_out_grp1, ::_setLightIntensity, 1.5 );
	
	light_models_off_grp1 = getentarray( "security_lights_off_grp1", "targetname" );
	array_call( light_models_off_grp1, ::hide );

	light_models_on_grp1 = getentarray( "security_lights_on_grp1", "targetname" );
	array_thread( light_models_on_grp1, ::steamroom_light_glow_fx );
	
	//group 2
	lights_out_grp2 = getentarray( "lights_off_grp2", "targetname" );
	array_thread( lights_out_grp2, ::_setLightIntensity, 1.7);
	
	light_models_off_grp2 = getentarray( "security_lights_off_grp2", "targetname" );
	array_call( light_models_off_grp2, ::hide );

	light_models_on_grp2 = getentarray( "security_lights_on_grp2", "targetname" );
	array_thread( light_models_on_grp2, ::steamroom_light_glow_fx );
	
	//group 3
	lights_out_grp3 = getentarray( "lights_off_grp3", "targetname" );
	array_thread( lights_out_grp3, ::_setLightIntensity, 1.7);
	
	light_models_off_grp3 = getentarray( "security_lights_off_grp3", "targetname" );
	array_call( light_models_off_grp3, ::hide );

	light_models_on_grp3 = getentarray( "security_lights_on_grp3", "targetname" );
	array_thread( light_models_on_grp3, ::steamroom_light_glow_fx );

	//group 4
	lights_out_grp4 = getentarray( "lights_off_grp4", "targetname" );
	array_thread( lights_out_grp4, ::_setLightIntensity, 1.5);
	
	light_models_off_grp4 = getentarray( "security_lights_off_grp4", "targetname" );
	array_call( light_models_off_grp4, ::hide );

	light_models_on_grp4 = getentarray( "security_lights_on_grp4", "targetname" );
	array_thread( light_models_on_grp4, ::steamroom_light_glow_fx );

}

steamroom_light_glow_fx()
{
	if ( self.model == "dt_light_on" || self.model == "com_utility_light_on" )
	{
		PlayFXOnTag( getfx( "light_glow_white_bulb" ), self, "tag_fx");
	}
}

steamroom_door_setup()
{
	door = GetEnt( "cavedoor", "targetname" );
	door.lightOffModel = GetEnt( "sbmodel_steamroom_light_off", "targetname" );
	door.lightOnModel = GetEnt( "sbmodel_steamroom_light_on", "targetname" );
	door.lightOffModel Hide();
	level.steamroom_door = door;
	
	doorlight = GetEnt( "cave_door_light", "targetname" );
	doorlight SetLightIntensity( 1.5 );
	level.steamroom_doorlight = doorlight;
}

steamroom_door_lightswap()
{
	level.steamroom_doorlight SetLightIntensity( 0 );
	
	if( IsDefined( level.steamroom_door ) )
	{
		level.steamroom_door.lightOnModel Hide();
		level.steamroom_door.lightOffModel Show();
	}
	
	wait( 0.25 );
	level.player playsound( "scn_blackout_breaker_box" );
	
	glowspots = GetStructArray( "cave_red_light_glowspot", "targetname" );
	foreach( spot in glowspots )
	{
		PlayFX( getfx( "redlight_glow" ), spot.origin );
	}
	
	dlightspots = GetStructArray( "cave_red_light_dlight_spot", "targetname" );
	foreach( dlight in dlightspots )
	{
		dlight.looper = PlayLoopedFX( getfx( "dlight_red" ), 50, dlight.origin, 2500 );
	}
}

steamroom_lights_go_out()
{
	thread steamroom_steam_fx_swap();
	
	level.player playsound( "scn_blackout_breaker_box" );

	thread vision_set_fog_changes( "af_caves_outdoors", 2.25 );

	//group 1
	lights_out_grp1 = getentarray( "lights_off_grp1", "targetname" );
	array_thread( lights_out_grp1, ::_setLightIntensity, 0 );

	light_models_on_grp1 = getentarray( "security_lights_on_grp1", "targetname" );
	array_call( light_models_on_grp1, ::delete );

	light_models_off_grp1 = getentarray( "security_lights_off_grp1", "targetname" );
	array_call( light_models_off_grp1, ::show );

	wait .75;

	level.player playsound( "scn_blackout_breaker_box" );

	//group 2
	lights_out_grp2 = getentarray( "lights_off_grp2", "targetname" );
	array_thread( lights_out_grp2, ::_setLightIntensity, 0 );

	light_models_on_grp2 = getentarray( "security_lights_on_grp2", "targetname" );
	array_call( light_models_on_grp2, ::delete );

	light_models_off_grp2 = getentarray( "security_lights_off_grp2", "targetname" );
	array_call( light_models_off_grp2, ::show );

	wait .75;
	level.player playsound( "scn_blackout_breaker_box" );

	//group 3
	lights_out_grp3 = getentarray( "lights_off_grp3", "targetname" );
	array_thread( lights_out_grp3, ::_setLightIntensity, 0 );

	light_models_on_grp3 = getentarray( "security_lights_on_grp3", "targetname" );
	array_call( light_models_on_grp3, ::delete );

	light_models_off_grp3 = getentarray( "security_lights_off_grp3", "targetname" );
	array_call( light_models_off_grp3, ::show );
	
	wait .75;
	level.player playsound( "scn_blackout_breaker_box" );

	//group 4
	lights_out_grp4 = getentarray( "lights_off_grp4", "targetname" );
	array_thread( lights_out_grp4, ::_setLightIntensity, 0 );

	light_models_on_grp4 = getentarray( "security_lights_on_grp4", "targetname" );
	array_call( light_models_on_grp4, ::delete );

	light_models_off_grp4 = getentarray( "security_lights_off_grp4", "targetname" );
	array_call( light_models_off_grp4, ::show );
	
	thread steamroom_door_lightswap();
	
	flag_set( "steamroom_lights_out" );
}

steamroom_steam_fx_swap()
{
	wait( 2 );
	pauseExploder( "steamroom_steamclouds" );
	exploder( "steamroom_steamclouds_dark" );
	
	level.og_pipe_fx = level._pipes._effect[ "steam" ];
	level._pipes._effect[ "steam" ] = getfx( "pipe_steam_dark" );
}
