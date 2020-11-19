#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;


main_anim()
{
	ride_vehicle_anims();
	ride_player_anims();
	generic_human();
	dialog();
	vehicles();
}

//notetrack_gun_2_chest( guy )
//{
//	level notify( "gun_2_chest" );
//}
//
//notetrack_shotgun_pickup( guy )
//{
//	level notify( "shotgun_pickup" );
//}

notetrack_notify_attach_rocket( guy )
{
	guy notify( "attach rocket" );
}

notetrack_notify_fire_rocket( guy )
{
	guy notify( "fire rocket" );
}

notetrack_notify_drop_rocket( guy )
{
	guy notify( "drop rocket" );
}

#using_animtree( "vehicles" );
ride_vehicle_anims()
{
	level.scr_anim[ "generic" ][ "boneyard_UAZ_door" ]			= %boneyard_UAZ_door;
}

//called by main contingency script
#using_animtree( "vehicles" );
ride_uaz_door()
{
	anim_model = self maps\_vehicle_aianim::getanimatemodel();
	anim_model setflaggedanimknob( "uaz_door_anim", level.scr_anim[ "generic" ][ "boneyard_UAZ_door" ], 1, .2, 1 );
	anim_model waittillmatch( "uaz_door_anim", "end" );
	anim_model ClearAnim( level.scr_anim[ "generic" ][ "boneyard_UAZ_door" ], 0 );
	
/*
	flag_wait( "wait_for_player" );
	anim_model = self maps\_vehicle_aianim::getanimatemodel();
	anim_model maps\_vehicle_aianim::setanimrestart_once( %uaz_passenger_exit_into_stand_door, false );

	flag_wait( "uaz_mounted" );
	anim_model ClearAnim( %uaz_passenger_exit_into_stand_door, 0 );
	anim_model maps\_vehicle_aianim::setanimrestart_once( %uaz_passenger_enter_from_huntedrun_door, true );
*/
}


#using_animtree( "player" );
ride_player_anims()
{
	level.scr_animtree[ "player_rig" ] 							= #animtree;
	level.scr_model[ "player_rig" ] 							= "ch_viewhands_player_gk_ar15";
	level.scr_anim[ "player_rig" ][ "boneyard_uaz_mount" ]		= %boneyard_player_enter_UAZ;
}

#using_animtree( "generic_human" );
generic_human()
{
	level.scr_anim[ "price" ][ "intro" ]	= %contengency_price_intro;
	level.scr_anim[ "generic" ][ "cqb_stand_idle_scan" ]	= %patrol_bored_react_look_v1; 
	//level.scr_anim[ "generic" ][ "cqb_stand_idle_scan" ]	= %cqb_stand_idle_scan;
		
	level.scr_anim[ "price" ][ "slide" ]	= %contengency_price_slide;
	level.scr_anim[ "price" ][ "caution_stop" ]	= %afgan_caves_intro_stop;
	
	
	level.scr_anim[ "generic" ][ "tear_gas_guy1" ]	= %contingency_teargas_1;
	level.scr_anim[ "generic" ][ "tear_gas_guy2" ]	= %contingency_teargas_2;
	level.scr_anim[ "generic" ][ "tear_gas_guy3" ]	= %contingency_teargas_3;
	
	//FRAME 29 "attach rocket"
	//FRAME 47 "fire rocket"
	//FRAME 80 "drop rocket"

	addNotetrack_customFunction( "price", "price_land", ::price_land_fx );
	addNotetrack_customFunction( "price", "price_land_settle", ::price_land_settle_fx );
	addNotetrack_customFunction( "price", "price_slide_start", ::price_slide_fx );
	addNotetrack_customFunction( "price", "price_slide_end", ::price_stop_slide_fx );
	
	level.scr_anim[ "bricktop" ][ "at4_fire" ] = %contengency_rocket_moment;
	addNotetrack_customFunction( "bricktop", "attach rocket", ::notetrack_notify_attach_rocket, "at4_fire" );
	addNotetrack_customFunction( "bricktop", "fire rocket", ::notetrack_notify_fire_rocket, "at4_fire" );
	addNotetrack_customFunction( "bricktop", "drop rocket", ::notetrack_notify_drop_rocket, "at4_fire" );
	
	level.scr_anim[ "rasta" ][ "at4_fire" ] = %contengency_rocket_moment;
	addNotetrack_customFunction( "rasta", "attach rocket", ::notetrack_notify_attach_rocket, "at4_fire" );
	addNotetrack_customFunction( "rasta", "fire rocket", ::notetrack_notify_fire_rocket, "at4_fire" );
	addNotetrack_customFunction( "rasta", "drop rocket", ::notetrack_notify_drop_rocket, "at4_fire" );
	
	level.scr_anim[ "price" ][ "at4_fire" ] = %contengency_rocket_moment;
	addNotetrack_customFunction( "price", "attach rocket", ::notetrack_notify_attach_rocket, "at4_fire" );
	addNotetrack_customFunction( "price", "fire rocket", ::notetrack_notify_fire_rocket, "at4_fire" );
	addNotetrack_customFunction( "price", "drop rocket", ::notetrack_notify_drop_rocket, "at4_fire" );
	
	//level.scr_anim[ "price" ][ "at4_fire" ] = %launchfacility_a_at4_fire;
	
//	level.scr_anim[ "generic" ][ "shotgun_stand_pullout" ]	= %shotgun_stand_pullout;
//	
//	//addNotetrack_customFunction( <animname>, <notetrack> , <function> , <anime> );
//	addNotetrack_customFunction( "generic", "gun_2_chest", ::notetrack_gun_2_chest, "shotgun_stand_pullout" );
//	addNotetrack_customFunction( "generic", "shotgun_pickup", ::notetrack_shotgun_pickup, "shotgun_stand_pullout" );
	
	
	maps\_hand_signals::initHandSignals();
	
	// cold patrol
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_a" ]	= %patrolwalk_cold_gunup_idle;
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_b" ]	= %patrolwalk_cold_gunup_idle;
	
	level.scr_anim[ "generic" ][ "patrol_cold_huddle" ][0]		= %patrolwalk_cold_huddle_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle" ][1]		= %patrolwalk_cold_huddle_twitch;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle_pause" ]	= %patrolwalk_cold_huddle_stand_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle_stop" ]	= %patrolwalk_cold_huddle_walk2stand;
	level.scr_anim[ "generic" ][ "patrol_cold_huddle_start" ]	= %patrolwalk_cold_huddle_stand2walk;
	
	level.scr_anim[ "generic" ][ "patrol_cold_crossed" ][0]		= %patrolwalk_cold_crossed_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed" ][1]		= %patrolwalk_cold_crossed_twitch;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed_pause" ]	= %patrolwalk_cold_crossed_stand_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed_stop" ]	= %patrolwalk_cold_crossed_walk2stand;
	level.scr_anim[ "generic" ][ "patrol_cold_crossed_start" ]	= %patrolwalk_cold_crossed_stand2walk;
		
	level.scr_anim[ "generic" ][ "sprint" ]	= %sprint1_loop;

	weights = [];
	weights[0] = 8;
	weights[1] = 2;
	
	level.scr_anim[ "generic" ][ "patrol_twitch_weights" ] = get_cumulative_weights( weights );
	
	level.scr_anim[ "generic" ][ "patrol_cold_gunup_search" ] = %patrolwalk_cold_gunup_idle;
	
	level.scr_anim[ "generic" ][ "patrol_cold_gunup" ][0]	= %patrolwalk_cold_gunup_idle;
	level.scr_anim[ "generic" ][ "patrol_cold_gunup" ][1]	= %patrolwalk_cold_gunup_twitchA;
	level.scr_anim[ "generic" ][ "patrol_cold_gunup" ][2]	= %patrolwalk_cold_gunup_twitchB;	
	
	weights = [];
	weights[0] = 4;
	weights[1] = 3;	
	weights[2] = 3;	
	
	level.scr_anim[ "generic" ][ "patrol_gunup_twitch_weights" ] = get_cumulative_weights( weights );
	
	//TRUCKRIDE
	level.scr_anim[ "generic" ][ "truckride_climbin" ]			 = %traverse_stepup_52;

	//JEEPCRASH
