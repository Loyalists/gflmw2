#include maps\_utility;
#include common_scripts\utility;
#include animscripts\utility;
#include maps\_anim;
#include maps\_vehicle;
//#include maps\af_chase_code;
//#include maps\af_chase_zodiac;
#include maps\af_chase_knife_fight_code;
#include maps\_hud_util;


ENDING_MOVE_SPEED = 0.45;

add_knife_fight_starts()
{
	add_start( "wakeup", 		 		::start_wakeup_after_crash, "", 					::wakeup_after_crash );
	add_start( "wakefast", 		 		::start_wakeup_after_crash, "", 					::wakeup_after_crash );
	add_start( "turnbuckle", 			::start_turnbuckle, "", 							::fight_turnbuckle );
	add_start( "gloat", 				::start_shepherd_gloats, "", 						::shepherd_gloats );
	add_start( "gun_drop", 	 			::start_gun_drop, "", 								::gun_drop );
	add_start( "crawl", 				::start_gun_crawl, "", 								::gun_crawl );
	add_start( "gun_kick", 				::start_gun_kick, "", 								::gun_kick );
	add_start( "wounded", 				::start_wounded_show, "Watch Price/Shep fight", 	::wounded_show );
	add_start( "pullout", 				::start_knife_pullout, "", 	 						::knife_pullout );
	add_start( "kill", 					::start_knife_kill, "", 	 						::knife_kill );
	add_start( "price_wakeup", 			::start_price_wakeup, "", 							::price_wakeup );
	add_start( "walkoff", 				::start_walkoff, "", 								::walkoff );

}


init_ending()
{
	// ^3[{+usereload}]^7
	add_hint_string( "knife", &"AF_CHASE_PRESS_USE", ::stop_pressing_use );
	// ^3[{+attack}]^7
	add_hint_string( "hint_crawl_right", &"AF_CHASE_HINT_CRAWL_RIGHT", ::hint_crawl_right );
	// ^3[{+speed_throw}]^7
	add_hint_string( "hint_crawl_left", &"AF_CHASE_HINT_CRAWL_LEFT", ::hint_crawl_left );

	add_hint_string( "hint_melee", &"AF_CHASE_HINT_MELEE_EMPTY", ::stop_melee_hint );

	flag_init( "player_learned_melee" );

	flag_init( "stop_heart" );
	flag_init( "fell_off_waterfall" );
	flag_init( "shepherd_spawned" );
	flag_init( "wakeup_start" );
	flag_init( "player_standing" );
	flag_init( "focused_on_knife" );
	flag_init( "player_looks_at_knife" );
	flag_init( "helicopter_sound_played" );
	flag_init( "player_uses_knife" );
	flag_init( "player_aims_knife_at_shepherd" );
	flag_init( "stop_aftermath_player" );
	flag_init( "two_hand_pull_begins" );
	flag_init( "price_shepherd_fight_e_flag" );
	flag_init( "gloat_fade_in" );

	flag_init( "dialog_all_finished" );
	flag_init( "fog_pulse_window_for_spawn" );
	flag_init( "player_near_shepherd" );
	flag_init( "turn_buckle_fadeout" );
	flag_init( "steady_boat_participating" );
	flag_init( "trigger_over_waterfall" );
	flag_init( "shepherd_stumbles_by" );
	flag_init( "shepherd_killed" );
	flag_init( "player_throws_knife" );
	flag_init( "fade_away_idle_crawl_fight" );
	flag_init( "price_told_player_to_hold_steady" );
	flag_init( "stop_boat_dialogue" );
	flag_init( "af_chase_nextmission" );
	flag_init( "shepherd_should_do_idle_b" );
	flag_init( "player_touched_shepherd" );
	flag_init( "bloody_player_rig" );
	flag_init( "end_heli_crashed" );
	flag_init( "end_heli_nearly_crashed" );
	flag_init( "player_gets_up_after_waterfall" );
	flag_init( "water_cliff_jump_splash_sequence" );
	flag_init( "killed_pickup_heli" );
	flag_init( "fog_out_stumble_shepherd" );
	flag_init( "blinder_effect" );
	flag_init( "goodtime_for_fog_blast" );
	flag_init( "sandstorm_fully_masked" );
	flag_init( "fight_objective_positioned" );
	flag_init( "turn_buckle_start" );
	flag_init( "af_chase_final_ending" );
	flag_init( "af_chase_ending_credits" );
	flag_init( "af_chase_final_fight" );
	thread maps\_aftermath_player::main();
}

init_main_and_ending_common_stuff()
{
	set_water_sheating_time( "bump_small_start", "bump_big_start" );

	level.DODGE_DISTANCE = 2500;
	level.POS_LOOKAHEAD_DIST = 1200;

	maps\_compass::setupMiniMap( "compass_map_afghan_chase" );

	maps\createart\af_chase_fog::main();

	waittillframeend; // after _load	
	if ( isdefined( level.stop_load ) && level.stop_load )
		return;

	level thread maps\af_chase_amb::main();
}

empty()
{
}


Ending_common()
{
//	thread end_credits();
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );
	set_ambient( "af_chase_ext" );
	
	init_fight_physics();
	
	trigger_multiple_visionset = getentarray( "trigger_multiple_visionset", "classname" );
	array_call( trigger_multiple_visionset, ::delete );	


	level.player SetEqLerp( 1, level.eq_main_track );
	level.player AllowJump( false );

	thread ending_common_speed();
	
	thread eq_blender();
	thread maps\_ambient::use_eq_settings( "fadeout_noncritical", level.eq_mix_track );

	anim.fire_notetrack_functions[ "empty_script" ] = ::empty;
	
	ent = spawn_tag_origin();
	level.fov_ent = ent;
	
	fov = GetDvarInt( "cg_fov" );
	ent.origin = ( fov, 0, 0 );
	ent thread blend_fov();

	delaythread( 0.05, ::slowmo_sound_adjustment );

	thread maps\_aftermath_player::aftermath_style_walking();
	cast_structs_to_origins();// easier than rotating a bunch of WIP locations

	SetSavedDvar( "g_friendlyNameDist", 0 );
	SetSavedDvar( "sm_sunSampleSizeNear", .25 );
	spawn_shepherd();
	spawn_price();

	level.sandstorm_time = SpawnStruct();
	level.sandstorm_time.min = 0.5;
	level.sandstorm_time.max = 0.8;

	fog_set_changes( "afch_fog_dunes_far", 0 );
	//vision_set_changes( "af_chase_outdoors_2", 0 );

	remove_extra_autosave_check( "boat_check_trailing" );
	remove_extra_autosave_check( "boat_check_player_speeding_along" );

	set_wind( 100, 0.7, 0.4 );

	SetSavedDvar( "cg_fov", 65 );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "compassHideSansObjectivePointer", 1 ); // for later when we update the objective.
	SetSavedDvar( "actionSlotsHide", 1 );
	level.player AllowSprint( false );
	//level.player AllowJump( false );


