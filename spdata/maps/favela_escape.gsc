#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
#include maps\favela_escape_code;

#using_animtree( "generic_human" );

CONST_CHICKEN_ACHIEVEMENT_NUM = 7;
CONST_CHICKEN_ACHIEVEMENT_TIME = 10;

main()
{
	SoundSetTimeScaleFactor( "Music", 0 );
	SoundSetTimeScaleFactor( "Announcer", 0 );
	SoundSetTimeScaleFactor( "local3", 0 );
	
	level.friendly_baseaccuracy = 0.5;
	level.respawn_friendlies_force_vision_check = true;
	
	// so burning vehicles don't block friendly progression up the skinny streets
	level.destructible_badplace_radius_multiplier		= 0.75;
	//level.destructible_explosion_radius_multiplier		= 0.85;
	level.destructible_health_drain_amount_multiplier	= 1.75;  // burn faster
	
	// don't track choppers on the minimap since we're doing a lot of fakery
	SetSavedDvar( "compassHideVehicles", "1" );
	
	weapons = [];
	sounds = [];
	weapons[ weapons.size ] = "ak47_drone_sound";
	sounds[ "ak47_drone_sound" ] = "drone_ak47_fire_npc";
	weapons[ weapons.size ] = "uzi_drone_sound";
	sounds[ "uzi_drone_sound" ] = "drone_miniuzi_fire_npc";
	weapons[ weapons.size ] = "glock_drone_sound";
	sounds[ "glock_drone_sound" ] = "drone_glock_fire_npc";
	weapons[ weapons.size ] = "fal_drone_sound";
	sounds[ "fal_drone_sound" ] = "drone_fnfal_fire_npc";
	level.scriptedweapons = weapons;
	level.scriptedweaponsounds = sounds;
	
	level.cosine[ "45" ] = cos( 45 );
	
	maps\createart\favela_escape_art::main();  // Redundant now, since all this currently does is fog, and we moved that to favela_escape_fog. Keeping it in case the artists are expecting it to be there at some point.
	maps\createart\favela_escape_fog::main();
	maps\createfx\favela_escape_fx::main();
	maps\favela_escape_precache::main();
	maps\favela_escape_fx::main();
	precache_scripted_assets();
	
	init_level_flags();
	init_weaponClipModels();
	
	build_starts();
	
	maps\_hiding_door_anims::main();
	maps\_rambo::main();
	
	level.airliner = airliner_setup();
	
	level.friendly_startup_thread = ::favela_escape_friendly_startup_thread;
	setup_color_friendly_spawners();
	
	maps\_drone_ai::init();
	
	maps\_load::main();
	
	flag_set( "respawn_friendlies" );
	
	thread triggered_hostile_bursts_setup();
	
	thread setup_friends();
	thread setup_enemies();
	thread setup_vehicles();
	
	maps\favela_escape_anim::main();
	thread maps\favela_escape_amb::main();
	
	thread move_stuff_at_levelstart();
	thread deletetrigs();
	
	thread maps\favela_escape_fx::bird_startle_trigs();
	thread airliner_flyby_trigs();
	
	maps\_compass::setupMiniMap("compass_map_favela_escape");
	
	thread favela_escape_objectives();
	
	thread enemy_cleanup();
	
	thread chicken_achievement();
}

chicken_achievement()
{
	level.chickens_killed = [];
	
	destructible_toy = GetEntArray( "destructible_toy", "targetname" );
	chickens = [];
	foreach( item in destructible_toy )
	{
		if( issubstr( item.destructible_type, "toy_chicken" ) )
			chickens[ chickens.size ] = item;	
	}
	
	array_thread( chickens, ::chicken_achievement_think );	
}

chicken_achievement_think()
{
	self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	
	if( !isplayer( attacker ) )
		return;
	
	level.chickens_killed[ level.chickens_killed.size ] = gettime();
	
	if( level.chickens_killed.size < CONST_CHICKEN_ACHIEVEMENT_NUM )
		return;
	
	time1 = level.chickens_killed[ level.chickens_killed.size - CONST_CHICKEN_ACHIEVEMENT_NUM ];
	time2 = level.chickens_killed[ level.chickens_killed.size - 1 ];
	
	if( ( time2 - time1 ) > CONST_CHICKEN_ACHIEVEMENT_TIME * 1000 )
		return;
	
	maps\_utility::giveachievement_wrapper( "COLONEL_SANDERSON" );
}

precache_scripted_assets()
{
	PrecacheItem( "uzi" );
	PrecacheItem( "smoke_grenade_american" );
	PrecacheItem( "rpg_straight" );
	PrecacheItem( "rpg_straight_short_life" );
	PrecacheItem( "freerunner" );
	
	PrecacheItem( "ak47_drone_sound" );
	PrecacheItem( "uzi_drone_sound" );
	PrecacheItem( "glock_drone_sound" );
	PrecacheItem( "fal_drone_sound" );
	
	PrecacheShellshock( "favela_escape_player_recovery" );
	
	PrecacheString( &"FAVELA_ESCAPE_SOLORUN_KEEP_MOVING" );
	PrecacheString( &"FAVELA_ESCAPE_HINT_SPRINT" );
	PrecacheString( &"FAVELA_ESCAPE_HINT_SPRINT_PC" );
	PrecacheString( &"FAVELA_ESCAPE_HINT_SPRINT_PC_ALT" );
	PrecacheString( &"FAVELA_ESCAPE_CHOPPER_TIMER" );
	PrecacheString( &"FAVELA_ESCAPE_CHOPPER_TIMER_EXPIRED" );
	PrecacheString( &"FAVELA_ESCAPE_DEADQUOTE_FAILED_CHOPPER_JUMP" );
}

