#include maps\_anim;
#include common_scripts\utility;

#using_animtree( "generic_human" );
main()
{
	ride_vehicle_anims();
	ride_player_anims();
	angel_flare_rig_anims();
	dialogue();

	level.scr_anim[ "generic" ][ "prone_2_stand" ]			= %prone_2_stand;
	level.scr_anim[ "rook" ][ "boneyard_driver_death" ]		= %boneyard_driver_death;
}

dialogue()
{
//	level.scr_sound[ "animname" ][ "yyy" ]			 = "yyy";
//	level.scr_radio[ "yyy" ] = "yyy";

	// Price
	level.scr_radio[ "byard_pri_wipeoutus" ]				 = "byard_pri_wipeoutus";
	level.scr_radio[ "byard_pri_backupplan" ]				 = "byard_pri_backupplan";
	level.scr_radio[ "byard_pri_lzishot" ]					 = "byard_pri_lzishot";
	level.scr_radio[ "byard_pri_sharpish" ]					 = "byard_pri_sharpish";
	level.scr_radio[ "byard_pri_gettransport" ]				 = "byard_pri_gettransport";
	level.scr_radio[ "byard_pri_headnorth" ]				 = "byard_pri_headnorth";
	level.scr_radio[ "byard_pri_radiotraffic" ]				 = "byard_pri_radiotraffic";
	level.scr_radio[ "byard_pri_contactmakarov" ]			 = "byard_pri_contactmakarov";
	level.scr_radio[ "byard_pri_warhero" ]					 = "byard_pri_warhero";
	level.scr_radio[ "byard_pri_takecareofrest" ]			 = "byard_pri_takecareofrest";
	level.scr_radio[ "byard_pri_onthischannel" ]			 = "byard_pri_onthischannel";
	level.scr_radio[ "byard_pri_lastaweek" ]				 = "byard_pri_lastaweek";
	level.scr_radio[ "byard_pri_myfriend" ]					 = "byard_pri_myfriend";
	level.scr_radio[ "byard_pri_myregards" ]				 = "byard_pri_myregards";
	level.scr_radio[ "byard_pri_whereareyou" ]				 = "byard_pri_whereareyou";
	level.scr_radio[ "byard_pri_landtheplane" ]				 = "byard_pri_landtheplane";
	level.scr_radio[ "byard_pri_gettoplane" ]				 = "byard_pri_gettoplane";
	level.scr_radio[ "byard_pri_muchtime" ] 				 = "byard_pri_muchtime";
	level.scr_radio[ "byard_pri_foudntransport" ]			 = "byard_pri_foudntransport";

	level.scr_sound[ "price" ][ "byard_pri_getinjeep" ]		 = "byard_pri_getinjeep";
	level.scr_sound[ "price" ][ "byard_pri_contact12" ]		 = "byard_pri_contact12";
	level.scr_sound[ "price" ][ "byard_pri_contactahead" ]	 = "byard_pri_contactahead";
	level.scr_sound[ "price" ][ "byard_pri_behindus" ]		 = "byard_pri_behindus";
	level.scr_sound[ "price" ][ "byard_pri_onour6" ]		 = "byard_pri_onour6";
	level.scr_sound[ "price" ][ "byard_pri_totheright" ]	 = "byard_pri_totheright";
	level.scr_sound[ "price" ][ "byard_pri_rightside" ]		 = "byard_pri_rightside";
	level.scr_sound[ "price" ][ "byard_pri_totheleft" ]		 = "byard_pri_totheleft";
	level.scr_sound[ "price" ][ "byard_pri_ontheleft" ]		 = "byard_pri_ontheleft";
	level.scr_sound[ "price" ][ "byard_pri_vehiclesat12" ]	 = "byard_pri_vehiclesat12";
	level.scr_sound[ "price" ][ "byard_pri_vehicleson6" ]	 = "byard_pri_vehicleson6";
	level.scr_sound[ "price" ][ "byard_pri_thedrivers" ]	 = "byard_pri_thedrivers";
	level.scr_sound[ "price" ][ "byard_pri_hangon" ]		 = "byard_pri_hangon";
	level.scr_sound[ "price" ][ "byard_pri_holdon" ]		 = "byard_pri_holdon";
	level.scr_sound[ "price" ][ "byard_pri_takewheel" ]		 = "byard_pri_takewheel";

	level.scr_sound[ "price" ][ "byard_pri_droptheramp" ]	 = "byard_pri_droptheramp";
	level.scr_face[ "price" ][ "byard_pri_droptheramp" ]	 = %byard_pri_droptheramp;

	level.scr_sound[ "price" ][ "byard_pri_aimforramp" ]	 = "byard_pri_aimforramp";
	level.scr_sound[ "price" ][ "byard_pri_weareleaving" ]	 = "byard_pri_weareleaving";

	// Makarov
	level.scr_radio[ "byard_mkv_neitherwillyou" ]			 = "byard_mkv_neitherwillyou";
	level.scr_radio[ "byard_mkv_cutsbothways" ]				 = "byard_mkv_cutsbothways";
	level.scr_radio[ "byard_mkv_hotelbravo" ]				 = "byard_mkv_hotelbravo";

	// Nikolai
	level.scr_radio[ "byard_nkl_ontheway" ]					 = "byard_nkl_ontheway";
	level.scr_radio[ "byard_nkl_sandstorms" ]				 = "byard_nkl_sandstorms";
	level.scr_radio[ "byard_nkl_unsafetoland" ]				 = "byard_nkl_unsafetoland";
	level.scr_radio[ "byard_nkl_paidenough" ]				 = "byard_nkl_paidenough";
	level.scr_radio[ "byard_nkl_oneminute" ]				 = "byard_nkl_oneminute";
}

