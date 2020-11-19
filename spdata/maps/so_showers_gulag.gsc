#include maps\_utility;
#include maps\_riotshield;
#include maps\_vehicle;
#include maps\_vehicle_spline;
#include maps\_anim;
#include maps\_hud_util;
#include common_scripts\utility;
#include maps\gulag_code;
#include maps\_specialops;

// ---------------------------------------------------------------------------------
//	NEED TO PURGE AND CLEAN MAIN
// ---------------------------------------------------------------------------------

main()
{

	level.so_compass_zoom = "close";

//	breakpoint;
	gulag_destructible_volumes = GetEntArray( "gulag_destructible_volume", "targetname" );
	mask_destructibles_in_volumes( gulag_destructible_volumes );
	mask_interactives_in_volumes( gulag_destructible_volumes );

	level.default_goalheight = 128;
	create_dvar( "f15", 1 );
	SetSavedDvar( "g_friendlyNameDist", 0 );

	maps\createfx\gulag_audio::main();
	//VisionSetNight( "gulag_nvg", 1.5 );

	// The Gulag
//	PreCacheString( &"GULAG_INTROSCREEN_LINE_1" );
	// Northern Russia - 09:20:[{FAKE_INTRO_SECONDS:02}] hrs
//	PreCacheString( &"GULAG_INTROSCREEN_LINE_2" );
	// P03 'Roach' Silvers
//	PreCacheString( &"GULAG_INTROSCREEN_LINE_3" );
	// SEAL Team Six, U.S.N.
//	PreCacheString( &"GULAG_INTROSCREEN_LINE_4" );

//	level.start_point = "unload";
	set_default_start( "so_showers" );
	add_start( "so_showers", ::start_so_showers_timed, "Special Op: Showers" );

	falling_rib_chunks = GetEntArray( "falling_rib_chunk", "targetname" );
	array_thread( falling_rib_chunks, ::self_delete );
	top_hall_exploders = GetEntArray( "top_hall_exploder", "targetname" );
	array_thread( top_hall_exploders, ::self_delete );
	top_hall_chunks = GetEntArray( "top_hall_chunk", "targetname" );
	array_thread( top_hall_chunks, ::self_delete );
	top_hall_chunks = GetEntArray( "top_hall_chunk", "targetname" );
	array_thread( top_hall_chunks, ::self_delete );

	level.disable_interactive_tv_use_triggers = true;

	/*
	start = create_start( "intro" );
	start.main = ::gulag_flyin;
	start.text = "Intro";
	
	start = create_start( "approach" );
	start.main = ::gulag_approach;
	start.text = "Approach";
	*/

	level.custom_no_game_setupFunc = ::gulag_no_game_start_setupFunc;
	level.slowmo_viewhands = "viewhands_player_udt";

	maps\_drone_ai::init();
	maps\gulag_precache::main();
	maps\createart\gulag_fog::main();
	maps\gulag_fx::main();

	maps\_load::main();
	maps\_compass::setupMiniMap( "compass_map_gulag_2" );
	setsaveddvar( "compassmaxrange", "1350" );

	maps\_slowmo_breach::slowmo_breach_init();
	level._effect[ "breach_door" ]					 = LoadFX( "explosions/breach_wall_concrete" );

	maps\gulag_anim::gulag_anim();
	maps\_nightvision::main( level.players );

	level.rioter_threat = 1000;
	level._pipe_fx_time = 2.5;

	flag_init( "intro_helis_go" );
	flag_init( "stop_tv_loop" );
	flag_init( "f15s_spawn" );
	flag_init( "anti_air_missiles_fire" );
	flag_init( "aa_hit" );
	flag_init( "f15s_attack" );
	flag_init( "player_heli_uses_modified_yaw" );
	flag_init( "intro_helis_spawned" );
	flag_init( "player_lands" );
	flag_init( "overlook_cleared_with_safe_time" );
	//flag_init( "cell_door1" );
	flag_init( "cell_door2" );
	flag_init( "cell_door3" );
	flag_init( "cell_door4" );
	flag_init( "cell_door_weapons" );
	flag_init( "access_control_room" );
	flag_init( "going_in_hot" );
	flag_init( "gulag_cell_doors_enabled" );
	flag_init( "player_exited_bathroom" );
	flag_init( "player_rappels_from_bathroom" );
	flag_init( "rope_drops_now" );
	flag_init( "cell_duty" );
	flag_init( "cellblock_player_starts_rappel" );
	flag_init( "bathroom_second_wave_trigger" );
	flag_init( "soap_snipes_tower" );
	flag_init( "slamraam_gets_players_attention" );
	flag_init( "slamraam_killed_2" );
	flag_init( "stop_rotating_around_gulag" );
	flag_init( "player_goes_in_for_landing" );
	flag_init( "enable_endlog_fx" );
	flag_init( "escape_the_gulag" );
//	flag_set( "player_goes_in_for_landing" );
	flag_init( "gulag_perimeter" );
	flag_init( "pre_boats_attack" );
	flag_init( "clear_dof" );
	flag_init( "player_heli_backs_up" );
	flag_init( "stop_shooting_right_side" );
	flag_set( "player_can_rappel" );// didnt need

	flag_init( "gulag_shower_music_done" );

	PreCacheItem( "smoke_grenade_american" );
	PreCacheItem( "armory_grenade" );
	PreCacheItem( "m4m203_reflex_arctic" );
	PreCacheItem( "f15_sam" );
	PreCacheItem( "sam" );
	PreCacheItem( "slamraam_missile" );
	PreCacheItem( "slamraam_missile_guided" );
	PreCacheItem( "stinger" );
	PreCacheItem( "cobra_seeker" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "cobra_Sidewinder" );
	PreCacheItem( "m14_scoped" );
	PreCacheItem( "claymore" );
	PreCacheItem( "mp5_silencer_reflex" );
	PreCacheTurret( "heli_spotlight" );
	PreCacheTurret( "player_view_controller" );


	PreCacheItem( "fraggrenade" );
	PreCacheItem( "flash_grenade" );
	PreCacheItem( "claymore" );

	precachemodel( "viewhands_player_udt" );
	precachemodel( "viewhands_udt" );

	PreCacheModel( "com_emergencylightcase_blue" );
	PreCacheModel( "gulag_price_ak47" );
	PreCacheModel( "com_emergencylightcase_orange" );
	PreCacheModel( "com_emergencylightcase_blue_off" );
//	PreCacheModel( "rappelrope100_le_obj" );
	PreCacheModel( "com_drop_rope_obj" );
	PreCacheModel( "com_blackhawk_spotlight_on_mg_setup" );
	PreCacheModel( "com_blackhawk_spotlight_on_mg_setup_3x" );
	PreCacheModel( "vehicle_slamraam_launcher_no_spike" );
	PreCacheModel( "vehicle_slamraam_missiles" );
	PreCacheModel( "projectile_slamraam_missile" );
	PreCacheModel( "tag_turret" );
	PreCacheModel( "me_lightfluohang_double_destroyed" );
	PreCacheModel( "me_lightfluohang_single_destroyed" );
	PreCacheModel( "ma_flatscreen_tv_wallmount_broken_01" );
	PreCacheModel( "ma_flatscreen_tv_wallmount_broken_02" );
	PreCacheModel( "com_tv2_d" );
	PreCacheModel( "com_tv1" );
	PreCacheModel( "com_tv2" );
	PreCacheModel( "com_tv1_testpattern" );
	PreCacheModel( "com_tv2_testpattern" );
	PreCacheModel( "com_locker_double_destroyed" );
	PreCacheModel( "ch_street_wall_light_01_off" );
	PreCacheModel( "dt_mirror_dam" );	
	PreCacheModel( "dt_mirror_des" );	

	loadfx( "explosions/tv_flatscreen_explosion" );
	loadfx( "misc/light_fluorescent_single_blowout_runner" );
	loadfx( "misc/light_fluorescent_blowout_runner" );
	loadfx( "props/locker_double_des_01_left" );
	loadfx( "props/locker_double_des_02_right" );
	loadfx( "props/locker_double_des_03_both" );
	loadfx( "misc/no_effect" );
	loadfx( "misc/light_blowout_swinging_runner" );
	loadfx( "props/mirror_dt_panel_broken" );
	loadfx( "props/mirror_shatter" );
	precacheshellshock( "gulag_attack" );
	precacheshellshock( "nosound" );

	level.breakables_fx[ "tv_explode" ] = LoadFX( "explosions/tv_explosion" );

	thread so_handle_exterior_fx();
	thread handle_gulag_world_fx();

	level thread maps\gulag_amb::main();

	flag_set( "run_from_armory" );
	thread player_riotshield_threatbias();

	SetIgnoreMeGroup( "team3", "axis" );
	SetIgnoreMeGroup( "axis", "team3" );

	array_spawn_function_noteworthy( "overlook_spawner", ::overlook_spawner_think );
	//array_spawn_function_noteworthy( "hallway_runner_spawner", ::hallway_runner_spawner_think );
	array_spawn_function_targetname( "bhd_spawner", ::bhd_heli_think );
	array_spawn_function_noteworthy( "breach_death_spawner", ::die_on_ragdoll );
	array_spawn_function_noteworthy( "riot_shield_spawner", ::riot_shield_guy );
	array_spawn_function_noteworthy( "flee_armory_spawner", ::flee_armory_think );
	array_spawn_function_noteworthy( "tarp_spawner", ::tarp_spawner_think );
//	array_spawn_function_noteworthy( "doomed_just_doomed", ::doomed_just_doomed_think );
	array_spawn_function_noteworthy( "close_fighter_spawner", ::close_fighter_think );
	array_spawn_function_noteworthy( "bathroom_balcony_spawner", ::bathroom_balcony_spawner );
	array_spawn_function_noteworthy( "riot_escort_spawner", ::riot_escort_spawner );
	array_spawn_function_noteworthy( "catwalk_spawner", ::catwalk_spawner );
	

	challenge_onlys = GetEntArray( "challenge_only", "targetname" );
	array_thread( challenge_onlys, ::challenge_only_think );
	
	damage_targ_triggers = GetEntArray( "damage_targ_trigger", "targetname" );
	array_thread( damage_targ_triggers, ::damage_targ_trigger_think );

	add_wait( ::flag_wait, "player_moves_into_gulag" );
	add_func( ::flag_set, "gulag_cell_doors_enabled" );
	thread do_wait();

	thread landing_blocker_think();


	level.ending_flee_guys = 0;
	level.ending_flee_max = 0;
	level.slamraam_missile = "slamraam_missile_guided";

	// makes the friendlies go the right way
	ai_field_blocker = GetEnt( "ai_field_blocker", "targetname" );
	ai_field_blocker ConnectPaths();
	ai_field_blocker NotSolid();
}

