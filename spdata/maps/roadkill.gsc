#include maps\roadkill_code;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;


main()
{
	setdvar( "newintro", 1 );
	SetSavedDvar( "physVeh_collideWithClipOnly", 1 );
	level.toffset = 0;
	level.nocompass = true;

	PreCacheItem( "m14_scoped" );
	PreCacheItem( "littlebird_FFAR" );

	maps\_drone_ai::init();
	maps\createart\roadkill_art::main();
	maps\createfx\roadkill_audio::main();
	maps\roadkill_anim::main();
	maps\roadkill_precache::main();
	maps\roadkill_fx::main();
	maps\createart\roadkill_fog::main();

	setup_player_killer_orgs();

	set_default_start( "riverbank" );
	add_start( "riverbank", ::start_riverbank, "riverbank", ::roadkill_riverbank );
//	add_start( "move_out", ::start_move_out, "riverbank", ::roadkill_riverbank );
	add_start( "convoy", ::start_convoy, "convoy", ::roadkill_convoy );
	add_start( "ride", ::start_ride, "ride", ::roadkill_ride );
	add_start( "ambush", ::start_crazy_ride, "ambush", ::roadkill_crazy_ride );
	add_start( "ride_later", ::start_crazy_ride_later, "ride_later", ::roadkill_crazy_ride_later );
//	add_start( "ride_end", ::start_ride_end, "ride_end", ::roadkill_ride_end );
	add_start( "dismount", ::start_dismount, "dismount", ::roadkill_convoy_dismounts );
	add_start( "school", ::start_roadkill_school_fight, "school", ::roadkill_school_fight );
	add_start( "endfight", ::start_roadkill_endfight, "end", ::roadkill_the_end );
	add_start( "end", ::start_roadkill_end, "end", ::roadkill_the_end );

	PreCacheTurret( "humvee_50cal_mg" );
	PreCacheTurret( "rpd_bipod_prone" );
	PreCacheTurret( "rpd_bipod_crouch" );
	PreCacheModel( "weapon_m16" );
	PreCacheModel( "weapon_rpd_mg_setup" );
	PreCacheModel( "com_soup_can" );
	PreCacheModel( "com_bottle1" );
	PreCacheModel( "me_plastic_crate1" );
	PreCacheModel( "mil_mre_chocolate01" );
	PreCacheModel( "weapon_binocular" );
	PreCacheModel( "vehicle_hummer_seat_rb_obj" );
	PreCacheModel( "ch_viewhands_gk_ump45" );
	PreCacheModel( "ch_viewhands_player_gk_ump45" );
	PreCacheModel( "weapon_suburban_minigun_viewmodel" );
	PreCacheRumble( "collapsing_building" );
	PreCacheModel( "me_woodcrateclosed" );
	PreCacheModel( "com_cardboardboxshortclosed_2" );
	PreCacheModel( "com_hand_radio" );
	PreCacheItem( "scripted_silent" );
	
	precachestring( &"ROADKILL_BRIDGELAYER_DESTROYED" );
	precachestring( &"ROADKILL_HOLD_TO_BOARD" );
	precachestring( &"ROADKILL_SHOT_TOO_MUCH" );
	precachestring( &"ROADKILL_OBJECTIVE_BRIDGELAYER" );
	precachestring( &"ROADKILL_OBJECTIVE_HUMVEE" );
	precachestring( &"ROADKILL_OBJECTIVE_AIRSTRIKE" );
	precachestring( &"ROADKILL_OBJECTIVE_SCAN" );
	precachestring( &"ROADKILL_OBJECTIVE_TARGETS" );
	precachestring( &"ROADKILL_OBJECTIVE_DISMOUNT" );
	precachestring( &"ROADKILL_OBJECTIVE_SCHOOL" );
	precachestring( &"ROADKILL_OBJECTIVE_REPORT" );
	precachestring( &"ROADKILL_GOT_SNIPED" );
	precachestring( &"ROADKILL_SHOT_UNARMED" );
	precachestring( &"SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN" );
	precachestring( &"SCRIPT_LEARN_JAVELIN" );
	precachestring( &"SCRIPT_PLATFORM_HINT_FLASH" );
	precachestring( &"SCRIPT_LEARN_GRENADE_LAUNCHER" );
	precachestring( &"SCRIPT_WAYPOINT_TARGETS" );
	
	


	level.roadkill_feedline_delay = ::introlines_delay;
	//thread rpg_flies_by_view();


	level.crazy_ride_convoy = [];
	level.crazy_ride_convoy[ "detour" ] = SpawnStruct();// for start points
	level.crazy_ride_convoy[ "max" ] = 4;
	level.convoy_dialogue_guy = [];
	level.school_baddies = [];

	trapper_clip = GetEnt( "trapper_clip", "targetname" );
	trapper_clip ConnectPaths();
	trapper_clip Delete();

	// Press ^3[{weapnext}]^7 to switch to the Javelin
	PreCacheString( &"SCRIPT_LEARN_JAVELIN" );
	maps\_empty::main( "tag_origin" );

	maps\_load::main();
	maps\_javelin::init();
	
	// civ failure
	add_global_spawn_function( "neutral", ::fail_for_civ_kill );

	flag_init( "riverbank_baddies_retreat" );
	flag_init( "binoc_explosion" );
	flag_init( "player_gets_in" );
	flag_init( "player_humvee_stops" );
	flag_init( "shepherd_moves_out" );
	flag_init( "shepherd_vehicles_leave" );
	flag_init( "ambush_auto_adjust_speed" );
	flag_init( "player_knocked_down" );
	flag_init( "resume_the_path" );
	flag_init( "bridgelayer_crosses" );
	flag_init( "time_to_go" );
	flag_init( "get_on_the_line" );
	flag_init( "guys_get_in_convoy_vehicles" );
	flag_init( "convoy_moment" );
	flag_init( "lets_go_trigger" );
	flag_init( "room_was_flashed" );
	flag_init( "we're cut off" );
	flag_init( "retreaters_run" );
	flag_init( "final_objective" );
	flag_init( "friendlies_run_to_school" );
	flag_init( "leaving_riverbank" );
	flag_init( "player_attacked_bridge_enemy" );
	flag_init( "player_switched_to_javelin" );
	flag_init( "missile_fire_1" );
	flag_init( "missile_fire_2" );
	flag_init( "missile_fire_3" );
	flag_init( "push_through" );
	flag_init( "100ton_bomb_goes_off" );
	flag_init( "bridge_baddies_retreat" );
	flag_init( "player_is_dismounted" );
	flag_init( "hidden_guy_opens_fire" );
	flag_init( "bridgelayer_starts" );
	flag_init( "roadkill_school_10" );
	flag_init( "roadkill_school_11" );
	flag_init( "pull_garage" );
	flag_init( "rpg_end" );
	flag_init( "friendlies_suppress_school" );
	flag_init( "intro_lines_complete" );
	flag_init( "fight_back" );
	flag_init( "trapper_spawners_ignoreme" );
	flag_init( "riverbank_scene_starts" );
	flag_init( "player_closes_gap" );
	flag_init( "bridgelayer_complete" );
	flag_init( "convoy_oscar_mike_after_explosion" );
	flag_init( "bridge_layer_attacked_by_bridge_baddies" );
	flag_init( "shot_rings_out" );
	flag_init( "humvees_spin_up" );
	flag_init( "video_tapers_react" );
	flag_init( "playground_baddies_retreat" );
	flag_init( "sweep_dismount_building" );

	maps\_potted_plant::potted_plant_init();

	// Press ^3[{weapnext}]^7 to switch to the Javelin
	add_hint_string( "learn_javelin", &"SCRIPT_LEARN_JAVELIN", ::player_learned_javelin );
	// Press ^3[{+smoke}]^7 to throw a flash bang.
	add_hint_string( "learn_flash", &"SCRIPT_PLATFORM_HINT_FLASH", ::player_learned_flash );

	add_hint_string( "learn_m203", &"SCRIPT_LEARN_GRENADE_LAUNCHER", ::player_learned_m203 );
	

	add_global_spawn_function( "allies", ::get_in_moving_vehicle );
	add_global_spawn_function( "axis", ::balcony_check );

	run_thread_on_noteworthy( "fire_missile", maps\_attack_heli::boneyard_style_heli_missile_attack_linked );
	run_thread_on_noteworthy( "plane_sound", maps\_f15::plane_sound_node );
	run_thread_on_targetname( "helper_model", ::self_delete );
	run_thread_on_targetname( "barbwire_ride_cutoff", ::hide_helper_model );
	run_thread_on_targetname( "vehicle_break", ::vehicle_break );
	run_thread_on_targetname( "ent_flag_set_trigger", ::ent_flag_set_trigger );
	run_thread_on_targetname( "trigger_delete_axis_not_in_volume", ::trigger_delete_axis_not_in_volume );

	level.crash_friendly = [];
	level.spark_presets = [];
	run_thread_on_targetname( "spark_preset", ::spark_preset );
	run_thread_on_targetname( "vehicle_spark_trigger", ::vehicle_spark_trigger );

	maps\_compass::setupMiniMap( "compass_map_roadkill" );

	run_thread_on_targetname( "deleteme", ::self_delete );
	run_thread_on_targetname( "damage_targ_trigger", ::damage_targ_trigger_think );
	run_thread_on_targetname( "wave_right_trigger", ::wave_right_trigger );

//	array_spawn_function_noteworthy( "player_humvee", ::player_humvee );
//	array_spawn_function_noteworthy( "rear_vehicle", ::rear_vehicle );
//	array_spawn_function_noteworthy( "front_vehicle", ::front_vehicle );
//	array_spawn_function_noteworthy( "near_vehicle", ::near_vehicle );

//	array_spawn_function_targetname( "intro_convoy", ::intro_convoy );
	//xx
	array_spawn_function_targetname( "riverbank_tank", ::riverbank_tank );
	array_spawn_function_noteworthy( "retreat_spawner", ::retreat_spawner );
	level.forced_bcs_callouts = 0;
	array_spawn_function_noteworthy( "extra_retreat_spawner", ::extra_retreat_spawner );

	array_spawn_function_noteworthy( "convoy_gunner", ::convoy_gunner_think );
	array_spawn_function_noteworthy( "dismount_macey", ::dismount_foley );
	array_spawn_function_noteworthy( "dismount_dunn", ::dismount_dunn );
	//array_spawn_function_noteworthy( "ignore_and_delete", ::ignore_and_delete );

	array_spawn_function_noteworthy( "school_unreachable_spawner", ::school_unreachable_spawner );

	//thread street_walk_scene();
	thread wobbly_fans();

	//array_spawn_function_noteworthy( "hargrove", ::hargrove_spawner );
	array_spawn_function_targetname( "foley_spawner", ::foley_spawner );
	array_spawn_function_noteworthy( "dunn_spawner", ::dunn_spawner );
	array_spawn_function_noteworthy( "shepherd_spawner", ::shepherd_spawner );

	level.ambushed_hummers = [];
	array_spawn_function_targetname( "ambushed_hummer", ::ambushed_hummer );


	//array_spawn_function_noteworthy( "near_turret_guy", ::turret_guy_in_near_humvee );
	//array_spawn_function_noteworthy( "intro_rundown_friendly_spawner", ::intro_rundown_friendly_spawner );

	level.more_street_spawners = GetEntArray( "more_street_spawner", "script_noteworthy" );
	level.school_ambush_spawners = GetEntArray( "school_ambush", "targetname" );
	array_spawn_function( level.school_ambush_spawners, ::school_spawner_think );


	level.color_doesnt_care_about_classname = true;
	level.color_doesnt_care_about_heroes = true;
	level.dialogue_function_stack_struct = SpawnStruct();
	level.arab_function_stack_struct = spawnstruct();
	level.special_weapon_dof_funcs[ "javelin" ] = maps\_art::javelin_dof;



	blockers = GetEntArray( "player_backtrack_blocker_model", "targetname" );
	foreach ( blocker in blockers )
	{
		blocker Hide();
	}

	blockers = GetEntArray( "player_backtrack_blocker_brush", "targetname" );
	foreach ( blocker in blockers )
	{
		blocker Hide();
		blocker NotSolid();
	}

	models = GetEntArray( "dead_vehicle_spawner", "targetname" );
	foreach ( model in models )
	{
		model.oldcontents = model SetContents( 0 );
		model Hide();
	}

	thread ps3_hide();

	thread maps\roadkill_amb::main();
	maps\_utility::set_vision_set( "roadkill", 0 );

	thread roadkill_startpoint_catchup_thread();

	CreateThreatBiasGroup( "axis_school" );
	CreateThreatBiasGroup( "axis_school_unreachable" );
	CreateThreatBiasGroup( "axis_ambush_house" );
	CreateThreatBiasGroup( "axis_dismount_attackers" );
	CreateThreatBiasGroup( "ally_with_player" );
	CreateThreatBiasGroup( "ally_outside_school" );
	CreateThreatBiasGroup( "bridge_attackers" );
	CreateThreatBiasGroup( "just_player" );
	
	// player uses just_player until dismount
	level.player SetThreatBiasGroup( "just_player" );

	
	SetIgnoreMeGroup( "ally_with_player", "axis_school_unreachable" );
	SetIgnoreMeGroup( "axis_school_unreachable", "ally_with_player" );

	SetIgnoreMeGroup( "ally_with_player", "axis_school" );
	SetIgnoreMeGroup( "axis_school", "ally_with_player" );
	SetThreatBias( "ally_outside_school", "axis_ambush_house", 750 );

	thread roadkill_objective_thread();
	thread roadkill_music();

	waittillframeend;// needs to happen after init
	level.player.bcNameID = undefined;// player isn't roach

	thread lights();
}

