#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

#using_animtree( "generic_human" );
main()
{	
	dialog();
	
	talking_anims();
	forward_run_anims();
	sniper_anims();
	bouncing_betty_anims();
	breach_anims();
	breach_data();
	ending_anims();
	ending_playerview_anims();
	ending_heli_anims();
}

talking_anims()
{
	level.scr_anim[ "ghost" ][ "temp_cellphone" ] = %patrol_bored_idle_cellphone;
	level.scr_anim[ "ghost" ][ "temp_walkto" ] = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "estate_ghost_radio" ] = %estate_ghost_radio;
	level.scr_anim[ "generic" ][ "estate_house_photoshoot" ] = %estate_house_photoshoot;
	
	level.scr_anim[ "generic" ][ "exposed_crouch_extendedpainA" ] = %exposed_crouch_extendedpainA;
}

forward_run_anims()
{
	level.scr_anim[ "ghost" ][ "downhill_run" ] = %estate_downhill_1;
	level.scr_anim[ "generic" ][ "downhill_run" ] = %estate_downhill_1;
	level.scr_anim[ "ozone" ][ "downhill_run" ] = %estate_downhill_1;
	level.scr_anim[ "scarecrow" ][ "downhill_run" ] = %estate_downhill_1;
	
	level.scr_anim[ "ghost" ][ "run" ] = %run_lowready_F;
	level.scr_anim[ "generic" ][ "run" ] = %run_lowready_F;
	level.scr_anim[ "ozone" ][ "run" ] = %run_lowready_F;
	level.scr_anim[ "scarecrow" ][ "run" ] = %run_lowready_F;
}
	
breach_anims()
{	
	level.scr_anim[ "generic" ][ "exposed_idle_reactA" ] = %exposed_idle_reactA;
	
	level.scr_anim[ "generic" ][ "favela_chaotic_cornerR_med90" ] = %favela_chaotic_cornerR_med90;
	level.scr_anim[ "generic" ][ "favela_chaotic_cornerCrL_fire_mid" ] = %favela_chaotic_cornerCrL_fire_mid;
	level.scr_anim[ "generic" ][ "favela_chaotic_cornerCrR_fire_mid" ] = %favela_chaotic_cornerCrR_fire_mid;
	
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_fireA" ] = %favela_chaotic_crouchcover_fireA;
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_fireB" ] = %favela_chaotic_crouchcover_fireB;
	
	level.scr_anim[ "generic" ][ "breach_react_blowback_v1" ] = %breach_react_blowback_v1;
	level.scr_anim[ "generic" ][ "breach_react_blowback_v2" ] = %breach_react_blowback_v2;
	level.scr_anim[ "generic" ][ "breach_react_blowback_v3" ] = %breach_react_blowback_v3;
	
	level.scr_anim[ "generic" ][ "breach_react_knife_charge" ] = %breach_react_knife_charge;
	level.scr_anim[ "generic" ][ "breach_react_knife_charge_death" ] = %death_shotgun_back_v1;
	
	//NOT USED
	
	/*
	
	level.scr_anim[ "generic" ][ "breach_react_desk_v1" ] = %breach_react_desk_v1;	//cool
	level.scr_anim[ "generic" ][ "breach_react_desk_v2" ] = %breach_react_desk_v2;
	level.scr_anim[ "generic" ][ "breach_react_desk_v3" ] = %breach_react_desk_v3;
	level.scr_anim[ "generic" ][ "breach_react_desk_v4" ] = %breach_react_desk_v4;	//cool
	level.scr_anim[ "generic" ][ "breach_react_desk_v7" ] = %breach_react_desk_v7;
	
	level.scr_anim[ "generic" ][ "patrol_bored_react_walkstop" ] = %patrol_bored_react_walkstop;
	
	level.scr_anim[ "generic" ][ "heat_stand_turn_R" ] = %heat_stand_turn_R;
	
	level.scr_anim[ "generic" ][ "favela_chaotic_crouchcover_fireC" ] = %favela_chaotic_crouchcover_fireC;
	
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_fireA" ] = %favela_chaotic_standcover_fireA;
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_fireB" ] = %favela_chaotic_standcover_fireB;
	level.scr_anim[ "generic" ][ "favela_chaotic_standcover_fireC" ] = %favela_chaotic_standcover_fireC;
	
	level.scr_anim[ "generic" ][ "favela_chaotic_cornerL_mid90" ] = %favela_chaotic_cornerL_mid90;
	
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy1" ] = %breach_react_guntoss_v2_guy1;
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy2" ] = %breach_react_guntoss_v2_guy2;
	
	level.scr_anim[ "generic" ][ "breach_react_push_guy1" ] = %breach_react_push_guy1;
	level.scr_anim[ "generic" ][ "breach_react_push_guy2" ] = %breach_react_push_guy2;
	
	level.scr_anim[ "generic" ][ "breach_chair_hide_reaction_v1" ] = %breach_chair_hide_reaction_v1;
	level.scr_anim[ "generic" ][ "breach_chair_hide_reaction_v1_death" ] = %covercrouch_death_1;
	level.scr_anim[ "generic" ][ "breach_chair_hide_reaction_v1_death2" ] = %covercrouch_death_2;
	
	level.scr_anim[ "generic" ][ "breach_chair_hide_reaction_v2" ] = %breach_chair_hide_reaction_v2;	//cool
	level.scr_anim[ "generic" ][ "breach_chair_hide_reaction_v2_death" ] = %breach_chair_hide_reaction_death_v2;
	
	level.scr_anim[ "generic" ][ "takedown_room2A_soldier" ] = %takedown_room2A_soldier;
	level.scr_anim[ "generic" ][ "takedown_room2A_soldier_idle" ][ 0 ] = %takedown_room2A_soldier_end_idle;
	level.scr_anim[ "generic" ][ "takedown_room2B_soldier" ] = %takedown_room2B_soldier;
	level.scr_anim[ "generic" ][ "takedown_room2B_soldier_idle" ][ 0 ] = %takedown_room2B_soldier_idle;
	level.scr_anim[ "generic" ][ "takedown_room1A_soldier" ] = %takedown_room1A_soldier;
	level.scr_anim[ "generic" ][ "takedown_room1A_soldier_idle" ][ 0 ] = %takedown_room1A_soldier_idle;
	level.scr_anim[ "generic" ][ "takedown_room1B_soldier" ] = %takedown_room1B_soldier;
	level.scr_anim[ "generic" ][ "takedown_room1B_soldier_idle" ][ 0 ] = %takedown_room1B_soldier_idle;
	
	*/
	
}

