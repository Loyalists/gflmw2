#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_hud_util;
#include common_scripts\utility;

main()
{

	set_console_status();
	
	if ( level.console )
		level.hint_text_size = 1.6;
	else
		level.hint_text_size = 1.2;
	
	setDvarIfUninitialized( "trainer_debug", "0" );
	level.objectiveRegroup = 0; //used to determine if the string for the course objective is "regroup upstairs" or "run the course blah blah"
	level.endingThreadStarted = false;
	level.tryagain = false;
	level.translatordelay = 1.5;
	level.droneCallbackThread = ::AI_drone_think;
	level.spawnerCallbackThread = ::AI_think;
	level.oldObjectiveAlpha = getDvar( "objectiveAlpha" );
	level.skippingTimedADS = false;	//may skip if player is elite and has turned autoaim off in the options menu
	
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.2 );
	setsaveddvar( "r_lightGridContrast", 0 );
	
	/*-----------------------
	PIT SCORING/TIMING
	-------------------------*/
	level.targets_hit_with_melee = 0;
	level.patrolDudes = [];
	level.recommendedDifficulty = undefined;
	
	level.bestPitTime = 29.05;	//IW best time
	level.timeFail = 240;		//anything higher than this will fail
	level.timeEasy = 75;		//anything above this number will choose "easy"
	level.timeRegular = 43;		//anything above this number but less than timeEast will choose "regular"
	level.timeHard = 35;		//anything above this number but less than timeRegular will choose "hard"
	//veteran time.....			//anything below "timeHard" will choose "veteran"
	
	level.maximumfriendliesalloweddead = 5;		//if you kill more than 5 friendlies, you will fail
	level.minimumenemiestokill = 18;			//you have to kill at leat 18 enemies to pass
	
	level.timepenaltyForMissedEnemies = 2;	//in seconds
	level.timepenaltyForKilledCivvies = 2;	//in seconds
	level.timelimitMax = 160;
	level.timelimitMin = 80;
	level.courseFriendlies = [];
	level.courseEnemies = [];
	level.color[ "white" ] = ( 1, 1, 1 );
	level.color[ "red" ] = ( 1, 0, 0 );
	level.color[ "blue" ] = ( .1, .3, 1 );
	

	/*-----------------------
	STARTS
	-------------------------*/
	add_start( "timed_ads", ::start_timed_ads, "timed_ads" );
	add_start( "bullet_penetration", ::start_bullet_penetration, "bullet_penetration" );
	add_start( "frag", ::start_frag_training, "frag" );
	add_start( "pit", ::start_pit, "pit" );
	add_start( "course", ::start_course, "course" );
	add_start( "end", ::start_ending, "end" );
	if ( is_specialop() )
	{
		add_start( "so_killspree_trainer_start_map", level.so_trainer_start ); 
		default_start( level.so_trainer_start ); 
	}
	else
	{
		// Delete the special ops gate
		array_call( GetEntArray( "so_gate", "targetname" ), ::Delete );

		default_start( ::start_default );
		pit = getent( "pit", "targetname" );
	}
	init_precache();
	
	maps\createart\trainer_fog::main();
	maps\trainer_precache::main();
	maps\createfx\trainer_audio::main();
	maps\trainer_fx::main();
	maps\_drone_ai::init();
	

	maps\_load::main();	
	
	maps\_compass::setupMiniMap("compass_map_trainer");

	thread maps\trainer_amb::main();
	maps\trainer_anim::main();
	
	//misc
	flag_init( "never" );
	flag_init( "can_talk" );
	flag_set( "can_talk" );
	flag_init( "start_anims" );
	flag_init( "no_more_course_nags" );
	
	//firing range
	flag_init( "firing_range_initialized" );
	flag_init( "player_picked_up_rifle" );
	
	//hip fire and ads
	flag_init( "player_facing_targets_for_hip_fire" );
	flag_init( "foley_turns_for_hip_demo" );
	flag_init( "hip_fire_done" );
	flag_init( "firing_range_hip_and_ads_done" );
	flag_init( "foley_turns_for_ads_demo" );
	flag_init( "foley_done_talking_from_hip_ads_training" );
	
	//timed ads
	flag_init( "aa_timed_shooting_training" );
	flag_init( "foley_done_talking_from_timed_ads_training" );
	flag_init( "foley_turns_for_adstimed_demo" );
	
	//penetration
	flag_init( "foley_turns_for_penetration_demo" );
	flag_init( "firing_range_timed_ads_done" );
	flag_init( "firing_range_penetration_done" );
	flag_init( "foley_done_talking_from_penetration_training" );
	
	//frags
	flag_init( "player_just_threw_a_frag" );
	flag_init( "foley_turns_for_frag_demo" );
	flag_init( "frags_have_been_spawned" );
	flag_init( "player_picked_up_frags" );
	flag_init( "targets_hit_with_grenades" );
	flag_init( "player_has_thrown_frag_into_target" );
	flag_init( "firing_range_frags_done" );
	flag_init( "foley_done_talking_from_frag_training" );

	//objective training
	flag_init( "obj_go_to_the_pit_given" );
	flag_init( "obj_go_to_the_pit_done" );
	
	//sidearm training
	flag_init( "dunn_dialogue_welcome_01" );
	flag_init( "dunn_dialogue_welcome_02" );
	flag_init( "dunn_finished_welcome_anim" );
	flag_init( "sidearm_complete" );
	flag_init( "case_flip_01" );
	flag_init( "case_flip_02" );
	flag_init( "button_press" );
	
	//course/pit
	flag_init( "dunn_finished_with_open_case_dialogue" );
	flag_init( "melee_target_hit" );
	flag_init( "course_end_targets_dead" );
	flag_init( "sprinted" );
	flag_init( "pit_dialogue_starting" );
	flag_init( "course_start_targets_dead" );
	flag_init( "course_first_floor_targets_dead" );
	flag_init( "course_second_floor_targets_dead" );
	flag_init( "course_end_targets_dead" );
	flag_init( "dunn_finished_with_difficulty_selection_dialogue" );
	
	//ending
	flag_init( "player_done_with_course" );
	flag_init( "end_sequence_starting" );
	
	/*-----------------------
	POP-UP TARGETS
	-------------------------*/
	level.penetration_targets = [];
	level.grenade_targets = [];
	level.hip_targets = [];
	level.pit_enemies = [];
	level.plywood = getent( "plywood", "script_noteworthy" );
	level.plywood rotateRoll( -90, 0.25, 0.1, 0.1 );
	level.lastTimePlywoodWasHit = gettime();
	level.target_rail_start_points = getentarray( "target_rail_start_point", "targetname" );
	target_triggers = getentarray( "target_trigger", "targetname" );
	array_thread( target_triggers,::target_triggers_think );
	targets_enemy = getentarray( "target_enemy", "script_noteworthy" );
	targets_friendly = getentarray( "target_friendly", "script_noteworthy" );
	array_thread( targets_friendly,::target_think, "friendly" );
	array_thread( targets_enemy,::target_think, "enemy" );
	level.targets_hit = 0;
	level.friendlies_hit = 0;
	target_enemy = getentarray( "target_enemy", "script_noteworthy" );
	target_friendly = getentarray( "target_friendly", "script_noteworthy" );
	level.targets = array_merge( target_enemy, target_friendly );
	level.speakers = getentarray( "speakers", "targetname" );
	/*-----------------------
	WEAPONS
	-------------------------*/	
	level.fragsGlowing = false;
	level.gunPrimary = "m4_grunt";
	level.gunPrimaryClipAmmo = 30;
	level.gunSidearm = "deserteagle";
	//array_thread( getEntArray( "pickup_rifle", "targetname" ), ::ammoRespawnThink, "spawn_rifles", level.gunPrimary );
	//array_thread( getEntArray( "pickup_sidearm", "targetname" ), ::ammoRespawnThink, "spawn_sidearms", level.gunSidearm );
	pit_weapons = getentarray( "pit_weapons", "targetname" );
	array_thread( pit_weapons,::weapons_hide );
	
	level.cosine = [];
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "90" ] = cos( 90 );

	/*-----------------------
	SPAWNER THREADS
	-------------------------*/	
	aVehicleSpawners = maps\_vehicle::_getvehiclespawnerarray();
	array_thread( aVehicleSpawners, ::add_spawn_function, ::vehicle_think );
	array_thread( getentarray( "ai_ambient", "script_noteworthy" ), ::add_spawn_function, ::ai_ambient_noprop_think );
	array_spawn_function_noteworthy( "patrol", ::AI_patrol_think );
	array_spawn_function_noteworthy( "runners", ::AI_runners_think );
	
	/*-----------------------
	KEY FRIENDLIES
	-------------------------*/
	level.foley = spawn_targetname( "foley", true );
	level.foley.animname = "foley";
	level.foley.animnode = getent( "node_foley", "targetname" );
	level.foley forceUseWeapon( "m4_grunt", "primary" );
	level.traineeanimnode = spawn( "script_origin", ( 0, 0, 0 ) );
	level.traineeanimnode.origin = level.foley.animnode.origin;
	level.traineeanimnode.angles = level.foley.animnode.angles;
	level.translatoranimnode = spawn( "script_origin", ( 0, 0, 0 ) );
	level.translatoranimnode.origin = level.foley.animnode.origin;
	level.translatoranimnode.angles = level.foley.animnode.angles;
	spawn_pitguy();
	level.pit_case_01 = getent( "pit_case_01", "targetname" );
	level.pit_case_02 = getent( "pit_case_02", "targetname" );
	level.pit_case_01.animname = "training_case_01";
	level.pit_case_02.animname = "training_case_02";
	level.pit_case_01 assign_animtree();
	level.pit_case_02 assign_animtree();
	level.pitcases = [];
	level.pitcases[ 0 ] = level.pit_case_01;
	level.pitcases[ 1 ] = level.pit_case_02;
	level.trainees = array_spawn( getentarray( "trainees", "targetname" ), true );
	level.translator = spawn_script_noteworthy( "translator", true );
	level.translator gun_remove();
	level.translator.animname = "translator";
	level.trainee_01 = spawn_script_noteworthy( "trainee_01", true );
	level.trainee_01.animname = "trainee_01";
	level.translatoranimnode thread anim_loop_solo( level.translator, "training_intro_begining", "stop_idle" );		//loop forever
	level.traineeanimnode thread anim_loop_solo( level.trainee_01, "training_intro_begining", "stop_idle" );		//loop forever
	level.foley.animnode thread anim_first_frame_solo( level.foley, "training_intro_begining" );
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	level.curObjective = 1;
	level.objectives = [];
	registerActions();
	level.aRangeActors = [];
	level.aRangeActors[ 0 ] = level.foley;
	level.aRangeActors[ 1 ] = level.translator;
	level.aRangeActors[ 2 ] = level.trainee_01;
	level.aRangeActors = array_merge( level.aRangeActors, level.trainees );
	level.gate_cqb_enter = make_door_from_prefab( "gate_cqb_enter" );
	level.gate_cqb_exit = make_door_from_prefab( "gate_cqb_exit" );
	level.gate_cqb_enter_main = make_door_from_prefab( "gate_cqb_enter_main" );
	level.gate_cqb_enter_main.openangles = -170;
	level.gate_cqb_enter_main.closeangles = 170;
	level.gate_cqb_exit.openangles = -95;
	level.gate_cqb_exit.closeangles = 95;
	
	if ( !is_specialop() )
	{
		level.gate_cqb_enter_main thread door_open();
		level.player takeAllWeapons();
	}
	

	
	/*-----------------------
	AMBIENT AI
	-------------------------*/	
	if ( !is_specialop() )
	{
		level.ambientai = array_spawn( getentarray( "friendlies_ambient", "targetname" ), true );
		thread bridge_layer_think();
		level.basketball_guys = array_spawn( getentarray( "friendlies_basketball", "targetname" ), true );
		thread AI_runner_group_think( "runner_group_01" );
		thread AI_runner_group_think( "runner_group_02" );
		thread ambient_vehicles();
	}
	
	thread music();
	
	hummer_end_main = getent( "hummer_end_main", "targetname" );
	hummer_end_01 = getent( "hummer_end_01", "targetname" );
	hummer_end_main hide();
	hummer_end_01 hide();
	end_blockers = getent( "end_blockers", "targetname" );
	end_blockers hide_entity();
	
	dummies = getentarray( "dummies", "targetname" );
	array_call( dummies,::delete );
	
	level.firing_range_area = getent( "firing_range_area", "targetname" );
	
	thread vars_for_after_main();
	
	thread weaponfire_failure();
	thread player_camp_disable_weapons();
	thread basketball_nag();
	
	level.player thread never_run_out_of_ammo();
}

never_run_out_of_ammo()
{
	level endon ( "button_press" );
	while( true )
	{
		level.player waittill( "reload_start" );
		if ( flag( "player_inside_course" ) )
			break;
		weaponName = self GetCurrentWeapon();
		if ( level.player GetWeaponAmmoStock( weaponName ) < 100 )
		{
			level.player SetWeaponAmmoStock( weaponName, 9999 );
		}
	}	
}

vars_for_after_main()
{
	wait( .5 );
	/*-----------------------
	PUT TOTAL PIT ENEMIES/CIVVIES IN A VARIABLE
	-------------------------*/	
	level.totalPitEnemies = level.courseEnemies.size;
	level.totalPitCivvies = level.courseFriendlies.size;
		
}
/****************************************************************************
    START FUNCTIONS
****************************************************************************/ 

start_default()
{
	thread AA_range_start_init();
}

start_debug()
{
	
}

start_timed_ads()
{
	firing_range_anims_foley_trainee_and_translator_start_points();
	thread firing_range_init();
	flag_set( "firing_range_hip_and_ads_done" );
	flag_set( "foley_done_talking_from_hip_ads_training" );
	thread AA_timed_ADS_init();
	
}

start_bullet_penetration()
{
	firing_range_anims_foley_trainee_and_translator_start_points();
	thread firing_range_init();
	flag_set( "firing_range_timed_ads_done" );
	flag_set( "foley_done_talking_from_timed_ads_training" );
	thread AA_penetration_init();
}

start_frag_training()
{
	firing_range_anims_foley_trainee_and_translator_start_points();
	thread firing_range_init();
	flag_set( "firing_range_penetration_done" );
	flag_set( "foley_done_talking_from_penetration_training" );
	thread AA_frags_init();
}

start_pit()
{
	flag_set( "foley_done_talking_from_frag_training" );
	flag_set( "firing_range_frags_done" );
	level.player giveWeapon( level.gunPrimary );
	level.player switchToWeapon( level.gunPrimary );
	org = getent( "pit_start", "targetname" );
	level.player SetOrigin( org.origin );
	level.player SetPlayerAngles( org.angles );
	thread AA_find_pit_init();
}

start_course()
{
	flag_set( "dunn_finished_welcome_anim" );
	level.player giveWeapon( level.gunSidearm );
	level.player giveWeapon( level.gunPrimary );
	level.player switchToWeapon( level.gunPrimary );
	org = getent( "course_start_pit", "targetname" );
	level.player SetOrigin( org.origin );
	level.player SetPlayerAngles( org.angles );
	thread AA_pit_init();
	maps\_utility::vision_set_fog_changes( "trainer_pit", 0 );
}

start_ending()
{
	level.player giveWeapon( level.gunSidearm );
	level.player giveWeapon( level.gunPrimary );
	level.player switchToWeapon( level.gunPrimary );
	org = getent( "course_leave", "targetname" );
	level.player SetOrigin( org.origin );
	level.player SetPlayerAngles( org.angles );
	registerObjective( "obj_course", &"TRAINER_OBJ_EXIT_THE_PIT", getent( "course_start", "targetname" ) );
	setObjectiveState( "obj_course", "current" );
	thread AA_ending_init();
	maps\_utility::vision_set_fog_changes( "trainer_pit", 0 );
	
}

music()
{
	radio_org = getent( "radio_org", "targetname" );
	
	while( true )
	{
		radio_org playsound( "training_radio_music_01", "done" );
		radio_org waittill( "done" );
		wait( 1 );
		radio_org playsound( "training_radio_music_02", "done" );
		radio_org waittill( "done" );
		wait( 1 );
		radio_org playsound( "training_radio_music_03", "done" );
		radio_org waittill( "done" );
		wait( 1 );
		radio_org playsound( "training_radio_music_04", "done" );
		radio_org waittill( "done" );
		wait( 1 );
	}
}

ambient_vehicles()
{
	
	thread spawn_vehicles_from_targetname_and_drive( "heli_group_01" );
	
	pavelows = spawn_vehicles_from_targetname_and_drive( "pavelow_group_01" );
	array_call( pavelows,::Vehicle_TurnEngineOff );
	//thread spawn_vehicles_from_targetname_and_drive( "f15_takeoff_01" );
	
	flag_wait( "player_leaving_range" );
	thread spawn_vehicles_from_targetname_and_drive( "f15_flyby_01" );

}

/****************************************************************************
    FIRING RANGE START - BASIC FIRING AND ADS
****************************************************************************/ 
AA_range_start_init()
{
	thread firing_range_init();
	flag_wait( "start_anims" );
	thread firing_range_hip_and_ads();
	
	flag_wait( "firing_range_hip_and_ads_done" );
	
	thread AA_timed_ADS_init();

}

firing_range_init()
{
	setsaveddvar( "g_friendlyNameDist", 196 );
	setSavedDvar( "objectiveAlpha", 0.4 );
	level.player takeallweapons();
	player_start_range = getent( "player_start_range", "targetname" );
	level.player SetOrigin( player_start_range.origin );
	level.player SetPlayerAngles( player_start_range.angles );
	ads_target_trigger_middle = getent( "ads_target_trigger_middle", "targetname" );
	ads_target_trigger_front = getent( "ads_target_trigger_front", "targetname" );
	ads_target_trigger_rear = getent( "ads_target_trigger_rear", "targetname" );
	timed_ads_target_trigger = getent( "timed_ads_target_trigger", "targetname" );
	ads_target_trigger_middle thread target_triggers_think();
	ads_target_trigger_front thread target_triggers_think();
	ads_target_trigger_rear thread target_triggers_think();
	timed_ads_target_trigger thread target_triggers_think();
	
	level.targetsFront = ads_target_trigger_front.targets;
	level.targetsMiddle = ads_target_trigger_middle.targets;
	level.targetsRear = timed_ads_target_trigger.targets;
	level.firingRangeTimedTargets = timed_ads_target_trigger.targets;

	flag_set( "firing_range_initialized" );
	
	flag_wait( "obj_go_to_the_pit_given" );
	setsaveddvar( "g_friendlyNameDist", 15000 );
}

firing_range_anims()
{
	/*-----------------------
	FOLEY AND TRAINEES DO INTRO ANIMS
	-------------------------*/	
	level.foley.animnode anim_single_solo( level.foley, "training_intro_begining" );								//specific one-off anim

	/*-----------------------
	FOLEY GOES INTO IDLE (TRAINEE AND TRANS ALREADY IDLING)
	-------------------------*/	
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );

	/*-----------------------
	FOLEY TURNS 
	-------------------------*/	
	flag_wait( "foley_turns_for_hip_demo" );
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_turnaround_1" );

	/*-----------------------
	FOLEY GOES INTO IDLE
	-------------------------*/	
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	
	/*-----------------------
	FOLEY TALKS A BIT
	-------------------------*/	
	flag_wait( "hip_fire_done" );
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_idle_talk_1" );
	
	/*-----------------------
	FOLEY TURNS AROUND
	-------------------------*/	
	level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_turnaround_2" );
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	
	flag_wait( "firing_range_hip_and_ads_done" );
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_idle_talk_2" );
	flag_set( "foley_done_talking_from_hip_ads_training" );
}

firing_range_anims_foley_trainee_and_translator_start_points()
{
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	wait( 0.05 );
}

