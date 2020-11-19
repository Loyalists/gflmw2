#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;

#using_animtree( "generic_human" );
gulag_anim()
{
	gulag_anims();
	gulag_vo();
	gulag_script_models();
	gulag_vehicles();
	gulag_player();
}

gulag_anims()
{
	level.scr_anim[ "operator" ][ "pulldown" ] = %gulag_slamraam_tarp_pull_guy2_v1;
	level.scr_anim[ "operator" ][ "idle" ][ 0 ] = %gulag_slamraam_tarp_idle_guy2_v1;

	level.scr_anim[ "puller" ][ "pulldown" ] = %gulag_slamraam_tarp_pull_guy1_v1;

	level.scr_anim[ "generic" ][ "rappel_start" ] = %gulag_rappel_soldier;

	level.scr_anim[ "pilot" ][ "idle" ][ 0 ] = %F15_pilot_idle;
	level.scr_animtree[ "pilot" ]				= #animtree;
	level.scr_anim[ "generic" ][ "sewer_slide" ] = %gulag_sewer_slide;

	// Slow mo breach anims	
	level.scr_anim[ "generic" ][ "breach_stackL_approach" ] = %breach_stackL_approach;
	level.scr_anim[ "generic" ][ "death_explosion_stand_B_v3" ] = %death_explosion_stand_B_v3;
	level.scr_anim[ "generic" ][ "react_stand_2_run_R45" ] = %react_stand_2_run_R45;
	level.scr_anim[ "generic" ][ "execution_fightback_guy1_03" ] = %execution_fightback_guy1_03;
	level.scr_anim[ "generic" ][ "execution_fightback_guy2_03" ] = %execution_fightback_guy2_03;
	level.scr_anim[ "generic" ][ "execution_fightback_guy2_03_survives" ] = %execution_fightback_guy2_03_survives;
	level.scr_anim[ "generic" ][ "execution_fightback_guy2_03_death" ] = %execution_fightback_guy2_03_death;
	
	
	addNotetrack_customFunction( "generic", "slide_start", ::slide_start, "sewer_slide" );
	addNotetrack_customFunction( "generic", "slide_end", ::slide_stop, "sewer_slide" );
	addNotetrack_customFunction( "generic", "slide_land", ::slide_land, "sewer_slide" );
	addNotetrack_customFunction( "generic", "slide_land_deep", ::slide_land_deep, "sewer_slide" );

	level.scr_anim[ "ghost" ][ "laptop_approach" ] = %laptop_sit_runin;
	level.scr_anim[ "ghost" ][ "laptop_idle" ][0] = %laptop_sit_idle_active;
	level.scr_anim[ "ghost" ][ "laptop_idle" ][1] = %laptop_sit_idle_calm;
	level.scr_anim[ "ghost" ][ "laptop_idle" ][2] = %laptop_sit_idle_flinch;
	
	// flash
	level.scr_anim[ "generic" ][ "grenade_throw" ] = %corner_standr_grenade_b;
	addNotetrack_customFunction( "generic", "grenade_throw", ::throw_flash, "grenade_throw" );
	
} 

throw_flash( guy )
{
	//oldweapon = guy.grenadeWeapon;
	//guy.grenadeWeapon = "flash_grenade";
	//guy.grenadeAmmo++;
	

	flash_start = getstruct( "flash_org", "targetname" );
	flash_end = getstruct( flash_start.target, "targetname" );
	start = flash_start.origin;
	end = flash_end.origin;
	
	MagicGrenade( "flash_grenade", start, end, 0.9 );
	wait( 1.0 );
	level notify( "flashed_room" );
}

slide_start( guy )
{
	slide_fx = getFX ( "water_slide" );
	
	guy endon( "stop_slide_fx" );
	guy endon( "death" );
	while ( true )
	{
		PlayFXOnTag( slide_fx , guy, "tag_origin" );	
		wait( .1 );
	}
}

slide_stop( guy )
{
	guy notify( "stop_slide_fx" );		
}

slide_land( guy )
{
	if ( !isdefined( guy.slide_landed ) )
	{
		// only play it on first notetrack hit
		index = guy get_my_index();
		
		guy.slide_landed = true;
		// scn_gulag_sewer_slide_friend1, scn_gulag_sewer_slide_friend2, scn_gulag_sewer_slide_friend3
		guy playsound( "scn_gulag_sewer_slide_friend" + index );
	}

	slide_start_fx = getFX ( "water_slide_start" );
	PlayFXOnTag( slide_start_fx , guy, "tag_origin" );
}

slide_land_deep( guy )
{
	if ( !isdefined( guy.slide_landed_deep ) )
	{
		// only play it on first notetrack hit
		index = guy get_my_index();
		
		guy.slide_landed_deep = true;
		// scn_gulag_sewer_splash_friend1, scn_gulag_sewer_splash_friend2, scn_gulag_sewer_splash_friend3
		guy playsound( "scn_gulag_sewer_splash_friend" + index );
	}
	
	slide_splash_fx = getFX ( "water_slide_splash" );
	PlayFXOnTag( slide_splash_fx , guy, "tag_origin" );
}

get_my_index()
{
	allies = getaiarray( "allies" );
	foreach ( index, ai in allies )
	{
		if ( ai == self )
			break;
	}
	
	index %= 3;
	index++;
	assert( index > 0 && index < 4 );
	return index;
}

#using_animtree( "script_model" );
gulag_script_models()
{
	level.scr_animtree[ "tarp" ]										= #animtree;
	level.scr_anim[ "tarp" ][ "pulldown" ]								= %gulag_slamraam_tarp_simulation;
	level.scr_model[ "tarp" ]											= "slamraam_tarp";
	
	level.scr_animtree[ "ai_rope" ] 									= #animtree;
	level.scr_model[ "ai_rope" ] 										= "gulag_rappel_rope_soldier_60ft";
	level.scr_anim[ "ai_rope" ][ "rappel_start" ]						= %gulag_rappel_soldier_rope_60ft;
	                                                                	
                                                                    	
	level.scr_animtree[ "player_rope" ] 								= #animtree;
	level.scr_model[ "player_rope" ] 									= "gulag_rappel_rope_player_60ft";
	level.scr_anim[ "player_rope" ][ "rappel_start" ]					= %gulag_rappel_player_rope_60ft;
                                                                    	
	level.scr_animtree[ "player_rope_obj" ] 							= #animtree;
	level.scr_model[ "player_rope_obj" ] 								= "gulag_rappel_rope_player_60ft_obj";
	level.scr_anim[ "player_rope_obj" ][ "rappel_start" ]				= %gulag_rappel_player_rope_60ft;

	level.scr_animtree[ "folding_chair" ] 						 		= #animtree;
	level.scr_model[ "folding_chair" ] 							 		= "com_folding_chair";
	level.scr_anim[ "folding_chair" ][ "laptop_approach" ]		 		= %laptop_chair_runin;

	level.scr_animtree[ "strangle_chain" ] 						 				= #animtree;
	level.scr_model[ "strangle_chain" ] 									 		= "strangle_chain";
	level.scr_anim[ "strangle_chain" ][ "price_breach" ]			= %gulag_strangle_chain;

}	

