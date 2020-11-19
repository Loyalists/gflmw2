#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;

main()
{
	generic_human();
	linebook();
	mi28();

	tunnels();
	whitehouse();
	whitehouse_script_model();
	player_animations();
	whitehouse_door();
	tunnels_door();
	emp_script_model();
}

#using_animtree( "generic_human" );
generic_human()
{	
	level.scr_anim[ "generic" ][ "stand_exposed_wave_halt" ] 		= %stand_exposed_wave_halt;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_halt_v2" ] 	= %stand_exposed_wave_halt_v2;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_on_me" ] 		= %stand_exposed_wave_on_me;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_on_me_v2" ] 	= %stand_exposed_wave_on_me_v2;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_move_up" ] 	= %stand_exposed_wave_move_up;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_move_out" ] 	= %stand_exposed_wave_move_out;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_target_spotted" ] 	= %stand_exposed_wave_target_spotted;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_down" ] 		= %stand_exposed_wave_down;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_go" ] 			= %stand_exposed_wave_go;
	
	level.scr_anim[ "generic" ][ "CornerStndR_alert_signal_enemy_spotted" ] = %CornerStndR_alert_signal_enemy_spotted;
	level.scr_anim[ "generic" ][ "CornerStndR_alert_signal_move_out" ] 		= %CornerStndR_alert_signal_move_out;
	level.scr_anim[ "generic" ][ "CornerStndR_alert_signal_on_me" ] 		= %CornerStndR_alert_signal_on_me;
	level.scr_anim[ "generic" ][ "CornerStndR_alert_signal_stopStay_down" ] = %CornerStndR_alert_signal_stopStay_down;
	
	//ISS
	level.scr_anim[ "generic" ][ "oilrig_sub_A_idle_1" ] 			= %oilrig_sub_A_idle_1;
	
	//EMP
	level.scr_anim[ "generic" ][ "bulletshield_pain_short" ] 		= %stand_exposed_extendedpain_chest;
	level.scr_anim[ "generic" ][ "CornerCrR_trans_IN_L" ] 			= %CornerCrR_trans_IN_L;
	level.scr_anim[ "generic" ][ "corner_standR_trans_CQB_IN_2" ] 	= %corner_standR_trans_CQB_IN_2;
	level.scr_anim[ "generic" ][ "CornerCrL_alert_2_stand" ] 		= %CornerCrL_alert_2_stand;
	level.scr_anim[ "generic" ][ "exposed_tracking_turn135R" ] 		= %exposed_tracking_turn135R;
	level.scr_anim[ "generic" ][ "dcemp_BHrescue_soldier" ] 		= %dcemp_BHrescue_soldier;
	level.scr_anim[ "generic" ][ "corner_standR_trans_IN_3" ] 		= %corner_standR_trans_IN_3;
	level.scr_anim[ "generic" ][ "corner_standR_trans_CQB_IN_3" ] 	= %corner_standR_trans_CQB_IN_3;
	
	level.scr_anim[ "generic" ][ "DCemp_react_guyB_react" ] 		= %DCemp_react_guyB_react;
	level.scr_anim[ "generic" ][ "DCemp_react_guyA_react" ] 		= %DCemp_react_guyA_react;
	
	level.scr_anim[ "generic" ][ "corner_standR_painC" ] 			= %corner_standR_painC;
	level.scr_anim[ "generic" ][ "corner_standR_look_idle" ][0] 	= %corner_standR_look_idle;
	level.scr_anim[ "generic" ][ "corner_standR_alert_2_look" ] 	= %corner_standR_alert_2_look;
	level.scr_anim[ "generic" ][ "corner_standR_look_2_alert_fast" ]= %corner_standR_look_2_alert_fast;
	level.scr_anim[ "generic" ][ "corner_standR_look_2_alert" ]		= %corner_standR_look_2_alert;
	
	level.scr_anim[ "generic" ][ "CornerCrR_alert_painA" ] 			= %CornerCrR_alert_painA;
	level.scr_anim[ "generic" ][ "CornerCrR_look_idle" ][0] 		= %CornerCrR_look_idle;
	level.scr_anim[ "generic" ][ "CornerCrR_alert_2_look" ] 		= %CornerCrR_alert_2_look;
	level.scr_anim[ "generic" ][ "CornerCrR_look_2_alert_fast" ]	= %CornerCrR_look_2_alert_fast;
	level.scr_anim[ "generic" ][ "CornerCrR_look_2_alert" ] 		= %CornerCrR_look_2_alert;
	
	level.scr_anim[ "marine1" ][ "dcemp_BHrescue" ] 				= %dcemp_BHrescue_soldier;
		
	//STREET
	level.scr_anim[ "generic" ][ "CornerCrR_trans_OUT_F" ] 			= %CornerCrR_trans_OUT_F;
	level.scr_anim[ "generic" ][ "corner_standR_trans_OUT_6" ] 		= %corner_standR_trans_OUT_6;
		
	level.scr_anim[ "generic" ][ "traverse_jumpdown_96" ] 			= %traverse_jumpdown_96;
	level.scr_anim[ "generic" ][ "cornerCrR_alert_2_stand" ] 		= %cornerCrR_alert_2_stand;
	level.scr_anim[ "generic" ][ "street_flare_throw" ] 			= %grenade_return_standing_throw_overhand_forward;
	addNotetrack_customFunction( "generic", "grenade_right", ::street_pickup_flare, "street_flare_throw" );
	addNotetrack_customFunction( "generic", "grenade_throw", ::street_throw_flare, "street_flare_throw" );
	
	level.scr_anim[ "generic" ][ "exposed_idle_reactB" ] 			= %exposed_idle_reactB;	
	level.scr_anim[ "generic" ][ "exposed_flashbang_v1" ] 			= %exposed_flashbang_v1;
	level.scr_anim[ "generic" ][ "exposed_flashbang_v4" ] 			= %exposed_flashbang_v4;
	
	level.scr_anim[ "generic" ][ "run_reaction_R_quick" ] 			= %run_reaction_R_quick;
	level.scr_anim[ "generic" ][ "run_reaction_L_quick" ] 			= %run_reaction_L_quick;	
	level.scr_anim[ "generic" ][ "run_turn_R45" ] 					= %run_turn_R45;	
	level.scr_anim[ "generic" ][ "run_turn_L45" ] 					= %run_turn_L45;	
	level.scr_anim[ "generic" ][ "run_turn_R90" ] 					= %run_turn_R90;	
	level.scr_anim[ "generic" ][ "run_turn_L90" ] 					= %run_turn_L90;	
	
		
	level.scr_anim[ "generic" ][ "crouch_2run_F" ] 					= %crouch_2run_F;	
	level.scr_anim[ "generic" ][ "crouch_2run_R" ] 					= %crouch_2run_R;	
	level.scr_anim[ "generic" ][ "crouch_2run_L" ] 					= %crouch_2run_L;	
	
	level.scr_anim[ "generic" ][ "stand_2_run_F_2" ] 				= %stand_2_run_F_2;	
	level.scr_anim[ "generic" ][ "stand_2_run_R" ] 					= %stand_2_run_R;	
	level.scr_anim[ "generic" ][ "stand_2_run_L" ] 					= %stand_2_run_L;	
	
	level.scr_anim[ "generic" ][ "jump_across_100_lunge" ] 			= %jump_across_100_lunge;	
	level.scr_anim[ "generic" ][ "jump_across_100_spring" ] 		= %jump_across_100_spring;	
	level.scr_anim[ "generic" ][ "jump_across_100_stumble" ] 		= %jump_across_100_stumble;	
		
	level.scr_anim[ "generic" ][ "run_react_stumble_non_loop" ]		= %run_react_stumble_non_loop;	
	level.scr_anim[ "generic" ][ "run_react_flinch_non_loop" ] 		= %run_react_flinch_non_loop;	
	level.scr_anim[ "generic" ][ "run_react_duck_non_loop" ] 		= %run_react_duck_non_loop;	
	
	level.scr_anim[ "generic" ][ "run_pain_fallonknee" ] 			= %run_pain_fallonknee;
	level.scr_anim[ "generic" ][ "run_pain_fallonknee_02" ] 		= %run_pain_fallonknee_02;
	level.scr_anim[ "generic" ][ "run_pain_fallonknee_03" ] 		= %run_pain_fallonknee_03;
	level.scr_anim[ "generic" ][ "slide_across_car" ] 				= %slide_across_car;
	level.scr_anim[ "generic" ][ "gulag_sewer_slide" ] 				= %gulag_sewer_slide;
	level.scr_anim[ "generic" ][ "fastrope_fall" ] 					= %fastrope_fall;
	level.scr_anim[ "generic" ][ "traverse_window_M_2_dive" ]	 	= %traverse_window_M_2_dive;
	
	level.scr_anim[ "generic" ][ "exposed_flashbang_v1" ] 			= %exposed_flashbang_v1;
	level.scr_anim[ "generic" ][ "exposed_flashbang_v2" ] 			= %exposed_flashbang_v2;
	level.scr_anim[ "generic" ][ "exposed_flashbang_v3" ] 			= %exposed_flashbang_v3;
	level.scr_anim[ "generic" ][ "exposed_flashbang_v4" ] 			= %exposed_flashbang_v4;
	level.scr_anim[ "generic" ][ "exposed_flashbang_v5" ] 			= %exposed_flashbang_v5;
		
	level.scr_anim[ "generic" ][ "cqb_stand_signal_move_out" ] 		= %cqb_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "cqb_stop_8_signal" ] 				= %cqb_stop_2_signal;
	
	level.scr_anim[ "generic" ][ "bog_b_spotter_react" ] 			= %bog_b_spotter_react;
	level.scr_anim[ "generic" ][ "favela_run_and_wave" ] 			= %favela_run_and_wave;
	
	//CORNER
	level.scr_anim[ "generic" ][ "corner_standR_explosion_divedown" ] 	= %corner_standR_explosion_divedown;
	level.scr_anim[ "generic" ][ "corner_standR_explosion_standup" ] 	= %corner_standR_explosion_standup;
	level.scr_anim[ "generic" ][ "hunted_open_barndoor_flathand" ] 	= %hunted_open_barndoor_flathand;
	level.scr_anim[ "generic" ][ "run_reaction_180" ] 				= %run_reaction_180;
		
	level.scr_anim[ "generic" ][ "combatwalk_F_spin" ] 				= %combatwalk_F_spin;
	level.scr_anim[ "generic" ][ "patrol_jog_look_up_once" ] 		= %patrol_jog_look_up_once;
	level.scr_anim[ "generic" ][ "patrol_jog_360_once" ] 			= %patrol_jog_360_once;
	level.scr_anim[ "generic" ][ "patrol_jog_orders_once" ] 		= %patrol_jog_orders_once;
	
	level.scr_anim[ "generic" ][ "CQB_walk_turn_6" ] 				= %CQB_walk_turn_6;
	level.scr_anim[ "generic" ][ "CQB_walk_turn_7" ] 				= %CQB_walk_turn_7;
	level.scr_anim[ "generic" ][ "CQB_walk_turn_9" ] 				= %CQB_walk_turn_9;
	
	level.scr_anim[ "generic" ][ "casual_killer_jog_stop" ] 		= %casual_killer_jog_stop;
	level.scr_anim[ "generic" ][ "casual_killer_jog_start" ] 		= %casual_killer_jog_start;
		
	level.scr_anim[ "generic" ][ "casual_killer_jog" ][0] 			= %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "casual_killer_jog" ][1] 			= %casual_killer_jog_B;
	
	level.scr_anim[ "generic" ][ "combat_jog" ] 					= %combat_jog;	
	level.scr_anim[ "generic" ][ "scout_sniper_price_wave" ] 		= %scout_sniper_price_wave;	
	
	level.scr_anim[ "foley" ][ "hunted_woundedhostage_check" ]		= %hunted_woundedhostage_check_soldier;
	level.scr_sound[ "foley" ][ "hunted_woundedhostage_check" ]		= "scn_dcemp_check_dead_sgtfoley";
		
	//MEETING
	level.scr_anim[ "generic" ][ "casual_killer_jog_A" ] 			= %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "casual_killer_jog_B" ] 			= %casual_killer_jog_B;
	level.scr_anim[ "generic" ][ "casual_killer_jog" ][0] 			= %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "casual_killer_jog" ][1] 			= %casual_killer_jog_B;
		
	level.scr_anim[ "generic" ][ "patrol_bored_2_walk" ] 			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_bored_walk_2_bored" ] 		= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_bored_patrolwalk" ] 		= %patrol_bored_patrolwalk;
	
	level.scr_anim[ "generic" ][ "covercrouch_hide_idle" ][0] 		= %covercrouch_hide_idle;
	level.scr_anim[ "generic" ][ "covercrouch_hide_2_stand" ] 		= %covercrouch_hide_2_stand;
	level.scr_anim[ "generic" ][ "traverse_window_M_2_stop" ] 		= %traverse_window_M_2_stop;
	level.scr_anim[ "generic" ][ "traverse_window_M_2_run" ] 		= %traverse_window_M_2_run;
	
	
	level.scr_anim[ "generic" ][ "exposed_idle_reactA" ] 			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "cqb_stand_react_A" ] 				= %CQB_stand_react_A;
	level.scr_anim[ "generic" ][ "cqb_stand_react_B" ] 				= %CQB_stand_react_B;
	level.scr_anim[ "generic" ][ "cqb_stand_react_C" ] 				= %CQB_stand_react_C;
	level.scr_anim[ "generic" ][ "cqb_stand_react_D" ] 				= %CQB_stand_react_D;
	level.scr_anim[ "generic" ][ "cqb_stand_react_E" ] 				= %CQB_stand_react_E;
	
	level.scr_anim[ "generic" ][ "cargoship_open_cargo_guyL" ] 		= %cargoship_open_cargo_guyL;
	level.scr_anim[ "generic" ][ "run_2_stand_90R" ] 				= %run_2_stand_90R;
	level.scr_anim[ "generic" ][ "run_2_crouch_F" ] 				= %run_2_crouch_F;
	level.scr_anim[ "generic" ][ "run_2_crouch_90L" ] 				= %run_2_crouch_90L;
	level.scr_anim[ "generic" ][ "run_2_crouch_90R" ] 				= %run_2_crouch_90R;
	level.scr_anim[ "generic" ][ "casual_stand_idle_trans_in" ]	 	= %casual_stand_idle_trans_in;	
	level.scr_anim[ "generic" ][ "favela_escape_bigjump_faust" ] 	= %favela_escape_bigjump_faust;
	level.scr_anim[ "generic" ][ "freerunnerA_loop" ] 				= %freerunnerA_loop;
	level.scr_anim[ "generic" ][ "freerunnerB_loop" ] 				= %freerunnerB_loop;
	level.scr_anim[ "generic" ][ "unarmed_climb_wall" ] 			= %unarmed_climb_wall;
		
	level.scr_anim[ "generic" ][ "exposed_crouch_2_stand" ] 		= %exposed_crouch_2_stand;
	level.scr_anim[ "generic" ][ "coverstand_hide_2_aim" ] 			= %coverstand_hide_2_aim;
	level.scr_anim[ "generic" ][ "corner_standR_trans_alert_2_A_v2" ]= %corner_standR_trans_alert_2_A_v2;
	
	level.scr_anim[ "generic" ][ "DCemp_run_sequence_runner" ] 		= %DCemp_run_sequence_runner;
	addNotetrack_customFunction( "generic", "dcemp_ar3_whiskeyhotel_ps", ::dialogue_meetup_1, "DCemp_run_sequence_runner" );
	level.scr_anim[ "generic" ][ "DCemp_run_sequence_guy1" ] 		= %DCemp_run_sequence_guy1;
	addNotetrack_customFunction( "generic", "dcemp_cpd_wheregoin_ps", ::dialogue_meetup_2, "DCemp_run_sequence_guy1" );
	//addNotetrack_customFunction( "generic", "dcemp_cpd_wheregoin_ps", ::lookat_off, "DCemp_run_sequence_guy1" );

	level.scr_anim[ "runner" ][ "DCemp_run_sequence" ] 		= %DCemp_run_sequence_runner;
	level.scr_anim[ "dunn" ][ "DCemp_run_sequence" ] 		= %DCemp_run_sequence_guy1;
	addNotetrack_customFunction( "runner", "dcemp_ar3_whiskeyhotel_ps", ::dialogue_meetup_1, "DCemp_run_sequence" );
	addNotetrack_customFunction( "dunn", "dcemp_cpd_wheregoin_ps", ::dialogue_meetup_2, "DCemp_run_sequence" );
	
	//LOBBY
	level.scr_anim[ "generic" ][ "corner_standR_trans_CQB_OUT_8" ] 	= %corner_standR_trans_CQB_OUT_8;
	level.scr_anim[ "generic" ][ "hunted_open_barndoor" ] 			= %hunted_open_barndoor;
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_death_R" ] 			= %airport_security_guard_pillar_death_R;
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_death_L" ] 			= %airport_security_guard_pillar_death_L;
	level.scr_anim[ "generic" ][ "breach_kick_kickerR1_enter" ] 	= %breach_kick_kickerR1_enter;
	addNotetrack_customFunction( "generic", "kick", ::lobby_door_kick, "breach_kick_kickerR1_enter" );
	level.scr_anim[ "generic" ][ "corner_standR_flinchB" ] 			= %corner_standR_flinchB;
	level.scr_anim[ "generic" ][ "CQB_stand_grenade_throw" ] 		= %CQB_stand_grenade_throw;
	addNotetrack_attach( "generic", "grenade_right", "weapon_m84_flashbang_grenade", "TAG_INHAND", "CQB_stand_grenade_throw" );
	addNotetrack_detach( "generic", "grenade_throw", "weapon_m84_flashbang_grenade", "TAG_INHAND", "CQB_stand_grenade_throw" );
	addNotetrack_customFunction( "generic", "grenade_throw", ::lobby_flash_throw, "CQB_stand_grenade_throw" );
	level.scr_anim[ "generic" ][ "exposed_tracking_turn180L" ] 		= %exposed_tracking_turn180L;
		
	//PARKING
	level.scr_anim[ "generic" ][ "coverstand_hide_idle" ][0]		= %coverstand_hide_idle;
	level.scr_anim[ "generic" ][ "traverse_jumpdown_96" ] 			= %traverse_jumpdown_96;
	level.scr_anim[ "generic" ][ "traverse40" ] 					= %traverse40;
	level.scr_anim[ "generic" ][ "death_pose_on_desk" ] 			= %death_pose_on_desk;	
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_check_soldier_end" ]	= %hunted_woundedhostage_check_soldier_end;
	level.scr_anim[ "generic" ][ "DCemp_wounded_check_end" ]	= %DCemp_wounded_check_end;
	
	
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_climb_guy1" ] 	= %DCemp_BTR_moment_climb_guy1;
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_climb_guy2" ] 	= %DCemp_BTR_moment_climb_guy2;
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_climb_guy3" ] 	= %DCemp_BTR_moment_climb_guy3;
	
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_idle_guy1" ][0] 	= %DCemp_BTR_moment_idle_guy1;
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_idle_guy2" ][0] 	= %DCemp_BTR_moment_idle_guy2;
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_idle_guy3" ][0] 	= %DCemp_BTR_moment_idle_guy3;
	
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_guy1" ] 			= %DCemp_BTR_moment_guy1;
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_guy2" ] 			= %DCemp_BTR_moment_guy2;
	level.scr_anim[ "generic" ][ "DCemp_BTR_moment_guy3" ] 			= %DCemp_BTR_moment_guy3;
	
	level.scr_anim[ "generic" ][ "CornerStndR_alert_2_lean" ] 		= %CornerStndR_alert_2_lean;
	level.scr_anim[ "generic" ][ "CornerCrR_alert_2_lean" ]			= %CornerCrR_alert_2_lean;
	
			
	//PLAZA
	level.scr_anim[ "generic" ][ "favela_civ_warning_landing" ]		= %favela_civ_warning_landing;
	level.scr_anim[ "generic" ][ "corner_standR_trans_CQB_OUT_9" ] 	= %corner_standR_trans_CQB_OUT_9;
	level.scr_anim[ "generic" ][ "coverstand_look_moveup" ] 		= %coverstand_look_moveup;
	level.scr_anim[ "generic" ][ "coverstand_look_idle" ][0]	 	= %coverstand_look_idle;
	level.scr_anim[ "generic" ][ "coverstand_look_movedown" ] 		= %coverstand_look_movedown;
	level.scr_anim[ "generic" ][ "coverstand_trans_OUT_R" ] 		= %coverstand_trans_OUT_R;
	level.scr_anim[ "generic" ][ "corner_standR_alert_2_look" ] 	= %corner_standR_alert_2_look;
	level.scr_anim[ "generic" ][ "corner_standR_look_2_alert" ] 	= %corner_standR_look_2_alert;
	level.scr_anim[ "generic" ][ "corner_standR_look_idle" ][0] 	= %corner_standR_look_idle;
	level.scr_anim[ "generic" ][ "patrol_bored_react_look_retreat" ]= %patrol_bored_react_look_retreat;
		
	level.scr_anim[ "generic" ][ "corner_standR_trans_OUT_9" ] 		= %corner_standR_trans_OUT_9;	
}