firing_range_hip_and_ads()
{
	flag_wait( "firing_range_initialized" );
	
	player_needs_to_pickup_primary_weapon = true;
	
	thread firing_range_anims();
	/*-----------------------
	FOLEY INTRO DIALOGUE
	-------------------------*/	
	//Sgt. Foley  Welcome to pull-the-trigger 101. 	
	flag_wait( "ps_train_fly_welcome" );
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_welcome" );
	//level.foley dialogue_execute( "train_fly_welcome" );

	//Sgt. Foley  Pvt. Allen here is going to do a quick weapons demonstration to show you locals how its done.	
	flag_wait( "ps_train_fly_demonstration" );
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_demonstration" );
	//level.foley dialogue_execute( "train_fly_demonstration" );

	//Sgt. Foley  No offense, but I see a lot of you guys firing from the hip and spraying bullets all over the range. 	
	flag_wait( "ps_train_fly_nooffense" );
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_nooffense" );
	//level.foley dialogue_execute( "train_fly_nooffense" );

	//Sgt. Foley  You don't end up hitting a damn thing and it makes you look like an ass.	
	flag_wait( "ps_train_fly_makesyoulook" );
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_makesyoulook" );
	//level.foley dialogue_execute( "train_fly_makesyoulook" );

	//Sgt. Foley  Private Allen, show 'em what I'm talking about.	
	flag_wait( "foley_anim_pickup_weapon" );
	//level.foley dialogue_execute( "train_fly_showem" );
	
	flag_set( "foley_turns_for_hip_demo" );
	
	/*-----------------------
	PICK UP THE WEAPON
	-------------------------*/	
	if ( !player_has_primary_weapon() )
	{
		registerObjective( "obj_rifle", &"TRAINER_PICK_UP_A_RIFLE_FROM", getEnt( "range_rifle", "script_noteworthy" ) );
		setObjectiveState( "obj_rifle", "current" );

		pickup_rifle = getent( "pickup_rifle", "targetname" );
		if ( isdefined( pickup_rifle ) ) 
		{
			pickup_rifle glow();
			pickup_rifle HidePart( "TAG_THERMAL_SCOPE" );
			//pickup_rifle HidePart( "TAG_FOREGRIP" );
			//pickup_rifle HidePart( "TAG_WEAPON"
			pickup_rifle HidePart( "TAG_ACOG_2" );
			pickup_rifle HidePart( "TAG_EOTECH" );
			pickup_rifle HidePart( "TAG_HEARTBEAT" );
			pickup_rifle HidePart( "TAG_M203" );
			pickup_rifle HidePart( "TAG_RED_DOT" );
			pickup_rifle HidePart( "TAG_SHOTGUN" );
			pickup_rifle HidePart( "TAG_SILENCER" );
			//pickup_rifle HidePart( "TAG_BRASS" );
			//pickup_rifle HidePart( "TAG_CLIP" );
			//pickup_rifle HidePart( "TAG_FLASH" );
			//pickup_rifle HidePart( "TAG_LASER" );
			//pickup_rifle HidePart( "TAG_SIGHT_OFF" );
			//pickup_rifle HidePart( "TAG_SIGHT_ON" );
			//pickup_rifle HidePart( "TAG_FLASH_SILENCED" );
		}
		
		//Sgt. Foley  Grab that weapon off the table and fire at some targets downrange.	
		level.foley dialogue_execute( "train_fly_fireattargets" );
		level.foley thread nag_till_flag_set( "nag_rifle_pickup_0", 2, "player_picked_up_rifle" ); 
			
	}
	else
	{
		player_needs_to_pickup_primary_weapon = false;
	}
	
	while( !player_has_primary_weapon() )
	{
		wait .05;
	}
	flag_set( "player_picked_up_rifle" );
	/*-----------------------
	FIRE FROM THE HIP
	-------------------------*/	
	//Shoot each target while firing from the hip.
	if ( player_needs_to_pickup_primary_weapon == false )
	{
		registerObjective( "obj_rifle", &"TRAINER_SHOOT_EACH_TARGET_WHILE1", getEnt( "firing_range", "targetname" ) );
		setObjectiveState( "obj_rifle", "current" );
	}
	else
	{
		setObjectiveString( "obj_rifle", &"TRAINER_SHOOT_EACH_TARGET_WHILE1" );
		setObjectiveLocation( "obj_rifle", getEnt( "firing_range", "targetname" ) );
	}
	
	/*-----------------------
	FACE THE TARGETS HINT
	-------------------------*/	
	if ( !within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
	{
		
		//Sgt. Foley	Turn around and fire at the targets.	
		level.foley thread dialogue_execute( "train_fly_turnaround" );
	}

	thread delaythread( 8,::turnaround_hint_if_flag_not_set, "player_facing_targets_for_hip_fire" );

	/*-----------------------
	FIRE FROM THE HIP TARGETS POP UP
	-------------------------*/	
	while ( !within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
	{
		wait 0.05;
	}
	flag_set( "player_facing_targets_for_hip_fire" );

	/*-----------------------
	FIRE FROM THE HIP HINT
	-------------------------*/	
	clear_hints();
	
	level.foley thread nag_on_notify_till_flag_set( "nag_hip_fire_0", 2, "player_needs_to_fire_from_the_hip", "hip_fire_done" ); 
	
	if ( level.Xenon )
		thread keyHint( "hip_attack", undefined, true );
	else
		thread keyHint( "pc_hip_attack", undefined, true );// PC and PS3 are both press
		
	numberOfTagretsToHit = 2;
	mustADS = false;
	//cycle_targets_till_hit( targets, numberOfTagretsToHit, mustADS, mustCrouch, mustShootThroughPlywood, bInOrder )
	cycle_targets_till_hit( level.hip_targets, numberOfTagretsToHit, mustADS, undefined, undefined, true );
	
	level.player notify( "did_action_stop_ads" );
	clear_hints();
	
	playerIsInverted = undefined;
	/*-----------------------
	INVERT CONTROLS?
	-------------------------*/	
	setDvar( "ui_start_inverted", 0 );
    if ( level.Console )
	{
		if ( isdefined( level.player GetLocalPlayerProfileData( "invertedPitch" ) ) && level.player GetLocalPlayerProfileData( "invertedPitch" ) )
			setDvar( "ui_start_inverted", 1 );
	}
	else// PC
	{
		if ( isdefined( getdvar( "ui_mousepitch" ) ) && getdvar( "ui_mousepitch" ) == "1" )
			setDvar( "ui_start_inverted", 1 );
	}
	wait .1;// make sure dvar is set
	
	setDvar( "ui_invert_string", "@TRAINER_AXIS_OPTION_MENU1_ALL" );
	if ( level.console )
		level.player openpopupMenu( "invert_axis" );
	else
		level.player openpopupMenu( "invert_axis_pc" );

	level.player freezecontrols( true );
	setblur( 2, .1 );
	level.player waittill( "menuresponse", menu, response );
    setblur( 0, .2 );
    level.player freezecontrols( false );



	playerIsInvertedAfterFirstMenu = false;
    if ( level.Console )
	{
		if ( isdefined( level.player GetLocalPlayerProfileData( "invertedPitch" ) ) && level.player GetLocalPlayerProfileData( "invertedPitch" ) )
			playerIsInvertedAfterFirstMenu = true;
	}
	else// PC
	{
		if ( isdefined( getdvar( "ui_mousepitch" ) ) && getdvar( "ui_mousepitch" ) == "1" )
			playerIsInvertedAfterFirstMenu = true;
	}
	
	
	
	
	/*-----------------------
	DO A FEW MORE TARGETS IF PLAYER CHOSE TO INVERT
	-------------------------*/	
    if ( response == "try_invert" )
    {
    	//Foley: Let's try a few more.	
		level.foley thread dialogue_execute( "train_fly_tryafew" );

		/*-----------------------
		FIRE FROM THE HIP HINT
		-------------------------*/	
		if ( level.Xenon )
			thread keyHint( "hip_attack" );
		else
			thread keyHint( "pc_hip_attack" );// PC and PS3 are both press
	
		/*-----------------------
		FIRE FROM THE HIP TARGETS POP UP
		-------------------------*/	
		while ( !within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
			wait 0.05;
		
		numberOfTagretsToHit = 2;
		mustADS = false;
		//cycle_targets_till_hit( targets, numberOfTagretsToHit, mustADS, mustCrouch, mustShootThroughPlywood, bInOrder )
		cycle_targets_till_hit( level.hip_targets, numberOfTagretsToHit, mustADS, undefined, undefined, true );
		
		level.player notify( "did_action_stop_ads" );
		clear_hints();
		

		/*-----------------------
		DID THE PLAYER SWAP INVERSION FROM THE MAIN MENU DURING EXCERCISE?
		-------------------------*/	
		playerIsInvertedAfterTryingAgain = false;
	    if ( level.Console )
		{
			if ( isdefined( level.player GetLocalPlayerProfileData( "invertedPitch" ) ) && level.player GetLocalPlayerProfileData( "invertedPitch" ) )
				playerIsInvertedAfterTryingAgain = true;
		}
		else// PC
		{
			if ( isdefined( getdvar( "ui_mousepitch" ) ) && getdvar( "ui_mousepitch" ) == "1" )
				playerIsInvertedAfterTryingAgain = true;
		}
		
		/*-----------------------
		ONLY SHOW THE MENU TO KEEP CONTROLS IF PLAYER HASN'T SCREWED WITH MAIN MENU
		-------------------------*/	
		
		if ( playerIsInvertedAfterFirstMenu == playerIsInvertedAfterTryingAgain )
		{
			setDvar( "ui_invert_string", "@TRAINER_AXIS_OPTION_MENU2_ALL" );
			if ( level.console )
				level.player openpopupMenu( "invert_axis" );
			else
				level.player openpopupMenu( "invert_axis_pc" );
	
			level.player freezecontrols( true );
			setblur( 2, .1 );
			level.player waittill( "menuresponse", menu, response );
			setblur( 0, .2 );
			level.player freezecontrols( false );
		}

	}
	
	setObjectiveState( "obj_rifle", "done" );
	
	/*-----------------------
	CROSSHAIR SPREAD HINT
	-------------------------*/	
	// Notice that your crosshair expands as you fire.\nThe bigger the crosshairs, the less accurate you are.
	//double_line = true;
	//thread killhouse_hint( &"TRAINER_HINT_CROSSHAIR_CHANGES", 6, double_line );
	
	/*-----------------------
	ADS TRAINING
	-------------------------*/	
	flag_set( "hip_fire_done" );
	//Sgt. Foley  See what I mean? He sprayed bullets all over the damn place.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_sprayedbullets" );
	level.foley dialogue_execute( "train_fly_sprayedbullets" );

	//Sgt. Foley  You've got to pick your targets by aiming deliberately down your sights from a stable stance.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_pickyourtargets" );
	level.foley dialogue_execute( "train_fly_pickyourtargets" );
	
	thread autosave_by_name( "ads_training" );
	
	//Sgt. Foley  Private Allen, show our friends here how the Rangers take down a target. 	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_howtherangers" );
	level.foley dialogue_execute( "train_fly_howtherangers" );

	//Sgt. Foley  Crouch first, and then aim down your sight at the targets.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_crouchfirst" );
	level.foley dialogue_execute( "train_fly_crouchfirst" );

	// Shoot three targets while aiming down your sights.
	thread setObjectiveString( "obj_rifle", &"TRAINER_SHOOT_EACH_TARGET_WHILE" );
	setObjectiveState( "obj_rifle", "current" );
	
	numberOfTagretsToHit = 3;
	mustADS = true;
	mustCrouch = true;

	if ( level.player GetStance() != "crouch" )
	{
		thread keyHint( "crouch" );
	}

	level.foley thread nag_on_notify_till_flag_set( "nag_ads_fire_0", 2, "player_needs_to_ADS", "firing_range_hip_and_ads_done" ); 
	level.foley thread nag_on_notify_till_flag_set( "nag_crouch_fire_0", 2, "player_needs_to_crouch", "firing_range_hip_and_ads_done" ); 
	cycle_targets_till_hit( level.targetsFront, numberOfTagretsToHit, mustADS, mustCrouch );

	level.player notify( "did_action_crouch" );
	level.player notify( "did_action_ads_360" );
	level.player notify( "did_action_ads" );
	clear_hints();
	setObjectiveState( "obj_rifle", "done" );
	flag_set( "firing_range_hip_and_ads_done" );

	if ( level.player GetStance() != "stand" )
	{
		thread keyHint( "stand" );
	}
	
	//Sgt. Foley  That's all there is to it. You want your target to go down? You gotta aim down your sights.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_gottaaim" );
	level.foley dialogue_execute( "train_fly_gottaaim" );
	

}

turnaround_hint_if_flag_not_set( sFlag )
{
	level endon( sFlag );
	if ( !flag( sFlag ) )
	{
		//double_line = true;
		thread killhouse_hint( &"TRAINER_HINT_TURN_AROUND" );
	}
}

nag_till_flag_set( sNagLine, iNumberOfLines, sFlagToStop )
{
	thread nag_reset_can_talk_flag( sFlagToStop );	//reset can_talk flag in case this function ends mid-dialogue
	level endon( sFlagToStop );
	while( !flag( sFlagToStop ) )
	{
		wait( randomfloatrange( 25, 35 ) );
		i = 1;
		if ( flag( "can_talk" ) )
		{
			flag_clear( "can_talk" );
			self dialogue_execute( sNagLine + i );
			flag_set( "can_talk" );	
			i++;
			if ( i > iNumberOfLines )
			{
				i = 1;
			}
		}
	}
}

nag_on_notify_till_flag_set( sNagLine, iNumberOfLines, sNotify, sFlagToStop )
{
	thread nag_reset_can_talk_flag( sFlagToStop );	//reset can_talk flag in case this function ends mid-dialogue
	level endon( sFlagToStop );
	i = 1;
	while( !flag( sFlagToStop ) )
	{
		level waittill( sNotify );

		if ( flag( "can_talk" ) )
		{
			flag_clear( "can_talk" );
			self dialogue_execute( sNagLine + i );
			flag_set( "can_talk" );	
			i++;
			if ( i > iNumberOfLines )
			{
				i = 1;
			}
		}
	}
}

nag_reset_can_talk_flag( sFlagToWaitFor )
{
	flag_wait( sFlagToWaitFor );
	wait( 0.05 );
	flag_set( "can_talk" );
}

cycle_targets_till_hit( targets, numberOfTagretsToHit, mustADS, mustCrouch, mustShootThroughPlywood, bInOrder )
{
	numberOfTagretsHit = 0;
	
	/*-----------------------
	IF NEED TO DO IN A CERTAIN ORDER, USE SCRIPT_GROUP NUMBER
	-------------------------*/	
	if ( isdefined( bInOrder ) )
	{
		newArray = [];
		while ( newArray.size < targets.size )
		{
			wait( 0.05 );
			foreach( target in targets )
			{
				if ( target.script_group == newArray.size )
					newArray[ newArray.size ] = target;
			}
		}
		targets = newArray;
	}
	/*-----------------------
	LOOP THROUGH TARGETS TILL KILLED ENOUGH
	-------------------------*/	
	while( true )
	{
		wait( 0.05 );
		//have we already killed enough?
		if ( numberOfTagretsHit >= numberOfTagretsToHit )
			break;
			
		foreach( target in targets )
		{
			//have we already killed enough?
			if ( numberOfTagretsHit >= numberOfTagretsToHit )
				break;

			target notify( "pop_up" );
			target waittill ( "hit" );
			
			/*-----------------------
			DO WE NEED TO CROUCH?
			-------------------------*/	
			if ( isdefined( mustCrouch ) )
			{

				if ( level.player GetStance() == "crouch" )
				{
					level.player notify( "did_action_crouch" );
				}
				else
				{
					thread keyHint( "crouch" );
					level notify( "player_needs_to_crouch" );
					continue;
				}
						
			}
			
			/*-----------------------
			DO WE NEED TO ADS OR FIRE FROM THE HIP?
			-------------------------*/	
			if ( isdefined( mustADS ) )
			{
				if ( mustADS == false )
				{
					if ( !level.player isADS() )
					{
						numberOfTagretsHit++;
						level.player notify( "did_action_stop_ads" );
					}
						
					else
					{
						thread keyHint( "stop_ads", undefined, true );
						level notify( "player_needs_to_fire_from_the_hip" );
					}
						
				}
				if ( mustADS == true )
				{
					if ( level.player isADS() )
					{
						numberOfTagretsHit++;
						level.player notify( "did_action_ads" );
						level.player notify( "did_action_ads_360" );
					}
						
					else
					{
						if ( level.Xenon )
							thread keyHint( "ads_360" );
						else
							thread keyHint( "ads" );// PC and PS3 are both press
						level notify( "player_needs_to_ADS" );
					}
				}
			}
			/*-----------------------
			DO WE NEED TO SHOOT THROUGH PLYWOOD?
			-------------------------*/	
			if ( isdefined( mustShootThroughPlywood ) )
			{
				waittillframeend;
				time = gettime();
				if ( level.lastTimePlywoodWasHit == time )
				{
					numberOfTagretsHit++;
					clear_hints();
				}
				else
				{
					clear_hints();
					//thread killhouse_hint( &"TRAINER_SHOOT_THE_TARGET_THROUGH", 6 ); 
					level notify( "player_needs_to_shoot_through_plywood" );
					continue;
				}
			}
		}
	}
	
	/*-----------------------
	ENOUGH KILLED...RESET ALL TARGETS
	-------------------------*/	
	array_thread( targets,::target_reset_manual );
}


/****************************************************************************
    FIRING RANGE START - TIMED ADS
****************************************************************************/ 
AA_timed_ADS_init()
{
	hasAutoAim = ( level.player GetLocalPlayerProfileData( "autoAim" ) );
	if ( ( !hasAutoAim ) || ( !level.console ) )
	{
		level.skippingTimedADS = true;
		//Skip timed ADS training if autoaim is turned off or if we are on a PC
		flag_set( "firing_range_timed_ads_done" );
		flag_set( "foley_done_talking_from_timed_ads_training" );
		thread AA_penetration_init();
	}
	else
	{
		//Do full training...player has not mucked with autoaim in options menu
		thread firing_range_timed_ads();
		flag_wait( "firing_range_timed_ads_done" );
		thread AA_penetration_init();
	}
}

timed_ads_anims()
{
	flag_wait( "foley_done_talking_from_hip_ads_training" );
	/*-----------------------
	FOLEY GOES INTO IDLE
	-------------------------*/	
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	
	flag_wait( "aa_timed_shooting_training" );
	/*-----------------------
	FOLEY TURNS AROUND
	-------------------------*/	
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_turnaround_1" );
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	
	flag_wait( "firing_range_timed_ads_done" );
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_idle_talk_1" );
	flag_set( "foley_done_talking_from_timed_ads_training" );
	
}

firing_range_timed_ads()
{
	flag_wait( "firing_range_hip_and_ads_done" );
	thread timed_ads_anims();
	/*-----------------------
	ADS TARGET SWITCHING - TIMED
	-------------------------*/	
	thread autosave_by_name( "timed_ads" );
	
	//Sgt. Foley  Aiming down your sights also works for switching quickly between targets. 	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_switching" );
	level.foley dialogue_execute( "train_fly_switching" );
	
	//Sgt. Foley  Aim down your sights, then pop in and out to acquire new targets. 
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_popinandout" );
	level.foley dialogue_execute( "train_fly_popinandout" );

	//Sgt. Foley  Show 'em Private.	
	level.foley dialogue_execute( "train_fly_showemprivate" );
	
	// Shoot each target as quickly as possible.
	registerObjective( "obj_timed_rifle", &"TRAINER_SHOOT_EACH_TARGET_AS", getEnt( "firing_range", "targetname" ) );
	setObjectiveState( "obj_timed_rifle", "current" );
	
	//(HINT: RELEASE AND PULL LT TO AUTOMATICALLY SNAP TO A NEARBY TARGET)
	//Foley: If your target is close to where you are aiming, you can snap to it quickly by quickly aiming down your sight.
	//OBJECTIVE: Shoot each target as quickly as possible. 
	
	flag_set( "aa_timed_shooting_training" );
	
	//Now I'm going make the targets pop up one at a time.
	//level.waters execDialog( "targetspop" );

	//wait .5;

	//Hit all of them as fast as you can.
	//level.waters execDialog( "hitall" );

	//Sgt. Foley  If your target is close to where you are aiming, you can snap to it quickly by quickly aiming down your sights.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_iftargetclose" );
	level.foley dialogue_execute( "train_fly_iftargetclose" );
		

//	if ( auto_aim() )
//	{
//		//ps3_flipped = is_ps3_flipped();
//
//		//if ( ( level.xenon ) || ( ps3_flipped ) )
//		if ( level.xenon )
//			actionBind = getActionBind( "ads_switch" );
//		else
//			actionBind = getActionBind( "ads_switch_shoulder" );
//		double_line = true;
//		thread killhouse_hint( actionBind.hint, 6, double_line );
//	}
	

	if ( ( level.player GetWeaponAmmoClip( level.gunPrimary ) ) < level.gunPrimaryClipAmmo )
	{
		keyHint( "reload" );
		wait( 2.0 );
	}

	numRepeats = 0;
	dialogueLine = 0;
	
	level.foley thread nag_on_notify_till_flag_set( "nag_ads_snap_0", 4, "player_needs_to_ADS", "firing_range_timed_ads_done" ); 
	
	while ( 1 )
	{
		//lowerTargetDummies( "rifle" );

		if ( auto_aim() && numRepeats != 0 )
		{
			if ( level.xenon )
				actionBind = getActionBind( "ads_switch" );
			else
				actionBind = getActionBind( "ads_switch_shoulder" );
			double_line = true;
			thread killhouse_hint( actionBind.hint, 10, double_line );
			wait 4;
		}

		level.num_hit = 0;
		level.num_hit_with_ads = 0;
		level.num_hit_without_ads = 0;
		thread timedTargets();
		
		level waittill( "a timed target has been hit" );
		
		/*-----------------------
		WAIT FOR 10 SECONDS OR UNTIL TOO MANY HIT FROM THE HIP
		-------------------------*/	
		level waittill_notify_or_timeout( "player_has_hit_too_many_from_hip", 10 );
		
		level notify( "times_up" );
		
		if ( level.num_hit > 6 )
		{
			if ( level.num_hit_with_ads > 4 )
			{
				//PASS: Player hit more than 6 targets in the alotted time, 
				//at least 5 of which were in ADS
				break;
			}
		}
			
		wait 1;

		numRepeats++;
		
		array_thread( level.firingRangeTimedTargets,::target_reset_manual );
		
		/*-----------------------
		FAILED - TOO SLOW OR NOT ENOUGH IN ADS
		-------------------------*/	
		if ( level.num_hit_with_ads < 4 )
		{
			//Sgt. Foley	Do it again. You can snap to new targets by quickly engaging and releasing your aim.
			//Sgt. Foley	Private Allen, you're not snapping to your targets. You need to quickly engage and release aiming down the sight to snap to new targets.	
			//Sgt. Foley	Private Allen, you're doing it wrong. Quickly engage and release aiming down the sight to snap to new targets.	
			level.foley dialogue_execute( "timed_ads_not_snapping_0" + dialogueLine );
		}
		else
		{
			//Sgt. Foley	That was too slow. You need engage and release your aim quickly to snap to new targets
			//Sgt. Foley	Too slow. Private Allen, you need to quickly pop in and out of aiming down your sights to snap to new targets.
			//Sgt. Foley	Do it again and speed it up. Show these men how to snap to new targets by quickly popping in and out of aiming down your sights.
			level.foley dialogue_execute( "timed_ads_too_slow_0" + dialogueLine );
		}
		
		dialogueLine++;
		if ( dialogueLine > 2 )
		{
			dialogueLine = 0;
		}
		wait 1;

		if ( ( level.player GetWeaponAmmoClip( level.gunPrimary ) ) < level.gunPrimaryClipAmmo )
		{
			thread keyHint( "reload" );
			while ( ( level.player GetWeaponAmmoClip( level.gunPrimary ) ) < level.gunPrimaryClipAmmo )
				wait .1;
			clear_hints();
			wait 1;
		}
	}

	/*-----------------------
	PASSED TIMED ADS
	-------------------------*/	
	wait 1;

	setObjectiveState( "obj_timed_rifle", "done" );
	array_thread( level.firingRangeTimedTargets,::target_reset_manual );
	
	/*-----------------------
	ADS TARGET SWITCHING - COMPLETE
	-------------------------*/	
	wait 0.5;
	flag_clear( "aa_timed_shooting_training" );
	
	//Sgt. Foley	Now that's how you do it. You want to take down your targets quickly and with control.	
	level.foley dialogue_execute( "train_fly_howyoudoit" );
	
	flag_set( "firing_range_timed_ads_done" );

}

timedTargets()
{
	level endon( "times_up" );
	targets = level.firingRangeTimedTargets;
	last_selection = -1;
	while ( 1 )
	{
		while ( 1 )
		{
			//randomly pop up a target
			wait( 0.05 );
			selected_target = randomint( targets.size );
			if ( selected_target != last_selection )
				break;
		}

		last_selection = selected_target;
		targets[ selected_target ] notify( "pop_up" );

		//wait for target to be hit
		targets[ selected_target ] waittill( "hit" );
		level notify( "a timed target has been hit" );
		
		if ( level.player isADS() )
		{
			level.num_hit_with_ads++;
			level.player notify( "did_action_ads" );
			level.player notify( "did_action_ads_360" );
		}
			
		else
		{
			level.num_hit_without_ads++;
			if ( level.num_hit_without_ads > 2 )
			{
				level notify( "player_has_hit_too_many_from_hip" );
				break;
			}
			
			if ( level.Xenon )
				thread keyHint( "ads_360" );
			else
				thread keyHint( "ads" );// PC and PS3 are both press
			level notify( "player_needs_to_ADS" );
		}
		
		level.num_hit++;

		wait .1;
	}
}

/****************************************************************************
    FIRING RANGE - BULLET PENETRATION
****************************************************************************/ 
AA_penetration_init()
{
	thread firing_range_penetration();
	
	flag_wait( "firing_range_penetration_done" );
	
	thread AA_frags_init();
}

penetration_anims()
{
	if ( level.skippingTimedADS == true )
	{
		flag_wait( "foley_done_talking_from_hip_ads_training" );
	}
	
	flag_wait( "foley_done_talking_from_timed_ads_training" );
	/*-----------------------
	FOLEY GOES INTO IDLE
	-------------------------*/	
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	
	flag_wait( "foley_turns_for_penetration_demo" );
	/*-----------------------
	FOLEY TURNS AROUND
	-------------------------*/	
	level.foley.animnode notify( "stop_idle" );
	level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_turnaround_1" );
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );

	flag_set( "foley_done_talking_from_penetration_training" );
	
}

firing_range_penetration()
{
	thread penetration_anims();
	thread autosave_by_name( "penetration" );
	
	//Sgt. Foley		Now if your target is behind light cover, remember that certain weapons can penetrate and hit your target.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_lightcover" );
	level.foley dialogue_execute( "train_fly_lightcover" );
	
	flag_set( "foley_turns_for_penetration_demo" );
	//Sgt. Foley		The Private here will demonstrate.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_theprivatehere" );
	level.foley dialogue_execute( "train_fly_theprivatehere" );
	
	registerObjective( "obj_penetration", &"TRAINER_SHOOT_A_TARGET_THROUGH", getEnt( "firing_range", "targetname" ) );
	setObjectiveState( "obj_penetration", "current" );
	
	while ( !within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
		wait 0.05;
	
	level.foley thread nag_on_notify_till_flag_set( "nag_penetration_fire_0", 2, "player_needs_to_shoot_through_plywood", "firing_range_penetration_done" ); 
		
	thread raisePlywoodWalls();
	numberOfTagretsToHit = 1;
	mustADS = undefined;
	mustCrouch = undefined;
	mustShootThroughPlywood = true;
	cycle_targets_till_hit( level.penetration_targets, numberOfTagretsToHit, mustADS, mustCrouch, mustShootThroughPlywood );
	
	
	
	thread spawn_frags();
	setObjectiveState( "obj_penetration", "done" );
	delaythread( 3,:: lowerPlywoodWalls );
	
	clear_hints();
	flag_set( "firing_range_penetration_done" );
}

raisePlywoodWalls()
{
	level.plywood rotateRoll( 90, 0.25, 0.1, 0.1 );
	level.plywood playSound( "trainer_target_up_wood" );
	level.plywood.up = true;
	level.plywood endon( "plywood_going_down" );
	level.plywood solid();
	level.plywood setCanDamage( true );
	wait .25;
	while( level.plywood.up == true )
	{
		level.plywood waittill ( "damage", amount, attacker, direction_vec, point, type );
		if ( !isdefined( attacker ) )
			continue;
		if ( !isdefined( type ) )
			continue;
		if ( isplayer( attacker ) )
		{
			level.lastTimePlywoodWasHit = gettime();
		}
	}
}

lowerPlywoodWalls()
{
	level.plywood rotateRoll( -90, 0.25, 0.1, 0.1 );
	level.plywood playSound( "trainer_target_up_wood" );
	level.plywood notify( "plywood_going_down" );
	level.plywood.up = false;
}

/****************************************************************************
    FIRING RANGE - FRAGS
****************************************************************************/ 
AA_frags_init()
{
	thread firing_range_frags();
	
	flag_wait( "firing_range_frags_done" );
	
	thread AA_find_pit_init();
}

frags_anims()
{
	flag_wait( "foley_done_talking_from_penetration_training" );
	level.foley.animnode notify( "stop_idle" );
	
	if ( !flag( "foley_turns_for_frag_demo" ) )
	{
		level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_idle_talk_2" );
		
		/*-----------------------
		FOLEY GOES INTO IDLE
		-------------------------*/	
		level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	}

	
	flag_wait( "foley_turns_for_frag_demo" );
	/*-----------------------
	FOLEY TURNS AROUND
	-------------------------*/	
	if ( !flag( "firing_range_frags_done" ) )
	{
		level.foley.animnode notify( "stop_idle" );
		level.foley.animnode anim_single_solo( level.foley, "training_intro_foley_turnaround_2" );
	}
	
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_idle", "stop_idle" );
	wait( 0.05 );
	flag_set( "foley_done_talking_from_frag_training" );
}

firing_range_frags()
{
	if ( !flag( "frags_have_been_spawned" ) )
		thread spawn_frags();
	
	thread autosave_by_name( "frags" );
	thread frags_anims();
	/*-----------------------
	PICKUP SOME FRAGS
	-------------------------*/	
	wait( 1 );
	//Sgt. Foley	Last but not least, you need to know how to toss a frag grenade.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_tossafrag" );
	level.foley dialogue_execute( "train_fly_tossafrag" );
		
	alreadyHadFrags = false;
	
	if ( !flag( "player_picked_up_frags" ) )
	{
		thread frags_glow();
		//Sgt. Foley	Private Allen, pick up some frag grenades from the table.	
		level.foley thread dialogue_execute( "train_fly_pickupfrag" );
		registerObjective( "obj_frags", &"TRAINER_PICK_UP_THE_FRAG_GRENADES", getEnt( "frag_trigger", "script_noteworthy" ) );
		setObjectiveState( "obj_frags", "current" );
	}
	else
	{
		alreadyHadFrags = true;
	}
	
	while ( level.player GetWeaponAmmoStock( "fraggrenade" ) < 3 )
		wait ( 0.05 );
	

	/*-----------------------
	THROW A FRAG INTO THE SPOT...
	-------------------------*/	
	if ( alreadyHadFrags )
	{
		registerObjective( "obj_frags", &"TRAINER_THROW_A_GRENADE_INTO", getEnt( "firing_range", "targetname" ) );
		setObjectiveState( "obj_frags", "current" );
		setObjectiveLocation( "obj_frags", getent( "firing_range", "targetname" ) );
	}
	else
	{
		thread setObjectiveString( "obj_frags", &"TRAINER_THROW_A_GRENADE_INTO" );
		setObjectiveState( "obj_frags", "current" );
		setObjectiveLocation( "obj_frags", getent( "firing_range", "targetname" ) );
	}
	
	flag_set( "foley_turns_for_frag_demo" );
	
	thread frag_nags();
	
	/*-----------------------
	WAITTILL FRAG SUCCESS
	-------------------------*/	
	numberOfTagretsToHit = 1;
	mustADS = undefined;
	mustCrouch = undefined;
	mustShootThroughPlywood = true;
	
	while ( !within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
		wait 0.05;
	
	//Pop translator into new idle while player not looking	
	level.translatoranimnode notify( "stop_idle" );
	level.translatoranimnode thread anim_loop_solo( level.translator, "training_intro_idle", "stop_idle" );
	level.traineeanimnode notify( "stop_idle" );
	level.traineeanimnode thread anim_loop_solo( level.trainee_01, "training_intro_idle", "stop_idle" );
	
	array_thread( level.grenade_targets,::target_pop_up_continuously, "targets_hit_with_grenades" );
	array_thread( level.grenade_targets,::set_flag_when_hit_by_grenade, "targets_hit_with_grenades" );
	
	thread keyHint( "frag", undefined, true );
	
	flag_wait( "targets_hit_with_grenades" );
	
	flag_set( "firing_range_frags_done" );
	clear_hints();
	wait( 1 );
	setObjectiveState( "obj_frags", "done" );


	if ( ( level.player GetWeaponAmmoStock( "fraggrenade" ) ) > 0 )
	{
		level.player SetWeaponAmmoStock( "fraggrenade", 0 );
	}
	
	array_thread( level.grenade_targets,::target_reset_manual );

}

frag_nags()
{
	nagNumber = 0;
	
	//Sgt. Foley	Toss a grenade down range to take out several targets at once.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_grenadedownrange" );
	level.foley dialogue_execute( "train_fly_grenadedownrange" );
	
	level endon( "targets_hit_with_grenades" );
	
	thread player_frag_usage_monitor();
	while( !flag( "targets_hit_with_grenades" ) )
	{
		wait( 6 );
		
		if ( !within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
		{
			thread killhouse_hint( &"TRAINER_HINT_TURN_AROUND" );
			while ( !within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
				wait 0.05;
			clear_hints();
		}
		else if ( !flag( "player_just_threw_a_frag" ) )
		{
			//Sgt. Foley	training	Private, throw a grenade and take out those targets.	
			//Sgt. Foley	training	Private, let's go. Throw a grenade at the targets!	
			//Sgt. Foley	training	Toss a grenade down range to take out several targets at once.	
			level.foley dialogue_execute( "frag_nag_0" + nagNumber );
			nagNumber++;
			if ( nagNumber > 2 )
				nagNumber = 0;
		}
	}
}

player_frag_usage_monitor()
{
	level endon( "targets_hit_with_grenades" );
	
	while( true )
	{
		level.player waittill_either( "grenade_pullback", "did_action_frag" );
		flag_set( "player_just_threw_a_frag" );
		wait( 5 );
		flag_clear( "player_just_threw_a_frag" );
	}
	
	
}
set_flag_when_hit_by_grenade( sFlagToSet )
{
	level endon( sFlagToSet );
	while( true )
	{
		self waittill ( "hit_with_grenade" );
		if (!flag( sFlagToSet ) )
			flag_set( sFlagToSet );
	}
}

target_pop_up_continuously( sFlagToStop )
{
	level endon( sFlagToStop );
	while ( true )
	{
		self notify( "pop_up" );
		self waittill ( "hit" );
		wait( 1 );
	}
}

//firing_range_frags_old()
//{
//	if ( !flag( "frags_have_been_spawned" ) )
//		thread spawn_frags();
//	
//	thread autosave_now( "frag_training" );
//	
//	/*-----------------------
//	PICKUP SOME FRAGS
//	-------------------------*/	
//	level.foley dialogue_execute( "Last but not least, you need to know how to toss a frag." );
//	
//	alreadyHadFrags = false;
//	
//	if ( !level.player GetWeaponAmmoStock( "fraggrenade" ) )
//	{
//		frags_glow();
//		level.foley thread dialogue_execute( "Ramirez, pick up some frag grenades from the table." );
//		registerObjective( "obj_frags", &"TRAINER_PICK_UP_THE_FRAG_GRENADES", getEnt( "frag_trigger", "script_noteworthy" ) );
//		setObjectiveState( "obj_frags", "current" );
//	}
//	else
//	{
//		alreadyHadFrags = true;
//	}
//	
//	while ( level.player GetWeaponAmmoStock( "fraggrenade" ) < 3 )
//		wait ( 0.05 );
//	
//
//	/*-----------------------
//	THROW A FRAG INTO THE SPOT...
//	-------------------------*/	
//	level.foley thread dialogue_execute( "Toss a grenade into one of those mortar craters." );
//	if ( alreadyHadFrags )
//	{
//		registerObjective( "obj_frags", &"TRAINER_THROW_A_GRENADE_INTO", getEnt( "firing_range", "targetname" ) );
//		setObjectiveState( "obj_frags", "current" );
//	}
//	else
//	{
//		thread setObjectiveString( "obj_frags", &"TRAINER_THROW_A_GRENADE_INTO" );
//		setObjectiveState( "obj_frags", "current" );
//	}
//
//	/*-----------------------
//	WAITTILL FRAG SUCCESS
//	-------------------------*/	
//	
//	grenade_damage_triggers = getentarray( "grenade_damage_trigger", "targetname" );
//	array_thread( grenade_damage_triggers,::frag_triggers_think, "player_has_thrown_frag_into_target" );
//	
//	thread keyHint( "frag", undefined, true );
//	flag_wait( "player_has_thrown_frag_into_target" );
//	
//	clear_hints();
//	setObjectiveState( "obj_frags", "done" );
//	level.foley dialogue_execute( "Good." );
//	flag_set( "firing_range_frags_done" );
//
//}

//nags_frag()
//{
//	level endon( "player_has_thrown_frag_into_target" );
//	while( !flag( "player_has_thrown_frag_into_target" ) )
//	{
//		clear_hints();
//		thread keyHint( "frag", undefined, true );
//		wait( 5 );
//	}
//}

frag_triggers_think( sFlagToSetWhenComplete )
{
	//self ==> the damage trigger
	self enablegrenadetouchdamage();
	while( true )
	{
		self waittill( "trigger" );
		if ( !flag( sFlagToSetWhenComplete ) )
			flag_set( sFlagToSetWhenComplete );
		break;
	}
}

frags_glow()
{
	frags = getentarray( "frags", "script_noteworthy" );
	array_thread( frags,::glow );
	
	flag_wait( "player_picked_up_frags" );
	
	array_thread( frags,::stopglow );	
}

frags_glow_stop()
{
	frags = getentarray( "frags", "script_noteworthy" );
	array_thread( frags,::stopglow );	
}

spawn_frags()
{
	flag_set( "frags_have_been_spawned" );
	
	frag_trigger = getent( "frag_trigger", "script_noteworthy" );
	grenade_box = getent( "grenade_box", "targetname" );
	grenade_box setmodel( "mil_grenade_box_opened" );
	level.frags = getentarray( "frags", "script_noteworthy" );
	level.fragsPickups = getentarray( "frags_pickup", "targetname" );
	maxFrags = 4;
	level endon( "firing_range_frags_done" );
	while( true )
	{
		wait( .1 );
		frag_trigger waittill( "trigger" );
		
		if ( !level.player WorldPointInReticle_Circle( grenade_box.origin, 45, 400 ) )
			continue;
			
		if ( level.player GetWeaponAmmoStock( "fraggrenade" ) > 3 )
			continue;
		if ( !flag( "player_picked_up_frags" ) )
		{
			flag_set( "player_picked_up_frags" );
			level.player giveWeapon( "fraggrenade" );
			level.player SetWeaponAmmoStock( "fraggrenade", 0 );
			frags_glow_stop();
		}
		currentPlayerFrags = level.player GetWeaponAmmoStock( "fraggrenade" );
		fragsToHide = maxFrags - currentPlayerFrags;
		if ( fragsToHide > 0 )
		{
			hide_frags_till_player_not_looking( fragsToHide );
			level.player GiveMaxAmmo( "fraggrenade" );
			level.player playsound( "grenade_pickup" );
		}
	}
}


hide_frags_till_player_not_looking( fragsToHide )
{
	level endon( "firing_range_frags_done" );
	validFragsToHide = [];
	foreach( frag in level.fragsPickups )
	{
		if ( !isdefined( frag.hidden ) )
			validFragsToHide[ validFragsToHide.size ] = frag;
	}
	
	//if we are already hiding all the frags, return;
	if ( validFragsToHide.size == 0 )
		return;
		
	i = 0;
	fragToHide = undefined;
	hiddenFrags = [];
	while( i < fragsToHide )
	{
		wait( 0.05 );
		fragToHide = getclosest( level.player.origin, validFragsToHide );
		if ( !isdefined( fragToHide ) )
			continue;
		validFragsToHide = array_remove( validFragsToHide, fragToHide );
		fragToHide hide();
		fragToHide.hidden = true;
		hiddenFrags[ hiddenFrags.size ] = fragToHide;
		i++;
	}
	thread show_me_when_player_not_looking_or_timeout( hiddenFrags, 3 );
}

show_me_when_player_not_looking_or_timeout( hiddenFrags, timeout )
{
	level endon( "firing_range_frags_done" );
	
	wait( .5 );
	//don't bother until player on his last frag
	while ( level.player GetWeaponAmmoStock( "fraggrenade" ) > 0 )
		wait ( 0.05 );
	
	start_time = gettime();
	while( true )
	{
		wait( .5 );
		if ( within_fov( level.player.origin, level.player getplayerangles(), level.firing_range_area.origin, level.cosine[ "45" ] ) )
			break;
		if ( gettime() >= start_time + timeout * 1000 )
			break;
	}
	array_call( hiddenFrags,::show );
	foreach( frag in hiddenFrags )
		frag.hidden = undefined;
}

/****************************************************************************
    OBJECTIVE TO THE PIT START
****************************************************************************/ 

AA_find_pit_init()
{
	thread AA_find_the_pit_sequence();
	flag_wait( "sidearm_complete" );
	
	thread AA_pit_init();
}

go_to_pit_anims()
{
	flag_wait( "firing_range_frags_done" );
	flag_wait( "foley_done_talking_from_frag_training" );
	level.foley.animnode notify( "stop_idle" );
	level.traineeanimnode notify( "stop_idle" );
	level.translatoranimnode notify( "stop_idle" );
	
	//foley and crew regroup
	level.foley.animnode thread anim_single_solo( level.foley, "training_intro_end" );
	level.traineeanimnode thread anim_single_solo( level.trainee_01, "training_intro_end" );
	level.translatoranimnode anim_single_solo( level.translator, "training_intro_end" );
	
	//idle forever doing weapon demo
	level.foley.animnode thread anim_loop_solo( level.foley, "training_intro_end_idle", "stop_idle" );
	level.translatoranimnode thread anim_loop_solo( level.translator, "training_intro_end_idle", "stop_idle" );
	level.traineeanimnode anim_loop_solo( level.trainee_01, "training_intro_end_idle", "stop_idle" );
	
}

AA_find_the_pit_sequence()
{
	/*-----------------------
	SIDEARM TRAINING SETUP
	-------------------------*/	
	level.pitguy.isidling = true;
	level.pitguygun show();
	level.pitguy.animnode anim_first_frame( level.pitActors, "training_pit_sitting_welcome" );
	level.pitguy.animnode anim_first_frame( level.pitcases, "training_pit_open_case" );
	level.pitguy.animnode thread anim_loop( level.pitActors, "training_pit_sitting_idle", "stop_idle" );
	
	//Sgt. Foley	Good.	
	level.foley dialogue_execute( "train_fly_good" );
	
	//Sgt. Foley Note that frags tend to roll on sloped surfaces. So think twice before tossing one up hill.	
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_fragstendtoroll" );
	level.foley dialogue_execute( "train_fly_fragstendtoroll" );

	/*-----------------------
	FOLEY STEPS AWAY
	-------------------------*/	
	blocker_range = getent( "blocker_range", "targetname" );
	blocker_range hide_entity();
	thread go_to_pit_anims();
	
	thread autosave_by_name( "find_the_pit" );
	
	//Sgt. Foley  Thanks for the help, Private Allen. Now get over to The Pit...Colonel Shepherd wants to see you run the course.	
	flag_wait( "notetrack_dialogue_foley_thanks_for_help" );
	level.foley play_sound_on_entity( "train_fly_thanksforhelp" );
	
	thread dialogue_ambient();
	
	setSavedDvar( "objectiveAlpha", 1 );
	registerObjective( "obj_course_locate", &"TRAINER_OBJ_GO_TO_THE_PIT", getEnt( "origin_sidearm_table_babystep_1", "targetname" ) );
	setObjectiveState( "obj_course_locate", "current" );
	flag_set( "obj_go_to_the_pit_given" );
	
	delaythread ( 4, ::objective_hints, "obj_go_to_the_pit_done" );
	
	//Sgt. Foley  All right, who here wants to go first? Show me what you've learned so far.	
	flag_wait( "notetrack_dialogue_foley_who_go_first" );
	level.translator delaythread( level.translatordelay,::dialogue_execute, "train_fly_gofirst" );
	level.foley play_sound_on_entity( "train_fly_gofirst" );
	
	flag_wait( "player_passing_barracks" );
	
	flag_wait( "player_at_pit_stairs" );
	setObjectiveLocation( "obj_course_locate", getent( "origin_sidearm_table", "targetname" ) );
	
	/*-----------------------
	SIDEARM TRAINING
	-------------------------*/	
	flag_wait( "player_entering_course" );
	flag_set( "obj_go_to_the_pit_done" );
	wait( 0.05 );
	clear_hints();
	setObjectiveState( "obj_course_locate", "done" );
	
	thread sideArm_Training();
}

pitguy_anims()
{
	level.pitguy.animnode notify( "stop_idle" );
	level.pitguy.animnode anim_single( level.pitActors, "training_pit_sitting_welcome" );
	level.pitguy.animnode notify( "stop_idle" );
	level.pitguy.animnode thread anim_loop( level.pitActors, "training_pit_sitting_idle", "stop_idle" );
	flag_set( "dunn_finished_welcome_anim" );
}

sideArm_Training()
{
	setSavedDvar( "objectiveAlpha", level.oldObjectiveAlpha );
	thread autosave_by_name( "sidearm" );

	thread pitguy_anims();
	
	flag_wait( "dunn_dialogue_welcome_01" );
	//Cpl. Dunn  Hey Private. Welcome back to The Pit. 	
	level.pitguy play_sound_on_entity( "train_cpd_welcomeback" );
	
	flag_wait( "dunn_dialogue_welcome_02" );
	//Cpl. Dunn  I hear Colonel Shepherd wants to pull a shooter from our unit for some special op - he's up there in observation.
	level.pitguy play_sound_on_entity( "train_cpd_specialop" );
	
	alreadyHadPistol = true;
	if ( !level.player HasWeapon( level.gunSidearm ) )
	{
		alreadyHadPistol = false;
		registerObjective( "obj_sidearm", &"TRAINER_GET_A_PISTOL_FROM_THE", getEnt( "origin_sidearm_table", "targetname" ) );
		setObjectiveState( "obj_sidearm", "current" );
		//Cpl. Dunn  Go ahead and grab a pistol. 
		level.pitguy dialogue_execute( "train_cpd_grabapistol" );
		pickup_sidearm = getent( "pickup_sidearm", "targetname" );
		if ( isdefined( pickup_sidearm ) ) 
			pickup_sidearm glow();
	}
	
	while ( ! level.player HasWeapon( level.gunSidearm ) )
	{
		//NAG_HINT: Approach the table and hold [USE_BUTTON] to pick up a pistol.
		wait .05;
	}
	
	if ( alreadyHadPistol == true )
	{
		registerObjective( "obj_sidearm", &"TRAINER_GET_A_PISTOL_FROM_THE", getEnt( "origin_course_01", "targetname" ) );
		setObjectiveState( "obj_sidearm", "current" );
		//Cpl. Dunn	OK. So you already have your side arm.
		//level.pitguy dialogue_execute( "train_cpd_alreadyhave" );
	}
	else
	{
		wait( 1 );
	}
	
	setObjectiveLocation( "obj_sidearm", getent( "origin_course_01", "targetname" ) );
	setObjectiveString( "obj_sidearm", &"TRAINER_SWITCH_TO_YOUR_RIFLE" );
	
	currentWeapon = level.player getCurrentWeapon();
	if (  currentWeapon == level.gunSidearm )
	{
		//Cpl. Dunn  Alright, try switching to your rifle
		level.pitguy dialogue_execute( "train_cpd_switchtorifle" );
		
		currentWeapon = level.player getCurrentWeapon();
		if (  currentWeapon != level.gunPrimary )
			thread keyHint( "primary" );
	
		while ( level.player getCurrentWeapon() != level.gunPrimary )
		{
			thread keyHint( "primary" );
			wait .05;
		}
			
			
		clear_hints();
		
		//Cpl. Dunn  Good. Switch to your sidearm again.	
		level.pitguy dialogue_execute( "train_cpd_switchtosidearm" );

		if ( level.player getCurrentWeapon() != level.gunSidearm )
		{
			//NAG_HINT: Press [WEAPON_SWITCH] to switch to your pistol.
			thread keyHint( "sidearm" );
			//wait .05;
		}
		while ( level.player getCurrentWeapon() != level.gunSidearm )
		{
			wait .05;
			clear_hints();
			thread keyHint( "sidearm" );
		}
			
		
		clear_hints();
	}
	else
	{
		//Cpl. Dunn	Do me a favor and try switching to your sidearm.	
		level.pitguy dialogue_execute( "train_cpd_tryswitching" );
		if ( level.player getCurrentWeapon() != level.gunSidearm )
		{
			//NAG_HINT: Press [WEAPON_SWITCH] to switch to your pistol.
			thread keyHint( "sidearm" );
			//wait .05;
		}
		while ( level.player getCurrentWeapon() != level.gunSidearm )
		{
			clear_hints();
			thread keyHint( "sidearm" );
			wait .05;
		}
			
			
		clear_hints();
	}

	//Cpl. Dunn  You see how switching to your pistol is always faster than reloading?	
	level.pitguy dialogue_execute( "train_cpd_alwaysfaster" );
	
	setObjectiveState( "obj_sidearm", "done" );
	
	flag_set ( "sidearm_complete" );
	level notify ( "sideArmTraining_end" );
}

/****************************************************************************
    CQB PIT COURSE START
****************************************************************************/ 

AA_pit_init()
{
	thread AA_pit_sequence();
	thread pit_cases_and_door();
}

AA_pit_sequence()
{
	if ( !isdefined( level.pitguy.isidling ) ) 
	{
		level.pitguygun show();
		level.pitguy.animnode anim_first_frame( level.pitActors, "training_pit_sitting_welcome" );
		level.pitguy.animnode thread anim_loop( level.pitActors, "training_pit_sitting_idle", "stop_idle" );
		wait( 3 );
	}
	
	/*-----------------------
	PIT GUY OPENS CASE AND SHOWS MORE WEAPONRY
	-------------------------*/	
	
	//Cpl. Dunn	Smile for the cameras and don't miss.. Shepard and the rest of the brass are scouting for a shooter for some special op.	
	thread dunn_open_case_dialogue();
	
	thread course_loop_think();
	thread AI_delete_when_out_of_sight( level.patrolDudes, 256 );

	flag_wait( "dunn_finished_welcome_anim" );

	level.pitguy.animnode notify( "stop_idle" );
	level.pitguy.animnode thread anim_single( level.pitcases, "training_pit_open_case" );
	level.pitguy.animnode anim_single( level.pitActors, "training_pit_open_case" );
	level.pitguy.animnode thread anim_loop( level.pitActors, "training_pit_stand_idle", "stop_idle"  );
	

	/*-----------------------
	TELEPORT PIT GUY WHILE PLAYER IS RUNNING COURSE
	-------------------------*/	
	flag_wait( "player_course_stairs2" );
	level.pitguy.animnode notify( "stop_idle" );
	level.pitguy.animnode = getent( "node_dunn_training_exit", "targetname" );
	level.pitguy.animnode thread anim_loop( level.pitActors, "training_pit_stand_idle", "stop_idle"  );
//	level.pitguygun delete();
}

dunn_open_case_dialogue()
{
	flag_wait( "dunn_notetrack_open_case_dialogue" );
	//Cpl. Dunn	Smile for the cameras and don't miss.. Shepard and the rest of the brass are scouting for a shooter for some special op.	
	level.pitguy play_sound_on_entity( "train_cpd_smileforcameras" );
	flag_set( "dunn_finished_with_open_case_dialogue" );
}	

spawn_pitguy()
{
	level.pitguy = spawn_targetname( "pitguy", true );
	level.pitguy gun_remove();
	level.pitguy.animname = "dunn";
	level.pitguygun = spawn( "script_model", ( 0, 0, 0 ) );
	level.pitguygun setmodel( "viewmodel_desert_eagle" );
	level.pitguygun.origin = level.pitguy.origin;
	level.pitguygun hide();
	level.pitguygun.animname = "pit_gun";
	level.pitguygun assign_animtree();
	level.pitguy.animnode = getent( "node_dunn_training", "targetname" );
	level.pitActors = [];
	level.pitActors[ 0 ] = level.pitguy;
	level.pitActors[ 1 ] = level.pitguygun;
}

pit_cases_and_door()
{
	/*-----------------------
	PIT GUY OPENS CASE AND SHOWS MORE WEAPONRY
	-------------------------*/	
	flag_wait( "case_flip_01" );
	level.pit_case_01 playsound( "scn_trainer_case_open1" );	
	pit_weapons_case_01 = getentarray( "pit_weapons_case_01", "script_noteworthy" );
	array_thread( pit_weapons_case_01,::weapons_show );
	
	flag_wait( "case_flip_02" );
	level.pit_case_02 playsound( "scn_trainer_case_open2" );
	pit_weapons_case_02 = getentarray( "pit_weapons_case_02", "script_noteworthy" );
	array_thread( pit_weapons_case_02,::weapons_show );
	
	flag_wait( "button_press" );
	thread autosave_by_name( "pit_course_start" );
	level.gate_cqb_enter thread door_open();
	
	flag_wait( "player_course_stairs2" );
	
	/*-----------------------
	MORE WEAPONRY ON TABLE BY THE TIME THE PLAYER GETS BACK
	-------------------------*/	
	pit_weapons_table = getentarray( "pit_weapons_table", "script_noteworthy" );
	array_thread( pit_weapons_table,::weapons_show );


}

course_loop_think()
{
	level endon( "clear_course" );
	level endon( "mission failed" );
	numTimesPlayed = 0;
	setdvar( "killhouse_too_slow", "0" );
	level.first_time = true;
	previous_time = 0;
	previous_selection = "none";
	clear_hints();
	numberOfTimesRun = 0;
	/*-----------------------
	COURSE LOOPS
	-------------------------*/	
	while( true )
	{
		if ( level.first_time )
		{
//			if ( ( !( level.player getCurrentWeapon() == "mp5" ) ) || ( level.player GetWeaponAmmoStock( "flash_grenade" ) < 4 ) )
//			{
//				//"Pick up that MP5 and four flashbangs." );
//				level.price thread execDialog( "pickupmp5" );
//				// Equip the MP5 and pick up 4 flashbangs.
//				setObjectiveString( "obj_price", &"KILLHOUSE_EQUIP_THE_MP5_AND_PICK" );
//				setObjectiveLocation( "obj_price", getent( "obj_flashes", "targetname" ) );
//			}
		}
		else
		{
//			jump_off_trigger thread jumpoff_monitor();
//
//			//"Replace any flash bangs you used." 
//			level.price execDialog( "replaceflash" );
//			if ( !( level.player getCurrentWeapon() == "mp5" ) )
//			{
//				//"Equip your MP5." 
//				level.price execDialog( "equipmp5" );
//			}
		}

		/*-----------------------
		WAIT UNTILL PLAYER HAS FULL AMMO
		-------------------------*/	
		//TODO
		
		/*-----------------------
		SPECIFIC DIALOGUE FOR FIRST-TIMERS
		-------------------------*/	
		if ( level.first_time )
		{
			//level.price execDialog( "ropedeck" );	// On my go, I want you to rope down to the deck and rush to position 1.
			//level.price execDialog( "stormstairs" );	// After that you will storm down the stairs to position 2.
			//level.price execDialog( "hit3and4" );	// Then hit position 3 and 4 following my precise instructions at each position.
		}
		
		thread dialogue_nag_start_course( level.first_time );
		
		/*-----------------------
		COURSE OBJECTIVE
		-------------------------*/	
		if( level.first_time )
		{
			level.objectiveRegroup = 0;
			registerObjective( "obj_course", &"TRAINER_OBJ_COURSE", getEnt( "origin_course_01", "targetname" ) );
			setObjectiveState( "obj_course", "current" );
		}
		
		/*-----------------------
		RESET CQB COURSE AND OPEN DOOR
		-------------------------*/
		course_triggers_01 = getentarray( "course_triggers_01", "script_noteworthy" );
		array_notify( course_triggers_01, "activate" );

		/*-----------------------
		COURSE START
		-------------------------*/
		flag_wait( "player_has_started_course" );
		flag_clear( "dunn_finished_with_difficulty_selection_dialogue" );
		
		setObjectiveLocation( "obj_course", getent( "origin_course_01", "targetname" ) );
		if ( level.objectiveRegroup != 0 )
			setObjectiveString( "obj_course", &"TRAINER_OBJ_COURSE" );
		
		
		flag_clear( "melee_target_hit" );
		level.targets_hit_with_melee = 0;
		
		thread target_flag_management();
		if( level.first_time )
		{
			thread dialogue_course_civilian_killed();	
			delaythread ( 3,::dialogue_ambient_pit_course );
		}
		level.recommendedDifficulty = undefined;
		
		thread dialogue_course();

		conversation_orgs_pit = getentarray( "conversation_orgs_pit", "targetname" );
		org = getclosest( level.player.origin, conversation_orgs_pit );
		
		if ( cointoss() )
		{
			//Ranger 3   Come on. Get some, Allen!	
			org delaythread( 3,::play_sound_in_space, "train_ar3_getsome" );
		}
		else if ( cointoss() )
		{
			//Ranger 4   Bring it, bitch!	
			org delaythread( 3,::play_sound_in_space, "train_ar4_bringit" );
		}
		else
		{
			//Ranger 5   Come on! Get some!	
			org delaythread( 3,::play_sound_in_space, "train_ar5_comeon" );
		}
		
		/*-----------------------
		TOP OFF PLAYER WEAPONS
		-------------------------*/
		playerPrimaryWeapons = level.player GetWeaponsListPrimaries();
		if ( playerPrimaryWeapons.size > 0 )
		{
			foreach ( weapon in playerPrimaryWeapons )
				level.player givemaxammo( weapon );
		}

		level.targets_hit = 0;
		level.friendlies_hit = 0;
		
		if ( getdvarint( "killhouse_too_slow" ) >= 1 )
			thread startTimer( level.timelimitMax );
		else
			thread startTimer( level.timelimitMin );
		
		thread accuracy_bonus();

		if ( isdefined( level.IW_deck ) )
			level.IW_deck destroy();
		

		
		setObjectiveLocation( "obj_course", getEnt( "origin_course_02", "targetname" ) );
	
		flag_wait( "player_course_03a" );
		setObjectiveLocation( "obj_course", getEnt( "origin_course_03", "targetname" ) );
		
		/*-----------------------
		MELEE TARGET
		-------------------------*/	
		flag_wait( "player_course_stairs2" );
		
		thread key_hint_till_flag_set( "melee", "melee_target_hit" );

		
		flag_wait( "player_course_upstairs" );
		
		level.gate_cqb_enter thread door_close();
		level.gate_cqb_exit thread door_open();
		flag_clear( "player_inside_course" );
		course_end_blocker = getent( "course_end_blocker", "targetname" );
		course_end_blocker hide_entity();
		setObjectiveLocation( "obj_course", getEnt( "origin_course_03a", "targetname" ) );
		
		flag_wait( "player_course_jumping_down" );
		
		setObjectiveLocation( "obj_course", getEnt( "origin_course_05", "targetname" ) );
		
		/*-----------------------
		SPRINT TO FINISH
		-------------------------*/	
		flag_wait_either( "player_course_end_02", "course_end_targets_dead" );
		
		flag_wait( "player_course_end_03" );
		flag_clear( "player_has_started_course" );
		
		/*-----------------------
		SPRINT LOGIC LOOP - MUST SPRINT TO EXIT
		-------------------------*/	
		first_sprint_try = true;
		iNag_didnt_sprint_number = 0;
		iNag_sprint_number = 0;
		
		while( true )
		{
			flag_wait( "player_standing_on_sprint_marker" );
			flag_clear( "sprinted" );
			
			thread player_sprint_monitor();
			clear_hints();
			
			/*-----------------------
			SETUP SPRINT DETECTORS
			-------------------------*/	
			notify_on_sprint();
			thread flag_on_notify( "sprinted" );
			
			//player must sprint
			if ( level.xenon )// ghetto but PS3 requires "Press X" and 360 requires "Click X"
				thread key_hint_till_flag_set( "sprint", "player_course_end" );
			else
				thread key_hint_till_flag_set( "sprint_pc", "player_course_end" );
				
			if ( first_sprint_try )
			{
				//Cpl. Dunn  Sprint to the exit! Clock's ticking!	
				thread radio_dialogue( "train_cpd_sprint" );
				first_sprint_try = false;
			}
			else
			{
				setObjectiveLocation( "obj_course", getEnt( "origin_course_05", "targetname" ) );
				level.gate_cqb_exit thread door_open( undefined, true );
				thread exit_light_off();
				//Cpl. Dunn     Go! Sprint to the exit!
				//Cpl. Dunn     Move! Sprint, Private!
				//Cpl. Dunn     Sprint, Allen! Go! Go! Go!
				//Cpl. Dunn     Now sprint to the exit! Move! Move! Move!
				thread radio_dialogue( "nag_sprint_0" + iNag_sprint_number );
				iNag_sprint_number++;
				if ( iNag_sprint_number > 3 )
					iNag_sprint_number = 0;
			}
			
			flag_wait( "player_sprint_door_close" );
			
			if ( !flag( "sprinted" ) )
			{
				/*-----------------------
				PLAYER DIDN'T SPRINT
				-------------------------*/	
				setObjectiveLocation( "obj_course", getEnt( "origin_course_sprint", "targetname" ) );
				level.gate_cqb_exit thread door_close( undefined, true );
				level.gate_cqb_exit thread play_sound_on_entity( "door_close_buzzer" );
				thread exit_light_on();
				//Cpl. Dunn     You need to sprint to complete the course. Go back to the red circle and try again
				//Cpl. Dunn     You didn't sprint, Private. Go back to the red circle and sprint to the exit.
				//Cpl. Dunn     You need to sprint, Private. Go back to the red circle and sprint to the end.
				//Cpl. Dunn     You can't finish till you sprint, Allen. Go back to the red circle and sprint to the end.
				thread radio_dialogue( "nag_didnt_sprint_0" + iNag_didnt_sprint_number );
				thread killhouse_hint( &"TRAINER_TRY_SPRINT_AGAIN", undefined, true ); 
				iNag_didnt_sprint_number++;
				if ( iNag_didnt_sprint_number > 3 )
					iNag_didnt_sprint_number = 0;
			}
			else
			{
				break;
			}
		}
		
		//if ( !flag( "player_course_end" ) )
			//thread second_sprint_hint();
			
		/*-----------------------
		COURSE END
		-------------------------*/	
		flag_wait( "player_course_end" );
		course_end_blocker = getent( "course_end_blocker", "targetname" );
		course_end_blocker show_entity();
		
		numberOfTimesRun++;
		clear_hints();
		
		thread reset_course_targets();
		level.gate_cqb_exit thread door_close( "player_course_end_close_gate" );

		//level notify ( "kill_sprint_hint" );
		clear_hints();

		flag_clear( "sprinted" );
		
		level notify ( "test_cleared" );
		
		final_time = killTimer( level.bestPitTime, false );
			
		
		while( !isdefined( level.recommendedDifficulty ) )
			wait( .1 );
		selection = dialog_end_of_course( numberOfTimesRun );
		
		if ( level.recommendedDifficulty == 1000 )
		{
			selection = undefined;
			
			if ( level.targets_hit_with_melee > 10 )
			{
				//Cpl. Dunn	You took out too many targets with your knife. Try again, this time, with bullets.
				selection = "train_cpd_targetswithknife";
			}
			else if ( level.toomanycivilianskilled && level.basetimetooklongerthanminimum ) 
			{
				//Cpl. Dunn	training	Not good enough, Allen. You took too long and killed too many civilians. Try it again.	
				selection = "train_cpd_longandcivilians";
			}
			else if ( level.toomanytargetsmissed && level.basetimetooklongerthanminimum ) 
			{
				//Cpl. Dunn	training	Not good enough, Allen. You took too long and missed too many targets. Try it again.	
				selection = "train_cpd_longandtargets";
			}
			else if ( level.toomanytargetsmissed )
			{
				//Cpl. Dunn	training	Not good enough, Allen. You missed too many targets. Try it again.	
				selection = "train_cpd_targets";
			}
			else if ( level.toomanycivilianskilled )
			{
				//Cpl. Dunn	training	Not good enough, Allen. You killed too many civilians. Try it again.	
				selection = "train_cpd_civilians";
			}
			else
			{
				//Cpl. Dunn	Too damn slow. You need to run it again, Private.	
				selection = "train_cpd_needtorunagain";
			}
		}
		
		else
		{
			//player passed....upload score
			level.player UploadTime( "LB_KILLHOUSE", final_time );
			
			thread try_again();

		}
		
		level.pitguy dialogue_execute( selection );
		
		previous_selection = selection;
		
		previous_time = final_time;
		
		level.gate_cqb_enter thread door_open();
		
		/*-----------------------
		DO IT AGAIN, OR EXIT?
		-------------------------*/	
		if ( level.recommendedDifficulty != 1000 )
		{
			if ( !flag( "player_has_started_course" ) )
			{
				//player passed....give the option of trying again....or not
				//Cpl. Dunn  You can run the course again or regroup with the others by the main gate.	
				level.pitguy thread dialogue_execute( "train_cpd_runagain", "dunn_finished_with_difficulty_selection_dialogue" );
				setObjectiveLocation( "obj_course", getent( "course_start", "targetname" ) );
				setObjectiveString( "obj_course", &"TRAINER_OBJ_EXIT_THE_PIT" );
				level.objectiveRegroup = 1;
			}
		}
		else
		{
			setObjectiveLocation( "obj_course", getent( "origin_course_01", "targetname" ) );
		}
		
		flag_wait_either( "player_inside_course", "player_done_with_course" );
		
		if( flag( "player_done_with_course" ) )
			break;
		
		level.first_time = false;

	}
}

player_sprint_monitor()
{
	level notify( "starting sprint monitor" );
	level endon( "starting sprint monitor" );
	level endon( "sprinted" );
	level endon( "player_course_end" );
	
	sprint_volume = getent( "sprint_volume", "targetname" );
	while( true )
	{
		wait( 0.05 );
		vel = level.player GetVelocity();
		// figure out the length of the vector to get the speed (distance from world center = length)
		velocity = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
		if ( ( isdefined( velocity ) ) && ( velocity > 250 ) && ( level.player istouching( sprint_volume ) ) )
		{
			flag_set( "sprinted" );
		}
	}
}

exit_light_on()
{
	redlight_fx_org = GetStruct( "light_exit", "targetname" );
	level.exitDoorLightEffect = PlayLoopedFX( getfx( "redlight_fx" ), 50, redlight_fx_org.origin, 2500 );
	level.exitDoorLightEffect.dummy = spawn_tag_origin();
	level.exitDoorLightEffect.dummy.origin = redlight_fx_org.origin;
	playfxontag( getfx( "dlight_red" ), level.exitDoorLightEffect.dummy, "tag_origin" );
}

exit_light_off()
{
	if ( isdefined( level.exitDoorLightEffect ) )
	{
		level.exitDoorLightEffect Delete();
		level.exitDoorLightEffect.dummy delete();
	}
}

get_global_fx( name )
{
	fxName = level.global_fx[ name ];
	return level._effect[ fxName ];
}

try_again()
{
	level endon( "player_has_started_course" );
	
	level notify( "try_again_thread" );
	level endon( "try_again_thread" );
	
	/*-----------------------
	MENU POPUP FOR DIFFICULTY SELECTION
	-------------------------*/	
	flag_wait_either( "player_entering_course", "player_course_looking_down_hall_to_exit" );
	level.player freezecontrols( true );
	setblur( 2, .1 );
	wait( 1 );
	
	// <menu popup> selects difficulty, the difficulty selected is the difficulty this level will be completed in.
	level.player openpopupMenu( "select_difficulty" );
	while ( true )
	{
		level.player waittill( "menuresponse", menu, response );
		if ( response == "continue" || response == "tryagain" )
			break;

		level.player openpopupMenu( "select_difficulty" );
	}
	assertex( response == "continue" || response == "tryagain", "Menu response from Training difficulty selection is incorrect!" );
	
	setblur( 0, .2 );
    level.player freezecontrols( false );
	
	//level notify( "okay_if_friendlies_in_line_of_fire" );
	
	if ( response == "tryagain" )
	{
		//Cpl. Dunn	Alright. Head back in and give it another go.	
		level.pitguy thread dialogue_execute( "train_cpd_anothergo" );
		setObjectiveLocation( "obj_course", getent( "origin_course_01", "targetname" ) );
		setObjectiveString( "obj_course", &"TRAINER_OBJ_COURSE" );
		level.objectiveRegroup = 0;
	}
	else
	{
		flag_set( "player_done_with_course" );
		
		//setObjectiveLocation( "obj_course", getent( "course_start", "targetname" ) );
		//setObjectiveString( "obj_course", &"TRAINER_OBJ_EXIT_THE_PIT" );
		//setObjectiveState( "obj_course", "current" );
				
		if ( !level.endingThreadStarted )
		{
			level.endingThreadStarted = true;
			thread AA_ending_init();
		}
		level.gate_cqb_enter thread door_close();
		
		if ( flag( "dunn_finished_with_difficulty_selection_dialogue" ) )
		{
			//Cpl. Dunn	Alright. Head upstairs and regroup with the others	
			level.pitguy dialogue_execute( "train_cpd_headupstairs" );
		}

		
		clear_timer_elems();
		clear_hints();
		level notify( "kill_timer" );
		level notify( "clear_course" );
	}
}

key_hint_till_flag_set( hintString, sFlagToEndOn )
{
	thread keyHint( hintString, undefined, undefined, true );
	thread clear_hints_on_flag( sFlagToEndOn );
}

reset_course_targets()
{
	foreach ( target in level.targets )
	{
		target target_reset_manual();
		if ( isdefined( target.lateralStartPosition ) )
		{
			target thread target_lateral_reset_random();
		}
	}	
}

target_flag_management()
{
	waittill_targets_killed_and_flag_is_set_or_timeout_on_flag( 10, "course_start_targets_dead", "player_course_03a" );
	
	flag_wait( "player_course_03a" );
	
	waittill_targets_killed_and_flag_is_set_or_timeout_on_flag( 3, "course_first_floor_targets_dead", "player_course_stairs" );
	
	flag_wait( "player_course_stairs" );
	
	waittill_targets_killed_and_flag_is_set_or_timeout_on_flag( 5, "course_second_floor_targets_dead", "player_course_jumped_down" );
	
	flag_wait( "player_course_jumped_down" );
	
	waittill_targets_killed_and_flag_is_set_or_timeout_on_flag( 6, "course_end_targets_dead", "player_course_end_03" );
	
	flag_clear( "course_start_targets_dead" );
	flag_clear( "course_first_floor_targets_dead" );
	flag_clear( "course_second_floor_targets_dead" );
	flag_clear( "course_end_targets_dead" );
}

waittill_targets_killed_and_flag_is_set_or_timeout_on_flag( iNumberOfTargets, sFlagToSetWhenKilled, sFlagToTimeOutOn )
{
	level endon( sFlagToTimeOutOn );
	iTargetsKilled = 0;
	while( iTargetsKilled < iNumberOfTargets )
	{
		level waittill ( "target_killed" );
		iTargetsKilled++;
	}
	flag_set( sFlagToSetWhenKilled );
}

player_alt_weapon_has_ammo()
{
	currentWeapon = level.player getcurrentweapon();
	heldweapons = level.player GetWeaponsListPrimaries();
	foreach( weapon in heldweapons )
	{
		if ( weapon == currentWeapon )
			continue;
		altWeaponAmmo = level.player GetWeaponAmmoClip( weapon );
		if ( altWeaponAmmo > 5 )
			return true;
		else
			return false;
	}
	return false;
}

dialogue_course()
{
	flag_wait( "player_has_started_course" );
	flag_clear( "no_more_course_nags" );
	thread dialogue_course_reload_nag();
	thread dialogue_course_hurry_up();
	thread dialogue_course_ADS_nag();
	
	/*-----------------------
	COURSE START
	-------------------------*/	
	level.pitguy stopsounds();
	if ( flag( "can_talk" ) )
	{
		//Cpl. Dunn	Clear the first area. Go! Go! Go!	
		flag_clear( "can_talk" );
		radio_dialogue( "train_cpd_clearfirstgogogo" );
		flag_set( "can_talk" );	
	}
	
	/*-----------------------
	FIRST AREA CLEARED/PASSED BY
	-------------------------*/	
	flag_wait_either( "player_course_03a", "course_start_targets_dead" );
	if ( flag( "course_start_targets_dead" ) )
	{
		if ( flag( "can_talk" ) )
		{
			//Cpl. Dunn	Area cleared! Move into the building!
			flag_clear( "can_talk" );
			radio_dialogue( "train_cpd_areacleared" );
			flag_set( "can_talk" );	
		}
	}
	else
	{
		if ( flag( "can_talk" ) )
		{
			flag_clear( "can_talk" );
			//Cpl. Dunn	You missed some targets, just keep moving	
			radio_dialogue( "train_cpd_missedsome" );
			flag_set( "can_talk" );	
		}
	}
	/*-----------------------
	SECOND AREA CLEARED/PASSED BY
	-------------------------*/	
	flag_wait_either( "player_course_stairs2", "course_first_floor_targets_dead" );
	if ( flag( "course_first_floor_targets_dead" ) )
	{
		if ( flag( "can_talk" ) )
		{
			//Cpl. Dunn	Up the stairs!	
			flag_clear( "can_talk" );
			radio_dialogue( "train_cpd_upthestairs" );
			flag_set( "can_talk" );	
		}
	}
	/*-----------------------
	UP THE STAIRS
	-------------------------*/	
	flag_wait( "player_course_stairs2" );
	thread melee_nag();

	/*-----------------------
	SECOND FLOOR CLEARED/PASSED BY
	-------------------------*/	
	flag_wait_either( "player_course_jumped_down", "course_second_floor_targets_dead" );
	if ( flag( "course_second_floor_targets_dead" ) )
	{
		if ( flag( "can_talk" ) )
		{
			//Cpl. Dunn	Area cleared! Jump down!	
			flag_clear( "can_talk" );
			radio_dialogue( "train_cpd_jumpdown" );
			flag_set( "can_talk" );	
		}
	}

	/*-----------------------
	LAST AREA
	-------------------------*/	
	flag_wait( "player_course_jumped_down" );
	flag_set( "no_more_course_nags" );
	if ( ( flag( "can_talk" ) ) && ( !flag( "course_end_targets_dead" ) ) )
	{
		//Cpl. Dunn	Last area! Move! Move!	
		flag_clear( "can_talk" );
		radio_dialogue( "train_cpd_lastareamove" );
		flag_set( "can_talk" );	
	}
	
	/*-----------------------
	SPRINT TO FINISH
	-------------------------*/	
	flag_wait( "player_course_end_03" );
	
}

melee_nag()
{
	nagFrequency = 3;
	melee_nag_number = 0;
	while( true )
	{
		if ( flag( "melee_target_hit" ) )
			break;
			
		if ( ( flag( "can_talk" ) ) && ( !flag ( "melee_target_hit" ) ) )
		{
			if ( !flag( "player_near_melee_target" ) )
			{
				wait( .5 );
				continue;
			}
			flag_clear( "can_talk" );
			//Cpl. Dunn  Melee with your knife!	
			radio_dialogue( "melee_nag_0" + melee_nag_number );
			flag_set( "can_talk" );	
			melee_nag_number++;
			if ( melee_nag_number > 4 )
				melee_nag_number = 0;
			flag_wait_or_timeout( "melee_target_hit", nagFrequency );
		}
		else
		{
			wait( .5 );
		}
	}
	
}

dialogue_course_civilian_killed()
{
	level notify( "starting_civilian_nags" );
	level endon( "starting_civilian_nags" );
	
	dialogue = [];
	dialogue[ 0 ] = "train_cpd_watchout"; //Cpl. Dunn		Watch out for civilians.	
	dialogue[ 1 ] = "train_cpd_awwkilled"; //Cpl. Dunn		Aww you killed a civvie. Come on, Allen!	
	dialogue[ 2 ] = "train_cpd_acivilian";	//Cpl. Dunn		That was a civilian, Private.	
	iLine = 0;
	while( !flag( "player_course_jumped_down" ) )
	{
		level waittill( "civilian_killed" );
		if ( flag( "player_course_jumped_down" ) )
			break;
		if( !flag( "player_inside_course" ) )
			break;
		if ( flag( "no_more_course_nags" ) )
			break;
		if ( flag( "can_talk" ) )
		{
			flag_clear( "can_talk" );
			radio_dialogue( dialogue[ iLine ] );
			flag_set( "can_talk" );	
			iLine++;
			if ( iLine > 2 )
				iLine = 0;
			flag_wait_or_timeout( "player_course_jumped_down", 5 );
		}
	}
}

dialogue_course_hurry_up()
{
	level notify( "starting_hurry_nags" );
	level endon( "starting_hurry_nags" );
	
	thread track_player_kill_frequency();
	
	iLine = 0;
	while( !flag( "player_course_jumped_down" ) )
	{
		level waittill( "player_not_killing_targets_at_a_good_rate" );
		if( !flag( "player_inside_course" ) )
			break;
		if ( flag( "no_more_course_nags" ) )
			break;
		if ( flag( "can_talk" ) )
		{
			flag_clear( "can_talk" );
			
			radio_dialogue( "nag_hurry_0" + iLine );
			flag_set( "can_talk" );	
			iLine++;
			if ( iLine > 4 )
				iLine = 0;
			flag_wait_or_timeout( "player_course_jumped_down", 5 );
		}
	}
}

track_player_kill_frequency()
{
	level notify( "track_player_kill_frequency" );
	level endon( "track_player_kill_frequency" );
	
	level endon( "player_course_jumped_down" );
	
	while( !flag( "player_course_jumped_down" ) )
	{
		targetsHit = level.targets_hit;
		level waittill_notify_or_timeout( "target_killed", 8 );
		if ( targetsHit == level.targets_hit )
		{
			//if these values are equal, we timed out waiting for the slow-ass player to hit a target
			level notify( "player_not_killing_targets_at_a_good_rate" );
		}
		wait( 2 );
	}
}

dialogue_course_reload_nag()
{
	level notify( "starting_reload_nags" );
	level endon( "starting_reload_nags" );

	while( true )
	{
		level.player waittill( "reload_start" );
		if( flag( "player_course_jumped_down" ) )
			break;
		if( !flag( "player_inside_course" ) )
			break;
		if ( flag( "no_more_course_nags" ) )
			break;
		if ( ( flag( "can_talk" ) ) && ( player_alt_weapon_has_ammo() ) )
		{
			//Cpl. Dunn	Just switch to your other weapon! It's faster than reloading!
			flag_clear( "can_talk" );
			radio_dialogue( "train_cpd_justswitch" );
			flag_set( "can_talk" );	
			break;
		}
	}
}

dialogue_course_ADS_nag()
{
	level notify( "starting_ADS_nags" );
	level endon( "starting_ADS_nags" );
	iNagnumber = 0;
	while( true )
	{
		level waittill( "pit_target_hit_without_ADS" );
		if( flag( "player_course_jumped_down" ) )
			break;
		if( !flag( "player_inside_course" ) )
			break;
		if ( flag( "no_more_course_nags" ) )
			break;
		if ( flag( "can_talk" ) )
		{
			//Cpl. Dunn     Stop firing from the hip! Aim down your sights!
			//Cpl. Dunn     Aim down your sights, Private!
			//Cpl. Dunn     You need to aim down your sights, Allen!
			flag_clear( "can_talk" );
			radio_dialogue( "pit_ads_nag_0" + iNagnumber );
			flag_set( "can_talk" );	
			iNagnumber++;
			if ( iNagnumber > 2 )
				break;
		}
	}
}


dialogue_nag_start_course( firstTimeThroughCourse )
{
	level endon( "player_has_started_course" );
	level endon( "player_inside_course" );
	if ( !firstTimeThroughCourse )
	{
		firstLoop = false;
	}
	else
	{
		firstLoop = true;
	}
	
	wait( 1 );
	
	flag_wait( "dunn_finished_with_open_case_dialogue" );
	
	while( !flag( "player_inside_course" ) )
	{
		if ( flag( "player_inside_course" ) )
			break;
			
		//Cpl. Dunn	Ok, head on in. Timer starts as soon as the first target pops.	
		level.pitguy dialogue_execute( "train_cpd_timerstarts" );
		
		if ( firstLoop )
		{
			wait( 3 );
			
			//Cpl. Dunn	I don't know why they won't put us in first, Allen.	
			level.pitguy dialogue_execute( "train_cpd_putusin" );
			//Cpl. Dunn	There ain't much the Rangers can't do that SF and Delta can...but...(snorts) whatever man. That's SOCOM brass for ya.	
			level.pitguy dialogue_execute( "train_cpd_socombrass" );
			
			wait( 2 );
			//Cpl. Dunn	And all those frickin' blocking positions. When are we gonna see some real action instead of babysitting Seals and D-boys, huah?	
			level.pitguy dialogue_execute( "train_cpd_realaction" );
			
			//Cpl. Dunn	<sigh, sentiment is 'same shit different day/what else is new > 	
			level.pitguy play_sound_on_entity( "train_cpd_sigh" );
			
			firstLoop = false;
			
			wait( 15 );
		}
		else
		{
			if ( flag( "player_inside_course" ) )
				break;
			wait( 30 );
		}
		
		if ( flag( "player_inside_course" ) )
			break;
		//Cpl. Dunn	Private Allen, we don't have all day. Get in The Pit.	
		level.pitguy dialogue_execute( "train_cpd_donthaveallday" );

		if ( flag( "player_inside_course" ) )
			break;
		wait( 15 );

		if ( flag( "player_inside_course" ) )
			break;
		//Cpl. Dunn	You're gonna get us both in trouble with the Colonel man. Get in The Pit and run the course.	
		level.pitguy dialogue_execute( "train_cpd_bothintrouble" );
		
		if ( flag( "player_inside_course" ) )
			break;
		wait( 60 );
	}
}

door_open( sFlagToWaitFor, bFast )
{
	if ( isdefined( self.moving ) )
	{
		while( isdefined( self.moving ) )
			wait( 0.05 );
	}
	
	self.moving = true;
	angles = 90;
	if ( isdefined( self.openangles ) )
		angles = self.openangles;
	
	//wait for flag if there
	if ( isdefined( sFlagToWaitFor ) )
		flag_wait( sFlagToWaitFor );
	
	iTime = 4;
	if ( isdefined( bFast ) )
	{
		iTime = 1.5;
		self rotateto( self.angles + ( 0, angles, 0 ), 1.5, .25, .25 );
	}
	else
	{
		self rotateto( self.angles + ( 0, angles, 0 ), 4, 1.5, 1.5 );
	}

	
	if( isdefined( self.blocker ) )
		self.blocker hide_entity();
	self thread play_sound_on_entity( "scn_training_fence_open" );
	array_call( self.brushes,::notsolid );
	wait( iTime );
	self.moving = undefined;
}

door_close( sFlagToWaitFor, bFast )
{
	if ( isdefined( self.moving ) )
	{
		while( isdefined( self.moving ) )
			wait( 0.05 );
	}
	
	self.moving = true;
	angles = -90;
	if ( isdefined( self.closeangles ) )
		angles = self.closeangles;
	
	//wait for flag if there
	if ( isdefined( sFlagToWaitFor ) )
		flag_wait( sFlagToWaitFor );

	iTime = 2;
	if ( isdefined( bFast ) )
	{
		iTime = 1;
		self rotateto( self.angles + ( 0, angles, 0 ), 1, .25, .25 );
	}
	else
	{
		self rotateto( self.angles + ( 0, angles, 0 ), 2, .5, .5 );
	}
	
	if( isdefined( self.blocker ) )
			self.blocker show_entity();
	self thread play_sound_on_entity( "scn_training_fence_close" );
	array_call( self.brushes,::solid );
	wait( iTime );
	self.moving = undefined;
}


/****************************************************************************
    CQB PIT COURSE START
****************************************************************************/ 

AA_ending_init()
{
	thread end_sequence();

}


end_sequence()
{
	
	// Regroup with your team

	/*-----------------------
	SETUP ACTORS
	-------------------------*/	
	array = getaiarray();
	guys_to_delete = [];
	foreach ( dude in array )
	{
		if ( !isdefined( dude.script_parameters ) )
			guys_to_delete[ guys_to_delete.size ] = dude;		
			
	}
	drones_to_delete = array_merge( level.drones[ "allies" ].array, level.drones[ "axis" ].array );
	drones_to_delete = array_merge( drones_to_delete, level.drones[ "neutral" ].array );
	foreach( dude in drones_to_delete )
	{
		if ( isdefined( dude.script_parameters ) )
			drones_to_delete = array_remove( drones_to_delete, dude );
	}

	//array_notify( level.aRangeActors, "stop_idle" );
	//array_thread( level.aRangeActors,::anim_stopanimscripted );
	//array_thread( level.aRangeActors,::AI_delete );
	
	array_thread( guys_to_delete,::AI_delete );
	basketball = getent( "basketball", "targetname" );
	basketball delete();
	array_thread( drones_to_delete,::AI_delete );
	


	//spawners = getentarray( "friendlies_end_carrying_guys", "targetname" );
	
	//friendlies_end_carrying_guys = array_spawn( getentarray( "friendlies_end_carrying_guys", "targetname" ), true );
	//friendlies_end_carrying_guys[ 0 ].animname = "carrier";
	//friendlies_end_carrying_guys[ 1 ].animname = "carried";
	//friendlies_end_carrying_guys[ 0 ].dontDoNotetracks = true;
	//friendlies_end_carrying_guys[ 1 ].dontDoNotetracks = true;
	//friendlies_end_carrying_guys[ 0 ].script_looping = 0;
	//friendlies_end_carrying_guys[ 1 ].script_looping = 0;
	//friendlies_end_carrying_guys_anim_ent = spawners[ 0 ];
	//friendlies_end_carrying_guys_anim_ent anim_first_frame( friendlies_end_carrying_guys, "wounded_pickup" );
	//thread friendlies_end_carrying_guys_think( friendlies_end_carrying_guys, friendlies_end_carrying_guys_anim_ent);
	friendlies_end_sequence = array_spawn( getentarray( "friendlies_end_sequence", "targetname" ), true );
	//main_gate_blocker = getent( "main_gate_blocker", "targetname" );
	//main_gate_blocker hide_entity();
	gate_left = getent( "gate_left", "targetname" );
	gate_right = getent( "gate_right", "targetname" );
	gate_left rotateYaw( 90, 0.5 );
	gate_right rotateYaw( -90, 0.5 );
	
	gate_left02 = getent( "gate_left02", "targetname" );
	gate_right02 = getent( "gate_right02", "targetname" );
	gate_left02 rotateYaw( 90, 0.5 );
	gate_right02 rotateYaw( -90, 0.5 );
	
	hummer_end_01 = getent( "hummer_end_01", "targetname" );

	hummer_end_main = getent( "hummer_end_main", "targetname" );
	hummer_actors_main = array_spawn( getentarray( "hummer_actors_main", "targetname" ), true );
	if ( hummer_actors_main[ 0 ].animation == "training_humvee_wounded" )
	{
		hummer_actors_main[ 0 ].animname = "soldier_wounded";
		hummer_actors_main[ 1 ].animname = "soldier_door";
	}
	else
	{
		hummer_actors_main[ 1 ].animname = "soldier_wounded";
		hummer_actors_main[ 0 ].animname = "soldier_door";
	}
	hummer_actors_main[ 0 ] gun_remove();
	hummer_actors_main[ 1 ] gun_remove();
	hummer_end_main.animname = "hummer";
	hummer_end_main assign_animtree();
	hummer_actors_main[ 2 ] = hummer_end_main;
	hummer_actors_main_anim_ent = spawn( "script_origin", ( 0, 0, 0 ) );
	hummer_actors_main_anim_ent.origin = hummer_end_main.origin;
	hummer_actors_main_anim_ent.angles = hummer_end_main.angles;
	hummer_actors_main_anim_ent anim_first_frame( hummer_actors_main, "hummer_sequence" );
	array_call( hummer_actors_main,::hide );
	
	/*-----------------------
	PLAYER LEAVING COURSE
	-------------------------*/	
	flag_wait( "player_exiting_course_00" );
	//thread autosave_now( true );
	level.player enableinvulnerability( true );
	level.gate_cqb_enter_main thread door_close();
	thread sirens();
	thread radio_end();
	heli_group_pre_end = spawn_vehicles_from_targetname_and_drive( "heli_group_pre_end" );
	
	
	flag_wait( "player_exiting_course" );
		
	flag_set( "end_sequence_starting" );
	
	hummer_end_01 show();
	end_blockers = getent( "end_blockers", "targetname" );
	end_blockers show_entity();
	//thread fail_if_friendlies_in_line_of_fire();
	clear_timer_elems();
	clear_hints();
	level notify( "kill_timer" );
	level notify( "clear_course" );
	
	/*-----------------------
	END SEQUENCE
	-------------------------*/	
	thread spawn_vehicles_from_targetname_and_drive( "heli_group_01" );

	flag_wait( "player_exiting_course_02" );
	

		
	thread lerp_player_moverate( 0.1, 1 );
	level.player allowsprint( false );
	setObjectiveState( "obj_course", "done" );
	
	heli_group_end = spawn_vehicles_from_targetname_and_drive( "heli_group_end" );
	hummer_gate = spawn_vehicle_from_targetname_and_drive( "hummer_gate" ); 
	hummer_gate2 = spawn_vehicle_from_targetname_and_drive( "hummer_gate2" ); 
	hummer_gate3 = spawn_vehicle_from_targetname_and_drive( "hummer_gate3" ); 
	array_call( hummer_actors_main,::show );
	hummer_end_01 show_entity();
	hummer_end_main delaythread( 1,::play_sound_in_space, "scn_trainer_humvee_skid1" );
	hummer_end_01 delaythread( 2,::play_sound_in_space, "scn_trainer_humvee_skid2" );
	hummer_gate3 delaythread( 5,::play_sound_in_space, "scn_trainer_humvee_skid3" );
	hummer_actors_main_anim_ent thread anim_single( hummer_actors_main, "hummer_sequence" );
	thread maps\trainer_fx::hummer_steam();
	wait( 10 );
	
	/*-----------------------
	FADE OUT
	-------------------------*/	
	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay fadeOverTime( 1 );
	black_overlay.alpha = 1;
	wait 2;
	nextmission();
}

lerp_player_moverate( desiredRate, transitionTime )
{
	currentMoveRate = 1;
	incrementToDecrease = desiredRate / ( transitionTime / 0.05 );
	
	time = 0;
	while ( time < transitionTime )
	{
		currentMoveRate -= incrementToDecrease;
		if ( currentMoveRate < 0 )
			break;
		level.player SetMoveSpeedScale( currentMoveRate );
		time += .05;
		wait( .05 );
	}

}

sirens()
{
	
	siren_orgs = getentarray( "siren_org", "targetname" );
	
	while ( true )
	{
		foreach( siren in siren_orgs )
		{
			wait( .5 );
			siren playsound ( "emt_alarm_trainer_alert" );
		}
		wait( 3 );
	}

} 

radio_end()
{
	radio_orgs = getentarray( "radio_org_end", "targetname" );	
	
	flag_wait_or_timeout( "player_exiting_course", 1 );
	
	//Overlord (HQ Radio)	training	All Hunter units, get to your victors. We're headed out.	
	thread radio_dialogue( "train_hqr_headedout" );
	
	flag_wait( "player_exiting_course" );
	
	org = getfarthest( level.player.origin, radio_orgs );
	//Ranger 2  They blew the damn bridge! We gotta move!	
	org thread play_sound_in_space( "train_ar2_blewthebridge" );
	
	flag_wait( "player_exiting_course_02" );
	
	//Ranger 1  BCT One is trapped across the river in the red zone! We've lost contact!	
	level.player play_sound_on_entity( "train_ar1_trapped" );
	
	//Sgt. Foley  Everyone get to your vehicles! We're moving out!	
	level.player play_sound_on_entity( "train_fly_movingout" );
	
	org = getfarthest( level.player.origin, radio_orgs );
	//Ranger 2   Get a medic over here!	train_ar2_getamedic
	org play_sound_in_space( "train_ar2_getamedic" );


	


}

friendlies_end_carrying_guys_think( guys, anim_ent )
{
	flag_wait( "player_exiting_course_02" );
	anim_ent anim_single( guys, "wounded_pickup" );
	while( true )
	{
		guys[ 0 ] thread anim_single_solo( guys[ 0 ], "wounded_carry" );
		guys[ 1 ] anim_single_solo( guys[ 1 ], "wounded_carry" );
	}
}

/****************************************************************************
    TARGET LOGIC AND SCORING
****************************************************************************/ 
target_triggers_think()
{

	//self ==> the trigger that makes the targets pop up
	//linkedTargets = getentarray( self.script_LinkTo, "script_Linkname" );
	linkedTargets = self get_linked_ents();
	self.targets = [];
	self.targetsFriendly = [];
	self.targetsEnemy = [];
	foreach( ent in linkedTargets )
	{
		if ( !isdefined( ent.script_noteworthy ) )
			continue;
		if ( ( isdefined( ent.code_classname ) ) && ( ent.code_classname == "script_brushmodel" ) )
		{
			//add this target to the trigger's target array
			self.targets[ self.targets.size ] = ent;
			
			//diffentiate between enemy and civvie targets
			if ( ent.script_noteworthy == "target_enemy" ) 
			{
				self.targetsEnemy[ self.targetsEnemy.size ] = ent;
			}
			else if ( ent.script_noteworthy == "target_friendly" ) 
			{
				self.targetsFriendly[ self.targetsFriendly.size ] = ent;
			}
			else
			{
				assertmsg( "Target at " + ent.origin + " needs a script_noteworthy with either target_enemy or target_friendly." );
			}
			continue;
		}
	}

	/*-----------------------
	ADD TO TOTAL COURSE TARGETS, IF THERE ARE ANY
	-------------------------*/	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "course_triggers_01" ) )
	{
		level.courseFriendlies = array_merge( level.courseFriendlies, self.targetsFriendly );
		level.courseEnemies = array_merge( level.courseEnemies, self.targetsEnemy );
	}
	
	while ( true )
	{
		self trigger_off();
		self waittill( "activate" );
		self trigger_on();
		self waittill( "trigger" );
		array_notify( self.targets, "pop_up" );
	}
}

target_think( targetType )
{
	//self ==> the script brushmodel target

	if ( getdvar( "trainer_debug" ) == "1" )
	{
		self.orgEnt = getEnt( self.target, "targetname" );
		aim_assist_target = getEnt( self.orgEnt.target, "targetname" );
		aim_assist_target hide();
		return;
	}
		
	/*-----------------------
	SETUP BRUSHMODEL TARGET AND ALL ENTITIES
	-------------------------*/	
	self.meleeonly = undefined;
	self.orgEnt = getEnt( self.target, "targetname" );
	//thread debug_message( "orgEnt", undefined, 9999, self.orgEnt );
	assert( isdefined( self.orgEnt ) );
	self linkto ( self.orgEnt );
	aim_assist_target = getEnt( self.orgEnt.target, "targetname" );
	//aim_assist_target linkTo( self );
	aim_assist_target hide();
	aim_assist_target notsolid();
	//thread debug_message( "X", undefined, 9999, aim_assist_target );

	if ( ! isdefined ( self.orgEnt.script_noteworthy ) )
		self.orgEnt.script_noteworthy = "standard";
	if (self.orgEnt.script_noteworthy == "reverse" )
		self.orgEnt rotatePitch( 90, 0.25 );
	else if (self.orgEnt.script_noteworthy == "sideways" )
		self.orgEnt rotateYaw( -180, 0.5 );
	else
		self.orgEnt rotatePitch( -90, 0.25 );

	self.lateralMovementOrgs = undefined;
	self.lateralStartPosition = undefined;
	self.lateralEndPosition = undefined;
	self.restMoveTime = undefined;
	self.lateralMoveTime = undefined;
	
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "penetration_targets" ) )
	{
		level.penetration_targets[ level.penetration_targets.size ] = self;
	}
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "grenade_targets" ) )
	{
		level.grenade_targets[ level.grenade_targets.size ] = self;
	}
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "hip_targets" ) )
	{
		level.hip_targets[ level.hip_targets.size ] = self;
	}

	/*-----------------------
	SETUP LATERALLY MOVING TARGETS
	-------------------------*/	
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "use_rail" ) )
	{
		aim_assist_target linkTo( self );
		self.lateralStartPosition = getclosest( self.orgEnt.origin, level.target_rail_start_points, 10 );
		assertex( isdefined( self.lateralStartPosition ), "Pop up target at " + self.origin + " has its script_parameters set to 'use_rail' but there is no valid rail start org within 10 units ");
		self.lateralEndPosition = getent( self.lateralStartPosition.target, "targetname" );
		assertex( isdefined( self.lateralEndPosition ),  "Pop up target at " + self.origin + " has a rail start position that is not targeting an end rail position" );
		//thread debug_message( "End", undefined, 9999, self.lateralEndPosition );
		//thread debug_message( "Start", undefined, 9999, self.lateralStartPosition );
		self.lateralMovementOrgs = [];
		self.lateralMovementOrgs[ 0 ] = self.lateralStartPosition;
		self.lateralMovementOrgs[ 1 ] = self.lateralEndPosition;
		dist = distance( self.lateralMovementOrgs[ 0 ].origin, self.lateralMovementOrgs[ 1 ].origin );
		self.restMoveTime = ( dist / 30 );
		self.restMoveTime = roundDecimalPlaces( self.restMoveTime, 0 );
		self.lateralMoveTime = ( dist / 22 );
		self.lateralMoveTime = roundDecimalPlaces( self.lateralMoveTime, 0 );
		foreach( org in self.lateralMovementOrgs )
		{
			assertex( org.code_classname == "script_origin", "Pop up targets that move laterally need to be targeting 2 script_origins" );
		}
		self target_lateral_reset_random();
	}
	
	while ( true )
	{
		/*-----------------------
		TARGET POPS UP WHEN TRIGGERED
		-------------------------*/	
		self waittill ( "pop_up" );

		so_player_tooclose_wait();

		if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "melee" ) )
		{
			self.meleeonly = true;
			melee_clip = getent( "melee_clip", "targetname" );
			melee_clip show_entity();
		}
		
		if ( isdefined( self.script_flag ) )
			self thread target_go_back_down_when_flag_is_set( self.script_flag );
		wait randomfloatrange ( 0, .2 );
		
		self solid();
		self playSound( "target_up_metal" );
		self setCanDamage( true );
		if ( targetType != "friendly" )
			aim_assist_target enableAimAssist();
		if ( self.orgEnt.script_noteworthy == "reverse" )
			self.orgEnt rotatePitch( -90, 0.25 );
		else if ( self.orgEnt.script_noteworthy == "sideways" )
			self.orgEnt rotateYaw( 180, 0.5 );
		else
			self.orgEnt rotatePitch( 90, 0.25 );
		
		wait .25;
		
		if ( isdefined( self.lateralStartPosition ) )
		{
			self thread target_lateral_movement();
		}
		
		/*-----------------------
		TARGET IS DAMAGED, OR TOLD TO GO BACK DOWN VIA SCRIPT/FLAGS
		-------------------------*/	
		while ( true )
		{
			self waittill ( "damage", amount, attacker, direction_vec, point, type );
			
			if ( !isdefined( attacker ) )
				continue;
			if ( !isdefined( type ) )
				continue;
			if( type == "MOD_IMPACT" )
				continue;
			if ( type == "scripted_target_drop" )
			{
				//self playSound( "target_up_metal" );

//				if ( is_specialop() )
//				{
//					if ( targetType != "friendly" )
//					{
//						level.missed_targets++;
//						speaker = getclosest( level.player.origin, level.speakers );
//						speaker playSound( "target_mistake_buzzer" );
//						maps\_specialops::info_hud_decrement_timer( level.so_missed_target_deduction );
//					}
//				}

				break; 
			}

			if ( type == "timed_target_drop" )
			{
				// if the targets get proped by timeout in specialops
				speaker = getclosest( level.player.origin, level.speakers );
				speaker playSound( "target_mistake_buzzer" );

//				if ( is_specialop() )
//				{
//					if ( targetType != "friendly" )
//					{
//						level.missed_targets++;
//						maps\_specialops::info_hud_decrement_timer( level.so_missed_target_deduction );
//					}
//				}

				break; 
			}
			
			if ( isplayer( attacker ) )
			{
				if ( isdefined( self.meleeonly ) ) 
				{
					if ( type != "MOD_MELEE" )
						continue;
				}

				// makes targets take more hits to put down.
				// MikeD 7/10: It's not intuitive to the enduser to keep this
//				if ( is_specialop() && level.gameSkill == 3 )
//				{
//					assert( isdefined( level.target_fall_health ) );
//					if ( self.health > level.target_fall_health )
//						continue;
//				}

				self playSound( "target_metal_hit" );
				if ( targetType == "friendly" )
				{
					speaker = getclosest( level.player.origin, level.speakers );
					speaker playSound( "target_mistake_buzzer" );

					if ( isdefined( attacker.friendlies_hit ) )
					{
						attacker.friendlies_hit++;
					}

					level.friendlies_hit++;
					if ( !is_specialop() )
					{
						if ( isdefined( level.HUDcivviesKilled ) )
						{
							level.HUDcivviesKilled setValue ( level.friendlies_hit );
							level.HUDcivviesKilled.color = level.color[ "red" ];
						}
					}
					level notify( "civilian_killed" );
				}
				else
				{
					attacker maps\_player_stats::register_kill( self, type );

					if ( isdefined( attacker.targets_hit ) )
					{
						attacker.targets_hit++;
					}

					level.targets_hit++;
					if ( type == "MOD_MELEE" )
					{
						level.targets_hit_with_melee++;
					}
					
					level notify( "target_killed" );
					if ( !is_specialop() )
					{
						if ( isdefined( level.HUDenemiesKilled ) )
						{
							level.HUDenemiesKilled setValue ( level.targets_hit );
						}
					}
				}
				
				if ( type == "MOD_GRENADE_SPLASH" )
				{
					self notify( "hit_with_grenade" );
				}
				break; 
			}
		}
		
		/*-----------------------
		TARGET OUT OF PLAY TILL TOLD TO POP UP AGAIN
		-------------------------*/		
		if ( isdefined( self.meleeonly ) ) 
		{
			self.meleeonly = true;
			melee_clip = getent( "melee_clip", "targetname" );
			melee_clip thread hide_entity();
			flag_set( "melee_target_hit" );
		}
		
		else if ( ( targetType != "friendly" ) && ( !level.player isADS() ) )
		{
			if ( ( isdefined( type ) ) && ( type != "MOD_MELEE" ) && ( type != "scripted_target_drop" ) )
				level notify( "pit_target_hit_without_ADS" );
		}
		
		self notify ( "hit" );
		self notify ( "target_going_back_down" );
		self.health = 1000;
		aim_assist_target disableAimAssist();
		self notsolid();
		//wait( 0.05 );
		if (self.orgEnt.script_noteworthy == "reverse" )
			self.orgEnt rotatePitch( 90, 0.25 );
		else if (self.orgEnt.script_noteworthy == "sideways" )
			self.orgEnt rotateYaw( -180, 0.5 );
		else
			self.orgEnt rotatePitch( -90, 0.25 );
		self setCanDamage( false );
		wait .25;

	}
}