start_empty()
{
}

roadkill_intro_common()
{
	thread blend_sm_sunsamplesizenear();


	thread intro_runner_path_breaker();
	//thread intro_shepherd();
	bridge_layer_clipbrush = GetEnt( "bridge_layer_clipbrush", "targetname" );
	bridge_layer_clipbrush DisconnectPaths();

	destroyed_humvee_models = GetEntArray( "destroyed_humvee_model", "targetname" );
	array_thread( destroyed_humvee_models, ::hide_notsolid );

	array_spawn_function_noteworthy( "enemy_riverbank_rpg_spawner", ::enemy_riverbank_rpg_spawner );

	// no spawn funcs on drones so rewrite this for our drone
	//array_spawn_function_noteworthy( "humvee_rider_spawner", ::humvee_rider_spawner );
	thread humvee_rider_spawner();

	//array_spawn_function_targetname( "idle_commander", ::idle_commander );
	array_spawn_function_targetname( "foley_spawner", ::idle_commander );

	array_spawn_function_noteworthy( "stryker", ::stryker_think );
	array_spawn_function_noteworthy( "network_chatter_spawner1", ::put_noteworthy_in_magic_chatter );
	array_spawn_function_noteworthy( "network_chatter_spawner2", ::put_noteworthy_in_magic_chatter );


	add_global_spawn_function( "allies", ::ai_invulnerable );

	array_spawn_targetname( "foley_spawner" );

	if ( is_default_start() )
	{
		array_spawn_noteworthy( "shepherd_spawner" );
		thread roadkill_foley_shepherd_intro();
	}


	disable_all_vehicle_mgs();

	level.allied_riverbank_ai = [];
	array_spawn_function_targetname( "riverbank_spawner", ::allied_riverbank_spawner );

	//xx
	thread roadkill_bridge_layer();
	thread binoc_scene();

	// these guys spawn once the bridge is halfway done, then try to shoot it
	array_spawn_function_targetname( "enemy_bridge_spawner", ::enemy_bridge_spawner );

	if ( is_default_start() )
	{
		thread radio_scene();
		run_thread_on_targetname( "cover_scene_rock", ::cover_scene );
		run_thread_on_targetname( "candy_man", ::candy_bar_scene );
		run_thread_on_targetname( "riverbank_mg", ::riverbank_mg );
	}

//	run_thread_on_targetname( "cover_scene", ::cover_scene );

	array_spawn_function_targetname( "enemy_riverbank_spawner", ::riverbank_guy_dies_on_retreat );
	array_spawn_targetname( "enemy_riverbank_spawner" );

	//spawn_vehicle_from_targetname( "riverbank_stryker" );

	array_spawn_function_noteworthy( "player_personal_convoy", ::player_personal_convoy );

	add_global_spawn_function( "allies", ::set_dontshootwhilemoving, true );

	//xx
	spawn_vehicles_from_targetname( "riverbank_tank" );

	run_thread_on_targetname( "mortar_org", ::roadkill_mortars );
	array_spawn_targetname( "riverbank_spawner" );

	level.stair_block_guys = [];
	array_spawn_function_targetname( "stair_block_guy", ::stair_block_guy );
	if ( is_default_start() )
		array_spawn_targetname( "stair_block_guy" );

	// wall on the front of a building breaks off during exploder
	run_thread_on_targetname( "broken_wall", ::broken_wall );
}

start_riverbank()
{
	SetSavedDvar( "g_friendlyNameDist", 0 );
	noself_delayCall( 3, ::setsaveddvar, "g_friendlyNameDist", 15000 );
	roadkill_intro_common();
	//xx
	
	if ( getdvarint( "newintro" ) )
	{
		level.player ShellShock( "default", 5.8 );
		//struct = getstruct( "player_intro_struct", "targetname" );
		//level.player SetOrigin( struct.origin );
		//level.player SetPlayerAngles( struct.angles );
		//level.player setstance( "prone" );
	//	level.player freezecontrols( true );
		level.player disableweapons();

		black_overlay = create_client_overlay( "black", 0, level.player );
		black_overlay.alpha = 1;
		wait( 1 );
		black_overlay FadeOverTime( 2 );
		black_overlay.alpha = 0;		
		level waittill ( "get_on_the_line" );
//		level.player freezecontrols( false );
		level.player enableweapons();
		//level.player setstance( "stand" );
	}	
}