tunnels()
{
	level.scr_anim[ "dunn" ][ "hunted_woundedhostage_check" ]				= %hunted_woundedhostage_check_soldier;
	level.scr_sound[ "dunn" ][ "hunted_woundedhostage_check" ]				= "scn_dcemp_check_dead_sgtfoley";
	level.scr_anim[ "dunn" ][ "hunted_woundedhostage_check_soldier_end" ]	= %hunted_woundedhostage_check_soldier_end;

	// Huah.
	level.scr_sound[ "dunn" ][ "dcemp_cpd_huah3" ]							= "dcemp_cpd_huah3";
	// Check out the seal on this door...I thought the President's bunker was under the West Wing.
	level.scr_sound[ "dunn" ][ "dcemp_cpd_westwing" ]						= "dcemp_cpd_westwing";
	// Well, real or not, this place is history man. Hope they got out in time.
	level.scr_sound[ "dunn" ][ "dcemp_cpd_placeishistory" ]					= "dcemp_cpd_placeishistory";

	// Cut the chatter. Ramirez, take point.
	level.scr_sound[ "foley" ][ "dcemp_fly_cutchatter" ]					= "dcemp_fly_cutchatter";
	// No, that's just for tourists. This must be the real thing. Open it up.
	level.scr_sound[ "foley" ][ "dcemp_fly_fortourists" ]					= "dcemp_fly_fortourists";
	level.scr_face[ "foley" ][ "dcemp_fly_fortourists" ]					= %dcemp_fly_fortourists;
	
	

	// Feet dry.
	level.scr_sound[ "marine1" ][ "dcemp_ar1_feetdry" ]						= "dcemp_ar1_feetdry";

	// Let's go! Let's go! 
	level.scr_sound[ "generic" ][ "dcemp_ar2_letsgo" ]						= "dcemp_ar2_letsgo";

	// Hustle up! Get to the Whiskey Hotel! Move!
	level.scr_sound[ "generic" ][ "dcemp_ar3_hustleup" ]					= "dcemp_ar3_hustleup";
	// Come on, let's go people! This way!
	level.scr_sound[ "generic" ][ "dcemp_ar3_thisway" ]						= "dcemp_ar3_thisway";
	// Move! Move! Get to the Whiskey Hotel!
	level.scr_sound[ "generic" ][ "dcemp_ar3_movemove" ]					= "dcemp_ar3_movemove";

	level.scr_anim[ "dead_guy" ][ "hunted_woundedhostage_check" ]			= %hunted_woundedhostage_check_hostage;
	level.scr_sound[ "dead_guy" ][ "hunted_woundedhostage_check" ]			= "scn_dcemp_check_dead_soldier";
	
	level.scr_anim[ "dead_guy" ][ "hunted_woundedhostage_idle_start" ][0]	= %hunted_woundedhostage_idle_start;
	level.scr_anim[ "dead_guy" ][ "hunted_woundedhostage_idle_end" ]		= %hunted_woundedhostage_idle_end;

	level.scr_anim[ "generic" ][ "death_sitting_pose_v1" ] 					= %death_sitting_pose_v1;

	level.scr_anim[ "generic" ][ "tunnel_door_open_guy" ]					= %cargoship_open_cargo_guyL;

	level.scr_anim[ "dunn" ][ "DCemp_door_sequence" ]					= %DCemp_door_sequence_dunn;
	level.scr_anim[ "foley" ][ "DCemp_door_sequence_foley_approch" ]	= %DCemp_door_sequence_foley_approch;
	level.scr_anim[ "foley" ][ "DCemp_door_sequence_foley_idle" ][0]	= %DCemp_door_sequence_foley_idle;
	level.scr_anim[ "foley" ][ "DCemp_door_sequence_foley_wave" ]		= %DCemp_door_sequence_foley_wave;

	// Check out the seal on this door...I thought the President's bunker was under the West Wing.
	addNotetrack_dialogue( "dunn", "dcemp_cpd_westwing_ps", "DCemp_door_sequence" , "dcemp_cpd_westwing" );
	addNotetrack_flag( "dunn" , "foley_dialogue", "tunnels_foley_dialogue", "DCemp_door_sequence" );
	// Well, real or not, this place is history man. Hope they got out in time.
	addNotetrack_dialogue( "dunn", "dcemp_cpd_placeishistory_ps", "DCemp_door_sequence" , "dcemp_cpd_placeishistory" );

	// Tunnel wave on - TEMP
	level.scr_anim[ "generic" ][ "wave_on" ][0]								= %coup_civilians_interrogated_guard_wave;
	//Go go go!!!			
	level.scr_sound[ "generic" ][ "gogogo" ] 		= "dcemp_fly_gogogo";	
	//Don't stop!! Keep moving!!			
	level.scr_sound[ "generic" ][ "keep_moving" ] 		= "dcemp_fly_dontstop";	
}

