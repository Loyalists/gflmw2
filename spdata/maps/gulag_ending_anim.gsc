#include maps\_utility;
#include maps\_vehicle;
#include maps\_vehicle_spline;
#include maps\_anim;
#include maps\_hud_util;
#include maps\gulag_ending_code;
#include common_scripts\utility;

gulag_ending_anim_main()
{
	endlog_run_anims();
	endlog_player_animations();
	endlog_scrip_model_animations();
	endlog_vehicle_animations();
}

#using_animtree( "generic_human" );
endlog_run_anims()
{
	level.scr_anim[ "generic" ][ "panic_run" ] = %unarmed_panickedrun_loop_V2;
	level.scr_anim[ "generic" ][ "panic_stumble" ] = %unarmed_panickedrun_stumble;
	level.scr_anim[ "generic" ][ "run_root" ] = %combatrun_forward;
	//level.scr_anim[ "generic" ][ "stumble_knee" ] = %run_nopain_fallonknee;

	level.scr_anim[ "generic" ][ "reaction_180" ] = %run_reaction_180;
	level.scr_anim[ "generic" ][ "run_180" ] = %run_turn_180;

	level.scr_anim[ "generic" ][ "run_duck" ] = %run_react_duck;
	level.scr_anim[ "generic" ][ "run_flinch" ] = %run_react_flinch;
	level.scr_anim[ "generic" ][ "run_stumble" ] = %run_react_stumble;
	
	level.scr_anim[ "generic" ][ "walk_and_run_loops" ] = %walk_and_run_loops;
	
	level.scr_anim[ "generic" ][ "slide_across_car" ] = %slide_across_car;
	
	level.scr_anim[ "stumble_baddie" ][ "stumble" ] = %DC_Burning_bunker_stumble;
	
	
	level.scr_anim[ "price" ][ "price_breach" ] 				= %gulag_rescueA_Price;
	level.scr_anim[ "chokey" ][ "price_breach" ] 				= %gulag_rescueA_enemy;
	
	level.scr_anim[ "price" ][ "price_rescue" ] 				= %gulag_rescueB_Price_reshootB;
	level.scr_anim[ "soap" ][ "price_rescue" ] 					= %gulag_rescueB_soldier1_reshootB;
	level.scr_anim[ "redshirt" ][ "price_rescue" ] 				= %gulag_rescueB_soldier2_reshootB;

	level.scr_sound[ "price" ][ "price_rescue" ] 				= "scn_gulag_price_rescue_b_dx";



	level.scr_anim[ "old_soap" ][ "price_rescue" ] 				= %gulag_rescueB_soldier1_reshoot;

	level.scr_anim[ "price" ][ "price_rescue_intro" ] 			= %gulag_rescueB_Price_intro;
//	level.scr_anim[ "price" ][ "price_rescue_intro_loop" ][0] 	= %gulag_rescueB_Price_idle;
	
	addNotetrack_customFunction( "price", "bang", ::rescue_exploder, "price_rescue" );
	
	level.scr_anim[ "soap" ][ "cafe_entrance" ] 				= %gulag_end_beginning_soap;
	level.scr_anim[ "price" ][ "cafe_entrance" ] 				= %gulag_end_beginning_soldier;
	level.scr_anim[ "redshirt" ][ "cafe_entrance" ] 			= %gulag_end_beginning_price;

	level.scr_anim[ "soap" ][ "cafe_entrance" ] 				= %gulag_cafeteria_soap;
	level.scr_anim[ "price" ][ "cafe_entrance" ] 				= %gulag_cafeteria_price;
	level.scr_anim[ "redshirt" ][ "cafe_entrance" ] 			= %gulag_cafeteria_soldier;
	
	addNotetrack_dialogue( "soap", "dialog", "cafe_entrance", "gulag_cmt_whereareyou" );

	
	
	level.scr_anim[ "price" ][ "gate" ] 	= %gulag_end_run2gate_price;
	level.scr_anim[ "redshirt" ][ "gate" ] 	= %gulag_end_run2gate_soldier;

	level.scr_anim[ "price" ][ "cafe_dustcover" ] 				= %gulag_end_dustcover_price;
	level.scr_anim[ "redshirt" ][ "cafe_dustcover" ] 			= %gulag_end_dustcover_soldier;
	level.scr_anim[ "soap" ][ "cafe_dustcover_idle" ][0]		= %gulag_end_soap_idle;
	
	
	level.scr_anim[ "redshirt" ][ "cafe_runback" ] 				= %gulag_end_runback_soldier;
	level.scr_anim[ "soap" ][ "cafe_runback" ] 					= %gulag_end_runback_soap;
	level.scr_anim[ "price" ][ "cafe_runback" ] 				= %gulag_end_runback_price;

	level.scr_anim[ "redshirt" ][ "evac" ] 	= %gulag_end_evac_soldier;
	level.scr_anim[ "price" ][ "evac" ] 	= %gulag_end_evac_price;
	level.scr_anim[ "soap" ][ "evac" ] 		= %gulag_end_evac_soap;
	addNotetrack_dialogue( "price", "dialog", "evac", "gulag_pri_doitfast" );

	level.scr_anim[ "generic" ][ "gundrop_death" ] = %death_explosion_stand_B_v1; //death_explosion_run_B_v1;
	
	addNotetrack_customFunction( "soap", "fire", ::soap_fires_flare, "evac" );
	
	addNotetrack_customFunction( "soap", "player", ::got_player_notetrack, "evac" );
}