start_move_out()
{
	thread roadkill_intro_common();
	//xx

	/*
	level.player SwitchToWeapon( "javelin" );
	
	level endon( "bmps_destroyed" );
	count = 0;
	for ( ;; )
	{
		bmps = GetEntArray( "script_vehicle_bmp_woodland", "classname" );
		foreach ( bmp in bmps )
		{
			if ( IsAlive( bmp ) )
			{
				bmp Vehicle_SetSpeed( 80, 80, 80 );
				if ( IsDefined( bmp.javelin_targettable ) )
				{
					bmp godoff();
					RadiusDamage( bmp.origin, 150, bmp.health + 500, bmp.health + 500 );
					count++;
					flag_set( "missile_fire_" + count );
				}
			}
		}
		wait( 1 );
	}
	*/
}

roadkill_riverbank()
{
	enemy_riverhouse_spawners = GetEntArray( "enemy_riverhouse_spawner", "targetname" );
	enemy_riverside_spawners = GetEntArray( "enemy_riverside_spawner", "targetname" );

	array_spawn_function( enemy_riverhouse_spawners, ::riverbank_spawner_retreat_think );
	array_spawn_function( enemy_riverside_spawners, ::riverbank_spawner_retreat_think );

	thread riverside_house_manager( enemy_riverhouse_spawners );
	thread riverside_flood_manager( enemy_riverside_spawners );
	//array_thread( enemy_riverhouse_spawners, ::riverside_flood_think, 10, 15 );

	
	delayThread( 5, ::spawn_vehicles_from_targetname_and_drive, "littlebird_attacks" );
	delayThread( 10, ::spawn_vehicles_from_targetname_and_drive, "littlebird_attacks_2" );
}

start_convoy()
{
	roadkill_intro_common();

	start_ride_player = getstruct( "start_ride_player", "targetname" );
	level.player SetOrigin( start_ride_player.origin );
	level.player SetPlayerAngles( start_ride_player.angles );
}

roadkill_convoy()
{
//	add_wait( ::flag_wait, "missile_fire_3" );
//	add_func( ::axis_flee_riverbank );
//	thread do_wait();

	blocker = GetEnt( "friendly_video_blocker", "targetname" );
	blocker Solid();
	blocker ConnectPaths();
	blocker NotSolid();


	level.runnings_to_convoy_count = 0;
//	level.player.attackeraccuracy = 0;
//	level.player.IgnoreRandomBulletDamage = true;

//	run_thread_on_targetname( "intro_orders", ::intro_orders );
	thread player_fights_bmps();

	array_spawn_function_targetname( "riverbank_bmp", ::riverbank_tank );
	thread riverbank_bmp();

	thread detect_if_player_tries_to_cross_bridge();
	//array_spawn_function_targetname( "ride_vehicle_starts_spawned", ::ride_vehicle_starts_moving );
	//spawn_vehicles_from_targetname( "ride_vehicle_starts_spawned" );



	array_spawn_function_targetname( "lead_vehicle_spawner", ::common_ride_vehicle_init );
	array_spawn_function_targetname( "ride_vehicle_starts_spawned", ::common_ride_vehicle_init );
	//xx
	spawn_vehicles_from_targetname_and_drive( "ride_vehicle_starts_spawned" );

	level.npc_ride_vehicles = [];
	level.guy_gets_in_vehicle_targets = [];
	guy_gets_in_vehicle = GetEnt( "guy_gets_in_vehicle", "targetname" );
	guy_gets_in_vehicle thread trigger_guy_gets_in_vehicle();

	//xx
//	wait( 1 );



	//pre_bridge_vehicle_brush = GetEnt( "pre_bridge_vehicle_brush", "targetname" );
	//pre_bridge_vehicle_brush ConnectPaths(); 
	//pre_bridge_vehicle_brush Delete();       

	stairs_blocker = GetEnt( "stairs_blocker", "targetname" );
	stairs_blocker ConnectPaths();
	stairs_blocker Delete();


	//post_bridge_vehicle_brush = GetEnt( "post_bridge_vehicle_brush", "targetname" );
	//post_bridge_vehicle_brush ConnectPaths();
	//post_bridge_vehicle_brush NotSolid();

	friendly_midroad_blocker = GetEnt( "friendly_midroad_blocker", "targetname" );
	friendly_midroad_blocker ConnectPaths();
	friendly_midroad_blocker Delete();

	blockers = GetEntArray( "player_backtrack_blocker_model", "targetname" );
	foreach ( blocker in blockers )
	{
		blocker Show();
	}

	blockers = GetEntArray( "player_backtrack_blocker_brush", "targetname" );
	foreach ( blocker in blockers )
	{
		blocker Show();
		blocker Solid();
	}

	array_spawn_function_noteworthy( "friendly_open_humvee", ::friendly_open_humvee );
	array_spawn_function_targetname( "player_ride_vehicle", ::player_ride_vehicle );
	array_spawn_function_targetname( "ride_vehicle_starts_moving", ::ride_vehicle_starts_moving );

	// xx
	if ( !is_default_start() )
		wait( 0.1 );
	spawn_vehicle_from_targetname( "player_ride_vehicle" );
	spawn_vehicles_from_targetname( "ride_vehicle_starts_moving" );
//	wait( 0.05 ); // for the start points

	thread riverbank_player_learns_m203();

	flag_wait_or_timeout( "player_enters_riverbank", 10 );

	flag_set( "riverbank_scene_starts" );

	if ( is_default_start() )
	{
		add_func( ::enter_riverbank_foley_shepherd_dialogue );
		add_func( ::airstrike_call_in_dialogue );
		thread do_funcs();
	}

	flag_wait( "bridge_baddies_retreat" );
	autosave_by_name( "bridge_baddies_retreat" );

	flag_wait( "bridgelayer_crosses" );


	bridge_layer_clipbrush = GetEnt( "bridge_layer_clipbrush", "targetname" );
	bridge_layer_clipbrush ConnectPaths();
	bridge_layer_clipbrush Delete();


	add_wait( ::flag_wait, "leaving_riverbank" );
	add_func( ::flag_set, "time_to_go" );
	add_func( ::allies_leave_riverbank );
	add_func( ::convoy_moves_out_dialogue );
	add_func( ::autosave_by_name, "leaving_riverbank" );
	do_wait();
	
	stair_wave_spawner = getent( "stair_wave_spawner", "targetname" );
	stair_wave_spawner add_spawn_function( ::stair_wave_spawner );
	stair_wave_spawner stalingradspawn();

	spawner = GetEnt( "player_humvee_passenger_spawner", "targetname" );
	spawner add_spawn_function( ::guy_gets_in_player_humvee );
	spawner spawn_ai();

	battlechatter_off( "allies" );


//	array_spawn_function_targetname( "airstrike_blocker_spawner", ::airstrike_spawner );
//	array_spawn_targetname( "airstrike_blocker_spawner" );

//	array_spawn_function_targetname( "airstrike_spawner", ::airstrike_spawner );
//	airstrike_spawners = GetEntArray( "airstrike_spawner", "targetname" );
//	array_thread( airstrike_spawners, ::spawn_ai );


	flag_wait( "player_climbs_stairs" );

	battlechatter_off( "axis" );

	array_spawn_function_targetname( "escape_block_spawner", ::escape_block_spawner );
	array_spawn_targetname( "escape_block_spawner" );


	flag_set( "convoy_moment" );

	//run_thread_on_targetname( "cover_scene", ::cover_scene );
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		time = RandomFloat( 2 );
		guy delayCall( time, ::Kill );
	}

	delayThread( 4.5, ::flag_set, "guys_get_in_convoy_vehicles" );

	thread player_get_in_reminder();
	flag_wait( "player_gets_in" );
	thread baddies_on_building_get_your_attention();

	delayThread( 0, ::spawn_vehicles_from_targetname_and_drive, "apache_show_building_spawner" );


	SetSavedDvar( "sm_sunSampleSizeNear", "0.6" );// a little more shadow for the start

	ClearAllCorpses();
	autosave_by_name( "player_gets_in" );


	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();
		guy.ignoreall = false;
	}

//	level.player.attackeraccuracy = 1;
//	level.player.IgnoreRandomBulletDamage = false;

	array_spawn_function_targetname( "extra_bmp", ::extra_bmp_blows_up );
	spawn_vehicles_from_targetname_and_drive( "extra_bmp" );

	thread airstrike_completion_dialogue_and_exploder();


	wait( 3.5 );

	blocker = GetEnt( "friendly_video_blocker", "targetname" );
	blocker Solid();
	blocker DisconnectPaths();



	jeep_rider_spawners = GetEntArray( "jeep_rider_spawner", "targetname" );
	array_spawn_function( jeep_rider_spawners, ::jeep_rider_spawner_think );
	array_thread( jeep_rider_spawners, ::spawn_ai );

	run_thread_on_targetname( "film_org", ::guys_film_explosion );


//	post_bridge_vehicle_brush Solid();
//	post_bridge_vehicle_brush DisconnectPaths();

//	wait( 0.5 );
//	player_got_in_spawners = GetEntArray( "player_got_in_spawner", "targetname" );
//	array_spawn_function( player_got_in_spawners , ::magic_bullet_shield );
//	array_thread( player_got_in_spawners, ::spawn_ai );

	thread street_walk_scene();