whitehouse()
{
	// Keep hitting 'em with the Two-Forty Bravos! Get more men moving on the left flank! 
 	level.scr_sound[ "marshall" ][ "dcemp_cml_moremen" ] 			= "dcemp_cml_moremen";
 	// You're lookin' at the 'high ground' Sergeant! There's still power in the Whiskey Hotel! 
// 	level.scr_sound[ "marshall" ][ "dcemp_cml_highground" ] 		= "dcemp_cml_highground";
 	// That means we still have a way to talk to Central Command IF we can retake it!
// 	level.scr_sound[ "marshall" ][ "dcemp_cml_retakeit" ] 			= "dcemp_cml_retakeit";
	// Now get your squad movin' up the left flank! Go!
// 	level.scr_sound[ "marshall" ][ "dcemp_cml_getyoursquad" ] 		= "dcemp_cml_getyoursquad";

	// Sounds like the party's already started.
	level.scr_sound[ "dunn" ][ "dcemp_cpd_partystarted" ] 			= "dcemp_cpd_partystarted";
	// Hey, there's a radio over here! The transmitter's not working, but I'm getting something!
	level.scr_sound[ "dunn" ][ "dcemp_cpd_radiooverhere" ] 			= "dcemp_cpd_radiooverhere";
	// What the hell are they talking about?
	level.scr_sound[ "dunn" ][ "dcemp_cpd_talkingabout" ] 			= "dcemp_cpd_talkingabout";
	// What happens now?
	level.scr_sound[ "dunn" ][ "dcemp_cpd_happensnow" ] 			= "dcemp_cpd_happensnow";

	// Roger that. Stay frosty.
	level.scr_sound[ "foley" ][ "dcemp_fly_rogerstayfrosty" ] 		= "dcemp_fly_rogerstayfrosty";
	// Sir, what's the situation here?
//	level.scr_sound[ "foley" ][ "dcemp_fly_situationhere" ] 		= "dcemp_fly_situationhere";
	// Roger that! Squad! Let's go! We're oscar mike! 
//	level.scr_sound[ "foley" ][ "dcemp_fly_squadoscarmike" ] 		= "dcemp_fly_squadoscarmike";
	//Work your way to the left!!
 	level.scr_sound[ "foley" ][ "dcemp_fly_workyourwayleft" ] 		= "dcemp_fly_workyourwayleft";
	//Ramirez, let's go! 
 	level.scr_sound[ "foley" ][ "dcemp_fly_ramirezgo" ] 			= "dcemp_fly_ramirezgo";
	//Move up! We gotta take the left flank!
 	level.scr_sound[ "foley" ][ "dcemp_fly_takeleftflank" ] 		= "dcemp_fly_takeleftflank";
	//We need to punch through right here!
 	level.scr_sound[ "foley" ][ "dcemp_fly_punchthrough" ] 			= "dcemp_fly_punchthrough";
	//Take out those machine guns!
 	level.scr_sound[ "foley" ][ "dcemp_fly_machineguns" ] 			= "dcemp_fly_machineguns";
	//Hammer Down means they're gonna flatten the city - we gotta get to the roof and stop 'em! 
 	level.scr_sound[ "foley" ][ "dcemp_fly_flattenthecity" ] 		= "dcemp_fly_flattenthecity";
	//We got less than two minutes, let's go!
 	level.scr_sound[ "foley" ][ "dcemp_fly_lessthantwomins" ] 		= "dcemp_fly_lessthantwomins";
	// 30 seconds! We gotta get to the roof now!! Go! Go!
	level.scr_sound[ "foley" ][ "dcemp_fly_30seconds" ]				= "dcemp_fly_30seconds";
	// One minute! Go go go!
	level.scr_sound[ "foley" ][ "dcemp_fly_60seconds" ]				= "dcemp_fly_60seconds";
	// 90 seconds! We got to push through.
	level.scr_sound[ "foley" ][ "dcemp_fly_90seconds" ]				= "dcemp_fly_90seconds";
	// Pop the flares!!
	level.scr_sound[ "foley" ][ "dcemp_fly_poptheflares" ]			= "dcemp_fly_poptheflares";
	//This war ain't over yet Corporal...all we did was level the playing field. 
 	level.scr_sound[ "foley" ][ "dcemp_fly_waraintover" ] 			= "dcemp_fly_waraintover";
	//Everyone back downstairs. Let's try and get the transmitter working on that radio. 
 	level.scr_sound[ "foley" ][ "dcemp_fly_backdownstairs" ] 		= "dcemp_fly_backdownstairs";

	//This is Cujo-Five-One to any friendly units in D.C.: Hammer Down is in effect, I repeat, Hammer Down is in effect. 
 	level.scr_radio[ "dcemp_fp1_hammerdown" ] 						= "dcemp_fp1_hammerdown";
	//If you can receive this transmission, you are in a hardened high-value structure. 
 	level.scr_radio[ "dcemp_fp1_highvalue" ] 						= "dcemp_fp1_highvalue";
	//Deploy green flares on the roof of this structure to indicate you are still combat effective. 
 	level.scr_radio[ "dcemp_fp1_greenflares" ] 						= "dcemp_fp1_greenflares";
	//We will abort our mission on direct visual contact with this countersign. 
 	level.scr_radio[ "dcemp_fp1_willabort" ] 						= "dcemp_fp1_willabort";
	//Two minutes to weapons release. 
 	level.scr_radio[ "dcemp_fp1_2minutes" ] 						= "dcemp_fp1_2minutes";
	//Ninety seconds to weapons release. 
 	level.scr_radio[ "dcemp_fp1_90secs" ] 							= "dcemp_fp1_90secs";
	//1 minute to weapons release. 
 	level.scr_radio[ "dcemp_fp1_1minute" ] 							= "dcemp_fp1_1minute";
	//Thirty seconds to weapons release. 
 	level.scr_radio[ "dcemp_fp1_30secs" ] 							= "dcemp_fp1_30secs";
	//(garble)...target package Whiskey Hotel Zero-One has been authorized....roger...passing IP Buick...standby�
 	level.scr_radio[ "dcemp_fp1_beenauthorized" ] 					= "dcemp_fp1_beenauthorized";
	//Bombs away bombs away.
 	level.scr_radio[ "dcemp_fp1_bombsaway" ] 						= "dcemp_fp1_bombsaway";
	//Countersign detected at the Whiskey Hotel! Abort abort!!
 	level.scr_radio[ "dcemp_fp1_abortabort" ] 						= "dcemp_fp1_abortabort";
	//Cujo 5-1 to friendly ground units at the Whiskey Hotel - that was a close one. 
 	level.scr_radio[ "dcemp_fp1_closeone" ] 						= "dcemp_fp1_closeone";
	//We're sending word back to HQ, stay alive down there. Cujo 5-1 out.
 	level.scr_radio[ "dcemp_fp1_wordtohq" ] 						= "dcemp_fp1_wordtohq";
	//We got a countersign! Abort mission!
 	level.scr_radio[ "dcemp_fp2_abortmission" ] 					= "dcemp_fp2_abortmission";
	//Aborting weapons release! Rolling out!
 	level.scr_radio[ "dcemp_fp3_rollingout" ] 						= "dcemp_fp3_rollingout";
	//Roger, weapons on safe! Aborting mission!
 	level.scr_radio[ "dcemp_fp4_abortingmission" ] 					= "dcemp_fp4_abortingmission";

	// rappel - TEMP
	level.scr_anim[ "rappel_guy" ][ "rappel_stand_idle_1" ][ 0 ]	= %launchfacility_a_rappel_idle_1;
	level.scr_anim[ "rappel_guy" ][ "rappel_stand_idle_2" ][ 0 ]	= %launchfacility_a_rappel_idle_2;
	level.scr_anim[ "rappel_guy" ][ "rappel_stand_idle_3" ][ 0 ]	= %launchfacility_a_rappel_idle_3;
	level.scr_anim[ "rappel_guy" ][ "rappel_drop" ]					= %launchfacility_a_rappel_1;

	// door kick
	level.scr_anim[ "generic" ][ "doorburst_wave" ]					= %doorburst_wave;
	level.scr_anim[ "generic" ][ "doorburst_fall" ]					= %doorburst_fall;

	// foley flare - TEMP
	level.scr_anim[ "foley" ][ "flare_moment_stand" ]				= %flare_moment_stand;
	addNotetrack_attach( "foley" , "attach flare" , "mil_emergency_flare", "tag_inhand", "flare_moment_stand" );
	addNotetrack_customFunction( "foley", "start flare", maps\dcemp_endpart_code::foley_flare_fx_start, "flare_moment_stand" );

	// tunnel exit briefing - TEMP
//	level.scr_anim[ "marshall" ][ "cover_dialogue_guy1" ]			= %invasion_vehicle_cover_dialogue_guy1;
//	level.scr_anim[ "marshall" ][ "cover_dialogue_guy1_idle" ][ 0 ]	= %invasion_vehicle_cover_dialogue_guy1_idle;
//	level.scr_anim[ "generic" ][ "cover_dialogue_guy2" ]			= %invasion_vehicle_cover_dialogue_guy2;

	level.scr_anim[ "marshall" ][ "DCemp_whitehouse_briefing" ]		= %DCemp_whitehouse_briefing_marshall;
	level.scr_anim[ "foley" ][ "DCemp_whitehouse_briefing" ]		= %DCemp_whitehouse_briefing_foley;

	// Sir, what's the situation here?
	addNotetrack_dialogue( "foley" , "dcemp_fly_situationhere_ps" , "DCemp_whitehouse_briefing" , "dcemp_fly_situationhere" );
 	// You're lookin' at the 'high ground' Sergeant! There's still power in the Whiskey Hotel! 
	addNotetrack_dialogue( "marshall" , "dcemp_cml_highground_ps" , "DCemp_whitehouse_briefing" , "dcemp_cml_highground" );
 	// That means we still have a way to talk to Central Command IF we can retake it!
	addNotetrack_dialogue( "marshall" , "dcemp_cml_retakeit_ps" , "DCemp_whitehouse_briefing" , "dcemp_cml_retakeit" );
	// Now get your squad movin' up the left flank! Go!
	addNotetrack_dialogue( "marshall" , "dcemp_cml_getyoursquad_ps" , "DCemp_whitehouse_briefing" , "dcemp_cml_getyoursquad" );
	// Roger that! Squad! Let's go! We're oscar mike! 
	addNotetrack_dialogue( "foley" , "dcemp_fly_squadoscarmike_ps" , "DCemp_whitehouse_briefing" , "dcemp_fly_squadoscarmike" );
	// not track for when to start moving towards the wh entrance.
	addNotetrack_flag( "marshall" , "dcemp_cml_getyoursquad_ps" , "whitehouse_moveout" , "DCemp_whitehouse_briefing" ); 

	// drone death anims
	anims = [];
	anims[ "death_explosion_up10" ]			= %death_explosion_up10;
	anims[ "death_explosion_left11" ]		= %death_explosion_left11;
	anims[ "death_explosion_stand_B_v2" ]	= %death_explosion_stand_B_v2;

	level.drone_death_anims = anims;
}