ending_anims()
{
	level.scr_model[ "body_ending" ] 							 		= "ch_body_gk_ar15";
	level.scr_animtree[ "body_ending" ] 							 	= #animtree;
	level.scr_anim[ "body_ending" ][ "estate_ending_part1" ] 			= %estate_chopper_sequence_body;
	
	level.scr_anim[ "ghost" ][ "estate_ending_drag" ] 					= %estate_drag_friendly;
	level.scr_anim[ "ghost_ending" ][ "estate_ending_part1" ] 			= %estate_chopper_sequence_soldier;
	
	level.scr_anim[ "shepherd_ending" ][ "estate_ending_part1" ] 		= %estate_chopper_sequence_leader;
	addNotetrack_dialogue( "shepherd_ending" , "shepherd_dsm_talk" , "estate_ending_part1" , "est_shp_havethedsm" );
	addNotetrack_dialogue( "shepherd_ending" , "shepherd_talk_looseend" , "estate_ending_part1" , "est_shp_looseend" );
	
	level.scr_anim[ "guy1_ending" ][ "estate_ending_part1" ] 			= %estate_chopper_sequence_enemy1;
	level.scr_anim[ "guy2_ending" ][ "estate_ending_part1" ] 			= %estate_chopper_sequence_enemy2;

	level.scr_anim[ "guy1_ending" ][ "estate_ending_part2" ] 			= %estate_body_toss_guy1;
	level.scr_anim[ "guy2_ending" ][ "estate_ending_part2" ] 			= %estate_body_toss_guy2;
	level.scr_anim[ "body_ending" ][ "estate_ending_part2" ] 			= %estate_body_toss_body;
	
	level.scr_anim[ "guy1_ending" ][ "estate_ending_part2_2ndbody" ]	= %estate_2ND_body_toss_guy1;
	level.scr_anim[ "guy2_ending" ][ "estate_ending_part2_2ndbody" ]	= %estate_2ND_body_toss_guy2;
	//level.scr_anim[ "body_ending" ][ "estate_ending_part2_2ndbody" ]	= %estate_2ND_body_toss_body;
	level.scr_anim[ "ghost_ending_dead" ][ "estate_ending_part2_2ndbody" ]	= %estate_2ND_body_toss_body;
	
	level.scr_anim[ "gasolineGuy" ][ "estate_ending_part3" ] 			= %estate_ending_gasoline_guy;
	level.scr_anim[ "shepherd_ending" ][ "estate_ending_part3" ] 		= %estate_ending_gasoline_leader;
	
	//play gascan effects
	addNotetrack_customFunction( "gasolineGuy", "gas_splash_start", ::play_gas_can_fx_splash );
	addNotetrack_customFunction( "gasolineGuy", "gas_drip_start", ::play_gas_can_fx_drips );
	addNotetrack_customFunction( "gasolineGuy", "gas_splash_end", ::stop_gas_can_fx_splash );
	addNotetrack_customFunction( "gasolineGuy", "gas_drip_end", ::stop_gas_can_fx_drips );
	addNotetrack_customFunction( "ghost_ending_dead", "bodyfall large", ::play_bodyimpact_fx );
	addNotetrack_customFunction( "ghost_ending", "blood_splat", ::play_ghost_shot_fx );

}

