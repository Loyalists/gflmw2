#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;

CONST_regular_obj	= &"SO_FOREST_CONTINGENCY_OBJ_REGULAR";
CONST_hardened_obj	= &"SO_FOREST_CONTINGENCY_OBJ_HARDENED";
CONST_veteran_obj	= &"SO_FOREST_CONTINGENCY_OBJ_VETERAN";

//	penalty seconds per kill
CONST_kill_penalty	= 10;
//	Time multiplier when out of stealth.
CONST_stealth_multiplier	= 3;

main()
{
	// optimization
	setsaveddvar( "sm_sunShadowScale", 0.5 );
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.5 );
	setsaveddvar( "r_lightGridContrast", 0 );
	
	level._effect[ "extraction_smoke" ] = loadfx( "smoke/signal_smoke_green" );
	
//	level.custom_eog_no_time = true;
//	level.custom_eog_no_skill = true;
//	level.custom_eog_no_kills = true;

	// custom eog summary added timebonus for enemies NOT killed.
//	level.eog_summary_callback = ::custom_eog_summary;

	// delete certain non special ops entities
	so_delete_all_by_type( ::type_vehicle );
	thread remove_dead_trees();
	thread remove_extra_vehicles();
	
	default_start( ::start_so_forest );
	add_start( "so_forest", ::start_so_forest );
	
	flag_init( "forest_success" );
//	flag_init( "forest_success_time_updated" );
	flag_init( "escaped_trigger" );
	flag_init( "stop_stealth_music" );
	flag_init( "someone_became_alert" );
	flag_init( "so_forest_contingency_start" );
	flag_init( "enemy_killed" );

	thread stealth_achievement();
//	thread stealth_achievement_end();
	
	// init stuff
	maps\contingency_precache::main();
	maps\createart\contingency_fog::main();
	maps\contingency_fx::main();
	maps\contingency_anim::main_anim();
	
	maps\_load::main();
	
	maps\_load::set_player_viewhand_model( "viewhands_player_arctic_wind" );
	thread maps\contingency_amb::main();
	maps\createart\contingency_art::main();
	
	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();
	
	animscripts\dog\dog_init::initDogAnimations();
	maps\_patrol_anims::main();

	//SILENCER ADVICE ----
	//Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
	level.scr_radio[ "so_for_cont_pri_attractattn" ]		= "so_for_cont_pri_attractattn";

	// original contingency threat bias setup
	threat_bias_code();

	maps\_stealth::main();
	stealth_settings();
	thread stealth_music_control();
	
	thread dialog_we_are_spotted_wrapper();
	thread dialog_stealth_recovery_wrapper();
	thread dialog_player_kill_master_wrapper();
	array_thread( level.players, ::dialog_unsilenced_weapons );

	foreach ( player in level.players )
	{
		player stealth_plugin_basic();
		player thread playerSnowFootsteps();
	}

	maps\_compass::setupMiniMap( "compass_map_contingency" );	
}

stealth_achievement()
{
	flag_init( "broke_stealth" );
	
	wait 1;
	
	flag_wait_any( "_stealth_spotted", "someone_became_alert" );
	flag_set( "broke_stealth" );
}

stealth_achievement_end()
{
	flag_wait( "forest_success" );
	
	if ( !flag( "broke_stealth" ) && !flag( "enemy_killed" ) )
	{
		foreach( player in level.players )
			player maps\_utility::player_giveachievement_wrapper( "SPECTER" );	
	}
}

remove_extra_vehicles()
{
	remove_ents = getentarray( "cargo1_group2", "targetname" );
	remove_ents = array_merge( remove_ents, getentarray( "cargo2_group2", "targetname" ) );
	remove_ents = array_merge( remove_ents, getentarray( "cargo3_group2", "targetname" ) );
	foreach( ent in remove_ents )
		ent Delete();
}

remove_dead_trees()
{
	dead_trees = getentarray( "destroyable_tree_base", "script_noteworthy" );
	foreach( dead_tree in dead_trees )
	{
		dead_parts = getentarray( dead_tree.target, "targetname" );
		if( isdefined( dead_parts ) )
			foreach( part in dead_parts ) part delete();
	}
}