init_level_flags()
{
	flag_init( "friends_setup" );
	
	//flag_init( "scripted_dialogue" );
	
	flag_init( "introscreen_start_dialogue" );
	
	flag_init( "radiotower_runpath_dialogue_done" );
	
	flag_init( "radiotower_start" );
	flag_init( "radiotower_vehicles_start" );
	flag_init( "radiotower_escape_technical_1_arrival" );
	flag_init( "radiotower_escape_technical_2_arrival" );
	flag_init( "radiotower_vehicle1_donut_done" );
	flag_init( "radiotower_enemies_retreat" );
	flag_init( "radiotower_exit" );
	
	flag_init( "hind_turret_shutdown" );
	flag_init( "hind_fire" );
	flag_init( "hind_reveal_rpg_dodge" );
	flag_init( "hind_reveal_dodgestop" );
	flag_init( "hind_reveal_bugout" );
	
	flag_init( "market_introdialogue_done" );
	flag_init( "market_chopper_spawned" );
	
	flag_init( "market_evac_chopper_spawned" );
	flag_init( "market_evac_chopper_bugout" );
	flag_init( "market_evac_player_near_soccerfield" );
	flag_init( "market_evac_chopper_incoming" );
	flag_init( "market_evac_ambush_start" );
	flag_init( "market_evac_enemies_depleted" );
	flag_init( "market_evac_chopper_leaves_scene" );
	flag_init( "market_evac_follow_sarge_climb" );
	flag_init( "market_evac_soap_climbed_up" );
	flag_init( "market_evac_player_mantled" );
	flag_init( "market_evac_player_on_roof" );
	
	flag_init( "roofrun_done" );
	flag_init( "roofrun_sarge_bigjumped" );
	flag_init( "roofrun_player_bigjump_start" );
	flag_init( "player_jump_watcher_stop" );
	flag_init( "player_fell_normally" );
	flag_init( "bigjump_sargeplayer_interact_start" );
	flag_init( "player_bigjump_done" );
	flag_init( "player_recovery_blackscreen" );
	flag_init( "player_recovery_done" );
	
	flag_init( "solorun_objective_display" );
	flag_init( "solorun_start" );
	flag_init( "solorun_mob_start_shooting" );
	flag_init( "solorun_player_at_balcony" );
	flag_init( "solorun_player_progression_stalled" );
	flag_init( "solorun_timer_start" );
	flag_init( "timer_expired" );
	flag_init( "chopperjump_player_jump" );
	flag_init( "solorun_player_boarded_chopper" );
	
	flag_init( "level_faded_to_black" );
}

init_weaponClipModels()
{
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_ak47_tactical_clip";
	level.weaponClipModels[1] = "weapon_rpd_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_skorpion_clip";
	level.weaponClipModels[4] = "weapon_saw_clip";
}

move_stuff_at_levelstart()
{
	level.market_evac_helperClips = GetEntArray( "sbmodel_market_evac_helperclip", "targetname" );
	foreach( clip in level.market_evac_helperClips )
	{
		clip ConnectPaths();
	}
	
	// create a badplace for one of the street alleys so friendlies don't choose a path through there
	Badplace_Cylinder( "street_uphill_alley", -1, ( -388, 524, 1016 ), 90, 128, "allies" );
}

setup_friends()
{
	friends = GetEntArray( "starting_allies", "script_noteworthy" );
	
	foreach( guy in friends )
	{
		if( IsDefined( guy.targetname ) )
		{
			// MacTavish
			if( guy.targetname == "sarge" )
			{
				//guy thread magic_bullet_shield();
				guy.animname = "sarge";
				guy.isHero = true;
				level.sarge = guy;
			}
			// Ghost
			else if( guy.targetname == "hero1" )
			{
				//guy thread magic_bullet_shield();
				guy.animname = "hero1";
				guy.isHero = true;
				
				level.hero1 = guy;
			}
		}
		
		if( IsDefined( guy.isHero ) )
		{
			// heroes are invincible
			guy thread magic_bullet_shield();
		}
		else
		{
			guy thread replace_on_death();  // only have to do this for first spawned guys, others will do it automatically in color respawn system
		}
		
		guy scr_accuracy( level.friendly_baseaccuracy );
		
		guy scr_usechokepoints( true );
		
		guy friend_add();
	}
	
	// run on everyone else who spawns
	add_global_spawn_function( "allies", ::scr_usechokepoints, true );
	
	flag_set( "friends_setup" );
}

setup_enemies()
{
	add_global_spawn_function( "axis", ::scr_usechokepoints, true );
	
	deleters = GetEntArray( "delete_at_path_end", "script_noteworthy" );
	array_thread( deleters, ::add_spawn_function, ::delete_at_path_end );
	
	ignorers2 = GetEntArray( "ignore_til_pathend_or_damage", "script_noteworthy" );
	array_thread( ignorers2, ::add_spawn_function, ::ignore_til_pathend_or_damage );
	
	ignore_and_deleters = GetEntArray( "ignore_and_delete_at_path_end", "script_noteworthy" );
	array_thread( ignore_and_deleters, ::add_spawn_function, ::ignore_and_delete_at_path_end );
	
	seekers = GetEntArray( "playerseek_at_path_end", "script_noteworthy" );
	array_thread( seekers, ::add_spawn_function, ::playerseek_at_path_end );
	
	smashers1 = GetEntArray( "window_smash_stop_inside", "script_noteworthy" );
	array_thread( smashers1, ::add_spawn_function, ::window_smash_stop_inside );
	
	chaoticAboves = GetEntArray( "chaotic_above_shooter", "script_noteworthy" );
	array_thread( chaoticAboves, ::add_spawn_function, ::chaotic_above_shooter );
	
	solorunChasers = GetEntArray( "solorun_chaser_spawner", "script_noteworthy" );
	array_thread( solorunChasers, ::add_spawn_function, ::solorun_chaser_spawnfunc );
	
	noBackShooters = GetEntArray( "dont_shoot_player_in_back", "script_noteworthy" );
	array_thread( noBackShooters, ::add_spawn_function, ::dont_shoot_player_in_back );
	
	guy = GetEnt( "spawner_vista2_endhouse", "script_noteworthy" );
	guy thread add_spawn_function( ::ai_unlimited_rocket_ammo );
	
	roofRunners = GetEntArray( "solorun_roofrunner", "script_noteworthy" );
	array_thread( roofRunners, ::add_spawn_function, ::dont_shoot_player_in_back );
	array_thread( roofRunners, ::add_spawn_function, ::delete_at_path_end );
}

setup_vehicles()
{
	solorunChoppers = GetEntArray( "solorun_chopper", "script_noteworthy" );
	array_thread( solorunChoppers, ::add_spawn_function, ::solorun_chopper_spawnfunc );
}