play_ghost_shot_fx( ghost_ending )
{
	//iprintlnbold( "ghost betrayed" );
	PlayFXOnTag( getfx( "flesh_hit_body_fatal_exit" ), ghost_ending, "J_SpineUpper" );
}

play_gas_can_fx_splash( gasolineGuy )
{
	self endon("gas_splash_end");
//	iprintlnbold( "splash!" );
	for ( ;; )
	{
		PlayFXOnTag( getfx( "gas_can_splash" ), gasolineGuy, "TAG_FX" );
		wait( 0.03 );
	}
}

play_gas_can_fx_drips( gasolineGuy )
{
	self endon("gas_drip_end");
//	iprintlnbold( "drip!" );
	for ( ;; )
	{
		PlayFXOnTag( getfx( "gas_can_splash" ), gasolineGuy, "TAG_FX" );
		wait( 0.03 );
	}
}

stop_gas_can_fx_splash( gasolineGuy )
{
//	iprintlnbold( "stop splash!" );
	self notify( "gas_splash_end" );	
}

stop_gas_can_fx_drips( gasolineGuy )
{
//	iprintlnbold( "stop drip!" );
	self notify( "gas_drip_end" );	
}

play_bodyimpact_fx( ghost_ending )
{
	//iprintlnbold( "poof_ghost" );
	PlayFXOnTag( getfx( "bodydump_dust_large" ), ghost_ending, "J_SpineLower" );
}


sniper_anims()
{
	level.scr_anim[ "ghillie" ][ "prone_2_stand" ]	 			= %prone_2_stand;	
	level.scr_anim[ "ghillie" ][ "prone_2_stand_firing" ]	 	= %prone_2_stand_firing;	
}

