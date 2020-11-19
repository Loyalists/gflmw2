#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_stealth_utility;
#include maps\_hud_util;
#include maps\cliffhanger_snowmobile_code;
#include maps\cliffhanger_stealth;

global_inits()
{

	level.weaponClipModels = [];
	level.weaponClipModels[ 0 ] = "weapon_m14_clip";
	level.weaponClipModels[ 1 ] = "weapon_kriss_clip";
	level.weaponClipModels[ 2 ] = "weapon_ak47_clip";
	level.weaponClipModels[ 3 ] = "weapon_famas_clip";
	level.weaponClipModels[ 4 ] = "weapon_g36_clip";
	level.weaponClipModels[ 5 ] = "weapon_dragunov_clip";

	level.friendly_init_cliffhanger = maps\cliffhanger_stealth::friendly_init_cliffhanger;

	maps\_load::set_player_viewhand_model( "ch_viewhands_player_gk_ar15" );

	maps\_snowmobile_drive::snowmobile_preLoad( "ch_viewhands_player_gk_ar15", "vehicle_snowmobile_player" );

	PreCacheItem( "hind_turret_penetration" );
	PreCacheItem( "hind_FFAR" );
	PreCacheItem( "zippy_rockets" );
	PreCacheModel( "com_computer_keyboard_obj" );
	PreCacheItem( "c4" );
	PreCacheShader( "overhead_obj_icon_world" );
	
	precacheShader( "hud_icon_heartbeat" );
	precacheShader( "hud_dpad" );
	precacheShader( "hud_arrow_left" );


	precachestring( &"CLIFFHANGER_LINE1" );
	precachestring( &"CLIFFHANGER_LINE2" );
	precachestring( &"CLIFFHANGER_LINE3" );
	precachestring( &"CLIFFHANGER_LINE4" );
	precachestring( &"CLIFFHANGER_LINE5" );
	precachestring( &"SCRIPT_WAYPOINT_COVER" );
	precachestring( &"AUTOSAVE_AUTOSAVE" );
	precachestring( &"SCRIPT_WAYPOINT_COVER" );
	precachestring( &"CLIFFHANGER_RUN_OVER" );
	precachestring( &"CLIFFHANGER_BOARD" );
	precachestring( &"CLIFFHANGER_E3_NOT_AS_PLANNED" );
	precachestring( &"CLIFFHANGER_HOW_TO_CLIMB" );
	precachestring( &"CLIFFHANGER_HOLD_ON_TIGHT" );
	precachestring( &"CLIFFHANGER_MAKES_FIRST_JUMP" );
	precachestring( &"CLIFFHANGER_E3_INTEREST_OF_TIME" );
	precachestring( &"CLIFFHANGER_E3_NOT_AS_PLANNED" );
	precachestring( &"CLIFFHANGER_LEFT_ICEPICK" );
	precachestring( &"CLIFFHANGER_RIGHT_ICEPICK" );
	

	//precacheShader( "hud_dpad" );
	//precacheShader( "hud_arrow_right" );

	maps\createart\cliffhanger_art::main();
	maps\cliffhanger_fx::main();
	maps\createfx\cliffhanger_audio::main();

	destructible_trees = GetEntArray( "destructible_tree", "targetname" );
	array_thread( destructible_trees, ::destructible_tree_think );

	maps\_empty::main( "tag_origin" );

	maps\_load::main();
	maps\_idle::idle_main();
	maps\_compass::setupMiniMap( "compass_map_cliffhanger" );

	// Press^3 [{+actionslot 3}] ^7to activate heartbeat sensor.
	add_hint_string( "hint_heartbeat_sensor", &"CLIFFHANGER_SWITCH_HEARTBEAT", ::should_break_activate_heartbeat );


	//must be after _load.gsc

	maps\_idle_sit_load_ak::main();

	maps\_c4::main();

	maps\cliffhanger_anim::main_anim();

	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();

	maps\_stealth::main();
	stealth_settings();

	maps\_patrol_anims::main();

	maps\_climb::climb_init();

	//dynamic_run_dialogue = dynamic_run_dialogue_init();
	//maps\_dynamic_run_speed::main( dynamic_run_dialogue );

	thread hide_extra_migs();// extra migs that hide and then pop out later all destroyed

	thread maps\cliffhanger_amb::main();

	//thread slidetest();

	level.firegroups = [];

	thread init_cliff_deaths();
	cliff_death_spawners = GetEntArray( "cliff_death_spawner", "script_noteworthy" );
	array_thread( cliff_death_spawners, ::add_spawn_function, maps\cliffhanger_snowmobile_code::cliff_attacker_think );

	high_threat_spawners = GetEntArray( "high_threat_spawner", "targetname" );
	array_thread( high_threat_spawners, ::high_threat_spawner_think );

	level.icepick_snowmobiles = [];
	tarmac_snowmobiles = GetEntArray( "tarmac_snowmobile", "script_noteworthy" );
	array_thread( tarmac_snowmobiles, ::tarmac_snowmobile_think );


	wind_blown_flags = GetEntArray( "wind_blown_flag", "targetname" );
	array_thread( wind_blown_flags, ::wind_blown_flag_think );

	end_camp_spawners = GetEntArray( "end_camp_spawner", "targetname" );
	array_thread( end_camp_spawners, ::add_spawn_function, ::end_camp_spawner_think );

	speedy_littlebird_spawners = GetEntArray( "speedy_littlebird_spawner", "script_noteworthy" );
	array_thread( speedy_littlebird_spawners, ::add_spawn_function, ::speedy_littlebird_spawner_think );

	ending_heli = GetEnt( "ending_heli", "script_noteworthy" );
	ending_heli add_spawn_function( ::ending_heli_think );

	// these guys are magic bullet shield because price needs to ride their snowmobile
	magic_bullet_spawners = GetEntArray( "magic_bullet_spawner", "script_noteworthy" );
	array_thread( magic_bullet_spawners, ::magic_bullet_spawner_think );
	god_vehicle_spawners = GetEntArray( "god_vehicle_spawner", "script_noteworthy" );
	array_thread( god_vehicle_spawners, ::god_vehicle_spawner_think );


	array_thread( GetEntArray( "start_crate_patroller", "script_noteworthy" ), ::add_spawn_function, ::tent_1_patrollers );
	array_thread( GetEntArray( "start_crate_patroller", "script_noteworthy" ), ::add_spawn_function, ::tent_1_crate_patroller );
	array_thread( GetEntArray( "start_quonset_patroller", "script_noteworthy" ), ::add_spawn_function, ::tent_1_patrollers );
	array_thread( GetEntArray( "right_side_start_guy", "script_noteworthy" ), ::add_spawn_function, ::right_side_start_patroller );

	array_thread( GetEntArray( "2story_leaner", "script_noteworthy" ), ::add_spawn_function, ::camp_leaner );
	array_thread( GetEntArray( "2story_sitter", "script_noteworthy" ), ::add_spawn_function, ::twostory_sitter );
	array_thread( GetEntArray( "container_leaner", "script_noteworthy" ), ::add_spawn_function, ::camp_leaner );

	array_thread( GetEntArray( "fence_walker", "script_noteworthy" ), ::add_spawn_function, ::dialog_hes_mine );
	array_thread( GetEntArray( "satbuilding_patroller", "script_noteworthy" ), ::add_spawn_function, ::dialog_hes_mine );
	array_thread( GetEntArray( "ridge_patroler", "script_noteworthy" ), ::add_spawn_function, ::dialog_hes_mine );
	array_thread( GetEntArray( "start_crate_patroller", "script_noteworthy" ), ::add_spawn_function, ::dialog_hes_mine );

	ridge_guy_left = GetEntArray( "ridge_guy_left", "script_noteworthy" );
	array_thread( ridge_guy_left, ::add_spawn_function, ::dialog_hes_mine );
	array_thread( ridge_guy_left, ::add_spawn_function, ::set_first_alert_patrol, "ridge_guy_left_first_alert" );

	ridge_guy_right = GetEntArray( "ridge_guy_right", "script_noteworthy" );
	array_thread( ridge_guy_right, ::add_spawn_function, ::set_first_alert_patrol, "ridge_guy_right_first_alert" );

	array_thread( getstructarray( "price_target_start", "script_noteworthy" ), ::price_target_start );
	array_thread( getstructarray( "price_target_stop", "script_noteworthy" ), ::price_target_stop );

	array_thread( GetEntArray( "blue_building_smoker", "script_noteworthy" ), ::add_spawn_function, ::reduce_footstep_detect_dist );
	array_thread( GetEntArray( "blue_building_loader", "script_noteworthy" ), ::add_spawn_function, ::reduce_footstep_detect_dist );
	array_thread( GetEntArray( "blue_building_smoker", "script_noteworthy" ), ::add_spawn_function, ::increase_fov_when_player_is_near );
	array_thread( GetEntArray( "blue_building_loader", "script_noteworthy" ), ::add_spawn_function, ::increase_fov_when_player_is_near );

	array_thread( GetEntArray( "fence_walker", "script_noteworthy" ), ::add_spawn_function, ::cliffhanger_set_flag_on_dead, "fence_walker_dead" );
	array_thread( GetEntArray( "satbuilding_smoker", "script_noteworthy" ), ::add_spawn_function, ::cliffhanger_set_flag_on_dead, "satbuilding_smoker_dead" );
	array_thread( GetEntArray( "southeast_patroller", "script_noteworthy" ), ::add_spawn_function, ::cliffhanger_set_flag_on_dead, "southeast_patroller_dead" );
	array_thread( GetEntArray( "satbuilding_patroller", "script_noteworthy" ), ::add_spawn_function, ::cliffhanger_set_flag_on_dead, "satbuilding_patroller_dead" );

	//Enable landing Lights on Migs
	mig_spawners = GetEntArray( "script_vehicle_mig29", "classname" );
	array_thread( mig_spawners, ::add_spawn_function, ::miglights );

	init_slope_trees();

	thread stealth_camp_threatbias();
	thread satbuilding_area_dead_wait();
	//thread wrong_way_monitor();
	thread script_chatgroups();
	//thread price_kills_very_close_enemies();

	//thread player_on_runway();
	thread dialog_found_a_body();
	thread dialog_stay_away_from_bmp();
	thread dialog_unsilenced_weapons();
	thread dialog_pretty_sneaky();
	thread dialog_stealth_spotted();
	thread dialog_stealth_failure();
	thread dialog_price_battlechatter();

	thread spawn_cliffjump_clouds();
	thread aim_assist_in_blizzard();
	thread bmp_blizzard_setup();
	thread cliffhanger_music();
	thread base_loud_speakers();
	thread setup_welders();

	level.radioForcedTransmissionQueue = [];
	level.player_radio = Spawn( "script_origin", level.player.origin );
	level.player_radio LinkTo( level.player );
	level.player_radio_interupt = Spawn( "script_origin", level.player.origin );
	level.player_radio_interupt LinkTo( level.player );

	ending_heli_fly_off_triggers = GetEnt( "ending_heli_fly_off_trigger", "targetname" );
	ending_heli_fly_off_triggers thread ending_heli_fly_off_trigger_think();

	triggers = GetEntArray( "end_heli_trigger", "targetname" );
	//array_thread( triggers, ::activate_trigger );
	//thread base_sound_remove();
	
	thread stealth_achievement();
}

cliffhanger_set_flag_on_dead( flag_name )
{
	self waittill( "death" );

	flag_set( flag_name );
}

base_loud_speakers()
{
	level endon( "start_big_explosion" );

	flag_wait( "dialog_take_point" );

	speakers = GetEntArray( "base_loudspeaker", "targetname" );

	loudspeaker = [];
	loudspeaker[ loudspeaker.size ] = "cliff_ru2_stolesandwich";
	loudspeaker[ loudspeaker.size ] = "cliff_ru3_competrov";
	loudspeaker[ loudspeaker.size ] = "cliff_ru3_indoctrination";
	loudspeaker[ loudspeaker.size ] = "cliff_ru3_ltpavlov";
	loudspeaker[ loudspeaker.size ] = "cliff_ru3_repteams";
	loudspeaker[ loudspeaker.size ] = "cliff_ru3_spareparts";
	loudspeaker[ loudspeaker.size ] = "cliff_ru3_cptkonovalov";
	loudspeaker[ loudspeaker.size ] = "cliff_ru4_ptborodin";

	current_line = 0;

	alert = [];
	alert[ alert.size ] = "cliff_ru3_redalert";
	alert[ alert.size ] = "cliff_ru3_enemyforces";
	alert[ alert.size ] = "cliff_ru3_hostiletroops";
	alert[ alert.size ] = "cliff_ru3_cutthemoff";

	current_alert = 0;

	while ( 1 )
	{
		if ( flag( "_stealth_spotted" ) )
		{
			dialog = loudspeaker[ current_alert ];
			current_alert++;
			if ( current_alert >= alert.size )
				current_alert = 0;
		}
		else
		{
			dialog = loudspeaker[ current_line ];
			current_line++;
			if ( current_line >= loudspeaker.size )
				current_line = 0;
		}

		foreach ( speaker in speakers )
			speaker PlaySound( dialog );

		wait( RandomIntRange( 12, 16 ) );
	}
}

aim_assist_in_blizzard()
{
	wait 1;
	flag_wait( "blizzard_start" );

	/*
	Added dvars "aim_aimAssistRangeScale" and "aim_autoAimRangeScale".  I found
	that 0.3 for both works pretty good during the blizzard.

	You can turn on "aim_slowdown_debug" to test the aim assist range and
	"aim_autoaim_debug" to test the auto aim range.
	*/
	SetSavedDvar( "aim_aimAssistRangeScale", ".3" );
	SetSavedDvar( "aim_autoAimRangeScale", ".3" );

	flag_wait( "done_with_stealth_camp" );

	SetSavedDvar( "aim_aimAssistRangeScale", "1" );
	SetSavedDvar( "aim_autoAimRangeScale", "1" );
}

/////////////////////////////////////////////////////////////////////////
bmp_blizzard_setup()
{
	flag_wait( "blizzard_start" );
	level.blizzard_bmp = spawn_vehicle_from_targetname( "blizzard_bmp" );
	level.blizzard_bmp thread bmp_headlights();
	level.blizzard_bmp godon();
	level.blizzard_bmp SetMotionTrackerVisible( true );
	level.blizzard_bmp thread bmp_aims_at_targets();
	level.blizzard_bmp thread bmp_shoots_player();

	//flag_wait( "done_with_stealth_camp" );
	flag_wait( "keyboard_used" );

	level.blizzard_bmp Delete();
}

bmp_headlights()
{
	//headlights
	PlayFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "tag_front_light_left" );
	PlayFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "tag_front_light_right" );
	PlayFXOnTag( level._effect[ "lighthaze_snow_spotlight" ], self, "tag_turret_light" );

 	self waittill( "death" );

 /*
	StopFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "tag_front_light_left" );
	StopFXOnTag( level._effect[ "lighthaze_snow_headlights" ], self, "tag_front_light_right" );
 	StopFXOnTag( level._effect[ "lighthaze_snow_spotlight" ], self, "tag_turret_light" );
*/
}



bmp_shoots_player()
{
	self endon( "death" );
	self thread dialog_bmp_aiming_at_player();

	self waittill_entity_in_range( level.player, 980 );

	self notify( "bmp_aim_at_player" );
	self SetTurretTargetEnt( level.player );

	self waittill_entity_in_range( level.player, 600 );

	for ( ;; )
	{
		shots = RandomIntRange( 4, 7 );
		for ( i = 0; i < shots; i++ )
		{
			self FireWeapon();
			wait( 0.35 );
		}
		wait( RandomFloatRange( .2, .5 ) );

		shots = RandomIntRange( 4, 7 );
		for ( i = 0; i < shots; i++ )
		{
			self FireWeapon();
			wait( 0.35 );
		}
		level.player DoDamage( ( level.player.health + 1000 ), self.origin );
		wait( RandomFloatRange( .2, .5 ) );
	}
}

bmp_aims_at_targets()
{
	self endon( "death" );
	self endon( "bmp_aim_at_player" );
	targets = GetEntArray( "bmp_blizzard_target", "targetname" );
	for ( ;; )
	{
		for ( i = 0; i < targets.size; i++ )
		{
			self SetTurretTargetEnt( targets[ i ] );
			self waittill( "turret_on_target" );
			wait( RandomFloatRange( 10, 15 ) );
		}
	}
}


price_kills_me_if_too_close()
{
	if ( IsDefined( self.script_noteworthy ) )
		if ( self.script_noteworthy == "truck_guys" )
			return;
	if ( !isdefined( self.script_stealth ) )
		return;
	self endon( "death" );

	level.price waittill_entity_in_range( self, 300 );

	if ( flag( "_stealth_spotted" ) )
		return;

	thread price_kills_me_do_the_killing();
}

price_kills_me_do_the_killing()
{
	level endon( "said_lets_split_up" );

	self.ignoreme = false;
	self.dontattackme = undefined;
	self.health = 1;
	//level.price.baseaccuracy = 5000;

	level.price.fixednode = false;
	level.price disable_ai_color();
	level.price SetGoalPos( level.price.origin );
	level.price.goalradius = 8;
	self.dontattackme = undefined;

	if ( !isdefined( level.price.stargets ) )
		level.price.stargets = 1;
	else
		level.price.stargets++;

	self waittill( "death" );

	level.price.stargets--;

	if ( level.price.stargets < 1 )
	{
		level.price.fixednode = true;
		level.price enable_ai_color();
	}
}


return_spawning()
{
	to_be_respawned[ 3 ] = SpawnStruct();
	to_be_respawned[ 3 ].triggername = "west_base_guys_trigger";
	to_be_respawned[ 3 ].dead_flag = "ridge_patroler_dead";


	array_thread( to_be_respawned, ::spawn_if_dead );


	to_be_spawned = [];
	to_be_spawned[ to_be_spawned.size ] = "north_patroler";
	to_be_spawned[ to_be_spawned.size ] = "north_patroler_buddy";
	to_be_spawned[ to_be_spawned.size ] = "north_patroler2";
	to_be_spawned[ to_be_spawned.size ] = "north_patroler_buddy2";
	//to_be_spawned[ to_be_spawned.size ] = "2_tents_patroler";


	if ( flag( "truckguys_dead" ) )
	{
		to_be_spawned[ to_be_spawned.size ] = "center_road_patrol";
		to_be_spawned[ to_be_spawned.size ] = "center_road_patrol_buddy";
		to_be_spawned[ to_be_spawned.size ] = "center_road_patrol2";
		to_be_spawned[ to_be_spawned.size ] = "center_road_patrol_buddy2";
	}


	//to_be_spawned[ to_be_spawned.size ] = "snow_wall_patrol";
	//to_be_spawned[ to_be_spawned.size ] = "snow_wall_patrol_buddy";
	//to_be_spawned[ to_be_spawned.size ] = "tent_smoker";

	foreach ( noteworthy_name in to_be_spawned )
	{
		guy = GetEnt( noteworthy_name, "script_noteworthy" );
		if ( IsDefined( guy ) )
		{
			guy.count = 1;
			guy = guy spawn_ai();
		}
	}
}

spawn_if_dead()
{
	if ( flag( self.dead_flag ) )
		GetEnt( self.triggername, "targetname" ) notify( "trigger" );
}

stealth_camp_threatbias()
{
	CreateThreatBiasGroup( "player" );
	level.player SetThreatBiasGroup( "player" );
	SetThreatBias( "player", "axis", 500 );
	flag_wait( "done_with_stealth_camp" );
	SetThreatBias( "player", "axis", 0 );
}