//	wait( 7 );

	//flag_set( "time_to_pull_out" );
	flag_wait( "convoy_oscar_mike_after_explosion" );

//	wait( 4 );
	delayThread( 2.2, ::flag_set, "lead_vehicle_rolls_out" );
	waits = [];
	waits[ 1 ] = 0.7;
	waits[ 2 ] = 0.6;
	waits[ 3 ] = 0.1;
	waits[ 4 ] = 3.2;
	waits[ 5 ] = 0.4;
	waits[ 6 ] = 0;

	//delaythread( 1.4, ::exploder, "town_bombed" );

	for ( i = 1; i <= 6; i++ )
	{
		// convoy_crosses_bridge1
		if ( flag_exist( "convoy_crosses_bridge" + i ) )
			flag_set( "convoy_crosses_bridge" + i );
		wait( waits[ i ] );
	}

	start_ride_common( false );
}

start_ride()
{
	setup_ride_path_targets( "start_vehicle_ride" );
	start_ride_common( true );
}

start_ride_common( from_start_point )
{
	add_global_spawn_function( "axis", ::set_ignoreSuppression, true );

	set_custom_gameskill_func( ::roadkill_gameskill_ride_settings );
	
	//setsaveddvar( "player_radiusdamagemultiplier", "0.1" );

	handle_start_points_for_detour_humvee();
	destroyed_humvee_models = GetEntArray( "destroyed_humvee_model", "targetname" );
	array_thread( destroyed_humvee_models, ::hide_notsolid );

	level.createRpgRepulsors = false;
	level.player EnableDeathShield( true );


	thread player_doesnt_die_in_red_flashing();
	level.player DisableWeapons();
	level.player ent_flag_clear( "near_death_vision_enabled" );

	level.player_repulsor = Missile_CreateRepulsorEnt( level.player, 2000, 500 );

	level.convoy_gunners = [];

	// ai
	array_spawn_function_noteworthy( "run_away_die", ::run_away_die );

	// vehicles
//	array_spawn_function_noteworthy( "lead_vehicle", ::lead_vehicle_func );
	array_spawn_function_noteworthy( "start_player_crazy_ride", ::player_turret_humvee );
	array_spawn_function_targetname( "ride_vehicle_spawner", ::player_personal_convoy );
	array_spawn_function_noteworthy( "traffic_jam_truck", ::traffic_jam_truck );

	array_spawn_function_noteworthy( "ignore_until_attack", ::ignore_until_attack );


	array_spawn_function_noteworthy( "trapper_spawner", ::trapper_spawner );
	array_spawn_function_noteworthy( "rpg_ambush_spawner", ::rpg_ambush_spawner );


	thread trapper_killer_trigger();


	//array_spawn_function_noteworthy( "ambusher_spawner", ::ambusher_spawner );
	// driver that tries to block
	array_spawn_function_noteworthy( "blocker_driver", ::blocker_driver );

	// guy that ends the ride
	array_spawn_function_noteworthy( "ride_killer", ::ride_killer );

	if ( from_start_point )
		spawn_vehicles_from_targetname_and_drive( "ride_vehicle_spawner" );

	add_global_spawn_function( "axis", ::no_grenades );


	//ambushed_hummers = GetEntArray( "ambushed_hummer", "targetname" );
	//array_thread( ambushed_hummers, ::hide_notsolid );


	// spread the vehicles out a bit on the ride
	thread ride_adjust_convoy_speed_trigger();

	thread ride_scenes();

}

roadkill_ride()
{
	ai = GetAIArray();
	foreach ( guy in ai )
	{
		if ( IsAlive( level.detour_gunner ) && guy == level.detour_gunner )
			continue;

		if ( IsDefined( guy.magic_bullet_shield ) )
		{
			guy stop_magic_bullet_shield();
		}
	}


	flag_wait( "roadkill_town_dialogue" );
	thread maps\_introscreen::ramp_out_sunsample_over_time( 2 );

	autosave_by_name( "roadkill_town_dialogue" );

	thread player_vehicle_catches_up();
	waittillframeend;// wait for the ride vehicles to get defined


	if ( level.start_point != "ride" )
	{
		start_time = gettime();

		wait( 0.6 ); // 2.5
		
		// Hunter two breaking away.	
		thread radio_dialogue_generic( "roadkill_fly_breakingaway" );
		wait( 2.1 ); // 2.5

		// Copy Hunter Two.	
		thread radio_dialogue_generic( "roadkill_hqr_copyhunter2" );


		wait_for_buffer_time_to_pass( start_time, 6.5 );

		// All Hunter Two victors, keep an eye out for civvies, we�re not cleared to engage unless they fire first.	
		thread radio_dialogue_generic( "roadkill_fly_eyeoutforciv" );
		wait( 6.5 );

		// Scan the rooftops for hostiles. Stay frosty.	
		thread radio_dialogue_generic( "roadkill_fly_scanrooftops" );
		wait( 4.8 );
		wait_for_buffer_time_to_pass( start_time, 17.8 );
	}

	// You see anything?	
	thread driver_line( "roadkill_cpd_seeanything" );
	wait( 2.2 );

	// I got nothin'. This place is dead.	
	thread dunn_line( "roadkill_cpd_placeisdead" );
	wait( 2.3 );

	// Huah.	
	thread driver_line( "roadkill_ar3_huah" );
	wait( 2.5 );

	// Overlord, Hunter Two-One. We're passing tunnel Harvey, cross street Elizabeth.	
	thread radio_dialogue_generic( "roadkill_fly_crossstreeteliz" );
	wait( 4.5 );

	// Roger that, Hunter Two-One, proceed with caution.	
	thread radio_dialogue_generic( "roadkill_hqr_caution" );
	wait( 4.0 );

	flag_wait( "civie_dialogue" );
	wait( 2.9 );

	// Stay frosty guys, this is the Wild West.	
	thread dunn_line( "roadkill_cpd_wildwest" );
	wait( 2.6 );

	// Roger that.	
	thread driver_line( "roadkill_ar3_rogerthat" );






	flag_wait( "start_runner" );

	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.ridingVehicle ) )
			continue;
		guy safe_delete();
	}

	thread gaz_balcony_guys();

	// Watch the alleys.	
	delayThread( 6.0, ::radio_dialogue_generic, "roadkill_fly_watchalleys" );
	// Covering.	
	delayThread( 8.0, ::radio_dialogue_generic, "roadkill_ar3_covering" );

	wait( 13.7 );

	// Three foot-mobiles, balcony 12 o'clock. Probable militia.	
	thread radio_dialogue_generic( "roadkill_ar1_probablemilitia" );
	wait( 3.5 );
	// Are they armed?	
	thread radio_dialogue_generic( "roadkill_fly_aretheyarmed" );
	wait( 2.2 );

	// Negative, they're just watching us. 	
	thread radio_dialogue_generic( "roadkill_ar1_watchingus" );
	wait( 5.1 );

	// Bet they're scouting us.	
	thread dunn_line( "roadkill_cpd_scoutingus" );
	wait( 2.0 );

	// Doesn�t mean we can shoot 'em.	
	thread driver_line( "roadkill_fly_doesntmean" );


	/*
	wait( 24.5 );
	// Hold off, it�s a civilian.	
	add_func( ::foley_line, "roadkill_fly_holdoff" );
	
	// Bet he�s scouting us.	
	add_func( ::dunn_line, "roadkill_cpd_scoutingus" );
	
	// Doesn�t mean you can shoot him.	
	add_func( ::foley_line, "roadkill_fly_doesntmean" );
	
	do_funcs();


	// Wonder what's got him all worked up?	
	add_wait( ::flag_wait, "worked_up" );
	add_func( ::dunn_line, "roadkill_cpd_allworkedup" );
	thread do_wait();
	*/


	/*	
	// Watch your sector!	
	foley_line( "roadkill_fly_watchsector" );
	wait( 4 );
	// You see anything?	
	dunn_line( "roadkill_cpd_seeanything" );
	wait( 6 );
	// Stay frosty!	
	foley_line( "roadkill_fly_stayfrosty" );
	*/

//	array_spawn_function_noteworthy( "rooftop_drone", ::rooftop_drone );





}

start_crazy_ride()
{
	setup_ride_path_targets( "start_vehicle_crazy_ride" );
	start_ride_common( true );
}

roadkill_crazy_ride()
{
	run_thread_on_targetname( "shot_fired_trigger", ::shot_fired_trigger );
	flag_wait( "shot_rings_out" );

	thread player_convoy_encounters_baddies();

	thread crazy_ride_dialogue();
	thread roadkill_ride_kill_drones();
	flag_wait( "ambush_spawn" );

	ai = GetAIArray();
	foreach ( guy in ai )
	{
		if ( IsDefined( guy GetTurret() ) )
			continue;
		if ( guy.team != "neutral" )
			continue;

		guy safe_delete();
	}

	// dont want the player getting hit after the enemies retreat
	level.player.ignoreme = false;
	level.player.IgnoreRandomBulletDamage = false;

	array_thread( level.school_ambush_spawners, ::spawn_ai );
	flag_wait( "ambush" );
	//SetHalfResParticles( true );
	battlechatter_on( "axis" );
	add_global_spawn_function( "axis", ::die_after_awhile );

	level.old_physics_force = GetDvarFloat( "physveh_explodeforce", 0 );
	SetSavedDvar( "physveh_explodeforce", 0 );

	//array_spawn_targetname( "school_ambush_lower_floor" );

//	delayThread( 2, ::array_spawn_targetname, "school_ambush_outside_spawner" );

	wait( 3 );

	autosave_by_name( "ambush" );
}