favela_escape_objectives()
{
	flag_wait( "radiotower_start" );
	
	obj1_set = false;  // hack to make Soap-less start points work with objectives
	if( IsDefined( level.sarge ) )
	{
		Objective_Add( 1, "current", &"FAVELA_ESCAPE_OBJ_FOLLOW_SOAP" );
		Objective_OnEntity( 1, level.sarge );
		Objective_SetPointerTextOverride( 1, &"FAVELA_ESCAPE_OBJ_FOLLOW_MARKER" );
		
		obj1_set = true;
	}
	
	flag_wait( "market_introdialogue_done" );
	if( obj1_set )
	{
		Objective_String( 1, &"FAVELA_ESCAPE_OBJ_FLEE_RADIOTOWER" );
		Objective_Position( 1, ( -3154, -1875, 1096 ) );
		Objective_SetPointerTextOverride( 1, "" );  // reset to default
	}
	
	flag_wait( "market_evac_chopper_incoming" );
	Objective_Complete( 1 );
	Objective_Add( 2, "current", &"FAVELA_ESCAPE_OBJ_MARKET_ESCAPE", ( -3937, -1051, 1241 ) );
	// start point hack
	if( IsDefined( level.chopper ) )
	{
		Objective_OnEntity( 2, level.chopper );
	}
	
	thread market_evac_chopper_obj_update_pos( 2 );
	
	flag_wait( "solorun_objective_display" );
	//flag_wait( "solorun_start" );
	Objective_Complete( 2 );
	Objective_Add( 3, "current", &"FAVELA_ESCAPE_OBJ_GET_BACK_TO_ROOF", ( -5924, -870, 816 ) );
	
	thread solorun_houses_obj_update_pos( 3 );
	thread solorun_houses_obj_turnoff_compass();
	
	flag_wait( "solorun_player_at_balcony" );
	Objective_Complete( 3 );
	Objective_Add( 4, "current", &"FAVELA_ESCAPE_OBJ_GET_TO_CHOPPER", ( -8192, 2128, 704 ) );
	
	thread solorun_roof_obj_update_pos( 4 );
	
	flag_wait( "solorun_player_boarded_chopper" );
	Objective_Complete( 4 );
}

solorun_houses_obj_turnoff_compass()
{
	// turn off compass while running through buildings
	trigger_wait( "solorun_houses_obj_update_0", "script_noteworthy" );
	SetSavedDvar( "compass", 0 );
	
	flag_wait( "solorun_player_at_balcony" );
	SetSavedDvar( "compass", 1 );
}

market_evac_chopper_obj_update_pos( objID )
{
	level endon( "solorun_start" );
	
	flag_wait( "market_evac_chopper_leaves_scene" );
	//Objective_Position( objID, ( -5897, -948, 1216 ) );
	
	//flag_wait( "market_evac_follow_sarge_climb" );
	Objective_State( 1, "active" );
	Objective_Current( 1 );
	Objective_OnEntity( 1, level.sarge );
	
	flag_wait( "roofrun_player_at_start_loc" );
	
	while( IsDefined( level.chopper ) )
	{
		wait( 0.05 );
	}
	
	chopper = undefined;
	while( !IsDefined( chopper ) )
	{
		wait( 0.05 );
		chopper = get_vehicle( "veh_chopper_roofrun", "targetname" );
	}
	
	Objective_State( 1, "done" );
	Objective_State( objID, "active" );
	Objective_Current( objID );
	
	Objective_OnEntity( objID, chopper );
	
	flag_wait( "player_recovery_blackscreen" );
	
	Objective_Position( objID, ( -6370.5, -944, 1044 ) );
}

solorun_houses_obj_update_pos( objID )
{
	level endon( "solorun_player_at_balcony" );
	
	trigger_wait( "solorun_houses_obj_update_0", "script_noteworthy" );
	Objective_Position( objID, ( -4756, -384, 808 ) );
	
	//trigger_wait( "solorun_houses_obj_update_1", "script_noteworthy" );
	//Objective_Position( objID, ( -4756, -384, 808 ) );
	
	trigger_wait( "solorun_houses_obj_update_2", "script_noteworthy" );
	Objective_Position( objID, ( -4760, 880, 804 ) );
	
	trigger_wait( "solorun_houses_obj_update_3", "script_noteworthy" );
	Objective_Position( objID, ( -5112, 864, 944 ) );
}

solorun_roof_obj_update_pos( objID )
{
	level endon( "solorun_player_boarded_chopper" );
	
	trigger_wait( "objective_breadcrumb_update_1", "script_noteworthy" );
	Objective_Position( objID, ( -8312, 1440, 416 ) );
	
	trigger_wait( "objective_breadcrumb_update_2", "script_noteworthy" );
	Objective_Position( objID, ( -9152, 1408, 352 ) );
	
	trigger_wait( "objective_breadcrumb_update_3", "script_noteworthy" );
	Objective_Position( objID, ( -9086, 2224, -152 ) );
	
	trigger_wait_targetname( "trig_end_glass_break" );
	Objective_OnEntity( objID, level.chopperladder, ( 0, 0, -85 ) );
	//Objective_SetPointerTextOverride( objID, &"FAVELA_ESCAPE_OBJ_JUMP_MARKER" );
}


// --------------------------
// -- STARTS --
// --------------------------
build_starts()
{
	default_start( ::start_radiotower );
	
	add_start( "intro", ::start_radiotower, "map start" );
	add_start( "street", ::start_street, "street after radiotower" );
	add_start( "street_mid", ::start_street_mid, "street after first chopper reveal" );
	add_start( "street_vista2", ::start_street_vista2, "street second vista area" );
	add_start( "market", ::start_market, "market start" );
	add_start( "market_evac", ::start_market_evac, "market evac goes wrong" );
	add_start( "market_evac_escape", ::start_market_evac_escape, "friendlies climb up to rooftops" );
	add_start( "roofrun", ::start_roofrun, "roofrun start" );
	add_start( "roofrun_bigjump", ::start_roofrun_player_jump, "roofrun player jump" );
	add_start( "solorun", ::start_solorun, "player solo run" );
	add_start( "solorun_rooftops", ::start_solorun_rooftops, "player solo run rooftops" );
	add_start( "solorun_chopper", ::start_solorun_chopper, "player jump to chopper" );
	
	add_start( "test", ::start_favela_escape_test, "[dev test]" );
}

start_favela_escape_test()
{
	level.player.ignoreme = true;
	
	level.player teleport_to_origin( ( 4892, 292, 1134 ), ( 0, 180, 0 ) );
	thread radiotower_enemy_vehicles();
	
	/* market evac
	delaythread( 0.05, ::market_evac_playermantle_helper, 1148 );
	trigger_off( "sbmodel_market_evac_playerblock", "targetname" );
	level.player teleport_to_origin( ( -3128, -2888, 1064 ), ( 0, 90, 0 ) );
	chopper = spawn_chopper( 6, false );
	
	path2start = GetStruct( "struct_market_evac_chopper_path2", "targetname" );
	path2nextnode = GetStruct( path2start.target, "targetname" );
	
	chopper thread market_evac_chopper_bugout_path( path2start );
	*/
	
	/*
	level.player teleport_to_origin( ( -6226, -874, 788 ), ( 0, 300, 0 ) );
	thread bigjump_angrymob();
	*/
	
	/*
	spawner = GetEnt( "spawner_vista2_endhouse", "script_noteworthy" );
	guy = spawner spawn_ai();
	remove_all_flood_spawners();
	thread vista2_endhouse_jumpthru();
	level.player teleport_to_origin( ( -972, 1740, 1124 ), ( 0, 180, 0 ) );
	level.hero1 teleport_to_origin( ( -796, 1716, 1124 ), ( 0, 180, 0 ) );
	*/
}

start_radiotower()
{
	level thread radiotower();
}