fill_weapon_pickups()
{
	// Fill up all of the weapons in the level
	weapons = GetEntArray( "so_weapons", "targetname" );

	foreach ( weapon in weapons )
	{
		weapon_names = strtok( weapon.classname, "_" );

		weapon_name = weapon_names[ 1 ];
		for ( i = 2; i < weapon_names.size; i++ )
		{
			weapon_name = weapon_name + "_" + weapon_names[ i ];
		}

		if ( WeaponAltWeaponName( weapon_name ) != "none" )
		{
			weapon ItemWeaponSetAmmo( 999, 999, 999, 1 );
		}

		weapon ItemWeaponSetAmmo( 999, 999 );
	}
}

// ---------------------------------------------------------------------------------
//	SPECIAL OPS SPECIFIC
// ---------------------------------------------------------------------------------

start_so_showers_timed()
{
//	if ( !isdefined( anim.bcs_locations ) )
//		anim.bcs_locations = [];

	fill_weapon_pickups();
	level thread breach_hint_model();

	flag_set( "enable_interior_fx" );
//	flag_set( "disable_exterior_fx" );

	thread maps\_utility::set_ambient( "gulag_hall_int0" );

	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_showers_timed_setup_Regular();	break;	// Regular
		case 2:	so_showers_timed_setup_hardened();	break;	// Hardened
		case 3:	so_showers_timed_setup_veteran();	break;	// Veteran
	}
	
	// Prevent player from leaving the valid play space.
	thread enable_escape_warning();
	thread enable_escape_failure();
	
	breach_marker = GetEnt( "pipe_breach_org", "targetname" );
	Objective_Add( 1, "current", level.challenge_objective, breach_marker.origin );
	maps\_slowmo_breach::objective_breach( 1, 2 );
	thread so_showers_update_objective();
	
	volume = GetEnt( "gulag_shower_destructibles", "script_noteworthy" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();

	thread fade_challenge_in();
	thread fade_challenge_out( "player_exited_bathroom" );
	thread enable_challenge_timer( "player_enters_bathroom", "player_exited_bathroom" );
	thread enable_triggered_complete( "player_rappels_from_bathroom", "player_exited_bathroom" );
	thread gulag_shower_challenge_music();

	foreach ( player in level.players )
	{
		player SetActionSlot( 1, "" );
	}

	flag_wait( "player_enters_bathroom" );

	thread maps\_ambient::activateAmbient( "gulag_shower_int0" );

	level.player.attackeraccuracy = 0;
	level.player delayThread( 6, maps\_gameskill::update_player_attacker_accuracy );

	activate_trigger_with_targetname( "bathroom_initial_enemies" );
	
	delayThread( 10, ::activate_trigger_with_targetname, "bathroom_balcony_room1_trigger" );

	flag_wait( "bathroom_start_second_wave" );

	delaythread( 1, ::activate_trigger_with_targetname, "bathroom_balcony_room2_trigger" );
	activate_trigger_with_targetname( "bathroom_second_wave_trigger" );
}

