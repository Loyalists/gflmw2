#include maps\_anim;
#include maps\_props;
#include maps\_utility;
#include maps\af_caves_code;

main()
{
	anims();
	dialog();
	dog();
	script_models();
	player_animations();
	animated_model_setup();
}

#using_animtree( "generic_human" );
anims()
{
	//AIRSTRIP
	level.scr_anim[ "price" ][ "launchfacility_a_c4_plant_short" ]	= %launchfacility_a_c4_plant_short;
	level.scr_anim[ "price" ][ "favela_run_and_wave" ]				= %favela_run_and_wave;
	level.scr_anim[ "price" ][ "laptop_stand_idle_start" ]			= %laptop_stand_idle_focused;
	level.scr_anim[ "price" ][ "laptop_stand_idle" ][ 0 ]			= %laptop_stand_idle_focused;
	level.scr_anim[ "price" ][ "laptop_stand_yell" ]			= %laptop_stand_lookaway;

	level.scr_anim[ "price" ][ "invasion_vehicle_cover_dialogue_guy2" ]			= %invasion_vehicle_cover_dialogue_guy2;
	
	//dazed and confused shadow company
	level.scr_anim[ "generic" ][ "civilian_crawl_1" ]				= %civilian_crawl_1;
	level.scr_anim[ "generic" ][ "civilian_crawl_2" ]				= %civilian_crawl_2;
	level.scr_anim[ "generic" ][ "civilian_leaning_death" ]			= %civilian_leaning_death;
	level.scr_anim[ "generic" ][ "civilian_leaning_death_death" ]	= %civilian_leaning_death_shot;
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_C_limp" ]		= %hunted_dazed_walk_C_limp;
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_C_limp_death" ]	 = %exposed_death_falltoknees;
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_B_blind" ]		= %hunted_dazed_walk_B_blind;
	
	//GENERIC
	level.scr_anim[ "generic" ][ "cqb_stand_idle_scan" ]			= %patrol_bored_react_look_v1;
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke_reach" ]					= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke" ]							= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke_react" ]					= %patrol_bored_react_look_advance;
	
	level.scr_anim[ "generic" ][ "lean_smoke_idle" ][ 0 ]			= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "lean_smoke_idle" ][ 1 ]			= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "lean_smoke_react" ]			  	= %parabolic_leaning_guy_react;
	
	level.scr_anim[ "lean_smoker" ][ "lean_smoke_idle" ][ 0 ]		= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "lean_smoker" ][ "lean_smoke_idle" ][ 1 ]		= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "lean_smoker" ][ "lean_smoke_react" ]			= %parabolic_leaning_guy_react;

	add_sit_load_ak_notetracks( "generic" );
	level.scr_anim[ "generic" ][ "sit_load_ak_idle" ][ 0 ]			= %sitting_guard_loadAK_idle;
	level.scr_anim[ "generic" ][ "sit_load_ak_react" ]				= %sitting_guard_loadAK_react1;

	level.scr_anim[ "generic" ][ "patrol_walk" ]				  	= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]				= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]				  	= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]				  	= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				 	= %patrol_bored_2_walk_180turn;

	level.scr_anim[ "generic" ][ "patrol_idle_1" ]				 	= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]				 	= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]				 	= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]				 	= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]				 	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]				 	= %patrol_bored_twitch_stretch;

	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]			  	= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	  		= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]		  	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]			  	= %patrol_bored_idle_cellphone;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]		= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]		= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]		= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]		= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]		= %run_pain_stumble;

	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]= %exposed_idle_twitch_v4;// patrol_bored_2_combat_alarm_short;
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]	= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_heard_scream" ]	= %exposed_idle_twitch_v4;

	level.scr_anim[ "generic" ][ "combat_jog" ]					= %combat_jog;

	level.scr_anim[ "generic" ][ "smoking_reach" ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 0 ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 1 ]				= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "smoking_react" ]				= %parabolic_leaning_guy_react;

	level.scr_anim[ "generic" ][ "sit_idle" ][ 0 ]				= %breach_chair_idle_v2;
	level.scr_anim[ "generic" ][ "sit_react" ]					= %breach_chair_reaction_v2;
	
	// guy using the arcadia fridge rummaging idle
	level.scr_anim[ "generic" ][ "fridge_idle" ][ 0 ]			= %arcadia_fridge_idle;
	level.scr_anim[ "generic" ][ "fridge_react" ]				= %arcadia_fridge_react;

	// Guys sleeping on a cot
	level.scr_anim[ "generic" ][ "sleep_idle1" ][ 0 ]			= %afgan_caves_sleeping_guard_idle;
	level.scr_anim[ "generic" ][ "sleep_death1" ]				= %cargoship_sleeping_guy_death_1;
	level.scr_anim[ "generic" ][ "sleep_alert1" ]				= %afgan_caves_sleeping_guard_scramble;
	
	// Chess Players
	level.scr_anim[ "generic" ][ "chess_surprise_1" ]			= %parabolic_chessgame_surprise_a;
	level.scr_anim[ "generic" ][ "chess_surprise_2" ]			= %parabolic_chessgame_surprise_b;
	level.scr_anim[ "generic" ][ "chess_idle_1" ][ 0 ]			= %parabolic_chessgame_idle_a;
	level.scr_anim[ "generic" ][ "chess_idle_2" ][ 0 ]			= %parabolic_chessgame_idle_b;
	level.scr_anim[ "chess_guy1" ][ "chess_death_1" ]			= %parabolic_chessgame_death_a;
	level.scr_anim[ "chess_guy2" ][ "chess_death_2" ]			= %parabolic_chessgame_death_b;
	
	//CQB Hand signals
	level.scr_anim[ "generic" ][ "signal_moveout_cqb" ]	= %CQB_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "signal_moveup_cqb" ]	= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "signal_go_cqb" ]		= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "signal_stop_cqb" ]	= %CQB_stand_signal_stop;
	level.scr_anim[ "generic" ][ "signal_onme_cqb" ]	= %CQB_stand_wave_on_me;
	
	level.scr_anim[ "price" ][ "intro_stop" ]					= %afgan_caves_intro_stop;	
	
	level.scr_anim[ "generic" ][ "run_2_crouch_f" ]				= %run_2_crouch_f;
	level.scr_anim[ "generic" ][ "crouch_fastwalk_f" ]			= %crouch_fastwalk_F;
	level.scr_anim[ "generic" ][ "crouch_talk" ]				= %casual_crouch_V2_talk;
	level.scr_anim[ "generic" ][ "crouch_idle" ]				= %casual_crouch_idle;
	
	level.scr_anim[ "generic" ][ "look_up_stand" ]				= %coverstand_look_moveup;
	level.scr_anim[ "generic" ][ "look_idle_stand" ][ 0 ]		= %coverstand_look_idle;
	level.scr_anim[ "generic" ][ "look_down_stand" ]			= %coverstand_look_movedown;
	
	//INTRO
	level.scr_anim[ "price" ][ "rise_up" ]	 					= %scout_sniper_price_prone_opening;	
	level.scr_anim[ "price" ][ "price_slide" ]	 				= %afgan_caves_price_slide;	

	//RAPPEL
	level.scr_anim[ "price" ][ "rappel" ]						= %afgan_caves_price_rappel_animatic;
	level.scr_anim[ "price" ][ "pri_rappel_setup" ]				= %afgan_caves_price_rappel_setup;
	level.scr_anim[ "price" ][ "pri_rappel_idle" ][ 0 ]			= %afgan_caves_price_rappel_idle;
	addNotetrack_customFunction( "price", "rope", maps\af_caves::price_rope_hookup, "pri_rappel_setup" );
			
	level.scr_anim[ "price" ][ "pri_rappel_jump" ]				= %afgan_caves_price_rappel_jump;
	addNotetrack_attach(  "price", "knife", "weapon_parabolic_knife", "TAG_INHAND", "pri_rappel_jump" );
	
	level.scr_anim[ "price" ][ "pri_hanging_idle" ][ 0 ]		= %afgan_caves_Price_hanging_idle;	
	
	level.scr_anim[ "price" ][ "pri_rappel_kill" ]				= %afgan_caves_Price_rappel_kill;
	addNotetrack_detach( "price", "knife", "weapon_parabolic_knife", "TAG_INHAND", "pri_rappel_kill" );

	level.scr_anim[ "guard_2" ][ "flick" ] 						= %cliff_guardA_flick;
	level.scr_anim[ "guard_2" ][ "guardB_idle" ][ 0 ]			= %cliff_guardB_idle;	
	level.scr_anim[ "guard_2" ][ "guardB_react" ] 				= %cliff_guardB_react;
	level.scr_anim[ "guard_2" ][ "guard_2_death" ] 				= %afgan_caves_guard_2_death;
	
	level.scr_anim[ "guard_1" ][ "rappel_kill" ] 				= %afgan_caves_guard_1_death;
	level.scr_anim[ "guard_1" ][ "guardA_idle" ][ 0 ]			= %cliff_guardA_idle;
	level.scr_anim[ "guard_1" ][ "guardA_react" ] 				= %cliff_guardA_react;

	addNotetrack_customFunction( "guard_1", "kill", ::kill_me );
	addNotetrack_customFunction( "guard_1", "death_gurgle", ::rappel_guard1_deathgurgle, "rappel_kill" );

	//addNotetrack_flag( "price", "dialogue", "price_hooksup", "pri_rappel_setup" );

	level.scr_anim[ "guard_2" ][ "rappel" ]						= %afgan_caves_guard_2_animatic;
	
	
	// STEAM ROOM
	level.scr_anim[ "generic" ][ "steamroom_knifekill_price" ] = %parabolic_knifekill_mark;
	level.scr_anim[ "generic" ][ "steamroom_knifekill_guard" ] = %parabolic_knifekill_phoneguy;
	level.scr_anim[ "generic" ][ "steamroom_knifekill_guard_idle" ][ 0 ] = %parabolic_phoneguy_idle;
	level.scr_anim[ "generic" ][ "steamroom_knifekill_guard_reaction" ] = %parabolic_phoneguy_reaction;
	

	//LEDGE
	//level.scr_anim[ "price" ][ "pri_dive" ]						= %exposed_dive_grenade_B;
	//level.scr_anim[ "price" ][ "pri_prone_stand" ]				= %prone_2_stand;

	level.scr_anim[ "price" ][ "pri_dive" ]						= %hunted_dive_2_pronehide_v1;
	level.scr_anim[ "price" ][ "pri_prone_stand" ]				= %hunted_pronehide_2_stand_v1;

	level.scr_anim[ "price" ][ "pri_bridge_jump" ]				= %jump_across_100_stumble;
	addNotetrack_flag( "price", "footstep_right_large", "price_jumping", "pri_bridge_jump" );	
	addNotetrack_flag( "price", "footstep_left_large", "price_jumped", "pri_bridge_jump" );	
	
	level.scr_anim[ "destroyer" ][ "shoot_bridge" ]				= %corner_standL_trans_A_2_B_v2;


	//CONTROL ROOM
	level.scr_anim[ "generic" ][ "killhouse_sas_price_idle" ][ 0 ]		= %killhouse_sas_price_idle;
	level.scr_anim[ "generic" ][ "look_idle_cornerR" ][ 0 ]		= %corner_standr_look_idle;
	level.scr_anim[ "generic" ][ "alert2look_cornerR" ]			= %corner_standr_alert_2_look;
	
	
	//breach anims
	level.scr_anim[ "generic" ][ "patrol_bored_react_walkstop" ] = %patrol_bored_react_walkstop;
	level.scr_anim[ "generic" ][ "breach_react_push_guy2" ]		= %breach_react_push_guy2;
	level.scr_anim[ "generic" ][ "breach_react_push_guy1" ]= %breach_react_push_guy1;
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy1" ]	= %breach_react_guntoss_v2_guy1;	
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy2" ]	= %breach_react_guntoss_v2_guy2;	
	level.scr_anim[ "generic" ][ "breach_react_knife_charge" ] = %breach_react_knife_charge;
	level.scr_anim[ "generic" ][ "breach_react_knife_charge_death" ] = %death_shotgun_back_v1;

	//AIRSTRIP
	level.scr_anim[ "nade_tosser" ][ "cqb_nade_throw" ]			= %CQB_stand_grenade_throw;
	addNotetrack_flag( "nade_tosser", "grenade_throw", "nade_tossed", "cqb_nade_throw" ); //grenade_throw //grenade_right
}