//	thread maps\af_chase_fx::sand_storm_effect();
	thread maps\af_chase_fx::sandstorm_fog_management();

	thread maps\af_chase_fx::sand_storm_rolls_in();
	thread kill_all_the_ai_and_fx_from_boatride();
	level.player TakeAllWeapons();
}

start_wakeup_after_crash()
{
}

wakeup_after_crash()
{
	do_wakeup_anim = level.start_point != "wakefast";
	
	flag_wait( "fell_off_waterfall" );

	//set_vision_set( "aftermath", 0 );

	shellshock_very_long( "af_chase_ending_wakeup" );

//	ai = GetAIArray();
//	array_call( ai, ::Delete );

	// setup crash site seqeunces
	thread shepherd_stumbles_out_of_helicopter();
	//thread modulate_player_movement();
	
	thread more_dust_as_shepherd_nears();
	thread impaled_guy();

	ending_common();
	
	// no sound
	level.eq_ent.origin = (1,0,0);
	level.player SetEqLerp( 0, level.eq_main_track );

	if ( do_wakeup_anim )
		thread fade_in_from_crash();

	SetBlur( 20, 0 );
	SetBlur( 0, 8 );


	scene = "wakeup";
	// player wakes up
	anim_node = get_anim_node();
	//player_wakeup_struct = getstruct( "end_scene_org_wakeup", "targetname" );
	player_rig = spawn_anim_model( "player_rig" );

	anim_node anim_first_frame_solo( player_rig, scene );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	SaveGame( scene, &"AUTOSAVE_LEVELSTART", "shot", true );
	level.player FreezeControls( true );

	array_spawn_function_targetname( "crawling_spawner", ::crawling_guy_crawls );
	array_spawn_targetname( "crawling_spawner" );
	
	time = 1;
	level.eq_ent MoveTo( (0.0,0,0), time, time * 0.5, time * 0.5 );

	damaged_pavelow = getent( "damaged_pavelow", "targetname" );
	damaged_pavelow thread play_sound_on_entity( "scn_afchase_heli_cookoff" );
	
	if ( do_wakeup_anim )
	{
		//level.g = gettime();
		level.player delaythread( 5, ::play_sound_on_entity, "scn_afchase_wakeup_player" ); 
		level.player delaythread( 12.5, ::play_sound_on_entity, "scn_afchase_wakeup_player_cough" ); 
		
		anim_node anim_single_solo( player_rig, scene );
	}
	else
	{
		anim_node thread anim_single_solo( player_rig, scene );
		animation = player_rig getanim( scene );
		player_rig SetAnim( animation, 1, 0, 25 );
		for ( ;; )
		{
			animtime = player_rig GetAnimTime( animation );
			if ( animtime >= 0.95 )
				break;
			wait 0.05;
		}
	}
	thread random_breathing_sounds();
	level delaythread( 5, ::send_notify, "stop_random_breathing_sounds" );
	
	player_rig Delete();

//	shellshock_very_long( "af_chase_ending_wakeup" );
	
	flag_set( "player_standing" );
	flag_set( "start_doing_aftermath_walk" );
}

start_turnbuckle()
{
	teleport_to_truck_area();
	shellshock_very_long( "af_chase_ending_wakeup" );

}

fight_turnbuckle_idle_handle()
{
	anim_node = get_anim_node();
	
	level endon ( "no_more_shepherd_idle" );
	
	while( 1 )
	{
		anim_node thread anim_loop_solo( level.shepherd, "turn_buckle_idle", "player_arrived" );
		flag_wait( "shepherd_should_do_idle_b" );
		anim_node notify ( "player_arrived" );
		anim_node thread anim_loop_solo( level.shepherd, "turn_buckle_idleb", "player_arrived" );
		flag_waitopen( "shepherd_should_do_idle_b" );
		anim_node notify ( "player_arrived" );
	}
	
}

