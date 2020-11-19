#include animscripts\utility;
#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );

main_anim()
{
	af_chase_anims_and_vo();
	player_animations();
	script_model_animations();
	script_vehicle_animations();
	player_body();

}

player_body()
{
	level.scr_animtree[ "player_body" ] 								 = #animtree;
	level.scr_model[ "player_body" ] 								 = "ch_body_gk_m4_sopmod_ii";
	level.scr_anim[ "player_body" ][ "price_wakeup" ] 				 = %afchase_ending_player_body;
}

af_chase_anims_and_vo()
{
	level.ai_root_anim = %root;
	level.scr_anim[ "crawl_death_1" ][ "crawl" ]		 		= %dying_crawl;
	level.scr_anim[ "crawl_death_1" ][ "death" ][0]		 		= %dying_crawl_death_v3;
	level.scr_anim[ "crawl_death_1" ][ "blood_fx_rate" ]		= .5;
//	level.scr_anim[ "crawl_death_1" ][ "blood_fx" ]				= "blood_drip";
	
	level.scr_sound[ "generic" ][ "afchase_pri_zodiacnine" ] = "afchase_pri_zodiacnine";

	level.scr_sound[ "generic" ][ "afchase_pri_gettingaway" ] = "afchase_pri_gettingaway";
	level.scr_sound[ "generic" ][ "afchase_pri_gogogo" ] = "afchase_pri_gogogo";
	level.scr_sound[ "generic" ][ "afchase_pri_cantlet" ] = "afchase_pri_cantlet";
	level.scr_sound[ "generic" ][ "afchase_pri_losinghim" ] = "afchase_pri_losinghim";
	level.scr_sound[ "generic" ][ "afchase_pri_aroundcorner" ] = "afchase_pri_aroundcorner";
	level.scr_sound[ "generic" ][ "afchase_pri_getonboat" ] = "afchase_pri_getonboat";
	level.scr_sound[ "generic" ][ "afchase_pri_drivingtheboat" ] = "afchase_pri_drivingtheboat";
	level.scr_sound[ "generic" ][ "afchase_pri_anotherchance" ] = "afchase_pri_anotherchance";
	level.scr_sound[ "generic" ][ "afchase_pri_wrongway" ] = "afchase_pri_wrongway";
	level.scr_sound[ "generic" ][ "afchase_pri_turntoobjective" ] = "afchase_pri_turntoobjective";
	level.scr_sound[ "generic" ][ "afchase_pri_wheregoing" ] = "afchase_pri_wheregoing";
	level.scr_sound[ "generic" ][ "afchase_pri_enemysix" ] = "afchase_pri_enemysix";
	level.scr_sound[ "generic" ][ "afchase_pri_zodiacsix" ] = "afchase_pri_zodiacsix";
	level.scr_sound[ "generic" ][ "afchase_pri_evasive" ] = "afchase_pri_evasive";
	level.scr_sound[ "generic" ][ "afchase_pri_enginesdead" ] = "afchase_pri_enginesdead";

	level.scr_sound[ "generic" ][ "afchase_pri_behindrocks" ] = "afchase_pri_behindrocks";
	level.scr_sound[ "generic" ][ "afchase_pri_miniguns" ] = "afchase_pri_miniguns";
	level.scr_sound[ "generic" ][ "afchase_pri_shakeemoff" ] = "afchase_pri_shakeemoff";
	level.scr_sound[ "generic" ][ "afchase_pri_threadtheneedle" ] = "afchase_pri_threadtheneedle";
	level.scr_sound[ "generic" ][ "afchase_pri_enemyboats" ] = "afchase_pri_enemyboats";
	level.scr_sound[ "generic" ][ "afchase_pri_openareas" ] = "afchase_pri_openareas";
	level.scr_sound[ "generic" ][ "afchase_pri_dodgedodge" ] = "afchase_pri_dodgedodge";
	level.scr_sound[ "generic" ][ "afchase_pri_leftleft" ] = "afchase_pri_leftleft";
	level.scr_sound[ "generic" ][ "afchase_pri_rightright" ] = "afchase_pri_rightright";
	level.scr_sound[ "generic" ][ "afchase_pri_left" ] = "afchase_pri_left";
	level.scr_sound[ "generic" ][ "afchase_pri_right" ] = "afchase_pri_right";
	level.scr_sound[ "generic" ][ "afchase_pri_rpgsonbridge" ] = "afchase_pri_rpgsonbridge";
	level.scr_sound[ "generic" ][ "afchase_pri_otherside" ] = "afchase_pri_otherside";
	level.scr_sound[ "generic" ][ "afchase_pri_technical" ] = "afchase_pri_technical";

	level.scr_sound[ "generic" ][ "dialog_helicopter_six2" ] = "dialog_helicopter_six2";
	level.scr_sound[ "generic" ][ "afchase_pri_dodgeheli" ] = "afchase_pri_dodgeheli";
	level.scr_sound[ "generic" ][ "afchase_pri_gunsspinup" ] = "afchase_pri_gunsspinup";
	level.scr_sound[ "generic" ][ "afchase_pri_steerclear" ] = "afchase_pri_steerclear";
	level.scr_sound[ "generic" ][ "afchase_pri_rapidsahead" ] = "afchase_pri_rapidsahead";
	level.scr_sound[ "generic" ][ "afchase_pri_fullpower" ] = "afchase_pri_fullpower";
	level.scr_sound[ "generic" ][ "afchase_pri_thrucave" ] = "afchase_pri_thrucave";

	level.scr_anim[ "generic" ][ "rapids_in" ] = %zodiac_rightside_rapids_trans_in;
	level.scr_anim[ "generic" ][ "rapids_loop" ][ 0 ] = %zodiac_rightside_rapids_loopB;
	level.scr_sound[ "generic" ][ "rapids_in" ] = "afchase_pri_rapidsahead";

	level.scr_anim[ "generic" ][ "left_afchase_pri_gettingaway" ] = %zodiac_rightside_wave_short;
	level.scr_anim[ "generic" ][ "left_afchase_pri_gogogo" ] = %zodiac_rightside_wave_short;
	level.scr_anim[ "generic" ][ "left_afchase_pri_cantlet" ] = %zodiac_rightside_wave;

	level.scr_anim[ "generic" ][ "left_afchase_pri_losinghim" ] = %zodiac_rightside_wave;
	level.scr_anim[ "generic" ][ "left_afchase_pri_drivingtheboat" ] = %afchase_pri_drivingtheboat_R;
	level.scr_anim[ "generic" ][ "left_afchase_pri_fullpower" ] = %zodiac_rightside_wave;

	level.scr_anim[ "generic" ][ "right_afchase_pri_gettingaway" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_gogogo" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_cantlet" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_losinghim" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_drivingtheboat" ] = %afchase_pri_drivingtheboat_L;
	level.scr_anim[ "generic" ][ "right_afchase_pri_fullpower" ] = %zodiac_leftside_wave;

	level.scr_sound[ "generic" ][ "right_afchase_pri_gettingaway" ] = "afchase_pri_gettingaway";
	level.scr_sound[ "generic" ][ "right_afchase_pri_gogogo" ] = "afchase_pri_gogogo";
	level.scr_sound[ "generic" ][ "right_afchase_pri_cantlet" ] = "afchase_pri_cantlet";
//	level.scr_face[ "generic" ][ "right_afchase_pri_cantlet" ] = %afchase_pri_cantlet;
	
	level.scr_sound[ "generic" ][ "right_afchase_pri_losinghim" ] = "afchase_pri_losinghim";
	level.scr_sound[ "generic" ][ "right_afchase_pri_drivingtheboat" ] = "afchase_pri_drivingtheboat";
//	level.scr_face[ "generic" ][ "right_afchase_pri_drivingtheboat" ] = %afchase_pri_drivingtheboat;
	level.scr_sound[ "generic" ][ "right_afchase_pri_fullpower" ] = "afchase_pri_fullpower";

	level.scr_sound[ "generic" ][ "left_afchase_pri_gettingaway" ] = "afchase_pri_gettingaway";
	level.scr_sound[ "generic" ][ "left_afchase_pri_gogogo" ] = "afchase_pri_gogogo";
	level.scr_sound[ "generic" ][ "left_afchase_pri_cantlet" ] = "afchase_pri_cantlet";
//	level.scr_face[ "generic" ][ "left_afchase_pri_cantlet" ] = %afchase_pri_cantlet;
	level.scr_sound[ "generic" ][ "left_afchase_pri_losinghim" ] = "afchase_pri_losinghim";
	level.scr_sound[ "generic" ][ "left_afchase_pri_drivingtheboat" ] = "afchase_pri_drivingtheboat";
//	level.scr_face[ "generic" ][ "left_afchase_pri_drivingtheboat" ] = %afchase_pri_drivingtheboat;
	level.scr_sound[ "generic" ][ "left_afchase_pri_fullpower" ] = "afchase_pri_fullpower";

	level.scr_anim[ "generic" ][ "price_into_boat" ] = %zodiac_jumpin;

	level.scr_anim[ "generic" ][ "standby" ]				 = %walk_CQB_F;

	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_12" ] = "TF_pri_callout_targetclock_12";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_1" ] = "TF_pri_callout_targetclock_1";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_2" ] = "TF_pri_callout_targetclock_2";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_3" ] = "TF_pri_callout_targetclock_3";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_4" ] = "TF_pri_callout_targetclock_4";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_5" ] = "TF_pri_callout_targetclock_5";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_6" ] = "TF_pri_callout_targetclock_6";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_7" ] = "TF_pri_callout_targetclock_7";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_8" ] = "TF_pri_callout_targetclock_8";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_9" ] = "TF_pri_callout_targetclock_9";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_10" ] = "TF_pri_callout_targetclock_10";
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_11" ] = "TF_pri_callout_targetclock_11";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_12" ] = "TF_pri_callout_yourclock_12";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_1" ] = "TF_pri_callout_yourclock_1";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_2" ] = "TF_pri_callout_yourclock_2";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_3" ] = "TF_pri_callout_yourclock_3";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_4" ] = "TF_pri_callout_yourclock_4";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_5" ] = "TF_pri_callout_yourclock_5";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_6" ] = "TF_pri_callout_yourclock_6";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_7" ] = "TF_pri_callout_yourclock_7";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_8" ] = "TF_pri_callout_yourclock_8";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_9" ] = "TF_pri_callout_yourclock_9";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_10" ] = "TF_pri_callout_yourclock_10";
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_11" ] = "TF_pri_callout_yourclock_11";

	level.scr_anim[ "shepherd" ][ "turn_buckle_idle" ][ 0 ] = %afchase_ending_shepherd_turnbuckle_idle;
	level.scr_anim[ "shepherd" ][ "turn_buckle_idleb" ][ 0 ] = %afchase_ending_shepherd_turnbuckle_idleB;
	

	level.scr_anim[ "shepherd" ][ "turn_buckle" ] = %afchase_ending_shepherd_turnbuckle;
	level.scr_anim[ "shepherd" ][ "turn_buckle_alt" ] = %afchase_ending_shepherd_turnbuckle_alt;
