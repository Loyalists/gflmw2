#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#using_animtree( "generic_human" );
main()
{
	bridge_layer();
	roadkill_dialogue();
	roadkill_player_anims();
	script_model_animations();

	maps\_minigun_viewmodel::anim_minigun_hands();

	level.scr_anim[ "shepherd" ][ "player_shep_intro" ] = %roadkill_intro_pickup_shepherd;
	addNotetrack_dialogue( "shepherd", "dialog", "player_shep_intro", "roadkill_shp_ontheline" );

	level.scr_anim[ "hargrove" ][ "roadkill_intro_orders" ] = %roadkill_orders_officer;
	level.scr_anim[ "foley" ][ "roadkill_intro_orders" ] = %roadkill_orders_soldier;

	level.scr_anim[ "hargrove" ][ "walk" ] = %civilian_walk_hurried_1;
	level.scr_anim[ "foley" ][ "walk" ] = %civilian_walk_hurried_1;
	addNotetrack_flag( "foley", "slam", "slam_hood" );
//	addNotetrack_customFunction( "foley", "bang", ::intro_explosion, "roadkill_intro_orders" );

	//roadkill_shp_ontheline
	level.scr_anim[ "shepherd" ][ "roadkill_cover_active_leader" ]	 = %roadkill_cover_active_leader;
	level.scr_anim[ "shepherd" ][ "shepherd_cover" ][ 0 ] 			 = %roadkill_cover_active_leader_idle;
	addNotetrack_customFunction( "shepherd", "lookat on", ::enable_lookat );
	addNotetrack_customFunction( "shepherd", "lookat off", ::disable_lookat );
	addNotetrack_dialogue( "shepherd", "dialog", "roadkill_cover_active_leader", "roadkill_shp_ontheline" );


	level.scr_anim[ "shepherd" ][ "roadkill_riverbank_intro" ]		 = %roadkill_opening_shepherd;
	level.scr_anim[ "shepherd" ][ "intro_idle" ][ 0 ]				 = %roadkill_opening_shepherd_idle;
	addNotetrack_dialogue( "shepherd", "roadkill_shp_dontcare_ps", "roadkill_riverbank_intro", "roadkill_shp_dontcare" );

	level.scr_anim[ "foley" ][ "roadkill_riverbank_intro" ] 		 = %roadkill_opening_foley;
	level.scr_anim[ "foley" ][ "intro_idle" ][ 0 ] 					 = %roadkill_opening_foley_idle;
//	addNotetrack_dialogue( "foley", "roadkill_fly_yessir_ps", "roadkill_riverbank_intro", "roadkill_fly_yessir" );	
	addNotetrack_customFunction( "foley", "m203", ::foley_m203, "roadkill_riverbank_intro" );

	//addNotetrack_sound( "foley", "whistle", "roadkill_riverbank_intro", "ps_roadkill_whistle" );
//	addNotetrack_customFunction( "foley", "whistle", ::foley_whistle, "roadkill_riverbank_intro" );

	level.scr_anim[ "shepherd" ][ "ending" ]						 = %roadkill_ending;
	level.scr_anim[ "shepherd" ][ "walk" ] 							 = %roadkill_opening_shepherd_walk;

	//level.scr_anim[ "shepherd" ][ "walk" ] 							= %civilian_walk_hurried_2;
	//level.scr_anim[ "shepherd" ][ "walk" ] 							= %civilian_walk_paper;
	level.scr_anim[ "shepherd" ][ "idle_reach" ] 					 = %laptop_officer_idle;
	level.scr_anim[ "shepherd" ][ "idle" ][ 0 ] 					 = %laptop_officer_idle;

	level.scr_anim[ "shepherd" ][ "stair_approach" ]				 = %roadkill_shepherd_stair_approach;
	level.scr_anim[ "shepherd" ][ "stair_idle" ][ 0 ]				 = %roadkill_shepherd_stair_idle;
	level.scr_anim[ "shepherd" ][ "stair_wave" ]					 = %roadkill_shepherd_stair_wave;
	
	level.scr_anim[ "shepherd" ][ "angry_walk" ]					 = %roadkill_shepherd_walk;
	level.scr_anim[ "shepherd" ][ "angry_wander" ]					 = %roadkill_shepherd_shout_sequence;
	






	//level.scr_anim[ "shepherd" ][ "walk" ] 							= %civilian_walk_hurried_2;


	// Gentlemen, good work on taking the town!	
	addNotetrack_dialogue( "shepherd", "roadkill_shp_goodwork_ps", "ending", "roadkill_shp_goodwork" );

	// Private Allen, you'll be taking orders from me from now on. I'll brief you on the chopper. Let's go.	
	addNotetrack_dialogue( "shepherd", "roadkill_shp_specialop_ps", "ending", "roadkill_shp_specialop" );

//	addNotetrack_customFunction( "shepherd", "point_start", ::point_start, "ending" );
	addNotetrack_customFunction( "shepherd", "point_end", ::point_end, "ending" );

	level.scr_anim[ "spotter" ][ "idle" ][ 0 ] = %roadkill_cover_spotter_idle;
	level.scr_anim[ "soldier" ][ "idle" ][ 0 ] = %roadkill_cover_soldier_idle;

	level.scr_anim[ "spotter" ][ "binoc_scene" ] = %roadkill_cover_spotter;
	level.scr_anim[ "soldier" ][ "binoc_scene" ] = %roadkill_cover_soldier;
	addNotetrack_customFunction( "spotter", "detach binoc", ::detach_binoc, "binoc_scene" );
	addNotetrack_customFunction( "spotter", "attach binoc", ::attach_binoc, "binoc_scene" );

	level.scr_anim[ "cover_attack1" ][ "idle" ][ 0 ] = %roadkill_cover_active_soldier1;
	level.scr_anim[ "cover_attack2" ][ "idle" ][ 0 ] = %roadkill_cover_active_soldier2;
	level.scr_anim[ "cover_attack3" ][ "idle" ][ 0 ] = %roadkill_cover_active_soldier3;
	level.scr_anim[ "cover_radio1" ][ "idle" ][ 0 ]  = %roadkill_cover_radio_soldier1;
	level.scr_anim[ "cover_radio2" ][ "idle" ][ 0 ]  = %roadkill_cover_radio_soldier2;
	level.scr_anim[ "cover_radio3" ][ "idle" ][ 0 ]  = %roadkill_cover_radio_soldier3;
	level.scr_anim[ "cover_radio1" ][ "idle_noshoot" ][ 0 ]  = %roadkill_cover_radio_soldier1_idle;


	level.scr_anim[ "film1" ][ "video_film_start" ] = %roadkill_videotaper_1B_explosion_start;
	level.scr_anim[ "film1" ][ "video_film_idle" ][ 0 ] = %roadkill_videotaper_1B_explosion_idle;
	level.scr_anim[ "film1" ][ "video_film_react" ] = %roadkill_videotaper_1B_explosion;

	level.scr_anim[ "film2" ][ "video_film_start" ] = %roadkill_videotaper_2B_explosion_start;
	level.scr_anim[ "film2" ][ "video_film_idle" ][ 0 ] = %roadkill_videotaper_2B_explosion_idle;
	level.scr_anim[ "film2" ][ "video_film_react" ] = %roadkill_videotaper_2B_explosion;
	level.scr_anim[ "film2" ][ "video_film_end" ] = %roadkill_videotaper_2B_explosionend;

	level.scr_anim[ "film3" ][ "video_film_start" ] = %roadkill_videotaper_3B_explosion_start;
	level.scr_anim[ "film3" ][ "video_film_idle" ][ 0 ] = %roadkill_videotaper_3B_explosion_idle;
	level.scr_anim[ "film3" ][ "video_film_react" ] = %roadkill_videotaper_3B_explosion;
	level.scr_anim[ "film3" ][ "video_film_end" ] = %roadkill_videotaper_3B_explosionend;

	level.scr_anim[ "film4" ][ "video_film_start" ] = %roadkill_videotaper_4B_explosion_start;
	level.scr_anim[ "film4" ][ "video_film_idle" ][ 0 ] = %roadkill_videotaper_4B_explosion_idle ;
	level.scr_anim[ "film4" ][ "video_film_react" ] = %roadkill_videotaper_4B_explosion;

	level.scr_anim[ "generic" ][ "balcony_death" ] = [];
	level.scr_anim[ "generic" ][ "balcony_death" ][ 0 ] = %bog_b_rpg_fall_death;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 1 ] = %death_rooftop_A;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 2 ] = %death_rooftop_B;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 3 ] = %death_rooftop_D;

	/*
	level.scr_anim[ "film1" ][ "video_film" ] = %roadkill_videotaper_1_explosion;
	level.scr_anim[ "film2" ][ "video_film" ] = %roadkill_videotaper_2_explosion;
	level.scr_anim[ "film3" ][ "video_film" ] = %roadkill_videotaper_3_explosion;

	level.scr_anim[ "film2" ][ "video_film_end" ] = %roadkill_videotaper_2_explosionend;
	level.scr_anim[ "film3" ][ "video_film_end" ] = %roadkill_videotaper_3_explosionend;
	*/

	level.scr_model[ "film1" ] = "electronics_camera_pointandshoot_low";
	level.scr_model[ "film2" ] = "electronics_camera_cellphone_low";
	level.scr_model[ "film3" ] = "electronics_camera_cellphone_low";
	level.scr_model[ "film4" ] = "electronics_camera_cellphone_low";


	level.scr_anim[ "shepherd" ][ "ending_additive_right" ] = %roadkill_ending_point_left45;
	level.scr_anim[ "shepherd" ][ "ending_additive_left" ] = %roadkill_ending_point_right45;
	level.scr_anim[ "shepherd" ][ "ending_additive_controller" ] = %roadkill_ending_additive;


	level.scr_anim[ "exposed_flashbang_v1" ][ "flashed" ] = %exposed_flashbang_v1;
	level.scr_anim[ "exposed_flashbang_v2" ][ "flashed" ] = %exposed_flashbang_v2;
	level.scr_anim[ "exposed_flashbang_v3" ][ "flashed" ] = %exposed_flashbang_v3;
	level.scr_anim[ "exposed_flashbang_v4" ][ "flashed" ] = %exposed_flashbang_v4;
	level.scr_anim[ "exposed_flashbang_v5" ][ "flashed" ] = %exposed_flashbang_v5;

	level.scr_anim[ "generic" ][ "pistol_walk_back" ] = %pistol_walk_back;
	level.scr_anim[ "generic" ][ "pistol_death" ] = %airport_security_guard_pillar_death_r;
	level.scr_anim[ "generic" ][ "exposed_reload" ] = %exposed_reloadb;

	level.scr_anim[ "generic" ][ "cqb_wave" ] = %CQB_stand_signal_move_out;

	level.scr_anim[ "sit_1" ][ "sit_around" ][ 0 ] = %sitting_guard_loadAK_idle;
	level.scr_anim[ "sit_2" ][ "sit_around" ][ 0 ] = %civilian_texting_sitting;
	level.scr_anim[ "sit_3" ][ "sit_around" ][ 0 ] = %civilian_sitting_talking_A_1;

	level.scr_model[ "sit_2" ] = "electronics_pda";

	level.scr_anim[ "generic" ][ "rooftop_turn" ] = %stand_2_run_180L;

	level.scr_anim[ "generic" ][ "walk" ] = %patrol_bored_patrolwalk;

	level.scr_anim[ "street_runner" ][ "scene" ] = %airport_civ_pillar_exit;
	level.scr_anim[ "roof_backup" ][ "scene" ] = %airport_civ_fear_drop_6;

	level.scr_anim[ "generic" ][ "help_player_getin" ]					 = %roadkill_hummer_soldier_getin;

	level.scr_anim[ "generic" ][ "combat_walk" ] = %combatwalk_f_spin;

	level.scr_anim[ "generic" ][ "garage_spawner" ] = %unarmed_close_garage;
	level.scr_anim[ "generic" ][ "garage_spawner_right" ] = %unarmed_runinto_garage_right;
	level.scr_anim[ "generic" ][ "garage_spawner_left" ] = %unarmed_runinto_garage_left;
	level.scr_anim[ "generic" ][ "garage_spawner_left_run" ] = %unarmed_scared_run_delta;

	level.scr_anim[ "generic" ][ "garage_window_shouter_spawner" ][ 0 ] = %unarmed_shout_window;

	level.scr_anim[ "generic" ][ "garage_spawner_right" ] = %unarmed_runinto_garage_right;