fight_turnbuckle()
{
	anim_node = get_anim_node();
	player_rig = get_player_rig();
	player_rig Hide();

//	convert_shepherd_to_drone();

	anim_node anim_first_frame_solo( player_rig, "turn_buckle" );
	
	thread fight_turnbuckle_idle_handle();

//	level.shepherd play_sound_on_tag( "afchase_shp_goodwarrior", "J_Jaw" );
//	level.shepherd play_sound_on_tag( "afchase_shp_extrastep", "J_Jaw" );
//	level.shepherd play_sound_on_tag( "afchase_shp_necessary", "J_Jaw" );

	give_knife_fight_weapon();

	lookat_ent = Spawn( "script_model", level.player.origin + ( 0, 0, 32 ) );
	lookat_ent SetModel( "ch_viewhands_player_gk_m4_sopmod_ii" );
	lookat_ent Hide();
	lookat_ent LinkTo( level.player );

	wait_for_player_to_melee_shepherd();
	level notify( "stop_drunk_walk" );	
	level notify( "kill_limp" );
	SetSavedDvar( "compass", 0 );

	level notify ( "do_staged_pain_pulse" ); // stop any more of these
	level notify ( "kill_limp" );
	flag_set( "stop_aftermath_player" );
	fade_in( 1 ); // in case we were fading out

	if ( IsDefined( level.shepherd.function_stack ) )
		level.shepherd function_stack_clear();// stop the dialogue

	level.shepherd StopSounds();

	ending_common_wounded();

	flag_set( "turn_buckle_start" );

	level notify ( "no_more_shepherd_idle" );
	anim_node notify( "player_arrived" );

	thread blend_player_to_turn_buckle();

	player_rig Attach( "weapon_commando_knife", "TAG_WEAPON_LEFT" );

	knife = get_knife();

	objects = [];
	objects[ "shepherd" ] = level.shepherd;
	objects[ "player" ] = player_rig;
	objects[ "knife" ] = knife;
	
	animation = player_rig getanim( "turn_buckle" );
	fade_out_time = 1.15;
	thread fade_turn_buckle( fade_out_time );

	delayThread( 7.35, ::flag_set, "turn_buckle_fadeout" );
	
 //FRAME 1055 "attach_knife"             ( 0 seconds )				
//FRAME 1067 "switch_model"             ( 0.4 seconds )			
//FRAME 1072 "rumble"                   ( 0.566 seconds )			
//FRAME 1121 "rumble"                   ( 2.2 seconds )			
//FRAME 1122 "vision_effect"            ( 2.233 seconds )			
//FRAME 1158 "bodyfall large"           ( 3.433 seconds )			
//FRAME 1159 "rumble"                   ( 3.466 seconds )			
//FRAME 1247 "rumble"                   ( 6.4 seconds )			
//FRAME 1352 "fadeout"                  ( 9.9 seconds )			

// Knife
//NUMFRAMES 348 ( Time: 11.6 Seconds ) 			
//////  NOTETRACKS  ////                          	
//FRAME 1244 "blood"           ( 6.3 seconds )
	
	//alias: scn_afchase_tbuckle_start_front
	//- Starts from the first frame of the animation sequence
	player_rig thread play_sound_on_entity( "scn_afchase_tbuckle_start_front" );
	
	//alias: scn_afchase_tbuckle_pullknife_mono
	//- This is shepherd grabbing and pulling out the knife.  Play on the grab
	knife delayThread( 4.31, ::play_sound_on_entity, "scn_afchase_tbuckle_pullknife_mono" );
	
	//alias: scn_afchase_tbuckle_car_front
	//- This should play just a hair before player's head hits the car
	level.player delayThread( 2.11, ::play_sound_on_entity, "scn_afchase_tbuckle_car_front" );
	
	//alias: scn_afchase_tbuckle_bodyfall_front
	//- This is the players bodyfall, play as you are falling back.
	level.player delayThread( 3.31-0.5, ::play_sound_on_entity, "scn_afchase_tbuckle_bodyfall_front" );
	
	//alias: scn_afchase_tbuckle_stab_front
	//- This is the stab, it should play a frame or two before it starts to enter
	//players chest
	level.player delayThread( 6.1, ::knife_in_player );

	//alias: scn_afchase_tbuckle_standup_mono
	//- This should play on shepherd and starts as he begins to release the knife. So
	level.shepherd delayThread( 9.9, ::play_sound_on_entity, "scn_afchase_tbuckle_standup_mono" );
	
	anim_scene = "turn_buckle";
	if( flag( "player_touched_shepherd" ) )
		anim_scene = "turn_buckle_alt";
		
	knife hide();
	level.shepherd Attach( level.scr_model[ "knife" ], "tag_inhand" );
	anim_node thread anim_single( objects, anim_scene );
	
	flag_wait( "turn_buckle_fadeout" );
	wait fade_out_time;
	wait .5; // half second in black
	level.shepherd detach( level.scr_model[ "knife" ], "tag_inhand" );
	knife show();
}

start_shepherd_gloats()
{
	fade_out( 0 );
}

bloody_player_rig( player_rig )
{
	flag_set( "bloody_player_rig" );
	player_rig setmodel( "ch_viewhands_player_gk_m4_sopmod_ii" );
}

shepherd_gloats()
{
	level notify ( "not_random_blur" );
//	vision_set_changes( "af_chase_outdoors_2", 0 );
	vision_set_changes( "af_chase_ending_noshock", 0 );
	thread maps\_aftermath_player::player_heartbeat();
	level.player stopshellshock();
	
	//shellshock_very_long( "af_chase_ending_no_control_lowkick" );

	anim_node = get_anim_node();
	player_rig = get_player_rig();
	bloody_player_rig( player_rig );
	gun_model = get_gun_model();
	knife = get_knife();

	convert_shepherd_to_drone();
	
	dof_target_ent = get_dof_targetEnt();
	dof_target_ent.origin = level.player.origin;
	dof_target_ent movetotag( level.shepherd, "tag_eye", 1 );

	remove_fences();

	dof_target_ent = get_dof_targetEnt();
	dof_target_ent LinkTo( level.shepherd, "tag_eye", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	guys = [];
	guys[ "shepherd" ] = level.shepherd;
	guys[ "player_rig" ] = player_rig;
	guys[ "gun" ] = gun_model;
	guys[ "knife" ] = knife;
	anim_node anim_first_frame( guys, "gun_monologue" );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 5, 5, 5, 5, true );

	SetBlur( 0, 1.75 );
	delay_fadein = 6.5;
	start_time_offset = 4;
	delay_fadein -= start_time_offset;
	thread scene_gun_monologue_dialogue( start_time_offset );
	flag_wait( "gloat_fade_in" );
	//wait delay_fadein;
	fade_in( 3.5);
	anim_node anim_first_frame_solo( level.price, "gun_drop" );
	
//	gun_model delaythread( 7.450, ::play_sound_on_tag, "anaconda_revolver_flick", "tag_flash" );
//	gun_model delaythread( 10.00, ::play_sound_on_tag, "anaconda_click", "tag_flash" );

	
	level.shepherd thread play_sound_on_entity( "scn_afchase_shepherd_gloat_stereo" );

	// we know
	//level.price delaythread( 12.5, ::play_sound_on_entity, "afchase_pri_weknow" );
	level.player delaythread( 13.45, maps\_gameskill::grenade_dirt_on_screen, "right" );
	delaythread( 14.7, ::fight_music ); 
	anim_node anim_single( guys, "gun_monologue" );
}

fight_music()
{
	flag_set( "af_chase_final_fight" );
}

