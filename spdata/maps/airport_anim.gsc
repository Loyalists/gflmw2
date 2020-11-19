#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;

main()
{
	generic_human();
	linebook();
	player();
	props();
}

#using_animtree( "generic_human" );
generic_human()
{	
	level.scr_anim[ "shotgun" ][ "stand_reload" ] = 	%shotgun_stand_reload_c;
	level.scr_anim[ "m4" ][ "stand_reload" ] = 			%exposed_reload;
	level.scr_anim[ "makarov" ][ "stand_reload" ] = 			%exposed_reload;
	level.scr_anim[ "saw" ][ "stand_reload" ] = 			%exposed_reload;
	
	
	level.scr_anim[ "generic" ][ "casual_killer_walk_wave" ] = 			%casual_killer_walk_wave;
		
	level.scr_anim[ "generic" ][ "casual_killer_walk_point" ] = 		%casual_killer_walk_point;
	level.scr_anim[ "generic" ][ "casual_killer_walk_stop" ] = 			%casual_killer_walk_stop;
	level.scr_anim[ "generic" ][ "casual_killer_walk_start" ] = 		%casual_killer_walk_start;
	level.scr_anim[ "generic" ][ "casual_killer_jog_stop" ] = 			%casual_killer_jog_stop;
	level.scr_anim[ "generic" ][ "casual_killer_jog_start" ] = 			%casual_killer_jog_start;	
	level.scr_anim[ "generic" ][ "casual_killer_stand_aim5" ][0] = 			%casual_killer_stand_aim5;	
	level.scr_anim[ "generic" ][ "casual_killer_flinch" ] = 			%casual_killer_flinch;	
	level.scr_anim[ "generic" ][ "casual_killer_weapon_swap" ] = 			%casual_killer_walk_F_weapon_swap;	
	
		
		
	// SIGNALS
	level.scr_anim[ "generic" ][ "stand_exposed_wave_move_out" ] = 			%stand_exposed_wave_move_out;
	level.scr_anim[ "generic" ][ "stand_exposed_wave_halt_v2" ] = 			%stand_exposed_wave_halt_v2;
	level.scr_anim[ "generic" ][ "CornerStndR_alert_signal_move_out" ] = 	%CornerStndR_alert_signal_move_out;
	level.scr_anim[ "generic" ][ "CornerStndR_alert_signal_stopstay_down" ] = 	%CornerStndR_alert_signal_stopstay_down;
	level.scr_anim[ "generic" ][ "CornerStndR_alert_signal_enemy_spotted" ] = 	%CornerStndR_alert_signal_enemy_spotted;
	
	// ELEVATOR SCENE
	level.scr_anim[ "shotgun" ][ "elevator_scene" ] 			= %airport_elevator_sequence_guy1;
	level.scr_anim[ "makarov" ][ "elevator_scene" ] 			= %airport_elevator_sequence_guy2;
	level.scr_anim[ "saw" ][ "elevator_scene" ] 				= %airport_elevator_sequence_guy3;
	level.scr_anim[ "m4" ][ "elevator_scene" ] 					= %airport_elevator_sequence_guy4;
	//addNotetrack_dialogue( "shotgun", "airport_at1_nosurv_ps", "elevator_scene", "airport_at1_nosurv" );
	//addNotetrack_dialogue( "makarov", "airport_mkv_noruss_ps", "elevator_scene", "airport_mkv_noruss" );
		
	level.scr_anim[ "generic" ][ "makarov_elevator_reload" ] = 		%stand_2_melee_1;
	level.scr_anim[ "generic" ][ "m4_elevator_reload" ] = 			%exposed_reloadb;
	level.scr_anim[ "generic" ][ "shotgun_elevator_reload" ] = 		%exposed_pain_face;
	level.scr_anim[ "generic" ][ "saw_elevator_reload" ] = 			%exposed_reload;
	
	level.scr_anim[ "generic" ][ "m4_elevator_idle" ][0] = 			%corner_standL_alert_idle;	
	level.scr_anim[ "generic" ][ "shotgun_elevator_idle" ][0] = 	%corner_standR_alert_idle;
	
	//LOBBY SCENE
	level.scr_anim[ "generic" ][ "civilian_texting_standing" ][0] 	= %civilian_texting_standing;
	level.scr_anim[ "generic" ][ "civilian_atm" ][0] 								= %civilian_atm;
	level.scr_anim[ "generic" ][ "civilian_stand_idle" ][0] 				= %civilian_stand_idle;	
	level.scr_anim[ "generic" ][ "unarmed_cowerstand_idle" ][0] 		= %unarmed_cowerstand_idle;	
	
	level.scr_anim[ "generic" ][ "airport_civ_in_line_6_A" ] 				= %airport_civ_in_line_6_A;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_6_A_reaction" ] 		= %airport_civ_in_line_6_A_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_6_B" ] 				= %airport_civ_in_line_6_B;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_6_B_reaction" ] 		= %airport_civ_in_line_6_B_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_6_C" ] 				= %airport_civ_in_line_6_C;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_6_C_reaction" ] 		= %airport_civ_in_line_6_C_reaction;
	
	level.scr_anim[ "generic" ][ "airport_civ_in_line_9_A" ] 				= %airport_civ_in_line_9_A;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_9_A_reaction" ] 		= %airport_civ_in_line_9_A_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_9_B" ] 				= %airport_civ_in_line_9_B;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_9_B_reaction" ] 		= %airport_civ_in_line_9_B_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_9_C" ] 				= %airport_civ_in_line_9_C;			
	level.scr_anim[ "generic" ][ "airport_civ_in_line_9_C_reaction" ] 		= %airport_civ_in_line_9_C_reaction;				
							
	level.scr_anim[ "generic" ][ "airport_civ_in_line_10_A" ] 			= %airport_civ_in_line_10_A;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_10_A_reaction" ] 	= %airport_civ_in_line_10_A_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_10_B" ] 			= %airport_civ_in_line_10_B;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_10_B_reaction" ] 	= %airport_civ_in_line_10_B_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_10_C" ] 			= %airport_civ_in_line_10_C;		
	level.scr_anim[ "generic" ][ "airport_civ_in_line_10_C_reaction" ] 	= %airport_civ_in_line_10_C_reaction;					
							
	level.scr_anim[ "generic" ][ "airport_civ_in_line_12_A" ] 			= %airport_civ_in_line_12_A;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_12_A_reaction" ] 	= %airport_civ_in_line_12_A_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_12_B" ] 			= %airport_civ_in_line_12_B;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_12_B_reaction" ] 	= %airport_civ_in_line_12_B_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_12_C" ] 			= %airport_civ_in_line_12_C;		
	level.scr_anim[ "generic" ][ "airport_civ_in_line_12_C_reaction" ] 	= %airport_civ_in_line_12_C_reaction;				
	
	level.scr_anim[ "generic" ][ "airport_civ_in_line_15_A" ] 			= %airport_civ_in_line_15_A;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_15_A_reaction" ] 	= %airport_civ_in_line_15_A_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_15_B" ] 			= %airport_civ_in_line_15_B;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_15_B_reaction" ] 	= %airport_civ_in_line_15_B_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_15_C" ] 			= %airport_civ_in_line_15_C;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_15_C_reaction" ] 	= %airport_civ_in_line_15_C_reaction;
	
	level.scr_anim[ "generic" ][ "airport_civ_in_line_13_A" ] 			= %airport_civ_in_line_13_A;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_13_A_reaction" ] 	= %airport_civ_in_line_13_A_reaction;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_13_C" ] 			= %airport_civ_in_line_13_C;	
	level.scr_anim[ "generic" ][ "airport_civ_in_line_13_C_reaction" ] 	= %airport_civ_in_line_13_C_reaction;
	
	level.scr_anim[ "generic" ][ "exposed_crouch_death_flip" ] 			= %exposed_crouch_death_flip;
	
	level.scr_anim[ "generic" ][ "stairs_up" ][0] 		= %traverse_stair_run_01;
	level.scr_anim[ "generic" ][ "stairs_up" ][1] 		= %run_react_stumble;
	level.scr_anim[ "generic" ][ "stairs_up_weights" ][0] 			= 3;
	level.scr_anim[ "generic" ][ "stairs_up_weights" ][1] 			= 1;
	
	//RIOTSHIELD BEHAVIOR
	level.scr_anim[ "generic" ][ "riotshield_run" ] 			= %riotshield_run_F;
	level.scr_anim[ "generic" ][ "riotshield_sprint" ] 			= %riotshield_sprint;
	
	//CASUAL KILLER
	level.scr_anim[ "generic" ][ "casual_killer_jog_A" ]	= %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "casual_killer_jog_B" ]	= %casual_killer_jog_B;
	
	level.scr_anim[ "generic" ][ "casual_killer_jog" ][0]	= %casual_killer_jog_B;
	level.scr_anim[ "generic" ][ "casual_killer_jog" ][1]	= %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "casual_killer_walk_F" ]	= %casual_killer_walk_F;
	level.scr_anim[ "generic" ][ "casual_killer_walk_R" ]	= %casual_killer_walk_R;
	level.scr_anim[ "generic" ][ "casual_killer_walk_L" ]	= %casual_killer_walk_L;
	
	//casual_killer_walk_shoot_F_aimdown
	//casual_killer_walk_shoot_L_aimdown
	//casual_killer_walk_shoot_R_aimdown
	
	//CASUAL DYNAMIC RUN SPEED	
	level.scr_anim[ "generic" ][ "DRS_sprint" ] 		= undefined;
	level.scr_anim[ "generic" ][ "DRS_sprint" ][0]		= %casual_killer_jog_B;
	level.scr_anim[ "generic" ][ "DRS_sprint" ][1]		= %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "DRS_run" ]			= undefined;
	level.scr_anim[ "generic" ][ "DRS_combat_jog" ]		= undefined;
	level.scr_anim[ "generic" ][ "DRS_run_2_stop" ]		= %patrol_bored_walk_2_bored;		// run_2_stand_F_6;
	level.scr_anim[ "generic" ][ "DRS_stop_idle" ][ 0 ]	= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "signal_go" ]			= undefined;
	
	//SECURITY GUARD DESK
	level.scr_anim[ "generic" ][ "airport_security_guard_2" ] 	= %airport_security_guard_2;
	addNotetrack_customFunction( "generic", "bodyshot", ::kill_guy, "airport_security_guard_2" );
	level.scr_anim[ "generic" ][ "airport_security_guard_3" ] 	= %airport_security_guard_3;
	addNotetrack_customFunction( "generic", "headshot", ::kill_guy, "airport_security_guard_3" );
	level.scr_anim[ "generic" ][ "airport_security_guard_4" ] 	= %airport_security_guard_4;
	addNotetrack_customFunction( "generic", "headshot", ::kill_guy, "airport_security_guard_4" );
	
	//DEAD BODIES
	level.scr_anim[ "generic" ][ "corner_standR_death_grenade_explode" ]= %corner_standR_death_grenade_explode;
	level.scr_anim[ "generic" ][ "dying_crawl_death_v3" ]				= %dying_crawl_death_v3;
	level.scr_anim[ "generic" ][ "run_death_facedown" ]					= %run_death_facedown;
	level.scr_anim[ "generic" ][ "dying_back_death_v2" ]				= %dying_back_death_v2;
	level.scr_anim[ "generic" ][ "coverstand_death_right" ]				= %coverstand_death_right;
	level.scr_anim[ "generic" ][ "covercrouch_death_3" ]				= %covercrouch_death_3;
	
	//BACK LOBBY							
	level.scr_anim[ "generic" ][ "civ_run_array" ][ 0 ] 		= %civilian_run_hunched_A;
	level.scr_anim[ "generic" ][ "civ_run_array" ][ 1 ]			= %civilian_run_hunched_C;
	level.scr_anim[ "generic" ][ "civ_run_array" ][ 2 ]			= %civilian_run_hunched_flinch;
	level.scr_anim[ "generic" ][ "civilian_run_hunched_flinch" ]		= %civilian_run_hunched_flinch;
						
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_idle" ][0]		= %unarmed_cowercrouch_idle;
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_idle_reach" ]		= %unarmed_cowercrouch_idle;
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_idle_duck" ][0]	= %unarmed_cowercrouch_idle_duck;
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_duck" ]			= %unarmed_cowercrouch_idle_duck;
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_react_A" ] 		= %unarmed_cowercrouch_react_A;
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_react_B" ] 		= %unarmed_cowercrouch_react_B;
	level.scr_anim[ "generic" ][ "unarmed_cowerstand_pointidle" ][0] 	= %unarmed_cowerstand_pointidle;
	
	level.scr_anim[ "generic" ][ "cliffhanger_capture_Price_idle" ][0] 				= %cliffhanger_capture_Price_idle;
	level.scr_anim[ "generic" ][ "cliffhanger_capture_Price_idle_reach" ] 			= %cliffhanger_capture_Price_idle;
	level.scr_anim[ "generic" ][ "exposed_squat_idle_grenade_F" ][0] 				= %exposed_squat_idle_grenade_F;
	level.scr_anim[ "generic" ][ "exposed_squat_idle_grenade_F_reach" ] 			= %exposed_squat_idle_grenade_F;
	level.scr_anim[ "generic" ][ "coup_civilians_interrogated_civilian_v1" ][0]		= %coup_civilians_interrogated_civilian_v1;
	level.scr_anim[ "generic" ][ "coup_civilians_interrogated_civilian_v1_reach" ]	= %coup_civilians_interrogated_civilian_v1;
	level.scr_anim[ "generic" ][ "coup_civilians_interrogated_civilian_v3" ][0]		= %coup_civilians_interrogated_civilian_v3;
	
	level.scr_anim[ "generic" ][ "run_pain_fallonknee" ]	= %run_pain_fallonknee;
	level.scr_anim[ "generic" ][ "breach_react_desk_v5" ]	= %breach_react_desk_v5;
	level.scr_anim[ "generic" ][ "breach_react_desk_v6" ]	= %breach_react_desk_v6;
	level.scr_anim[ "generic" ][ "crouch_2run_L" ]			= %crouch_2run_L;
	level.scr_anim[ "generic" ][ "stand_2_run_L" ]			= %stand_2_run_L;
	level.scr_anim[ "generic" ][ "stand_2_run_F_2" ]		= %stand_2_run_F_2;
	level.scr_anim[ "generic" ][ "slide_across_car" ]		= %slide_across_car;
	level.scr_anim[ "generic" ][ "slide_across_car_death" ]	= %slide_across_car_death;
	addNotetrack_customFunction( "generic", "traverse_death", ::slide_death, "slide_across_car" );
	
	level.scr_anim[ "generic" ][ "melee_f_awin_attack" ]	= %melee_f_awin_attack;
	level.scr_anim[ "generic" ][ "melee_f_awin_defend" ]	= %melee_f_awin_defend;
	addNotetrack_customFunction( "generic", "sync", :: allowdeath_off, "melee_f_awin_defend" );