//	level.scr_anim[ "generic" ][ "garage_spawner_right_run" ] = %unarmed_scared_run_delta;


	level.scr_anim[ "flee_alley" ][ "round_corner" ]		 = %flee_alley_civilain;
	level.scr_anim[ "flee_alley" ][ "idle" ][ 0 ]			 = %flee_alley_civilain_idle;
	level.scr_anim[ "flee_alley" ][ "idle_location" ]		 = %flee_alley_civilain_idle;


	level.scr_anim[ "flee_alley" ][ "hands_up" ] 			 = %unarmed_cowercrouch_react_A;


	level.scr_anim[ "generic" ][ "unarmed_climb_wall" ]		 = %unarmed_climb_wall;
	level.scr_anim[ "generic" ][ "unarmed_climb_wall_v2" ]	 = %unarmed_climb_wall_v2;
	level.scr_anim[ "generic" ][ "facedown_death" ]			 = %run_death_facedown;


	level.scr_anim[ "flee_alley" ][ "flee_shooting" ]		 = %flee_stand_2_run_med;


	level.scr_anim[ "generic" ][ "killhouse_gaz_idleA" ][ 0 ]				 = %killhouse_gaz_idleA;
	level.scr_anim[ "generic" ][ "killhouse_gaz_talk_side" ][ 0 ]			 = %killhouse_gaz_talk_side;
	level.scr_anim[ "generic" ][ "killhouse_gaz_idleB" ][ 0 ]				 = %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "killhouse_sas_price_idle" ][ 0 ]		 = %killhouse_sas_price_idle;

	level.scr_anim[ "generic" ][ "killhouse_gaz_idleA_solo" ]				 = %killhouse_gaz_idleA;
	level.scr_anim[ "generic" ][ "killhouse_gaz_talk_side_solo" ]			 = %killhouse_gaz_talk_side;
	level.scr_anim[ "generic" ][ "killhouse_gaz_idleB_solo" ]				 = %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "killhouse_sas_price_idle_solo" ]			 = %killhouse_sas_price_idle;



	/*
	level.scr_anim[ "generic" ][ "step_idle" ][ 0 ]		 = %unarmed_waving_startidle;
	level.scr_anim[ "generic" ][ "step_out" ]			 = %unarmed_waving_stepout;
	level.scr_anim[ "generic" ][ "waving_idle" ][ 0 ]		 = %unarmed_waving;
	level.scr_anim[ "generic" ][ "waving_idle" ][ 1 ]		 = %unarmed_waving_twitch;
	level.scr_anim[ "generic" ][ "close_garage" ]		 = %unarmed_close_garage;
	level.scr_anim[ "generic" ][ "close_garage2" ]		 = %unarmed_close_garage_v2;
	level.scr_anim[ "generic" ][ "waving_end" ]			 = %unarmed_waving_endidle;
	level.scr_anim[ "generic" ][ "arrive" ]			 = %unarmed_runinto_garage_right;
	level.scr_anim[ "generic" ][ "arrive" ]			 = %unarmed_runinto_garage_left;
	level.scr_anim[ "generic" ][ "arrive" ]		 = %unarmed_runinto_garage;
	level.scr_anim[ "generic" ][ "climb" ]					 = %unarmed_climb_wall;
	level.scr_anim[ "generic" ][ "climb" ]					 = %unarmed_climb_wall_v2;
	level.scr_anim[ "generic" ][ "climb" ]					 = %unarmed_climb_wall_v3;
	level.scr_anim[ "generic" ][ "idle" ][ 0 ]				 = %unarmed_pullup_window_guyA_idle;
	level.scr_anim[ "generic" ][ "pull" ]					 = %unarmed_pullup_window_guyA;
	level.scr_anim[ "generic" ][ "pull" ]					 = %unarmed_pullup_window_guyB;

	level.scr_runanim[ "unarmed" ] = %unarmed_run_delta;
	*/

	level.scr_anim[ "generic" ][ "humvee_turret_bounce" ]				 = %humvee_turret_bounce;
	level.scr_anim[ "generic" ][ "humvee_turret_idle_lookback" ]		 = %humvee_turret_idle_lookback;
	level.scr_anim[ "generic" ][ "humvee_turret_idle_lookbackB" ]		 = %humvee_turret_idle_lookbackB;
	level.scr_anim[ "generic" ][ "humvee_turret_idle_signal_forward" ]	 = %humvee_turret_idle_signal_forward;
	level.scr_anim[ "generic" ][ "humvee_turret_idle_signal_side" ]		 = %humvee_turret_idle_signal_side;
	level.scr_anim[ "generic" ][ "humvee_turret_radio" ]				 = %humvee_turret_radio;
	level.scr_anim[ "generic" ][ "humvee_turret_flinchA" ]				 = %humvee_turret_flinchA;
	level.scr_anim[ "generic" ][ "humvee_turret_flinchB" ]				 = %humvee_turret_flinchB;
	level.scr_anim[ "generic" ][ "humvee_turret_rechamber" ]			 = %humvee_turret_rechamber;

}

