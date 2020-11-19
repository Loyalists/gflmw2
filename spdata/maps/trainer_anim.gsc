#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#using_animtree( "generic_human" );
main()
{
	anims();
	dialogue();
	vehicles();
	basketball_anims();
	model_anims();
}

anims()
{
	maps\_props::add_smoking_notetracks( "generic" );
	/*-----------------------
	TRAINING - RANGE
	-------------------------*/	
	//Begining, all start at same time:
	level.scr_anim[ "foley" ][ "training_intro_begining" ]					= %training_intro_foley_begining;
	
	//addNotetrack_flag( animname, notetrack, theFlag, anime )
	addNotetrack_flag( "foley", "ps_train_fly_welcome", "ps_train_fly_welcome", "training_intro_begining" );
	addNotetrack_flag( "foley", "ps_train_fly_demonstration", "ps_train_fly_demonstration", "training_intro_begining" );
	addNotetrack_flag( "foley", "ps_train_fly_nooffense", "ps_train_fly_nooffense", "training_intro_begining" );
	addNotetrack_flag( "foley", "ps_train_fly_makesyoulook", "ps_train_fly_makesyoulook", "training_intro_begining" );
	addNotetrack_flag( "foley", "ps_train_fly_showem", "ps_train_fly_showem", "training_intro_begining" );
	addNotetrack_flag( "foley", "pickup", "foley_anim_pickup_weapon", "training_intro_begining" );

	level.scr_anim[ "translator" ][ "training_intro_begining_start" ]		= %training_intro_translator_begining;
	level.scr_anim[ "translator" ][ "training_intro_begining" ][ 0 ]		= %training_intro_translator_begining;
	level.scr_anim[ "trainee_01" ][ "training_intro_begining_start" ]		= %training_intro_trainee_1_begining;
	level.scr_anim[ "trainee_01" ][ "training_intro_begining" ][ 0 ]		= %training_intro_trainee_1_begining;
	
	//Idle:
	level.scr_anim[ "foley" ][ "training_intro_idle" ][ 0 ]				= %training_intro_foley_idle_1;
	level.scr_anim[ "translator" ][ "training_intro_idle" ][ 0 ]		= %training_intro_translator_idle;
	level.scr_anim[ "trainee_01" ][ "training_intro_idle" ][ 0 ]		= %training_intro_trainee_1_transition_idle;
	
	//Turn arounds:
	level.scr_anim[ "foley" ][ "training_intro_foley_turnaround_1" ]		= %training_intro_foley_turnaround_1;
	level.scr_anim[ "foley" ][ "training_intro_foley_turnaround_2" ]		= %training_intro_foley_turnaround_2;
	
	//Talk idles:
	level.scr_anim[ "foley" ][ "training_intro_foley_idle_talk_1" ]		= %training_intro_foley_idle_talk_1;
	level.scr_anim[ "foley" ][ "training_intro_foley_idle_talk_2" ]		= %training_intro_foley_idle_talk_2;
	
	//Final group
	level.scr_anim[ "foley" ][ "training_intro_end" ]		= %training_intro_foley_end;
	addNotetrack_flag( "foley", "dialog_1", "notetrack_dialogue_foley_thanks_for_help", "training_intro_end" );
	addNotetrack_flag( "foley", "dialog_2", "notetrack_dialogue_foley_who_go_first", "training_intro_end" );

	
	level.scr_anim[ "translator" ][ "training_intro_end" ]		= %training_intro_translator_end;
	level.scr_anim[ "trainee_01" ][ "training_intro_end" ]		= %training_intro_trainee_1_end;
	
	//Idles forever:
	level.scr_anim[ "foley" ][ "training_intro_end_idle" ][ 0 ]				= %training_intro_foley_end_idle;
	level.scr_anim[ "translator" ][ "training_intro_end_idle" ][ 0 ]		= %training_intro_translator_end_idle;
	level.scr_anim[ "trainee_01" ][ "training_intro_end_idle" ][ 0 ]		= %training_intro_trainee_1_end_idle;
	addNotetrack_customFunction( "trainee_01", "fire_spray", ::trainee_fire_weapon );
	
	level.scr_anim[ "soldier_wounded" ][ "hummer_sequence" ]		= %training_humvee_wounded;
	level.scr_anim[ "soldier_door" ][ "hummer_sequence" ]			= %training_humvee_soldier;

	level.scr_anim[ "generic" ][ "training_locals_groupA_guy1" ][ 0 ]		= %training_locals_groupA_guy1;
	level.scr_anim[ "generic" ][ "training_locals_groupA_guy2" ][ 0 ]		= %training_locals_groupA_guy2;
	level.scr_anim[ "generic" ][ "training_locals_groupB_guy1" ][ 0 ]		= %training_locals_groupB_guy1;
	level.scr_anim[ "generic" ][ "training_locals_groupB_guy2" ][ 0 ]		= %training_locals_groupB_guy2;
	level.scr_anim[ "generic" ][ "training_locals_sit" ][ 0 ]		= %training_locals_sit;
	level.scr_anim[ "generic" ][ "training_locals_kneel" ][ 0 ]		= %training_locals_kneel;
	
	
	/*-----------------------
	PATROLS
	-------------------------*/	
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
	
	level.scr_anim[ "generic" ][ "combat_jog" ]					 = %combat_jog;

	level.scr_anim[ "generic" ][ "smoking_reach" ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 0 ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 1 ]				= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "smoking_react" ]				= %parabolic_leaning_guy_react;

	/*-----------------------
	RUNNERS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "training_jog_guy1" ]		= %training_jog_guy1;
	level.scr_anim[ "generic" ][ "training_jog_guy2" ]		= %training_jog_guy2;
	level.scr_anim[ "generic" ][ "casual_killer_jog_A" ]	= %casual_killer_jog_A;
	level.scr_anim[ "generic" ][ "casual_killer_jog_B" ]	= %casual_killer_jog_B;
	level.scr_anim[ "generic" ][ "freerunnerA_loop" ]		= %freerunnerA_loop;
	level.scr_anim[ "generic" ][ "freerunnerB_loop" ]		= %freerunnerB_loop;
	level.scr_anim[ "generic" ][ "huntedrun_1_idle" ]		= %huntedrun_1_idle;
	
	/*-----------------------
	AMBIENT
	-------------------------*/	
	//looping
	level.scr_anim[ "generic" ][ "training_sleeping_in_chair" ][ 0 ]	= %training_sleeping_in_chair;
	level.scr_anim[ "generic" ][ "training_basketball_rest" ][ 0 ]		= %training_basketball_rest;
	//level.scr_sound[ "generic" ][ "training_basketball_rest" ][ 0 ]		= "scn_trainer_bball_resting_guy";

	level.scr_anim[ "generic" ][ "training_basketball_guy1" ][ 0 ]		= %training_basketball_guy1;
	level.scr_anim[ "generic" ][ "training_basketball_guy2" ][ 0 ]		= %training_basketball_guy2;
	level.scr_anim[ "generic" ][ "training_humvee_repair" ][ 0 ]		= %training_humvee_repair;
	//level.scr_sound[ "generic" ][ "training_humvee_repair" ][ 0 ]		= "scn_trainer_mechanic";
	
	level.scr_anim[ "generic" ][ "training_pushups_guy1" ][ 0 ]			= %training_pushups_guy1;
	//level.scr_sound[ "generic" ][ "training_pushups_guy1" ][ 0 ]		= "scn_trainer_pushup_guy";
	
	level.scr_anim[ "generic" ][ "training_pushups_guy2" ][ 0 ]			= %training_pushups_guy2;
	//level.scr_sound[ "generic" ][ "training_pushups_guy2" ][ 0 ]		= "scn_trainer_pushup_guy";
	
	level.scr_anim[ "generic" ][ "training_humvee_repair" ][ 0 ]		= %training_humvee_repair;
	level.scr_anim[ "generic" ][ "killhouse_laptop_idle" ][ 0 ]			= %killhouse_laptop_idle;
	level.scr_anim[ "generic" ][ "killhouse_laptop_idle" ][ 1 ]			= %killhouse_laptop_lookup;
	level.scr_anim[ "generic" ][ "killhouse_laptop_idle" ][ 2 ]			= %killhouse_laptop_twitch;
	level.scr_anim[ "generic" ][ "cliffhanger_welder_wing" ][ 0 ]		= %cliffhanger_welder_wing;
	//level.scr_sound[ "generic" ][ "cliffhanger_welder_wing" ][ 0 ]		= "scn_trainer_welders_working_loop";


	level.scr_anim[ "generic" ][ "cliffhanger_welder_engine" ][ 0 ]		= %cliffhanger_welder_engine;
	level.scr_anim[ "generic" ][ "patrolstand_idle" ][ 0 ]		= %patrolstand_idle;
	level.scr_anim[ "generic" ][ "parabolic_guard_sleeper_idle" ][ 0 ]		= %parabolic_guard_sleeper_idle;
	level.scr_anim[ "generic" ][ "roadkill_cover_spotter_idle" ][ 0 ]		= %roadkill_cover_spotter_idle;
	level.scr_anim[ "generic" ][ "oilrig_balcony_smoke_idle" ][ 0 ]		= %oilrig_balcony_smoke_idle;
	level.scr_anim[ "generic" ][ "killhouse_gaz_idleB" ][ 0 ]		= %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "civilian_sitting_talking_A_2" ][ 0 ]		= %civilian_sitting_talking_A_2;
	level.scr_anim[ "generic" ][ "parabolic_leaning_guy_smoking_idle" ][ 0 ]		= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "parabolic_leaning_guy_idle" ][ 0 ]		= %parabolic_leaning_guy_idle;
	level.scr_anim[ "generic" ][ "parabolic_leaning_guy_idle_training" ][ 0 ]		= %parabolic_leaning_guy_idle_training;
	level.scr_anim[ "generic" ][ "civilian_texting_sitting" ][ 0 ]		= %civilian_texting_sitting;
	level.scr_anim[ "generic" ][ "sitting_guard_loadAK_idle" ][ 0 ]		= %sitting_guard_loadAK_idle;
	level.scr_anim[ "generic" ][ "afgan_caves_sleeping_guard_idle" ][ 0 ]		= %afgan_caves_sleeping_guard_idle;
	level.scr_anim[ "generic" ][ "cargoship_sleeping_guy_idle_2" ][ 0 ]		= %cargoship_sleeping_guy_idle_2;
	level.scr_anim[ "generic" ][ "civilian_sitting_talking_A_1" ][ 0 ]		= %civilian_sitting_talking_A_1;
	level.scr_anim[ "generic" ][ "bunker_toss_idle_guy1" ][ 0 ]		= %bunker_toss_idle_guy1;
	level.scr_anim[ "generic" ][ "roadkill_cover_radio_soldier3" ][ 0 ]		= %roadkill_cover_radio_soldier3;
	level.scr_anim[ "generic" ][ "civilian_sitting_talking_B_1" ][ 0 ]		= %civilian_sitting_talking_B_1;
	level.scr_anim[ "generic" ][ "civilian_smoking_A" ][ 0 ]		= %civilian_smoking_A;
	level.scr_anim[ "generic" ][ "civilian_reader_1" ][ 0 ]		= %civilian_reader_1;
	level.scr_anim[ "generic" ][ "civilian_reader_2" ][ 0 ]		= %civilian_reader_2;
	
	//HACK...need to make looping once anim is fixed
	level.scr_anim[ "generic" ][ "guardA_sit_sleeper_sleep_idle" ]		= %guardA_sit_sleeper_sleep_idle;
	level.scr_anim[ "generic" ][ "roadkill_humvee_map_sequence_quiet_idle" ][ 0 ]			= %roadkill_humvee_map_sequence_quiet_idle;
	level.scr_anim[ "generic" ][ "guardB_sit_drinker_idle" ][ 0 ]		= %guardB_sit_drinker_idle;
	level.scr_anim[ "generic" ][ "guardB_standing_cold_idle" ][ 0 ]		= %guardB_standing_cold_idle;
	level.scr_anim[ "generic" ][ "civilian_texting_standing" ][ 0 ]		= %civilian_texting_standing;
	level.scr_anim[ "generic" ][ "killhouse_sas_2_idle" ][ 0 ]		= %killhouse_sas_2_idle;
	level.scr_anim[ "generic" ][ "killhouse_sas_3_idle" ][ 0 ]		= %killhouse_sas_3_idle;
	level.scr_anim[ "generic" ][ "killhouse_sas_price_idle" ][ 0 ]		= %killhouse_sas_price_idle;
	level.scr_anim[ "generic" ][ "killhouse_sas_1_idle" ][ 0 ]		= %killhouse_sas_1_idle;
	level.scr_anim[ "generic" ][ "little_bird_casual_idle_guy1" ][ 0 ]		= %little_bird_casual_idle_guy1;
	level.scr_anim[ "generic" ][ "sniper_escape_spotter_idle" ][ 0 ]		= %sniper_escape_spotter_idle;
	level.scr_anim[ "generic" ][ "patrol_bored_idle" ][ 0 ]		= %patrol_bored_idle;

	//escalator_up_briefcase_guy_enter

	level.scr_anim[ "generic" ][ "training_woundedwalk_soldier_1" ]			 = %training_woundedwalk_soldier_1;
	level.scr_anim[ "generic" ][ "training_woundedwalk_soldier_2" ]			 = %training_woundedwalk_soldier_2;
	
	//one-off then loop 
	level.scr_anim[ "generic" ][ "hostage_pickup_runout_guy1" ]			 = %hostage_pickup_runout_guy1;
	level.scr_anim[ "generic" ][ "hostage_pickup_runout_guy2" ]			 = %hostage_pickup_runout_guy2;
	

	//checking wounded:
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_medic" ]			 = %DC_Burning_stop_bleeding_medic;
	addNotetrack_attach(  "generic", "attach prop", "clotting_powder_animated", "TAG_INHAND", "DC_Burning_stop_bleeding_medic" );
	addNotetrack_detach(  "generic", "dettach prop", "clotting_powder_animated", "TAG_INHAND", "DC_Burning_stop_bleeding_medic" );
	
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded" ]			 = %DC_Burning_stop_bleeding_wounded;
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_medic_idle" ][0]			 = %DC_Burning_stop_bleeding_medic_endidle;
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_idle" ][0]			 = %DC_Burning_stop_bleeding_wounded_endidle;

	level.scr_anim[ "carrier" ][ "wounded_pickup" ]			 = %wounded_pickup_carrierguy;
	level.scr_anim[ "carried" ][ "wounded_pickup" ]			 = %wounded_pickup_carriedguy;

	level.scr_anim[ "carrier" ][ "wounded_carry" ]		 = %wounded_carry_fastwalk_carrier;
	level.scr_anim[ "carried" ][ "wounded_carry" ]			 = %wounded_carry_fastwalk_wounded;
	
	level.scr_anim[ "generic" ][ "cliff_guardA_flick" ]		= %cliff_guardA_flick;
		
	//one-off
	level.scr_anim[ "generic" ][ "unarmed_climb_wall" ]		= %unarmed_climb_wall;

	//walk cycles
	level.scr_anim[ "generic" ][ "civilian_walk_coffee" ][ 0 ]		= %civilian_walk_coffee;
	level.scr_anim[ "generic" ][ "civilian_walk_cool" ][ 0 ]		= %civilian_walk_cool;
	level.scr_anim[ "generic" ][ "patrol_bored_patrolwalk" ][ 0 ]		= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrolwalk_swagger" ][ 0 ]		= %patrolwalk_swagger;
	level.scr_anim[ "generic" ][ "civilian_walk_hurried_1" ][ 0 ]		= %civilian_walk_hurried_1;
	level.scr_anim[ "generic" ][ "civilian_crowd_behavior_A" ][ 0 ]		= %civilian_crowd_behavior_A;
	level.scr_anim[ "generic" ][ "civilian_crazywalker_loop" ][ 0 ]		= %civilian_crazywalker_loop;
	level.scr_anim[ "generic" ][ "civilian_cellphonewalk" ][ 0 ]		= %civilian_cellphonewalk;
	level.scr_anim[ "generic" ][ "civilian_briefcase_walk_shoelace" ][ 0 ]		= %civilian_briefcase_walk_shoelace;
	level.scr_anim[ "generic" ][ "civilian_sodawalk" ][ 0 ]		= %civilian_sodawalk;

	addNotetrack_customFunction( "generic", "footstep_right_large", ::bounce_fx );
	addNotetrack_customFunction( "generic", "footstep_left_large", ::bounce_fx );
	addNotetrack_customFunction( "generic", "footstep_right_small", ::bounce_fx );
	addNotetrack_customFunction( "generic", "footstep_left_small", ::bounce_fx );
	
	/*-----------------------
	JAVELIN BEHAVIOR
	-------------------------*/	
	//javelin_idle_A
	
	/*-----------------------
	HUMVEES COMING IN, WOUNDED
	-------------------------*/	
	//estate_chopper_sequence_body
	//estate_chopper_sequence_soldier
	
	/*-----------------------
	PIT
	-------------------------*/	
	level.scr_anim[ "dunn" ][ "training_pit_sitting_welcome" ]		= %training_pit_sitting_welcome;
	level.scr_anim[ "dunn" ][ "training_pit_sitting_idle" ][ 0 ]		= %training_pit_sitting_idle;
	//level.scr_sound[ "dunn" ][ "training_pit_sitting_idle" ][ 0 ]		= "scn_trainer_pit_sitting_idle";
	
	level.scr_anim[ "dunn" ][ "training_pit_stand_idle" ][ 0 ]		= %training_pit_stand_idle;
	//level.scr_sound[ "dunn" ][ "training_pit_stand_idle" ][ 0 ]		= "scn_trainer_pit_stand_idle";
	level.scr_anim[ "dunn" ][ "training_pit_open_case" ]				= %training_pit_open_case;
	
	addNotetrack_customFunction( "dunn", "dialog",::notetrack_dunn_welcome_dialogue_01, "training_pit_sitting_welcome" );
	addNotetrack_customFunction( "dunn", "dialog2",::notetrack_dunn_welcome_dialogue_02, "training_pit_sitting_welcome" );
	addNotetrack_customFunction( "dunn", "case_flip_01",::notetrack_dunn_case_flip_01, "training_pit_open_case" );
	addNotetrack_customFunction( "dunn", "case_flip_02",::notetrack_dunn_case_flip_02, "training_pit_open_case" );
	addNotetrack_customFunction( "dunn", "button_press",::notetrack_dunn_button_press, "training_pit_open_case" );
	addNotetrack_flag( "dunn", "dialog", "dunn_notetrack_open_case_dialogue", "training_pit_open_case" );

}