//	addNotetrack_customFunction( "generic", "bodyfall large", :: allowdeath_on, "melee_f_awin_defend" );
	addNotetrack_customFunction( "generic", "bodyfall large", :: allowdeath_off_wait, "melee_f_awin_defend" );
	
	level.scr_anim[ "generic" ][ "cliffhanger_Price_intro_idle" ][0]	= %cliffhanger_Price_intro_idle;
	level.scr_anim[ "generic" ][ "crawl_death_front" ]	= %crawl_death_front;	
	
	//STAIRS
	level.scr_anim[ "generic" ][ "run_react_180" ]				= %run_reaction_180;
	level.scr_anim[ "generic" ][ "run_turn_180" ]				= %run_turn_180;
	level.scr_anim[ "generic" ][ "airport_civ_fear_drop_5" ]	= %airport_civ_fear_drop_5;
	level.scr_anim[ "generic" ][ "airport_civ_fear_drop_6" ]	= %airport_civ_fear_drop_6;
		
	level.scr_anim[ "generic" ][ "run_stumble0" ]		= %run_pain_fallonknee;
	level.scr_anim[ "generic" ][ "run_stumble1" ]		= %run_pain_fallonknee;
	level.scr_anim[ "generic" ][ "run_stumble2" ]		= %run_pain_fallonknee;
	
	level.scr_anim[ "generic" ][ "run_death0" ]		= %run_death_facedown;
	level.scr_anim[ "generic" ][ "run_death1" ]		= %run_death_roll;
	level.scr_anim[ "generic" ][ "run_death2" ]		= %airport_security_guard_3_reaction;
	level.scr_anim[ "generic" ][ "run_death3" ]		= %airport_security_guard_4_reaction;
	
	level.scr_anim[ "generic" ][ "unarmed_cowerstand_react" ]				= %unarmed_cowerstand_react;
	level.scr_anim[ "generic" ][ "unarmed_cowerstand_react_2_crouch" ]		= %unarmed_cowerstand_react_2_crouch;
	level.scr_anim[ "generic" ][ "airport_civ_cower_piller_idle" ][0]		= %airport_civ_cower_piller_idle;
	
	//UPPERDECK
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble" ]		 	= %DC_Burning_bunker_stumble;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_sit_idle" ][ 0 ]	= %DC_Burning_bunker_sit_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_react" ]		 	= %DC_Burning_bunker_react;
	
	level.scr_anim[ "generic" ][ "airport_civ_pillar_exit" ]		 		= %airport_civ_pillar_exit;
	level.scr_anim[ "generic" ][ "airport_civ_pillar_exit_death" ]			= %airport_civ_pillar_exit_death;
	level.scr_anim[ "generic" ][ "airport_civ_cellphone_hide" ]		 		= %airport_civ_cellphone_hide;
	level.scr_anim[ "generic" ][ "airport_civ_cellphone_death" ]			= %airport_civ_cellphone_death;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupA_kneel" ]			= %airport_civ_dying_groupA_kneel;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupA_kneel_death" ]	= %airport_civ_dying_groupA_kneel_death;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupA_lean" ]			= %airport_civ_dying_groupA_lean;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ]			= %airport_civ_dying_groupB_pull;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull_death" ]	= %airport_civ_dying_groupB_pull_death;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded" ]		= %airport_civ_dying_groupB_wounded;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded_death" ]	= %airport_civ_dying_groupB_wounded_death;
	level.scr_anim[ "generic" ][ "dying_crawl_back" ]		 				= %bleedout_crawlB;
	level.scr_anim[ "generic" ][ "bleedout_crawlB" ]		 				= %bleedout_crawlB;
	level.scr_anim[ "generic" ][ "dying_back_death_v1" ]		 			= %dying_back_death_v1;
	level.scr_anim[ "generic" ][ "civilian_leaning_death" ]					= %civilian_leaning_death;
	level.scr_anim[ "generic" ][ "civilian_leaning_death_shot" ]			= %civilian_leaning_death_shot;
	
	
	level.scr_anim[ "generic" ][ "civilian_crawl_1" ]		 			= %civilian_crawl_1;
	level.scr_anim[ "generic" ][ "civilian_crawl_2" ]		 			= %civilian_crawl_2;
	level.scr_anim[ "generic" ][ "dying_crawl" ]		 				= %dying_crawl;
			
	level.scr_anim[ "crawl_death_1" ][ "crawl" ]		 		= %civilian_crawl_1;
	level.scr_anim[ "crawl_death_1" ][ "death" ][0]		 		= %civilian_crawl_1_death_A;
	level.scr_anim[ "crawl_death_1" ][ "death" ][1]		 		= %civilian_crawl_1_death_B;
	level.scr_anim[ "crawl_death_1" ][ "blood_fx_rate" ]		= .5;
	level.scr_anim[ "crawl_death_1" ][ "blood_fx" ]				= "blood_drip";
	
	level.scr_anim[ "crawl_death_2" ][ "crawl" ]		 		= %civilian_crawl_2;
	level.scr_anim[ "crawl_death_2" ][ "death" ][0]				= %civilian_crawl_2_death_A;
	level.scr_anim[ "crawl_death_2" ][ "death" ][1]				= %civilian_crawl_2_death_B;  
	level.scr_anim[ "crawl_death_2" ][ "blood_fx_rate" ]		= .25;          
	
	
	//MASSACRE
	level.scr_anim[ "generic" ][ "corner_standR_alert_idle" ][0]= %corner_standR_alert_idle;
	level.scr_anim[ "generic" ][ "corner_standR_trans_IN_2" ]	= %corner_standR_trans_IN_2;
	level.scr_anim[ "generic" ][ "corner_standR_trans_IN_1" ]	= %corner_standR_trans_IN_1;
	
	level.scr_anim[ "generic" ][ "walk_left" ]					= %walk_left;
	level.scr_anim[ "generic" ][ "stand_2_run_L" ]				= %stand_2_run_L;
	level.scr_anim[ "generic" ][ "run_2_stand_F_6" ]			= %run_2_stand_F_6;
	level.scr_anim[ "generic" ][ "exposed_fast_grenade_F2" ]	= %exposed_fast_grenade_F2;
	
	addNotetrack_attach( "generic", "grenade_right", "projectile_m67fraggrenade", "TAG_INHAND", "exposed_fast_grenade_F2" );	
	addNotetrack_detach( "generic", "fire", "projectile_m67fraggrenade", "TAG_INHAND", "exposed_fast_grenade_F2" );	
	addNotetrack_customFunction( "generic", "fire", ::nadethrow_mak, "exposed_fast_grenade_F2" );	
	
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_react_L" ]	= %airport_security_guard_pillar_react_L;
	addNotetrack_customFunction( "generic", "fire", ::_ignoreme_off, "airport_security_guard_pillar_react_L" );
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_death_L" ]	= %airport_security_guard_pillar_death_L;
	
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_react_R" ]	= %airport_security_guard_pillar_react_R;
	addNotetrack_customFunction( "generic", "fire", ::_ignoreme_off, "airport_security_guard_pillar_react_R" );
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_death_R" ]	= %airport_security_guard_pillar_death_R;
	
	level.scr_anim[ "generic" ][ "airport_security_civ_rush_guard" ]	= %airport_security_civ_rush_guard;
	addNotetrack_customFunction( "generic", "shout", ::cop_shout, "airport_security_civ_rush_guard" );
	level.scr_anim[ "generic" ][ "airport_security_civ_rush_guard" ]	= %airport_security_civ_rush_guard;
	addNotetrack_customFunction( "generic", "fire", ::cop_killme, "airport_security_civ_rush_guard" );
	level.scr_anim[ "generic" ][ "airport_security_civ_rush_civA" ]		= %airport_security_civ_rush_civA;
	level.scr_anim[ "generic" ][ "airport_security_civ_rush_civB" ]		= %airport_security_civ_rush_civB;
	level.scr_anim[ "generic" ][ "airport_security_civ_rush_civC" ]		= %airport_security_civ_rush_civC;
	
	level.scr_anim[ "generic" ][ "corner_standL_rambo_jam" ]		= %corner_standL_rambo_jam;
	level.scr_anim[ "generic" ][ "corner_standL_rambo_set" ]		= %corner_standL_rambo_set;
	
	level.scr_anim[ "generic" ][ "death_shotgun_legs" ]		= %death_shotgun_legs;
	level.scr_anim[ "generic" ][ "exposed_death_falltoknees" ]		= %exposed_death_falltoknees;
	level.scr_anim[ "generic" ][ "exposed_death_falltoknees_02" ]	= %exposed_death_falltoknees_02;
	level.scr_anim[ "generic" ][ "exposed_death_blowback" ]	= %exposed_death_blowback;
	
	level.scr_anim[ "generic" ][ "covercrouch_blindfire_1" ]		= %covercrouch_blindfire_1;
	level.scr_anim[ "generic" ][ "covercrouch_blindfire_2" ]		= %covercrouch_blindfire_2;
	level.scr_anim[ "generic" ][ "covercrouch_hide_idle" ][0]		= %covercrouch_hide_idle;
		
	level.scr_anim[ "generic" ][ "walk_backward" ]				= %walk_backward;
	level.scr_anim[ "generic" ][ "exposed_backpedal" ]			= %exposed_backpedal;
	level.scr_anim[ "generic" ][ "react_stand_2_run_180" ]		= %react_stand_2_run_180;
	level.scr_anim[ "generic" ][ "exposed_crouch_2_stand" ]		= %exposed_crouch_2_stand;
	
	level.scr_anim[ "generic" ][ "death_explosion_stand_L_v3" ]		= %death_explosion_stand_L_v3;
	level.scr_anim[ "generic" ][ "death_explosion_stand_R_v1" ]		= %death_explosion_stand_R_v1;
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v1" ]		= %death_explosion_stand_B_v1;
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v3" ]		= %death_explosion_stand_B_v3;
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v4" ]		= %death_explosion_stand_B_v4;
	
	level.scr_anim[ "generic" ][ "death_explosion_run_R_v1" ]		= %death_explosion_run_R_v1;
	level.scr_anim[ "generic" ][ "death_explosion_run_R_v2" ]		= %death_explosion_run_R_v2;
	level.scr_anim[ "generic" ][ "death_explosion_run_L_v1" ]		= %death_explosion_run_L_v1;
	level.scr_anim[ "generic" ][ "death_explosion_run_L_v2" ]		= %death_explosion_run_L_v2;
	level.scr_anim[ "generic" ][ "death_explosion_run_B_v1" ]		= %death_explosion_run_B_v1;
	level.scr_anim[ "generic" ][ "death_explosion_run_B_v2" ]		= %death_explosion_run_B_v2;	
	level.scr_anim[ "generic" ][ "death_explosion_run_F_v1" ]		= %death_explosion_run_F_v1;	
	level.scr_anim[ "generic" ][ "death_explosion_run_F_v2" ]		= %death_explosion_run_F_v2;	
				
	level.scr_anim[ "generic" ][ "corner_standL_alert_idle_reach" ]	= %corner_standL_alert_idle;
	level.scr_anim[ "generic" ][ "corner_standL_alert_idle" ][0]	= %corner_standL_alert_idle;
	level.scr_anim[ "generic" ][ "corner_standR_alert_idle" ][0]	= %corner_standR_alert_idle;
	
	level.scr_anim[ "generic" ][ "exposed_grenadeThrowB" ]		= %exposed_grenadeThrowB;
	addNotetrack_attach( "generic", "grenade_right", "projectile_m67fraggrenade", "TAG_INHAND", "exposed_grenadeThrowB" );	
	addNotetrack_detach( "generic", "grenade_throw", "projectile_m67fraggrenade", "TAG_INHAND", "exposed_grenadeThrowB" );	
	addNotetrack_customFunction( "generic", "grenade_throw", ::nadethrow_elev, "exposed_grenadeThrowB" );	
	
	level.scr_anim[ "generic" ][ "corner_standL_explosion_B" ]		= %corner_standL_explosion_B;
	level.scr_anim[ "generic" ][ "corner_standR_trans_OUT_6" ]		= %corner_standR_trans_OUT_6;
	level.scr_anim[ "generic" ][ "run_turn_R90" ]					= %run_turn_R90;
	
	level.scr_anim[ "generic" ][ "CornerCrL_alert_idle" ][0]	= %CornerCrL_alert_idle;
	level.scr_anim[ "generic" ][ "CornerCrL_look_fast" ]		= %CornerCrL_look_fast;
	level.scr_anim[ "generic" ][ "CornerCrR_alert_idle" ][0]	= %CornerCrR_alert_idle;
	level.scr_anim[ "generic" ][ "CornerCrR_alert_first_frame" ]= %CornerCrR_alert_idle;
	
	//GATE
	level.scr_anim[ "generic" ][ "civilian_run_hunched_turnR90_slide" ]= %civilian_run_hunched_turnR90_slide;
	level.scr_anim[ "generic" ][ "airport_civilian_run_turnR_90" ]= %airport_civilian_run_turnR_90;
	level.scr_anim[ "generic" ][ "civilian_run_hunched_A" ]= %civilian_run_hunched_A;
	level.scr_anim[ "generic" ][ "civilian_run_hunched_C" ]= %civilian_run_hunched_C;
	
			
	//BASEMENT
	level.scr_anim[ "generic" ][ "doorkick_basement" ]		= %doorkick_2_cqbwalk;
	addNotetrack_customFunction( "generic", "kick", ::doorkick_basement, "doorkick_basement" );
	
	level.scr_anim[ "generic" ][ "hunted_open_barndoor_flathand" ]		= %hunted_open_barndoor_flathand;
	
	level.scr_anim[ "generic" ][ "doorkick_escape" ]		= %doorkick_2_cqbwalk;
	addNotetrack_customFunction( "generic", "kick", ::doorkick_escape, "doorkick_escape" );	
	level.scr_anim[ "generic" ][ "bog_a_start_briefing" ]		= %bog_a_start_briefing;
	level.scr_anim[ "generic" ][ "bog_b_guard_react" ]			= %bog_b_guard_react;
							
	//TARMAC
	
	level.scr_anim[ "generic" ][ "pistol_sprint" ]		 		= %pistol_sprint;
	level.scr_anim[ "generic" ][ "pistol_walk_left" ]		 	= %pistol_walk_left;
	level.scr_anim[ "generic" ][ "pistol_walk_right" ]		 	= %pistol_walk_right;
	level.scr_anim[ "generic" ][ "pistol_walk" ]		 		= %pistol_walk;
	level.scr_anim[ "generic" ][ "pistol_walk_back" ]		 	= %pistol_walk_back;
	
	
	level.scr_anim[ "generic" ][ "sprint_loop_distant" ]		 		= %sprint_loop_distant;
	level.scr_anim[ "generic" ][ "coverstand_grenadeA" ]		 		= %coverstand_grenadeA;
	addNotetrack_customFunction( "generic", "grenade_throw", :: nadethrow, "coverstand_grenadeA" );	
	level.scr_anim[ "generic" ][ "coverstand_grenadeB" ]		 		= %coverstand_grenadeB;
	addNotetrack_customFunction( "generic", "grenade_throw", :: nadethrow, "coverstand_grenadeB" );
	
	level.scr_anim[ "generic" ][ "pistol_stand_pullout" ]		 		= %pistol_stand_pullout;
	level.scr_anim[ "generic" ][ "pistol_stand_aim_5" ][0]		 		= %pistol_stand_aim_5;
	level.scr_anim[ "generic" ][ "pistol_crouchaimstraight2stand" ]		= %pistol_crouchaimstraight2stand;
	
	level.scr_anim[ "generic" ][ "riotshield_idle" ][0]		 			= %riotshield_idle;	
	level.scr_anim[ "generic" ][ "traverse_jumpdown_40" ]	 			= %traverse_jumpdown_40;
	level.scr_anim[ "generic" ][ "bm21_driver_idle" ][0] 				= %bm21_driver_idle;
	level.scr_anim[ "generic" ][ "bm21_driver_climbout" ]	 			= %bm21_driver_climbout;
	
	level.scr_anim[ "generic" ][ "exposed_crouch_2_stand" ]	 			= %exposed_crouch_2_stand;
	level.scr_anim[ "generic" ][ "casual_stand_idle_trans_in" ]	 		= %casual_stand_idle_trans_in;
	level.scr_anim[ "generic" ][ "casual_stand_idle" ][0]	 			= %casual_stand_idle;
	level.scr_anim[ "generic" ][ "casual_stand_idle" ][1]	 			= %casual_stand_idle_twitch;
	level.scr_anim[ "generic" ][ "casual_stand_idle" ][2]	 			= %casual_stand_idle_twitchB;
	
	level.scr_anim[ "generic" ][ "traverse_stepup_52" ]	 				= %traverse_stepup_52;
	
	//ENDING
	level.scr_anim[ "generic" ][ "patrol_bored_walk_2_bored" ]	 		= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_bored_2_walk" ]	 			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_bored_idle" ][0] 				= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_bored_patrolwalk" ]	 		= %patrol_bored_patrolwalk;
	
	level.scr_anim[ "van_mate" ][ "end_ride_in" ][0]	 			= %airport_ending_start_soldierB;
	level.scr_anim[ "comrad" ][ "end_get_in" ]	 				= %airport_ending_climbin_soldierA;
	level.scr_anim[ "van_mate" ][ "end_get_in" ]	 			= %airport_ending_climbin_soldierB;
	//addNotetrack_dialogue( "van_mate", "dialog", "end_get_in", "airport_vt_madeit" );
	addNotetrack_flag( "van_mate" , "dialog" , "end_get_in_the_van" , "end_get_in" );
	level.scr_anim[ "makarov" ][ "end_get_in" ]	 				= %airport_ending_climbin_makarov;
	addNotetrack_customFunction( "makarov", "lookat on", ::lookat_on, "end_get_in" );
	addNotetrack_customFunction( "makarov", "lookat off", ::lookat_off, "end_get_in" );

	addNotetrack_customFunction( "makarov", "gun_2_chest", ::gun_off, "end_get_in" );
	addNotetrack_sound( "makarov" , "player_ready" , "end_get_in" , "scn_airport_weapon_toss" );
	
	addNotetrack_flag( "makarov" , "player_ready" , "end_player_ready" , "end_get_in" );
	addNotetrack_flag( "makarov" , "start_player" , "end_makarov_in_place" , "end_get_in" );
	addNotetrack_dialogue( "makarov", "dialog", "end_get_in", "airport_mkv_nomessage" );
	addNotetrack_customFunction( "makarov", "fire", ::change_team, "end_get_in" );	
	addNotetrack_customFunction( "makarov", "fire", maps\airport::escape_kill_player, "end_get_in" );
	addNotetrack_customFunction( "makarov", "fire", ::gun_fx, "end_get_in" );
	
	
	addNotetrack_customFunction( "makarov", "aim", ::makarov_aim_player, "end_alt" );	
	addNotetrack_customFunction( "makarov", "fire", ::change_team, "end_alt" );	
	addNotetrack_customFunction( "makarov", "fire", maps\airport::escape_kill_player, "end_alt" );
	addNotetrack_customFunction( "makarov", "fire", ::gun_fx, "end_alt" );	
	
	level.scr_anim[ "comrad" ][ "end_get_in_idle" ][0]	 			= %airport_ending_idle_soldierA;
	level.scr_anim[ "van_mate" ][ "end_get_in_idle" ][0]	 		= %airport_ending_idle_soldierB;
	level.scr_anim[ "makarov" ][ "end_get_in_idle" ][0]	 			= %airport_ending_wave_makarov;
	

	level.scr_anim[ "makarov" ][ "end_player_shot" ]	 			= %airport_ending_mid_makarov;
	addNotetrack_attach( "makarov", "pistol_pickup", getWeaponModel( "beretta" ), "TAG_INHAND", "end_player_shot" );	
		
	
	
	
	
	
	level.scr_anim[ "van_mate" ][ "end_player_shot" ]	 			= %airport_ending_mid_soldierB;
	//addNotetrack_dialogue( "van_mate", "dialog", "end_player_shot", "airport_vt_beenough" );
	level.scr_anim[ "makarov" ][ "end_drive_away" ]	 				= %airport_ending_end_makarov;
	addNotetrack_customFunction( "makarov", "lookat off", ::lookat_off, "end_drive_away" );	
	
	
	
	level.scr_anim[ "generic" ][ "van_end_ride_in" ][0]	 			= %airport_ending_start_soldierB;
	level.scr_anim[ "generic" ][ "com_end_get_in" ]	 				= %airport_ending_climbin_soldierA;
	level.scr_anim[ "generic" ][ "van_end_get_in" ]	 			= %airport_ending_climbin_soldierB;
	level.scr_anim[ "generic" ][ "mak_end_get_in" ]	 				= %airport_ending_climbin_makarov;
	level.scr_anim[ "generic" ][ "com_end_get_in_idle" ][0]	 			= %airport_ending_idle_soldierA;
	level.scr_anim[ "generic" ][ "van_end_get_in_idle" ][0]	 		= %airport_ending_idle_soldierB;
	level.scr_anim[ "generic" ][ "mak_end_get_in_idle" ][0]	 			= %airport_ending_wave_makarov;
	level.scr_anim[ "generic" ][ "mak_end_player_shot" ]	 			= %airport_ending_mid_makarov;
	addnotetrack_flag( "generic", "lookat off", "escape_mak_grab_hand", "mak_end_player_shot" );
	level.scr_anim[ "generic" ][ "van_end_player_shot" ]	 			= %airport_ending_mid_soldierB;
	level.scr_anim[ "generic" ][ "mak_end_drive_away" ]	 				= %airport_ending_end_makarov;	
	
	level.scr_anim[ "generic" ][ "patrol_jog_orders_once" ]	 			= %patrol_jog_orders_once;
	level.scr_anim[ "generic" ][ "patrol_boredjog_find" ]	 			= %patrol_boredjog_find;
	level.scr_anim[ "generic" ][ "patrol_boredrun_find" ]	 			= %patrol_boredrun_find;
	level.scr_anim[ "generic" ][ "patrol_jog_look_up_once" ]	 		= %patrol_jog_look_up_once;
	level.scr_anim[ "generic" ][ "patrol_jog_360_once" ]	 			= %patrol_jog_360_once;
	level.scr_anim[ "generic" ][ "patrol_jog" ]	 						= %patrol_jog;
	
	level.scr_anim[ "generic" ][ "afgan_chase_ending_search_spin" ]	 	= %afgan_chase_ending_search_spin;
	level.scr_anim[ "generic" ][ "pistol_stand_pullout" ]	 			= %pistol_stand_pullout;
	level.scr_anim[ "generic" ][ "pistol_stand_switch" ]	 			= %pistol_stand_switch;	
}