#using_animtree( "player" );
gulag_player()
{
	level.scr_anim[ "player_rappel" ][ "rappel_start" ]					 = %gulag_rappel_player;
	level.scr_animtree[ "player_rappel" ] 								 = #animtree;
	level.scr_model[ "player_rappel" ] 									 = "ch_viewhands_player_gk_ar15";
}

#using_animtree( "vehicles" );
gulag_vehicles()
{
	level.rotate_anims_vehicle = [];
	level.rotate_anims_vehicle[ "x_right" ] = %rotate_body_X_R;
	
	level.scr_animtree[ "f15" ]				= #animtree;
	level.scr_model[ "f15" ]				= "vehicle_f15"; // "vehicle_av8b_harrier_jet_anim";  // vehicle_f15
	
	level.scr_animtree[ "f15" ]				= #animtree;
	level.scr_model[ "f15" ]				= "vehicle_f15"; // "vehicle_av8b_harrier_jet_anim"; // vehicle_f15
	level.scr_anim[ "f15" ][ "intro_1" ]	= %gulag_F15_intro_1;
	level.scr_sound[ "f15" ][ "intro_1" ]	= "scn_gulag_f15_jet1";
	
	level.scr_anim[ "f15" ][ "landing_gear" ]	= %mig_landing_gear_up;
	
	level.scr_anim[ "f15" ][ "intro_2" ]	= %gulag_F15_intro_2;
	level.scr_sound[ "f15" ][ "intro_2" ]	= "scn_gulag_f15_jet2";
	addNotetrack_customFunction( "f15", "explode", ::f15_explode );

	level.scr_animtree[ "intro_1_missile" ]			= #animtree;
	level.scr_model[ "intro_1_missile" ]				= "vehicle_f15_missile"; // "vehicle_av8b_harrier_jet_anim"; // vehicle_f15
	level.scr_anim[ "intro_1_missile" ][ "missile_fire_a" ]	= %gulag_missile_F15_1_A;
	

	level.scr_animtree[ "intro_1_missile" ]			= #animtree;
	level.scr_model[ "intro_1_missile" ]				= "vehicle_f15_missile"; // "vehicle_av8b_harrier_jet_anim"; // vehicle_f15
	level.scr_anim[ "intro_1_missile" ][ "missile_fire_b" ]	= %gulag_missile_F15_1_B;
	
	level.scr_animtree[ "intro_2_missile" ]			= #animtree;
	level.scr_model[ "intro_2_missile" ]				= "vehicle_f15_missile"; // "vehicle_av8b_harrier_jet_anim"; // vehicle_f15
	level.scr_anim[ "intro_2_missile" ][ "missile_fire_a" ]	= %gulag_missile_F15_2_A;

	level.scr_animtree[ "intro_2_missile" ]			= #animtree;
	level.scr_model[ "intro_2_missile" ]				= "vehicle_f15_missile"; // "vehicle_av8b_harrier_jet_anim"; // vehicle_f15
	level.scr_anim[ "intro_2_missile" ][ "missile_fire_b" ]	= %gulag_missile_F15_2_B;
	
	
	addNotetrack_customFunction( "f15", "missile", ::f15_fire_missile );
	addNotetrack_customFunction( "f15", "missile_fx", ::f15_missile_fx);
	addNotetrack_customFunction( "f15", "afterburner", ::f15_afterburner );


	//addNotetrack_customFunction( "missile_1", "launch", ::missile_launch_fx );
	//addNotetrack_customFunction( "missile_2", "launch", ::missile_launch_fx );
}

f15_fire_missile( f15 )
{
	if ( f15.scene == "intro_1" )
	{
		f15.missiles[ 0 ] playsound( "scn_gulag_f15_missile_fire1" );
	}
	else
	{
		f15.missiles[ 0 ] playsound( "scn_gulag_f15_missile_fire2" );
	}
	
	brackets = getfx( "missile_brackets" );
	
	foreach ( model in f15.missiles )
	{
		model show();
		PlayFXOnTag( brackets, model, "TAG_FX" );
	}	
}

f15_missile_fx( f15 )
{
	wait( 0.3 );
	trail = getfx( "javelin_trail" );
	ignition = getfx( "javelin_ignition" );
	
	if ( level.looker_f15 == f15 )
	{
		level.looker_f15 = f15.missiles[ 0 ];
		level notify( "switch_look" );
	}
	
	foreach ( model in f15.missiles )
	{
		model show();
		PlayFXOnTag( trail, model, "TAG_FX" );
		PlayFXOnTag( ignition, model, "TAG_FX" );
	}
}

f15_afterburner( f15 )
{
	jet_afterburn_ignites = getfx( "jet_afterburner_ignite" );
	playfxontag( jet_afterburn_ignites, f15, "tag_engine_left" );	
	playfxontag( jet_afterburn_ignites, f15, "tag_engine_right" );	
	
	f15 ent_flag_set( "contrails" );	
}

missile_launch_fx( missile )
{
	missile endon( "death" );
	smoke = getfx( "missile_trail" );

	for ( ;; )
	{
		playFxOnTag( smoke, missile, "tag_weapon" );
		wait( 0.05 );
	}
}

f15_explode( f15 )
{
	fx = getfx( "missile_explosion" );
	PlayFXOnTag( fx, f15, "le_side_wing_jnt" );
	f15 thread maps\gulag_fx::f15_smoke();
	
}