breach_hint_model()
{
	model = getent( "breach_hint_model", "targetname" );
	level waittill( "breaching" );
	model delete();
}

so_showers_update_objective()
{
	level waittill( "player_enters_bathroom" );

	objective_marker = getent( "player_rappels_from_bathroom", "script_noteworthy" );
	objective_position( 1, objective_marker.origin );
	Objective_SetPointerTextOverride( 1, "" );
}

// This does not appear to be call from anywhere
so_showers_timed_setup_get_spawners( randomize )
{
	if ( !isdefined( randomize ) )
		randomize = true;
		
	// Access all the enemy spawners used in the bathroom
	level.bathroom_initial			= getentarray( "bathroom_initial_spawner", "script_noteworthy" );
	level.bathroom_balcony			= getentarray( "bathroom_balcony_spawner", "script_noteworthy" );
	level.bathroom_reinforcements	= getentarray( "bathroom_reinforcements_spawner", "script_noteworthy" );
	level.riot_shield				= getentarray( "riot_shield_spawner", "script_noteworthy" );
	level.riot_escort				= getentarray( "riot_escort_spawner", "script_noteworthy" );

	if ( randomize )
	{
		array_randomize( level.bathroom_initial );
		array_randomize( level.bathroom_balcony );
		array_randomize( level.bathroom_reinforcements );
		array_randomize( level.riot_shield );
		array_randomize( level.riot_escort );
	}
	
	// Purge the riot_shield guys not actually used in the bathroom.
	for ( i = 0; i < level.riot_shield.size; i++ )
	{
		if ( level.riot_shield[i].classname ==  "actor_enemy_arctic_SMG" )
			level.riot_shield[i] = undefined;
	}
	array_removeUndefined( level.riot_shield );
}