#using_animtree( "player" );
player()
{
	level.scr_anim[ "player_ending" ][ "end_player_shot" ]				 = %airport_ending_mid_player;
	level.scr_anim[ "player_ending" ][ "end_player_shot_alt" ]			 = %airport_ending_alt_player;
	level.scr_animtree[ "player_ending" ] 								 = #animtree;
	level.scr_model[ "player_ending" ] 									 = "ch_viewhands_player_gk_ump45";
}

#using_animtree( "animated_props" );
props()
{
	level.scr_anim[ "ending_weap" ][ "end_get_in" ]				 = %airport_ending_climbin_makarov_weapon;
	level.scr_animtree[ "ending_weap" ] 						 = #animtree;
	level.scr_model[ "ending_weap" ] 							 = "weapon_m4";	
}

#using_animtree( "generic_human" );
linebook()
{
	//Leave no survivors comrades -	
	level.scr_sound[ "makarov" ][ "airport_mkv_snamibog" ] 		= "airport_mkv_snamibog";	
	//Remember - no Russian.
	level.scr_sound[ "makarov" ][ "airport_mkv_noruss" ]		= "airport_mkv_noruss";
	//30 seconds. Go.
	level.scr_radio[ "airport_mkv_30secs" ]		= "airport_mkv_30secs";
	//go
	level.scr_radio[ "airport_mkv_go" ]			= "airport_mkv_go";
	//Up the stairs. Go.			
	level.scr_radio[ "airport_mkv_upstairs" ]					= "airport_mkv_upstairs";
	
	//AUTOKILL DIALOGUE
	//You're cleared to engage, my friend. 		
	level.scr_radio[ "airport_mkv_clearedeng" ]			= "airport_mkv_clearedeng";
	//Team, engage all civilian targets. Leave no survivors.	
	level.scr_radio[ "airport_mkv_nosurvivors" ]			= "airport_mkv_nosurvivors";
	//Stick to the plan. Maximum casualties, no exceptions.	
	level.scr_radio[ "airport_mkv_noexceptions" ]			= "airport_mkv_noexceptions";
	
	//Let's go, move up!	
	level.scr_radio[ "airport_mkv_letsmoveup" ]			= "airport_mkv_letsmoveup";
	//Let's go!	
	level.scr_radio[ "airport_mkv_letsgo2" ]				= "airport_mkv_letsgo2";
	//Keep moving!	
	level.scr_radio[ "airport_mkv_keepmoving" ]			= "airport_mkv_keepmoving";
	
	//Shoot them all. These sheep are hardly Russians. Consider this a final test of your loyalty to me.	
	level.scr_radio[ "airport_mkv_thesesheep" ]			= "airport_mkv_thesesheep";
	//You've served me well this far. Don't give me a reason to doubt you. 	
	level.scr_radio[ "airport_mkv_doubtyou" ]				= "airport_mkv_doubtyou";
	//Open fire that's an order.	
	level.scr_radio[ "airport_mkv_openfire" ]				= "airport_mkv_openfire";
	
	//Nice. Zakhaev would be proud.	
	level.scr_radio[ "airport_mkv_nice" ]					= "airport_mkv_nice";
	//Well done. I knew you wouldn't let me down.	
	level.scr_radio[ "airport_mkv_welldone" ]				= "airport_mkv_welldone";
	
	//You traitor.	
	level.scr_radio[ "airport_mkv_youtraitor" ]			= "airport_mkv_youtraitor";
	//I have no patience for cowards.	
	level.scr_radio[ "airport_mkv_cowards" ]				= "airport_mkv_cowards";
	//Check your fire!	
	level.scr_radio[ "airport_mkv_checkfire" ]				= "airport_mkv_checkfire";
		
	
	//UPPERDECK
	//Get down!! Get down!!!!
	level.scr_sound[ "male_civ_1" ][ "stairs_line" ]		= "airport_rmc2_getdown";
	//They have guns!!! Run!!!
	level.scr_sound[ "male_civ_2" ][ "stairs_line" ]		= "airport_rmc2_theyhaveguns";
	//Dima!! Take your sister and hide!! Go!!!
	level.scr_sound[ "male_civ_3" ][ "stairs_line" ]		= "airport_rmc1_takeyoursister";
	//Don't wait for me! Just run as far as you can!!!!
	level.scr_sound[ "male_civ_4" ][ "stairs_line" ]		= "airport_rmc2_dontwait";
	//Run away!!! Run away!!!!
	level.scr_sound[ "male_civ_5" ][ "stairs_line" ]		= "airport_rmc1_runaway";
	//Get out of here!!! Go! Go!!!
	level.scr_sound[ "male_civ_6" ][ "stairs_line" ]		= "airport_rmc2_getoutofhere";
	//Hurry up!!! They're getting closer!!!
	level.scr_sound[ "female_civ_1" ][ "stairs_line" ]		= "airport_rfc1_hurryup";
	//Take the stairs!!!
	level.scr_sound[ "female_civ_2" ][ "stairs_line" ]		= "airport_rfc2_takethestairs";
	//scream
	level.scr_sound[ "male_civ_1" ][ "scream1" ]		= "airport_rmc1_scream1";
	level.scr_sound[ "male_civ_1" ][ "scream2" ]		= "airport_rmc1_scream2";
	level.scr_sound[ "male_civ_1" ][ "scream3" ]		= "airport_rmc1_scream3";
	level.scr_sound[ "male_civ_1" ][ "scream4" ]		= "airport_rmc1_scream4";
	
	level.scr_sound[ "male_civ_2" ][ "scream1" ]		= "airport_rmc2_scream1";
	level.scr_sound[ "male_civ_2" ][ "scream2" ]		= "airport_rmc2_scream2";
	level.scr_sound[ "male_civ_2" ][ "scream3" ]		= "airport_rmc2_scream3";
	level.scr_sound[ "male_civ_2" ][ "scream4" ]		= "airport_rmc2_scream4";
	
	level.scr_sound[ "female_civ_1" ][ "scream1" ]		= "airport_rfc1_scream1";
	level.scr_sound[ "female_civ_1" ][ "scream2" ]		= "airport_rfc1_scream2";
	level.scr_sound[ "female_civ_1" ][ "scream3" ]		= "airport_rfc1_scream3";
	level.scr_sound[ "female_civ_1" ][ "scream4" ]		= "airport_rfc1_scream4";
	
	level.scr_sound[ "female_civ_2" ][ "scream1" ]		= "airport_rfc2_scream1";
	level.scr_sound[ "female_civ_2" ][ "scream2" ]		= "airport_rfc2_scream2";
	level.scr_sound[ "female_civ_2" ][ "scream3" ]		= "airport_rfc2_scream3";
	level.scr_sound[ "female_civ_2" ][ "scream4" ]		= "airport_rfc2_scream4";
	
	//Aaaaaa, my leg, my leg!!! Somebody help me!!!!
	level.scr_sound[ "generic" ][ "airport_rmc2_myleg" ]	= "airport_rmc2_myleg";
	level.scr_sound[ "generic" ][ "airport_rmc2_scream2" ]	= "airport_rmc2_scream2";
	level.scr_sound[ "generic" ][ "airport_rmc1_mykatia" ]	= "airport_rmc1_mykatia";
	level.scr_sound[ "generic" ][ "airport_rmc1_runaway" ]	= "airport_rmc1_runaway";
	level.scr_sound[ "generic" ][ "airport_rmc1_scream2" ]	= "airport_rmc1_scream2";
	level.scr_sound[ "generic" ][ "airport_rmc2_scream3" ]	= "airport_rmc2_scream3";
	
	level.scr_sound[ "makarov" ][ "airport_mkv_takebookstore" ] 	= "airport_mkv_takebookstore";
		
	//MASSACRE
	level.scr_sound[ "generic" ][ "airport_rac_freeze" ]	= "airport_rac_freeze";
	level.scr_sound[ "generic" ][ "airport_rac_movemove" ]	= "airport_rac_movemove";
	level.scr_sound[ "generic" ][ "airport_rac_handsup" ]	= "airport_rac_handsup";
	
	//Take care of it!	
	level.scr_radio[ "airport_mkv_careofit" ]		= "airport_mkv_careofit";
	//Movement at the elevators!	
	level.scr_radio[ "airport_mkv_elevators" ]		= "airport_mkv_elevators";
	//Fire in the hole!	
	level.scr_radio[ "airport_mkv_fireinhole" ]		= "airport_mkv_fireinhole";
	//I got a runner!	
	level.scr_radio[ "airport_mkv_runner" ]			= "airport_mkv_runner";
	//Frag out!	
	level.scr_radio[ "airport_mkv_fragout" ]		= "airport_mkv_fragout";
	//Security detail up ahead!	
	level.scr_radio[ "airport_at1_security" ]		= "airport_at1_security";
	//Frag out!	
	level.scr_radio[ "airport_at1_fragout" ]		= "airport_at1_fragout";
	
	level.scr_sound[ "makarov" ][ "airport_mkv_forzakhaev" ] 	= "airport_mkv_forzakhaev";
	
	level.scr_sound[ "makarov" ][ "airport_mkv_ontime" ] 		= "airport_mkv_ontime";
	level.scr_sound[ "makarov" ][ "airport_mkv_rightontime" ] 		= "airport_mkv_rightontime";
	level.scr_sound[ "makarov" ][ "airport_mkv_checkammo" ] 	= "airport_mkv_checkammo";
	
	level.scr_sound[ "m4" ][ "airport_vkt_beenwaiting" ] 		= "airport_vkt_beenwaiting";
	level.scr_sound[ "m4" ][ "airport_vkt_beenwaiting2" ] 		= "airport_vkt_beenwaiting2";
	
	level.scr_sound[ "makarov" ][ "airport_mkv_haventweall" ] 	= "airport_mkv_haventweall";
	level.scr_sound[ "makarov" ][ "airport_mkv_haventweall2" ] 	= "airport_mkv_haventweall2";
	





			
	//TARMAC
	//Go! Go! Go!
	level.scr_sound[ "makarov" ][ "airport_mkv_gogogo" ]	= "airport_mkv_gogogo";
	//Movement - 2nd floor windows. 			
	level.scr_radio[ "airport_mkv_2ndfloor" ]		= "airport_mkv_2ndfloor";
	//I see 'em.			
	level.scr_radio[ "airport_at1_isee" ]			= "airport_at1_isee";
	//F.S.B. - Take 'em out.		
	level.scr_radio[ "airport_mkv_fsb" ]			= "airport_mkv_fsb";
		
	//We got more F.S.B.		
	level.scr_radio[ "airport_at1_gotmorefsb" ]		= "airport_at1_gotmorefsb";
	//Take care of it.		
	level.scr_radio[ "airport_mkv_takecare" ]		= "airport_mkv_takecare";
	//Roger.		
	level.scr_radio[ "airport_at1_roger" ]				= "airport_at1_roger";

	
	//F.S.B. F.S.B!!!		
	level.scr_sound[ "generic" ][ "airport_fsb1_fsbfsb" ]		= "airport_fsb1_fsbfsb";
	//Move in! Go go go!!		
	level.scr_sound[ "generic" ][ "airport_fsb1_moveingo" ]		= "airport_fsb1_moveingo";
	//F.S.B.!!!! 		
	level.scr_sound[ "generic" ][ "airport_fsb2_fsb" ]			= "airport_fsb2_fsb";
	//They're wearing heavy body armor, aim for the head!!
	level.scr_sound[ "generic" ][ "airport_fsb2_aimforhead" ]	= "airport_fsb2_aimforhead";
	//F.S.B., F.S.B.!!!
	level.scr_sound[ "generic" ][ "airport_fsb2_fsbfsb" ]		= "airport_fsb2_fsbfsb";
	//Open fire!!!		
	level.scr_sound[ "generic" ][ "airport_fsb3_openfire" ]		= "airport_fsb3_openfire";
	//They're wearing too much body armor! Aim for their heads!!!		
	level.scr_sound[ "generic" ][ "airport_fsb3_aimforheads" ]	= "airport_fsb3_aimforheads";
	
	//RADIO VOICE
	//Team Six, we're sending the armored truck to Terminal Two, Gate Seventeen. 		
	level.scr_sound[ "generic" ][ "airport_fsbr_sendingtruck" ]		= "airport_fsbr_sendingtruck";
	level.scr_sound[ "generic" ][ "airport_fsbr_servicetunnels" ]	= "airport_fsbr_servicetunnels";
	
	
	//BCS
	//Man down!			
	level.scr_sound[ "m4" ][ "man_down" ] 				= "airport_vkt_mandown";
	//He's dead! Leave him! Go! Go!			
	level.scr_sound[ "makarov" ][ "man_down" ] 				= "airport_mkv_hesdead";
	
	//Check your fire!			
	level.scr_sound[ "makarov" ][ "check_fire1" ] 			= "airport_mkv_checkyourfire";
	//Watch your fire!			
	level.scr_sound[ "makarov" ][ "check_fire2" ] 			= "airport_mkv_watchyourfire";
	//Check your fire!			
	level.scr_sound[ "m4" ][ "check_fire1" ] 			= "airport_vkt_checkfire";
	//Watch your fire!			
	level.scr_sound[ "m4" ][ "check_fire2" ] 			= "airport_vkt_watchfire";
	
	//Grenade!			
	level.scr_sound[ "makarov" ][ "grenade1" ] 				= "airport_mkv_grenade";
	//Grenade!			
	level.scr_sound[ "m4" ][ "grenade1" ] 				= "airport_vkt_grenade";
	//Incoming!			
	level.scr_sound[ "makarov" ][ "grenade2" ] 				= "airport_mkv_incoming";
	//Look out!			
	level.scr_sound[ "m4" ][ "grenade2" ] 				= "airport_vkt_lookout";
	
	//Stay clear of the jet engine!			
	level.scr_sound[ "makarov" ][ "engine_warn" ] 			= "airport_mkv_clearofjetengine";
	//Move! That jet engine's gonna blow!			
	level.scr_sound[ "m4" ][ "engine_warn" ] 			= "airport_vkt_gonnablow";
	
	
	//Ready!			
	level.scr_sound[ "m4" ][ "ready1" ] 			= "airport_vkt_ready";
	//Ready!!			
	level.scr_sound[ "m4" ][ "ready2" ] 			= "airport_vkt_ready2";
	//Ready!					
	level.scr_sound[ "makarov" ][ "ready1" ] 			= "airport_mkv_ready1";
	//Ready!!	
	level.scr_sound[ "makarov" ][ "ready2" ] 			= "airport_mkv_ready2";
	
	//Go!			
	level.scr_sound[ "m4" ][ "go1" ] 				= "airport_vkt_go";
	//Move!			
	level.scr_sound[ "m4" ][ "go2" ] 				= "airport_vkt_move";
	//Go go go!!			
	level.scr_sound[ "m4" ][ "go3" ] 				= "airport_vkt_gogogo";
	
	//Go! Go!			
	level.scr_sound[ "makarov" ][ "go1" ] 				= "airport_mkv_gogo";
	//Go!!			
	level.scr_sound[ "makarov" ][ "go2" ] 				= "airport_mkv_go1";
	//Move!			
	level.scr_sound[ "makarov" ][ "go3" ] 				= "airport_mkv_move";
	//Go!			
	level.scr_sound[ "makarov" ][ "go4" ] 				= "airport_mkv_go2";
		
	//Moving!!			
	level.scr_sound[ "m4" ][ "moving1" ] 				= "airport_vkt_moving";
	//Moving! Cover me!			
	level.scr_sound[ "m4" ][ "moving2" ] 				= "airport_vkt_movingcover";
	//Moving up!!			
	level.scr_sound[ "m4" ][ "moving3" ] 				= "airport_vkt_movingup";
	//Moving!			
	level.scr_sound[ "makarov" ][ "moving1" ] 				= "airport_mkv_moving1";
	//Moving!!			
	level.scr_sound[ "makarov" ][ "moving2" ] 				= "airport_mkv_moving2";
	//Comin' through!!			
	level.scr_sound[ "makarov" ][ "moving3" ] 				= "airport_mkv_cominthru";
	
	//More by the luggage cart!			
	level.scr_sound[ "makarov" ][ "enemy_luggage" ] 	= "airport_mkv_luggagecart";
	//Behind that luggage cart!			
	level.scr_sound[ "m4" ][ "enemy_luggage" ] 		= "airport_vkt_luggagecart";
	//Behind the landing gear!			
	level.scr_sound[ "makarov" ][ "enemy_landinggear" ]	= "airport_mkv_landinggear";
	//Over by the landing gear!			
	level.scr_sound[ "m4" ][ "enemy_landinggear" ] 	= "airport_vkt_landinggear";
	//More under the plane!			
	level.scr_sound[ "makarov" ][ "enemy_underplane" ] 	= "airport_mkv_underplane";
	//Behind the bus!! 			
	level.scr_sound[ "m4" ][ "enemy_bus" ] 			= "airport_vkt_behindbus";
	
	//Contact! 2nd floor windows!			
	level.scr_sound[ "makarov" ][ "contact_2nd_floor" ] 	= "airport_mkv_2ndflrwndws";
	//Copy that! 2nd floor windows!!			
	level.scr_sound[ "m4" ][ "contact_2nd_floor" ] 		= "airport_vkt_copy2ndflr";
	//FSB van!! Left side!!			
	level.scr_sound[ "makarov" ][ "van_left" ] 			= "airport_mkv_fsbvan";
	
	
	//goal_changed
		
	//Shoot the jet engine!!			
//	level.scr_sound[ "victor" ][ "engine_shoot" ] 			= "airport_vkt_shootjetengine";
	//Behind us! 2nd floor!			
	level.scr_sound[ "makarov" ][ "airport_mkv_behindus" ]	= "airport_mkv_behindus";
	//Go! Go! Go!			
//	level.scr_sound[ "makarov" ][ "go1" ] 				= "airport_mkv_gogogo";
	
	
	
	
	level.scr_radio[ "airport_at1_scream" ]			= "airport_at1_scream";
		
	
	//ESCAPE
	//This way let's go.
	level.scr_radio[ "airport_mkv_thisway" ]				= "airport_mkv_thisway";
	//Hallway clear.
	level.scr_radio[ "airport_mkv_hallway" ]				= "airport_mkv_hallway";
	level.scr_sound[ "makarov" ][ "airport_mkv_hallway" ]	= "airport_mkv_hallway";
	//Hold your fire.
	level.scr_radio[ "airport_mkv_holdfire" ]				= "airport_mkv_holdfire";
	level.scr_sound[ "makarov" ][ "airport_mkv_holdfire" ]	= "airport_mkv_holdfire";
	level.scr_face[ "makarov" ][ "airport_mkv_holdfire" ]	= %airport_mkv_holdfire;
	level.scr_anim[ "makarov" ][ "stand_exposed_wave_halt_v2" ] = 			%stand_exposed_wave_halt_v2;
	
	//Van Terrorist	Good, you made it! Get in.	
	level.scr_sound[ "van_mate" ][ "airport_vt_madeit" ]		= "airport_vt_madeit";
	//Van Terrorist	Come on, let's go.	
	level.scr_sound[ "van_mate" ][ "airport_vt_comeon" ]		= "airport_vt_comeon";
	//Van Terrorist	What are you waiting for? Get in.	
	level.scr_sound[ "van_mate" ][ "airport_vt_waitingfor" ]	= "airport_vt_waitingfor";
	//Van Terrorist	Will it be enough to blame the Americans?	
	level.scr_sound[ "van_mate" ][ "airport_vt_beenough" ]		= "airport_vt_beenough";
	//That was no message�	
	level.scr_sound[ "makarov" ][ "airport_mkv_nomessage" ]		= "airport_mkv_nomessage";
	//This is a message.
	level.scr_sound[ "makarov" ][ "airport_mkv_thiswill" ]		= "airport_mkv_thiswill";
	
	level.scr_radio[ "airport_mkv_allofrussia" ]	= "airport_mkv_allofrussia";	
}

