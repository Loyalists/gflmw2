#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#using_animtree( "generic_human" );
main()
{
	anims();
	vehicle_anims();
	dialogue();
	script_model_anims();
	flag_init( "roof_door_kicked" );
	addNotetrack_customFunction( "generic", "kick",::notetrack_roof_door_kicked, "shotgunhinges_breach_left_stack_breach_01" );
}

anims()
{
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ]			= %airport_civ_dying_groupB_pull;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull_death" ]	= %airport_civ_dying_groupB_pull_death;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded" ]		= %airport_civ_dying_groupB_wounded;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded_death" ]	= %airport_civ_dying_groupB_wounded_death;
	
	/*-----------------------
	TRENCH ANIMS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "favela_run_and_wave" ]	= %favela_run_and_wave;
	level.scr_anim[ "generic" ][ "civilian_run_2_crawldeath" ]	= %civilian_run_2_crawldeath;
	level.scr_anim[ "generic" ][ "death_explosion_run_F_v1" ]	= %death_explosion_run_F_v1;
	level.scr_anim[ "generic" ][ "roadkill_cover_spotter" ][ 0 ]	= %roadkill_cover_spotter;
	level.scr_anim[ "generic" ][ "roadkill_cover_radio_soldier3" ][ 0 ]	= %roadkill_cover_radio_soldier3;
	level.scr_anim[ "generic" ][ "roadkill_cover_radio_soldier2" ][ 0 ]	= %roadkill_cover_radio_soldier2;
	
	
	/*-----------------------
	DRONE RUN CYCLES
	-------------------------*/	
	//default
	//run_lowready_F_relative
	
	//variations