variable_blizzard( first_trans_time )
{
	level endon( "starting_hanger_backdoor_path" );
	level endon( "kill_variable_blizzard" );

	flag_set( "blizzard_start" );
	first = true;

	while ( 1 )
	{
		t = RandomFloatRange( 1, 3 );
		if ( first )
		{
			first = !first;
			if ( IsDefined( first_trans_time ) )
				t = first_trans_time;
		}
		maps\_blizzard::blizzard_level_transition_hard( t );
		//println( "blizzard      -> hard" );
		wait t;

		if ( RandomInt( 2 ) == 0 )
		{
			wait( RandomFloatRange( 1, 3 ) );
		}
		else
		{
			wait( RandomFloatRange( 7, 9 ) );
			//println( "blizzard       longer hard" );
		}

		if ( !flag( "_stealth_spotted" ) )
		{
			t = RandomFloatRange( 1, 3 );
			maps\_blizzard::blizzard_level_transition_extreme( t );
			//println( "blizzard       -> extreme" );
			wait t;
		}

		if ( RandomInt( 9 ) == 0 )
		{
			wait 2;
			//println( "blizzard       longer extreme" );
		}
	}
}



//1000 units
//c4_plant_price_teleport
//1300 units
//hanger_path_price_teleport

price_teleport_fallback( flag, loc_ent, dist )
{
	flag_wait( flag );
	player = get_closest_player( level.price.origin );
	p_dist = Distance( player.origin, level.price.origin );
	if ( p_dist > dist )
	{
		loc_ent = GetEnt( loc_ent, "targetname" );
		level.price Teleport( loc_ent.origin, loc_ent.angles );
	}
	else
	{
		PrintLn( " skipping price teleport, distance: " + p_dist );
	}
}

satbuilding_area_dead_wait()
{
	flag_wait( "satbuilding_smoker_dead" );
	flag_wait( "satbuilding_patroller_dead" );
	flag_wait( "southeast_patroller_dead" );
	flag_wait( "fence_walker_dead" );

	flag_set( "satbuilding_area_guys_dead" );
}

/*
1. cliffhanger_stealth - start when the first two enemies come into view at the
clifftop. Play this on an infinite loop, ten seconds silence between repeats.

2. cliffhanger_stealth_busted - kicks in when stealth is broken, play on a
loop, three seconds between repeats. Fade it out over five seconds once stealth
is restored, and go back to looping "cliffhanger_stealth"

3. cliffhanger_satellite - when the player passes a trigger situated after the
first hangar (just past the windows looking at the welders), fade out any
currently playing music over five seconds. Then play this track off a trigger
in the doorway of the satellite hangar, once.

4. cliffhanger_satellite_busted - Fade out "cliffhanger_satellite" over three
seconds, three seconds before the hangar door shadows open. Then start this
track exactly when the hangar door shadows start to part. Stop this track when
the first explosion goes off.

5. cliffhanger_escape - play this as soon as slow motion ends at the hangar,
Price should shout "Let's go!" as soon as this track is started.

*/

cliffhanger_music()
{
	waittillframeend; // so flags get set and music will play from start points
	waittillframeend; // so flags get set and music will play from start points
	if ( !flag( "player_rides_snowmobile" ) )
	{
		if ( !flag( "player_in_hanger" ) )
		{
			thread stealth_music_control();
			flag_wait( "player_in_hanger" );

			music_stop( 1 );
			wait 1.5;
		}

		if ( !flag( "start_busted_music" ) )
		{
			thread satellite_music_loop();
			flag_wait( "start_busted_music" );

			wait 0.5;
			music_stop( 1 );
			wait 1.25;

			MusicPlayWrapper( "cliffhanger_satellite_busted" );
		}

		if ( !flag( "start_big_explosion" ) )
		{
			flag_wait( "start_big_explosion" );

			music_stop( 0.5 );
			wait 0.75;

			flag_wait( "hanger_slowmo_ends" );
			wait 1;
		}

		thread escape_music();

		flag_wait( "player_rides_snowmobile" );

		wait 1;
		music_stop( 3 );
		wait 3.25;
	}

	//now play the snowmobile music loop until the crash

	thread snowmobile_music();

	//play the skijump music

	flag_wait( "snowmobile_fog_clears" );

	wait 2.25;
	music_stop( 2 );

	level.player play_sound_on_entity( "cliffhanger_skijump_fade_in" );
}

snowmobile_music()
{
	level endon( "snowmobile_fog_clears" );
	
	alias = "cliffhanger_snowmobile";
	time = musicLength( alias );

	while ( 1 )
	{
		MusicPlayWrapper( alias );
		wait time;
	}
}

escape_music()
{
	level endon( "player_rides_snowmobile" );

	alias = "cliffhanger_escape";
	time = musicLength( alias );

	while ( 1 )
	{
		MusicPlayWrapper( alias );
		wait time;
	}
}

satellite_music_loop()
{
	level endon( "start_busted_music" );
	
	alias = "cliffhanger_satellite";
	time = musicLength( alias );

	while ( 1 )
	{
		MusicPlayWrapper( alias );
		wait time;
	}
}