#using_animtree( "generic_human" );
gulag_vo()
{
	// Thirty seconds.	
	level.scr_sound[ "soap" ][ "gulag_rpt_30sec" ] = "gulag_rpt_30sec";
	level.scr_face[ "soap" ][ "gulag_rpt_30sec" ] = %gulag_rpt_30sec;
	
	
	// Hornet Two-One, this is Jester One-One, flight of two F-15s, four HARMs for the section, standby for SEAD (pr. see-add) over.	
	level.scr_radio[ "gulag_hrp1_angelsone" ] = "gulag_hrp1_angelsone";
	
	// Solid copy Jester. Go get 'em.	
	level.scr_radio[ "gulag_lbp1_gogetem" ] = "gulag_lbp1_gogetem";
	
	// Good tone good tone - Fox three fox three.	
	level.scr_radio[ "gulag_fp1_goodtone" ] = "gulag_fp1_goodtone";
	
	// Good kill good kill!	
	level.scr_radio[ "gulag_fp2_goodkill" ] = "gulag_fp2_goodkill";
	
	// Hornet Two-One you're cleared all the way in. Have a nice day.	
	level.scr_radio[ "gulag_fp1_niceday" ] = "gulag_fp1_niceday";
	
	// Hornet Two-One copies.	
	level.scr_radio[ "gulag_lbp1_copies" ] = "gulag_lbp1_copies";
	
	// Two-two copies all.	
	level.scr_radio[ "gulag_lbp2_copiesall" ] = "gulag_lbp2_copiesall";
	
	// Two-Three solid copy.	
	level.scr_radio[ "gulag_lbp3_solidcopy" ] = "gulag_lbp3_solidcopy";
	
	
	//=============================================
	
	// Two going in hot.	
	level.scr_radio[ "gulag_lbp2_goinghot" ] = "gulag_lbp2_goinghot";
	
	// Roger.	
	level.scr_radio[ "gulag_lbp1_roger" ] = "gulag_lbp1_roger";
	
	// Gunsgunsguns.	
	level.scr_radio[ "gulag_lbp2_guns" ] = "gulag_lbp2_guns";
	
	// Gunsgunsguns.	
	level.scr_radio[ "gulag_lbp2_guns2" ] = "gulag_lbp2_guns2";
	
	// Two-two, two-one - good effect on target.	
	level.scr_radio[ "gulag_lbp1_goodeffect" ] = "gulag_lbp1_goodeffect";
	
	// Peeling.	
	level.scr_radio[ "gulag_lbp2_peeling" ] = "gulag_lbp2_peeling";
	
	// Hornet Five-Three, go ahead and start your attack run.	
	level.scr_radio[ "gulag_lbp1_startattack" ] = "gulag_lbp1_startattack";
	
	// Roger that. Rolling in.	
	level.scr_radio[ "gulag_lbp3_rollingin" ] = "gulag_lbp3_rollingin";
	
	// All snipers this is Raptor, standby to engage.	
	level.scr_sound[ "soap" ][ "gulag_rpt_stbyengage" ] = "gulag_rpt_stbyengage";
	
	//===================================================
	
	// Stabilize.	
	level.scr_sound[ "soap" ][ "gulag_rpt_stabilize" ] = "gulag_rpt_stabilize";
	
	// Roger.	
	level.scr_radio[ "gulag_lbp1_roger2" ] = "gulag_lbp1_roger2";
	
	// On target.	
	level.scr_radio[ "gulag_tco_ontarget" ] = "gulag_tco_ontarget";
	
	// All snipers - cleared to engage.	
	level.scr_sound[ "soap" ][ "gulag_rpt_clearedengage" ] = "gulag_rpt_clearedengage";
	
	// Shift right.	
	level.scr_sound[ "soap" ][ "gulag_rpt_shiftright" ] = "gulag_rpt_shiftright";
	
	// Shifting.	
	level.scr_radio[ "gulag_lbp1_shifting" ] = "gulag_lbp1_shifting";
	
	// Stabilize.	
	level.scr_radio[ "gulag_rpt_stabilize2" ] = "gulag_rpt_stabilize2";
	
	// Ready.	
	level.scr_radio[ "gulag_lbp1_ready" ] = "gulag_lbp1_ready";
	
	// On target.	
	level.scr_radio[ "gulag_wrm_ontarget" ] = "gulag_wrm_ontarget";
	
	// Shift right.	
	level.scr_sound[ "soap" ][ "gulag_rpt_shiftright2" ] = "gulag_rpt_shiftright2";
	
	// Shifting.	
	level.scr_radio[ "gulag_lbp1_shifting2" ] = "gulag_lbp1_shifting2";
	
	// Stabilize.	
	level.scr_radio[ "gulag_rpt_stabilize3" ] = "gulag_rpt_stabilize3";
	
	// Ready.	
	level.scr_radio[ "gulag_lbp1_ready2" ] = "gulag_lbp1_ready2";
	
	// On target.	
	level.scr_radio[ "gulag_wrm_ontarget2" ] = "gulag_wrm_ontarget2";
	
	// On target.	
	level.scr_radio[ "gulag_tco_ontarget2" ] = "gulag_tco_ontarget2";
	
	// Take 'em out.	
	level.scr_radio[ "gulag_rpt_takeemout" ] = "gulag_rpt_takeemout";
	
	//============================================================
	
	// Hang on!	
	level.scr_radio[ "gulag_lbp1_hangon" ] = "gulag_lbp1_hangon";
	
	// Command, we need those Russian naval vessels to cease fire immediately! That was too close!	
	level.scr_radio[ "gulag_rpt_tooclose" ] = "gulag_rpt_tooclose";
	
	// Roger, we are currently negotiating with the commander of Russian naval forces for more time. Out.	
	level.scr_radio[ "gulag_hqr_moretime" ] = "gulag_hqr_moretime";
	

	// Crazy motherfu**ers. Are these the good Russians or the bad Russians!	
	level.scr_radio[ "gulag_tco_goodorbad" ] = "gulag_tco_goodorbad";
	// Bloody Yanks�whose side are they on anyway?!		
	level.scr_radio[ "gulag_tco_goodorbad" ] = "gulag_gst_yanks2";

	// lets use this one
	// Bloody Yanks...I thought they were the good guys!		
	level.scr_radio[ "gulag_tco_goodorbad" ] = "gulag_gst_yanks1";
	
	
	
	// Taco cut the chatter. Stay frosty.	
	level.scr_radio[ "gulag_rpt_cutchatter" ] = "gulag_rpt_cutchatter";
	level.scr_anim[ "gulag_rpt_cutchatter" ] = %gulag_rpt_cutchatter;
	
	
	// First wave going in.	
	level.scr_radio[ "gulag_lbp2_firstwave" ] = "gulag_lbp2_firstwave";
	
	// Three-One, troops are on the deck.	
	level.scr_radio[ "gulag_lbp2_ondeck" ] = "gulag_lbp2_ondeck";
	
	// This is Three-One, troops are on the deck, going into holding pattern.	
	level.scr_radio[ "gulag_lbp2_holdingpatt" ] = "gulag_lbp2_holdingpatt";
	
	// Second wave going in. Standby.	
	level.scr_radio[ "gulag_lbp1_2ndwave" ] = "gulag_lbp1_2ndwave";
	
	// Fifty feet.	
	level.scr_radio[ "gulag_lbp1_50ft" ] = "gulag_lbp1_50ft";
	
	// Ten feet.	
	level.scr_radio[ "gulag_lbp1_10ft" ] = "gulag_lbp1_10ft";
	
	// Two-One touching down at target.	
	level.scr_radio[ "gulag_lbp1_touchdown" ] = "gulag_lbp1_touchdown";
	
	// Team One is deployed. Going into holding pattern.	
	level.scr_radio[ "gulag_lbp1_deployed" ] = "gulag_lbp1_deployed";
	
	// Five-Three going into overhead pattern to provide sniper cover, over.	
	level.scr_radio[ "gulag_lbp3_snipercover" ] = "gulag_lbp3_snipercover";
	
	// Five-Three, this is Two-One, solid copy on all.	
	level.scr_radio[ "gulag_lbp1_solidcopy" ] = "gulag_lbp1_solidcopy";
	
	// Go! Go! Go!	
	level.scr_sound[ "generic" ][ "gulag_rpt_gogogo" ] = "gulag_rpt_gogogo";
	

	// Ghost, tap into their control hub! Track our movement and find the P.O.W. Rocket, watch his back. Roach and Sandman, we're on cell duty, let's go!	
	level.scr_sound[ "soap" ][ "gulag_cmt_tapinto" ] = "gulag_cmt_tapinto";
	
	// Ghost, we've hit a security door, get it open!	
	level.scr_sound[ "soap" ][ "gulag_cmt_secdoor" ] = "gulag_cmt_secdoor";
	
	// Workin' on it...this hardware is ancient!	
	level.scr_radio[ "gulag_cmt_ancient" ] = "gulag_cmt_ancient";
	
	// Wrong door!! 	
	level.scr_sound[ "soap" ][ "gulag_cmt_wrongdoor" ] = "gulag_cmt_wrongdoor";
	
	// Roger, standby
	level.scr_radio[ "gulag_gst_standby" ] = "gulag_gst_standby";
	
	// got it.	
	level.scr_radio[ "gulag_gst_gotit2" ] = "gulag_gst_gotit2";
	
	
	// That's better, let's go!	
	level.scr_sound[ "soap" ][ "gulag_cmt_thatsbetter" ] = "gulag_cmt_thatsbetter";
	
	// Ok - next door in three, two -	
	level.scr_radio[ "gulag_gst_threetwo" ] = "gulag_gst_threetwo";
	
	// See anything you like?	
	level.scr_sound[ "soap" ][ "gulag_cmt_seeanything" ] = "gulag_cmt_seeanything";
	
	// We've got company!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_gotcompany" ] = "gulag_cmt_gotcompany";
	
	// Grab a riot shield!	
	level.scr_sound[ "soap" ][ "gulag_cmt_riotshield" ] = "gulag_cmt_riotshield";
	level.scr_face[ "soap" ][ "gulag_cmt_riotshield" ] = %gulag_cmt_riotshield;
	
	// Ghost! We're getting pinned down here! Open the armory gate! Hurry!	
	level.scr_sound[ "soap" ][ "gulag_cmt_openarmory" ] = "gulag_cmt_openarmory";
	
	// Almost there. Standby.	
	level.scr_radio[ "gulag_gst_almostthere" ] = "gulag_gst_almostthere";
	
	// Open the door!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_openthedoor" ] = "gulag_cmt_openthedoor";
	
	// Got it.	
	level.scr_radio[ "gulag_gst_gotit" ] = "gulag_gst_gotit";
	
	// Switch to night vision.	
	level.scr_sound[ "soap" ][ "gulag_cmt_switchnv" ] = "gulag_cmt_switchnv";
	
	
	
	// See anything you like?		
	// Bad news mate. I'm tracking three, no, four hostile squads converging on your position!		
	level.scr_radio[ "gulag_gst_badnews" ] = "gulag_gst_badnews";
	// I can hear them coming...let's go! We're too exposed!		
	level.scr_sound[ "soap" ][ "gulag_cmt_hearcoming" ] = "gulag_cmt_hearcoming";
	// Ghost! Open the door!		
	level.scr_sound[ "soap" ][ "gulag_cmt_opendoor" ] = "gulag_cmt_opendoor";
	// Bloody hell, they've locked it from the hard line. I'll have to run a bypass.		
	level.scr_radio[ "gulag_gst_runabypass" ] = "gulag_gst_runabypass";
	// Too late! They're already here!		
	level.scr_sound[ "soap" ][ "gulag_cmt_toolate" ] = "gulag_cmt_toolate";
	// Be advised - you've got more tangos headed your way.		
	level.scr_radio[ "gulag_gst_gotmoretangos" ] = "gulag_gst_gotmoretangos";
	// We're going to need more cover - grab a riot shield!		
	level.scr_sound[ "soap" ][ "gulag_cmt_morecover" ] = "gulag_cmt_morecover";
	// Roach, pick up one of those riot shields!		
	level.scr_sound[ "soap" ][ "gulag_cmt_pickupone" ] = "gulag_cmt_pickupone";
	// Open the door!!		
	level.scr_sound[ "soap" ][ "gulag_cmt_openthedoor" ] = "gulag_cmt_openthedoor";
	// Almost there! Routing through the auxiliary circuit...got it!		
	level.scr_radio[ "gulag_gst_gotit" ] = "gulag_gst_gotit";
	// We've got company!!		
	level.scr_sound[ "soap" ][ "gulag_cmt_gotcompany" ] = "gulag_cmt_gotcompany";
	// Grab a riot shield!		
	level.scr_sound[ "soap" ][ "gulag_cmt_riotshield" ] = "gulag_cmt_riotshield";

	// Ghost! We're getting pinned down here! Open the armory gate! Hurry!		
//	level.scr_sound[ "generic" ][ "gulag_cmt_openarmory" ] = "gulag_cmt_openarmory";
	

	// roach is down!
	level.scr_sound[ "soap" ][ "gulag_cmt_roachisdown" ] = "gulag_cmt_roachisdown";
	// roach!!
	level.scr_sound[ "soap" ][ "gulag_cmt_roach" ] = "gulag_cmt_roach";


	// Cell clear.	
	level.scr_radio[ "gulag_tf1_cellclear" ] = "gulag_tf1_cellclear";
	// Cell 4d is clear.		
	level.scr_radio[ "gulag_tf1_cell4dclear" ] = "gulag_tf1_cell4dclear";
	// This cell's clear. Move.		
	level.scr_radio[ "gulag_tf1_cellsclear" ] = "gulag_tf1_cellsclear";
	// Last floor clear. We�ll link up with you at the bottom.		
	level.scr_radio[ "gulag_tf1_lastfloor" ] = "gulag_tf1_lastfloor";
	
	
	// Captain MacTavish, last floor clear. We'll link up with you at the bottom.		
	level.scr_radio[ "gulag_tf1_captainlastfloor" ] = "gulag_tf1_captainlastfloor";
	
	
	// Clear.		
	level.scr_radio[ "gulag_tf2_clear" ] = "gulag_tf2_clear";
	// This one's empty.		
	level.scr_radio[ "gulag_tf2_onesempty" ] = "gulag_tf2_onesempty";
	// This one's empty too.		
	level.scr_radio[ "gulag_tf3_emptytoo" ] = "gulag_tf3_emptytoo";
	// Clear.		
	level.scr_radio[ "gulag_tf3_clear" ] = "gulag_tf3_clear";
	







	// Quarterback, what the hell was that? Call off the barrage!	
	level.scr_sound[ "soap" ][ "gulag_cmt_calloff" ] = "gulag_cmt_calloff";
	
	// We�re working on it. The Russian Navy isn't exactly cooperating right now.  Keep moving. Out.	
	level.scr_radio[ "gulag_hqr_working" ] = "gulag_hqr_working";
	
	// Quarterback to Task Force - Admiral Tarkovsky's a real loose cannon, but he�s agreed to stop firing for now. Keep going, we�ll keep you posted. Out.	
	level.scr_radio[ "gulag_hqr_loosecannon" ] = "gulag_hqr_loosecannon";
	
	// Go go go! 	
	level.scr_sound[ "soap" ][ "gulag_cmt_gogogo1" ] = "gulag_cmt_gogogo1";
	
	// Ok, I see you on the cameras.	
	level.scr_radio[ "gulag_gst_oncameras" ] = "gulag_gst_oncameras";
	
	// The old shower room's about thirty feet ahead on your left. You'll have to breach the wall to get in.	
	level.scr_radio[ "gulag_gst_30ftonleft" ] = "gulag_gst_30ftonleft";
	
	// Roach - plant the breaching charge!	
	level.scr_sound[ "soap" ][ "gulag_cmt_plantbreach" ] = "gulag_cmt_plantbreach";
	
	// Hurry up Roach, let�s go!	
	level.scr_sound[ "soap" ][ "gulag_cmt_hurryup" ] = "gulag_cmt_hurryup";

	// We got companyyy!	
	level.scr_sound[ "soap" ][ "gulag_cmt_wegotcompany" ] = "gulag_cmt_wegotcompany";
	
	// Ghost, we�re in the old tunnel system � which way?	
	level.scr_sound[ "soap" ][ "gulag_cmt_whichway" ] = "gulag_cmt_whichway";
	
	// I'm checking the blueprints, standby. Ok. Head fifty meters along that tunnel to the west.	
	level.scr_radio[ "gulag_gst_50meters" ] = "gulag_gst_50meters";
	
	// Talk to me Ghost...I don�t want to be down here when those ships start firing again.	
	level.scr_sound[ "soap" ][ "gulag_cmt_startfiring" ] = "gulag_cmt_startfiring";
	
	// Keep going - you should see an old cistern in thirty meters.	
	level.scr_radio[ "gulag_gst_cistern" ] = "gulag_gst_cistern";
	
	// Ok, I count eight tangos. Plant your breaching charge as far to the northwest as you can � otherwise you risk killing our man inside.	
	level.scr_radio[ "gulag_gst_8tangos" ] = "gulag_gst_8tangos";
	
	// Quarterback, we need more time � get the Russians to hold off on their attack!	
	level.scr_sound[ "soap" ][ "gulag_cmt_needmoretime" ] = "gulag_cmt_needmoretime";
	
	// No can do � they're ignoring us. Admiral Tarkovsky has jurisdiction here and he's going to level the place in three minutes. Move!	
	level.scr_radio[ "gulag_hqr_nocando" ] = "gulag_hqr_nocando";
	
	// Task Force be advised, they've started the bombardment early � get the hell out of there now!	
	level.scr_radio[ "gulag_hqr_getout" ] = "gulag_hqr_getout";
	
	// Viper Six-Four, we�re in the northwest cellblock, do you have a SPIE (pr. 'spee') rig onboard over???	
	level.scr_sound[ "soap" ][ "gulag_cmt_spierig" ] = "gulag_cmt_spierig";
	
	// Roger on the SPIE rig, over.	
	level.scr_radio[ "gulag_plp_rogeronspie" ] = "gulag_plp_rogeronspie";
	
	// Send it down now!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_sendit" ] = "gulag_cmt_sendit";
	
	// Roger, on the way.	
	level.scr_radio[ "gulag_plp_ontheway" ] = "gulag_plp_ontheway";
	
	// Hook up!! Moove!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_hookup" ] = "gulag_cmt_hookup";
	
	// Go!! Go!! Go!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_gogogo2" ] = "gulag_cmt_gogogo2";
	
	// Quarterback, this is Viper Six-Four, task force and precious cargo are secure. We�re on our way home, out.	
	level.scr_sound[ "soap" ][ "gulag_plp_onwayhome" ] = "gulag_plp_onwayhome";
	

	// There�s the chopper!!! Get ready to jump!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_ready2jump" ] = "gulag_cmt_ready2jump";
	
	// Ahh, bollocks!!! Go back go back!!! We'll find another way out!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_anotherway" ] = "gulag_cmt_anotherway";
	


	// Viper Six-Four, this is Hunter Two-One! We're trapped in the mess hall at the northeast corner of the gulag, depth 100 meters!!! I need a four-point SPIE rig for emergency extraction over!	
	level.scr_sound[ "soap" ][ "gulag_cmt_depth100" ] = "gulag_cmt_depth100";
	
	// Roger on the SPIE rig - we're on the way, give us fifteen seconds.	
	level.scr_radio[ "gulag_plp_15secs" ] = "gulag_plp_15secs";
	
	// We'll be dead in five!!! Move your arse man!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_deadinfive" ] = "gulag_cmt_deadinfive";
	
	// Six-Four, where the hell are you, over?!!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_whereareyou" ] = "gulag_cmt_whereareyou";
	
	// Two-One, there's too much smoke, I can't see you I can't see you -	
	level.scr_radio[ "gulag_plp_cantsee" ] = "gulag_plp_cantsee";
	
	// Whatever you're gonna do Soap, do it fast!!!	
	level.scr_sound[ "price" ][ "gulag_pri_doitfast" ] = "gulag_pri_doitfast";
	
	// Two-One, I see your flare. SPIE rig coming down.	
	level.scr_radio[ "gulag_plp_seeflare" ] = "gulag_plp_seeflare";
	
	// Let's go!! Let's go!!!	
	level.scr_sound[ "price" ][ "gulag_pri_letsgo" ] = "gulag_pri_letsgo";
	
	// Hook uuuup!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_hookup2" ] = "gulag_cmt_hookup2";
	
	// Go go!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_gogo" ] = "gulag_cmt_gogo";
	
	// Hang on!!!	
	level.scr_sound[ "price" ][ "gulag_pri_hangon" ] = "gulag_pri_hangon";
	








	// *****************************
	//  new dialogue for exterior to cellblocks
	// *****************************
		
	// Two-One is in position for gun run.	
	level.scr_radio[ "gulag_lbp1_gunrun" ] = "gulag_lbp1_gunrun";
	
	// Copy Two-One, lasing target on the second floor!	
	level.scr_sound[ "soap" ][ "gulag_cmt_lasingtarget" ] = "gulag_cmt_lasingtarget";
	
	// Two-One copies, got a tally on 6 tangos, inbound hot.	
	level.scr_radio[ "gulag_lbp1_gotatally" ] = "gulag_lbp1_gotatally";
	
	// Roach! Hostiles on the third floor, use your M203!	
	level.scr_sound[ "soap" ][ "gulag_cmt_usem203" ] = "gulag_cmt_usem203";
	
	// The entrance is up ahead, keep moving!	
	level.scr_sound[ "soap" ][ "gulag_cmt_upahead" ] = "gulag_cmt_upahead";
	
	// This is it! We go in, grab Prisoner 627, and get out! Ready?	
	level.scr_sound[ "soap" ][ "gulag_cmt_getout" ] = "gulag_cmt_getout";
	
	// Check your corners! Let's go!	
	level.scr_sound[ "soap" ][ "gulag_cmt_checkcorners" ] = "gulag_cmt_checkcorners";
	
	// That's the control room up ahead! I can use it to find our prisoner!	
	level.scr_radio[ "gulag_gst_controlroom" ] = "gulag_gst_controlroom";
	
	// That's the control room up ahead! I can use it to find our prisoner!	
	level.scr_sound[ "ghost" ][ "gulag_gst_controlroom_ghost" ] = "gulag_gst_controlroom";
	
	// I'll tap into their system and look for the prisoner! It's gonna take some time!	
	level.scr_radio[ "gulag_cmt_tapinto" ] = "gulag_cmt_tapinto";
	
	// I'll tap into their system and look for the prisoner! It's gonna take some time!	
	level.scr_sound[ "ghost" ][ "gulag_cmt_tapinto_ghost" ] = "gulag_cmt_tapinto";
	
	// Copy that! Roach, we're on cell duty! Follow me!	
	level.scr_sound[ "soap" ][ "gulag_cmt_cellduty" ] = "gulag_cmt_cellduty";
	
	// All right, I'm patched in. I'm tracking your progress on the security cameras.	
	level.scr_radio[ "gulag_gst_patchedin" ] = "gulag_gst_patchedin";
	
	// Copy that! Do you have the location of Prisoner 627?	
	level.scr_sound[ "soap" ][ "gulag_cmt_location" ] = "gulag_cmt_location";
	
	// Negative, but I've got a searchlight tracking hostiles on your floor. That should make your job easier.	
	level.scr_radio[ "gulag_gst_jobeasier" ] = "gulag_gst_jobeasier";
	
	// Roger that! Roach! Stay sharp! The prisoner may be in one of these cells!	
	level.scr_sound[ "soap" ][ "gulag_cmt_staysharp" ] = "gulag_cmt_staysharp";
	
	// Ghost, you opened the wrong door!	
	level.scr_sound[ "soap" ][ "gulag_cmt_wrongdoor" ] = "gulag_cmt_wrongdoor";
	
	// Talk to me Ghost...these cells are deserted! 	
	level.scr_sound[ "soap" ][ "gulag_cmt_talktome" ] = "gulag_cmt_talktome";
	
	// Got it! Prisoner 627's been transferred to the east wing! Head through the armory in the center - that's the fastest way there.	
	level.scr_radio[ "gulag_gst_eastwing" ] = "gulag_gst_eastwing";
	
	// Roger that! Roach, head for that armory down there! Move!	
	level.scr_sound[ "soap" ][ "gulag_cmt_armorydownthere" ] = "gulag_cmt_armorydownthere";
	
	// I'm working on it... The main circuit's dead! Standby!	
	level.scr_radio[ "gulag_gst_almostthere" ] = "gulag_gst_almostthere";
	
	// Almost there! Routing through the auxiliary circuit...got it!	
	level.scr_radio[ "gulag_gst_gotit" ] = "gulag_gst_gotit";
	






	
	// Let's go!! Let's go!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_letsgo" ] = "gulag_cmt_letsgo";
	
	// There�s the chopper!!! Get ready to jump!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_ready2jump" ] = "gulag_cmt_ready2jump";
	
	// Ahh, bollocks!!! Go back go back!!! We'll find another way out!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_anotherway" ] = "gulag_cmt_anotherway";
	level.scr_face[ "soap" ][ "gulag_cmt_anotherway" ] = %gulag_cmt_anotherway;

	// This way this way!!!	
	level.scr_sound[ "redshirt" ][ "gulag_wrm_thisway" ] = "gulag_wrm_thisway";
	level.scr_face[ "redshirt" ][ "gulag_wrm_thisway" ] = %gulag_wrm_thisway;
	
	// It's a dead end!!!	
	level.scr_sound[ "redshirt" ][ "gulag_wrm_deadend" ] = "gulag_wrm_deadend";
	
	// We can't go back that way!!! Let's try to get these doors open!!!	
	level.scr_sound[ "price" ][ "gulag_pri_doorsopen" ] = "gulag_pri_doorsopen";

	
	// Viper Six-Four, this is Bravo Six Actual! We're trapped in the mess hall at the northeast corner of the gulag, depth 100 meters!!! I need a four-point SPIE rig for emergency extraction over!	
	level.scr_sound[ "soap" ][ "gulag_cmt_depth100" ] = "gulag_cmt_depth100";

	// Roger on the SPIE rig - we're on the way, give us fifteen seconds.	
	level.scr_radio[ "gulag_plp_15secs" ] = "gulag_plp_15secs";
	
	// We'll be dead in five!!! Move your arse man!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_deadinfive" ] = "gulag_cmt_deadinfive";
	
	// Six-Four, where the hell are you, over?!!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_whereareyou" ] = "gulag_cmt_whereareyou";

	// Bravo Six, there's too much smoke, I can't see you I can't see you -	
	level.scr_radio[ "gulag_plp_cantsee" ] = "gulag_plp_cantsee";
	
	// Whatever you're gonna do Soap, do it fast!!!	
	level.scr_sound[ "price" ][ "gulag_pri_doitfast" ] = "gulag_pri_doitfast";

	// Bravo Six, I see your flare. SPIE rig coming down.	
	level.scr_radio[ "gulag_plp_seeflare" ] = "gulag_plp_seeflare";
		
	// Hook uuuup!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_hookup2" ] = "gulag_cmt_hookup2";
	
	// Go go!!!	
	level.scr_sound[ "soap" ][ "gulag_cmt_gogo" ] = "gulag_cmt_gogo";
	
	// Hang on!!!	
	level.scr_sound[ "price" ][ "gulag_pri_hangon" ] = "gulag_pri_hangon";






	// I see 4 hostiles on the next tower!	
	level.scr_sound[ "soap" ][ "gulag_cmt_seehostiles" ] = "gulag_cmt_seehostiles";
	level.scr_face[ "soap" ][ "gulag_cmt_seehostiles" ] = %gulag_cmt_seehostiles;
	
	
	// Sheppard! Get those fighters to cease fire immediately! That was too close!	
	level.scr_radio[ "gulag_rpt_tooclose" ] = "gulag_rpt_tooclose";
	
	// Use your riot shield to draw their fire!	
	level.scr_sound[ "soap" ][ "gulag_cmt_usesheild" ] = "gulag_cmt_usesheild";
	
	// I'll draw their fire with the riot shield, you take 'em out!	
	level.scr_sound[ "soap" ][ "gulag_cmt_illdrawfire" ] = "gulag_cmt_illdrawfire";
	
	// Ghost here. Recommend you bypass the lower floors by rappelling out that window.	
	level.scr_radio[ "gulag_gst_bypassfloors" ] = "gulag_gst_bypassfloors";
	
	// Copy that! Roach, follow me!	
	level.scr_sound[ "soap" ][ "gulag_cmt_roachfollow" ] = "gulag_cmt_roachfollow";
	level.scr_face[ "soap" ][ "gulag_cmt_roachfollow" ] = %gulag_cmt_roachfollow;
	
	// The camera feed in solitary confinement is dead. The power must be down in that section.	
	level.scr_radio[ "gulag_gst_feedisdead" ] = "gulag_gst_feedisdead";
	
	// Roger that. Roach, switch to night vision.	
	level.scr_sound[ "soap" ][ "gulag_cmt_switchnv" ] = "gulag_cmt_switchnv";
	
	// Roach, check the cells for stragglers.	
	level.scr_sound[ "soap" ][ "gulag_cmt_stragglers" ] = "gulag_cmt_stragglers";
	
	// Sheppard, what the hell was that? Get those ships to cease fire!	
	level.scr_sound[ "soap" ][ "gulag_cmt_calloff" ] = "gulag_cmt_calloff";
	
	// I'm working on it buddy. The Navy isn't in a talking mood right now. Standby.	
	level.scr_radio[ "gulag_hqr_working" ] = "gulag_hqr_working";
	
	// Bravo Six - they've agreed to stop firing for now. Keep going, I�ll keep you posted. Out.	
	level.scr_radio[ "gulag_hqr_loosecannon" ] = "gulag_hqr_loosecannon";
	
	// Its too narrow! Roach, sweep the corridor and we'll follow once its clear! Go!	
	level.scr_sound[ "soap" ][ "gulag_cmt_toonarrow" ] = "gulag_cmt_toonarrow";
	
	// Roach - plant the breaching charge on the wall!	
	level.scr_sound[ "soap" ][ "gulag_cmt_plantbreach" ] = "gulag_cmt_plantbreach";
	
	// Roach - not the door! Plant the breaching charge on the wall over here!	
	level.scr_sound[ "soap" ][ "gulag_cmt_hurryup" ] = "gulag_cmt_hurryup";
	
	// Roach - forget that door! Plant the breaching charge on the wall, we're taking a shortcut!	
	level.scr_sound[ "soap" ][ "gulag_cmt_forgetthatdoor" ] = "gulag_cmt_forgetthatdoor";
	
	// Spread out!	
	level.scr_sound[ "soap" ][ "gulag_cmt_spreadout" ] = "gulag_cmt_spreadout";
	
	// Hostiles on the second floor! Take them out!	
	level.scr_sound[ "soap" ][ "gulag_cmt_hostiles2ndfloor" ] = "gulag_cmt_hostiles2ndfloor";
	
	// Keep moving!	
	level.scr_sound[ "soap" ][ "gulag_cmt_keepmoving" ] = "gulag_cmt_keepmoving";
	
	// Use the lockers for cover!	
	level.scr_sound[ "soap" ][ "gulag_cmt_uselockers" ] = "gulag_cmt_uselockers";
	
	// Heavy assault troops up ahead! Don't attack them head on! Move quickly and hit them from the side!	
	level.scr_sound[ "soap" ][ "gulag_cmt_hitfromside" ] = "gulag_cmt_hitfromside";
	
	// Cook your grenades to detonate behind them!	
	level.scr_sound[ "soap" ][ "gulag_cmt_cookgrenades" ] = "gulag_cmt_cookgrenades";
	
	// I�m heading for that hole in the floor on the far side of the showers! Follow me! Let's go!	
	level.scr_sound[ "soap" ][ "gulag_cmt_holeinfloor" ] = "gulag_cmt_holeinfloor";
	
	// Sheppard! We've got him but we're not out yet! Stall for more time! 	
	level.scr_sound[ "soap" ][ "gulag_cmt_needmoretime" ] = "gulag_cmt_needmoretime";
	
	// Sorry buddy. The navy says 'no can do.' Get your ass outta there now, I'm sending the chopper.	
	level.scr_radio[ "gulag_hqr_nocando" ] = "gulag_hqr_nocando";
	


	// Price! He's with us!	
	level.scr_sound[ "generic" ][ "gulag_cmt_heswithus" ] = "gulag_cmt_heswithus";
	
	// Soap?	
	level.scr_sound[ "generic" ][ "gulag_pri_soap" ] = "gulag_pri_soap";
	
	// Who's Soap?	
	level.scr_sound[ "generic" ][ "gulag_wrm_whosoap" ] = "gulag_wrm_whosoap";


	// Drop it!	
	level.scr_sound[ "generic" ][ "gulag_cmt_heswithus" ] = "gulag_cmt_heswithus";
	
	// Soap?	
	level.scr_sound[ "generic" ][ "gulag_pri_soap" ] = "gulag_pri_soap";
	
	// Who's Soap?	
	level.scr_sound[ "generic" ][ "gulag_wrm_whosoap" ] = "gulag_wrm_whosoap";
	
	// Captain� This belongs to you sir.	
	level.scr_sound[ "generic" ][ "gulag_cmt_belongstoyou" ] = "gulag_cmt_belongstoyou";
	
	// Come on, we gotta get outta here! Move! Move!	
	level.scr_sound[ "generic" ][ "gulag_cmt_getouttaheremove" ] = "gulag_cmt_getouttaheremove";
	
	// Who's Soap?	
	//level.scr_sound[ "generic" ][ "gulag_wrm_whosoap" ] = "gulag_wrm_whosoap";

	// Attention! The west tower has been destroyed! Enemy special forces troops are sniping at our air defense teams on the west wall from their helicopters! Shoot them down before they do any more damage!	
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_1" ] = "gulag_rpa_ext_1";
	// They have destroyed all surface-to-air missile batteries along the peninsula - activate local air defense system and engage at will!		
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_2" ] = "gulag_rpa_ext_2";
	// Enemy helicopters are attacking from the west! I repeat, enemy helicopters are attacking from the west!		
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_3" ] = "gulag_rpa_ext_3";
	// We are under attack! They are attempting to land troops via helicopter in the prison grounds!		
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_4" ] = "gulag_rpa_ext_4";
	// Attention! Attention! Reinforcements are on the way from Petropavlovsk Naval Base! They will arrive in thirty minutes!		
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_5" ] = "gulag_rpa_ext_5";
	// Enemy forces have infiltrated the base! They are moving from the helipad towards the southwest gate!		
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_6" ] = "gulag_rpa_ext_6";
	// Enemy special forces troops have landed! They are on the ground, I repeat, they are on the ground and moving towards the southwest gate!		
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_7" ] = "gulag_rpa_ext_7";
	// The southwest gate is taking heavy fire from enemy troops! Reinforce the southwest gate!		
	level.scr_sound[ "generic" ][ "gulag_rpa_ext_8" ] = "gulag_rpa_ext_8";
	// They are attacking the command center! I repeat, they are attacking the command center! Send reinforcements!!		
	level.scr_sound[ "generic" ][ "gulag_rpa_int_1" ] = "gulag_rpa_int_1";
	// They've taken the main control room and are moving through the central cellblock section!		
	level.scr_sound[ "generic" ][ "gulag_rpa_int_2" ] = "gulag_rpa_int_2";
	// They've taken out the main generator! We are switching to auxiliary power!		
	level.scr_sound[ "generic" ][ "gulag_rpa_int_3" ] = "gulag_rpa_int_3";
	// Send reinforcements to levels one and two of the main cellblock! Divert two teams to level three as a backup! Reinforcements from Petropavlovsk will arrive in twenty-five minutes!		
	level.scr_sound[ "generic" ][ "gulag_rpa_int_4" ] = "gulag_rpa_int_4";
	// Enemy is approaching the armory on level two, repeat, the enemy is approaching the armory on level two!		
	level.scr_sound[ "generic" ][ "gulag_rpa_int_5" ] = "gulag_rpa_int_5";

	/*
	// heavy breathing and "Soap?" 
	level.scr_sound[ "generic" ][ "gulag_pri_soap" ] = "gulag_pri_soap";

	//: just breathing 
	level.scr_sound[ "generic" ][ "gulag_pri_breath" ] = "gulag_pri_breath";

	// soap?
	level.scr_sound[ "generic" ][ "gulag_pri_soap2" ] = "gulag_pri_soap2";
	*/

	// yes!
	level.scr_sound[ "generic" ][ "gulag_pri_yes" ] = "gulag_pri_yes";

}