//	level.scr_anim[ "generic" ][ "cliff_jeep_crash_price" ]		= %cliff_jeep_crash_price;	
}

price_caution_stop()
{
	//level.price.goalradius = 64;
	
	level endon( "run_to_woods" );
	self anim_reach_solo( level.price, "caution_stop" );
	self anim_single_solo( level.price, "caution_stop" );
	level.price setgoalnode( self );
}


#using_animtree( "vehicles" );
vehicles()
{
	level.scr_anim[ "gauntlet" ][ "radar_spinup" ]		 = %sa15_radar_spinup;
	level.scr_anim[ "gauntlet" ][ "radar_spinloop" ]		 = %sa15_radar_spinloop;
	level.scr_anim[ "gauntlet" ][ "radar_spindown" ]		 = %sa15_radar_spindown;
	level.scr_anim[ "gauntlet" ][ "turret_scanloop" ]		 = %sa15_turret_scanloop;
	
	level.scr_animtree[ "contingency_btr_slide" ]					 = #animtree;
	level.scr_anim[ "contingency_btr_slide" ][ "contingency_btr_slide" ]		 = %contingency_btr_slide;
	level.scr_model[ "contingency_btr_slide" ]					 = "vehicle_btr80_snow";
	addNotetrack_customFunction( "contingency_btr_slide", "btr_fire", ::btr80_notetrack_fire, "contingency_btr_slide" );
	
	//addNotetrack_customFunction( <animname>, <notetrack> , <function> , <anime> );
	//addNotetrack_customFunction( "btr80", "BTRfire", ::btr80_notetrack_fire, "invasion_opening_BTR" );
}


btr80_notetrack_fire( guy )
{
	guy fireWeapon();
	//println( "fire" );
	level notify ( "btr_fired" );
}

//animate_gauntlet1()
//{
//	self.animname = "gauntlet";
//		
//	//anim_loop_solo( guy, anime, ender, tag )
//	self anim_single_solo( self, "radar_spinloop" );
//}
//
//animate_gauntlet2()
//{
//	self.animname = "gauntlet";
//		
//	//anim_loop_solo( guy, anime, ender, tag )
//	self thread anim_single_solo( self, "turret_scanloop" );
//	self anim_single_solo( self, "radar_spinloop" );
//}


price_land_fx ( price )
{
	//iprintlnbold( "land" );
	//playfxontag( getfx( "price_landing" ), price, "J_Ankle_RI");

	tagPos = price gettagorigin( "J_Ankle_RI" );	// rough tag to play fx on
	tagPos = PhysicsTrace( tagPos + ( 0,0,64), tagPos + ( 0,0,-64) );
	playfx( level._effect[ "price_landing" ], tagPos );

}

price_land_settle_fx ( price )
{
	
	//iprintlnbold( "settle " );
	tagPos = price gettagorigin( "J_Ankle_LE" );	// rough tag to play fx on
	tagPos = PhysicsTrace( tagPos + ( 0,0,64), tagPos + ( 0,0,-64) );
	playfx( level._effect[ "price_landing" ], tagPos );
}

