#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_slowmo_breach;

global_inits()
{
	maps\_uaz::main( "vehicle_uaz_hardtop", "uaz_physics" );
	maps\_littlebird::main( "vehicle_little_bird_bench" );
	maps\_pavelow::main( "vehicle_pavelow" );
	maps\_littlebird::main( "vehicle_little_bird_armed" );
	
	//maps\createart\estate_art::main();
	maps\createfx\estate_audio::main();
	maps\createart\estate_fog::main();
	
	maps\estate_anim::main();
	maps\estate_fx::main();
	
	maps\_load::main();
	
	level.autosave_proximity_threat_func = ::estate_autosave_proximity_threat_func;
	
	maps\_drone_ai::init();
	
	maps\_slowmo_breach::slowmo_breach_init();
	
	common_scripts\_sentry::main();
	
	level.customIntroAngles = intro_angles();	//Makes the view point to a specific direction at the end of slam zoom
	
	PreCacheItem( "claymore" );
	PreCacheItem( "flash_grenade" );
	PrecacheItem( "javelin" );
	PreCacheItem( "cheytac" );
	PreCacheModel( "projectile_bouncing_betty_grenade" );
	PreCacheModel( "accessories_gas_canister_highrez" );
	PreCacheModel( "prop_cigarette_pack" );
	PreCacheModel( "prop_price_cigar" );
	PreCacheModel( "weapon_colt_anaconda" );
	PreCacheModel( "mil_wireless_dsm_small" );
	PreCacheModel( "electronics_camera_pointandshoot_animated" );
	PreCacheModel( "ch_body_gk_ar15" );

	PreCacheTurret( "minigun_littlebird_spinnup" );
	PreCacheShellShock( "estate_bouncingbetty" );
	
	PreCacheRumble( "artillery_rumble" );
	PreCacheRumble( "shepherd_pistol" );
	PreCacheRumble( "shot_collapse" );
	PreCacheRumble( "bodytoss_impact" );
	PreCacheRumble( "dsm_rummage" );
	
	precachestring( &"ESTATE_DSM_FRAME" );
	precachestring( &"ESTATE_DSM_WORKING" );
	precachestring( &"ESTATE_DSM_NETWORK_FOUND" );
	precachestring( &"ESTATE_DSM_IRONBOX" );
	precachestring( &"ESTATE_DSM_BYPASS" );
	precachestring( &"ESTATE_DSM_PROGRESS" );
	precachestring( &"ESTATE_DSM_SLASH_TOTALFILES" );
	precachestring( &"ESTATE_DSM_DLTIMELEFT" );
	precachestring( &"ESTATE_DSM_DLTIMELEFT_MINS" );
	precachestring( &"ESTATE_DSM_DLTIMELEFT_SECS" );
	precachestring( &"ESTATE_DSM_DL_RATEMETER" );
	precachestring( &"ESTATE_DSM_DLRATE" );
	
	precachestring( &"ESTATE_DSM_DESTROYED_BY_PLAYER" );
	precachestring( &"ESTATE_DSM_DESTROYED_BY_AI_GUNFIRE" );
	precachestring( &"ESTATE_DSM_DESTROYED_BY_DESERTION" );
	
	precachestring( &"ESTATE_LEARN_PRONE" );
	precachestring( &"ESTATE_LEARN_PRONE_TOGGLE" );
	precachestring( &"ESTATE_LEARN_PRONE_HOLDDOWN" );
	
	precachestring( &"ESTATE_USE_CLAYMORE_HINT" );
	
	precachestring( &"ESTATE_REMIND_PRONE_LINE1" );
	precachestring( &"ESTATE_REMIND_PRONE_LINE2" );
	
	precachestring( &"ESTATE_REMIND_PRONE_LINE2_TOGGLE" );
	precachestring( &"ESTATE_REMIND_PRONE_LINE2_HOLDDOWN" );
	
	thread maps\estate_amb::main();
	//maps\_utility::set_vision_set( "estate", 0 );
	
	level.bouncing_betty_clicks = 0;
	level.custom_linkto_slide = true;
	
	level.forestEnemyCount = 0;
	
	level.activeSmokePots = 0;
	level.activeSmokePotLimit = 7;
	level.smokeTimeOut = 15;	//originally 10
	level.activeGameplayMines = 0;
	level.canSave = true;
	
	maps\_compass::setupMiniMap("compass_map_estate");
	
	level.scr_sound[ "mortar" ][ "incomming" ] = "mortar_incoming";
	level.scr_sound[ "mortar" ][ "dirt" ] = "mortar_explosion_dirt";
	level.alwaysquake = 1;
	
	add_hint_string( "claymore_hint", &"ESTATE_USE_CLAYMORE_HINT", ::should_break_claymore_hint );
		
	//PC Prone Key Config Handling - there are three different bindable controls for going prone on PC		
		
	//"toggleprone" (press prone once, stays prone)
	//Msg: "Press^3 [{toggleprone}] ^7to evade the landmine!"
	add_hint_string( "mineavoid_hint_toggle", &"ESTATE_LEARN_PRONE_TOGGLE", ::should_break_mineavoid_hint );
	
	//"+prone" (press and hold to go prone, gets up as soon as key is released)
	//Msg: "Press and hold down^3 [{+prone}] ^7to evade the landmine!"
	add_hint_string( "mineavoid_hint_holddown", &"ESTATE_LEARN_PRONE_HOLDDOWN", ::should_break_mineavoid_hint );
	
	// This last one works for console automatically
	// Press and hold^3 [{+stance}] ^7to evade the landmine!
	add_hint_string( "mineavoid_hint", &"ESTATE_LEARN_PRONE", ::should_break_mineavoid_hint );
	
	level.friendlyForestProgress = 0;
	
	level.perimeter_jeepguards = 0;
	
	level.mainfloorPop = 0;
    level.topfloorPop = 4;	//4 in the top room
    level.basementPop = 5;	//2 in the armory, 3 fleeing from the guestroom
	
	level.interiorRoomsBreached = 0;
	
	level.dsmHealthMax = 3000;	//health
	level.dsmHealth = level.dsmHealthMax;
	level.dsm_regen_dist_limit = 1000; 	//world units
	level.dsm_regen_amount = 0;
	level.dsm_regen_amount_max = 50;	//health per second
	
	level.playerDSMsafedist = 1500;	//player must be within this many units for the game to save during the defense
	
	level.enemyTotalPop = 0;
	level.enemyPop = 0;
	
	level.breachesDone = 3;
	
	level.usedFirstWarning = 0;
	level.usedSecondWarning = 0;
	level.early_escape_timelimit = 30;
	level.dangerZoneTimeLimit = 44;
	
	level.ending_attacker_deaths = 0;
	
	run_thread_on_targetname( "forest_friendly_advance_trig", ::forest_friendly_trigger_erase );
	
	run_thread_on_targetname( "breach_normalguy", ::house_extra_breachguys );
	array_spawn_function_targetname( "breach_normalguy", ::house_extra_breachguys_init );
	
	array_spawn_function_targetname( "breach_extraguy", ::house_floorpop_deathmonitor_init, 1 );
	array_spawn_function_targetname( "breach_extraguy", ::house_extras_stopcancel );
	
	array_spawn_function_targetname( "breach_enemy_spawner", ::house_floorpop_deathmonitor_init );
	array_spawn_function_targetname( "breach_normalguy", ::house_floorpop_deathmonitor_init );
	
	thread bouncing_betty_gameplay_saveguard();
	thread house_guestroom_breach_flee();
	thread house_armory_breach_windowtrick();
	thread house_furniture_sounds();
	
	thread solar_panels();
	
	//===========
	
	thread zone_detection_init();
	thread defense_schedule_control();
	thread defense_enemy_spawn();
	
	thread magic_sniper_guy();
	thread magic_sniper_guy_breaktimes();
	
	thread ending_shadowops_dronespawn();
	
	thread terminal_hunters();
	thread terminal_blockers();
	thread terminal_hillchasers();
	
	//===========
	
	thread abandonment_start_monitor();
	thread abandonment_early_escape_timer();
	thread abandonment_exit_tracking();
	thread abandonment_main_check();
	thread abandonment_failure();
}

forest_friendly_trigger_erase()
{
	self endon ( "death" );
	
	otherTrigs = undefined;
	
	if ( isdefined( self.script_linkto ) )
	{
		otherTrigs = [];
		otherTrigs = self get_linked_ents();
		
		foreach( otherTrig in otherTrigs )
		{
			otherTrig.trig = self;
		}
	}
	
	self waittill ( "trigger" );
	
	assertEX( self.script_index == level.friendlyForestProgress + 1, "goingbackwards" );
	
	level.friendlyForestProgress = self.script_index;
	
	if ( isdefined( otherTrigs ) )
	{
		foreach( otherTrig in otherTrigs )
		{
			otherTrig delete();
		}
	}
	else
	{
		if( isdefined( self.trig ) )
		{
			self.trig delete();
		}
	}
}


should_break_mineavoid_hint()
{
	if( level.player getstance() == "prone" )
	{
		return( true );
	}
	else
	{	
		return( false );
	}
}

flags()
{
	flag_init( "room_1_frontdoor_cleared" );
	flag_init( "room_1_kitchen_cleared" );
	flag_init( "room_2_laundry_cleared" );
	flag_init( "room_3_armory_cleared" );
	flag_init( "room_5_masterbed_cleared" );
	
	flag_init( "slam_zoom_done" );
	
	flag_init( "skip_intro" );
	flag_init( "skip_ambush" );
	flag_init( "skip_forestfight" );
	flag_init( "skip_houseapproach" );
	flag_init( "skip_housebreach" );
	flag_init( "skip_breachandclear" );
	flag_init( "skip_housebriefing" );
	flag_init( "skip_defense" );
	
	flag_init( "test_alt_ending" );
	
	flag_init( "print_first_objective" );
	flag_init( "futilejeeps_destroyed" );
	
	flag_init( "start_ghost_intro_nav" );
	flag_init( "downhill_run_enable" );
	flag_init( "downhill_run_disable" );
	
	flag_init( "ambush_shouted" );
	
	flag_init( "deploy_rpg_ambush" );
	flag_init( "deploy_mortar_attack" );
	
	flag_init( "gameplay_mine_done" );
	
	flag_init( "bouncing_betty_activated" );
	flag_init( "bouncing_betty_done" );
	flag_init( "mine_throw_player" );
	flag_init( "bouncing_betty_player_released" );
	flag_init( "ambushed_player_back_to_normal" );
	flag_init( "slow_motion_ambush_done" );
	flag_init( "spawn_first_ghillies" );
	flag_init( "smoke_screen_activated" );
	flag_init( "smoke_screen_assault_activated" );
	flag_init( "player_exits_smoke" );
	flag_init( "start_ambush_music" );
	
	flag_init( "stop_smokescreens" );
	
	flag_init( "ambush_complete" );
	
	flag_init( "player_is_out_of_ambush_zone" );
	
	flag_init( "forestfight_littlebird_1" );
	flag_init( "start_early_helicopter" );
	
	flag_init( "approaching_house" );
	
	flag_init( "deploy_house_defense_jeeps" );
	
	flag_init( "autosave_housearrival" );
	
	flag_init( "scripted_dialogue_on" );
	
	flag_init( "first_free_save" );
	
	flag_init( "dialogue_ghost_orders" );
	flag_init( "dialogue_topfloor_cleared" );
	flag_init( "dialogue_basement_cleared" );
	
	flag_init( "save_the_game_indoors" );
	flag_init( "save_the_game_downstairs" );
	
	flag_init( "foyer_breached_first" );
	flag_init( "kitchen_breached_first" );
	flag_init( "basement_breached_first" );
	
	flag_init( "breach0_foyerhall_cancel" );
	flag_init( "breach0_diningroom_cancel" );
	flag_init( "breach0_bathroomrush_cancel" );
	
	flag_init( "ghost_begins_sweep" );
	
	flag_init( "ghost_at_bottom_of_stairs" );
	
	flag_init( "ghost_goes_outside" );
	
	flag_init( "topfloor_breached" );
	flag_init( "basement_breached" );
	flag_init( "armory_breached" );
	flag_init( "guestroom_breached" );
	
	flag_init( "furniture_moving_sounds" );
	
	flag_init( "scarecrow_said_upstairs" );
	
	flag_init( "mainfloor_cleared" );
	flag_init( "topfloor_cleared" );
	flag_init( "basement_cleared" );
	
	flag_init( "mainfloor_cleared_confirmed" );
	flag_init( "basement_cleared_confirmed" );
	
	flag_init( "ghost_gives_regroup_order" );
	
	flag_init( "house_friendlies_instructions_given" );
	
	flag_init( "house_exterior_has_been_breached" );
	flag_init( "house_interior_breaches_done" );
	flag_init( "all_enemies_killed_up_to_house_capture" );
	
	flag_init( "house_approach_dialogue" );
	flag_init( "house_perimeter_softened" );
	
	flag_init( "house_briefing_is_over" );
	flag_init( "photographs_done" );
	
	flag_init( "house_briefing_dialogue_done" );
	
	flag_init( "dsm_ready_to_use" );
	flag_init( "download_started" );
	flag_init( "download_files_started" );
	flag_init( "dsm_exposed" );
	flag_init( "dsm_destroyed" );
	flag_init( "download_test" );
	flag_init( "download_data_initialized" );
	
	flag_init( "ozone_to_earlydefense_start" );
	flag_init( "scarecrow_to_earlydefense_start" );
	
	flag_init( "strike_packages_definitely_underway" );
	flag_init( "abandonment_danger_zone" );
	flag_init( "player_can_fail_by_desertion" );
	flag_init( "player_entered_autofail_zone" );
	
	flag_init( "dsm_compromised" );
	
	flag_init( "skip_house_defense_dialogue" );
	
	flag_init( "defense_battle_begins" );
	flag_init( "defending_dsm" );
	flag_init( "sniper_in_position" );	
	
	flag_init( "skip_defense_firstwave" );
	
	flag_init( "sniper_attempting_shot" );	
	flag_init( "sniper_shot_complete" );	
	flag_init( "sniper_shooting" );	
	
	flag_init( "strike_package_birchfield_dialogue" );
	flag_init( "strike_package_bighelidrop_dialogue" );
	flag_init( "strike_package_boathouse_dialogue" );
	flag_init( "strike_package_solarfield_dialogue" );
	flag_init( "strike_package_md500rush_dialogue" );
	flag_init( "rpg_stables_dialogue" );
	flag_init( "rpg_boathouse_dialogue" );
	flag_init( "rpg_southwest_dialogue" );
	flag_init( "scarecrow_death_dialogue" );	
	flag_init( "ozone_death_dialogue" );
	flag_init( "sniper_breaktime_dialogue" );
	
	flag_init( "boathouse_invaders_arrived" );
	
	flag_init( "activate_package_on_standby" );
	flag_init( "strike_package_spawned" );
	flag_init( "strike_component_activated" );
	
	flag_init( "activate_component_on_standby" );
	
	flag_init( "main_defense_fight_finished" );
	
	flag_init( "download_complete" );
	flag_init( "dsm_recovered" );
	
	flag_init( "begin_escape_music" );
	
	flag_init( "fence_removed" );
	
	flag_init( "player_is_escaping" );
	
	flag_init( "cointoss_done" );
	
	flag_init( "birchfield_cleared_sector1" );
	flag_init( "birchfield_cleared_sector2" );
	
	flag_init( "ghost_covered_player" );
	
	flag_init( "bracketing_mortars_started" );
	flag_init( "player_retreated_into_birchfield" );
	
	flag_init( "point_of_no_return" );
	
	flag_init( "finish_line" );
	
	flag_init( "begin_ending_music" );
	
	flag_init( "play_ending_sequence" );
	
	flag_init( "drag_sequence_slacker_check" );
	flag_init( "drag_sequence_killcount_achieved" );
	
	flag_init( "no_slow_mo" );
	
	flag_init( "start_playerdrag_sequence" );
	
	flag_init( "test_with_pavelow_already_in_place" );
	
	flag_init( "thunderone_heli" );
	
	flag_init( "enter_the_littlebirds" );
	
	flag_init( "made_it_to_lz" );
	
	flag_init( "test_whole_ending" );
	flag_init( "test_ending" );
	flag_init( "ghost_grabbed_player" );
	flag_init( "test_ending_body_toss" );
	flag_init( "begin_overlapped_gasoline_sequence" );
	flag_init( "cigar_flicked" );
	flag_init( "cigar_flareup" );
	
	flag_init( "end_the_mission" );
	
	flag_init( "claymore_hint_printed" );
}

intro_angles()
{
	startPoint = getent( "player_view_start_1", "targetname" );
	endPoint = getent( "player_view_start_2", "targetname" );
	
	vec = endPoint.origin-startPoint.origin;
	ang = vectorToAngles( vec );
	return( ang );
}

ghost_init()
{
	// spawn ghost
	level.ghost = spawn_targetname( "ghost", true );
	level.ghost.animname = "ghost";
	
	if( !flag( "test_ending" ) )
	{
		level.ghost thread downhill_run();
		level.ghost.pathRandomPercent = 0;	
		level.ghost thread magic_bullet_shield();
		
		if( !flag( "skip_houseapproach" ) )
		{
			level.ghost allowedstances ( "crouch" );
		}
		
		level.ghost pushplayer( true );
	
		level.ghost enable_cqbwalk();
		level.ghost.ignoresuppression = true;
	}
}

downhill_run()
{
	while( 1 )
	{
		guy = trigger_wait_targetname( "downhill_run_enable" );
		
		if( guy == self )
		{
			break;
		}
	}

	self disable_cqbwalk();
	self set_run_anim( "downhill_run" );
	
	while( 1 )
	{
		guy = trigger_wait_targetname( "downhill_run_disable" );
		
		if( guy == self )
		{
			break;
		}
	}
	
	if( self == level.ghost )
	{
		self allowedstances ( "stand", "crouch", "prone" );
	}
	
	self enable_cqbwalk();
	self clear_run_anim();
}

ghost_intro_nav()
{	
	//If player waits for intro sequence to end, Ghost gets up and moves out
	
	level endon ( "ghost_leaving_start_area_early" );
	
	flag_wait( "start_ghost_intro_nav" );
	
	level notify ( "ghost_leaving_start_area_on_cue" );
	
	starter = getent( "ghost_starter", "targetname" );
	
	if( isdefined( starter ) )
		starter notify ( "trigger" );

	level.ghost allowedstances ( "crouch", "prone", "stand" );
}

ghost_intro_interrupt()
{
	//If player rushes away from start location, Ghost gets up and moves out right away
	
	level endon ( "ghost_leaving_start_area_on_cue" );
	level notify ( "ghost_leaving_start_area_early" );
	
	starter = getent( "ghost_starter", "targetname" );
	
	if( isdefined( starter ) )
		starter waittill ( "trigger" );

	level.ghost allowedstances ( "crouch", "prone", "stand" );
}

friendly_troop_spawn()
{
    array_spawn_function_targetname( "starter_friendly", ::friendly_troop_init );
    starter_friendly_spawns = getentarray( "starter_friendly", "targetname" );
    array_thread( starter_friendly_spawns, ::spawn_ai );
}

friendly_troop_init()
{
    //self.disableArrivals = true;
    self.ignoresuppression = true;
    self pushplayer( true );
    self enable_cqbwalk();
    
    badass = isdefined( self.script_friendname );
    
    if ( badass )
    {
    	self thread magic_bullet_shield();
    	
    	if ( self.script_friendname == "Ozone" )
    	{
    		level.ozone = self;
    		level.ozone.animname = "ozone";
    		level.ozone thread downhill_run();
			level.ozone thread deathtalk_ozone();
			level.ozone thread ozone_death_decide();
    	}
    	
    	if ( self.script_friendname == "Scarecrow" )
    	{
    		level.scarecrow = self;
    		level.scarecrow.animname = "scarecrow";
    		level.scarecrow thread downhill_run();
    		level.scarecrow thread deathtalk_scarecrow();
    		level.scarecrow thread scarecrow_death_decide();
    	}
    } 
}

friendly_scout_spawn()
{
	array_spawn_function_targetname( "starter_scout", ::friendly_scout_init );
    starter_scout_spawns = getentarray( "starter_scout", "targetname" );
    array_thread( starter_scout_spawns, ::spawn_ai );   
}

friendly_scout_init()
{
    //self.disableArrivals = true;
    self.ignoresuppression = true;
    self pushplayer( true );
    self enable_cqbwalk();
    
    self thread friendly_die_in_ambush();
}

friendly_die_in_ambush()
{
	self endon ( "death" );
	
	flag_wait( "mine_throw_player" );	
	
	wait randomfloatrange( 0.1, 1 );
	
	self kill();
}

friendly_sniper_spawn()
{
    array_spawn_function_targetname( "starter_sniper", ::friendly_sniper_init );
    starter_sniper_spawns = getentarray( "starter_sniper", "targetname" );
    array_thread( starter_sniper_spawns, ::spawn_ai );  
}

friendly_sniper_init()
{
	self endon ( "death" );
	
    //self.disableArrivals = true;
    self.ignoresuppression = true;
    self pushplayer( true );
    self allowedStances( "crouch" );
    
    flag_wait( "player_is_out_of_ambush_zone" );
    self delete();
}

redshirtStartSpawnTeleport( startPointName )
{
	friendly_troop_spawn();
	
	allies = getaiarray( "allies" );
	
	foreach( ally in allies )
	{
		if( isdefined( ally.script_friendname ) )
		{
			if ( ally.script_friendname == "Ozone" )
			{
				node = getnode( "ozone_" + startPointName + "_start", "targetname" );
				ally forceTeleport( node.origin, node.angles );
			}
			
			if ( ally.script_friendname == "Scarecrow" )
			{
				node = getnode( "scarecrow_" + startPointName + "_start", "targetname" );
				ally forceTeleport( node.origin, node.angles );
			}
		}
		else
		{
			ally delete();
		}
	}
}