so_setup_regular()
{
	level.challenge_objective 	= CONST_regular_obj;
	level.new_enemy_accuracy	= 1;

// noteworthy: two_on_right - remove.
// noteworthy: cqb_patrol - remove two with targetname first_patrol_cqb.
// noteworthy: regular_remove - remove

	spawner_array = getentarray( "two_on_right", "script_noteworthy" );
	spawner_array = array_combine( spawner_array, getentarray( "regular_remove", "script_noteworthy" ) ); 

	array = getentarray( "cqb_patrol", "script_noteworthy" );
	add_count = 0;
	foreach( spawner in array )
	{
		if ( spawner.targetname == "first_patrol_cqb" )
		{
			spawner_array = array_add( spawner_array, spawner );
			add_count++; 
		}
		if ( add_count >= 2 )
			break;
	}

	foreach( spawner in spawner_array )
	{
		spawner.count = 0;
	}

/*	spawners = getspawnerarray();
	first_third = false;
	second_third = true;
	third_third = false;

	foreach( spawner in spawners )
	{
		if( isdefined( spawner.script_pet ) )
			continue;
		if( first_third )
		{
			spawner.count = 0;
			first_third = false;
			second_third = true;
			third_third = false;
			continue;
		}
		if( second_third )
		{
//			spawner.count = 0;
			first_third = false;
			second_third = false;
			third_third = true;
			continue;
		}
		if( third_third )
		{
			first_third = false;
			second_third = false;
			third_third = false;
			continue;
		}
	}
*/
}

so_setup_hardened()
{
	level.challenge_objective 	= CONST_hardened_obj;
	level.new_enemy_accuracy 	= 1.75;
}

so_setup_veteran()
{
	level.challenge_objective 	= CONST_veteran_obj;
	level.new_enemy_accuracy	= 1.75;
}

so_forest_init()
{
	add_global_spawn_function( "axis", ::enemy_nerf );

	level.enemies_killed = 0;

	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:								// Easy
		case 1:	so_setup_Regular();	break;	// Regular
		case 2:	so_setup_hardened();break;	// Hardened
		case 3:	so_setup_veteran();	break;	// Veteran
	}

	escape_trig = getent( "escaped_trigger", "script_noteworthy" );
	escape_obj_origin = getent( escape_trig.target, "targetname" ).origin;
	Objective_Add( 1, "current", level.challenge_objective, escape_obj_origin );
	playFX( getfx( "extraction_smoke" ), escape_obj_origin );

	deadquotes = [];
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_LOOK_FOR_ENEMIES";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_STAY_LOW";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_USE_SILENCERS";
	so_include_deadquote_array( deadquotes );
	
	thread enable_escape_warning();
	thread enable_escape_failure();

//	thread penalty_timer();
//	level.challenge_time_force_on = true;
	thread enable_challenge_timer( "so_forest_contingency_start", "forest_success" );
	thread enable_triggered_complete( "escaped_trigger", "forest_success", "all" );

	thread fade_challenge_out( "forest_success" );
}

enemy_nerf()
{
	self.baseaccuracy = level.new_enemy_accuracy;
}

start_so_forest()
{
	so_forest_init();
	
	// ----- modified original contingency functions -----
	maps\contingency::sight_ranges_foggy_woods();
	thread maps\contingency::dialog_russians_looking_for_you();
	thread woods_first_patrol_cqb();
	thread woods_second_dog_patrol();
	
	thread fade_challenge_in();
}

// ==================================================================================
// ======================= modified functions from contingency ======================
// ==================================================================================

stealth_settings()
{
	stealth_set_default_stealth_function( "woods", ::stealth_woods );

	ai_event = [];
	ai_event[ "ai_eventDistNewEnemy" ] = [];
	ai_event[ "ai_eventDistNewEnemy" ][ "spotted" ]		 = 512;
	ai_event[ "ai_eventDistNewEnemy" ][ "hidden" ] 		 = 256;

	ai_event[ "ai_eventDistExplosion" ] = [];
	ai_event[ "ai_eventDistExplosion" ][ "spotted" ]	 = level.explosion_dist_sense;
	ai_event[ "ai_eventDistExplosion" ][ "hidden" ] 	 = level.explosion_dist_sense;

	ai_event[ "ai_eventDistDeath" ] = [];
	ai_event[ "ai_eventDistDeath" ][ "spotted" ] 		 = 512;
	ai_event[ "ai_eventDistDeath" ][ "hidden" ] 		 = 512; // used to be 256
	
	ai_event[ "ai_eventDistPain" ] = [];
	ai_event[ "ai_eventDistPain" ][ "spotted" ] 		 = 256;
	ai_event[ "ai_eventDistPain" ][ "hidden" ] 		 	 = 256; // used to be 256
	
	ai_event[ "ai_eventDistBullet" ] = [];
	ai_event[ "ai_eventDistBullet" ][ "spotted" ]		 = 96;
	ai_event[ "ai_eventDistBullet" ][ "hidden" ] 		 = 96;
	
	ai_event[ "ai_eventDistFootstep" ] = [];
	ai_event[ "ai_eventDistFootstep" ][ "spotted" ]		 = 300;
	ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 		 = 300;

	ai_event[ "ai_eventDistFootstepWalk" ] = [];
	ai_event[ "ai_eventDistFootstepWalk" ][ "spotted" ]	 = 300;
	ai_event[ "ai_eventDistFootstepWalk" ][ "hidden" ] 	 = 300;

	ai_event[ "ai_eventDistFootstepSprint" ] = [];
	ai_event[ "ai_eventDistFootstepSprint" ][ "spotted" ]	 = 400;
	ai_event[ "ai_eventDistFootstepSprint" ][ "hidden" ] 	 = 400;

	stealth_ai_event_dist_custom( ai_event );
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 800;
	rangesHidden[ "crouch" ]	= 1200;
	rangesHidden[ "stand" ]		= 1600;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 8192;
	rangesSpotted[ "crouch" ]	= 8192;
	rangesSpotted[ "stand" ]	= 8192;

	stealth_detect_ranges_set( rangesHidden, rangesSpotted );
	stealth_alert_level_duration( 0.5 );	
	stealth_ai_event_dist_custom( ai_event );

	array = [];
	array[ "sight_dist" ]	 = 400;
	array[ "detect_dist" ]	 = 200;
	stealth_corpse_ranges_custom( array );
}