start_street()
{
	flag_set( "radiotower_start" );
	flag_set( "radiotower_enemies_retreat" );
	flag_set( "radiotower_escape_technical_2_arrival" );
	
	thread radiotower_gate_open( false );
	
	level.sarge set_force_color( "b" );
	
	warp_friends_and_player( "struct_start_street" );
	
	trigger_activate_targetname( "trig_script_color_allies_b5" );
	
	thread street();
	
	thread autosave_by_name( "street_start" );
}

start_street_mid()
{
	flag_set( "radiotower_start" );
	
	level.sarge set_force_color( "b" );
	
	warp_friends_and_player( "struct_start_street_mid" );
	
	thread street();
}

start_street_vista2()
{
	flag_set( "radiotower_start" );
	
	level.sarge set_force_color( "b" );
	
	warp_friends_and_player( "struct_start_street_vista2" );
	
	trigger_activate_targetname( "uphill_advance_3" );
	
	thread street( "vista2" );
}

start_market()
{
	flag_set( "radiotower_start" );
	
	level.sarge set_force_color( "b" );
	
	warp_friends_and_player( "struct_start_market" );
	
	trigger_activate_targetname( "trig_spawn_market_start" );
	trigger_activate_targetname( "uphill_advance_6" );
	
	thread friendly_colors( "market" );
	thread market();
	
	// let enemies spawn and run to nodes
	trigger_off( "market_advance_1", "targetname" );
	wait( 10 );
	trigger_on( "market_advance_1", "targetname" );
	trigger_activate_targetname_safe( "market_advance_1" );
}

start_market_evac()
{
	flag_set( "radiotower_start" );
	flag_set( "market_introdialogue_done" );
	
	remove_nonhero_friends( 1 );
	guys = get_nonhero_friends();
	redshirt = guys[0];
	
	level.sarge set_force_color( "b" );
	level.hero1 set_force_color( "b" );
	//redshirt set_force_color( "p" );
	redshirt disable_replace_on_death();
	redshirt notify( "death" );
	redshirt Delete();
	
	// fake chopper spawn
	flag_set( "market_advance_4" );
	thread market_fake_choppers();
	
	warp_friends_and_player( "struct_start_market_evac" );
	
	thread market_evac();
}

start_market_evac_escape()
{
	flag_set( "radiotower_start" );
	
	remove_nonhero_friends( 1 );
	guys = get_nonhero_friends();
	redshirt = guys[0];
	
	struct = GetStruct( "struct_start_market_evac_escape_player", "targetname" );
	level.player teleport_to_origin( struct.origin, struct.angles );
	
	sargeNode = GetNode( "node_sarge_preclimb", "targetname" );
	hero1Node = GetNode( "node_hero1_preclimb", "targetname" );
	redshirtNode = GetNode( "node_redshirt_preclimb", "targetname" );
	
	array_thread( level.friends, ::set_temp_goalradius, 128 );
	
	redshirt = get_single_redshirt();
	
	level.sarge ForceTeleport( sargeNode.origin, sargeNode.angles );
	level.hero1 ForceTeleport( hero1Node.origin, hero1Node.angles );
	redshirt ForceTeleport( redshirtNode.origin, redshirtNode.angles );
	
	level.sarge SetGoalNode( sargeNode );
	level.hero1 SetGoalNode( hero1Node );
	redshirt SetGoalNode( redshirtNode );
	
	array_thread( level.friends, ::ent_flag_init, "climbing_ok" );
	waittillframeend;
	array_thread( level.friends, ::ent_flag_set, "climbing_ok" );
	
	thread favesc_waveoff_music();
	thread market_evac_escape();
}

start_roofrun()
{
	flag_set( "radiotower_start" );
	
	remove_nonhero_friends( 1 );
	guys = get_nonhero_friends();
	redshirt = guys[0];
	redshirt magic_bullet_shield();
	
	array_thread( level.friends, ::clear_force_color );
	
	sargenode = GetNode( "node_roofrun_sarge_waitforplayer", "targetname" );
	hero1node = GetNode( "node_roofrun_hero1_waitforplayer", "targetname" );
	redshirtnode = GetNode( "node_roofrun_redshirt_waitforplayer", "targetname" );
	
	level.sarge thread teleport_to_origin( sargenode.origin, sargenode.angles );
	level.hero1 thread teleport_to_origin( hero1node.origin, hero1node.angles );
	redshirt thread teleport_to_origin( redshirtnode.origin, redshirtnode.angles );
	
	level.player teleport_to_origin( ( -3552, -992, 1194 ), ( 0, 180, 0 ) );
	
	array_thread( level.friends, ::ent_flag_init, "roofrun_start" );
	array_thread( level.friends, ::ent_flag_init, "climbing_ok" );
	waittillframeend;
	array_thread( level.friends, ::ent_flag_set, "roofrun_start" );
	array_thread( level.friends, ::ent_flag_set, "climbing_ok" );
	waittillframeend;
	
	thread favesc_waveoff_music();
	thread roofrun();
}

start_roofrun_player_jump()
{
	flag_set( "radiotower_start" );
	flag_set( "market_introdialogue_done" );
	flag_set( "market_evac_chopper_incoming" );
	
	flag_set( "market_evac_player_on_roof" );
	
	remove_nonhero_friends( 1 );
	guys = get_nonhero_friends();
	redshirt = guys[0];
	
	level.runnersDone = 0;
	
	array_thread( level.friends, ::ent_flag_init, "roofrun_start" );
	
	sargeorg = GetStruct( "roofrun_sarge_waitforplayer", "targetname" );
	level.sarge teleport_to_origin( sargeorg.origin, sargeorg.angles );
	
	playerorg = GetStruct( "struct_start_roofrun_player_jump_player", "targetname" );
	level.player teleport_to_origin( playerorg.origin, playerorg.angles );
	
	wait( 0.05 );
	array_thread( level.friends, ::ent_flag_set, "roofrun_start" );
	waittillframeend;
	
	level.sarge thread roofrun_sarge( true );
	redshirt thread roofrun_redshirt( true );
	level.hero1 thread roofrun_hero1( true );

	thread roofrun_player_bigjump();
	
	flag_wait( "player_recovery_done" );
	
	// level progression
	thread solorun();
}

start_solorun()
{
	flag_set( "solorun_objective_display" );
	flag_set( "radiotower_start" );
	flag_set( "market_introdialogue_done" );
	flag_set( "market_evac_chopper_incoming" );
	flag_set( "market_evac_player_on_roof" );
	
	delete_all_friends();
	
	level.player TakeAllWeapons();
	
	playerorg = GetStruct( "struct_solorun_beginning_start_player", "targetname" );
	level.player thread teleport_to_origin( playerorg.origin, playerorg.angles );
	
	thread favesc_finalrun_music();
	
	thread solorun();
}

