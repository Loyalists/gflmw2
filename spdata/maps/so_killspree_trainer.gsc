#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_hud_util;

main()
{
	level.so_compass_zoom = "close";

	friendlyfire_warnings_off();

	precache_shaders();
	precache_strings();

	level.custom_eog_no_defaults = true;
	level.eog_summary_callback = ::custom_eog_summary;

	level.so_trainer_start = ::start_map;
	maps\trainer::main();

	earned_stars = level.player get_current_stars();

	// Set the proper visionset
	vision_set_fog_changes( "trainer_pit", 0 );

	// setup custom eog summary
	flag_init( "so_player_course_completed" );
	flag_init( "so_killspree_trainer_initialized" );
	flag_init( "kill_too_many_civs" );
	flag_init( "challenge_done" );
	flag_init( "players_died" );
	flag_init( "half_way" );
	flag_init( "timeout" );
	flag_init( "course_initial_targets_dead" );
	flag_init( "course_pre_start_targets_dead" );
	flag_init( "course_pre_end_targets_dead" );
	flag_init( "display_splash" );
	
	flag_set( "so_killspree_trainer_initialized" );

	add_hint_string( "hint_missed_target", &"SO_KILLSPREE_TRAINER_HINT_MISSED_TARGET", ::hint_missed_target_break );
	add_hint_string( "hint_missed_targets", &"SO_KILLSPREE_TRAINER_HINT_MISSED_TARGETS", ::hint_missed_target_break );
	add_hint_string( "hint_missed_target_before_jump", &"SO_KILLSPREE_TRAINER_HINT_MISSED_TARGET_JUMP", ::hint_missed_target_break );
	add_hint_string( "hint_missed_target_before_jumps", &"SO_KILLSPREE_TRAINER_HINT_MISSED_TARGETS_JUMP", ::hint_missed_target_break );
}

precache_shaders()
{
	PrecacheShader( "difficulty_star" );
}

precache_strings()
{
	// Objective
	PrecacheString( &"SO_KILLSPREE_TRAINER_OBJ_MAIN" );

	// HUD
	PrecacheString( &"SO_KILLSPREE_TRAINER_MAX_CIV_KILLS_NORM" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_MAX_CIV_KILLS_HARD" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_MAX_CIV_KILLS_VET" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_AREA_CLEARED" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_CIVILIAN_HIT" );

	// Scoreboard
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_CIVS_SHOT" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_FINAL_TIME" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_FINISH_TIME" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_MISSED_TARGETS" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_NA" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_PLUS" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_TIMETOBEAT" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_SCOREBOARD_DESC_CIVS_HIT" );

	// Dead Quotes
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES1" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES2" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_HINT1" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_HINT2" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_HINT3" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_HINT4" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_HINT5" );

	PrecacheString( &"SO_KILLSPREE_TRAINER_CIVVIES" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_CIVVIES_COUNT" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_ENEMIES" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_ENEMIES_COUNT" );

	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED_HALFWAY" );
	PrecacheString( &"SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED_END" );
}

custom_eog_summary()
{
	foreach ( player in level.players )
	{
		player set_custom_eog_summary( 1, 1, "@SO_KILLSPREE_TRAINER_SCOREBOARD_FINISH_TIME" );
		player set_custom_eog_summary( 2, 1, "@SO_KILLSPREE_TRAINER_SCOREBOARD_ENEMIES_HIT" );
		player set_custom_eog_summary( 3, 1, "@SO_KILLSPREE_TRAINER_SCOREBOARD_CIVS_HIT" );

		earned_stars = player get_current_stars();
		assert( isdefined( earned_stars ) && earned_stars < 4 && earned_stars >= 0 );

		if ( earned_stars < 3 && isdefined( level.finished_time ) )
		{
			if ( level.friendlies_hit != 0 && level.finished_time <= level.race_times[ "veteran" ] )
			{
				player set_custom_eog_summary( 5, 1, "@SO_KILLSPREE_TRAINER_SCOREBOARD_CIVS_KILLED" );
				player set_custom_eog_summary( 5, 2, "@SO_KILLSPREE_TRAINER_SCOREBOARD_CIVS_SPACE" );
			}
			else
			{
				player set_custom_eog_summary( 5, 1, "@SO_KILLSPREE_TRAINER_SCOREBOARD_TIMETOBEAT" );
			}
		}

		if ( flag( "timeout" ) || flag( "kill_too_many_civs" ) || flag( "players_died" ) || !flag( "half_way" ) )
		{
			player set_custom_eog_summary( 1, 2, "@SO_KILLSPREE_TRAINER_SCOREBOARD_NA" );
			player set_custom_eog_summary( 2, 2, player.targets_hit + "/" + level.totalPitEnemies );
			player set_custom_eog_summary( 3, 2, player.friendlies_hit + "/" + level.max_civilian_casualties );
		}
		else
		{
			player set_custom_eog_summary( 1, 2, convert_to_time_string( level.finished_time, true ) );
			player set_custom_eog_summary( 2, 2, player.targets_hit + "/" + level.totalPitEnemies );
			player set_custom_eog_summary( 3, 2, player.friendlies_hit + "/" + level.max_civilian_casualties );

			if ( earned_stars < 3 && level.finished_time > level.race_times[ "veteran" ] )
			{
				time_to_beat = convert_to_time_string( level.race_times[ "veteran" ] );

				if ( earned_stars < 1 )
				{
					time_to_beat = convert_to_time_string( level.race_times[ "normal" ] );
				}
				else if ( earned_stars < 2 )
				{
					time_to_beat = convert_to_time_string( level.race_times[ "hard" ] );
				}

				player set_custom_eog_summary( 5, 2, time_to_beat );
			}
		}
	}
}