stealth_music_control()
{
	//DEFINE_BASE_MUSIC_TIME 		 = 143.5;
	//DEFINE_ESCAPE_MUSIC_TIME 	 = 136;
	//DEFINE_SPOTTED_MUSIC_TIME 	 = 117;

	level endon( "player_in_hanger" );

	flag_wait( "first_two_guys_in_sight" );

	while ( 1 )
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


stealth_music_hidden_loop()
{
	level endon( "player_in_hanger" );
	level endon( "_stealth_spotted" );

	alias = "cliffhanger_stealth";
	time = musicLength( alias );

	while ( 1 )
	{
		MusicPlayWrapper( alias );
		wait time;
	}
}

stealth_music_busted_loop()
{
	level endon( "player_in_hanger" );
	level endon( "_stealth_spotted" );

	alias = "cliffhanger_stealth_busted";
	time = musicLength( alias );
	
	while ( 1 )
	{
		MusicPlayWrapper( alias );
		wait time;
	}
}

setup_welders()
{
	light = GetEnt( "welding_light", "targetname" );
	light SetLightIntensity( 0 );

	flag_wait( "starting_hanger_backdoor_path" );

	//WELDERS
	//level.scr_anim[ "welder_wing" ][ "welding" ]			= %cliffhanger_welder_wing;
	//level.scr_anim[ "welder_engine" ][ "welding" ]			= %cliffhanger_welder_engine;

	node = GetEnt( "mig_origin", "targetname" );

	welder_wing = get_guy_with_script_noteworthy_from_spawner( "welder_wing" );
	welder_wing.animname = "welder_wing";
	welder_wing	gun_remove();
	welder_wing.allowdeath = true;
	welder_wing.ignoreme = true;
	welder_wing Attach( "machinery_welder_handle", "tag_inhand" );

	node thread anim_loop_solo( welder_wing, "welding", "stop_welding" );

	welder_engine = get_guy_with_script_noteworthy_from_spawner( "welder_engine" );
	welder_engine.animname = "welder_engine";
	welder_engine gun_remove();
	welder_engine.allowdeath = true;
	welder_engine.ignoreme = true;
	welder_engine Attach( "machinery_welder_handle", "tag_inhand" );


	node thread anim_loop_solo( welder_engine, "welding", "stop_welding" );

	//thread flashing_welding( welder_engine, "TAG_TIP_FX" );

	thread flashing_welding_fx_only( welder_engine, "tag_tip_fx" );
	thread flashing_welding_fx_only_death_handler( welder_engine );

	thread flashing_welding( welder_wing, "tag_tip_fx" );
	thread flashing_welding_death_handler( welder_wing );

	//flag_wait( "player_before_welders" );


	/*
	SetDvar( "start", "snowmobile" );
	ChangeLevel( "cliffhanger", true );

	IPrintLnBold( "END OF SCRIPTED LEVEL" );
	level waittill( "forever" );
	*/
}

flashing_welding_death_handler( welder )
{
	light = GetEnt( "welding_light", "targetname" );
	welder waittill( "death" );

	light stop_loop_sound_on_entity( "scn_cliffhanger_welders_loop" );
	light SetLightIntensity( 0 );
}

flashing_welding_fx_only_death_handler( welder )
{
	welder waittill( "death" );

	//welder stop_loop_sound_on_entity( "scn_cliffhanger_welders_loop" );
}

flashing_welding_fx_only( welder, tag )
{
	//level endon ( "at_hanger_entrance" );
	welder endon( "death" );

	//welder thread play_loop_sound_on_entity( "scn_cliffhanger_welders_loop" );

	min_flickerless_time = .2;
	max_flickerless_time = 1.5;
	num = 0;

	for ( ;; )
	{
		num = RandomIntRange( 1, 10 );
		while ( num )
		{
			wait( RandomFloatRange( .05, .1 ) );
			PlayFXOnTag( level._effect[ "welding_runner" ], welder, tag );
			welder PlaySound( "elec_spark_welding_bursts" );
			num--;

			wait( RandomFloatRange( .05, .1 ) );
		}
		wait( RandomFloatRange( min_flickerless_time, max_flickerless_time ) );
	}
}

flashing_welding( welder, tag )
{
	//level endon ( "at_hanger_entrance" );
	welder endon( "death" );


	light = GetEnt( "welding_light", "targetname" );
	light SetLightColor( ( 0.909804, 0.482353, 0.200000 ) );

	light thread play_loop_sound_on_entity( "scn_cliffhanger_welders_loop" );

	min_flickerless_time = .2;
	max_flickerless_time = 1.5;

	on = 2;
	off = 0;
	curr = on;
	num = 0;

	lit_model = undefined;
	unlit_model = undefined;
	linked_models = false;

	for ( ;; )
	{
		num = RandomIntRange( 1, 10 );
		while ( num )
		{
			wait( RandomFloatRange( .05, .1 ) );
			PlayFXOnTag( level._effect[ "welding_runner" ], welder, tag );
			welder PlaySound( "elec_spark_welding_bursts" );
			if ( linked_models )
			{
				lit_model Show();
			}
			light SetLightIntensity( on );
			num--;

			wait( RandomFloatRange( .05, .1 ) );

			light SetLightIntensity( off );

		}

		light SetLightIntensity( off );
		if ( linked_models )
		{
			lit_model Hide();
		}
		wait( RandomFloatRange( min_flickerless_time, max_flickerless_time ) );
	}
}

mig_landing1()
{
	flag_wait( "mig_landing" );

	//mig = spawn_anim_model( "mig" );
	mig_spawner = GetEnt( "mig1", "targetname" );
	mig = mig_spawner spawn_vehicle();
	mig.animname = "mig";
	node = GetNode( "jet_landing", "targetname" );
	mig thread play_sound_on_entity( "scn_cliffhanger_jet_landing" );
	node anim_single_solo( mig, "mig_landing1" );

	flag_wait( "give_c4_obj" );
	mig Delete();
}

flags()
{

	flag_init( "found_fueling_station" );
	flag_init( "brought_friends" );
	flag_init( "script_attack_override" );
	flag_init( "mission_fail" );
	//CLIFFTOP
	flag_init( "clifftop_fire_position" );
	flag_init( "clifftop_firefight" );
	flag_init( "clifftop_area_done" );
	flag_init( "clifftop_patrollers_spawned" );
	flag_init( "clifftop_patrol1_dead" );
	flag_init( "clifftop_patrol2_dead" );
	flag_init( "hk_gives_chase" );

	//CAMP
	flag_init( "tent1_patrollers_dead" );
	flag_init( "tent1_lookouts_dead" );
	flag_init( "blue_bldg_guys_dead" );
	flag_init( "2story_roof_guys_dead" );
	flag_init( "2story_slackers_dead" );
	flag_init( "party_guys_dead" );
	flag_init( "radar_bldg_guys_dead" );
	flag_init( "container_guys_dead" );

	flag_init( "clifftop_guys_move" );
	flag_init( "delay_weapon_switch" );

	flag_init( "first_encounter_dialog_starting" );
	flag_init( "second_encounter_dialog_starting" );
	flag_init( "said_two_tangos_in_front" );

	flag_init( "c4_plant" );
	flag_init( "blizzard_start" );
	flag_init( "conversation_active" );
	flag_init( "someone_became_alert" );

	flag_init( "said_lets_split_up" );
	flag_init( "dialog_danger_interupt" );
	flag_init( "player_has_been_seen" );

	flag_init( "player_on_runway_said_4_warnings" );
	flag_init( "kill_variable_blizzard" );
	flag_init( "said_thermal" );
	flag_init( "player_killed_someone" );

	flag_init( "one_c4_planted" );
	flag_init( "mig_c4_planted" );
	flag_init( "fuel_c4_planted" );

	flag_init( "said_they_are_respawning" );
	flag_init( "truck_guys_alerted" );
	flag_init( "said_path_clear" );
	flag_init( "soap_is_back" );

	flag_init( "whiteout_started" );
	flag_init( "done_with_stealth_camp" );
	flag_init( "satbuilding_area_guys_dead" );
	flag_init( "player_detonate" );

	flag_init( "fence_walker_dead" );
	flag_init( "satbuilding_smoker_dead" );
	flag_init( "southeast_patroller_dead" );
	flag_init( "satbuilding_patroller_dead" );

	flag_init( "jeep_blown_up" );
	flag_init( "jeep_stopped" );

	flag_init( "price_moving_to_hanger" );


	flag_init( "start_big_explosion" );
	flag_init( "end_big_explosion" );

	flag_init( "player_reloading" );
	flag_init( "capture_enemies_dead" );

	//BASE
	flag_init( "base_c4_order" );
	flag_init( "base_c4_planted" );
	flag_init( "base_c4_price_done" );
	//ICEPICK
	flag_init( "icepick_noturningback" );
	flag_init( "icepick_fight_stopshort" );
	flag_init( "icepick_guys_driver_dead" );
	flag_init( "icepick_guys_passenger_dead" );
	flag_init( "icepick_brawl_stopshort" );
	//LOCKERROOM
	flag_init( "locker_room_noturningback" );
	flag_init( "lockerroom_moment" );
	flag_init( "lockerroom_defender_dead" );
	flag_init( "locker_room_brawl_stopshort" );
	flag_init( "locker_brawl_becomes_uninteruptable" );

	flag_init( "start_busted_music" );

	flag_init( "hanger_slowmo_ends" );
	//TRUCKRIDE
	flag_init( "truckride_players_in_truck" );

	flag_init( "escape_with_soap" );
	// tarmac
	flag_init( "tarmac_escape" );
	flag_init( "hanger_reinforcements" );
	flag_init( "tarmac_snowmobiles_spawned" );

	// snowmobile
	flag_init( "price_ditches_player" );// player gets killed if he doesnt keep up with price
	flag_init( "player_gets_on_snowmobile" );
	flag_init( "avalanche_begins" );

	flag_init( "stay_away_from_bmp" );
	flag_init( "first_two_guys_in_sight" );
	flag_init( "check_heart_beat_sensor" );
	flag_init( "price_starts_moving" );
	flag_init( "clifftop_snowmobile_guys_die" );
	flag_init( "player_snowmobile_available" );
	flag_init( "price_enters_heli" );

	flag_init( "avalanche_ride_starts" );
	flag_init( "ending_heli_flies_in" );

	flag_init( "bad_heli_missile_killed" );
	flag_init( "player_boards" );

}

tent_1_patrollers()
{
	self endon( "death" );

	self SetGoalPos( self.origin );
	self.goalradius = 64;

	flag_wait( "near_camp_entrance" );

	self ent_flag_wait( "_stealth_normal" );

	self maps\_patrol::patrol();
}

tent_1_crate_patroller()
{
	self endon( "death" );

	nearDoorStruct = getstruct( "struct_crate_patroller_enterhut", "targetname" );

	while ( 1 )
	{
		nearDoorStruct waittill( "trigger", other );

		if ( other == self )
		{
			break;
		}
	}

	// switch him back to regular patrol anims as he heads inside
	self clear_cliffhanger_cold_patrol_anims();
}

right_side_start_patroller()
{
	self endon( "death" );

	self SetGoalPos( self.origin );
	self.goalradius = 64;

	flag_wait( "dialog_take_point" );

	self ent_flag_wait( "_stealth_normal" );

	self maps\_patrol::patrol();
}

increase_fov_when_player_is_near()
{
	self endon( "death" );
	self endon( "enemy" );

	while ( 1 )
	{
		if ( DistanceSquared( self.origin, level.player.origin ) < squared( self.footstepDetectDistSprint ) )
		{
			self.fovcosine = 0.01;
			return;
		}

		wait 0.5;
	}
}

reduce_footstep_detect_dist()
{
	self.footstepDetectDistWalk = 90;
	self.footstepDetectDist = 90;
	self.footstepDetectDistSprint = 90;
}

/************************************************************************************************************/
/*												CLIFFTOP													*/
/************************************************************************************************************/
/*
clifftop_aim_thread()
{
	self waittill( "trigger", guy );

	if ( guy ent_flag( "_stealth_stay_still" ) )
		return;
	guy endon( "_stealth_stay_still" );

	if ( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );

	if ( flag( "_stealth_event" ) )
		return;
	level endon( "_stealth_event" );

	if ( flag( "clifftop_firefight" ) )
		return;
	level endon( "clifftop_firefight" );

	guy.ref_node.origin = guy.origin;

	ai1 = get_living_ai_array( "patrollers_1", "script_noteworthy" );
	ai2 = get_living_ai_array( "patrollers_2", "script_noteworthy" );

	if ( ai1.size )
	{
		vector = ai1[ 0 ].origin - guy.origin;
		guy.ref_node.angles = VectorToAngles( VectorNormalize( vector ) );
	}
	else if ( ai2.size )
	{
		vector = ai2[ 0 ].origin - guy.origin;
		guy.ref_node.angles = VectorToAngles( VectorNormalize( vector ) );
	}
	else
		guy.ref_node.angles = self.angles;

	add_wait( ::flag_wait, "_stealth_event" );
	add_wait( ::flag_wait, "_stealth_spotted" );
	add_wait( ::flag_wait, "clifftop_firefight" );
	guy add_wait( ::ent_flag_wait, "_stealth_stay_still" );
	guy.ref_node add_endon( "stop_loop" );
	guy.ref_node add_func( ::send_notify, "stop_loop" );
	thread do_wait_any();

	guy.ref_node.angles = ( 0, guy.ref_node.angles[ 1 ] - 30, 0 );
	wait .5;

	guy.ref_node thread anim_generic_loop( guy, "crouch_aim" );

	if ( IsDefined( self.script_delay ) )
		self.script_delay = self.script_delay - .5;

	self script_delay();

	if ( !self.script_requires_player )
		self waittill( "script_requires_player" );

	if ( self.targetname == "clifftop_node1" )
	{
		guy handsignal( "go" );
		wait 1;
	}

	if ( self.targetname == "clifftop_lookout_node" )
		flag_wait( "clifftop_firefight" );

	guy.ref_node notify( "stop_loop" );
}
*/

flag_if_player_kill()
{
	self waittill( "death", attacker );
	if ( !isdefined( attacker ) )
		return;
	if ( IsPlayer( attacker ) )
		flag_set( "player_killed_one_first_two_encounters" );
}

clifftop_patroller1_logic()
{
	self endon( "death" );

	_flag = self stealth_get_group_spotted_flag();
	if ( flag( _flag ) )
		return;
	level endon( _flag );

	flag_wait( "clifftop_guys_move" );
	waittillframeend;
	self ent_flag_wait( "_stealth_normal" );

	if ( IsDefined( level.clifftop_patroller1_moveout ) )
		wait 1;
	level.clifftop_patroller1_moveout = 1;

	//self stealth_ai_clear_custom_idle_and_react();
	self notify( "stop_idle_proc" );

	self.script_patroller = 1;
	self.target = self.script_parameters;

	self thread maps\_patrol::patrol();
}

/*
clifftop_set_firefight_flag()
{
	self waittill_any( "pain", "pain_death", "death" );
	flag_set( "clifftop_firefight" );
}
*/

clifftop_smartstance_settings()
{
	looking_away = [];
	looking_away[ "stand" ] 	 = 0;
	looking_away[ "crouch" ] 	 = -800;
	looking_away[ "prone" ] 	 = -500;

	neutral = [];
	neutral[ "stand" ] 			 = 200;
	neutral[ "crouch" ] 		 = 0;
	neutral[ "prone" ] 			 = 0;

	looking_towards = [];
	looking_towards[ "stand" ] 	 = 200;
	looking_towards[ "crouch" ]  = 0;
	looking_towards[ "prone" ] 	 = 0;

	self stealth_friendly_stance_handler_distances_set( looking_away, neutral, looking_towards );
}

create_chatter_aliases_for_patrols()
{
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru1_passcig";
	aliases[ aliases.size ] = "scoutsniper_ru2_whoseturnisit";
	aliases[ aliases.size ] = "scoutsniper_ru1_wakeup";
	aliases[ aliases.size ] = "scoutsniper_ru2_buymotorbike";
	aliases[ aliases.size ] = "scoutsniper_ru1_tooexpensive";
	aliases[ aliases.size ] = "scoutsniper_ru2_illtakecareofit";
	aliases[ aliases.size ] = "scoutsniper_ru1_otherteam";
	aliases[ aliases.size ] = "scoutsniper_ru2_notwandering";
	aliases[ aliases.size ] = "scoutsniper_ru1_wandering";
	aliases[ aliases.size ] = "scoutsniper_ru2_zahkaevspayinggood";
	aliases[ aliases.size ] = "scoutsniper_ru1_wasteland";
	//aliases[ aliases.size ] = "scoutsniper_ru2_imonit";//yelling
	//aliases[ aliases.size ] = "scoutsniper_ru1_takealook";//radio and loud
	aliases[ aliases.size ] = "scoutsniper_ru2_whoseturnisit";
	aliases[ aliases.size ] = "scoutsniper_ru1_onourway";
	aliases[ aliases.size ] = "scoutsniper_ru1_passcig";
	aliases[ aliases.size ] = "scoutsniper_ru2_youidiot";
	aliases[ aliases.size ] = "scoutsniper_ru1_wakeup";
	aliases[ aliases.size ] = "scoutsniper_ru2_call";
	aliases[ aliases.size ] = "scoutsniper_ru1_tooexpensive";
	aliases[ aliases.size ] = "scoutsniper_ru2_americagoingtostartwar";
	aliases[ aliases.size ] = "scoutsniper_ru4_raise";
	aliases[ aliases.size ] = "scoutsniper_ru2_sendsomeonetocheck";
	aliases[ aliases.size ] = "scoutsniper_ru4_ifold";
	aliases[ aliases.size ] = "scoutsniper_ru2_andreibringingfood";
	aliases[ aliases.size ] = "scoutsniper_ru4_thisonesheavy";
	aliases[ aliases.size ] = "scoutsniper_ru2_quicklyaspossible";
	aliases[ aliases.size ] = "scoutsniper_ru4_didnteatbreakfast";
	aliases[ aliases.size ] = "scoutsniper_ru2_yescomrade";
	aliases[ aliases.size ] = "scoutsniper_ru4_takenzakhaevsoffer";
	aliases[ aliases.size ] = "scoutsniper_ru2_clearrotorblades";
	//aliases[ aliases.size ] = "scoutsniper_ru4_mayhaveproblem";//fear
	aliases[ aliases.size ] = "scoutsniper_ru2_radiationdosimeters";
	aliases[ aliases.size ] = "scoutsniper_ru4_canceltransactions";
	aliases[ aliases.size ] = "scoutsniper_ru2_dontbelieveatall";
	aliases[ aliases.size ] = "scoutsniper_ru4_cantwaitforshiftend";
	aliases[ aliases.size ] = "scoutsniper_ru2_ok";
	aliases[ aliases.size ] = "scoutsniper_ru4_hopeitdoesntrain";
	aliases[ aliases.size ] = "scoutsniper_ru2_professionaljob";

	level.chatter_aliases = aliases;
}

script_chatgroups()
{
	level.last_talker = undefined;
	talker = undefined;
	create_chatter_aliases_for_patrols();
	spawners = GetSpawnerTeamArray( "axis" );
	array_thread( spawners, ::add_spawn_function, ::setup_chatter );

	level.current_conversation_point = RandomInt( level.chatter_aliases.size );


	while ( !flag( "done_with_stealth_camp" ) )
	{
		flag_waitopen( "_stealth_spotted" );

		closest_talker = undefined;
		next_closest = undefined;
		enemies = GetAIArray( "axis" );
		//sort from closest to furthest
		closest_enemies = get_array_of_closest( getAveragePlayerOrigin(), enemies );

		for ( i = 0; i < closest_enemies.size; i++ )
		{
			if ( IsDefined( closest_enemies[ i ].script_chatgroup ) )
			{
				closest_chat_group = closest_enemies[ i ].script_chatgroup;
				closest_talker = closest_enemies[ i ];
				if ( closest_talker ent_flag_exist( "_stealth_normal" ) )
					if ( !closest_talker ent_flag( "_stealth_normal" ) )
						continue;

				//find next closest member of same chat group
				next_closest = find_next_member( closest_enemies, i, closest_chat_group );

				//if has no buddy or is too far from buddy or buddy is alert find another

				if ( !isdefined( next_closest ) )
					continue;
				if ( next_closest ent_flag_exist( "_stealth_normal" ) )
					if ( !next_closest ent_flag( "_stealth_normal" ) )
						continue;
				d = Distance( next_closest.origin, closest_talker.origin );
				if ( d > 220 )
				{
					//println( d );
					continue;
				}
				else
					break;
			}
		}
		//we have a group, say something
		if ( IsDefined( next_closest ) )
		{
			//check if closest guy is our last talker, if so use second closest
			if ( IsDefined( level.last_talker ) )
			{
				if ( level.last_talker == closest_talker )
					talker = next_closest;
				else
					talker = closest_talker;
			}
			else
				talker = closest_talker;

			talker chatter_play_sound( level.chatter_aliases[ level.current_conversation_point ] );

			level.current_conversation_point++;
			if ( level.current_conversation_point >= level.chatter_aliases.size )
				level.current_conversation_point = 0;
			level.last_talker = talker;

			wait .5;// conversation has pauses
		}
		else
			wait 2;// lets try again in 2 seconds
	}
}


setup_chatter()
{
	if ( !isdefined( self.script_chatgroup ) )
		return;

	self endon( "death" );

	self ent_flag_init( "mission_dialogue_kill" );
	self setup_chatter_kill_wait();
	self ent_flag_set( "mission_dialogue_kill" );
}

setup_chatter_kill_wait()
{
	self endon( "death" );
	self endon( "event_awareness" );
	self endon( "enemy" );

	flag_wait_any( "_stealth_spotted", "_stealth_found_corpse" );
}

chatter_play_sound( alias )
{
	if ( is_dead_sentient() )
		return;

	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	thread maps\_utility::delete_on_death_wait_sound( org, "sounddone" );

	org.origin = self.origin;
	org.angles = self.angles;
	org LinkTo( self );

	org PlaySound( alias, "sounddone" );
	//println( "script_chatter alias = " + alias );

	self chatter_play_sound_wait( org );
	if ( IsAlive( self ) )
		self notify( "play_sound_done" );

	org StopSounds();
	wait( 0.05 );// stopsounds doesnt work if the org is deleted same frame

	org Delete();
}

chatter_play_sound_wait( org )
{
	self endon( "death" );
	self endon( "mission_dialogue_kill" );
	org waittill( "sounddone" );
}


find_next_member( closest_enemies, closest, closest_chat_group )
{
	for ( i = closest + 1; i < closest_enemies.size; i++ )
	{
		if ( IsDefined( closest_enemies[ i ].script_chatgroup ) )
		{
			if ( closest_enemies[ i ].script_chatgroup == closest_chat_group )
				return closest_enemies[ i ];
		}
	}
	return undefined;
}


/************************************************************************************************************/
/*													CAMP													*/
/************************************************************************************************************/
camp_smartstance_settings()
{
	looking_away = [];
	looking_away[ "stand" ] 	 = 0;
	looking_away[ "crouch" ] 	 = -300;
	looking_away[ "prone" ] 	 = -500;

	neutral = [];
	neutral[ "stand" ] 			 = 0;
	neutral[ "crouch" ] 		 = 0;
	neutral[ "prone" ] 			 = 0;

	looking_towards = [];
	looking_towards[ "stand" ] 	 = 200;
	looking_towards[ "crouch" ]  = 0;
	looking_towards[ "prone" ] 	 = 0;

	self stealth_friendly_stance_handler_distances_set( looking_away, neutral, looking_towards );
}



camp_leaner()
{
	node = getstruct( self.target, "targetname" );
	node stealth_ai_idle_and_react( self, "lean_balcony", "lean_react" );
}

twostory_sitter()
{
	node = getstruct( self.target, "targetname" );
	node stealth_ai_idle_and_react( self, "sit_idle", "sit_react" );
}

/*
camp_time_save()
{
	if ( flag( "c4_plant" ) )
		return;
	level endon( "c4_plant" );

	level notify( "camp_save" );
	level endon( "camp_save" );

	wait 90;

	thread camp_save_proc();
}
*/

camp_flag_save( _flag )
{
	flag_wait( _flag );

	thread camp_save_proc();
}

camp_save_proc()
{
	level notify( "camp_save" );

	autosave_stealth();

	//thread camp_time_save();
}

mission_fail( string )
{
	if ( flag( "mission_fail" ) )
		return;
	flag_set( "mission_fail" );

	SetDvar( "ui_deadquote", level.strings[ string ] );
	missionFailedWrapper();
}


c4_player_obj()
{
	if ( !isdefined( level.basec4num ) )
		level.basec4num = 0;

	level.basec4num++;
	self.script_flag = "base_c4_num_" + level.basec4num;
	flag_init( self.script_flag );

	//make sure level.basec4num is set before we start decrementing it below
	waittillframeend;

	//flag_wait( "base_c4_order" );

	//if( false )
	if ( self.script_noteworthy == "mig_c4" )
	{
		self thread show_closest_c4();
	}
	else
	{
		self Show();
		self thread add_c4_glow( self.script_flag );
	}

	self MakeUsable();
	self SetCursorHint( "HINT_ACTIVATE" );
	self SetHintString( level.strings[ "hint_c4_plant" ] );

	self waittill( "trigger" );

	self MakeUnusable();
//	self thread maps\_c4::playC4Effects();
	self thread play_sound_on_entity( "detpack_plant" );
	flag_set( self.script_flag );

	level.basec4num--;

	if ( self.script_noteworthy == "mig_c4" )
		flag_set( "mig_c4_planted" );
	else
		flag_set( "fuel_c4_planted" );

	flag_set( "one_c4_planted" );

	//if ( level.basec4num )
	//	return;

	flag_set( "base_c4_planted" );
	flag_wait( "player_detonate" );

	//self Delete();	
	possible_c4_models = GetEntArray( "possible_c4_models", "targetname" );
	foreach ( model in possible_c4_models )
	{
		model Delete();
	}
}

show_closest_c4()
{
	possible_c4_models = GetEntArray( "possible_c4_models", "targetname" );
	foreach ( model in possible_c4_models )
		model Hide();
	current_c4 = getClosest( level.player.origin, possible_c4_models );
	current_c4 Show();
	current_c4 SetModel( "weapon_c4_obj" );
	self.origin = current_c4.origin;

	closest_c4 = undefined;
	while ( !flag( "mig_c4_planted" ) )
	{
		closest_c4 = getClosest( level.player.origin, possible_c4_models );
		if ( current_c4 != closest_c4 )
		{
			current_c4 Hide();
			closest_c4 Show();
			closest_c4 SetModel( "weapon_c4_obj" );
			self.origin = closest_c4.origin;
		}

		wait .05;
		current_c4 = closest_c4;
	}
	closest_c4 SetModel( "weapon_c4" );
	closest_c4 thread maps\_c4::playC4Effects();
}

follow_player( radius )
{
	self notify( "follow_player" );
	self endon( "follow_player" );
	self endon( "stop_following_player" );

	self.goalradius = radius * .9;

	while ( 1 )
	{
		flag_waitopen( "_stealth_spotted" );

		if ( Distance( level.player.origin, self.origin ) > radius )
			self SetGoalPos( level.player.origin );

		wait .5;
	}
}


ch_teleport_player( name )
{
	if ( !isdefined( name ) )
		name = level.start_point;

	array = getstructarray( "start_point", "targetname" );

	nodes = [];
	foreach ( ent in array )
	{
		if ( ent.script_noteworthy != name )
			continue;

		nodes[ nodes.size ] = ent;
	}

	level.player SetOrigin( nodes[ 0 ].origin );
	level.player SetPlayerAngles( nodes[ 0 ].angles );
	//teleport_players( nodes );
}

/************************************************************************************************************/
/*													OBJECTIVES												*/
/************************************************************************************************************/

objective_follow_price()
{
	// Follow Captain MacTavish.
	registerObjective( "obj_follow_price", &"CLIFFHANGER_OBJ_FOLLOW", ( 0, 0, 0 ) );
	setObjectiveState( "obj_follow_price", "current" );

	//this is where compass 1 dvar is turned on.
	flag_wait( "reached_top" );

	setObjectiveOnEntity( "obj_follow_price", level.price, ( 0, 0, 60 ) );

	flag_wait( "price_go_to_climb_ridge" );
	//while ( !flag( "price_go_to_climb_ridge" ) )
	//{
	//	wait( 0.05 );
	//}

	setObjectiveState( "obj_follow_price", "done" );
}

objective_enter_camp()
{
				// Find a way into the base.
	//level.strings[ "obj_base" ]			 = &"CLIFFHANGER_OBJ_BASE";

	flagEnt = getEntWithFlag( "give_c4_obj" );
	origin = flagEnt.origin;

	// Find a way into the base.
	registerObjective( "obj_enter", &"CLIFFHANGER_OBJ_BASE", origin );
	setObjectiveState( "obj_enter", "current" );

	flag_wait( "give_c4_obj" );

	setObjectiveState( "obj_enter", "done" );
}

objective_c4_both()
{
					// Plant explosives on the fuel tanks.
	//level.strings[ "obj_c4" ]				 = &"CLIFFHANGER_OBJ_C4";

	fuel_tank_c4 = GetEnt( "fuel_tank_c4", "script_noteworthy" );
	origin = fuel_tank_c4.origin;

	// Plant explosives on the fuel tanks.
	registerObjective( "obj_fuel", &"CLIFFHANGER_OBJ_C4", origin );
	setObjectiveState( "obj_fuel", "current" );

					// Plant explosives on the MiG-29 Jet Fighter.
	//level.strings[ "obj_c4_mig" ]				 = &"CLIFFHANGER_OBJ_C4_MIG";

	mig_c4 = GetEnt( "mig_c4", "script_noteworthy" );
	origin = mig_c4.origin;

	// Plant explosives on the MiG-29 Jet Fighter.
	registerObjective( "obj_mig", &"CLIFFHANGER_OBJ_C4_MIG", origin );

	//Objective_AdditionalPosition( level.objectives["obj_fuel"].id, 1, mig_c4.origin );
	//objective_current( level.objectives["obj_fuel"].id, level.objectives["obj_mig"].id );
	setObjectiveState( "obj_mig", "current" );


	level add_wait( ::flag_wait, "fuel_c4_planted" );
	level add_func( ::setObjectiveState, "obj_fuel", "done" );
	thread do_wait();


	level add_wait( ::flag_wait, "mig_c4_planted" );
	level add_func( ::setObjectiveState, "obj_mig", "done" );
	thread do_wait();

	flag_wait( "base_c4_planted" );// wait for obj to finish
}

objective_c4_fuel_tanks()
{
					// Plant explosives on the fuel tanks.
	//level.strings[ "obj_c4" ]				 = &"CLIFFHANGER_OBJ_C4";

	fuel_tank_c4 = GetEnt( "fuel_tank_c4", "script_noteworthy" );
	origin = fuel_tank_c4.origin;

	// Plant explosives on the fuel tanks.
	registerObjective( "obj_fuel", &"CLIFFHANGER_OBJ_C4", origin );
	setObjectiveState( "obj_fuel", "current" );

	flag_wait( "fuel_c4_planted" );

	setObjectiveState( "obj_fuel", "done" );
}

objective_c4_mig()
{
					// Plant explosives on the MiG-29 Jet Fighter.
	//level.strings[ "obj_c4_mig" ]				 = &"CLIFFHANGER_OBJ_C4_MIG";

	mig_c4 = GetEnt( "mig_c4", "script_noteworthy" );
	origin = mig_c4.origin;

	// Plant explosives on the MiG-29 Jet Fighter.
	registerObjective( "obj_mig", &"CLIFFHANGER_OBJ_C4_MIG", origin );

	if ( !flag( "mig_c4_planted" ) )
		setObjectiveState( "obj_mig", "current" );

	flag_wait( "mig_c4_planted" );

	setObjectiveState( "obj_mig", "done" );
}


objective_c4_fuel_station()
{
					// Plant explosives on the fueling station.
	//level.strings[ "obj_c4_mig" ]				 = &"CLIFFHANGER_OBJ_FUEL_STATION";

	mig_c4 = GetEnt( "mig_c4", "script_noteworthy" );
	origin = mig_c4.origin;

	// Plant explosives on the fueling station.
	registerObjective( "obj_mig", &"CLIFFHANGER_OBJ_FUEL_STATION", origin );

	if ( !flag( "mig_c4_planted" ) )
		setObjectiveState( "obj_mig", "current" );

	flag_wait( "mig_c4_planted" );

	setObjectiveState( "obj_mig", "done" );
}

objective_goto_hanger()
{
			// Get to the satellite.
	//level.strings[ "goto_hanger_obj" ]		 = &"CLIFFHANGER_OBJ_GOTO_HANGER";

	flagEnt = getEntWithFlag( "at_hanger_entrance" );
	//hangerpath_obj_location = GetEnt( "hangerpath_obj_location", "targetname" );
	origin = flagEnt.origin;

	// Get to the satellite.
	registerObjective( "obj_goto_hanger", &"CLIFFHANGER_OBJ_GOTO_HANGER", origin );
	setObjectiveState( "obj_goto_hanger", "current" );

	flag_wait( "at_hanger_entrance" );

	setObjectiveState( "obj_goto_hanger", "done" );
}

objective_satellite()
{
	flag_wait( "player_on_backdoor_path" );

	// Retrieve the ACS module.
	registerObjective( "obj_satellite", &"CLIFFHANGER_OBJ_COMPUTER", ( 0, 0, 0 ) );
	setObjectiveState( "obj_satellite", "current" );
	setObjectiveOnEntity( "obj_satellite", level.price );

	flag_wait( "player_in_hanger" );
	wait( 3.5 );

	dsm = GetEnt( "dsm", "targetname" );

	// Download the files.
	setObjectiveLocation( "obj_satellite", dsm.origin );
	flag_wait( "keyboard_used" );


	setObjectiveState( "obj_satellite", "done" );
}

objective_exfiltrate()
{
	flag_wait( "escape_with_soap" );
	if ( !isalive( level.price ) )
		return;
	level.price endon( "death" );

//	level.snowmobile_objective_origin = (-12357.9, -32374.2, 397.2);

	// Escape with Captain MacTavish.
	registerObjective( "obj_exfiltrate", &"CLIFFHANGER_OBJ_EVACUATE", ( 0, 0, 0 ) );
	setObjectiveOnEntity( "obj_exfiltrate", level.price );

	setObjectiveState( "obj_exfiltrate", "current" );
	
	flag_wait( "player_slides_down_hill" );
	setObjectiveOnEntity( "obj_exfiltrate", level.price );
	
	wait 2.1; // for delay threaded objective getting set
	setObjectiveOnEntity( "obj_exfiltrate", level.price );

	flag_wait( "player_snowmobile_available" );
	setObjectiveState( "obj_exfiltrate", "done" );
}

objective_snowmobile()
{
	if ( !isalive( level.price ) )
		return;

	// Obtain a snowmobile.
	registerObjective( "obj_snowmobile", &"CLIFFHANGER_OBJ_SNOWMOBILE", level.player_snowmobile.origin + ( 0, 0, 48 ) );
	setObjectiveState( "obj_snowmobile", "current" );

	flag_wait( "player_rides_snowmobile" );

	setObjectiveState( "obj_snowmobile", "done" );

	objective_end_org = GetEnt( "objective_end_org", "targetname" );
	ent = Spawn( "script_origin", ( 0, 0, 0 ) );
	ent thread objective_ent_leads_player();
	// Get to the extraction point.
	Objective_Add( 9, "current", &"CLIFFHANGER_OBJ_EXTRACT", ( 0, 0, 0 ) );
	Objective_Current( 9 );

	//Objective_OnEntity( 9, ent );
	// until onentity gets fixed for script origins

	set_obj_point_from_flag( 9, "player_starts_snowmobile_trip" );
	flag_wait( "obj_2" );
	set_obj_point_from_flag( 9, "obj_2" );
	flag_wait( "obj_3" );
	set_obj_point_from_flag( 9, "obj_3" );
	flag_wait( "obj_4" );
	set_obj_point_from_flag( 9, "obj_4" );

	flag_wait( "enemy_snowmobiles_wipe_out" );
	Objective_Position( 9, ent.origin );


	Objective_Position( 9, objective_end_org .origin );


	// Escape with Captain MacTavish.
	//objective_end_org = GetEnt( "objective_end_org", "targetname" );
	// Escape with Captain MacTavish.
	//registerObjective( "obj_final_escape", &"CLIFFHANGER_OBJ_EVACUATE", objective_end_org.origin );
	//setObjectiveState( "obj_final_escape", "current" );

	//setObjectiveOnEntity( "obj_final_escape", level.price, (0, 0, 74) );


	//org = level.price.origin;
    //
	//dif = 0.95;
	//for ( ;; )
	//{
	//	if ( !isalive( level.price ) )
	//		break;
	//	angles = level.price.angles;
	//	forward = AnglesToForward( angles );
	//	new_org = level.price.origin + forward * 2000;
	//	objective_org = org * dif + new_org * ( 1 - dif );
	//	setObjectiveLocation( "obj_final_escape", objective_org );
	//	org = objective_org;
	//	wait( 0.1 );
	//}

	flag_wait( "player_boards" );
	objective_complete( 9 ) ;

	SetSavedDvar( "compass", "0" );
	//setObjectiveState( "obj_final_escape", "done" );
}



registerObjective( objName, objText, objOrigin )
{
	flag_init( objName );
	objID = obj( objName );

	newObjective = SpawnStruct();
	newObjective.name = objName;
	newObjective.id = objID;
	newObjective.state = "invisible";
	newObjective.text = objText;
	newObjective.origin = objOrigin;
	newObjective.added = false;

	level.objectives[ objName ] = newObjective;

	return newObjective;
}


setObjectiveState( objName, objState )
{
	Assert( IsDefined( level.objectives[ objName ] ) );

	objective = level.objectives[ objName ];
	objective.state = objState;

	if ( !objective.added )
	{
		Objective_Add( objective.id, objective.state, objective.text, objective.origin );
		objective.added = true;
	}
	else
	{
		Objective_State( objective.id, objective.State );
	}

	if ( objective.state == "done" )
		flag_set( objName );
}


setObjectiveString( objName, objString )
{
	objective = level.objectives[ objName ];
	objective.text = objString;

	Objective_String( objective.id, objString );
}


setObjectiveLocation( objName, objLoc )
{
	objective = level.objectives[ objName ];
	objective.loc = objLoc;

	Objective_Position( objective.id, objective.loc );
	// clear this, can be overwritten elsewhere
	Objective_SetPointerTextOverride( objective.id, "" );
}

setObjective_pointerText( objName, text )
{
	objective = level.objectives[ objName ];
	Objective_SetPointerTextOverride( objective.id, text );
}


setObjectiveRemaining( objName, objString, objRemaining )
{
	Assert( IsDefined( level.objectives[ objName ] ) );

	objective = level.objectives[ objName ];

	if ( !objRemaining )
		Objective_String( objective.id, objString );
	else
		Objective_String( objective.id, objString, objRemaining );
}


setObjectiveOnEntity( objName, ent, offset )
{
	objID = obj( objName );
	//objective = level.objectives[ objName ];
	if ( IsDefined( offset ) )
		Objective_OnEntity( objID, ent, offset );
	else
		Objective_OnEntity( objID, ent );
}


//objective_stealth()
//{
//	while ( 1 )
//	{
//		flag_wait( "_stealth_spotted" );
//			Objective_String( level.curr_obj, level.strings[ "obj_stealth" ] );
//
//		flag_waitopen( "_stealth_spotted" );
//			Objective_String( level.curr_obj, level.curr_obj_string );
//	}
//}

/************************************************************************************************************/
/*												INITIALIZATIONS												*/
/************************************************************************************************************/

dynamic_run_dialogue_init()
{

	return undefined;
}

misc_precache()
{
	PreCacheModel( "machinery_welder_handle" );
	PreCacheModel( "weapon_m21sd_wht" );
	PreCacheShader( "overlay_frozen" );
			// Get the thing from the satelite

			// Plant explosives on the fueling station.
	level.strings[ "fuel_station_obj" ]		 = &"CLIFFHANGER_OBJ_FUEL_STATION";
			// Extract the Data Storage Module from the Satellite.
	level.strings[ "use_satelite_obj" ]		 = &"CLIFFHANGER_OBJ_USE_SATELITE";
			// Get to the satellite.
	level.strings[ "goto_hanger_obj" ]		 = &"CLIFFHANGER_OBJ_GOTO_HANGER";
			// Retrieve the 'package'.
	level.strings[ "obj_package" ]		 = &"CLIFFHANGER_OBJ_PACKAGE";
				// Find a way into the base.
	level.strings[ "obj_base" ]			 = &"CLIFFHANGER_OBJ_BASE";
					// Plant explosives on the fuel tanks.
	level.strings[ "obj_c4" ]				 = &"CLIFFHANGER_OBJ_C4";
				// Find the fuel tankers.
	level.strings[ "obj_fuel" ]			 = &"CLIFFHANGER_OBJ_FIND_FUEL";

					// Plant explosives on the MiG-29 Jet Fighter.
	level.strings[ "obj_c4_mig" ]				 = &"CLIFFHANGER_OBJ_C4_MIG";

			// Press and hold &&1 to plant the explosives.
	level.strings[ "hint_c4_plant" ]		 = &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES";

			// Escape with Captain MacTavish.
	level.strings[ "obj_snowmobile" ]		 = &"CLIFFHANGER_OBJ_EVACUATE";

	foreach ( string in level.strings )
		PreCacheString( string );
}

model_initializations()
{
	c4s = GetEntArray( "base_c4_models", "targetname" );
	foreach ( c4 in c4s )
		c4 Hide();
}

player_init()
{
	level.player stealth_cliffhanger();
	level.player thread playerSnowFootsteps();// "price_moving_to_hanger" );
	player_speed_percent( 90 );
	//Player setup
	player_weapons_init();
}


player_weapons_init()
{
	level.player TakeAllWeapons();
	//level.player GiveWeapon( "m4m203_motion_tracker" );
	//level.player SwitchToWeapon( "m4m203_motion_tracker" );


	level.motiontrackergun_off = "masada_silencer_mt_camo_off";
	level.motiontrackergun_on = "masada_silencer_mt_camo_on";
	level.player GiveWeapon( level.motiontrackergun_on );
	level.player SwitchToWeapon( level.motiontrackergun_off );

	/*
	level.motiontrackergun_on = "masada_silencer_mt_dust_on";
	level.player GiveWeapon( level.motiontrackergun_off );
	*/

	level.silenced_sidearm = "usp_silencer";
	level.player GiveWeapon( level.silenced_sidearm );
	//level.player GiveWeapon( "usp_silencer", 0, true );//akimbo
	level.player GiveWeapon( "fraggrenade" );
	level.player GiveWeapon( "flash_grenade" );
	level.player SetOffhandSecondaryClass( "flash" );
	//level.player GiveWeapon( "claymore" );
	//level.player GiveMaxAmmo( "claymore" );
	//level.player SetActionSlot( 4, "weapon", "claymore" );
	//if( flag( "delay_weapon_switch" ) )
	//	wait 2;
	//level.player SwitchToWeapon( level.motiontrackergun_off );
}

enemy_init()
{
	wait .5;
	anim.shootEnemyWrapper_func = ::ShootEnemyWrapper_SSNotify;
}

do_nothing()
{
}

price_bullet_sheild()
{
	level endon( "stop_price_shield" );

	while ( 1 )
	{
		if ( Distance( level.player.origin, self.origin ) > 1300 )
		{
			self stop_magic_bullet_shield();

			while ( Distance( level.player.origin, self.origin ) > 1300 )
				wait .1;

			self thread magic_bullet_shield();
		}

		wait .1;
	}
}

price_handle_death()
{
	self waittill( "death" );

	thread mission_fail( "fail_price_dead" );
}

ShootEnemyWrapper_price()
{
	self endon( "death" );

	while ( 1 )
	{
		self waittill( "animscript_shot" );

		if ( flag( "_stealth_spotted" ) )
			continue;
	//	if( IsAlive( self.enemy ) )
	//		self.enemy Kill();
	}
}

ShootEnemyWrapper_SSNotify()
{
	self notify( "animscript_shot" );
	animscripts\utility::shootEnemyWrapper_normal();
}

climbing_test_init()
{
	level.price_a = GetEnt( "price_a", "targetname" );
	level.price_a make_hero();
	level.price_a.animname = "price_a";

	level.price_b = GetEnt( "price_b", "targetname" );
	level.price_b make_hero();
	level.price_b.animname = "price_b";

	level.price_c = GetEnt( "price_c", "targetname" );
	level.price_c make_hero();
	level.price_c.animname = "price_c";

	level.price_d = GetEnt( "price_d", "targetname" );
	level.price_d make_hero();
	level.price_d.animname = "price_d";

	level.cake_a = GetEnt( "cake_a", "targetname" );
	level.cake_a make_hero();
	level.cake_a.animname = "cake_a";

	level.cake_b = GetEnt( "cake_b", "targetname" );
	level.cake_b make_hero();
	level.cake_b.animname = "cake_b";

	level.cake_c = GetEnt( "cake_c", "targetname" );
	level.cake_c make_hero();
	level.cake_c.animname = "cake_c";

	level.cake_d = GetEnt( "cake_d", "targetname" );
	level.cake_d make_hero();
	level.cake_d.animname = "cake_d";

	level.price_jump = GetEnt( "price_jump", "targetname" );
	level.price_jump make_hero();
	level.price_jump.animname = "price_jump";

	climbing_ref = GetEnt( "climbing_ref", "targetname" );

	guys = [];
	guys[ guys.size ] = level.price_a;
	guys[ guys.size ] = level.price_b;
	guys[ guys.size ] = level.price_c;
	guys[ guys.size ] = level.price_d;

	guys[ guys.size ] = level.cake_a;
	guys[ guys.size ] = level.cake_b;
	guys[ guys.size ] = level.cake_c;
	guys[ guys.size ] = level.cake_d;

	jump = [];
	jump[ jump.size ] = level.price_jump;

	// spawn the props
	level.price_a anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.price_a anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	level.price_b anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.price_b anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	level.price_c anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.price_c anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	level.price_d anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.price_d anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );

	level.cake_a anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.cake_a anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	level.cake_b anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.cake_b anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	level.cake_c anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.cake_c anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	level.cake_d anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.cake_d anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );

	level.price_jump anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
	level.price_jump anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );

	climbing_ref anim_first_frame( guys, "climbing_test_scene" );

	while ( 1 )
	{
		climbing_ref anim_single_solo( level.price_jump, "climbing_test_jump1" );
		wait 3;
		climbing_ref anim_single_solo( level.price_jump, "climbing_test_jump2" );
		wait 3;
		climbing_ref anim_single_solo( level.price_jump, "climbing_test_jump3" );
		wait 3;
		climbing_ref anim_single_solo( level.price_jump, "climbing_test_jump4" );
		wait 3;
		climbing_ref anim_single_solo( level.price_jump, "climbing_test_jump5" );
		wait 3;
		climbing_ref anim_single_solo( level.price_jump, "climbing_test_jump6" );
		wait 3;
	}
}