start_solorun_rooftops()
{
	flag_set( "solorun_objective_display" );
	flag_set( "radiotower_start" );
	flag_set( "market_introdialogue_done" );
	flag_set( "market_evac_chopper_incoming" );
	flag_set( "market_evac_player_on_roof" );
	flag_set( "solorun_start" );
	
	delete_all_friends();
	
	level.player TakeAllWeapons();
	
	playerorg = GetStruct( "struct_solorun_rooftops_start_player", "targetname" );
	level.player teleport_to_origin( playerorg.origin, playerorg.angles );
	
	thread solorun( "rooftops" );
}

start_solorun_chopper()
{
	flag_set( "radiotower_start" );
	flag_set( "market_evac_player_on_roof" );
	flag_set( "solorun_player_at_balcony" );
	
	delete_all_friends();
	
	level.player TakeAllWeapons();
	
	playerorg = GetStruct( "struct_solorun_chopper_start_player", "targetname" );
	level.player teleport_to_origin( playerorg.origin, playerorg.angles );
	
	thread solorun( "chopperjump" );
}


// ------------------
// --- RADIOTOWER ---
// ------------------
radiotower()
{
	thread intro_rojas_crucified();
	thread favesc_combat_music();
	thread radiotower_crowd_walla();
	thread radiotower_runup_scout();
	thread radiotower_runup_friendlies_ignore();
	thread radiotower_friendly_colors();
	thread radiotower_doorkick_1();
	thread radiotower_curtainpull_1();
	thread radiotower_hiding_door_guy_cleanup();
	
	thread radiotower_stop_roof_respawners();
	
	flag_set( "radiotower_start" );
	
	battlechatter_off( "allies" );
	
	// make all redshirts invincible for a while
	array_thread( get_nonhero_friends(), ::magic_bullet_shield );
	
	thread radiotower_runpath_dialogue();
	
	if( GetDvar( "introscreen" ) != "0" )
	{
		level waittill( "introscreen_complete" );
	}
	else
	{
		flag_set( "introscreen_start_dialogue" );
	}
	
	sarge_postintro_walkspot = GetNode( "node_sarge_post_intro_goal", "targetname" );
	level.sarge SetGoalNode( sarge_postintro_walkspot );
	
	hero1_postintro_walkspot = GetNode( "node_hero1_post_intro_goal", "targetname" );
	level.hero1 SetGoalNode( hero1_postintro_walkspot );
	
	// after player moves forward, trigger color chain
	trigger_wait_targetname( "trig_intro_playerturnedcorner" );
	trigger_activate_targetname( "trig_script_color_allies_b0" );
	
	// player gets to end of little path
	trigger_wait_targetname( "trig_radiotower_brushpath_end" );
	
	// nonheroes are mortal again
	array_thread( get_nonhero_friends(), ::stop_magic_bullet_shield_safe );
	
	thread radiotower_enemy_vehicles_prethink();
	delaythread( 0.75, ::radiotower_escape_dialogue );
	
	thread radiotower_enemies_retreat();
	
	// level progression
	trigger_wait_targetname( "trig_radiotower_exit" );
	flag_set( "radiotower_exit" );
	thread autosave_by_name( "street_start" );
	
	thread vista1_walla();
	
	thread street();
}

intro_rojas_crucified()
{
	level endon( "radiotower_exit" );
	level endon( "cleaning_up_rojas" );
	
	animref = GetEnt( "intro_rojas_beaten_animref", "targetname" );
	spawner = GetEnt( animref.target, "targetname" );
	ASSERT( IsDefined( animref ) && IsDefined( spawner ) );
	
	spawner.script_drone = undefined;
	//spawner.script_drone_override = true;
	
	rojas = spawner spawn_ai( true );
	ASSERT( IsDefined( rojas ) );
	
	restraints = spawn_anim_model( "rojas_restraints" );
	
	idleAnime = "intro_rojas_idle";
	deathAnime = "intro_rojas_death";
	
	animref thread anim_generic_loop( rojas, idleAnime );
	animref thread anim_loop_solo( restraints, "idle" );
	
	level thread intro_rojas_crucified_cleanup( rojas, animref, restraints );
	
	rojas.grenadeAmmo = 0;
	rojas.dropWeapon = false;
	rojas set_battlechatter( false );
	rojas.allowDeath = false;
	rojas.a.nodeath = true;
	rojas.skipDeathAnim = true;
	rojas.noragdoll = true;
	rojas.takedamage = true;
	rojas.animname = "generic";
	rojas.health = 5000;
	rojas disable_pain();
	
	rojas add_damage_function( ::bloody_pain );
	
	while( 1 )
	{
		rojas waittill( "damage", amount, who );
		
		if( amount <= 1 )
		{
			continue;
		}
		
		if( IsPlayer( who ) )
		{
			break;
		}
	}
	
	animref anim_stopanimscripted();
	rojas anim_stopanimscripted();
	
	rojas.allowDeath = true;
	rojas.a.nodeath = true;
	rojas.takedamage = false;
	
	//rojas.anim_mode = "nophysics";//zonly_physics, nophysics, none gravity
	// rojas animmode( "nophysics" );
	rojas delaycall( 0.1, ::Kill );
	
//	animref thread anim_generic( rojas, deathAnime );
	animref thread anim_custom_animmode_solo( rojas, "nophysics", deathAnime );
	// wait 0.05;
	// rojas animmode( "nophysics" );
}

intro_rojas_crucified_cleanup( rojas, animref, restraints )
{
	flag_wait( "radiotower_exit" );
	
	level notify( "cleaning_up_rojas" );
	
	if( IsDefined( rojas ) )
	{
		rojas anim_stopanimscripted();
	}
	animref anim_stopanimscripted();
	restraints anim_stopanimscripted();
	
	wait( 0.05 );
	
	
	if( IsDefined( rojas ) )
	{
		rojas Delete();
	}
	animref Delete();
	restraints Delete();
}


// ---------------
// --- STREETS ---
// ---------------
street( startPoint )
{
	thread friendly_colors( startPoint );
	
	thread street_dialogue();
	
	thread vista1_door1_kick();
	thread vista1_wavingguy();
	
	thread street_roof1_doorkick();
	thread street_mid_intersection_clearout();
	
	thread vista2_walla();
	
	thread vista2_technical_prethink();
	thread vista2_endhouse_jumpthru();
	thread vista2_firsthalf_enemies_retreat();
	thread vista2_leftbalcony_enemies_magicgrenade();
	
	// level progression
	thread market();
}