dialog()
{
	// Archer: Snipers in position.
	level.scr_radio[ "est_snp1_inposition" ] 								= "est_snp1_inposition";
	
	// Scarecrow: Roger that.
	level.scr_radio[ "est_sld1_rogerthat" ] 								= "est_sld1_rogerthat";
	
	// Ozone: Solid copy.
	level.scr_radio[ "est_sld2_solidcopy" ] 								= "est_sld2_solidcopy";

	// Ghost: Strike team, go. Engage Makarov on sight.
	level.scr_sound[ "ghost" ][ "est_gst_engageonsight" ] 				= "est_gst_engageonsight";
	
	// Let's go, let's go!
	level.scr_sound[ "ghost" ][ "est_gst_letsgoletsgo" ]				= "est_gst_letsgoletsgo";
	
	// AMBUUUSH!!!!
	level.scr_sound[ "ghost" ][ "est_gst_ambush" ]						= "est_gst_ambush";
		
	// AMBUUUSH!!!!!
	level.scr_sound[ "ozone" ][ "est_tf1_ambush" ]						= "est_tf1_ambush";
	
	// AMBUUUSH!!!!!
	level.scr_sound[ "scarecrow" ][ "est_tf2_ambush" ]						= "est_tf2_ambush";
	
	// Taaargeets!!!! Left sidde!! Left siide!!!!!
	level.scr_sound[ "ghost" ][ "est_gst_targetsleftside" ]						= "est_gst_targetsleftside";
	
	// COUNTERATTACK INTO THE SMOKE! Push push push!!!
	level.scr_sound[ "ghost" ][ "est_gst_counterattack" ]						= "est_gst_counterattack";
	
	// Roach! You're gonna get hit by a mortar! Lose 'em in the smoke!! Go go gooo!!!!
	level.scr_sound[ "ghost" ][ "est_gst_loseeminsmoke" ]						= "est_gst_loseeminsmoke";
	
	// They've got this area presighted for mortar fire!!!
	level.scr_sound[ "scarecrow" ][ "est_scr_presighted" ]						= "est_scr_presighted";
	
	// Hostile chopper to the south!
	level.scr_sound[ "ghost" ][ "est_gst_hostchopper" ]						= "est_gst_hostchopper";
	
	// Archer: We got two trucks leaving the target building!
	level.scr_radio[ "est_snp1_trucksleaving" ] 								= "est_snp1_trucksleaving";
	
	// Don't let those trucks get awaay!!!
	level.scr_sound[ "ghost" ][ "est_gst_trucksgetaway" ]						= "est_gst_trucksgetaway";
	
	// Bloody hell, these trucks are bulletproofed!
	level.scr_sound[ "ghost" ][ "est_gst_bulletproofed" ]						= "est_gst_bulletproofed";
	
	// Archer: Roger! Firing Javelin, danger close!
	level.scr_radio[ "est_snp1_firingjavelin" ] 								= "est_snp1_firingjavelin";
	
	//Javelin, danger clooose!!! Get back from the roaaad!!!
	level.scr_sound[ "ghost" ][ "est_gst_dangerclose" ]						= "est_gst_dangerclose";
	
	// Archer: Two away!
	level.scr_radio[ "est_snp1_twoaway" ] 								= "est_snp1_twoaway";
	
	// Archer: Moving vehicles have been neutralized.
	level.scr_radio[ "est_snp1_neutralized" ] 								= "est_snp1_neutralized";
	
	// Archer: Be advised, we have not, I repeat, we have not spotted Makarov, and no one else has left the house. Those trucks may have been decoys.
	level.scr_radio[ "est_snp1_decoys" ] 								= "est_snp1_decoys";
	
	//Roger that, we're advancing on the house now! 
	level.scr_sound[ "ghost" ][ "est_gst_advancingonhouse" ]						= "est_gst_advancingonhouse";
	
	//Clear the perimeter!
	level.scr_sound[ "ghost" ][ "est_gst_clearperimieter" ]						= "est_gst_clearperimieter";
	
	//Breach and clear the safehouse! Go! Go!
	level.scr_sound[ "ghost" ][ "est_gst_breachnclear" ]						= "est_gst_breachnclear";
	
	//Office clear!	
	level.scr_radio[ "est_gst_officeclear" ]						= "est_gst_officeclear";
	
	//Dining room clear!
	level.scr_radio[ "est_gst_diningroomclr" ]						= "est_gst_diningroomclr";
	
	//Clear!	
	level.scr_radio[ "est_gst_clear" ]						= "est_gst_clear";
	
	//Let's go, let's go!
	level.scr_radio[ "est_gst_letsgo2" ]						= "est_gst_letsgo2";
	
	//Roach, go upstairs and check any locked rooms on the top floor. Breach and clear.	
	level.scr_radio[ "est_gst_lockedrooms" ]						= "est_gst_lockedrooms";
	
	//I've got this area covered Roach. Get upstairs and check the rooms on the top floor.	
	level.scr_radio[ "est_scr_getupstairs" ]						= "est_scr_getupstairs";
	
	//Roach, check the basement for enemy activity. Breach and clear. Go.	
	level.scr_radio[ "est_gst_checkbasement" ]						= "est_gst_checkbasement";
	
	//Scarecrow, gimme a sitrep.	
	level.scr_radio[ "est_gst_sitrep" ]						= "est_gst_sitrep";
	
	//No one's leaving through the front of the basement.
	level.scr_radio[ "est_scr_noonesleaving" ]						= "est_scr_noonesleaving";
	
	//Ozone, make sure no one leaves through the kitchen.	
	level.scr_radio[ "est_gst_thrukitchen" ]						= "est_gst_thrukitchen";
	
	//Roger that.	
	level.scr_radio[ "est_ozn_rogerthat" ]						= "est_ozn_rogerthat";

	//Main floor clear!
	level.scr_radio[ "est_scr_mainfloor" ]						= "est_scr_mainfloor";

	//Copy that, main floor clear!
	level.scr_radio[ "est_gst_mainfloor" ]						= "est_gst_mainfloor";

	//I got your back, Roach.	
	level.scr_radio[ "est_scr_gotyourback" ]						= "est_scr_gotyourback";

	//Basement clear!	
	level.scr_radio[ "est_scr_basement" ]						= "est_scr_basement";
	
	//Copy, basement clear!
	level.scr_radio[ "est_gst_basement" ]						= "est_gst_basement";
	
	//Top floor clear!	
	level.scr_radio[ "est_scr_topfloor" ]						= "est_scr_topfloor";
	
	//Roger that, top floor clear!
	level.scr_radio[ "est_gst_topfloor" ]						= "est_gst_topfloor";
	
	//All clear. Squad, regroup on me.
	level.scr_radio[ "est_gst_regroup" ]						= "est_gst_regroup";
	
	//Scarecrow, photographs.
	level.scr_sound[ "ghost" ][ "est_gst_photos" ]						= "est_gst_photos";
	
	//Roger that.
	level.scr_radio[ "est_scr_rogerthat" ] 								= "est_scr_rogerthat";
	
	//Shepherd, this is Ghost. No sign of Makarov, I repeat, no sign of Makarov. Captain Price, any luck in Afghanistan?
	level.scr_sound[ "ghost" ][ "est_gst_nosign" ]						= "est_gst_nosign";
	
	//Negative. Soap and I are in position at the boneyard. No sign of Makarov. So much for the intel.
	level.scr_radio[ "est_pri_somuchforintel" ]						= "est_pri_somuchforintel";
	
	//Price: Plenty...at least fifty hired guns here, but no sign of Makarov. Perhaps our intel was off.
	level.scr_radio[ "est_pri_atleast50" ]							= "est_pri_atleast50";
	
	//Well, the quality of the intel's about to change. This safehouse's a bloody gold mine.
	level.scr_sound[ "ghost" ][ "est_gst_goldmine" ]						= "est_gst_goldmine";
	
	//Shepherd: Copy that. Ghost, have your team collect everything you can for an operations playbook. Names, contacts, places, everything.
	level.scr_radio[ "est_shp_everything" ] 								= "est_shp_everything";
	
	//We're already on it sir. Makarov will have nowhere to run.
	level.scr_sound[ "ghost" ][ "est_gst_alreadyonit" ]						= "est_gst_alreadyonit";
	
	//Shepherd: That's the idea. I'm bringing up the extraction force, E.T.A. five minutes. Get that intel. Shepherd out.
	level.scr_radio[ "est_shp_eta5mins" ] 								= "est_shp_eta5mins";
	
	//Roach, get to Makarov's computer and start the transfer.
	level.scr_sound[ "ghost" ][ "est_gst_starttransfer" ]						= "est_gst_starttransfer";
	
	//Ozone, you're on rear security. I've got the front. Go.
	level.scr_sound[ "ghost" ][ "est_gst_rearsecurity" ]						= "est_gst_rearsecurity";	
	
	//On my way.
	level.scr_radio[ "est_ozn_onmyway" ] 								= "est_ozn_onmyway";
	
	//Price: Task Force, this is Price. More of Makarov's men just arrived at the boneyard. They're searching for something�
	level.scr_radio[ "est_pri_searching" ]								= "est_pri_searching";
	
	//Price: Wait...they're getting closer to us�
	level.scr_radio[ "est_pri_gettingcloser" ]							= "est_pri_gettingcloser";
	
	//Price: We're going silent for a few minutes. Good luck up there in Russia. Price out.
	level.scr_radio[ "est_pri_goingsilent" ]							= "est_pri_goingsilent";
	
	//Roach - connect the DSM to Makarov's computer.
	level.scr_radio[ "est_gst_filesoff" ] 								= "est_gst_filesoff";
	
	//Roach, we're not leaving without those files. Start the transfer.
	level.scr_radio[ "est_gst_startdownload" ] 								= "est_gst_startdownload";
	
	//Sniper Team One to strike team, be advised, we got enemy helos approaching from the northwest and southeast. 
	level.scr_radio[ "est_snp1_mainroad" ] 								= "est_snp1_mainroad";
	
	//We got 60 seconds tops, over. 
	level.scr_radio[ "est_snp1_60seconds" ] 								= "est_snp1_60seconds";
	
	//Makarov's men are going to do whatever it takes to keep us from leaving with this intel. We need to protect the DSM until the transfer's done.
	level.scr_radio[ "est_gst_withintel" ] 								= "est_gst_withintel";
	
	//Use the weapons caches and set up your claymores if you've got any left. Defensive positions, let's go!
	level.scr_radio[ "est_gst_weaponscache" ] 								= "est_gst_weaponscache";
	
	//Enemy choppers in 15 seconds. 
	level.scr_radio[ "est_snp1_15seconds" ] 								= "est_snp1_15seconds";
	
	//Roger that, 15 seconds!
	level.scr_radio[ "est_gst_15seconds" ] 								= "est_gst_15seconds";
	
	//I'm in position!
	level.scr_radio[ "est_scr_inposition" ] 								= "est_scr_inposition";
	
	//Ready to engage!
	level.scr_radio[ "est_ozn_readyengage" ] 								= "est_ozn_readyengage";
	
	//Roach, there's an armory in the basement. Better stock up while you can.	
	level.scr_radio[ "est_ozn_stockup" ] 								= "est_ozn_stockup";
	
	//********* MD500_rush strikepackage
	
	//Enemy fast-attack choppers coming in from the northwest.	
	level.scr_radio[ "est_snp1_fastattack" ] 								= "est_snp1_fastattack";
	
	//Roger that. Enemy helos approaching from the northwest.	
	level.scr_radio[ "est_gst_helosnw" ] 								= "est_gst_helosnw";
	
	//We gotta cover the front lawn! 	
	level.scr_radio[ "est_scr_frontlawn" ] 								= "est_scr_frontlawn";
	
	//I'm moving to the main windows, I need someone to mine and cover the driveway approach.	
	level.scr_radio[ "est_ozn_mainwindows" ] 								= "est_ozn_mainwindows";
	
	//Roach, use your claymores on the driveway and pull back to the house!	
	level.scr_radio[ "est_gst_useclaymores" ] 								= "est_gst_useclaymores";
	
	//********* Birchfield FenceBreachers Pkg
	
	//What the hell was that?	
	level.scr_radio[ "est_scr_whatwasthat" ] 								= "est_scr_whatwasthat";
	
	//Be advised, you have a large concentration of hostiles moving in from the southeast, they just breached the perimeter!	
	level.scr_radio[ "est_snp1_hostilesse" ] 								= "est_snp1_hostilesse";
	
	//I'll try to thin 'em out before they get too close. Recommend you switch to scoped weapons, over.	
	level.scr_radio[ "est_snp1_thinemout" ] 								= "est_snp1_thinemout";
	
	//Roger that! Everyone cover the field to the southeast! Move!	
	level.scr_radio[ "est_gst_fieldtose" ] 								= "est_gst_fieldtose";
	
	//I got eyes on! Here they come! They're in the field to the the southeast!	
	level.scr_radio[ "est_ozn_eyeson" ] 								= "est_ozn_eyeson";

	//********* Boathouse Helidrop Pkg

	//They're dropping in more troops west of the house!	
	level.scr_radio[ "est_snp1_troopswest" ] 								= "est_snp1_troopswest";
	
	//They must be by the boathouse! Cover the west approach! 
	level.scr_radio[ "est_gst_boathouse" ] 								= "est_gst_boathouse";
	
	//We got 249s and RPGs at the dining room window, plus L86 machine guns.	
	level.scr_radio[ "est_ozn_249sandrpgs" ] 								= "est_ozn_249sandrpgs";
	
	//Roger that, use 'em to cut 'em down as they come outta the treeline!	
	level.scr_radio[ "est_gst_cutemdown" ] 								= "est_gst_cutemdown";
	
	//You have hostiles approaching from the boathouse to the west, over.	
	level.scr_radio[ "est_snp1_boathousewest" ] 								= "est_snp1_boathousewest";
	
	//Roger that, hostiles approaching from the west side of the house!	
	level.scr_radio[ "est_gst_westsideofhouse" ] 								= "est_gst_westsideofhouse";

	//********* Solarfield SmokeAssault Pkg

	//I have eyes on additional hostile forces moving in on your position. They're approaching through the solar panels east of the house.	
	level.scr_radio[ "est_snp1_additionalhostile" ] 								= "est_snp1_additionalhostile";
	
	//They're moving in through the solar panels east of the house!	
	level.scr_radio[ "est_gst_solarpanelseast" ] 								= "est_gst_solarpanelseast";
	
	//Roger, I'll try to cut 'em off as they come through the trees.	
	level.scr_radio[ "est_scr_comethrutrees" ] 								= "est_scr_comethrutrees";
	
	//Use your claymores if you have 'em. Plant 'em around the trail east of the house.	
	level.scr_radio[ "est_gst_easttrail" ] 								= "est_gst_easttrail";

	//********* Archer the Magical Sniper
	
	//Tango down.
	level.scr_radio[ "est_snp1_tangodown" ] 								= "est_snp1_tangodown";
	
	//Got one.	
	level.scr_radio[ "est_snp1_gotone" ] 								= "est_snp1_gotone";
	
	//Hostile neutralized.	
	level.scr_radio[ "est_snp1_hostneut" ] 								= "est_snp1_hostneut";
	
	//That's one down.	
	level.scr_radio[ "est_snp1_thatsakill" ] 								= "est_snp1_thatsakill";
	
	//Tango down.	
	level.scr_radio[ "est_snp1_thatsone" ] 								= "est_snp1_thatsone";
	
	//That's a kill.	
	level.scr_radio[ "est_snp1_tangodown2" ] 								= "est_snp1_tangodown2";
	
	//Dropped him.
	level.scr_radio[ "est_snp1_droppedhim" ] 								= "est_snp1_droppedhim";
	
	//He's down.	
	level.scr_radio[ "est_snp1_hesdown" ] 								= "est_snp1_hesdown";
	
	//I'm moving to a different vantage point. Sniper support will be unavailable for forty-five seconds, standby.	
	level.scr_radio[ "est_snp1_moving" ] 								= "est_snp1_moving";
	
	//I'm displacing. You're gonna be without sniper support for thirty seconds, standby.	
	level.scr_radio[ "est_snp1_displacing" ] 								= "est_snp1_displacing";

	//********* RPG Components **********//
	
	//RPG team moving in from the east!!	
	level.scr_radio[ "est_snp1_rpgteameast" ] 								= "est_snp1_rpgteameast";
	
	//Roger that, RPG team moving in from the east!!	
	level.scr_radio[ "est_ozn_rpgteameast" ] 								= "est_ozn_rpgteameast";
	
	//RPG team approaching from the west!!	
	level.scr_radio[ "est_snp1_rpgteamwest" ] 								= "est_snp1_rpgteamwest";
	
	//Solid copy! RPG team approaching from the west!!	
	level.scr_radio[ "est_gst_rpgteamwest" ] 								= "est_gst_rpgteamwest";
	
	//RPG team moving in from the southwest!!	
	level.scr_radio[ "est_snp1_rpgteamsw" ] 								= "est_snp1_rpgteamsw";
	
	//Got it! RPG team moving in from the southwest!!	
	level.scr_radio[ "est_ozn_rpgteamsw" ] 									= "est_ozn_rpgteamsw";

	//********* FRIENDLY OBITUARIES ***********//

	//Aaagh! I'm hit!!! Need assis- (static hiss)	
	level.scr_radio[ "est_ozn_imhit" ] 									= "est_ozn_imhit";
	
	//Ozone is down!	
	level.scr_radio[ "est_snp1_ozoneisdown" ] 									= "est_snp1_ozoneisdown";
	
	//I'm hit - (static hiss) 	
	level.scr_radio[ "est_scr_imhit" ] 									= "est_scr_imhit";
	
	//Scarecrow is down, I repeat Scarecrow is down!	
	level.scr_radio[ "est_snp1_scarecrowdown" ] 								= "est_snp1_scarecrowdown";
	
	//********* ABANDONMENT MECHANIC ***********//
	
	//Roach! Stay the close to the house!		
	level.scr_radio[ "est_gst_stayclose" ] 								= "est_gst_stayclose";
	
	//Roach! Don't stray too far from the safehouse! We need to protect the transfer!		
	level.scr_radio[ "est_gst_dontstray" ] 								= "est_gst_dontstray";
	
	//Roach, where the hell are you?! Fall back to the house! Move!	
	level.scr_radio[ "est_gst_fallback" ] 								= "est_gst_fallback";
	
	//Roach, pull back to the safehouse! They're trying to stop the transfer!		
	level.scr_radio[ "est_gst_tryingtostop" ] 								= "est_gst_tryingtostop";
	
	//There's too many of them in here! Roach!!! We've lost the DSM, I repeat we've lost-(static hiss)		
	level.scr_radio[ "est_gst_lostthedsm" ] 								= "est_gst_lostthedsm";
	
	//Roach! They've destroyed the DSM!! They've destroyed-(static hiss)	
	level.scr_radio[ "est_gst_destroyedthedsm" ] 								= "est_gst_destroyedthedsm";
	
	//********* GET THE DSM ***********//
	
	//Roach, the transfer's complete! I'll cover the main approach while you get the DSM! Move!	
	level.scr_radio[ "est_gst_dsmcomplete" ] 								= "est_gst_dsmcomplete";
	
	//Roach! I'm covering the front! Get the DSM! We gotta get outta here!	
	level.scr_radio[ "est_gst_getouttahere" ] 								= "est_gst_getouttahere";
	
	
	//********* Birchfield Exfil *********//

	//This is Shepherd. We're almost at the LZ. What's your status, over?	
	level.scr_radio[ "est_shp_almostatlz" ] 								= "est_shp_almostatlz";
	
	//We're on our way to the LZ! Roach, let's go!!	
	level.scr_sound[ "ghost" ][ "est_gst_onourway" ]						= "est_gst_onourway";

	//They're bracketing our position with mortars, keep moving but watch your back!!!	
	level.scr_sound[ "ghost" ][ "est_gst_bracketing" ]						= "est_gst_bracketing";
	
	//We gotta get to the LZ! Roach, come on!	
	level.scr_sound[ "ghost" ][ "est_gst_gettothelz" ]						= "est_gst_gettothelz";
	
	//Roach, I got you covered!! Go! Go!!	
	level.scr_sound[ "ghost" ][ "est_gst_gotyoucovered" ]						= "est_gst_gotyoucovered";
	
	//I'll cover you! Move!!!		
	level.scr_sound[ "ghost" ][ "est_gst_illcoveryou" ]						= "est_gst_illcoveryou";
	
	//Get to the LZ! Keep moving!		
	level.scr_sound[ "ghost" ][ "est_gst_keepmoving" ]						= "est_gst_keepmoving";
	
	//Go! Go!		
	level.scr_sound[ "ghost" ][ "est_gst_gogo" ]						= "est_gst_gogo";
	
	//********* Ending - Player Drag *************//

	//I've got you Roach, hang on!
	level.scr_radio[ "est_gst_gotyouroach" ] 								= "est_gst_gotyouroach";
	
	//Thunder Two-One, I've popped red smoke in the treeline! Standby to engage on my mark!
	level.scr_radio[ "est_gst_redsmoke" ]									= "est_gst_redsmoke";

	//Roger that, I have a visual on the red smoke. Standing by.
	level.scr_radio[ "est_fp1_visual" ] 									= "est_fp1_visual";

	//Thunder Two-One, cleared hot!
	level.scr_radio[ "est_gst_clearedhot" ] 								= "est_gst_clearedhot";
	
	//Roger that cleared hot. 	
	level.scr_radio[ "est_fp1_clearedhot" ] 								= "est_fp1_clearedhot";
	
	//Guns guns guns.
	level.scr_radio[ "est_hp1_gunsgunsguns" ] 								= "est_hp1_gunsgunsguns";	
	
	//Roach, hang in there!!!	
	level.scr_radio[ "est_gst_hanginthere" ] 								= "est_gst_hanginthere";
	
	//********* Ending - Final Walk *************//
	
	//Come on, get up!	
	level.scr_sound[ "ghost_ending" ][ "est_gst_comeongetup" ]						= "est_gst_comeongetup";
	
	//Get up! Get up! We're almost there!	
	level.scr_sound[ "ghost_ending" ][ "est_gst_getupgetup" ]						= "est_gst_getupgetup";
	
	//This is Viper Two-Six, standby for rocket attack, over.	
	level.scr_radio[ "est_hp1_rocketattck" ] 								= "est_hp1_rocketattck";
	
	//Uh, roger�hit 'em hard on that hill, make sure they're down.
	level.scr_radio[ "est_hp2_hitemhard" ] 								= "est_hp2_hitemhard";	

	//Roger I'm on it. Coming around on heading two-five-zero.	
	level.scr_radio[ "est_hp1_imonit" ] 								= "est_hp1_imonit";	

	//Roger, I got 'em lined up.
	level.scr_radio[ "est_hp1_linedup" ] 								= "est_hp1_linedup";
	
	//Gold Eagle is on the ground. Watch for snipers on thermal, over.	
	level.scr_radio[ "est_hp2_watchforsnipers" ] 								= "est_hp2_watchforsnipers";
	
	//********* Ending - Shepherd's Greeting *************//
	
	//Do you have the DSM?	
	//level.scr_sound[ "shepherd_ending" ][ "est_shp_havethedsm" ]			= "est_shp_havethedsm";
	
	//We got it, sir!	
	level.scr_sound[ "ghost_ending" ][ "est_gst_wegotit" ]						= "est_gst_wegotit";
	
	//Well done, soldier.	
	level.scr_sound[ "shepherd_ending" ][ "est_shp_welldone" ]			= "est_shp_welldone";
	
	//Good. That's one less loose end.
	//level.scr_sound[ "shepherd_ending" ][ "est_shp_looseend" ]			= "est_shp_looseend";
	
	//NO!	
	level.scr_sound[ "ghost_ending" ][ "est_gst_no" ]						= "est_gst_no";
	
	//Area is sanitized. All targets destroyed.
	level.scr_radio[ "est_hp2_sanitized" ] 								= "est_hp2_sanitized";	

	//Solid copy, no movement detected. Two-six going into holding pattern.	
	level.scr_radio[ "est_hp1_holdingpattern" ] 								= "est_hp1_holdingpattern";	
	
	//********* Ending - Price on radio *************//
	
	//Ghost, come in, this is Price! We're under attack by Shepherd's men at the boneyard! 	
	level.scr_radio[ "est_pri_comein" ] 								= "est_pri_comein";	
	
	//(off mike) Soap, hold the left flank! 	
	level.scr_radio[ "est_pri_holdleftflank" ] 								= "est_pri_holdleftflank";	

	//Do not trust Shepherd - I say again, do not trust Shepherd!	
	level.scr_radio[ "est_pri_donottrust" ] 								= "est_pri_donottrust";	

	//(off mike) Soap get dowwwwn!!!	
	level.scr_radio[ "est_pri_getdown" ] 								= "est_pri_getdown";	
	
	//All 4 above lines combined and edited into one cool sounding delivery
	level.scr_radio[ "est_pri_underattack" ] 								= "est_pri_underattack";	
}

