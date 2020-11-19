#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;

main()
{
	tunnels();
	whitehouse();
	whitehouse_script_model();
	player_animations();
	whitehouse_door();
	tunnels_door();
}

#using_animtree( "generic_human" );

tunnels()
{
	level.scr_anim[ "generic" ][ "combatwalk_F_spin" ] 				= %combatwalk_F_spin;

	level.scr_anim[ "dunn" ][ "hunted_woundedhostage_check" ]				= %hunted_woundedhostage_check_soldier;
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

	// Feet dry.
	level.scr_sound[ "marine1" ][ "dcemp_ar1_feetdry" ]						= "dcemp_ar1_feetdry";

	// Let's go! Let's go! 
	level.scr_sound[ "generic" ][ "dcemp_ar2_letsgo" ]						= "dcemp_ar2_letsgo";

	// Hustle up! Get to the Whiskey Hotel! Move!
	level.scr_sound[ "generic" ][ "dcemp_ar3_hustleup" ]					= "dcemp_ar3_hustleup";
	level.scr_face[ "generic" ][ "dcemp_ar3_hustleup" ]						= %dcemp_ar3_hustleup;
	// Come on, let's go people! This way!
	level.scr_sound[ "generic" ][ "dcemp_ar3_thisway" ]						= "dcemp_ar3_thisway";
	// Move! Move! Get to the Whiskey Hotel!
	level.scr_sound[ "generic" ][ "dcemp_ar3_movemove" ]					= "dcemp_ar3_movemove";

	level.scr_anim[ "dead_guy" ][ "hunted_woundedhostage_check" ]			= %hunted_woundedhostage_check_hostage;
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
	level.scr_anim[ "generic" ][ "wave_on" ][0]								= %dcemp_guard_wave;
	//Go go go!!!			
	level.scr_sound[ "generic" ][ "gogogo" ] 		= "dcemp_fly_gogogo";	
	//Don't stop!! Keep moving!!			
	level.scr_sound[ "generic" ][ "keep_moving" ] 		= "dcemp_fly_dontstop";	
}