friendly_colors( startPoint )
{
	street_trigPrefix = "street_advance";
	street_numTrigs = 5;
	
	uphill_trigPrefix = "uphill_advance";
	uphill_numTrigs = 6;
	
	market_trigPrefix = "market_advance";
	market_numTrigs = 6;
	
	if( !IsDefined( startPoint ) )
	{
		// MAIN LOGIC
		thread color_flags_advance( street_trigPrefix, street_numTrigs );
		flag_wait( street_trigPrefix + "_" + street_numTrigs );
		
		thread color_flags_advance( uphill_trigPrefix, uphill_numTrigs );
		flag_wait( uphill_trigPrefix + "_" + uphill_numTrigs );
		
		thread color_flags_advance( market_trigPrefix, market_numTrigs );
		flag_wait( market_trigPrefix + "_" + market_numTrigs );
		
	}
	else
	{
		// SPECIAL CASE ALTERNATE LOGIC FOR START POINTS
		if( startPoint == "vista2" )
		{
			// start from the third trigger in the uphill chain
			thread color_flags_advance( uphill_trigPrefix, uphill_numTrigs, 3 );
			flag_wait( uphill_trigPrefix + "_" + uphill_numTrigs );
			
			thread color_flags_advance( market_trigPrefix, market_numTrigs );
			flag_wait( market_trigPrefix + "_" + market_numTrigs );
		}
		if( startPoint == "market" )
		{
			// start from the last trigger in the uphill chain
			thread color_flags_advance( uphill_trigPrefix, uphill_numTrigs, 6 );
			flag_wait( uphill_trigPrefix + "_" + uphill_numTrigs );
			
			thread color_flags_advance( market_trigPrefix, market_numTrigs );
			flag_wait( market_trigPrefix + "_" + market_numTrigs );
		}
	}
}


// --------------
// --- MARKET ---
// --------------
market()
{
	thread market_dialogue();
	thread market_fake_choppers();
	
	// allies using chokepoints in the market causes bad behavior
	array_thread( level.friends, ::scr_usechokepoints, false );
	remove_global_spawn_function( "allies", ::scr_usechokepoints );
	
	thread market_hero1_change_color();
	thread market_kill_extra_redshirts();
	
	thread market_door1();
	
	// level progression
	thread market_evac();
}

market_fake_choppers()
{
	flag_wait( "market_advance_4" );
	fakechopper = maps\_vehicle::spawn_vehicle_from_targetname( "vehicle_market_fake_chopper_1" );
	flag_wait( "market_chopper_spawned" );
	wait( 1 );
	fakechopper Delete();
	
	flag_wait( "market_chopper_leaving_scene" ); // a vehiclenode on the chopper path sets this script_flag
	wait( 5 );
	
	fakechopper = maps\_vehicle::spawn_vehicle_from_targetname( "vehicle_market_fake_chopper_2" );
	flag_wait( "market_evac_chopper_spawned" );
	wait( 4 );
	fakechopper Delete();
}

market_evac()
{
	flag_wait( "market_evac_start" );
	
	thread market_evac_dialogue();
	
	level notify( "color_flags_advance_stop" );
	
	// warp friendlies forward if the player has slammed through this area
	warpSpots = GetStructArray( "struct_market_evac_friendly_warp", "targetname" );
	ASSERT( warpSpots.size >= level.friends.size );
	
	foreach( idx, guy in level.friends )
	{
		guy thread market_evac_friend_teleport( warpSpots[ idx ] );
	}
	
	// spawn an invincible redshirt if one's not alive right now
	nonheroes = get_nonhero_friends();
	redshirt = undefined;
	if( !nonhero_is_valid( nonheroes ) )
	{
		// if guys are here now it means they're meleeing, so throw them away and spawn the new guy
		if( nonheroes.size )
		{
			foreach( guy in nonheroes )
			{
				guy friend_remove();
				guy disable_ai_color();
				guys = [];
				guys[ 0 ] = guy;
				thread AI_delete_when_out_of_sight( guys, 1000 );
			}
		}
		
		// if we don't have any more redshirts, spawn an emergency guy
		spawner = GetEnt( "market_evac_redshirt_spawner", "targetname" );
		
		guy = spawner spawn_ai();
		ASSERTEX( IsDefined( guy ), "Couldn't spawn emergency friendly for market evac escape." );
		
		guy friend_add();
		redshirt = guy;
	}
	else
	{
		redshirt = nonheroes[ 0 ];
	}
	
	// stop color replacements
	maps\_colors::kill_color_replacements();
	
	redshirt magic_bullet_shield_safe();
	
	// redshirt becomes a pink guy
	redshirt set_force_color( "p" );
	
	player_speed_percent( 85, 1 );
	array_thread( level.friends, ::scr_moveplaybackrate, 1.25 );
	
	battlechatter_off( "allies" );
	
	level thread market_evac_chopper();
	level thread market_evac_enemy_foreshadowing();
	
	// "There's Nikolai's Pave Low! Let's go!"
	level.sarge delaythread( 2, ::dialogue, "favesc_cmt_therespavelow" );
	
	thread market_evac_friends();
	
	flag_wait( "market_evac_chopper_incoming" );
	autosave_by_name( "market_evac_chopper_incoming" );
	
	// keep the redshirt alive, because it looks a lot better when he runs to his climb spot
	//  with the rest of the squad
	nonheroes = get_nonhero_friends();
	foreach( guy in nonheroes )
	{
		guy magic_bullet_shield_safe();
	}
	
	delaythread( 0.5, ::market_evac_fakefire_rpgs );
	delaythread( 4, ::market_evac_fakefire_smallarms );
	thread market_evac_enemies();
	
	flag_set( "market_evac_ambush_start" );
	
	player_speed_percent( 90, 1 );
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	
	flag_wait( "market_evac_enemies_depleted" );
	
	// level progression
	thread market_evac_escape();
}

market_evac_friend_teleport( warpSpot )
{
	if( Distance( self.origin, level.player.origin ) < 800 )
	{
		return;
	}
	
	if( self != level.sarge && self != level.hero1 )
	{
		// a meleeing nonhero is going to be replaced later so we don't have to teleport him
		if( IsDefined( self.melee ) )
		{
			return;
		}
	}
	
	self teleport_to_node( warpSpot );
}

nonhero_is_valid( nonheroes )
{
	if( !nonheroes.size )
	{
		return false;
	}
	
	guy = nonheroes[ 0 ];
	
	if( !IsAlive( guy ) )
	{
		return false;
	}
	
	if( IsDefined( guy.melee ) )
	{
		return false;
	}
	
	return true;
}