so_player_tooclose_wait()
{
	if ( !is_specialop() )
	{
		return;
	}

	origin = self.origin;

	y_check = undefined;
	if ( IsDefined( self.script_parameters ) && self.script_parameters == "melee" )
	{
		origin = ( -5723, 2547, -49 ); // Just under the melee target
		y_check = 2520;
	}

	while ( 1 )
	{
		close = false;
		foreach ( player in level.players )
		{
			dist_test = 56 * 56;
			if ( Length( player GetVelocity() ) > 200 )
			{
				dist_test = 128 * 128;
			}

			if ( DistanceSquared( player.origin, origin ) < dist_test )
			{
				close = true;

				if ( IsDefined( y_check ) && player.origin[ 1 ] < y_check )
				{
					close = false;
				}
			}
		}

		if ( !close )
		{
			return;
		}

		wait( 0.05 );
	}
}

target_lateral_movement()
{
	dummy = spawn( "script_origin", ( 0, 0, 0 ) );
	dummy.angles = self.orgEnt.angles;
	dummy.origin = self.orgEnt.origin;
	self.orgEnt thread lateral_dummy_move( dummy );
	
	dummy endon( "deleted_because_player_was_too_close" );
	dummy endon( "death" );
	foreach( player in level.players )
	{
		dummy thread delete_when_player_too_close( player );
	}

	self thread dummy_delete_when_target_goes_back_down( dummy );
	
	while ( true )
	{
		dummy moveTo( self.lateralEndPosition.origin, self.lateralMoveTime );
		wait( self.lateralMoveTime );
		dummy moveTo( self.lateralStartPosition.origin, self.lateralMoveTime );
		wait( self.lateralMoveTime );
	}


}