//	addNotetrack_attach(  "shepherd", "attach_knife", "weapon_parabolic_knife", "TAG_INHAND", "turn_buckle" );
//	addNotetrack_customFunction( "shepherd", "detach_knife" , ::knife_in_player , "turn_buckle");

	level.scr_anim[ "shepherd" ][ "gun_monologue" ] = %afchase_ending_shepherd_gun_monologue;
	//addNotetrack_customFunction( "shepherd", "bullets" , ::bullets_notify , "gun_monologue");

	// what are you waiting for mactavish
 	level.scr_sound[ "shepherd" ][ "afchase_shp_waitingfor" ] = "afchase_shp_waitingfor";
 	level.scr_sound[ "shepherd" ][ "afchase_shp_digtwograves" ] = "afchase_shp_digtwograves";
 	level.scr_sound[ "shepherd" ][ "afchase_shp_goahead" ] = "afchase_shp_goahead";
 	level.scr_sound[ "shepherd" ][ "afchase_shp_couldntdoit" ] = "afchase_shp_couldntdoit";
 	level.scr_sound[ "shepherd" ][ "afchase_shp_goodwarrior" ] = "afchase_shp_goodwarrior";
 	level.scr_sound[ "shepherd" ][ "afchase_shp_extrastep" ] = "afchase_shp_extrastep";
 	level.scr_sound[ "shepherd" ][ "afchase_shp_necessary" ] = "afchase_shp_necessary";

	level.scr_anim[ "shepherd" ][ "gun_drop" ] = %afchase_ending_shepherd_gun_drop;// 4.233
	addNotetrack_customFunction( "shepherd", "fire", ::gun_fire, "gun_drop" );


	level.scr_anim[ "shepherd" ][ "gun_kick" ] = %afchase_ending_shepherd_gun_kick;
	level.scr_anim[ "shepherd" ][ "knife_moment" ] = %afchase_ending_shepherd_knife_moment;
	level.scr_anim[ "shepherd" ][ "price_wakeup" ] = %afchase_shepherd_wakeup;

	level.scr_anim[ "shepherd" ][ "fight" ] = %afchase_fightC_Shepherd;
	level.scr_anim[ "shepherd" ][ "fight_B" ] = %afchase_fightB_price;
	level.scr_anim[ "shepherd" ][ "fight_B2" ] = %afchase_fightB_price_short;
	level.scr_anim[ "shepherd" ][ "fight_C" ] = %afchase_fightC_price;
	level.scr_anim[ "shepherd" ][ "fight_C2" ] = %afchase_fightC_shepherd; //_short;
	level.scr_anim[ "shepherd" ][ "fight_D2" ] = %afchase_fightD2_Shepherd;
	level.scr_anim[ "shepherd" ][ "fight_D3" ] = %afchase_fightD3_Shepherd;
	level.scr_anim[ "shepherd" ][ "fight_D3_swapped" ] = %afchase_fightD3_price;
	level.scr_anim[ "shepherd" ][ "fight_E" ] = %afchase_fightE_Shepherd;
	level.scr_anim[ "shepherd" ][ "prone_stand" ] = %hunted_pronehide_2_stand_v3;
	
	