market_evac_friends()
{
	flag_wait( "market_evac_friendlies_go_outside" );
	
	// head outside heat style to predefined nodes
	array_thread( level.friends, ::market_evac_friend_outside_setup );
	
	sargeNode = GetNode( "node_sarge_soccerfield_cover", "targetname" );
	hero1Node = GetNode( "node_hero1_soccerfield_cover", "targetname" );
	redshirtNode = GetNode( "node_redshirt_soccerfield_cover", "targetname" );
	
	redshirt = get_single_redshirt();
	level.sarge thread market_evac_friend_runexactpath( sargeNode );
	level.hero1 thread market_evac_friend_runexactpath( hero1Node );
	redshirt thread market_evac_friend_runexactpath( redshirtNode );
	
	flag_wait( "market_evac_enemies_depleted" );
}

market_evac_friend_outside_setup()
{
	self thread clear_force_color();
	self thread enable_heat_behavior();
	self thread be_less_scared();
	self thread set_temp_goalradius( 256 );
	self thread disable_arrivals();
	self thread set_fixednode_false();
	self thread pathrandompercent_set( 0 );
	self thread scr_usechokepoints( false );
}

market_evac_friend_runexactpath( startnode )
{
	self ent_flag_init( "climbing_ok" );
	
	nodes = get_targeted_line_array( startnode );
	
	// first node in the chain is specially handled
	nodes = array_remove( nodes, startnode );
	
	self SetGoalNode( startnode );
	
	// wait til we want to start moving forward
	flag_wait( "market_evac_enemies_depleted" );
	
	// always move while shooting
	self thread scr_disable_dontshootwhilemoving();
	// SUPER accurate - normal scale is 0 to 1 but there are lots of other factors too
	self thread scr_accuracy( 5.0 );
	
	foreach( node in nodes )
	{
		self SetGoalNode( node );
		self waittill( "goal" );
	}
	
	self disable_heat_behavior();
	
	self ent_flag_set( "climbing_ok" );
}

market_evac_escape()
{
	array_thread( level.friends, ::scr_moveplaybackrate, 1 );
	player_speed_percent( 90, 1 );
	
	//trigger_activate_targetname_safe( "trig_script_color_allies_b30" );
	
	thread market_evac_remove_helperclip();
	
	// "Come on! We've got to get to the rooftops, this way!"
	level.sarge thread dialogue( "favesc_cmt_gettorooftops" );
	delaythread( 15, ::market_evac_bugplayer );
	
	//let player get close before friendlies climb
	flag_wait( "market_evac_friendlies_start_climbing" );
	
	
	zTest = 1148;
	thread market_evac_playermantle_watch( zTest );
	thread market_evac_playermantle_helper( zTest );
	thread market_evac_friendlies_climb();
	
	flag_wait( "market_evac_player_on_roof" );

	// level progression	
	thread roofrun();
}

market_evac_friendlies_climb()
{
	animref = GetStruct( "market_evac_friendlies_climb_animspot", "targetname" );
	animref2 = GetStruct( "market_evac_friendlies_climb_animspot_2", "targetname" );
	animeL = "favela_escape_rooftop_traverse_L";
	animeR = "favela_escape_rooftop_traverse_R";
	animeM = "favela_escape_rooftop_traverse_M";
	animeM_idle = "favela_escape_rooftop_traverse_M_idle";
	animeM_idle_2_run = "favela_escape_rooftop_traverse_M_idle_2_run";
	
	redshirt = get_single_redshirt();
	
	array_thread( level.friends, ::ent_flag_init, "roofrun_start" );
	
	redshirt magic_bullet_shield_safe();
	
	array_thread( level.friends, ::ignore_everything );
	array_thread( level.friends, ::set_temp_goalradius, 32 );
	array_thread( level.friends, ::scr_walkDistFacingMotion, 16 );  // per jiesang
	
	hero1Node = GetNode( "node_roofrun_hero1_waitforplayer", "targetname" );
	redshirtNode = GetNode( "node_roofrun_redshirt_waitforplayer", "targetname" );
	
	array_thread( level.friends, ::clear_force_color );
	
	level.friendliesClimbing = 0;
	
	level.hero1 thread market_evac_friendly_climb( animref2, animeL, hero1Node );
	redshirt thread  market_evac_friendly_climb( animref, animeR, redshirtNode );
	level.sarge thread market_evac_sarge_climb( animref, animeM, animeM_idle, animeM_idle_2_run );
	
	// wait for all friendlies to climb up
	while( level.friendliesClimbing < level.friends.size )
	{
		wait( 0.05 );
	}
	
	// remove player blocking clip
	trigger_off( "sbmodel_market_evac_playerblock", "targetname" );
}

market_evac_friendly_climb( animref, anime, node )
{
	// wait to finish the exact path running through the soccer field
	self ent_flag_wait( "climbing_ok" );
	
	animref anim_generic_reach( self, anime );
	level.friendliesClimbing++;
	animref anim_generic( self, anime );
	
	self SetGoalNode( node );
	
	wait( 0.05 );
	self ent_flag_set( "roofrun_start" );
}

market_evac_sarge_climb( animref, anime, anime_idle, anime_idle_2_run )
{
	// wait to finish the exact path running through the soccer field
	self ent_flag_wait( "climbing_ok" );
	
	flag_set( "market_evac_follow_sarge_climb" );
	
	animref anim_generic_reach( self, anime );
	level.friendliesClimbing++;
	animref anim_generic( self, anime );
	
	if( market_evac_sarge_should_idle() )
	{
		self SetGoalPos( self.origin );
		animref thread anim_generic_loop( self, anime_idle, "sarge_idle_stop" );
		
		while( market_evac_sarge_should_idle() )
		{
			wait( 0.05 );
		}
		
		animref notify( "sarge_idle_stop" );
		animref anim_generic( self, anime_idle_2_run );
	}
	
	sargeNode = GetNode( "node_roofrun_sarge_waitforplayer", "targetname" );
	self SetGoalNode( sargeNode );
	
	wait( 0.05 );
	self ent_flag_set( "roofrun_start" );
}

market_evac_sarge_should_idle()
{
	if( flag( "market_evac_player_mantled" ) )
	{
		return false;
	}
	
	trig = GetEnt( "trig_market_evac_mantlehelper", "targetname" );
	if( level.player IsTouching( trig ) )
	{
		return false;
	}
	
	return true;
}

// ----------------
// --- ROOF RUN ---
// ----------------
roofrun()
{
	autosave_by_name( "roofrun_start" );
	
	level.runnersDone = 0;
	thread roofrun_waitfor_finish();
	
	battlechatter_off( "allies" );
	
	flag_wait( "roofrun_player_at_start_loc" );
	
	thread roofrun_chopper_cargodoor_open();
	delaythread( 3, ::roofrun_walla );
	
	// TODO I think this stuff needs adjustment based on distance
	player_speed_percent( 90, 1 );
	setSavedDvar( "player_sprintUnlimited", "1" );
	array_thread( level.friends, ::scr_animplaybackrate, 1.135 );
	
	foreach( index, guy in level.friends )
	{
		guy.animname = "freerunner";
		guy thread roofrun_friendly_generic();
		
		if( guy == level.sarge )
		{
			guy thread roofrun_sarge();
		}
		else if( guy == level.hero1 )
		{
			guy thread roofrun_hero1();
		}
		else
		{
			guy thread roofrun_redshirt();
		}	
	}
	
	thread roofrun_dialogue();
	
	//thread roofrun_modulate_playerspeed( level.sarge );
	
	thread roofrun_player_bigjump();
	
	flag_wait( "player_recovery_done" );
	
	// level progression
	thread solorun();
}