//	level.scr_anim[ "generic" ][ "wounded_walkcycle" ]	= %run_react_duck_non_loop;
//	level.scr_anim[ "generic" ][ "wounded_walkcycle" ][ 1 ]	= %shotgun_run_01;
//	level.scr_anim[ "generic" ][ "wounded_walkcycle" ][ 2 ]	= %hunted_dazed_walk_C_limp;
//	level.scr_anim[ "generic" ][ "wounded_walkcycle" ][ 3 ]	= %civilian_run_hunched_A;
//	level.scr_anim[ "generic" ][ "wounded_walkcycle" ][ 4 ]	= %run_react_stumble_non_loop;
//	level.scr_anim[ "generic" ][ "wounded_walkcycle" ][ 5 ]	= %hunted_dazed_walk_C_limp;
//	
//	shotgun_run_reload
//	run_react_duck_non_loop
//	run_react_flinch_non_loop
//	heat_run_loop
//	huntedrun_1_idle
//	huntedrun_1_look_left
//	huntedrun_1_look_right
//	huntedrun_2
//	unarmed_panickedrun_loop_V2
//	
//	//want to use
//	airport_civilian_run_turnR_90
//	
//	
//	//for a explosion death
//	civilian_run_2_crawldeath
//	death_explosion_run_F_v1
	
	
	/*-----------------------
	SEAKNIGHT LOADS/UNLOADS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "ch46_load_1" ]					 = %ch46_load_1;
	level.scr_anim[ "generic" ][ "ch46_load_2" ]					 = %ch46_load_2;
	level.scr_anim[ "generic" ][ "ch46_load_3" ]					 = %ch46_load_3;
	level.scr_anim[ "generic" ][ "ch46_load_4" ]					 = %ch46_load_4;
	
	level.scr_anim[ "generic" ][ "ch46_unload_idle" ][ 0 ]			 = %exposed_crouch_idle_alert_v1;
	
	/*-----------------------
	ROOFTOP
	-------------------------*/	
	level.scr_anim[ "generic" ][ "leader_blackhawk_getin" ]		 = %blackout_bh_evac_2;
	level.scr_anim[ "generic" ][ "leader_blackhawk_idle" ][ 0 ]	 = %blackout_bh_evac_2_idle;

	level.scr_anim[ "generic" ][ "redshirt_blackhawk_getin" ]		 = %blackout_bh_evac_2;
	level.scr_anim[ "generic" ][ "redshirt_blackhawk_idle" ][ 0 ]	 = %blackout_bh_evac_2_idle;
	
	
	level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_trans_A_2_B" ]	 = %dcburning_elevator_corpse_trans_A_2_B;
	level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_idle_A" ][ 0 ] 	 	= %dcburning_elevator_corpse_idle_A;
	level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_idle_B" ][ 0 ]		 = %dcburning_elevator_corpse_idle_B;
	level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_bump_A" ]		 = %dcburning_elevator_corpse_bump_A;
	level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_bump_B" ]	 = %dcburning_elevator_corpse_bump_B;
	
	/*-----------------------
	SLAMRAAM TARP
	-------------------------*/	
	level.scr_anim[ "operator" ][ "pulldown" ] = %gulag_slamraam_tarp_pull_guy2_v1;
	level.scr_anim[ "operator" ][ "idle" ][ 0 ] = %gulag_slamraam_tarp_idle_guy2_v1;
	level.scr_anim[ "puller" ][ "pulldown" ] = %gulag_slamraam_tarp_pull_guy1_v1;
	
	/*-----------------------
	LITTLEBIRD RIDER DEATHS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "littlebird_rider_death" ]	 = %fastrope_fall;
	
	level.scr_anim[ "generic" ][ "little_bird_death_guy1" ]	 = %little_bird_death_guy1;
	level.scr_anim[ "generic" ][ "little_bird_death_guy2" ]	 = %little_bird_death_guy2;
	level.scr_anim[ "generic" ][ "little_bird_death_guy3" ]	 = %little_bird_death_guy3;
	
	
	level.scr_anim[ "generic" ][ "deathanim_mortar_00" ]	 = %exposed_death_falltoknees;
	level.scr_anim[ "generic" ][ "deathanim_mortar_01" ]	 = %exposed_death_blowback;
	
	level.scr_anim[ "generic" ][ "AT4_idle" ][ 0 ]					 = %corner_standr_alert_idle;
	level.scr_anim[ "generic" ][ "launchfacility_a_at4_fire" ]		 = %launchfacility_a_at4_fire;
	
	/*-----------------------
	PATROL
	-------------------------*/	
	level.scr_anim[ "generic" ][ "patrol_walk" ]			 = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		 = %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			 = %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			 = %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			 = %patrol_bored_2_walk_180turn;

	/*-----------------------
	ENEMY JAVELIN, STINGER, SPOTTERS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "javelin_arrival" ]	 = %covercrouch_run_in_M;
	level.scr_anim[ "generic" ][ "javelin_idle_start" ]	 = %javelin_idle_A;
	level.scr_anim[ "generic" ][ "javelin_idle" ][ 0 ]	 = %javelin_idle_A;
	level.scr_anim[ "generic" ][ "javelin_fire" ]	 = %javelin_fire_A;
	level.scr_anim[ "generic" ][ "javelin_fire_short" ]	 = %javelin_fire_short_A;
	

	level.scr_anim[ "generic" ][ "javelin_react" ]	 = %javelin_react_A;
	addNotetrack_customFunction( "generic", "reload_begin",::javelin_reload_deathanim, "javelin_fire" );
	addNotetrack_customFunction( "generic", "reload_end",::javelin_reload_done_deathanim, "javelin_fire" );
	
	level.scr_anim[ "generic" ][ "javelin_death_barrett" ]	 = %exposed_death_blowback;	//for barrett enemies

	level.scr_anim[ "generic" ][ "javelin_idle_start2" ]	 = %javelin_idle_B;
	level.scr_anim[ "generic" ][ "javelin_idle2" ][ 0 ]	 = %javelin_idle_B;
	level.scr_anim[ "generic" ][ "javelin_fire2" ]	 = %javelin_fire_B;
	level.scr_anim[ "generic" ][ "javelin_react2" ]	 = %javelin_react_B;
	addNotetrack_customFunction( "generic", "reload_begin",::javelin_reload_deathanim, "javelin_fire2" );
	addNotetrack_customFunction( "generic", "reload_end",::javelin_reload_done_deathanim, "javelin_fire2" );

	level.scr_anim[ "generic" ][ "javelin_death2" ]	 			= %javelin_death_1;		//sitting
	level.scr_anim[ "generic" ][ "javelin_death_reloading2" ]	 = %javelin_death_2;	//sitting reload
	
	level.scr_anim[ "generic" ][ "javelin_death" ]	 = %javelin_death_3;	//kneeling
	level.scr_anim[ "generic" ][ "javelin_death_reloading" ]	 = %javelin_death_5;	//kneeling reload (with javelin on ground)
	
	level.scr_anim[ "generic" ][ "stinger_idle_start" ]	 = %stinger_idle;
	level.scr_anim[ "generic" ][ "stinger_idle" ][ 0 ]	 = %stinger_idle;
	level.scr_anim[ "generic" ][ "stinger_fire" ]	 = %stinger_fire;
	level.scr_anim[ "generic" ][ "stinger_react_stand" ]	 = %stinger_react_stand;
	level.scr_anim[ "generic" ][ "stinger_react_crouch" ]	 = %stinger_react_crouch;
	
	level.scr_anim[ "generic" ][ "enemy_spotter_crouched_idle" ][ 0 ]	 = %hunted_spotter_idle;
	level.scr_anim[ "generic" ][ "enemy_spotter_crouched_idle" ][ 1 ]	 = %hunted_spotter_twitch;
	level.scr_anim[ "generic" ][ "enemy_spotter_crouched_react" ]	 = %crouch2stand;
	level.scr_anim[ "generic" ][ "enemy_spotter_crouched_death" ]	 = %exposed_crouch_death_fetal;

	level.scr_anim[ "generic" ][ "enemy_spotter_prone_idle" ][ 0 ]	 = %sniper_escape_spotter_idle;
	level.scr_anim[ "generic" ][ "enemy_spotter_prone_idle" ][ 1 ]	 = %sniper_escape_spotter_wave;
	level.scr_anim[ "generic" ][ "enemy_spotter_prone_react" ]	 = %prone_2_stand;
	level.scr_anim[ "generic" ][ "enemy_spotter_prone_death" ]	 = %exposed_crouch_death_fetal;
	
	/*-----------------------
	ELEVATOR IDLES
	-------------------------*/	
	level.scr_anim[ "generic" ][ "node_elevator_cover_right" ][ 0 ]	 = %corner_standR_alert_idle;
	level.scr_anim[ "generic" ][ "node_elevator_cover_right" ][ 1 ]	 = %corner_standR_alert_twitch01;
	level.scr_anim[ "generic" ][ "node_elevator_cover_right" ][ 2 ]	 = %corner_standR_alert_twitch02;
	level.scr_anim[ "generic" ][ "node_elevator_cover_right" ][ 3 ]	 = %corner_standR_alert_twitch04;
	level.scr_anim[ "generic" ][ "node_elevator_cover_right" ][ 4 ]	 = %corner_standR_alert_twitch05;
	level.scr_anim[ "generic" ][ "node_elevator_cover_right" ][ 5 ]	 = %corner_standR_alert_twitch06;
	
	
	/*-----------------------
	COMMERCE RAPPEL
	-------------------------*/	
	level.scr_anim[ "generic" ][ "traverse_wallhop" ]	 = %traverse_wallhop;
	level.scr_anim[ "generic" ][ "oilrig_rappel_2_crouch" ]		 = %oilrig_rappel_2_crouch;
	addNotetrack_customFunction( "generic", "over_solid", maps\dcburning::rappel_window_exploder, "oilrig_rappel_2_crouch" );


	/*-----------------------
	BUNKER
	-------------------------*/	
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_sit_idle" ][ 0 ]	 = %DC_Burning_bunker_sit_idle;
	
	//stumble and sit
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble" ]		 	= %DC_Burning_bunker_stumble;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble_idle" ][ 0 ]	 = %DC_Burning_bunker_sit_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble_idle_react" ]		 	= %DC_Burning_bunker_react;

	//gun toss
	level.scr_anim[ "generic" ][ "bunker_toss_idle_guy1" ][ 0 ]		 = %bunker_toss_idle_guy1;
	level.scr_anim[ "generic" ][ "bunker_toss_idle_guy1_go" ]		 = %bunker_toss_guy1;
	level.scr_anim[ "generic" ][ "bunker_toss_guy2" ]		 = %bunker_toss_guy2;
	
	//sit idle and bunker react 1
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v1_idle_start" ]		 = %DC_Burning_artillery_reaction_v1_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v1_idle" ][ 0 ]			 = %DC_Burning_artillery_reaction_v1_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v1_idle_react" ]			 = %DC_Burning_artillery_reaction_v1_react_a;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v1_idle_react2" ]			 = %DC_Burning_artillery_reaction_v1_react_b;
	
	//sit idle and bunker react 2
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v2_idle_start" ]		 = %DC_Burning_artillery_reaction_v2_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v2_idle" ][ 0 ]			 = %DC_Burning_artillery_reaction_v2_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v2_idle_react" ]			 = %DC_Burning_artillery_reaction_v2_react_a;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v2_idle_react2" ]			 = %DC_Burning_artillery_reaction_v2_react_b;

	//sit idle and bunker react 3
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v3_idle_start" ]		 = %DC_Burning_artillery_reaction_v3_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v3_idle" ][ 0 ]			 = %DC_Burning_artillery_reaction_v3_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v3_idle_react" ]			 = %DC_Burning_artillery_reaction_v3_react_a;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v3_idle_react2" ]			 = %DC_Burning_artillery_reaction_v3_react_b;

	//running
	level.scr_anim[ "generic" ][ "unarmed_panickedrun_loop_V2" ]		 = %unarmed_panickedrun_loop_V2;
	
	//checking wounded on stretcher:
	level.scr_anim[ "generic" ][ "DC_Burning_CPR_medic" ]			 = %DC_Burning_CPR_medic;
	addNotetrack_attach(  "generic", "attach prop", "adrenaline_syringe_animated", "TAG_INHAND", "DC_Burning_CPR_medic" );
	addNotetrack_detach(  "generic", "dettach prop", "adrenaline_syringe_animated", "TAG_INHAND", "DC_Burning_CPR_medic" );
	
	level.scr_anim[ "generic" ][ "DC_Burning_CPR_wounded" ]			 = %DC_Burning_CPR_wounded;
	level.scr_anim[ "generic" ][ "DC_Burning_CPR_medic_idle" ][0]			 = %DC_Burning_CPR_medic_endidle;
	level.scr_anim[ "generic" ][ "DC_Burning_CPR_wounded_idle" ][0]			 = %DC_Burning_CPR_wounded_endidle;
	
	//checking wounded:
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_medic" ]			 = %DC_Burning_stop_bleeding_medic;
	addNotetrack_attach(  "generic", "attach prop", "clotting_powder_animated", "TAG_INHAND", "DC_Burning_stop_bleeding_medic" );
	addNotetrack_detach(  "generic", "dettach prop", "clotting_powder_animated", "TAG_INHAND", "DC_Burning_stop_bleeding_medic" );
	
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded" ]			 = %DC_Burning_stop_bleeding_wounded;
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_medic_idle" ][0]			 = %DC_Burning_stop_bleeding_medic_endidle;
	level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_idle" ][0]			 = %DC_Burning_stop_bleeding_wounded_endidle;

	//wounded asleep
	level.scr_anim[ "generic" ][ "cargoship_sleeping_guy_idle_2_start" ]		 = %cargoship_sleeping_guy_idle_2;
	level.scr_anim[ "generic" ][ "cargoship_sleeping_guy_idle_1_start" ]			 = %cargoship_sleeping_guy_idle_1;
	level.scr_anim[ "generic" ][ "cargoship_sleeping_guy_idle_2" ][0]			 = %cargoship_sleeping_guy_idle_2;
	level.scr_anim[ "generic" ][ "cargoship_sleeping_guy_idle_1" ][0]			 = %cargoship_sleeping_guy_idle_1;
	
	level.scr_anim[ "generic" ][ "afgan_caves_sleeping_guard_idle_start" ]		 = %afgan_caves_sleeping_guard_idle;
	level.scr_anim[ "generic" ][ "afgan_caves_sleeping_guard_idle" ][0]			 = %afgan_caves_sleeping_guard_idle;
	
	//laptop
	level.scr_anim[ "generic" ][ "laptop_sit_idle_calm_start" ]		 = %laptop_sit_idle_calm;
	level.scr_anim[ "generic" ][ "laptop_sit_idle_calm" ][ 0 ]		 = %laptop_sit_idle_calm;
	level.scr_anim[ "generic" ][ "laptop_sit_idle_calm" ][ 1 ]		 = %laptop_sit_idle_active;
	level.scr_anim[ "generic" ][ "laptop_sit_idle_react" ]			 = %laptop_sit_idle_flinch;

	level.scr_anim[ "generic" ][ "laptop_stand_idle_start" ]		 = %laptop_stand_idle;
	level.scr_anim[ "generic" ][ "laptop_stand_idle" ][ 0 ]		 = %laptop_stand_idle;
	level.scr_anim[ "generic" ][ "laptop_stand_idle_react" ]			 = %laptop_stand_idle_flinch;
	
	level.scr_anim[ "generic" ][ "laptop_officer_idle_start" ]		 = %laptop_officer_idle;
	level.scr_anim[ "generic" ][ "laptop_officer_idle" ][ 0 ]		 = %laptop_officer_idle;
	level.scr_anim[ "generic" ][ "laptop_officer_idle" ][ 1 ]		 = %laptop_officer_talk;
	
	level.scr_anim[ "generic" ][ "training_humvee_wounded" ]			= %training_humvee_wounded;
	level.scr_anim[ "generic" ][ "training_humvee_soldier" ]			= %training_humvee_soldier;
	level.scr_anim[ "generic" ][ "training_humvee_wounded_idle" ][ 0 ]	= %training_humvee_wounded_idle;
	level.scr_anim[ "generic" ][ "training_humvee_soldier_idle" ][ 0 ]	= %training_humvee_soldier_idle;
	
	//wounded carry anims:
	level.scr_anim[ "generic" ][ "wounded_carry_fastwalk_carrier" ]			 = %wounded_carry_fastwalk_carrier;
	level.scr_anim[ "generic" ][ "wounded_carry_fastwalk_wounded" ]			 = %wounded_carry_fastwalk_wounded;
	level.scr_anim[ "generic" ][ "DC_Burning_wounded_carry_putdown_carrier" ]			 = %DC_Burning_wounded_carry_putdown_carrier;
	level.scr_anim[ "generic" ][ "DC_Burning_wounded_carry_putdown_wounded" ]			 = %DC_Burning_wounded_carry_putdown_wounded;
	level.scr_anim[ "generic" ][ "DC_Burning_wounded_carry_idle_wounded" ][ 0 ]			 = %DC_Burning_wounded_carry_idle_wounded;
	level.scr_anim[ "generic" ][ "DC_Burning_wounded_carry_idle_carrier" ][0]			 = %DC_Burning_wounded_carry_idle_carrier;

	//talking on headset:
	level.scr_anim[ "generic" ][ "bog_radio_dialogue" ]			 = %bog_radio_dialogue;

}