#using_animtree( "generic_human" );
makarov_aim_player( guy )
{
	self endon( "death" );
	self endon( "done_shoot_player" );
	
	self setAnimLimited( %airport_ending_aim4_makarov, 1, 0 );
	self setAnimLimited( %airport_ending_aim6_makarov, 1, 0 );
	
	while ( 1 )
	{
		angleYaw = VectorToAngles( level.player.origin - self.origin )[ 1 ];
		angleYaw = AngleClamp180( self.angles[ 1 ] - angleYaw );
		angleYaw = clamp( angleYaw, -60, 60 );
		
		leftWeight = 0;
		rightWeight = 0;
		
		if ( angleYaw < 0 )
			leftWeight = angleYaw / -60;
		else if ( angleYaw > 0 )
			rightWeight = angleYaw / 60;
		
		self setAnimLimited( %airport_ending_aim_left, leftWeight, 0.2 );
		self setAnimLimited( %airport_ending_aim_right, rightWeight, 0.2 );
		
		wait 0.05;
	}	
}

change_team( guy )
{
	guy.ignoreme = true;
	guy.ignoreall = true;
	
	wait 1;
	guy.team = "axis";	
}

gun_fx( guy )
{
	thread play_sound_in_space( "weap_makarov_fire_npc" , guy GetTagOrigin( "TAG_FLASH" ) );
}