#using_animtree( "animated_props" );
animated_model_setup()
{
	level.anim_prop_models[ "foliage_desertbrush_1_animated" ][ "sway" ] = %foliage_desertbrush_1_sway;
}

#using_animtree( "dog" );
dog()
{
	level.scr_anim[ "generic" ][ "dog_idle" ][0]					= %german_shepherd_attackidle;		
	level.scr_anim[ "generic" ][ "dog_eating" ][0]					= %german_shepherd_eating;		
	level.scr_anim[ "generic" ][ "dog_eating_single" ]				= %german_shepherd_eating;		
	level.scr_anim[ "generic" ][ "dog_growling" ][0]				= %german_shepherd_attackidle_growl;	
	
	level.scr_anim[ "generic" ][ "dog_barking" ][0]					= %german_shepherd_attackidle_growl;
	level.scr_anim[ "generic" ][ "dog_barking" ][1]					= %german_shepherd_attackidle_bark;	
	level.scr_anim[ "generic" ][ "dog_barking" ][2]					= %german_shepherd_attackidle_bark;	
	level.scr_anim[ "generic" ][ "dog_barking" ][3]					= %german_shepherd_attackidle_bark;	
}

#using_animtree( "script_model" );
script_models()
{
	level.scr_model[ "knife" ] 										= "weapon_parabolic_knife";
	
	level.scr_anim[ "chair" ][ "sleep_react" ]						= %parabolic_guard_sleeper_react_chair;
	level.scr_animtree[ "chair" ] 									= #animtree;
	level.scr_model[ "chair" ] 										= "com_folding_chair";
	
	level.scr_anim[ "chair_ak" ][ "sit_load_ak_react" ]	 			= %sitting_guard_loadAK_idle_chair;
	level.scr_animtree[ "chair_ak" ] 								= #animtree;
	level.scr_model[ "chair_ak" ] 									= "com_folding_chair";
	
	level.scr_anim[ "flashlight" ][ "fl_death" ]					= %blackout_flashlightguy_death_flashlight;
	level.scr_sound[ "flashlight" ][ "fl_death" ]					= "scn_blackout_drop_flashlight";

	level.scr_anim[ "flashlight" ][ "search" ]						= %blackout_flashlightguy_moment2death_flashlight;
	level.scr_sound[ "flashlight" ][ "search" ]						= "scn_blackout_drop_flashlight_draw";
	
	level.scr_anim[ "rope" ][ "rappel_hookup" ]						= %afgan_caves_player_hookup_rope;
	level.scr_model[ "rope" ] 										= "weapon_carabiner_thin_rope";
	level.scr_animtree[ "rope" ] 									= #animtree;
	
	level.scr_anim[ "rope_price" ][ "rope_hookup" ]					= %afgan_caves_price_hookup_rope;
	level.scr_model[ "rope_price" ] 								= "weapon_carabiner_thin_rope";
	level.scr_animtree[ "rope_price" ] 								= #animtree;
	
	level.scr_anim[ "rappel_rope_price" ][ "pri_rappel_jump" ]		= %afgan_caves_Price_rappel_jump_rappelRope;
	level.scr_anim[ "rappel_rope_price" ][ "pri_hanging_idle" ][ 0 ]= %afgan_caves_Price_hanging_idle_rappelRope;
	level.scr_anim[ "rappel_rope_price" ][ "pri_rappel_idle" ][ 0 ] = %afgan_caves_Price_rappel_idle_rappelRope;
	level.scr_model[ "rappel_rope_price" ] 						 	= "afgan_caves_rappel_rope";
	level.scr_animtree[ "rappel_rope_price" ] 						= #animtree;

	level.scr_anim[ "tarp" ][ "rise_up" ]							= %scout_sniper_sand_ghillie_tarp_emerge;
	level.scr_animtree[ "tarp" ] 									= #animtree;
	level.scr_model[ "tarp" ] 										= "scout_sniper_sand_ghillie_tarp";	

// Breach door
	level.scr_anim[ "breach_door_model_caves" ][ "breach" ]	 		= %breach_player_door_v2;
	level.scr_animtree[ "breach_door_model_caves" ]					= #animtree;
	level.scr_model[ "breach_door_model_caves" ]					= "com_door_03_handleright";
	
	level.scr_anim[ "breach_door_hinge_caves" ][ "breach" ]			= %breach_player_door_hinge_v1;
	level.scr_animtree[ "breach_door_hinge_caves" ] 				= #animtree;
	level.scr_model[ "breach_door_hinge_caves" ] 					= "com_door_piece_hinge3";
	
// Swinging lamp
	level.scr_animtree[ "lamp" ] 									= #animtree;
	level.scr_model[ "lamp" ] 										= "ch_industrial_light_animated_01_on";
	level.scr_anim[ "lamp" ][ "swing" ] 							= %swinging_industrial_light_01_mild;
	level.scr_anim[ "lamp" ][ "swing_dup" ] 						= %swinging_industrial_light_01_mild_dup;
	
//	level.scr_animtree[ "lamp_off" ] 								= #animtree;
//	level.scr_model[ "lamp_off" ] 									= "ch_industrial_light_animated_01_off";

}