start_gun_drop()
{
	set_vision_set( "af_chase_ending_noshock", 0 );  // still getting player flying lerping or something through some vision set triggers. harmless I think.
	link_player_to_arms();
}

gun_drop()
{
//	thread gun_drop_slowmo();
	
	anim_node = get_anim_node();
	anim_node_ent = Spawn( "script_origin", anim_node.origin );
	anim_node_ent.angles = anim_node.angles;
	
	
	player_rig = get_player_rig();
	gun_model = get_gun_model();

	guys = [];
	guys[ "shepherd" ] = level.shepherd;
	guys[ "price" ] = level.price;

	dof_target_ent = get_dof_targetEnt();
	dof_target_ent LinkTo( level.shepherd, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	animation = level.shepherd getanim( "gun_drop" );
	animation_length = GetAnimLength( animation );

	player_anim = player_rig getanim( "gun_drop_player" );
	player_animation_lenght = GetAnimLength( player_anim );

	player_length_after_gun_drop = player_animation_lenght - animation_length;

	blendout_time = .7;
	wait_to_blendout = animation_length - blendout_time;

	anim_node_ent thread anim_single( guys, "gun_drop" );
	
	dof_target_ent movetotag( gun_model, "J_Cylinder_Rot", .4 );
	anim_node thread anim_single_solo( gun_model, "gun_drop" );
	anim_node thread anim_single_solo( player_rig, "gun_drop_player" );
	level.player thread play_sound_on_entity( "af_chase_scene_gun_drop" );
	
	wait .05;

	foreach ( guy in guys )
		guy LinkTo( anim_node_ent );

	wait wait_to_blendout - .05;
	anim_node_ent MoveTo( anim_node_ent.origin + ( 200, 0, 0 ), blendout_time + 1, 0, 0 );
	wait blendout_time - .05;

	wait player_length_after_gun_drop - .05;
}


start_gun_crawl()
{

	link_player_to_arms();
	gun_model = get_gun_model();
	anim_node = get_anim_node();
	player_rig = get_player_rig();
	dof_target_ent = get_dof_targetEnt();
	dof_target_ent movetotag( gun_model, "tag_flash", .1 );
	anim_node anim_first_frame_solo( gun_model, "gun_kick_gun" );
	anim_node anim_first_frame_solo( player_rig, "gun_crawl_01" );
	dof_target_ent delayCall( .1, ::linkto, player_rig, "J_Wrist_LE", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	set_vision_set( "af_chase_ending_noshock", 0 );
}


gun_crawl()
{
	SaveGame( "crawl", &"AUTOSAVE_LEVELSTART", "shot", true );
	beat_up_prices_head();
//	SetSavedDvar( "cg_fov", 40 );
	level.fov_ent.origin = ( 40, 0, 0 );
	set_vision_set( "af_chase_ending_noshock", 3 );

	anim_node = get_anim_node();
	player_rig = get_player_rig();
	gun_model = get_gun_model();

	guys = [];
	guys[ "player_rig" ] = player_rig;
	

//	level.player ShellShock( "af_chase_ending_wakeup", 60 );

	button_alt = [];
	button_alt[ 0 ] = ::hint_crawl_right;
	button_alt[ 1 ] = ::hint_crawl_left;

	button_hints = [];
	button_hints[ 0 ] = "hint_crawl_right";
	button_hints[ 1 ] = "hint_crawl_left";

	button_track = SpawnStruct();
	thread track_buttons( button_track, button_alt, button_hints );
	thread gun_crawl_fight_idle();

//	anim_node anim_first_frame( guys , "gun_crawl_01"  );

	if ( !is_default_start() )
		thread blend_player_to_crawl();

	level notify ( "stop_heart" );
	button_index = 0;

	for ( i = 0; i < 7; i++ )
	{

		anim_node thread anim_loop( guys, "gun_crawl_0" + i + "_idle", "stop_crawl" );
		if ( i == 1 )
			thread dof_target_to_gun_crawl();
		button_wait( button_alt, button_track, button_index );

		player_rig thread play_sound_on_entity( "sand_crawl" );
		if ( i == 2 )
		{
			thread dof_to_gun_kick_gun();
			thread gun_crawl_move_fighters_away();
		}
		if ( i == 3 )
		{
			thread gun_crawl_price_falls();
		}

		anim_node notify( "stop_crawl" );

		earthquake_time = randomfloatrange( 0.9, 1.1 );
		Earthquake( 0.16, earthquake_time, level.player.origin, 5000 );
		scene = "gun_crawl_0" + i;
		animation = player_rig getanim( scene );
		time = getanimlength( animation );
		delaythread( time - 0.25, ::crawl_earthquake );

		if ( i == 6 )
			break;

		button_index++;
		button_index %= button_alt.size;
	
		
		anim_node anim_single( guys, scene );
	}

}

crawl_earthquake()
{
	Earthquake( 0.12, 0.450, level.player.origin, 5000 );
}


start_gun_kick()
{
	level.fov_ent.origin = ( 40, 0, 0 );
	link_player_to_arms();
}

gun_kick()
{
	shep_beatup();

	anim_node = get_anim_node();
	player_rig = get_player_rig();
	gun_model = get_gun_model();

	new_anim_node = create_new_anim_node_from_anim_node();
	new_anim_node.origin += ( 288, -166, 0 ) * .155;

	anim_node thread anim_single_solo( gun_model, "gun_kick_gun" );

	dof_target_ent = get_dof_targetEnt();
	dof_target_ent movetotag( level.shepherd, "J_Ankle_RI", 1 );

//	dof_target_ent LinkTo( level.shepherd, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	scene = "gun_kick";
	animation = player_rig getanim( scene );
	anim_length = GetAnimLength( animation );
	thread fight_physics( scene, anim_length );

	anim_node thread anim_single_solo( level.shepherd, scene );
	anim_node thread anim_single_solo( player_rig, scene );

	blend_in_time = .7;
//	new_anim_node thread anim_single_solo( level.shepherd, "gun_kick" );
//	level.shepherd LinkTo( new_anim_node );
//	wait blend_in_time;
//	new_anim_node MoveTo( anim_node.origin, blend_in_time, 0, 0 );

	wait anim_length - blend_in_time;
	wait 2;
}

start_wounded_show()
{
	fade_out( 0 );
	set_vision_set( "af_chase_ending_noshock", 0 );
}

wounded_show()
{
	
	//run_thread_on_targetname( "shep_blood", ::gen_rocks );
	level.price thread scoot_rocks();
	level.shepherd thread scoot_rocks();
	
	
	flag_set( "player_heartbeat_sound" );
	set_wounded_fov();
	thread random_breathing_sounds();

	sandstorm_wounded_settings();


	//set_vision_set( "aftermath", 0 );
	//thread maps\_aftermath_player::player_heartbeat();

	level notify ( "stop_idle_crawl_fight" );// kill this if its running

	fight_b_animnode = GetEnt( "end_scene_org_fight_B", "targetname" );
	fight_c_animnode = GetEnt( "end_scene_org_fight_C", "targetname" );
	wrestle_c_animnode = GetStruct( "end_scene_org_wrestle_C", "targetname" );


	anim_node = get_anim_node_rotated();
	player_body = get_player_body();
	scene = "price_wakeup";
	anim_node thread anim_first_frame_solo( player_body, scene );

	player_rig = get_player_rig();
	player_rig Delete();// start over on the player rig
	player_rig = get_player_rig();

	knife = get_knife();

	thread wounded_show_player_view( player_rig );

//	slowmo_start();
//	slowmo_setspeed_slow( 0.70 );
//	slowmo_setlerptime_in( 0 );
//	slowmo_lerp_in();


	guys = [];
	guys[ "knife" ] = knife;
	guys[ "player_rig" ] = player_rig;

	anim_node anim_first_frame( guys, "knifepull_grab_02" );
	level notify( "link_player", player_rig );


	fighters = [];
	fighters[ "shepherd" ] = level.shepherd;
	fighters[ "price" ] = level.price;

	dof_target_ent = get_dof_targetEnt();
	dof_target_ent LinkTo( level.price, "tag_eye", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	level.player ShellShock( "af_chase_ending_no_control_lowkick", 6000 );
	//wait( 0.3 );

////////////////////////////////////////////////////////////////////////////////////////////////////
/*

	scene = "fight_C2";
	wrestle_c_animnode thread anim_single( fighters, scene );
	wait( 0.05 );
	foreach ( guy in fighters )
	{
		animation = guy getanim( scene );
		guy SetAnimTime( animation, 0.67 );
	}

	fade_in( 2.5 );
	animation = level.price getanim( scene );
	scene_time = GetAnimLength( animation );
	// blah

	for ( ;; )
	{
		if ( level.price GetAnimTime( animation ) >= 0.89 )
			break;

		wait( 0.05 );
	}

//	wait 37.7 * 0.22;

	fade_out_time = scene_time * 0.11;
	fade_out( fade_out_time );
	wait( fade_out_time );
	level.player ShellShock( "af_chase_ending_no_control", 60 );

	wait( 1.5 );
*/
////////////////////////////////////////////////////////////////////////////////////////////////////


	scene = "fight_B";
	animation = level.price getanim( scene );
	scene_time = GetAnimLength( animation );
	thread fight_physics( scene, scene_time );

	fight_b_animnode thread anim_single( fighters, scene );
	wait 1.0;

	//wait( 1.0 );
	fade_in( 2.5 );
	// blah

	for ( ;; )
	{
		if ( level.price GetAnimTime( animation ) >= 0.39 )
			break;

		wait( 0.05 );
	}

	fade_out_time = scene_time * 0.11;
	fade_out( fade_out_time );
	wait( fade_out_time );

	//level.player ShellShock( "af_chase_ending_no_control", 6000 );
	wait( 1.05 );
	
	
////////////////////////////////////////////////////////////////////////////////////////////////////

	scene = "fight_B2";
	animation = level.price getanim( scene );
	scene_time = GetAnimLength( animation );
	thread fight_physics( scene, scene_time );

	fight_b_animnode thread anim_single( fighters, scene );
	start_time = gettime();
	
	wait 0.45;
//	wait( 0.05 );
//
//	foreach ( guy in fighters )
//	{
//		animation = guy getanim( scene );
//		guy SetAnimTime( animation, 0.60 );
//	}
//
	fade_in( 1 );

	for ( ;; )
	{
		if ( level.price GetAnimTime( animation ) >= 0.50 ) //0.7
			break;

		wait( 0.05 );
	}

//	wait 19.23 * 0.1;
//	wait 19.23 * 0.1;

	fade_out_time = scene_time * 0.10;
	
	
	//wait_for_buffer_time_to_pass( start_time , scene_time - fade_out_time );
	
	fade_out( fade_out_time );
	wait( fade_out_time );

////////////////////////////////////////////////////////////////////////////////////////////////////

	/*
	fade_time = 8.0;
	wait( 15.5 - fade_time );

	slowmo_start();
	slowmo_setspeed_slow( 0.22 );
	slowmo_setlerptime_in( fade_time );
	slowmo_lerp_in();
	*/

	//fade_out( fade_time );
	//wait( fade_time );

//	slowmo_setlerptime_out( 0 );
//	slowmo_lerp_out();
//	slowmo_end();
	wait( 1.5 );
}

start_knife_pullout()
{
	fade_out( 0 );
}

knife_pullout()
{
	flag_set( "player_heartbeat_sound" );
	SaveGame( "pullout", &"AUTOSAVE_LEVELSTART", "shot", true );
	
	thread spawn_fake_wrestlers(); // so we can jump to the midpoint of an anim more smoothly
	
	fight_c_animnode = GetEnt( "end_scene_org_fight_C", "targetname" );
	anim_node = get_anim_node_rotated();
	player_rig = get_player_rig();
	knife = get_knife();
	player_body = get_player_body();

	thread pullout_player_view( player_rig );

	guys = [];
	guys[ "knife" ] = knife;
	guys[ "player_rig" ] = player_rig;

	fighters = [];
	fighters[ "shepherd" ] = level.shepherd;
	fighters[ "price" ] = level.price;

	anim_node thread anim_first_frame_solo( player_body, "price_wakeup" );
	anim_node anim_first_frame( guys, "knifepull_grab_02" );
	// playerlinktoblend
	wait( 0.5 );

//	anim_node anim_first_frame( guys, "knifepull_grab_01" );
//	thread player_links_to_rig_and_looks_left( player_rig, 5 );

//	slowmo_start();
//	slowmo_setspeed_slow( 0.7 );
//	slowmo_setlerptime_in( 0 );
//	slowmo_lerp_in();	
	level.player ShellShock( "af_chase_ending_pulling_knife_later", 6000 );

	level notify ( "player_has_min_arc" );

	dof_target_ent = get_dof_targetEnt();
	dof_target_ent LinkTo( level.price, "tag_eye", ( 0, 0, 0 ), ( 0, 0, 0 ) );


////////////////////////////////////////////////////////////////////////////////////////////////////
	
	scene = "fight_C";
	animation = level.price getanim( scene );
	scene_time = GetAnimLength( animation );
	thread fight_physics( scene, scene_time );
	fight_c_animnode thread anim_single( fighters, scene );
	
	thread hide_end_of_fight_C();

////////////////////////////////////////////////////////////////////////////////////////////////////

	delaythread( 0.3, ::fade_in, 1 );
	wait( 1.5 );
	fade_out( 1 );
	wait( 1 );

	anim_node thread price_shepherd_fight_e( fighters );
	level notify ( "waiting_for_player_to_look_at_knife" );
	wait( 1 );
	delaythread( 0.3, ::fade_in, 1 );


	wait_for_player_to_start_pulling_knife();
	flag_set( "player_looks_at_knife" );

	fade_in( 0.5 );

	flag_set( "focused_on_knife" );
	flag_set( "player_uses_knife" );
	
	
	
	//blend_to_knife_dof( 1 );
	level notify ( "lerp_view_after_uses_knife" );


	anim_node anim_single( guys, "knifepull_grab_02" );
	anim_node anim_first_frame( guys, "knifepull_pull_02" );

	delaythread( 3, ::flag_set, "price_shepherd_fight_e_flag" );

	thread knife_hint_blinks();

	level.additive_pull_weight = 0;
	thread hands_do_pull_additive( player_rig );
	
	// player pulls it out
	knife_struct = SpawnStruct();
	knife_struct.faded_out = false;
	knife_struct.pull_scale = 6;
	knife_struct.takes_pain = true;
	knife_struct.sin_scale = 0.75;
//	knife_struct.min_rate = 0.05; // 0.09;
//	knife_struct.max_rate = 0.09; // 0.14;
	knife_struct.rate = 0.065;
	knife_struct.range = 0.03;
	knife_struct.occumulator_base = 4;
	knife_struct.auto_occumulator_base = true;
	knife_struct.set_pull_weight = true;
	knife_struct.hurt_player_fx = "player_knife_pull_1";	
	knife_struct.min_light = 70;
	knife_struct.min_heavy = 90;
	knife_struct.rumble_loop = "light_3s";
	knife_struct player_pulls_out_knife( "knifepull_pull_02" );
//	fade_out_knife_hint( 0.5 );


	level.additive_pull_weight = 1;

	Earthquake( 0.2, 0.3, level.player.origin, 5000 );
	set_vision_set( "aftermath_hurt", 0.1 );
	delaythread( 0.8, ::set_vision_set, "aftermath_walking", 0.9 );


	level notify ( "second_knife_pull" );
	anim_node anim_single( guys, "knifepull_grab_03" );
	anim_node anim_first_frame( guys, "knifepull_pull_03" );
	flag_set( "two_hand_pull_begins" );
	

	

	// player pulls it out
	knife_struct = SpawnStruct();
	knife_struct.faded_out = false;
	knife_struct.pull_scale = 6;
	knife_struct.takes_pain = true;
	knife_struct.sin_scale = 0.75;
	knife_struct.rate = 0.7;
	knife_struct.range = 0.2;
	knife_struct.override_damage = 50;
	knife_struct.override_anim_time = 0.9;
	knife_struct.occumulator_base = 2;
	knife_struct.hurt_player_fx = "player_knife_pull_2";	
	knife_struct.min_light = 20;
	knife_struct.min_heavy = 50;
	knife_struct.rumble_loop = "heavy_3s";
	knife_struct player_pulls_out_knife( "knifepull_pull_03" );
	fade_out_knife_hint( 0.5 );

	level notify ( "fight_C_is_over" );

//	level.player ShellShock( "af_chase_ending_pulling_knife_later", 3 );
//	vision_set_changes( "af_chase_outdoors_2", 3 );
	

//	slowmo_start();
//	slowmo_setspeed_slow( 0.85 );
//	slowmo_setlerptime_in( 0 );
//	slowmo_lerp_in();	

	// appear while head looks right
	level.shepherd delayCall( 3, ::Show );
	level.price delayCall( 3, ::Show );

}

start_knife_kill()
{
	player_rig = get_player_rig();
	anim_node = get_anim_node_rotated();

	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	level.player ShellShock( "af_chase_ending_pulling_knife_later", 6000 );

	thread blend_to_knife_dof( 0.1 );
	
	player_body = get_player_body();
	anim_node thread anim_first_frame_solo( player_body, "price_wakeup" );

	wait( 0.05 );
	fighters = [];
	fighters[ "shepherd" ] = level.shepherd;
	fighters[ "price" ] = level.price;
	anim_node thread price_shepherd_fight_e( fighters );
}

knife_kill()
{
	
	if ( flag( "missionfailed" ) )
		return;
	level endon( "missionfailed" );

	maps\af_chase_anim::add_fighte_animsounds();
	flag_set( "player_heartbeat_sound" );
	SaveGame( "kill", &"AUTOSAVE_LEVELSTART", "shot", true );
	fight_c_animnode = GetEnt( "end_scene_org_fight_C", "targetname" );
	anim_node = get_anim_node_rotated();
	player_rig = get_player_rig();
	knife = get_knife();
	player_body = get_player_body();
	
	thread kill_player_view( player_rig );


	guys = [];
	guys[ "knife" ] = knife;
	guys[ "player_rig" ] = player_rig;

	fighters = [];
	fighters[ "shepherd" ] = level.shepherd;
	fighters[ "price" ] = level.price;

	level notify ( "knife_pulled_out" );
	anim_node anim_single( guys, "knifepull_pullout_flip" );

	level notify ( "aim_at_shepherd" );

	thread flag_if_player_aims_at_shepherd( player_rig );

	anim_node thread anim_loop( guys, "knifepull_pullout_flip_idle" );

	thread player_fails_if_does_not_throw();

	reticle = get_knife_reticle();
	reticle.alpha = 1;
	reticle fadeovertime( 1 );
	
	player_throws_knife( reticle );

	reticle destroy();
	
	musicStop( 4 );
	level.player thread play_sound_on_entity( "af_chase_shepherd_death_stinger" );
	
	fade_in( 0.5 );

	level notify ( "pull_back_knife_anim_starts" );

	blend_out_time = 1.2;
	level.fov_ent moveto( (52,0,0), blend_out_time, blend_out_time * 0.5, blend_out_time * 0.5 );
	
	
	player_rig thread play_sound_on_entity( "scn_afchase_player_knife_breath" );
	anim_node anim_single( guys, "knifepull_throw" );
	blend_to_kill_dof( 0.15 );

	//guys[ "shepherd" ] = level.shepherd;
	//guys[ "price" ] = level.price;
	anim_node notify ( "stop_loop" );

	anim_node thread anim_single( fighters, "knifepull_throw_kill" );
	flag_set( "shepherd_killed" );

	level.shepherd StopSounds(); // in case of punches
	level.price StopSounds();

	anim_node anim_single( guys, "knifepull_throw_kill" );
		
	
	run_thread_on_targetname( "shep_blood", ::shep_blood );

	anim_node thread anim_first_frame_solo( player_rig, "price_wakeup" );
}

start_price_wakeup()
{
	thread blend_to_ending_dof( 0.1 );

	waittillframeend; // after catchup thread.
	waittillframeend;

	maps\af_chase_anim::player_pulls_knife_from_chest( 0 );
	anim_node = get_anim_node_rotated();

	level.player_rig = spawn_anim_model( "player_rig" );
	player_rig = level.player_rig;
	anim_node thread anim_first_frame_solo( player_rig, "price_wakeup" );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 10, 15, 5, 10 );
	
	
}

price_wakeup()
{
	
	level.player shellshock( "af_chase_ending_fakeout", 6000 );
	anim_node = get_anim_node_rotated();
	player_rig = get_player_rig();
	player_body = get_player_body();

	wait( 1.8 );
	fovtime = 8.5;
	blend_to_ending_dof( fovtime );
	level.fov_ent moveto( (65,0,0), fovtime, fovtime * 0.5, fovtime * 0.5 );

	set_vision_set( "aftermath_nodesat", 0 );
	//set_vision_set( "af_chase_ending_final", fovtime );
	
	
	guys = [];
	guys[ "shepherd" ] = level.shepherd;
	guys[ "price" ] = level.price;
	//guys[ "player" ] = player_rig;

//	dof_target_ent = get_dof_targetEnt();
//	dof_target_ent movetotag( player_rig, "J_Wrist_LE", 2);

	//anim_node2 = SpawnStruct();
	//dif = ( 25887.2, 35597, -9959.6 ) - ( 25865.2, 35546, -9959.6 );
	//anim_node2.origin = anim_node.origin - dif;
	//anim_node2.angles = anim_node.angles;

	if ( level.start_point == "price_wakeup" )
	{
		anim_node thread anim_first_frame_solo( player_body, "price_wakeup" );
		anim_node thread anim_first_frame_solo( player_rig, "price_wakeup" );
		anim_node anim_first_frame( guys, "price_wakeup" );
	}
	
//	if ( level.start_point == "price_wakeup" )
//		wait( 3 );

	start_time = gettime();
//	AmbientStop( time );

	wait_for_buffer_time_to_pass( start_time, 4 );
	
	// stop ambient event system
	//AmbientStop( 5 );
	
//	delaythread( 3, ::ending_fade_out ); // 8, ::fade_out 27

	level.override_eq = true;
	time = 30;
	//level.eq_ent MoveTo( (0.66,0,0), time, time * 0.5, time * 0.5 );

	wait_for_buffer_time_to_pass( start_time, 13.5 );
	
	fade_out( 19.5 );	
	
//	wait_for_buffer_time_to_pass( start_time, 25 );
//	fade_in( 4 );

	wait_for_buffer_time_to_pass( start_time, 24 );
	
	scene = "price_wakeup";
	animation = level.price getanim( scene );
	scene_time = GetAnimLength( animation );
	thread fight_physics( scene, scene_time );
	
	anim_node thread anim_single_solo( player_body, scene );
	anim_node thread anim_single_solo( player_rig, scene );

	animation = level.price getanim( scene );
	anim_length = GetAnimLength( animation );
	waittime = anim_length * 0.75;
	delayThread( waittime, ::fade_out, 1 );
//	delaythread( 14.1, maps\af_chase_anim::blend_to_ending_dof_fov );
	
	endMusicTiming = 2.7;
	delaythread( endMusicTiming, ::flag_set, "af_chase_final_ending" );
	delaythread( endMusicTiming + 55.70, ::end_credits );//timed to come in on the big swelling boom
	delaythread( endMusicTiming + 195, ::flag_set, "af_chase_ending_credits" ); //timed to come in after the af_chase_final_ending music is done	
	
	delaythread( endMusicTiming + 0.25, ::fade_in, 1 );
	level.eq_ent delaycall( endMusicTiming - 1, ::moveto, (0.55,0,0), 3 );
	//level.eq_ent MoveTo( (0.66,0,0), time, time * 0.5, time * 0.5 );
	
	anim_node thread anim_single( guys, scene );
	wait( anim_length * 0.85 );
	//wait 0.5;
}

start_walkoff()
{
}

walkoff()
{
	guys = [];
	guys[ "shepherd" ] = level.shepherd;
	guys[ "price" ] = level.price;

	anim_node = get_anim_node_rotated();
	
	player_rig = get_player_rig();
	level.player_rig delete();
	player_rig = get_player_rig();
	
	player_body = get_player_body();

	arc = 0; // 10;
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, arc, arc, arc, arc, true );
	delaythread( 0.8, ::expand_player_view );
	
	ground_ref = spawn_tag_origin();
	ground_ref linkto( player_rig, "tag_player", (0,0,0), (0,0,0) );
	level.player PlayerSetGroundReferenceEnt( ground_ref );

	scene = "price_wakeup";
	
	anim_node thread anim_first_frame_solo( player_body, scene );
	anim_node thread anim_first_frame_solo( player_rig, scene );
	anim_node anim_first_frame( guys, scene );

	thread sandstorm_fades_away();

	player_body Delete();

	guys = [];
	spawn_nikolai();

	thread black_out_on_walk();
//	dof_target_ent = get_dof_targetEnt();

	level.nikolai animscripts\shared::DropAllAIWeapons();

//	if ( IsDefined( level.shepherd ) )
//		level.shepherd Delete();

	thread blend_to_price_healing_dof( 3 );
	//level.player ShellShock( "af_chase_ending_pulling_knife_later", 60 );
	//set_vision_set( "aftermath_walking", 0 );
	set_vision_set( "aftermath_nodesat", 0 );
	//set_vision_set( "af_chase_ending_final", 0 );

	
	thread maps\af_chase_anim::blend_to_ending_dof_fov( 0.1 );
	
	delaythread( 0.5, ::fade_in, 1 );

	ending_rescue_chopper = spawn_vehicle_from_targetname( "ending_rescue_chopper" );
	ending_rescue_chopper setmodel( "vehicle_little_bird_bench_afghan" );
	ending_rescue_chopper.animname = "littlebird";
	ending_rescue_chopper notify( "suspend_drive_anims" );
	ending_rescue_chopper thread helicopter_sound_blend();
//	thread end_blind( ending_rescue_chopper );

	guys[ "nikolai" ] = level.nikolai;
	guys[ "price" ] = level.price;
	guys[ "player_rig" ] = player_rig;

//	dof_target_ent LinkTo( level.price, "tag_eye", ( 0, 0, 0 ), ( 0, 0, 0 ) );


	thread scene_walk_off_dialog();
	anim_node = get_anim_node();
	anim_node_chopper = getstruct( "anim_node_chopper", "targetname" );
	
	scene = "walk_off";
	animation = level.price getanim( scene );
	scene_time = GetAnimLength( animation );
	thread fight_physics( scene, scene_time );

	anim_node_chopper thread anim_single_solo( ending_rescue_chopper, scene );
	anim_node thread anim_single( guys, scene );


	start_time = gettime();

	animation = player_rig getanim( scene );
	fade_out_time = 0.5;
	timer = GetAnimLength( animation ) - fade_out_time;

	wait_for_buffer_time_to_pass( start_time, timer - 10 );

	time = 5;
	level.eq_ent MoveTo( (0.85,0,0), time, time * 0.5, time * 0.5 );
}

end_credits()
{		
	fade_out_time = 0.5;
	
	black_overlay = get_black_overlay();
	black_overlay.alpha = 1;
	
	level.eq_ent MoveTo( (1.0,0,0), fade_out_time, fade_out_time * 0.5, fade_out_time * 0.5 );
	
	delaythread( 4, ::nextmission );  // next mission will wait for the flag "af_chase_nextmission" on af_chase before continuing.
	
	flag_set( "do_museum_credits" );
	
	wait .1;
	ai = getaispeciesarray();
	array_call( ai, ::delete );
	level.fov_ent delete();
	thread maps\af_chase_fx::stop_sandstorm_effect();	
}

knife_fight_objectives()
{
	// Kill Shepherd.
	Objective_Add( obj( "get_shepherd" ), "current", &"AF_CHASE_KILL_SHEPHERD" );

	flag_wait( "shepherd_killed" );
	wait( 3.1 );
//	objective_complete( obj( "get_shepherd" ) );
	Objective_Delete( obj( "get_shepherd" ) );
}


startpoint_catchup()
{
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	
	

	flag_set( "end_heli_crashed" );
	flag_set( "water_cliff_jump_splash_sequence" );
	flag_set( "killed_pickup_heli" );
	flag_set( "fell_off_waterfall" );

	if ( start == "wakeup" )
		return;

	if ( start == "wakefast" )
		return;

	flag_set( "start_doing_aftermath_walk" );		

	maps\af_chase_knife_fight::ending_common();
	maps\af_chase_knife_fight_code::teleport_to_truck_area();
	maps\af_chase_fx::sandstorm_fx_increase();

	flag_set( "player_standing" );

	if ( start == "turnbuckle" )
		return;

	level notify( "stop_drunk_walk" );
	level notify( "kill_limp" );	
	maps\af_chase_knife_fight_code::swap_knife();
	
	maps\af_chase_knife_fight_code::convert_shepherd_to_drone();

	level.heartbeat_blood_func = maps\af_chase_fx::blood_pulse;

	flag_set( "aftermath_dont_do_wakeup" );
	level.player TakeAllWeapons();
	flag_set( "stop_aftermath_player" );
	
	maps\af_chase_knife_fight_code::ending_common_wounded();

	flag_set( "player_near_shepherd" );
	flag_set( "turn_buckle_fadeout" );
	
	if ( start == "gloat" )
		return;
	
	flag_set( "bloody_player_rig" );
		
	if ( start == "gun_drop" )
		return;
	if ( start == "crawl" )
		return;
	if ( start == "gun_kick" )
		return;
	maps\af_chase_knife_fight_code::shep_beatup();
		
	player_rig = maps\af_chase_knife_fight_code::beat_up_prices_head();
		
	set_vision_set( "af_chase_ending_noshock", 0 );
	maps\af_chase_knife_fight_code::remove_fences();
	if ( start == "wounded" )
		return;
	maps\af_chase_knife_fight_code::set_wounded_fov();
	maps\af_chase_knife_fight_code::sandstorm_wounded_settings();
	if ( start == "pullout" )
		return;
	if ( start == "kill" )
		return;
	
	level.fov_ent.origin = ( 65, 0, 0 );
		
	if ( start == "price_wakeup" )
		return;
	if ( start == "walkoff" )
		return;

		
	assertex( "Start point " + start + " is not handled by the catchup thread." );
}