truck_overrides()
{
	positions = maps\_truck::setanims();

	positions[ 1 ].sittag = "tag_guy3";
	positions[ 3 ].sittag = "tag_guy2";

	positions[ 4 ].sittag = "tag_passenger";
	positions[ 4 ].idle = %technical_passenger_idle;
	positions[ 4 ].getout = %pickup_passenger_climb_out;

	return positions;
}

suburban_minigun_overrides()
{
	positions = maps\_suburban_minigun::setanims();
	positions = suburban_shared_overrides( positions );
	return positions;
}

suburban_overrides()
{
	positions = maps\_suburban::setanims();
	positions = suburban_shared_overrides( positions );

	positions[ 1 ].death = %uaz_rear_driver_death;
	positions[ 2 ].death = %uaz_rear_driver_death;
	positions[ 3 ].death = %uaz_rear_driver_death;

	return positions;
}

suburban_shared_overrides( positions )
{
	/*
	UAZ_Lguy_fire_side_v1
	UAZ_Lguy_fire_side_v2
	UAZ_Lguy_idle_hide

	UAZ_Rguy_scan_side_v1
	UAZ_Rguy_idle
	*/

	positions[ 1 ].hide_attack_left[ 0 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 1 ].hide_attack_left[ 1 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 1 ].hide_attack_left_occurrence[ 0 ] = 500;
	positions[ 1 ].hide_attack_left_occurrence[ 1 ] = 500;

	positions[ 2 ].hide_attack_left[ 0 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 2 ].hide_attack_left[ 1 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 2 ].hide_attack_left_occurrence[ 0 ] = 500;
	positions[ 2 ].hide_attack_left_occurrence[ 1 ] = 500;

	positions[ 3 ].hide_attack_left[ 0 ] = %UAZ_Lguy_fire_side_v1;
	positions[ 3 ].hide_attack_left[ 1 ] = %UAZ_Lguy_fire_side_v2;
	positions[ 3 ].hide_attack_left_occurrence[ 0 ] = 500;
	positions[ 3 ].hide_attack_left_occurrence[ 1 ] = 500;

	return positions;
}