dummy_delete_when_target_goes_back_down( dummy )
{
	dummy endon( "death" );
	//self --> the target
	self waittill( "target_going_back_down" );
	dummy delete();
}

delete_when_player_too_close( player )
{
	//want to stop lateral movement if player is too close to avoid getting stuck
	self endon( "death" );
	dist = 128;
	distSquared = dist * dist;
	while( true )
	{
		wait( .05 );
		if ( distancesquared( player.origin, self.origin ) < distSquared )
			break;
	}
	self notify( "deleted_because_player_was_too_close" );
	self delete();
}

lateral_dummy_move( dummy )
{
	dummy endon( "death" );
	while( true )
	{
		wait( 0.05 );
		self.origin = dummy.origin;
	}
}

target_lateral_reset_random()
{	
	if ( cointoss() )
	{
		self.lateralStartPosition = self.lateralMovementOrgs[ 0 ];
		self.lateralEndPosition = self.lateralMovementOrgs[ 1 ];
	}
	else
	{
		self.lateralStartPosition = self.lateralMovementOrgs[ 1 ];
		self.lateralEndPosition = self.lateralMovementOrgs[ 0 ];
	}

	self.orgEnt moveTo( self.lateralStartPosition.origin, .1 );

}

target_go_back_down_when_flag_is_set( sFlag )
{
	if ( is_specialop() )
	{
		return;
	}

	/*-----------------------
	TARGET GOES BACK DOWN PREMATURELY IF FLAG IS SET
	-------------------------*/	
	self endon ( "target_going_back_down" );
	flag_wait( sFlag );
	self target_reset_manual();
	
}