house_perimeter_jeepguards()
{
	array_spawn_function_noteworthy( "perimeter_guard", ::house_perimeter_jeepguards_init );
}

house_perimeter_jeepguards_init()
{
	level.perimeter_jeepguards++;
	
	self thread house_perimeter_jeepguards_deathmonitor();
}

house_perimeter_jeepguards_deathmonitor()
{
	self waittill ( "death" );
	
	level.perimeter_jeepguards--;
	
	if( !level.perimeter_jeepguards )
	{
		flag_set( "house_perimeter_softened" );
	}
}

/*==========================================

BOUNCING BETTY SEQUENCE

==========================================*/

bouncing_betty_slow_mo()
{	
	thread bouncing_betty_activate();
	
	// don't slomo the mission critical speech
	SoundSetTimeScaleFactor( "Mission", 0 );
	SoundSetTimeScaleFactor( "Shellshock", 0 );
	SoundSetTimeScaleFactor( "Voice", 0 );
	SoundSetTimeScaleFactor( "Menu", 0 );
	SoundSetTimeScaleFactor( "Effects1", 0.8 );
	SoundSetTimeScaleFactor( "Effects2", 0.8 );
	SoundSetTimeScaleFactor( "Announcer", 0 );
	
	slomoLerpTime_in = 2;		//1.5
	slomoLerpTime_out = 0.65;	//0.65
	slomobreachplayerspeed = 0.1;	//0.1
	slomoSpeed = 0.3;	//0.25
	slomoDuration = 10;	//24
	
	//level.player thread play_sound_on_entity( "mine_betty_spin" );
	
	music_stop();
	
	slowmo_start();
	slowmo_setspeed_slow( slomoSpeed );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
	
	flag_set( "deploy_rpg_ambush" );
	
	level.player SetMoveSpeedScale( slomobreachplayerspeed );
	
	wait slomoDuration * slomoSpeed;
	
	level.player thread play_sound_on_entity( "mine_betty_spin_slomo" );
	
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();
	slowmo_end();
	level.player SetMoveSpeedScale( 1.0 );
	
	
	flag_set( "slow_motion_ambush_done" );
}

playerFovGroundSpot( specialPlayerCase )
{
	angles = level.player getplayerangles();
	
	angles = ( 0, angles[ 1 ], 0 );	//only use yaw component
	
	forward = anglestoforward( angles );
	right = anglestoright( angles );
	left = right * ( -1 );
	
	mineOrg = level.player.origin + forward * 96; //96 units ahead of player
	
	if( isdefined( specialPlayerCase ) )
	{
		startPoint = level.player.origin + ( 0, 0, 64 );
		
		//head top traces
		
		endPointForward = level.player.origin + forward * 128 + ( 0, 0, 64 );
		//Print3d( endPointForward, "x1", ( 0, 0, 1 ), 1, 1, 15000 );
		
		endPointRight = endPointForward + right * 16;
		//Print3d( endPointRight, "r1", ( 0, 0, 1 ), 1, 1, 15000 );
		
		endPointLeft = endPointForward + left * 16;
		//Print3d( endPointLeft, "l1", ( 0, 0, 1 ), 1, 1, 15000 );
		
		//waist high traces
		
		endPointMidForward = level.player.origin + forward * 128 + ( 0, 0, 28 );
		//Print3d( endPointMidForward, "x2", ( 1, 1, 0 ), 1, 1, 15000 );
		
		endPointMidRight = endPointMidForward + right * 16;
		//Print3d( endPointMidRight, "r2", ( 1, 1, 1 ), 1, 1, 15000 );
		
		endPointMidLeft = endPointMidForward + left * 16;
		//Print3d( endPointMidLeft, "l2", ( 1, 1, 1 ), 1, 1, 15000 );
		
		//low blocker traces
		
		//endPointLowForward = level.player.origin + forward * 128 + ( 0, 0, 2 );
		//Print3d( endPointLowForward, "x3", ( 1, 0, 1 ), 1, 1, 15000 );
		
		//endPointLowRight = endPointLowForward + right * 16;
		//Print3d( endPointLowRight, "r3", ( 1, 0, 1 ), 1, 1, 15000 );
		
		//endPointLowLeft = endPointLowForward + left * 16;
		//Print3d( endPointLowLeft, "l3", ( 1, 0, 1 ), 1, 1, 15000 );
		
		test1 = BulletTracePassed( startPoint, endPointForward, true, level.player );
		test2 = BulletTracePassed( startPoint, endPointRight, true, level.player );
		test3 = BulletTracePassed( startPoint, endPointLeft, true, level.player );
		
		test4 = BulletTracePassed( startPoint, endPointMidForward, true, level.player );
		test5 = BulletTracePassed( startPoint, endPointMidRight, true, level.player );
		test6 = BulletTracePassed( startPoint, endPointMidLeft, true, level.player );
		
		//test7 = BulletTracePassed( startPoint, endPointLowForward, true, level.player );
		//test8 = BulletTracePassed( startPoint, endPointLowRight, true, level.player );
		//test9 = BulletTracePassed( startPoint, endPointLowLeft, true, level.player );
		
		if( test1 && test2 && test3 && test4 && test5 && test6 )
		{
			mineOrg = drop_to_ground( mineOrg, 200, -200 );
			return( mineOrg );
		}
		else
		{
			alts = getentarray( "alternate_bb_location", "targetname" );
			
			dist = 128;
			useableLoc = false;
			validLocFound = false;
			
			foreach( alt in alts )
			{
				newdist = length( level.player.origin - alt.origin );
				
				eyePos = level.player GetEye();
				//success = SightTracePassed( eyePos, alt.origin + ( 0, 0, 6 ), true, level.player );
				success = player_can_see_origin( alt.origin + ( 0, 0, 6 ) );
				
				if( success )
				{
					useableLoc = true;
				}
				else
				{
					useableLoc = false;
				}
				
				if( newdist < dist && newdist > 48 && useableLoc )
				{
					validLocFound = true;
					mineOrg = drop_to_ground( alt.origin, 200, -200 );			
					return( mineOrg );
				}
			}
			
			if( !validLocFound )
			{
				newdist = undefined;
				olddist = 100000;
				bestOrg = undefined;
				
				foreach( alt in alts )
				{
					newdist = length( level.player.origin - alt.origin );
					
					if( newdist < olddist )
					{
						olddist = newdist;
						bestOrg = alt;
					}
				}
				
				mineOrg = drop_to_ground( bestOrg.origin, 200, -200 );
				return( mineOrg );
			}
		}
	}
	else
	{
		mineOrg = drop_to_ground( mineOrg, 200, -200 );
		return( mineOrg );
	}
}

bouncing_betty_activate()
{
	wait 0.2;
	
	mines = getentarray( "bouncing_betty", "targetname" );
	
	foreach ( mine in mines )
	{
		mine thread bouncing_betty_fx( undefined, undefined, undefined );
		wait randomfloatrange( 0.15, 0.2 );
	}
	
	//launch player's special personal mine
	
	mineOrg = playerFovGroundSpot( "specialPlayerCase" );
	
	if( isdefined( mineOrg ) )
	{
		thread bouncing_betty_throwplayer( mineOrg );
		
		//playerMine = spawn( "script_origin", level.player.origin + ( 32, -72, 0 ) );
		playerMine = spawn( "script_origin", mineOrg );
		playerMine thread bouncing_betty_fx( 1, undefined );
	}
	else
	{
		thread bouncing_betty_throwplayer( level.player.origin );
		
		playerMine = spawn( "script_origin", level.player.origin );
		playerMine thread bouncing_betty_fx( 1, undefined, 1 );
	}
	
	thread bouncing_betty_hintprint();
	
	while( level.bouncing_betty_clicks < mines.size )
	{
		wait 0.05;
	}
	
	level.player allowSprint( false );
	
	flag_set( "ambush_shouted" );
	
	wait 0.35;
	
	//"AMBUUUSH!!!"
	level.ghost dialogue_queue( "est_gst_ambush" );
	
	wait 1;
	
	flag_set( "bouncing_betty_done" );
}

bouncing_betty_hintprint()
{
	if( level.console )
	{
		wait 0.6;
	}
	else
	{
		wait 0.1;
		
		//PC Prone Key Config Handling - there are three different bindable controls for going prone on PC
		
		if( is_command_bound( "toggleprone" ) )
		{
			//"toggleprone" (press prone once, stays prone)
			//Msg: "Press^3 [{toggleprone}] ^7to evade the landmine!"
			level.player thread display_hint( "mineavoid_hint_toggle" );
		}
		else 
		if( is_command_bound( "+prone" ) )
		{
			//"+prone" (press and hold to go prone, gets up as soon as key is released)
			//Msg: "Press and hold down^3 [{+prone}] ^7to evade the landmine!"
			level.player thread display_hint( "mineavoid_hint_holddown" );
		}
		else
		if( is_command_bound( "+stance" ) )
		{
			//"+stance" (press and hold to go prone)
			//Msg: "Press and hold^3 [{+stance}] ^7to evade the landmine!"
			level.player thread display_hint( "mineavoid_hint" );
		}
	}
}

bouncing_betty_fx( specialPlayerCase, gameplayOn, skipFX )
{
	playFX( getfx( "bouncing_betty_launch" ), self.origin );
	self playsound( "mine_betty_click" );
	self playsound( "mine_betty_spin" );
	
	gameplay = isdefined( gameplayOn );
	skipFX = isdefined( skipFX );
	
	if( !gameplay )
	{
		level.bouncing_betty_clicks++;
	}
	else
	{
		level.canSave = false;
		level.activeGameplayMines++;
	}
	
	spinner = undefined;
	explosion_org = undefined;
	
	if( !skipFX )
	{
		spinner = spawn( "script_model", self.origin );
		spinner setmodel( "projectile_bouncing_betty_grenade" );
		spinner.animname = "bouncingbetty";
		spinner useAnimTree( level.scr_animtree[ "bouncingbetty" ] );
		
		spinner thread play_spinner_fx();
		
		self anim_single_solo( spinner, "bouncing_betty_detonate" );
		
		explosion_org = spinner.origin;
		
		if( !gameplay )
		{
			flag_wait( "ambush_shouted" );
		}
		
		spinner playsound( "grenade_explode_metal" );
	}
	
	if( isdefined( specialPlayerCase ) )
	{	
		if( !skipFX )
		{
			playFXontag( getfx( "bouncing_betty_explosion" ), spinner, "tag_fx" );
		}
		else
		{
			wait 2;
		}
		
		friendlies = getaiarray( "allies" );
		foreach( guy in friendlies )
		{
			if( !isdefined( guy.name ) )
				continue;
				
			if( guy.name != "Archer" && guy.name != "Toad" )
			{
				//knockdown the guy
				guy delaythread( randomfloat( 0.15 ), ::anim_generic, guy, "exposed_crouch_extendedpainA" );
			}
		}
	
		level.player PlayRumbleOnEntity( "artillery_rumble" );
		
		setplayerignoreradiusdamage( false );
			
		if( level.player getstance() == "prone" )
		{
			flag_set( "mine_throw_player" );
		}
		else
		{
			wait 0.05;
			level.player kill();
		}
	}
	else
	{	
		playFXontag( getfx( "bouncing_betty_explosion" ), spinner, "tag_fx" );
		
		spinner hide();
		
		if( gameplay )
		{
			dist = length( level.player.origin - self.origin );

			level.player PlayRumbleOnEntity( "artillery_rumble" );
			
			if( dist <= self.radius )
			{
				if( level.player getstance() == "prone" )
				{
					SetPlayerIgnoreRadiusDamage( true );
				
					//thread bouncing_betty_gameplay_fake_damage();
					thread bouncing_betty_gameplay_real_damage( explosion_org );
				
					rightFovCheck = within_fov( level.player.origin, level.player.angles + (0 , -95, 0 ), self.origin, cos( 180 ) );
					leftFovCheck = within_fov( level.player.origin, level.player.angles + (0 , 95, 0 ), self.origin, cos( 180 ) );
					centerFovCheck = within_fov( level.player.origin, level.player.angles, self.origin, cos( 10 ) );
					
					if( rightFovCheck )
					{
						level.player thread maps\_gameskill::grenade_dirt_on_screen( "right" );	
					}
					
					if( leftFovCheck )
					{
						level.player thread maps\_gameskill::grenade_dirt_on_screen( "left" );
					}
					
					if( centerFovCheck )
					{
						level.player thread maps\_gameskill::grenade_dirt_on_screen( "bottom_b" );
					}
				
					thread bouncing_betty_gameplay_shock();
				}
				else
				{
					wait 0.2;
					
					if( isalive( level.player ) )
					{
						thread bouncing_betty_gameplay_real_damage( explosion_org );
						
						level notify( "new_quote_string" );
						
						level.player kill();
						
						thread bouncing_betty_deathquote();
					}
				}
			}
		}
		else
		{
			SetPlayerIgnoreRadiusDamage( true );
			radiusdamage( explosion_org, self.radius, 1000, 20 );
		}
		
		SetPlayerIgnoreRadiusDamage( false );
	}
	
	wait 0.2;
	
	if( isdefined( spinner ) )
		spinner delete();
	
	wait 0.5;
	
	if( gameplay )
	{
		level.activeGameplayMines--;
		level notify ( "gameplay_mine_done" );
	}
}

bb_autosave()
{
	trig = getent( "forestfight_start_redshirts", "targetname" );
	trig waittill ( "trigger" );
	
	autosave_by_name( "bb_autosave" );
}

bouncing_betty_deathquote()
{
	setDvar( "ui_deadquote", "" );
	
	textOverlay = level.player maps\_hud_util::createClientFontString( "default", 1.75 );
	textOverlay.color = ( 1, 1, 1 );
	
	textOverlay setText( &"ESTATE_REMIND_PRONE_LINE1" );	
	
	textOverlay.x = 0;
	textOverlay.y = -30;
	textOverlay.alignX = "center";
	textOverlay.alignY = "middle";
	textOverlay.horzAlign = "center";
	textOverlay.vertAlign = "middle";
	textOverlay.foreground = true;
	textOverlay.alpha = 0;
	textOverlay fadeOverTime( 1 );
	textOverlay.alpha = 1;
	
	textOverlay2 = level.player maps\_hud_util::createClientFontString( "default", 1.75 );
	textOverlay2.color = ( 1, 1, 1 );
	
	if( level.console )
	{
		textOverlay2 setText( &"ESTATE_REMIND_PRONE_LINE2" );
	}
	else
	{
		//PC Prone Control Handling
		
		if( is_command_bound( "toggleprone" ) )
		{
			//"Press ^3[{toggleprone}]^7 to evade them."
			textOverlay2 setText( &"ESTATE_REMIND_PRONE_LINE2_TOGGLE" );
		}
		else
		if( is_command_bound( "+prone" ) )
		{
			//"Press and hold down ^3[{+prone}]^7 to evade them."
			textOverlay2 setText( &"ESTATE_REMIND_PRONE_LINE2_HOLDDOWN" );
		}
		else
		if( is_command_bound( "+stance" ) )
		{
			textOverlay2 setText( &"ESTATE_REMIND_PRONE_LINE2" );
		}     
	}
	
	textOverlay2.x = 0;
	textOverlay2.y = -5;
	textOverlay2.alignX = "center";
	textOverlay2.alignY = "middle";
	textOverlay2.horzAlign = "center";
	textOverlay2.vertAlign = "middle";
	textOverlay2.foreground = true;
	textOverlay2.alpha = 0;
	textOverlay2 fadeOverTime( 1 );
	textOverlay2.alpha = 1;
}

bouncing_betty_gameplay_shock()
{
	level.player shellshock( "estate_bouncingbetty", 3.5 );
	earthquake( 1, 0.8, level.player.origin, 2000 );
	
	level.player.ignoreme = true;
	wait 3.5;
	level.player.ignoreme = false;
}

bouncing_betty_gameplay_fake_damage()
{
	level.player dodamage( randomfloatrange( 30, 35 ), self.origin );
}

bouncing_betty_gameplay_real_damage( mineOrg )
{
	radiusdamage( mineOrg, self.radius * 2, 200, 20 );
}

bouncing_betty_gameplay_saveguard()
{
	while( 1 )
	{	
		level waittill ( "gameplay_mine_done" );
		
		if( !level.activeGameplayMines )
		{
			level.canSave = true;
		}
	}
}

bouncing_betty_throwplayer( mineOrg )
{
	if( !flag( "ambush_complete" ) )
	{
		flag_wait( "mine_throw_player" );	
	}
	
	level.player freezeControls( true );
		
	vec = ( level.player.origin + ( 0, 0, 40) ) - mineOrg;	//vector from mine to player's upper body
	baseThrust = vectornormalize( vec );
	boost = 2000;	//1800
	
	thread bouncing_betty_shellshock();
	thread bouncing_betty_stances();
	thread ambush_fake_rpg_barrage();
	
	touchingVol = false;
	
	antiSliderVol = getent( "no_sliding_allowed", "targetname" );
	if( !( level.player istouching( antiSliderVol ) ) )
	{
		touchingVol = true;
		level.player thread BeginSliding( baseThrust * boost, 10, 0.25 );
	}
	
	wait 0.5;
	
	if( touchingVol )
		level.player thread endsliding();
	
	flag_set( "bouncing_betty_player_released" );
	
	if( touchingVol )
		wait 3.5;
	
	level.player freezeControls( false );
	
	flag_set( "spawn_first_ghillies" );
}

bouncing_betty_shellshock()
{
	level.player shellshock( "estate_bouncingbetty", 10 );
	
	wait 0.1;
	
	earthquake( 3, 0.2, level.player.origin, 2000 );
	
	wait 0.2;
	
	earthquake( 1, 1, level.player.origin, 2000 );
	wait 1;
	
	//Taargets, left side, left side!!
	level.ghost thread dialogue_queue( "est_gst_targetsleftside" );
	
	earthquake( 0.5, 0.5, level.player.origin, 2000 );
	wait 0.5;
	
	flag_wait( "ambushed_player_back_to_normal" );
	
	level.player AllowCrouch( true );
	level.player AllowStand( true );
	
	level.player allowSprint( true );

	wait 3;
	
	//"AMBUUUSH!!!"
	level.ozone dialogue_queue( "est_tf1_ambush" );
	
	flag_set( "start_ambush_music" );
	
	wait 2;
	
	//"AMBUUUSH!!!"
	level.scarecrow dialogue_queue( "est_tf2_ambush" );
	
	wait 1;
	
	flag_set( "deploy_mortar_attack" );
}

bouncing_betty_stances()
{
	flag_wait( "bouncing_betty_player_released" );
	
	level.player AllowCrouch( false );
	level.player AllowStand( false );
	level.player AllowProne( true );
	
	wait 5;
	
	flag_set( "ambushed_player_back_to_normal" );
}

play_spinner_fx()
{
	self endon( "death");
	timer = gettime() + 1000;
	while ( gettime() < timer )
	{
		wait .05;
		playFXontag( getfx( "bouncing_betty_swirl" ), self, "tag_fx_spin1" );
		playFXontag( getfx( "bouncing_betty_swirl" ), self, "tag_fx_spin3" );
		wait .05;
		playFXontag( getfx( "bouncing_betty_swirl" ), self, "tag_fx_spin2" );
		playFXontag( getfx( "bouncing_betty_swirl" ), self, "tag_fx_spin4" );
	}
}

ambush_fake_rpg_barrage()
{
	fakeRpgs = getstructarray( "fake_rpg", "targetname" );
	
	foreach( index, fakeRpg in fakeRpgs )
	{
		repulsor = Missile_CreateRepulsorEnt( level.player, 1000, 512 );
		fakeRpgTarget = getstruct( fakeRpg.target, "targetname" );
		
		MagicBullet( "rpg", fakeRpg.origin, fakeRpgTarget.origin );
		
		wait randomfloatrange( 0.8, 1.4 );
	}
}

/*==========================================

BOUNCING BETTY GAMEPLAY EDITION

==========================================*/

bouncing_betty_gameplay_init()
{
	mines = getentarray( "bouncing_betty_gameplay", "targetname" );
	
	foreach( mine in mines )
	{
		mine thread bouncing_betty_gameplay();
	}
}

bouncing_betty_gameplay()
{
	level endon ( "house_exterior_has_been_breached" );
	
	mine = spawn( "script_origin", self.origin );
	mine.radius = self.radius;
	mine.origin = self.origin;
	
	detonated = false;
	
	requiredStareTime = 0.15;
	fov_angle = 5;
	
	while( !detonated )
	{
		self waittill ( "trigger" );
		
		fovCheckTime = 0;
	
		fovCheck = within_fov( level.player.origin, level.player.angles, mine.origin, cos( fov_angle ) );
	
		while( fovCheck )
		{
			if( fovCheckTime >= requiredStareTime )
			{
				mine thread bouncing_betty_fx( undefined, 1 );
				detonated = true;
				level notify ( "gameplay_mine_deployed" );
				break;
			}

			fovCheck = within_fov( level.player.origin, level.player.angles, mine.origin, cos( fov_angle ) );
			fovCheckTime = fovCheckTime + 0.05;
			wait 0.05;
		}
	}
}

/*==========================================

FOREST SMOKE SCREENS

==========================================*/

forest_smokepot1()
{
	level endon ( "approaching_house" );
	level endon ( "stop_smokescreens" );
	
	while( 1 )
	{
		flag_wait( "smokepot1" );
		
		flag_clear( "smokepot2" );
		flag_clear( "smokepot3" );
		
		smoke_pots = getentarray( "smokepot1", "targetname" );
		smoke_pots = array_randomize ( smoke_pots );
		
		forest_smokeloop( "smokepot1", smoke_pots );
	}
}