uaz_overrides()
{
	positions = 	maps\_uaz::setanims();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";
	positions[ 2 ].sittag = "tag_guy0";// RR
	positions[ 3 ].sittag = "tag_guy1";// RR
	positions[ 4 ].sittag = "tag_guy2";// RR
	positions[ 5 ].sittag = "tag_guy3";// RR

	positions[ 0 ].idle = %UAZ_driver_idle;
//	positions[ 1 ].idle = %UAZ_Rguy_idle;

	positions[ 0 ].getout = %uaz_driver_exit_into_stand;
	positions[ 2 ].getout = %uaz_driver_exit_into_run;
//	positions[ 3 ].getout = %uaz_passenger_exit_into_run;

	positions[ 0 ].getin = %uaz_driver_enter_from_huntedrun;

	positions[ 2 ].idle = [];
	positions[ 2 ].idle[ 0 ] = %UAZ_Lguy_idle_hide;
	positions[ 2 ].idle[ 1 ] = %UAZ_Lguy_idle_react;
	positions[ 2 ].idleoccurrence[ 0 ] = 1000;
	positions[ 2 ].idleoccurrence[ 1 ] = 100;

//	positions[ 3 ].idle = %UAZ_Rguy_idle;
//	positions[ 4 ].idle = undefined;
//	positions[ 5 ].idle = undefined;

	positions[ 2 ].hidetoback = %UAZ_Lguy_trans_hide2back;
	positions[ 2 ].back_attack = %UAZ_Lguy_fire_back;
	positions[ 2 ].backtohide = %UAZ_Lguy_trans_back2hide;

	positions[ 2 ].hide_attack_forward = %UAZ_Lguy_fire_hide_forward;

	positions[ 2 ].hide_attack_left[ 0 ] = %UAZ_Lguy_fire_side_v1;
	positions[ 2 ].hide_attack_left[ 1 ] = %UAZ_Lguy_fire_side_v2;
	positions[ 2 ].hide_attack_left_occurrence[ 0 ] = 500;
	positions[ 2 ].hide_attack_left_occurrence[ 1 ] = 500;

	positions[ 2 ].hide_attack_left_standing[ 0 ] = %UAZ_Lguy_standfire_side_v3;
	positions[ 2 ].hide_attack_left_standing[ 1 ] = %UAZ_Lguy_standfire_side_v4;
	positions[ 2 ].hide_attack_left_standing_occurrence[ 0 ] = 100;
	positions[ 2 ].hide_attack_left_standing_occurrence[ 1 ] = 100;

	positions[ 2 ].hide_attack_back[ 0 ] = %UAZ_Lguy_fire_hide_back_v1;
	positions[ 2 ].hide_attack_back[ 1 ] = %UAZ_Lguy_fire_hide_back_v2;
	positions[ 2 ].hide_attack_back_occurrence[ 0 ] = 500;
	positions[ 2 ].hide_attack_back_occurrence[ 1 ] = 500;
	positions[ 2 ].react = %UAZ_Lguy_idle_react;

//	positions[ 1 ].hide_attack_back[ 0 ] = %UAZ_Rguy_fire_back_v2;
//	positions[ 1 ].hide_attack_back[ 1 ] = %UAZ_Rguy_fire_back_v1;
//	positions[ 1 ].hide_attack_back_occurrence[ 0 ] = 500;
//	positions[ 1 ].hide_attack_back_occurrence[ 1 ] = 500;

//	positions[ 1 ].hide_attack_left[ 0 ] = %UAZ_Lguy_fire_side_v1;
//	positions[ 1 ].hide_attack_left[ 1 ] = %UAZ_Lguy_fire_side_v2;
//	positions[ 1 ].hide_attack_left_occurrence[ 0 ] = 500;
//	positions[ 1 ].hide_attack_left_occurrence[ 1 ] = 500;

	positions[ 0 ].duck_once = %UAZ_driver_duck;
	positions[ 0 ].turn_right = %UAZ_driver_turnright;
	positions[ 0 ].turn_left = %UAZ_driver_turnleft;
	positions[ 0 ].weave = %UAZ_driver_weave;

	return positions;
}