target_reset_manual()
{
	self notify( "damage", 1000, "worldspawn", undefined, undefined, "scripted_target_drop" );
}


/****************************************************************************
    UTILITY
****************************************************************************/ 
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



//ammoRespawnThink( flag, type, obj_flag )
//{
//	wait .2; //timing 
//	weapon = self;
//	ammoItemClass = weapon.classname;
//	ammoItemOrigin = ( weapon.origin + (0,0,8) ); //wont spawn if inside something
//	ammoItemAngles = weapon.angles;
//	weapon set_ammo();
//	
//	if ( type == "flash_grenade" )
//		ammo_fraction_required = 1;
//	else 
//		ammo_fraction_required = .2;
//		
//	if ( isdefined ( flag ) )
//	{
//		//self delete();
//		weapon.origin = weapon.origin + (0, 0, -10000);
//
//		flag_wait ( flag );
//	
//		weapon.origin = weapon.origin + (0, 0, 10000);
//		weapon glow();
//		weapon set_ammo();
//	}
//	
//	weapon waittill ( "trigger" );
//	
//	//weapon stopGlow();
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

set_ammo()
{
	if ( (self.classname == "weapon_fraggrenade") || (self.classname == "weapon_flash_grenade") )
		self ItemWeaponSetAmmo( 1, 0 );
	else
		self ItemWeaponSetAmmo( 999, 999 );
}