notetrack_dunn_welcome_dialogue_01( guy )
{
	flag_set( "dunn_dialogue_welcome_01" );
}

notetrack_dunn_welcome_dialogue_02( guy )
{
	flag_set( "dunn_dialogue_welcome_02" );
}

notetrack_dunn_case_flip_01( guy )
{
	flag_set( "case_flip_01" );
}

notetrack_dunn_case_flip_02( guy )
{
	flag_set( "case_flip_02" );
}

notetrack_dunn_button_press( guy )
{
	flag_set( "button_press" );
	self thread play_sound_in_space( "scn_training_fence_button" );
}

dialogue()
{
	/*-----------------------
	BASKETBALL NAGS
	-------------------------*/	
	//Ranger 2		Get off the court dude.	train_ar2_getoffcourt
	level.scr_sound[ "court_nag_00" ] = "train_ar2_getoffcourt";

	//Ranger 2		Come on man, wait your turn.	
	level.scr_sound[ "court_nag_01" ] = "train_ar2_waityourturn";

	//Ranger 2		Allen, what the hell?	
	level.scr_sound[ "court_nag_02" ] = "train_ar2_allenwhatthe";
	
	/*-----------------------
	RIFLE TRAINING START
	-------------------------*/	
	//Sgt. Foley	training	Welcome to pull-the-trigger 101. 	
	level.scr_sound[ "foley" ][ "train_fly_welcome" ] = "train_fly_welcome";

	//Afghan Translator	Welcome to weapons training.	
	level.scr_sound[ "translator" ][ "train_fly_welcome" ] = "train_aft_welcome";
	
	//Sgt. Foley	training	Pvt. Allen here is going to do a quick weapons demonstration to show you locals how its done.	
	level.scr_sound[ "foley" ][ "train_fly_demonstration" ] = "train_fly_demonstration";

	//Afghan Translator	This soldier is going to perform a weapons demonstration to show all of you how to fire a weapon accurately.	
	level.scr_sound[ "translator" ][ "train_fly_demonstration" ] = "train_aft_demonstration";
	
	//Sgt. Foley	training	No offense, but I see a lot of you guys firing from the hip and spraying bullets all over the range. 	
	level.scr_sound[ "foley" ][ "train_fly_nooffense" ] = "train_fly_nooffense";
	
	//Afghan Translator	I see many of you firing from the hip and spraying bullets all over the place. 	
	level.scr_sound[ "translator" ][ "train_fly_nooffense" ] = "train_aft_nooffense";
	
	//Sgt. Foley	training	You don't end up hitting a damn thing and it makes you look like an ass.	
	level.scr_sound[ "foley" ][ "train_fly_makesyoulook" ] = "train_fly_makesyoulook";

	//Afghan Translator	When you fire from the hip, you end up missing your targets and look incompetent while doing it.	
	level.scr_sound[ "translator" ][ "train_fly_makesyoulook" ] = "train_aft_makesyoulook";
	
	//Sgt. Foley	training	Private Allen, show 'em what I'm talking about.	
	level.scr_sound[ "foley" ][ "train_fly_showem" ] = "train_fly_showem";

	//Afghan Translator	The soldier will show you an example of this mistake.	
	//level.scr_sound[ "translator" ][ "train_fly_showem" ] = "train_aft_showem";
	
	//Sgt. Foley	training	Grab that weapon off the table and fire at some targets downrange.	
	level.scr_sound[ "foley" ][ "train_fly_fireattargets" ] = "train_fly_fireattargets";
	level.scr_face[ "foley" ][ "train_fly_fireattargets" ] = %train_fly_fireattargets;

	//Afghan Translator	Grab that weapon off the table and fire at some targets down range.	
	//level.scr_sound[ "translator" ][ "train_fly_fireattargets" ] = "train_aft_fireattargets";
	
	//Sgt. Foley	Turn around and fire at the targets.	
	level.scr_sound[ "foley" ][ "train_fly_turnaround" ] = "train_fly_turnaround";
	level.scr_face[ "foley" ][ "train_fly_turnaround" ] = %train_fly_turnaround;

	/*-----------------------
	FIRE FROM THE HIP
	-------------------------*/	
	//Sgt. Foley	training	Sgt. Foley	Private Allen, grab that weapon off the table and fire at the targets behind you.
	level.scr_sound[ "foley" ][ "nag_rifle_pickup_01" ] = "train_fly_grabthatweapon";

	//Sgt. Foley	training	Come on, Allen. Get with the program. Pick up that weapon and fire at the targets downrange. 	
	level.scr_sound[ "foley" ][ "nag_rifle_pickup_02" ] = "train_fly_comeonallen";

	//Sgt. Foley	training	Don't aim down the sight yet. I'm tryin' to make a point here. Just fire from the hip.	
	level.scr_sound[ "foley" ][ "nag_hip_fire_01" ] = "train_fly_dontaimdown";

	//Sgt. Foley	training	Fire from the hip, Private. Just like in the movies.	
	level.scr_sound[ "foley" ][ "nag_hip_fire_02" ] = "train_fly_firefromthehip";
	
	//Let's try a few more.	
	level.scr_sound[ "foley" ][ "train_fly_tryafew" ] = "train_fly_tryafew";

	//Sgt. Foley	training	Everyone pay attention. You must remember to change magazines when you run out of ammo.	
	//level.scr_sound[ "foley" ][ "train_fly_payattention" ] = "train_fly_payattention";

	//Afghan Translator	Everyone pay attention. You must remember to reload when you run out of ammo.	
	//level.scr_sound[ "translator" ][ "train_aft_payattention" ] = "train_aft_payattention";
	
	//Sgt. Foley	training	Reload your weapon, Private.	
	//level.scr_sound[ "foley" ][ "train_fly_reload" ] = "train_fly_reload";

	//Sgt. Foley	training	What are you waiting for? Reload your weapon. 	
	//level.scr_sound[ "foley" ][ "train_fly_waitingfor" ] = "train_fly_waitingfor";

	/*-----------------------
	ADS WHILE CROUCHED
	-------------------------*/	
	//Sgt. Foley	training	See what I mean? He sprayed bullets all over the damn place.	
	level.scr_sound[ "foley" ][ "train_fly_sprayedbullets" ] = "train_fly_sprayedbullets";

	//Afghan Translator	See what I mean? He sprayed bullets all over the damn place.	
	level.scr_sound[ "translator" ][ "train_fly_sprayedbullets" ] = "train_aft_sprayedbullets";

	//Sgt. Foley	training	You've got to pick your targets by aiming deliberately down your sights from a stable stance.	
	level.scr_sound[ "foley" ][ "train_fly_pickyourtargets" ] = "train_fly_pickyourtargets";

	//Afghan Translator	You've got to pick your targets by aiming deliberately down your sights from a stable stance.	
	level.scr_sound[ "translator" ][ "train_fly_pickyourtargets" ] = "train_aft_pickyourtargets";
	
	//Sgt. Foley	training	Private Allen, show our friends here how the Rangers take down a target. 	
	level.scr_sound[ "foley" ][ "train_fly_howtherangers" ] = "train_fly_howtherangers";
	level.scr_face[ "foley" ][ "train_fly_howtherangers" ] = %train_fly_howtherangers;
	
	//Afghan Translator	The soldier will now demonstrate how the Rangers shoot at a target. 	
	level.scr_sound[ "translator" ][ "train_fly_howtherangers" ] = "train_aft_howtherangers";
	
	//Sgt. Foley	training	Crouch first, and then aim down your sight at the targets.	
	level.scr_sound[ "foley" ][ "train_fly_crouchfirst" ] = "train_fly_crouchfirst";

	//Afghan Translator	Crouch first, and then aim down your sight at the targets.	
	level.scr_sound[ "translator" ][ "train_fly_crouchfirst" ] = "train_aft_crouchfirst";
	
	//Sgt. Foley	training	Private Allen, aim down your sights before engaging the target.	
	level.scr_sound[ "foley" ][ "nag_ads_fire_01" ] = "train_fly_beforeengaging";

	//Sgt. Foley	training	Don't forget to aim down your sights, Private.	
	level.scr_sound[ "foley" ][ "nag_ads_fire_02" ] = "train_fly_dontforget";

	//Sgt. Foley	training	Allen, adopt a crouching stance and aim down your sights.	
	level.scr_sound[ "foley" ][ "nag_crouch_fire_01" ] = "train_fly_crouchingstance";

	//Sgt. Foley	training	I need to you fire while crouched, Private.	
	level.scr_sound[ "foley" ][ "nag_crouch_fire_02" ] = "train_fly_crouched";
	
	//Sgt. Foley	5	12	Now that's how you do it. You want to take down your targets quickly and with control.	
	level.scr_sound[ "foley" ][ "train_fly_howyoudoit" ] = "train_fly_howyoudoit";

	/*-----------------------
	ADS WHILE PRONE
	-------------------------*/	
	//Sgt. Foley	training	That's all there is to it. You want your target to go down? You gotta aim down your sights.	
	level.scr_sound[ "foley" ][ "train_fly_gottaaim" ] = "train_fly_gottaaim";

	//Afghan Translator	It is that simple. Do you want to hit your target or not? You must aim using the sights on your weapons.	
	level.scr_sound[ "translator" ][ "train_fly_gottaaim" ] = "train_aft_gottaaim";
	
	//Sgt. Foley	training	Your accuracy will increase if you are crouched or prone on the ground. 	
	//level.scr_sound[ "foley" ][ "train_fly_accuracy" ] = "train_fly_accuracy";
	
	//Afghan Translator	Your accuracy will increase if you are crouched or lying prone on the ground. 	
	//level.scr_sound[ "translator" ][ "train_aft_accuracy" ] = "train_aft_accuracy";

	//Sgt. Foley	training	Private Allen will demonstrate what I'm talking about.	
	//level.scr_sound[ "foley" ][ "train_fly_willdemonstrate" ] = "train_fly_willdemonstrate";

	//Afghan Translator	The soldier will demonstrate what I'm talking about.	
	//level.scr_sound[ "translator" ][ "train_aft_willdemonstrate" ] = "train_aft_willdemonstrate";
	
	//Sgt. Foley	training	Private Allen, go prone and take out a few more targets.	
	//level.scr_sound[ "foley" ][ "train_fly_goprone" ] = "train_fly_goprone";

	//Afghan Translator	The soldier will now go prone and shoot a few more targets to demonstrate.	
	//level.scr_sound[ "translator" ][ "train_aft_goprone" ] = "train_aft_goprone";
	
	//Sgt. Foley	training	Fire from the prone position, Private.	
	//level.scr_sound[ "foley" ][ "train_fly_firefromprone" ] = "train_fly_firefromprone";

	//Sgt. Foley	training	Private, I need you to fire from the prone position.	
	//level.scr_sound[ "foley" ][ "train_fly_needyoutofire" ] = "train_fly_needyoutofire";

	/*-----------------------
	TIMED ADS - SWITCHING TARGETS
	-------------------------*/	
	//Sgt. Foley	training	Aiming down your sights also works for switching quickly between targets. 	
	level.scr_sound[ "foley" ][ "train_fly_switching" ] = "train_fly_switching";

	//Afghan Translator	Aiming down your sights also works for switching quickly between targets. 	
	level.scr_sound[ "translator" ][ "train_fly_switching" ] = "train_aft_switching";
	
	//Sgt. Foley	training	Aim down your sights, then pop in and out to acquire new targets. 	
	level.scr_sound[ "foley" ][ "train_fly_popinandout" ] = "train_fly_popinandout";
	level.scr_face[ "foley" ][ "train_fly_popinandout" ] = %train_fly_popinandout;

	//Afghan Translator	Aim down your sights, then pop in and out to acquire new targets. 	
	level.scr_sound[ "translator" ][ "train_fly_popinandout" ] = "train_aft_popinandout";
	
	//Sgt. Foley	training	Show 'em Private.	
	level.scr_sound[ "foley" ][ "train_fly_showemprivate" ] = "train_fly_showemprivate";
	level.scr_face[ "foley" ][ "train_fly_showemprivate" ] = %train_fly_showemprivate;
	
	//Sgt. Foley	training	If your target is close to where you are aiming, you can snap to it quickly by quickly aiming down your sights.	
	level.scr_sound[ "foley" ][ "train_fly_iftargetclose" ] = "train_fly_iftargetclose";

	//Afghan Translator	If your target is close to where you are aiming, you can snap to it quickly by quickly aiming down your sights.	
	level.scr_sound[ "translator" ][ "train_fly_iftargetclose" ] = "train_aft_iftargetclose";

	/*-----------------------
	TIMED ADS - FAILED - TOO SLOW
	-------------------------*/	
	//Sgt. Foley	training	That was too slow. You need engage and release your aim quickly to snap to new targets
	level.scr_sound[ "foley" ][ "timed_ads_too_slow_00" ] = "train_fly_tooslow";

	//Sgt. Foley	training	Too slow. Private Allen, you need to quickly pop in and out of aiming down your sights to snap to new targets.
	level.scr_sound[ "foley" ][ "timed_ads_too_slow_01" ] = "train_fly_acquirenew";

	//Sgt. Foley	training	Do it again and speed it up. Show these men how to snap to new targets by quickly popping in and out of aiming down your sights.
	level.scr_sound[ "foley" ][ "timed_ads_too_slow_02" ] = "train_fly_poppinginandout";

	/*-----------------------
	TIMED ADS - FAILED - NOT SNAPPING
	-------------------------*/	
	//Sgt. Foley	training	Do it again. You can snap to new targets by quickly engaging and releasing your aim.
	level.scr_sound[ "foley" ][ "timed_ads_not_snapping_00" ] = "train_fly_speeditup";
	
	//Private Allen, you're not snapping to your targets. You need to quickly engage and release aiming down the sight to snap to new targets.	
	level.scr_sound[ "foley" ][ "timed_ads_not_snapping_01" ] = "train_fly_notsnapping";

	//Private Allen, you're doing it wrong. Quickly engage and release aiming down the sight to snap to new targets.	
	level.scr_sound[ "foley" ][ "timed_ads_not_snapping_02" ] = "train_fly_doingitwrong";
	
	/*-----------------------
	TIMED ADS - NOT SNAPPING NAGS
	-------------------------*/	
	//Private Allen, aim down your sights to snap to the target.	
	level.scr_sound[ "foley" ][ "nag_ads_snap_01" ] = "train_fly_aimtosnap";
	
	//Don't forget to aim down your sights.	
	level.scr_sound[ "foley" ][ "nag_ads_snap_02" ] = "train_fly_forgettoaim";
	
	//You're firing from the hip, Private. Snap to the target by aiming down your sights	
	level.scr_sound[ "foley" ][ "nag_ads_snap_03" ] = "train_fly_fromthehip";
	
	//You're not aiming properly, Private. Snap to the targets by aiming down your sights.	
	level.scr_sound[ "foley" ][ "nag_ads_snap_04" ] = "train_fly_notaimingprop";

	
	/*-----------------------
	BULLET PENETRATION
	-------------------------*/	
	//Sgt. Foley	training	Now if your target is behind light cover, remember that certain weapons can penetrate and hit your target.	
	level.scr_sound[ "foley" ][ "train_fly_lightcover" ] = "train_fly_lightcover";
	level.scr_face[ "foley" ][ "train_fly_lightcover" ] = %train_fly_lightcover;

	//Afghan Translator	Now if your target is behind a thin wall, remember that certain weapons can penetrate and hit your target.	
	level.scr_sound[ "translator" ][ "train_fly_lightcover" ] = "train_aft_lightcover";

	
	//Sgt. Foley	training	The Private here will demonstrate.	
	level.scr_sound[ "foley" ][ "train_fly_theprivatehere" ] = "train_fly_theprivatehere";
	level.scr_face[ "foley" ][ "train_fly_theprivatehere" ] = %train_fly_theprivatehere;
	
	//Afghan Translator	This soldier will demonstrate.	
	level.scr_sound[ "translator" ][ "train_fly_theprivatehere" ] = "train_aft_theprivatehere";
	
	//Sgt. Foley	training	Private, hit the target through the wood panel.	
	level.scr_sound[ "foley" ][ "nag_penetration_fire_01" ] = "train_fly_woodpanel";
	level.scr_face[ "foley" ][ "nag_penetration_fire_01" ] = %train_fly_woodpanel;

	//Sgt. Foley	training	Private Allen, hit the target through the wood panel.	
	level.scr_sound[ "foley" ][ "nag_penetration_fire_02" ] = "train_fly_allenwoodpanel";

	/*-----------------------
	FRAG TRAINING
	-------------------------*/	
	//Sgt. Foley	training	Last but not least, you need to know how to toss a frag grenade.	
	level.scr_sound[ "foley" ][ "train_fly_tossafrag" ] = "train_fly_tossafrag";

	//Afghan Translator	Last but not least, you need to know how to toss a hand grenade.	
	level.scr_sound[ "translator" ][ "train_fly_tossafrag" ] = "train_aft_tossafrag";
	
	//Sgt. Foley	training	Private Allen, pick up some frag grenades from the table.	
	level.scr_sound[ "foley" ][ "train_fly_pickupfrag" ] = "train_fly_pickupfrag";
	level.scr_face[ "foley" ][ "train_fly_pickupfrag" ] = %train_fly_pickupfrag;

	//Sgt. Foley	training	Toss a grenade down range to take out several targets at once.	
	level.scr_sound[ "foley" ][ "train_fly_grenadedownrange" ] = "train_fly_grenadedownrange";
	level.scr_face[ "foley" ][ "train_fly_grenadedownrange" ] = %train_fly_grenadedownrange;

	//Sgt. Foley	training	Sgt. Foley	Note that frags tend to roll on sloped surfaces. So think twice before tossing one up hill.	
	level.scr_sound[ "foley" ][ "train_fly_fragstendtoroll" ] = "train_fly_fragstendtoroll";
	level.scr_face[ "foley" ][ "train_fly_fragstendtoroll" ] = %train_fly_fragstendtoroll;
	 

	//Afghan Translator	7	12	Note that frags tend to roll on sloped surfaces. So think twice before tossing one up hill.	
	level.scr_sound[ "translator" ][ "train_fly_fragstendtoroll" ] = "train_aft_fragstendtoroll";

	//Afghan Translator	This soldier here will throw a grenade to take out several targets at once.	
	level.scr_sound[ "translator" ][ "train_fly_grenadedownrange" ] = "train_aft_grenadedownrange";

	/*-----------------------
	FOLEY FRAG NAGS
	-------------------------*/	
	//****TODO - REPLACE WITH REAL DIALOGUE
	//Sgt. Foley     Let's go, Private. Pick up some of the frag grenades from the table
	//Sgt. Foley      Grab some frags from the table, Private
	//Sgt. Foley       Private Allen, you need to pick up some frags from the table to complete this demonstration
	
	
	
	//Sgt. Foley	training	Private, throw a grenade and take out those targets.	
	level.scr_sound[ "foley" ][ "frag_nag_00" ] = "train_fly_throwagrenade";

	//Sgt. Foley	training	Private, let's go. Throw a grenade at the targets!	
	level.scr_sound[ "foley" ][ "frag_nag_01" ] = "train_fly_letsgothrow";

	//Sgt. Foley	training	Toss a grenade down range to take out several targets at once.	
	level.scr_sound[ "foley" ][ "frag_nag_02" ] = "train_fly_grenadedownrange";
	
	//Sgt. Foley	training	That's not good enough, Private. You need to land the grenade closer to the target.	
	//level.scr_sound[ "foley" ][ "train_fly_notgoodenough" ] = "train_fly_notgoodenough";

	//Sgt. Foley	training	You're a Ranger, Private. I know you can get the grenade closer to the target than that, huah?	
	//level.scr_sound[ "foley" ][ "train_fly_yourearanger" ] = "train_fly_yourearanger";

	//Sgt. Foley	Good.	
	level.scr_sound[ "foley" ][ "train_fly_good" ] = "train_fly_good";

	/*-----------------------
	GET TO OBJECTIVE
	-------------------------*/	
	//Sgt. Foley	training	Thanks for the help, Private Allen. Now get over to The Pit...Colonel Shepherd wants to see you run the course.	
	level.scr_sound[ "foley" ][ "train_fly_thanksforhelp" ] = "train_fly_thanksforhelp";

	//Sgt. Foley	training	All right, who here wants to go first? Show me what you've learned so far.	
	level.scr_sound[ "foley" ][ "train_fly_gofirst" ] = "train_fly_gofirst";
	
	//Afghan Translator	All right, who here wants to go first? Show me what you've learned so far.	
	level.scr_sound[ "translator" ][ "train_fly_gofirst" ] = "train_aft_gofirst";


	/*-----------------------
	CQB COURSE
	-------------------------*/	
	
	//Cpl. Dunn	training	Hey Private. Welcome back to The Pit. 	
	level.scr_sound[ "dunn" ][ "train_cpd_welcomeback" ] = "train_cpd_welcomeback";

	//Cpl. Dunn	training	I hear Colonel Shepherd wants to pull a shooter from our unit for some special op - he's watching from the tower up there.	
	level.scr_sound[ "dunn" ][ "train_cpd_specialop" ] = "train_cpd_specialop";

	//Cpl. Dunn	training	Go ahead and grab a pistol. 	
	level.scr_sound[ "dunn" ][ "train_cpd_grabapistol" ] = "train_cpd_grabapistol";
	level.scr_face[ "dunn" ][ "train_cpd_grabapistol" ] = %train_cpd_grabapistol;

	//Cpl. Dunn	OK. So you already have your side arm.   	
	level.scr_sound[ "dunn" ][ "train_cpd_alreadyhave" ] = "train_cpd_alreadyhave";
	
	//Cpl. Dunn	training	Alright, try switching to your rifle
	level.scr_sound[ "dunn" ][ "train_cpd_switchtorifle" ] = "train_cpd_switchtorifle";
	level.scr_face[ "dunn" ][ "train_cpd_switchtorifle" ] = %train_cpd_switchtorifle;

	//Cpl. Dunn	training	Good. Switch to your sidearm again.	
	level.scr_sound[ "dunn" ][ "train_cpd_switchtosidearm" ] = "train_cpd_switchtosidearm";
	level.scr_face[ "dunn" ][ "train_cpd_switchtosidearm" ] = %train_cpd_switchtosidearm;
	
	//Cpl. Dunn	Do me a favor and try switching to your sidearm.	
	level.scr_sound[ "dunn" ][ "train_cpd_tryswitching" ] = "train_cpd_tryswitching";
	
	//Cpl. Dunn	training	You see how switching to your pistol is always faster than reloading?	
	level.scr_sound[ "dunn" ][ "train_cpd_alwaysfaster" ] = "train_cpd_alwaysfaster";
	level.scr_face[ "dunn" ][ "train_cpd_alwaysfaster" ] = %train_cpd_alwaysfaster;
	
	//Cpl. Dunn	training	Ok, grab any weapon you like and head on in. Timer starts as soon as the first target pops.	
	//level.scr_sound[ "dunn" ][ "train_cpd_anyweapon" ] = "train_cpd_anyweapon";

	//Cpl. Dunn	Smile for the cameras and don't miss.. Shepard and the rest of the brass are scouting for a shooter for some special op.	
	level.scr_sound[ "dunn" ][ "train_cpd_smileforcameras" ] = "train_cpd_smileforcameras";

	/*-----------------------
	GET INTO THE PIT NAGS
	-------------------------*/	
	//Cpl. Dunn	Ok, head on in. Timer starts as soon as the first target pops.	
	level.scr_sound[ "dunn" ][ "train_cpd_timerstarts" ] = "train_cpd_timerstarts";
	level.scr_face[ "dunn" ][ "train_cpd_timerstarts" ] = %train_cpd_timerstarts;

	//Cpl. Dunn	training	Private Allen, we don't have all day. Get in The Pit.	
	level.scr_sound[ "dunn" ][ "train_cpd_donthaveallday" ] = "train_cpd_donthaveallday";
	level.scr_face[ "dunn" ][ "train_cpd_donthaveallday" ] = %train_cpd_donthaveallday;

	//Cpl. Dunn	training	You're gonna get us both in trouble with the Colonel man. Get in The Pit and run the course.	
	level.scr_sound[ "dunn" ][ "train_cpd_bothintrouble" ] = "train_cpd_bothintrouble";
	

	//Cpl. Dunn	I don't know why they won't put us in first, Allen.	
	level.scr_sound[ "dunn" ][ "train_cpd_putusin" ] = "train_cpd_putusin";
	level.scr_face[ "dunn" ][ "train_cpd_putusin" ] = %train_cpd_putusin;
	
	//Cpl. Dunn	There ain't much the Rangers can't do that SF and Delta can...but...(snorts) whatever man. That's SOCOM brass for ya.	
	level.scr_sound[ "dunn" ][ "train_cpd_socombrass" ] = "train_cpd_socombrass";
	level.scr_face[ "dunn" ][ "train_cpd_socombrass" ] = %train_cpd_socombrass;
	
	//Cpl. Dunn	And all those frickin' blocking positions. When are we gonna see some real action instead of babysitting Seals and D-boys, huah?	
	level.scr_sound[ "dunn" ][ "train_cpd_realaction" ] = "train_cpd_realaction";
	level.scr_face[ "dunn" ][ "train_cpd_realaction" ] = %train_cpd_realaction;
	
	//Cpl. Dunn	<sigh, sentiment is 'same shit different day/what else is new > 	
	level.scr_sound[ "dunn" ][ "train_cpd_sigh" ] = "train_cpd_sigh";

	/*-----------------------
	PIT DIALOGUE
	-------------------------*/	
	//Cpl. Dunn	Clear the area!
	level.scr_radio[ "train_cpd_clearthearea" ] = "train_cpd_clearthearea";
	
	//Cpl. Dunn	Clear the first area. Go! Go! Go!
	level.scr_radio[ "train_cpd_clearfirstgogogo" ] = "train_cpd_clearfirstgogogo";
	
	//Cpl. Dunn	Area cleared! Move into the building!
	level.scr_radio[ "train_cpd_areacleared" ] = "train_cpd_areacleared";
	
	//Cpl. Dunn	Up the stairs!
	level.scr_radio[ "train_cpd_upthestairs" ] = "train_cpd_upthestairs";
	
	//Cpl. Dunn	Last area! Move! Move!
	level.scr_radio[ "train_cpd_lastareamove" ] = "train_cpd_lastareamove";
	
	//Cpl. Dunn	Just switch to your other weapon! It's faster than reloading!
	level.scr_radio[ "train_cpd_justswitch" ] = "train_cpd_justswitch";

	//Cpl. Dunn	You missed some targets, just keep moving	
	level.scr_radio[ "train_cpd_missedsome" ] = "train_cpd_missedsome";

	//Cpl. Dunn	You left targets in the last area, just keep moving	
	level.scr_radio[ "train_cpd_lefttargets" ] = "train_cpd_lefttargets";

	//Cpl. Dunn	training	Watch out for civilians.	
	level.scr_radio[ "train_cpd_watchout" ] = "train_cpd_watchout";

	//Cpl. Dunn	training	Aww you killed a civvie. Come on, Allen!	
	level.scr_radio[ "train_cpd_awwkilled" ] = "train_cpd_awwkilled";

	//Cpl. Dunn	training	That was a civilian, Private.	
	level.scr_radio[ "train_cpd_acivilian" ] = "train_cpd_acivilian";

	//Cpl. Dunn	training	Melee with your knife!	
	level.scr_radio[ "train_cpd_melee" ] = "train_cpd_melee";

	//Cpl. Dunn	training	Crouch under the obstacle and keep moving!	
	//level.scr_radio[ "train_cpd_crouch" ] = "train_cpd_crouch";

	//Cpl. Dunn	training	Jump down and head for the exit!	
	level.scr_radio[ "train_cpd_jumpdown" ] = "train_cpd_jumpdown";

	//Cpl. Dunn	training	Sprint to the exit! Clock's ticking!	
	level.scr_radio[ "train_cpd_sprint" ] = "train_cpd_sprint";

	
	/*-----------------------
	DUNN MELEE NAGS
	-------------------------*/	
	
	//Cpl. Dunn	training	Melee with your knife!	
	level.scr_radio[ "melee_nag_00" ] = "train_cpd_melee";

	//Cpl. Dunn  You need to use your knife, Allen
	level.scr_radio[ "melee_nag_01" ] = "train_cpd_needtouseknife";
	
	//Cpl. Dunn     No bullets, Private, use your knife for that target
	level.scr_radio[ "melee_nag_02" ] = "train_cpd_nobullets";
	
	//Cpl. Dunn     Melee that target, Private
	level.scr_radio[ "melee_nag_03" ] = "train_cpd_meleethattarget";
	
	//Cpl. Dunn     Use your knife!
	level.scr_radio[ "melee_nag_04" ] = "train_cpd_useyourknife";

	/*-----------------------
	DUNN ADS NAGS
	-------------------------*/	
	//Cpl. Dunn     Stop firing from the hip! Aim down your sights!	
	level.scr_radio[ "pit_ads_nag_00" ] = "train_cpd_stopfiringfromhip";
	
	//Cpl. Dunn     Aim down your sights, Private!	
	level.scr_radio[ "pit_ads_nag_01" ] = "train_cpd_aimsightsprivate";

	//Cpl. Dunn     You need to aim down your sights, Allen!	
	level.scr_radio[ "pit_ads_nag_02" ] = "train_cpd_needtoaim";
	
	//Cpl. Dunn     Stop firing from the hip! Aim down your sights!	
	//level.scr_radio[ "pit_ads_nag_02" ] = "train_cpd_stopfiringfromhip2";

	/*-----------------------
	DUNN MOVE FORWARD NAGS
	-------------------------*/	

	//Cpl. Dunn	Move! This is a timed course!
	level.scr_radio[ "nag_hurry_00" ] = "train_cpd_timedcourse";
	
	//Cpl. Dunn	Keep moving forward!
	level.scr_radio[ "nag_hurry_01" ] = "train_cpd_movingforward";
	
	//Cpl. Dunn     Keep moving forward! Go! Go! Go!
	level.scr_radio[ "nag_hurry_02" ] = "train_cpd_movingforwardgo";
	
	//Cpl. Dunn     Move! Move! You're running out of time!
	level.scr_radio[ "nag_hurry_03" ] = "train_cpd_runningoutoftime";
	
	//Cpl. Dunn     Let's go! Move up! This is a timed course, Private
	level.scr_radio[ "nag_hurry_04" ] = "train_cpd_timedcourse2";

	
	/*-----------------------
	DUNN SPRINT NAGS - FAIL, TRY AGAIN
	-------------------------*/	
	
	//Cpl. Dunn     You need to sprint to complete the course. Go back to the red circle and try again
	level.scr_radio[ "nag_didnt_sprint_00" ] = "train_cpd_needtosprint";
	
	//Cpl. Dunn     You didn't sprint, Private. Go back to the red circle and sprint to the exit.
	level.scr_radio[ "nag_didnt_sprint_01" ] = "train_cpd_didntsprint";
	
	//Cpl. Dunn     You need to sprint, Private. Go back to the red circle and sprint to the end.
	level.scr_radio[ "nag_didnt_sprint_02" ] = "train_cpd_gobackandsprint";
	
	//Cpl. Dunn     You can't finish till you sprint, Allen. Go back to the red circle and sprint to the end.
	level.scr_radio[ "nag_didnt_sprint_03" ] = "train_cpd_cantfinishsprint";
	
	/*-----------------------
	DUNN SPRINT NAGS - GO GO GO
	-------------------------*/	
	//Cpl. Dunn     Go! Sprint to the exit!
	level.scr_radio[ "nag_sprint_00" ] = "train_cpd_sprinttoexit";
	
	//Cpl. Dunn     Move! Sprint, Private!
	level.scr_radio[ "nag_sprint_01" ] = "train_cpd_movesprint";
	
	//Cpl. Dunn     Sprint, Allen! Go! Go! Go!
	level.scr_radio[ "nag_sprint_02" ] = "train_cpd_sprintallengogogo";
	
	//Cpl. Dunn     Now sprint to the exit! Move! Move! Move!
	level.scr_radio[ "nag_sprint_03" ] = "train_cpd_nowsprint";

	/*-----------------------
	END OF PIT DIALOGUE
	-------------------------*/	
	//Cpl. Dunn	You took out too many targets with your knife. Try again, this time, with bullets.	
	level.scr_sound[ "dunn" ][ "train_cpd_targetswithknife" ] = "train_cpd_targetswithknife";
	
	//Cpl. Dunn	training	Not good enough, Allen. You took too long and killed too many civilians. Try it again.	
	level.scr_sound[ "dunn" ][ "train_cpd_longandcivilians" ] = "train_cpd_longandcivilians";

	//Cpl. Dunn	training	Not good enough, Allen. You took too long and missed too many targets. Try it again.	
	level.scr_sound[ "dunn" ][ "train_cpd_longandtargets" ] = "train_cpd_longandtargets";

	//Cpl. Dunn	training	Not good enough, Allen. You missed too many targets. Try it again.	
	level.scr_sound[ "dunn" ][ "train_cpd_targets" ] = "train_cpd_targets";

	//Cpl. Dunn	training	Not good enough, Allen. You killed too many civilians. Try it again.	
	level.scr_sound[ "dunn" ][ "train_cpd_civilians" ] = "train_cpd_civilians";

	//Cpl. Dunn	Too damn slow. You need to run it again, Private.	
	level.scr_sound[ "dunn" ][ "train_cpd_needtorunagain" ] = "train_cpd_needtorunagain";
	
	//Cpl. Dunn	Alright. Head back in and give it another go.	
	level.scr_sound[ "dunn" ][ "train_cpd_anothergo" ] = "train_cpd_anothergo";
	level.scr_face[ "dunn" ][ "train_cpd_anothergo" ] = %train_cpd_anothergo;

	//Cpl. Dunn	Alright. Head upstairs and regroup with the others	
	level.scr_sound[ "dunn" ][ "train_cpd_headupstairs" ] = "train_cpd_headupstairs";
	level.scr_face[ "dunn" ][ "train_cpd_headupstairs" ] = %train_cpd_headupstairs;
	
	//Cpl. Dunn	training	You can run the course again or regroup with the others by the main gate.	
	level.scr_sound[ "dunn" ][ "train_cpd_runagain" ] = "train_cpd_runagain";
	level.scr_face[ "dunn" ][ "train_cpd_runagain" ] = %train_cpd_runagain;
	
	/*-----------------------
	END OF PIT DIFFICULTY SELECTION
	-------------------------*/	
	
	//EASY
	//Cpl. Dunn	training	Not bad. Looks like you're getting a little sloppy though.	
	level.scr_sound[ "dunn" ][ "end_of_course_easy_01" ] = "train_cpd_sloppy";
	level.scr_face[ "dunn" ][ "train_cpd_sloppy" ] = %train_cpd_sloppy;

	//Cpl. Dunn	Alright I guess. You need some serious polish though.	
	level.scr_sound[ "dunn" ][ "end_of_course_easy_02" ] = "train_cpd_alrgihtiguess";
	level.scr_face[ "dunn" ][ "end_of_course_easy_02" ] = %train_cpd_alrgihtiguess;
	
	//Cpl. Dunn	Good enough, but you're getting a little sloppy.	
	level.scr_sound[ "dunn" ][ "end_of_course_easy_03" ] = "train_cpd_goodenough";
	level.scr_face[ "dunn" ][ "end_of_course_easy_03" ] = %train_cpd_goodenough;

	//REGULAR
	//Cpl. Dunn	training	I've seen worse. You've got a few rough edges though.	
	level.scr_sound[ "dunn" ][ "end_of_course_reg_01" ] = "train_cpd_roughedges";
	level.scr_face[ "dunn" ][ "end_of_course_reg_01" ] = %train_cpd_roughedges;
	
	//Cpl. Dunn	That wasn't horrible, but it wasn't amazing either.	
	level.scr_sound[ "dunn" ][ "end_of_course_reg_02" ] = "train_cpd_wasnthorrible";
	level.scr_face[ "dunn" ][ "end_of_course_reg_02" ] = %train_cpd_wasnthorrible;
	
	//Cpl. Dunn	You look ok out there, but you still need some work.	
	level.scr_sound[ "dunn" ][ "end_of_course_reg_03" ] = "train_cpd_lookok";
	level.scr_face[ "dunn" ][ "end_of_course_reg_03" ] = %train_cpd_lookok;
	
	//HARDENED
	//Cpl. Dunn	training	Good, man, very good. You've still got it.	
	level.scr_sound[ "dunn" ][ "end_of_course_hard_01" ] = "train_cpd_stillgotit";
	level.scr_face[ "dunn" ][ "end_of_course_hard_01" ] = %train_cpd_stillgotit;
	
	//Cpl. Dunn	That was pretty damn good. Nice work, Allen.	
	level.scr_sound[ "dunn" ][ "end_of_course_hard_02" ] = "train_cpd_prettygood";
	level.scr_face[ "dunn" ][ "end_of_course_hard_02" ] = %train_cpd_prettygood;
	
	//Cpl. Dunn	Very nice. Run like a true professional.	
	level.scr_sound[ "dunn" ][ "end_of_course_hard_03" ] = "train_cpd_verynice";
	level.scr_face[ "dunn" ][ "end_of_course_hard_03" ] = %train_cpd_verynice;

	//VETERAN
	//Cpl. Dunn	training	Very impressive, man! You made that course your bitch!	
	level.scr_sound[ "dunn" ][ "end_of_course_vet_01" ] = "train_cpd_veryimpressive";
	level.scr_face[ "dunn" ][ "end_of_course_vet_01" ] = %train_cpd_veryimpressive;
	
	//Cpl. Dunn	Amazing work. Now that's how you run The Pit.	
	level.scr_sound[ "dunn" ][ "end_of_course_vet_02" ] = "train_cpd_amazingwork";
	level.scr_face[ "dunn" ][ "end_of_course_vet_02" ] = %train_cpd_amazingwork;
	
	/*-----------------------
	ENDING SEQUENCE
	-------------------------*/	
	//Overlord (HQ Radio)	training	All Hunter units, get to your victors. We're headed out.	
	level.scr_radio[ "train_hqr_headedout" ] = "train_hqr_headedout";

	//Sgt. Foley	training	Everyone get to your vehicles! We're moving out!	
	level.scr_sound[ "foley" ][ "train_fly_movingout" ] = "train_fly_movingout";

	//Ranger 2	training	They blew the damn bridge! We gotta move!	
	level.scr_sound[ "generic" ][ "train_ar2_blewthebridge" ] = "train_ar2_blewthebridge";

	//Ranger 1	training	BCT One is trapped across the river in the red zone! We've lost contact!	
	level.scr_sound[ "generic" ][ "train_ar1_trapped" ] = "train_ar1_trapped";

	//Ranger 1	training	Come on Allen!	
	//level.scr_sound[ "generic" ][ "train_ar1_comeon" ] = "train_ar1_comeon";
	
	
	
	
	

	//Yeah that guy was my C. O.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_myco";
	
	//Yeah he got taken out.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_takenout";		
	
	//Yeah you should see my truck, I got a dually.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_truck";		
	
	//Yeah, I can haul… pretty big loads.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_canhaul";		
	
	//Dude you love big loads.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_lovebigloads";		
	
	//I'm joking!  Everybody take it easy.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_joking";		
	
	//There are times when I wake up in the morning and think... You know what?  I could probably dodge bullets… like that movie.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_dodgebullets";		
	
	//No, not that movie, the one with the….	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_notthatmovie";		
	
	//… yeah "Cats and Dogs".	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_catsanddogs";		
	
	//Dude you know what's great about this place?  Nobody minds if you're high.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_nobodyminds";		
	
	//Nobody can tell if your high if you're wearing shades, that's the whole point of shades.	
	//level.scr_sound[ "conversation_xx" ][ xx ] = "train_ar4_shades";		





	/*-----------------------
	RANDOM CONVERSATIONS #1
	-------------------------*/	
	//Ranger 3	training	14	3	Hey man, you get the word? Boon bugged out.	
	level.scr_sound[ "conversation_01" ][ 0 ] = "train_ar3_boonbugged";
	
	//Ranger 4	training	14	4	AWOL? Man he's going to miss the party.	
	level.scr_sound[ "conversation_01" ][ 1 ] = "train_ar4_awol";

	//Ranger 2	Get those letters? See those letters?	
	level.scr_sound[ "conversation_01" ][ 2 ] = "train_ar2_getthoseletters";
	
	//Ranger 5	training	14	5	Yeah word came down from the Captain in G-2. 	
	level.scr_sound[ "conversation_01" ][ 3 ] = "train_ar5_wordcame";

	//Ranger 2	I ain't worried about them mines… worried about them damn camel spiders.	
	level.scr_sound[ "conversation_01" ][ 4 ] = "train_ar2_camelspiders";
	
	//Ranger 1	training	14	1	Yeah, maybe if we had some batteries for our PEQ-4's (pr. Peck fours) we wouldn't be in this situation.	
	level.scr_sound[ "conversation_01" ][ 5 ] = "train_ar1_somebatteries";
	
	//Ranger 2	training	14	2	Supply company coming in at oh eight hundred...	
	level.scr_sound[ "conversation_01" ][ 6 ] = "train_ar2_0800";
	
	//Ranger 1	training	14	6	Fine, but don't push our luck. I've got the Sergeant-Major up my ass about this.	
	level.scr_sound[ "conversation_01" ][ 7 ] = "train_ar1_pushourluck";

	//Man you shoot like a girl.  Look at you.	
	level.scr_sound[ "conversation_01" ][ 8 ] = "train_ar4_likeagirl";		
	
	//Look how you hold your gun.  You look like you're in the civil war.	
	level.scr_sound[ "conversation_01" ][ 9 ] = "train_ar4_holdgun";		

	//Ranger 2	training	14	7	Gotta secure that turret plating before we roll out. 	
	level.scr_sound[ "conversation_01" ][ 10 ] = "train_ar2_secureturret";
	
	//Ranger 3	training	14	8	Roger that, Sar-Major.	
	level.scr_sound[ "conversation_01" ][ 11 ] = "train_ar3_sarmajor";

	//Ranger 2	It's the one bad thing about being up front- no women.	
	level.scr_sound[ "conversation_01" ][ 12 ] = "train_ar2_nowomen";
	
	//Ranger 2	Who's got watch tonight?	
	level.scr_sound[ "conversation_01" ][ 13 ] = "train_ar2_watchtonight";
	
	//Ranger 5	training	14	15	BCT-1 rolled out at oh-four hundred across the bridge.	
	level.scr_sound[ "conversation_01" ][ 14 ] = "train_ar5_rolledout";
	
	//Ranger 1	training	14	16	Total B.S. man...we get stuck here while BCT-1 gets all the action.	
	level.scr_sound[ "conversation_01" ][ 15 ] = "train_ar1_alltheaction";

	//Ranger 2	I tell ya . . . I hear that- you guys sleepin'? I hear that crap going off at night I can't sleep. I don't think I've slept in like six months.	
	level.scr_sound[ "conversation_01" ][ 16 ] = "train_ar2_icantsleep";
	
	//Ranger 2	training	14	17	Gaskets are blown. Need new plugs too.	
	level.scr_sound[ "conversation_01" ][ 17 ] = "train_ar2_newplugs";
	
	//Ranger 3	training	14	18	Where the hell did you get that?	
	level.scr_sound[ "conversation_01" ][ 18 ] = "train_ar3_getthat";
	
	//Ranger 3	training	14	23	Keep it to yourself, Jackson.	
	level.scr_sound[ "conversation_01" ][ 19 ] = "train_ar3_toyourself";
	
	//Ranger 2	So wait dude, combat jack? What the hell is that? Are you crazy? Like in the middle of a battle?	
	level.scr_sound[ "conversation_01" ][ 20 ] = "train_ar2_combatjack";
	
	//Ranger 2	Hey, hey Donnie. I might need some help back here. It's a two man job.	
	level.scr_sound[ "conversation_01" ][ 21 ] = "train_ar2_twomanjob";
	
	//Ranger 5	<laughs>	
	level.scr_sound[ "conversation_01" ][ 22 ] = "train_ar5_laugh1";

	//You should have seen these local cops we had to train.  Some of these guys were total yahoos.	
	level.scr_sound[ "conversation_01" ][ 23 ] = "train_ar4_traincops";		
	
	//It's like the show up in track suits expecting to shoot people in the face.  I don't know what these guys were thinking.	
	level.scr_sound[ "conversation_01" ][ 24 ] = "train_ar4_tracksuits";		
	
	//Nah, these guys were like kids most of them… they're like.. You know, shooting their neighbors and then all of a sudden they want to be policemen.  It's ridiculous.	
	level.scr_sound[ "conversation_01" ][ 25 ] = "train_ar4_ridiculous";


	/*-----------------------
	RANDOM CONVERSATIONS #2
	-------------------------*/	

	//Ranger 1	training	14	21	No ammo, no armor.	
	level.scr_sound[ "conversation_02" ][ 0 ] = "train_ar1_noammo";
	
	//Ranger 2	training	14	22	That's why I'm a cold-blooded carnivorous warrior, bro.	
	level.scr_sound[ "conversation_02" ][ 1 ] = "train_ar2_coldblooded";
	
	//Ranger 4	training	14	9	It's like watching a monkey trying to screw a football.	
	level.scr_sound[ "conversation_02" ][ 2 ] = "train_ar4_monkey";
	
	//Ranger 5	training	14	10	<laughs>	
	level.scr_sound[ "conversation_02" ][ 3 ] = "train_ar5_laugh1";

	//Ranger 2	Can't sleep- dust, sand. I just wanna go home.	
	level.scr_sound[ "conversation_02" ][ 4 ] = "train_ar2_wannagohome";
	
	//Ranger 1	training	14	11	Get over to the motor pool and give Hunter Two a hand with that jam on the Mark-19, huah?	
	level.scr_sound[ "conversation_02" ][ 5 ] = "train_ar1_motorpool";
	
	//Ranger 2	training	14	12	Since when does a //Ranger get paid to sit on his ass?	
	level.scr_sound[ "conversation_02" ][ 6 ] = "train_ar2_getpaid";
	
	//Ranger 3	training	14	13	Check mate, bitch.	
	level.scr_sound[ "conversation_02" ][ 7 ] = "train_ar3_checkmate";
	
	//Ranger 4	training	14	14	<sigh> Saw that coming. Weak, man!	
	level.scr_sound[ "conversation_02" ][ 8 ] = "train_ar4_weakman";
	
	//Ranger 5	training	14	30	You guys see the Delta team that came through here yesterday?	
	level.scr_sound[ "conversation_02" ][ 9 ] = "train_ar5_deltateam";
	
	//Ranger 1	training	14	31	Uh, I don't think those guys were Delta. 	
	level.scr_sound[ "conversation_02" ][ 10 ] = "train_ar1_dontthink";
	
	//Ranger 2	training	14	32	I'm pretty sure some of them were from Delta. Except maybe that dude with the freaky mask.	
	level.scr_sound[ "conversation_02" ][ 11 ] = "train_ar2_freakymask";

	//Ranger 2	Hey, anybody seen my duffel?	
	level.scr_sound[ "conversation_02" ][ 12 ] = "train_ar2_seenmyduffel";
	
	//Ranger 3	training	14	33	I remember that guy…totally non-regulation man.	
	level.scr_sound[ "conversation_02" ][ 13 ] = "train_ar3_nonregulation";
	
	//Ranger 4	training	14	34	Ya think? What about that dude with the mohawk?	
	level.scr_sound[ "conversation_02" ][ 14 ] = "train_ar4_yathink";
	
	//Ranger 5	training	14	35	Bender says he saw that mohawk guy bitchslap the D-boys on the shooting course.	
	level.scr_sound[ "conversation_02" ][ 15 ] = "train_ar5_bendersays";
	
	//Ranger 1	training	14	36	BS man. Nobody's faster than Delta. Nobody.	
	level.scr_sound[ "conversation_02" ][ 16 ] = "train_ar1_nobody";
	
	//Ranger 2	training	14	37	These guys were man, I'm tellin' ya.	
	level.scr_sound[ "conversation_02" ][ 17 ] = "train_ar2_tellinya";
	
	//Ranger 3	training	14	38	Whatever dude...Bender says a lot of things.	
	level.scr_sound[ "conversation_02" ][ 18 ] = "train_ar3_bendersaysalot";

	//Ranger 2	You know, whatever. Jerk.	
	level.scr_sound[ "conversation_02" ][ 19 ] = "train_ar2_whateverjerk";
	
	//Ranger 4	training	14	39	You got any chocolate covered raisins in your MRE?	
	level.scr_sound[ "conversation_02" ][ 20 ] = "train_ar4_raisins";
	
	//Ranger 5	training	14	40	Yeah.	
	level.scr_sound[ "conversation_02" ][ 21 ] = "train_ar5_yeah";
	
	//Ranger 1	training	14	41	Fork 'em over man, I'll trade ya for these curry packets.	
	level.scr_sound[ "conversation_02" ][ 22 ] = "train_ar1_forkemover";
	
	//Ranger 2	training	14	42	Sweet. Thanks man. I love this stuff.	
	level.scr_sound[ "conversation_02" ][ 23 ] = "train_ar2_thanksman";

	//Ranger 2	How's your family doing?	
	level.scr_sound[ "conversation_02" ][ 24 ] = "train_ar2_howsyourfamily";
	
	//Ranger 3	training	14	43	Better put your blood type on your shoelaces.	
	level.scr_sound[ "conversation_02" ][ 25 ] = "train_ar3_bloodtype";
	
	//Ranger 4	training	14	44	Yeah, that's what the D-boys do. 	
	level.scr_sound[ "conversation_02" ][ 26 ] = "train_ar4_dboysdo";
	
	//Ranger 2	training	14	47	Make sure you get a box of tracers. 	
	level.scr_sound[ "conversation_02" ][ 27 ] = "train_ar2_boxoftracers";

	//Ranger 2	Oh, oh that's. . . That's good. Oh. <laughs> Yeah. Alright. Alright bro. You gotta sleep sometime.	
	level.scr_sound[ "conversation_02" ][ 28 ] = "train_ar2_sleepsometime";

	//Honestly, I can not take the taste of sand anymore.	
	level.scr_sound[ "conversation_02" ][ 29 ] = "train_ar4_tasteofsand";		
	
	//There is sand in every single orafice on my body, it's unbelievable.	
	level.scr_sound[ "conversation_02" ][ 30 ] = "train_ar4_sandyorafice";		
	
	//I swear to god I am crapping sand now.	
	level.scr_sound[ "conversation_02" ][ 31 ] = "train_ar4_crapsand";		
	
	/*-----------------------
	RANDOM CONVERSATIONS #3
	-------------------------*/	
	
	//Ranger 5	training	14	50	Anyone see the grease for the Mark 19 turret? I'm trying to fix the turret ring.	
	level.scr_sound[ "conversation_03" ][ 0 ] = "train_ar5_fixturret";

	//Ranger 3	training	14	53	Anyone hear back from BCT-1 yet?	
	level.scr_sound[ "conversation_03" ][ 1 ] = "train_ar3_bct1";
	
	//Ranger 4	training	14	54	Hey Troy, you gotta pack of smokes? 	
	level.scr_sound[ "conversation_03" ][ 2 ] = "train_ar4_packasmokes";

	//Ranger 2	D'you get that stuff from yer mom?	
	level.scr_sound[ "conversation_03" ][ 3 ] = "train_ar2_stufffrommom";

	//Ranger 5	training	14	55	<laughs>	
	level.scr_sound[ "conversation_03" ][ 4 ] = "train_ar5_laugh3";
	
	//Ranger 3	training	14	48	Load one tracer three rounds before the end of your mag. That way you'll know ahead of time to reload.	
	level.scr_sound[ "conversation_03" ][ 5 ] = "train_ar3_onetracer";
	
	//Ranger 4	training	14	49	Cool idea man, never thought of that.	
	level.scr_sound[ "conversation_03" ][ 6 ] = "train_ar4_coolidea";

	//Came home and his old lady was shacked up with some other guy.	
	level.scr_sound[ "conversation_03" ][ 7 ] = "train_ar4_oldlady";		
	
	//I don't wish that on anybody	
	level.scr_sound[ "conversation_03" ][ 8 ] = "train_ar4_dontwish";		
	
	//Ranger 2	Yo! Who took my water?	
	level.scr_sound[ "conversation_03" ][ 9 ] = "train_ar2_tookmywater";
	
	//Ranger 1	training	14	51	Hey, I need an extra mag for the two-forty. You got one?	
	level.scr_sound[ "conversation_03" ][ 10 ] = "train_ar1_extramag";
	
	//Ranger 2	training	14	52	Huah, I got five. Knock yourself out.	
	level.scr_sound[ "conversation_03" ][ 11 ] = "train_ar2_gotfive";

	//Ranger 5	training	14	45	You wanna live, you do what they do.	
	level.scr_sound[ "conversation_03" ][ 12 ] = "train_ar5_wannalive";
	
	//Ranger 1	training	14	46	Huah.	
	level.scr_sound[ "conversation_03" ][ 13 ] = "train_ar1_huah";

	//Ranger 2	Hey you guys wanna give me a hand over here?	
	level.scr_sound[ "conversation_03" ][ 14 ] = "train_ar2_givemeahand";
	
	//Ranger 4	training	14	24	Hey Marks, you ever see a grown man naked?	
	level.scr_sound[ "conversation_03" ][ 15 ] = "train_ar4_grownman";
	
	//Ranger 5	training	14	25	<laughter and snort> 	
	level.scr_sound[ "conversation_03" ][ 16 ] = "train_ar5_laugh2";
	
	//Ranger 1	training	14	26	Careful Booker, don't encourage him.	
	level.scr_sound[ "conversation_03" ][ 17 ] = "train_ar1_carefulbooker";
	
	//Ranger 2	training	14	27	We're on a tight schedule here, ell-tee.	
	level.scr_sound[ "conversation_03" ][ 18 ] = "train_ar2_tightschedule";
	
	//Ranger 3	training	14	28	No kidding. Colonel Shepherd's been breathing down my neck about the AVLB but it's just too slow for rapid-response.	
	level.scr_sound[ "conversation_03" ][ 19 ] = "train_ar3_tooslow";
	
	//Ranger 4	training	14	29	Well, you'd better figure out something Lieutenant, or we're swimming across that river.	
	level.scr_sound[ "conversation_03" ][ 20 ] = "train_ar4_swimming";
	
	//Ranger 2	You see those Delta guys? Yeah, man. That was crazy. Dude with the beard- that's the gig I want. Except. . . Not really. <laughs>	
	level.scr_sound[ "conversation_03" ][ 21 ] = "train_ar2_seedeltaguys";
	
	//Ranger 2	Can't wait 'til we get back to supply camp. She was hot.	
	level.scr_sound[ "conversation_03" ][ 22 ] = "train_ar2_shewashot";

	//Hey man you still gay?	
	level.scr_sound[ "conversation_03" ][ 23 ] = "train_ar4_stillgay";		
	
	//I'm kidding.	
	level.scr_sound[ "conversation_03" ][ 24 ] = "train_ar4_kidding";		
	
	//Don't ask don't tell bro.	
	level.scr_sound[ "conversation_03" ][ 25 ] = "train_ar4_dontaskdonttell";		
	
}