rescue_exploder( price )
{
	wait( 0.1 );
	flag_set( "background_explosion" );
	exploder( "background_explosion" );
}

soap_fires_flare( soap )
{
	tag_origin = spawn_taG_origin();
	tag_origin.origin = soap gettagorigin( "tag_laser" );
	tag_origin.angles = soap gettagangles( "tag_laser" );
	forward = anglestoforward( tag_origin.angles );
	
	start = getfx( "flare_start_gulag" );
	PlayFXOnTag( start, tag_origin, "tag_origin" );
	
	burn = getfx( "flare_gulag" );
	PlayFXOnTag( burn, tag_origin, "tag_origin" );

	tag_origin MoveTo( tag_origin.origin + (0,0,2000), 3, 0, 0 );	
	wait( 4 );
	tag_origin delete();
}

got_player_notetrack( soap )
{
//	flag_set( "player_uses_rig" );
//  waittillframeend;
	soap.got_player_notetrack = true;
	trigger = getentwithflag( "player_uses_rig" );
	trigger trigger_off();
	
	flag_set( "player_evac" );
	
	
	if ( flag( "player_uses_rig" ) )
		return;
	
	wait( 2 );
	thread maps\gulag_ending_code::player_dies_to_cavein( 0 );
	scale = 0.4;
	time = 0.1;
	for ( ;; )
	{
		Earthquake( scale, time, level.player.origin, 5000 );
		wait( time );
		scale+= 0.2 / 5;
	}
}

#using_animtree( "player" );
endlog_player_animations()
{
	level.scr_animtree[ "player_rig" ] 							 = #animtree;
	level.scr_model[ "player_rig" ] 							 = "ch_viewhands_player_gk_ar15";

	level.scr_anim[ "player_rig" ][ "evac" ] 		= %gulag_end_buried_player;
	level.scr_anim[ "player_rig" ][ "fly_away" ] 	= %gulag_end_evac_player;
	level.scr_anim[ "player_rig" ][ "hookup" ] 		= %gulag_end_evac_player_hookup;
	level.scr_anim[ "player_rig" ][ "idle" ][0] 	= %gulag_end_evac_player_idle;
	
	level.player_anim = %gulag_end_evac_player;

	level.scr_anim[ "player_rig" ][ "price_breach" ] 		= %gulag_rescueA_player;
	level.scr_anim[ "player_rig" ][ "price_rescue" ] 		= %gulag_rescueB_player_reshootB;

//	level.scr_anim[ "player_rig" ][ "price_rescue_intro" ] 			= %gulag_rescueB_player_intro;
//	level.scr_anim[ "player_rig" ][ "price_rescue_intro_loop" ][0] 	= %gulag_rescueB_player_idle;
	addNotetrack_customFunction( "player_rig", "black", ::black_screen );
}


#using_animtree( "script_model" );
endlog_scrip_model_animations()
{
	level.scr_animtree[ "rock" ] 						= #animtree;
	level.scr_model[ "rock" ] 							= "gulag_rock";
	level.scr_anim[ "rock" ][ "evac" ] 					= %gulag_prop_rock;
	
	level.scr_animtree[ "post" ] 						= #animtree;
	level.scr_model[ "post" ] 							= "gulag_post";
	level.scr_anim[ "post" ][ "gate" ] 					= %gulag_prop_post;
	
	level.scr_animtree[ "lamp" ] 						= #animtree;
	level.scr_model[ "lamp" ] 							= "ch_industrial_light_animated_01_on";
	level.scr_anim[ "lamp" ][ "swing" ] 				= %swinging_industrial_light_01_mild;
	level.scr_anim[ "lamp" ][ "swing_dup" ] 			= %swinging_industrial_light_01_mild_dup;
	
	level.scr_animtree[ "lamp_off" ] 					= #animtree;
	level.scr_model[ "lamp_off" ] 						= "ch_industrial_light_animated_01_off";

	
	level.scr_animtree[ "ending_rope" ] 				= #animtree;
	level.scr_model[ "ending_rope" ] 					= "gulag_escape_rope_100ft";
	level.scr_anim[ "ending_rope" ][ "evac" ] 			= %gulag_escape_rope;
	level.rope_anim = %gulag_escape_rope;
		

	level.scr_animtree[ "player_carabiner" ] 			= #animtree;
	level.scr_model[ "player_carabiner" ] 				= "weapon_carabiner";
	level.scr_anim[ "player_carabiner" ][ "hookup" ]	= %gulag_prop_carabiner;

	level.scr_animtree[ "1911" ] 						= #animtree;
	level.scr_model[ "1911" ] 							= "weapon_colt1911_black";
	level.scr_anim[ "1911" ][ "price_rescue" ]			= %gulag_rescueB_pistol_reshootB;
                                                       
}

#using_animtree( "vehicles" );
endlog_vehicle_animations()
{
	level.scr_animtree[ "pavelow" ] 						= #animtree;
	level.scr_model[ "pavelow" ] 							= "vehicle_pavelow";
	level.scr_anim[ "pavelow" ][ "evac" ] 				= %gulag_end_pavelow;
}