init_precache()
{
	precacheModel( "weapon_binocular" );
	precachemodel( "mil_grenade_box_opened" );
	precachemodel( "adrenaline_syringe_animated" );
	precachemodel( "clotting_powder_animated" );
	precacheModel( "com_bottle2" );
	precacheModel( "viewmodel_desert_eagle" );
	precacheshader( "black" );
	precacheModel( "weapon_m67_grenade_obj" );
	precacheModel( "prop_price_cigar" );
	PreCacheModel( "electronics_pda" );
	precacheModel( "weapon_m4" );
	precacheModel( "weapon_m4_clip" );
	precacheModel( "characters_accessories_pencil" );
	precacheModel( "mil_mre_chocolate01" );
	precacheModel( "weapon_desert_eagle_tactical_obj" );
	precacheModel( "weapon_m4_obj" );
	//precacheModel( "weapon_m4_obj" );
	precacheShader( "objective" );
	precacheShader( "hud_icon_c4" );
	precacheShader( "hud_dpad" );
	precacheShader( "hud_arrow_right" );
	precacheShader( "hud_arrow_down" );
	precacheShader( "hud_icon_40mm_grenade" );
	precacheshader( "popmenu_bg" );
	
	precacheString( &"TRAINER_OBJ_GET_RIFLE_AMMO" );
	precacheString( &"TRAINER_KILLED_CIVVIES_PENALTY" );
	precacheString( &"TRAINER_TRY_SPRINT_AGAIN" );
	precacheString( &"TRAINER_KILLED_CIVVIES_NONE" );
	precacheString( &"TRAINER_ACCURACY_LABEL" );
	
	precacheString( &"TRAINER_MISSION_FAIL_FIRE_IN_CAMP" );
	precacheString( &"TRAINER_SHOOT_THE_TARGET_THROUGH" );
	
	// Press ^3[{weaponslot primaryb}]^7 to switch to your sidearm.
	precacheString( &"TRAINER_HINT_SIDEARM" );
	// The Objective Indicator is on the \nbottom of your screen in the middle.
	precacheString( &"TRAINER_HINT_OBJECTIVE_MARKER" );
	// When the yellow circle is in the middle of\nthe compass, you are facing your objective.
	precacheString( &"TRAINER_HINT_OBJECTIVE_REMINDER" );
	// Turn until the yellow circle in your compass tape\nlines up with the white ticks and head in that direction\nto locate your current objective.
	precacheString( &"TRAINER_HINT_OBJECTIVE_REMINDER2" );
	// You don't have to hold ^3[{+sprint}]^7 to continue sprinting.
	precacheString( &"TRAINER_HINT_HOLDING_SPRINT" );
	// Reverse your controls for looking up and down?
	precacheString( &"TRAINER_AXIS_OPTION_MENU1_ALL" );
	// Keep your controls like this?
	precacheString( &"TRAINER_AXIS_OPTION_MENU2_ALL" );

	if ( level.console )
		precacheMenu( "invert_axis" );
	else
		precacheMenu( "invert_axis_pc" );

	precacheMenu( "select_difficulty" );
	
	// The Objective Indicator is on the \nbottom of your screen in the middle.
	precachestring( &"TRAINER_HINT_OBJECTIVE_MARKER" );
	// Press ^3[{pause}]^7 to check your objectives.
	precachestring( &"TRAINER_HINT_CHECK_OBJECTIVES_PAUSED" );
	// Press ^3[{+scores}]^7 to check your objectives.
	precachestring( &"TRAINER_HINT_CHECK_OBJECTIVES_SCORES" );
	// Press the START button to check your objectives.
	precachestring( &"TRAINER_HINT_CHECK_OBJECTIVES_SCORES_PS3" );
	// The Objective Indicator is on the \nbottom of your screen in the middle.
	precachestring( &"TRAINER_HINT_OBJECTIVE_MARKER" );
	// When the yellow circle is in the middle of\nthe compass, you are facing your objective.
	precachestring( &"TRAINER_HINT_OBJECTIVE_REMINDER" );
	// Turn until the yellow circle in your compass tape\nlines up with the white ticks and head in that direction\nto locate your current objective.
	precachestring( &"TRAINER_HINT_OBJECTIVE_REMINDER2" );
	// Press ^3[{+attack}]^7 to fire your weapon.
	precachestring( &"TRAINER_HINT_ATTACK_PC" );
	// Pull ^3[{+attack}]^7 to fire your weapon.
	precachestring( &"TRAINER_HINT_ATTACK" );
	// Press ^3[{+attack}]^7 to fire from the hip.
	precachestring( &"TRAINER_HINT_HIP_ATTACK_PC" );
	// Pull ^3[{+attack}]^7 to fire from the hip.
	precachestring( &"TRAINER_HINT_HIP_ATTACK" );
	// Pull and hold ^3[{+speed}]^7 to aim down the sights of your weapon.
	precachestring( &"TRAINER_HINT_ADS_360" );
	// Press and hold ^3[{+speed}]^7 to aim down the sights of your weapon.
	precachestring( &"TRAINER_HINT_ADS" );
	// Press ^3[{toggleads}]^7 to aim down the sight.
	precachestring( &"TRAINER_HINT_ADS_TOGGLE" );
	// Pull and hold ^3[{+speed_throw}]^7 to aim down the sights of your weapon.
	precachestring( &"TRAINER_HINT_ADS_THROW_360" );
	// Press and hold ^3[{+speed_throw}]^7 to aim down the sights of your weapon.
	precachestring( &"TRAINER_HINT_ADS_THROW" );
	// Press ^3[{+toggleads_throw}]^7 to aim down the sights of your weapon.
	precachestring( &"TRAINER_HINT_ADS_TOGGLE_THROW" );
	// Hit the targets while firing from the hip.\nRelease ^3[{+speed}]^7 to stop aiming down your sight.
	precachestring( &"TRAINER_HINT_STOP_ADS" );
	// Hit the targets while firing from the hip.\nPress ^3[{toggleads}]^7 to stop aiming down your sight.
	precachestring( &"TRAINER_HINT_STOP_ADS_TOGGLE" );
	// Hit the targets while firing from the hip.\nRelease ^3[{+speed_throw}]^7 to stop aiming down your sight.
	precachestring( &"TRAINER_HINT_STOP_ADS_THROW" );
	// Hit the targets while firing from the hip.\nPress ^3[{+toggleads_throw}]^7 to stop aiming down your sight.
	precachestring( &"TRAINER_HINT_STOP_ADS_TOGGLE_THROW" );
	// Press and hold ^3[{+melee_breath}]^7 to steady your breathing.
	precachestring( &"TRAINER_HINT_BREATH_MELEE" );
	// Press and hold ^3[{+breath_sprint}]^7 to steady your breathing.
	precachestring( &"TRAINER_HINT_BREATH_SPRINT" );
	// Press and hold ^3[{+breath_binoculars}]^7 to steady your breathing.
	precachestring( &"TRAINER_HINT_BREATH_BINOCULARS" );
	// Press ^3[{+breath_binoculars}]^7 near the melon to strike it with your weapon.
	precachestring( &"TRAINER_HINT_MELEE_BREATH" );
	// Press ^3[{+melee}]^7 near the melon to strike it with your weapon.
	precachestring( &"TRAINER_HINT_MELEE" );
	// Click ^3[{+breath_binoculars}]^7 near the melon to strike it with your weapon.
	precachestring( &"TRAINER_HINT_MELEE_BREATH_CLICK" );
	// Click ^3[{+melee}]^7 near the melon to strike it with your weapon.
	precachestring( &"TRAINER_HINT_MELEE_CLICK" );
	// Press ^3[{goprone}]^7 to go prone.
	precachestring( &"TRAINER_HINT_PRONE" );
	// Press and hold ^3[{+prone}]^7 to go prone.
	precachestring( &"TRAINER_HINT_PRONE_HOLD" );
	// Press ^3[{toggleprone}]^7 to go prone.
	precachestring( &"TRAINER_HINT_PRONE_TOGGLE" );
	// Press and hold down ^3[{+stance}]^7 to go prone.
	precachestring( &"TRAINER_HINT_PRONE_STANCE" );
	// Double tap ^3[{lowerstacnce}]^7 to go prone.
	precachestring( &"TRAINER_HINT_PRONE_DOUBLE" );
	// Press ^3[{+stance}]^7 to crouch.
	precachestring( &"TRAINER_HINT_CROUCH_STANCE" );
	// Press ^3[{gocrouch}]^7 to crouch.
	precachestring( &"TRAINER_HINT_CROUCH_HOLD" );
	precachestring( &"TRAINER_HINT_CROUCH" );
	// Press ^3[{togglecrouch}]^7 to crouch.
	precachestring( &"TRAINER_HINT_CROUCH_TOGGLE" );
	// Press ^3[{+gostand}]^7 to stand up.
	precachestring( &"TRAINER_HINT_STAND" );
	// Press ^3[{+stance}]^7 to stand up.
	precachestring( &"TRAINER_HINT_STAND_STANCE" );
	// While standing, press ^3[{+gostand}]^7 to jump.
	precachestring( &"TRAINER_HINT_JUMP_STAND" );
	// While standing, press ^3[{+moveup}]^7 to jump.
	precachestring( &"TRAINER_HINT_JUMP" );
	// Press ^3[{+sprint}]^7 while moving forward to sprint.
	precachestring( &"TRAINER_HINT_SPRINT_PC" );
	// Click ^3[{+sprint}]^7 while moving forward to sprint.
	precachestring( &"TRAINER_HINT_SPRINT" );
	// Press ^3[{+breath_sprint}]^7 while moving forward to sprint.
	precachestring( &"TRAINER_HINT_SPRINT_BREATH_PC" );
	// Click ^3[{+breath_sprint}]^7 while moving forward to sprint.
	precachestring( &"TRAINER_HINT_SPRINT_BREATH" );
	// You don't have to hold ^3[{+sprint}]^7 to continue sprinting.
	precachestring( &"TRAINER_HINT_HOLDING_SPRINT" );
	// You don't have to hold ^3[{+breath_sprint}]^7 to continue sprinting.
	precachestring( &"TRAINER_HINT_HOLDING_SPRINT_BREATH" );
	// Press ^3[{+usereload}]^7 to reload your weapon.
	precachestring( &"TRAINER_HINT_RELOAD_USE" );
	// Press ^3[{+reload}]^7 to reload your weapon.
	precachestring( &"TRAINER_HINT_RELOAD" );
	// Touch the obstacle and press ^3[{+gostand}]^7 to mantle over it.
	precachestring( &"TRAINER_HINT_MANTLE" );
	// Release and pull ^3[{+speed}]^7 to automatically\nswitch to a nearby target.
	precachestring( &"TRAINER_HINT_ADS_SWITCH" );
	// Release then press and hold ^3[{+speed}]^7 to\nquickly switch to a nearby target.
	precachestring( &"TRAINER_HINT_ADS_SWITCH_SHOULDER" );
	// Release and pull ^3[{+speed_throw}]^7 to automatically\nswitch to a nearby target.
	precachestring( &"TRAINER_HINT_ADS_SWITCH_THROW" );
	// Release then press and hold ^3[{+speed_throw}]^7 to\nquickly switch to a nearby target.
	precachestring( &"TRAINER_HINT_ADS_SWITCH_THROW_SHOULDER" );
	// Press ^3[{weapnext}]^7 to switch to your sidearm.
	precachestring( &"TRAINER_HINT_SIDEARM_SWAP" );
	// Press ^3[{weapnext}]^7 to switch to your primary weapon.
	precachestring( &"TRAINER_HINT_PRIMARY_SWAP" );
	// Press ^3[{weaponslot primaryb}]^7 to switch to your sidearm.
	precachestring( &"TRAINER_HINT_SIDEARM" );
	// Press ^3[{+reload}]^7 to load your sidearm.
	precachestring( &"TRAINER_HINT_SIDEARM_RELOAD" );
	// Press ^3[{+usereload}]^7 to load your sidearm.
	precachestring( &"TRAINER_HINT_SIDEARM_RELOAD_USE" );
	// Press ^3[{+frag}]^7 to throw a frag grenade.
	precachestring( &"TRAINER_HINT_FRAG" );
	// Notice that your crosshair expands as you fire.\nThe bigger the crosshairs, the less accurate you are.
	precachestring( &"TRAINER_HINT_CROSSHAIR_CHANGES" );
	
	
	precachestring( &"TRAINER_HINT_TURN_AROUND" );
	
	// Firing from the hip is never as\naccurate as aiming down your sight.
	precachestring( &"TRAINER_HINT_ADS_ACCURACY" );
	
	// You were too slow.
	precachestring( &"TRAINER_SHIP_TOO_SLOW" );
	
	precachestring( &"TRAINER_CIVVIES_KILLED" );
	precachestring( &"TRAINER_ENEMIES_KILLED" );
	precachestring( &"TRAINER_YOUR_TIME_IN_SECONDS" );
	
	// Your time: 
	precachestring( &"TRAINER_YOUR_TIME" );
	// Your final time: 
	precachestring( &"TRAINER_YOUR_FINAL_TIME" );
	// IW best time:     
	precachestring( &"TRAINER_IW_BEST_TIME" );
	// Your deck time: 
	precachestring( &"TRAINER_YOUR_DECK_TIME" );
	// IW deck time: 
	precachestring( &"TRAINER_IW_DECK_TIME" );
	// You don't have enough flashes to finish.
	precachestring( &"TRAINER_SHIP_OUT_OF_FLASH" );
	// You jumped too early.
	precachestring( &"TRAINER_SHIP_JUMPED_TOO_EARLY" );
	// You hit a friendly target.
	precachestring( &"TRAINER_HIT_FRIENDLY" );
	// Press ^3[{+smoke}]^7 to throw a flash bang.
	precachestring( &"TRAINER_HINT_FLASH" );
	
	precachestring( &"TRAINER_MISSED_ENEMY_PENALTY_NONE" );
	precachestring( &"TRAINER_MISSED_ENEMY_PENALTY" );
	
	// Accuracy bonus:+
	precachestring( &"TRAINER_ACCURACY_BONUS" );
	// Cargoship Bridge
	precachestring( &"TRAINER_SHIP_LABEL" );
	// Cargoship Deck
	precachestring( &"TRAINER_DECK_LABEL" );
	
	
	precachestring( &"TRAINER_ACCURACY_NA" );
	
	// Accuracy bonus:+0.0
	precachestring( &"TRAINER_ACCURACY_BONUS_ZERO" );

	// You must aim above your target with grenades.
	precachestring( &"TRAINER_HINT_GRENADE_TOO_LOW" );
	// You must aim above your target with grenade launchers.
	precachestring( &"TRAINER_HINT_GL_TOO_LOW" );
	// Reverse your controls
	precachestring( &"TRAINER_AXIS_OPTION_MENU1" );
	// Switch your controls
	precachestring( &"TRAINER_AXIS_OPTION_MENU2" );
	// for looking up and down?
	precachestring( &"TRAINER_AXIS_OPTION_MENU1B" );
	// back to how they were?
	precachestring( &"TRAINER_AXIS_OPTION_MENU2B" );
	// 
	precachestring( &"TRAINER_AXIS_OPTION_YES" );
	// 
	precachestring( &"TRAINER_AXIS_OPTION_NO" );
	// Reverse your controls for looking up and down?
	precachestring( &"TRAINER_AXIS_OPTION_MENU1_ALL" );
	// Keep your controls like this?
	precachestring( &"TRAINER_AXIS_OPTION_MENU2_ALL" );
	// Look up.
	precachestring( &"TRAINER_LOOK_UP" );
	// Look down.
	precachestring( &"TRAINER_LOOK_DOWN" );
	// Notice you now have an icon of a grenade launcher on your display.
	precachestring( &"TRAINER_HINT_LAUNCHER_ICON" );
	// You endangered a team mate.
	precachestring( &"TRAINER_FIRED_NEAR_FRIENDLY" );
	// Use your Objective Indicator to find the firing range.
	precachestring( &"TRAINER_USE_YOUR_OBJECTIVE_INDICATOR" );
	// Pick up a rifle from the table.
	precachestring( &"TRAINER_PICK_UP_A_RIFLE_FROM" );
	// Get a pistol from the same place you got the rifle.
	precachestring( &"TRAINER_GET_A_PISTOL_FROM_THE" );
	// Melee the watermelon with your knife.
	precachestring( &"TRAINER_MELEE_THE_WATERMELON" );
	// Go outside and report to Sgt. Newcastle.
	precachestring( &"TRAINER_GO_OUTSIDE_AND_REPORT" );
	// Pick up the rifle with the grenade launcher attachment.
	precachestring( &"TRAINER_PICK_UP_THE_RIFLE_WITH" );
	// Pick up the C4 explosive.
	precachestring( &"TRAINER_PICK_UP_THE_C4_EXPLOSIVE" );
	// Run the obstacle course.
	precachestring( &"TRAINER_RUN_THE_OBSTACLE_COURSE" );
	// Use your objective indicator to locate The Pit.
	precachestring( &"OBJ_GO_TO_THE_PIT" );
	// Climb the ladder.
	precachestring( &"TRAINER_CLIMB_THE_LADDER" );
	
	precachestring( &"TRAINER_OBJ_EXIT_THE_PIT" );
	
	
	// Debrief with Captain Price.
	precachestring( &"TRAINER_DEBRIEF_WITH_CPT_PRICE" );
	// Enter station number 1 and aim down your sights.
	precachestring( &"TRAINER_ENTER_STATION_NUMBER" );
	// Shoot each target while aiming down your sights.
	precachestring( &"TRAINER_SHOOT_EACH_TARGET_WHILE" );
	// Shoot each target while firing from the hip.
	precachestring( &"TRAINER_SHOOT_EACH_TARGET_WHILE1" );
	// Shoot each target as quickly as possible.
	precachestring( &"TRAINER_SHOOT_EACH_TARGET_AS" );
	// Equip the MP5 and pick up 4 flashbangs.
	precachestring( &"TRAINER_EQUIP_THE_MP5_AND_PICK" );
	// Clear the cargoship bridge mock-up.
	precachestring( &"TRAINER_CLEAR_THE_CARGOSHIP_BRIDGE" );
	// Switch to your rifle and then back to your pistol.
	precachestring( &"TRAINER_SWITCH_TO_YOUR_RIFLE" );
	// Pick up the frag grenades.
	precachestring( &"TRAINER_PICK_UP_THE_FRAG_GRENADES" );
	// Enter the safety pit.
	precachestring( &"TRAINER_ENTER_THE_SAFETY_PIT" );
	// Throw a grenade into windows two, three and four.
	precachestring( &"TRAINER_THROW_A_GRENADE_INTO" );
	// Return to the safety pit and equip the grenade launcher.
	precachestring( &"TRAINER_RETURN_TO_THE_SAFETY" );
	// Fire at the wall with the number one on it.
	precachestring( &"TRAINER_FIRE_AT_THE_WALL_WITH" );
	// Plant the C4 explosive at the glowing spot.
	precachestring( &"TRAINER_PLANT_THE_C4_EXPLOSIVE" );
	// Fire your grenade launcher into windows five, six and seven.
	precachestring( &"TRAINER_FIRE_YOUR_GRENADE_LAUNCHER" );
	// Climb the ladder.
	precachestring( &"TRAINER_CLIMB_THE_LADDER1" );
	// Shoot a target through the wood.
	precachestring( &"TRAINER_SHOOT_A_TARGET_THROUGH" );

	// Slide down the rope.\n
	precachestring( &"TRAINER_SLIDE_DOWN_THE_ROPE" );
	// Complete the deck mock-up.
	precachestring( &"TRAINER_COMPLETE_THE_DECK_MOCKUP" );

	// Recommended
	precachestring( &"TRAINER_RECOMMENDED_LABEL" );
	// difficulty:
	precachestring( &"TRAINER_RECOMMENDED_LABEL2" );
	// Recruit
	precachestring( &"TRAINER_RECOMMENDED_EASY" );
	// Regular
	precachestring( &"TRAINER_RECOMMENDED_NORMAL" );
	// Hardened
	precachestring( &"TRAINER_RECOMMENDED_HARD" );
	// Veteran
	precachestring( &"TRAINER_RECOMMENDED_VETERAN" );
	
	precachestring( &"TRAINER_RECOMMENDED_TRY_AGAIN" );

}

dialogue_execute( sLineToExecute, sFlagToSetWhenDone )
{
	if ( !isdefined( self ) )
		return;
	self endon( "death" );
	self dialogue_queue( sLineToExecute );
	if ( isdefined( sFlagToSetWhenDone ) )
		flag_set( sFlagToSetWhenDone );

}


hint_temp( string, timeOut )
{
	hintfade = 0.5;

	level endon( "clearing_hints" );

	if ( isDefined( level.tempHint ) )
		level.tempHint destroyElem();

	level.tempHint = createFontString( "default", 1.5 );
	level.tempHint setPoint( "BOTTOM", undefined, 0, -60 );
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

registerObjective( objName, objText, objEntity )
{
	flag_init( objName );
	objID = level.objectives.size;

	newObjective = spawnStruct();
	newObjective.name = objName;
	newObjective.id = objID;
	newObjective.state = "invisible";
	newObjective.text = objText;
	newObjective.entity = objEntity;
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
		objective_add( objective.id, objective.state, objective.text, objective.entity.origin );
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

	objective_position( objective.id, objective.loc.origin );
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


keyHint( actionName, timeOut, doubleline, alwaysDisplay )
{
	clear_hints();
	level endon ( "clearing_hints" );

	if ( isdefined ( doubleline ) )
		add_hint_background( doubleline );
	else
		add_hint_background();
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	actionBind = getActionBind( actionName );
	if ( ( actionName == "melee" ) && ( level.xenon ) && ( actionBind.key == "BUTTON_RSTICK" ) )
		level.hintElem setText( &"TRAINER_HINT_MELEE_CLICK" );
	else
		level.hintElem setText( actionBind.hint );
	//level.hintElem endon ( "death" );
	
	if ( !isdefined( alwaysDisplay ) )
	{
		notifyName = "did_action_" + actionName;
		for ( index = 0; index < level.actionBinds[actionName].size; index++ )
		{
			actionBind = level.actionBinds[actionName][index];
			notifyOnCommand( notifyName, actionBind.binding );
		}
	
		if ( isDefined( timeOut ) )
			level.player thread notifyOnTimeout( notifyName, timeOut );
		level.player waittill( notifyName );
	
		level.hintElem fadeOverTime( 0.5 );
		level.hintElem.alpha = 0;
		wait ( 0.5 );
	
		clear_hints();
	}

}


clear_hints_on_flag( msg )
{
	level endon ( "clearing_hints" );
	flag_wait ( msg );
	clear_hints();
}

generic_compass_hint_reminder( msg, time )
{
	thread clear_hints_on_flag( msg );
	level endon ( msg );
	wait time;
	
	compass_hint();
	
	wait 2;
	
	timePassed = 6;
	for ( ;; )
	{
		if ( timePassed > 20.0 )
		{
			thread compass_reminder();
			RefreshHudCompass();
			timePassed = 0;
		}
		timePassed += 0.05;
		wait ( 0.05 );
	}
}

objective_hints( completion_flag )
{
	level endon ( "mission failed" );
	level endon ( "navigationTraining_end" );
	level endon ( "obj_go_to_the_pit_done" );
	
	//wait( 2 );
	//compass_hint();
	
	wait ( 20 );
	
	if ( level.Console )
	{
		if ( level.Xenon )
			keyHint( "objectives", 6.0);
		else
			killhouse_hint( &"TRAINER_HINT_CHECK_OBJECTIVES_SCORES_PS3", 6 ); 
	}
	else
	{ 
		keyHint( "objectives_pc", 6.0);
	}
	
	//level.marine1.lastNagTime = getTime();
	timePassed = 0;
	for ( ;; )
	{
		//if( distance( level.player.origin, level.marine1.origin ) < 512 )
		//	level.marine1 nagPlayer( "squadwaiting", 15.0 );

		if ( !flag( completion_flag ) && timePassed > 20.0 )
		{
			//killhouse_hint( &"TRAINER_HINT_OBJECTIVE_REMINDER", 6.0 );
			thread compass_reminder();
			RefreshHudCompass();
			//wait( 0.5 );
			//thread killhouse_hint( &"TRAINER_HINT_OBJECTIVE_REMINDER2", 10.0 );
			timePassed = 0;
		}

		timePassed += 0.05;
		wait ( 0.05 );
	}
}

add_hint_background( double_line )
{
	if ( isdefined ( double_line ) )
		level.hintbackground = createIcon( "popmenu_bg", 650, 50 );
	else
		level.hintbackground = createIcon( "popmenu_bg", 650, 30 );
	level.hintbackground.hidewheninmenu = true;
	level.hintbackground setPoint( "TOP", undefined, 0, 105 );
	level.hintbackground.alpha = .5;
	level.hintbackground.sort = 0;
}

//compass_hint_old( text, timeOut )
//{
//	clear_hints();
//	level endon ( "clearing_hints" );
//
//	double_line = true;
//	add_hint_background( double_line );
//	level.hintElem = createFontString( "objective", level.hint_text_size );
//	level.hintElem.hidewheninmenu = true;
//	level.hintElem setPoint( "TOP", undefined, 0, 110 );
//	level.hintElem.sort = 0.5;
//
//	level.hintElem setText( &"TRAINER_HINT_OBJECTIVE_MARKER" );
//
//	level.iconElem = createIcon( "objective", 32, 32 );
//	level.iconElem.hidewheninmenu = true;
//	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
//	level.iconElem setPoint( "TOP", undefined, 0, 155 );
//
//	wait 5;
//
//	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
//	
//	level.iconElem scaleovertime(1, 20, 20);
//	
//	wait .85;
//	level.iconElem fadeovertime(.15);
//	level.iconElem.alpha = 0;
//	
//	wait .5;
//	level.hintElem fadeovertime(.5);
//	level.hintElem.alpha = 0;
//	
//	clear_hints();
//}

//compass_reminder_old()
//{	
//	clear_hints();
//	level endon ( "clearing_hints" );
//
//	double_line = true;
//	add_hint_background( double_line );
//	level.hintElem = createFontString( "objective", level.hint_text_size );
//	level.hintElem.hidewheninmenu = true;
//	level.hintElem setPoint( "TOP", undefined, 0, 110 );
//	level.hintElem.sort = 0.5;
//
//	level.hintElem setText( &"TRAINER_HINT_OBJECTIVE_REMINDER" );
//
//
//	level.iconElem = createIcon( "objective", 32, 32 );
//	level.iconElem.hidewheninmenu = true;
//	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
//	level.iconElem setPoint( "TOP", undefined, 0, 155 );
//
//	wait 5;
//	//setObjectiveLocation( "obj_enter_range", getEnt( "rifle_range_obj", "targetname" )  );
//
//	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
//	
//	level.iconElem scaleovertime(1, 20, 20);
//	
//	wait .85;
//	level.iconElem fadeovertime(.15);
//	level.iconElem.alpha = 0;
//	
//	wait 2;
//	level.hintElem fadeovertime(.5);
//	level.hintElem.alpha = 0;
//	
//	clear_hints();
//}
compass_hint( text, timeOut )
{
	clear_hints();
	level endon ( "clearing_hints" );

	double_line = true;
	add_hint_background( double_line );
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( &"TRAINER_HINT_OBJECTIVE_MARKER" );

//	level.iconElem = createIcon( "objective", 32, 32 );
//	level.iconElem.hidewheninmenu = true;
//	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
//	level.iconElem setPoint( "TOP", undefined, 0, 155 );

	wait 5;

//	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
//	
//	level.iconElem scaleovertime(1, 20, 20);
//	
//	wait .85;
//	level.iconElem fadeovertime(.15);
//	level.iconElem.alpha = 0;
	
	wait .5;
	level.hintElem fadeovertime(.5);
	level.hintElem.alpha = 0;
	
	clear_hints();
}

compass_reminder()
{	
	level endon ( "mission failed" );
	level endon ( "navigationTraining_end" );
	level endon ( "obj_go_to_the_pit_done" );
	
	clear_hints();
	level endon ( "clearing_hints" );

	double_line = true;
	add_hint_background( double_line );
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( &"TRAINER_HINT_OBJECTIVE_REMINDER" );


//	level.iconElem = createIcon( "objective", 32, 32 );
//	level.iconElem.hidewheninmenu = true;
//	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
//	level.iconElem setPoint( "TOP", undefined, 0, 155 );

	wait 5;
	//setObjectiveLocation( "obj_enter_range", getEnt( "rifle_range_obj", "targetname" )  );

//	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
//	
//	level.iconElem scaleovertime(1, 20, 20);
//	
//	wait .85;
//	level.iconElem fadeovertime(.15);
//	level.iconElem.alpha = 0;
	
	wait 2;
	level.hintElem fadeovertime(.5);
	level.hintElem.alpha = 0;
	
	clear_hints();
}

clear_hints()
{
	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();
	if ( isDefined( level.iconElem ) )
		level.iconElem destroyElem();
	if ( isDefined( level.iconElem2 ) )
		level.iconElem2 destroyElem();
	if ( isDefined( level.iconElem3 ) )
		level.iconElem3 destroyElem();
	if ( isDefined( level.hintbackground ) )
		level.hintbackground destroyElem();
	level notify ( "clearing_hints" );
}


killhouse_hint( text, timeOut, double_line )
{
	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background( double_line );
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( text );
	//level.hintElem endon ( "death" );

	if ( isDefined( timeOut ) )
		wait ( timeOut );
	else
		return;

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;
	wait ( 0.5 );

	clear_hints();
}

notifyOnTimeout( finishedNotify, timeOut )
{
	self endon( finishedNotify );
	wait timeOut;
	self notify( finishedNotify );
}

delete_if_obj_complete( obj_flag )
{
	self endon ( "death" );
	flag_wait ( obj_flag );
	self delete();
}




registerActions()
{
	level.actionBinds = [];
	registerActionBinding( "objectives",		"pause",				&"TRAINER_HINT_CHECK_OBJECTIVES_PAUSED" );
	
	registerActionBinding( "objectives_pc",		"+scores",				&"TRAINER_HINT_CHECK_OBJECTIVES_SCORES" );

	registerActionBinding( "pc_attack", 		"+attack",				&"TRAINER_HINT_ATTACK_PC" );
	registerActionBinding( "pc_hip_attack", 	"+attack",				&"TRAINER_HINT_HIP_ATTACK_PC" );
	
	registerActionBinding( "hip_attack", 		"+attack",				&"TRAINER_HINT_HIP_ATTACK" );
	registerActionBinding( "attack", 			"+attack",				&"TRAINER_HINT_ATTACK" );

	registerActionBinding( "stop_ads",			"+speed_throw",			&"TRAINER_HINT_STOP_ADS_THROW" );
	registerActionBinding( "stop_ads",			"+speed",				&"TRAINER_HINT_STOP_ADS" );
	registerActionBinding( "stop_ads",			"+toggleads_throw",		&"TRAINER_HINT_STOP_ADS_TOGGLE_THROW" );
	registerActionBinding( "stop_ads",			"toggleads",			&"TRAINER_HINT_STOP_ADS_TOGGLE" );
		
	registerActionBinding( "ads_360",			"+speed_throw",			&"TRAINER_HINT_ADS_THROW_360" );
	registerActionBinding( "ads_360",			"+speed",				&"TRAINER_HINT_ADS_360" );
	
	registerActionBinding( "ads",				"+speed_throw",			&"TRAINER_HINT_ADS_THROW" );
	registerActionBinding( "ads",				"+speed",				&"TRAINER_HINT_ADS" );
	registerActionBinding( "ads",				"+toggleads_throw",		&"TRAINER_HINT_ADS_TOGGLE_THROW" );
	registerActionBinding( "ads",				"toggleads",			&"TRAINER_HINT_ADS_TOGGLE" );
	
	registerActionBinding( "ads_switch",		"+speed_throw",			&"TRAINER_HINT_ADS_SWITCH_THROW" );
	registerActionBinding( "ads_switch",		"+speed",				&"TRAINER_HINT_ADS_SWITCH" );

	registerActionBinding( "ads_switch_shoulder",		"+speed_throw",			&"TRAINER_HINT_ADS_SWITCH_THROW_SHOULDER" );
	registerActionBinding( "ads_switch_shoulder",		"+speed",				&"TRAINER_HINT_ADS_SWITCH_SHOULDER" );

	registerActionBinding( "breath",			"+melee_breath",		&"TRAINER_HINT_BREATH_MELEE" );
	registerActionBinding( "breath",			"+breath_sprint",		&"TRAINER_HINT_BREATH_SPRINT" );
	registerActionBinding( "breath",			"+holdbreath",			&"TRAINER_HINT_BREATH" );

	registerActionBinding( "melee",				"+melee",				&"TRAINER_HINT_MELEE" );
	registerActionBinding( "melee",				"+melee_breath",		&"TRAINER_HINT_MELEE_BREATH" );

	registerActionBinding( "prone",				"goprone",				&"TRAINER_HINT_PRONE" );
	registerActionBinding( "prone",				"+stance",				&"TRAINER_HINT_PRONE_STANCE" );
	registerActionBinding( "prone",				"toggleprone",			&"TRAINER_HINT_PRONE_TOGGLE" );
	registerActionBinding( "prone",				"+prone",				&"TRAINER_HINT_PRONE_HOLD" );
	registerActionBinding( "prone",				"lowerstance",			&"TRAINER_HINT_PRONE_DOUBLE" );
//	registerActionBinding( "prone",				"+movedown",			&"" );

	registerActionBinding( "crouch",			"gocrouch",				&"TRAINER_HINT_CROUCH" );
	registerActionBinding( "crouch",			"+stance",				&"TRAINER_HINT_CROUCH_STANCE" );
	registerActionBinding( "crouch",			"togglecrouch",			&"TRAINER_HINT_CROUCH_TOGGLE" );
//	registerActionBinding( "crouch",			"lowerstance",			&"TRAINER_HINT_CROUCH_DOU" );
	registerActionBinding( "crouch",			"+movedown",			&"TRAINER_HINT_CROUCH_HOLD" );

	registerActionBinding( "stand",				"+gostand",				&"TRAINER_HINT_STAND" );
	registerActionBinding( "stand",				"+stance",				&"TRAINER_HINT_STAND_STANCE" );
	registerActionBinding( "stand",				"+moveup",				&"TRAINER_HINT_STAND_UP" );
	
	registerActionBinding( "jump",				"+gostand",				&"TRAINER_HINT_JUMP_STAND" );
	registerActionBinding( "jump",				"+moveup",				&"TRAINER_HINT_JUMP" );

	registerActionBinding( "sprint",			"+breath_sprint",		&"TRAINER_HINT_SPRINT_BREATH" );
	registerActionBinding( "sprint",			"+sprint",				&"TRAINER_HINT_SPRINT" );

	registerActionBinding( "sprint_pc",			"+breath_sprint",		&"TRAINER_HINT_SPRINT_BREATH_PC" );
	registerActionBinding( "sprint_pc",			"+sprint",				&"TRAINER_HINT_SPRINT_PC" );

	registerActionBinding( "sprint2",			"+breath_sprint",		&"TRAINER_HINT_HOLDING_SPRINT_BREATH" );
	registerActionBinding( "sprint2",			"+sprint",				&"TRAINER_HINT_HOLDING_SPRINT" );

	registerActionBinding( "reload",			"+reload",				&"TRAINER_HINT_RELOAD" );
	registerActionBinding( "reload",			"+usereload",			&"TRAINER_HINT_RELOAD_USE" );

	registerActionBinding( "mantle",			"+gostand",				&"TRAINER_HINT_MANTLE" );

	registerActionBinding( "sidearm",			"weapnext",				&"TRAINER_HINT_SIDEARM_SWAP" );

	registerActionBinding( "primary",			"weapnext",				&"TRAINER_HINT_PRIMARY_SWAP" );

	registerActionBinding( "frag",				"+frag",				&"TRAINER_HINT_FRAG" );
	
	registerActionBinding( "flash",				"+smoke",				&"TRAINER_HINT_FLASH" );

	registerActionBinding( "swap_launcher",		"+activate",			&"TRAINER_HINT_SWAP" );
	registerActionBinding( "swap_launcher",		"+usereload",			&"TRAINER_HINT_SWAP_RELOAD" );

	registerActionBinding( "firemode",			"+actionslot 2",		&"TRAINER_HINT_FIREMODE" );

	registerActionBinding( "attack_launcher", 	"+attack",				&"TRAINER_HINT_LAUNCHER_ATTACK" );

	registerActionBinding( "swap_explosives",	"+activate",			&"TRAINER_HINT_EXPLOSIVES" );
	registerActionBinding( "swap_explosives",	"+usereload",			&"TRAINER_HINT_EXPLOSIVES_RELOAD" );

	registerActionBinding( "plant_explosives",	"+activate",			&"TRAINER_HINT_EXPLOSIVES_PLANT" );
	registerActionBinding( "plant_explosives",	"+usereload",			&"TRAINER_HINT_EXPLOSIVES_PLANT_RELOAD" );

	registerActionBinding( "equip_C4",			"+actionslot 4",		&"TRAINER_HINT_EQUIP_C4" );
	
	registerActionBinding( "throw_C4",			"+toggleads_throw",		&"TRAINER_HINT_THROW_C4_TOGGLE" );
	registerActionBinding( "throw_C4",			"+speed_throw",			&"TRAINER_HINT_THROW_C4_SPEED" );
	registerActionBinding( "throw_C4",			"+throw",				&"TRAINER_HINT_THROW_C4" );
	
	registerActionBinding( "detonate_C4",		"+attack",				&"TRAINER_DETONATE_C4" );

	initKeys();
	updateKeysForBindings();
}



registerActionBinding( action, binding, hint )
{
	if ( !isDefined( level.actionBinds[action] ) )
		level.actionBinds[action] = [];

	actionBind = spawnStruct();
	actionBind.binding = binding;
	actionBind.hint = hint;

	actionBind.keyText = undefined;
	actionBind.hintText = undefined;

	precacheString( hint );

	level.actionBinds[action][level.actionBinds[action].size] = actionBind;
}


getActionBind( action )
{
    for ( index = 0; index < level.actionBinds[action].size; index++ )
    {
        actionBind = level.actionBinds[action][index];

        binding = getKeyBinding( actionBind.binding );
        if ( !binding["count"] )
            continue;

        return level.actionBinds[action][index];
    }

    return level.actionBinds[action][0];//unbound
}


updateKeysForBindings()
{
	if ( level.console )
	{
		setKeyForBinding( getCommandFromKey( "BUTTON_START" ), "BUTTON_START" );
		setKeyForBinding( getCommandFromKey( "BUTTON_A" ), "BUTTON_A" );
		setKeyForBinding( getCommandFromKey( "BUTTON_B" ), "BUTTON_B" );
		setKeyForBinding( getCommandFromKey( "BUTTON_X" ), "BUTTON_X" );
		setKeyForBinding( getCommandFromKey( "BUTTON_Y" ), "BUTTON_Y" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSTICK" ), "BUTTON_LSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSTICK" ), "BUTTON_RSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSHLDR" ), "BUTTON_LSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSHLDR" ), "BUTTON_RSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LTRIG" ), "BUTTON_LTRIG" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RTRIG" ), "BUTTON_RTRIG" );
	}
	else
	{
		//level.kbKeys = "1234567890-=QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,./";
		//level.specialKeys = [];

		for ( index = 0; index < level.kbKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.kbKeys[index] ), level.kbKeys[index] );
		}

		for ( index = 0; index < level.specialKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.specialKeys[index] ), level.specialKeys[index] );
		}

	}
}