price_slide_fx( price )
{
	//iprintlnbold( "slide " );
	self endon( "stop_slide_fx" );
	while ( true )
	{
		playfxontag( getfx( "price_sliding" ), price, "J_Ankle_LE" );
		wait( .1 );
	}
}

price_stop_slide_fx( price )
{
	//iprintlnbold( "stop sliding " );
	self notify( "stop_slide_fx" );	
}


dialog()
{
//replacements:

//Take them out or leave them be. Your call.	cont_pri_yourcall
//Use a suppressed weapon. We'll have to take them out at the same time.	cont_pri_cantslipby
//You take the handler and his dog on the left.	cont_pri_twoonleft
//A Predator drone loaded with Hellfires is enroute to your position.	cont_cmt_almostinpos
//Roach take control of the Predator drone.	cont_pri_controluav
//There's a mobile SAM site in the village. It just shot down our Predator.	cont_pri_mobilesaminvillage
//Soap, we need another Predator with Hellfire missiles!	cont_pri_uavsharpish
//Roger that. The second Predator is almost in position. Make it count, these things don't grow on trees.	cont_cmt_2nduav



//Heads up, two trucks, ten plus guys to our north east!	cont_rst_headsup


	//Firing an unsuppressed weapon is going to alert a lot of enemies, Roach.	
	level.scr_radio[ "cont_pri_alertenemies" ]					 = "cont_pri_alertenemies";


	
	//Looks like they found a body.	
	level.scr_radio[ "cont_pri_foundabody" ]					 = "cont_pri_foundabody";
	//They found a body.	
	level.scr_radio[ "cont_pri_foundabody2" ]					 = "cont_pri_foundabody2";
	

	//Let them pass.	
	level.scr_radio[ "cont_pri_letpass" ]					 = "cont_pri_letpass";
	
	
	//You handle the two on the left.	
	level.scr_radio[ "cont_pri_twoonleft" ]					 = "cont_pri_twoonleft";
	
	//Take them out or try to slip past. Your call.	
	level.scr_radio[ "cont_pri_slippast" ]					 = "cont_pri_slippast";
	
	
	//Nicely done.	
	level.scr_radio[ "cont_pri_nicelydone" ]					 = "cont_pri_nicelydone";
	
	//Well done.	
	level.scr_radio[ "cont_pri_welldone" ]					 = "cont_pri_welldone";
	
	//Good.	
	level.scr_radio[ "cont_pri_good" ]					 = "cont_pri_good";
	
	//Not bad, but I've seen better.	
	level.scr_radio[ "cont_pri_seenbetter" ]					 = "cont_pri_seenbetter";
	
	//Good work.	
	level.scr_radio[ "cont_pri_goodwork" ]					 = "cont_pri_goodwork";
	
	//Impressive.	
	level.scr_radio[ "cont_pri_impressive" ]					 = "cont_pri_impressive";
	
	
	
	
	
	//Two of them have stopped for a smoke. Take one and I'll take out the other.	
	level.scr_radio[ "cont_pri_forasmoke" ]					 = "cont_pri_forasmoke";
	
	//Take out the two in the woods on the other side of the bridge.	
	level.scr_radio[ "cont_pri_twoinwoods" ]					 = "cont_pri_twoinwoods";
	
	//I'm ready. Lets take them all out at once.	
	level.scr_radio[ "cont_pri_imready" ]					 = "cont_pri_imready";
	
	
	
	//Sometimes you can't end a war with a bullet, Soap.	
	level.scr_radio[ "cont_pri_endawar" ]					 = "cont_pri_endawar";
	


	//level.scr_sound[ "price" ][ "cliff_pri_noidea" ]				 = "cliff_pri_noidea";
	//level.scr_radio[ "outrunthem" ] = "cliff_pri_outrunthem";
	
//IN ----
	//Soap, I've found Roach. He appears to be intact.	
	level.scr_sound[ "price" ][ "cont_pri_foundroach" ]				 = "cont_pri_foundroach";
	level.scr_radio[ "cont_pri_foundroach" ]					 = "cont_pri_foundroach";
	//We're going to head northwest to the sub base, over.
	level.scr_sound[ "price" ][ "cont_pri_headnw" ]				 = "cont_pri_headnw";
	level.scr_radio[ "cont_pri_headnw" ]					 = "cont_pri_headnw";
	//Copy that. I've located Rasta and Bricktop, they landed pretty far to the east.	
	level.scr_radio[ "cont_cmt_fareast" ]					 = "cont_cmt_fareast";
	//Tell them to proceed with the mission, we'll regroup if possible. 	
	level.scr_sound[ "price" ][ "cont_pri_proceed" ]				 = "cont_pri_proceed";
	level.scr_radio[ "cont_pri_proceed" ]					 = "cont_pri_proceed";
	//Have you found us some transport?	
	level.scr_sound[ "price" ][ "cont_pri_foundtransport" ]					 = "cont_pri_foundtransport";
	level.scr_radio[ "cont_pri_foundtransport" ]					 = "cont_pri_foundtransport";
	//I'm working on it. Out.	
	level.scr_radio[ "cont_cmt_workingonit" ]					 = "cont_cmt_workingonit";
	
//IN ----
	//Roach, follow me and stay out of sight.	
	level.scr_radio[ "cont_pri_outofsight" ]					 = "cont_pri_outofsight";
	//Contact.  Enemy patrol 30 meters to our front.	
	level.scr_radio[ "cont_pri_30metersfront" ]					 = "cont_pri_30metersfront";
	//Let's follow them quietly, and pick off any stragglers.	
	level.scr_radio[ "cont_pri_pickoffstragglers" ]					 = "cont_pri_pickoffstragglers";
	
//IN ----
	//Convoy coming, get out of sight.	
	level.scr_sound[ "price" ][ "cont_pri_convoycoming" ]				 = "cont_pri_convoycoming";
	level.scr_radio[ "cont_pri_convoycoming" ]				 = "cont_pri_convoycoming";
	//Let them pass.	
	level.scr_sound[ "price" ][ "cont_pri_letthempass" ]				 = "cont_pri_letpass";
	level.scr_radio[ "cont_pri_letthempass" ]				 = "cont_pri_letpass";
	
	
	//Soap, our intel was off. The Russians have mobile SAMs.	
	level.scr_sound[ "price" ][ "cont_pri_intelwasoff" ]				 = "cont_pri_intelwasoff";
	level.scr_radio[ "cont_pri_intelwasoff" ]				 = "cont_pri_intelwasoff";
	//Roger that.	
	level.scr_sound[ "price" ][ "cont_cmt_rogerthat" ] 				= "cont_cmt_rogerthat";
	level.scr_radio[ "cont_cmt_rogerthat" ] 				= "cont_cmt_rogerthat";
	

//IN ----
	//Looks like they saw your parachute. 	
	level.scr_radio[ "cont_pri_yourparachute" ]					 = "cont_pri_yourparachute";
	//Let's keep moving. 	
	level.scr_radio[ "cont_pri_keepmoving" ]					 = "cont_pri_keepmoving";
	
	
	//Helicopters coming! Get down!	
	level.scr_radio[ "cont_pri_getdown" ]					 = "cont_pri_getdown";
	//Hug the walls!	
	level.scr_radio[ "cont_pri_hugthewalls" ]					 = "cont_pri_hugthewalls";
	//That was close. Lets keep moving.	
	level.scr_radio[ "cont_pri_thatwasclose" ]					 = "cont_pri_thatwasclose";
	//We're sitting ducks out here! Get off the bridge! Move!	
	level.scr_radio[ "cont_pri_sittingducks" ]					 = "cont_pri_sittingducks";
	
	
///////////////////////
/////   MISC STEALTH
	
//STEALTH BROKEN!   ----
	//We're spotted! Go loud! Take them out! 	
	level.scr_radio[ "cont_pri_goloud" ]					 = "cont_pri_goloud";
	//They're on to us! Open fire!	
	level.scr_radio[ "cont_pri_ontous" ]					 = "cont_pri_ontous";
	//We're spotted! Take them out!	
	level.scr_radio[ "cont_pri_werespotted" ]					 = "cont_pri_werespotted";

//first stragglers
	//Patience�don't do anything stupid.	-----
	level.scr_radio[ "cont_pri_patience" ]					 = "cont_pri_patience";
	//We'll have to take 'em out at the same time.	-----
	level.scr_radio[ "cont_pri_sametime" ]					 = "cont_pri_sametime";
	//Now's your chance. Take one of 'em out. 	----
	level.scr_radio[ "cont_pri_yourchance" ]					 = "cont_pri_yourchance";
	

//STEALTH TIPS
	//Don't get so close.	
	level.scr_radio[ "cont_pri_dontgetclose" ]					 = "cont_pri_dontgetclose";
	//Wait for me to get into position.	
	level.scr_radio[ "cont_pri_waitposition" ]					 = "cont_pri_waitposition";
	//Wait for me.	
	level.scr_radio[ "cont_pri_waitforme" ]					 = "cont_pri_waitforme";
	//I'm in position - take the shot when you're ready.
	level.scr_radio[ "cont_pri_whenyoureready" ]					 = "cont_pri_whenyoureready";

//STEALTH RECOVERY	-----
	//What the hell was that? You trying to get us killed?	
	level.scr_radio[ "cont_pri_getuskilled" ]					 = "cont_pri_getuskilled";
	//Does the word stealth mean anything to you?	
	level.scr_radio[ "cont_pri_thewordstealth" ]					 = "cont_pri_thewordstealth";
	
	//Don't give away our position, Roach. This is only going to get harder.	
	level.scr_radio[ "cont_pri_giveawayposition" ]					 = "cont_pri_giveawayposition";
	//Roach, we can't afford to keep giving away our position like that. Maintain a low profile!	
	level.scr_radio[ "cont_pri_lowprofile" ]					 = "cont_pri_lowprofile";
	
//MOVE
	//Move up.	
	level.scr_radio[ "cont_pri_moveup" ]					 = "cont_pri_moveup";
	//Move.	
	level.scr_radio[ "cont_pri_move" ]					 = "cont_pri_move";
	
//ALERTED ALONG THE ROAD	----
	//Quick! Hide in the woods! You alerted one of them!	
	level.scr_radio[ "cont_pri_hideinwoods" ]					 = "cont_pri_hideinwoods";
	//Get into the woods! Hide!	
	level.scr_radio[ "cont_pri_getintowoods" ]					 = "cont_pri_getintowoods";
	//They're alerted! Hide in the woods! Move!	
	level.scr_radio[ "cont_pri_theyrealerted" ]					 = "cont_pri_theyrealerted";
	

//STRAGGLERS	
	//Take him out when the others aren't looking.	
	level.scr_radio[ "cont_pri_arentlooking" ]					 = "cont_pri_arentlooking";
	//They're splitting up. Take him down.	
	level.scr_radio[ "cont_pri_splittingup" ]					 = "cont_pri_splittingup";

//GOOD JOB	----
	//Beautiful.	
	level.scr_radio[ "cont_pri_beautiful" ]					 = "cont_pri_beautiful";
	//Good shot.	
	level.scr_radio[ "cont_pri_goodshot" ]					 = "cont_pri_goodshot";

//PRICE KILLS	-----
	//Got one.	
	level.scr_radio[ "cont_pri_gotone" ]					 = "cont_pri_gotone";
	//He's down. 	
	level.scr_radio[ "cont_pri_hesdown2" ]					 = "cont_pri_hesdown2";
	//Tango down.	
	level.scr_radio[ "cont_pri_tangodown" ]					 = "cont_pri_tangodown";
	//Good night.	
	level.scr_radio[ "cont_pri_goodnight" ]					 = "cont_pri_goodnight";
	//Target eliminated.	
	level.scr_radio[ "cont_pri_targeteliminated" ]					 = "cont_pri_targeteliminated";
	//Target down.	
	level.scr_radio[ "cont_pri_targetdown" ]					 = "cont_pri_targetdown";

//ALERTED!
	//He noticed that! Hide!	
	level.scr_radio[ "cont_pri_henoticed" ]					 = "cont_pri_henoticed";
	//Get out of sight! That one's coming over here!	
	level.scr_radio[ "cont_pri_getoutofsight" ]					 = "cont_pri_getoutofsight";
	//Hide! One of them's been alerted!	
	level.scr_radio[ "cont_pri_hidebeenalerted" ]					 = "cont_pri_hidebeenalerted";
	//He's alerted! Hide!	
	level.scr_radio[ "cont_pri_hesalerted" ]					 = "cont_pri_hesalerted";
	
//WOODS PATROL CALLOUTS
	//Dog patrol.	------
	level.scr_radio[ "cont_pri_dogpatrol" ]					 = "cont_pri_dogpatrol";
	//Three man patrol dead ahead.	-----
	level.scr_radio[ "cont_pri_3manpatrol" ]					 = "cont_pri_3manpatrol";
	//Large patrol at 12 o'clock.	-----
	level.scr_radio[ "cont_pri_largepatrol12" ]					 = "cont_pri_largepatrol12";
	//We got another dog patrol.	-----
	level.scr_radio[ "cont_pri_anotherdogpatrol" ]					 = "cont_pri_anotherdogpatrol";
	//Another patrol up ahead.	
	level.scr_radio[ "cont_pri_anotherpatrol" ]					 = "cont_pri_anotherpatrol";
	
//YOUR DECISION
	//Take them out or leave them be. It's your call.	------
	level.scr_radio[ "cont_pri_yourcall" ]					 = "cont_pri_yourcall";
	//We can't slip by them. Get ready to take them out quickly.	------
	level.scr_radio[ "cont_pri_cantslipby" ]					 = "cont_pri_cantslipby";
	//Take them out or go around.	
	level.scr_radio[ "cont_pri_outoraround" ]					 = "cont_pri_outoraround";




//BTR80 moment
//Incoming! Look out! 	
	level.scr_sound[ "price" ][ "cont_pri_incoming" ]				 = "cont_pri_incoming";
	level.scr_radio[ "cont_pri_incoming" ]				 = "cont_pri_incoming";
//Get down!
	level.scr_radio[ "cont_pri_getdown2" ]				 = "cont_pri_getdown2";	

	//INTO THE WOODS! LETS GO! LETS GO!	
	level.scr_sound[ "price" ][ "cont_pri_intothewoods" ]				 = "cont_pri_intothewoods";
	level.scr_radio[ "cont_pri_intothewoods" ]				 = "cont_pri_intothewoods";
	
	//FOLLOW ME!	
	level.scr_sound[ "price" ][ "cont_pri_followme" ]				 = "cont_pri_followme";
	level.scr_radio[ "cont_pri_followme" ]				 = "cont_pri_followme";
	

//now in woods
	//Slow down. They cant follow us this far.	
	level.scr_sound[ "price" ][ "cont_pri_slowdown" ]				 = "cont_pri_slowdown";
	level.scr_radio[ "cont_pri_slowdown" ]				 = "cont_pri_slowdown";
	
	
	//Dogs. I hate dogs. You go first.	
	level.scr_radio[ "cont_pri_hatedogs" ]				 = "cont_pri_hatedogs";
	//Got'm.	
	level.scr_radio[ "cont_pri_gotm" ]				 = "cont_pri_gotm";
	//Hes down.	
	level.scr_radio[ "cont_pri_hesdown" ]				 = "cont_pri_hesdown";
	//Down boy.	
	level.scr_radio[ "cont_pri_downboy" ]				 = "cont_pri_downboy";
	//Nap time.	
	level.scr_radio[ "cont_pri_naptime" ]				 = "cont_pri_naptime";
	
	
	
	//Soap, what's the status of our air support?	
	level.scr_sound[ "price" ][ "cont_pri_airsupport" ]				 = "cont_pri_airsupport";
	level.scr_radio[ "cont_pri_airsupport" ]				 = "cont_pri_airsupport";
	//The UAV is almost in position.	
	level.scr_radio[ "cont_cmt_almostinpos" ] = "cont_cmt_almostinpos";
	//Roger that. 	
	level.scr_sound[ "price" ][ "cont_pri_rogerthat" ]				 = "cont_pri_rogerthat";
	level.scr_radio[ "cont_pri_rogerthat" ]				 = "cont_pri_rogerthat";
	//This ridge is perfect.	
	level.scr_sound[ "price" ][ "cont_pri_ridgeisperfect" ]				 = "cont_pri_ridgeisperfect";
	level.scr_radio[ "cont_pri_ridgeisperfect" ]				 = "cont_pri_ridgeisperfect";
	//Roach take control of the UAV.	
	level.scr_sound[ "price" ][ "cont_pri_controluav" ]				 = "cont_pri_controluav";
	level.scr_radio[ "cont_pri_controluav" ]				 = "cont_pri_controluav";
	//Bollocks!	
	level.scr_sound[ "price" ][ "cont_pri_bollocks" ]				 = "cont_pri_bollocks";
	level.scr_radio[ "cont_pri_bollocks" ]				 = "cont_pri_bollocks";
	
	
	
	//What just happened?	
	level.scr_radio[ "cont_cmt_whathappened" ] = "cont_cmt_whathappened";
	//There's a mobile SAM site in the village. It just took out our UAV.	
	level.scr_sound[ "price" ][ "cont_pri_mobilesaminvillage" ]				 = "cont_pri_mobilesaminvillage";
	level.scr_radio[ "cont_pri_mobilesaminvillage" ]				 = "cont_pri_mobilesaminvillage";
	//Soap, we need another UAV, sharpish!	
	level.scr_sound[ "price" ][ "cont_pri_uavsharpish" ]				 = "cont_pri_uavsharpish";
	level.scr_radio[ "cont_pri_uavsharpish" ]				 = "cont_pri_uavsharpish";
	//Roach - let's go.	
	level.scr_sound[ "price" ][ "cont_pri_roachletsgo" ]				 = "cont_pri_roachletsgo";
	level.scr_radio[ "cont_pri_roachletsgo" ]				 = "cont_pri_roachletsgo";
	
	
//////////////////////  STOP RADIO????
	
	
	//Stand back!	
	level.scr_sound[ "rasta" ][ "cont_rst_standback" ]				 = "cont_rst_standback";
	//Get back!	
	level.scr_sound[ "rasta" ][ "cont_rst_getback" ]				 = "cont_rst_getback";
	
	//Check your fire! Check your fire! Friendlies coming in at your 12!	
	level.scr_sound[ "rasta" ][ "cont_rst_checkfire" ]				 = "cont_rst_checkfire";

	//Nice work on that SAM site.	
	level.scr_sound[ "price" ][ "cont_pri_nicework" ]				 = "cont_pri_nicework";
	//Thanks, but we better get moving - those explosions are gonna attract a lot of attention.	
	level.scr_sound[ "rasta" ][ "cont_rst_getmoving" ]				 = "cont_rst_getmoving";
	//Roach, they know we're here. You might want to grab a different weapon.	
	level.scr_sound[ "price" ][ "cont_pri_grabweapon" ]				 = "cont_pri_grabweapon";
	
	
	//Soap - Rasta and Bricktop are here. 	
	level.scr_sound[ "price" ][ "cont_pri_rastaandbricktop" ]				 = "cont_pri_rastaandbricktop";
	//Roger that. The second UAV is almost in position.	
	level.scr_radio[ "cont_cmt_2nduav" ] = "cont_cmt_2nduav";


//race through base

	//There's the submarine! Right below that crane!	
	level.scr_sound[ "price" ][ "cont_pri_belowcrane" ]				 = "cont_pri_belowcrane";
	//Roach, soften up their defenses with the Hellfires!	
	level.scr_sound[ "price" ][ "cont_pri_softendefenses" ]				 = "cont_pri_softendefenses";

	//That got their attention!	
	level.scr_radio[ "cont_cmt_gotattention" ] = "cont_cmt_gotattention";
	//The whole base has gone on alert!	
	level.scr_radio[ "cont_cmt_baseonalert" ] = "cont_cmt_baseonalert";
	//You'd better hurry. You've only got a couple of minutes before that submarine dives.	
	level.scr_radio[ "cont_cmt_betterhurry" ] = "cont_cmt_betterhurry";
	//We're moving!	
	level.scr_sound[ "price" ][ "cont_pri_weremoving" ]				 = "cont_pri_weremoving";

	//You're halfway there!	
	level.scr_radio[ "cont_cmt_halwaythere" ] = "cont_cmt_halwaythere";
	//90 seconds!	
	level.scr_radio[ "cont_cmt_90secs" ] = "cont_cmt_90secs";
	//60 seconds!	
	level.scr_radio[ "cont_cmt_60secs" ] = "cont_cmt_60secs";
	//30 seconds! Move!	
	level.scr_radio[ "cont_cmt_30secs" ] = "cont_cmt_30secs";


	//We've got to hurry! That sub isn't going to wait for us!	
	level.scr_sound[ "price" ][ "cont_pri_subwontwait" ]				 = "cont_pri_subwontwait";
	//Go go go! 	
	level.scr_sound[ "price" ][ "cont_pri_gogogo" ]				 = "cont_pri_gogogo";
	//Get to the sub! Hurry!	
	level.scr_sound[ "price" ][ "cont_pri_gettosub" ]				 = "cont_pri_gettosub";
	
	
	//Soap, we've reached the sub!	
	level.scr_sound[ "price" ][ "cont_pri_reachedsub" ]				 = "cont_pri_reachedsub";
	//Roger that!	
	level.scr_radio[ "cont_cmt_rogerthat2" ] = "cont_cmt_rogerthat2";
	
	
	
//enter sub	
	//Roach! Get your mask on!	
	level.scr_sound[ "price" ][ "cont_pri_getmaskon" ]				 = "cont_pri_getmaskon";
	//Down the hatch, lets go!	
	level.scr_sound[ "price" ][ "cont_pri_downthehatch" ]				 = "cont_pri_downthehatch";
	//Roach! I need a few minutes! Cover me!	
	level.scr_sound[ "price" ][ "cont_pri_needfewminutes" ]				 = "cont_pri_needfewminutes";
	
	//Alert! The use of nuclear weapons has been authorized.	
	
	//Price! I'm on my way to the east gate with our transport, over!	
	level.scr_radio[ "cont_cmt_eastgate" ] = "cont_cmt_eastgate";
	//Copy that Soap! 	
	level.scr_sound[ "price" ][ "cont_pri_copythatsoap" ]				 = "cont_pri_copythatsoap";
	
	//Launch codes verified authentic. Launch codes accepted. 	
	//Set condition one-SQ. Nuclear missile launch authorized.	
	//Now spinning up missiles 1 through 4 and 8 through 12 for strategic missile launch�	
	//Target package 572 has been authorized. Standing by for target confirmation and launch order.	
	
	//Roach! I'm almost done! Hold your ground!!	
	level.scr_sound[ "price" ][ "cont_pri_almostdone" ]				 = "cont_pri_almostdone";
	//Price! How much longer do you need to sink the sub? We're almost at the gate!	
	level.scr_radio[ "cont_cmt_muchlonger" ] = "cont_cmt_muchlonger";
	//Soap, I'm not sinking the sub - I'm launching the nukes.	
	level.scr_sound[ "price" ][ "cont_pri_notsinking" ]				 = "cont_pri_notsinking";
	//The bloody hell you are!!!!	
	level.scr_radio[ "cont_cmt_bloodyhell" ] = "cont_cmt_bloodyhell";
	//There's no time to explain! Roach! Turn that key over there! Hurry! They've scrambled MiGs to take us out!	
	level.scr_sound[ "price" ][ "cont_pri_notime" ]				 = "cont_pri_notime";
	//Roach! We're running out of time! Turn the key!!!	
	level.scr_sound[ "price" ][ "cont_pri_runningout" ]				 = "cont_pri_runningout";
	//Roach! Trust me! Turn - your - key!!!	
	level.scr_sound[ "price" ][ "cont_pri_trustme" ]				 = "cont_pri_trustme";
	
	//Missiles are ready for launch. Ten�Nine�Eight�Seven�Six...Five�Four�Three�Two�One�ignition on missiles 1 through 4 and 8 through 12 for strategic missile launch.	
	
	//We're done here! Let's go!	
	level.scr_sound[ "price" ][ "cont_pri_donehereletsgo" ]				 = "cont_pri_donehereletsgo";
	//Roach! Get to the truck! Move! Move!!	
	level.scr_sound[ "price" ][ "cont_pri_gettotruck" ]				 = "cont_pri_gettotruck";
	
	//Bloody 'ell Price...God help us all if you're wrong�	
	
	//Sometimes you can't end a war with a bullet, Soap.	
	level.scr_sound[ "price" ][ "cont_pri_endawar" ]				 = "cont_pri_endawar";



////////////////////////////////


	//Use a Hellfire on that truck!	
	level.scr_sound[ "price" ][ "cont_pri_usehellfire" ]				 = "cont_pri_usehellfire";
	//Take out that helicopter!	
	level.scr_sound[ "price" ][ "cont_pri_takeoutheli" ]				 = "cont_pri_takeoutheli";
	

	//Five men, automatic rifles, frag grenades. One German Shepherd.	
	level.scr_radio[ "cont_pri_fivemen" ]					 = "cont_pri_fivemen";
	
	//Dogs... I hate dogs.		
	level.scr_radio[ "cont_cmt_hatedogs" ]					 = "cont_cmt_hatedogs";
	
	//Take the two on the right.	
	level.scr_radio[ "cont_pri_twoonright" ]					 = "cont_pri_twoonright";

	
	
	//Looks like they're searching for us.	
	level.scr_radio[ "cont_pri_searchingforus" ]					 = "cont_pri_searchingforus";
	
	//Destroy that armored vehicle!	
	level.scr_sound[ "price" ][ "cont_pri_armoredvehicle" ]				 = "cont_pri_armoredvehicle";	
	

//split up
	//I'm going for the sub!	
	level.scr_sound[ "price" ][ "cont_pri_goingforsub" ]				 = "cont_pri_goingforsub";	
	//Cover me from that guardhouse by the west gate!	
	level.scr_sound[ "price" ][ "cont_pri_coverme" ]				 = "cont_pri_coverme";
	//Roger that!	
	level.scr_sound[ "rasta" ][ "cont_gst_rogerthat" ]				 = "cont_gst_rogerthat";
	//Roach, we have to get to that guardhouse by the west gate to cover Price! Follow me!	
	level.scr_sound[ "rasta" ][ "cont_gst_guardhouse" ]				 = "cont_gst_guardhouse";
	
	//All right, I'm inside the sub! Cover me, I need a few minutes!	
	level.scr_radio[ "cont_pri_insidesub" ]					 = "cont_pri_insidesub";
	
	
	
//defend
	//Incoming! Two trucks to the east!	
	level.scr_sound[ "rasta" ][ "cont_gst_twotruckseast" ]				 = "cont_gst_twotruckseast";
	
	//More vehicles to the east! Use the Hellfires!	
	level.scr_sound[ "rasta" ][ "cont_gst_morevehicleseast" ]				 = "cont_gst_morevehicleseast";
	
	//Contact to the south, on the dock next to the sub!	
	level.scr_sound[ "rasta" ][ "cont_gst_nexttosub" ]				 = "cont_gst_nexttosub";
	
	//Price, are you there? The silo doors are opening on the sub, I repeat, the silo doors are opening on the sub!	
	level.scr_sound[ "rasta" ][ "cont_gst_youthere" ]				 = "cont_gst_youthere";
	
	//Price, come in!! They're opening the silo doors on the sub!!! Hurry!!!	
	level.scr_sound[ "rasta" ][ "cont_gst_comein" ]				 = "cont_gst_comein";
	
	//Price, do you copy??? The silo doors are open, I repeat, the silo doors are open!!	
	level.scr_sound[ "rasta" ][ "cont_gst_doyoucopy" ]				 = "cont_gst_doyoucopy";
	
	
	
	//Good.	
	level.scr_radio[ "cont_pri_good2" ]					 = "cont_pri_good2";
	
	//What�? Wait...wait, Price - no!!!	
	level.scr_sound[ "rasta" ][ "cont_gst_whatwait" ]				 = "cont_gst_whatwait";
	
	//We have a nuclear missile launch, missile in the air missile in the air!! Code black code black!!	
	level.scr_sound[ "rasta" ][ "cont_gst_codeblack" ]				 = "cont_gst_codeblack";
	
	//Price what have you done???	
	level.scr_sound[ "rasta" ][ "cont_gst_whathaveyoudone" ]				 = "cont_gst_whathaveyoudone";
	




	//Launch codes verified authentic. Launch codes accepted. 	
	//cont_rsc_launchcodes
	//Alert! The use of nuclear weapons has been authorized.	
	//cont_rsc_alert
	//Set condition one-SQ. Nuclear missile launch authorized.	
	//cont_rsc_setcondition
	//Now spinning up missiles 1 through 4 and 8 through 12 for strategic missile launch�	
	//cont_rsc_spinningup
	//Target package 572 has been authorized. Standing by for target confirmation and launch order.	
	//cont_rsc_launchorder


	//Missiles are ready for launch. Ten�Nine�Eight�Seven�Six...Five�Four�Three�Two�One�ignition on missiles 1 through 4 and 8 through 12 for strategic missile launch.	
	//cont_rsc_missilesready


	//These Russian dogs are like pussycats compared to the ones in Pripyat.	
	level.scr_radio[ "cont_pri_russiandogs" ]					 = "cont_pri_russiandogs";
	//Its good to have you back, old man.	
	level.scr_radio[ "cont_cmt_haveyouback" ]					 = "cont_cmt_haveyouback";
	//Roger that. 	
	level.scr_radio[ "cont_pri_rogerthat2" ]					 = "cont_pri_rogerthat2";



	//Direct hit on the enemy helo. Nice shot Roach.	
	level.scr_radio[ "cont_cmt_directhitshelo" ]					 = "cont_cmt_directhitshelo";
	//Good effect on target. BTR destroyed.	
	level.scr_radio[ "cont_cmt_btrdestroyed" ]					 = "cont_cmt_btrdestroyed";
	//Direct hit on that jeep.	
	level.scr_radio[ "cont_cmt_directhitjeep" ]					 = "cont_cmt_directhitjeep";
	//Good kill. Truck destroyed.	
	level.scr_radio[ "cont_cmt_goodkilltruck" ]					 = "cont_cmt_goodkilltruck";
	
	//Good hit. Multiple vehicles destroyed.	
	level.scr_radio[ "cont_cmt_goodhitvehicles" ]					 = "cont_cmt_goodhitvehicles";
	//Good effect on target. Multiple enemy vehicles KIA.	
	level.scr_radio[ "cont_cmt_goodeffectkia" ]					 = "cont_cmt_goodeffectkia";
	
	
	//Five plus KIAs. Good hit. Good hit.	
	level.scr_radio[ "cont_cmt_fivepluskias" ]					 = "cont_cmt_fivepluskias";
	//Multiple confirmed kills. Nice work.	
	level.scr_radio[ "cont_cmt_mutlipleconfirmed" ]					 = "cont_cmt_mutlipleconfirmed";
	//Good hit. Looks like at least three kills.	
	level.scr_radio[ "cont_cmt_3kills" ]					 = "cont_cmt_3kills";
	//They're down.	
	level.scr_radio[ "cont_cmt_theyredown" ]					 = "cont_cmt_theyredown";
	//Direct hit.	
	level.scr_radio[ "cont_cmt_directhit" ]					 = "cont_cmt_directhit";
	//He's down.	
	level.scr_radio[ "cont_cmt_hesdown" ]					 = "cont_cmt_hesdown";

	// Sets up the dialog for remotemissile online/offline only
	level.uav_radio_initialized = true;
	level.scr_radio[ "uav_reloading" ] 				= "cont_cmt_rearmhellfires";
	level.scr_radio[ "uav_offline" ] 				= "cont_cmt_hellfiresoffline";
	level.scr_radio[ "uav_online" ] 				= "cont_cmt_hellfireonline";
	level.scr_radio[ "uav_online_repeat" ] 			= "cont_cmt_repeatonline";
	level.scr_radio[ "uav_down" ] 					= "cont_cmt_predatordown";
	
	
	//Rearming Hellfires. Standby.
	//level.scr_radio[ "cont_cmt_rearmhellfires" ]					 = "cont_cmt_rearmhellfires";
	//Arming AGMs. Standby.
	//cont_cmt_armagm
	//Arming Hellfires. Standby.
	//cont_cmt_armhellfire
 
	//Price, I can barely see Roach's chute on my satellite feed.  Too much interference. Do you see him, over?
	level.scr_radio[ "cont_cmt_barelysee" ]					 = "cont_cmt_barelysee";
	
	//Watch for the blinking strobes. That�s us.	
	level.scr_sound[ "price" ][ "cont_pri_strobes" ]				 = "cont_pri_strobes";
	

}