#using_animtree( "vehicles" );
uaz_override_vehicle( positions )
{
		positions = maps\_uaz::set_vehicle_anims( positions );

		positions[ 0 ].vehicle_idle = %UAZ_steeringwheel_idle;
		positions[ 0 ].vehicle_duck_once = %UAZ_steeringwheel_duck;
		positions[ 0 ].vehicle_turn_left = %UAZ_steeringwheel_turnleft;
		positions[ 0 ].vehicle_turn_right = %UAZ_steeringwheel_turnright;
		positions[ 0 ].vehicle_weave = %UAZ_steeringwheel_weave;
		positions[ 2 ].vehicle_getoutanim = %uaz_rear_driver_exit_into_run_door;
		positions[ 3 ].vehicle_getoutanim = %uaz_passenger2_exit_into_run_door;

		return positions;
}

truck_vehicle_overrides( positions )
{

	positions[ 0 ].vehicle_getoutanim = %door_pickup_driver_climb_out;
	positions[ 1 ].vehicle_getoutanim = %door_pickup_passenger_climb_out;
	positions[ 2 ].vehicle_getoutanim = %door_pickup_passenger_RR_climb_out;
	positions[ 3 ].vehicle_getoutanim = %door_pickup_passenger_RL_climb_out;
	positions[ 4 ].vehicle_getoutanim = %door_pickup_passenger_climb_out;

	positions[ 0 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	positions[ 4 ].vehicle_getoutanim_clear = false;

	positions[ 0 ].vehicle_getinanim = %door_pickup_driver_climb_in;
	positions[ 1 ].vehicle_getinanim = %door_pickup_passenger_climb_in;
	//positions[ 2 ].vehicle_getinanim = %door_pickup_driver_climb_in;
	//positions[ 3 ].vehicle_getinanim = %door_pickup_passenger_climb_in;
		return positions;

}

ride_vehicle_anims()
{
	level.scr_anim[ "c130_propeller" ][ "rotate" ][0]	= %rotate_X_R;
	level.scr_animtree[ "c130_propeller" ] 				= #animtree;

	level.scr_anim[ "generic" ][ "boneyard_jeep_evac" ]	= %boneyard_jeep_evac;
	level.scr_anim[ "generic" ][ "boneyard_UAZ_door" ]	= %boneyard_UAZ_door;

	level.scr_anim[ "generic" ][ "steer_straight" ]		= %boneyard_UAZ_steer_straight;
	level.scr_anim[ "generic" ][ "steer_left" ]			= %boneyard_UAZ_steer_left;
	level.scr_anim[ "generic" ][ "steer_right" ]		= %boneyard_UAZ_steer_right;

	level.scr_anim[ "generic" ][ "old_steering" ]		= %UAZ_steeringwheel_idle;
}

#using_animtree( "player" );
ride_player_anims()
{
	level.scr_animtree[ "player_rig" ] 							= #animtree;
	level.scr_model[ "player_rig" ] 							= "ch_viewhands_player_gk_m4_sopmod_ii";
	level.scr_anim[ "player_rig" ][ "boneyard_uaz_sit" ]		= %boneyard_player_UAZ_sit;
	level.scr_anim[ "player_rig" ][ "boneyard_uaz_stand" ]		= %boneyard_player_UAZ_stand;
	level.scr_anim[ "player_rig" ][ "boneyard_uaz_mount" ]		= %boneyard_player_enter_UAZ;
	level.scr_anim[ "player_rig" ][ "boneyard_player_evac" ]	= %boneyard_player_evac;
	level.scr_anim[ "player_rig" ][ "grab_wheel" ]				= %boneyard_player_grab_wheel;
	level.scr_anim[ "player_rig" ][ "steer_straight" ]			= %boneyard_player_steer_straight;
	level.scr_anim[ "player_rig" ][ "steer_left" ]				= %boneyard_player_steer_left;
	level.scr_anim[ "player_rig" ][ "steer_right" ]				= %boneyard_player_steer_right;
}

#using_animtree( "script_model" );
angel_flare_rig_anims()
{
	level.scr_animtree[ "angel_flare_rig" ] 						= #animtree;
	level.scr_model[ "angel_flare_rig" ] 							= "angel_flare_rig";

	level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][0]	= %ac130_angel_flares01;
	level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][1]	= %ac130_angel_flares02;
	level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][2]	= %ac130_angel_flares03;

}