gun_off( guy )
{
	guy gun_remove();	
	wait .25;
	guy playsound( "scn_airport_weapon_catch" );
}

lookat_on( guy )
{
	guy SetLookAtEntity( level.player );	
}

lookat_off( guy )
{
	guy SetLookAtEntity();	
}

doorkick_basement( guy )
{
	door = getent( "basement_door", "targetname" );
	door connectpaths();
	
	door playsound( "wood_door_kick" );
	door rotateyaw( 95, .25, 0, .25 );
	door waittill( "rotatedone" );
	door rotateyaw( -20, 2, 0, 2 );
}

doorkick_escape( guy )
{
	door = getent( "escape_door", "targetname" );
	door connectpaths();
	door playsound( "wood_door_kick" );
	door rotateyaw( -95, .25, 0, .25 );
	door waittill( "rotatedone" );
	door rotateyaw( 20, 2, 0, 2 );
}

cop_shout( guy )
{
	guy thread play_sound_on_tag_endon_death( "airport_rac_movemove" );	
}

cop_killme( guy )
{	
	flag_set( "massacre_kill_rush" );
}

_ignoreme_off( guy )
{
	guy.ignoreme = false;
	guy notify( "shoot_me" );
}

nadethrow_elev( guy )
{
	guy.grenadeAmmo++;	
	vec = anglestoforward(guy.angles);
	ri	= anglestoright( guy.angles );
	ri 	= vector_multiply( ri, -.25 );
	end = guy.origin + vector_multiply( vec, 50 );
	end = end + (0,0,14) + ri;
	vec = vectornormalize( end - guy.origin );
	vec = vector_multiply( vec, 800 );
	
	time = 2.5;
	
	guy magicgrenademanual( guy gettagorigin( "TAG_INHAND" ), vec, time );	
	
	delaythread( time - .05, ::flag_set, "massacre_elevator_grenade_exp" );
	
	wait .75;
	flag_set( "massacre_elevator_grenade_throw" );
}