start_map()
{
	flag_wait( "so_killspree_trainer_initialized" );

	/*-----------------------
	INITIALIZATION
	-------------------------*/	
	thread fade_challenge_in();
//	level.challenge_civililans_killed = 0;
//	level.missed_enemies_penalty = 0;
//	level.killed_civvies_penalty = 0;

	level.splash_count = 0;
	level.splash_counted = 1;
	level.race_times[ "normal" ] 	= -1; // no limit.
	level.race_times[ "hard" ] 		= 45;
	level.race_times[ "veteran" ] 	= 35;
	level.max_civilian_casualties 	= 5; // UPDATE THE SO_KILLSPREE_TRAINER_CIVVIES_COUNT TO MATCH THIS NUMBER

	foreach ( player in level.players )
	{
		player thread init_stars();
		player.targets_hit = 0;
		player.friendlies_hit = 0;
	}

	melee_clip = getent( "melee_clip", "targetname" );
	melee_clip thread hide_entity();

	init_course_triggers();
	
	if ( IsDefined( level.challenge_time_limit ) )
	{
		level.challenge_time_nudge = int( level.challenge_time_limit / 3 );
		level.challenge_time_hurry = int( level.challenge_time_limit / 6 );
	}
	
	// replaced pawlows with blackhawks to get rid of helicopter in the minimap.
	so_ambient_vehicles();
	array_thread( getstructarray( "delete_heli_node", "script_noteworthy" ), ::delete_heli_node );
	array_thread( GetEntArray( "ai_ambient", "script_noteworthy" ), maps\trainer::AI_delete );
	array_thread( GetEntArray( "translator", "script_noteworthy" ), maps\trainer::AI_delete );
	array_thread( GetEntArray( "trainee_01", "script_noteworthy" ), maps\trainer::AI_delete );
	array_thread( GetAiArray( "allies" ), maps\trainer::AI_delete );

//	level.pitguy delete();

	// display "waiting for other player..." message at end.
	trigger_ent = getent( "end_trigger", "targetname" );
	level thread maps\_specialops_code::wait_all_players_are_touching( trigger_ent );

	// reveal pit weapons
	level thread so_pit_start_sequence();
	
	music_loop( "so_killspree_trainer_music", 500 );

	/*-----------------------
	COURSE LOOP
	-------------------------*/	
	thread so_course_loop_think();

	flag_wait( "challenge_done" );

	if ( flag( "missionfailed" ) )
	{
		return;
	}

	flag_wait( "challenge_timer_passed" );

	waittillframeend;
	calculate_finish();
}
 
calculate_finish()
{
	level.finished_time = ( level.challenge_end_time - level.challenge_start_time ) * 0.001;

	foreach ( player in level.players )
	{
		player.forcedGameSkill = level.star_count;
	}

	fade_challenge_out();
}

//---------------------------------------------------------
// Course Init
//---------------------------------------------------------
init_course_triggers()
{
	so_trigger = GetEnt( "so_player_melee_trigger", "targetname" );
	level thread maps\_load::flag_set_trigger( so_trigger );
	so_trigger trigger_off();

	// Remove thise stair2 trigger, and use the so version
	trigger = get_script_flag_trigger( "player_course_stairs2", so_trigger );
	trigger Delete();

	level.so_end_trigger = get_script_flag_trigger( "so_player_course_end" );
	level.so_end_trigger trigger_off();

	triggers = GetEntArray( "target_trigger", "targetname" );

	foreach ( trigger in triggers )
	{
		trigger.script_linkto_num = int( trigger.script_linkto );

		// Disable the trigger manually, cause trainer.gsc will use trigger_off() / trigger_on()
		// We want to trigger these manually via script depending on how many targets are hit.
		if ( trigger.script_linkto != "1" )
		{
			// Don't have the trigger go back to the realOrigin from trigger_on()
			if ( IsDefined( trigger.realOrigin ) )
			{
				trigger.realOrigin = undefined;
			}

			trigger.origin = trigger.origin + ( 0, 0, -10000 );
		}
	}

	triggers = course_trigger_sort( triggers );

	thread course_trigger_thread( triggers );
}