crazy_ride_dialogue()
{

	flag_wait( "shot_rings_out" );

	wait( 1 );
	// Can you see 'em? Can you see 'em?	
	thread passenger_line( "roadkill_ar2_seeem" );
	wait( 1.5 );

	// I don't see jack! 	
	thread dunn_line( "roadkill_cpd_dontseejack" );
	wait( 1.5 );

	// All Hunter victors, this is Sergeant Foley. Prepare to engage, we're taking sniper fire from multiple directions.	
	thread radio_dialogue_generic( "roadkill_fly_prepeng" );
	wait( 3.8 );

	// Prepare to engage!! We're goin' in!!!	
	thread dunn_line( "roadkill_cpd_goinin" );
	wait( 1.8 );

	// This is it!!! Spin 'em up!!	
	thread driver_line( "roadkill_ar1_spinemup" );
	wait( 1.5 );
	flag_set( "humvees_spin_up" );

	// Watch twelve and six! 	
	thread ahead_line( "roadkill_ar3_12and6" );
	wait( 0.5 );

	// We got a ton of contacts front and back!	
	thread way_ahead_line( "roadkill_ar4_tonacontacts" );
	wait( 1.5 );

//	// Watch for movement! 	
//	thread dunn_line( "roadkill_cpd_watchmvmnt" );

	// Taking fire, multiple contacts at long range!	
	thread way_ahead_line( "roadkill_ar5_longrange" );
	wait( 1.0 );

	// Goin' forward!!	
	thread ahead_line( "roadkill_ar2_goinforward" );
	wait( 2.0 );
	
	battlechatter_on( "axis" );

	// There they are!!!! Right there!	
	//thread radio_dialogue_generic( "roadkill_ar1_rightthere" );
//	wait( 4.5 );

	// Shut that thing off!	
	//thread dunn_line( "roadkill_cpd_shutitoff" );
//	wait( 3.8 );

	// There they are, light 'em up!!	
	thread dunn_line( "roadkill_cpd_lightemup" );

	// Here they come!	
	delaythread( 0.5, ::arab_line, "roadkill_AB2_heretheycome" );

	// Use your RPGs! Target the humvees!	
	delaythread( 2.5, ::arab_line, "roadkill_AB2_rpgshumvees" );



	

	flag_wait( "ambush" );
	wait( 5.0 );
	// There's too many of 'em! Back up back up!!!	
	thread dunn_line( "roadkill_cpd_backup" );

	wait( 2 );
	// Get us outta here! Drive!	
	thread dunn_line( "roadkill_cpd_outtahere" );


	// Hassan! Move across the street for a better vantage point!	
	delaythread( 3.5, ::arab_line, "roadkill_AB2_hassanmove" );

	// Die you American dogs!	
	delaythread( 6.5, ::arab_line, "roadkill_AB2_diedogs" );

	// Move move move!!	
	delaythread( 8.5, ::arab_line, "roadkill_AB2_movex3" );



	// Hunter 2-1, this is Hunter 2-3, our humvee got shot up and we're cut off from you, over!	
//	radio_line( "roadkill_ar2_shotup" );

	// Solid copy Hunter 2-3! Hang tight! We'll make our way back to you, over!	
//	foley_line( "roadkill_fly_hangtight" );

	// Hunter 2-3 solid copy!	
//	radio_line( "roadkill_ar2_solidcopy" );

}

start_crazy_ride_later()
{
	setup_ride_path_targets( "start_vehicle_ride_later" );
	start_ride_common( true );
}


roadkill_crazy_ride_later()
{
	thread ride_later_dialogue();

	// makes the player and technical brake
	player_brake_trigger = GetEnt( "player_brake_trigger", "targetname" );
	player_brake_trigger thread player_pushes_truck_down_alley();

	lead_vehicle = level.crazy_ride_convoy[ 0 ];
	player_vehicle = level.crazy_ride_convoy[ 1 ];
	rear_vehicle = level.crazy_ride_convoy[ 2 ];

	player_vehicle VehPhys_DisableCrashing();


	level.player EnableDeathShield( false );


	wait( 0.05 );// wait for level.lead_vehicle to get set.
	thread convoy_gunners_pick_targets();

	thread enemy_ai_accuracy_effected_by_player_humvee();

	flag_wait( "lead_vehicle_speeds_up" );

	//lead_vehicle Vehicle_SetSpeed( 26, 1, 1 );

//	player_vehicle thread radius_damage_in_front();

//	flag_wait( "traffic_jam" );


	level.old_physics_force = GetDvarFloat( "physveh_explodeforce", 0 );
	SetSavedDvar( "physveh_explodeforce", 0 );


	flag_wait( "resume_the_path" );
	SetPlayerIgnoreRadiusDamage( true );


//	player_vehicle ResumeSpeed( 5 );			
//	player_vehicle Vehicle_SetSpeed( 10, 2, 2 );

//	technical Vehicle_SetSpeedImmediate( 5, 1, 1 );
//	technical delayThread( 0.01, ::set_brakes, 0 );
//	technical delayCall( 0.01, ::vehicle_setspeedimmediate, 8, 1, 1 );

//	player_vehicle.veh_brake = 0.0;

	//wait( 1.2 );
	//wait( 0.6 );
	delayThread( 0.25, ::force_player_vehicle_speed, 12 );
	delayThread( 0.2, ::player_impact_earthquake );
	delayThread( 0.2, ::traffic_truck_pushed );
	delayThread( 1.25, ::force_player_vehicle_speed, 8 );

	flag_wait( "player_is_pushing_truck" );
	level.traffic_jam_truck godoff();

	level.traffic_jam_truck delayCall( 1, ::vehicle_setspeedimmediate, 0, 1, 1 );

	push_truck = GetVehicleNode( "push_truck", "targetname" );
	player_vehicle StartPath( push_truck );

	rear_vehicle.veh_brake = 0.5;
	lead_vehicle.veh_brake = 0.5;


	flag_wait( "player_goes_in_reverse" );
	level notify( "stop_updating_player_vehicle_speed" );

	player_vehicle.veh_transmission = "reverse";
	player_vehicle.veh_pathdir = "reverse";

	wait( 1 );

	player_vehicle.veh_transmission = "forward";
	player_vehicle.veh_pathdir = "forward";

	player_reattach_route = GetVehicleNode( "player_reattach_route", "script_noteworthy" );
	player_vehicle StartPath( player_reattach_route );

	rear_vehicle.veh_brake = 0;

	lead_vehicle thread lead_vehicle_starts_going_again();

	player_vehicle ResumeSpeed( 5 );
	flag_set( "push_complete" );

	level notify( "stop_updating_player_vehicle_speed" );

	SetPlayerIgnoreRadiusDamage( false );

	thread ride_end_dialogue();
	lead_vehicle = level.crazy_ride_convoy[ 0 ];
	player_vehicle = level.crazy_ride_convoy[ 1 ];
	rear_vehicle = level.crazy_ride_convoy[ 2 ];

	flag_wait( "player_vehicle_wipes_out" );
	//SetHalfResParticles( false );
	player_vehicle  Vehicle_SetSpeed( 14, 2, 2 );
	rear_vehicle	Vehicle_SetSpeed( 14, 2, 2 );

//	wait( 0.5 );
	last_building_spawners = GetEntArray( "last_building_spawner", "targetname" );
	array_spawn( last_building_spawners );

	Missile_DeleteAttractor( level.player_repulsor );
	missile_target = GetEnt( "missile_target", "targetname" );
	attract_ent = GetEnt( missile_target.target, "targetname" );
	attractor = Missile_CreateAttractorEnt( attract_ent, 50000, 50000, level.ride_killer );


	// recover and dont get hurt while you get out
	set_player_attacker_accuracy( 0.0 );
	level.player.IgnoreRandomBulletDamage = true;
	thread player_gets_max_health_for_dismount();
	wait( 2 );

	player_vehicle  Vehicle_SetSpeed( 10, 2, 2 );
	rear_vehicle	Vehicle_SetSpeed( 10, 2, 2 );

	level.player EnableDeathShield( true );
	rocket = undefined;

	for ( ;; )
	{
		found_rocket = false;
		rockets = GetEntArray( "rocket", "classname" );
		foreach ( rocket in rockets )
		{

			if ( Distance( rocket.origin, level.player.origin ) < 750 )
			{
				found_rocket = true;
				break;
			}
		}
		if ( found_rocket )
			break;
		wait( 0.05 );
	}

	dot = get_dot( level.player GetEye(), level.player GetPlayerAngles(), rocket.origin );
	PrintLn( "dot " + dot );
	slowmo = dot >= 0.8;

	if ( slowmo )
	{
		slowmo_start();
		slowmo_setspeed_slow( 0.65 );
		slowmo_setlerptime_in( 0.2 );
		slowmo_lerp_in();
	}

	for ( ;; )
	{
		if ( !isdefined( rocket ) )
			break;
		if ( Distance( rocket.origin, level.player.origin ) < 150 )
		{
			if ( slowmo )
			{
				slowmo = false;
				slowmo_setlerptime_out( 0.0 );
				slowmo_lerp_out();
				slowmo_end();
			}
		}

		if ( Distance( rocket.origin, level.player.origin ) < 75 )
			break;

		wait( 0.05 );
	}

	if ( slowmo )
	{
		slowmo_setlerptime_out( 0.0 );
		slowmo_lerp_out();
		slowmo_end();
	}

	thread player_becomes_normal_gameskill();


	//ignoresuppression
	org = level.player.origin;
//	level.player FreezeControls( true );
	level.player Unlink();
//	level.player_turret UseBy( level.player );
	level.player_turret Delete();// 	UseBy( level.player );
	level.player SetOrigin( org );
	level notify( "ride_ends" );
	level.player maps\_gameskill::update_player_attacker_accuracy();

	ai = GetAIArray( "allies" );
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();
	}

	// I banish ye to vehicle hell
	vehicles = [];
	vehicles[ 0 ] = lead_vehicle;
	vehicles[ 1 ] = player_vehicle;
	vehicles[ 2 ] = rear_vehicle;

	vehicle_hell = GetVehicleNode( "vehicle_hell", "targetname" );
	foreach ( vehicle in vehicles )
	{
		vehicle thread goes_to_hell( vehicle_hell );
	}

	SetSavedDvar( "physveh_explodeforce", level.old_physics_force );
}