//		afchase_fightC_Shepherd_short
//		afchase_fightC_Price_short
//		afchase_fightB_Shepherd_short
//		afchase_fightB_Price_short


	level.scr_anim[ "price" ][ "fight_E_loop" ][ 0 ] = %afchase_fightE_Price_punchloop;
	level.scr_anim[ "shepherd" ][ "fight_E_loop" ][ 0 ] = %afchase_fightE_Shepherd_punchloop;
	add_fighte_animsounds();


	level.scr_anim[ "shepherd" ][ "wakeup" ] = %afchase_shepherd_wakeup;

	level.scr_anim[ "price" ][ "gun_drop" ] = %afchase_ending_price_gun_drop;// 4.233
	level.scr_anim[ "price" ][ "gun_kick_price" ] = %afchase_ending_price_gun_kick;
	level.scr_anim[ "price" ][ "knife_moment" ] = %afchase_ending_price_knife_moment;
	level.scr_anim[ "price" ][ "price_wakeup" ] = %afchase_price_wakeup;
	level.scr_sound[ "price" ][ "price_wakeup" ] = "scn_afchase_wakeup_price_foley";

	addNotetrack_sound( "price", "dialog1", "price_wakeup", "afchase_pri_soap1" );
	addNotetrack_sound( "price", "dialog2", "price_wakeup", "afchase_pri_soap2" );
	

	level.scr_anim[ "price" ][ "fight" ] = %afchase_fightC_Price;
	level.scr_anim[ "price" ][ "fight_B" ] = %afchase_fightB_shepherd;
	level.scr_anim[ "price" ][ "fight_B2" ] = %afchase_fightB_shepherd_short;
	level.scr_anim[ "price" ][ "fight_C" ] = %afchase_fightC_shepherd;
	level.scr_anim[ "price" ][ "fight_C2" ] = %afchase_fightC_Price; //_short;
	
	level.scr_anim[ "price" ][ "fight_D2" ] = %afchase_fightD2_Price;
	level.scr_anim[ "price" ][ "fight_D3" ] = %afchase_fightD3_Price;
	level.scr_anim[ "price" ][ "fight_D3_swapped" ] = %afchase_fightD3_shepherd;
	level.scr_anim[ "price" ][ "fight_E" ] = %afchase_fightE_Price;

	level.scr_anim[ "generic" ][ "zodiac_rapids_sniper" ] = %zodiac_rapids_sniper;
	level.scr_anim[ "generic" ][ "zodiac_rapids_sniper_aimidle" ][ 0 ] = %zodiac_rapids_sniper_aimidle;
	level.scr_anim[ "generic" ][ "zodiac_rapids_sniper_fire" ] = %zodiac_rapids_sniper_fire;
	
	level.scr_anim[ "generic" ][ "zodiac_rapids_sniper_waterfall" ] = %zodiac_rapids_sniper_waterfall;
	addNotetrack_sound( "generic", "dialog_afchase_pri_backup", "zodiac_rapids_sniper_waterfall", "afchase_pri_backup" );
	
	level.scr_anim[ "generic" ][ "zodiac_rapids_sniper_rapididle" ][ 0 ] = %zodiac_rapids_sniper_rapididle;

	level.scr_anim[ "price" ][ "walk_off" ] = %afchase_price_walkoff;
	level.scr_sound[ "price" ][ "walk_off" ] = "scn_afchase_walkoff_foley_stereo";
	addNotetrack_sound( "price", "dialog1", "walk_off", "afchase_pri_holdfornow" );
	addNotetrack_sound( "price", "dialog2", "walk_off", "afchase_pri_toldyou" );
	addNotetrack_sound( "price", "dialog3", "walk_off", "afchase_pri_soapouttahere" );

	level.scr_sound[ "price" ][ "afchase_pri_holdfornow" ] = "afchase_pri_holdfornow";
	level.scr_sound[ "price" ][ "afchase_pri_toldyou" ] = "afchase_pri_toldyou";
	level.scr_sound[ "price" ][ "afchase_pri_soapouttahere" ] = "afchase_pri_soapouttahere";
	level.scr_sound[ "nikolai" ][ "afchase_nkl_lookingforus" ] = "afchase_nkl_lookingforus";
	level.scr_sound[ "nikolai" ][ "afchase_nkl_knowaplace" ] = "afchase_nkl_knowaplace";

	level.scr_anim[ "nikolai" ][ "walk_off" ] = %afchase_nikolai_walkoff;
	addNotetrack_dialogue( "nikolai", "dialog", "walk_off", "afchase_nkl_lookingforus" );
	addNotetrack_dialogue( "nikolai", "dialog", "walk_off", "afchase_nkl_knowaplace" );

	level.scr_anim[ "generic" ][ "civilian_crawl_1" ]		 			 = %civilian_crawl_1;
	level.scr_anim[ "generic" ][ "civilian_crawl_2" ]		 			 = %civilian_crawl_2;
	level.scr_anim[ "generic" ][ "dying_crawl" ]		 				 = %dying_crawl;


	level.scr_anim[ "impaled" ][ "idle" ][ 0 ] 			 = %afchase_impaled_guy_idle;
	level.scr_anim[ "impaled" ][ "react" ]		 		 = %afchase_impaled_guy_react;
	level.scr_anim[ "impaled" ][ "react_death" ]		 = %afchase_impaled_guy_react_end;
	level.scr_anim[ "impaled" ][ "react_loop" ][0]		 = %afchase_impaled_guy_react_idle;