course_trigger_sort( triggers )
{
	sorted = [];
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 1 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 2 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 3 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 4 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 5 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 14 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 6 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 12 );
	sorted[ sorted.size ] = get_trigger_by_linkto( triggers, 13 );

	return sorted;
}

get_trigger_by_linkto( triggers, num )
{
	foreach ( trigger in triggers )
	{
		if ( trigger.script_linkto_num == num )
		{
			return trigger;
		}
	}
}

course_trigger_thread( triggers )
{
	for( i = 0; i < triggers.size; i++ )
	{
		additional_trigger = undefined;
		trigger = triggers[ i ];

		// Do not notify the first one
		if ( i != 0 )
		{
			trigger notify( "trigger" );
		}

		// 3 and 4 are really close to each other, so treat them as one.
		if ( trigger.script_linkto_num == 3 )
		{
			i++;
			additional_trigger = triggers[ i ];
			additional_trigger notify( "trigger" );
		}

		// Set the half way flag when 12 (after the jump down) is triggered
		if ( trigger.script_linkto_num == 12 )
		{
			flag_set( "half_way" );
		}

		trigger course_trigger_logic( additional_trigger );
		thread so_area_cleared();

		// After 5 is done, we need to enable the stairs trigger
		if ( trigger.script_linkto_num == 5 )
		{
			so_melee_trigger = GetEnt( "so_player_melee_trigger", "targetname" );
			so_melee_trigger trigger_on();
		}
	}
}

so_area_cleared()
{
	wait( 0.05 );
	so_splash( "area_cleared" );
}

so_civilian_hit_hud()
{
	so_splash( "civilian_hit" );
}

so_splash( type )
{
	level.splash_count++;
	num = level.splash_count;

	if ( level.splash_count - level.splash_counted > 0 )
	{
		level waittill( "pre_display_splash" + num );
	} 

	if ( flag( "special_op_terminated" ) )
	{
		return;
	}

	if ( type == "civilian_hit" )
	{
		str = &"SO_KILLSPREE_TRAINER_CIVILIAN_HIT";
	}
	else
	{
		level thread play_sound_in_space( "emt_airhorn_area_clear", level.player.origin + ( 0, 0, 40 ) );
		str = &"SO_KILLSPREE_TRAINER_AREA_CLEARED";
	}

	splash = so_create_hud_item( 2, 0, str );
	splash.alignx = "center";
	splash.horzAlign = "center";
	splash.fontscale = 2;

	if ( type == "civilian_hit" )
	{
		splash set_hud_red();
	}
	else
	{
		splash set_hud_yellow();
	}
	
	wait( 0.2 );
	time = 1;
	splash FadeOverTime( time );
	splash.alpha = 0;
	
	splash ChangeFontScaleOverTime( time );
	splash.fontscale = 0.5;
	
	wait( time * 0.75 );

	level notify( "pre_display_splash" + ( num + 1 ) );
	level.splash_counted++;

	wait( time * 0.25 );
	
	splash Destroy();
}

course_trigger_logic( additional_trigger )
{
	enemy_target_count = self.targetsEnemy.size;

	if ( IsDefined( additional_trigger ) )
	{
		enemy_target_count += additional_trigger.targetsEnemy.size;
	}
 
	while ( enemy_target_count > 0 )
	{
		level waittill( "target_killed" );
		enemy_target_count--;
	}
}

get_script_flag_trigger( str, exclude )
{
	array = GetEntArray( "trigger_multiple_flag_set_touching", "classname" );
	array = array_combine( array, GetEntArray( "trigger_multiple_specialops_flag_set", "classname" ) );
	array = array_combine( array, GetEntArray( "trigger_multiple_flag_set", "classname" ) );	

	foreach ( ent in array )
	{
		if ( IsDefined( exclude ) && exclude == ent )
		{
			continue;
		}

		if ( IsDefined( ent.script_flag ) && ent.script_flag == str )
		{
			return ent;
		}
	}

	return undefined;
}