linebook()
{
//ISS
	//Come in Sat1, this is ISS Control. Houston's requesting a feed from your helmet cam, over.
	level.scr_radio[ "dcemp_iss_requestfeed" ] = "dcemp_iss_requestfeed";
	//Uh, they want you to look over towards the dark side of the earth.  It should be cresting the horizon about 15 degrees east of the starboard PV arrays.
	level.scr_radio[ "dcemp_iss_theywantyou" ] = "dcemp_iss_theywantyou";
	//Sat1, rotate your view a little further to the right will ya?
	level.scr_radio[ "dcemp_iss_rotateview" ] = "dcemp_iss_rotateview";
	//There it is, we're getting your feed Sat1.  Come in Houston, are you getting this?
	level.scr_radio[ "dcemp_iss_thereitis" ] = "dcemp_iss_thereitis";
	//Copy that ISS, video feed from Sat1 is clear.
	level.scr_radio[ "dcemp_hsc_copythat" ] = "dcemp_hsc_copythat";
	//Sat1, keep tracking the bogey. We're looking into it, standby.
	level.scr_radio[ "dcemp_hsc_keeptracking" ] = "dcemp_hsc_keeptracking";
	//Houston, we're not scheduled for any satellite launches today are we?
	level.scr_radio[ "dcemp_iss_notscheduled" ] = "dcemp_iss_notscheduled";
	//ISS, Houston. Standby. We may have a problem here.
	level.scr_radio[ "dcemp_hsc_standby" ] = "dcemp_hsc_standby";
	//Houston, this is ISS Control, uh... any word on the-
	level.scr_radio[ "dcemp_iss_anyword" ] = "dcemp_iss_anyword";
	
	
	level.scr_radio[ "scn_dcemp_iss_helmet_breathe_slow" ] 			= "scn_dcemp_iss_helmet_breathe_slow";
	level.scr_radio[ "scn_dcemp_iss_helmet_breathe_fast" ] 			= "scn_dcemp_iss_helmet_breathe_fast";
	
//STREET
	
	
	level.scr_sound[ "dunn" ][ "dcemp_cpd_EMP" ] 			= "dcemp_cpd_EMP";	
	//What the hell's goin' on?			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_whatsgoinon" ] 	= "dcemp_cpd_whatsgoinon";	
	//Seek shelter!!! Get off the street now!!!			
	level.scr_sound[ "foley" ][ "dcemp_fly_seekshelter" ] 	= "dcemp_fly_seekshelter";
	level.scr_face[ "foley" ][ "dcemp_fly_seekshelter" ] 	= %dcemp_fly_seekshelter;
		
	//This is not goood!			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_notgood" ] 		= "dcemp_cpd_notgood";	
	//Go go go!!!			
	level.scr_sound[ "foley" ][ "dcemp_fly_gogogo" ] 		= "dcemp_fly_gogogo";	
	//Don't stop!! Keep moving!!			
	level.scr_sound[ "foley" ][ "dcemp_fly_dontstop" ] 		= "dcemp_fly_dontstop";	
	//Whoa!!!			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_whoa" ] 			= "dcemp_cpd_whoa";
	//Holy shiiiiiit!!!			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_holy" ] 			= "dcemp_cpd_holy";
	//Go!! Go!!			
	level.scr_sound[ "foley" ][ "dcemp_fly_gogo" ] 			= "dcemp_fly_gogo";	
	//What the hell is goin' on!!!			
	level.scr_sound[ "marine1" ][ "dcemp_ar1_whatsgoinon" ] = "dcemp_ar1_whatsgoinon";	
	//Just keep moving!!			
	level.scr_sound[ "foley" ][ "dcemp_fly_justkeepmovin" ] = "dcemp_fly_justkeepmovin";	
	//Look out!!!			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_lookout" ] 		= "dcemp_cpd_lookout";

//CORNER	
	//What the hell are we gonna do now? We got no air support...we got no comms�we're screwed man! We are totally- fucked!			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_wearetotally" ] 	= "dcemp_cpd_wearetotally";
	//Shut up!! Get a grip Corporal! Our weapons still work, which means we can still kick some ass, huah?			
	level.scr_sound[ "foley" ][ "dcemp_fly_getagrip" ] 		= "dcemp_fly_getagrip";	
	level.scr_face[ "foley" ][ "dcemp_fly_getagrip" ]		= %dcemp_fly_getagrip;
	//Huah.		
	level.scr_sound[ "dunn" ][ "dcemp_cpd_huah" ] 			= "dcemp_cpd_huah";
	//Huah.			
	level.scr_sound[ "marine1" ][ "dcemp_ar1_huah" ] 		= "dcemp_ar1_huah";

//PLANE CRASH	
	//What the hell was that?!			
	level.scr_sound[ "marine1" ][ "dcemp_ar1_whatwasthat" ]	= "dcemp_ar1_whatwasthat";
	//Stay here.			
	level.scr_sound[ "foley" ][ "dcemp_fly_stayhere" ] 		= "dcemp_fly_stayhere";	
	level.scr_face[ "foley" ][ "dcemp_fly_stayhere" ]		= %dcemp_fly_stayhere;
	//You're goin' out there? Are you nuts?			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_younuts" ] 		= "dcemp_cpd_younuts";
	//It's over! Come on, we still have a war to fight.			
	level.scr_sound[ "foley" ][ "dcemp_fly_wartofight" ] 	= "dcemp_fly_wartofight";	
	
	//What happened here?			
	level.scr_sound[ "marine1" ][ "dcemp_ar1_thisisweird" ]	= "dcemp_ar1_thisisweird";
	//It�s so�quiet.			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_soquiet" ] 		= "dcemp_cpd_soquiet";
	//Hey! What the�? My red dot's not working.			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_heywhatthe" ] 	= "dcemp_cpd_heywhatthe";
	//Mine's down too, this is weird, bro.			
	level.scr_sound[ "marine1" ][ "dcemp_ar1_minedowntoo" ]	= "dcemp_ar1_minedowntoo";
	//Looks like optics are down�comms too.  There's not even a street light for blocks.
	level.scr_sound[ "foley" ][ "dcemp_fly_empblast" ] 		= "dcemp_fly_empblast";	
	
	level.scr_sound[ "marine1" ][ "dcemp_ar1_findironsite" ]= "dcemp_ar1_findironsite";	
	level.scr_sound[ "marine2" ][ "dcemp_ar1_huah" ] 		= "dcemp_ar1_huah";	
	
	
//BAR	
	//Whoa...check it out, man.			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_checkitout" ] 	= "dcemp_cpd_checkitout";
	//dammit		
	level.scr_sound[ "foley" ][ "dcemp_fly_dammit" ]		= "dcemp_fly_dammit";
	//Huah. We gotta regroup with whoever's left out there. Corporal Dunn, take point. 			
	level.scr_sound[ "foley" ][ "dcemp_fly_regroup" ]		= "dcemp_fly_regroup";
	level.scr_face[ "foley" ][ "dcemp_fly_regroup" ]		= %dcemp_fly_regroup;
	//Huah.			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_huah2" ] 			= "dcemp_cpd_huah2";

//MEETUP	
	//"Star"!			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_star" ] 			= "dcemp_cpd_star";
	//"Star", or we will fire on you!			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_willfire" ] 		= "dcemp_cpd_willfire";
	//I don't remember the damn countersign all right? I'm just a runner! Don't shoot!			
	level.scr_sound[ "runner" ][ "dcemp_ar3_dontshoot" ] 	= "dcemp_ar3_dontshoot";
	//The proper response is "Texas", soldier. What'dya got?			
	level.scr_sound[ "foley" ][ "dcemp_fly_properresponse" ]= "dcemp_fly_properresponse";
	//Colonel Marshall's assembling a task force at the Whiskey Hotel. You guys need to keep heading north.			
	level.scr_sound[ "runner" ][ "dcemp_ar3_whiskeyhotel" ]	= "dcemp_ar3_whiskeyhotel";
	//So where are you goin'?			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_wheregoin" ] 		= "dcemp_cpd_wheregoin";
	//To tell everyone else! Get to the Whiskey Hotel! Go!			
	level.scr_sound[ "runner" ][ "dcemp_ar3_everyoneelse" ]	= "dcemp_ar3_everyoneelse";

//LOBBY
	//You heard the man, lets go.		
	level.scr_sound[ "foley" ][ "dcemp_fly_heardtheman" ] 	= "dcemp_fly_heardtheman";
	//Dunn, you're up.		
	level.scr_sound[ "foley" ][ "dcemp_fly_dunnyoureup" ] 	= "dcemp_fly_dunnyoureup";
	//Clear.		
	level.scr_sound[ "dunn" ][ "dcemp_cpd_clear" ] 			= "dcemp_cpd_clear";
	//I got our six.		
	level.scr_sound[ "marine2" ][ "dcemp_ar2_gotoursix" ]	= "dcemp_ar2_gotoursix";
	//Copy that. 		
	level.scr_sound[ "foley" ][ "dcemp_fly_copythat" ] 		= "dcemp_fly_copythat";
	//Star!		
	level.scr_sound[ "marine3" ][ "dcemp_ar3_star" ]		= "dcemp_ar3_star";
	//Son of a....		
	level.scr_sound[ "dunn" ][ "dcemp_cpd_sonofa" ] 		= "dcemp_cpd_sonofa";
	//Contaaact!!!		
	level.scr_sound[ "foley" ][ "dcemp_fly_contact" ] 		= "dcemp_fly_contact";
	//Contaaact!!!		
	level.scr_sound[ "dunn" ][ "dcemp_cpd_conact" ] 		= "dcemp_cpd_conact";

//PARKING	
	//Huuah�		
	level.scr_sound[ "dunn" ][ "dcemp_cpd_huaah" ] 				= "dcemp_cpd_huaah";
	//Clear!		
	level.scr_sound[ "marine1" ][ "dcemp_ar2_clear" ] 			= "dcemp_ar2_clear";
	//Room clear! Let's go!		
	level.scr_sound[ "foley" ][ "dcemp_fly_roomclear" ] 		= "dcemp_fly_roomclear";	
	//There's the Eisenhower Building. Whiskey Hotel's on the other side.		
	level.scr_sound[ "foley" ][ "dcemp_fly_oldexecbuilding" ]	= "dcemp_fly_oldexecbuilding";	
	//Aw man, we gotta go out there�		
	level.scr_sound[ "dunn" ][ "dcemp_cpd_gottagoout" ] 		= "dcemp_cpd_gottagoout";	
	
	//Dunn. Check for vitals, we'll cover you.			
	level.scr_sound[ "foley" ][ "dcemp_fly_checkvitals" ]		= "dcemp_fly_checkvitals";	
	//He's a gonner.			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_gonner" ] 			= "dcemp_cpd_gonner";	
	//Keep Quiet�			
	level.scr_sound[ "foley" ][ "dcemp_fly_keepquiet" ]			= "dcemp_fly_keepquiet";	
	//Got a visual on three tangos.			
	level.scr_sound[ "marine1" ][ "dcemp_ar2_gotavisual" ]		= "dcemp_ar2_gotavisual";	
	//Stay low, move into position.			
	level.scr_sound[ "foley" ][ "dcemp_fly_moveintopos" ]		= "dcemp_fly_moveintopos";	
	//Clear shot.			
	level.scr_sound[ "marine1" ][ "dcemp_ar2_clearshot" ]		= "dcemp_ar2_clearshot";	
	//Smoke 'em.			
	level.scr_sound[ "foley" ][ "dcemp_fly_smokeem" ]			= "dcemp_fly_smokeem";	
	
//PLAZA	
	//Move up.			
	level.scr_sound[ "foley" ][ "dcemp_fly_moveup" ]			= "dcemp_fly_moveup";	
	//What about the guys inside?			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_whatabout" ]			= "dcemp_cpd_whatabout";	
	//What about 'em?			
	level.scr_sound[ "foley" ][ "dcemp_fly_whataboutem" ]		= "dcemp_fly_whataboutem";	
	//I got our six, go.			
	level.scr_sound[ "marine1" ][ "dcemp_ar2_gotoursixgo" ] 	= "dcemp_ar2_gotoursixgo";	
	//It's clear.			dcemp_cpd_itsclear
	level.scr_sound[ "dunn" ][ "dcemp_cpd_itsclear" ]			= "dcemp_cpd_itsclear";	

	//I don't know what's worse, man- dodging falling helicopters or freezing my ass out here in this monsoon.		
	level.scr_sound[ "dunn" ][ "dcemp_cpd_freezingmonsoon" ]	= "dcemp_cpd_freezingmonsoon";	
	//Huah.		
	level.scr_sound[ "marine1" ][ "dcemp_ar2_huah" ] 			= "dcemp_ar2_huah";	
	//Quiet - I think I see something.		
	level.scr_sound[ "foley" ][ "dcemp_fly_quietseesomething" ] = "dcemp_fly_quietseesomething";
	//Hold your fire.			
	level.scr_sound[ "foley" ][ "dcemp_fly_holdyourfire" ] 		= "dcemp_fly_holdyourfire";
	//Are they friendly			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_aretheyfriendly" ]		= "dcemp_cpd_aretheyfriendly";	
	//I don't know�Star!			
	level.scr_sound[ "foley" ][ "dcemp_fly_dontknowstar" ] 		= "dcemp_fly_dontknowstar";
	//Cover me.			
	level.scr_sound[ "foley" ][ "dcemp_fly_coverme" ] 			= "dcemp_fly_coverme";
	//Staaar!!!
	level.scr_sound[ "foley" ][ "dcemp_fly_staaar" ] 			= "dcemp_fly_staaar";
	//Say Texas, dammit�just say it.			
	level.scr_sound[ "dunn" ][ "dcemp_cpd_saytexas" ]			= "dcemp_cpd_saytexas";	
	//Street clear!			
	level.scr_sound[ "marine1" ][ "dcemp_ar2_streetclear" ] 	= "dcemp_ar2_streetclear";
	//Oscar mike. Lets go!			
	level.scr_sound[ "foley" ][ "dcemp_fly_oscarmike" ] 		= "dcemp_fly_oscarmike";
	//Watch for movement.		
	level.scr_sound[ "foley" ][ "dcemp_fly_watchmovement" ] 	= "dcemp_fly_watchmovement";
	
}