//	level.scr_anim[ "impaled" ][ "react" ]		 	 = %afchase_impaled_guy_reactB;


	level.scr_anim[ "impaled" ][ "death" ]		 	 = %afchase_impaled_guy_knife_death;

	level.scr_anim[ "impaled" ][ "aim_controller" ]		 = %afchase_impaled_additive;
	level.scr_anim[ "impaled" ][ "aim_6" ]		 		 = %afchase_impaled_guy_aim6;
	level.scr_anim[ "impaled" ][ "aim_4" ]		 		 = %afchase_impaled_guy_aim4;

	level.scr_anim[ "shepherd" ][ "flee" ]		 	 = %afchase_shepherd_flee;
	level.scr_anim[ "shepherd" ][ "run" ]		 	 = %afchase_shepherd_flee_loop;

	level.scr_anim[ "shepherd" ][ "knifepull_throw_kill" ]		 	 = %afchase_Shepherd_dies;
	level.scr_anim[ "price" ][ "knifepull_throw_kill" ]		 		 = %afchase_price_Shepherd_dies;
	addNotetrack_sound( "shepherd" , "bodyfall large" , "knifepull_throw_kill" , "scn_afchase_shepherd_death_bodyfall" );
	addNotetrack_customFunction( "shepherd", "slowmo_early", ::shepherd_slowmo );
	addNotetrack_customFunction( "shepherd", "slowmo", ::shepherd_slowmo );
	addNotetrack_customFunction( "shepherd", "settle", ::shepherd_slowmo_ends );


	addNotetrack_customFunction( "impaled", "click", ::click );
	addNotetrack_customFunction( "impaled", "stop_aim", ::stop_aim, "react_death" );
	addNotetrack_customFunction( "impaled", "start_aim", ::start_aim, "react" );
	addNotetrack_customFunction( "impaled", "pistol_pickup", ::delete_glock );

	//footstep fx
	addNotetrack_customFunction( "shepherd", "footstep_right_large", ::right_footstep_fx );
	addNotetrack_customFunction( "shepherd", "footstep_left_large", ::left_footstep_fx );
	addNotetrack_customFunction( "shepherd", "footstep_right_small", ::right_footstep_small_fx );
	addNotetrack_customFunction( "shepherd", "footstep_left_small", ::left_footstep_small_fx );

	addNotetrack_customFunction( "price", "footstep_right_large", ::right_footstep_fx );
	addNotetrack_customFunction( "price", "footstep_left_large", ::left_footstep_fx );
	addNotetrack_customFunction( "price", "footstep_right_small", ::right_footstep_small_fx );
	addNotetrack_customFunction( "price", "footstep_left_small", ::left_footstep_small_fx );

	addNotetrack_customFunction( "nikolai", "footstep_right_large", ::right_footstep_fx, "walk_off" );
	addNotetrack_customFunction( "nikolai", "footstep_left_large", ::left_footstep_fx, "walk_off" );
	addNotetrack_customFunction( "nikolai", "footstep_right_small", ::right_footstep_small_fx, "walk_off" );
	addNotetrack_customFunction( "nikolai", "footstep_left_small", ::left_footstep_small_fx, "walk_off" );

	//body fall fx
	addNotetrack_customFunction( "shepherd", "bodyfall large", ::bodyfall_fx );
	addNotetrack_customFunction( "shepherd", "bodyfall small", ::bodyfall_fx );

	addNotetrack_customFunction( "price", "bodyfall large", ::bodyfall_fx );
	addNotetrack_customFunction( "price", "bodyfall small", ::bodyfall_fx );

//	level.scr_sound[ "generic" ][ "zodiac_rapids_sniper" ] = "afchase_pri_holdsteady";


	level.scr_sound[ "generic" ][ "afchase_pri_steady1" ] = "afchase_pri_steady1";
	level.scr_sound[ "generic" ][ "afchase_pri_steady2" ] = "afchase_pri_steady2";

	// Five years ago, I lost 30,000 men in the blink of an eye��and the world just fuckin' watched.	
	level.scr_sound[ "shepherd" ][ "afchase_shp_fiveyearsago" ] = "afchase_shp_fiveyearsago";
	// Tomorrow...there will be no shortage of volunteers...no shortage of patriots.			
	level.scr_sound[ "shepherd" ][ "afchase_shp_noshortage" ] = "afchase_shp_noshortage";
	// I know you understand�		
	level.scr_sound[ "shepherd" ][ "afchase_shp_iknow" ] = "afchase_shp_iknow";
	

	// Avatar One, gimme a sitrep, over!		self waittill( "trigger" );
	level.scr_radio[ "afchase_shp_sitrep" ] = "afchase_shp_sitrep";
	// I have Warhorse 5-1 standing by. Pave Low's downriver sir.		
	level.scr_radio[ "afchase_uav_downriver" ] = "afchase_uav_downriver";
	// Copy that! Warhorse 5-1, be advised, we're comin' in hot!		
	level.scr_radio[ "afchase_shp_comininhot" ] = "afchase_shp_comininhot";
	// Roger - dropping the hatch - keep it above 30 knots and watch the vertical clearance.		
	level.scr_radio[ "afchase_plp_above30knots" ] = "afchase_plp_above30knots";

	// You know what they say about revenge�you better be ready to dig two graves�	
	level.scr_sound[ "generic" ][ "afchase_shp_digtwograves" ] = "afchase_shp_digtwograves";
	// Go ahead and end it. It won't change anything.		
	level.scr_sound[ "generic" ][ "afchase_shp_goahead" ] = "afchase_shp_goahead";
	// Hmph. I knew you couldn't do it�		
	level.scr_sound[ "generic" ][ "afchase_shp_couldntdoit" ] = "afchase_shp_couldntdoit";
	// You're a good warrior�		
	level.scr_sound[ "generic" ][ "afchase_shp_goodwarrior" ] = "afchase_shp_goodwarrior";
	// �but you could never take that extra step�		
	level.scr_sound[ "generic" ][ "afchase_shp_extrastep" ] = "afchase_shp_extrastep";
	// �to do what was absolutely necessary.		
	level.scr_sound[ "generic" ][ "afchase_shp_necessary" ] = "afchase_shp_necessary";
	
	

}                      