forest_smokepot2()
{
	level endon ( "approaching_house" );
	level endon ( "stop_smokescreens" );
	
	while( 1 )
	{
		flag_wait( "smokepot2" );
		
		flag_clear( "smokepot1" );
		flag_clear( "smokepot3" );
		
		smoke_pots = getentarray( "smokepot2", "targetname" );
		smoke_pots = array_randomize ( smoke_pots );
		
		forest_smokeloop( "smokepot2", smoke_pots );
	}
}

forest_smokepot3()
{
	level endon ( "approaching_house" );
	level endon ( "stop_smokescreens" );
	
	while( 1 )
	{
		flag_wait( "smokepot3" );
		
		flag_clear( "smokepot1" );
		flag_clear( "smokepot2" );
		
		smoke_pots = getentarray( "smokepot3", "targetname" );
		smoke_pots = array_randomize ( smoke_pots );
		
		forest_smokeloop( "smokepot3", smoke_pots );
	}
}

forest_smokeloop( smokeName, smoke_pots )
{
	level endon ( "approaching_house" );
	level endon ( "stop_smokescreens" );
	
	while( flag( smokeName) )
	{
		foreach ( smoke_pot in smoke_pots )
		{
			wait 6;	//originally 5
			
			if( level.activeSmokePots <= level.activeSmokePotLimit )				
			{
				smoke_pot thread smokepot();
				level.activeSmokePots++;
				thread forest_smokepot_timer();
			}	
		}
	
		wait 18;	//originally 15
	}	
}

forest_smokepot_timer()
{
	wait level.smokeTimeOut;
	
	level.activeSmokePots--;
}

/*==========================================

SPAWNING AND NAV

==========================================*/

ghillie_spawn( ghillie_name )
{
	spawners = getentarray( ghillie_name, "targetname" );
	
	assertEX( isdefined( ghillie_name), "ghillie_spawn called without a ghillie_name" );
	
	if ( ghillie_name == "early_sniper" )
	{
		array_spawn_function_targetname( ghillie_name, ::forest_fight_ai_cleanup );
	}
	
	array_spawn_function_targetname( ghillie_name, ::ghillie_init );
	array_thread( spawners, ::spawn_ai );
}

ghillie_init()
{
	self start_in_prone_and_standup();
}

prowler_spawn()
{	
    array_spawn_function_targetname( "prowler1", ::prowler_init_1 );
    array_spawn_function_targetname( "prowler1", ::forest_fight_ai_cleanup );
    array_spawn_function_targetname( "prowler2", ::prowler_init_2 );
    array_spawn_function_targetname( "prowler2", ::forest_fight_ai_cleanup );
    array_spawn_function_targetname( "prowler3", ::prowler_init_3 );
    array_spawn_function_targetname( "prowler3", ::forest_fight_ai_cleanup );
    
    spawners = [];
    spawners = getentarray( "prowler1", "targetname" );
    array_thread( spawners, ::spawn_ai );  
    
    spawners = [];
    spawners = getentarray( "prowler2", "targetname" );
    array_thread( spawners, ::spawn_ai );  
    
    spawners = [];
    spawners = getentarray( "prowler3", "targetname" );
    array_thread( spawners, ::spawn_ai );  
}

forest_fight_ai_cleanup()
{
	self endon ( "death" );
	
	flag_wait( "forestfight_littlebird_1" );
	
	wait randomfloatrange( 1.5, 4.7 );
	
	self.goalradius = 2000;
	self.forcegoal = 1;
	
	testnumber = randomint( 100 );
	
	if( testnumber >= 75 )
	{
		while( 1 )
		{
			self setGoalPos( level.player.origin );
			wait randomfloatrange( 5, 10 );
		}
	}
	else
	{
		node = getnode( "forestfight_cleanup_enemy_rallypoint", "targetname" );
		self setgoalnode( node );
	}
}