whitehouse()
{
	// Keep hitting 'em with the Two-Forty Bravos! Get more men moving on the left flank! 
 	level.scr_sound[ "marshall" ][ "dcemp_cml_moremen" ] 			= "dcemp_cml_moremen";

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

	//Cujo 5-1 to friendly ground units - that was a close one. Stay alive down there. Cujo 5-1 out. 
 	level.scr_radio[ "dcemp_fp1_closeone2" ] 						= "dcemp_fp1_closeone";


	// rappel - TEMP
	level.scr_anim[ "rappel_guy" ][ "rappel_stand_idle_1" ][ 0 ]		= %launchfacility_a_rappel_idle_1;
	level.scr_anim[ "rappel_guy" ][ "rappel_stand_idle_2" ][ 0 ]		= %launchfacility_a_rappel_idle_2;
	level.scr_anim[ "rappel_guy" ][ "rappel_stand_idle_3" ][ 0 ]		= %launchfacility_a_rappel_idle_3;
	level.scr_anim[ "rappel_guy" ][ "rappel_drop" ]						= %launchfacility_a_rappel_1;

	// door kick
	level.scr_anim[ "generic" ][ "doorburst_wave" ]						= %doorburst_wave;

	level.scr_anim[ "flare_guy" ][ "dcemp_flare_reshoot_start_idle" ][0]	= %dcemp_flare_reshoot_start_idle;
	level.scr_anim[ "flare_guy" ][ "dcemp_flare_reshoot_start" ]			= %dcemp_flare_reshoot_start;
	addNotetrack_attach( "flare_guy" , "attach flare" , "mil_emergency_flare", "tag_inhand", "dcemp_flare_reshoot_start" );
	addNotetrack_customFunction( "flare_guy", "start flare", maps\dc_whitehouse_code::flare_fx_start, "dcemp_flare_reshoot_start" );
	addNotetrack_flag( "flare_guy" , "attach flare" , "flareguy_flare_popped", "dcemp_flare_reshoot_start" );

	level.scr_anim[ "flare_guy" ][ "dcemp_flare_reshoot_end" ]				= %dcemp_flare_reshoot_end;
	addNotetrack_flag( "flare_guy" , "detach flare" , "flare_guy_drop_flares", "dcemp_flare_reshoot_end" );

	level.scr_anim[ "flare_guy" ][ "dcemp_flare_reshoot_start_short" ]		= %dcemp_flare_reshoot_start_short;
	addNotetrack_attach( "flare_guy" , "attach flare" , "mil_emergency_flare", "tag_inhand", "dcemp_flare_reshoot_start_short" );
	addNotetrack_customFunction( "flare_guy", "start flare", maps\dc_whitehouse_code::flare_fx_start, "dcemp_flare_reshoot_start_short" );
	addNotetrack_flag( "flare_guy" , "attach flare" , "flareguy_flare_popped", "dcemp_flare_reshoot_start_short" );

	level.scr_anim[ "flare_guy" ][ "dcemp_flare_idle" ][0]					= %casual_stand_idle;
	level.scr_anim[ "flare_guy" ][ "dcemp_flare_idle" ][1]					= %casual_stand_idle_twitch;
	level.scr_anim[ "flare_guy" ][ "dcemp_flare_idle" ][2]					= %casual_stand_idle_twitchB;

	// run
	level.scr_anim[ "flare_guy" ][ "whitehouse_ending_runuphill" ]			= %whitehouse_ending_runuphill; // run cycle

	level.scr_anim[ "marshall" ][ "DCemp_whitehouse_briefing" ]				= %DCemp_whitehouse_briefing_marshall;
	level.scr_anim[ "marshall" ][ "DCemp_whitehouse_briefing_idle" ][0]		= %DCemp_whitehouse_briefing_marshall_idle;
	level.scr_anim[ "foley" ][ "DCemp_whitehouse_briefing" ]				= %DCemp_whitehouse_briefing_foley;

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
	// note track for when to start moving towards the wh entrance.
	addNotetrack_flag( "marshall" , "dcemp_cml_getyoursquad_ps" , "whitehouse_moveout" , "DCemp_whitehouse_briefing" ); 
	addNotetrack_flag( "marshall" , "dcemp_cml_getyoursquad_ps" , "music_cue" , "DCemp_whitehouse_briefing" ); 

	level.scr_anim[ "foley" ][ "dcemp_wh_radio_1" ]					= %dcemp_wh_radio_1;
	level.scr_anim[ "foley" ][ "dcemp_wh_radio_1_exit" ]			= %dcemp_wh_radio_1_exit;
	level.scr_anim[ "foley" ][ "dcemp_wh_radio_1_idle" ][0]			= %dcemp_wh_radio_1_idle;

	level.scr_anim[ "dunn" ][ "dcemp_wh_radio" ]					= %dcemp_wh_radio_2;

	// note track for when to start foleys oval office anim.
	addNotetrack_flag( "dunn" , "folley_dialog" , "oval_office_foley_dialogue" , "dcemp_wh_radio" ); 
	addNotetrack_flag( "dunn" , "start" , "oval_office_foley_react" , "dcemp_wh_radio" ); 
	addNotetrack_flag( "dunn" , "fire" , "oval_office_door_open" , "dcemp_wh_radio" ); 

	// You reading this?
	level.scr_sound[ "dunn" ][ "dcwhite_cpd_readingthis" ]			= "dcwhite_cpd_readingthis";
	// Roger tha.
	level.scr_sound[ "dunn" ][ "dcwhite_cpd_rogerthat" ]			= "dcwhite_cpd_rogerthat";
	// Dunn, get the door!
	level.scr_sound[ "foley" ][ "dcwhite_fly_dunngetdoor" ]			= "dcwhite_fly_dunngetdoor";
	// Dunn!
	level.scr_sound[ "foley" ][ "dcwhite_fly_dunn" ]				= "dcwhite_fly_dunn";
	// Yes, that's why we gota go.
	level.scr_sound[ "foley" ][ "dcwhite_fly_thatswhy" ]			= "dcwhite_fly_thatswhy";

	// drone death anims
	anims = [];
	anims[ "death_explosion_up10" ]			= %death_explosion_up10;
	anims[ "death_explosion_left11" ]		= %death_explosion_left11;
	anims[ "death_explosion_stand_B_v2" ]	= %death_explosion_stand_B_v2;

	level.drone_death_anims = anims;

	//Get to the roof! Move!
	level.scr_sound[ "foley" ][ "dcemp_fly_gettoroof" ]			= "dcemp_fly_gettoroof";
	//Use your flares!!
	level.scr_sound[ "foley" ][ "dcemp_fly_useyourflares" ]		= "dcemp_fly_useyourflares";

	//So when are we goin' to Moscow?
	level.scr_sound[ "flare_guy" ][ "dcemp_ar1_moscow" ]		= "dcemp_ar1_moscow";
	level.scr_face[ "flare_guy" ][ "dcemp_ar1_moscow" ]			= %dcemp_ar1_moscow;

	//Not soon enough, man. But I know we're gonna burn it down when we get there.
	level.scr_sound[ "dunn" ][ "dcwhite_cpd_burnitdown" ]		= "dcwhite_cpd_burnitdown";
	level.scr_face[ "dunn" ][ "dcwhite_cpd_burnitdown" ]		= %dcwhite_cpd_burnitdown;

	//Huah.
	level.scr_sound[ "flare_guy" ][ "dcwhite_ar1_huah" ]		= "dcwhite_ar1_huah";
	level.scr_face[ "flare_guy" ][ "dcwhite_ar1_huah" ]			= %dcwhite_ar1_huah;

	//When the time's right, Corporal. When the time's right.
	level.scr_sound[ "foley" ][ "dcemp_fly_timeisright" ]		= "dcemp_fly_timeisright";
	level.scr_face[ "foley" ][ "dcemp_fly_timeisright" ]		= %dcemp_fly_timeisright;


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

	level.scr_animtree[ "painting" ]							= #animtree;
	level.scr_model[ "painting" ]								= "picture_frame_07_animated";
	level.scr_anim[ "painting" ][ "dcemp_wh_radio" ]			= %dcemp_wh_painting;
}

tunnels_door()
{
	level.scr_animtree[ "tunnel_door" ]								= #animtree;
	level.scr_model[ "tunnel_door" ]								= "tag_origin";
	level.scr_anim[ "tunnel_door" ][ "DCemp_door_sequence" ]		= %DCemp_door_sequence_door;
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