dialogue()
{

	/*-----------------------
	BUNKER
	-------------------------*/
	//Marine 1	Give him some water and keep him still.	
	level.scr_sound[ "dcburn_gm1_keepstill" ] = "dcburn_gm1_keepstill";

	//Marine 1	Corporal, where's your Canteen?
	level.scr_sound[ "dcburn_gm1_wherescanteen" ] = "dcburn_gm1_wherescanteen";
	
	//Marine 2	Right here, L-T.	
	level.scr_sound[ "dcburn_gm2_righthere" ] = "dcburn_gm2_righthere";
	
	//Marine 3	He's all yours doc.	
	level.scr_sound[ "dcburn_gm3_allyoursdoc" ] = "dcburn_gm3_allyoursdoc";
	
	//Marine 4	Christenson, two stretchers to Rajan.	
	level.scr_sound[ "dcburn_gm4_2stretchers" ] = "dcburn_gm4_2stretchers";

	//Marine 5	We've got wounded!	
	level.scr_sound[ "dcburn_gm5_gotwounded" ] = "dcburn_gm5_gotwounded";

	//Marine 6	He's stable for now. Get him to the evac site.	
	level.scr_sound[ "dcburn_gm6_stablefornow" ] = "dcburn_gm6_stablefornow";
	
	//Overlord HQ Radio Voice	Ensure all weapons are condition-one and get topside to provide support. Casevac birds are under heavy fire.	
	level.scr_radio[ "dcburn_hqr_ensureweapons" ] = "dcburn_hqr_ensureweapons";

	//Ranger 1: On your feet - we're Oscar Mike!
	level.scr_sound[ "generic" ][ "dcburn_gr1_onyourfeet" ] = "dcburn_gr1_onyourfeet";
		
	//Sgt. Macey: Roger, Two-One Actual out.
	level.scr_sound[ "generic" ][ "dcburn_mcy_rogerout" ] = "dcburn_mcy_twooneout";
	
	//Sgt. Macey: Listen up! This evac site is getting hit hard and we need to buy 'em some time. Hooah?
	level.scr_sound[ "generic" ][ "dcburn_mcy_evachithard" ] = "dcburn_mcy_buytime2";
	
	//Rangers: Hooah!
	level.scr_sound[ "dcburn_hoh_1" ] = "dcburn_hoh_1";
	

	/*-----------------------
	TRENCHES NAGGING
	-------------------------*/
	//Cpl. Dunn	11	4	Ramirez! Stay in the trenches, you're gonna get your ass blown off!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_stayintrench" ] = "dcburn_cpd_stayintrench";
	
	//Cpl. Dunn	11	5	Stay low! Stick to the trenches!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_staylow" ] = "dcburn_cpd_staylow";
	
	//Cpl. Dunn	11	6	Get your ass back in the trenches!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_backintrench" ] = "dcburn_cpd_backintrench";
	
	//Cpl. Dunn	11	7	Ramirez, what are you doing? Stick to the trenches!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_wheregoing" ] = "dcburn_cpd_wheregoing";

	/*-----------------------
	TRENCHES - JAVELIN ALERTS
	-------------------------*/
	//Marine 2	Incoming!	
	level.scr_sound[ "dcburn_javelins_incoming_00" ] = "dcburn_gm2_incoming";
	
	//Marine 1	Incoming! Incoming! Take cover!!!	
	level.scr_sound[ "dcburn_javelins_incoming_01" ] = "dcburn_gm1_takecover";
	
	/*-----------------------
	TRENCHES - GENERAL
	-------------------------*/
	//Overlord HQ Radio Voice	All callsigns be advised...eyes on Commerce confirms enemy activity. Mortars, rockets...heavy small arms fire. Stay frosty.	
	level.scr_radio[ "dcburn_hqr_commerceconfirms" ] = "dcburn_hqr_commerceconfirms";

	//Overlord HQ Radio Voice	All callsigns, the LZ is under heavy fire. Uncover enemy positions and engage potential targets.	
	level.scr_radio[ "dcburn_hqr_uncoverengage" ] = "dcburn_hqr_uncoverengage";
	
	//Cpl. Dunn	They've got optics on us..snipers, rpg teams and heavy arms fire, all floors...12 o'clock due west of our position.	
	level.scr_radio[ "dcburn_cpd_opticsonus" ] = "dcburn_cpd_opticsonus";
	
	//Sgt. Macey	Overlord, this is Hunter 2-1. Requesting airstrike, over.	
	level.scr_sound[ "generic" ][ "dcburn_mcy_reqairstrike" ] = "dcburn_mcy_reqairstrike";
	
	//Overlord HQ Radio Voice	Uh, negative Two-One, all available air units are currently tasked with multiple casevacs along the Potomac. Proceed west to the target building and provide support, out.	
	level.scr_radio[ "dcburn_hqr_alongpotomac" ] = "dcburn_hqr_alongpotomac";
	
	//Sgt. Macey	Everyone move up, get out of the killzone. We gotta buy some time for those casevac birds.	
	level.scr_sound[ "generic" ][ "dcburn_mcy_buytime" ] = "dcburn_mcy_buytime";
	
	//Cpl. Dunn	(To self) Where the hell is RCT One going? (To all) Hey, those victors from RCT One are going the wrong way!	
	level.scr_radio[ "dcburn_cpd_wrongway" ] = "dcburn_cpd_wrongway";
	
	//Sgt. Macey	Overlord this is Hunter Two-One. We're screening west with no adjacent support, and friendly victors from RCT One are hauling ass past us, over.	
	level.scr_sound[ "generic" ][ "dcburn_mcy_haulingpastus" ] = "dcburn_mcy_haulingpastus";
	
	//Overlord HQ Radio Voice	 Roger. RCT One has already peeled off an LAV to provide suppression, over."
	level.scr_radio[ "dcburn_hqr_humvee" ] = "dcburn_hqr_humvee";
	
	//Sgt. Macey	Copy that.	
	level.scr_radio[ "dcburn_mcy_copythat" ] = "dcburn_mcy_copythat";
	
	//Overlord HQ Radio Voice	Hunter Two-One, this is Overlord. SEAL Team Six is maneuvering into position on the northwest corner of the target building. Link up with them on the top floor and eliminate enemy fire teams, over.	
	level.scr_radio[ "dcburn_hqr_linkup" ] = "dcburn_hqr_linkup";
	
	//Sgt. Macey	Roger solid copy on all.	
	level.scr_radio[ "dcburn_mcy_solidcopyonall" ] = "dcburn_mcy_solidcopyonall";
	
	//Sgt. Macey	Keep your fire low...we got friendlies inserting up there.	
	level.scr_sound[ "generic" ][ "dcburn_mcy_firelow" ] = "dcburn_mcy_firelow";
	
	//Cpl. Dunn	I see foot mobiles...12 o'clock, 100 meters!	
	level.scr_radio[ "dcburn_cpd_footmobiles" ] = "dcburn_cpd_footmobiles";

	/*-----------------------
	TRENCHES - MOVE IN WHILE LAV IS SUPPRESSING NAGS
	-------------------------*/
	//Sgt. Macey	All right! RCT One's LAV has them suppressed! Get ready to move on my mark!
	level.scr_sound[ "generic" ][ "dcburn_mcy_humveesupp" ] = "dcburn_mcy_humveesupp";
	
	//Sgt. Macey	Ready….!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_ready" ] = "dcburn_mcy_ready";
	
	//Sgt. Macey	Go go go!!! Move up! Move up!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_gomoveup" ] = "dcburn_mcy_gomoveup";
	
	//Sgt. Macey	Move up and stay out of that LAV's line of fire!
	level.scr_radio[ "dcburn_mcy_lineoffire" ] = "dcburn_mcy_lineoffire";
	
	//Sgt. Macey	Move! Move!	
	level.scr_radio[ "dcburn_mcy_movemove" ] = "dcburn_mcy_movemove";
	
	//Sgt. Macey	The LAV has them suppressed! Move in! Move in!
	level.scr_radio[ "dcburn_mcy_50calsupp" ] = "dcburn_mcy_50calsupp";
	
	//Sgt. Macey	Push, push, push! We're sitting ducks out here!	
	level.scr_radio[ "dcburn_mcy_sittingducks" ] = "dcburn_mcy_sittingducks";
	
	//Sgt. Macey	Get out of the killzone before you get your ass blown off! Move up!	
	level.scr_radio[ "dcburn_mcy_blownoff" ] = "dcburn_mcy_blownoff";
	
	//Sgt. Macey	Move up, get out of the killzone!	
	level.scr_radio[ "dcburn_mcy_moveup" ] = "dcburn_mcy_moveup";
	
	//Sgt. Macey	Get your ass out of the killzone and into the target building, NOW!	
	level.scr_radio[ "dcburn_mcy_intotargbuilding" ] = "dcburn_mcy_intotargbuilding";

	/*-----------------------
	COMMERCE - LOBBY TO ELEVATOR NAGS
	-------------------------*/
	//Sgt. Foley	Use your grenade launchers!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_grenadelaunch" ] = "dcburn_mcy_grenadelaunch";
	
	//Sgt. Macey Move up! Go! Go!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_lobby_move_nag_00" ] = "dcburn_mcy_moveupgogo";
	
	//Sgt. Macey Move in!	also dcburn_mcy_movein2
	level.scr_sound[ "generic" ][ "dcburn_mcy_lobby_move_nag_01" ] = "dcburn_mcy_movein";
	
	//Sgt. Macey Push forward! Move! Move!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_lobby_move_nag_02" ] = "dcburn_mcy_pushforward";
	
	//Sgt. Macey Keep moving forward!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_lobby_move_nag_03" ] = "dcburn_mcy_moveforward";
	
	//Sgt. Macey Move up! Move up!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_lobby_move_nag_04" ] = "dcburn_mcy_moveup2";

	/*-----------------------
	COMMERCE ELEVATOR BOTTOM TO ELEVATOR TOP 
	-------------------------*/
	//Sgt. Macey	Overlord, this is Hunter Two-One, be advised, we're inside and proceeding to the upper floors.	
	level.scr_radio[ "dcburn_mcy_upperfloors" ] = "dcburn_mcy_upperfloors";

	//Overlord HQ Radio Voice	Roger, Overlord copies all.	
	level.scr_radio[ "dcburn_hqr_copiesall" ] = "dcburn_hqr_copiesall";
 		
	//Sgt. Macey: Fire team has been suppressed in Section One-Alpha.   
	level.scr_radio[ "dcburn_mcy_alldeadcourtyard" ] = "dcburn_mcy_fireteamsupp";
	
	//Overlord HQ Radio Voice: Solid copy, Two-One.	
	level.scr_radio[ "dcburn_hqr_solidcopy" ] = "dcburn_hqr_solidcopy";
	
	/*-----------------------
	COMMERCE COURTYARD - HEADING TO MEZZANINE
	-------------------------*/
	//Sgt. Macey: Overlord this is Hunter Two-One. Proceeding to the mezzanine. Tell the LAV from RCT One to hold their fire, over.
	level.scr_radio[ "dcburn_mcy_tomezzanine" ] = "dcburn_mcy_mezzanine";
	
	//Overlord HQ Radio Voice: Copy that, Two One, good hunting.
	level.scr_radio[ "dcburn_hqr_goodhunt" ] = "dcburn_hqr_goodhunting";
			
	//Sgt. Macey: Hostiles suppressed in Section Two-Echo.   
	level.scr_radio[ "dcburn_mcy_alldeadmezzanine" ] = "dcburn_mcy_hostsupp";
	
	//Overlord HQ Radio Voice: Roger that, Two-One.	
	level.scr_radio[ "dcburn_hqr_rogerthat" ] = "dcburn_hqr_rogerthat";
	
	/*-----------------------
	COMMERCE COURTYARD - UP PAVLOV'S RAMP
	-------------------------*/
	
	//That's the frickin' Capitol Building!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_capitolbuild" ] = "dcburn_cpd_capitolbuild";
	
	//Sgt. Macey	15	3	Let's get the drop on them...Ramirez, activate your heartbeat sensor.
	level.scr_radio[ "dcburn_mcy_droponthem" ] = "dcburn_mcy_droponthem";
	
	//Sgt. Macey	15	4	Keep an eye on your heartbeat sensor Ramirez. I wanna hit 'em fast and hard.
	level.scr_radio[ "dcburn_mcy_hitemfast" ] = "dcburn_mcy_hitemfast";
	
	//Sgt. Macey	Outlaw Two-Three this is Two-One-Actual. Interrogative - what are you seeing from your position over?	
	level.scr_radio[ "dcburn_mcy_whatseeing_r" ] = "dcburn_mcy_whatseeing_r";
	
	//Marine 5	The LZ is still receiving heavy fire from the target building, break - I see RPG teams on the upper floors, and medium caliber fire coming from the southwest corner over.	
	level.scr_radio[ "dcburn_gm5_lzheavyfire" ] = "dcburn_gm5_lzheavyfire";
	
	//Sgt. Macey	Solid copy, Two-One out.	
	level.scr_radio[ "dcburn_mcy_solidcopy_r" ] = "dcburn_mcy_solidcopy_r";

	//Overlord HQ Radio Voice: Hunter Two-One be advised, hostiles on the southwest corner of the fifth floor are hammering the evac site, over.
	level.scr_radio[ "dcburn_hqr_crownag" ] = "dcburn_hqr_swcorn5th";
	
	//Sgt. Macey: Solid copy Overlord. We are Oscar Mike to the fifth floor. Out.
	level.scr_radio[ "dcburn_mcy_omwtofifth" ] = "dcburn_mcy_omto5th";

	//Sgt. Macey: Enemy fire team eliminated in Section Four-Charlie.    
	level.scr_radio[ "dcburn_mcy_alldeadfourth" ] = "dcburn_mcy_fireteamelim";
	
	//Overlord HQ Radio Voice	Copy that, Two-One.	
	level.scr_radio[ "dcburn_hqr_copythat" ] = "dcburn_hqr_copythat";

	/*-----------------------
	COMMERCE ELEVATOR TOP TO CROWS NEST
	-------------------------*/
	//Sgt. Macey: Overlord, We're on the fifth floor, proceeding to the southwest corner.
	level.scr_radio[ "dcburn_mcy_onfifth" ] = "dcburn_mcy_swcorner";
	
	//Overlord HQ Radio Voice: Copy that, Two-One.	
	level.scr_radio[ "dcburn_hqr_copy21" ] = "dcburn_hqr_copy21";

	//Cpl. Dunn: I got movement.
	level.scr_radio[ "dcburn_cdn_movement" ] = "dcburn_cpd_gotmvmnt";

	//Sgt. Macey: Standby to engage.
	level.scr_radio[ "dcburn_mcy_sby2engage" ] = "dcburn_mcy_standbyeng";

	//Sgt. Macey: Watch your sectors.	
	level.scr_radio[ "dcburn_mcy_watchsectors" ] = "dcburn_mcy_watchsectors";
	
	//Sgt. Macey: Check those corners.	
	level.scr_radio[ "dcburn_mcy_checkcorners" ] = "dcburn_mcy_checkcorners";

	//Sgt. Macey: All Hunter units, I have a visual on the enemy crow's nest at the southwest corner. Move forward and clear it out.
	level.scr_radio[ "dcburn_mcy_visoncrow" ] = "dcburn_mcy_viscrowsnest";

	/*-----------------------
	CROWS NEST
	-------------------------*/
	//Sgt. Macey: Overlord this is Hunter Two-One. We've secured the enemy crow's nest on the southwest corner.
	level.scr_sound[ "generic"][ "dcburn_mcy_seccrowsnest" ] = "dcburn_mcy_seccrowsnest";
	
	//Overlord HQ Radio Voice: Overlord copies all. Evac site reports several transports away, but they are still vulnerable. Can you provide support from your position, over?
	level.scr_radio[ "dcburn_hqr_canyousupport" ] = "dcburn_hqr_stillvuln";
	
	//Sgt. Macey: Roger that. We're sittin' on a stockpile of enemy munitions. We'll dig in and burn through their ammo. Out.
	level.scr_sound[ "generic"][ "dcburn_mcy_stockpile" ] = "dcburn_mcy_stockpile";

	//Evac Site Radio Voice	All callsigns on this net, this is the Washington Monument Evac Site! We're holding our own but have glassed enemies to the west and are taking fire from that direction!	
	level.scr_radio[ "dcburn_evc_glassedenemieswest" ] = "dcburn_evc_glassedenemieswest";

	//Sgt. Macey	21	1	Ramirez, get on that sniper rifle! Scan for targets to the south of the Washington Monument.		
	level.scr_sound[ "generic" ][ "dcburn_mcy_sniperrifle" ] = "dcburn_mcy_sniperrifle";

	//Sgt. Macey	Ramirez, scan for targets to the south of the Washington Monument!		
	level.scr_sound[ "generic" ][ "dcburn_mcy_scanfortargets" ] = "dcburn_mcy_scanfortargets";
	
	/*-----------------------
	CROWS EVAC GETTING SCHWACKED NAGS
	-------------------------*/
	//Evac Site Radio Voice	We're taking fire at the Washington Monument! We are down to 80 percent combat effectiveness! Request immediate sniper fire on targets west of the Monument, over!	
	level.scr_radio[ "dcburn_evc_damage_00" ] = "dcburn_evc_80percenteffective";

	//Evac Site Radio Voice	All callsigns, be advised, enemies to the west are attempting a force-in-detail assault on the Washington Monument evac site! 	
	level.scr_radio[ "dcburn_evc_damage_01" ] = "dcburn_evc_forceindetail";
	
	//Evac Site Radio Voice	Washington Monument evac site to all callsigns!! Enemy fire from the west is threatening to destroy our position!! We can't take much more of this!!	
	level.scr_radio[ "dcburn_evc_damage_02" ] = "dcburn_evc_canttakemuchmore";
	
	//Evac Site Radio Voice	Washington Monument evac site taking heavy fire!!! We're down to 50 percent combat effectiveness!!! We gotta get more fire support or this evac site is gonna fall!!! Over!!!	
	level.scr_radio[ "dcburn_evc_damage_03" ] = "dcburn_evc_50percenteffective";
	
	//Evac Site Radio Voice	All callsigns, this is the Washington Monument evac site!!! Be advised, our situation is critical!!! We can't take much more of this!!! We need more time to get these civvies outta here!!!	
	level.scr_radio[ "dcburn_evc_damage_fail" ] = "dcburn_evc_civviesouttahere";


	/*-----------------------
	CROWS GET ON BARRETT NAGS
	-------------------------*/
	//Sgt. Macey We got foot-mobiles at the World War Two Memorial. Ramirez, get on the Barrett and take 'em out!		
	level.scr_sound[ "generic" ][ "barret_nag_0" ] = "dcburn_mcy_ww2mem";

	//Sgt. Macey The evac site is still taking fire. Get on the Barrett and take 'em out!		
	level.scr_sound[ "generic" ][ "barret_nag_1" ] = "dcburn_mcy_getonbarrett";

	//Sgt. Macey Ramirez - get your ass on that sniper rifle. Move!		
	level.scr_sound[ "generic" ][ "barret_nag_2" ] = "dcburn_mcy_getonrifle";

	/*-----------------------
	CROWS SHOOT BARRETT NAGS
	-------------------------*/
	//Sgt. Macey	21	6	The evac site is still taking heavy fire! Ramirez - target all enemy foot-mobiles.		
	level.scr_sound[ "generic" ][ "barret_shoot_nag_0" ] = "dcburn_mcy_targetenemy";

	//Sgt. Macey	21	7	Ramirez! Target the enemy infantry! Take 'em out!		
	level.scr_sound[ "generic" ][ "barret_shoot_nag_1" ] = "dcburn_mcy_targetinfantry";

	/*-----------------------
	CROWS STAY IN CROWSNEST NAGS
	-------------------------*/
	//Sgt. Macey	21	8	Ramirez, get back here! We gotta provide support to the evac site before they get overrun!		
	level.scr_sound[ "generic" ][ "stay_in_nest_nag_0" ] = "dcburn_mcy_beforeoverrun";

	//Sgt. Macey	21	9	Where the hell are you going? We need to cover the evac site!		
	level.scr_sound[ "generic" ][ "stay_in_nest_nag_1" ] = "dcburn_mcy_coverevacsite";

	//Sgt. Macey	21	10	Ramirez, return to your post! We gotta cover the evac site!		
	level.scr_sound[ "generic" ][ "stay_in_nest_nag_2" ] = "dcburn_mcy_returntopost";

	/*-----------------------
	CROWS NEST - HOSTILES INSIDE PERIMETER NAGS
	-------------------------*/
	//Overlord (HQ Radio) Hunter Two-One be advised, you have enemy foot mobiles converging on your position...stay frosty.		
	level.scr_radio[ "dcburn_hqr_stayfrosty" ] = "dcburn_hqr_stayfrosty";
	
	//Cpl. Dunn	22	2	Hostiles inside the perimeter! Open fire! Open fire!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_inperimeter" ] = "dcburn_cpd_inperimeter";

	//Cpl. Dunn	22	3	Eyes up! Hostiles on our six!!!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_hostatsix" ] = "dcburn_cpd_hostatsix";

	//Cpl. Dunn	22	4	Taking fire! Taking fire! Foot mobiles inside the perimeter! 	
	level.scr_sound[ "generic" ][ "dcburn_cpd_takingfire" ] = "dcburn_cpd_takingfire";

	/*-----------------------
	CROWS NEST - ENEMY ARMOR
	-------------------------*/
	//Overlord (HQ Radio) Hunter Two-One, recommend you clear outta there...I see a mass of foot-mobiles converging on your position…		
	level.scr_radio[ "dcburn_hqr_clearout" ] = "dcburn_hqr_clearout";
	
	//Sgt. Macey	23	2	Negative negative. I have eyes on enemy armor and helicopters advancing on the evac site from the south and southwest! 	
	level.scr_sound[ "generic" ][ "dcburn_mcy_negative" ] = "dcburn_mcy_negative";
	
	//Sgt. Macey	23	3	We're gonna do what we can to buy them more time. Out.	
	level.scr_sound[ "generic" ][ "dcburn_mcy_whatwecan" ] = "dcburn_mcy_whatwecan";

	//Sgt. Macey	24	1	Squad, listen up! We are not, I repeat - we are NOT abandoning those casevacs, hooah?	
	//level.scr_sound[ "generic" ][ "dcburn_mcy_listenup" ] = "dcburn_mcy_listenup";

	//Cpl. Dunn: Hooah!
	//level.scr_sound[ "dcburn_hoh_2" ] = "dcburn_hoh_2";
	
	/*-----------------------
	CROWS NEST - FIND ROCKETS NAGS
	-------------------------*/
	//Sgt. Macey	Ramirez, use some of this ordnance to take out the enemy vehicles! Move!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_useordnance" ] = "dcburn_mcy_useordnance";
	
	//Sgt. Macey	Ramirez, grab a Javelin and destroy those vehicles!	
	level.scr_sound[ "generic" ][ "rocket_nag_0" ] = "dcburn_mcy_grabajavelin";

	//Sgt. Macey	24	5	Ramirez! Find some heavy ordnance and take out the armor and helicopters...we need to give our people on the ground time to get out.	, dcburn_mcy_heavyord2
	level.scr_sound[ "generic" ][ "rocket_nag_1" ] = "dcburn_mcy_heavyord";
	
	//Sgt. Macey	24	6	Ramirez! Find some heavy weapons and eliminate that armor and enemy air. Hurry!		
	level.scr_sound[ "generic" ][ "rocket_nag_2" ] = "dcburn_mcy_heavyweap";

	//Sgt. Macey	24	7	Use whatever enemy ordnance you can find and take down those helis and armor. Move!		
	level.scr_sound[ "generic" ][ "rocket_nag_3" ] = "dcburn_mcy_whateveryoufind";

	/*-----------------------
	CROWS NEST - USE ROCKETS NAGS
	-------------------------*/
	//Sgt. Macey	25	2	Ramirez! Take out those vehicles!!! The evac site is taking heavy fire!!!		
	level.scr_sound[ "generic" ][ "rocket_shoot_nag_0" ] = "dcburn_mcy_heavyfire";

	//Sgt. Macey	25	3	Ramirez! Enemy vehicles are closing in!!! Take 'em out!!!		
	level.scr_sound[ "generic" ][ "rocket_shoot_nag_1" ] = "dcburn_mcy_closingin";
	
	//Sgt. Macey	25	1	The evac site is getting overrun! Take out the enemy vehicles!		
	level.scr_sound[ "generic" ][ "rocket_shoot_nag_2" ] = "dcburn_mcy_takeoutveh";

	/*-----------------------
	CROWS NEST TO ROOF 
	-------------------------*/
	
	//Overlord (HQ Radio)	32	7	Atlas Two-Six is now away. All remaining evacuation units, execute level three evacuation protocols. Urgent surgicals only.	
	level.scr_radio[ "dcburn_hqr_urgentsurgicals" ] = "dcburn_hqr_urgentsurgicals";
	
	//Ranger 5	32	8	We just lost Atlas Two-Three to triple-A from the Capitol Building!!!	
	level.scr_radio[ "dcburn_ar5_triplea" ] = "dcburn_ar5_triplea";
	
	//Ranger 2	32	9	Get those civvies back in their seats!!!!	
	level.scr_radio[ "dcburn_ar2_backinseats" ] = "dcburn_ar2_backinseats";

	//Ranger 3	32	5	I've got a major hydraulic leak! We're barely gonna make it over the MSR! We gotta touch down - we gotta (static)!	
	level.scr_radio[ "dcburn_ar3_gottatouchdown" ] = "dcburn_ar3_gottatouchdown";
	
	
	//Overlord (HQ Radio)	Hunter Two-One, you've bought the evac site valuable time. Well done. Now get your ass to the roof ASAP...you are in danger of being overrun. 	dcburn_hqr_roofasap
	level.scr_radio[ "dcburn_hqr_roofasap" ] = "dcburn_hqr_roofasap";
	
	//Sgt. Macey	26	2	Roger that, we're headed to the rooftop! Everyone, move out!		
	level.scr_sound[ "generic" ][ "dcburn_mcy_rooftop" ] = "dcburn_mcy_rooftop";

	//Cpl. Dunn	27	4	Hostiles closing in!!!	
	level.scr_sound[ "generic" ][ "dcburn_cpd_closingin" ] = "dcburn_cpd_closingin";
	
	//Black Hawk Pilot	Hunter, this is Dagger Two-One. We are in position at the LZ on the rooftop, what's your status?	
	level.scr_radio[ "dcburn_bhp_whatsyourstatus" ] = "dcburn_bhp_whatsyourstatus";
	
	//Sgt. Macey	We're on our way! Hostiles following close behind!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_hostilesclose" ] = "dcburn_mcy_hostilesclose";
	

	//Sgt. Foley   There's no time! Keep moving!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_notime" ] = "dcburn_mcy_notime";
	
	//Sgt. Foley   We have to keep moving! Go! Go! Go!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_keepmoving" ] = "dcburn_mcy_keepmoving";
	
	//Sgt. Foley   We're getting overrun! Move! Move! Move!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_overrun" ] = "dcburn_mcy_overrun";
	
	//Sgt. Foley   We're out of time! Go!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_outoftimego" ] = "dcburn_mcy_outoftimego";


	/*-----------------------
	CROWS NEST TO ROOF - GET TO BREACH DOOR
	-------------------------*/
	//Sgt. Macey	26	4	Get to the roof and RV with the SEAL Team! Move! Move!		
	level.scr_sound[ "generic" ][ "dcburn_mcy_rvwithseals" ] = "dcburn_mcy_rvwithseals";
	
	//Sgt. Macey	26	3	Keep moving! This sector's gonna be crawlin' with hostiles! We gotta go, NOW!!		
	level.scr_sound[ "generic" ][ "dcburn_mcy_crawlin" ] = "dcburn_mcy_crawlin";

	//Sgt. Macey	Ramirez! Let's move out!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_letsmoveout" ] = "dcburn_mcy_letsmoveout";

	//Sgt. Macey	Ramirez! Move your ass! We've gotta get to the roof, NOW!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_gettoroofnow" ] = "dcburn_mcy_gettoroofnow";

	//Sgt. Macey	Ramirez, let's go! Hostiles are overrunning this position!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_overrunningpos" ] = "dcburn_mcy_overrunningpos";
	
	/*-----------------------
	CROWS NEST TO ROOF - GET TO STAIRWELL
	-------------------------*/
	//Sgt. Macey	26	5	We're outnumbered - we need to get to the roof ASAP!!!! Go! Go! Go!		
	level.scr_sound[ "generic" ][ "dcburn_mcy_outnumbered" ] = "dcburn_mcy_outnumbered";
	
	//Sgt. Macey	Ramirez! Up the stairs! Let's go!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_upthestairsgo" ] = "dcburn_mcy_upthestairsgo";
	
	//Sgt. Macey	Ramirez! Get up the stairs to the roof ASAP…our evac choppers aren't going to wait all day!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_waitallday" ] = "dcburn_mcy_waitallday";

	//Sgt. Macey	We're getting overrun! Everyone to the roof! Now!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_gettingoverrun" ] = "dcburn_mcy_gettingoverrun";

	/*-----------------------
	HELI RIDE - MINIGUN NAGS
	-------------------------*/
	//Sgt. Macey	27	5	Ramirez, get on the minigun!!!		
	level.scr_sound[ "generic" ][ "dcburn_mcy_getonminigun" ] = "dcburn_mcy_getonminigun";

	//Sgt. Macey	27	6	We've gotta move! Ramirez, get on that minigun!		
	level.scr_sound[ "generic" ][ "dcburn_mcy_moveminigun" ] = "dcburn_mcy_moveminigun";

	//Sgt. Macey	Ramirez!!! Get in the chopper!!!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_getinchopper" ] = "dcburn_mcy_getinchopper";
	
	//Sgt. Macey	Ramirez!!! We are way outnumbered! Get on board!! Move!!!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_wayoutnumbered" ] = "dcburn_mcy_wayoutnumbered";
	
	//Sgt. Macey	Ramirez!! Forget about it! We got a minigun on board! Get on the helicopter! Let's go!!!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_forgetaboutit" ] = "dcburn_mcy_forgetaboutit";
	
	//Sgt. Macey	Ramirez!!! You're polishing brass on the Titanic! Get on the minigun, let's go!!!	
	level.scr_sound[ "generic" ][ "dcburn_mcy_brassontitanic" ] = "dcburn_mcy_brassontitanic";

	/*-----------------------
	HELI RIDE BG CHATTER
	-------------------------*/

	//Overlord (HQ Radio)	32	1	First wave of civilian transports is away. Reaver Two, proceed with second stage evacation. Litter urgent personnel only.	
	level.scr_radio[ "dcburn_hqr_firstwave" ] = "dcburn_hqr_firstwave";
	
	//Overlord (HQ Radio)	32	3	Atlas Two-Three, Two-Four and Two-Five are all away. Ground units at LZ 4, fall back now.	
	level.scr_radio[ "dcburn_hqr_fallbacknow" ] = "dcburn_hqr_fallbacknow";
	
	//Ranger 2	32	4	This is Atlas Two-Five at LZ 1! Engines are at 30 percent! I can't carry any more people! We're gonna have to leave some of them behind!!	
	level.scr_radio[ "dcburn_ar2_leavebehind" ] = "dcburn_ar2_leavebehind";

	//Ranger 2	32	2	We're bleeding hydraulic fluid, I'm losin' the tail rotor!	
	level.scr_radio[ "dcburn_ar2_hydraulicfluid" ] = "dcburn_ar2_hydraulicfluid";
	
	//Ranger 4	32	6	This is Atlas One-One, civilian transport going down two klicks west of Dupont Circle! We are- (static) (screaming women and children on board in background)	
	level.scr_radio[ "dcburn_ar4_wearegoingdown" ] = "dcburn_ar4_wearegoingdown";
	
	//Overlord (HQ Radio)	32	10	Overlord to all units, evacuation order Irene, I repeat, evacuation order Irene. Everyone get the hell outta there.	
	level.scr_radio[ "dcburn_hqr_orderirene" ] = "dcburn_hqr_orderirene";
	
	//Ranger 1	32	11	Get your men on that transport now, WE ARE LEAVING!!!	
	level.scr_radio[ "dcburn_ar1_weareleaving" ] = "dcburn_ar1_weareleaving";
	


	/*-----------------------
	HELI RIDE
	-------------------------*/

	//Sgt. Foley   Overlord, Dagger Two-Two is hit and going down!
	level.scr_radio[ "dcburn_mcy_hitgoingdown" ] = "dcburn_mcy_hitgoingdown";
	
	//Black Hawk Pilot	Incoming! Incoming!		intense, extremely urgent 	helicopter radio
	level.scr_radio[ "dcburn_bhp_incoming" ] = "dcburn_bhp_incoming";
	
	//Sgt. Foley	Overlord, we're hit, but still in the air. We've got a massive SAM battery dead ahead...we're going in!!		end of the world	headset
	level.scr_radio[ "dcburn_mcy_stillintheair" ] = "dcburn_mcy_stillintheair";
	
	//Black Hawk Pilot	RPG teams! 12 o'clock!!!		intense, extremely urgent 	helicopter radio
	level.scr_radio[ "dcburn_bhp_rpgteams" ] = "dcburn_bhp_rpgteams";
	
	//Black Hawk Pilot	We're losing attitude control…!!!		struggling with the controls, keeping it aloft	helicopter radio
	level.scr_radio[ "dcburn_bhp_attitudecontrol" ] = "dcburn_bhp_attitudecontrol";
	
	//Sgt. Foley	Take us up!!! If we're goin' down we're taking those SAM sites with us!!!		last ditch effort before we all crash and burn	headset
	level.scr_radio[ "dcburn_mcy_takeusup" ] = "dcburn_mcy_takeusup";
	
	//Black Hawk Pilot	Multiple fire teams spotted!		struggling with the controls, keeping it aloft, still flying	helicopter radio
	level.scr_radio[ "dcburn_bhp_fireteams" ] = "dcburn_bhp_fireteams";
	

	//Sgt. Macey Overlord, we've linked up with the SEALs on the rooftop and are heading out. Interrogative - has the bunker been evacuated, over?		
	level.scr_radio[ "dcburn_mcy_bunkerevac" ] = "dcburn_mcy_bunkerevac";
	
	//Overlord (HQ Radio)	27	2	Negative Two-One, they're still pinned down by infantry and light armor. Doesn't look good from here, over.		
	level.scr_radio[ "dcburn_hqr_stillpinned" ] = "dcburn_hqr_stillpinned";
	
	//Sgt. Macey	27	3	Copy Overlord, we'll do what we can from the air, out.		
	level.scr_radio[ "dcburn_mcy_fromtheair" ] = "dcburn_mcy_fromtheair";
	
	//Sgt. Macey	28	1	This is Hunter Two-One Actual. We have eyes on multiple hostile victors and foot mobiles....request permission to engage, over.		
	level.scr_radio[ "dcburn_mcy_permission" ] = "dcburn_mcy_permission";
	
	//Overlord (HQ Radio)	28	2	Your call, Two-One. Outlaw is pinned down at the bunkers. You're cleared hot along the MSR, over.		
	level.scr_radio[ "dcburn_hqr_clearedhot" ] = "dcburn_hqr_clearedhot";
	
	//Sgt. Macey	28	3	Squad, we're engaging all targets of opportunity to buy Outlaw some time to get out! This may be a one way trip. Hooah?		
	level.scr_radio[ "dcburn_mcy_onewaytrip" ] = "dcburn_mcy_onewaytrip";
	
	//SEAL Team Leader  We're with you, Two-One. Let's do this.		
	level.scr_radio[ "dcburn_sll_withyou" ] = "dcburn_sll_withyou";
	
	//Cpl. Dunn Hooah. Rangers lead the way!
	level.scr_radio[ "dcburn_cpd_leadtheway" ] = "dcburn_cpd_leadtheway";
	
	//Sgt. Macey All the way.		
	level.scr_radio[ "dcburn_mcy_alltheway" ] = "dcburn_mcy_alltheway";

	//Little Bird Pilot 1	Dagger Two, SAM launch! Break left break left!!!	
	level.scr_radio[ "dcburn_lbp1_breakleftbreakleft" ] = "dcburn_lbp1_breakleftbreakleft";
	
	
	//Little Bird Pilot 1	Ramirez, we got foot mobiles and light armor down there. You're cleared hot.	
	level.scr_radio[ "dcburn_lbp1_clearedhot" ] = "dcburn_lbp1_clearedhot";
	
	//Sgt. Macey	Ramirez, spin her up and let her rip!!!	
	level.scr_radio[ "dcburn_mcy_spinherup" ] = "dcburn_mcy_spinherup";
	
	//Little Bird Pilot 1	Enemy gunship lifting off at your twelve o'clock.	
	level.scr_radio[ "dcburn_lbp1_gunshipliftingoff" ] = "dcburn_lbp1_gunshipliftingoff";
	
	//Little Bird Pilot 1	Light armor rolling in.	
	level.scr_radio[ "dcburn_lbp1_armorrollingin" ] = "dcburn_lbp1_armorrollingin";
	
	//Little Bird Pilot 1	Foot mobiles...take em out.	
	level.scr_radio[ "dcburn_lbp1_footmobiles" ] = "dcburn_lbp1_footmobiles";
	
	//Evac Site Radio Voice	Dagger Two, the evac site is taking fire from the main road!	
	level.scr_radio[ "dcburn_evc_mainroad" ] = "dcburn_evc_mainroad";
	
	//Little Bird Pilot 1	Copy that, we're on it.	
	level.scr_radio[ "dcburn_lbp1_wereonit" ] = "dcburn_lbp1_wereonit";
	
	//Little Bird Pilot 1	Overlord, this is Dagger Two-One. We've taken some of the heat off the evac site -	
	level.scr_radio[ "dcburn_lbp1_takenheatoff" ] = "dcburn_lbp1_takenheatoff";
	

	
	//Little Bird Pilot 1	Overlord, Dagger Two-two and Two-three are down. I repeat, Dagger Two-Two and Two-Three are down, over.	
	level.scr_radio[ "dcburn_lbp1_22and23aredown" ] = "dcburn_lbp1_22and23aredown";
	
	//Black Hawk Pilot	RPG teams in sight...I want you to pull that trigger till they don't get up.	
	level.scr_radio[ "dcburn_bhp_dontgetup" ] = "dcburn_bhp_dontgetup";
	
	//Little Bird Pilot 1	SAM launch! Hang on!!	
	level.scr_radio[ "dcburn_lbp1_samlaunch" ] = "dcburn_lbp1_samlaunch";
	
	//Little Bird Pilot 1	We're hit! Mayday mayday, this is Dagger Two-One, we are going down at grid square Papa Bravo, 2 niner 2, 1 7 8. I repeat, we are going down.
	level.scr_sound[ "dcburn_lbp1_maydaymayday" ] = "dcburn_lbp1_maydaymayday";
		
	//Little Bird Pilot 1	Brace for impact!	
	level.scr_radio[ "dcburn_lbp1_braceforimpact" ] = "dcburn_lbp1_braceforimpact";


}