ride_later_dialogue()
{
	flag_wait( "lead_vehicle_speeds_up" );
	start_time = GetTime();
	// Slow down, we're getting strung out!	
//	wait( 2.5 );
	thread foley_line( "roadkill_fly_strungout" );
//	wait_for_buffer_time_to_pass( start_time, 4.2 );


	flag_wait( "we're cut off" );
	// We're cut off!	
	dunn_line( "roadkill_cpd_cutoff" );

	//wait_for_buffer_time_to_pass( start_time, 7.2 );

	flag_wait( "push_through" );

	// Push through!	
	foley_line( "roadkill_fly_pushthrough" );

}

ride_end_dialogue()
{
	flag_wait( "player_vehicle_wipes_out" );
	//wait( 1 );

	// Heads up!	
	foley_line( "roadkill_fly_headsup" );
}

start_dismount()
{
	level.player DisableWeapons();
	slide_org = getstruct( "slide_org", "targetname" );
	level.player SetOrigin( slide_org.origin );
}

roadkill_convoy_dismounts()
{
	SetSavedDvar( "compass", 1 );
	flag_set( "kill_drones" );
	remove_global_spawn_function( "axis", ::no_grenades );

	thread handle_player_exposing_himself_in_front_of_school();

	if ( IsDefined( level.crazy_ride_convoy[ "detour" ] ) && IsDefined( level.crazy_ride_convoy[ "detour" ].classname ) )
	{
		level.crazy_ride_convoy[ "detour" ].deathfx_ent Delete();
		level.crazy_ride_convoy[ "detour" ] Delete();
	}

	exploder( "smoke_column" );
	destroyed_humvee_models = GetEntArray( "destroyed_humvee_model", "targetname" );
	array_thread( destroyed_humvee_models, ::show_solid );

	if ( level.start_point != "dismount" )
		thread maps\_autosave::_autosave_game_now_nochecks();

	thread dismount_dialogue_and_friendly_progression_logic();

	array_spawn_function( level.school_ambush_spawners, ::join_school_threatbias_group_and_damage_func );
//	array_spawn_function_noteworthy( "school_spawner", ::join_school_threatbias_group );
	array_spawn_function_noteworthy( "school_spawner", ::enable_danger_react, 5000 );
	array_spawn_function_noteworthy( "school_spawner", ::school_spawner_think );
	//thread school_spawner_flee_node();


	run_thread_on_targetname( "barbwire_ride_cutoff", ::show_helper_model );
	activate_trigger_with_targetname( "friendlies_flee_ambush_trigger" );

	delayThread( 0.95, ::crash_physics_explosion );

	level.player ShellShock( "default", 5 );
	Earthquake( 1, 2, level.player.origin, 2000 );

	models = GetEntArray( "dead_vehicle_spawner", "targetname" );
	foreach ( model in models )
	{
		model SetContents( model.oldcontents );
		model Show();
	}

	//(-6404 8583 362) : 270 345
	player_slide_crash = getstruct( "player_slide_crash", "targetname" );

	slideModel = spawn_tag_origin();
	slideModel.origin = level.player.origin;
	slideModel.angles = level.player.angles;
	level.player PlayerLinkTo( slideModel, "tag_origin", 1, 0, 0, 0, 0, 0 );


	movetime = 0.3;
	slideModel MoveTo( player_slide_crash.origin, movetime, movetime * 0.6, movetime * 0.4 );
	slideModel RotateTo( player_slide_crash.angles, movetime, movetime * 0.6, movetime * 0.4 );
	wait( movetime );
	slideModel Delete();
	level.player SetOrigin( player_slide_crash.origin );
//	level.player SetPlayerAngles( player_slide_crash.angles );
	level.player SetStance( "prone" );
	level.player AllowCrouch( true );
	level.player AllowProne( true );


	// temporary thing to delete far away axis to save me a recompile
	ai = GetAIArray( "axis" );
	get_array_of_closest( level.player.origin, ai );
	for ( i = ai.size - 1; i >= 0 && i >= ai.size - 4; i-- )
	{
		if ( IsDefined( ai[ i ].magic_bullet_shield ) )
			continue;
		ai[ i ] Kill();
	}

	friendly_crash_spawners = GetEntArray( "friendly_crash_spawner", "targetname" );
	array_spawn_function( friendly_crash_spawners, ::friendly_crash_think );
	array_thread( friendly_crash_spawners, ::move_flashed_spawner_and_spawn );

	level.player SetThreatBiasGroup( "ally_with_player" );

	flag_set( "player_knocked_down" );
	battlechatter_on( "allies" );

	// rooftop enemies show up
	//thread modify_dismount_spawner_threatbias();
	array_spawn_function_targetname( "dismount_enemy_spawner", ::dismount_enemy_spawner );
	array_spawn_targetname( "dismount_enemy_spawner" );

//	autosave_by_name( "dismount" );

	exploder( "crashed_humvees" );

	remove_global_spawn_function( "axis", ::die_after_awhile );
	remove_global_spawn_function( "axis", ::set_ignoreSuppression );

//	level.player thread EndSliding();

	wait( 0.5 );
	timer = 5;
	frames = timer * 20;
	for ( i = 0; i < frames; i++ )
	{
		if ( level.player GetStance() != "prone" )
			break;
		wait( 0.05 );
	}

	weapons = level.player GetWeaponsListPrimaries();
	other_weapon = undefined;
	foreach ( weapon in weapons )
	{
		if ( weapon == "javelin" )
		{
			level.player TakeWeapon( weapon );
			continue;
		}
		other_weapon = weapon;
	}
	if ( IsDefined( other_weapon ) )
		level.player SwitchToWeapon( other_weapon );

	level.player delayCall( 4, ::EnableDeathShield, false );
	level.player EnableWeapons();


//	lead_vehicle Vehicle_SetSpeedImmediate( 32, 2, 2 );

//	player_wipe_out_path = GetVehicleNode( "player_wipe_out_path", "targetname" );
//	player_vehicle StartPath( player_wipe_out_path );

	set_promotion_order( "g", "c" );// if a green guy dies, cyan becomes green

	flag_set( "player_is_dismounted" );

	//thread grenade_barrage_if_you_delay();

	// player needs full health.
//	maps\_gameskill::updateAllDifficulty();

	flag_wait( "player_enters_ambush_house" );

	//thread staircase_grenade();

	level.ambush_allies_outside_vehicle = 0;
	ambush_ally_spawners = GetEntArray( "ambush_ally_spawner", "targetname" );
	array_spawn_function( ambush_ally_spawners, ::ambush_ally_spawner_think );
	array_thread( ambush_ally_spawners, ::spawn_ai );

	ambush_house_spawners = GetEntArray( "ambush_house_spawner", "targetname" );

	array_spawn_function_noteworthy( "slowbie", ::ambush_house_slowbie );
	array_spawn_function( ambush_house_spawners, ::ambush_house_spawner_think );

	//array_thread( ambush_house_spawners, ::spawn_ai );


	add_wait( ::flag_wait, "player_looks_at_staircase" );
	add_wait( ::flag_wait, "player_progresses_in_ambush_house" );
	add_func( ::array_spawn_targetname, "ambush_house_spawner" );
	thread do_wait_any();

	/*	
	flag_wait( "ambush_house_enemies_came_down_stairs" );

	volume = GetEnt( "ambush_house_lower_volume", "targetname" );
	volume waittill_volume_dead_or_dying();
	*/
	add_wait( ::flag_wait, "sweep_dismount_building" );
	add_wait( ::flag_wait, "player_progresses_in_ambush_house" );
	do_wait_any();

	activate_trigger_with_targetname( "ambush_house_friendlies_progress_downstairs" );

	//flag_wait( "staircase_grenade" );
	flag_wait( "dismount_friendlies_go_for_staircase" );


	activate_trigger_with_targetname( "ambush_house_friendlies_reach_staircase" );


	spawn_vehicles_from_targetname( "ambushed_hummer" );

	remove_car = GetEnt( "remove_car", "script_noteworthy" );
	remove_car Delete();



	add_wait( ::flag_wait, "foley_flashbang" );
	add_func( ::learn_flash );
	thread do_wait();
//	thread learn_flash( start_time );

	flag_wait( "ambush_house_player_goes_upstairs" );
	thread detect_room_was_flashed();



	level.enemy_playground_enemies = [];
	// spawn the badguys in front of the school
	array_spawn_function_noteworthy( "enemy_playground_spawner", ::enemy_playground_spawner );
	array_spawn_noteworthy( "enemy_playground_spawner" );

	// the school attacks!
	foreach ( spawner in level.school_ambush_spawners )
	{
		spawner.count = 1;
		spawner.script_accuracy = 1;
		spawner spawn_ai();
	}


	start_time = GetTime();
	volume = GetEnt( "ambush_house_upstairs_first_room", "targetname" );
	volume add_wait( ::waittill_volume_dead_or_dying );
	add_wait( ::flag_wait, "player_leaves_ambush_house" );
	do_wait_any();


	activate_trigger_with_targetname( "ambush_house_friendlies_upstairs_trigger" );

	//flag_wait_either( "ambush_house_player_goes_last_room", "room_was_flashed" );
	flag_wait_or_timeout( "ambush_house_player_goes_last_room", 12 );

	/*	
	if ( !flag( "player_leaves_ambush_house" ) )
	{
		volume = GetEnt( "ambush_house_last_room", "targetname" );
		volume add_wait( ::waittill_volume_dead_or_dying );
		add_wait( ::flag_wait, "player_leaves_ambush_house" );
		do_wait_any();
	}

	if ( !flag( "player_leaves_ambush_house" ) )
	{
		activate_trigger_with_targetname( "ambush_house_friendlies_last_room_trigger" );
		wait( 3 );
	}
	*/
	activate_trigger_with_targetname( "ambush_house_friendlies_last_room_trigger" );
	level.foley set_force_color( "b" );
	level.dunn set_force_color( "p" );

	flag_wait( "playground_baddies_retreat" );

	activate_trigger_with_targetname( "ambush_house_friendlies_leave_trigger" );

	flag_wait( "player_leaves_ambush_house" );
//	level.player SetThreatBiasGroup( "allies" );


}