shepherd_death_fx( guy )
{
	tag = "J_EyeBall_LE";
	tag_origin = spawn_tag_origin();
	tag_origin LinkTo( level.shepherd, tag, (0,0,0), (0,90,0) );  // pitch yaw roll
	//tag_origin thread maps\_debug::drawtagforever( "tag_origin" );
	
	PlayFXOnTag( getfx( "blood_sheperd_eye_geotrail" ), tag_origin, "tag_origin" );

	spurts = 3;

	for ( i=0; i<spurts; i++ )
	{
		PlayFXOnTag( getfx( "blood_sheperd_eye" ), tag_origin, "tag_origin" );
		wait randomfloatrange( 0.1, 0.15 );
	}
}

shepherd_slowmo( guy )
{
//	level.fov_ent moveto( (65,0,0), blend_out_time, blend_out_time * 0.5, blend_out_time * 0.5 );
//	println( 1 );
//	wait( 0.2 );
//	slowmo_start();
//	slowmo_setspeed_slow( 0.15 );
//	slowmo_setlerptime_in( 0 );
//	slowmo_lerp_in();
}


shepherd_slowmo_ends( guy )
{
//	wait( 0.85 );
	slowmo_start();
	slowmo_setspeed_slow( 0.33 );
	slowmo_setlerptime_in( 0 );
	slowmo_lerp_in();

	wait 2;

	slowmo_setlerptime_out( 1 );
	slowmo_lerp_out();
	slowmo_end();
}

blend_to_ending_dof_fov( blend_out_time )
{
	if ( !isdefined( blend_out_time ) )
		blend_out_time = 14;
		
	maps\af_chase_knife_fight_code::blend_to_ending_dof( blend_out_time );
	level.fov_ent moveto( (65,0,0), blend_out_time, blend_out_time * 0.5, blend_out_time * 0.5 );
}


delete_glock( guy )
{
	if ( IsDefined( level.glock ) )
		level.glock Delete();

	origin = guy GetTagOrigin( "tag_weapon_right" );
	angles = guy GetTagAngles( "tag_weapon_right" );

	PrintLn( "	// origin and angles for the gun on the ground" );
	PrintLn( "	gun_org = ( " + origin[ 0 ] + ", " + origin[ 1 ] + ", " + origin[ 2 ] + " );" );
	PrintLn( "	gun_ang = ( " + angles[ 0 ] + ", " + angles[ 1 ] + ", " + angles[ 2 ] + " );" );
	PrintLn( " " );
}

start_aim( guy )
{
	guy thread impaled_aims_at_player();
}

impaled_aims_at_player()
{
	self endon( "death" );
	self endon( "stop_aim" );

	controller = self getanim( "aim_controller" );
	left_anim = self getanim( "aim_6" );
	right_anim = self getanim( "aim_4" );
	range = 45;

	self SetAnim( controller, 1, 0.2, 1 );

	for ( ;; )
	{
		right = AnglesToRight( self.angles );
		othervec = VectorNormalize( level.player.origin - self.origin );

		forward = AnglesToForward( self.angles );
		right = AnglesToRight( self.angles );

		forward_dot = VectorDot( forward, othervec );
		right_dot = VectorDot( right, othervec );

		//println( " ");
		//println( "forward dot " + forward_dot );
		//println( "right dot " + right_dot );

		degrees = ACos( forward_dot );
		//println( "degrees " + degrees );
		degrees = abs( degrees );

		weight = 0;
		if ( right_dot > 0 )
		{
			if ( degrees > range )
				degrees = range;

			weight = degrees / range;
			self SetAnim( left_anim, weight, 0.2, 1 );
			self SetAnim( right_anim, 1 - weight, 0.2, 1 );
		}
		else
		{
			degrees += 10;
			if ( degrees > range )
				degrees = range;

			weight = degrees / range;
			self SetAnim( right_anim, weight, 0.2, 1 );
			self SetAnim( left_anim, 1 - weight, 0.2, 1 );
		}

		//forward = AnglesToForward( self.angles );
		//Line( self.origin, self.origin + forward * 150, (1,0,0) );
		//Line( self.origin, level.player.origin, (1,1,1) );
		//Print3d( self.origin, degrees, (1,1,0), 1, 1 );
		//Print3d( self.origin + (0,0,30), weight, (1,1,1), 1, 1 );

		wait( 0.05 );
	}
}

price_aims_at_end_heli()
{
	self endon( "death" );
	self endon( "stop_aim" );

	controller = self getanim( "aim_controller" );
	left_anim = self getanim( "aim_4" );
	right_anim = self getanim( "aim_6" );
	range = 45;

	self SetAnim( controller, 1, 0.2, 1 );

	for ( ;; )
	{
		right = AnglesToRight( self.angles );
		othervec = VectorNormalize( level.player.origin - self.origin );

		forward = AnglesToForward( self.angles );
		right = AnglesToRight( self.angles );

		forward_dot = VectorDot( forward, othervec );
		right_dot = VectorDot( right, othervec );

		//println( " ");
		//println( "forward dot " + forward_dot );
		//println( "right dot " + right_dot );

		degrees = ACos( forward_dot );
		//println( "degrees " + degrees );
		degrees = abs( degrees );

		weight = 0;
		if ( right_dot > 0 )
		{
			if ( degrees > range )
				degrees = range;

			weight = degrees / range;
			self SetAnim( left_anim, weight, 0.2, 1 );
			self SetAnim( right_anim, 1 - weight, 0.2, 1 );
		}
		else
		{
			degrees += 10;
			if ( degrees > range )
				degrees = range;

			weight = degrees / range;
			self SetAnim( right_anim, weight, 0.2, 1 );
			self SetAnim( left_anim, 1 - weight, 0.2, 1 );
		}

		//forward = AnglesToForward( self.angles );
		//Line( self.origin, self.origin + forward * 150, (1,0,0) );
		//Line( self.origin, level.player.origin, (1,1,1) );
		//Print3d( self.origin, degrees, (1,1,0), 1, 1 );
		//Print3d( self.origin + (0,0,30), weight, (1,1,1), 1, 1 );

		wait( 0.05 );
	}
}


