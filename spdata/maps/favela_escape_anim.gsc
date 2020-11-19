#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

#using_animtree( "generic_human" );

main()
{
	setup_anims();
	setup_dialogue();
}

setup_anims()
{
	// intro rojas strung up
	level.scr_anim[ "generic" ][ "intro_rojas_idle" ][ 0 ]	= %favela_escape_crucified_idle;
	level.scr_anim[ "generic" ][ "intro_rojas_death" ]		= %favela_escape_crucified_death;
	
	// intro casual walking
	level.scr_anim[ "generic" ][ "intro_casual_walk" ] = %patrol_bored_patrolwalk;
	
	// radiotower scout/guy waving his buddies on
	level.scr_anim[ "generic" ][ "favela_run_and_wave" ] = %favela_run_and_wave;
	
	// door kick
	level.scr_anim[ "generic" ][ "door_kick_in" ]		= %door_kick_in;
	level.scr_anim[ "generic" ][ "doorburst_wave" ]		= %doorburst_wave;
	level.scr_anim[ "generic" ][ "doorburst_search" ]	= %doorburst_search;
	level.scr_anim[ "generic" ][ "doorburst_fall" ]		= %doorburst_fall;
	
	// window smashing
	level.scr_anim[ "generic" ][ "window_smash_stop_inside" ]	= %window_smash_stop_inside;
	level.scr_anim[ "generic" ][ "window_smash_stop_outside" ]	= %window_smash_stop_outside;
	level.scr_anim[ "generic" ][ "window_smash_run" ]			= %window_smash_run;
	
	// guys running & shooting above player
	level.scr_anim[ "generic" ][ "favela_chaotic_above_through" ]		= %favela_chaotic_above_through;
	level.scr_anim[ "generic" ][ "favela_chaotic_above_through_uzi" ]	= %favela_chaotic_above_through_uzi;
	level.scr_anim[ "generic" ][ "favela_chaotic_above_back" ]	= %favela_chaotic_above_back;
	
	// curtain pulldown
	level.scr_anim[ "curtain_pull" ][ "pulldown" ] = %favela_curtain_pull;
	
	// enemy diving through a window
	level.scr_anim[ "generic" ][ "traverse_window_M_2_dive" ] = %traverse_window_M_2_dive;

	// friends climbing up to rooftops anims
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_traverse_L" ] = %favela_escape_rooftop_traverse_L;
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_traverse_R" ] = %favela_escape_rooftop_traverse_R;
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_traverse_M" ] = %favela_escape_rooftop_traverse_M;
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_traverse_M_idle" ][ 0 ] = %favela_escape_rooftop_traverse_M_idle;
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_traverse_M_idle_2_run" ] = %favela_escape_rooftop_traverse_M_idle_2_run;
	
	// roofrun anims
	level.scr_anim[ "generic" ][ "freerunnerA_run" ]			= %freerunnerA_loop;
	level.scr_anim[ "generic" ][ "freerunnerB_run" ]			= %freerunnerB_loop;
	level.scr_anim[ "freerunner" ][ "freerunnerA_left" ]		= %freerunnerA_left;
	level.scr_anim[ "freerunner" ][ "freerunnerB_mid" ]			= %freerunnerB_mid;
	level.scr_anim[ "freerunner" ][ "freerunnerA_right" ]		= %freerunnerA_right;
	level.scr_anim[ "freerunner" ][ "freerunnerA_sideslope" ]	= %freerunnerA_sideslope;
	level.scr_anim[ "freerunner" ][ "freerunnerA_laundry" ]		= %freerunnerA_laundry;
	level.scr_anim[ "freerunner" ][ "freerunnerB_laundry" ]		= %freerunnerB_laundry;
	level.scr_anim[ "freerunner" ][ "jump_across_100_lunge"]	= %jump_across_100_lunge;
	level.scr_anim[ "freerunner" ][ "favela_escape_bigjump_faust_loop" ][ 0 ] = %favela_escape_bigjump_faust_loop;
	level.scr_anim[ "freerunner" ][ "favela_escape_bigjump_ghost_loop" ][ 0 ] = %favela_escape_bigjump_ghost_loop;
	level.scr_anim[ "freerunner" ][ "favela_escape_bigjump_soap_loop" ][ 0 ] = %favela_escape_bigjump_soap_loop;
	level.scr_anim[ "freerunner" ][ "favela_escape_bigjump_soap_reach" ] = %favela_escape_bigjump_soap_reach;
	level.scr_anim[ "freerunner" ][ "favela_escape_bigjump_soap" ] = %favela_escape_bigjump_soap;
	level.scr_anim[ "freerunner" ][ "favela_escape_bigjump_ghost" ] = %favela_escape_bigjump_ghost;
	level.scr_anim[ "freerunner" ][ "favela_escape_bigjump_faust" ] = %favela_escape_bigjump_faust;
	// (added in script later, so that they don't stomp on scripted dialogue if the timing works out that way)
	// "Uraaa!"
	//level.scr_sound[ "freerunner" ][ "favela_escape_bigjump_soap" ] = "favesc_cmt_jumpsfx";
	// "Unghh!"
	//level.scr_sound[ "freerunner" ][ "favela_escape_bigjump_ghost" ] = "favesc_gst_jumpsfx";
	// "Gahh!"
	level.scr_sound[ "freerunner" ][ "favela_escape_bigjump_faust" ] = "favesc_tf1_jumpsfx";
	
	// angry mob anims
	level.scr_anim[ "generic" ][ "mobwalk_A" ] = %mob_arc_A;
	level.scr_anim[ "generic" ][ "mobwalk_B" ] = %mob_arc_B;
	level.scr_anim[ "generic" ][ "mobwalk_C" ] = %mob_arc_C;
	level.scr_anim[ "generic" ][ "mobwalk_D" ] = %mob_arc_D;
	
	level.scr_anim[ "generic" ][ "mob2_arc_A" ] = %mob2_arc_A;
	level.scr_anim[ "generic" ][ "mob2_arc_B" ] = %mob2_arc_B;
	level.scr_anim[ "generic" ][ "mob3_arc_C" ] = %mob3_arc_C;
	level.scr_anim[ "generic" ][ "mob2_arc_D" ] = %mob2_arc_D;
	level.scr_anim[ "generic" ][ "mob2_arc_E" ] = %mob2_arc_E;
	level.scr_anim[ "generic" ][ "mob2_arc_F" ] = %mob2_arc_F;
	level.scr_anim[ "generic" ][ "mob2_arc_G" ] = %mob2_arc_G;
	level.scr_anim[ "generic" ][ "mob2_arc_H" ] = %mob2_arc_H;
	
	level.scr_anim[ "generic" ][ "mob_left_A" ] = %mob_left_A;
	level.scr_anim[ "generic" ][ "mob_left_B" ] = %mob_left_B;
	level.scr_anim[ "generic" ][ "mob_left_C" ] = %mob_left_C;
	level.scr_anim[ "generic" ][ "mob_left_D" ] = %mob_left_D;
	
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_mob1" ] = %favela_escape_rooftop_mob1;
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_mob2" ] = %favela_escape_rooftop_mob2;
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_mob3" ] = %favela_escape_rooftop_mob3;
	level.scr_anim[ "generic" ][ "favela_escape_rooftop_mob4" ] = %favela_escape_rooftop_mob4;
	
	// player solo run civilian door slammer
	level.scr_anim[ "default_civilian" ][ "run_and_slam_idle" ][ 0 ] = %flee_alley_civilain_idle;
	level.scr_anim[ "default_civilian" ][ "run_and_slam" ] = %flee_alley_civilain;
	level.scr_anim[ "default_civilian" ][ "run_and_slam_endidle" ][ 0 ] = %civilain_crouch_hide_idle;
	
	// player solo run roof civilians
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_react_A" ]		= %unarmed_cowercrouch_react_A;
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_react_B" ]		= %unarmed_cowercrouch_react_B;
	level.scr_anim[ "generic" ][ "unarmed_cowercrouch_idle" ][ 0 ]		= %unarmed_cowercrouch_idle;
	level.scr_anim[ "generic" ][ "cargoship_stunned_react_v2" ]			= %cargoship_stunned_react_v2;
	level.scr_anim[ "generic" ][ "unarmed_cowerstand_react_2_crouch" ]	= %unarmed_cowerstand_react_2_crouch;
	level.scr_anim[ "generic" ][ "unarmed_cowerstand_idle" ][ 0 ]		= %unarmed_cowerstand_idle;
	
	// sarge chopper door anims
	level.scr_anim[ "chopper_door_guy" ][ "chopperjump_in" ]		= %favela_escape_ending_mctavish_in;
	level.scr_anim[ "chopper_door_guy" ][ "chopperjump_loop" ][ 0 ]	= %favela_escape_ending_mctavish_flying_loop;
	level.scr_anim[ "chopper_door_guy" ][ "chopperjump_flyaway" ]	= %favela_escape_ending_mctavish_flying_away;
	
	// vehicle anims
	setup_vehicle_anims();
	
	// model anims
	setup_model_anims();
	
	// player anims
	favela_escape_player();
}