#using_animtree( "vehicles" );
mi28()
{
	level.scr_anim[ "emp_heli_spotlight" ][ "crash" ] 	= %DCemp_emp_heli_crash;	
	level.scr_anim[ "emp_heli_rappel" ][ "crash" ] 		= %cobra_crash;	
	level.scr_anim[ "emp_heli_distant" ][ "crash" ] 	= %cobra_crash;	
	level.scr_anim[ "emp_heli_last" ][ "crash" ] 		= %sniper_escape_crash_mi28_crash;	
	
	level.scr_anim[ "generic" ][ "cobra_crash" ] = %cobra_crash;
	level.scr_anim[ "street_car" ][ "crash" ] = %DCemp_car_hit;
	
	
	level.scr_anim[ "emp_mi28" ][ "crash" ]		 	= %DCemp_emp_heli_crash;
	level.scr_animtree[ "emp_mi28" ] 			 	= #animtree;
	level.scr_model[ "emp_mi28" ] 				 	= "vehicle_mi-28_flying_low";
	
	level.scr_anim[ "street_mi28a" ][ "crash" ]		= %DCemp_heli_crash_1;
	level.scr_animtree[ "street_mi28a" ] 			= #animtree;
	level.scr_model[ "street_mi28a" ] 				= "vehicle_mi-28_flying_low";
	
	level.scr_anim[ "street_mi28b" ][ "crash" ]		= %DCemp_heli_crash_2;
	level.scr_animtree[ "street_mi28b" ] 			= #animtree;
	level.scr_model[ "street_mi28b" ] 				= "vehicle_mi-28_flying_low";
	
	level.scr_anim[ "street_bh" ][ "crash" ]		= %DCemp_heli_crash_3;
	level.scr_animtree[ "street_bh" ] 				= #animtree;
	level.scr_model[ "street_bh" ] 					= "vehicle_blackhawk_low";
}