getActionForBinding( binding )
{
	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;

			return arrayKeys[index];
		}
	}
}

setKeyForBinding( binding, key )
{
	if ( binding == "" )
		return;

	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys.size; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;

			bindArray[bindIndex].key = key;
		}
	}
}

initKeys()
{
	level.kbKeys = "1234567890-=qwertyuiop[]asdfghjkl;'zxcvbnm,./";

	level.specialKeys = [];

	level.specialKeys[level.specialKeys.size] = "TAB";
	level.specialKeys[level.specialKeys.size] = "ENTER";
	level.specialKeys[level.specialKeys.size] = "ESCAPE";
	level.specialKeys[level.specialKeys.size] = "SPACE";
	level.specialKeys[level.specialKeys.size] = "BACKSPACE";
	level.specialKeys[level.specialKeys.size] = "UPARROW";
	level.specialKeys[level.specialKeys.size] = "DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "ALT";
	level.specialKeys[level.specialKeys.size] = "CTRL";
	level.specialKeys[level.specialKeys.size] = "SHIFT";
	level.specialKeys[level.specialKeys.size] = "CAPSLOCK";
	level.specialKeys[level.specialKeys.size] = "F1";
	level.specialKeys[level.specialKeys.size] = "F2";
	level.specialKeys[level.specialKeys.size] = "F3";
	level.specialKeys[level.specialKeys.size] = "F4";
	level.specialKeys[level.specialKeys.size] = "F5";
	level.specialKeys[level.specialKeys.size] = "F6";
	level.specialKeys[level.specialKeys.size] = "F7";
	level.specialKeys[level.specialKeys.size] = "F8";
	level.specialKeys[level.specialKeys.size] = "F9";
	level.specialKeys[level.specialKeys.size] = "F10";
	level.specialKeys[level.specialKeys.size] = "F11";
	level.specialKeys[level.specialKeys.size] = "F12";
	level.specialKeys[level.specialKeys.size] = "INS";
	level.specialKeys[level.specialKeys.size] = "DEL";
	level.specialKeys[level.specialKeys.size] = "PGDN";
	level.specialKeys[level.specialKeys.size] = "PGUP";
	level.specialKeys[level.specialKeys.size] = "HOME";
	level.specialKeys[level.specialKeys.size] = "END";
	level.specialKeys[level.specialKeys.size] = "MOUSE1";
	level.specialKeys[level.specialKeys.size] = "MOUSE2";
	level.specialKeys[level.specialKeys.size] = "MOUSE3";
	level.specialKeys[level.specialKeys.size] = "MOUSE4";
	level.specialKeys[level.specialKeys.size] = "MOUSE5";
	level.specialKeys[level.specialKeys.size] = "MWHEELUP";
	level.specialKeys[level.specialKeys.size] = "MWHEELDOWN";
	level.specialKeys[level.specialKeys.size] = "AUX1";
	level.specialKeys[level.specialKeys.size] = "AUX2";
	level.specialKeys[level.specialKeys.size] = "AUX3";
	level.specialKeys[level.specialKeys.size] = "AUX4";
	level.specialKeys[level.specialKeys.size] = "AUX5";
	level.specialKeys[level.specialKeys.size] = "AUX6";
	level.specialKeys[level.specialKeys.size] = "AUX7";
	level.specialKeys[level.specialKeys.size] = "AUX8";
	level.specialKeys[level.specialKeys.size] = "AUX9";
	level.specialKeys[level.specialKeys.size] = "AUX10";
	level.specialKeys[level.specialKeys.size] = "AUX11";
	level.specialKeys[level.specialKeys.size] = "AUX12";
	level.specialKeys[level.specialKeys.size] = "AUX13";
	level.specialKeys[level.specialKeys.size] = "AUX14";
	level.specialKeys[level.specialKeys.size] = "AUX15";
	level.specialKeys[level.specialKeys.size] = "AUX16";
	level.specialKeys[level.specialKeys.size] = "KP_HOME";
	level.specialKeys[level.specialKeys.size] = "KP_UPARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGUP";
	level.specialKeys[level.specialKeys.size] = "KP_LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_5";
	level.specialKeys[level.specialKeys.size] = "KP_RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_END";
	level.specialKeys[level.specialKeys.size] = "KP_DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGDN";
	level.specialKeys[level.specialKeys.size] = "KP_ENTER";
	level.specialKeys[level.specialKeys.size] = "KP_INS";
	level.specialKeys[level.specialKeys.size] = "KP_DEL";
	level.specialKeys[level.specialKeys.size] = "KP_SLASH";
	level.specialKeys[level.specialKeys.size] = "KP_MINUS";
	level.specialKeys[level.specialKeys.size] = "KP_PLUS";
	level.specialKeys[level.specialKeys.size] = "KP_NUMLOCK";
	level.specialKeys[level.specialKeys.size] = "KP_STAR";
	level.specialKeys[level.specialKeys.size] = "KP_EQUALS";
	level.specialKeys[level.specialKeys.size] = "PAUSE";
	level.specialKeys[level.specialKeys.size] = "SEMICOLON";
	level.specialKeys[level.specialKeys.size] = "COMMAND";
	level.specialKeys[level.specialKeys.size] = "181";
	level.specialKeys[level.specialKeys.size] = "191";
	level.specialKeys[level.specialKeys.size] = "223";
	level.specialKeys[level.specialKeys.size] = "224";
	level.specialKeys[level.specialKeys.size] = "225";
	level.specialKeys[level.specialKeys.size] = "228";
	level.specialKeys[level.specialKeys.size] = "229";
	level.specialKeys[level.specialKeys.size] = "230";
	level.specialKeys[level.specialKeys.size] = "231";
	level.specialKeys[level.specialKeys.size] = "232";
	level.specialKeys[level.specialKeys.size] = "233";
	level.specialKeys[level.specialKeys.size] = "236";
	level.specialKeys[level.specialKeys.size] = "241";
	level.specialKeys[level.specialKeys.size] = "242";
	level.specialKeys[level.specialKeys.size] = "243";
	level.specialKeys[level.specialKeys.size] = "246";
	level.specialKeys[level.specialKeys.size] = "248";
	level.specialKeys[level.specialKeys.size] = "249";
	level.specialKeys[level.specialKeys.size] = "250";
	level.specialKeys[level.specialKeys.size] = "252";
}

make_door_from_prefab( sTargetname )
{
	ents = getentarray( sTargetname, "targetname" );
	door_org = undefined;
	door_models = [];
	door_brushes = [];
	door_trigger = undefined;
	door_blocker = undefined;
	foreach( ent in ents )
	{
		if ( ent.code_classname == "script_brushmodel" )
		{
			door_brushes[ door_brushes.size ] = ent;
			if ( ( isdefined( ent.script_noteworthy ) ) && ( ent.script_noteworthy == "blocker" ) )
				door_blocker = ent;
			continue;
		}
		if ( ent.code_classname == "script_origin" )
		{
			door_org = ent;
			continue;
		}
		if ( ent.code_classname == "script_model" )
		{
			door_models[ door_models.size ] = ent;
			continue;
		}
		if ( ent.code_classname == "trigger_radius" )
		{
			door_trigger = ent;
			continue;
		}
		
	}
	
	
	foreach( model in door_models )
		model linkto( door_org );
	foreach( brush in door_brushes )
		brush linkto( door_org );
	
	door = door_org;
	door.brushes = door_brushes;
	
	
	if ( isdefined( door_blocker ) )
	{
		door_blocker unlink();
		door.blocker = door_blocker;
	}
		
	if ( isdefined( door_trigger ) )
		door.trigger = door_trigger;
	
	return door;
}


weapons_hide()
{
	self.origin = self.origin + ( 0, 0, -1000 );
}

weapons_show()
{
	self.origin = self.origin + ( 0, 0, 1000 );
}




vehicle_think()
{
	switch( self.vehicletype )
    {
		case "humvee":
		case "hummer_minigun":
		case "hummer":
   			self thread vehicle_humvee_think();
    		break;
    	case "m1a1":
    		self thread vehicle_m1a1_think();
    		break;
    	case "cobra":
    		self thread vehicle_cobra_think();
    		break;
    }
}

vehicle_humvee_think()
{
	
}

vehicle_m1a1_think()
{
	
}

vehicle_cobra_think()
{
	
}


AI_drone_think()
{
	self endon( "death" );
	self endon( "stop_default_drone_behavior" );
	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "ai_ambient" ) )
	{
		self.dontDoNotetracks = true;	//allows using of ai _anim functons without getting errors
		self.script_looping = 0;		//will force drone to scip default idle behavior
	}
	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "runners" ) )
	{
		self waittill( "goal" );
		self delete();
	}
}

ai_ambient_think( sAnim, sFailSafeFlag )
{	
	self endon( "death" );
	self AI_ambient_ignored(); 
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
		
		if ( sAnim == "training_basketball_guy2" )
		{
			basketball = getent( "basketball", "targetname" );
			basketball.animname = "basketball";
			basketball assign_animtree();
			self.eAnimEnt thread anim_loop_solo( basketball, "training_basketball_loop", "stop_idle" );
		}

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
				anim_generic( self, sAnimReact );
			else
				anim_generic( self, sAnimReact2 );
			thread anim_generic_loop( self, sAnim, "stop_idle" );
			
		}
	}
}


ai_ambient_cleanup()
{
	self waittill( "death" );
	if ( ( isdefined( self.eAnimEnt ) ) && ( !isspawner( self.eAnimEnt ) ) )
		self.eAnimEnt delete();
			
}


AI_patrol_think()
{
	self endon( "death" );
	self pushplayer( true );
	self.walkdist = 1000;
	self.disablearrivals = true;
	wait( 0.1 );
	self thread maps\_patrol::patrol();
	level.patrolDudes[ level.patrolDudes.size ] = self;
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
		case "training_humvee_repair":
			self thread mechanic_sound_loop();
			self gun_remove();
			break;
		case "roadkill_humvee_map_sequence_quiet_idle":
			self attach( "characters_accessories_pencil", "TAG_INHAND", 1 );
			self gun_remove();
			break;
		case "training_locals_kneel":
			//this particular guy needs his weapon attached to chest
			self gun_remove();
			self.m4 = spawn( "script_model", ( 0, 0, 0 ) );
			self.m4 setmodel( "weapon_m4" );
			self.m4 HidePart( "TAG_THERMAL_SCOPE" );
			self.m4 HidePart( "TAG_FOREGRIP" );
			self.m4 HidePart( "TAG_ACOG_2" );
			self.m4 HidePart( "TAG_HEARTBEAT" );
			self.m4 HidePart( "TAG_RED_DOT" );
			self.m4 HidePart( "TAG_SHOTGUN" );
			self.m4 HidePart( "TAG_SILENCER" );
			self.m4.origin = self gettagorigin( "tag_inhand" );
			self.m4.angles = self gettagangles( "tag_inhand" );
			self.m4 linkto( self, "tag_inhand" );
			self thread delete_on_death( self.m4 );
			break;
		case "training_locals_groupA_guy1":
		case "training_locals_groupA_guy2":
		case "training_locals_groupB_guy1":
		case "training_locals_groupB_guy2":
		case "training_locals_sit":
			//leave weapons on these guys
			break;
		case "parabolic_leaning_guy_idle_training":
		case "parabolic_leaning_guy_idle":
		case "little_bird_casual_idle_guy1":
		case "killhouse_sas_2_idle":
			//leave weapons on these guys
			break;
		case "training_sleeping_in_chair":
			self gun_remove();
			self.eAnimEnt = getent( self.target, "targetname" );	//just use whatever model he is targeting
			break;
		case "death_explosion_run_F_v1":
		case "civilian_run_2_crawldeath":
			self gun_remove();
			self.skipDeathAnim = true;
			self.noragdoll = true;
			break;
		case "afgan_caves_sleeping_guard_idle":
			self gun_remove();
			self.eAnimEnt.origin = self.eAnimEnt.origin + ( 0, 0, 26 );
			break;
		case "bunker_toss_idle_guy1":
		case "DC_Burning_artillery_reaction_v1_idle":
		case "DC_Burning_artillery_reaction_v2_idle":
		case "DC_Burning_bunker_stumble":
			self gun_remove();
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
			self gun_remove();
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
			thread anim_generic( self, "wounded_carry_putdown_closet_carrier" );
			anim_generic( eBuddy, "wounded_carry_putdown_closet_wounded" );
			thread anim_generic_loop( eBuddy, "wounded_carry_closet_idle_wounded" );
			thread anim_generic_loop( self, "wounded_carry_closet_idle_carrier" );
			return;
		case "sitting_guard_loadAK_idle":
			self gun_remove();
			self Attach( "weapon_m4_clip", "tag_inhand" );
			break;
		case "civilian_texting_standing":
		case "civilian_texting_sitting":
			self gun_remove();
			self Attach( "electronics_pda", "tag_inhand" );
			break;
		case "civilian_reader_1":
		case "civilian_reader_2":
			self gun_remove();
			self Attach( "open_book_static", "tag_inhand" );
			break;
		case "civilian_smoking_A":
		case "oilrig_balcony_smoke_idle":
		case "parabolic_leaning_guy_smoking_idle":
			self thread maps\_props::attach_cig_self();
			break;
		case "cliffhanger_welder_wing":
			self gun_remove();
			self.eAnimEnt.origin = self.eAnimEnt.origin + ( 0, 0, -3 );
			self Attach( "machinery_welder_handle", "tag_inhand" );
			self thread flashing_welding();
			self thread play_loop_sound_on_entity( "scn_trainer_welders_working_loop" );
			//thread flashing_welding_death_handler( self );
			break;
		case "roadkill_cover_radio_soldier2":
			break;
		case "roadkill_cover_spotter_idle":
			self attach( "weapon_binocular", "TAG_INHAND", 1 );
			break;
		case "roadkill_cover_radio_soldier3":
			self attach( "mil_mre_chocolate01", "TAG_INHAND", 1 );
			break;
		case "training_basketball_rest":
			self gun_remove();
			self attach( "com_bottle2", "TAG_INHAND", 1 );
			break;
		case "favela_run_and_wave":
			break;
		default:
			self gun_remove();
			break;
	}
	
	self thread ai_ambient_think( sAnim, sFailSafeFlag );

}

AI_ambient_ignored()
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


mechanic_sound_loop()
{
	self endon( "death" );
	while( true )
	{
		self waittillmatch( "looping anim", "end" );
		self thread play_sound_in_space( "scn_trainer_mechanic" );
	}
}

flashing_welding()
{
	self endon( "death" );
	self thread stop_sparks();
	while( true )
	{
		self waittillmatch( "looping anim", "spark on" );
		self thread start_sparks();
	}
}

start_sparks()
{
	self endon( "death" );
	self notify( "starting sparks" );
	self endon( "starting sparks" );
	self endon( "spark off" );
	while( true )
	{
		PlayFXOnTag( level._effect[ "welding_runner" ], self, "tag_tip_fx" );
		self PlaySound( "elec_spark_welding_bursts" );
		wait( randomfloatRange( .25, .5 ) );
	}
}

stop_sparks()
{
	self endon( "death" );
	while( true )
	{
		self waittillmatch( "looping anim", "spark off" );
		self notify( "spark off" );
	}
}

flashing_welding_death_handler( welder )
{
	//light = GetEnt( "welding_light", "targetname" );
	welder waittill( "death" );

	//light stop_loop_sound_on_entity( "scn_cliffhanger_welders_loop" );
	//light SetLightIntensity( 0 );
}

AI_think( guy )
{
	guy.ignoreme = true;
	guy.ignoreall = true;
	guy thread magic_bullet_shield();
	guy disable_pain();
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
	self forceUseWeapon( "m4_grunt", "primary" );
	self.team = "allies";
}

player_has_primary_weapon()
{
	if ( level.player HasWeapon( level.gunPrimary ) )
		return true;
	else
		return false;
}

auto_aim()
{
	if ( level.console )
	{
		if ( level.player GetLocalPlayerProfileData( "autoAim" ) )
			return true;
	}
	return false;
}

bridge_layer_think()
{
	bridge_layer = getent( "bridge_layer", "targetname" );
	bridge_layer_bridge = getent( "bridge_layer_bridge", "targetname" );

	bridge_layer.animname = "bridge_layer";
	bridge_layer assign_animtree();
	bridge_layer_bridge.animname = "bridge_layer_bridge";
	bridge_layer_bridge assign_animtree();

	animOrg = spawn( "script_origin", ( 0, 0, 0 ) );
	animOrg.origin = bridge_layer.origin;
	animOrg.angles = bridge_layer.angles;
	
	animOrg thread anim_first_frame_solo( bridge_layer, "bridge_raise" );
	animOrg anim_first_frame_solo( bridge_layer_bridge, "bridge_raise" );

	bridge_layer playloopsound( "m1a1_abrams_idle_low" );
	
	flag_wait( "player_passing_barracks" );
	
	animOrg thread anim_single_solo( bridge_layer, "bridge_raise" );
	animOrg anim_single_solo( bridge_layer_bridge, "bridge_raise" );
	
}