threat_bias_code()
{
	createThreatBiasGroup( "bridge_guys" );
	createThreatBiasGroup( "truck_guys" );
	createThreatBiasGroup( "bridge_stealth_guys" );
	createThreatBiasGroup( "dogs" );
	createThreatBiasGroup( "price" );
	createThreatBiasGroup( "player" );
	createThreatBiasGroup( "end_patrol" );
	level.player setthreatbiasgroup( "player" );
	SetIgnoreMeGroup( "price", "dogs" );
	setthreatbias( "player", "bridge_stealth_guys", 1000 );
	setthreatbias( "player", "truck_guys", 1000 );
}

woods_second_dog_patrol()
{
	level endon( "special_op_terminated" );

	flag_wait( "dialog_woods_second_dog_patrol" );
	
	if( flag( "someone_became_alert" ) )
		return;

	end_patrol = getentarray( "end_patrol", "targetname" );
	foreach( guy in end_patrol )
	{
		if( isalive( guy ) )
			guy.threatbias = 10000;
	}
}

woods_first_patrol_cqb()
{
	level endon( "special_op_terminated" );

	flag_wait( "first_patrol_cqb" );
	first_patrol_cqb = getentarray( "first_patrol_cqb", "targetname" );
	foreach( guy in first_patrol_cqb )
		guy spawn_ai();	
}

stealth_woods()
{
	level endon( "special_op_terminated" );

	if ( !isdefined( level.woods_enemy_count ) )
		level.woods_enemy_count = 0;

	self stealth_plugin_basic();

	if ( isplayer( self ) )
		return;

	switch( self.team )
	{
		case "axis":
			if( self.type == "dog" )
			{
				self thread maps\contingency::dogs_have_small_fovs_when_stopped();
				self 		maps\contingency::set_threatbias_group( "dogs" );
			}
			else
			{
				level.woods_enemy_count++;
				self thread maps\contingency::attach_flashlight();
			}
			if( isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "cqb_patrol" ) )
			{
				if( isdefined( self.script_patroller ) )
				{
					wait .05;
					self clear_run_anim();
				}
				self thread enable_cqbwalk();
				self.moveplaybackrate = .8;
			}
			self.pathrandompercent = 0;
			self stealth_plugin_threat();
			self stealth_pre_spotted_function_custom( ::woods_prespotted_func );

			threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			threat_array[ "attack" ] = ::small_goal_attack_behavior;//default
			self stealth_threat_behavior_custom( threat_array );
			
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			self.baseaccuracy = 2;
			self.fovcosine = .5;	
			self.fovcosinebusy = .1;
			
			self thread monitor_stealth_kills();
			self thread maps\contingency::monitor_someone_became_alert();
			self maps\contingency::init_cold_patrol_anims();
			
			break;

		case "allies":
			//use the bridge area settings!
	}
}

Small_Goal_Attack_Behavior()
{
	level endon( "special_op_terminated" );

	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	
	self.goalradius = 400;

	self endon( "death" );

	self ent_flag_set( "_stealth_override_goalpos" );

	while ( isdefined( self.enemy ) && self ent_flag( "_stealth_enabled" ) )
	{
		self setgoalpos( self.enemy.origin );

		wait 4;
	}
	
	player_to_pursue = get_closest_player_healthy( self.origin );
	if ( isdefined( player_to_pursue ) )
		self setgoalpos( player_to_pursue.origin );
}