#using_animtree( "script_model" );
script_model_anims()
{
	level.scr_animtree[ "tarp" ]				= #animtree;
	level.scr_anim[ "tarp" ][ "pulldown" ]		= %gulag_slamraam_tarp_simulation;
	level.scr_model[ "tarp" ]					= "slamraam_tarp";
	
}

#using_animtree( "vehicles" );
vehicle_anims()
{
	//seaknights
	level.scr_anim[ "seaknight" ][ "sniper_escape_ch46_take_off" ] 				= %sniper_escape_ch46_take_off;
	level.scr_anim[ "seaknight" ][ "sniper_escape_ch46_take_off_idle" ][ 0 ] 	= %sniper_escape_ch46_idle;
	level.scr_anim[ "seaknight" ][ "rotors" ]									= %sniper_escape_ch46_rotors;
	level.scr_animtree[ "seaknight" ] 							= #animtree;
	
	//level.scr_anim[ "seaknight" ][ "landing" ] 					= %sniper_escape_ch46_land;
	//level.scr_anim[ "seaknight" ][ "doors_open" ]				= %ch46_doors_open;
}

notetrack_roof_door_kicked( guy )
{
	flag_set( "roof_door_kicked" );
}


javelin_reload_deathanim( guy )
{
	guy.deathanim = guy.deathanimReload;
	guy notify( "reload_begin" );
}

javelin_reload_done_deathanim( guy )
{
	guy.deathanim = guy.deathanimIdle;
}