/************************************************************************************************************/
/*												DIALOG												*/
/************************************************************************************************************/



dialog_stealth_failure()// in
{
	level.player endon( "death" );
	level endon( "price_moving_to_hanger" );
	//Not very sneaky, Soap.	
	//This is easier when you don't alert them.	
	//There is a reason we brought silencers. 	
	//That was sloppy.	

	failure = [];
	failure[ failure.size ] = "cliff_pri_notsneaky";
	failure[ failure.size ] = "cliff_pri_dontalertthem";
	failure[ failure.size ] = "cliff_pri_sloppy";
	failure[ failure.size ] = "cliff_pri_silencers";
	line = RandomInt( failure.size );

	second_line = [];
	//They are going back to their positions. 	
	second_line[ second_line.size ] = "cliff_pri_theygoingback";
	//You're in the clear, they're returning to their positions. 	
	second_line[ second_line.size ] = "cliff_pri_youreclear";
	//The rest of them have given up looking for you and are returning to their original positions. 	
	second_line[ second_line.size ] = "cliff_pri_resthavegivenup";


	while ( 1 )
	{
		flag_wait( "_stealth_spotted" );
		wait 1;
		flag_waitopen( "_stealth_spotted" );
		wait 1;

		play_Sound_over_radio( failure[ line ] );
		line++;
		if ( line >= failure.size )
			line = 0;
		if ( flag( "said_lets_split_up" ) )
		{
			wait 1;
			play_Sound_over_radio( second_line[ RandomInt( second_line.size ) ] );
		}
	}
}

dialog_stealth_spotted()
{
	flag_wait( "price_go_to_climb_ridge" );
	level endon( "start_big_explosion" );
	//Take cover! They're on to you!	
	//You've been spotted take cover!	
	//Get out of there they've found you!	
	//Heads up! I see tangos coming from multiple directions!	

	failure = [];
	failure[ failure.size ] = "cliff_pri_takecover";
	failure[ failure.size ] = "cliff_pri_beenspotted";
	failure[ failure.size ] = "cliff_pri_foundyou";
	failure[ failure.size ] = "cliff_pri_multipledirections";
	failure = array_randomize( failure );
	line = 0;

	while ( 1 )
	{
		flag_wait( "_stealth_spotted" );

		play_Radio_Interupt( failure[ line ] );
		line++;
		if ( line >= failure.size )
			line = 0;

		wait 1;
		flag_waitopen( "_stealth_spotted" );
		wait 1;
		//dialog_check_path_clear();
	}
}


dialog_price_battlechatter()
{
	left = [];
//ON YOUR LEFT
	//Tango to your left.	
	left[ left.size ] = "cliff_pri_tangoleft";
	//Target on your left.	
	left[ left.size ] = "cliff_pri_targetleft";

	right = [];
//ON YOUR RIGHT	
	//Hostile to the right.	
	right[ right.size ] = "cliff_pri_hostileright";
	//Target on your right.	
	right[ right.size ] = "cliff_pri_targetright";

	rear = [];
//BEHIND YOU	
	//Tango on your six.	
	rear[ rear.size ] = "cliff_pri_tangosix";
	//Target behind you.	
	rear[ rear.size ] = "cliff_pri_targetbehindyou";


	left_callout_time = 0;
	right_callout_time = 0;
	rear_callout_time = 0;
	min_time_between_callouts = 2;
	min_time_between_each_direction = 5 * 1000;

	level endon( "price_moving_to_hanger" );
	while ( ( !flag( "done_with_stealth_camp" ) ) && ( !flag( "price_moving_to_hanger" ) ) )
	{
		//flag_wait( "_stealth_spotted" );

		//while( flag( "_stealth_spotted" ) )//only when stealth broken
		while ( 1 )
		{
			wait .5;

			enemies = GetAIArray( "axis" );
			enemies = get_array_of_closest( level.player.origin, enemies, undefined, undefined, 800, undefined );
			if ( enemies.size == 0 )
				continue;
			foreach ( enemy in enemies )
			{
				if ( !( enemy CanSee( level.player ) ) )
					continue;

				if ( enemy doingLongDeath() )
					continue;

				start_origin = level.player.origin;
				start_angles = level.player.angles;
				end_origin = enemy.origin;

				normal = VectorNormalize( end_origin - start_origin );
				forward = AnglesToForward( start_angles );
				dot = VectorDot( forward, normal );

				if ( dot >= 0.77 )
					//in front
					continue;

				current_time = GetTime();

				if ( dot < -0.77 )
				{
					// behind
					if ( current_time > ( rear_callout_time + min_time_between_each_direction ) )
					{
						rear_callout_time = current_time;
						alias = rear[ RandomInt( rear.size ) ];
						thread play_Sound_Over_Radio( alias );
						wait min_time_between_callouts;
						break;
					}
					else
						continue;
				}

				right_vec = AnglesToRight( start_angles );
				second_dot = VectorDot( right_vec, normal );

				if ( second_dot < 0 )
				{
					// left
					if ( current_time > ( left_callout_time + min_time_between_each_direction ) )
					{
						left_callout_time = current_time;
						alias = left[ RandomInt( left.size ) ];
						thread play_Sound_Over_Radio( alias );
						wait min_time_between_callouts;
						break;
					}
					else
						continue;
				}
				else
				{
					// right
					if ( current_time > ( right_callout_time + min_time_between_each_direction ) )
					{
						right_callout_time = current_time;
						alias = right[ RandomInt( right.size ) ];
						thread play_Sound_Over_Radio( alias );
						wait min_time_between_callouts;
						break;
					}
					else
						continue;
				}
			}
		}
	}
}