#using_animtree( "player" );
player_animations()
{
	level.scr_animtree[ "player_rig" ] 								= #animtree;
	level.scr_model[ "player_rig" ] 								= "ch_viewhands_player_gk_m4_sopmod_ii"; //viewhands_player_us_army
	level.scr_anim[ "player_rig" ][ "rappel_close" ] 				= %afgan_caves_player_rappel_close;
	level.scr_anim[ "player_rig" ][ "rappel_far" ] 					= %afgan_caves_player_rappel_far;

	level.scr_anim[ "player_rig" ][ "rappel_close_node" ] 			= %cave_rappel_close;
	level.scr_anim[ "player_rig" ][ "rappel_far_node" ] 			= %cave_rappel_far;
	level.scr_anim[ "player_rig" ][ "rappel_hookup" ] 				= %afgan_caves_player_rappel_hookup;
	
	level.scr_anim[ "player_rig" ][ "rappel_root" ] 				= %cave_rappel;	
	level.scr_anim[ "player_rig" ][ "rappel_kill" ] 				= %afgan_caves_player_rappel_end_kill;
	
	addNotetrack_customFunction( "player_rig", "start_guard", ::start_guard_anim );
}

start_guard_anim( guy )
{
	self anim_single_solo( self.guard, "rappel_kill" );
}