dismount_dialogue_and_friendly_progression_logic()
{
	wait( 4 );
	// We need to get off the street!	
	thread foley_line( "roadkill_fly_getoffstreet" );
	flag_wait( "player_is_dismounted" );
	wait( 0.5 );

	flag_wait( "player_enters_ambush_house" );
	wait( 3.0 );

	// Is everybody ok?	
	foley_line( "roadkill_fly_everybodyok" );
	wait( 0.5 );
	dunn_line( "roadkill_cpd_huah" );

	thread play_sound_in_space( "scn_roadkill_interior_scuffle1", level.dunn.origin + (0,0,120) );
	
	//other_two_guys_say_huah();
	wait( 0.45 );
	
	// They're movin' around upstairs!		
	dunn_line( "roadkill_cpd_movinaroundup" );
	
	// Get the hell away from those windows and secure the top floor! Move! Move!		
	foley_line( "roadkill_fly_securetopfloor" );

	flag_set( "sweep_dismount_building" );

	//flag_wait( "ambush_house_player_goes_last_room" );

	flag_wait( "eyes_on_school" );
	if ( !flag( "lets_go_trigger" ) )
	{
		add_endon( "lets_go_trigger" );
		volume = GetEnt( "ambush_house_last_room", "targetname" );
		volume add_wait( ::waittill_volume_dead );
		add_wait( ::_wait, 4 );
		do_wait_any();
	}


	thread foley_gets_eyes_on_school_dialogue();

	add_wait( ::flag_wait, "player_leaves_ambush_house" );
	add_wait( ::flag_wait, "playground_baddies_retreat" );
	add_wait( ::_wait, 20 );
	do_wait_any();
	
	flag_set( "playground_baddies_retreat" );

	wait_for_chance_to_charge_school();


	/#
	// should be no more cyan guys now
	guys = get_force_color_guys( "allies", "c" );
	AssertEx( !guys.size, "Found cyan guys!" );
	#/


	delayThread( 1.1, ::flag_set, "friendlies_run_to_school" );

	// Follow me let's go!  	
	thread foley_line( "roadkill_fly_followme" );

	flag_wait( "friendlies_run_to_school" );

	ai = level.crash_friendly;
	level.crash_friendly = array_removeDead( level.crash_friendly );
	foreach ( guy in level.crash_friendly )
	{
		guy enable_heat_behavior();
	}

	activate_trigger_with_targetname( "school_friendlies_gather_outside_trigger" );

	run_thread_on_targetname( "stop_sprinting_trigger", ::stop_sprinting_trigger );
}

start_roadkill_school_fight()
{
	struct = getstruct( "school_start_player", "targetname" );
	level.player teleport_ent( struct );

	array_spawn_noteworthy( "dismount_macey" );
	array_spawn_noteworthy( "dismount_dunn" );

	waittillframeend;// wait till they spawn

	struct = getstruct( "school_start_foley", "targetname" );
	level.foley teleport_ent( struct );
	level.foley magic_bullet_shield();

	struct = getstruct( "school_start_dunn", "targetname" );
	level.dunn teleport_ent( struct );
	level.dunn magic_bullet_shield();

	level.foley set_force_color( "b" );
	level.dunn set_force_color( "p" );

	activate_trigger_with_targetname( "school_friendlies_gather_outside_trigger" );
}

roadkill_school_fight()
{
	thread school_enemies_retreat_dialogue();
	thread friendlies_traverse_school();
	array_spawn_function_noteworthy( "hidden_room_spawner", ::hidden_room_spawner );
	
	thread dunn_says_clear_on_room_clear();

	thread cutting_history_class_dialogue();

	flag_set( "lets_go_trigger" );

	flag_wait( "roadkill_school_2" );

	// Watch it! Some of 'em just went in that classroom on the right!	
	dunn_line( "roadkill_cpd_classonright" );
	wait( 2 );

	// Hunter 2-3, Hunter 2-1, we're in the school. Heavy resistance.	
	add_func( ::foley_line, "roadkill_fly_intheschool" );
	// Copy that Hunter 2-1.	
	add_func( ::shepherd_line, "roadkill_shp_copythat21" );
	thread do_funcs();


	flag_wait( "roadkill_school_3" );

	// clear out the ally threatbias group
	SetThreatBias( "axis_school", "ally_with_player", 0 );
	SetThreatBias( "ally_with_player", "axis_school", 0 );

	flag_wait( "roadkill_school_5" );

	add_wait( ::player_is_safe );
	add_wait( ::_wait, 3.5 );
	add_func( ::foley_line, "roadkill_fly_pressureoff" );
	thread do_wait_any();



	flag_wait( "roadkill_school_6" );
	respawn_dead_school_window_guys();

	trigger = GetEnt( "player_shoot_detection_trigger", "targetname" );
	trigger thread player_shoot_detection_trigger();

	array_spawn_function_noteworthy( "fleeing_baddie_spawner", ::fleeing_baddie_spawner );


	flag_wait( "roadkill_school_9" );
	flag_set( "shepherd_moves_out" );

	flag_wait( "roadkill_school_13" );

	thread roadkill_ending_run_dialogue();
	thread school_badguy_cleanup();
	
}

school_enemies_retreat_dialogue()
{
	flag_wait( "retreaters_run" );

	wait( 2 );
	
	// Hunter 2-1 this is Shepherd, thanks for the assist! This town's almost ours - let's finish the job, huah?	
	shepherd_line( "roadkill_shp_thanksforassist" );

	// Huah. Roger that 2-3. Rangers lead the way sir!	
	foley_line( "roadkill_fly_allthewaysir" );
}

roadkill_ending_run_dialogue()
{
	if ( flag( "player_rounds_end_corner" ) )
		return;

	level endon( "player_rounds_end_corner" );

	roadkill_school_14 = GetEnt( "roadkill_school_14", "targetname" );
	volume = roadkill_school_14 get_color_volume_from_trigger();
	volume waittill_volume_dead_or_dying();
	wait( 1 );

	// All the way! We'll see you on the flipside Hunter 2-1, Shepherd out.	
//	shepherd_line( "roadkill_shp_alltheway" );

	// Hunter 2-1 Actual to Goliath.	
	foley_line( "roadkill_fly_togoliath" );
	
	// Hunter 2-1 Actual this is Goliath, send traffic.	
	radio_line( "roadkill_ar3_sendtraffic" );
	
	// Copy Goliath, the school is secure and hostiles are withdrawing from the area. We're just moppin' up now.	
	foley_line( "roadkill_fly_schoolsecure" );
	
	// Copy that Hunter 2-1 Actual, proceed with caution to the rally point. EPWs may still be in the area. Over.	
	radio_line( "roadkill_ar3_rallypoint" );
	
	// Roger that Goliath, thanks for the tip. Hunter 2-1 Actual out.	
	foley_line( "roadkill_fly_thanksfortip" );

	// Squad, watch for enemy stragglers! Let's get to that rally point!	
	foley_line( "roadkill_fly_watchstragglers" );
	flag_set( "final_objective" );
}