dialog_player_kill()
{

	self waittill( "death", killer, method );

	if ( !isdefined( killer ) )
		return;
	if ( IsPlayer( killer ) )
		flag_set( "player_killed_someone" );

	if ( flag( "_stealth_spotted" ) )
		return;
	if ( flag( "conversation_active" ) )
		return;
	if ( !stealth_is_everything_normal() )
		return;
	if ( flag( "price_moving_to_hanger" ) )
		return;

	if ( IsPlayer( killer ) )
	{
		wait 1;
		if ( !stealth_is_everything_normal() )
			return;
		if ( !isdefined( level.player_kill_time ) )
		{
			level.player_kill_time = GetTime();
		}
		else
		{
			if ( GetTime() < ( level.player_kill_time + ( 15 * 1000 ) ) )
				return;
		}
		level.player_kill_time = GetTime();

		PrintLn( "--------- player kill: " + method );
		if ( ( method != "MOD_RIFLE_BULLET" ) && ( method != "MOD_PISTOL_BULLET" ) )
			play_Sound_Over_Radio( "cliff_pri_melee_plyr" );
		else
			play_Sound_Over_Radio( "cliff_pri_killfirm_plyr" );
	}
}

price_target_start()
{
	self waittill( "trigger", other );
	other notify( "target_stop" );
	other thread dialog_hes_mine();
}

price_target_stop()
{
	self waittill( "trigger", other );
	other notify( "target_stop" );
}

dialog_hes_mine()
{
	level endon( "price_moving_to_hanger" );
	self endon( "death" );
	self endon( "target_stop" );

	while ( 1 )
	{
		self waittill_entity_in_range( level.player, 650 );
		PrintLn( "        price target in range" );
		self waittill_player_lookat_for_time( 0.4 );
		PrintLn( "        price target looked at" );

		if ( flag( "_stealth_spotted" ) )
			return;

		// price should not shoot at me if I have buddies nearby
		if ( self price_should_snipe_me() )
		{
		    //I'll take this one.	
		    //level.scr_sound[ "price" ][ "cliff_pri_takethisone" ]		 = "cliff_pri_takethisone";
		    //He's mine.	
		    //level.scr_sound[ "price" ][ "cliff_pri_hesmine" ]		 = "cliff_pri_hesmine";

		    //if( !self ent_flag( "_stealth_normal" ) )
		    //	return;
		    /*
		    if( !isdefined( level.price_kill_time ) )
		    {
			    level.price_kill_time = GetTime();
		    }
		    else
		    {
			    if( GetTime() < ( level.price_kill_time + ( 3 * 1000 ) ) )
				    return;
		    }
		    level.price_kill_time = GetTime();
		    */
		    if ( !isdefined( level.price_snipe_dialog ) )
			    level.price_snipe_dialog = 0;

		    thread dialog_hes_mine_think();
			return;
		}

		wait 3;
	}
}

dialog_hes_mine_think()
{
	//self endon( "death" );
	dialog = [];
	dialog [ dialog.size ] = "cliff_pri_hesmine";
	dialog [ dialog.size ] = "cliff_pri_takethisone";
	dialog [ dialog.size ] = "cliff_pri_ivegothim";
	dialog [ dialog.size ] = "cliff_pri_onesmine";
	dialog [ dialog.size ] = "cliff_pri_illtakehim";

	can_speak = play_Sound_Over_Radio( dialog[ level.price_snipe_dialog ] );
	if ( ! can_speak )
		return;

	//wait .5;

	level.price_snipe_dialog++;
	if ( level.price_snipe_dialog >= dialog.size )
		level.price_snipe_dialog = 0;

	if ( IsAlive( self ) )
	{
		aim_spot = self GetEye();
		vec = VectorNormalize( level.price.origin - aim_spot );// vec towards price
		vec *= 20;// bullet starts 20 units from head
		start_spot = aim_spot + vec;
		MagicBullet( level.price.weapon, start_spot, aim_spot );
	}
	else
	{
		wait .5;
		if ( cointoss() )
		{
			//Never mind.	
			play_Sound_Over_Radio( "cliff_pri_nevermind" );
		}
		else
		{
			//Then again, maybe not.	
			play_Sound_Over_Radio( "cliff_pri_maybenot" );
		}
	}
}

dialog_price_kill()
{
	level endon( "price_moving_to_hanger" );

	self waittill( "death", killer );

	if ( !isdefined( killer ) )
		return;

	if ( level.price == killer )
		play_Sound_Over_Radio( "UK_pri_inform_killfirm_generic_s" );
}

//dialog_stealth_advice()//in
//{
//	wait 1;
//	//Don't shoot indiscriminately. Make sure the target is alone.	
//	level.price anim_single_queue( level.price, "cliff_pri_targetisalone" );
//}

dialog_found_a_body()
{
	dialog = [];
	//Hold on - they've only found a body. They don't know where you are.	
	dialog[ dialog.size ] = "cliff_pri_foundabody";
	//Looks like they've found a corpse, bnut they haven't seen you yet. Keep quiet.	
	dialog[ dialog.size ] = "cliff_pri_keepquiet";
	//Soap - they found a corpse but they're not onto you yet. Stay calm.	
	dialog[ dialog.size ] = "cliff_pri_staycalm";

	level endon( "price_moving_to_hanger" );
	current_line = 0;

	while ( !flag( "done_with_stealth_camp" ) )
	{
		flag_wait( "_stealth_found_corpse" );

		if ( !flag( "_stealth_spotted" ) )
		{
			play_Sound_Over_Radio( dialog[ current_line ] );
			current_line++;
			if ( current_line >= dialog.size )
				current_line = 0;
		}

		flag_waitopen( "_stealth_found_corpse" );
	}
}

//-------------------PRICE OUT OF BASE DIALOG

//ENEMIES LOOKING FOR YOU
dialog_theyre_looking_for_you()
{
	dialog = [];
	//Relax. They�re looking for you but they don�t know where you are.	
	//dialog[ dialog.size ] = "cliff_pri_relax";

	//They�re looking for you so stay hidden.	
	//dialog[ dialog.size ] = "cliff_pri_stayhidden";

	//Stay out of sight - you�ve alerted some guards.	
	dialog[ dialog.size ] = "cliff_pri_outofsight";

	// You alerted them.	
	//dialog[ dialog.size ] = "cliff_pri_alertedthem";

	//PRICE: Hide! You've alerted one of the guards.
	dialog[ dialog.size ] = "cliff_pri_hidealerted";

	//PRICE: One of them has seen you, stay out of sight!
	//dialog[ dialog.size ] = "cliff_pri_alertedthem";

	//PRICE: Stay out of sight - you�ve alerted one of them!
	dialog[ dialog.size ] = "cliff_pri_sightalertedone";

	//PRICE: Stay out of sight - you've been spotted!
	//dialog[ dialog.size ] = "cliff_pri_sightbeenspotted";




	self endon( "death" );
	//if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "truck_guys" ) )
	//	return;

	self ent_flag_waitopen( "_stealth_normal" );

	if ( flag( "someone_became_alert" ) )
		return;

	flag_set( "someone_became_alert" );
	
	self endon( "jumpedout" );// dont play this on truck guys

	level add_wait( ::wait_till_every_thing_stealth_normal_for, 3 );
	level add_func( ::flag_clear, "someone_became_alert" );
	thread do_wait();

	level endon( "_stealth_spotted" );
	if ( flag( "_stealth_spotted" ) )
		return;

	wait 2;// was 3

	/*
	if( !isdefined( level.stay_hidden_dialog ) )
	{
		level.stay_hidden_dialog = GetTime();
	}
	else
	{
		if( GetTime() < ( level.stay_hidden_dialog + ( 15 * 1000 ) ) )
			return;
	}
	level.stay_hidden_dialog = GetTime();
	*/

	if ( flag( "price_moving_to_hanger" ) )
		return;

	dialog_line = dialog[ RandomInt( dialog.size ) ];
	PrintLn( dialog_line );
	radio_clear_queue();
	radio_dialogue( dialog_line );// dont cut off the other line but clear the que
	//play_Radio_Interupt( dialog_line, true );//cut off the line and clear the que.
}

wait_till_every_thing_stealth_normal_for ( time )
{
	while ( 1 )
	{
		if ( stealth_is_everything_normal() )
		{
			wait time;
			if ( stealth_is_everything_normal() )
				return;
		}
		wait 1;
	}
}

dialog_near_fueling_station()
{
	flag_wait( "give_c4_obj" );
	level.player endon( "death" );
	level endon( "one_c4_planted" );
	obj_origin = GetEnt( "base_c4_models", "targetname" ).origin;

	level.player waittill_in_range( obj_origin, 600 );
	//That's the fueling station.	
	play_Sound_Over_Radio( "cliff_pri_fuelingstation", true, 2 );

	level.player waittill_in_range( obj_origin, 180 );
	//You found it.	
	flag_set( "found_fueling_station" );
	play_Sound_Over_Radio( "cliff_pri_foundit", true, 2 );
}

dialog_plant_c4_nag()
{
	flag_wait( "give_c4_obj" );
	level endon( "one_c4_planted" );

	last_nag = true;
	//obj_origin = GetEnt( "base_c4_models", "targetname" ).origin;
	//last_dist = Distance( level.player.origin, obj_origin );

	while ( 1 )
	{
		wait 50;
		if ( flag( "_stealth_spotted" ) )
		{
			flag_waitopen( "_stealth_spotted" );
			continue;
		}
		//current_distance = Distance( level.player.origin, obj_origin );
		//PrintLn( "current dist:       " + current_distance );
		//if ( current_distance > ( last_dist + 50 ) )
		//{
			if ( flag( "found_fueling_station" ) )
			{
				//Soap, go back to the fueling station and plant your C4.	
				play_Sound_Over_Radio( "cliff_pri_goback", true );
			}
			else
			{
				if ( last_nag )
				{
					//Soap, the fueling station is near the northeast corner of the runway.	
					play_Sound_Over_Radio( "cliff_pri_necorner", false );
					last_nag = false;
				}
				else
				{
					//Soap - search the northeast part of the runway for the fueling station.	
					play_Sound_Over_Radio( "cliff_pri_searchntheast", false );
					last_nag = true;
				}
			}
			//wait 20;
		//}
		//last_dist = current_distance;
	}
}

dialog_goto_hanger_nag()
{
	level endon( "player_on_backdoor_path" );

	wait 25;

	last_nag = true;
	//obj_origin = GetEnt( "price_hanger_start", "targetname" ).origin;
	//last_dist = Distance( level.player.origin, obj_origin );

	while ( 1 )
	{
		wait 40;
		if ( flag( "_stealth_spotted" ) )
		{
			flag_waitopen( "_stealth_spotted" );
			continue;
		}
		//current_distance = Distance( level.player.origin, obj_origin );
		//if ( current_distance > ( last_dist + 50 ) )
		//{
			if ( last_nag )
			{
				//Soap I'm waiting behind the hangars at the southwest corner of the runway.	
				play_Sound_Over_Radio( "cliff_pri_behindhangars", true, 2 );
				last_nag = false;
			}
			else
			{
				//Soap, meet me behind the hangers at the southwest corner of the runway.	
				play_Sound_Over_Radio( "cliff_pri_meetme", true, 2 );
				last_nag = true;
			}
			//wait 20;
		//}
		//last_dist = current_distance;
	}
}




dialog_truck_coming()
{
	self endon( "driver dead" );
	level endon( "jeep_stopped" );
	level endon( "price_moving_to_hanger" );
	level endon( "jeep_blown_up" );

	//There�s a truck coming! Stay out of sight.	
	play_Sound_Over_Radio( "cliff_pri_truckcoming", true, 7 );

	wait 15;

	//self waittill_entity_out_of_range( level.player, 650 );
	while ( 1 )
	{
		self waittill_entity_in_range( level.player, 1200 );
		truck_coming = within_fov( self.origin, self.angles, level.player.origin, Cos( 45 ) );
		if ( truck_coming )
		{
			if ( cointoss() )
			{
				//PRICE: The truck is coming back.
				play_Sound_Over_Radio( "cliff_pri_truckcomingback", true, 2 );
			}
			else
			{
				//PRICE: The truck is coming.
				play_Sound_Over_Radio( "cliff_pri_truckiscoming", true, 2 );
			}
			wait 10;
		}
		else
			wait 1;
	}
}


//STAY AWAY FROM BMP		-------------in
dialog_stay_away_from_bmp()
{
	flag_wait( "stay_away_from_bmp" );
	if ( flag( "done_with_stealth_camp" ) )
		return;


	//Picking up large heat signatures near the tower, could be BMPs. I'd avoid that area.
	play_Sound_Over_Radio( "cliff_pri_avoidarea", true );
}

dialog_bmp_aiming_at_player()
{
	level.player endon( "death" );
	self waittill( "bmp_aim_at_player" );

	//That BMP�s got thermal sights � get the hell out of there!	
	play_Radio_Interupt( "cliff_pri_getoutofthere", false );
}

//THEY ARE RESPAWNING
dialog_they_are_respawning()
{
	//while( flag( "_stealth_spotted" ) )
	//wait 3;

	if ( !flag( "_stealth_spotted" ) )
	{
		//Hold up.	
		play_Sound_Over_Radio( "cliff_pri_holdup", true );
	}

	//I'm seeing some activity on the runway.	
	play_Sound_Over_Radio( "cliff_pri_activityonrunway", true );


	//Looks like twenty plus 'foot-mobiles' headed your way
	play_Sound_Over_Radio( "cliff_pri_footmobiles", true );

	wait 5;

	//flag_set( "said_they_are_respawning" );
}

//GOTO HANGER	-------------in
dialog_goto_hanger()
{
	//flag_wait( "said_they_are_respawning" );

	if ( !flag( "_stealth_spotted" ) )
	{
		wait 4;
	}

	if ( !flag( "_stealth_spotted" ) )
	{
		//I'm picking more radio traffic about the satellite. Standby.	
		play_Sound_Over_Radio( "cliff_pri_radiotraffic", true );

		wait 3;
	}

	if ( !flag( "_stealth_spotted" ) )
	{
		//Got it. Sounds like the satellite's in the far hangar.	
		play_Sound_Over_Radio( "cliff_pri_infarhangar", true );

		//Race you there. Oscar Mike. Out.	
		play_Sound_Over_Radio( "cliff_pri_oscarmike" );
	}
	else
	{
		//I'm headed for the hanger. Get there asap.	
		play_Sound_Over_Radio( "cliff_pri_getthereasap", true );
	}
}



dialog_unsilenced_weapons()
{
	flag_wait( "first_two_guys_in_sight" );
	//level endon ( "start_big_explosion" );
	level endon( "done_with_stealth_camp" );
	level.player endon( "death" );

	while ( 1 )
	{
		wait 1;
		weap = level.player GetCurrentWeapon();
		if ( ( weap != level.motiontrackergun_off )
			 && ( weap != level.motiontrackergun_on )
			 && ( weap != level.silenced_sidearm )
			 && ( weap != "none" ) )// ladders etc
			break;
	}

	if ( IsDefined( level.price.function_stack ) )
	{
		while ( level.price.function_stack.size > 0 )// price is speaking using anim_single_queue
			wait .5;
	}

	PrintLn( weap );
	//Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
	play_Sound_Over_Radio( "cliff_pri_attractattn", true );

	//wait 20;
	//
	//while( 1 )
	//{
	//	wait 1;
	//	weap = level.player GetCurrentWeapon();
	//	if( ( weap != level.motiontrackergun_off ) 
	//		&& ( weap != level.motiontrackergun_on )
	//		&& ( weap != level.silenced_sidearm )
	//		&& ( weap != "none" ) )//ladders etc
	//		break;
	//}
	//println( weap );
	////Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
	//play_Sound_Over_Radio( "cliff_pri_attractattn", true );	
}

dialog_pretty_sneaky()
{
	//No kills, no alerts. Impressive Soap." 
	level endon( "player_killed_someone" );
	level endon( "_stealth_spotted" );
	level endon( "someone_became_alert" );
	flag_wait( "base_c4_planted" );

	maps\_utility::giveachievement_wrapper( "GHOST" );
	//Pretty sneaky Soap. No one�s been alerted to your presence.	
	play_Sound_Over_Radio( "cliff_pri_prettysneaky", true );
}

dialog_jeep_blown_up()
{
	level endon( "price_moving_to_hanger" );
	flag_wait( "jeep_blown_up" );

	if ( flag( "_stealth_spotted" ) )
		return;
	wait 1;
	if ( flag( "_stealth_spotted" ) )
		return;
	//Gee, I wonder if they will notice a flaming wreck in the middle of the road�.	
	play_Sound_Over_Radio( "cliff_pri_flamingwreck" );
}

dialog_jeep_stopped()
{
	level endon( "price_moving_to_hanger" );
	self waittill( "unloading" );

	if ( flag( "_stealth_spotted" ) )
		return;

	//Heads up, the truck just stopped.	
	play_Sound_Over_Radio( "cliff_pri_headsup", true );

	if ( flag( "_stealth_spotted" ) )
		return;

	truck_guys = getentarray( "truck_guys", "script_noteworthy" );
	alive = 0;
	foreach ( guy in truck_guys )
	{
		if( isalive( guy ) )
			alive++;
	}

	//Four tangos just got out and are looking around.	
	if( alive == 4 )
		play_Sound_Over_Radio( "cliff_pri_lookingaround", true, 5 );
}

play_Sound_Over_Radio_use_que( soundAlias, timeout )
{
	if ( flag( "tarmac_escape" ) )
		return;

	return radio_dialogue( soundAlias, timeout );
}

play_Sound_Over_Radio( soundAlias, force_transmit_on_turn, timeout )
{
	if ( flag( "tarmac_escape" ) )
		return;

	if ( IsDefined( force_transmit_on_turn ) && force_transmit_on_turn == true )
		return radio_dialogue( soundAlias, timeout );
	else
		return radio_dialogue_safe( soundAlias );
}

play_Radio_Interupt( soundAlias, clear_the_que )
{
	if ( flag( "tarmac_escape" ) )
		return;

	radio_dialogue_stop();
	radio_dialogue( soundAlias );
}

radio_clear_queue()
{
	radio_dialogue_clear_stack();
}

/************************************************************************************************************/
/*												SLIDE TEST													*/
/************************************************************************************************************/

slidetest()
{
	wait .05;
	// creates a trigger on the hill you're supposed to slide down.
	// this should be made into a real trigger to avoid walking around it. =)
	trigger = Spawn( "trigger_radius", ( -12266, -31591, 400 ), 0, 410, 700 );
	thread maps\_load::trigger_slide( trigger );
}

player_dies_if_he_moves()
{
	/#
	flag_assert( "start_big_explosion" );
	#/
	level endon( "start_big_explosion" );

	org = level.player.origin;
	for ( ;; )
	{
		if ( Distance( org, level.player.origin ) > 64 )
		{
			break;
		}
		wait( 0.05 );
	}

	level.price.ignoreme = true;
	level.player EnableDeathShield( false );
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		timer = RandomFloatRange( 0.1, 0.3 );
		guy delayThread( timer, ::guy_starts_shooting );
	}
	wait( 2 );
	/#
	if ( IsGodMode( level.player ) )
		return;
	#/
	level.player Kill();
}

guy_starts_shooting()
{
	self.dontEverShoot = undefined;
}


should_break_activate_heartbeat()
{
	Assert( IsPlayer( self ) );

//	if ( GetTime() > level.heartbeat_timeout )
//		return true;

	weapons = level.player GetWeaponsListPrimaries();
	has_masada = false;
	foreach ( weapon in weapons )
	{
		if ( weapon == level.motiontrackergun_on )
		{
			has_masada = true;
			break;
		}
	}
	if( !has_masada )
		return true;
		
	if( level.player GetCurrentWeapon() == level.motiontrackergun_on )
		return true;

	return false;
}