lobby_door_kick( guy )
{
	door = getent( "lobby_door_right", "targetname" );	
	parts = getentarray( door.target, "targetname" );
	array_call( parts, ::linkto, door );
	door connectpaths();
	
	flag_set( "lobby_door_kick" );
	
	time = .4;
	door rotateroll( -90, time );
	door playsound( "wood_door_kick" );
	
	door waittill( "rotatedone" );
	door Vibrate( (0,0,1), 1, 0.4, .5 );
}

lobby_flash_throw( guy )
{
	guy.old_grenadeweapon = guy.grenadeweapon;
	guy.grenadeweapon = "flash_grenade";
	guy.grenadeAmmo++;		
	
	ent = getstruct( "office_magic_bullet_target", "targetname" );
	vec = vectornormalize( ent.origin - guy gettagorigin( "TAG_INHAND" ) + (0,0,40) );
	vec = vector_multiply( vec, 800 );
	
	time = 1;
	
	guy magicgrenademanual( guy gettagorigin( "TAG_INHAND" ), vec, time );	
}

street_pickup_flare( guy )
{
	model = getent( "street_flare", "targetname" );
	newtag = spawn( "script_model", model.fxtag.origin );
	newtag.angles = model.fxtag.angles;
	newtag setmodel( model.fxtag.model );
	newtag linkto( model );
	model.fxtag delete();
	model.fxtag = newtag;
	model.fxtag linkto( model );
	
	playfxontag( level._effect[ "handflare" ], model.fxtag, "TAG_ORIGIN" );	
			
	model.origin = guy gettagorigin( "TAG_INHAND" );
	vec = anglestoup( guy gettagangles( "TAG_INHAND" ) );
	angles = vectortoangles( vec * -1 );
	model.angles = angles;
	model linkto( guy, "TAG_INHAND" );
}

