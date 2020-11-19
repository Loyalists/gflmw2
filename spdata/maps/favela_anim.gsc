#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

#using_animtree( "generic_human" );
main()
{
	precacheModel( "com_cellphone_on" );
	precacheModel( "com_metal_briefcase" );
	
	civilian_walk_loops();
	favela_anims();
	civilian_stand_loops();
	fence_dog_anims();
	vehicle_anims();
	player_anims();
	model_anims();
	dialog();
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
}

favela_anims()
{
	level.scr_anim[ "generic" ][ "bike_rider" ]								= %favela_bicycle_rider;
	
	level.scr_anim[ "makarov" ][ "opening_scene" ]							= %favela_van_shootout_guy1;
	level.scr_anim[ "makarov" ][ "opening_scene_shoot" ][ 0 ]				= %favela_van_shootout_guy1_aimidle;
	level.scr_anim[ "makarov" ][ "opening_scene_flee" ]						= %favela_van_shootout_guy1_runaway;
	level.scr_anim[ "makarov" ][ "stand_fire" ]								= %pistol_stand_fire_A;
	
	level.scr_anim[ "gunner1" ][ "opening_scene" ]							= %favela_van_shootout_guy2;
	level.scr_anim[ "gunner2" ][ "opening_scene" ]							= %favela_van_shootout_guy3;
	level.scr_anim[ "driver" ][ "opening_scene" ]							= %favela_van_shootout_guy4;
	
	level.scr_anim[ "generic" ][ "airport_civ_fear_drop_5" ] 				= %airport_civ_fear_drop_5;
	
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupA_kneel" ] 		= %airport_civ_dying_groupA_kneel;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupA_lean" ] 			= %airport_civ_dying_groupA_lean;
	
	level.scr_anim[ "driver" ][ "idle" ][ 0 ]								= %coup_driver_idle;
	level.scr_anim[ "driver" ][ "center2right" ]							= %coup_driver_center2smallright;
	level.scr_anim[ "driver" ][ "right2center" ]							= %coup_driver_smallright2center;
	level.scr_anim[ "driver" ][ "react" ]									= %favela_opening_driver_death;
	addNotetrack_customFunction( "driver", "bullet hit", maps\favela::driver_shot_in_head );
	addNotetrack_customFunction( "driver", "steering hit", maps\favela::driver_falls_on_horn );
	
	level.scr_anim[ "curtain_pull" ][ "pulldown" ] 							= %favela_curtain_pull;
	level.scr_anim[ "generic" ][ "window_smash" ]							= %window_melee;
	
	level.scr_anim[ "generic" ][ "civilian_window_1" ]						= %unarmed_shout_window_v2;
	level.scr_sound[ "generic" ][ "civilian_window_1" ]						= "civilian_window_shout_1";
	
	level.scr_anim[ "desert_eagle_guy" ][ "run" ]						 	= %unarmed_run_russian;
	
	level.scr_anim[ "generic" ][ "run_death_roll" ]					 		= %run_death_roll;
	
	level.scr_anim[ "generic" ][ "alley_death_fall" ]				 		= %civilian_run_2_crawldeath;
	addNotetrack_animSound( "generic", "alley_death_fall", "bodyfall large", "scn_favela_death_crawl" );
	
	level.scr_anim[ "meat" ][ "favela_warning_jump" ]						= %favela_civ_warning_jump;
	level.scr_anim[ "meat" ][ "favela_warning_landing" ]					= %favela_civ_warning_landing;
	//level.scr_sound[ "meat" ][ "favela_warning_landing" ]					= "favela_met_notsafe";		// It's not safe to be here!! Get as far away as you can!!
	
	level.scr_anim[ "mactavish" ][ "run_and_wave" ]							= %favela_run_and_wave;
	level.scr_sound[ "mactavish" ][ "run_and_wave" ]						= "favela_cmt_gettingaway";	// He's getting away!! Roach let's go let's go!!!
	
	level.scr_anim[ "faust" ][ "ending_takedown" ]							= %favela_ending_runner;
	level.scr_anim[ "mactavish" ][ "ending_takedown" ]						= %favela_ending_soldier;
	addNotetrack_dialogue( "mactavish", "dialog", "ending_takedown", "favela_cmt_gotpackage" );
	addNotetrack_animSound( "mactavish", "ending_takedown", "break_glass", "scn_favela_npc_through_window" );
	addNotetrack_customFunction( "mactavish", "break_glass", maps\favela_code::dive_through_glass );
	
	level.scr_anim[ "torture_enemy" ][ "torture" ]							= %favela_torture_sequence_prisoner;
	level.scr_anim[ "torture_friend1" ][ "torture" ]						= %favela_torture_sequence_soldier1;
	level.scr_anim[ "torture_friend2" ][ "torture" ]						= %favela_torture_sequence_soldier2;
	level.scr_sound[ "torture_friend2" ][ "torture" ]						= "favela_cmt_hidinginfav";	// Roach, this is going to take some time. Go with Meat and Royce and check out the favela for any sign of Faust - that's where this guy was headed.
	addNotetrack_flag( "torture_friend2", "pull_start", "drop_door" );
	
	level.scr_anim[ "trailer" ][ "casual_stand_v2_twitch_talk" ][ 0 ]		= %casual_stand_v2_twitch_talk;
}