woods_prespotted_func()
{
	level endon( "special_op_terminated" );

	switch( level.gameskill )
	{
		default:	// regular
			wait 4;
			break;
		case 2:		// hardened
			wait 3;
			break;
		case 3:		// veteran
			wait 2;
			break;
	}
}

monitor_stealth_kills()
{
	self waittill( "death", killer );
	
	if ( !isdefined( killer ) )
		return;
		
	if ( isplayer( killer ) )
	{
		level.enemies_killed++;
		flag_set( "enemy_killed" );

		thread dialog_player_kill();
		return;
	}
}

dialog_player_kill()
{
	if( flag( "_stealth_spotted" ) )
		return;
	
	wait 3;
	
	if( !stealth_is_everything_normal() )
		return;
	if( !isdefined( level.good_kill_dialog_time ) )
	{
		level.good_kill_dialog_time = gettime();
	}
	else
	{
		if( gettime() < ( level.good_kill_dialog_time + ( 15 * 1000 ) ) )
			return;
	}
	level.good_kill_dialog_time = gettime();
	
	level notify( "player kill dialog" );
}

stealth_music_control()
{
	level endon( "special_op_terminated" );

	//DEFINE_BASE_MUSIC_TIME 		 = 143.5;
	//DEFINE_ESCAPE_MUSIC_TIME 	 = 136;
	//DEFINE_SPOTTED_MUSIC_TIME 	 = 117;
	
	if( flag( "stop_stealth_music" ) )
		return;
	level endon ( "stop_stealth_music" );
	
	//flag_wait( "first_two_guys_in_sight" );
	
	//thread test_stealth_spotted();
	
	while( 1 )
	{
		thread stealth_music_hidden_loop();
	
		flag_wait( "_stealth_spotted" );
	
		music_stop( .2 );
		wait .5;
		thread stealth_music_busted_loop();
	
		flag_waitopen( "_stealth_spotted" );
	
		music_stop( 3 );
		wait 3.25;
	}
}

/*
test_stealth_spotted()
{
	while ( 1 )
	{
		level waittill( "_stealth_spotted" );
		if ( flag( "_stealth_spotted" ) )
			iprintln( "SPOTTED!" );
		else
			iprintln( "HIDDEN!" );	
	}
}
*/

stealth_music_hidden_loop()
{
	music_loop( "so_forest_contingency_stealth_music", 2 );

/*	level endon( "special_op_terminated" );

	cliffhanger_stealth_music_TIME = 528;
	//level endon( "player_in_hanger" );
	level endon( "_stealth_spotted" );
	
	if( flag( "stop_stealth_music" ) )
		return;
	level endon ( "stop_stealth_music" );
	
	while( 1 )
	{
		MusicPlayWrapper( "so_forest_contingency_stealth_music" );
		
		wait cliffhanger_stealth_music_TIME;
		
		wait 10;
	}*/
}

stealth_music_busted_loop()
{
	music_loop( "so_forest_contingency_busted_music", 2 );

/*	level endon( "special_op_terminated" );

	cliffhanger_stealth_busted_music_TIME = 154;
	//level endon( "player_in_hanger" );
	level endon( "_stealth_spotted" );
	if( flag( "stop_stealth_music" ) )
		return;
	level endon ( "stop_stealth_music" );
	while( 1 )
	{
		MusicPlayWrapper( "so_forest_contingency_busted_music" );
		
		wait cliffhanger_stealth_busted_music_TIME;
		
		wait 3;
	}*/
}

dialog_we_are_spotted_wrapper()
{
	level endon( "missionfailed" );
	maps\contingency::dialog_we_are_spotted();
}

dialog_stealth_recovery_wrapper()
{
	level endon( "missionfailed" );
	maps\contingency::dialog_stealth_recovery();
}

dialog_player_kill_master_wrapper()
{
	level endon( "missionfailed" );
	maps\contingency::dialog_player_kill_master();
}

dialog_unsilenced_weapons()
{
	self endon( "death" );
	level endon( "nonsilenced_weapon_pickup" );

	old_weapon_list = self GetWeaponsListPrimaries();

	while ( true )
	{
		self waittill( "weapon_change"  );

		current_weapon_list = self GetWeaponsListPrimaries();

		state = false;
		foreach( weapon in current_weapon_list ) 
		{
			if ( !array_contains( old_weapon_list, weapon ) )
				state = true;
		}

		if ( state )
		{
//			println( "picked up a new weapon" );
			//Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
			thread radio_dialogue( "so_for_cont_pri_attractattn" );
			break;
		}
	}

	level notify( "nonsilenced_weapon_pickup" );
}