//---------------------------------------------------------
// Kill Threads
//---------------------------------------------------------
civilian_kill_thread()
{
	level endon( "mission failed" );
	level endon( "special_op_terminated" );
	level endon( "challenge_done" );

	count = 0;
	while ( 1 )
	{
		level waittill( "civilian_killed" );

		count++;
		level notify( "civilian_killed_" + count );

		so_civilian_hit_hud();

//		maps\_specialops::info_hud_decrement_timer( level.so_civ_deduction );

		foreach ( player in level.players )
		{
			player.HUDcivviesKilled setValue( level.friendlies_hit );
		}

		if ( level.friendlies_hit >= level.max_civilian_casualties )
		{
			flag_set( "kill_too_many_civs" );

			set_failure_quote( "friendlies" );
			missionFailedWrapper();
			return;
		}
	}
}

enemy_kill_thread()
{
	level endon( "mission failed" );
	level endon( "special_op_terminated" );
	level endon( "challenge_done" );

	while ( 1 )
	{
		level waittill( "target_killed" );
		
		foreach ( player in level.players )
		{
			player.HUDenemiesKilled setValue( level.targets_hit );
			if ( level.targets_hit == level.totalPitEnemies )
			{
				player.HUDenemiesKilled thread so_hud_pulse_success();
				player.HUDenemies thread so_hud_pulse_success();
			}
		}
	}
}

so_pit_start_sequence()
{
	level thread pit_cases_and_door();

	level.pitguy.animnode anim_first_frame( level.pitcases, "training_pit_open_case" );

	foreach( pitcase in level.pitcases )
	{
		animation = pitcase getanim( "training_pit_open_case" );
		pitcase SetAnimknob( animation, 1, 0 );
		pitcase SetAnimTime( animation, 1 );
	}
}

pit_cases_and_door()
{
	/*-----------------------
	PIT GUY OPENS CASE AND SHOWS MORE WEAPONRY
	-------------------------*/	
	level.pit_case_01 playsound( "scn_trainer_case_open1" );	
	pit_weapons_case_01 = getentarray( "pit_weapons_case_01", "script_noteworthy" );
	array_thread( pit_weapons_case_01, maps\trainer::weapons_show );
	
	level.pit_case_02 playsound( "scn_trainer_case_open2" );
	pit_weapons_case_02 = getentarray( "pit_weapons_case_02", "script_noteworthy" );
	array_thread( pit_weapons_case_02, maps\trainer::weapons_show );
	
	level.gate_cqb_enter thread maps\trainer::door_open();
}

so_ambient_vehicles()
{
	path_arr = getstructarray( "blackhawk_path", "script_noteworthy" );
	heli_arr = getentarray( "heli_group_01", "targetname" );
	
	blackhawk = undefined;
	foreach( heli in heli_arr )
	{
		if ( heli.classname == "script_vehicle_blackhawk_low" )
		{
			blackhawk = heli;
			break;
		}
	}

	foreach( path in path_arr )
	{
		// move, spawn and go one heli per path
		blackhawk move_spawn_and_go( path );
		wait 0.15; // to awoid spawning from the same spawner on the same frame.
	}
}

player_death_watch()
{
	level endon( "so_special_failure_hint_set" );
	self waittill( "death", attacker, cause );
	flag_set( "players_died" );
}