///////////////////////////////////////////
price_move_speed_think( pushdist, sprintdist, stopdist, jogdist, crouchdist )
{
	self notify( "start_dynamic_run_speed" );

	self endon( "death" );
	self endon( "stop_dynamic_run_speed" );
	self endon( "start_dynamic_run_speed" );

	if ( self ent_flag_exist( "_stealth_custom_anim" ) )
		self ent_flag_waitopen( "_stealth_custom_anim" );

	if ( !isdefined( self.ent_flag[ "dynamic_run_speed_stopped" ] ) )
	{
		self ent_flag_init( "dynamic_run_speed_stopped" );
		self ent_flag_init( "dynamic_run_speed_stopping" );
	}
	else
	{
		self ent_flag_clear( "dynamic_run_speed_stopping" );
		self ent_flag_clear( "dynamic_run_speed_stopped" );
	}

	self.run_speed_state = "";

	self thread stop_dynamic_price_speed();

	//MUCH faster to do distancesquared checks than distance
	//pushdist2rd 	 = pushdist * pushdist;
	sprintdist2rd 	 = sprintdist * sprintdist;
	//stopdist2rd 	 = stopdist * stopdist;
	//jogdist2rd		 = jogdist * jogdist;

	while ( 1 )
	{
		wait .2;


		player = level.players[ 0 ];
		foreach ( value in level.players )
		{
			if ( DistanceSquared( player.origin, self.origin ) > DistanceSquared( value.origin, self.origin ) )
				player = value;
		}

		vec = AnglesToForward( self.angles );
		vec2 = VectorNormalize( ( player.origin - self.origin ) );
		vecdot = VectorDot( vec, vec2 );

		//how far is the player
		dist2rd = DistanceSquared( self.origin, player.origin );


		if ( IsDefined( self.cqbwalking ) && self.cqbwalking )
				self.moveplaybackrate = 1;

	//	if ( dist2rd < sprintdist2rd || vecdot > - .25 )
	//	{
	//		dynamic_price_run_set( "sprint" );
	//		continue;
	//	}

		if ( ( dist2rd > ( 150 * 150 ) ) && ( vecdot > -.25 ) )// player is in front angle wise
		{
			dynamic_price_run_set( "run" );
			continue;
		}
		if ( flag( "_stealth_spotted" ) )
		{
			dynamic_price_run_set( "cqb" );
			continue;
		}

		//otherwise crouch
		dynamic_price_run_set( "crouch" );


	//	else if ( dist2rd > jogdist2rd )
	//	{
	//		dynamic_price_run_set( "jog" );
	//		continue;
	//	}
	}
}

stop_dynamic_price_speed()
{
	self endon( "start_dynamic_run_speed" );
	self endon( "death" );

	self.moveplaybackrate = 1;
	self clear_run_anim();
	self AllowedStances( "stand", "crouch", "prone" );

	self notify( "stop_loop" );
	self ent_flag_clear( "dynamic_run_speed_stopping" );
	self ent_flag_clear( "dynamic_run_speed_stopped" );
}


dynamic_price_run_set( speed )
{
	if ( self.run_speed_state == speed )
		return;

	self.run_speed_state = speed;

	switch( speed )
	{
		case "sprint":
			if ( IsDefined( self.cqbwalking ) && self.cqbwalking )
				self.moveplaybackrate = 1;
			else
				self.moveplaybackrate = 1.15;
			self set_generic_run_anim( "DRS_sprint" );
			self AllowedStances( "stand", "crouch", "prone" );

			self disable_cqbwalk();
			self notify( "stop_loop" );
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "run":
			self.moveplaybackrate = 1;

			self clear_run_anim();
			self AllowedStances( "stand", "crouch", "prone" );

			self disable_cqbwalk();
			self notify( "stop_loop" );
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "jog":
			self.moveplaybackrate = 1;

			self set_generic_run_anim( "DRS_combat_jog" );
			self AllowedStances( "stand", "crouch", "prone" );

			self disable_cqbwalk();
			self notify( "stop_loop" );
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "crouch":
			self.moveplaybackrate = 1;

			self clear_run_anim();
			self AllowedStances( "crouch" );

			self disable_cqbwalk();
			self notify( "stop_loop" );
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "cqb":
			self.moveplaybackrate = 1;

			self enable_cqbwalk();
			self AllowedStances( "stand", "crouch", "prone" );

			self notify( "stop_loop" );
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
	}
}


spawn_cliffjump_clouds()
{
      flag_wait( "player_climbs_past_safe_point" );
      //iprintlnbold( "Clouds Spawning" );
      exploder( 1 );
}

hide_extra_migs()
{
	/#
	if ( level.start_point == "snowmobile" )
		return;
	if ( level.start_point == "icepick" )
		return;
	if ( level.start_point == "avalanche" )
		return;
	#/
	extra_tarmac_migs = GetEntArray( "extra_tarmac_migs", "script_noteworthy" );
	extra_tarmac_mig_delayed = GetEntArray( "extra_tarmac_mig_delayed", "script_noteworthy" );
	migs_turn_on_and_off = extra_tarmac_migs;
	migs_turn_on_and_off = array_combine( migs_turn_on_and_off, extra_tarmac_mig_delayed );

	wait( 1 );
	foreach ( mig in migs_turn_on_and_off )
	{
		mig.origin += ( 0, 0, -5000 );
		mig Hide();
	}

	flag_wait( "start_big_explosion" );

	foreach ( mig in migs_turn_on_and_off )
	{
		mig.origin += ( 0, 0, 5000 );
		mig Show();
	}

	foreach ( mig in extra_tarmac_migs )
	{
		if ( mig.code_classname == "script_model" )
			mig thread destructible_force_explosion();
	}

	// this mig has some guys by it, it blows up when they die	
	flag_wait( "jet_defenders_die" );

	foreach ( mig in extra_tarmac_mig_delayed )
	{
		if ( !isdefined( mig ) )
			continue;
		if ( mig.code_classname == "script_model" )
			mig thread destructible_force_explosion();
	}

	set_off_destructible_with_noteworthy( "destructible_oilrig_1" );

	// swap the fire on the jet for the fire on the ground
	pauseExploder( 56 );
	exploder( 55 );
}

set_off_destructible_with_noteworthy( noteworthy )
{
	destructibles = GetEntArray( noteworthy, "script_noteworthy" );
	foreach ( ent in destructibles )
	{
		if ( !isdefined( ent ) )
			continue;

		if ( ent.code_classname != "script_model" )
			continue;

		ent destructible_force_explosion();
		wait( RandomFloatRange( 0.15, 0.25 ) );
	}
}


more_reinforcements_spawn()
{
	wait( 3 );
	hanger_late_spawners = GetEntArray( "hanger_late_spawner", "targetname" );
	array_thread( hanger_late_spawners, ::spawn_ai );
}

high_threat_spawner_think()
{
	self.threatbias = 1000;
}

tarmac_snowmobile_think()
{
	self waittill( "spawned", vehicle );
	vehicle thread vehicle_becomes_crashable();
	vehicle VehPhys_DisableCrashing();// so they dont go off their path inconsistently

	flag_set( "tarmac_snowmobiles_spawned" );

	vehicle thread force_unload();
	vehicle waittill( "unloading" );
	level notify( "tarmac_snowmobile_unload" );

}

force_unload()
{
	self endon( "death" );
	self endon( "unloading" );
	level waittill( "tarmac_snowmobile_unload" );
	self Vehicle_SetSpeed( 0, 45 );
	wait 1.75;
	self thread vehicle_unload();
	// so both snowmobiles dismount once either reaches the end of the path
}


open_up_player_fov( view_arms, tag )
{
	level.player PlayerLinkToDelta( view_arms, tag, 0.0, 90, 90, 90, 30 );
}

vehicle_tumble_in_avalanche()
{
	self endon( "death" );
	self waittill_either( "veh_collision", "driver_died" );

	avalanche_progress_org = GetEnt( "avalanche_progress_org", "targetname" );
	targ = GetEnt( avalanche_progress_org.target, "targetname" );

	direction = VectorNormalize( targ.origin - avalanche_progress_org.origin );
	delayThread( 13, ::self_delete );

	for ( ;; )
	{
		self waittill( "driver_died", other );
		speed = level.player_ride Vehicle_GetSpeed();
		velocity = direction * speed;
		velocity = ( velocity[ 0 ], velocity[ 1 ], 10.0 );
		self VehPhys_Launch( velocity, RandomFloatRange( 0.4, 0.8 ) );
		wait( RandomFloatRange( 0.05, 0.15 ) );
	}
}

new_captain_price_spawns()
{
	maps\_climb::safe_price_delete( level.price );

	spawner = level.price_spawner;
	spawner.count = 1;
	price = spawner StalingradSpawn();
	level.price = price;
	spawn_failed( price );
	price.animname = "price";
	price thread magic_bullet_shield();

	price add_damage_function( ::kill_snowmobiles_that_touch_me );

	return price;
}

kill_snowmobiles_that_touch_me( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	if ( !isdefined( attacker ) )
		return;
	classname = attacker.classname;
	if ( !isdefined( classname ) )
		return;
	if ( classname != "script_vehicle_snowmobile" )
		return;


	foreach ( rider in attacker.riders )
	{
		if ( !isalive( rider ) )
			continue;
		rider DoDamage( 1000, self.origin, self );
	}
}

wind_blown_flag_think()
{
	animname = "flag_square";
	if ( IsDefined( self.script_noteworthy ) )
		animname = self.script_noteworthy;
	waving_flag = spawn_anim_model( animname );
	waving_flag.origin = self.origin;
	waving_flag.angles = self.angles;
	self Delete();

	angles = VectorToAngles( waving_flag.angles );
	forward = AnglesToForward( angles );
	//waving_flag.origin += forward * 8;
	waving_flag thread flag_waves();
}

flag_waves()
{
	animation = self getanim( "flag_waves" );
	self SetAnim( animation, 1, 0, 1 );
	//Print3d( self.origin, "x", (1,1,1), 1, 1, 50000 );
	for ( ;; )
	{
		if ( !isdefined( self ) )
			return;
		flap_rate = RandomFloatRange( 0.8, 1.2 );
		self SetAnim( animation, 1, 0, flap_rate );
		wait( RandomFloatRange( 0.3, 0.7 ) );
	}
}

base_sound_remove()
{
	flag_wait( "player_slides_down_hill" );
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		ent = level.createFXent[ i ];

		if ( IsDefined( ent.v[ "soundalias" ] ) )
		{
			if ( ent.v[ "soundalias" ] == "velocity_whitenoise_loop" )
				continue;
		}
		if ( IsDefined( ent.looper ) )
			ent.looper Delete();
	}

	models = GetEntArray( "script_model", "code_classname" );
	foreach ( model in models )
	{
		model Delete();
	}


	foreach ( tree in level.destructible_tree_models )
	{
		model = Spawn( "script_model", tree[ "origin" ] );
		model.angles = tree[ "angles" ];
		model SetModel( tree[ "model" ] );
		tree[ "owner" ].tree = model;
//		tree[ "owner" ] thread tree_think();
	}
}

destructible_tree_think()
{
	brush = undefined;
	targets = GetEntArray( self.target, "targetname" );
	model = undefined;
	foreach ( target in targets )
	{
		if ( target.code_classname == "script_brushmodel" )
		{
			brush = target;
			continue;
		}

		model = target;
	}
	targets = undefined;

	self waittill( "damage" );

	brush Delete();
	if ( IsDefined( self.tree ) )
	{
		vector = randomvector( 100 );
		vector = set_z( vector, abs( vector[ 2 ] ) );
		model PhysicsLaunchClient( model.origin, vector + ( 0, 0, 50 ) );
	}
	self Delete();
}

keyboard_nag()
{
	flag_waitopen( "keyboard_used" );
	level endon( "keyboard_used" );

	for ( ;; )
	{
		wait( 18 );
		// �Soap, get upstairs and download the files.�	
		level.price dialogue_queue( "downloadfiles" );
	}
}

init_slope_trees()
{
	slope_trees = GetEntArray( "slope_tree", "targetname" );
	top_of_hill = getstruct( "top_of_hill", "targetname" );

	slope_trees = get_array_of_closest( top_of_hill.origin, slope_trees );

	if ( level.gameskill == 0 )
	{
		slope_trees = array_delete_evenly( slope_trees, 2, 3 );
	}
	else
	if ( level.gameskill == 1 )
	{
		slope_trees = array_delete_evenly( slope_trees, 1, 2 );
	}

	slope_tree_clip = GetEntArray( "slope_tree_clip", "targetname" );
	foreach ( index, slope_tree in slope_trees )
	{
		AssertEx( IsDefined( slope_tree_clip[ index ] ), "Not enough slope_tree_clip placed in the map" );
		slope_tree.clip = slope_tree_clip[ index ];
		slope_tree_clip[ index ] = undefined;
	}

	// delete the excess clip
	foreach ( clip in slope_tree_clip )
	{
		clip Delete();
	}

	array_thread( slope_trees, ::slope_tree_think );
}

run_in_and_shout()
{
	self endon( "death" );

	self enable_cqbwalk();
	hanger_enemies_enter = GetNode( "hanger_enemies_enter", "targetname" );
	hanger_enemies_enter anim_single_solo( self, "runin" );
	self SetGoalPos( self.origin );
	self.goalradius = 64 ;
	level waittill( "kill_price" );
	self StopAnimScripted();
	self.ignoreall = false;
	for ( ;; )
	{
		self Shoot();
		wait( RandomFloatRange( 0.1, 0.2 ) );
	}


}

random_yelling( enemies )
{
	yell = [];
	yell [ yell.size ] = "cliff_ru1_gogogo";
	yell [ yell.size ] = "cliff_ru1_freezedropit";
	yell [ yell.size ] = "cliff_ru1_handsup";
	yell [ yell.size ] = "cliff_ru2_movemove";
	yell [ yell.size ] = "cliff_ru2_doitnow";
	yell [ yell.size ] = "cliff_ru2_handsintheair";
	yell [ yell.size ] = "cliff_ru3_letsgoletsgo";
	yell [ yell.size ] = "cliff_ru3_dropitdropit";
	yell [ yell.size ] = "cliff_ru3_stopdontmove";
	yell [ yell.size ] = "cliff_ru4_dropitmfer";
	yell [ yell.size ] = "cliff_ru4_dropyourweapon";
	yell [ yell.size ] = "cliff_ru4_dropitnow";
	yell [ yell.size ] = "cliff_ru4_shutupdropit";
	yell [ yell.size ] = "cliff_ru4_shutmouth";
	yell = array_randomize( yell );
	yell_index = 0;

	//13 seconds
	start_time = GetTime();
	onethird_time = start_time + ( 4 * 1000 );
	twothird_time = start_time + ( 8 * 1000 );
	while ( !flag( "start_big_explosion" ) )
	{
		current_time = GetTime();
		w = 1;
		if ( current_time > onethird_time )
			w = .5;
		if ( current_time > twothird_time )
			w = 0;
		wait( RandomFloatRange( 1, 3 ) );
		wait( w );

		yeller = enemies[ RandomInt( enemies.size ) ];
		if ( IsAlive( yeller ) )
		{
			current_yell = yell[ yell_index ];
			yeller anim_generic( yeller, current_yell );
		}
		else
		{
			wait( 0.5 );
		}
		yell_index++;
		if ( yell_index >= yell.size )
			yell_index = 0;
	}
}

kill_all_enemies()
{
	enemies = GetAIArray( "axis" );
	foreach ( mf in enemies )
		mf Delete();
}


brawl_interupted( price, guy )
{
	level endon( "locker_brawl_becomes_uninteruptable" );
	guy waittill( "death" );
	price notify( "single anim", "end" );
	price StopAnimScripted();
	price.cutoff_brawl = true;

	locker_brawl = GetEnt( "locker_brawl", "targetname" );
	foreach ( locker in level.lockers )
	{
		// stop the lockers
		//locker StopAnimScripted();
		locker notify( "single anim", "end" );// send the notify so the sequence ends
		locker_brawl anim_first_frame( level.lockers, "locker_brawl" );
	}
}

cliffhanger_locker_brawl()
{

	//get rid of all enemies to make room for new stealth free gameplay
	kill_all_enemies();
	if ( IsDefined( level.truck_patrol ) )
	{
		level.truck_patrol delete_truck_headlights();
		level.truck_patrol Delete();
	}

//	blizzard_level_transition_light( 0.05 );
//	blizzard_level_transition_none( 0.75 );

	locker_brawl_spawner = GetEnt( "locker_brawl_spawner", "targetname" );
	locker_brawl = GetEnt( "locker_brawl", "targetname" );
	locker_brawl anim_reach_solo( level.price, "locker_brawl" );

	level.price.cutoff_brawl = true;

	guy = locker_brawl_spawner spawn_ai();
	if ( spawn_failed( guy ) )
		return;

	guy set_battlechatter( false );

	level.price.cutoff_brawl = undefined;

	guy.grenadeawareness = 0;
	guy.animname = "defender";
	guy.allowdeath = true;
	guy.health = 1;
	guy gun_remove();
	guy.noDrop = true;
	thread brawl_interupted( level.price, guy );

	guys = [];
	guys[ 0 ] = guy;
	guys[ 1 ] = level.price;
	guys = array_combine( guys, level.lockers );// add the lockers

	org = GetEnt( "price_locker_brawl_end_dest", "targetname" );
	level.price SetGoalPos( org.origin );

	locker_brawl thread anim_single( guys, "locker_brawl" );
	level.price waittillmatch( "single anim", "end" );

}

price_anims_satellite()
{
	satelite_sequence_node = GetEnt( "satelite_sequence", "targetname" );
	thread price_goes_to_satellite();
	flag_wait( "keyboard_used" );
	satelite_sequence_node notify( "stop_satellite_idle" );
	price_puts_his_hands_up();
}

price_puts_his_hands_up()
{
	level.price endon( "death" );

	price_capture_node = GetEnt( "price_capture_node", "targetname" );
	//level.price ForceTeleport( node.origin, node.angles );
	/*
	level.price.fixednode = false;
	level.price.script_forcegoal = true;
	level.price.goalradius = 64;
	level.price SetGoalPos( price_capture_node.origin );
	*/

	price_capture_node thread anim_loop_solo( level.price, "capture_idle", "stop_capture_idle" );

	flag_wait( "start_big_explosion" );
	price_capture_node notify( "stop_capture_idle" );

	// put his main weapon on his chest so it doesn't disappear when he pulls out his pistol
	level.price animscripts\shared::placeWeaponOn( level.price.weapon, "chest" );
	price_capture_node anim_single_solo( level.price, "capture_pullout" );
	level.price.forcesidearm = true;
	level.price.fixednode = true;
	level.price.goalradius = 2000;

	flag_wait( "capture_enemies_dead" );

	level.price.forcesidearm = undefined;
	level.price disable_cqbwalk();
}



price_goes_to_satellite()
{
	if ( flag( "keyboard_used" ) )
		return;

	level endon( "keyboard_used" );

	satelite_sequence_node = GetEnt( "satelite_sequence", "targetname" );
	if ( IsDefined( level.price.cutoff_brawl ) )
		satelite_sequence_node anim_reach_solo( level.price, "enter" );

	//delayThread( 2, ::autosave_by_name, "price_to_satellite" );

	guys[ "price" ] = level.price;
	guys[ "drill" ] = level.drill;

	satelite_sequence_node anim_single( guys, "enter" );
	satelite_sequence_node thread anim_loop_solo( level.price, "satellite_idle", "stop_satellite_idle" );
}