setup_dialogue()
{
	// -- INTRO PATH --
	// "Sir, the militia's closin' in! Almost two hundred of 'em, front and back!"
	level.scr_sound[ "hero1" ][ "favesc_gst_closingin" ] = "favesc_gst_closingin";
	
	// "We're gonna have to fight our way to the LZ! Let's go!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_fightourway" ] = "favesc_cmt_fightourway";
	
	// "What about Rojas?"
	level.scr_sound[ "hero1" ][ "favesc_gst_whataboutrojas" ] = "favesc_gst_whataboutrojas";
	
	// "Victim of a hostile takeover?"
	level.scr_sound[ "sarge" ][ "favesc_cmt_takeover" ] = "favesc_cmt_takeover";
	
	// "Works for me."
	level.scr_sound[ "hero1" ][ "favesc_gst_worksforme" ] = "favesc_gst_worksforme";
	
	// "Nikolai! We're at the top of the favela surrounded by militia! Bring the chopper to the market, do you copy, over!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_surrounded" ] = "favesc_cmt_surrounded";
	
	// "Ok my friend, I am on the way!"
	level.scr_radio[ "favesc_nkl_ontheway" ] = "favesc_nkl_ontheway";
	
	// "Everyone get ready! Lock and load! "
	level.scr_sound[ "sarge" ][ "favesc_cmt_lockandload" ] = "favesc_cmt_lockandload";
	
	// "Let's do this!!"
	level.scr_sound[ "hero1" ][ "favesc_gst_letsdothis" ] = "favesc_gst_letsdothis";

	
	// -- ENEMY SPAWN CALLOUTS --
	// "Contaaact!!! Foot-mobiles on the rooftops, closing in fast from the south!!!"
	level.scr_sound[ "hero1" ][ "favesc_gst_onrooftops" ] = "favesc_gst_onrooftops";
	
	// "Tangos at ground level dead ahead!!"
	level.scr_sound[ "hero1" ][ "favesc_gst_deadahead" ] = "favesc_gst_deadahead";
	
	// "Militia comin' out of the shack on the left!"
	level.scr_sound[ "hero1" ][ "favesc_gst_shackonleft" ] = "favesc_gst_shackonleft";
	
	// "More skinnies on the rooftops at 12 o'clock!!"
	level.scr_sound[ "hero1" ][ "favesc_gst_skinnies" ] = "favesc_gst_skinnies";
	
	// "They're moving on our left flaank!!"
	level.scr_sound[ "hero1" ][ "favesc_gst_leftflank" ] = "favesc_gst_leftflank";
	
	// "Rooftops on our left! Shift fire!!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_shiftfire" ] = "favesc_cmt_shiftfire";
	
	// "LEFT LEFT LEFT! In those wooden shacks!"
	level.scr_sound[ "hero1" ][ "favesc_gst_leftleftleft" ] = "favesc_gst_leftleftleft";
	
	// "RPGs to the east!!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_rpgseast" ] = "favesc_cmt_rpgseast";
	
	// "RPGs on the rooftops to the south!"
	level.scr_sound[ "hero1" ][ "favesc_gst_tothesouth" ] = "favesc_gst_tothesouth";
	
	// "Tangos moving in low from the southeast!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_lowfromse" ] = "favesc_cmt_lowfromse";
	
	// "Bloody hell there's a lot of 'em!"
	level.scr_sound[ "hero1" ][ "favesc_gst_alotofem" ] = "favesc_gst_alotofem";
	
	// "We gotta move...!!!"
	level.scr_sound[ "hero1" ][ "favesc_gst_gottamove" ] = "favesc_gst_gottamove";
	
	
	// -- RADIOTOWER SCOUT YELLING --
	// "Kill them!!! Kill them all!!! They deserve nothing less!!!"
	level.scr_sound[ "generic" ][ "favesc_pe4_killthemall" ] = "favesc_pe4_killthemall";
	
	// "Here they come!"
	level.scr_sound[ "generic" ][ "favesc_pe1_heretheycome" ] = "favesc_pe1_heretheycome";
	
	// "Attaaaack!"
	level.scr_sound[ "generic" ][ "favesc_pe1_attack" ] = "favesc_pe1_attack";
	
	
	// -- RADIOTOWER SPECIFIC --
	// "Technical comin' in from the south!!"
	level.scr_sound[ "hero1" ][ "favesc_gst_technical" ] = "favesc_gst_technical";
	
	// "We got another technical! Take it out!!!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_technical" ] = "favesc_cmt_technical";
	
	// "Head through that gate!!! Keep pushing to the evac point!!!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_thruthatgate" ] = "favesc_cmt_thruthatgate";
	
	// "We've gotta get to the helicopter - head through the gate to the market! Move!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_thrugate" ] = "favesc_cmt_thrugate";
	
	// "Go! Go! Go!"
	level.scr_sound[ "hero1" ][ "favesc_gst_gogogo" ] = "favesc_gst_gogogo";
	
	
	// -- CHOPPER REVEAL --
	// "Chopper inbound!"
	level.scr_sound[ "hero1" ][ "favesc_gst_chopperinbound" ] = "favesc_gst_chopperinbound";
	
	// "Nikolai, get out of here! You're gonna get hit by an RPG! We rendezvous at the market as planned!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_hitbyrpg" ] = "favesc_cmt_hitbyrpg";
	
	// "Ok, ok, we do it your way. My gunner and I will give you covering fire from above, from a safer distance."
	level.scr_radio[ "favesc_nkl_doityourway" ] = "favesc_nkl_doityourway";
	
	// "The market is not far from where you are, but I see many milita moving towards you."
	level.scr_radio[ "favesc_nkl_manymilitia" ] = "favesc_nkl_manymilitia";
	
	// "Roger that Nikolai! And thanks! Out!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_rogerandthanks" ] = "favesc_cmt_rogerandthanks";
	
	
	// -- STREET COMBAT --
	// "Let's go, let's go!  We've gotta push through these streets to the market!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_pushthrustreets" ] = "favesc_cmt_pushthrustreets";
	
	// "Watch for flanking routes!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_flankingroutes" ] = "favesc_cmt_flankingroutes";
	
	// "Roach! Lay down some fire on the intersection!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_laydownfire" ] = "favesc_cmt_laydownfire";
	
	// "Heads up! Alley on the left!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_alleyonleft" ] = "favesc_cmt_alleyonleft";
	
	// "Keep moving!! We're almost at the market!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_almostatmarket" ] = "favesc_cmt_almostatmarket";
	
	
	// -- MARKET COMBAT --
	// "Not exactly the High Street shops, eh?"
	level.scr_sound[ "hero1" ][ "favesc_gst_highstreet" ] = "favesc_gst_highstreet";
	
	// "Squad! Split up and clear the market! Watch your sectors - these guys are everywhere!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_splitup" ] = "favesc_cmt_splitup";
	
	// "Contacts above us at 11 o'clock, firing blind!"
	level.scr_sound[ "hero1" ][ "favesc_gst_firingblind" ] = "favesc_gst_firingblind";
	
	// "Tango coming out of the shack on the right!!!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_shackonright" ] = "favesc_cmt_shackonright";
	
	
	// -- MARKET EVAC --
	// "There's Nikolai's Pave Low! Let's go!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_therespavelow" ] = "favesc_cmt_therespavelow";
	
	// "Nikolai! ETA 20 seconds! Be ready for immediate dustoff!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_immediatedustoff" ] = "favesc_cmt_immediatedustoff";
	
	// "That may not be fast enough! I see more militia closing in on the market!"
	level.scr_radio[ "favesc_nkl_notfastenough" ] = "favesc_nkl_notfastenough";
	
	// "Pick up the pace! Let's go!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_pickuppace" ] = "favesc_cmt_pickuppace";
	
	// "It's too hot! We will not survive this landing!"
	level.scr_radio[ "favesc_nkl_toohot" ] = "favesc_nkl_toohot";
	
	// "Nikolai, wave off, wave off! We'll meet you at the secondary LZ instead! Go!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_waveoff" ] = "favesc_cmt_waveoff";
	
	// "Very well, I will meet you there! Good luck!"
	level.scr_radio[ "favesc_nkl_meetyouthere" ] = "favesc_nkl_meetyouthere";
	
	// "Come on! We've got to get to the rooftops, this way!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_gettorooftops" ] = "favesc_cmt_gettorooftops";
	
	// "Roach! Get up here on the rooftops, let's go!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_getuphere" ] = "favesc_cmt_getuphere";
	
	// "Roach! Get over here and climb up to the rooftops!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_climbup" ] = "favesc_cmt_climbup";
	
	// "Roach! You can climb up over here!"
	level.scr_sound[ "sarge" ][ "favesc_cmt_climbuphere" ] = "favesc_cmt_climbuphere";
	
	
	// -- ROOF RUN --
	// "Let's go, let's go!!"
	level.scr_sound[ "freerunner" ][ "favesc_cmt_letsgoletsgo" ] = "favesc_cmt_letsgoletsgo";
	
	// "My friend, from up here, it looks like the whole village is trying to kill you!"
	level.scr_radio[ "favesc_nkl_wholevillage" ] = "favesc_nkl_wholevillage";
	
	// "Tell me something I don't know! Just get ready to pick us up at the secondary RV!"
	level.scr_sound[ "freerunner" ][ "favesc_cmt_pickusup" ] = "favesc_cmt_pickusup";
	level.scr_face[ "freerunner" ][ "favesc_cmt_pickusup" ] = %favela_escape_Soap_pickusup;
	
	// "Ok, I will pick you up soon, keep going!"
	level.scr_radio[ "favesc_nkl_keepgoing" ] = "favesc_nkl_keepgoing";
	
	// "We're running out of rooftop!!!"
	level.scr_sound[ "freerunner" ][ "favesc_gst_runoutofroof" ] = "favesc_gst_runoutofroof";
	
	// "We can make it! Go go go!"
	level.scr_sound[ "freerunner" ][ "favesc_cmt_makeitgogo" ] = "favesc_cmt_makeitgogo";
	level.scr_face[ "freerunner" ][ "favesc_cmt_makeitgogo" ] = %favela_escape_Soap_makeitgogo;
	
	// "We've got to get out of here, Roach, come on!"
	level.scr_sound[ "freerunner" ][ "favesc_cmt_getoutta" ] = "favesc_cmt_getoutta";
	
	// "C'mon Roach, we're almost at the chopper!"
	level.scr_sound[ "freerunner" ][ "favesc_cmt_gettochopper" ] = "favesc_cmt_gettochopper";
	
	// "Roach, what's the holdup, let's go!"
	level.scr_sound[ "freerunner" ][ "favesc_cmt_whatsholdup" ] = "favesc_cmt_whatsholdup";
	
	
	// -- PLAYER RECOVERY --
	// "Roach!!! Roach!!! Wake up!!!"
	level.scr_radio[ "favesc_cmt_wakeup" ] = "favesc_cmt_wakeup";
	
	// "Roach! We can see them from the chopper! They're coming for you, dozens of 'em!!!"
	level.scr_radio[ "favesc_gst_comingforyou" ] = "favesc_gst_comingforyou";
	
	// "Roach! There's too many of them! Get the hell out of there and find a way to the rooftops! Move!"
	level.scr_radio[ "favesc_cmt_toomany" ] = "favesc_cmt_toomany";
	
	// "Run for it!!! Get to the rooftops!!"
	level.scr_radio[ "favesc_cmt_runforit" ] = "favesc_cmt_runforit";
	
	
	// -- PLAYER SOLO RUN --
	// "Roach, we're circling the area but I can't see you! You've got to get to the rooftops!"
	level.scr_radio[ "favesc_cmt_circlingarea" ] = "favesc_cmt_circlingarea";
	
	// "Roach, we're running low on fuel! Where the hell are you?!"
	level.scr_radio[ "favesc_cmt_lowonfuel" ] = "favesc_cmt_lowonfuel";
	
	// "Roach! I see you! Jump down to the rooftops and meet us south of your position! Go!"
	level.scr_radio[ "favesc_cmt_meetussouth" ] = "favesc_cmt_meetussouth";
	
	// "Left!!! Turn left and jump down!"
	level.scr_radio[ "favesc_cmt_leftturnleft" ] = "favesc_cmt_leftturnleft";
	
	// "Head to the right!"
	level.scr_radio[ "favesc_cmt_headtoright" ] = "favesc_cmt_headtoright";
	
	// "Come on!!!!"
	level.scr_radio[ "favesc_cmt_comeon" ] = "favesc_cmt_comeon";
	
	// "Gas is very low! I must leave in thirty seconds, ok?"
	level.scr_radio[ "favesc_nkl_verylow" ] = "favesc_nkl_verylow";
	
	// "Roach! We're running on fumes here! You got thirty seconds! Run!"
	level.scr_radio[ "favesc_cmt_onfumes" ] = "favesc_cmt_onfumes";
	
	// "Jump for it!!!"
	level.scr_sound[ "chopper_door_guy" ][ "favesc_cmt_jump" ] = "favesc_cmt_jump";
	level.scr_face[ "chopper_door_guy" ][ "favesc_cmt_jump" ] = %favela_escape_soap_cmt_jump;
	
	// "Nikolai! We got him! Get us outta here!"
	level.scr_radio[ "favesc_cmt_gothim" ] = "favesc_cmt_gothim";
	
	// "Where to, Captain?"
	level.scr_radio[ "favesc_nkl_whereto" ] = "favesc_nkl_whereto";
	
	// "Just get us to the sub..."
	level.scr_radio[ "favesc_cmt_tothesub" ] = "favesc_cmt_tothesub";
}