#using_animtree( "dog" );
fence_dog_anims()
{
	level.scr_anim[ "dog" ][ "fence_attack" ]								= %sniper_escape_dog_fence;
}

#using_animtree( "vehicles" );
vehicle_anims()
{
	level.scr_animtree[ "van" ] 										 	= #animtree;
	level.scr_anim[ "van" ][ "door_open" ]									= %favela_van_shootout_van;
	
	level.scr_animtree[ "car" ] 										 	= #animtree;
	level.scr_anim[ "car" ][ "driving" ]									= %coup_driver_idle_car;
	level.scr_anim[ "car" ][ "door_open" ]									= %favela_opening_cardoor_open;
	level.scr_anim[ "car" ][ "center2right" ]								= %coup_driver_center2smallright_car;
	level.scr_anim[ "car" ][ "right2center" ]								= %coup_driver_smallright2center_car;
	level.scr_anim[ "car" ][ "run_and_wave" ]								= %favela_run_and_wave_cardoor;
	
	level.scr_anim[ "car" ][ "ending_takedown" ]							= %favela_ending_car;
	addNotetrack_animSound( "car", "ending_takedown", "window_shatter", "scn_favela_npc_car_landing" );
	addNotetrack_customFunction( "car", "window_shatter", maps\favela_code::ending_car_fx );
}

#using_animtree( "player" );
player_anims()
{
	level.scr_anim[ "player_rig" ][ "die" ]									 = %favela_opening_playerview_death;
	level.scr_anim[ "player_rig" ][ "duck_down" ]							 = %favela_opening_playerview_down;
	level.scr_anim[ "player_rig" ][ "duck_down_idle" ][ 0 ]					 = %favela_opening_playerview_downidle;
	level.scr_anim[ "player_rig" ][ "duck_up" ]								 = %favela_opening_playerview_up;
	level.scr_animtree[ "player_rig" ] 										 = #animtree;
	level.scr_model[ "player_rig" ] 										 = "ch_viewhands_player_gk_ar15";
}

#using_animtree( "script_model" );
model_anims()
{
	level.scr_animtree[ "bike" ] 										 	= #animtree;
	level.scr_anim[ "bike" ][ "pedal" ]										= %favela_bicycle;
	
	level.scr_animtree[ "curtain" ] 										 = #animtree;
	level.scr_model[ "curtain" ] 											 = "curtain_torn01_animated";
	level.scr_anim[ "curtain" ][ "pulldown" ]								 = %favela_curtain_model_pull;
	
	level.scr_animtree[ "torture_cables" ] 									 = #animtree;
	level.scr_model[ "torture_cables" ] 									 = "machinery_jumper_cable";
	level.scr_anim[ "torture_cables" ][ "torture" ]							 = %favela_jumper_cables;
	//addNotetrack_animSound( "torture_cables", "torture", "spark", "SOUNDALIAS" );
	addNotetrack_customFunction( "torture_cables", "spark", ::jumper_cable_fx );
	
	level.scr_animtree[ "hula_girl" ] 										 = #animtree;
	level.scr_model[ "hula_girl" ] 											 = "vehicle_hummer_hula_girl";
	level.scr_anim[ "hula_girl" ][ "bobble" ]								 = %hula_girl_bobble;
	level.scr_anim[ "hula_girl" ][ "bobble_stop" ]							 = %hula_girl_bobble_stop;
	
}