kill_me( guy )
{
	guy.a.nodeath = true;
	guy.allowdeath = true;
	guy.diequietly = true;
	guy kill();
}


dialog()
{
	// GENERAL
	// "Make sure you're using a suppressed weapon, otherwise we're dead."
	level.scr_radio[ "afcaves_pri_suppressedweapon" ] = "afcaves_pri_suppressedweapon";

	
	// INTRO
	// "I'll wait for you at the exfil point. Three hours."
	level.scr_radio[ "afcaves_nkl_waitforyou" ] = "afcaves_nkl_waitforyou";
	
	// "Don't bother. This was a one-way flight, mate."
	level.scr_radio[ "afcaves_pri_dontbother" ] = "afcaves_pri_dontbother";
	
	// "Then good luck, my friend."
	level.scr_radio[ "afcaves_nkl_goodluck" ] = "afcaves_nkl_goodluck";
	
	// "Move out."
	level.scr_radio[ "afcaves_pri_moveout" ] = "afcaves_pri_moveout";
	
	
	// INTRO/HILLSIDE WIRETAP
	// "This decryption code better be worth the price we paid..."
	level.scr_radio[ "afcaves_pri_decryptioncode" ] = "afcaves_pri_decryptioncode";
	
	// "...(go) ahead Alpha?"
	level.scr_radio[ "afcaves_schq_goahead" ] = "afcaves_schq_goahead";
	
	// "Looks like Makarov's intel was solid. This is it."
	level.scr_radio[ "afcaves_pri_intelwassolid" ] = "afcaves_pri_intelwassolid";
	
	// "Riverbed all clear, over."
	level.scr_radio[ "afcaves_sc1_riverbedclear" ] = "afcaves_sc1_riverbedclear";
	
	// "Bravo?"
	level.scr_radio[ "afcaves_schq_bravo" ] = "afcaves_schq_bravo";
	
	// "Catwalk all clear... visibility 100%, over."
	level.scr_radio[ "afcaves_sc2_catwalkclear" ] = "afcaves_sc2_catwalkclear";
	
	// "Zulu?"
	level.scr_radio[ "afcaves_schq_zulu" ] = "afcaves_schq_zulu";
	
	// "Sandstorm. Not much to see right now, over."
	level.scr_radio[ "afcaves_sc3_sandstorm" ] = "afcaves_sc3_sandstorm";
	
	// "...uh, we're starting our patrol east along the canyon, north side access road, over."
	level.scr_radio[ "afcaves_sc1_startingpatrol" ] = "afcaves_sc1_startingpatrol";
	
	// "Copy that, Disciple Four.  Finish your sweep and get back inside. Zulu team report's a heavy sandstorm on the way. Oxide out."
	level.scr_radio[ "afcaves_schq_finishsweep" ] = "afcaves_schq_finishsweep";


	// ROAD PATROL
	// "Hold up."
	level.scr_radio[ "pri_holdup" ] = "afcaves_pri_holdup2";

	// "Enemy patrol."
	level.scr_radio[ "pri_enemypatrol" ] = "afcaves_pri_enemypatrol2";
	
	// "Hold your fire."
	level.scr_radio[ "afcaves_pri_holdyourfire" ] = "afcaves_pri_holdyourfire";
	
	// "Good, they're splitting up. Let them separate."
	level.scr_radio[ "afcaves_pri_splittingup" ] = "afcaves_pri_splittingup";
	
	// "Wait for them to split up."
	//level.scr_radio[ "afcaves_pri_splitup" ] = "afcaves_pri_splitup";
	
	// "Focus on the group on the right, directly beneath us. Let's take them out first."
	level.scr_radio[ "afcaves_pri_grouponright" ] = "afcaves_pri_grouponright";
	
	// "I'll take the two on the left."
	level.scr_radio[ "afcaves_pri_twoonleft" ] = "afcaves_pri_twoonleft";
	
	// "On my mark."
	level.scr_radio[ "afcaves_pri_onmymark" ] = "afcaves_pri_onmymark";
	
	// "Three..."
	level.scr_radio[ "afcaves_pri_three" ] = "afcaves_pri_three";
	
	// "Two..."
	level.scr_radio[ "afcaves_pri_two" ] = "afcaves_pri_two";
	
	// "One..."
	level.scr_radio[ "afcaves_pri_one" ] = "afcaves_pri_one";
	
	// "Mark."
	level.scr_radio[ "afcaves_pri_mark" ] = "afcaves_pri_mark";
	
	// "Just like old times."
	level.scr_radio[ "afcaves_pri_justlikeoldtimes" ] = "afcaves_pri_justlikeoldtimes";
	
	// "Dog neutralized, I count five tangos down."
	level.scr_radio[ "afcaves_pri_dogneutralized" ] = "afcaves_pri_dogneutralized";
	
	// "Close enough."
	level.scr_radio[ "afcaves_pri_closeenough" ] = "afcaves_pri_closeenough";
	
	// "We have to work together, Soap - stick to the plan next time."
	level.scr_radio[ "afcaves_pri_sticktoplan" ] = "afcaves_pri_sticktoplan";
	
	// "We've been spotted - take 'em out before they can radio back in!"
	level.scr_radio[ "afcaves_pri_beenspotted" ] = "afcaves_pri_beenspotted";
	
	// "Soap, these aren't your average muppets. No more mistakes, let's go."
	level.scr_radio[ "afcaves_pri_nomistakes" ] = "afcaves_pri_nomistakes";
	
	// "All right, we've got to take out the other group before they come back. Move."
	level.scr_radio[ "afcaves_pri_beforecomeback" ] = "afcaves_pri_beforecomeback";
	
	// "Soap! Down here, let's go!"
	level.scr_radio[ "afcaves_pri_downhere" ] = "afcaves_pri_downhere";
	
	// "Move up! The other group's coming back!"
	level.scr_radio[ "afcaves_pri_groupsback" ] = "afcaves_pri_groupsback";
	
	// "Quickly, let's move up and take the others."
	level.scr_radio[ "afcaves_pri_taketheothers" ] = "afcaves_pri_taketheothers";
	
	// "I'm in position - take the shot."
	level.scr_radio[ "afcaves_pri_taketheshot" ] = "afcaves_pri_taketheshot";
	
	// "Soap, they're coming back -  I'm repositioning to get out of sight."
	level.scr_radio[ "afcaves_pri_repositioning" ] = "afcaves_pri_repositioning";
	
	// "Soap, they're about to find the bodies! We need to take them out!"
	level.scr_radio[ "afcaves_pri_findthebodies" ] = "afcaves_pri_findthebodies";
	
	// "I'm in position, ready to shoot."
	level.scr_radio[ "afcaves_pri_readytoshoot" ] = "afcaves_pri_readytoshoot";
	
	// "Soap, the second group found the bodies!  Take 'em out before they radio in!"
	level.scr_radio[ "afcaves_pri_foundbodies" ] = "afcaves_pri_foundbodies";

	// "We don't have much time before they find the bodies. Let's keep moving."
	level.scr_radio[ "afcaves_pri_muchtime" ] = "afcaves_pri_muchtime";

	// "Soap, I'm picking up a thermal spike up ahead. The cave must be somewhere over the edge."
	level.scr_radio[ "pri_thermalspike" ]				= "afcaves_pri_thermalspike";
	
	
	// POST ROAD-CLEARING WIRETAP
	// "Disciple Four, Oxide. What's your status, over?"
	level.scr_radio[ "afcaves_schq_d4whatsyourstatus" ] = "afcaves_schq_d4whatsyourstatus";
	
	// "Disciple Four, Oxide, do you copy, over?"
	level.scr_radio[ "afcaves_schq_d4doyoucopy" ] = "afcaves_schq_d4doyoucopy";
	
	// "Hey, I'm not gettin' anything from Disciple Four at the north ridge road. Could be a bad transmitter."
	level.scr_radio[ "afcaves_schq_badtransmitter" ] = "afcaves_schq_badtransmitter";
	
	// "Butcher Seven, Oxide. We've lost contact with Disciple Four."
	level.scr_radio[ "afcaves_schq_lostcontact2" ] = "afcaves_schq_lostcontact2";
	
	// "Probably just the sandstorm that's rollin' in or a bad transmitter."
	level.scr_radio[ "afcaves_schq_badtransmitter2" ] = "afcaves_schq_badtransmitter2";
	
	// "Send a team to check it out, over."
	level.scr_radio[ "afcaves_schq_sendateam2" ] = "afcaves_schq_sendateam2";
	
	// "Roger that Oxide, I'll send Vinson and Lambert. Butcher Seven out."
	level.scr_radio[ "afcaves_sc2_sendvinson" ] = "afcaves_sc2_sendvinson";


	// RAPPEL SETUP
	// Here we go - hook up here."
	level.scr_radio[ "pri_hookup" ]						= "afcaves_pri_hookup";

	// Price: "Soap, hook up."
	level.scr_radio[ "pri_soaphookup" ]					= "afcaves_pri_soaphookup";
	
	// Price: "Soap, what's the problem? Hook up to the railing."
	level.scr_radio[ "pri_whatstheproblem" ]			= "afcaves_pri_whatstheproblem";
	
	// Price: "Soap, hook up, let's go."
	level.scr_radio[ "pri_hookupletsgo" ]				= "afcaves_pri_hookupletsgo";


	// RAPPEL
	// Price: "Go."
	level.scr_radio[ "pri_go" ]							= "afcaves_pri_go";	
	
	// Price: "Got two tangos down below."
	level.scr_radio[ "pri_2inthechest" ]				= "afcaves_pri_2inthechest";		


	// BACKDOOR BARRACKS
	// Price: "Let's go."
	level.scr_radio[ "pri_letsgo" ] = "afcaves_pri_letsgo";
	
	// "Tango up ahead. Do not engage."
	level.scr_radio[ "afcaves_pri_tangoupahead" ] = "afcaves_pri_tangoupahead";
	
	// "Patrol coming our way - go left, quickly!"
	level.scr_radio[ "afcaves_pri_patrolcoming" ] = "afcaves_pri_patrolcoming";
	
	// "Let them pass."
	level.scr_radio[ "afcaves_pri_letthempass" ] = "afcaves_pri_letthempass";
	
	// "Take out the guard having a smoke, or wait for him to move along."
	level.scr_radio[ "afcaves_pri_havingasmoke" ] = "afcaves_pri_havingasmoke";
	
	// Price: "Good night."
	level.scr_radio[ "pri_goodnight" ] = "afcaves_pri_goodnight";
	
	// "Soap, that area's full of hostiles. We should keep to the left to avoid being spotted."
	level.scr_radio[ "afcaves_pri_avoidbeingspotted" ] = "afcaves_pri_avoidbeingspotted";

	// "Move."
	level.scr_radio[ "afcaves_pri_move2" ] = "afcaves_pri_move2";
	
	// "Easy now."
	level.scr_radio[ "afcaves_pri_easynow" ] = "afcaves_pri_easynow";
	
	// "Two tangos in this corridor - hold your fire and stay to the left."
	level.scr_radio[ "afcaves_pri_incorridor" ] = "afcaves_pri_incorridor";
	
	// "Tangos on our six."
	level.scr_radio[ "afcaves_pri_tangosonsix" ] = "afcaves_pri_tangosonsix";
	
	// "Soap, we've got two tangos with taclights coming down the stairs under that red light, dead ahead."
	level.scr_radio[ "afcaves_pri_tangoswithtaclights" ] = "afcaves_pri_tangoswithtaclights";
	
	// "I'll take the one on the right. On my mark."
	level.scr_radio[ "afcaves_pri_takeoneright" ] = "afcaves_pri_takeoneright";
	
	// "Impressive."
	level.scr_radio[ "afcaves_pri_impressive" ] = "afcaves_pri_impressive";
	
	// "Clear. Go."
	level.scr_radio[ "afcaves_pri_cleargo" ] = "afcaves_pri_cleargo";
	
	
	// CAVE STEALTHBREAK
	// "The guards know something's not right. Get out of sight and stay quiet."
	level.scr_radio[ "afcaves_pri_guardsknow" ] = "afcaves_pri_guardsknow";
	
	// "They're onto us - go loud."
	level.scr_radio[ "afcaves_pri_ontousgoloud" ] = "afcaves_pri_ontousgoloud";
	
	// "We're compromised - go loud."
	level.scr_radio[ "afcaves_pri_compromisedgoloud" ] = "afcaves_pri_compromisedgoloud";
	
	// "Soap, where are you? Get back here!"
	level.scr_radio[ "afcaves_pri_getbackhere" ] = "afcaves_pri_getbackhere";
	
	// "We got lucky that time."
	level.scr_radio[ "afcaves_pri_gotlucky" ] = "afcaves_pri_gotlucky";
	
	// "That was close."
	level.scr_radio[ "afcaves_pri_thatwasclose" ] = "afcaves_pri_thatwasclose";
	
	
	// SHADOW COMPANY TALKING WHEN STEALTH SPOTTED
	// "I see him, he's over here!"
	level.scr_radio[ "afcaves_sc1_iseehim" ] = "afcaves_sc1_iseehim";
	
	// "Intruder spotted!"
	level.scr_radio[ "afcaves_sc1_spotted" ] = "afcaves_sc1_spotted";
	
	// "Hostile at my location!"
	level.scr_radio[ "afcaves_sc1_hostilemyloc" ] = "afcaves_sc1_hostilemyloc";
	
	
	// CAVE WIRETAP
	// "Disciple Five, Oxide. Gimme a sitrep over."
	level.scr_radio[ "afcaves_schq_sitrep" ] = "afcaves_schq_sitrep";
	
	// "Disciple Five, Oxide. Gimme a sitrep over. [second time]"
	level.scr_radio[ "afcaves_schq_sitrepover" ] = "afcaves_schq_sitrepover";


	// STEAM ROOM
	// "Disciple Six, we've lost all contact with Disciple Five. Check it out over."
	level.scr_radio[ "afcaves_schq_lostcontact" ] = "afcaves_schq_lostcontact";
	
	// "Roger that Oxide, we're on the catwalk, heading to the steam room. Standby."
	level.scr_radio[ "afcaves_sc3_oncatwalk" ] = "afcaves_sc3_oncatwalk";
	
	// "Top of the staircase - he's mine."
	level.scr_radio[ "afcaves_pri_topofstairs" ] = "afcaves_pri_topofstairs";
	
	// "Never mind, then."
	level.scr_radio[ "afcaves_pri_nevermind" ] = "afcaves_pri_nevermind";
	
	// "Oxide, Disciple Six at the steam room. No sign of Five, over."
	level.scr_radio[ "afcaves_sc3_atsteamroom" ] = "afcaves_sc3_atsteamroom";
	
	// "Disciple Six, assume possible enemy infiltration. Go dark, breach and clear."
	level.scr_radio[ "afcaves_schq_godark" ] = "afcaves_schq_godark";
	
	// "Sounds like we're gonna meet 'em head on, Soap."
	level.scr_radio[ "afcaves_pri_meetemheadon" ] = "afcaves_pri_meetemheadon";
	
	// "Here we go - get ready."
	level.scr_radio[ "afcaves_pri_getready" ] = "afcaves_pri_getready";
	
	// Shadow Company Leader: "Move in."
	level.scr_radio[ "scl_movein" ] = "afcaves_scl_movein";
	
	// "Door charge planted. Ready to breach."
	level.scr_radio[ "afcaves_sc3_chargeplanted" ] = "afcaves_sc3_chargeplanted";
	
	// "Hit it."
	level.scr_radio[ "afcaves_scl_hitit" ] = "afcaves_scl_hitit";
	
	// "Breaching, breaching!"
	level.scr_radio[ "afcaves_sc3_breaching" ] = "afcaves_sc3_breaching";
	
	// "Foxtrot element, sweep left."
	level.scr_radio[ "afcaves_scl_foxtrotelement" ] = "afcaves_scl_foxtrotelement";
	
	// "Search pattern Echo Charlie. Go."
	level.scr_radio[ "afcaves_scl_patternecho" ] = "afcaves_scl_patternecho";
	
	// "Door area clear."
	level.scr_radio[ "afcaves_sc3_areaclear" ] = "afcaves_sc3_areaclear";
	
	// "Check your corners."
	level.scr_radio[ "afcaves_scl_checkcorners" ] = "afcaves_scl_checkcorners";
	
	// "They're here! Open fire!"
	level.scr_radio[ "afcaves_scl_theyrehere" ] = "afcaves_scl_theyrehere";
	
	// "Stay frosty, hunt them down!"
	level.scr_radio[ "afcaves_scl_huntthemdown" ] = "afcaves_scl_huntthemdown";
	
	// "Go loud! Open fire!"
	level.scr_radio[ "afcaves_pri_goloud" ] = "afcaves_pri_goloud";
	
	// "Disciple Nine, your rear guard just flatlined!"
	level.scr_radio[ "afcaves_schq_flatlined" ] = "afcaves_schq_flatlined";
	
	// "Not possible. We just cleared that area. (snort) Nobody's that good Oxi-"
	level.scr_radio[ "afcaves_sc3_notpossible" ] = "afcaves_sc3_notpossible";
	
	// "It's Price."
	level.scr_radio[ "afcaves_shp_itsprice" ] = "afcaves_shp_itsprice";
	
	// "Backup priority items and burn the rest. Fire teams - just delay 'em until we're ready to pull out."
	level.scr_radio[ "afcaves_shp_burntherest" ] = "afcaves_shp_burntherest";


	//CAVERN
	//* Price: "We gotta take out those sentry guns!"                                                                                    
	//level.scr_radio[ "pri_takeoutsentry" ]				= "afcaves_pri_takeoutsentry";

	//* Price: "I got a visual on Shepherd! He's getting away! Head for that door to the northwest! Go! Go!"                                                                                    
	level.scr_radio[ "pri_gettingaway" ]				= "afcaves_pri_gettingaway";
	
	//* Shadow Company 2: "We're gonna tear you a new one MacTavish�"                                                                                    
	//level.scr_radio[ "sc2_tearyou" ]					= "afcaves_sc2_tearyou";

	//* Price: "Soap, get in position to breach!"                                                                                    
	level.scr_radio[ "pri_positiontobreach" ]			= "afcaves_pri_positiontobreach";

	//* Price: "Do it."                                                                                    
	level.scr_radio[ "pri_doit" ]						= "afcaves_pri_doit";


	//AIRSTRIP
	//* Shepherd: "Have your men stay with me."                                                                                    
	level.scr_radio[ "shp_menstaywithme" ]				= "afcaves_shp_menstaywithme";

	//* Shepherd: "Leave two squads to cover the entrance."                                                                                    
	level.scr_radio[ "shp_twosquads" ]					= "afcaves_shp_twosquads";

	//* Lieutenant: "Yes sir!."                                                                                    
	level.scr_radio[ "lnt_yessir3" ]					= "afcaves_lnt_yessir3";

	//* Price: "There he is! He's gone into the tunnel to the southwest!"                                                                                    
	level.scr_radio[ "pri_intothetunnel" ]				= "afcaves_pri_intothetunnel";
	
	//* Shepherd: "Call in some air support!"                                                                                    
	level.scr_radio[ "shp_airsupport" ]					= "afcaves_shp_airsupport";

	//* Lieutenant: "Little Bird inbound now."                                                                                    
	level.scr_radio[ "lnt_littlebirdinbound" ]			= "afcaves_lnt_littlebirdinbound";
	
	//* Price: 	Heads up Soap! Helicopter coming in fast from the west!                                                                                   
	level.scr_radio[ "pri_gonnagetaway" ]				= "afcaves_pri_gonnagetaway";
	
	//* Price: "Take out that helicopter!!"                                                                                    
	level.scr_radio[ "pri_takeoutheli" ]				= "afcaves_pri_takeoutheli";

	//* Price: "Soap, regroup on me! He went through this tunnel, let's go!"                                                                                    
	level.scr_radio[ "pri_regrouponme" ]				= "afcaves_pri_regrouponme";
	
	//* Price: "Keep moving!"                                                                                    
	level.scr_radio[ "pri_keepmoving" ]					= "afcaves_pri_keepmoving";

	//* Price: "Move up!"                                                                                    
	level.scr_radio[ "pri_moveup1" ]					= "afcaves_pri_moveup1";
}