enable_lookat( guy )
{
	//guy SetLookAtEntity( level.player );
}

disable_lookat( guy )
{
	//guy SetLookAtEntity();
}

detach_binoc( guy )
{
	if ( !isdefined( guy.binoc ) )
		return;

	guy Detach( "weapon_binocular", "tag_inhand" );
	guy.binoc = undefined;
}

attach_binoc( guy )
{
	if ( IsDefined( guy.binoc ) )
		return;

	guy Attach( "weapon_binocular", "tag_inhand" );
	guy.binoc = true;
}

foley_whistle( foley )
{
	foley thread play_sound_on_entity( "roadkill_whistle" );
	wait( 0.9 );
	flag_set( "bridgelayer_starts" );
}

point_start( shepherd )
{
	shepherd.pointing = true;
	//shepherd SetLookAtEntity( level.player );
	shepherd shepherd_points_at_player();
}

shepherd_points_at_player()
{
	self endon( "point_end" );
	controller = self getanim( "ending_additive_controller" );
	left_anim = self getanim( "ending_additive_left" );
	right_anim = self getanim( "ending_additive_right" );
	range = 45;

	for ( ;; )
	{
		animation = self getanim( "ending" );
		//self SetAnim( animation, 1, 0, 0.1 );

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
			self SetAnim( left_anim, 0, 0.2, 1 );
			self SetAnim( right_anim, 1, 0.2, 1 );
		}
		else
		{
			degrees += 10;
			if ( degrees > range )
				degrees = range;

			weight = degrees / range;
			self SetAnim( left_anim, 1, 0.2, 1 );
			self SetAnim( right_anim, 0, 0.2, 1 );
		}
		
		if ( isdefined( self.pointing ) )
		{
			if ( abs( weight ) >= 1 )
			{
				self SetLookAtEntity( level.player );
				//iprintln( 1 );
			}
			else
			{
				self SetLookAtEntity();
			}
		}

		self SetAnim( controller, weight, 0.2, 1 );

		//forward = AnglesToForward( self.angles );
		//Line( self.origin, self.origin + forward * 150, (1,0,0) );
		//Line( self.origin, level.player.origin, (1,1,1) );
		//Print3d( self.origin, degrees, (1,1,0), 1, 1 );
		//Print3d( self.origin + (0,0,30), weight, (1,1,1), 1, 1 );

		wait( 0.05 );
	}
	
	//guy SetLookAtEntity( level.player );
}

point_end( shepherd )
{
	wait 2.9;
	shepherd.pointing = undefined;
	shepherd SetLookAtEntity();
	
	Shepherd notify( "point_end" );
	controller = Shepherd getanim( "ending_additive_controller" );
	Shepherd ClearAnim( controller, 0.2 );
	//shepherd SetLookAtEntity( level.player );
	//( position, turn acceleration );
}

foley_m203( foley )
{
	effect = getfx( "m203" );

	start = foley GetTagOrigin( "tag_flash" );
	angles = foley GetTagAngles( "tag_flash" );

	PlayFXOnTag( effect, foley, "tag_flash" );
	//shootpos = foley.enemy GetShootAtPos() + ( 0, 0, 190 );
	shootpos = ( -1734, -1205, 740 );
	MagicBullet( "m203", start, shootpos );
}

#using_animtree( "script_model" );
script_model_animations()
{
	level.scr_animtree[ "gun_model" ] 							= #animtree;
	level.scr_model[ "gun_model" ] 								= "weapon_colt_anaconda_animated";
	level.scr_anim[ "gun_model" ][ "player_shep_intro" ]		= %roadkill_intro_pickup_gun;
}

#using_animtree( "player" );
roadkill_player_anims()
{
	level.scr_anim[ "player_rig" ][ "player_getin" ] 		 = %roadkill_hummer_player_getin;
//	level.scr_sound[ "player_rig" ][ "player_getin" ] 		 = "scn_roadkill_enter_humvee_plr";
	
	level.scr_animtree[ "player_rig" ] 					 = #animtree;
	level.scr_model[ "player_rig" ] 						 = "ch_viewhands_player_gk_ump45";
	

	level.scr_anim[ "player_rig" ][ "player_shep_intro" ] 		 = %roadkill_intro_pickup_player;

}


#using_animtree( "vehicles" );
bridge_layer()
{
	level.scr_anim[ "bridge_layer_bridge" ][ "bridge_lower" ] 		 = %roadkill_M60A1_bridge_lower;
	level.scr_anim[ "bridge_layer_bridge" ][ "bridge_driveup" ] 	 = %roadkill_M60A1_bridge_driveup;

	level.scr_anim[ "bridge_layer" ][ "bridge_lower" ] 				 = %roadkill_M60A1_tank_lower;
	level.scr_anim[ "bridge_layer" ][ "bridge_driveup" ] 			 = %roadkill_M60A1_tank_driveup;
	level.scr_anim[ "bridge_layer" ][ "bridge_cross" ]	 			 = %roadkill_M60A1_tank_cross;
	level.scr_anim[ "bridge_layer" ][ "bridge_arm_lower" ]			 = %roadkill_M60A1_arm_lower;


	level.scr_animtree[ "bridge_layer_bridge" ] 					 = #animtree;
	level.scr_animtree[ "bridge_layer" ] 							 = #animtree;

	level.scr_animtree[ "player_humvee" ] 							 = #animtree;
	level.scr_anim[ "player_humvee" ][ "roadkill_intro_orders" ] 	 = %roadkill_orders_hummer;

	level.scr_anim[ "player_humvee" ][ "roadkill_player_door_open" ]  = %roadkill_hummer_door_soldier;


	level.scr_anim[ "turret" ][ "player_getin" ] 					 = %roadkill_hummer_gun_getin;
	level.scr_animtree[ "turret" ]					 				 = #animtree;


	level.scr_anim[ "technical" ][ "technical_pushed" ] 			 = %roadkill_pickup_technical_pushed;
	level.scr_animtree[ "technical" ]					 			 = #animtree;


}

intro_explosion( foley )
{
	exploder( "intro_boom" );
}