street_throw_flare( guy )
{
	model = getent( "street_flare", "targetname" );
	model unlink();	
	
	//throw
	vec = anglestoforward(guy.angles);
	end = guy.origin + vector_multiply( vec, 50 );
	end = end + (0,0,18);
	vec = vectornormalize( end - guy.origin );
	mag = vector_multiply( vec, 704 );
	
	time = .85;
	model movegravity( mag, time );
	model rotatevelocity( (400,0,50), time );
	
	wait time;
	
	flag_set( "plaza_throw_react" );	
	//bounce
	old = model;
	model = spawn( "script_model", old.origin );
	model.angles = old.angles;
	model setmodel( old.model );
	model.fxtag = old.fxtag;
	model.targetname = "street_flare";
	old.fxtag linkto( model );
	old delete();
		
	time = .4;
	mag = vec * 415;
	model movegravity( mag, time );
	model rotatevelocity( (550,0,50), time );
	
	
	light = getent( "parking_throw_flare", "targetname" );
	light setlightcolor( ( 0.823529, 0.435294, 0.435294 ) );
	light delaythread( 0, maps\dcemp_code::lerp_lightintensity, 6, 1.2 );
	thread battlechatter_on( "axis" );
	
	wait time;
	
	//slide
	old = model;
	model = spawn( "script_model", old.origin );
	model.angles = old.angles;
	model setmodel( old.model );
	model.fxtag = old.fxtag;
	model.targetname = "street_flare";
	old.fxtag linkto( model );
	old delete();
			
	time = 1;	
	delta = vec * 95;
	origin = model.origin + ( delta[0], delta[1], 0 );
	
	model moveto( origin, time, 0, time );
	//model rotateto( ( 0,300,0 ), time, 0, time );
	
	model waittill( "movedone" );
			
	model = getent( "street_flare", "targetname" );
	newtag = spawn( "script_model", model.fxtag.origin );
	newtag.angles = model.fxtag.angles;
	newtag setmodel( model.fxtag.model );
	newtag linkto( model );
	model.fxtag delete();
	model.fxtag = newtag;
	model.fxtag linkto( model );
	
	playfxontag( level._effect[ "groundflare" ], model.fxtag, "TAG_ORIGIN" );	
}

