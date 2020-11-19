#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;

main()
{
	generic_human();
	civilian_walk_loops();
	civilian_stand_loops();
	dog_anims();
	model_anims();
}

#using_animtree( "generic_human" );
generic_human()
{	
	level.scr_anim[ "generic" ][ "afgan_caves_Price_rappel_idle" ] 			= %afgan_caves_Price_rappel_idle;
	level.scr_anim[ "generic" ][ "afchase_ending_shepherd_gun_monologue" ] 	= %afchase_ending_shepherd_gun_monologue;
	level.scr_anim[ "generic" ][ "patrol_bored_idle_smoke" ] 				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "zodiac_trans_L2R" ] 						= %zodiac_trans_L2R;
	
	level.scr_anim[ "generic" ][ "training_intro_foley_begining" ] 			= %training_intro_foley_begining;
	level.scr_anim[ "generic" ][ "training_pit_sitting_welcome" ] 			= %training_pit_sitting_welcome;
	level.scr_anim[ "generic" ][ "riotshield_idle" ] 						= %riotshield_idle;
		
	level.scr_anim[ "generic" ][ "riotshield_bashB_attack" ] 				= %riotshield_bashB_attack;
	level.scr_anim[ "generic" ][ "riotshield_bashB_defend" ] 				= %riotshield_bashB_defend;
	level.scr_anim[ "generic" ][ "airport_security_civ_rush_guard" ] 		= %airport_security_civ_rush_guard;
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_react_R" ] 	= %airport_security_guard_pillar_react_R;	
	level.scr_anim[ "generic" ][ "airport_elevator_sequence_guy1" ] 		= %airport_elevator_sequence_guy1;
	level.scr_anim[ "generic" ][ "airport_elevator_sequence_guy2" ] 		= %airport_elevator_sequence_guy2;
	
	level.scr_anim[ "generic" ][ "killhouse_sas_1" ] 						= %killhouse_sas_1;
	level.scr_anim[ "generic" ][ "killhouse_sas_2" ] 						= %killhouse_sas_2;
	level.scr_anim[ "generic" ][ "killhouse_sas_3" ] 						= %killhouse_sas_3;
	level.scr_anim[ "generic" ][ "killhouse_sas_price" ] 					= %killhouse_sas_price;
	level.scr_anim[ "generic" ][ "guardA_standing_cold_idle" ] 				= %guardA_standing_cold_idle;
	level.scr_anim[ "generic" ][ "guardB_standing_cold_idle" ] 				= %guardB_standing_cold_idle;
	
	level.scr_anim[ "generic" ][ "gulag_end_evac_soap" ] 					= %gulag_end_evac_soap;
	level.scr_anim[ "generic" ][ "estate_ghost_radio" ] 					= %estate_ghost_radio;
	level.scr_anim[ "generic" ][ "airport_civ_in_line_15_B" ] 				= %airport_civ_in_line_15_B;
	level.scr_anim[ "generic" ][ "invasion_vehicle_cover_dialogue_guy1" ] 	= %invasion_vehicle_cover_dialogue_guy1;
	level.scr_anim[ "generic" ][ "invasion_vehicle_cover_dialogue_guy2" ] 	= %invasion_vehicle_cover_dialogue_guy2;
	
	level.scr_anim[ "generic" ][ "oilrig_sub_B_idle_3" ] 					= %oilrig_sub_b_idle_3;
	level.scr_anim[ "generic" ][ "oilrig_sub_B_idle_4" ] 					= %oilrig_sub_b_idle_4;
	level.scr_anim[ "generic" ][ "roadkill_opening_shepherd" ] 				= %roadkill_opening_shepherd;
	level.scr_anim[ "generic" ][ "roadkill_opening_foley" ] 				= %roadkill_opening_foley;
	level.scr_anim[ "generic" ][ "oilrig_balcony_smoke_idle" ] 				= %oilrig_balcony_smoke_idle;
	
	level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier1" ] 		= %roadkill_cover_active_soldier1;
	level.scr_anim[ "generic" ][ "roadkill_cover_active_soldier2" ] 		= %roadkill_cover_active_soldier2;
	level.scr_anim[ "generic" ][ "roadkill_cover_soldier" ] 				= %roadkill_cover_soldier;
	level.scr_anim[ "generic" ][ "roadkill_cover_spotter" ] 				= %roadkill_cover_spotter;
	level.scr_anim[ "generic" ][ "bh_6_drop" ] 								= %bh_6_drop;
	level.scr_anim[ "generic" ][ "bh_rope_drop_le" ] 						= %bh_rope_drop_le;
	
	level.scr_anim[ "generic" ][ "training_intro_trainee_1_end" ] 			= %training_intro_trainee_1_end;
	level.scr_anim[ "generic" ][ "training_intro_translator_end" ] 			= %training_intro_translator_end;
	level.scr_anim[ "generic" ][ "training_intro_foley_end" ] 				= %training_intro_foley_end;
	level.scr_anim[ "generic" ][ "parabolic_leaning_guy_idle_training" ] 	= %parabolic_leaning_guy_idle_training;
	level.scr_anim[ "generic" ][ "training_pushups_guy1" ] 					= %training_pushups_guy1;
	
	level.scr_anim[ "generic" ][ "takedown_room1B_soldier" ] 			= %takedown_room1B_soldier;
	level.scr_anim[ "generic" ][ "takedown_room1B_hostage" ] 			= %takedown_room1B_hostage;
	level.scr_anim[ "generic" ][ "hostage_chair_idle" ] 				= %hostage_chair_idle;
	level.scr_anim[ "generic" ][ "hostage_chair_dive" ] 				= %hostage_chair_dive;
	level.scr_anim[ "generic" ][ "hostage_chair_ground_idle" ] 			= %hostage_chair_ground_idle;
	
	level.scr_anim[ "generic" ][ "coup_guard2_jeera" ] 						= %coup_guard2_jeerA;
	level.scr_anim[ "generic" ][ "coup_guard2_jeerb" ] 						= %coup_guard2_jeerB;
	level.scr_anim[ "generic" ][ "coup_guard2_jeerc" ] 						= %coup_guard2_jeerC;
	level.scr_anim[ "generic" ][ "coup_guard1_jeer" ] 						= %coup_guard1_jeer;
	level.scr_anim[ "generic" ][ "village_interrogationA_Price" ] 			= %village_interrogationA_Price;
	level.scr_anim[ "generic" ][ "village_interrogationA_Zak" ] 			= %village_interrogationA_Zak;
	
				
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_grenadefireA" ] 	= %favela_chaotic_crouchcover_grenadeFireA;
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_fireA" ] 			= %favela_chaotic_crouchcover_fireA;
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_fireB" ] 			= %favela_chaotic_crouchcover_fireB;
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_fireC" ] 			= %favela_chaotic_crouchcover_fireC;
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_gunjamA" ] 		= %favela_chaotic_crouchcover_gunjamA;
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_gunjamB" ] 		= %favela_chaotic_crouchcover_gunjamB;
	
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_grenadeFireA" ] 	= %favela_chaotic_standcover_grenadeFireA;
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_fireA" ] 			= %favela_chaotic_standcover_fireA;
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_fireB" ] 			= %favela_chaotic_standcover_fireB;
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_fireC" ] 			= %favela_chaotic_standcover_fireC;
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_gunjamA" ] 			= %favela_chaotic_standcover_gunjamA;
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_gunjamB" ] 			= %favela_chaotic_standcover_gunjamB;
	
	level.scr_anim[ "generic" ][ "civilian_sitting_talking_A_1" ] 			= %civilian_sitting_talking_A_1;
	level.scr_anim[ "generic" ][ "civilian_sitting_talking_A_2" ] 			= %civilian_sitting_talking_A_2;
	level.scr_anim[ "generic" ][ "civilian_sitting_talking_B_1" ] 			= %civilian_sitting_talking_B_1;
	level.scr_anim[ "generic" ][ "civilian_sitting_talking_B_2" ] 			= %civilian_sitting_talking_B_2;
			
	level.scr_anim[ "generic" ][ "casual_stand_v2_idle" ]					= %casual_stand_v2_idle;
	level.scr_anim[ "generic" ][ "casual_stand_v2_twitch_shift" ]			= %casual_stand_v2_twitch_shift;
	level.scr_anim[ "generic" ][ "casual_stand_v2_twitch_talk" ]			= %casual_stand_v2_twitch_talk;
	level.scr_anim[ "generic" ][ "casual_stand_v2_twitch_radio" ]			= %casual_stand_v2_twitch_radio;
	
	level.scr_anim[ "generic" ][ "casual_crouch_idle" ]						= %casual_crouch_idle;
	level.scr_anim[ "generic" ][ "casual_crouch_twitch" ]					= %casual_crouch_twitch;
	level.scr_anim[ "generic" ][ "casual_crouch_point" ]					= %casual_crouch_point;
	
	level.scr_anim[ "generic" ][ "training_intro_foley_idle_talk_1" ] 		= %training_intro_foley_idle_talk_1;
	level.scr_anim[ "generic" ][ "training_intro_foley_idle_talk_2" ] 		= %training_intro_foley_idle_talk_2;
	level.scr_anim[ "generic" ][ "training_intro_foley_turnaround_1" ] 		= %training_intro_foley_turnaround_1;
	level.scr_anim[ "generic" ][ "training_intro_foley_turnaround_2" ] 		= %training_intro_foley_turnaround_2;
	level.scr_anim[ "generic" ][ "training_intro_foley_turnaround_3" ] 		= %training_intro_foley_turnaround_3;
	
	level.scr_anim[ "generic" ][ "stinger_fire" ]							= %stinger_fire;
	level.scr_anim[ "generic" ][ "stinger_fire_alt" ]						= %stinger_fire_alt;
	level.scr_anim[ "generic" ][ "stinger_idle" ]							= %stinger_idle;
	
	
	level.scr_anim[ "generic" ][ "favela_crouch" ][0] 					= %favela_chaotic_crouchcover_grenadeFireA;
	level.scr_anim[ "generic" ][ "favela_crouch" ][1]					= %favela_chaotic_crouchcover_fireA;
	level.scr_anim[ "generic" ][ "favela_crouch" ][2]					= %favela_chaotic_crouchcover_fireB;
	level.scr_anim[ "generic" ][ "favela_crouch" ][3] 					= %favela_chaotic_crouchcover_fireC;
	level.scr_anim[ "generic" ][ "favela_crouch" ][4] 					= %favela_chaotic_crouchcover_gunjamA;
	level.scr_anim[ "generic" ][ "favela_crouch" ][5] 					= %favela_chaotic_crouchcover_gunjamB;
	
	level.scr_anim[ "generic" ][ "favela_stand" ][0]				 	= %favela_chaotic_standcover_grenadeFireA;
	level.scr_anim[ "generic" ][ "favela_stand" ][1]		 			= %favela_chaotic_standcover_fireA;
	level.scr_anim[ "generic" ][ "favela_stand" ][2]					= %favela_chaotic_standcover_fireB;
	level.scr_anim[ "generic" ][ "favela_stand" ][3]					= %favela_chaotic_standcover_fireC;
	level.scr_anim[ "generic" ][ "favela_stand" ][4]					= %favela_chaotic_standcover_gunjamA;
	level.scr_anim[ "generic" ][ "favela_stand" ][5]		 			= %favela_chaotic_standcover_gunjamB;
	
	level.scr_anim[ "generic" ][ "casual_stand" ][ 0 ] = %casual_stand_v2_idle;
	level.scr_anim[ "generic" ][ "casual_stand" ][ 1 ] = %casual_stand_v2_twitch_shift;
	level.scr_anim[ "generic" ][ "casual_stand" ][ 2 ] = %casual_stand_v2_twitch_talk;
	level.scr_anim[ "generic" ][ "casual_stand" ][ 3 ] = %casual_stand_v2_twitch_radio;
	
	level.scr_anim[ "generic" ][ "casual_crouch" ][ 0 ] = %casual_crouch_idle;
	level.scr_anim[ "generic" ][ "casual_crouch" ][ 1 ] = %casual_crouch_twitch;
	level.scr_anim[ "generic" ][ "casual_crouch" ][ 2 ] = %casual_crouch_point;
	
	level.scr_anim[ "generic" ][ "rpg" ][ 0 ] = %stinger_fire;
	level.scr_anim[ "generic" ][ "rpg" ][ 1 ] = %stinger_fire_alt;
	level.scr_anim[ "generic" ][ "rpg" ][ 2 ] = %stinger_idle;
	
	level.scr_anim[ "generic" ][ "chair" ][ 0 ] = %hostage_chair_idle;
	level.scr_anim[ "generic" ][ "chair" ][ 1 ] = %hostage_chair_twitch;
	level.scr_anim[ "generic" ][ "chair" ][ 2 ] = %hostage_chair_twitch2;
			
	level.scr_anim[ "generic" ][ "foley_talk" ][ 0 ] = %training_intro_foley_idle_talk_1;
	level.scr_anim[ "generic" ][ "foley_talk" ][ 1 ] = %training_intro_foley_idle_talk_2;
	level.scr_anim[ "generic" ][ "foley_talk" ][ 2 ] = %training_intro_foley_turnaround_2;
	level.scr_anim[ "generic" ][ "foley_talk" ][ 3 ] = %training_intro_foley_turnaround_3;
	
}