set_first_alert_patrol( struct_targetname )
{
	struct = getstruct( struct_targetname, "targetname" );
	self.stealth_first_alert_new_patrol_path = struct;
}

miglights()
{
	lights_on( "running" );
	lights_on( "landing" );
}



/*
create_price_target()
{
	level.price_targets[ level.price_targets.size ] = self;
	self.ignoreme = true;
}
*/




price_starts_moving()
{
	flag_wait( "price_starts_moving" );

	level.price.moveplaybackrate = 1;
	if ( IsDefined( level.price.node ) && abs( level.price.node.angles[ 1 ] - level.price.angles[ 1 ] ) < 5 )
	{
		level.price OrientMode( "face current" );
		set_custom_move_start_transition( level.price, "casual_crouch_exit" );
	}

	GetEnt( "price_starts_moving", "targetname" ) notify( "trigger" );
	level.price.fixednode = false;
	level.price SetLookAtEntity();// clears it

	level.price disable_cqbwalk();
	level.price AllowedStances( "crouch" );

	//enable_dynamic_run_speed( pushdist, sprintdist, stopdist, jogdist )
	//level.price enable_dynamic_run_speed( 250, 60, 500, 312.5 );
	//level.price AllowedStances( "crouch" );
	//level.price clifftop_smartstance_settings();//override of default
	//level.price enable_stealth_smart_stance();
	//level.price enable_dynamic_run_speed( undefined, 60 );

	//level.price handsignal( "go" );

	player_speed_percent( 90, 2 );


//	flag_wait( "clifftop_patrol1_dead" );
	flag_wait( "first_two_guys_in_sight" );
	level.price thread price_move_speed_think( undefined, 300 );
}


//HEART BEAT SETUP
dialog_setup_heartbeat()
{

	flag_wait( "check_heart_beat_sensor" );

	level.price SetLookAtEntity( level.player );

	//Soap, check your heartbeat sensor.	
	level.price dialogue_queue( "cliff_pri_checksensor" );

//	level.heartbeat_timeout = GetTime() + 30000;

	// with no parameter, stays on forever
	level.player thread display_hint_timeout( "hint_heartbeat_sensor" );// it will endon this thread if not threaded

	if ( level.console )
		thread explain_dpad_hint();

	level endon( "first_two_guys_in_sight" );

	while ( level.player GetCurrentWeapon() != level.motiontrackergun_on )
	{
		//flag_wait( "player_activated_sensor" );
		wait .5;
	}

	//You should be able to see me on the scope.	
	level.price dialogue_queue( "cliff_pri_seeme" );
	//That blue dot is me.	
	level.price dialogue_queue( "cliff_pri_bluedot" );

	//Heartbeat signatures are like fingerprints - no two are alike.	
	//level.price anim_single_queue( level.price, "cliff_pri_fingerprints" );

	wait .1;// getting weird overlap with dialog_first_encounter
	//Any unrecognized contacts will show up as white dots.	
	level.price thread dialogue_queue( "cliff_pri_whitedots" );

	flag_set( "price_starts_moving" );
}


explain_dpad_hint()
{
	setsaveddvar( "cg_drawcrosshair", "0" );
	level.iconElem = createIcon( "hud_dpad", 32, 32 );
	level.iconElem.hidewheninmenu = true;
	level.iconElem setPoint( "TOP", undefined, 0, 175 );
	
	level.iconElem2 = createIcon( "hud_icon_heartbeat", 32, 32 );
	level.iconElem2.hidewheninmenu = true;
	level.iconElem2 setPoint( "TOP", undefined, -32, 175 );	


	level.iconElem3 = createIcon( "hud_arrow_left", 24, 24 );
	level.iconElem3.hidewheninmenu = true;
	level.iconElem3 setPoint( "TOP", undefined, 0, 179 );
	level.iconElem3.sort = 1;
	level.iconElem3.color = (1,1,0);
	level.iconElem3.alpha = .7;


	while( !( level.player should_break_activate_heartbeat() ) )
		wait .5;
	//while ( level.player GetCurrentWeapon() != level.motiontrackergun_on )
	//	wait .5;
	
	level.iconElem setPoint( "CENTER", "BOTTOM", 320, -20, 2 );
	level.iconElem2 setPoint( "CENTER", "BOTTOM", 288, -20, 2 );
	level.iconElem3 setPoint( "CENTER", "BOTTOM", 320, -20, 2 );
	
	level.iconElem scaleovertime(2, 20, 20);
	level.iconElem2 scaleovertime(2, 20, 20);
	level.iconElem3 scaleovertime(2, 15, 15);
	
	wait 1.7;
	level.iconElem fadeovertime(.3);
	level.iconElem.alpha = 0;
	
	level.iconElem2 fadeovertime(.3);
	level.iconElem2.alpha = 0;
	
	level.iconElem3 fadeovertime(.3);
	level.iconElem3.alpha = 0;
	
	level.iconElem destroy();
	level.iconElem2 destroy();
	level.iconElem3 destroy();
	setsaveddvar( "cg_drawcrosshair", "1" );
}


//FIRST ENCOUNTER	
dialog_first_encounter()
{
	level endon( "clifftop_patrol1_dead" );

	flag_wait( "first_two_guys_in_sight" );
	flag_wait( "price_two_guys_in_sight" );// price in pos

	level endon( "interupt_first_encounter" );
	thread player_interupt_first_encounter();

	thread dialog_nag_player_too_far();
	level.player waittill_entity_in_range( level.price, 300 );
	flag_set( "first_encounter_dialog_starting" );


	//Soap, these muppets have no idea we�re here. Let�s take this nice and slow.
	level.price dialogue_queue( "cliff_pri_noidea" );

	//You take the one on the left. 
	level.price dialogue_queue( "cliff_pri_youtakeleft" );

	thread price_stops_during_dialog();

	//level.price disable_ai_color();//dont start moving to a new node

	// � �On three.�
	level.price PlaySound( "Cliff_pri_onthree" );
	wait 1;

	// � �One��
	level.price PlaySound( "Cliff_pri_one" );
	wait 1;

	// � �Two��
	level.price PlaySound( "Cliff_pri_two" );
	wait 1;

	// � �Three.�
	level.price PlaySound( "Cliff_pri_three" );
	wait .2;

	flag_set( "first_encounter_dialog_finished" );

	targetguy = get_living_ai( "patrollers_1_rightguy", "script_noteworthy" );
	targetguy2 = get_living_ai( "patrollers_1_leftguy", "script_noteworthy" );
	if ( IsAlive( targetguy ) )
	{
		targetguy thread price_stealth_kills_guy( targetguy2 );
	}
	else
	{
		if ( IsAlive( targetguy2 ) )
			targetguy2 thread price_stealth_kills_guy( targetguy );
		else
			thread price_goes_in_two();
	}
}





price_climbs_ledge()
{
	flag_wait( "price_go_to_climb_ridge" );

	price_ledgeclimb = GetEntArray( "price_ledgeclimb", "targetname" );
	price_ledgeclimb[ 0 ] anim_reach_solo( level.price, "ledge_climb" );
	price_ledgeclimb[ 0 ] anim_single_solo( level.price, "ledge_climb" );


	level.price enable_ai_color();
	GetEnt( "price_position_on_ridge", "targetname" ) notify( "trigger" );
}

price_goes_in_two()
{
	wait 2;
	level.price.fixednode = true;
	level.price enable_ai_color();
}

price_stops_during_dialog()
{
	level.price.fixednode = false;
	level.price disable_ai_color();
	level.price SetGoalPos( level.price.origin );
	level.price.goalradius = 8;
}

dialog_nag_player_too_far()
{
	level endon( "first_encounter_dialog_starting" );
	level endon( "second_encounter_dialog_starting" );
	level endon( "interupt_first_encounter" );
	level endon( "interupt_second_encounter" );

	wait 3;

	/*
	if( !flag( "said_two_tangos_in_front" ) )
	{
		flag_set( "said_two_tangos_in_front" );
		//Two tangos in front.	
		level.price dialogue_queue( "cliff_pri_2tangosfront" );
		
		wait 2;
	}
	*/
	//Get over here.	
	level.price dialogue_queue( "cliff_pri_getoverhere" );
}


player_interupt_first_encounter()
{
	level endon( "first_encounter_dialog_finished" );

	wait_for_player_interupt( "airfield_in_sight" );
	wait .5;

	if ( !flag( "first_encounter_dialog_finished" ) )
		level.price StopSounds();

	flag_set( "interupt_first_encounter" );

	targetguy = get_living_ai( "patrollers_1_rightguy", "script_noteworthy" );
	targetguy2 = get_living_ai( "patrollers_1_leftguy", "script_noteworthy" );
	if ( IsAlive( targetguy ) )
		targetguy.dontattackme = undefined;
	if ( IsAlive( targetguy2 ) )
		targetguy2.dontattackme = undefined;

	level.price disable_ai_color();
	level.price.fixednode = false;
	level.price SetGoalPos( level.price.origin );

	flag_wait( "clifftop_patrol1_dead" );

	level.price.fixednode = false;
	level.price enable_ai_color();
}

dialog_first_encounter_success()
{
	level endon( "interupt_first_encounter" );
	level endon( "_stealth_spotted" );
	flag_wait( "first_encounter_dialog_finished" );
	flag_wait( "clifftop_patrol1_dead" );

	wait .5;
	if ( !flag( "player_killed_one_first_two_encounters" ) )
	{
		//I guess I have to do everything?	
		level.price dialogue_queue( "cliff_pri_doeverything" );
		level.said_i_do_everything = true;
	}
	else
	{
		//cliff_pri_nicelydone
		level.price dialogue_queue( "cliff_pri_nicelydone" );
		flag_set( "said_nicely_done" );
	}
}


dialog_first_encounter_failure()
{
	failure = false;
	flag_wait( "clifftop_patrol1_dead" );
	if ( flag( "_stealth_spotted" ) )
		failure = true;
	wait .5;

	//cliff_pri_dontalertthem
	if ( failure )
	{
		level.price dialogue_queue( "cliff_pri_dontalertthem" );
		flag_set( "said_dont_alert_them" );
	}
}


//SECOND ENCOUNTER	
dialog_second_encounter()
{
	level endon( "_stealth_spotted" );
	level endon( "clifftop_patrol2_dead" );
	flag_wait( "second_two_guys_in_sight" );// price hits this

	//thread dialog_second_encounter_failure();
	level endon( "interupt_second_encounter" );
	thread player_interupt_second_encounter();

	thread dialog_nag_player_too_far();
	level.player waittill_entity_in_range( level.price, 300 );
	flag_clear( "player_killed_one_first_two_encounters" );
	flag_set( "second_encounter_dialog_starting" );

	if ( flag( "said_nicely_done" ) )
		//Same plan.
		level.price dialogue_queue( "cliff_pri_sameplan" );
	else
		//You take the one on the left. 
		level.price dialogue_queue( "cliff_pri_youtakeleft" );

	// � �On three.�
	level.price PlaySound( "Cliff_pri_onthree" );
	wait 1;

	// � �One��
	level.price PlaySound( "Cliff_pri_one" );
	wait 1;

	// � �Two��
	level.price PlaySound( "Cliff_pri_two" );
	wait 1;

	// � �Three.�
	level.price PlaySound( "Cliff_pri_three" );
	wait .2;

	flag_set( "second_encounter_dialog_finished" );

	targetguy = get_living_ai( "patrollers_2_rightguy", "script_noteworthy" );
	targetguy2 = get_living_ai( "patrollers_2_leftguy", "script_noteworthy" );
	if ( IsAlive( targetguy ) )
		targetguy thread price_stealth_kills_guy( targetguy2 );
}

player_interupt_second_encounter()
{
	level endon( "second_encounter_dialog_finished" );

	wait_for_player_interupt( "player_passing_second_encounter" );
	wait .5;

	if ( !flag( "second_encounter_dialog_finished" ) )
		level.price StopSounds();

	flag_set( "interupt_second_encounter" );

	targetguy = get_living_ai( "patrollers_2_rightguy", "script_noteworthy" );
	targetguy2 = get_living_ai( "patrollers_2_leftguy", "script_noteworthy" );
	if ( IsAlive( targetguy ) )
		targetguy.dontattackme = undefined;
	if ( IsAlive( targetguy2 ) )
		targetguy2.dontattackme = undefined;

	level.price disable_ai_color();
	level.price.fixednode = false;
	level.price SetGoalPos( level.price.origin );

	flag_wait( "clifftop_patrol2_dead" );

	level.price.fixednode = false;
	level.price enable_ai_color();
}

dialog_second_encounter_success()
{
	level endon( "interupt_second_encounter" );
	level endon( "_stealth_spotted" );
	flag_wait( "second_encounter_dialog_finished" );
	flag_wait( "clifftop_patrol2_dead" );

	wait .5;

	if ( !flag( "player_killed_one_first_two_encounters" ) )
	{
		if ( IsDefined( level.said_i_do_everything ) )
		{
			//This is easier when you do some of the work.	
			level.price dialogue_queue( "cliff_pri_somework" );
		}
		else
		{
			//I guess I have to do everything?	
			level.price dialogue_queue( "cliff_pri_doeverything" );
		}
		return;
	}

	if ( flag( "said_nicely_done" ) )
	{
		//Nice work.	
		level.price dialogue_queue( "cliff_pri_nicework" );
	}
	else
	{
		//cliff_pri_nicelydone
		level.price dialogue_queue( "cliff_pri_nicelydone" );
	}
	flag_set( "said_nicely_done" );
}


dialog_second_encounter_failure()
{
	failure = false;
	flag_wait( "clifftop_patrol2_dead" );
	if ( flag( "_stealth_spotted" ) )
	{
		//flag_waitopen( "_stealth_spotted" );
		failure = true;
	}
	if ( flag( "interupt_second_encounter" ) )
	{
		failure = true;
	}
	wait .5;

	if ( failure )
	{
		if ( flag( "said_dont_alert_them" ) )
		{
			//Not very sneaky, Soap.	
			level.price dialogue_queue( "cliff_pri_notsneaky" );
		}
		//cliff_pri_dontalertthem
		else
		{
			level.price dialogue_queue( "cliff_pri_dontalertthem" );
			flag_set( "said_dont_alert_them" );
		}
	}
}

blizzard_starts()
{
	thread maps\_blizzard::blizzard_level_transition_hard( 40 );
	thread maps\_utility::set_ambient( "snow_base_white" );
	flag_set( "whiteout_started" );
	//settings for blizzard
	wait 20;

	flag_set( "blizzard_halfway" );
	sight_ranges_blizzard();

	wait_for_flag_or_timeout( "blizzard_finish", 20 );

	variable_blizzard();
}

dialog_storm_moving_in()
{
	flag_wait_either( "clifftop_patrol2_dead", "price_go_to_climb_ridge" );
	wait 3;// avoid overlap with post patrol 2 dead dialog
	flag_wait( "blizzard_halfway" );

	if ( !flag( "someone_became_alert" ) || !flag( "_stealth_spotted" ) )
	{
		//The storm's brewing up.	
		level.price dialogue_queue( "cliff_pri_stormsbrewing" );
	}
	flag_set( "said_storm_brewing" );
}

dialog_go_do_the_work()
{
	flag_wait( "price_at_climbing_spot" );
	flag_wait( "said_storm_brewing" );

	//flag_set( "conversation_active" );
	if ( flag( "someone_became_alert" ) || flag( "_stealth_spotted" ) )
		return;

	level endon( "someone_became_alert" );

	//Let�s split up. I'll use the thermal scope and provide overwatch from this ridge.	
	play_Sound_Over_Radio_use_que( "cliff_pri_splitup" );

	wait .2;

	//Use the cover of the storm to enter the base.         	
	Play_Sound_Over_Radio_Use_Que( "cliff_pri_coverofstorm" );

	wait .5;

	//You'll be like a ghost in this blizzard, so the guards won�t see you until you�re very close.	
	play_Sound_Over_Radio_use_que( "cliff_pri_likeaghost" );

	wait .2;

	//Keep an eye on your heart beat sensor, good luck.
	play_Sound_Over_Radio_use_que( "cliff_pri_keepeyeonheart" );

	flag_set( "said_lets_split_up" );
}


dialog_your_in()
{
	level endon( "base_c4_planted" );
	flag_wait( "give_c4_obj" );

	//flag_waitopen( "_stealth_spotted" );
	if ( flag( "someone_became_alert" ) || flag( "_stealth_spotted" ) )
		return;

	//All right, I've tapped into their comms.	
	thread play_Sound_Over_Radio_use_que( "cliff_pri_tappedcomms" );

	//Head southeast and plant your C4 at the fueling station. 	
	thread play_Sound_Over_Radio_use_que( "cliff_pri_yourein_2" );

	//We may need to go to �Plan B� if things go south.	
	thread play_Sound_Over_Radio_use_que( "cliff_pri_yourein_3" );

}



//enemy_lives()
//{
//	if ( self doingLongDeath() )
//		return false;
//
//	return Distance( level.player.origin, self.origin ) < 1350;
//}

//enemies_rush_or_die()
//{
//	//Took the scenic route eh?	
//	//level.price thread dialogue_queue( "cliff_pri_scenicroute" );
//
//
//	if( isalive( level.truck_patrol ) )
//		level.truck_patrol Vehicle_SetSpeed( 0, 15 );
//
//	flag_set( "script_attack_override" );
//	level.hanger_path_attackers = 0;
//	enemies = GetAIArray( "axis" );
//	foreach ( enemy in enemies )
//	{
//		if ( IsDefined( enemy.script_noteworthy ) )
//		{
//			if ( ( enemy.script_noteworthy == "welder_wing" ) || ( enemy.script_noteworthy == "welder_engine" ) )
//				continue;
//		}
//		if( isdefined( enemy.ridingvehicle ) )
//			enemy delete();
//
//		if ( enemy enemy_lives() )
//		{
//			enemy ent_flag_clear( "_stealth_enabled" );
//			enemy disable_cqbwalk();
//			enemy.goalradius = 32;
//			enemy SetGoalEnt( level.player );
//			enemy thread hanger_path_handle_death();
//			enemy thread dialog_brought_friends();
//			level.hanger_path_attackers++;
//		}
//		else
//		{
//			timer = RandomFloat( 1 );
//			enemy delayCall( 1, ::Kill );
//			enemy.DropWeapon = false;
//		}
//	}
//
//	while ( level.hanger_path_attackers > 0 )
//		wait 1;
//}
//
//hanger_path_handle_death()
//{
//	self waittill( "death" );
//	level.hanger_path_attackers--;
//}


//dialog_brought_friends()
//{
//	self endon( "death" );
//	level endon( "brought_friends" );
//	while ( 1 )
//	{
//		if ( self CanSee( level.price ) )
//			break;
//		wait .1;
//	}
//	if ( !flag( "brought_friends" ) )
//	{
//		//Brought some friends with you?	
//		level.price thread dialogue_queue( "cliff_pri_broughtfriends" );
//	}
//
//	flag_set( "brought_friends" );
//}


turn_off_blizzard()
{
	level notify( "kill_variable_blizzard" );
	thread maps\_blizzard::blizzard_level_transition_light( 9 );
	thread maps\_utility::set_ambient( "snow_base" );
	wait 9;
	
	//settings for no blizzard
	sight_ranges_long();
}



setup_stealth_enemy_cleanup()
{
	self.pathrandompercent = 200;
	self thread disable_cqbwalk();
	if( isdefined( self.script_stealthgroup ) )
		self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	
	self.goalradius = 400;
	self.favoriteenemy = level.player;
	self setgoalentity( level.player );
}