#using_animtree( "vehicles" );
vehicles()
{
	level.scr_anim[ "bridge_layer_bridge" ][ "bridge_lower" ] 		= %roadkill_M60A1_bridge_lower;
	level.scr_anim[ "bridge_layer_bridge" ][ "bridge_raise" ] 		= %M60A1_bridge_raise;

	level.scr_anim[ "bridge_layer" ][ "bridge_lower" ] 				= %roadkill_M60A1_tank_lower;
	level.scr_anim[ "bridge_layer" ][ "bridge_raise" ] 				= %M60A1_tank_raise;
	
	level.scr_anim[ "bridge_layer" ][ "bridge_arm_lower" ]			= %roadkill_M60A1_arm_lower;

	level.scr_animtree[ "bridge_layer_bridge" ] 					= #animtree;
	level.scr_animtree[ "bridge_layer" ] 							= #animtree;
	

	level.scr_anim[ "hummer" ][ "hummer_sequence" ]					= %training_humvee_door;
	level.scr_animtree[ "hummer" ] 									= #animtree;

}

#using_animtree( "script_model" );
model_anims()
{
	//gun anims
	level.scr_anim[ "pit_gun" ][ "training_pit_sitting_welcome" ]	= %training_pit_sitting_welcome_gun;
	level.scr_anim[ "pit_gun" ][ "training_pit_sitting_idle" ][ 0 ]	= %training_pit_sitting_idle_gun;
	level.scr_anim[ "pit_gun" ][ "training_pit_stand_idle" ][ 0 ]	= %training_pit_stand_idle_gun;
	level.scr_anim[ "pit_gun" ][ "training_pit_open_case" ]			= %training_pit_open_case_gun;
	
	level.scr_animtree[ "pit_gun" ] 								= #animtree;
	
	level.scr_anim[ "training_case_01" ][ "training_pit_open_case" ]			= %training_pit_case_1;
	level.scr_anim[ "training_case_02" ][ "training_pit_open_case" ]			= %training_pit_case_2;
	
	level.scr_animtree[ "training_case_01" ] 								= #animtree;
	level.scr_animtree[ "training_case_02" ] 								= #animtree;
	
	
	level.scr_anim[ "tarp" ][ "training_camo_tarp_wind" ][ 0 ]			= %training_camo_tarp_wind;
	level.scr_animtree[ "tarp" ] 								= #animtree;
	
	tarps = getentarray( "tarps", "targetname" );
	foreach( tarp in tarps )
	{
		tarp.animent = spawn( "script_origin", ( 0, 0, 0 ) );
		tarp.animent.origin = tarp.origin;
		tarp.animent.angles = tarp.angles;
		tarp.animname = "tarp";
		tarp assign_animtree();
		tarp.animent thread anim_loop_solo( tarp, "training_camo_tarp_wind", "stop_loop" );
	}
	
	
}

#using_animtree( "animated_props" );
basketball_anims()
{

	level.scr_anim[ "basketball" ][ "training_basketball_loop" ][ 0 ]	= %training_basketball_ball;
	level.scr_animtree[ "basketball" ] 								= #animtree;
	
	addNotetrack_customFunction( "basketball", "ps_scn_trainer_bball_dribble", ::bounce_fx );
	addNotetrack_customFunction( "basketball", "ps_scn_trainer_bball_bounce_pass", ::bounce_fx );

}

bounce_fx ( basketball )
{
	//iprintlnbold( "Boing" );
	playfxontag( getfx( "ball_bounce_dust_runner" ), basketball, "tag_origin");
	
}

trainee_fire_weapon( guy )
{
	if ( !flag( "player_near_range" ) )
		return;
	guy playsound( "drone_m4carbine_fire_npc" );
	PlayFXOnTag( getfx( "m16_muzzleflash" ), guy, "tag_flash" );
}