so_course_loop_think()
{
	level endon( "clear_course" );
	level endon( "mission failed" );
	level endon( "special_op_terminated" );

	SetDvar( "killhouse_too_slow", "0" );

	level.first_time = true;
	maps\trainer::clear_hints();

	// stop infinite ammo for player 1.
	flag_set( "button_press" );

	level thread civilian_kill_thread();
	level thread enemy_kill_thread();
	level thread course_completion_thread();
	array_thread( level.players, ::player_death_watch );

	/*-----------------------
	COURSE LOOPS
	-------------------------*/	
	
	/*-----------------------
	COURSE OBJECTIVE
	-------------------------*/	
	if( level.first_time )
	{
		maps\trainer::registerObjective( "obj_course", &"SO_KILLSPREE_TRAINER_OBJ_MAIN", getEnt( "origin_course_01", "targetname" ) );
		maps\trainer::setObjectiveState( "obj_course", "current" );
	}
	
	/*-----------------------
	RESET CQB COURSE AND OPEN DOOR
	-------------------------*/
	course_triggers_01 = getentarray( "course_triggers_01", "script_noteworthy" );
	array_notify( course_triggers_01, "activate" );

	/*-----------------------
	COURSE START
	-------------------------*/
	level.challenge_time_force_on = true;
	enable_challenge_timer( "player_has_started_course" , "so_player_course_completed" );
	array_thread( level.players, ::display_counters );
	flag_wait( "player_has_started_course" );

	flag_clear( "melee_target_hit" );
	level.targets_hit_with_melee = 0;

//	thread maps\trainer::target_flag_management();
	thread so_target_flag_management();
	if( level.first_time )
	{
		thread maps\trainer::dialogue_course_civilian_killed();	
		delaythread ( 3, maps\trainer::dialogue_ambient_pit_course );
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
	foreach( player in level.players )
	{
		playerPrimaryWeapons = player GetWeaponsListPrimaries();
		if ( playerPrimaryWeapons.size > 0 )
		{
			foreach ( weapon in playerPrimaryWeapons )
				player givemaxammo( weapon );
		}
	}

	level.targets_hit = 0;
	level.friendlies_hit = 0;
	level.missed_targets = 0;

	thread maps\trainer::accuracy_bonus();

	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_02", "targetname" ) );

	flag_wait( "player_course_03a" );
	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_03", "targetname" ) );
	
	/*-----------------------
	MELEE TARGET
	-------------------------*/	
	flag_wait( "player_course_stairs2" );

//	thread maps\trainer::key_hint_till_flag_set( "melee", "melee_target_hit" );
	so_melee_hint();
	
	flag_wait( "player_course_upstairs" );

	thread course_gate_controll();
	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_03a", "targetname" ) );
	
	flag_wait( "player_course_jumping_down" );
	maps\trainer::setObjectiveLocation( "obj_course", getEnt( "origin_course_05", "targetname" ) );

	level.gate_cqb_enter thread maps\trainer::door_open();

	/*-----------------------
	COURSE END
	-------------------------*/	
	flag_wait( "so_player_course_completed" );
	maps\trainer::clear_hints();

	thread maps\trainer::reset_course_targets();
//	level.gate_cqb_exit thread maps\trainer::door_close();

	maps\trainer::clear_hints();

	level notify ( "test_cleared" );

	maps\trainer::setObjectiveState( "obj_course", "done" );
	maps\trainer::clear_timer_elems();

	flag_set( "challenge_done" );
}

// --------------------------------------------------------
// Target Flag Management copied from Trainer without the endon
// --------------------------------------------------------
so_target_flag_management()
{
	so_waittill_targets_killed( 3, "course_initial_targets_dead" );

	so_waittill_targets_killed( 2, "course_pre_start_targets_dead" );

	so_waittill_targets_killed( 5, "course_start_targets_dead" );
	
	so_waittill_targets_killed( 3, "course_first_floor_targets_dead" );
	
	so_waittill_targets_killed( 5, "course_second_floor_targets_dead" );

	so_waittill_targets_killed( 4, "course_pre_end_targets_dead" );

	so_waittill_targets_killed( 2, "course_end_targets_dead" );
}

so_waittill_targets_killed( iNumberOfTargets, sFlagToSetWhenKilled )
{
	iTargetsKilled = 0;

	while( iTargetsKilled < iNumberOfTargets )
	{
		level waittill( "target_killed" );
		iTargetsKilled++;
	}

	flag_set( sFlagToSetWhenKilled );
}

so_melee_hint()
{
	foreach ( player in level.players )
	{
		player thread so_melee_hint_thread();
	}
}

add_client_hint_background( double_line )
{
	if ( IsDefined( double_line ) )
	{
		self.hintbackground = self createClientIcon( "popmenu_bg", 650, 50 );
	}
	else
	{
		self.hintbackground = self createClientIcon( "popmenu_bg", 650, 30 );
	}

	self.hintbackground.hidewheninmenu = true;
	self.hintbackground setPoint( "TOP", undefined, 0, 105 );
	self.hintbackground.alpha = 1;
	self.hintbackground.sort = 0;
}

so_melee_hint_thread()
{
	maps\trainer::clear_hints();
	self add_client_hint_background();
	self.hintbackground.alpha = 0;

	self.hintElem = self createClientFontString( "objective", level.hint_text_size );
	self.hintElem.hidewheninmenu = true;
	self.hintElem setPoint( "TOP", undefined, 0, 110 );
	self.hintElem.sort = 0.5;
	self.hintElem.alpha = 0;
	self.hintElem setText( &"TRAINER_HINT_MELEE" );

	trigger = GetEnt( "so_player_melee_trigger", "targetname" );
	while ( !flag( "melee_target_hit" ) )
	{
		if ( self IsTouching( trigger ) )
		{
			self.hintElem.alpha = 1;
			self.hintbackground.alpha = 0.5;
		}
		else
		{
			self.hintElem FadeOverTime( 0.5 );
			self.hintElem.alpha = 0;

			self.hintbackground FadeOverTime( 0.5 );
			self.hintbackground.alpha = 0;
		}

		wait( 0.25 );
	}

	self.hintElem FadeOverTime( 0.5 );
	self.hintElem.alpha = 0;
	wait ( 0.5 );

	self clear_client_hints();
}

clear_client_hints()
{
	if ( IsDefined( self.hintElem ) )
	{
		self.hintElem destroyElem();
	}

	if ( IsDefined( self.iconElem ) )
	{
		self.iconElem destroyElem();
	}

	if ( IsDefined( self.iconElem2 ) )
	{
		self.iconElem2 destroyElem();
	}

	if ( IsDefined( self.iconElem3 ) )
	{
		self.iconElem3 destroyElem();
	}

	if ( IsDefined( self.hintbackground ) )
	{
		self.hintbackground destroyElem();
	}

	self notify( "clearing_hints" );
}

course_completion_thread()
{
	// "so_pre_jump" trigger just before the jump down
//	flag_wait( "so_pre_jump" );
//	if ( level.targets_hit < 18 )
//	{
//		iprintlnbold( "You missed a target, go back before you jump down!" );
//	}

	// will clear the finnish line trigger once both players is passed the halfway drop down.
	flag_wait( "so_player_course_jumped_down" ); // requires all players to trigger the trigger to set the flag.

	// Make sure all of the targets leading up to here are hit, otherwise fail
	if ( !flag( "half_way" ) )
	{
		set_failure_quote( "missed_targets" );
		missionFailedWrapper();
		return;
	}

	flag_clear( "so_player_course_end" );

	flag_wait( "so_player_course_end" );  // requires all players to trigger the trigger to set the flag.

	if ( level.targets_hit < level.totalPitEnemies )
	{
		level.star_count = 0;
		level.finished_time = ( GetTime() - level.challenge_start_time ) * 0.001;
		set_failure_quote( "missed_targets_end" );
		missionFailedWrapper();
		return;
	}	
	else
	{
		flag_set( "so_player_course_completed" ); // this is the flag that completes the challenge.		
	}
}

course_gate_controll()
{
	level.gate_cqb_exit thread maps\trainer::door_open();

	// open gate after both players passed the middle of the course.
	flag_wait( "so_player_course_jumped_down" );
	level.gate_cqb_enter thread maps\trainer::door_close();

	// Wait until all of the targets are down before opening the gate.
	flag_wait( "course_end_targets_dead" );

	level.so_end_trigger trigger_on();

	ents = getentarray( "gate_cqb_exit", "targetname" );
	foreach ( ent in ents )
	{
		if ( ent.code_classname == "script_brushmodel" )
		{
			ent NotSolid();
			continue;
		}
	}
}

display_counters()
{
	ypos = so_hud_ypos();
	
	self.HUDenemies = so_create_hud_item( 3, ypos, &"SO_KILLSPREE_TRAINER_ENEMIES", self );	
	self.HUDcivvies = so_create_hud_item( 4, ypos, &"SO_KILLSPREE_TRAINER_CIVVIES", self );	

	self.HUDenemiesKilled = so_create_hud_item( 3, ypos, &"SO_KILLSPREE_TRAINER_ENEMIES_COUNT", self );
	self.HUDenemiesKilled setValue( level.targets_hit );
	self.HUDenemiesKilled.alignx = "left";
	
	self.HUDcivviesKilled = so_create_hud_item( 4, ypos, &"SO_KILLSPREE_TRAINER_CIVVIES_COUNT", self );
	self.HUDcivviesKilled setValue( level.friendlies_hit );
	self.HUDcivviesKilled.alignx = "left";

//	self thread info_hud_handle_fade( self.HUDenemies );
//	self thread info_hud_handle_fade( self.HUDcivvies );
//	self thread info_hud_handle_fade( self.HUDenemiesKilled );
//	self thread info_hud_handle_fade( self.HUDcivviesKilled );
	
	level waittill( "special_op_terminated" );

//	set_failure_quote();
	
	self.HUDenemies thread so_remove_hud_item();
	self.HUDcivvies thread so_remove_hud_item();
	self.HUDenemiesKilled thread so_remove_hud_item();
	self.HUDcivviesKilled thread so_remove_hud_item();
}

set_failure_quote( type )
{
	quotes = [];
	force = false;
	if ( type == "friendlies" )
	{
		force = true;
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES1";
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES2";
	}
	else if ( type == "missed_targets" )
	{
		force = true;
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED_HALFWAY";
	}
	else if ( type == "missed_targets_end" )
	{
		force = true;
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_MISSED_END";
	}
	else if ( type == "timeout" )
	{
		force = true;
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_TIMEOUT";
	}
	else if ( type == "hint" )
	{
		force = true;
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES1";
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_FRIENDLIES2";
	}

	if ( quotes.size == 0 && cointoss() )
	{
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_HINT1";
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_HINT2";
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_HINT3";
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_HINT4";
		quotes[ quotes.size ] = "@SO_KILLSPREE_TRAINER_DEADQUOTE_HINT5";
	}

	if ( force && quotes.size > 0 )
	{
		so_force_deadquote_array( quotes );
	}
	else if ( quotes.size > 0 )
	{
		so_include_deadquote_array( quotes );
	}
}

move_spawn_and_go( path_ent )
{
	self.origin = path_ent.origin;
	if ( IsDefined( path_ent.angles ) )
		self.angles = path_ent.angles;

	// changes targetname of ai so that they to can spawn
	other_ents = getentarray( self.target, "targetname" );
	foreach( ent in other_ents )
	{
		if ( isspawner( ent ) )
			ent.targetname = path_ent.targetname;
	}

	self.target = path_ent.targetname;

	vehicle = self thread maps\_vehicle::spawn_vehicle_and_gopath();

	return vehicle;
}

delete_heli_node()
{
	self waittill( "trigger", heli );
	heli delete();
}

//---------------------------------------------------------
// Stars
//---------------------------------------------------------

init_stars()
{
	level.star_count = 3;
	self thread star_challenge_hud( 0, level.race_times[ "normal" ], 	5, 0 );
	self thread star_challenge_hud( 1, level.race_times[ "hard" ], 		5, 1 );
	self thread star_challenge_hud( 2, level.race_times[ "veteran" ], 	1, 2 );
}

star_challenge_hud( x_pos_offset, removeTimer, civ_kill_num, next_star_count )
{
	level endon( "challenge_done" );
	level endon( "missionfailed" );

	star_width = 25;
	ypos = so_hud_ypos();
	
	star = so_create_hud_item( 5, ypos, undefined, self );
	star.x -= ( x_pos_offset * star_width ) - 30;
	star.y += 5;
	star SetShader( "difficulty_star", 25, 25 );
	
	flag_wait( "player_has_started_course" );
	
	self thread star_challenge_force_alpha_at_finish( star );

	// don't remove a start if timelimit is less then 0
	if ( removeTimer < 0 )
	{
		return;
	}

	self thread star_challenge_sound_and_flash( star, removeTimer );
	level waittill_any_timeout( removeTimer, "civilian_killed_" + civ_kill_num );

	if ( flag( "challenge_done" ) )
	{
		return;
	}

	level.star_count = next_star_count;	
	star Destroy();
}

star_challenge_sound_and_flash( star, removeTimer )
{
	star endon( "death" );
	self endon( "finish_line" );
	level endon( "challenge_done" );
	level endon( "missionfailed" );
	
	secondsToTick = 5;
	timeToWait = removeTimer - secondsToTick;
	assert( timeToWait > 0 );
	
	wait( timeToWait );
	
	for( i = 0 ; i < secondsToTick ; i++ )
	{
		self PlayLocalSound( "so_snowrace_star_tick" );

		star.alpha = 1;
		wait( 0.5 );

		star.alpha = 0.3;
		wait( 0.5 );
	}

	self PlayLocalSound( "so_snowrace_star_lost" );
}

star_challenge_force_alpha_at_finish( star )
{
	star endon( "death" );

	flag_wait( "challenge_done" );
	waittillframeend;
	star.alpha = 1;
}

get_current_stars()
{
	// run on player
	levelIndex = level.specOpsSettings maps\_endmission::getLevelIndex( level.script );

	stars = int( ( self GetLocalPlayerProfileData( "missionSOHighestDifficulty" ))[ levelIndex ] );
	stars = max( 0, stars - 1 );

	return stars;
}

dialogue_course()
{
	flag_wait( "player_has_started_course" );
	thread maps\trainer::dialogue_course_reload_nag();
	/*-----------------------
	COURSE START
	-------------------------*/	
	//Cpl. Dunn	Clear the first area. Go! Go! Go!	
	thread do_course_dialogue( "train_cpd_clearfirstgogogo" );

	// Disable all of the course progression triggers
	triggers = GetEntArray( "so_course_progression_triggers", "targetname" );
	array_thread( triggers, ::trigger_off );

	// --------------------------------
	// Just after first set of Targets
	// --------------------------------
	target_count 	= 3;
	flag_trigger 	= "so_course_after_start";
	flag_targets 	= "course_initial_targets_dead";
	hint_type 		= "hint_missed_target";
	sound_alias 	= "nag_hurry_01"; //Cpl. Dunn	Keep moving forward!
	course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_type, sound_alias );

	// -------------------------------
	// After 2nd set of targets
	// -------------------------------
	target_count 	+= 2;
	flag_trigger 	= "so_course_before_building";
	flag_targets 	= "course_pre_start_targets_dead";
	hint_type 		= "hint_missed_target";
	sound_alias 	= "nag_hurry_01"; //Cpl. Dunn	Keep moving forward!
	course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_type, sound_alias );

	/*-----------------------
	FIRST AREA CLEARED/PASSED BY
	-------------------------*/	
	target_count 	+= 5;
	flag_trigger 	= "so_course_in_building";
	flag_targets 	= "course_start_targets_dead";
	hint_type 		= "hint_missed_target";
	sound_alias 	= "train_cpd_areacleared"; 	//Cpl. Dunn	Area cleared! Move into the building!
	course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_type, sound_alias );

	/*-----------------------
	SECOND AREA CLEARED/PASSED BY
	-------------------------*/	
	target_count 	+= 3;
	flag_trigger 	= "so_course_stairs";
	flag_targets 	= "course_first_floor_targets_dead";
	hint_type 		= "hint_missed_target";
	sound_alias 	= "train_cpd_upthestairs"; 	//Cpl. Dunn	Up the stairs!
	course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_type, sound_alias );

	/*-----------------------
	UP THE STAIRS
	-------------------------*/	
	flag_wait( "player_course_stairs2" );
	//Cpl. Dunn  Melee with your knife!	
	radio_dialogue( "train_cpd_melee" );

	/*-----------------------
	SECOND FLOOR CLEARED/PASSED BY
	-------------------------*/	
	target_count 	+= 5;
	flag_trigger 	= "so_course_pre_jump";
	flag_targets 	= "course_second_floor_targets_dead";
	hint_type 		= "hint_missed_target_before_jump";
	sound_alias 	= "train_cpd_jumpdown"; 	//Cpl. Dunn	Area cleared! Jump down!
	course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_type, sound_alias );

	flag_wait_or_timeout( "player_course_jumped_down", 5 );
	{
		if ( !flag( "player_course_jumped_down" ) )
		{
			//Cpl. Dunn	Move! This is a timed course!
			thread do_course_dialogue( "nag_hurry_00" );
		}
	}

	/*-----------------------
	LAST AREA
	-------------------------*/	
	target_count 	+= 4;
	flag_trigger 	= "so_course_post_jump";
	flag_targets 	= "course_pre_end_targets_dead";
	hint_type 		= "hint_missed_target";
	sound_alias 	= "train_cpd_lastareamove"; 	//Cpl. Dunn	Last area! Move! Move!	
	course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_type, sound_alias );

	/*-----------------------
	SPRINT TO FINISH
	-------------------------*/
	target_count 	+= 2;
	flag_trigger 	= "so_course_end";
	flag_targets 	= "course_end_targets_dead";
	hint_type 		= "hint_missed_target";
	sound_alias 	= "";
	course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_type, sound_alias );

	flag_wait( "course_end_targets_dead" );	
	//Cpl. Dunn  Sprint to the exit! Clock's ticking!
	thread do_course_dialogue( "train_cpd_sprint" );
}