dialogue_meetup_1( guy )
{	
	//Colonel Marshall's assembling a task force at the Whiskey Hotel. You guys need to keep heading north.	
	level.runner play_sound_on_entity( "dcemp_ar3_whiskeyhotel" );
	
	wait .5;
	flag_set( "meetup_runner_leave" );
}

dialogue_meetup_2( guy )
{
	//So where are you goin'?	
	level.dunn play_sound_on_entity( "dcemp_cpd_wheregoin" );
	//To tell everyone else! Get to the Whiskey Hotel! Go!		
	level.runner dialogue_queue( "dcemp_ar3_everyoneelse" );
	flag_set( "meetup_runner_sprint" );
	flag_set( "lobby_main" );
}

lookat_off( guy )
{
	guy setlookatentity();	
}

#using_animtree( "script_model" );
whitehouse_script_model()
{
	level.scr_animtree[ "rope" ]								= #animtree;
	level.scr_model[ "rope" ]									= "rappelrope100_ri";

	level.scr_anim[ "rope" ][ "rappel_stand_idle_1" ][ 0 ]		 = %launchfacility_a_rappel_idle_1_100ft_rope;
	level.scr_anim[ "rope" ][ "rappel_stand_idle_2" ][ 0 ]		 = %launchfacility_a_rappel_idle_2_100ft_rope;
	level.scr_anim[ "rope" ][ "rappel_stand_idle_3" ][ 0 ]		 = %launchfacility_a_rappel_idle_3_100ft_rope;
	level.scr_anim[ "rope" ][ "rappel_drop" ]					 = %launchfacility_a_rappel_1_100ft_rope;
}

tunnels_door()
{
	level.scr_animtree[ "tunnel_door" ]								= #animtree;
	level.scr_model[ "tunnel_door" ]								= "tag_origin";
	level.scr_anim[ "tunnel_door" ][ "DCemp_door_sequence" ]		= %DCemp_door_sequence_door;
}

emp_script_model()
{
	level.scr_animtree[ "plank1" ]								= #animtree;
	level.scr_model[ "plank1" ]									= "tag_origin";
	level.scr_anim[ "plank1" ][ "dcemp_BHrescue" ]				= %dcemp_BHrescue_plank_1;
	
	level.scr_animtree[ "plank2" ]								= #animtree;
	level.scr_model[ "plank2" ]									= "tag_origin";
	level.scr_anim[ "plank2" ][ "dcemp_BHrescue" ]				= %dcemp_BHrescue_plank_2;	
	
	level.scr_animtree[ "iss_satellite" ]						= #animtree;
	level.scr_model[ "iss_satellite" ]							= "tag_origin";
	level.scr_anim[ "iss_satellite" ][ "ISS_animation" ]		= %ISS_sat;	
}

#using_animtree( "player" );
player_animations()
{
	level.scr_animtree[ "flare_rig" ] 							 = #animtree;
	level.scr_model[ "flare_rig" ] 								 = "ch_viewhands_player_gk_ump9";
	level.scr_anim[ "flare_rig" ][ "flare" ]					 = %DCemp_player_flare_wave;
	addNotetrack_flag( "flare_rig", "fx", "flare_start_fx", "flare" );
	addNotetrack_flag( "flare_rig", "fx", "whitehouse_hammerdown_jets_safe", "flare" );
		
	level.scr_animtree[ "iss_rig" ] 							 = #animtree;
	level.scr_model[ "iss_rig" ] 								 = "viewhands_player_iss";
	level.scr_anim[ "iss_rig" ][ "ISS_animation" ]				 = %ISS_player_rotate;		
	level.scr_anim[ "iss_rig" ][ "ISS_float_away" ]				 = %ISS_player_float_away;	
}



#using_animtree( "door" );
whitehouse_door()
{
	level.scr_animtree[ "door" ]								= #animtree;
	level.scr_model[ "door" ]									= "com_door_01_handleleft2";
	level.scr_anim[ "door" ][ "shotgunbreach_door_immediate" ]	= %shotgunbreach_door_immediate;
}