so_showers_timed_setup_regular()
{
	level.challenge_objective = &"SO_SHOWERS_GULAG_OBJ_REGULAR";
}

so_showers_timed_setup_hardened()
{
	level.challenge_objective = &"SO_SHOWERS_GULAG_OBJ_HARDENED";
}

so_showers_timed_setup_veteran()
{
	level.challenge_time_limit = 180; 
	level.challenge_objective = &"SO_SHOWERS_GULAG_OBJ_VETERAN";
}

gulag_shower_challenge_music()
{
	level waittill( "slowmo_breach_ending" );
	wait( 2 );
	music_loop( "so_showers_gulag_music", 150 );
}

challenge_only_think()
{
	if ( level.start_point == "so_showers" )
	{
		if ( self.classname == "script_model" )
		{
			self setcandamage( true );
		}
		return;
	}
	
	if ( self.classname == "script_brushmodel" )
		self connectpaths();
	
	self delete();
}

// ---------------------------------------------------------------------------------
//	NEED TO PURGE AND CLEAN EVERYTHING BELOW
// ---------------------------------------------------------------------------------

// sets McCord up with stuff he needs to test the map
gulag_no_game_start_setupFunc()
{
	maps\_loadout::init_loadout();

	level.spawn_funcs = [];
	level.spawn_funcs[ "allies" ] = [];
	level.spawn_funcs[ "axis" ] = [];
	level.spawn_funcs[ "neutral" ] = [];

	maps\_nightvision::main( level.players );
	level.player SetActionSlot( 1, "nightvision" );
}

enable_bathroom_complete_trigger()
{
	trigger_ent = getent( "player_rappels_from_bathroom", "script_noteworthy" );
	trigger_ent waittill( "trigger" );
	flag_set( "player_exited_bathroom" );
}

so_handle_exterior_fx()
{
	volume = getent( "gulag_exterior_fx_vol", "targetname" );

	dummy = Spawn( "script_origin", ( 0, 0, 0 ) );

	fx_array = [];
	foreach ( entFx in level.createfxent )
	{
		dummy.origin = EntFx.v[ "origin" ];

		if ( dummy IsTouching( volume ) )
		{
			fx_array[ fx_array.size ] = EntFx;
		}
    }

	flag_wait( "enable_interior_fx" );

	count = 0;
	foreach ( fx in fx_array )
	{
		fx pauseEffect();
		count++;
		if ( count > 5 )
		{
			count = 0;
			wait( 0.05 );
		}
	}
}