roofrun_chopper_cargodoor_open()
{
	chopperSpawner = GetEnt( "veh_chopper_roofrun", "targetname" );
	
	chopper = undefined;
	if( IsDefined( chopperSpawner.last_spawned_vehicle ) )
	{
		chopper = chopperSpawner.last_spawned_vehicle;
	}
	else
	{
		chopperSpawner waittill( "spawned", chopper );
	}
	
	chopper.animname = "chopper";
	
	chopper waittill( "reached_dynamic_path_end" );
	
	flag_wait( "player_near_bigjump" );
	
	chopper PlaySound( "pavelow_door_open" );
	chopper anim_single_solo( chopper, "cargodoor_open" );
}


// ----------------
// --- SOLO RUN ---
// ----------------
solorun( start )
{
	flag_set( "solorun_start" );
	
	waitBeforeJump = undefined;
	
	if( !IsDefined( start ) )
	{
		start = "normal";
	}
	
	player_speed_percent( 100, 0.1 );
	player_sprint_multiplier_blend( 1.5, 0.1 );
	setSavedDvar( "player_sprintUnlimited", "1" );
	
	// sprinty hands
	level.player GiveWeapon( "freerunner" );
	level.player SwitchToWeapon( "freerunner" );
	
	if( start == "chopperjump" )
	{
		thread rooftop_slide_exploder();
		thread rooftop_slide_glassbreak();
		
		waitBeforeJump = false;
		thread solorun_chopperjump( waitBeforeJump );
	}
	else if( start == "rooftops" )
	{
		thread solorun_balcony_save();
		
		thread solorun_player_difficulty_adjustment();
		thread solorun_sprint_tracker();
		thread solorun_playerhurt_replacehint();
		thread solorun_player_progression_tracker();
		
		thread player_bullet_whizbys();
		thread solorun_dialogue( false );
		
		thread solorun_rooftop_squibs();
		thread solorun_timer_prethink();
		thread solorun_chasers_remove();
		thread solorun_rooftop_chopper_fakefire();
		thread solorun_chopper_audio();
		
		thread rooftop_slide_exploder();
		thread rooftop_slide_glassbreak();
		thread rooftop_slide_deleteaxis();
		
		thread solorun_chopperjump( waitBeforeJump );
	}
	else
	{
		thread solorun_start_playerfail( 0.75 );
		thread solorun_civilian_doorshut();
		
		thread solorun_balcony_save();
		
		thread solorun_player_difficulty_adjustment();
		thread solorun_sprint_tracker();
		thread solorun_playerhurt_replacehint();
		thread solorun_player_progression_tracker();
		
		thread player_bullet_whizbys();
		thread solorun_dialogue();
		
		thread solorun_rooftop_squibs();
		thread solorun_timer_prethink();
		thread solorun_chasers_remove();
		thread solorun_rooftop_chopper_fakefire();
		thread solorun_chopper_audio();
		
		thread rooftop_slide_exploder();
		thread rooftop_slide_glassbreak();
		thread rooftop_slide_deleteaxis();
		
		thread solorun_chopperjump( waitBeforeJump );
	}
	
	flag_wait( "solorun_player_boarded_chopper" );
	
	wait( 8 );
	
	fadeTime = 4;
	blackTime = 4;
	
	// fade to black
	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay FadeOverTime( fadeTime );
	black_overlay.alpha = 1;
	wait( fadeTime );
	
	flag_set( "level_faded_to_black" );

	wait( blackTime );
	nextmission();
}

solorun_balcony_save()
{
	flag_wait( "solorun_player_near_balcony" );
	
	if( solorun_balcony_save_aicheck() )
	{
		maps\_autosave::_autosave_game_now();
	}
}

// mostly copied from _autosave::autoSaveThreatCheck(), with some omissions
solorun_balcony_save_aicheck()
{
	volume = GetEnt( "vol_solorun_ai_behind_player_near_balcony", "targetname" );
	
	enemies = GetAISpeciesArray( "bad_guys", "all" );

	foreach ( enemy in enemies )
	{
		if ( !IsDefined( enemy.enemy ) )
		{
			continue;
		}

		if ( !IsPlayer( enemy.enemy ) )
		{
			continue;
		}

		// is trying to melee the player
		if ( IsDefined( enemy.Melee ) && IsDefined( enemy.melee.target ) && IsPlayer( enemy.melee.target ) )
		{
			/# maps\_autosave::AutoSavePrint( "autosave failed: AI meleeing player" ); #/
			return( false );
		}

		if ( enemy.finalAccuracy < 0.021 && enemy.finalAccuracy > -1 )
		{
			// enemy lacks the accuracy to be a threat
			continue;
		}
		
		// level specific!  he's in the room behind the player
		if( volume IsTouching( enemy ) )
		{
			/# maps\_autosave::AutoSavePrint( "autosave failed: AI are in a volume close behind the player" ); #/
			return false;
		}
	
		/* we want CanSee checks here, this area is too squirrelly for distance checks to work well
		proximity_threat = false;
		foreach ( player in level.players )
		{
			dist = Distance( enemy.origin, player.origin );
			
			if ( dist < 360 )
			{
				/# maps\_autosave::AutoSavePrint( "autosave failed: AI too close to player" ); #/
				return false;
			}
			else
			if ( dist < 1000 )
			{
				proximity_threat = true;
			}
		}
		
		if ( !proximity_threat )
		{
			// enemy isn't close enough to be a threat
			continue;
		}
		*/
	
		// recently shot at the player
		if ( enemy.a.lastShootTime > GetTime() - 500 )
		{
			if ( enemy animscripts\utility::canSeeEnemy( 0 ) && enemy CanShootEnemy( 0 ) )
			{
				/# maps\_autosave::AutoSavePrint( "autosave failed: AI firing on player" ); #/
				return false;
			}
		}

		if ( IsDefined( enemy.a.aimIdleThread ) && enemy animscripts\utility::canSeeEnemy( 0 ) && enemy CanShootEnemy( 0 ) )
		{
			/# maps\_autosave::AutoSavePrint( "autosave failed: AI aiming at player" ); #/
			return false;
		}
	}

	if ( player_is_near_live_grenade() )
	{
		return false;
	}

	return true;
}