#using_animtree( "generic_human" );
roadkill_dialogue()
{
	/*
	Shepherd: I don't care how many rpgs they have. The time line dictates that we cross this river in 4 minutes, and we will be on time.
	Foley: Yes sir. (Foley whistles up at the bridge and signals for them to start).
	
	Foley: Hunter two! Keep the pressure on the rpg teams. If the bridge layer gets hit, shepherd will make us swim.
	
	Foley: Up there! They're making a push for the bridge layer! Beat them back!
	Foley: They're retreating, keep hitting them!
	Foley: Hunter two! The bridge is finished, we're oscar mike! Move out!

	AR3: What's the hold up?
	Dunn: Weren't you listening? Shepherd called in a major fire mission.
	AR3: Won't that be danger close for the task force?
	Dunn: Since when does Shepherd care about danger close?
	
	<Coughing sounds>
	
	later at the end of the ride:
	Straight ahead, top floor, he's got an RPG!

	in school:
	Hunter 2-3, We're in the school. Heavy resistance.
	Copy that hunter 2-1.
	
	Upstairs:
	"I'm cutting through history class."
	"Roger that."
	
	*/

	/*
	removed:
	// Private Brodsky, you have the Javelin? We've got enemy armor threatening the AVLB and satcom confirms multiple vehicles inbound. Your top priority is to take out that armor, huah?	
	level.scr_sound[ "generic" ][ "roadkill_fly_havethejavelin" ] = "roadkill_fly_havethejavelin";

	// Brodsky, use your Javelin to take out the armor!	
	level.scr_sound[ "generic" ][ "roadkill_fly_takeoutarmor" ] = "roadkill_fly_takeoutarmor";
	
	// Brodsky, switch to your Javelin!	
	level.scr_sound[ "generic" ][ "roadkill_fly_switchtojavelin" ] = "roadkill_fly_switchtojavelin";
	
	// Engage that armored vehicle across the river! 	
	level.scr_sound[ "generic" ][ "roadkill_fly_acrossriver" ] = "roadkill_fly_acrossriver";
	
	// Target that armored vehicle with your Javelin!	
	level.scr_sound[ "generic" ][ "roadkill_fly_targetvehicle" ] = "roadkill_fly_targetvehicle";

	// Knock it off! Hunter Two, we're oscar mike! Move out!	
	level.scr_sound[ "generic" ][ "roadkill_fly_knockitoff" ] = "roadkill_fly_knockitoff";

	// Brodsky - good job on taking out the enemy armor. Now let's get over there and take that town.	
	level.scr_sound[ "generic" ][ "roadkill_shp_taketown" ] = "roadkill_shp_taketown";

	
	// Hu-ahh!! What was that, a 1000 pounder?	
	level.scr_sound[ "generic" ][ "roadkill_ar3_whatwasthat" ] = "roadkill_ar3_whatwasthat";
	
	// I dunno but damn that was kick ass, huah?	
	level.scr_sound[ "generic" ][ "roadkill_ar4_idunno" ] = "roadkill_ar4_idunno";
	
	// Goliath Actual to Hunter 2-1, what's going on out there, over?	
	level.scr_radio[ "roadkill_ar3_goingon" ] = "roadkill_ar3_goingon";
	
	// Hunter 2-1 to Goliath Actual, we took fire and were separated from Hunter 2-3! We're working our way back around, over!	
	level.scr_sound[ "generic" ][ "roadkill_fly_tookfire" ] = "roadkill_fly_tookfire";
	
	// Goliath Actual solid copy.	
	level.scr_radio[ "roadkill_ar3_solidcopy" ] = "roadkill_ar3_solidcopy";
	

	// Wonder what's got him all worked up?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_allworkedup" ] = "roadkill_cpd_allworkedup";
	
	// Stop stop stop!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_stopstopstop" ] = "roadkill_cpd_stopstopstop";

	// What's going on?	
	level.scr_sound[ "generic" ][ "roadkill_fly_whatsgoingon" ] = "roadkill_fly_whatsgoingon";
	
	// We're being shot at!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_beingshotat" ] = "roadkill_cpd_beingshotat";
	
	// Quick, he's getting away!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_gettingaway" ] = "roadkill_ar1_gettingaway";
	
	// You got him you got him!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_yougothim" ] = "roadkill_ar1_yougothim";
	
	// Nice, nice!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_nicenice" ] = "roadkill_cpd_nicenice";

	// All right let's keep moving!	
	level.scr_sound[ "generic" ][ "roadkill_fly_letskeepgoing" ] = "roadkill_fly_letskeepgoing";

	// Nevermind, Allen handled it	
	level.scr_sound[ "generic" ][ "roadkill_cpd_handledit" ] = "roadkill_cpd_handledit";
	
	
	*/

	// Allen! Switch to your M203!			
	level.scr_sound[ "generic" ][ "roadkill_fly_yourM203" ] = "roadkill_fly_yourM203";
	// Drop some rounds on 'em across the river!				
	level.scr_sound[ "generic" ][ "roadkill_fly_acrossriver" ] = "roadkill_fly_acrossriver";
	// On the bridge, 10 o'clock high! Multiple targets, take em ouuutt!!!				
	level.scr_sound[ "generic" ][ "roadkill_fly_10oclockhigh" ] = "roadkill_fly_10oclockhigh";
	// Up there on the bridge!!!				
	level.scr_sound[ "generic" ][ "roadkill_fly_onthebridge" ] = "roadkill_fly_onthebridge";
	


	// I don't care how many rpgs they have - the time line dictates that we cross this river in four minutes, and we will be on time.	
	level.scr_sound[ "generic" ][ "roadkill_shp_dontcare" ] = "roadkill_shp_dontcare";

	// Yes sir.	
	level.scr_sound[ "generic" ][ "roadkill_fly_yessir" ] = "roadkill_fly_yessir";

	// Hunter Two! Keep up the pressure on those RPG teams! If that bridgelayer gets hit, we're swimming, huah?	
	level.scr_sound[ "generic" ][ "roadkill_fly_wereswimming" ] = "roadkill_fly_wereswimming";

	// Up there! They're making a push for the bridgelayer! Beat 'em back!	
	level.scr_sound[ "generic" ][ "roadkill_fly_makingapush" ] = "roadkill_fly_makingapush";

	// They're retreating, keep hitting 'em!	
	level.scr_sound[ "generic" ][ "roadkill_fly_keephitting" ] = "roadkill_fly_keephitting";

	// Hunter Two! Bridge complete, we're oscar mike! Move out!!	
	level.scr_sound[ "generic" ][ "roadkill_fly_bridgecomplete" ] = "roadkill_fly_bridgecomplete";
	level.scr_face[ "generic" ][ "roadkill_fly_bridgecomplete" ] = %roadkill_fly_bridgecomplete;
	





	// Warlord, Warlord, this is Hunter 2-1, requesting air strike at grid 2-5-2, 1-7-1! Target is a white, 
	// twelve story apartment building occupied by hostile forces, over!
	level.scr_sound[ "generic" ][ "roadkill_cpd_airstrike" ] = "roadkill_cpd_airstrike";

	// Hunter 2-1, this is Warlord, solid copy, uh, I have Devil 1-1, flight of two F-15s, on the line, standby for relay.	
	level.scr_radio[ "roadkill_auc_ontheline" ] = "roadkill_auc_ontheline";

	// Hunter 2-1 this is Devil 1-1, flight of two F-15s, time on station, one-five mikes, 
	// holding at three-Sierra, northwest, holding area Knife, carrying two JDAMs and two HARMs, over.	
	level.scr_radio[ "roadkill_fp1_devil11" ] = "roadkill_fp1_devil11";

	// Devil 1-1, this is Hunter 2-1, solid copy on check-in, standby.	
	level.scr_sound[ "generic" ][ "roadkill_cpd_checkin" ] = "roadkill_cpd_checkin";

	// Standing by.	
	level.scr_radio[ "roadkill_fp1_standingby" ] = "roadkill_fp1_standingby";

	// Devil 1-1, target is a white, twelve story apartment building at grid 2-5-2, 1-7-1. I need you to level that building, how copy over?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_levelbuilding" ] = "roadkill_cpd_levelbuilding";

	// Solid copy Hunter 2-1. Rolling in now... Target acquired.	
	level.scr_radio[ "roadkill_fp1_targetacquired" ] = "roadkill_fp1_targetacquired";

	// Cleared hot!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_clearedhot" ] = "roadkill_cpd_clearedhot";

	// Devil 1-1 off safe. Bombs away bombs away.	
	level.scr_radio[ "roadkill_fp1_offsafe" ] = "roadkill_fp1_offsafe";


	// What's the hold up?	
	level.scr_sound[ "generic" ][ "roadkill_ar3_holup" ] = "roadkill_ar3_holup";

	// Shepherd called in a major fire mission!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_majorfiremission" ] = "roadkill_cpd_majorfiremission";

	// Uh, won't that be danger close for the task force?	
	level.scr_sound[ "generic" ][ "roadkill_ar3_dangerclose" ] = "roadkill_ar3_dangerclose";

	// Since when does Shepherd care about danger close?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_sincewhen" ] = "roadkill_cpd_sincewhen";




	// Huah!! Get some!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_getsome" ] = "roadkill_cpd_getsome";

	// Yeah! 	
	level.scr_sound[ "generic" ][ "roadkill_ar1_yeah" ] = "roadkill_ar1_yeah";

	// Woo! Yeah!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_wooyeah" ] = "roadkill_ar2_wooyeah";

	// Huah! Hell yea!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_huahyeah" ] = "roadkill_ar1_huahyeah";

	// The networks are gonna pay big for this one!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_paybig" ] = "roadkill_cpd_paybig";

	// Keep dreamin video boy!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_keepdreamin" ] = "roadkill_ar2_keepdreamin";

	// No man, seriously, that was extreme!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_extreme" ] = "roadkill_cpd_extreme";


	// Whoa!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_whoa" ] = "roadkill_ar1_whoa";

	// Yeah - (cough)	
	level.scr_sound[ "generic" ][ "roadkill_ar2_yeahcough" ] = "roadkill_ar2_yeahcough";

	// (coughing)
	level.scr_sound[ "generic" ][ "roadkill_gar_cough1" ] = "roadkill_gar_cough1";
	level.scr_sound[ "generic" ][ "roadkill_gar_cough2" ] = "roadkill_gar_cough2";
	level.scr_sound[ "generic" ][ "roadkill_gar_cough3" ] = "roadkill_gar_cough3";
	level.scr_sound[ "generic" ][ "roadkill_gar_cough4" ] = "roadkill_gar_cough4";
	level.scr_sound[ "generic" ][ "roadkill_gar_cough5" ] = "roadkill_gar_cough5";
	level.scr_sound[ "generic" ][ "roadkill_gar_cough6" ] = "roadkill_gar_cough6";



	// We're movin' out!!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_movinout" ] = "roadkill_cpd_movinout";


	// Huah!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_huah" ] = "roadkill_ar2_huah";

	// Get your ass back in the vehicle!	
	level.scr_sound[ "generic" ][ "roadkill_ar3_backinvehicle" ] = "roadkill_ar3_backinvehicle";

	// Battalion is oscar mike!!!	
	level.scr_sound[ "generic" ][ "roadkill_ar4_oscarmike" ] = "roadkill_ar4_oscarmike";

	// We're oscar mike, move it!	
	level.scr_sound[ "generic" ][ "roadkill_fly_oscarmike" ] = "roadkill_fly_oscarmike";

	// We're oscar mike!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_oscarmike" ] = "roadkill_ar2_oscarmike";

	// If you have to do #2 go now because once I start the car I am not stoppin', huah?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_notstoppin" ] = "roadkill_cpd_notstoppin";

	// We're moving out now!	
	level.scr_sound[ "generic" ][ "roadkill_fly_movingout" ] = "roadkill_fly_movingout";

	// Mount up!	
	level.scr_sound[ "generic" ][ "roadkill_fly_mountup" ] = "roadkill_fly_mountup";


	// Come on Brodsky, get in!	
	level.scr_sound[ "generic" ][ "roadkill_fly_comeongetin" ] = "roadkill_fly_comeongetin";

	// Brodsky, get in your humvee, you're holding up the line!	
	level.scr_sound[ "generic" ][ "roadkill_fly_holdingupline" ] = "roadkill_fly_holdingupline";

	// Hurry up Private!	
	level.scr_sound[ "generic" ][ "roadkill_fly_hurryup" ] = "roadkill_fly_hurryup";

	// Brodsky, move your ass, let's go!	
	level.scr_sound[ "generic" ][ "roadkill_fly_moveletsgo" ] = "roadkill_fly_moveletsgo";



	// Hunter two breaking away.	
	level.scr_sound[ "generic" ][ "roadkill_fly_breakingaway" ] = "roadkill_fly_breakingaway";

	// Copy Hunter Two.	
	level.scr_radio[ "roadkill_hqr_copyhunter2" ] = "roadkill_hqr_copyhunter2";

	// Scan the rooftops for hostiles.	
	level.scr_sound[ "generic" ][ "roadkill_fly_scanrooftops" ] = "roadkill_fly_scanrooftops";

	// Hurry up, I�m not sure this building is going to last much longer.	
	level.scr_sound[ "generic" ][ "roadkill_fly_lastlonger" ] = "roadkill_fly_lastlonger";

	// Keep an eye out for civvies, we�re not cleared to engage unless they fire first.	
	level.scr_sound[ "generic" ][ "roadkill_fly_eyeoutforciv" ] = "roadkill_fly_eyeoutforciv";

	// Hold off, it�s a civilian.	
	level.scr_sound[ "generic" ][ "roadkill_fly_holdoff" ] = "roadkill_fly_holdoff";

	// Bet he�s scouting us.	
	level.scr_sound[ "generic" ][ "roadkill_cpd_scoutingus" ] = "roadkill_cpd_scoutingus";

	// Doesn�t mean you can shoot him.	
	level.scr_sound[ "generic" ][ "roadkill_fly_doesntmean" ] = "roadkill_fly_doesntmean";




	// Allen, what are you shooting at, there's nothing there! Cease fire!	
	level.scr_sound[ "generic" ][ "roadkill_fly_nothingthere" ] = "roadkill_fly_nothingthere";

	// Allen, stand down! The ROE dictates we can�t fire unless fired upon!	
	level.scr_sound[ "generic" ][ "roadkill_fly_standdown" ] = "roadkill_fly_standdown";

	// Allen! Cease fire!	
	level.scr_sound[ "generic" ][ "roadkill_fly_ceasefire" ] = "roadkill_fly_ceasefire";






	// Watch your sector!	
	level.scr_sound[ "generic" ][ "roadkill_fly_watchsector" ] = "roadkill_fly_watchsector";

	// You see anything?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_seeanything" ] = "roadkill_cpd_seeanything";

	// Stay frosty!	
	level.scr_sound[ "generic" ][ "roadkill_fly_stayfrosty" ] = "roadkill_fly_stayfrosty";



//school_convert_color_trigger



	// Eyes forward, Allen. Look alive.	
	level.scr_sound[ "generic" ][ "roadkill_fly_eyesforward" ] = "roadkill_fly_eyesforward";

	// Watch the alleys.	
	level.scr_sound[ "generic" ][ "roadkill_fly_watchalleys" ] = "roadkill_fly_watchalleys";





	// Contact 12 o clock!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_contact12" ] = "roadkill_cpd_contact12";

	// Floor it, we need to get out of the kill zone!	
	level.scr_sound[ "generic" ][ "roadkill_fly_sittingducks" ] = "roadkill_fly_sittingducks";

	// Slow down, we're getting strung out!	
	level.scr_sound[ "generic" ][ "roadkill_fly_strungout" ] = "roadkill_fly_strungout";

	// Keep moving!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_keepmoving" ] = "roadkill_cpd_keepmoving";

	// Hunter 2-1, this is Hunter 2-3, our humvee got shot up and we're cut off from you, over!	
	// Hunter 2-1, this is Hunter 2-3, Haggertys hurt bad and we're taking a lot of fire, where are you?
	level.scr_radio[ "roadkill_ar2_shotup" ] = "roadkill_ar2_shotup";

	// Solid copy Hunter 2-3! Hang tight! We're making our way back to you, over!
	level.scr_sound[ "generic" ][ "roadkill_fly_hangtight" ] = "roadkill_fly_hangtight";

	// Hunter 2-3 solid copy.
	level.scr_radio[ "roadkill_ar2_solidcopy" ] = "roadkill_ar2_solidcopy";


	// We're cut off!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_cutoff" ] = "roadkill_cpd_cutoff";

	// Push through!	
	level.scr_sound[ "generic" ][ "roadkill_fly_pushthrough" ] = "roadkill_fly_pushthrough";

	// Heads up!	
	// RPG!!! Top floor!!! Dead ahead!!
	level.scr_sound[ "generic" ][ "roadkill_fly_headsup" ] = "roadkill_fly_rpgtopfloor";

	// We need to get off the street!	
	level.scr_sound[ "generic" ][ "roadkill_fly_getoffstreet" ] = "roadkill_fly_getoffstreet";



	// Follow me let's go!  	
	level.scr_sound[ "generic" ][ "roadkill_fly_followme" ] = "roadkill_fly_followme";


	// Is everybody all right?	
	level.scr_sound[ "generic" ][ "roadkill_fly_everybodyok" ] = "roadkill_fly_everybodyok";
	// Huah.		
	level.scr_sound[ "generic" ][ "roadkill_cpd_huah" ] = "roadkill_cpd_huah";
	// Huah.		
	level.scr_sound[ "generic" ][ "roadkill_ar1_huah" ] = "roadkill_ar1_huah";
	// Huah.		
	level.scr_sound[ "generic" ][ "roadkill_ar2_huah2" ] = "roadkill_ar2_huah2";
	// They're movin' around upstairs! moving around upstairs		
	level.scr_sound[ "generic" ][ "roadkill_cpd_movinaroundup" ] = "roadkill_cpd_movinaroundup";


	// Get the hell away from those windows and secure the top floor! Move! Move!		
	level.scr_sound[ "generic" ][ "roadkill_fly_securetopfloor" ] = "roadkill_fly_securetopfloor";


	// Hunter 2-1 to Hunter 2-3, I have eyes on the school, over!	
	level.scr_sound[ "generic" ][ "roadkill_fly_eyesonschool" ] = "roadkill_fly_eyesonschool";
	// 2-1, we are combat ineffective here! We are taking heavy fire from the school, can you assist, over?!		
	level.scr_radio[ "roadkill_ar3_ineffective" ] = "roadkill_ar3_ineffective";
	// Keep it together 2-3! We're on the way! 2-1 out!		
	level.scr_sound[ "generic" ][ "roadkill_fly_keepittogether" ] = "roadkill_fly_keepittogether";
	



	// Hunter 2-3, Hunter 2-1, we're in the school. Heavy resistance.	
	level.scr_sound[ "generic" ][ "roadkill_fly_intheschool" ] = "roadkill_fly_intheschool";

	// Copy that Hunter 2-1.	
	level.scr_sound[ "generic" ][ "roadkill_shp_copythat21" ] = "roadkill_shp_copythat21";

	// I'm cutting through history class.	
	level.scr_sound[ "generic" ][ "roadkill_cpd_historyclass" ] = "roadkill_cpd_historyclass";

	// Roger that.	
	level.scr_sound[ "generic" ][ "roadkill_fly_rogerthat" ] = "roadkill_fly_rogerthat";

	// I think I saw one run into that classroom.	
	level.scr_sound[ "generic" ][ "roadkill_fly_sawone" ] = "roadkill_fly_sawone";

	// I gotta admit I was expecting a little more resistan-	
	level.scr_sound[ "generic" ][ "roadkill_fly_moreresistance" ] = "roadkill_fly_moreresistance";

	// Taaargeets, front of the school!! Take 'em out!!!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_frontofschool" ] = "roadkill_cpd_frontofschool";
	


	// Watch it! Some of 'em just went in that classroom on the right!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_classonright" ] = "roadkill_cpd_classonright";
	
	
	
	// Hunter 2-1 this is Hunter 2-3, thanks for the assist! We're leaving on Hunter Three's humvee, over!
	level.scr_sound[ "generic" ][ "roadkill_shp_thanksforassist" ] = "roadkill_shp_thanksforassist";
	// Roger that 2-3.				
	level.scr_sound[ "generic" ][ "roadkill_fly_allthewaysir" ] = "roadkill_fly_allthewaysir";
	// We'll see you on the flipside Hunter 2-1, 2-3 out.				
	level.scr_sound[ "generic" ][ "roadkill_shp_alltheway" ] = "roadkill_shp_alltheway";
	


	// Keep moving! General Shepherd's on board Hunter 2-3! We need to take the pressure off those humvees!	
	level.scr_sound[ "generic" ][ "roadkill_fly_pressureoff" ] = "roadkill_fly_pressureoff";

	// Hunter 2-1 this is Shepherd, thanks for the assist! This town's almost ours - let's finish the job, huah?	
	level.scr_radio[ "roadkill_shp_thanksforassist" ] = "roadkill_shp_thanksforassist";

	// Huah. Roger that 2-3. Rangers lead the way sir!	
	level.scr_sound[ "generic" ][ "roadkill_fly_allthewaysir" ] = "roadkill_fly_allthewaysir";

	// All the way! We'll see you on the flipside Hunter 2-1, Shepherd out.	
	level.scr_radio[ "roadkill_shp_alltheway" ] = "roadkill_shp_alltheway";

	// Hunter 2-1 Actual to Goliath.	
	level.scr_sound[ "generic" ][ "roadkill_fly_togoliath" ] = "roadkill_fly_togoliath";

	// Hunter 2-1 Actual this is Goliath, send traffic.	
	level.scr_radio[ "roadkill_ar3_sendtraffic" ] = "roadkill_ar3_sendtraffic";

	// Copy Goliath, the school is secure and hostiles are withdrawing from the area. We're just moppin' up now.	
	// Hunter 2-1 Actual to Goliath, the school is secure and hostiles are withdrawing from the area. We're just moppin' up now.
	level.scr_sound[ "generic" ][ "roadkill_fly_schoolsecure" ] = "roadkill_fly_schoolsecure";

	// Copy that Hunter 2-1 Actual, proceed with caution to the rally point. EPWs may still be in the area. Over.	
	level.scr_radio[ "roadkill_ar3_rallypoint" ] = "roadkill_ar3_rallypoint";

	// Roger that Goliath, thanks for the tip. Hunter 2-1 Actual out.	
	level.scr_sound[ "generic" ][ "roadkill_fly_thanksfortip" ] = "roadkill_fly_thanksfortip";

	// Squad, watch for enemy stragglers! Let's get to that rally point!	
	level.scr_sound[ "generic" ][ "roadkill_fly_watchstragglers" ] = "roadkill_fly_watchstragglers";


	// Clear! That's the last of 'em!	
	level.scr_sound[ "generic" ][ "roadkill_fly_lastofem" ] = "roadkill_fly_lastofem";

	// Transport the wounded directly to the shock trauma unit! Use my helicopter! I'll take the next one out!	
	level.scr_sound[ "generic" ][ "roadkill_shp_shocktrauma" ] = "roadkill_shp_shocktrauma";

	// Gentlemen, good work on taking the town!	
	level.scr_sound[ "generic" ][ "roadkill_shp_goodwork" ] = "roadkill_shp_goodwork";

	// Private Allen, you'll be taking orders from me from now on. I'll brief you on the chopper. Let's go.	
	level.scr_sound[ "generic" ][ "roadkill_shp_specialop" ] = "roadkill_shp_specialop";



	// Anybody got a spare MRE?	
	level.scr_sound[ "generic" ][ "roadkill_ar1_sparemre" ] = "roadkill_ar1_sparemre";

	// We're oscar mike!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_oscarmike2" ] = "roadkill_ar2_oscarmike2";

	// Stow your gear and move out!	
	level.scr_sound[ "generic" ][ "roadkill_ar3_stowyourgear" ] = "roadkill_ar3_stowyourgear";

	// I want that Mark 19 up and running in five mikes!	
	level.scr_sound[ "generic" ][ "roadkill_ar4_upandrunning" ] = "roadkill_ar4_upandrunning";




	// Private Allen! Get on the line! Rangers lead the way!	
	level.scr_sound[ "generic" ][ "roadkill_shp_ontheline" ] = "roadkill_shp_ontheline";





	// Which building is it sir?	
	level.scr_sound[ "generic" ][ "roadkill_ar1_whichbuilding" ] = "roadkill_ar1_whichbuilding";

	// The tall one at 1 o'clock.	
	level.scr_sound[ "generic" ][ "roadkill_ar2_tallone" ] = "roadkill_ar2_tallone";

	// Hey dawg, which building?	
	level.scr_sound[ "generic" ][ "roadkill_ar3_heydawg" ] = "roadkill_ar3_heydawg";

	// The one at 1 o'clock, the tall - hey Dave, which one is it? Is it the one of the left or the right?	
	level.scr_sound[ "generic" ][ "roadkill_ar4_whichone" ] = "roadkill_ar4_whichone";

	// The one on the left.	
	level.scr_sound[ "generic" ][ "roadkill_ar5_oneonleft" ] = "roadkill_ar5_oneonleft";

	// How long will it record for?	
	level.scr_sound[ "generic" ][ "roadkill_ar1_howlong" ] = "roadkill_ar1_howlong";

	// I dunno, till it runs out man.	
	level.scr_sound[ "generic" ][ "roadkill_ar2_runsout" ] = "roadkill_ar2_runsout";

	// 10 seconds!! 	
	level.scr_sound[ "generic" ][ "roadkill_ar1_10seconds" ] = "roadkill_ar1_10seconds";

	// 10 seconds!!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_10seconds" ] = "roadkill_ar2_10seconds";

	// 10 seconds!!	
	level.scr_sound[ "generic" ][ "roadkill_ar3_10seconds" ] = "roadkill_ar3_10seconds";

	// What's goin' on.	
	level.scr_sound[ "generic" ][ "roadkill_ar4_goinon" ] = "roadkill_ar4_goinon";

	// Shepherd called in a major fire mission.	
	level.scr_sound[ "generic" ][ "roadkill_ar5_majorfire" ] = "roadkill_ar5_majorfire";

	// You gonna tape this one? You got enough memory left?	
	level.scr_sound[ "generic" ][ "roadkill_ar4_memoryleft" ] = "roadkill_ar4_memoryleft";

	// Huah, should be good.	
	level.scr_sound[ "generic" ][ "roadkill_ar5_shouldbegood" ] = "roadkill_ar5_shouldbegood";

	// Hey isn't this danger close for the task force?	
	level.scr_sound[ "generic" ][ "roadkill_ar3_dangerclose" ] = "roadkill_ar3_dangerclose";

	// Since when does Shepherd care about danger close?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_sincewhen" ] = "roadkill_cpd_sincewhen";

	// BOOM!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_boom" ] = "roadkill_ar1_boom";

	// --ck yeah!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_yeah" ] = "roadkill_ar2_yeah";

	// Wooo!!!	
	level.scr_sound[ "generic" ][ "roadkill_ar3_woo" ] = "roadkill_ar3_woo";

	// Yeah!!!	
	level.scr_sound[ "generic" ][ "roadkill_ar4_yeah" ] = "roadkill_ar4_yeah";

	// That was hot man...	
	level.scr_sound[ "generic" ][ "roadkill_ar5_hotman" ] = "roadkill_ar5_hotman";

	// You don't get this on the 4th of July!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_4thofjuly" ] = "roadkill_ar1_4thofjuly";

	// (varitey pack of catcall, woos, yeahs, etc.)	
	level.scr_sound[ "generic" ][ "roadkill_ar1_catcalls" ] = "roadkill_ar1_catcalls";

	// (varitey pack of catcall, woos, yeahs, etc.)	
	level.scr_sound[ "generic" ][ "roadkill_ar2_catcalls" ] = "roadkill_ar2_catcalls";

	// (varitey pack of catcall, woos, yeahs, etc.)	
	level.scr_sound[ "generic" ][ "roadkill_ar3_catcalls" ] = "roadkill_ar3_catcalls";

	// Battalion is oscar mike!!!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_battalionom" ] = "roadkill_ar1_battalionom";

	// All right, we're oscar miiike!!!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_oscarmike" ] = "roadkill_cpd_oscarmike";

	// We're on the move!!!	
	level.scr_sound[ "generic" ][ "roadkill_ar3_onthemove" ] = "roadkill_ar3_onthemove";

	// Roger that!!	
	level.scr_sound[ "generic" ][ "roadkill_ar4_rogerthat" ] = "roadkill_ar4_rogerthat";

	// Hunter two breaking away.	
	level.scr_sound[ "generic" ][ "roadkill_fly_breakingaway" ] = "roadkill_fly_breakingaway";
//	
	// Copy Hunter Two.	
	level.scr_sound[ "generic" ][ "roadkill_hqr_copyhunter2" ] = "roadkill_hqr_copyhunter2";

	// All Hunter Two victors, keep an eye out for civvies, we�re not cleared to engage unless they fire first.	
	level.scr_sound[ "generic" ][ "roadkill_fly_eyeoutforciv" ] = "roadkill_fly_eyeoutforciv";

	// Scan the rooftops for hostiles. Stay frosty.	
	level.scr_sound[ "generic" ][ "roadkill_fly_scanrooftops" ] = "roadkill_fly_scanrooftops";

	// You see anything?	
	level.scr_sound[ "generic" ][ "roadkill_cpd_seeanything" ] = "roadkill_cpd_seeanything";

	// I got nothin'. This place is dead.	
	level.scr_sound[ "generic" ][ "roadkill_cpd_placeisdead" ] = "roadkill_cpd_placeisdead";

	// Huah.	
	level.scr_sound[ "generic" ][ "roadkill_ar3_huah" ] = "roadkill_ar3_huah";

	// Overlord, Hunter Two-One. We're passing tunnel Harvey, cross street Elizabeth.	
	level.scr_sound[ "generic" ][ "roadkill_fly_crossstreeteliz" ] = "roadkill_fly_crossstreeteliz";

	// Roger that, Hunter Two-One, proceed with caution.	
	level.scr_sound[ "generic" ][ "roadkill_hqr_caution" ] = "roadkill_hqr_caution";

	// Stay frosty guys, this is the Wild West.	
	level.scr_sound[ "generic" ][ "roadkill_cpd_wildwest" ] = "roadkill_cpd_wildwest";

	// Roger that.	
	level.scr_sound[ "generic" ][ "roadkill_ar3_rogerthat" ] = "roadkill_ar3_rogerthat";
//	
	// Watch the alleys.	
	level.scr_sound[ "generic" ][ "roadkill_fly_watchalleys" ] = "roadkill_fly_watchalleys";

	// Covering.	
	level.scr_sound[ "generic" ][ "roadkill_ar3_covering" ] = "roadkill_ar3_covering";

	// Three foot-mobiles, balcony 12 o'clock. Probable militia.	
	level.scr_sound[ "generic" ][ "roadkill_ar1_probablemilitia" ] = "roadkill_ar1_probablemilitia";

	// Are they armed?	
	level.scr_sound[ "generic" ][ "roadkill_fly_aretheyarmed" ] = "roadkill_fly_aretheyarmed";

	// Negative, they're just watching us. 	
	level.scr_sound[ "generic" ][ "roadkill_ar1_watchingus" ] = "roadkill_ar1_watchingus";

	// Bet they're scouting us.	
	level.scr_sound[ "generic" ][ "roadkill_cpd_scoutingus" ] = "roadkill_cpd_scoutingus";

	// Doesn�t mean we can shoot 'em.	
	level.scr_sound[ "generic" ][ "roadkill_fly_doesntmean" ] = "roadkill_fly_doesntmean";

	// Allen, what are you shooting at, there's nothing there! Cease fire!	
	level.scr_sound[ "generic" ][ "roadkill_fly_nothingthere" ] = "roadkill_fly_nothingthere";

	// Allen! Cease fire! Cease fire!	
	level.scr_sound[ "generic" ][ "roadkill_fly_ceasefire" ] = "roadkill_fly_ceasefire";

	/*
	// Shot. Nine o'clock. Three hundred twenty six meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Twelve o'clock. One hundred fifteen meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Three o'clock. Three hundred fifty seven meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Six o'clock. Three hundred eighty one meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Seven o'clock. One hundred ten meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Six o'clock. Four hundred twenty three meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Eleven o'clock. One hundred eight meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Twelve o'clock. Eighty six meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Nine o'clock. Two hundred eighty five meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Six o'clock. Five hundred sixty meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Seven o'clock. Two hundred fifty two meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Nine o'clock. Three hundred eighty one meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Nine o'clock. Three hundred thirty two meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	
	// Shot. Three o'clock. Two hundred seventy seven meters
	level.scr_sound[ "generic" ][ ".	" ] = ".	";
	*/

	// Can you see 'em? Can you see 'em?	
	level.scr_sound[ "generic" ][ "roadkill_ar2_seeem" ] = "roadkill_ar2_seeem";

	// I don't see jack! 	
	level.scr_sound[ "generic" ][ "roadkill_cpd_dontseejack" ] = "roadkill_cpd_dontseejack";

	// All Hunter victors, this is Sergeant Foley. Prepare to engage, we're taking sniper fire from multiple directions.	
	level.scr_sound[ "generic" ][ "roadkill_fly_prepeng" ] = "roadkill_fly_prepeng";

	// Prepare to engage!! We're goin' in!!!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_goinin" ] = "roadkill_cpd_goinin";

	// This is it!!! Spin 'em up!!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_spinemup" ] = "roadkill_ar1_spinemup";

	// Watch twelve and six! 	
	level.scr_sound[ "generic" ][ "roadkill_ar3_12and6" ] = "roadkill_ar3_12and6";

	// We got a ton of contacts front and back!	
	level.scr_sound[ "generic" ][ "roadkill_ar4_tonacontacts" ] = "roadkill_ar4_tonacontacts";

	// Watch for movement! 	
	level.scr_sound[ "generic" ][ "roadkill_cpd_watchmvmnt" ] = "roadkill_cpd_watchmvmnt";

	// Taking fire, multiple contacts at long range!	
	level.scr_sound[ "generic" ][ "roadkill_ar5_longrange" ] = "roadkill_ar5_longrange";

	// Goin' forward!!	
	level.scr_sound[ "generic" ][ "roadkill_ar2_goinforward" ] = "roadkill_ar2_goinforward";

	// There they are!!!! Right there!	
	level.scr_sound[ "generic" ][ "roadkill_ar1_rightthere" ] = "roadkill_ar1_rightthere";

	// Shut that thing off!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_shutitoff" ] = "roadkill_cpd_shutitoff";

	// There they are, light 'em up!!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_lightemup" ] = "roadkill_cpd_lightemup";

	// There's too many of 'em! Back up back up!!!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_backup" ] = "roadkill_cpd_backup";

	// Get us outta here! Drive!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_outtahere" ] = "roadkill_cpd_outtahere";



	// Shot. Nine o'clock. Three hundred twenty six meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_9_326" ] = "roadkill_bmr_9_326";

	// Shot. Twelve o'clock. One hundred fifteen meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_12_115" ] = "roadkill_bmr_12_115";

	// Shot. Three o'clock. Three hundred fifty seven meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_3_357" ] = "roadkill_bmr_3_357";

	// Shot. Six o'clock. Three hundred eighty one meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_6_381" ] = "roadkill_bmr_6_381";

	// Shot. Seven o'clock. One hundred ten meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_7_110" ] = "roadkill_bmr_7_110";

	// Shot. Six o'clock. Four hundred twenty three meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_11_108" ] = "roadkill_bmr_11_108";

	// Shot. Eleven o'clock. One hundred eight meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_6_423" ] = "roadkill_bmr_6_423";

	// Shot. Twelve o'clock. Eighty six meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_12_86" ] = "roadkill_bmr_12_86";

	// Shot. Nine o'clock. Two hundred eighty five meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_9_285" ] = "roadkill_bmr_9_285";

	// Shot. Six o'clock. Five hundred sixty meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_6_560" ] = "roadkill_bmr_6_560";

	// Shot. Seven o'clock. Two hundred fifty two meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_7_252" ] = "roadkill_bmr_7_252";

	// Shot. Nine o'clock. Three hundred eighty one meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_9_381" ] = "roadkill_bmr_9_381";

	// Shot. Nine o'clock. Three hundred thirty two meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_9_332" ] = "roadkill_bmr_9_332";

	// Shot. Three o'clock. Two hundred seventy seven meters.	
	level.scr_sound[ "generic" ][ "roadkill_bmr_3_277" ] = "roadkill_bmr_3_277";


	// Clear!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_clear" ] = "roadkill_cpd_clear";
	// Two comin' out!		
	level.scr_sound[ "generic" ][ "roadkill_cpd_2cominout" ] = "roadkill_cpd_2cominout";
	// Three comin' out!		
	level.scr_sound[ "generic" ][ "roadkill_cpd_3cominout" ] = "roadkill_cpd_3cominout";


	// Up on the bridge, far side!!	
	level.scr_sound[ "generic" ][ "roadkill_cpd_farside" ] = "roadkill_cpd_farside";
	// They're going for the bridge-layer!!		
	level.scr_sound[ "generic" ][ "roadkill_cpd_bridgelayer" ] = "roadkill_cpd_bridgelayer";
	


	// Look! Look! The building's goin' down! (ad lib)	
	level.scr_sound[ "generic" ][ "roadkill_cpd_looklook" ] = "roadkill_cpd_looklook";
	// Yeahhhh..haha...it's down man...damnnn (ad lib)		
	level.scr_sound[ "generic" ][ "roadkill_cpd_hahaitsdown" ] = "roadkill_cpd_hahaitsdown";
	

	// Here they come!	
	level.scr_sound[ "generic" ][ "roadkill_AB2_heretheycome" ] = "roadkill_AB2_heretheycome";
	// Use your RPGs! Target the humvees!		
	level.scr_sound[ "generic" ][ "roadkill_AB2_rpgshumvees" ] = "roadkill_AB2_rpgshumvees";
	// Hassan! Move across the street for a better vantage point!		
	level.scr_sound[ "generic" ][ "roadkill_AB2_hassanmove" ] = "roadkill_AB2_hassanmove";
	// Die you American dogs!		
	level.scr_sound[ "generic" ][ "roadkill_AB2_diedogs" ] = "roadkill_AB2_diedogs";
	// Move move move!!		
	level.scr_sound[ "generic" ][ "roadkill_AB2_movex3" ] = "roadkill_AB2_movex3";
	
	// Get a flashbang in there!	
	level.scr_sound[ "generic" ][ "roadkill_fly_getflashbang" ] = "roadkill_fly_getflashbang";
	


	/*
	
	
	
	
	
	
	hold your dispersion
	hitman 2 says alpha cleared this town under heavy fire
	no causies were reported
	bro why'd they shoot at us
	contact right
	here we go boys
	yeah, happy birthday
	try not to get shot in the face
	
	2nd floor balcony, shoot that mfucker
	I'm losing her
	don't leave me
	shoot that fucking gunner
	hit that building
	
	increase the rate of fire
	get some get some
	gogogogogo
	
	slow down
	fuck mark nineteen's down
	I got one, saw his knee explode
	
	
	
	contact 12 o clock!

	//Here we go boys!
	Floor it, we're sitting ducks out here!
	
	Slow down, we're getting strung out!
	
	Hitman 2, this is Hitman-3 interrogative, our humvee got shot up and we're cut off from you, over.
	
	Solid copy hitman-3, hang tight, we'll make our way back to you, over.
	
	Hitman 2 solid copy.
	
	Assassin Actual to hitman 2, what's going on out there?
	
	Hitman 2 to Assassin Actual, we took fire got separated from hitman 3. We're working our way back around, over.
	
	Assassin 2 solid copy.
	
	We're cut off! (Enemy technical rams into the convoy)
	Push through!
	
	
	
	Hitman 3, this is hitman 2, give me a sitrep over.
	
	Hitman 3 copies, we're taking cover behind our disabled vehicles, over.
	
	
	
	
	
	
	
	Hitman 2 to Assassin Actual, over.
	This is Assassin Actual, send traffic over.
	Interrogative, we're taking small arms fire from multiple targets over.
	





After first jav kill:
Good work Brodsky. Keep it up, there are two more armored vehicles moving in. 

After second jav kill:
Nice one Brodsky.

Last jav kill:
That's the last of the armored vehicles sir.



They called in a 1000 pounder!



		
	*/
}