stop_aim( guy )
{
	guy notify( "stop_aim" );
}

click( guy )
{
	guy.clicks++;
	if ( guy.clicks >= 6 )
	{
		if ( randomint( 100 ) > 50 )
			return;
	}
		
	org = guy GetTagOrigin( "tag_inhand" );
	play_sound_in_space( "scn_afchase_dryfire_pistol_npc", org );
}

#using_animtree( "player" );
player_animations()
{
	level.scr_animtree[ "player_rig" ] 								 = #animtree;
	level.scr_model[ "player_rig" ] 								 = "ch_viewhands_player_gk_m4_sopmod_ii";
	level.scr_anim[ "player_rig" ][ "wakeup" ] 				 = %player_afchase_ending_wakeup;

	level.scr_anim[ "player_rig" ][ "prethrow" ] 				 = %player_afchase_ending_knife_throw_soon;


	level.scr_anim[ "player_rig" ][ "turn_buckle" ] = %player_afchase_ending_turnbuckle;
	addNotetrack_detach( "player_rig", "vision_effect" , "weapon_commando_knife", "TAG_WEAPON_LEFT", "turn_buckle" );
	addNotetrack_customFunction( "player_rig", "rumble", ::rumble_bash, "turn_buckle" );
	addNotetrack_customFunction( "player_rig", "vision_effect", ::face_slam, "turn_buckle" );
	addNotetrack_customFunction( "player_rig", "fadeout", ::fade_out, "turn_buckle" );

	level.scr_anim[ "player_rig" ][ "turn_buckle_alt" ] = %player_afchase_ending_turnbuckle_alt;
	addNotetrack_detach( "player_rig", "vision_effect" , "weapon_commando_knife", "TAG_WEAPON_LEFT", "turn_buckle_alt" );
	addNotetrack_customFunction( "player_rig", "rumble", ::rumble_bash, "turn_buckle_alt" );
	addNotetrack_customFunction( "player_rig", "vision_effect", ::face_slam, "turn_buckle_alt" );
	addNotetrack_customFunction( "player_rig", "fadeout", ::fade_out, "turn_buckle_alt" );
	

	level.scr_anim[ "player_rig" ][ "gun_drop_player" ] = %player_afchase_ending_gun_drop;
	level.scr_anim[ "player_rig" ][ "gun_kick" ] = %player_afchase_ending_gun_kick;
	addNotetrack_customFunction( "player_rig", "rumble", maps\af_chase_knife_fight_code::fade_out_gun_kick, "gun_kick" );
	addNotetrack_customFunction( "player_rig", "vision_effect", ::face_stomp, "gun_kick" );
//	addNotetrack_customFunction( "player_rig", "fadeout" , maps\af_chase_knife_fight_code::fade_out_gun_kick, "gun_kick" );

	level.scr_anim[ "player_rig" ][ "knife_moment" ] = %player_afchase_ending_knife_moment;


	level.scr_anim[ "player_rig" ][ "gun_monologue" ] = %player_afchase_ending_monologue;
	addNotetrack_customFunction( "player_rig", "dof", maps\af_chase_knife_fight_code::dof_to_gun, "gun_monologue" );


//	addNotetrack_detach( "player_rig" , "switch_model", "weapon_parabolic_knife" , "TAG_INHAND" , anime );	
	level.scr_anim[ "player_rig" ][ "walk_off" ] = %player_afchase_walkoff;

	level.scr_anim[ "player_rig" ][ "gun_crawl_00" ] 						 = %player_afchase_ending_gun_crawl_00;
	level.scr_anim[ "player_rig" ][ "gun_crawl_01" ] 						 = %player_afchase_ending_gun_crawl_01;
	level.scr_anim[ "player_rig" ][ "gun_crawl_02" ] 						 = %player_afchase_ending_gun_crawl_02;
	level.scr_anim[ "player_rig" ][ "gun_crawl_03" ] 						 = %player_afchase_ending_gun_crawl_03;
	level.scr_anim[ "player_rig" ][ "gun_crawl_04" ] 						 = %player_afchase_ending_gun_crawl_04;
	level.scr_anim[ "player_rig" ][ "gun_crawl_05" ] 						 = %player_afchase_ending_gun_crawl_05;
	level.scr_anim[ "player_rig" ][ "gun_crawl_06" ] 						 = %player_afchase_ending_gun_crawl_06;
	level.scr_anim[ "player_rig" ][ "gun_crawl_00_idle" ][ 0 ] 				 = %player_afchase_ending_gun_crawl_idle_00;
	level.scr_anim[ "player_rig" ][ "gun_crawl_01_idle" ][ 0 ] 				 = %player_afchase_ending_gun_crawl_idle_01;
	level.scr_anim[ "player_rig" ][ "gun_crawl_02_idle" ][ 0 ] 				 = %player_afchase_ending_gun_crawl_idle_02;
	level.scr_anim[ "player_rig" ][ "gun_crawl_03_idle" ][ 0 ] 				 = %player_afchase_ending_gun_crawl_idle_03;
	level.scr_anim[ "player_rig" ][ "gun_crawl_04_idle" ][ 0 ] 				 = %player_afchase_ending_gun_crawl_idle_04;
	level.scr_anim[ "player_rig" ][ "gun_crawl_05_idle" ][ 0 ] 				 = %player_afchase_ending_gun_crawl_idle_05;
	level.scr_anim[ "player_rig" ][ "gun_crawl_06_idle" ][ 0 ] 				 = %player_afchase_ending_gun_crawl_idle_06;
	level.scr_anim[ "player_rig" ][ "knifepull_grab_01" ]					 = %player_afchase_ending_knife_grab_01;
	level.scr_anim[ "player_rig" ][ "knifepull_grab_02" ]					 = %player_afchase_ending_knife_grab_02;
	level.scr_anim[ "player_rig" ][ "knifepull_grab_03" ]					 = %player_afchase_ending_knife_grab_03;
	level.scr_anim[ "player_rig" ][ "knifepull_passout" ]					 = %player_afchase_ending_knife_passout;
	level.scr_anim[ "player_rig" ][ "knifepull_pull_01" ]					 = %player_afchase_ending_knife_pull_01;
	level.scr_anim[ "player_rig" ][ "knifepull_pull_02" ]					 = %player_afchase_ending_knife_pull_02;
	level.scr_anim[ "player_rig" ][ "knifepull_pull_03" ]					 = %player_afchase_ending_knife_pull_03;
	level.scr_anim[ "player_rig" ][ "knifepull_pullout_flip" ]				 = %player_afchase_ending_knife_pullout_2_flip;
	
	addNotetrack_customFunction( "player_rig", "blood", ::player_pulls_knife_out, "knifepull_pullout_flip" );
	addNotetrack_customFunction( "player_rig", "right_hand", ::right_hand_impact_fx );
	addNotetrack_customFunction( "player_rig", "left_hand", ::left_hand_impact_fx );

	
	level.scr_anim[ "player_rig" ][ "knifepull_pullout_flip_idle" ][ 0 ]	 = %player_afchase_ending_knife_pullout_2_flip_idle;
	level.scr_anim[ "player_rig" ][ "knifepull_throw" ]						 = %player_afchase_ending_knife_throw;
	level.scr_anim[ "player_rig" ][ "knifepull_throw_kill" ]				 = %player_afchase_ending_knife_throw_kill;
	level.scr_anim[ "player_rig" ][ "price_wakeup" ]						 = %player_afchase_ending_wakeup_end;

	level.scr_anim[ "player_rig" ][ "pull_additive_root" ]					 = %player_pull_additive;
	level.scr_anim[ "player_rig" ][ "pull_additive" ]						 = %player_afchase_ending_knife_pull_02_add;
}