accuracy_bonus()
{	
	level.bonus_time = undefined;
	level.pitaccuracy = undefined;
	
	/*-----------------------
	GET TOTAL PLAYER AMMO
	-------------------------*/	
	level.guns = level.player GetWeaponsListPrimaries();
	level.gun0 = level.player GetWeaponAmmoStock( level.guns[0] );
	level.gun1 = level.player GetWeaponAmmoStock( level.guns[1] );
	level.gunc0 = level.player GetWeaponAmmoClip( level.guns[0] );
	level.gunc1 = level.player GetWeaponAmmoClip( level.guns[1] );
	level.starting_ammo = level.gun0 + level.gun1 + level.gunc0 + level.gunc1;
	//iprintlnbold ( "starting_ammo " +  starting_ammo );
	
	/*-----------------------
	COURSE FINISHED
	-------------------------*/	
	level waittill ( "test_cleared" );

	/*-----------------------
	FIGURE OUT BONUS
	-------------------------*/	
	level.guns = level.player GetWeaponsListPrimaries();
	level.gun0 = level.player GetWeaponAmmoStock( level.guns[0] );
	level.gun1 = level.player GetWeaponAmmoStock( level.guns[1] );
	level.gunc0 = level.player GetWeaponAmmoClip( level.guns[0] );
	level.gunc1 = level.player GetWeaponAmmoClip( level.guns[1] );
	level.ending_ammo = level.gun0 + level.gun1 + level.gunc0 + level.gunc1;
	//iprintlnbold ( "ending_ammo " +  ending_ammo );

	/*-----------------------
	HOW MUCH AMMO USED?
	-------------------------*/	
	bullets_used_by_player = level.starting_ammo - level.ending_ammo;
	//iprintlnbold ( "ammo used: " +  bullets_used_by_player );
	
	enemy_targets_killed = level.targets_hit;

	//iprintlnbold ( "Enemy targets killed: " +  enemy_targets_killed );
	
	/*-----------------------
	ACCURACY PERCENTAGE
	-------------------------*/	
	if ( ( enemy_targets_killed == 0 ) || ( bullets_used_by_player == 0 ) )
	{
		level.pitaccuracy = 0;
	}
	else
	{
		level.pitaccuracy = ( enemy_targets_killed / bullets_used_by_player ) * 100;
		level.pitaccuracy = roundDecimalPlaces( level.pitaccuracy, 0 );
	}
	
	/*-----------------------
	ACCURACY BONUS TIME
	-------------------------*/	
	if ( level.pitaccuracy == 0 )
	{
		level.bonus_time = 0;
	}
	else
	{
		if ( level.pitaccuracy > 200 )
		{
			level.pitaccuracy = 200;
		}
		level.bonus_time = ( level.pitaccuracy / 0.2 ) / 100;
		level.bonus_time = roundDecimalPlaces( level.bonus_time, 1 );

	}
	
	level notify ( "accuracy_bonus" );
}

killTimer( best_time, deck )	
{
	//Your Time:			10:25
	//Enemies Killed:		5/12
	//Civilians Killed:		0/8

	//------------------------------------

	//Enemies missed penalty	10.00 sec
	//Civilians killed penalty	20.00 sec
	//Accuracy					37%
	//Accuracy bonus			00.00 sec
	
	//Final Time				1:09:00
	//IW Best Time				
	
	//Recommended
	//difficulty: 
	//Recruit
	
	//reset global variables
	level.toomanycivilianskilled = false;
	level.toomanytargetsmissed = false;
	level.basetimetooklongerthanminimum = false;
	
	friendlies_hit = level.friendlies_hit;
	enemies_hit = level.targets_hit;
	level notify ( "kill_timer" );
	clear_timer_elems();
	
	/*-----------------------
	PRINT BASE TIME
	-------------------------*/	
	time = ( ( gettime() - level.start_time ) / 1000 );
	time = roundDecimalPlaces( time, 2 );
	level.HUDtimer = get_pit_hud();
	level.HUDtimer.label = &"TRAINER_YOUR_TIME_IN_SECONDS";
	level.HUDtimer.y = 55;
	level.HUDtimer setValue ( time );
	
	/*-----------------------
	PRINT ENEMIES KILLED
	-------------------------*/	
	level.HUDenemiesKilled = get_pit_hud();	
	level.HUDenemiesKilled.label = &"TRAINER_ENEMIES_KILLED";
	level.HUDenemiesKilled setValue ( enemies_hit );
	level.HUDenemiesKilled.y = 70;

	/*-----------------------
	PRINT CIVVIES KILLED
	-------------------------*/	
	level.HUDcivviesKilled = get_pit_hud();	
	level.HUDcivviesKilled.label = &"TRAINER_CIVVIES_KILLED";
	level.HUDcivviesKilled setValue ( friendlies_hit );
	level.HUDcivviesKilled.y = 85;
	
	level waittill ( "accuracy_bonus" );
	
	/*-----------------------
	PRINT ACCURACY AND BONUS TIME
	-------------------------*/	
	level.HUDaccuracy = get_pit_hud();	
	level.HUDaccuracy.y = 115;
	level.HUDaccuracy.label = &"TRAINER_ACCURACY_LABEL";
	level.HUDaccuracy setValue ( level.pitaccuracy );
	
	level.HUDaccuracybonus = get_pit_hud();	
	level.HUDaccuracybonus.y = 130;
	
	if ( level.bonus_time <= 0 )
	{
		//"Accuracy bonus: 0.0"
		level.HUDaccuracybonus.label = &"TRAINER_ACCURACY_BONUS_ZERO";
	}
	else
	{
		level.HUDaccuracybonus.label = &"TRAINER_ACCURACY_BONUS";
		level.HUDaccuracybonus setValue ( level.bonus_time );
	}

	/*-----------------------
	PRINT MISSED ENEMIES PENALTY
	-------------------------*/	
	level.HUDmissedenemypenalty = get_pit_hud();	
	level.HUDmissedenemypenalty.y = 145;
	if ( enemies_hit == level.totalPitEnemies )
	{
		level.HUDmissedenemypenalty.label = &"TRAINER_MISSED_ENEMY_PENALTY_NONE";
		missed_enemies_penalty = 0;
	}
	else
	{
		missed_enemies = ( level.totalPitEnemies - enemies_hit );
		level.HUDmissedenemypenalty.color = level.color[ "red" ];
		level.HUDmissedenemypenalty.label = &"TRAINER_MISSED_ENEMY_PENALTY";
		missed_enemies_penalty = ( missed_enemies * level.timepenaltyForMissedEnemies );
		//timepenaltyForKilledCivvies
		level.HUDmissedenemypenalty setValue ( missed_enemies_penalty );
	}
	/*-----------------------
	PRINT KILLED FRIENDLIES PENALTY
	-------------------------*/	
	level.HUDkilledcivviespenalty = get_pit_hud();	
	level.HUDkilledcivviespenalty.y = 160;
	if ( friendlies_hit == 0 )
	{
		level.HUDkilledcivviespenalty.label = &"TRAINER_KILLED_CIVVIES_NONE";
		killed_civvies_penalty = 0;
	}
	else
	{
		level.HUDkilledcivviespenalty.color = level.color[ "red" ];
		level.HUDkilledcivviespenalty.label = &"TRAINER_KILLED_CIVVIES_PENALTY";
		killed_civvies_penalty = ( friendlies_hit * level.timepenaltyForKilledCivvies );
		level.HUDkilledcivviespenalty setValue ( killed_civvies_penalty );
	}
	
	/*-----------------------
	PRINT FINAL TIME SCORE
	-------------------------*/	
	level.HUDfinaltime = get_pit_hud();	
	level.HUDfinaltime.y = 190;
	
	//subtract any accuracy bonus time
	final_time = time - level.bonus_time;
	
	//add any enemies missed penalty time
	final_time = final_time + missed_enemies_penalty;
	
	//add any civvies killed penalty time
	final_time = final_time + killed_civvies_penalty;
	
	level.HUDfinaltime.label = &"TRAINER_YOUR_FINAL_TIME";
	level.HUDfinaltime setValue( final_time );
	
	/*-----------------------
	PRINT IW BEST TIME
	-------------------------*/	
//	level.IW_best = get_pit_hud();	
//	level.IW_best.y = 115;
//	level.IW_best.label = &"TRAINER_IW_BEST_TIME";
//	level.IW_best setValue ( best_time );

	/*-----------------------
	PRINT RECOMMENDED DIFFICULTY
	-------------------------*/	
	level.recommended_label = get_pit_hud();	
	level.recommended_label SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.recommended_label.label = &"TRAINER_RECOMMENDED_LABEL";
	level.recommended_label.y = 220;
	
	level.recommended_label2 = get_pit_hud();
	level.recommended_label2 SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.recommended_label2.label = &"TRAINER_RECOMMENDED_LABEL2";
	level.recommended_label2.y = 235;
	
	level.recommended = get_pit_hud();	
	level.recommended.y = 260;
	level.recommended SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	
	if ( time > level.timeFail )
	{
		level.basetimetooklongerthanminimum = true;
	}
	if ( enemies_hit < level.minimumenemiestokill )
	{
		level.toomanytargetsmissed = true;
	}
	if ( friendlies_hit > level.maximumfriendliesalloweddead )
	{
		level.toomanycivilianskilled = true;
	}
	if ( ( final_time > level.timeFail ) || ( level.targets_hit_with_melee > 10 ) || ( level.toomanytargetsmissed == true ) || ( level.toomanycivilianskilled == true ) )
	{
		level.recommended.label = &"TRAINER_RECOMMENDED_TRY_AGAIN";
		level.recommendedDifficulty = 1000;
	}
	else if ( final_time > level.timeEasy )
	{
		setdvar ( "recommended_gameskill", "0" );
		level.recommended.label = &"TRAINER_RECOMMENDED_EASY";
		level.recommendedDifficulty = 0;
	}
	else if ( final_time > level.timeRegular )
	{
		setdvar ( "recommended_gameskill", "1" );
		level.recommended.label = &"TRAINER_RECOMMENDED_NORMAL";
		level.recommendedDifficulty = 1;
	}
	else if ( final_time > level.timeHard )
	{
		setdvar ( "recommended_gameskill", "2" );
		level.recommended.label = &"TRAINER_RECOMMENDED_HARD";
		level.recommendedDifficulty = 2;
	}
	else
	{
		setdvar ( "recommended_gameskill", "3" );
		level.recommended.label = &"TRAINER_RECOMMENDED_VETERAN";
		level.recommendedDifficulty = 3;
	}
	
	if( final_time < 30.0 )
		maps\_utility::giveachievement_wrapper( "PIT_BOSS" ); 
		
	return final_time;

}


flag_on_notify( msg )
{
	level.player waittill( msg );
	flag_set( msg );
}

notify_on_sprint()
{
	NotifyOnCommand( "sprinted", "+breath_sprint" );
	NotifyOnCommand( "sprinted", "+sprint" );
}

dialog_end_of_course( numberOfTimesRun )
{
	dialogueLine = undefined;
	switch( level.recommendedDifficulty )
	{
		case 1000:
			dialogueLine = "end_of_course_try_again";
			break;
		case 0:		//easy
			//Cpl. Dunn	training	Not bad. Looks like you're getting a little sloppy though.	
			//Cpl. Dunn	Alright I guess. You need some serious polish though.	
			//Cpl. Dunn	Good enough, but you're getting a little sloppy.	
			iRand = randomintrange( 1, 4 );
			dialogueLine = "end_of_course_easy_0" + iRand;
			break;
		case 1:		//regular
			//Cpl. Dunn	training	I've seen worse. You've got a few rough edges though.	
			//Cpl. Dunn	That wasn't horrible, but it wasn't amazing either.	
			//Cpl. Dunn	You look ok out there, but you still need some work.	
			iRand = randomintrange( 1, 4 );
			dialogueLine = "end_of_course_reg_0" + iRand;
			break;
		case 2:		//hardened
			//Cpl. Dunn	training	Good, man, very good. You've still got it.	
			//Cpl. Dunn	That was pretty damn good. Nice work, Allen.	
			//Cpl. Dunn	Very nice. Run like a true professional.	
			iRand = randomintrange( 1, 4 );
			dialogueLine = "end_of_course_hard_0" + iRand;
			break;
		case 3:		//veteran
			//Cpl. Dunn  Very impressive, man! You made that course your bitch!	
			//Cpl. Dunn	Amazing work. Now that's how you run The Pit.	
			iRand = randomintrange( 1, 3 );
			dialogueLine = "end_of_course_vet_0" + iRand;
			break;
		
	}
	return dialogueLine;
}

//dialog_end_of_course( level.first_time, final_time, previous_time, previous_selection )
//{
//	if ( ! first_time )
//	{
//		if ( ( previous_time + 2 ) < final_time )
//		{
//			if ( ( randomint( 2 ) ) > 0 )
//			{
//				//Don't waste our time Soap. The idea is to take less time, not more.	
//				selection = ( "The idea is to take less time, not more." );
//				return selection;
//			}
//			else
//			{
//				//You're getting' slower. Perhaps it was a mistake to let you skip the obstacle course.
//				selection = ( "You're getting' slower" );
//				return selection;
//			}
//		}
//
//		if ( previous_time > ( final_time + 3 ) )
//		{
//			if ( ( randomint( 2 ) ) > 0 )
//			{
//				//That was an improvement, but it's not hard to improve on garbage. Try it again.	
//				selection = ( "Imprved, but not by much. Try it again" );
//				return selection;
//			}
//			else
//			{
//				//That was better. Not great. But better.	
//				selection = ( "That was better. Not great. But better." );
//				return selection;
//			}
//		}
//
//		if ( ( level.bonus_time < 1.8 ) && ( previous_selection != "sloppy" ) )
//		{
//			//Fast, but sloppy. You need to work on your accuracy.	
//			selection = ( "Fast, but sloppy. You need to work on your accuracy.	" );
//			return selection;
//		}
//	}
//
//	num = randomint( 2 );
//	if ( num == 0 )
//	{
//		//All right Soap, that's enough. You'll do.	
//		selection = ( "All right, that's enough. You'll do." );
//		return selection;
//	}
//	//else if ( num == 1 )	
//	//{
//		//I've seen better, but that'll do.	
//	//	selection = ( "seenbetter2" ); 
//	//	return selection;
//	//}
//	else
//	{
//		//"Pretty good, Soap. But I've seen better." );
//		selection = "Pretty good, but I've seen better.";
//		return selection;
//	}
//}

clear_timer_elems()
{
	if (isdefined (level.HUDtimer))
		level.HUDtimer destroy();
	if (isdefined (level.HUDaccuracybonus))
		level.HUDaccuracybonus destroy();
	if (isdefined (level.label))
		level.label destroy();
	if (isdefined (level.IW_best) )
		level.IW_best destroy();
	if (isdefined (level.recommended_label) )
		level.recommended_label destroy();
	if (isdefined (level.recommended_label2) )
		level.recommended_label2 destroy();
	if (isdefined (level.recommended) )
		level.recommended destroy();
	if (isdefined (level.HUDenemiesKilled) )
		level.HUDenemiesKilled destroy();
	if (isdefined (level.HUDcivviesKilled) )
		level.HUDcivviesKilled destroy();
	if (isdefined (level.HUDaccuracy) )
		level.HUDaccuracy destroy();
	if (isdefined (level.HUDmissedenemypenalty) )
		level.HUDmissedenemypenalty destroy();
	if (isdefined (level.HUDkilledcivviespenalty) )
		level.HUDkilledcivviespenalty destroy();
	if (isdefined (level.HUDfinaltime) )
		level.HUDfinaltime destroy();
	if (isdefined (level.recommended_label) )
		level.recommended_label destroy();

}


second_sprint_hint()
{
	level endon ( "kill_sprint_hint" );
	//getEnt( "obstacleTraining_sprint", "targetname" ) waittill ( "trigger" );

	wait .5;
	actionBind = getActionBind( "sprint2" );
	killhouse_hint( actionBind.hint, 5 );
}



startTimer( timelimit )
{
	/*-----------------------
	SETUP
	-------------------------*/	
	clear_timer_elems();
	// destroy timer and thread if objectives completed within limit
	level endon ( "kill_timer" );
	level.hudTimerIndex = 20;	//what the hell is this for?
	level.start_time = gettime();
	
	/*-----------------------
	YOUR TIME
	-------------------------*/	
	// Timer size and positioning
	level.HUDtimer = maps\_hud_util::get_countdown_hud();	
	level.HUDtimer.label = &"TRAINER_YOUR_TIME";
	level.HUDtimer settenthstimerUp( .05 );
	level.HUDtimer.y = 55;
	
	/*-----------------------
	PRINT ENEMIES KILLED
	-------------------------*/	
	level.HUDenemiesKilled = maps\_hud_util::get_countdown_hud();	
	level.HUDenemiesKilled.label = &"TRAINER_ENEMIES_KILLED";
	level.HUDenemiesKilled setValue ( level.targets_hit );
	level.HUDenemiesKilled.y = 70;
	
	/*-----------------------
	PRINT CIVVIES KILLED
	-------------------------*/	
	level.HUDcivviesKilled = maps\_hud_util::get_countdown_hud();	
	level.HUDcivviesKilled.label = &"TRAINER_CIVVIES_KILLED";
	level.HUDcivviesKilled setValue ( level.friendlies_hit );
	level.HUDcivviesKilled.y = 85;
	
	/*-----------------------
	TIMER EXPIRED
	-------------------------*/	
	wait ( timelimit );
	//flag_set ( "timer_expired" );
	
	/*-----------------------
	GET RID OF HUD ELEMENT AND FAIL THE MISSION 
	-------------------------*/	
	level.HUDtimer destroy();	
	level thread mission_failed_out_of_time();
}

mission_failed_out_of_time()
{
	level.player endon ( "death" );
	level endon ( "kill_timer" );
	
	//dialog = [];
	//dialog[ 0 ] = "startover"; //
	//dialog[ 1 ] = "doitagain"; //
	//dialog[ 2 ] = "tooslow"; //
					
	//selection = dialog[ randomint( dialog.size ) ];
					
	//level.pitguy thread dialogue_execute( selection );
	
	
	failures = getdvarint( "killhouse_too_slow" );
	setdvar( "killhouse_too_slow", ( failures + 1 ) );
	
	level notify ( "mission failed" );
	if( !flag( "player_course_end" ) )
		setDvar( "ui_deadquote", &"TRAINER_SHIP_TOO_SLOW");
	else 
		setDvar( "ui_deadquote", &"TRAINER_SHIP_DIDNT_SPRINT");
		
	maps\_utility::missionFailedWrapper();	
}

get_pit_hud( x, y, player )
{
	xPos = undefined;
	if ( !level.Console )
		xPos = -250; //override x-position if this is PC or the timer will get cut off
	else if ( !isdefined( x ) )
		xPos = -225;
	else
		xPos = x;

	if ( !isdefined( y ) )
		yPos = 100;
	else
		yPos = y;

	if ( isdefined( player ) )
		hudelem = newClientHudElem( player );
	else
		hudelem = newHudElem();
	
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "right";
	hudelem.vertAlign = "top";
	hudelem.x = xPos;
	hudelem.y = yPos;
	hudelem.fontScale = 1.3;
	hudelem.color = ( 0.8, 1.0, 0.8 );
	hudelem.font = "objective";
	hudelem.glowColor = ( 0.3, 0.6, 0.3 );
	hudelem.glowAlpha = 1;
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = true;
	hudelem.hidewhendead = true;
	return hudelem;
}

dialogue_ambient_wait()
{
	wait( randomfloatrange( 1.3, 2.8 ) );
}

dialogue_ambient()
{
	level endon( "end_sequence_starting" );
	level endon( "pit_dialogue_starting" );
	conversation_orgs = getentarray( "conversation_orgs", "targetname" );
	org = getclosest( level.player.origin, conversation_orgs );
	
	conversation_array[ 0 ] = level.scr_sound[ "conversation_01" ];
	conversation_array[ 1 ] = level.scr_sound[ "conversation_02" ];
	conversation_array[ 2 ] = level.scr_sound[ "conversation_03" ];
	
	if ( cointoss() )
	{
		conversation_array[ 0 ] = level.scr_sound[ "conversation_03" ];
		conversation_array[ 1 ] = level.scr_sound[ "conversation_02" ];
		conversation_array[ 2 ] = level.scr_sound[ "conversation_01" ];
	}
	
	iNumber = 0;
	while( true )
	{
		dialogue_array = conversation_array[ iNumber ];
		foreach( dialogue_line in dialogue_array )
		{
			org = getclosest( level.player.origin, conversation_orgs );
			org play_sound_in_space( dialogue_line );
			dialogue_ambient_wait();
		}
		iNumber++;
		if ( iNumber > 2 )
			iNumber = 0;
	}
}

dialogue_pit_wait()
{
	wait( randomfloatrange( .1, 1.2 ) );
}

dialogue_ambient_pit_course()
{
	level endon( "end_sequence_starting" );
	
	flag_set( "pit_dialogue_starting" );
	conversation_orgs_pit = getentarray( "conversation_orgs_pit", "targetname" );
	

	//Ranger 2	Whatever, I beat Mason's time by six seconds yesterday. 
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar2_masonstime" );
	
	dialogue_pit_wait();
	
	//Ranger 1   Yeah, I roll through this joint with the Desert Eagle.	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar1_deserteagle" );
	
	dialogue_pit_wait();
	
	//Ranger 2   Yeah? I roll through this joint with yo mamma!	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar2_yomamma" );
	
	dialogue_pit_wait();
		
	//Ranger 1   Very funny dickwad. You thought of that one all by yourself huah?	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar1_veryfunny" );
	
	dialogue_pit_wait();
	
	//Ranger 2   You guys ever run the course with the movers on max speed?	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar2_maxspeed" );
	
	dialogue_pit_wait();
	
	//Ranger 3   Hell no. We don't get enough trigger time for that kind of accuracy man.	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar3_triggertime" );
	
	dialogue_pit_wait();
	
	//Ranger 1   Yeah, who you kiddin'? Only Delta gets that kind of practice, huah?	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar1_onlydelta" );

	dialogue_pit_wait();

	//Ranger 2	Go home and take your girlfriend out. <laughs> Cuz you're here for four more months. I'll take care of her dude! I'll check in on her. Is that alright?	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar2_takecareofyourgf" );
	
	dialogue_pit_wait();

	//Ranger 2   Huah. Keating says he saw some D-boys take the course with the movers on max speed with double civvies. 	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar2_keatingsays" );
	
	dialogue_pit_wait();
	
	//Ranger 4   Yeah I was there - headshot, headshot, headshot. Those guys are badass man. 
	org = getclosest( level.player.origin, conversation_orgs_pit );	
	org play_sound_in_space( "train_ar4_headshot" );
	
	dialogue_pit_wait();
	
	//Ranger 4   Except one guy had a mohawk, spoke with a funny accent. British or somethin'. 	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar4_funnyaccent" );
	
	dialogue_pit_wait();
	
	//Ranger 1   SAS cross-trainin' with our Delta boys?	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar1_crosstraining" );
	
	dialogue_pit_wait();
	
	//Ranger 4   Maybe. That guy rolled the course in eight point two-six. Made our D-boys look like they were movin' in slow motion.	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar4_slowmotion" );
	
	dialogue_pit_wait();
	
	//Ranger 3   Damn, man, that is goood.	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar3_thatisgood" );
	
	dialogue_pit_wait();
	
	//Ranger 4   There was this other dude, guy with a ski mask with a skull painted on it. Eight point two-eight, usin' a 1911. 
	org = getclosest( level.player.origin, conversation_orgs_pit );	
	org play_sound_in_space( "train_ar4_skimask" );
	
	dialogue_pit_wait();
	
	//Ranger 4   I'm tellin' you...that guy was frickin' weird man…	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar4_weirdman" );

	dialogue_pit_wait();
	
	//Ranger 2	I dunnno man, marching off into the desert in a two man team like that, no support. . . .	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar2_twomanteam" );

	dialogue_pit_wait();
	
	//Ranger 2	Those dudes, they get killed, and like nobody even knows. . . Nobody knows: Nobody knows where they're going or where they're coming from. It's crazy. I can't even- I don't know. My wife would freak out. That's probably why most of them aren't even marrie	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar2_wifewouldfreak" );
	
	dialogue_pit_wait();

	//God how dumb are you guys?	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar4_howdumb" );
	
	dialogue_pit_wait();

	//Honestly… I could fight anybody in this platoon.	
	org = getclosest( level.player.origin, conversation_orgs_pit );
	org play_sound_in_space( "train_ar4_fightanybody" );
	
	wait( 5 );
	
	thread dialogue_ambient();
}

AI_runner_group_think( spawnerTargetname )
{
	spawners = getentarray( spawnerTargetname, "targetname" );
	runners = undefined;
	while ( true )
	{
		runners = array_spawn( spawners, true );
		waittill_dead( runners );
	}
}

AI_runners_think()
{
	self gun_remove();
	self.runanim = level.scr_anim[ "generic" ][ self.animation ];
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

weaponfire_failure()
{
	level endon( "mission failed" );
	while( true )
	{
		flag_wait( "player_in_camp" );
		while( flag( "player_in_camp" ) )
		{
			level.player waittill_either( "begin_firing", "player_not_in_camp" );
			if ( flag( "player_in_camp" ) )
			{
				//mission fail
				wait( .5 );
				SetDvar( "ui_deadquote", &"TRAINER_MISSION_FAIL_FIRE_IN_CAMP" );
				maps\_utility::missionFailedWrapper();	
				level notify( "mission failed" );
			}
			else
			{
				break;
			}
		}
	}
}

player_camp_disable_weapons()
{
	while( !flag( "player_has_started_course" ) )
	{
		flag_wait( "player_in_camp" );
		level.player disableweapons();
		while( flag( "player_in_camp" ) )
		{
			wait( 1 );
		}
		level.player enableweapons();
	}
	level.player enableweapons();
}

basketball_nag()
{
	level endon( "mission failed" );
	iDialogueLine = 0;
	conversation_orgs = getentarray( "conversation_orgs", "targetname" );
	while( true )
	{
		flag_wait( "player_on_bball_court" );
		while( flag( "player_on_bball_court" ) )
		{
			wait( 2 );
			if ( flag( "player_on_bball_court" ) )
			{
				//Ranger 2		Get off the court dude.	train_ar2_getoffcourt
				//Ranger 2		Come on man, wait your turn.	train_ar2_waityourturn
				//Ranger 2		Allen, what the hell?	train_ar2_allenwhatthe
				if ( iDialogueLine > 2 )
					iDialogueLine = 0;
				org = getclosest( level.player.origin, conversation_orgs );
				org play_sound_in_space( level.scr_sound[ "court_nag_0" + iDialogueLine ] );
				iDialogueLine++;
				wait( randomfloatrange( 8, 12 ) );
			}
			else
			{
				break;
			}
		}
	}
}