//dialog_took_scenic_route()
//{
//	//Took the scenic route eh?	
//	level.price thread dialogue_queue( "cliff_pri_scenicroute" );
//
//	price_comes_out = GetNode( "price_comes_out", "targetname" );
//	level.price SetGoalNode( price_comes_out );
//	level.price.goalradius = 16;
//	//level.price SetGoalPos( ( -9480.4, -25550.3, 898 ) );
//
//
//	//end idle
//	for ( ;; )
//	{
//		if ( Distance( level.player.origin, level.price.origin ) < 350 )
//			break;
//		wait( 0.25 );
//	}
//
//	if ( flag( "_stealth_spotted" ) || flag( "someone_became_alert" ) )
//		enemies_rush_or_die();
//}


price_is_captured()
{
	level.player endon( "detonate" );

	//level.player store_players_weapons( "c4_moment" );

//	level.player.pweapon = level.player GetCurrentWeapon();
//	level.player GiveWeapon( "c4" );
//	level.player SetWeaponAmmoClip( "c4", 0 );

	thread detect_player_shot();

	price_talks_about_compromised();
	thread price_died_you_lose();
}

price_died_you_lose()
{
	flag_clear( "can_save" );
	level notify( "kill_price" );
	level.price.ignoreme = false;
	level.price stop_magic_bullet_shield();
	wait( 0.5 );
	if ( IsAlive( level.price ) )
	{
		level.price.allowdeath = true;
		level.price StopAnimScripted();
		level.price Kill();
	}
	wait( 2.5 );

	// Captain MacTavish was executed.
	SetDvar( "ui_deadquote", &"CLIFFHANGER_PRICE_DIED" );
	missionFailedWrapper();
	level.player waittill( "detonate" );
}

detect_player_shot()
{
	level endon( "stop_detecting_player_shot" );
	level.player endon( "detonate" );
	level.player endon( "death" );
	level.price endon( "death" );

	wait( 0.1 );// for the start point to get the player to the right spot
	last_weapon = "";
	last_ammo = 0;
	for ( ;; )
	{
		if ( flag( "player_steps_into_view" ) || level.player IsThrowingGrenade() )
		{
			level.player delayThread( 1, ::send_notify, "player_shot" );
			return;
		}

		weapon = level.player GetCurrentWeapon();
		if ( weapon == "none" )
		{
			ammo = 0;
		}
		else
		{
			ammo = level.player GetWeaponAmmoClip( weapon );

			if ( weapon == last_weapon && ammo < last_ammo )
			{
				level.player delayThread( 1, ::send_notify, "player_shot" );
				return;
			}
		}
		last_weapon = weapon;
		last_ammo = ammo;
		wait( 0.05 );
	}
}


price_starts_shooting()
{
	if ( !isalive( level.price ) )
		return;
	level.price endon( "death" );

	level.price.dontEverShoot = true;

	flag_wait( "start_big_explosion" );

	level.price.dontEverShoot = undefined;
	level.price disable_cqbwalk();
	if ( level.price ent_flag_exist( "_stealth_enabled" ) )
		level.price ent_flag_clear( "_stealth_enabled" );

	//price_targets
	old_acc = level.price.baseaccuracy;
	level.price.baseaccuracy = 5000;
	level.price SetGoalPos( level.price.origin );
	level.price disable_ai_color();
	level.price.goalradius = 64;

	/*
	while( !flag( "capture_enemies_dead" ) )
	{
		new_target = get_closest_living( level.price.origin, level.price_targets );
		if( !isalive( new_target ) )
			break;
		new_target.ignoreme = false;
		new_target waittill ( "death" );
	}
	*/
	flag_wait( "capture_enemies_dead" );
	level.price.baseaccuracy = old_acc;
}

price_talks_about_compromised()
{
	level.player endon( "player_shot" );
	wait( 2 );

	level.petrov = GetEnt( "petrov_org", "targetname" );
	level.petrov.animname = "price";

	// "Soap, I've been compromised! Keep a low profile and hold your fire." 
	level.price dialogue_queue( "compromised" );

	// "This is major petrov! Come out with your hands up!
	level.petrov dialogue_queue( "petrov" );

	if ( GetDvar( "player_has_witnessed_capture" ) == "1" )
	{
		// player died once already so skip ahead
		flag_set( "player_can_see_capture" );
		waittillframeend;// for price_tells_you_plan_b() to progress
	}

	// extra lines if the player is hanging out in the room
	petrov_optional_encouragement_lines();

	if ( flag( "player_can_see_capture" ) )
	{
		// "You have five seconds to comply!"
		level.petrov dialogue_queue( "fiveseconds" );
	}

	thread price_tells_you_plan_b();

	if ( flag( "player_can_see_capture" ) )
	{
		wait( 1.2 );
	}
	wait( 0.5 );
	level.petrov dialogue_queue( "count_five" );
	wait( 1 );
	level.petrov dialogue_queue( "count_four" );
	wait( 1 );
	level.petrov dialogue_queue( "count_three" );
	wait( 1 );
	level.petrov dialogue_queue( "count_two" );
	wait( 1 );
	level.petrov dialogue_queue( "count_one" );
	wait( 2 );
}

price_tells_you_plan_b()
{
	if ( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	flag_wait( "player_can_see_capture" );
	SetDvar( "player_has_witnessed_capture", 1 );

	// "Soap, Go to plan b
	level.price dialogue_queue( "plan_b" );

	level notify( "stop_detecting_player_shot" );

	level.player GiveWeapon( "c4" );
	level.player SetWeaponAmmoClip( "c4", 0 );
	level.player_weapon = level.player GetCurrentWeapon();
	level.player SwitchToWeapon( "c4" );
	level.player DisableWeaponSwitch();
	level.player DisableOffhandWeapons();

	level.player endon( "detonate" );
	flag_wait( "player_steps_into_view" );
	level.player notify( "player_shot" );
}

petrov_optional_encouragement_lines()
{
	if ( flag( "player_can_see_capture" ) )
		return;

	level endon( "player_can_see_capture" );

	// To enemy infiltrators, we have captured one of your comrades!	
	level.petrov dialogue_queue( "cliff_pet_capturedcomrade" );

	// We know you are up there! Surrender now and we will spare your comrade!	
	level.petrov dialogue_queue( "cliff_pet_surrender" );

	// If you do not surrender, your comrade will die.	
	level.petrov dialogue_queue( "cliff_pet_willdie" );

	// Come out with your hands up!	
	level.petrov dialogue_queue( "cliff_pet_handsup" );

	// Very well - I will give you five seconds before I execute your comrade!	
	level.petrov dialogue_queue( "cliff_pet_verywell" );
}

check_player_detonate()
{
	level.player waittill( "detonate" );
	flag_set( "player_detonate" );
}



soap_opens_hanger_door()
{
	//* Let�s go.	
	level.price dialogue_queue( "letsgo" );	
	level.price enable_cqbwalk();
	
	anim_ent = GetEnt( "hanger_entrance_animent", "targetname" );
	anim_ent anim_reach_and_approach_solo( level.price, "hunted_open_barndoor", undefined, "Cover Right" );
	//anim_ent anim_single_solo( level.price, "hunted_open_barndoor_stop" );
	//anim_ent thread anim_loop_solo( level.price, "hunted_open_barndoor_idle", "stop_idle" );


	//anim_ent notify( "stop_idle" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_barndoor" );
	
	locker_1 = spawn_anim_model( "locker_1" );
	locker_2 = spawn_anim_model( "locker_2" );
	level.lockers = [];
	level.lockers[ level.lockers.size ] = locker_1;
	level.lockers[ level.lockers.size ] = locker_2;
	locker_brawl = GetEnt( "locker_brawl", "targetname" );
	locker_brawl anim_first_frame( level.lockers, "locker_brawl" );

	door = GetEnt( "hanger_entrance_door", "targetname" );
	attachments = GetEntArray( door.target, "targetname" );
	for ( i = 0; i < attachments.size; i++ )
	{
	    attachments[ i ] LinkTo( door );
	}
	door hunted_style_door_open();

	for ( i = 0; i < attachments.size; i++ )
	{
		if ( attachments[ i ].classname == "script_brushmodel" )
	   		attachments[ i ] ConnectPaths();
	}
	level.price disable_cqbwalk();
}




guards_run_in()
{
	guard1 = get_guy_with_script_noteworthy_from_spawner( "hanger_capture_enemy1" );
	guard2 = get_guy_with_script_noteworthy_from_spawner( "hanger_capture_enemy2" );
	guard3 = get_guy_with_script_noteworthy_from_spawner( "hanger_capture_enemy3" );
	guard4 = get_guy_with_script_noteworthy_from_spawner( "hanger_capture_enemy4" );

	guard1.animname = "guard1";
	guard2.animname = "guard2";
	guard3.animname = "guard3";
	guard4.animname = "guard4";

	enemies = [];
	enemies [ enemies.size ] = guard1;
	enemies [ enemies.size ] = guard2;
	enemies [ enemies.size ] = guard3;
	enemies [ enemies.size ] = guard4;


	array_thread( enemies, ::dont_shoot_till_explosion );
	array_thread( enemies, ::explosion_reaction );
	array_thread( enemies, ::run_in_and_shout );
	foreach ( guy in enemies )
	{
		guy disable_surprise();
		guy AllowedStances( "crouch" );
	}
	//array_thread( enemies, ::create_price_target );

//	thread random_yelling( enemies );
//	thread random_yelling( enemies );// call twice to have upto 2 guys yelling at once

	//hanger_enemies_enter thread anim_first_frame( enemies, "runin" );
}


capture_guy_think()
{
	self thread	dont_shoot_till_explosion();
	self thread explosion_reaction();
	self thread capture_shouting();
	self thread enable_cqbwalk();

	self AllowedStances( "stand" );
}


more_guards()
{
	enemies = GetEntArray( "hanger_capture_enemies", "targetname" );
	array_thread( enemies, ::add_spawn_function, ::capture_guy_think );
	array_thread( enemies, ::spawn_ai );
}

capture_shouting()
{
	self endon( "death" );
	//You can throw these in randomly on the guys in CQB to make them less static.
	//level.scr_anim[ "generic" ][ "capture_shouting" ]		= %CQB_stand_shout_A;
	//level.scr_anim[ "generic" ][ "capture_shouting" ]		= %CQB_stand_shout_B;

	shout = [];
	shout [ shout.size ] = "capture_shoutingA";
	shout [ shout.size ] = "capture_shoutingB";

	self waittill( "goal" );

	wait 1;

	self anim_generic( self, shout[ RandomInt( shout.size ) ] );
}

explosion_reaction()
{
	self endon( "death" );
	//added 5 reaction animations for cliffhanger capture sequence. 
	reaction = [];
	reaction [ reaction.size ] = "explosion_reactA";
	reaction [ reaction.size ] = "explosion_reactB";
	reaction [ reaction.size ] = "explosion_reactC";
	reaction [ reaction.size ] = "explosion_reactD";
	reaction [ reaction.size ] = "explosion_reactE";

	flag_wait( "start_big_explosion" );
	wait( RandomFloatRange( 0, .5 ) );

	self.allowdeath = true;
	self.health = 1;
	self.a.pose = "stand";
	self anim_generic( self, reaction[ RandomInt( reaction.size ) ] );

}



open_hanger_doors()
{
	hangar_leftdoor_goal = GetEnt( "hangar_leftdoor_goal", "targetname" );
	hangar_leftdoor = GetEnt( "hangar_leftdoor", "targetname" );
	hangar_leftdoor thread door_slides_open( hangar_leftdoor_goal );

	hangar_rightdoor_goal = GetEnt( "hangar_rightdoor_goal", "targetname" );
	hangar_rightdoor = GetEnt( "hangar_rightdoor", "targetname" );
	hangar_rightdoor thread door_slides_open( hangar_rightdoor_goal );

	hangar_leftdoor PlaySound( "door_hanger_metal_open" );
	wait( 0.3 );
//	hangar_rightdoor PlaySound( "door_hanger_metal_open" );
}

door_slides_open( door_goal )
{
	dif = 0.985;
	fraction_door_goal = self.origin * dif + door_goal.origin * ( 1 - dif );
	self MoveTo( fraction_door_goal, 1.15, 0.4, 0.7 );
	self ConnectPaths();
	self PlaySound( "door_hanger_metal_open" );

	wait( 1.5 );
	dif = 0.15;
	fraction_door_goal = self.origin * dif + door_goal.origin * ( 1 - dif );
	timer = 4.2;
	self MoveTo( fraction_door_goal, timer, 1, 0.4 );
	wait( timer );
	self DisconnectPaths();
}

instant_open_hangar_doors()
{
	hangar_leftdoor_goal = GetEnt( "hangar_leftdoor_goal", "targetname" );
	hangar_leftdoor = GetEnt( "hangar_leftdoor", "targetname" );
	hangar_leftdoor thread door_instantly_open( hangar_leftdoor_goal );

	hangar_rightdoor_goal = GetEnt( "hangar_rightdoor_goal", "targetname" );
	hangar_rightdoor = GetEnt( "hangar_rightdoor", "targetname" );
	hangar_rightdoor thread door_instantly_open( hangar_rightdoor_goal );
}

door_instantly_open( door_goal )
{
	dif = 0.15;
	fraction_door_goal = self.origin * dif + door_goal.origin * ( 1 - dif );
	self.origin = fraction_door_goal;
	self DisconnectPaths();
}

dont_shoot_till_explosion()
{
	self endon( "death" );
	self.dontEverShoot = true;

	self.goalradius = 64;
	self.script_forcegoal = true;

	flag_wait( "start_big_explosion" );
	self.allowdeath = true;

	wait 3;

	self.dontEverShoot = undefined;
}

player_slow_mo( parameter1, parameter2 )
{
	if ( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	flag_wait( "start_big_explosion" );

	wait .5;
	level.player Unlink();
	//level.player_rig Delete();
	level.player EnableWeapons();
	level.player TakeWeapon( "c4" );
	level.player EnableWeaponSwitch();
	level.player EnableOffhandWeapons();
	
	weapon = level.player_weapon;
	if ( !level.player HasWeapon( weapon ) )
	{
		weapon = level.player GetWeaponsListPrimaries()[ 0 ];
		if ( !isdefined( weapon ) )
		{
			weapon = level.player GetWeaponsListAll()[ 0 ];
		}
	}
	
	level.player SwitchToWeapon( weapon );
	//level.player restore_players_weapons( "c4_moment" );	
	
	level.player SetMoveSpeedScale( 1 );

	level.player AllowProne( true );
	level.player AllowCrouch( true );
	thread waittill_reload();

	//collision = GetEnt( "satelite_collision", "targetname" );
	//collision NotSolid();

	flag_wait( "end_big_explosion" );

	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		guy.baseaccuracy = 0;
	}

	slowmo_start();
	slowmo_setspeed_slow( 0.3 );// was .15
	slowmo_setlerptime_in( 0.05 );
	slowmo_lerp_in();

	//flag_wait_either( "capture_enemies_dead", "player_reloading" );
	wait( 0.5 ); //was .5

	//slowmo_setlerptime_out( 0.01 );
	slowmo_setlerptime_out( 1 );
	slowmo_lerp_out();
	slowmo_end();
	
	level.price gun_recall();

	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		guy.baseaccuracy = tarmac_base_Accuracy();
	}

	wait 2;
	flag_set( "hanger_slowmo_ends" );
	wait 3;
	autosave_by_name( "slowmo_ends" );
	//iprintlnbold( "END OF SCRIPTED LEVEL" );
}

tarmac_base_Accuracy()
{
	return 0.42;
}

explosion_chain_reaction( parameter1, parameter2 )
{
	exploder( 8 );
	//fuel_tanks = GetEntArray( "fuel_tank", "script_noteworthy" );
	//array_thread( fuel_tanks, ::destructible_force_explosion );

	wait .2;
	exploder( 12 );
	//fuel_truck1 = GetEnt( "fuel_truck1", "script_noteworthy" );
	//playfx( level._effect[ "fuel_truck_explosion" ], fuel_truck1.origin );

	wait .1;

	exploder( 10 );
	//fuel_truck2 = GetEnt( "fuel_truck2", "script_noteworthy" );
	//playfx( level._effect[ "fuel_truck_explosion" ], fuel_truck2.origin );

	wait .2;

	flag_set( "end_big_explosion" );

	wait .2;

	set_off_destructible_with_noteworthy( "mig1" );

	wait .2;

	set_off_destructible_with_noteworthy( "mig2" );

	wait .5;

	if ( IsDefined( level.explosion_enemies ) )
	{
		// kill the farther away enemies.	
		enemies = level.explosion_enemies;
		enemies = remove_dead_from_array( enemies );
		enemies = get_array_of_closest( level.player.origin, enemies );
		for ( i = 6; i < enemies.size; i++ )
		{
			org = randomvector( 10 );
			org = ( org[ 0 ], org[ 1 ], abs( org[ 2 ] ) );
			org += enemies[ i ].origin;
			//RadiusDamage( org, 32, 500, 500, enemies[ i ] );
			enemies[ i ] Kill();
			//Print3d( org, "x", ( 1, 0, 0 ), 1, 1, 100 );
			wait( 0.05 );
		}
	
	}
}


waittill_reload()
{
	level.player waittill( "reload_start" );
	flag_set( "player_reloading" );

	/*
		if ( ( level.player GetWeaponAmmoClip( level.gunPrimary ) ) < level.gunPrimaryClipAmmo )
		{
			thread keyHint( "reload" );
			while ( ( level.player GetWeaponAmmoClip( level.gunPrimary ) ) < level.gunPrimaryClipAmmo )
				wait .1;
			clear_hints();
			wait 1;
		}
		*/
}


clear_all_ai_grenades()
{
	add_global_spawn_function( "axis", ::no_grenades );
	ai = GetAIArray( "axis" );
	foreach ( guy in ai )
	{
		guy no_grenades();
	}
}

no_grenades()
{
	self.grenadeammo = 0;
}

connect_and_delete()
{
	if ( self.code_classname == "script_brushmodel" )
		self ConnectPaths();
	self Delete();
}

lower_ai_accuracy()
{
	self.baseaccuracy = tarmac_base_Accuracy();
}

e3_text_hud( text )
{
	hudelem = NewHudElem();
	hudelem.alignX = "center";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "center";
	hudelem.vertAlign = "middle";

//	hudelem.x = 80;
//	hudelem.y = 80 + index * 18;
	hudelem.x = 0;
	hudelem.y = 0;
	hudelem SetText( text );
	hudelem.alpha = 0;
	hudelem.foreground = true;
	hudelem.sort = 150;

	hudelem.fontScale = 1.75;
//	hudelem FadeOverTime( 0.5 );
//	hudelem.alpha = 1;
	return hudelem;
}

is_e3_start()
{
	starts = [];
	starts[ "e3" ] = true;
//	starts[ "tarmac" ] = true;
//	starts[ "jump" ] = true;

	return IsDefined( starts[ level.start_point ] );
}

stealth_achievement()
{
	flag_init( "broke_stealth" );
	
	flag_wait_any( "_stealth_spotted", "someone_became_alert" );
	flag_set( "broke_stealth" );
}

save_game_if_safe( saveID )
{
	wait 3;
	if ( !isalive( level.price ) )
		return;

	if ( !level.price.damageshield )
		return;
		
	if ( !maps\_autosave::autosavecheck() )
		return;
		
	CommitSave( saveID );
}