civilian_walk_loops()
{
	three_twitch_weights = [];
	three_twitch_weights[0] = 2;
	three_twitch_weights[1] = 1;
	three_twitch_weights[2] = 1;
	three_twitch_weights[3] = 1;
	
	weights = [];
	weights[ 0 ] = 7;
	weights[ 1 ] = 3;
	one_twitch_weights = get_cumulative_weights( weights );
	
	level.scr_anim[ "civilian_cellphone_walk" ][ "run_noncombat" ][ 0 ]		= %civilian_cellphonewalk;
	level.scr_anim[ "civilian_cellphone_walk" ][ "run_noncombat" ][ 1 ]		= %civilian_cellphonewalk_twitch;
	level.scr_anim[ "civilian_cellphone_walk" ][ "run_weights" ]			= one_twitch_weights;
	level.scr_anim[ "civilian_cellphone_walk" ][ "dodge_left" ]				= %civilian_cellphonewalk_dodge_L;
	level.scr_anim[ "civilian_cellphone_walk" ][ "dodge_right" ]			= %civilian_cellphonewalk_dodge_R;
	level.scr_anim[ "civilian_cellphone_walk" ][ "turn_left_90" ]			= %civilian_cellphonewalk_turn_L;
	level.scr_anim[ "civilian_cellphone_walk" ][ "turn_right_90" ]			= %civilian_cellphonewalk_turn_R;
	
	level.scr_anim[ "civilian_hurried_walk" ][ "run_noncombat" ][ 0 ]		= %civilian_walk_hurried_1;
	level.scr_anim[ "civilian_hurried_walk" ][ "run_noncombat" ][ 1 ]		= %civilian_walk_hurried_2;
	
	level.scr_anim[ "civilian_cool_walk" ][ "run_noncombat" ][ 0 ]			= %civilian_walk_cool;
	
	level.scr_anim[ "civilian_briefcase_walk" ][ "run_noncombat" ][ 0 ]		= %civilian_briefcase_walk;
	level.scr_anim[ "civilian_briefcase_walk" ][ "dodge_left" ]				= %civilian_briefcase_walk_dodge_L;
	level.scr_anim[ "civilian_briefcase_walk" ][ "dodge_right" ]			= %civilian_briefcase_walk_dodge_R;
	level.scr_anim[ "civilian_briefcase_walk" ][ "turn_left_90" ]			= %civilian_briefcase_walk_turn_L;
	level.scr_anim[ "civilian_briefcase_walk" ][ "turn_right_90" ]			= %civilian_briefcase_walk_turn_R;
	
	level.scr_anim[ "generic" ][ "civilian_hurried_walk" ][ 0 ]		= %civilian_walk_hurried_1;
	level.scr_anim[ "generic" ][ "civilian_hurried_walk" ][ 1 ]		= %civilian_walk_hurried_2;
	
	level.scr_anim[ "generic" ][ "civilian_cellphone_walk" ][ 0 ]	= %civilian_cellphonewalk;
	level.scr_anim[ "generic" ][ "civilian_cellphone_walk" ][ 1 ]	= %civilian_cellphonewalk_twitch;
	
	level.scr_anim[ "generic" ][ "civilian_cool_walk" ][ 0 ]		= %civilian_briefcase_walk;
	level.scr_anim[ "generic" ][ "civilian_walk" ][ 0 ]				= %civilian_walk_cool;
	
}