nadethrow_mak( guy )
{
	guy.grenadeAmmo++;	
	vec = anglestoforward(guy.angles);
	ri	= anglestoright( guy.angles );
	ri 	= vector_multiply( ri, 4 );
	end = guy.origin + vector_multiply( vec, 50 );
	end = end + (0,0,6) + ri;
	vec = vectornormalize( end - guy.origin );
	vec = vector_multiply( vec, 1300 );
	
	flag_set( "massacre_nadethrow" );
	guy magicgrenademanual( guy gettagorigin( "j_wrist_ri" ), vec, level.nadethrow_mak_time );	
}

nadethrow( guy )
{
	oldGrenadeWeapon = guy.grenadeWeapon;
	guy.grenadeWeapon = "flash_grenade";
	guy.grenadeAmmo++ ;	
	vec = anglestoforward(guy.angles);
	end = guy.origin + vector_multiply( vec, 50 );
	end = end + (0,0,5);
	dmg = end + (0,0,30);
	vec = vectornormalize( end - guy.origin );
	vec = vector_multiply( vec, 512 );
	
	guy magicgrenademanual( guy gettagorigin( "TAG_INHAND" ), vec, 1.5 );	
	guy.grenadeWeapon = oldGrenadeWeapon;
	
	wait .1;
	//make the glass break
	//model = spawn( "script_model", dmg );
	//model setmodel( "weapon_us_smoke_grenade" );
	radiusdamage( dmg, 64, 5000, 5000 );
}