dialog()
{
	// Chad - not hooked up yet
	// Roach, that was a civilian! Last I checked you served with the SAS, not the SS. Check your bloody targets!
	//level.scr_sound[ "mactavish" ][ "favela_cmt_notthess" ]				= "favela_cmt_notthess";
	
	//------------
	// DRIVING IN CAR
	//------------
	
	// Ghost, the plates are a match.
	level.scr_radio[ "favela_cmt_ready2move" ] 								= "favela_cmt_ready2move";
	
	// Copy. Any sign of Faust's right hand man?
	level.scr_radio[ "favela_gst_good2go" ] 								= "favela_gst_good2go";
	
	// Negative. They've stopped twice already - no sign of him.
	level.scr_radio[ "favela_cmt_rogerthat" ] 								= "favela_cmt_rogerthat";
	
	// Wait, they've stopped again. Standby.
	level.scr_radio[ "favela_cmt_inposition" ] 								= "favela_cmt_inposition";
	
	// Got a positive ID! Whoever these guys are, they're not happy to see him�
	level.scr_radio[ "favela_cmt_insight" ] 								= "favela_cmt_insight";
	
	// Ghost we have a situation here!
	level.scr_radio[ "favela_cmt_needhimalive" ] 							= "favela_cmt_needhimalive";
	
	// Get down get down!!!
	level.scr_radio[ "favela_cmt_getdown" ]									= "favela_cmt_getdown";
	
	//------------
	// CHASE
	//------------
	
	// Ghost, our driver's dead! We're on foot! Meet us at the Hotel Rio and cut him off if you can!
	level.scr_sound[ "mactavish" ][ "favela_cmt_driversdead" ]				= "favela_cmt_driversdead";
	
	// Roger, I'm on my way!
	level.scr_radio[ "favela_gst_onmyway" ] 								= "favela_gst_onmyway";
	
	// He went into the alley - bloody hell he's fast!
	level.scr_radio[ "favela_gst_hesfast" ] 								= "favela_gst_hesfast";
	
	// Non-lethal takedowns only! We need him alive!
	level.scr_sound[ "mactavish" ][ "favela_cmt_nonlethal" ]				= "favela_cmt_nonlethal";
	
	// Roach - take the shot!! Go for his leg!!
	level.scr_sound[ "mactavish" ][ "favela_cmt_takeshot" ]					= "favela_cmt_takeshot";
	
	// He's down! Good job Roach.
	level.scr_sound[ "mactavish" ][ "favela_cmt_hesdown" ]					= "favela_cmt_hesdown";	
	
	//------------
	// ALLEY
	//------------
	
	// Let's go.
	level.scr_sound[ "royce" ][ "favela_ryc_letsgo" ]						= "favela_ryc_letsgo";
	
	// Remember - there are civilians in the favela. Take clean shots, watch your background.
	level.scr_sound[ "royce" ][ "favela_ryc_watchyourbg" ]					= "favela_ryc_watchyourbg";
	
	// Meat, give the civvies a fair warning.
	level.scr_sound[ "royce" ][ "favela_ryc_warning" ]						= "favela_ryc_warning";
	
	// Roger that.
	level.scr_sound[ "meat" ][ "favela_met_rogerthat" ]						= "favela_met_rogerthat";
	
	//------------
	// FAVELA
	//------------
	
	// Bravo Six, be advised - we've engaged enemy militia at the lower village!
	level.scr_radio[ "favela_cmt_fullbattalion" ]							= "favela_cmt_fullbattalion";	
	
	// Roach! I'm with you! Watch the rooftops! Go!
	level.scr_radio[ "favela_ryc_withyou" ]									= "favela_ryc_withyou";
	
	// Royce, gimme a sitrep, over!
	level.scr_radio[ "favela_cmt_doingok" ]									= "favela_cmt_doingok";
	
	// Lots of militia but no sign of Faust over here, over!
	level.scr_radio[ "favela_ryc_nosign" ]									= "favela_ryc_nosign";
	
	// Copy that! Keep searching! Let me know if you see him! Out!
	level.scr_radio[ "favela_cmt_keepsearching" ]							= "favela_cmt_keepsearching";
	
	// Roach! Move up! Let's go!
	level.scr_radio[ "favela_ryc_moveup" ]									= "favela_ryc_moveup";
	
	// Meat is down! I repeat, Meat is down!
	level.scr_radio[ "favela_ryc_meatisdown" ]								= "favela_ryc_meatisdown";
	
	// Roach! I'm down! Meat's dead! They're all over - (gunfire, angry shouting in Portuguese)
	level.scr_radio[ "favela_ryc_imhit" ]									= "favela_ryc_imdown";
	
	//------------
	// SOCCER
	//------------
	
	// Roach - we've got Faust's location! He's headed west along the upper levels of the favela.
	level.scr_radio[ "favela_cmt_cuthimoff" ]								= "favela_cmt_cuthimoff";
	
	// We'll keep him from doubling back on our side - keep going and cut him off up top!
	level.scr_radio[ "favela_cmt_keepgoing" ]								= "favela_cmt_keepgoing";
	
	// There's no time to wait for backup. You're gonna have to do this on your own. Good luck. Out.
	level.scr_radio[ "favela_cmt_notime" ]									= "favela_cmt_notime";
	
	// Roach, watch the rooftops! We've had a few close calls with RPGs and machine guns positioned up high!
	level.scr_radio[ "favela_cmt_watchrooftops" ]							= "favela_cmt_watchrooftops";
	
	// Roach - this is their territory and they know it well! Keep an eye open for ambush positions and check your corners!
	level.scr_radio[ "favela_cmt_theirterritory" ]							= "favela_cmt_theirterritory";
	
	//------------
	// LOWER HILL
	//------------
	
	// Roach, we're taking heavy fire from militia here but I'm still tracking Faust! He's gone into a building to get something! Ghost, you see him?
	level.scr_radio[ "favela_cmt_stilltracking" ]							= "favela_cmt_stilltracking";
	
	// Roger that, subject is now carrying a black duffel bag full of cash! Greedy bastard!
	level.scr_radio[ "favela_gst_duffelbag" ]								= "favela_gst_duffelbag";
	
	// Well that ought to slow him down! Roach, we're keeping him from doubling back! Keep moving to intercept! Go! Go!
	level.scr_radio[ "favela_cmt_intercept" ]								= "favela_cmt_intercept";
	
	// Keep going! Faust is still headed towards your side of the favela!
	level.scr_radio[ "favela_cmt_yourside" ] 								= "favela_cmt_yourside";
	
	// Roach! Don't let the militia pin you down for too long! Use your flashbangs on them!
	level.scr_radio[ "favela_gst_pinyoudown" ] 								= "favela_gst_pinyoudown";
	
	// I've lost sight of him again! Ghost, talk to me!
	level.scr_radio[ "favela_cmt_lostsightagain" ] 							= "favela_cmt_lostsightagain";
	
	// I'm onto him! He's trying to double back through the alleys below!
	level.scr_radio[ "favela_gst_alleysbelow" ] 							= "favela_gst_alleysbelow";
	
	// Roger that! Stay on him!
	level.scr_radio[ "favela_cmt_stayonhim" ] 								= "favela_cmt_stayonhim";
	
	// I've got a visual on Faust! He's cutting through the market!	
	level.scr_radio[ "favela_gst_cuttingthru" ] 							= "favela_gst_cuttingthru";
	
	// Roger that! I'll head for the rooftops and try to cut him off on the right! He's going to have no choice but to head west!
	level.scr_radio[ "favela_cmt_headforrooftops" ] 						= "favela_cmt_headforrooftops";
	
	// Bloody hell, I'm taking a lot of fire from the militia, I don't think I can track him through the market! I'm going to have to find another way around!
	level.scr_radio[ "favela_gst_wayaround" ] 								= "favela_gst_wayaround";
	
	// Be advised, I'm about half a klick east of the market, I can see Faust running across the rooftops on my right side!
	level.scr_radio[ "favela_gst_halfklick" ] 								= "favela_gst_halfklick";
	
	// Roger that! Roach! We're corraling him closer to your side of the hill! Keep an eye open for Faust! He's still moving across the rooftops!
	level.scr_radio[ "favela_cmt_eyeopen" ] 								= "favela_cmt_eyeopen";
		
	// Sir, I've got Faust in my sights! I can go for a clean leg shot! We can end it here!
	level.scr_radio[ "favela_gst_legshot" ] 								= "favela_gst_legshot";
	
	// Negative! We can't risk it! Do not engage Faust!
	level.scr_radio[ "favela_cmt_donotengage" ] 							= "favela_cmt_donotengage";
	
	// Bollocks! Roger that!
	level.scr_radio[ "favela_gst_rogerthat2" ] 								= "favela_gst_rogerthat2";
	
	// Roach! I've spotted Faust, he's making a run for it! He's headed your way!
	level.scr_radio[ "favela_cmt_spottedfaust" ] 							= "favela_cmt_spottedfaust";
	
	// And don't shoot him! We need him alive and unharmed! 
	level.scr_radio[ "favela_cmt_unharmed" ] 								= "favela_cmt_unharmed";
	
	// Roach, we're going to cut him off at the summit, keep pushing him that way! Go! Go!
	level.scr_radio[ "favela_cmt_cutoff" ] 									= "favela_cmt_cutoff";
	
	// Roach! Keep moving uphill! I've cut him off! He's got nowhere to go but west over the rooftops into your area!
	level.scr_radio[ "favela_cmt_nowheretogo" ] 							= "favela_cmt_nowheretogo";
	
	// Roach! He knows the area well but we can trap him up here! Don't stop! Go! Go!
	level.scr_radio[ "favela_cmt_traphimuphere" ] 							= "favela_cmt_traphimuphere";
	
	// He jumped the fence! I'm after him!!!
	level.scr_radio[ "favela_gst_jumpedfence" ] 							= "favela_gst_jumpedfence";
	
	// Roger that! I'm going around to the left!
	level.scr_radio[ "favela_cmt_goingleft" ] 								= "favela_cmt_goingleft";
	
	// Where is he where is he?
	level.scr_radio[ "favela_gst_whereishe" ] 								= "favela_gst_whereishe";
	
	// Got a visual! He's over there, sliding down the tin rooftops!
	level.scr_radio[ "favela_cmt_slidingrooftops" ] 						= "favela_cmt_slidingrooftops";
	
	// I've got another clear leg shot!
	level.scr_radio[ "favela_gst_anotherlegshot" ] 							= "favela_gst_anotherlegshot";
	
	// Negative! Not unless you want to carry him back out with all this militia breathing down your neck! I need him unharmed!
	level.scr_radio[ "favela_cmt_carryhimback" ] 							= "favela_cmt_carryhimback";
	
	// Roach! He's getting closer to your part of the favela!! Keep moving! Go! Go!
	level.scr_radio[ "favela_cmt_closertoyourpart" ] 						= "favela_cmt_closertoyourpart";
	
	//------------
	// UPPER HILL
	//------------
	
	// Ghost he's going for that motorcycle!
	level.scr_radio[ "favela_cmt_motorcycle" ] 								= "favela_cmt_motorcycle";
	
	// (gunshots, explosion) No he's not.
	level.scr_radio[ "favela_gst_nohesnot" ] 								= "favela_gst_nohesnot";
	
	// Nice! He's breaking to the right again! Roach, if you see him, don't shoot him! I need him unharmed!
	level.scr_radio[ "favela_cmt_dontshoothim" ] 							= "favela_cmt_dontshoothim";
	
	// Roach! He's on the move and headed your way! Go! Go!
	level.scr_radio[ "favela_cmt_onthemove" ] 								= "favela_cmt_onthemove";
	
	// Roach! He's jumped another fence and he's still headed towards your end of the favela! Keep moving up! Go! Go!
	level.scr_radio[ "favela_cmt_anotherfence" ] 							= "favela_cmt_anotherfence";
	
	// Keep corraling him up the hill! We'll cut him off at the top!
	level.scr_radio[ "favela_cmt_corraling" ] 								= "favela_cmt_corraling";
	
	// We've got eyes on Faust - wait! Shite! he's headed back towards you! 
	level.scr_radio[ "favela_cmt_backtowards" ] 							= "favela_cmt_backtowards";

	// Roach, keep pushing him up the hill! Don't let him double back!
	level.scr_radio[ "favela_cmt_doubleback" ] 								= "favela_cmt_doubleback";
	
	// Ghost, I'm going far right!
	level.scr_radio[ "favela_cmt_farright" ] 								= "favela_cmt_farright";
	
	// Roger that.
	level.scr_radio[ "favela_gst_rogerthat" ] 								= "favela_gst_rogerthat";
	
	//------------
	// ENDING
	//------------
	
	// He's gonna get away!!
	level.scr_radio[ "favela_gst_getaway" ] 								= "favela_gst_getaway";
	
	// No he's not.
	level.scr_radio[ "favela_cmt_nohesnot" ] 								= "favela_cmt_nohesnot";
	
	// Frontrunner, this is Bravo Six. We've got the package.
	level.scr_sound[ "mactavish" ][ "favela_cmt_gotpackage" ]				= "favela_cmt_gotpackage";
	
	
	level.scr_sound[ "ghost" ][ "favela_gst_sendchopper" ]					= "favela_gst_sendchopper";
	level.scr_sound[ "ghost" ][ "favela_gst_skiesareclear" ]				= "favela_gst_skiesareclear";
	level.scr_sound[ "ghost" ][ "favela_gst_onourown" ]						= "favela_gst_onourown";
	
	
	
	
	
	
	
	
	
	
	
	//------------
	// CIVILIAN WALLA
	//------------
	
	level.scr_sound[ "generic" ][ "walla1" ]								= "favela_civ1_outofhere";			// Get out of here!! Hurry!!
	level.scr_sound[ "generic" ][ "walla2" ]								= "favela_civ2_run";				// Run! Get to cover!!!
	level.scr_sound[ "generic" ][ "walla3" ]								= "favela_civ3_kidsoutofhere";		// Get the kids out of here!!! Go! Go!!!
	level.scr_sound[ "generic" ][ "walla4" ]								= "favela_civ4_carlarun";			// Carla, run!! Get out here!!!	
	level.scr_sound[ "generic" ][ "walla5" ]								= "favela_civ1_policecoming";		// The police are coming to the favela!!!
	level.scr_sound[ "generic" ][ "walla6" ]								= "favela_civ2_surepolice";			// Cesar, are you sure they're the police??
	level.scr_sound[ "generic" ][ "walla7" ]								= "favela_civ3_notstaying";			// I don't know, they're not from around here and I'm not staying to find out!!
	level.scr_sound[ "generic" ][ "walla8" ]								= "favela_civ4_policeraid";			// It's a police raid!!! Get out of here!!!
	level.scr_sound[ "generic" ][ "walla9" ]								= "favela_civ1_ineshouse";			// Felipe and his men will take care of the police, get to Ines' house, go!!!
	level.scr_sound[ "generic" ][ "walla10" ]								= "favela_civ2_crossfire";			// Stay low!!! Stay out of the crossfire!!!
	level.scr_sound[ "generic" ][ "walla11" ]								= "favela_civ3_shootout";			// There's going to be a shootout!!! Get out of here!!!
	level.scr_sound[ "generic" ][ "walla12" ]								= "favela_civ4_otherside";			// Head for the other side of the favela, hurry!!!
	
	level.fleeing_civilian_wallas[ 0 ] = "walla1";
	level.fleeing_civilian_wallas[ 1 ] = "walla2";
	level.fleeing_civilian_wallas[ 2 ] = "walla3";
	level.fleeing_civilian_wallas[ 3 ] = "walla4";
	level.fleeing_civilian_wallas[ 4 ] = "walla5";
	level.fleeing_civilian_wallas[ 5 ] = "walla6";
	level.fleeing_civilian_wallas[ 6 ] = "walla7";
	level.fleeing_civilian_wallas[ 7 ] = "walla8";
	level.fleeing_civilian_wallas[ 8 ] = "walla9";
	level.fleeing_civilian_wallas[ 9 ] = "walla10";
	level.fleeing_civilian_wallas[ 10 ] = "walla11";
	level.fleeing_civilian_wallas[ 11 ] = "walla12";
}

jumper_cable_fx( cables )
{
	playFXOnTag( getfx( "jumper_cables" ), cables, "j_jcable_clamp02_head_ri" );
}