#using_animtree( "script_model" );
bouncing_betty_anims()
{
	level.scr_animtree[ "bouncingbetty" ] 								= #animtree;
	level.scr_anim[ "bouncingbetty" ][ "bouncing_betty_detonate" ]		= %bouncing_betty_detonate;
	level.scr_model[ "bouncingbetty" ] 									= "projectile_bouncing_betty_grenade";
}

breach_data()
{
	level.scr_anim[ "breach_door_model_estate" ][ "breach" ]	 		= %breach_player_door_v2;
	level.scr_animtree[ "breach_door_model_estate" ]					= #animtree;
	level.scr_model[ "breach_door_model_estate" ]						= "com_door_02_handleright";
	//level.scr_model[ "breach_door_model_estate" ]						= "com_door_02_handleleft";
	
	level.scr_anim[ "breach_door_hinge_estate" ][ "breach" ]			= %breach_player_door_hinge_v1;
	level.scr_animtree[ "breach_door_hinge_estate" ] 					= #animtree;
	level.scr_model[ "breach_door_hinge_estate" ] 						= "com_door_piece_hinge2";
}

#using_animtree( "player" );
ending_playerview_anims()
{
	level.scr_animtree[ "playerview" ] 							 	 	= #animtree;
	//level.scr_model[ "playerview" ] 							 		= "viewhands_player_sas_woodland";
	level.scr_model[ "playerview" ] 							 		= "ch_viewhands_player_gk_ar15";
	
	level.scr_anim[ "playerview" ][ "estate_ending_drag" ] 				= %estate_drag_player;
	level.scr_anim[ "playerview" ][ "estate_ending_part1" ] 			= %estate_chopper_sequence_player;
	level.scr_anim[ "playerview" ][ "estate_ending_part2" ] 			= %estate_body_toss_player;

	addNotetrack_customFunction( "playerview", "bodyfall large", ::play_bodyimpact_fx_player );

}

play_bodyimpact_fx_player( playerview )
{
	//iprintlnbold( "poof player" );
	PlayFXOnTag( getfx( "bodydump_dust_large" ), playerview, "J_Wrist_RI" );
}

#using_animtree( "vehicles" );
ending_heli_anims()
{
	level.scr_animtree[ "pavelow" ]									= #animtree;
	level.scr_anim[ "pavelow" ][ "estate_ending_part1" ] 			= %estate_chopper_sequence_pavelow;
}
	
/*

house breach anims

breach_react_desk_v1
breach_chair_hide_reaction_v1
breach_chair_hide_reaction_v2
breach_react_desk_v4

*/