start_roadkill_end()
{
	slide_org = getstruct( "start_player_end", "targetname" );
	level.player SetOrigin( slide_org.origin );
	level.player SetPlayerAngles( slide_org.angles );

}

start_roadkill_endfight()
{
	start = getstruct( "start_player_endfight", "targetname" );
	level.player SetOrigin( start.origin );
	level.player SetPlayerAngles( start.angles );

	ally_starts = getstructarray( "start_ally_endfight", "targetname" );

	foley_spawner = GetEnt( "dismount_macey", "script_noteworthy" );
	foley_spawner.origin = ally_starts[ 0 ].origin;

	dunn_spawner = GetEnt( "dismount_dunn", "script_noteworthy" );
	dunn_spawner.origin = ally_starts[ 1 ].origin;

	foley_spawner StalingradSpawn();
	dunn_spawner StalingradSpawn();

	for ( i = 0; i <= 16; i++ )
	{
		if ( flag_exist( "roadkill_school_" + i ) )
		{
			flag_set( "roadkill_school_" + i );
		}
	}

	thread friendlies_traverse_school();

	//Line( start, end, color, alpha, depthTest, duration );
	waittillframeend;
	level.foley set_force_color( "b" );
	level.dunn set_force_color( "p" );
}

roadkill_the_end()
{
	array_spawn_function_targetname( "shepherd_ending_spawner", ::shepherd_ending_spawner );
	array_spawn_function_targetname( "ending_hangout_spawner", ::ending_hangout_spawner );

	level.ending_vehicles = [];
	array_spawn_function_noteworthy( "ending_vehicle", ::ending_vehicle );
	array_spawn_function_noteworthy( "shepherd_ending_vehicle", ::shepherd_ending_vehicle );

	array_spawn_function_noteworthy( "pistol_walk_spawner", ::roadkill_pistol_guy );
	array_spawn_function_noteworthy( "pistol_killer_spawner", ::pistol_killer_spawner );

	run_thread_on_targetname( "friendlies_get_on_exit_convoy_trigger", ::friendlies_get_on_exit_convoy_trigger );

	flag_wait( "roadkill_school_20" );


	//link_heli_to_landing();

	level.heli_guy_left = [];
	level.heli_guy_right = [];

	array_spawn_function_noteworthy( "heli_spawner_left", ::heli_spawner_left );
	array_spawn_noteworthy( "heli_spawner_left" );

	array_spawn_function_noteworthy( "heli_spawner_right", ::heli_spawner_right );
	array_spawn_noteworthy( "heli_spawner_right" );

	array_spawn_function_targetname( "ending_takeoff_heli_spawner", ::ending_takeoff_heli_spawner );
	array_spawn_targetname( "ending_takeoff_heli_spawner" );

	flag_wait( "pistol_runner_died" );
	activate_trigger_with_targetname( "final_friendly_trigger" );

	// Clear! That's the last of 'em!	
	if ( IsAlive( level.pistol_killer ) )
		level.pistol_killer thread generic_dialogue_queue( "roadkill_fly_lastofem" );

	flag_wait( "player_rounds_end_corner" );

	spawner = GetEnt( "shepherd_ending_spawner", "targetname" );
	spawner spawn_ai();

	array_spawn_targetname( "ending_hangout_spawner" );


	flag_wait( "approaching_end" );

	spawner = GetEnt( "stryker_blocker_spawner", "targetname" );
	spawner spawn_vehicle();



	//thread roadkill_ending_chatter();
	thread ending_fadeout_nextmission();
	flag_wait( "the_end" );
	ai = get_force_color_guys( "allies", "c" );
	foreach ( guy in ai )
	{
		if ( IsDefined( guy.magic_bullet_shield ) )
		{
			guy stop_magic_bullet_shield();
		}
		guy Delete();
	}



	//jet_time = 2;
	//delayThread( jet_time, ::spawn_vehicle_from_targetname_and_drive, "ending_f15_flyby" );
	//delayThread( jet_time + 3.1, ::exploder, "end_bomb" );

	axis = GetAIArray( "axis" );
	foreach ( guy in axis )
	{
		guy Kill();
	}
	array_spawn_function_targetname( "friendly_ending_runner_spawner", ::friendly_ending_runner_spawner );
	array_spawn_targetname( "friendly_ending_runner_spawner" );

	//iprintlnbold( "End of scripted level" );
}

roadkill_ending_chatter()
{
	// We're oscar mike!	
	thread random_ai_line( "roadkill_ar2_oscarmike2" );
	wait( 1.2 );

	// Stow your gear and move out!	
	thread random_ai_line( "roadkill_ar3_stowyourgear" );
	wait( 0.7 );

	flag_wait( "the_end" );

	// I want that Mark 19 up and running in five mikes!	
	thread random_ai_line( "roadkill_ar4_upandrunning" );
	wait( 2.1 );

	// Anybody got a spare MRE?	
	thread random_ai_line( "roadkill_ar1_sparemre" );
	wait( 0.3 );

	// Battalion is oscar mike!!!	
	thread random_ai_line( "roadkill_ar4_oscarmike" );
	wait( 0.4 );

	// Mount up!	
	thread random_ai_line( "roadkill_fly_mountup" );
	wait( 1.2 );

	// We're moving out now!	
	thread random_ai_line( "roadkill_fly_movingout" );
}

roadkill_startpoint_catchup_thread()
{
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;

	if ( start == "intro" )
		return;

	if ( start == "riverbank" )
		return;

	if ( start == "move_out" )
		return;

	flag_set( "bridgelayer_crosses" );
	flag_set( "riverbank_baddies_retreat" );
	flag_set( "leaving_riverbank" );
	flag_set( "player_enters_riverbank" );
	flag_set( "bridge_baddies_retreat" );

//	player_stair_blocker = GetEnt( "player_stair_blocker", "targetname" );
//	player_stair_blocker Delete();


	battlechatter_off( "allies" );

	if ( start == "convoy" )
		return;
		
	battlechatter_off( "axis" );

	flag_set( "player_gets_in" );
	flag_set( "roadkill_town_dialogue" );
	flag_set( "100ton_bomb_goes_off" );

	if ( start == "ride" )
		return;

	flag_set( "fight_back" );
//	flag_set( "ambush_spawner_angry" );

	if ( start == "ambush" )
		return;

	flag_set( "detour_convoy_slows_down" );
	flag_set( "ambush_spawn" );
	flag_set( "ambush" );

	if ( start == "ride_later" )
		return;
	if ( start == "ride_end" )
		return;
	set_player_attacker_accuracy( 0.0 );
	level.player.IgnoreRandomBulletDamage = true;
	thread player_becomes_normal_gameskill();
	if ( start == "dismount" )
		return;

	battlechatter_on( "allies" );

	flag_set( "player_enters_ambush_house" );
	flag_set( "player_is_dismounted" );

	if ( start == "school" )
		return;


	flag_set( "final_objective" );
	flag_set( "roadkill_school_20" );

	flag_set( "school_back_baddies_dead" );

	if ( start == "endfight" )
		return;

	if ( start == "end" )
		return;

	AssertMsg( "Unhandled start point " + start );
}

roadkill_objective_thread()
{
	switch ( level.start_point )
	{
		case "default":
		case "intro":
		case "riverbank":
		case "move_out":
		case "convoy":
			roadkill_riverbank_objective();
		case "ride":
		case "ride_later":
		case "ride_end":
		case "ambush":
			roadkill_ride_objective();
		case "dismount":
			roadkill_dismount_objective();
			roadkill_school_objective();
		case "school":
		case "endfight":
		case "end":
			roadkill_exfil_objective();
			break;

		default:
			AssertMsg( "Unhandled start point " + level.start_point );
			break;
	}
}


roadkill_music()
{
	switch ( level.start_point )
	{
		case "default":
		case "intro":
			flag_wait( "get_on_the_line" );
		case "riverbank":
		case "move_out":
		case "convoy":

			MusicPlayWrapper( "roadkill_intro" );
			flag_wait( "player_starts_stairs" );
			MusicStop( 10 );
			
			flag_wait( "player_gets_in" );
		
		case "ride":
		case "ride_later":
		case "ride_end":
		case "ambush":
		case "dismount":
		case "school":
		case "endfight":

			thread MusicLoop( "roadkill_armored_and_combat" ); // 8 minutes 24 seconds
		case "end":
			flag_wait( "start_shepherd_end" );
			level notify( "stop_music" );
			MusicStop( 5 );
			level.player play_sound_on_entity( "roadkill_finish" );
			break;

		default:
			AssertMsg( "Unhandled start point " + level.start_point );
			break;
	}
	
}