course_progression_dialogue( flag_trigger, flag_targets, target_count, hint_msg, sound_alias )
{
	trigger = get_script_flag_trigger( flag_trigger );
	trigger trigger_on();

	flag_wait_either( flag_trigger, flag_targets );
	if ( !flag( flag_targets ) )
	{
		course_missed_targets( trigger, flag_targets, hint_msg, target_count );
		flag_wait( flag_targets );
	}

	if ( sound_alias != "" )
	{
		thread do_course_dialogue( sound_alias );
	}
}

course_missed_targets( trigger, flag_targets, hint_msg, target_count )
{
	if ( flag( "display_splash" ) )
	{
		flag_waitopen( "display_splash" );
	}

	foreach ( player in level.players )
	{
		player.hint_missed_targets = false;
	}

	if ( target_count - level.targets_hit > 1 )
	{
		thread hint_missed_target( trigger, flag_targets, hint_msg + "s" );
	}
	else
	{
		thread hint_missed_target( trigger, flag_targets, hint_msg );
	}
}

do_course_dialogue( alias )
{
	if ( flag( "can_talk" ) )
	{
		flag_clear( "can_talk" );
		radio_dialogue( alias );
		flag_set( "can_talk" );	
	}
}

hint_missed_target( trigger, flag_msg, hint_type )
{
	level notify( "stop_hint_missed_target" );
	level endon( "stop_hint_missed_target" );

	// Since HintPrintWait() in _utility_code does not support break params, this is a work-around
	level.hint_break_flag = flag_msg;

	while ( 1 )
	{
		foreach ( player in level.players )
		{
			if ( player IsTouching( trigger ) && !player.hint_missed_targets )
			{
				player.hint_missed_targets = true;
				player thread display_hint_timeout( hint_type );
			}
		}

		wait( 0.1 );
	}
}

hint_missed_target_break()
{
	if ( flag( level.hint_break_flag ) )
	{
		return true;
	}

	return false;
}