allowdeath_off( guy )
{
	guy.a.nodeath 	= true;
	guy.allowdeath = false;
	guy.nointerrupt = true;	
}

allowdeath_off_wait( guy )
{
	wait 1;
	
	guy.a.nodeath 	= true;
	guy.allowdeath = true;
	guy.nointerrupt = true;	
}

allowdeath_on( guy )
{
	guy.a.nodeath = false;
	guy.allowdeath = true;
}

kill_guy( guy )
{
	guy.allowdeath = true;
	guy kill();	
}

slide_death( guy )
{
	guy.allowdeath = false;
	guy.a.nodeath = true;
	
	origin = guy gettagorigin( "J_SpineUpper" );
	enemy = getclosest( guy.origin, level.team );  
	vec = vectornormalize( enemy.origin - origin );
	vec2 = vector_multiply( vec, 10 );
	 
	PlayFX( getfx( "killshot" ), origin + vec2, vec );
	
	guy thread anim_generic( guy, "slide_across_car_death" );
	wait 1;
	guy.allowdeath = true;
	guy kill();
}


smoke_throw( guy )
{
	oldGrenadeWeapon = guy.grenadeWeapon;
	guy.grenadeWeapon = "smoke_grenade_american";
	guy.grenadeAmmo++ ;	
	
	vec = guy.smoke_destination - guy.origin + (0,0,500);
		
	time = 6;
	
	guy magicgrenademanual( guy gettagorigin( "TAG_INHAND" ), vec, time );
	guy.grenadeWeapon = oldGrenadeWeapon;
			
	wait .5;
	
	guy stopanimscripted();
	guy notify( "grenade_throw_done" );
}