civilian_stand_loops()
{
	// STAND LOOPS
	level.scr_anim[ "generic" ][ "civilian_stand_idle" ][ 0 ]	 			= %civilian_stand_idle;
	level.scr_anim[ "generic" ][ "civilian_smoking_A" ][ 0 ]	 			= %civilian_smoking_A;
	level.scr_anim[ "generic" ][ "civilian_smoking_B" ][ 0 ]	 			= %civilian_smoking_B;
	level.scr_anim[ "generic" ][ "civilian_directions_1_A" ][ 0 ]	 		= %civilian_directions_1_A;
	level.scr_anim[ "generic" ][ "civilian_directions_1_B" ][ 0 ]	 		= %civilian_directions_1_B;	
	level.scr_anim[ "generic" ][ "civilian_hackey_guy1" ][ 0 ]	 			= %civilian_hackey_guy1;
	level.scr_anim[ "generic" ][ "civilian_hackey_guy2" ][ 0 ]	 			= %civilian_hackey_guy2;
	
	level.scr_anim[ "generic" ][ "oilrig_balcony_smoke_idle_idle" ][ 0 ]	 	= %oilrig_balcony_smoke_idle;
	level.scr_anim[ "generic" ][ "civilian_directions_1_A_once" ][0]	 		= %civilian_directions_1_A_once;
	level.scr_anim[ "generic" ][ "civilian_directions_1_B_once" ][0]	 		= %civilian_directions_1_B_once;
	level.scr_anim[ "generic" ][ "civilian_directions_2_A_once" ][0]	 		= %civilian_directions_2_A_once;
	level.scr_anim[ "generic" ][ "civilian_directions_2_B_once" ][0]	 		= %civilian_directions_2_B_once;
	
	level.scr_anim[ "generic" ][ "laptop_sit_idle_calm" ][0]	 				= %laptop_sit_idle_calm;
	level.scr_anim[ "generic" ][ "laptop_stand_idle" ][0]	 					= %laptop_stand_idle;
	level.scr_anim[ "generic" ][ "civilian_texting_sitting" ][0]	 			= %civilian_texting_sitting;	
}