player_pulls_knife_out( player )
{
	player_pulls_knife_from_chest( 3 );
}

player_pulls_knife_from_chest( time )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
	level notify ( "stop_random_breathing_sounds" );
	flag_set( "stop_heart" );
	flag_clear( "player_heartbeat_sound" );
//	level.player ShellShock( "af_chase_ending_pulling_knife_later", time );	
	set_vision_set( "aftermath_nodesat", time );
	//set_vision_set( "af_chase_ending_final", time );

	level.player ShellShock( "slowview", 5000 );
}

face_slam( guy )
{
	level.player PlayRumbleOnEntity( "damage_light" );
//	maps\af_chase_knife_fight_code::shellshock_very_long( "af_chase_turn_buckle_slam" );
	overlay = maps\af_chase_knife_fight_code::get_white_overlay();
	overlay.alpha = 1;
	overlay FadeOverTime( 1.0 );
	overlay.alpha = 0.0;
	level.player stopshellshock();
	SetBlur( 0 , 2 );
	level.player set_vision_set( "af_chase_ending_noshock" );
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

face_stomp( guy )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
	level.player DoDamage( 50 / level.player.damageMultiplier, level.player.origin );
	level.player thread play_sound_on_entity( "face_stomp" );
	maps\af_chase_knife_fight_code::shellshock_very_long( "af_chase_turn_buckle_slam" );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	wait 0.05;
	level.player setnormalhealth( 1 );
}


#using_animtree( "script_model" );
script_model_animations()
{
	level.scr_animtree[ "gun_model" ] 								 = #animtree;
	level.scr_model[ "gun_model" ] 								 = "weapon_colt_anaconda_animated";
	level.scr_anim[ "gun_model" ][ "gun_drop" ] = %afchase_ending_revolver_gun_drop;
	level.scr_anim[ "gun_model" ][ "gun_kick_gun" ] = %afchase_ending_revolver_gun_kick;
	level.scr_anim[ "gun_model" ][ "gun_monologue" ] = %afchase_ending_revolver_gun_monologue;
	//addNotetrack_customFunction( "gun_model", "bullets" , ::bullets_notify , "gun_monologue");
	//addNotetrack_customFunction( "knife", "blood" , ::blood_from_player, "turnbuckle" );
	addNotetrack_customFunction( "gun_model", "bullets", ::shelleject_fx, "gun_monologue" );

	level.scr_model[ "knife" ] = "weapon_commando_knife";
	level.scr_animtree[ "knife" ] 				 = #animtree;

	level.scr_anim[ "knife" ][ "turn_buckle" ] 							 = %afchase_ending_knife_gun_turnbuckle;
//	addNotetrack_customFunction( "knife", "blood", ::knife_in_player, "turn_buckle" );
//	Prep work for the stab fx, knife model anim still needs to be hookedup
	addNotetrack_customFunction( "knife", "blood", ::playerstabbed_fx, "turn_buckle" );

	level.scr_anim[ "knife" ][ "turn_buckle_alt" ] 							 = %afchase_ending_knife_gun_turnbuckle_alt;
//	addNotetrack_customFunction( "knife", "blood", ::knife_in_player, "turn_buckle_alt" );
//	Prep work for the stab fx, knife model anim still needs to be hookedup
	addNotetrack_customFunction( "knife", "blood", ::playerstabbed_fx, "turn_buckle_alt" );


	level.scr_anim[ "knife" ][ "gun_drop" ] 							 = %afchase_ending_knife_gun_drop;
	level.scr_anim[ "knife" ][ "gun_monologue" ]				 		 = %afchase_ending_knife_gun_monologue;
	level.scr_anim[ "knife" ][ "knifepull_grab_01" ] 					 = %afchase_ending_knife_grab_01;
	level.scr_anim[ "knife" ][ "knifepull_grab_02" ] 					 = %afchase_ending_knife_grab_02;
	level.scr_anim[ "knife" ][ "knifepull_grab_03" ] 					 = %afchase_ending_knife_grab_03;
	level.scr_anim[ "knife" ][ "knifepull_passout" ] 					 = %afchase_ending_knife_passout;
	level.scr_anim[ "knife" ][ "knifepull_pull_01" ] 					 = %afchase_ending_knife_pull_01;
	level.scr_anim[ "knife" ][ "knifepull_pull_02" ] 					 = %afchase_ending_knife_pull_02;
	level.scr_anim[ "knife" ][ "knifepull_pull_03" ] 					 = %afchase_ending_knife_pull_03;
	level.scr_anim[ "knife" ][ "knifepull_pullout_flip" ] 				 = %afchase_ending_knife_pullout_2_flip;
	level.scr_anim[ "knife" ][ "knifepull_pullout_flip_idle" ][ 0 ]		 = %afchase_ending_knife_pullout_2_flip_idle;
	level.scr_anim[ "knife" ][ "knifepull_throw" ] 						 = %afchase_ending_knife_throw;
	level.scr_anim[ "knife" ][ "knifepull_throw_kill" ]					 = %afchase_ending_knife_throw_kill;

	addNotetrack_customFunction( "knife", "blood", ::playerstabbed_fx, "turn_buckle" );
	addNotetrack_customFunction( "knife", "knife_in_eye", ::shepherd_death_fx, "knifepull_throw_kill" );
	addNotetrack_customFunction( "knife", "knife_out", ::playerstabbed_fx, "knifepull_pullout_flip" );


	level.scr_anim[ "rotation" ][ "z_down" ] = %rotate_Z_L;
	
	level.scr_anim[ "knife" ][ "prethrow" ] 				 = %afchase_ending_knife_throw_soon;
	
}