lobby_people_data()
{
	data = [];
	
	//kristin walks up with roller and pushes me out of the way
	data[ "intro_lobby_anim_group_1" ][0][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_1" ][0][ "anime" ] 		= "airport_civ_in_line_6_A";
	data[ "intro_lobby_anim_group_1" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_1" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_1" ][0][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_1" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_1" ][1][ "anime" ] 		= "airport_civ_in_line_6_B";
	data[ "intro_lobby_anim_group_1" ][1][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_1" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_1" ][1][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_1" ][2][ "model" ] 		= "civilian_female_suit";
	data[ "intro_lobby_anim_group_1" ][2][ "anime" ] 		= "airport_civ_in_line_6_C";
	data[ "intro_lobby_anim_group_1" ][2][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_1" ][2][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_1" ][2][ "deathtime" ] 	= 0;
	
	//all three die - i fall into allen
	data[ "intro_lobby_anim_group_2" ][0][ "model" ] 		= "civilian_female_suit";
	data[ "intro_lobby_anim_group_2" ][0][ "anime" ] 		= "airport_civ_in_line_9_A";
	data[ "intro_lobby_anim_group_2" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_2" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_2" ][0][ "deathtime" ] 	= 0;
	data[ "intro_lobby_anim_group_2" ][0][ "deleteme" ] 	= 1;
	
	data[ "intro_lobby_anim_group_2" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_2" ][1][ "anime" ] 		= "airport_civ_in_line_9_B";
	data[ "intro_lobby_anim_group_2" ][1][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_2" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_2" ][1][ "deathtime" ] 	= 0;
	data[ "intro_lobby_anim_group_2" ][1][ "deleteme" ] 	= 1;
	
	data[ "intro_lobby_anim_group_2" ][2][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_2" ][2][ "anime" ] 		= "airport_civ_in_line_9_C";
	data[ "intro_lobby_anim_group_2" ][2][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_2" ][2][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_2" ][2][ "deathtime" ] 	= 0;
	
	//pile up backwards
	data[ "intro_lobby_anim_group_3" ][0][ "model" ] 		= "civilian_female_suit";
	data[ "intro_lobby_anim_group_3" ][0][ "anime" ] 		= "airport_civ_in_line_10_A";
	data[ "intro_lobby_anim_group_3" ][0][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_3" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_3" ][0][ "deathtime" ] 	= 0;
	data[ "intro_lobby_anim_group_3" ][0][ "deleteme" ] 	= 1;
	
	data[ "intro_lobby_anim_group_3" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_3" ][1][ "anime" ] 		= "airport_civ_in_line_10_B";
	data[ "intro_lobby_anim_group_3" ][1][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_3" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_3" ][1][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_3" ][2][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_3" ][2][ "anime" ] 		= "airport_civ_in_line_10_C";
	data[ "intro_lobby_anim_group_3" ][2][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_3" ][2][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_3" ][2][ "deathtime" ] 	= 0;
	
	//pile up forwards - kristin steps over me
	data[ "intro_lobby_anim_group_4" ][0][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_4" ][0][ "anime" ] 		= "airport_civ_in_line_12_A";
	data[ "intro_lobby_anim_group_4" ][0][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_4" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_4" ][0][ "deathtime" ] 	= 0;
	data[ "intro_lobby_anim_group_4" ][0][ "deleteme" ] 	= 1;
	
	data[ "intro_lobby_anim_group_4" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_4" ][1][ "anime" ] 		= "airport_civ_in_line_12_B";
	data[ "intro_lobby_anim_group_4" ][1][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_4" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_4" ][1][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_4" ][2][ "model" ] 		= "civilian_female_suit";
	data[ "intro_lobby_anim_group_4" ][2][ "anime" ] 		= "airport_civ_in_line_12_C";
	data[ "intro_lobby_anim_group_4" ][2][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_4" ][2][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_4" ][2][ "deathtime" ] 	= 0;
	
	//pile up forwards - no kristin - pushing dying guy out of way
	data[ "intro_lobby_anim_group_5" ][0][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_5" ][0][ "anime" ] 		= "airport_civ_in_line_12_A";
	data[ "intro_lobby_anim_group_5" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_5" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_5" ][0][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_5" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_5" ][1][ "anime" ] 		= "airport_civ_in_line_12_B";
	data[ "intro_lobby_anim_group_5" ][1][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_5" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_5" ][1][ "deathtime" ] 	= 0;
	
	//pile up backward - near metal detector
	data[ "intro_lobby_anim_group_6" ][0][ "model" ] 		= "civilian_female_suit_low_LOD";
	data[ "intro_lobby_anim_group_6" ][0][ "anime" ] 		= "airport_civ_in_line_10_A";
	data[ "intro_lobby_anim_group_6" ][0][ "delay" ] 		= 2;
	data[ "intro_lobby_anim_group_6" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_6" ][0][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_6" ][1][ "model" ] 		= "civilian_male_suit_low_LOD";
	data[ "intro_lobby_anim_group_6" ][1][ "anime" ] 		= "airport_civ_in_line_10_B";
	data[ "intro_lobby_anim_group_6" ][1][ "delay" ] 		= 2;
	data[ "intro_lobby_anim_group_6" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_6" ][1][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_6" ][2][ "model" ] 		= "civilian_male_suit_low_LOD";
	data[ "intro_lobby_anim_group_6" ][2][ "anime" ] 		= "airport_civ_in_line_10_C";
	data[ "intro_lobby_anim_group_6" ][2][ "delay" ] 		= 2;
	data[ "intro_lobby_anim_group_6" ][2][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_6" ][2][ "deathtime" ] 	= 0;
	
	//pile up forwards - no kristin - near metal detector
	data[ "intro_lobby_anim_group_7" ][0][ "model" ] 		= "civilian_male_suit_low_LOD";
	data[ "intro_lobby_anim_group_7" ][0][ "anime" ] 		= "airport_civ_in_line_12_A";
	data[ "intro_lobby_anim_group_7" ][0][ "delay" ] 		= 2;
	data[ "intro_lobby_anim_group_7" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_7" ][0][ "deathtime" ] 	= 0;
	data[ "intro_lobby_anim_group_7" ][0][ "deleteme" ] 	= 1;
	
	data[ "intro_lobby_anim_group_7" ][1][ "model" ] 		= "civilian_male_suit_low_LOD";
	data[ "intro_lobby_anim_group_7" ][1][ "anime" ] 		= "airport_civ_in_line_12_B";
	data[ "intro_lobby_anim_group_7" ][1][ "delay" ] 		= 2;
	data[ "intro_lobby_anim_group_7" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_7" ][1][ "deathtime" ] 	= 0;
	data[ "intro_lobby_anim_group_7" ][1][ "deleteme" ] 	= 1;
	
	//pile up forwards 2 - no kristin - near metal detector 2
	data[ "intro_lobby_anim_group_8" ][0][ "model" ] 		= "civilian_male_suit_low_LOD";
	data[ "intro_lobby_anim_group_8" ][0][ "anime" ] 		= "airport_civ_in_line_12_A";
	data[ "intro_lobby_anim_group_8" ][0][ "delay" ] 		= 2;
	data[ "intro_lobby_anim_group_8" ][0][ "deathanim" ] 	= "exposed_crouch_death_flip";
	data[ "intro_lobby_anim_group_8" ][0][ "deathtime" ] 	= 9.5;
	data[ "intro_lobby_anim_group_8" ][0][ "deleteme" ] 	= 1;
	
	data[ "intro_lobby_anim_group_8" ][1][ "model" ] 		= "civilian_male_suit_low_LOD";
	data[ "intro_lobby_anim_group_8" ][1][ "anime" ] 		= "airport_civ_in_line_12_B";
	data[ "intro_lobby_anim_group_8" ][1][ "delay" ] 		= 2;
	data[ "intro_lobby_anim_group_8" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_8" ][1][ "deathtime" ] 	= 0;
	
	//2 instantly die, middle
	data[ "intro_lobby_anim_group_9" ][0][ "model" ] 		= "civilian_female_suit";
	data[ "intro_lobby_anim_group_9" ][0][ "anime" ] 		= "airport_civ_in_line_9_A";
	data[ "intro_lobby_anim_group_9" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_9" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_9" ][0][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_9" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_9" ][1][ "anime" ] 		= "airport_civ_in_line_9_B";
	data[ "intro_lobby_anim_group_9" ][1][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_9" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_9" ][1][ "deathtime" ] 	= 0;
	
	//push, run, die at close metal detector
	data[ "intro_lobby_anim_group_10" ][0][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_10" ][0][ "anime" ] 		= "airport_civ_in_line_6_A";
	data[ "intro_lobby_anim_group_10" ][0][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_10" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_10" ][0][ "deathtime" ] 	= 0;
	data[ "intro_lobby_anim_group_10" ][0][ "deleteme" ] 	= 1;
	
	data[ "intro_lobby_anim_group_10" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_10" ][1][ "anime" ] 		= "airport_civ_in_line_6_B";
	data[ "intro_lobby_anim_group_10" ][1][ "delay" ] 		= 1;
	data[ "intro_lobby_anim_group_10" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_10" ][1][ "deathtime" ] 	= 0;
	
	//die instantly near close detector
	data[ "intro_lobby_anim_group_11" ][0][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_11" ][0][ "anime" ] 		= "airport_civ_in_line_9_B";
	data[ "intro_lobby_anim_group_11" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_11" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_11" ][0][ "deathtime" ] 	= 0;
	
	//hit the deck, get up, run and die at close detector
	data[ "intro_lobby_anim_group_12" ][0][ "model" ] 		= "civilian_female_suit";
	data[ "intro_lobby_anim_group_12" ][0][ "anime" ] 		= "airport_civ_in_line_13_A";
	data[ "intro_lobby_anim_group_12" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_12" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_12" ][0][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_12" ][1][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_12" ][1][ "anime" ] 		= "airport_civ_in_line_15_B";
	data[ "intro_lobby_anim_group_12" ][1][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_12" ][1][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_12" ][1][ "deathtime" ] 	= 0;
	
	data[ "intro_lobby_anim_group_12" ][2][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_12" ][2][ "anime" ] 		= "airport_civ_in_line_13_C";
	data[ "intro_lobby_anim_group_12" ][2][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_12" ][2][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_12" ][2][ "deathtime" ] 	= 0;
	
	//die instantly at entrance
	data[ "intro_lobby_anim_group_13" ][0][ "model" ] 		= "civilian_female_suit";
	data[ "intro_lobby_anim_group_13" ][0][ "anime" ] 		= "airport_civ_in_line_15_A";
	data[ "intro_lobby_anim_group_13" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_13" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_13" ][0][ "deathtime" ] 	= 0;
	
	//die instantly at entrance
	data[ "intro_lobby_anim_group_14" ][0][ "model" ] 		= "civilian_male_suit";
	data[ "intro_lobby_anim_group_14" ][0][ "anime" ] 		= "airport_civ_in_line_15_C";
	data[ "intro_lobby_anim_group_14" ][0][ "delay" ] 		= 0;
	data[ "intro_lobby_anim_group_14" ][0][ "deathanim" ] 	= undefined;
	data[ "intro_lobby_anim_group_14" ][0][ "deathtime" ] 	= 0;
	
	return data;
}