#using_animtree( "dog" );
dog_anims()
{
	level.scr_anim[ "generic" ][ "german_shepherd_idle" ] 					= %german_shepherd_idle;
	level.scr_anim[ "generic" ][ "german_shepherd_attackidle" ] 			= %german_shepherd_attackidle;
	level.scr_anim[ "generic" ][ "german_shepherd_attackidle_bark" ] 		= %german_shepherd_attackidle_bark;
	level.scr_anim[ "generic" ][ "german_shepherd_attackidle_growl" ] 		= %german_shepherd_attackidle_growl;	
	
	level.scr_anim[ "generic" ][ "dog" ][ 0 ] = %german_shepherd_attackidle;
	level.scr_anim[ "generic" ][ "dog" ][ 1 ] = %german_shepherd_attackidle_bark;
	level.scr_anim[ "generic" ][ "dog" ][ 2 ] = %german_shepherd_attackidle_growl;
}

#using_animtree( "script_model" );
model_anims()
{
	//gun anims
	level.scr_anim[ "pit_gun" ][ "training_pit_sitting_welcome_gun" ]	= %training_pit_sitting_welcome_gun;
	level.scr_anim[ "pit_gun" ][ "training_pit_sitting_idle_gun" ]		= %training_pit_sitting_idle_gun;
	level.scr_anim[ "pit_gun" ][ "training_pit_stand_idle_gun" ]		= %training_pit_stand_idle_gun;
	level.scr_anim[ "pit_gun" ][ "training_pit_open_case_gun" ]			= %training_pit_open_case_gun;
	
	level.scr_animtree[ "pit_gun" ] 								= #animtree;
}