rumble_bash( guy )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

fade_out( guy )
{
	flag_set( "turn_buckle_fadeout" );
}


#using_animtree( "vehicles" );
script_vehicle_animations()
{

	level.scr_anim[ "littlebird" ][ "walk_off" ] = %afchase_chopper_landing;
 	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall_right" ] = %AFchase_waterfall_zodiac_R;
 	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall_left" ] = %AFchase_waterfall_zodiac_L;
 	
 	level.scr_anim[ "zodiac_player" ][ "waterfall_over" ] = %AFchase_waterfall_zodiac_fall;
 	
// 	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall_add" ]	 = %zodiac_waterfall_add;
//	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall" ]		 = %zodiac_waterfall;
	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall_add_left" ]	 = %zodiac_waterfall_add_left;
	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall_left" ]		 = %AFchase_waterfall_player_zodiac_add_L;
	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall_add_right" ]	 = %zodiac_waterfall_add_right;
	level.scr_anim[ "zodiac_player" ][ "zodiac_waterfall_right" ]		 = %AFchase_waterfall_player_zodiac_add_R;	

	//whole scene.
 	level.scr_anim[ "zodiac_player" ][ "sniper_waterfall" ] = %AFchase_waterfall_player_zodiac;
 	level.scr_anim[ "pavelow" ][ "sniper_waterfall" ] = %AFchase_waterfall_pavelow;
 	level.scr_anim[ "pavelow" ][ "sniper_waterfall_idle" ][0] = %AFchase_waterfall_pavelow_idle;
// 	addNotetrack_flag( "zodiac_player" , "steady_1" , "price_steady1" , "sniper_waterfall" );
// 	addNotetrack_flag( "zodiac_player" , "steady_2" , "price_steady2" , "sniper_waterfall" );
// 	addNotetrack_flag( "zodiac_player" , "steady_3" , "price_steady3" , "sniper_waterfall" );

  	addNotetrack_flag( "zodiac_player" , "shoot" , "price_steady_shoot" , "sniper_waterfall" );
 	
}


bullets_notify( guy )
{

	level notify( "bullets" );
}

playerstabbed_fx( knife )
{
	maps\af_chase_knife_fight_code::swap_knife();
	//IPrintLnBold( "Suirt Squirt" );
	PlayFXOnTag( getfx( "player_stabbed" ), knife, "TAG_FX" );
}

shelleject_fx( gun )
{
	//IPrintLnBold( "Bullets" );
	PlayFXOnTag( getfx( "revolver_bullets" ), gun, "J_Cylinder_Spin" );
}

right_footstep_fx( guy )
{
	//iprintlnbold( "right" );
	PlayFXOnTag( getfx( "footstep_dust_sandstorm_runner" ), guy, "J_Ball_RI" );
}

left_footstep_fx( guy )
{
	//iprintlnbold( "left" );
	PlayFXOnTag( getfx( "footstep_dust_sandstorm_runner" ), guy, "J_Ball_LE" );
}

right_footstep_small_fx( guy )
{
	//iprintlnbold( "right" );
	PlayFXOnTag( getfx( "footstep_dust_sandstorm_small_runner" ), guy, "J_Ball_RI" );
}

left_footstep_small_fx( guy )
{
	//iprintlnbold( "left" );
	PlayFXOnTag( getfx( "footstep_dust_sandstorm_small_runner" ), guy, "J_Ball_LE" );
}

right_hand_impact_fx( guy )
{
	//iprintlnbold( "right" );
	PlayFXOnTag( getfx( "crawl_dust_sandstorm_runner" ), guy, "J_Mid_RI_2" );
}

left_hand_impact_fx( guy )
{
	//iprintlnbold( "left" );
	PlayFXOnTag( getfx( "crawl_dust_sandstorm_runner" ), guy, "J_Mid_LE_2" );
}

bodyfall_fx( guy )
{
	//iprintlnbold( "body" );
	PlayFXOnTag( getfx( "bodyfall_dust_sandstorm_large_runner" ), guy, "J_SpineUpper" );
}


gun_fire( guy )
{
	maps\af_chase_knife_fight_code::fire_gun();

	time = 0.5;
	level.fov_ent MoveTo( ( 40, 0, 0 ), time, 0, time );
}


add_fighte_animsounds()
{
	level.scr_animSound[ "price" ][ "0fight_E_loop" ] = "scn_afchase_e_loop_price_foley";
	level.scr_animSound[ "shepherd" ][ "0fight_E_loop" ] = "scn_afchase_e_loop_shep_foley";
}

remove_fighte_animsounds()
{
	level.scr_animSound[ "price" ][ "0fight_E_loop" ] = undefined;
	level.scr_animSound[ "shepherd" ][ "0fight_E_loop" ] = undefined;
}