#using_animtree( "player" );
favela_escape_player()
{
	level.scr_anim[ "player_bigjump" ][ "jump" ]	= %player_favela_escape_bigjump;
	level.scr_anim[ "player_bigjump" ][ "recover" ]	= %player_favela_escape_bigjump_getup;
	level.scr_model[ "player_bigjump" ] 			= "ch_viewhands_player_gk_ar15";
	level.scr_animtree[ "player_bigjump" ] = #animtree;
	
	level.scr_anim[ "player" ][ "chopperjump_jump" ]	= %favela_escape_ending_player_catch_rope;
	level.scr_model[ "player" ] 						= "ch_viewhands_player_gk_ar15";
	level.scr_animtree[ "player" ] = #animtree;
}


#using_animtree( "script_model" );
setup_model_anims()
{
	level.scr_model[ "rojas_restraints" ]				= "unconscious_rojas_rope";
	level.scr_animtree[ "rojas_restraints" ]			= #animtree;
	level.scr_anim[ "rojas_restraints" ][ "idle" ][ 0 ]	= %favela_escape_crucified_ropes;
	
	level.scr_model[ "curtain" ]				= "curtain_torn01_animated";
	level.scr_animtree[ "curtain" ]				= #animtree;
	level.scr_anim[ "curtain" ][ "pulldown" ]	= %favela_curtain_model_pull;
	
	level.scr_model[ "civ_door" ] = "com_door_01_handleleft";
	level.scr_animtree[ "civ_door" ] = #animtree;
	level.scr_anim[ "civ_door" ][ "run_and_slam_idle" ][ 0 ] = %flee_alley_door_idle;
	level.scr_anim[ "civ_door" ][ "run_and_slam" ] = %flee_alley_door;
	
	level.scr_model[ "roof_rig" ]				= "favela_escape_roof_piece";
	level.scr_animtree[ "roof_rig" ]			= #animtree;
	level.scr_anim[ "roof_rig" ][ "breakaway" ]	= %favela_escape_roof_piece_collapse;
	
	level.scr_model[ "laundry" ]						= "hanging_sheet";
	level.scr_animtree[ "laundry" ]						= #animtree;
	level.scr_anim[ "laundry" ][ "roofrun_laundry_1" ]	= %favela_escape_sheet01_run_through;
	level.scr_anim[ "laundry" ][ "roofrun_laundry_2" ]	= %favela_escape_sheet02_run_through;
	
	level.scr_model[ "ladder" ]									= "favela_escape_ropeladder";
	level.scr_anim[ "ladder" ][ "chopperjump_in" ]				= %favela_escape_ending_rope_in;
	level.scr_anim[ "ladder" ][ "chopperjump_loop" ][ 0 ]		= %favela_escape_ending_rope_loop;
	level.scr_anim[ "ladder" ][ "chopperjump_jump" ]			= %favela_escape_ending_rope_interaction;
	level.scr_animtree[ "ladder" ] = #animtree;
}


#using_animtree( "vehicles" );
setup_vehicle_anims()
{
	level.scr_anim[ "chopper" ][ "cargodoor_open" ]			= %favela_escape_ending_chopper_open_back_door;
	level.scr_anim[ "chopper" ][ "chopperjump_in" ]			= %favela_escape_ending_chopper_in;
	level.scr_anim[ "chopper" ][ "chopperjump_loop" ][ 0 ]	= %favela_escape_ending_chopper_loop;
	level.scr_anim[ "chopper" ][ "chopperjump_flyaway" ]	= %favela_escape_ending_chopper_flying_away;
	level.scr_anim[ "chopper" ][ "rotors" ]					= %bh_rotors;
	level.scr_model[ "chopper" ]							= "vehicle_pavelow";
	level.scr_animtree[ "chopper" ] = #animtree;
}