prowler_init_1()
{
	self thread forest_enemy_deathmonitor();
	self thread forest_enemy_groundlevel_magicsnipe_cleanup();

	self start_in_prone_and_standup();
		
    //self.disableArrivals = true;
    self.ignoresuppression = true;
    self pushplayer( true );
    
   	node = getnode( "prowler1_start", "targetname" );
    	
    nodeLoiterTime = 5;
    nodeInitRadius = 4420;
    nodeEndRadius = 2400;
    nodeClosureRate = 0.1;
    nodeClosureInterval = 5;
    earlyEndonMsg = "forestfight_littlebird_1";
    	
    self thread roaming_nodechain_nav( node, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
}

prowler_init_2()
{
	self thread forest_enemy_deathmonitor();
	self thread forest_enemy_groundlevel_magicsnipe_cleanup();
   
   	self start_in_prone_and_standup();
   
   	node = getnode( "prowler2_start", "targetname" );
	
	nodeLoiterTime = 4;
	nodeInitRadius = 3700;
	nodeEndRadius = 2200;
	nodeClosureRate = 0.1;
	nodeClosureInterval = 5;
	earlyEndonMsg = "forestfight_littlebird_1";
    	
   	self thread roaming_nodechain_nav( node, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
}
    
prowler_init_3()
{
  	node = getnode( "prowler3_start", "targetname" );
  	
  	self thread forest_enemy_deathmonitor();
  	self thread forest_enemy_groundlevel_magicsnipe_cleanup();
    	
	nodeLoiterTime = 3;
	nodeInitRadius = 4500;
	nodeEndRadius = 3400;
	nodeClosureRate = 0.08;
	nodeClosureInterval = 4;
	earlyEndonMsg = "forestfight_littlebird_1";
    	
   	self thread roaming_nodechain_nav( node, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
}

start_in_prone_and_standup()
{
	self endon ( "death" );
	self endon ( "long_death" );
	
	self.animname = "ghillie";
	self.allowdeath = 1;
	self.a.pose = "prone";
		
	wait randomfloatrange( 0, 0.2 );
	
	self thread anim_single_solo( self , "prone_2_stand_firing" );
}

forest_enemy_deathmonitor()
{
	level.forestEnemyCount++;
	
	self waittill ( "death" );
	
	level.forestEnemyCount--;
	
	if( level.forestEnemyCount < 3 )
	{
		flag_set( "stop_smokescreens" );
	}
}

forest_enemy_groundlevel_magicsnipe_cleanup()
{
	self endon ( "death" );
	
	flag_wait_any( "approaching_house", "stop_smokescreens" );
	
	wait randomfloatrange( 1.5, 2.25 );
	
	ent = getent( "futilejeep_javelin_sourcepoint1", "targetname" );
	
	self kill();
}

/******************************

SLOW-MOTION BREACHING

******************************/

house_guestroom_breach_flee()
{
	//Guys in the guestroom try to escape
	
	openDoors = getent( "recroom_open_doors", "targetname" );
	openDoors hide();
	
	level waittill ( "breaching_number_" + "4" );
	
	closedDoors = getent( "recroom_closed_doors", "targetname" );
	closedDoors delete();
	
	openDoors show();
	
	level.forced_slowmo_breach_slowdown = true;
	
	wait 5;
	
	level.forced_slowmo_breach_slowdown = undefined;
}

house_guestroom_door_remove()
{
	//for any start point after the house breaches are done
	
	openDoors = getent( "recroom_open_doors", "targetname" );
	openDoors hide();

	closedDoors = getent( "recroom_closed_doors", "targetname" );
	closedDoors delete();

	openDoors show();
}

house_armory_breach_windowtrick()
{
	window_shards = getentarray( "window_brokenglass", "targetname" );
	foreach( shard in window_shards )
	{
		shard hide();
	}
	
	level waittill ( "breaching_number_3" );
	
	wait 2;
	
	window_sightblocker = getent( "paper_window_sightblocker", "targetname" );
	window_sightblocker delete();
	
	window_newspapers = getentarray( "window_newspaper", "targetname" );
	foreach( window_newspaper in window_newspapers )
	{
		window_newspaper delete();
	}
	
	window_panes = getentarray( "window_pane", "targetname" );
	foreach( window_pane in window_panes )
	{
		window_pane delete();
	}
	
	foreach( shard in window_shards )
	{
		shard show();
	}
	
	blinds = getentarray( "window_blinds", "targetname" );
	foreach( blind in blinds )
	{
		blind delete();
	}
	
	smashers = getentarray( "window_smasher", "targetname" );
	foreach( smasher in smashers )
	{
		radiusdamage( smasher.origin, smasher.radius, 1000, 1000 );
	}
}

house_furniture_sounds()
{
	flag_wait( "furniture_moving_sounds" );
	
	level endon ( "breaching_number_" + "5" );
	
	speaker = getent( "furniture_moving_sounds_speaker", "targetname" );
	
	speaker play_sound_on_entity( "scn_estate_furniture_knock_over" );
	
	speaker play_sound_on_entity( "scn_estate_furniture_slide" );
	
	speaker play_sound_on_entity( "scn_estate_furniture_slide" );
	
	wait 3;
	
	speaker play_sound_on_entity( "scn_estate_furniture_slide" );
	
	wait 4;
	
	speaker play_sound_on_entity( "scn_estate_furniture_slide" );
	
	wait 3; 
	
	speaker play_sound_on_entity( "scn_estate_furniture_slide" );
	
	wait 5;
	
	speaker play_sound_on_entity( "scn_estate_furniture_slide" );
}

house_extra_breachguys()
{
	//These are guys that spawn in on slow-motion breaches without a special animation, and do normal cool-looking AI behavior
	
	assertEX( isdefined( self.script_slowmo_breach ), "breach_normalguy in house must have a script_slowmo_breach keypair" );
	
	level waittill ( "breaching_number_" + self.script_slowmo_breach );
	
	wait 2;
		
    self stalingradSpawn();
}

house_extra_breachguys_init()
{
	self endon ( "death" );
	
	assertEX( isdefined( self.script_namenumber), "Script_namenumber with floorname is missing on this normalguy." );
	
	self.pathrandompercent = 0;
	self.ignoresuppression = true;
	self.grenadeammo = 0;
	
	if( isdefined( self.script_delay ) )
	{
		self.goalradius = 128;
		wait self.script_delay;
		self.goalradius = 1000;
	}
	
	self thread house_normalguy_accuracy();
		
	if( !isdefined( self.script_noteworthy ) )
		return;
	
	if( self.script_noteworthy == "hunter" )
	{
		wait randomfloatrange( 5, 10 );
		self.goalradius = 10000;
	}
		
	if( self.script_noteworthy == "ambusher" )
	{
		self.combatmode = "ambush";	
	}
}

house_normalguy_accuracy()
{
	self endon ( "death" );
	
	self.baseAccuracy = 0;	
	
	wait 3;
	
	self.baseAccuracy = 1;
}

//*************************************************
// EXTERIOR BREACH SPECIFIC EXTRA GUY SPAWNS
//*************************************************

//These only spawn under very specific circumstances where it would be plausible,
//taking into consideration where the player and friendlies may already have gone.
//They are controlled by triggering by script_flag_set trigs in the main_house prefab
//They are unilaterally canceled when the armory gets breached because being able to 
//see into every room complicates the spawn plausibility situation.

//trigger for diningroom spawners "breach0_diningroom_spawntrig": these guys emerge from the dining room and rush into the kitchen


//0. (DONE) make sure the triggers only work for the correct breachnum with a script_flag_true "breaching_number_0"
//1. (DONE) run tally on extraguys' script_battleplan
//			- add to floorpops (floorpop ++ 1 time per spawner here for theoretical presence)
//2. (DONE) run spawnfuncs on extraguys (ends if 3 runs)
//			- when spawned, add to floorpops (floorpop ++ 1 time here) 
//				- also notify to terminate the cancel thread for the battleplan
//			- on death, subtract 2 from floorpops (floorpop -- 1 time here, --1 for theoretical presence)
//3. (DONE) run a cancel thread for each battleplan (ends if 2 runs)
//			- if cancel flag gets set
//			- flag_trues on triggers will automatically prevent spawntriggers from triggering (DONE)
//			- tally spawners for this battleplan per floortype and subtract size of each array from each floorpops (floorpop --1 per spawner for theoretical presence)

house_extras_tally( battlePlanName, waitName )
{
	//Because they may or may not spawn, we pre-emptively add potential spawning Extras to the total count for each floor
	
	level waittill ( waitName );
	
	//spawners = GetSpawnerArray();
	
	spawners = getentarray( "breach_extraguy", "targetname" );
	
	foreach( spawner in spawners )
	{
		if( !isdefined( spawner.script_battleplan ) )
			continue;
			
		if( spawner.script_battleplan == battlePlanName )
		{
			assertEX( isdefined( spawner.script_namenumber ), "spawner for extras in house didn't have a script_namenumber for floortype" );
			
			if( spawner.script_namenumber == "mainfloor" )
			{
				level.mainfloorPop++;
			}
			
			if( spawner.script_namenumber == "topfloor" )
			{
				level.topfloorPop++;
			}
			
			if( spawner.script_namenumber == "basement" )
			{
				level.basementPop++;
			}		
		}
	}
}

house_extras_stopcancel()
{
	//spawnfunc for the extraguys
	//if the extraguy spawns, send a notify that terminates the thread that would artificially decrement the battleplan's spawners from floorpop
	
	assertEX( isdefined( self.script_battleplan ), "script_battleplan not specified on Extra spawner in house" );
	
	endonMsg = self.script_battleplan;
	
	level notify ( endonMsg );
}

house_extras_cancel_and_killswitch( endonMsg, activeCancelName, unlockName )
{
	//shuts down an active Extras spawner system that is still ready to cancel from standby mode
	//also cancels this Extra spawner system because a non-matching exterior breach was done
	
	level endon ( endonMsg );
	
	flag_wait( unlockName );
	
	flag_wait( "armory_breached" );
	flag_set( activeCancelName );
}

house_extras_cancel_floorpop_monitor( endonMsg, activeCancelName, unlockName )
{
	//if canceled, this reduces the floorpops associated with the spawners on this battleplan
	
	assertEX( isdefined( endonMsg ), "No endonMsg was passed into this function." );
	assertEX( isdefined( activeCancelName ), "No activeCancelName was passed into this function." );
	assertEX( isdefined( unlockName ), "No unlockName was passed into this function. This is the flag that is set by an exterior breach. e.g. foyer_breached_first" );
	
	level endon ( endonMsg );	//ends on a successful spawning
	
	thread house_extras_cancel_and_killswitch( endonMsg, activeCancelName, unlockName );
	
	flag_wait( activeCancelName );
	
	spawners = getspawnerarray();
	
	foreach( spawner in spawners )
	{
		if( !isdefined( spawner.script_battleplan ) )
			continue;
			
		if( spawner.script_battleplan == endonMsg )
		{
			assertEX( isdefined( spawner.script_namenumber), "Missing a script_namenumber on an Extra spawner in house." );
			
			if( spawner.script_namenumber == "mainfloor" )
			{
				//level.mainfloorPop--;
				level notify ( "mainfloor_enemy_killed" );
			}
			
			if( spawner.script_namenumber == "topfloor" )
			{
				level notify ( "topfloor_enemy_killed" );
				//level.topfloorPop--;
			}
			
			if( spawner.script_namenumber == "basement" )
			{
				level notify ( "basement_enemy_killed" );
				//level.basementPop--;
			}
		}
		
		wait 0.05;
	}
}

house_extras_spawncontrol( spawntrigname, customEndonMsg, unlockMsg, battleplan )
{
	assertEX( isdefined( spawntrigname ), "Missing a spawntrigname on an Extra spawntrig." );
	assertEX( isdefined( unlockMsg ), "Missing an unlockMsg on an Extra spawntrig." );
	assertEX( isdefined( battleplan ), "Missing a battleplan on an Extra spawntrig." );
	
	//*NOTE* It is assumed there is only one spawntrig for each Extras spawn setup
	
	trigs = getentarray( spawntrigname, "targetname" );
	
	assertEX( trigs.size, "No triggers exist to make the Extra guys spawn on this battleplan!" );
	assertEX( trigs.size == 1, "There should only be one trigger per Extra guys battleplan, make it a big compound one if necessary." );
	
	trigs = undefined;
	
	level endon ( "house_interior_breaches_done" );
	
	if( isdefined( customEndonMsg ) )
	{
		level endon ( customEndonMsg );
	}
	
	level waittill ( unlockMsg );
	
	trig = getent( spawntrigname, "targetname" );
	trig waittill ( "trigger" );
	
	thread house_extras_spawn( battleplan );
}

house_extras_spawn( battlePlan )
{
	assertEX( isdefined( battlePlan ), "script_battleplan for the group to be spawned needs to be passed into this function" );
	
	spawners = [];
	spawners = getspawnerarray();
	
	guys = [];
	
	foreach( spawner in spawners )
	{
		if( !isdefined( spawner.script_battleplan ) )
			continue;
		
		if( spawner.script_battleplan == battlePlan )
		{
			guys[ guys.size ] = spawner;
		}
	}
	
	array_thread( guys, ::spawn_ai );  
}

house_extras_bathroom_screamingguy_setup()
{
	spawners = getentarray( "breach_extraguy", "targetname" );
	foreach( spawner in spawners )
	{
		if( !isdefined( spawner.script_battleplan ) )
			continue;
			
		if( spawner.script_battleplan == "breach0_bathroomrush" )
		{
			spawner thread add_spawn_function( ::house_extras_bathroom_screamingguy );
		}
	}
}

house_extras_bathroom_screamingguy()
{
	//aaaaAAAAA (enemy charge)
	self thread play_sound_on_entity( "est_ru1_attack" );
}

//******************************************************
// HOUSE EXTERIOR BREACH BASIC NOTIFICATIONS
//******************************************************

house_extras_breach_mainfloor()
{
	level waittill ( "breaching_number_0" );
	
	flag_set( "foyer_breached_first" );
}

house_extras_breach_kitchen()
{
	level waittill ( "breaching_number_1" );
	
	flag_set( "kitchen_breached_first" );
}

house_extras_breach_basement()
{
	level waittill ( "breaching_number_2" );
	
	flag_set( "basement_breached_first" );
}

house_exterior_breach_awareness()
{
	level waittill_any( "breaching_number_0", "breaching_number_1", "breaching_number_2" );
	
	//autosave_by_name( "exterior_breach_save" );
	
	wait 2.5;
	
	allies = getaiarray( "allies" );
	enemies = getaiarray( "axis" );
	foreach( enemy in enemies )
	{
		level.scarecrow getenemyinfo( enemy );
		level.ozone getenemyinfo( enemy );
		
		foreach( ally in allies )
		{
			enemy getenemyinfo( ally );
			enemy getenemyinfo( level.player );	
		}
	}
}

//******************************************************
// HOUSE FLOOR POP MONITORING FOR DIALOGUE TRIGGERING
//******************************************************

house_floorpop_deathmonitor_init( extraGuy )
{	
	assertEX( isdefined( self.script_namenumber), "House spawner guy missing a script_namenumber" );
	
	//don't add any of the interior breach guys (3, 4, 5), they are preemptively included in the count because they spawn after the exterior breaches

	if( self.script_namenumber == "mainfloor" )
    {
    	level.mainfloorPop++;
    	self thread house_mainfloor_deathmonitor( extraGuy );
    }
    
    if( self.script_namenumber == "topfloor" )
    {
    	if( isdefined( self.script_slowmo_breach ) )
    	{
	    	if( self.script_slowmo_breach != 5 )
	    	{
	    		level.topfloorPop++;
	    	}
    	}
	    else
	    {
	    	level.topfloorPop++;
	    }	
	    
    	self thread house_topfloor_deathmonitor( extraGuy );
    }
    
    if( self.script_namenumber == "basement" )
    {
    	if( isdefined( self.script_slowmo_breach ) )
    	{
	    	if( self.script_slowmo_breach != 3 && self.script_slowmo_breach != 4 )
	    	{
	    		level.basementPop++;
	    	}
    	}
    	else
    	{
    		level.basementPop++;
    	}
	    	
    	self thread house_basement_deathmonitor( extraGuy );
    }
}

house_mainfloor_deathmonitor( extraGuy )
{
	self waittill ( "death" );
	level notify ( "mainfloor_enemy_killed" );
	
	wait 0.05;
	
	if( isdefined( extraGuy ) )
	{
		level notify ( "mainfloor_enemy_killed" );
	}
}

house_topfloor_deathmonitor( extraGuy )
{
	self waittill ( "death" );
	level notify ( "topfloor_enemy_killed" );
	
	wait 0.05;
	
	if( isdefined( extraGuy ) )
	{
		level notify ( "topfloor_enemy_killed" );
	}
}

house_basement_deathmonitor( extraGuy )
{
	self waittill ( "death" );	
	level notify ( "basement_enemy_killed" );
	
	wait 0.05;
	
	if( isdefined( extraGuy ) )
	{
		level notify ( "basement_enemy_killed" );
	}
}

house_mainfloor_cleared()
{
	//wait until the first breach begins
	
	flag_wait( "house_exterior_has_been_breached" );
	
	wait 2.1;
	
	while( level.mainfloorPop > 0 )
	{
		level waittill ( "mainfloor_enemy_killed" );
		level.mainfloorPop--;
	}
	
	flag_set( "mainfloor_cleared" );
}

house_topfloor_cleared()
{
	//wait until the first breach begins
	
	flag_wait( "house_exterior_has_been_breached" );
	
	while( level.topfloorPop > 0 )
	{
		level waittill ( "topfloor_enemy_killed" );
		level.topfloorPop--;
	}
	
	flag_set( "topfloor_cleared" );
}

house_basement_cleared()
{
	//wait until the first breach begins
	
	flag_wait( "house_exterior_has_been_breached" );
	
	while( level.basementPop > 0 )
	{
		level waittill ( "basement_enemy_killed" );
		level.basementPop--;
	}
	
	flag_set( "basement_cleared" );
}

//*************************************************
// HOUSE CLEARING DIALOGUE
//*************************************************

house_mainfloor_cleared_dialogue()
{
	level endon ( "house_interior_breaches_done" );
	
	flag_wait( "mainfloor_cleared" );
	
	/*
	//Main floor clear!
	radio_dialogue( "est_scr_mainfloor" );

	//Copy that, main floor clear!
	radio_dialogue( "est_gst_mainfloor" );
	*/
	
	flag_set( "mainfloor_cleared_confirmed" );
}

house_topfloor_cleared_dialogue()
{
	//flag_wait( "mainfloor_cleared" );
	
	//if mainfloor is cleared
	//teleport scarecrow to the node upstairs to confirm clearance
	//then have him proceed downstairs automatically back to his node
	
	flag_wait( "topfloor_breached" );
	
	level.scarecrow disable_ai_color();
	//node = getnode( "ozone_housebriefing_start", "targetname" );
	node = getnode( "scarecrow_teleport_closer", "targetname" );
	level.scarecrow forceTeleport( node.origin, node.angles );
	level.scarecrow.goalradius = 32;
	//level.scarecrow setgoalnode( node );
	
	level.scarecrow.attackeraccuracy = 0;
	level.scarecrow.ignorerandombulletdamage = 1;
	
	node = getnode( "house_teleport_scarecrow", "targetname" );
	level.scarecrow setgoalnode( node );

	flag_wait( "topfloor_cleared" );
	
	flag_set( "scripted_dialogue_on" );
	
	wait 2;
	
	flag_waitopen( "dialogue_ghost_orders" );
	flag_waitopen( "dialogue_basement_cleared" );
	
	flag_set( "dialogue_topfloor_cleared" );
	
	//autosave_by_name( "topfloor_cleared" );

	//Top floor clear!	
	radio_dialogue( "est_scr_topfloor" );

	//Roger that, top floor clear!
	radio_dialogue( "est_gst_topfloor" );
	
	flag_set( "ghost_goes_outside" );
	
	flag_clear( "scripted_dialogue_on" );
	flag_clear( "dialogue_topfloor_cleared" );
	
	if( !flag( "basement_cleared" ) )
	{
		//node = getnode( "scarecrow_breachhouse_start", "targetname" );
		node = getnode( "scarecrow_guard_basement1", "targetname" );
		level.scarecrow setgoalnode( node );
	}
}

house_basement_cleared_dialogue()
{
	flag_wait( "basement_cleared" );
	
	wait 2;
	
	flag_waitopen( "dialogue_ghost_orders" );
	flag_waitopen( "dialogue_topfloor_cleared" );
	
	flag_set( "dialogue_basement_cleared" );
	flag_set( "scripted_dialogue_on" );
	
	//if( !flag( "topfloor_breached" ) )
		//autosave_by_name( "basement_cleared" );
	
	//Basement clear!	
	radio_dialogue( "est_scr_basement" );
	
	//Copy, basement clear!
	radio_dialogue( "est_gst_basement" );
	
	flag_clear( "scripted_dialogue_on" );
	flag_clear( "dialogue_basement_cleared" );
	
	flag_set( "basement_cleared_confirmed" );	
}

house_topfloor_breached()
{
	level waittill ( "breaching_number_" + "5" );
	
	//autosave_by_name( "topfloor_breach_save" );
	//autosave_now();
	
	flag_set( "topfloor_breached" );
	level.interiorRoomsBreached++;
}

house_basement_breached_armory()
{	
	level waittill ( "breaching_number_" + "3" );
	
	//autosave_by_name( "armory_breach_save" );
	//autosave_now();
	
	flag_set( "basement_breached" );
	flag_set( "armory_breached" );
	level.interiorRoomsBreached++;
}

house_basement_breached_guestroom()
{
	level waittill ( "breaching_number_" + "4" );
	
	//autosave_by_name( "guestroom_breach_save" );
	//autosave_now();
	
	flag_set( "basement_breached" );
	flag_set( "guestroom_breached" );
	level.interiorRoomsBreached++;
}

house_check_upstairs_mainfloor_dialogue()
{
	level endon ( "house_interior_breaches_done" );
	
	flag_wait( "house_friendlies_instructions_given" );
	
	while( !flag( "topfloor_breached" ) )
	{
		//if main floor is cleared
		//AND top breach is not yet done
		
		tracePassed = level.ghost SightConeTrace( level.player.origin + ( 0, 0, 64 ) );
				
		if( tracePassed && flag( "ghost_at_bottom_of_stairs" ) )
		{
			flag_waitopen( "dialogue_ghost_orders" );
			flag_waitopen( "dialogue_topfloor_cleared" );
			flag_waitopen( "dialogue_basement_cleared" );
			
			if( flag( "scarecrow_said_upstairs" ) )
				wait 30;
			
			if( !flag( "topfloor_breached" ) )
			{
				flag_set( "scripted_dialogue_on" );
				
				//Roach, go upstairs and check any locked rooms on the top floor. Breach and clear.	
				radio_dialogue( "est_gst_lockedrooms" );
			
				flag_clear( "scripted_dialogue_on" );
			}
		
			break;
		}
		
		wait 0.5;
	}
}

house_check_upstairs_basement_dialogue()
{
	level endon ( "house_interior_breaches_done" );
	
	flag_wait( "basement_breached" );
	
	//flag_waitopen( "breaching_on" );

	//if basement is cleared, and top breach is not yet done
		
	//run scarecrow to basement room
		
	node = getnode( "scarecrow_guard_basement2", "targetname" );
	level.scarecrow disable_ai_color();
	level.scarecrow setgoalnode( node );
	level.scarecrow.goalradius = 16;
	level.scarecrow waittill ( "goal" );
	
	if( !flag( "basement_cleared" ) )
	{
		flag_waitopen( "dialogue_ghost_orders" );	
		flag_waitopen( "dialogue_topfloor_cleared" );	
		flag_waitopen( "dialogue_basement_cleared" );
		
		if( !flag( "basement_cleared" ) )
		{	
			flag_set( "scripted_dialogue_on" );
			
			//I got your back, Roach.	
			radio_dialogue( "est_scr_gotyourback" );
			
			flag_clear( "scripted_dialogue_on" );
		}
	}
	
	if( !flag( "topfloor_breached" ) )
	{
		flag_wait( "basement_cleared_confirmed" );
		
		if( !flag( "house_interior_breaches_done" ) )
		{
			//tracePassed = sighttracepassed( level.player.origin, level.scarecrow.origin, true, undefined );
			
			while( !flag( "topfloor_breached" ) )
			{
				tracePassed = level.scarecrow SightConeTrace( level.player.origin + ( 0, 0, 64 ) );
				
				if( tracePassed )
				{
					flag_waitopen( "dialogue_ghost_orders" );
					flag_waitopen( "dialogue_topfloor_cleared" );
					flag_waitopen( "dialogue_basement_cleared" );
					
					flag_set( "scripted_dialogue_on" );
					
					flag_set( "scarecrow_said_upstairs" );
					
					//I've got this area covered Roach. Get upstairs and check the rooms on the top floor.	
					radio_dialogue( "est_scr_getupstairs" );
			
					flag_clear( "scripted_dialogue_on" );
					
					break;
				}
				
				wait 0.5;
			}
		}
	}
}

house_check_basement_dialogue()
{
	flag_wait( "mainfloor_cleared" );
	flag_wait( "topfloor_cleared" );
	
	wait 4;
	
	if( !flag( "house_interior_breaches_done" ) )
	{
		if( !flag( "basement_cleared" ) )
		{
			//if topfloor is cleared
			//AND if mainfloor is cleared
			//AND basement is not cleared
			
			flag_set( "scripted_dialogue_on" );
			
			level.scarecrow.doorFlashChance = 1;
			
			enemies = getaiarray( "axis" );
			foreach( enemy in enemies )
			{
				level.scarecrow getenemyinfo( enemy );
			}
			
			flag_waitopen( "dialogue_ghost_orders" );
			flag_waitopen( "dialogue_topfloor_cleared" );
			flag_waitopen( "dialogue_basement_cleared" );
			
			//Roach, check the basement for enemy activity. Breach and clear. Go.	
			radio_dialogue( "est_gst_checkbasement" );
			
			flag_clear( "scripted_dialogue_on" );
		}
	}
}

house_clearing_banter()
{
	level endon ( "house_interior_breaches_done" );
	
	//if main floor is cleared
	//AND at least one interior breach remains
	
	flag_wait( "mainfloor_cleared_confirmed" );
	
	flag_set( "scripted_dialogue_on" );
	
	flag_waitopen( "dialogue_topfloor_cleared" );
	flag_waitopen( "dialogue_basement_cleared" );
	flag_set( "dialogue_ghost_orders" );
			
	wait 2;
	
	//Ozone now navigates to a final guard node inside the kitchen
		
	node = getnode( "ozone_guard_kitchen", "targetname" );
	level.ozone disable_ai_color();
	level.ozone setgoalnode( node );
	
	if( !flag( "topfloor_breached" ) || !flag( "basement_breached" ) )
	{			
		lines = [];
		lines[ lines.size ] = "est_gst_thrukitchen";	//Ozone, make sure no one leaves through the kitchen.	
		lines[ lines.size ] = "est_ozn_rogerthat";		//Roger that.	
		lines[ lines.size ] = "est_gst_sitrep";			//Scarecrow, gimme a sitrep.	
		lines[ lines.size ] = "est_scr_noonesleaving";	//No one's leaving through the front of the basement.
		
		foreach( index, line in lines )
		{
			flag_waitopen( "breaching_on" );
			radio_dialogue( lines[ index ] );
		}
	}
	
	flag_clear( "scripted_dialogue_on" );
	
	flag_clear( "dialogue_ghost_orders" );
	
	flag_set( "house_friendlies_instructions_given" );
}

house_battlechatter_check()
{
	//level endon ( "house_interior_breaches_done" );
	//level endon ( "all_enemies_killed_up_to_house_capture" );
	
	flag_wait( "breaching_on" );
	
	level.ghost.voice = "seal";
	level.ghost.countryID = "NS";
	
	level.scarecrow.voice = "seal";
	level.scarecrow.countryID = "NS";
	
	level.ozone.voice = "seal";
	level.ozone.countryID = "NS";
	
	while( !flag( "all_enemies_killed_up_to_house_capture" ) )
	{
		battlechatter_off( "allies" );
		battlechatter_off( "axis" );
		
		flag_waitopen( "breaching_on" );
		flag_waitopen( "scripted_dialogue_on" );
		
		battlechatter_on( "allies" );
		battlechatter_on( "axis" );
	
		flag_wait_any( "breaching_on", "scripted_dialogue_on" ); 
	}
}

house_autosaves()
{
	if ( flag( "all_enemies_killed_up_to_house_capture" ) )
		return;
		
	level endon ( "all_enemies_killed_up_to_house_capture" );
	
	level waittill_any( "breaching_number_0" , "breaching_number_1" , "breaching_number_2" );
	
	saveTrig = getent( "house_clearing_autosave_trigger", "targetname" );
	
	while ( 1 )
	{
		//if nothing inside the house has been breached, allow a save every 30 seconds if player touches trigger
		
		if( level.interiorRoomsBreached > 0 )
		{
			if( !flag( "first_free_save" ) )
			{
				level waittill ( "slomo_breach_over" );
			}
			
			saveTrig waittill ( "trigger" );
	
			autosave_by_name( "nearDoorBreach_save" );	
			
			flag_clear( "first_free_save" );
		}
		else
		{
			saveTrig waittill ( "trigger" );
			autosave_by_name( "nearDoorBreach_save" );
			
			house_autosave_timeout();	//interruptible debounce if breach is done
			
			flag_set( "first_free_save" );
			
			continue;
		}
	}
}

house_autosave_timeout()
{
	level endon ( "slomo_breach_over" );
	
	//level endon ( "breaching_number_3" );
	//level endon ( "breaching_number_4" );
	//level endon ( "breaching_number_5" );
	
	wait 30;
}

house_ghost_sweep()
{	
	//Ghost's basic movement through the house during the clearing sequence

	flag_set( "no_mercy" );

	level endon ( "house_reset_ghost" );
	
	level waittill_any( "breaching_number_0" , "breaching_number_1" , "breaching_number_2" );
	
	if( flag( "kitchen_breached_first" ) || flag( "basement_breached_first" ) )
	{
		thread house_ghost_sweep_trigger_timeout();
		thread house_ghost_sweep_trigger_manual();
	}
	
	level.ghost disable_ai_color();
	
	level.ghost.attackeraccuracy = 0;
	level.ghost.ignorerandombulletdamage = 1;
	level.ghost disable_pain();
	level.ghost disable_surprise();
	level.ghost.disableBulletWhizbyReaction = 1;
	
	level.ghost disable_arrivals();
	
	level.ghost.dontmelee = true;
	
	if( flag( "foyer_breached_first" ) )
	{	
		level waittill ( "sp_slowmo_breachanim_done" );
		
		level.ghost.goalradius = 64;
		
		magicSpot = getent( "ghost_slowmo_entry_teleport", "targetname" );
		level.ghost forceTeleport( magicSpot.origin, magicSpot.angles );
		
		level.ghost enable_heat_behavior( 1 );
		
		node = getnode( "ghost_slowmo_entry", "targetname" );
		
		setsaveddvar( "ai_friendlyFireBlockDuration", "0" );
		
		level.ghost setgoalnode( node );
		level.ghost waittill ( "goal" );

		wait 8;
	}
	else
	{
		flag_wait( "ghost_begins_sweep" );
		
		level.ghost delaythread( 3, ::enable_heat_behavior, 1 );
	}
	
	node = getnode( "ghost_house_sweep", "targetname" );
	
	nodecount = 0;
	
	while( 1 )
	{		
		level.ghost setgoalnode( node );
		level.ghost waittill ( "goal" );	
		
		setsaveddvar( "ai_friendlyFireBlockDuration", "2000" );
		
		if( nodecount == 0 )
		{
			wait 4;
			level.ghost.goalradius = 32;
		}
		
		if( nodecount == 1 )
		{
			wait 0.5;
			
			flag_set( "scripted_dialogue_on" );
			
			flag_waitopen( "dialogue_ghost_orders" );
			flag_waitopen( "dialogue_topfloor_cleared" );
			flag_waitopen( "dialogue_basement_cleared" );
			
			//Office clear!	
			radio_dialogue( "est_gst_officeclear" );
			
			//Clear!
			//radio_dialogue( "est_gst_clear" );
			
			wait 0.5;
			
			flag_waitopen( "dialogue_ghost_orders" );
			flag_waitopen( "dialogue_topfloor_cleared" );
			flag_waitopen( "dialogue_basement_cleared" );
			
			//Let's go, let's go!
			delaythread( 1, ::radio_dialogue, "est_gst_letsgo2" );
			
			flag_clear( "scripted_dialogue_on" );
		}
	
		nodecount++;
		
		if( nodecount == 4 )
		{
			wait 0.25;
			
			flag_waitopen( "dialogue_ghost_orders" );
			flag_waitopen( "dialogue_topfloor_cleared" );
			flag_waitopen( "dialogue_basement_cleared" );
			
			flag_set( "scripted_dialogue_on" );
		
			//Dining room clear!
			radio_dialogue( "est_gst_diningroomclr" );
			
			flag_clear( "scripted_dialogue_on" );
		}
		
		if( nodecount == 5 )
		{
			level.ghost disable_heat_behavior();	
			level.ghost enable_arrivals();
		}

		if( isdefined( node.target ) )
		{
			node = getnode( node.target, "targetname" );
		}
		else
		{
			break;
		}
	}	
	
	ent = getent( "ghost_fake_lookat", "targetname" );
	level.ghost cqb_aim( ent );
	
	flag_set( "ghost_at_bottom_of_stairs" );
	
	flag_wait( "topfloor_cleared" );
	
	if( !flag( "ghost_goes_outside" ) )
	{
		wait 9.5;
	}
	
	node = getnode( "ghost_cover_front", "targetname" );
	level.ghost setgoalnode( node );
}

house_ghost_sweep_trigger_timeout()
{
	level endon ( "house_reset_ghost" );
	
	//Send Ghost automatically if player never hits the trigger
	
	wait 30;
	
	flag_set( "ghost_begins_sweep" );
}

house_ghost_sweep_trigger_manual()
{
	level endon ( "house_reset_ghost" );
	
	manualTrig = getent( "ghost_manual_trig", "targetname" );
	manualTrig waittill ( "trigger" );
	
	flag_set( "ghost_begins_sweep" );
}

house_ghost_lastbreach_reset()
{
	//on the final interior breach, sends Ghost back to his spot outside the front door for the talking animation
	
	level waittill_any( "breaching_number_0" , "breaching_number_1" , "breaching_number_2" );	//exterior
	
	level waittill_any( "breaching_number_3" , "breaching_number_4" , "breaching_number_5" );	//interior 1
		
	level waittill_any( "breaching_number_3" , "breaching_number_4" , "breaching_number_5" );	//interior 2
	
	level waittill_any( "breaching_number_3" , "breaching_number_4" , "breaching_number_5" );	//interior 3
	
	level notify ( "house_reset_ghost" );
	
	level.ghost enable_ai_color();
}

//********************
// SOLAR PANELS
//********************

solar_panels()
{
	panels = getentarray( "solar_panel", "targetname" );
	panels_colmaps = getentarray( "solar_panel_collision", "targetname" );
	
	array_thread( panels, ::solar_panels_rotate );
	array_thread( panels_colmaps, ::solar_panels_rotate );
}

solar_panels_rotate()
{
	//self RotateYaw( 45, 180, 3, 3 );
	
	flag_wait( "forestfight_littlebird_1" );
	
	wait 3;
	
	self RotateYaw( -95, 60, 3, 3 );
}

//********************
// MUSIC
//********************

estate_music()
{	
	switch( level.start_point )
	{
		case "default":
		case "ambush":
		case "forestfight":
		case "house_approach":
		case "house_breach":
			flag_wait( "start_ambush_music" );
			thread MusicLoop( "estate_ambushfight" ); // 2 minutes 18 seconds
			
			flag_wait ( "all_enemies_killed_up_to_house_capture" );
		
			level notify( "stop_music" );
			musicStop( 5 );
			wait 5.1;
		
		case "house_briefing":
			thread MusicLoop( "estate_basement_clear" ); // 1 minutes 38 seconds
		
			flag_wait( "download_started" );
		
			level notify( "stop_music" );
			musicStop( 6 );
			wait 6.1;
		
		case "house_defense":
			musicPlayWrapper( "estate_dsm_wait" );
		
			flag_wait( "download_complete" );
			musicStop( 1 );
			wait 1.1;
			
		case "escape":		
			thread MusicLoop( "estate_escape" ); // 2 minutes 4 seconds
		
			flag_wait( "finish_line" );
		
			level notify( "stop_music" );
			musicStop();
			
		case "ending":
			flag_wait( "begin_ending_music" );
			wait 9;
			musicPlayWrapper( "estate_betrayal" );
			break;
	}
}

temp_text( text )
{
        iPrintln( text );
}

//*****************************
// PLAYER ZONE DETECTION
//*****************************

zone_detection_init()
{
	level.playerZone = undefined;
	
	zoneTriggers = getentarray( "zone_trigger", "script_noteworthy" );
	array_thread( zoneTriggers, ::zone_detection );
}

zone_detection()
{
	timePassed = 0;
	
	while( 1 )
	{
		self waittill( "trigger" );
		
		assertEX( isdefined( self.targetname ) );
	
		level.playerZone = self.targetname;
			
		//iprintln( level.playerZone );
	}
}

/*
Strike Package concept

A preset themed attack pattern based on known player location
	- mass helicopter troop assault
	- faked mass troop drop in the start area and solar panels for a double envelopment assault from the east, player is near house
	- mass troop smoke assault from the southeast with the fence getting blown up and breached
	- vehicle assault from the road, unloading lots of enemy troops
	- troop drop at the boathouse
	- mass troop smoke assault from the northeast woods
	
28 enemy troops in a strike package, no respawns

Need a way to control these options based on player position, so player does not witness spawning

Rolling Strike concept

After a Strike Package is deployed, it is supplemented by a Rolling Strike for some amount of time.
During the Rolling Strike, the player is not allowed to stray from the building too far.
Strike Components are deployed a la carte from a 'menu' of 'one-time pads'
	- MI-17 helicopter 8-man deployment
	- MD500 helicopter 4-man deployment
	- UAZ jeep 6-man deployment (limited supply due to pathing options)
	- ZIL truck 8-man deployment (limited supply due to pathing options)
	- Remote magic spawned 4-man Hunter-killer team (unlimited supply) with helicopter for show and smoke grenade action
	- Smokespawned 8-man assault team (unlimited supply) with smoke grenade action
	- Magic spawned 2-man Sniper team
	
No components are called twice during the Rolling Strike, there are many variants for each but quantity 1 for each
	- need to place many alternate positions that are player position sensitive
	
	
1. Need to set up strike packages.
		- each is a separate function
			- these are activated like Strike Components, player reactive, player goes anywhere			
2. Need to know which zone player is in at all times.
		- use waittill trigger on back-to-back triggers
3. Need to place a whole bunch of Strike Components in the level to support the strike packages during rolling strikes.
		- each zone needs to have corresponding Strike Components to handle visibility to the player
4. For the final field and the outer road, we need a failure cordon to keep the player from running into the wild
		- failure cordon
			- 1. don't get too far from the house warning shout + timer to fail begins unless retriggered
			- 2. we're doomed, failsafe trigger, automatic lose
			
Zones:

script_noteworthy: zone_trigger

targetnames:

zone_backsolarpanelfield

zone_backyardpond 
zone_backyardshed
zone_stables
zone_birchfield

zone_house
zone_forest
zone_frontsolarpanels
zone_parkinglot
zone_porchtriangle
zone_porch
zone_frontyardwedge
zone_frontyardhigh

zone_backpatio
zone_beach
zone_boathouse

*/

defense_schedule_control()
{	
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	
	flag_wait( "defense_battle_begins" );

	level.packageThresholdPop = 0;
	level.packageComponentThresholdPop = 14;	//the enemy pop at which we allow strikeComponents to be deployed during a strikePackage
	level.enemyTotalPop = 0;
	level.componentCycleLimit = 1;
	level.packageTime = undefined;

	//Every playerZone has a corresponding list of strikePackages
	
	level.strikePackage = [];

	addStrikePackage( "zone_backsolarpanelfield", ::strike_package_bighelidrop );
	addStrikePackage( "zone_backsolarpanelfield", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_backsolarpanelfield", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_backsolarpanelfield", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_backyardshed", ::strike_package_bighelidrop );
	addStrikePackage( "zone_backyardshed", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_backyardshed", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_backyardshed", ::strike_package_solarfield );
	addStrikePackage( "zone_backyardshed", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_stables", ::strike_package_bighelidrop );
	addStrikePackage( "zone_stables", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_stables", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_stables", ::strike_package_solarfield );
	addStrikePackage( "zone_stables", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_birchfield", ::strike_package_bighelidrop );
	addStrikePackage( "zone_birchfield", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_birchfield", ::strike_package_solarfield );
	addStrikePackage( "zone_birchfield", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_forest", ::strike_package_bighelidrop );
	addStrikePackage( "zone_forest", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_forest", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_frontsolarpanels", ::strike_package_bighelidrop );
	addStrikePackage( "zone_frontsolarpanels", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_frontsolarpanels", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_backyardpond", ::strike_package_bighelidrop );
	addStrikePackage( "zone_backyardpond", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_backyardpond", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_backyardpond", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_house", ::strike_package_bighelidrop );
	addStrikePackage( "zone_house", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_house", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_house", ::strike_package_solarfield );
	addStrikePackage( "zone_house", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_parkinglot", ::strike_package_bighelidrop );
	addStrikePackage( "zone_parkinglot", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_parkinglot", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_parkinglot", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_porchtriangle", ::strike_package_bighelidrop );
	addStrikePackage( "zone_porchtriangle", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_porchtriangle", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_porchtriangle", ::strike_package_solarfield );
	addStrikePackage( "zone_porchtriangle", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_porch", ::strike_package_bighelidrop );
	addStrikePackage( "zone_porch", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_porch", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_porch", ::strike_package_solarfield );
	addStrikePackage( "zone_porch", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_frontyardwedge", ::strike_package_bighelidrop );
	addStrikePackage( "zone_frontyardwedge", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_frontyardwedge", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_frontyardwedge", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_frontyardhigh", ::strike_package_bighelidrop );
	addStrikePackage( "zone_frontyardhigh", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_frontyardhigh", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_frontyardhigh", ::strike_package_solarfield );
	addStrikePackage( "zone_frontyardhigh", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_backpatio", ::strike_package_bighelidrop );
	addStrikePackage( "zone_backpatio", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_backpatio", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_backpatio", ::strike_package_solarfield );
	addStrikePackage( "zone_backpatio", ::strike_package_boathouse_helidrop );
	
	addStrikePackage( "zone_beach", ::strike_package_bighelidrop );
	addStrikePackage( "zone_beach", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_beach", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_beach", ::strike_package_solarfield );
	
	addStrikePackage( "zone_boathouse", ::strike_package_bighelidrop );
	addStrikePackage( "zone_boathouse", ::strike_package_birchfield_smokeassault );
	addStrikePackage( "zone_boathouse", ::strike_package_frontyard_md500_rush );
	addStrikePackage( "zone_boathouse", ::strike_package_solarfield );
	
	level.strikeComponents = [];
	
	addStrikeComponent( "zone_backsolarpanelfield", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_backsolarpanelfield", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_backsolarpanelfield", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_backyardshed", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_backyardshed", ::strike_component_rpg_team_boathouse );
	
	addStrikeComponent( "zone_stables", ::strike_component_rpg_team_boathouse );
	
	addStrikeComponent( "zone_birchfield", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_birchfield", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_forest", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_forest", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_forest", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_frontsolarpanels", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_frontsolarpanels", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_frontsolarpanels", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_backyardpond", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_backyardpond", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_house", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_house", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_house", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_parkinglot", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_parkinglot", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_parkinglot", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_porchtriangle", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_porchtriangle", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_porchtriangle", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_porch", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_porch", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_porch", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_frontyardwedge", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_frontyardwedge", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_frontyardwedge", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_frontyardhigh", ::strike_component_rpg_team_stables );
	addStrikeComponent( "zone_frontyardhigh", ::strike_component_rpg_team_boathouse );
	addStrikeComponent( "zone_frontyardhigh", ::strike_component_rpg_team_southwest );
	
	addStrikeComponent( "zone_backpatio", ::strike_component_rpg_team_stables );
	
	addStrikeComponent( "zone_beach", ::strike_component_rpg_team_stables );
	
	addStrikeComponent( "zone_boathouse", ::strike_component_rpg_team_stables );
	
	//tally up the total enemies in the package
	
	//enemies = [];
	//enemies = getaiarray( "axis" );
	level.enemyTotalPop = 0;
	
	badsave_volume = getent( "no_autosave_in_basement", "targetname" );
	safeDSMhealth = level.dsmHealthMax * 0.7;
	
	while( 1 )
	{
		//while we are in the defense phase
		//select a strike package based on player location and run it
		
		randomStrikePackage( level.playerZone );	
		
		dsm_real = getent( "dsm", "targetname" );
		playerDSMdist = length( level.player.origin - dsm_real.origin );
		
		if( flag( "can_save" ) && playerDSMdist <= level.playerDSMsafedist )
		{
			if( !( level.player istouching( badsave_volume ) ) && level.dsmHealth >= safeDSMhealth )
			{
				autosave_by_name( "strikePackageCleared" );		
			}
		}
		
		while( level.enemyTotalPop > level.packageThresholdPop )
		{
			level waittill ( "counterattacker_died" );
		}
		
		flag_set( "activate_package_on_standby" );
		
		//if all exhausted completely, bail out
		
		foreach( zone, array in level.strikePackage )
		{
			if( level.strikePackage[ zone ].size <= 0 )
			{
				level.strikePackage[ zone ] = undefined;
			}
		}
		
		wait 10;
		
		if( level.strikePackage.size <= 0 )
		{
			break;
		}
		
		flag_wait( "strike_package_spawned" );
		flag_clear( "strike_package_spawned" );
	
		//each package spawns everyone at once and the spawners autorun a deathmonitor thread on themselves
		//monitor the deathcount for the package until some threshold pop is reached
		
		while( level.enemyTotalPop > level.packageComponentThresholdPop )
		{
			level waittill ( "counterattacker_died" );
		}
		
		//when a minimum deathcount is reached
		//randomly select one-time-use Strike Components based on player location until the force cap is reached
		//keep doing this until the Strike Component usage limit is reached for this Strike Package
			//OR until the Strike Package Time on Target is expended
		
		if( !isdefined( level.packageTime ) )
		{
			level.packageTime = 30;
		}
		
		defense_component_schedule();
		
		//deploy the next strike_package
		
		wait 1;
	}
}

defense_component_schedule()
{
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	
	componentCount = 0;
	deployed = undefined;
	
	thread defense_component_timeout();
	
	while( level.packageTime > 0 )
	{
		//Cleanup empty arrays
		
		foreach( zone, array in level.strikeComponents )
		{
			if( level.strikeComponents[ zone ].size <= 0 )
			{
				level.strikeComponents[ zone ] = undefined;
			}
		}
		
		if( level.strikeComponents.size <= 0 )
		{
			level notify ( "stop_timeout" );
			break;
		}
		
		deployed = randomStrikeComponent( level.playerZone );
		if( isdefined( deployed ) && deployed )
		{
			flag_wait( "strike_component_activated" );
			flag_clear( "strike_component_activated" );
			
			componentCount++;
			
			while( level.enemyTotalPop > level.componentThresholdPop )
			{
				level waittill ( "counterattacker_died" );
			}
	
			flag_set( "activate_component_on_standby" );
		}
		
		if( componentCount >= level.componentCycleLimit )
		{
			level notify ( "stop_timeout" );
			break;
		}
		
		wait randomfloatrange( 2, 8 );
	}
}

defense_component_timeout()
{
	//Each package activates the release of strikeComponents for this amount of time before activating the next package
	
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	level endon ( "stop_timeout" );
	
	while( level.packageTime > 0 )
	{
		wait 1;
		level.packageTime--;
	}
}

//=================================================

addStrikePackage( zone, package )
{
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	
	if( !isdefined( level.strikePackage[ zone ] ) )
	{
		level.strikePackage[ zone ] = [];
	}
	level.strikePackage[ zone ][ level.strikePackage[ zone ].size ] = package;
}

randomStrikePackage( zone )
{
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	
	if( !isdefined( level.strikePackage[ zone ] ) )
		return( false );
	
	if( !level.strikePackage[ zone ].size )
	{
		level.strikePackage[ zone ] = undefined;
		return( false );
	}
	
	package = random( level.strikePackage[ zone ] );
	
	thread [[ package ]]();
	
	flag_set( "strike_packages_definitely_underway" );
	
	//a strikePackage is for one-time use only; this removes any cases of this package in all the strikePackage arrays
	
	foreach( zone, array in level.strikePackage )
	{	
		foreach( index, element in array )
		{
			if( element == package )
			{
				level.strikePackage[ zone ][ index ] = undefined;
			}
		}
	}
	
	return( true );
	
	//level.strikePackage[ "zone_backsolarpanelfield" ][ 0 ] = ::strike_package_bighelidrop;
	//level.strikePackage[ "zone_backsolarpanelfield" ][ 1 ] = "blah";
}

//=====================================

addStrikeComponent( zone, component )
{
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	
	if( !isdefined( level.strikeComponents[ zone ] ) )
	{
		level.strikeComponents[ zone ] = [];
	}
	
	level.strikeComponents[ zone ][ level.strikeComponents[ zone ].size ] = component;
}

randomStrikeComponent( zone )
{
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	
	if( !isdefined( level.strikeComponents[ zone ] ) )
		return( false );
	
	if( !level.strikeComponents[ zone ].size )
	{
		level.strikeComponents[ zone ] = undefined;
		return( false );
	}
	
	component = random( level.strikeComponents[ zone ] );
	
	thread [[ component ]]();
	
	//a strikeComponent is for one-time use only; this removes any cases of this package in all the strikePackage arrays
	
	foreach( zone, array in level.strikeComponents )
	{
		foreach( index, element in array )
		{
			if( element == component )
			{
				level.strikeComponents[ zone ][ index ] = undefined;
			}
		}
	}
	
	return( true );
}

//To do:

	//"forest_smokeassault";
	//"birchfield_smokeassault";
	//"beachlanding";
	//"forest_smokeassault";
	//"solarfield_fakedrop";

//=================================================

birchfield_exfil()
{
	flag_wait( "download_complete" );
	
	autosave_by_name( "download_done" );
	
	//Ghost goes to a good spot near the front door
	
	//*TEMP dialogue - Ghost prompts player to get the DSM
	
	if( !flag( "dsm_recovered" ) )
	{
		thread birchfield_exfil_nag();
	}

	if( flag( "skip_defense" ) )
	{
		wait 3;
	}
	
	//crank up Ghost's baseaccuracy
	
	level.ghost.baseAccuracy = 1000;
	
	//spawn token enemies for Ghost to own
	
	flag_wait( "dsm_recovered" );
	
	autosave_by_name( "birchfield_exfil_started" );
	
	wait 3;
	
	//Ghost starts using friendlychains again to get to the endzone
	
	//This is Shepherd. We're almost at the LZ. What's your status, over?	
	radio_dialogue( "est_shp_almostatlz" );
	
	//We're on our way to the LZ! Roach, let's go!!	
	level.ghost thread dialogue_queue( "est_gst_onourway" );
	
	wait 2;
	
	level.fixednodesaferadius_default = 64;
	
	level.ghost enable_ai_color();
	
	if( isalive( level.ozone ) )
	{
		level.ozone enable_ai_color();
	}
	
	if( isalive( level.scarecrow ) )
	{
		level.scarecrow enable_ai_color();
	}
	
	trig = getent( "ghost_exfil", "targetname" );
	trig notify ( "trigger" );
	
	flag_wait( "point_of_no_return" );
	
	autosave_by_name( "point_of_no_return" );
	
	thread maps\_mortar::bog_style_mortar_on( "2" );
	
	thread birchfield_mortar_playerkill();
	thread birchfield_ghost_covering_shouts();
	
	//They're bracketing our position with mortars, keep moving but watch your back!!!	
	level.ghost thread dialogue_queue( "est_gst_bracketing" );
	
	wait 1;
}

birchfield_exfil_nag()
{
	level endon ( "dsm_recovered" );
	
	delay = 7;
	
	while( 1 )
	{
		wait 2;
		
		//Roach, the transfer's complete! I'll cover the main approach while you get the DSM! Move!	
		radio_dialogue( "est_gst_dsmcomplete" );
		
		wait delay;
		
		if( delay < 30 )
		{
			delay = delay * 2;
		}
		
		//Roach! I'm covering the front! Get the DSM! We gotta get outta here!	
		radio_dialogue( "est_gst_getouttahere" );
	}
}

birchfield_mortar_playerkill()
{
	level endon ( "finish_line" );
	
	flag_wait( "player_retreated_into_birchfield" );
	
	thread mortar_in_face_killplayer();
}

birchfield_ghost_covering_shouts()
{
	//If Ghost gets to his colornodes, he triggers this line of dialogue to look like he's covering the player
	
	level endon ( "finish_line" );
	
	trigs = getentarray( "ghost_covering_shout", "targetname" );
	foreach( trig in trigs )
	{
		trig thread birchfield_ghost_shout_trigger();
	}
	
	wait 9;
	
	//We gotta get to the LZ! Roach, come on!	
	level.ghost dialogue_queue( "est_gst_gettothelz" );
}

birchfield_ghost_shout_trigger()
{
	self waittill ( "trigger" );
	
	if( !flag( "ghost_covered_player" ) )
	{
		flag_set( "ghost_covered_player" );
	
		//Roach, I got you covered!! Go! Go!!	
		level.ghost dialogue_queue( "est_gst_gotyoucovered" );
		
		//Get to the LZ! Keep moving!		
		level.ghost dialogue_queue( "est_gst_keepmoving" );
	}
	else
	{
		//I'll cover you! Move!!!		
		level.ghost dialogue_queue( "est_gst_illcoveryou" );
		
		//Go! Go!		
		level.ghost dialogue_queue( "est_gst_gogo" );
	}
}

birchfield_knockout()
{
	flag_wait( "finish_line" );
	
	level.player EnableDeathShield( true );
	level.cover_warnings_disabled = 1;
	
	level.player freezeControls( true );
	
	mortarHitOrg = playerFovGroundSpot();
	playFX( level._effect[ "mortar" ][ "dirt" ], mortarHitOrg );
	detorg = spawn( "script_origin", mortarHitOrg );
	detorg playsound( "clusterbomb_explode_default" );
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	wait 0.15;

	flag_set( "play_ending_sequence" );
	
	level.player freezeControls( false );
	
	musicStop();
}

//=================================================

mortar_in_face_killplayer()
{
	mortarHitOrg = playerFovGroundSpot();
	playFX( level._effect[ "mortar" ][ "dirt" ], mortarHitOrg );
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	wait 0.15;
	level.player kill();
}

//=================================================

strike_package_bighelidrop()
{
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "strike_package_bighelidrop_dialogue" );
	
	level.packageThresholdPop = 2;	//max number of AI that is allowed to be alive before deploying this group
	level.packageTime = 90;
	
	flag_wait( "activate_package_on_standby" );
	flag_clear( "activate_package_on_standby" );
	
	if( !flag( "dsm_recovered" ) )
	{
		thread strike_package_bighelidrop_dialogue();
	}
	
	heli1 = spawn_vehicle_from_targetname_and_drive( "heli_phoenix_01" );	
	heli2 = spawn_vehicle_from_targetname_and_drive( "heli_phoenix_02" );	
	heli3 = spawn_vehicle_from_targetname_and_drive( "heli_phoenix_03" );	
	heli4 = spawn_vehicle_from_targetname_and_drive( "heli_phoenix_04" );	
	
	thread defense_helidrop_rider_setup( heli1, "heli_phoenix_01" );
	thread defense_helidrop_rider_setup( heli2, "heli_phoenix_02" );
	thread defense_helidrop_rider_setup( heli3, "heli_phoenix_03" );
	thread defense_helidrop_rider_setup( heli4, "heli_phoenix_04" );
	
	//heli5 = spawn_vehicle_from_targetname_and_drive( "heli_phoenix_05" );
	
	wait 3;
	
	flag_set( "strike_package_spawned" );
}

strike_package_bighelidrop_dialogue()
{
	//Sniper Team One to strike team, be advised, we got enemy helos approaching from the northwest and southeast. 
	radio_dialogue( "est_snp1_mainroad" );
	
	//Enemy choppers in 15 seconds. 
	radio_dialogue( "est_snp1_15seconds" );
	
	//Roger that, 15 seconds!
	radio_dialogue( "est_gst_15seconds" );
	
	flag_clear( "strike_package_bighelidrop_dialogue" );
}

//=================================================

strike_package_birchfield_smokeassault()
{	
	//blow up the fence with several charges detonating, and quake the player each time
	
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "strike_package_birchfield_dialogue" );
	
	level.packageThresholdPop = 10;	//max number of AI that is allowed to be alive before deploying this group
	level.packageTime = 120;
	
	flag_wait( "activate_package_on_standby" );
	flag_clear( "activate_package_on_standby" );
	
	if( !flag( "dsm_recovered" ) )
	{
		thread strike_package_birchfield_smokeassault_dialogue();
	}
	
	fence_detonators = getstructarray( "chainlink_fence_detonator", "targetname" );
	foreach( detonator in fence_detonators )
	{
		wait randomfloatrange( 0.25, 1 );
		playFX( getfx( "fenceblast" ), detonator.origin );
		detorg = spawn( "script_origin", detonator.origin );
		detorg playsound( "clusterbomb_explode_default" );
		earthquake( 0.25, 1, level.player.origin, 2000 );
	}
	
	if( !flag( "fence_removed" ) )
	{
		fence = getent( "final_area_fence", "targetname" ); 
		fence delete();
		flag_set( "fence_removed" );
	}

	//turn on the smoke machines to hide the spawns
	
	//spawn the attack as one big batch, no respawns
	
	core_spawn( "birchfield_smokeassault_leftflank", ::birchfield_leftflank_routing );
	core_spawn( "birchfield_smokeassault_rightflank", ::birchfield_rightflank_routing );
	core_spawn( "birchfield_smokeassault_centersupport", ::birchfield_centersupport_routing );
	
	//send out the distracting MD-500 helicopters
	
	wait 3;
	
	flag_set( "strike_package_spawned" );
}

strike_package_birchfield_smokeassault_dialogue()
{
	wait 2;
	
	if( isalive( level.scarecrow ) )
	{
		//What the hell was that?
		radio_dialogue( "est_scr_whatwasthat" );	
	}
	
	//Be advised, you have a large concentration of hostiles moving in from the southeast, they just breached the perimeter!	
	radio_dialogue( "est_snp1_hostilesse" );
	
	//I'll try to thin 'em out before they get too close. Recommend you switch to scoped weapons, over.	
	radio_dialogue( "est_snp1_thinemout" );
	
	if( isalive( level.scarecrow ) || isalive( level.ozone ) )
	{
		//Roger that! Everyone cover the field to the southeast! Move!	
		radio_dialogue( "est_gst_fieldtose" );
	}
	
	if( isalive( level.ozone ) )
	{
		//I got eyes on! Here they come! They're in the field to the the southeast!	
		radio_dialogue( "est_ozn_eyeson" );
	}
	
	flag_clear( "strike_package_birchfield_dialogue" );
}

birchfield_leftflank_routing()
{
	assertEX( isalive( self ), "Tried to pass a dead AI into this function." );
	
	self endon ( "death" );
	
	//nodes = getnodearray( "birchfield_smokeassault_1a", "targetname" );
	
	nodeLoiterTime = randomfloatrange( 0.5, 2 );
	nodeInitRadius = 256;
	nodeEndRadius = 128;
	nodeClosureRate = 0.5;
	nodeClosureInterval = 0.5;
	earlyEndonMsg = "player_is_escaping";
	
	nodes = getnodearray( "birchfield_smokeassault_2a", "targetname" );
	
	if( !flag( "player_is_escaping" ) )
	{
		self roaming_nodecluster_nav( nodes, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
	}
	
	self terminal_guidance();	
}

birchfield_rightflank_routing()
{
	assertEX( isalive( self ), "Tried to pass a dead AI into this function." );
	
	self endon ( "death" );
	
	nodeLoiterTime = randomfloatrange( 0.5, 2 );
	nodeInitRadius = 256;
	nodeEndRadius = 128;
	nodeClosureRate = 0.5;
	nodeClosureInterval = 0.5;
	earlyEndonMsg = "player_is_escaping";
	
	nodes = getnodearray( "birchfield_smokeassault_1a", "targetname" );
	if( !flag( "player_is_escaping" ) )
	{
		self roaming_nodecluster_nav( nodes, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
	}
	
	self terminal_guidance();	
}

birchfield_centersupport_routing()
{
	assertEX( isalive( self ), "Tried to pass a dead AI into this function." );
	
	self endon ( "death" );
	
	nodeLoiterTime = randomfloatrange( 2, 4 );
	nodeInitRadius = 2100;
	nodeEndRadius = 1000;
	nodeClosureRate = 0.85;
	nodeClosureInterval = 10;
	earlyEndonMsg = "player_is_escaping";
	
	nodes = getnodearray( "birchfield_smokeassault_3a", "targetname" );
	if( !flag( "player_is_escaping" ) )
	{
		self roaming_nodecluster_nav( nodes, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
	}
	
	self terminal_guidance();	
}

//=================================================

strike_package_boathouse_helidrop()
{
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "strike_package_boathouse_dialogue" );
	
	level.packageThresholdPop = 12;	//max number of AI that is allowed to be alive before deploying this group
	level.packageTime = 45;

	if( !flag( "dsm_recovered" ) )
	{
		thread strike_package_boathouse_helidrop_dialogue();
	}
	
	heli1 = spawn_vehicle_from_targetname_and_drive( "boathouse_md500" );	
	heli2 = spawn_vehicle_from_targetname_and_drive( "boathouse_mi17" );	
	
	thread defense_helidrop_rider_setup( heli1, "boathouse_md500" );
	thread defense_helidrop_rider_setup( heli2, "boathouse_mi17" );
	
	wait 3;
	
	flag_set( "strike_package_spawned" );
}

strike_package_boathouse_helidrop_dialogue()
{
	//flag_wait( "boathouse_invaders_arrived" );
	wait 5;
	
	//They're dropping in more troops west of the house!	
	radio_dialogue( "est_snp1_troopswest" );
	
	//They must be by the boathouse! Cover the west approach! 
	radio_dialogue( "est_gst_boathouse" );
	
	if( isalive( level.ozone ) )
	{	
		//We got 249s and RPGs at the dining room window, plus L86 machine guns.	
		radio_dialogue( "est_ozn_249sandrpgs" );
		
		//Roger that, use 'em to cut 'em down as they come outta the treeline!	
		radio_dialogue( "est_gst_cutemdown" );
	}
	
	flag_clear( "strike_package_boathouse_dialogue" );
}

//=================================================

strike_package_solarfield()
{
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "strike_package_solarfield_dialogue" );
	
	level.packageThresholdPop = 17;	//max number of AI that is allowed to be alive before deploying this group
	level.packageTime = 60;
	
	flag_wait( "activate_package_on_standby" );
	flag_clear( "activate_package_on_standby" );
	
	if( !flag( "dsm_recovered" ) )
	{
		thread strike_package_solarfield_dialogue();
	}
	
	//spawn the attack as one big batch, no respawns
	
	core_spawn( "solarfield_pkg_openground", ::solarfield_routing_openground );
	core_spawn( "solarfield_pkg_forest", ::solarfield_routing_forest );
	
	thread smokescreen( "solarfield_pkg_smokepot" );
	
	wait 3;
	
	flag_set( "strike_package_spawned" );
}

strike_package_solarfield_dialogue()
{
	level endon ( "dsm_recovered" );
	
	//I have eyes on additional hostile forces moving in on your position. They're approaching through the solar panels east of the house.	
	radio_dialogue( "est_snp1_additionalhostile" );
	
	//They're moving in through the solar panels east of the house!	
	radio_dialogue( "est_gst_solarpanelseast" );
		
	if( isalive( level.scarecrow ) )
	{
		//Roger, I'll try to cut 'em off as they come through the trees.	
		radio_dialogue( "est_scr_comethrutrees" );
	}

	claymoreCount = level.player GetWeaponAmmoStock( "claymore" );
		
	if( level.gameSkill < 2 && !flag( "claymore_hint_printed" ) && claymoreCount > 4 )
	{
		//only print a hint on screen for easy and normal and less than 5 claymores in their stockpile
			
		flag_set( "claymore_hint_printed" );
		level.player thread display_hint( "claymore_hint" );
	}
		
	//Use your claymores if you have 'em. Plant 'em around the trail east of the house.	
	radio_dialogue( "est_gst_easttrail" );
	
	flag_clear( "strike_package_solarfield_dialogue" );
}

solarfield_routing_openground()
{
	//these guys are faster and more overt
	//they change locations faster and carry SMGs
	
	assertEX( isalive( self ), "Tried to pass a dead AI into this function." );
	
	self endon ( "death" );
	
	nodeLoiterTime = randomfloatrange( 0.5, 2 );
	nodeInitRadius = 2400;
	nodeEndRadius = 1200;
	nodeClosureRate = 0.8;
	nodeClosureInterval = 0.7;
	earlyEndonMsg = "player_is_escaping";
	
	nodes = getnodearray( "solarfield_pkg_route_1a", "targetname" );
	
	if( !flag( "player_is_escaping" ) )
	{
		self roaming_nodecluster_nav( nodes, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
	}
	
	self terminal_guidance();	
}

solarfield_routing_forest()
{
	//these guys are slower and sneakier
	//they carry heavier weapons
	
	assertEX( isalive( self ), "Tried to pass a dead AI into this function." );
	
	self endon ( "death" );
	
	self enable_cqbwalk();
	
	nodeLoiterTime = randomfloatrange( 0.5, 2 );
	nodeInitRadius = 1000;
	nodeEndRadius = 800;
	nodeClosureRate = 0.9;
	nodeClosureInterval = 5;
	earlyEndonMsg = "player_is_escaping";
	
	nodes = getnodearray( "solarfield_pkg_route_2a", "targetname" );
	
	if( !flag( "player_is_escaping" ) )
	{
		self roaming_nodecluster_nav( nodes, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
	}
	
	wait 10;
	
	self terminal_guidance();	
}


//=================================================

strike_package_frontyard_md500_rush()
{
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "strike_package_md500rush_dialogue" );
	
	//level.packageThresholdPop = 8;	//max number of AI that is allowed to be alive before deploying this group
	level.packageThresholdPop = 2;
	level.packageTime = 90;

	if( !flag( "dsm_recovered" ) )
	{
		thread strike_package_md500_rush_dialogue();
	}
	
	heli1 = spawn_vehicle_from_targetname_and_drive( "md500_rush_1" );	
	heli2 = spawn_vehicle_from_targetname_and_drive( "md500_rush_2" );	
	heli3 = spawn_vehicle_from_targetname_and_drive( "md500_rush_3" );	
	
	thread defense_helidrop_rider_setup( heli1, "md500_rush_1" );
	thread defense_helidrop_rider_setup( heli2, "md500_rush_2" );
	thread defense_helidrop_rider_setup( heli3, "md500_rush_3" );
	
	wait 3;
	
	flag_set( "strike_package_spawned" );
}

strike_package_md500_rush_dialogue()
{
	level endon ( "dsm_recovered" );
	
	//Enemy fast-attack choppers coming in from the northwest.	
	radio_dialogue( "est_snp1_fastattack" );
	
	//Roger that. Enemy helos approaching from the northwest.	
	radio_dialogue( "est_gst_helosnw" );
	
	if( isalive( level.scarecrow ) )
	{	
		//We gotta cover the front lawn! 	
		radio_dialogue( "est_scr_frontlawn" );
	}
	
	if( isalive( level.ozone ) )
	{
		node = getnode( "scarecrow_housebriefing_start", "targetname" );
		level.ozone disable_ai_color();
		level.ozone setgoalnode( node );
		
		//I'm moving to the main windows, I need someone to mine and cover the driveway approach.	
		radio_dialogue( "est_ozn_mainwindows" );
	}
	
	claymoreCount = level.player GetWeaponAmmoStock( "claymore" );
		
	if( level.gameSkill < 2 && !flag( "claymore_hint_printed" ) && claymoreCount > 4 )
	{
		//only print a hint on screen for easy and normal and if they have more than 5 claymores left in stockpile
		
		flag_set( "claymore_hint_printed" );
		level.player thread display_hint( "claymore_hint" );
	}
	
	//Roach, use your claymores on the driveway and pull back to the house!	
	radio_dialogue( "est_gst_useclaymores" );
	
	flag_clear( "strike_package_md500rush_dialogue" );
}

//****************************************//
// STRIKE COMPONENTS - BASIC SMOKEASSAULT
//****************************************//

//****************************************//
// STRIKE COMPONENTS - RPG TEAMS
//****************************************//

strike_component_rpg_team_stables()
{
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "rpg_stables_dialogue" );
	
	flag_set( "strike_component_activated" );
	
	level.componentThresholdPop = 24;	//max number of AI that is allowed to be alive before deploying this component
	
	flag_wait( "activate_component_on_standby" );
	flag_clear( "activate_component_on_standby" );
	
	core_spawn( "stables_rpg_team", ::rpg_team_nav, "stables_rpg_team_fp" );
	
	//RPG team moving in from the east!!	
	radio_dialogue( "est_snp1_rpgteameast" );
	
	if( isalive( level.ozone ) )
	{
		//Roger that, RPG team moving in from the east!!	
		radio_dialogue( "est_ozn_rpgteameast" );
	}
	
	flag_clear( "rpg_stables_dialogue" );
}

strike_component_rpg_team_boathouse()
{
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "rpg_boathouse_dialogue" );
	
	flag_set( "strike_component_activated" );
	
	level.componentThresholdPop = 23;	//max number of AI that is allowed to be alive before deploying this component
	
	flag_wait( "activate_component_on_standby" );
	flag_clear( "activate_component_on_standby" );
	
	core_spawn( "boathouse_rpg_team", ::rpg_team_nav, "boathouse_rpg_team_fp" );
	
	//RPG team approaching from the west!!	
	radio_dialogue( "est_snp1_rpgteamwest" );
	
	//Solid copy! RPG team approaching from the west!!	
	radio_dialogue( "est_gst_rpgteamwest" );
	
	flag_clear( "rpg_boathouse_dialogue" );
}

strike_component_rpg_team_southwest()
{
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );	
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "sniper_breaktime_dialogue" );
	
	flag_set( "rpg_southwest_dialogue" );
	
	flag_set( "strike_component_activated" );
	
	level.componentThresholdPop = 23;	//max number of AI that is allowed to be alive before deploying this component
	
	flag_wait( "activate_component_on_standby" );
	flag_clear( "activate_component_on_standby" );
	
	core_spawn( "southwest_rpg_team", ::rpg_team_nav, "southwest_rpg_team_fp" );
	
	//RPG team moving in from the southwest!!	
	radio_dialogue( "est_snp1_rpgteamsw" );
	
	if( isalive( level.ozone ) )
	{
		//Got it! RPG team moving in from the southwest!!	
		radio_dialogue( "est_ozn_rpgteamsw" );
	}
	
	flag_clear( "rpg_southwest_dialogue" );
}

rpg_team_nav( nodeName )
{
	assertEX( isalive( self ), "Tried to pass a dead AI into this function." );
	
	self endon ( "death" );
	
	nodes = getnodearray( nodeName, "targetname" );
	assertEX( nodes.size, "You have to place some nodes with the targetname " + nodeName );

	node = nodes[ randomint( nodes.size ) ];
	
	nodeLoiterTime = 2.5;
	nodeInitRadius = 2400;
	nodeEndRadius = 200;
	nodeClosureRate = 0.5;
	nodeClosureInterval = randomfloatrange( 0.5, 2  );
	earlyEndonMsg = "player_is_escaping";
	
	if( !flag( "player_is_escaping" ) )
	{
		self roaming_nodechain_nav( node, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
		self.goalradius = 2200;
		wait randomfloatrange( 25, 30 );
	}
	
	self terminal_guidance();	
}

//****************************************//
// HELICOPTER AI SPAWN
//****************************************//

defense_helidrop_rider_setup( heli, heliName )
{
	//wait 0.05;	//*TEMP* take this out when the heli riders bug is fixed
	riders = heli.riders;
	
	nodes = getnodearray( heliName, "targetname" );
	
	assertEX( nodes.size, "You have to have at least one node for the riders to attack towards, with the same targetname as the helicopter they're from." );
	
	startNode = nodes[ randomint( nodes.size ) ];

	//use targetnames on nodes tied to helicopters
	//one or more appropriate node chains lead to the DSM for a given helicopter
	//randomly pick one for the whole group so they stick together, send them on an attack mission
	
	foreach( rider in riders )
	{
		if( isdefined( rider.script_startingposition ) )
		{
			if( isdefined( heli.vehicletype ) )
			{
				if( heli.vehicletype == "littlebird" )
				{
					if( rider.script_startingposition == 1 )
					{
						continue;
					}
				}
				
				if( heli.vehicletype == "mi17" )
				{
					if( rider.script_startingposition == 0 )
					{
						continue;
					}
				}
			}
		}
		
		if( isalive( rider ) )
		{
			rider thread defense_helidrop_rider_deploy( heli, heliName, startNode );
		}
	}
	
}

defense_helidrop_rider_deploy( heli, heliName, startNode )
{
	assertEX( isalive( self ), "Tried to pass a dead AI into this function." );
	
	self endon( "death" );

	if ( isdefined( heli ) )
		heli waittill( "unloaded" );

	//access thread for customsettings

	settings = defense_helidrop_rider_settings( heliName );

	self.goalradius = settings[ "goalradius" ];
	
	node = startNode;
	
	nodeLoiterTime = settings[ "nodeLoiterTime" ];
	nodeInitRadius = settings[ "nodeInitRadius" ];
	nodeEndRadius = settings[ "nodeEndRadius" ];
	nodeClosureRate = settings[ "nodeClosureRate" ];
	nodeClosureInterval = randomfloatrange( settings[ "nodeClosureIntervalLow" ], settings[ "nodeClosureIntervalHigh" ] );
	
	earlyEndonMsg = "player_is_escaping";
	
	if( !flag( "player_is_escaping" ) )
	{
		self roaming_nodechain_nav( node, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg );
	}
	
	self terminal_guidance();
}

defense_helidrop_rider_settings( heliName )
{
	//filter by helicopter targetname
	
	settings = [];
	
	if( heliName == "md500_rush_1" )
	{
		settings[ "goalradius" ] = 3000;

		settings[ "nodeLoiterTime" ] = 8;
		settings[ "nodeInitRadius" ] = 3000;
		settings[ "nodeEndRadius" ] = 1400;
		settings[ "nodeClosureRate" ] = 0.75;
		settings[ "nodeClosureIntervalLow" ] = 3;
		settings[ "nodeClosureIntervalHigh" ] = 8;
	}
	if( heliName == "md500_rush_2" )
	{
		settings[ "goalradius" ] = 2000;
	
		settings[ "nodeLoiterTime" ] = 3;
		settings[ "nodeInitRadius" ] = 1600;
		settings[ "nodeEndRadius" ] = 800;
		settings[ "nodeClosureRate" ] = 0.5;
		settings[ "nodeClosureIntervalLow" ] = 8;
		settings[ "nodeClosureIntervalHigh" ] = 12;
	}
	if( heliName == "boathouse_md500" )
	{
		settings[ "goalradius" ] = 1600;
	
		settings[ "nodeLoiterTime" ] = 4;
		settings[ "nodeInitRadius" ] = 1600;
		settings[ "nodeEndRadius" ] = 1000;
		settings[ "nodeClosureRate" ] = 0.85;
		settings[ "nodeClosureIntervalLow" ] = 3;
		settings[ "nodeClosureIntervalHigh" ] = 6;
	}
	if( heliName == "boathouse_mi17" )
	{
		settings[ "goalradius" ] = 1800;
	
		settings[ "nodeLoiterTime" ] = 4;
		settings[ "nodeInitRadius" ] = 1800;
		settings[ "nodeEndRadius" ] = 1400;
		settings[ "nodeClosureRate" ] = 0.9;
		settings[ "nodeClosureIntervalLow" ] = 4;
		settings[ "nodeClosureIntervalHigh" ] = 6;
	}
	else
	{
		settings[ "goalradius" ] = 3000;
	
		settings[ "nodeLoiterTime" ] = 0;
		settings[ "nodeInitRadius" ] = 3000;
		settings[ "nodeEndRadius" ] = 1000;
		settings[ "nodeClosureRate" ] = 0.8;
		settings[ "nodeClosureIntervalLow" ] = 3;
		settings[ "nodeClosureIntervalHigh" ] = 7;
	}
	
	assertEX( settings.size == 7, "Missing one or more settings for one of the helidrop AI." );
	return( settings );	
}

//****************************************//
// AI SPAWN & BIOMETRICS
//****************************************//

core_spawn( spawnerName, spawnFunction, var )
{
	if ( !isdefined( var ) )
	{
		array_spawn_function_targetname( spawnerName, spawnFunction );
	}
	else
	{
		array_spawn_function_targetname( spawnerName, spawnFunction, var );
	}
	
	spawners = [];
    spawners = getentarray( spawnerName, "targetname" );
    array_thread( spawners, ::spawn_ai );  
}

defense_enemy_spawn()
{
	//this is run on all enemies that spawn after the download is started for enemy pop tracking
	
	array_spawn_function_noteworthy( "counterattacker", ::defense_enemy_init );
	array_spawn_function_noteworthy( "counterattacker", ::defense_enemy_flashbang_tweak );
	
}

defense_enemy_flashbang_tweak()
{
	if ( level.gameSkill >= 2 )
	{
		// hard and veteran
		self.doorFlashChance = 1;
	}
	else
	{
		// normal and easy
		self.doorFlashChance = .7;
	}
}

defense_enemy_init()
{
	self endon ( "death" );
	self thread defense_enemy_deathmonitor();
	level.enemyTotalPop++;
}

defense_enemy_deathmonitor()
{
	self waittill ( "death" );
	level notify ( "counterattacker_died" );
	level.enemyTotalPop--;
}

//****************************************//
// ENDING AI DRONES
//****************************************//

ending_shadowops_dronespawn()
{
	array_spawn_function_noteworthy( "ending_shadowops_drone", ::ending_shadowops_drone_init );
}

ending_shadowops_drone_init()
{
	self.team = "allies";
	self.pathRandomPercent = randomintrange( 0, 100 );
	self enable_cqbwalk();
	
	self waittill ( "goal" );
	self allowedstances( "crouch" );
}

//****************************************//
// AI NAVIGATION & ENCROACHMENT
//****************************************//

roaming_nodechain_nav( node, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg )
{
	//node 				= node to start from
	//nodeLoiterTime	= how long to stay at the current node post-closure phase, before being assigned to the next one
	//nodeEndRadius		= smallest goalradius around the node to reach before loitering
	//nodeClosureRate	= percentage of radius reduction per nodeClosureInterval to pull the AI closer to the node
	//nodeClosureInterval = time to wait before reducing the goalradius
	//earlyEndonMsg		= msg to endon
	
	self endon ( "death" );
	
	if ( isdefined( earlyEndonMsg ) )
	{
		level endon( earlyEndonMsg );
	}
	
	currentRadius = nodeInitRadius;
	
	while( 1 )
	{
		self setgoalnode( node );
		self waittill ( "goal" );
		
		while( currentRadius > nodeEndRadius )
		{
			currentRadius = currentRadius * nodeClosureRate;
			self.goalradius = currentRadius;
			self.goalheight = 32;
			self.pathRandomPercent = randomintrange( 0, 100 );
			self waittill ( "goal" );
			wait nodeClosureInterval;
		}
		
		wait nodeLoiterTime;
	
		if( isdefined( node.target ) )
			node = getnode( node.target, "targetname" );
		else
			break;
	}
}

roaming_nodecluster_nav( nodes, nodeLoiterTime, nodeInitRadius, nodeEndRadius, nodeClosureRate, nodeClosureInterval, earlyEndonMsg )
{
	//nodes				= array of potential starting nodes
	//nodeLoiterTime	= how long to stay at the current node post-closure phase, before being assigned to the next one
	//nodeEndRadius		= smallest goalradius around the node to reach before loitering
	//nodeClosureRate	= percentage of radius reduction per nodeClosureInterval to pull the AI closer to the node
	//nodeClosureInterval = time to wait before reducing the goalradius
	//earlyEndonMsg		= msg to endon
	
	//setup in map: make a set of starting nodes
		//draw an imaginary line to the end destination from the general starting area
		//set up multiple nodes at significantly different positions as 'clusters', 
		//each cluster is one side of the line only, clusters sequentially alternate sides of the line
	
	//randomly pick one of the starting nodes
	//use nodecluster encroachment loop with adjustable closure rate settings
	
	//randomly pick one node from the next 'cluster'
	//use nodecluster encroachment loop with adjustable closure rate settings
	//loop until no more clusters exist
	
	self endon ( "death" );
	
	if ( isdefined( earlyEndonMsg ) )
	{
		level endon( earlyEndonMsg );
	}
	
	currentRadius = nodeInitRadius;
	
	assertEX( isdefined( nodes ), "Must pass an array of starting nodes." );
	node = nodes[ randomint( nodes.size ) ];
	
	while( 1 )
	{	
		self setgoalnode( node );
		self waittill ( "goal" );
		
		while( currentRadius > nodeEndRadius )
		{
			currentRadius = currentRadius * nodeClosureRate;
			self.goalradius = currentRadius;
			self.goalheight = 32;
			self.pathRandomPercent = randomintrange( 0, 100 );
			self waittill ( "goal" );
			wait nodeClosureInterval;
		}
		
		wait nodeLoiterTime;
	
		if( isdefined( node.script_noteworthy ) )
		{
			nodes = getnodearray( node.script_noteworthy, "targetname" );
			assertEX( isdefined( nodes.size ), "Can't find any nodes with targetname " + node.script_noteworthy );
			
			node = nodes[ randomint( nodes.size ) ];
		}
		else
		{
			break;
		}
	}
}

terminal_guidance()
{
	//attack the DSM
	//attack the player using default AI if there is no DSM to attack
	//intercept the player on a new navigation goal if player_is_escaping is set
	
	self endon( "death" );
	
	//Start monitoring the trigger for failsafe suicide bombing if touched by this enemy
	//Do not start dsm destruction if the player has recovered the DSM && has hit the player_is_escaping trigger
	//However, navigation to the DSM is ok even if the DSM has been retrieved if player has not 'escaped' yet
	
	if( !flag( "player_is_escaping" ) )
	{	
		dsm = getent( "dsm", "targetname" );
		
		dsmKillNode = getnode( "dsm_killnode", "targetname" );
		self setgoalnode( dsmKillNode );
		self.goalradius = 4000;
		
		if( !flag( "dsm_recovered" ) && !flag( "dsm_destroyed" ) )
		{
			//self thread dsm_destruction_ai_trig( dsm );
			
			//Now they are made aware of the dsm as a sentient enemy if they haven't seen it already
			
			self getenemyinfo( dsm );	
		}
	}
	
	flag_wait( "player_is_escaping" );
	
	{
		self thread terminal_guidance_playerchase();
	}
}

terminal_guidance_playerchase()
{
	//AI nav once player is escaping with the DSM
	//NOW ATTACK THE PLAYER'S EXFIL ROUTE AND GO AFTER THE PLAYER MORE
	//CHANGE THE ai pursuit SETTINGS IN THE MASTER 'player is escaping' monitoring thread
	
	self endon ( "death" );
	
	chasenode = getnode( "chase_player", "targetname" );
	self setgoalnode( chasenode );
	self.goalradius = 3250;
	self.pathRandomPercent = randomintrange( 30, 100 );
	
	thread set_group_advance_to_enemy_parameters( 5, 1 );
}

terminal_hunters()
{
	flag_wait( "player_is_escaping" );
	
	exfil_hunters = getentarray( "player_exfil_hunter", "targetname" );
    array_thread( exfil_hunters, ::spawn_ai );
}

terminal_blockers()
{
	flag_wait( "point_of_no_return" );
	
	//The enemies that spawn here are too close to the ending dragging sequence, so don't spawn if testing that start point
	
	if( !flag( "test_ending" ) )
	{
		exfil_blockers = getentarray( "player_exfil_blocker", "targetname" );
    	array_thread( exfil_blockers, ::spawn_ai );
    }
}

terminal_hillchasers()
{
	flag_wait( "point_of_no_return" );
	
	trig = getent( "hillchaser_trigger", "targetname" );
	trig waittill ( "trigger" );
	
	exfil_hillchasers = getentarray( "player_exfil_hillchaser", "targetname" );
    array_thread( exfil_hillchasers, ::spawn_ai );
}

//****************************************//
// FRIENDLIES
//****************************************//

tough_friendly_biometrics( guy )
{
	self waittill ( "death" );
	
	assertEX( isdefined( guy ), "Must specify a string that is the name of the friendly." );
	
	if( guy == "scarecrow" )
	{
		//death notification dialogue for scarecrow
	}
	
	if( guy == "ozone" )
	{
		//death notification dialogue for ozone
	}
	
}

tough_friendly_kill()
{
	//TODO wait on a flag before killing them
	//TODO failsafe kill outright during field run from mortar hits!!
}

magic_sniper_guy()
{
	//Once in a while, our magic sniper guy Archer will kill an enemy for the player
	//Occasionally he will go out of contact and say so
	
	flag_wait( "defense_battle_begins" );
	
	flag_set( "sniper_in_position" );
	
	level endon ( "player_is_escaping" );		
	
	shot = false;
	
	while( !flag( "dsm_recovered" ) )
	{
		if( flag( "sniper_in_position" ) )	
		{					
			shot = magic_sniper_guy_targeting();
			wait randomfloatrange( 1, 3 );
			
			if( shot )
			{
				wait 2;
				shot = false;
			}
		}
		else
		{
			flag_wait( "sniper_in_position" );
		}
	}
} 

magic_sniper_guy_breaktimes()
{
	flag_wait( "defense_battle_begins" );
	
	level endon ( "player_is_escaping" );
	
	level waittill ( "magic_sniper_breaktime" );
	
	flag_waitopen( "strike_package_birchfield_dialogue" );
	flag_waitopen( "strike_package_bighelidrop_dialogue" );
	flag_waitopen( "strike_package_boathouse_dialogue" );
	flag_waitopen( "strike_package_solarfield_dialogue" );
	flag_waitopen( "strike_package_md500rush_dialogue" );
	flag_waitopen( "rpg_stables_dialogue" );
	flag_waitopen( "rpg_boathouse_dialogue" );
	flag_waitopen( "rpg_southwest_dialogue" );
	flag_waitopen( "ozone_death_dialogue" );
	flag_waitopen( "scarecrow_death_dialogue" );

	flag_set( "sniper_breaktime_dialogue" );

	if( flag( "sniper_attempting_shot" ) )
	{
		flag_waitopen( "sniper_attempting_shot" );
	}
	
	flag_clear( "sniper_in_position" );

	//I'm displacing. You're gonna be without sniper support for thirty seconds, standby.	
	radio_dialogue( "est_snp1_displacing" );
	
	flag_clear( "sniper_breaktime_dialogue" );

	wait 30;
	
	flag_set( "sniper_in_position" );
}

magic_sniper_guy_targeting( enemies )
{
	level endon ( "player_is_escaping" );
	
	killmsgs = [];
	
	killmsgs[ 0 ] = "est_snp1_tangodown"; 		
	killmsgs[ 1 ] = "est_snp1_gotone"; 			
	killmsgs[ 2 ] = "est_snp1_hostneut"; 		
	killmsgs[ 3 ] = "est_snp1_thatsakill"; 		
	killmsgs[ 4 ] = "est_snp1_thatsone"; 		
	killmsgs[ 5 ] = "est_snp1_tangodown2"; 		
	killmsgs[ 6 ] = "est_snp1_droppedhim"; 		
	killmsgs[ 7 ] = "est_snp1_hesdown"; 
	
	enemies = getaiarray( "axis" );
	
	foreach( enemy in enemies )
	{
		wait 1;
		
		if( isalive( enemy ) )
		{
			linesight = SightTracePassed( level.player.origin + ( 0, 0, 64 ), enemy.origin + ( 0, 0, 32 ), false, undefined );
			//if( linesight )
			
			//trace1 = player_can_see_ai( enemy );
			trace2 = enemy CanSee( level.player );
			dist = length( level.player.origin - enemy.origin );
			dangerCloseSniperRange = 480;	//so it's unlikely to happen in tight indoor spaces
			
			//if( enemy CanSee( level.player ) )
			//if( trace1 && trace2 && dist >= 480 )
			
			if( flag( "sniper_in_position" ) )
			{
				if( linesight && trace2 && dist >= 480 )
				{	
					flag_set( "sniper_attempting_shot" );	
					rnd = randomintrange( 0, 100 );
					if( rnd > 10 )
					{
						enemy thread play_sound_on_entity( "weap_cheytac_fire_plr" );
						enemy kill();
						wait 0.5;
						radio_dialogue( killmsgs[ randomint( killmsgs.size ) ] );
						flag_clear( "sniper_attempting_shot" );	
						return( true );
					}
					else
					{
						enemy play_sound_on_entity( "weap_cheytac_fire_plr" );
						flag_clear( "sniper_attempting_shot" );	
						return( false );
					}
				}
			}
		}
	}
	
	return( false );
}

//****************************************//
// DSM
//****************************************//

dsm_setup()
{
	flag_wait( "download_started" );
	
	//This struct controls the function stack for the ai that queue up to suicide bomb the dsm
	
	level.dsmDestructionController = spawnstruct();
	
	//This makes the dsm look like an AI to the enemy
	//They will seek cover in the goalradius at their engagementdist if no enemy
	//If they have an enemy, they will seek cover within the goalradius to attack the enemy
	//The dsm has a higher threatbias (defaults to 0 on AI) so they will prioritize hunting for it first
	//They will start engaging it at a range of maxvisibledist
	
	dsm = getent( "dsm", "targetname" );
	
	dsm MakeEntitySentient( "allies" );
	dsm.threatbias = 50;
	dsm.maxvisibledist = 300;
	
	thread set_group_advance_to_enemy_parameters( 6, 2 );
	
	flag_wait( "dsm_recovered" );
	
	dsm FreeEntitySentient();
}

dsm_display_control()
{
	dsm_real = getent( "dsm", "targetname" );
	dsm_obj = getent( "dsm_obj", "targetname" );
		
	dsm_real hide();
	dsm_obj hide();
		
	flag_wait( "dsm_ready_to_use" );
	
	trig = getent( "dsm_usetrigger", "targetname" );
	trig sethintstring( &"ESTATE_DSM_USE_HINT" );
	
	dsm_obj show();
	
	flag_wait( "download_started" );
	flag_set( "dsm_exposed" );
	
	autosave_by_name( "started_download" );
	
	dsm_obj hide();
	dsm_real show();
	
	dsm_real thread dsm_sounds();
	
	flag_clear( "dsm_ready_to_use" );
	
	trig sethintstring( &"ESTATE_DSM_PICKUP_HINT" );
	
	flag_wait( "download_complete" );
	flag_set( "dsm_ready_to_use" );
	
	dsm_obj show();
	
	trig waittill ( "trigger" );
	
	level.player thread play_sound_on_entity( "dsm_pickup" );
	
	if( !flag( "fence_removed" ) )
	{
		fence = getent( "final_area_fence", "targetname" ); 
		fence delete();
		flag_set( "fence_removed" );
	}
	
	flag_clear( "dsm_ready_to_use" );
	flag_clear( "dsm_exposed" );
	
	dsm_obj delete();
	dsm_real hide();
	
	flag_set( "dsm_recovered" );
	
	if( !flag( "can_save" ) )
	{
		flag_set( "can_save" );
	}
}

dsm_sounds()
{
	self playsound( "scn_estate_data_grab_setdown" );
	
	wait 2;
	
	self playloopsound( "scn_estate_data_grab_loop" );
	
	flag_wait( "download_complete" );
	
	self stoploopsound();
}

download_progress()
{
	flag_wait( "download_started" );
	
	level endon ( "main_defense_fight_finished" );
	level endon ( "player_is_escaping" );
	level endon ( "dsm_has_been_destroyed" );
	
	if( !flag( "download_test" ) )
	{
		level.hudelem = maps\_hud_util::get_countdown_hud( -300, undefined, undefined, true );
		level.hudelem SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
		level.hudelem.label = &"ESTATE_DSM_FRAME";	// DSM v6.04
		//level.hudelem.fontScale = 1.5;
		wait 0.65;
		
		level.hudelem_status = maps\_hud_util::get_countdown_hud( -200, undefined, undefined, true );
		level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
		level.hudelem_status.label = &"ESTATE_DSM_WORKING"; // ...working...
		wait 2.85;
		
		level.hudelem_status destroy();
		level.hudelem_status = maps\_hud_util::get_countdown_hud( -200, undefined, undefined, true );
		level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
		level.hudelem_status.label = &"ESTATE_DSM_NETWORK_FOUND"; // ...network found...
		wait 3.75;
		
		level.hudelem_status destroy();
		level.hudelem_status = maps\_hud_util::get_countdown_hud( -200, undefined, undefined, true );
		level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
		level.hudelem_status.label = &"ESTATE_DSM_IRONBOX"; // ...ironbox detected...
		wait 2.25; 
		
		level.hudelem_status destroy();
		
		level.hudelem_status = maps\_hud_util::get_countdown_hud( -200, undefined, undefined, true );
		level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
		level.hudelem_status.label = &"ESTATE_DSM_BYPASS"; // ...bypassed.
		wait 3.1;
		
		level.hudelem destroy();
		level.hudelem_status destroy();	
	}
	
	//Download meter - internally fixed time, visibly variable rate update, hard coded

	//6 minutes of defense battle gameplay

	//58 files at 1 file per second = 58 s
	//122 files at 2 files per second = 61 s
	//244 files at 4 files per second = 61 s
	//600 files at 10 files per second = 60 s
	//2400 files at 20 files per second max rate = 120s

	//3424 files over 360s (6 mins)
	
	//medium version
	
	//5 minutes of defense battle gameplay

	//88 files at 1 file per second = 88 s
	//122 files at 2 files per second = 61 s
	//204 files at 4 files per second = 51 s
	//600 files at 10 files per second = 60 s
	//800 files at 20 files per second max rate = 40s

	//1814 files over 300s (5 mins)
	
	//short version
	
	//4 minutes of defense battle gameplay

	//58 files at 1 file per second = 58 s
	//62 files at 2 files per second = 31 s
	//124 files at 4 files per second = 31 s
	//300 files at 10 files per second = 30 s
	//600 files at 20 files per second max rate = 30s

	//1144 files over 180s (3 mins)
	
	//subtract from available time pool
	//only increment by 1 second, cycle through the rates on a per second basis up and down, 12345, 54321 = marker
	
	level.currentfiles = 0;
	
	//8 minutes
	
	/*
	level.downloadGroups = [];
	level.downloadGroups[ 1 ] = 58;		//1
	level.downloadGroups[ 2 ] = 2400;	//20 fps
	level.downloadGroups[ 3 ] = 122;	//2 fps
	level.downloadGroups[ 4 ] = 244;	//4 fps
	level.downloadGroups[ 5 ] = 600;	//10 fps
	*/
	
	//5 minutes
	
	level.downloadGroups = [];
	level.downloadGroups[ 1 ] = 95;		//1 fps		//5 files per 5 second burst //100 files = 100 seconds
	level.downloadGroups[ 2 ] = 1280;	//20 fps 	//80 files per 4 second burst //1280 files = 64 seconds
	level.downloadGroups[ 3 ] = 112;	//2 fps		//8 files per 4 second burst //112 files = 56 seconds
	level.downloadGroups[ 4 ] = 180;	//4 fps		//12 files per 3 second burst //180 files = 45 seconds
	level.downloadGroups[ 5 ] = 400;	//10 fps 	//50 files per 5 second burst //350 files = 35 seconds
	
	//For testing timer and file meter
	/*
	level.downloadGroups = [];
	level.downloadGroups[ 1 ] = 35;	//1 fps	//5 files per 5 second burst //100 files = 100 seconds
	level.downloadGroups[ 2 ] = 560;	//20 fps //80 files per 4 second burst //1200 files = 60 seconds
	level.downloadGroups[ 3 ] = 56;	//2 fps	//8 files seconds per 4 second burst //120 files = 60 seconds
	level.downloadGroups[ 4 ] = 84;	//4 fps	//12 files seconds per 3 second burst //180 files = 45 seconds
	level.downloadGroups[ 5 ] = 350;	//10 fps //50 files per 5 second burst //350 files = 35 seconds
	*/
	
	//3 minutes
	
	/*
	level.downloadGroups = [];
	level.downloadGroups[ 1 ] = 58;		//1 fps
	level.downloadGroups[ 2 ] = 600;	//20 fps
	level.downloadGroups[ 3 ] = 62;		//2 fps
	level.downloadGroups[ 4 ] = 124;	//4 fps
	level.downloadGroups[ 5 ] = 300;	//10 fps
	*/
	
	level.totalfiles = 0;
	
	for( i = 1; i <= 5; i++ )
	{
		level.totalfiles = level.totalfiles + level.downloadGroups[ i ];
	}
	
	level.hudelem = maps\_hud_util::get_countdown_hud( -210 );	//205
	level.hudelem SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem.label = &"ESTATE_DSM_PROGRESS"; // Files copied:
	
	level.hudelem_status = maps\_hud_util::get_download_state_hud( -62, undefined, undefined, true );
	level.hudelem_status SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_status setvalue( 0 );
	
	level.hudelem_status_total = maps\_hud_util::get_countdown_hud( -62, undefined, undefined, true );
	level.hudelem_status_total SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	
	//level.hudelem_status_total.label = "/" + level.totalfiles;
	level.hudelem_status_total.label = &"ESTATE_DSM_SLASH_TOTALFILES";
	
	level.hudelem_dltimer_heading = maps\_hud_util::get_countdown_hud( -210, 120 );
	level.hudelem_dltimer_heading SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_dltimer_heading.label = &"ESTATE_DSM_DLTIMELEFT";	// Time left:
	level.hudelem_dltimer_heading.fontScale = 1.1;
	level.hudelem_dltimer_heading.color = ( 0.4, 0.5, 0.4 );
	
	level.hudelem_dltimer_value = maps\_hud_util::get_countdown_hud( -132, 120, undefined, true );
	level.hudelem_dltimer_value SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_dltimer_value.fontScale = 1.1;
	level.hudelem_dltimer_value.color = ( 0.4, 0.5, 0.4 );
	level.hudelem_dltimer_value.alignX = "right";
	
	level.hudelem_dltimer_units = maps\_hud_util::get_countdown_hud( -126, 120, undefined, true );
	level.hudelem_dltimer_units SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_dltimer_units.label = &"ESTATE_DSM_DLTIMELEFT_MINS";	// mins
	level.hudelem_dltimer_units.fontScale = 1.1;
	level.hudelem_dltimer_units.color = ( 0.4, 0.5, 0.4 );
	
	level.hudelem_dlrate_heading = maps\_hud_util::get_countdown_hud( -91, 120, undefined, true );
	level.hudelem_dlrate_heading SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_dlrate_heading.label = &"ESTATE_DSM_DL_RATEMETER";	// at
	level.hudelem_dlrate_heading.fontScale = 1.1;
	level.hudelem_dlrate_heading.color = ( 0.4, 0.5, 0.4 );
	
	level.hudelem_dlrate_value = maps\_hud_util::get_countdown_hud( -44, 120, undefined, true );
	level.hudelem_dlrate_value SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_dlrate_value.fontScale = 1.1;
	level.hudelem_dlrate_value.color = ( 0.4, 0.5, 0.4 );
	level.hudelem_dlrate_value.alignX = "right";
	
	level.hudelem_dlrate_units = maps\_hud_util::get_countdown_hud( -41, 120, undefined, true );
	level.hudelem_dlrate_units SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.hudelem_dlrate_units.label = &"ESTATE_DSM_DLRATE";	// Mbps
	level.hudelem_dlrate_units.fontScale = 1.1;
	level.hudelem_dlrate_units.color = ( 0.4, 0.5, 0.4 );
	
	level.switchtosecs = 0.85;
	
	flag_set( "download_data_initialized" );
	
	marker = undefined;
	rateTime = undefined;
	segment = undefined;
	
	startTime = gettime();
	
 	while( level.currentfiles < level.totalfiles )
 	{
 		/*
 		if( level.currentfiles > 1200 )
 		{
 			thread ending_moments();
 			badguys = getaiarray( "axis" );
 			foreach( guy in badguys )
 			{
 				guy kill();
 			}
 			break;
 		}
 		*/	
 				
 		level.timeElapsed = ( gettime() - startTime ) / 1000;
 		
 		fileSegment = 0;		
 		
 		//Select a download rate
 		
 		num = randomintrange( 1, 100 );
 		
 		if( num > 0 && num < 10 ) 
 		{
 			marker = 5;
 		}
 		
 		if( num >= 10 && num < 25 ) 
 		{
 			marker = 2;
 		}
 		
 		if( num >= 25 && num < 50 ) 
 		{
 			marker = 1;
 		}
 		
 		if( num >= 50 && num < 75 )
 		{
 			marker = 3;
 		}
 		
 		if( num >= 75 && num < 100 )
 		{
 			marker = 4;
 		}
 		 
 		switch( marker )
 		{
 			case 1:
 				//segment = 1;
 				segment = 5;
 				rateTime = 1;		//1 fps	//5 seconds per burst
 				break;
 			case 2:
 				//segment = 20;
 				segment = 80;
 				rateTime = 1 / 20;	//20 fps //4 seconds per burst
 				break;
 			case 3:
 				//segment = 2;
 				segment = 8;
 				rateTime = 1 / 2;	//2 fps	//4 seconds per burst
 				break;
 			case 4:
 				//segment = 4;
 				segment = 12;
 				rateTime = 1 / 4;	//4 fps	//3 seconds per burst
 				break;
 			case 5:
 				//segment = 10;
 				segment = 50;
 				rateTime = 1 / 10; 	//10 fps //5 seconds per burst
 				break;
 		}
 		
 		download_update( fileSegment, segment, rateTime, marker );

		if( marker == 5 )
 		{
 			marker = 1;
 		}
 		else
 		{
 			marker++;
 		}
 	}
	
	flag_set( "download_complete" );
	
	if( !flag( "can_save" ) )
		flag_set( "can_save" );
	
	thread download_display_delete();
}

download_display_delete()
{
	if ( isdefined( level.hudelem ) )
		level.hudelem destroy();
	
	if ( isdefined( level.hudelem_status ) )
		level.hudelem_status destroy();
	
	if ( isdefined( level.hudelem_status_total ) )
		level.hudelem_status_total destroy();
	
	//TIMER
		
	if ( isdefined( level.hudelem_dltimer ) )
		level.hudelem_dltimer destroy();
		
	if ( isdefined( level.hudelem_dltimer_value ) )
		level.hudelem_dltimer_value destroy();
	
	if ( isdefined( level.hudelem_dltimer_heading ) )
		level.hudelem_dltimer_heading destroy();
	
	if ( isdefined( level.hudelem_dltimer_secs ) )
		level.hudelem_dltimer_secs destroy();
	
	//DATA RATE

	if ( isdefined( level.hudelem_dlrate_heading ) )
		level.hudelem_dlrate_heading destroy();
		
	if ( isdefined( level.hudelem_dltimer_units ) )
		level.hudelem_dltimer_units destroy();
		
	if ( isdefined( level.hudelem_dlrate_value ) )
		level.hudelem_dlrate_value destroy();
	
	if ( isdefined( level.hudelem_dlrate_units ) )
		level.hudelem_dlrate_units destroy();	
}

download_update( fileSegment, segment, rateTime, marker )
{
	level endon ( "dsm_has_been_destroyed" );
	
	if( !level.downloadGroups[ marker ] )
		return;
		
	//set the download Mbps rate to dovetail the change in file acquisition speed
	//make the time remaining based off a constant known data size	
	
	//300 seconds at 20fps is 6000 files, top sustained speed of 26.8 Mbps
	
	//300 seconds at 20 fps (5 minutes) +/- 2 minutes, 26.8 +/- 6 Mbps
	//6000 seconds at 1 fps (100 minutes) +/- 30 minutes, 0.13 +/- 0.05 Mbps
	//3000 seconds at 2 fps (50 minutes) +/- 15 minutes, 0.3 +/- 0.16 Mbps
	//1500 seconds at 4 fps (25 minutes) +/- 8 minutes, 5 +/- 2.2 Mbps
	//600 seconds at 10 fps (10 minutes) +/- 3 minutes, 14 +/- 3.7 Mbps
	
	dlrate = undefined;
	timeleft = undefined;
	
	switch( marker )
	{
		case 1:	//1 fps
			timeleft = randomintrange( 70, 130 );
			dlrate = randomfloatrange( 0.08, 0.18 );
			break;
		case 2: //20 fps
			timeleft = randomintrange( 3, 5 );
			dlrate = randomfloatrange( 20.8, 32.8 );
			break;
		case 3: //2 fps
			timeleft = randomintrange( 35, 65 );
			dlrate = randomfloatrange( 0.17, 0.46 );
			break;
		case 4: //4 fps
			timeleft = randomintrange( 17, 33 );
			dlrate = randomfloatrange( 2.8, 7.2 );
			break;
		case 5: //10 fps
			timeleft = randomintrange( 7, 13 );
			dlrate = randomfloatrange( 11.7, 17.7 );
			break;
	}
	
	dlrate = digi_rounder( dlrate );
	
	frac = level.currentfiles / level.totalfiles;
	
	if( frac < level.switchtosecs )
	{
		level.hudelem_dltimer_value setvalue( timeleft );	
	}
	
	level.hudelem_dlrate_value SetValue( dlrate ) ;
		
	while( fileSegment < segment )
	{
		fileSegment++;
		
		level.currentfiles++;
		level.hudelem_status Setvalue( level.currentfiles );
		
		dsm_real = getent( "dsm", "targetname" );
		playerDSMdist = length( level.player.origin - dsm_real.origin );
		
		//Save only if player is within reasonable range of DSM 
		//&& DSM is at 70% integrity or greater 
		//&& not in the basement areas (a bit of anti-camping)
		
		badsave_volume = getent( "no_autosave_in_basement", "targetname" );
		
		safeDSMhealth = level.dsmHealthMax * 0.7;
		
		if( playerDSMdist <= level.playerDSMsafedist && level.dsmHealth >= safeDSMhealth )
		{
			if( !( level.player istouching( badsave_volume ) ) )
			{
				if( level.currentfiles == 300 )
				{
					autosave_by_name( "saved_during_download" );
				}
		 		
		 		if( level.currentfiles == 600 )
				{
					autosave_by_name( "saved_during_download" );
				}
				
				if( level.currentfiles == 900 )
				{
					autosave_by_name( "saved_during_download" );
				}
		 		
		 		if( level.currentfiles == 1200 )
				{
					autosave_by_name( "saved_during_download" );
				}
				
				if( level.currentfiles == 1500 )
				{
					autosave_by_name( "saved_during_download" );
				}
			}
		}
		
		if( level.currentfiles == 1000 )
 		{
 			level notify ( "magic_sniper_breaktime" );
 		}	

		level.downloadGroups[ marker ]--;
		
		wait rateTime;
	}
}

download_fake_timer()
{
	level endon ( "dsm_has_been_destroyed" );
	
	flag_wait( "download_data_initialized" );
	
	timeleft = 0;
	erase_minutes = 0;
	
	while( !flag( "download_complete" ) )
	{
		frac = level.currentfiles / level.totalfiles;
		
		if( frac >= level.switchtosecs && frac < 1 && !erase_minutes )
		{
			erase_minutes = true;
			level.hudelem_dltimer_units.label = &"ESTATE_DSM_DLTIMELEFT_SECS";	// secs
		}
		
		if( frac >= level.switchtosecs && frac < 1 )
		{		
			time1 = level.downloadGroups[ 1 ] / 1;
			time2 = level.downloadGroups[ 2 ] / 20;
			time3 = level.downloadGroups[ 3 ] / 2;
			time4 = level.downloadGroups[ 4 ] / 4;
			time5 = level.downloadGroups[ 5 ] / 10;
			
			timeleft = time1 + time2 + time3 + time4 + time5;
			
			timeleft = digi_rounder( timeleft, 1 );
			
			wait 0.05;
			
			level.hudelem_dltimer_value setvalue( timeleft );
			
			continue;
		}
		
		wait 0.05;
	}
}

digi_rounder( num, tenthsonly )
{
	//Adjusts num to total of 3 sigfigs if > 1, 2 sigfigs if < 1
	
	if( num >= 10 || isdefined( tenthsonly ) )
	{
		num = num * 10;
		num = int( num );
		num = num / 10;
	}
	else
	{
		num = num * 100;
		num = int( num );
		num = num / 100;
	}
	
	if( num >= 10 || isdefined( tenthsonly ) )
	{
		intnum = int( num );
		diff = num - intnum;
		if( diff == 0 )
		{
			num = num + 0.1;
		}
	}
	else
	if( num < 10 && num >= 1 )
	{
		//8.2 vs. 8.25
		//7.6 vs. 7.68
		
		bignum = num * 10;			//82 vs. 82.5
		checknum = int( num * 10 );	//82 vs. 82
		
		diff = bignum - checknum;	//0 & 0.5
		
		if( diff == 0 )
		{
			num = num + 0.01;
		}
	}
	else
	if( num < 1 && num >= 0.1 )
	{	
		intchecknum = int( num * 10 );	
		checknum = intchecknum / 10;	
		
		intnum = int( num * 100 );		
		intchecknum = int( checknum * 100 );	
		
		mod = intnum % intchecknum;	//mod only accepts integers
	
		if( mod == 0 )
		{
			num = num + 0.01;
		}
	}
	else
	if( num < 0.1 )
	{
		intchecknum = int( num * 100 );
		num = intchecknum / 100;
	}

	return( num );
}

dsm_health_regen()
{
	//regenerates the health of the dsm
	
	flag_wait( "download_started" );
	
	while( !flag( "dsm_recovered" ) )
	{
		boostedVal = level.dsmHealth + level.dsm_regen_amount;
		
		if( boostedVal >= level.dsmHealthMax )
		{
			//cap it
			level.dsmHealth = level.dsmHealthMax;
		}
		else
		{
			level.dsmHealth = boostedVal;
		}
		
		wait 1;
	}
}

dsm_health_regen_calc()
{
	//adjusts the regen per second amount of the dsm
	
	flag_wait( "download_started" );
	
	dsm_real = getent( "dsm", "targetname" );
	dsm_org = dsm_real.origin;
	
	while( !flag( "dsm_recovered" ) )
	{
		dist = length( level.player.origin - dsm_org );
		
		if( dist >= level.dsm_regen_dist_limit )
		{
			level.dsm_regen_amount = 0;
		 	wait 0.25;
		 	continue;
		}
		else
		{
			factor = ( level.dsm_regen_dist_limit - dist ) / level.dsm_regen_dist_limit;
			level.dsm_regen_amount = factor * level.dsm_regen_amount_max;
		}
		
		wait 0.25;
	}
}

dsm_destruction_damage_detect()
{
	level endon ( "dsm_recovered" );
	
	flag_wait( "download_started" );
	
	trig = getent( "dsm_dmg_trigger", "targetname" );

	while( !flag( "dsm_recovered" ) )
	{
		trig waittill ( "damage", amount, attacker );
		
		//stray shot protection on AI, AI must be within X units
		
		if( attacker != level.player )
		{
			dist = length( trig.origin - attacker.origin );
			
			if( dist < 512 )
			{
				level.dsmHealth = level.dsmHealth - amount;
			}
		}
		else
		{
			level.dsmHealth = level.dsmHealth - amount;
		}
		
		if( level.dsmHealth <= 500 )
		{
			flag_clear( "can_save" );
		}
		
		if( level.dsmHealth > 500 )
		{
			flag_set( "can_save" );
		}
		
		if( level.dsmHealth <= 0 )
		{
			if( attacker == level.player )
			{
				setdvar( "ui_deadquote", &"ESTATE_DSM_DESTROYED_BY_PLAYER" );
			}
			else
			{
				setdvar( "ui_deadquote", &"ESTATE_DSM_DESTROYED_BY_AI_GUNFIRE" );	
			}
			
			level notify ( "dsm_has_been_destroyed" );
			thread download_display_delete();
			
			missionFailedWrapper();	
		}
	}
}

/*

dsm_destruction_ai_trig( dsm )
{
	//When an enemy AI touches this trigger while the DSM is downloading, begin the dsm destruction process.
	
	self endon ( "death" );
	level endon ( "dsm_recovered" );
	
	trig = getent( "dsm_suicide_trig", "targetname" );
	
	while( 1 )
	{
		trig waittill( "trigger", other );
		if( other == self )
		{
			break;
		}
	}
	
	//Only one enemy AI can run the destruction function at a time, they get queued up
	
	level.dsmDestructionController function_stack( ::dsm_destruction_ai, self, dsm );
}

dsm_destruction_ai( guy, dsm )
{
	guy endon ( "death" );
	level endon ( "dsm_recovered" );
	
	//Player can prevent dsm destruction until this sound effect ends
	
	//dsm play_sound_on_entity( "RU_4_inform_attack_grenade" );
	
	screams = [];
	screams[ screams.size ] = "est_ru1_attack";
	screams[ screams.size ] = "est_ru2_attack";
	screams[ screams.size ] = "est_ru3_attack";
	screams[ screams.size ] = "est_ru4_attack";
	
	dsm play_sound_on_entity( screams[ randomint( screams.size ) ] );

	//This is the point of no return
	
	org = guy.origin;
	
	flag_set( "dsm_compromised" );
	
	level.ghost stop_magic_bullet_shield();
	level.ghost.health = 1;
	
	thread dsm_suicide_bombing( org, dsm );
}

dsm_suicide_bombing( org, dsm )
{
	//DSM suicide bombing fx
	
	level endon ( "dsm_recovered" );
	
	playFX( getfx( "suicide_bomber" ), org );
	detorg = spawn( "script_origin", org );
	detorg playsound( "clusterbomb_explode_default" );
	RadiusDamage( org, 512, 5000, 1000 );
	earthquake( 0.25, 1, org, 2000 );
	flag_set( "dsm_destroyed" );
	//dsm delete();
	//dsm hide();
	
	//wait 0.5;
	
	setdvar( "ui_deadquote", &"ESTATE_DSM_DESTROYED_BY_AI_DETONATION" );
	missionFailedWrapper();	
}

*/

//*************************************************
// FRIENDLY DEATH CONTROL
//*************************************************

//These are failsafes for friendly death if they don't die during the dsm defense
//If they are alive during the player escape, one is shot by enemies, the other is mortared, guaranteed, plus their health is dropped

friendly_death_cointoss()
{
	flag_wait( "player_is_escaping" );
	
	level.cointoss = cointoss();
	
	wait 0.1;
	
	flag_set( "cointoss_done" );
}

scarecrow_death_decide()
{
	self endon ( "death" );
	
	flag_wait( "cointoss_done" );
	
	if( level.cointoss )
	{
		self thread friendly_death_bullet();
	}
	else
	{
		self thread friendly_death_mortar();
	}
}

ozone_death_decide()
{
	self endon ( "death" );
	
	flag_wait( "cointoss_done" );
	
	if( level.cointoss )
	{
		self thread friendly_death_mortar();
	}
	else
	{
		self thread friendly_death_bullet();
	}
}

friendly_death_bullet()
{
	self endon ( "death" );
	
	flag_wait( "birchfield_cleared_sector2" );
	
	source = getent( "breach_tweak_start", "targetname" );
	sourceOrg = source.origin;
	
	MagicBullet( "cheytac", sourceOrg, self.origin + ( 0, 0, 60 ) );
	
	self kill();
}

friendly_death_mortar()
{
	self endon ( "death" );
	
	flag_wait( "point_of_no_return" );
	
	org = self.origin;
	
	playFX( level._effect[ "mortar" ][ "dirt" ], org );
	detorg = spawn( "script_origin", org );
	detorg playsound( "clusterbomb_explode_default" );
	
	self kill();
}

deathtalk_scarecrow()
{
	self waittill ( "death" );
	
	if( !flag( "player_is_escaping" ) )
	{
		//I'm hit - (static hiss) 	
		
		node = getnode( "scarecrow_earlydefense_start", "targetname" );
		playerCanSeeFriendly = SightTracePassed( level.player.origin, node.origin, true, undefined );
		dist = length( level.player.origin - node.origin );
		
		if( dist > 384 && !playerCanSeeFriendly )
		{
			radio_dialogue( "est_scr_imhit" );
		}
		
		startTime = gettime();
		
		flag_waitopen( "strike_package_birchfield_dialogue" );
		flag_waitopen( "strike_package_bighelidrop_dialogue" );
		flag_waitopen( "strike_package_boathouse_dialogue" );
		flag_waitopen( "strike_package_solarfield_dialogue" );
		flag_waitopen( "strike_package_md500rush_dialogue" );
		flag_waitopen( "rpg_stables_dialogue" );
		flag_waitopen( "rpg_boathouse_dialogue" );
		flag_waitopen( "rpg_southwest_dialogue" );
		flag_waitopen( "ozone_death_dialogue" );
		flag_waitopen( "sniper_breaktime_dialogue" );
	
		timeLimit = 0.5 * 1000;
		clearedTime = gettime();
		timeElapsed = clearedTime - startTime;
		
		if( timeElapsed <= timeLimit )
		{
			flag_set( "scarecrow_death_dialogue" );
		
			//Scarecrow is down, I repeat Scarecrow is down!	
			radio_dialogue( "est_snp1_scarecrowdown" );
			
			flag_clear( "scarecrow_death_dialogue" );
		}
	}
}

deathtalk_ozone()
{
	self waittill ( "death" );
	
	if( !flag( "player_is_escaping" ) )
	{
		//Aaagh! I'm hit!!! Need assis- (static hiss)	
		radio_dialogue( "est_ozn_imhit" );
		
		startTime = gettime();
		
		flag_waitopen( "strike_package_birchfield_dialogue" );
		flag_waitopen( "strike_package_bighelidrop_dialogue" );
		flag_waitopen( "strike_package_boathouse_dialogue" );
		flag_waitopen( "strike_package_solarfield_dialogue" );
		flag_waitopen( "strike_package_md500rush_dialogue" );
		flag_waitopen( "rpg_stables_dialogue" );
		flag_waitopen( "rpg_boathouse_dialogue" );
		flag_waitopen( "rpg_southwest_dialogue" );
		flag_waitopen( "scarecrow_death_dialogue" );
		flag_waitopen( "sniper_breaktime_dialogue" );
		
		timeLimit = 0.5 * 1000;
		clearedTime = gettime();
		timeElapsed = clearedTime - startTime;
		
		if( timeElapsed <= timeLimit )
		{
			flag_set( "ozone_death_dialogue" );
		
			//Ozone is down!	
			radio_dialogue( "est_snp1_ozoneisdown" );	
			
			flag_clear( "ozone_death_dialogue" );
		}
	}
}
	
//****************************************//
// ABANDONMENT UTILS
//****************************************//

abandonment_start_monitor()
{
	flag_wait( "strike_packages_definitely_underway" );
	
	//If player is already in the desertion zone when we start monitoring for desertion
	//Wait for him to leave the desertion zone and then start enforcing failure
	
	//Otherwise, start enforcing failure immediately
	
	if( flag( "abandonment_danger_zone" ) )
	{
		flag_waitopen( "abandonment_danger_zone" );	
		
		flag_set( "player_can_fail_by_desertion" );
	}
	else
	{
		flag_set( "player_can_fail_by_desertion" );
	}
}

abandonment_early_escape_timer()
{
	//If player is already in the desertion zone when we start monitoring for desertion
	//Give player some amount of time to get out of the zone before we start enforcing failure
	
	level endon ( "dsm_recovered" );
	
	flag_wait( "strike_packages_definitely_underway" );	
	
	wait level.early_escape_timelimit;
	
	flag_set( "player_can_fail_by_desertion" );
}

abandonment_exit_tracking()
{
	level endon ( "dsm_recovered" );
	level endon ( "player_deserted_the_area" );
	
	flag_wait( "strike_packages_definitely_underway" );
	
	while( 1 )
	{
		flag_waitopen( "abandonment_danger_zone" );	
		level notify ( "player_is_out_of_danger_zone" );
		flag_wait( "abandonment_danger_zone" );
	}
}

abandonment_main_check()
{
	//Begins when we start enforcing failure officially
	
	level endon ( "dsm_recovered" );
	level endon ( "player_deserted_the_area" );
	
	flag_wait( "strike_packages_definitely_underway" );
	
	//trigger_multiple_flag_set_touching detect player at danger zone
		//clear save
		//start timer until abandonment trigger is untouched
		
	while( 1 )
	{
		flag_wait( "abandonment_danger_zone" );
		
		flag_clear( "can_save" );
		thread abandonment_danger_zone_timer();			
		flag_waitopen( "abandonment_danger_zone" );
		flag_set( "can_save" );
	}
}

abandonment_danger_zone_timer()
{
	level endon ( "dsm_recovered" );
	level endon ( "player_deserted_the_area" );
	level endon ( "player_is_out_of_danger_zone" );
	
	//play initial danger dialogue
	//play serious warning dialogue

	if( !level.usedFirstWarning )
	{
		//Roach! Don't stray too far from the safehouse! We need to protect the transfer!		
		thread radio_dialogue( "est_gst_dontstray" );
		
		level.usedFirstWarning = true;
	}
	else
	{
		//Roach! Stay the close to the house!		
		thread radio_dialogue( "est_gst_stayclose" );
		
		level.usedFirstWarning = false;
	}
	
	wait level.dangerZoneTimeLimit / 2;
	
	if( !level.usedSecondWarning )
	{
		//Roach, where the hell are you?! Fall back to the house! Move!	
		thread radio_dialogue( "est_gst_fallback" );
	
		level.usedSecondWarning = true;
	}
	else
	{
		//Roach, pull back to the safehouse! They're trying to stop the transfer!		
		thread radio_dialogue( "est_gst_tryingtostop" );
	
		level.usedSecondWarning = false;
	}
	
	wait level.dangerZoneTimeLimit / 2;
	
	//fail the mission if the time limit is reached and player has not exited the danger zone
	flag_set( "player_entered_autofail_zone" );
}

abandonment_failure()
{	
	flag_wait( "player_can_fail_by_desertion" );
	
	flag_wait( "player_entered_autofail_zone" );
	
	//trigger_multiple_flag_set_touching detect player into fail zone
	//play failure dialogue
	//fail mission	
	
	level notify ( "player_deserted_the_area" );
	
	//Roach! They've destroyed the DSM!! They've destroyed-(static hiss)	
	radio_dialogue( "est_gst_destroyedthedsm" );
	radio_dialogue_stop();
	
	setdvar( "ui_deadquote", &"ESTATE_DSM_DESTROYED_BY_DESERTION" );	
	
	missionFailedWrapper();
	
	//Maybe I'll use this if I need it
	//There's too many of them in here! Roach!!! We've lost the DSM, I repeat we've lost-(static hiss)		
	//radio_dialogue( "est_gst_lostthedsm" );
}
	
//****************************************//
// SMOKESCREEN UTILS
//****************************************//

smokescreen( smokepotName )
{
	smokeMachines = getentarray( smokepotName, "targetname" );
	foreach( machine in smokeMachines )
	{
		machine thread smokepot();
	}
}

smokepot()
{
	playFX( getfx( "smoke_cloud" ), self.origin );
	self playsound( "estate_smokegrenade_explode" );
}

//****************************************//
// VISION SET UTILS
//****************************************//

blackOut( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 1, blur );
}

grayOut( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 0.6, blur );
}

restoreVision( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 0, blur );
}

fadeOverlay( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}

//****************************************//
// HINT PRINT UTILS
//****************************************//

should_break_claymore_hint()
{
	weapon = level.player GetCurrentWeapon();
	
	if( weapon == "claymore" )
	{
		return( true );
	}
	
	if( !( level.player buttonpressed( "DPAD_RIGHT" ) ) )
	{
		return( false );
	}
	else
	{
		return( true );
	}
}


estate_autosave_proximity_threat_func( enemy )
{
	foreach ( player in level.players )
	{
		dist = Distance( enemy.origin, player.origin );
		v_dist = abs( enemy.origin[2] - player.origin[2] );
		
		if ( dist < 360 && v_dist < 200 )
		{
			/# maps\_autosave::AutoSavePrint( "autosave failed: AI too close to player" ); #/
			return "return";
		}
		else
		if ( dist < 1000 )
		{
			return "threat_exists";
		}
	}
	
	return "none";
}