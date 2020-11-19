#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_climb;

#using_animtree( "generic_human" );
CONST_traceFX_dist = 10;

friendly_climb_anims()
{
	level.scr_anim[ "price" ][ "price_climb_intro" ] = %cliffhanger_price_intro;
	level.scr_anim[ "price" ][ "price_climb_intro_idle" ][ 0 ] = %cliffhanger_price_intro_idle;
	level.scr_anim[ "price" ][ "price_climb_start" ] = %cliffhanger_climb_up_start;
	level.scr_anim[ "price" ][ "price_climb_mid" ] = %cliffhanger_climb_up_mid;
	level.scr_anim[ "price" ][ "price_jump" ] = %cliffhanger_jump_price;
	level.scr_anim[ "price" ][ "price_idle" ][ 0 ] = %cliffhanger_jump_Price_idle;
	level.scr_anim[ "price" ][ "price_reach" ] = %cliffhanger_jump_Price_reach;
	
	level.scr_anim[ "generic" ][ "faux_player" ] = %invasion_parachute_ground_detach_idle;
	


	level.scr_anim[ "price" ][ "climb_catch" ] = %cliffhanger_gaz_bigjump;
	
	addNotetrack_customFunction( "price", "catch", ::price_catches_player, "climb_catch" );
	

	addNotetrack_customFunction( "price", "exhale", ::price_exhales );
	addNotetrack_customFunction( "price", "puff", ::price_puffs );

	addNotetrack_customFunction( "price", "attach_axe", ::attach_left_pick );
	addNotetrack_customFunction( "price", "detach_axe", ::detach_left_pick );
	addNotetrack_customFunction( "price", "attach_second_axe", ::attach_right_pick );
	addNotetrack_customFunction( "price", "detach_second_axe", ::detach_right_pick );
	addNotetrack_customFunction( "price", "attach_gun", ::price_gun_recall );

	addNotetrack_customFunction( "price", "attach_pick", ::attach_pick );
	addNotetrack_customFunction( "price", "pick_slide_left", ::pick_left_fx );
	
	addNotetrack_customFunction( "price", "pick_in_left", ::pick_left_hit );
	addNotetrack_customFunction( "price", "pick_in_right", ::pick_right_hit );
	addNotetrack_customFunction( "price", "pick_out_left", ::pick_left_out );
	addNotetrack_customFunction( "price", "pick_out_right", ::pick_right_out );
	
	addNotetrack_customFunction( "price", "footstep_right_small", ::ledge_scoot_fx_right );
	addNotetrack_customFunction( "price", "footstep_left_small", ::ledge_scoot_fx_left );
	addNotetrack_customFunction( "price", "footstep_right_large", ::ledge_scoot_fx_right );
	addNotetrack_customFunction( "price", "footstep_left_large", ::ledge_scoot_fx_left );
	addNotetrack_customFunction( "price", "bigjump_fx", ::big_jump_grab_fx );

	level.price_last_climb_hit = "none";
}

price_catches_player( price )
{
	if ( isdefined( level.rumble_ent ) )
		level.rumble_ent delete();
		
	level.player PlayRumbleOnEntity( "damage_light" );
	flag_set( "player_was_caught" );
}

big_jump_grab_fx( price )
{
	//iprintlnbold( "Exploder 4" );
	exploder( 4 );

}

ledge_scoot_fx_left( price )
{
	if ( flag( "reached_top" ) )
		return;

	//price traceFX_on_tag( "footstep_ice_climbing", "J_Ankle_LE", 5 );
	playfxontag( getfx( "footstep_ice_climbing" ), price, "J_Ankle_LE" );
}

ledge_scoot_fx_right( price )
{
	if ( flag( "reached_top" ) )
		return;
		
	//price traceFX_on_tag( "footstep_ice_climbing", "J_Ankle_RI", 5 );
	playfxontag( getfx( "footstep_ice_climbing" ), price, "J_Ankle_RI" );
}

pick_warning( warning )
{
	/#
	if ( !getdvarint( "debug_pickwarning" ) )
		return;
		
	if ( level.price_last_climb_hit == warning )
	{
		iprintlnbold( "Called same hit twice in a row (" + warning + ")" );
	}
	
	level.price_last_climb_hit = warning;
	#/
}

pick_left_hit( price )
{
	/# pick_warning( "left_in" ); #/

	// temporarily detach the other one so we can get the right tag
	price Detach( "weapon_ice_picker", "tag_inhand" );
	price traceFX_on_tag( "ice_pick", "TAG_ICE_PICKER_FX", CONST_traceFX_dist );
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
}

pick_left_fx( price )
{
	// temporarily detach the other one so we can get the right tag
	price Detach( "weapon_ice_picker", "tag_inhand" );
	price traceFX_on_tag( "ice_pick", "TAG_ICE_PICKER_FX", CONST_traceFX_dist );
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
}

pick_right_hit( price )
{
	/# pick_warning( "right_in" ); #/

	// temporarily detach the other one so we can get the right tag
	price Detach( "weapon_ice_picker", "tag_weapon_left" );
	price traceFX_on_tag( "ice_pick", "TAG_ICE_PICKER_FX", CONST_traceFX_dist );
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
}

pick_left_out( price )
{
	/# pick_warning( "left_out" ); #/

	// temporarily detach the other one so we can get the right tag
	price Detach( "weapon_ice_picker", "tag_inhand" );
	price traceFX_on_tag( "ice_pick_out", "TAG_ICE_PICKER_FX", CONST_traceFX_dist );
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
}

pick_right_out( price )
{
	/# pick_warning( "right_out" ); #/
	// temporarily detach the other one so we can get the right tag
	price Detach( "weapon_ice_picker", "tag_weapon_left" );
	price traceFX_on_tag( "ice_pick_out", "TAG_ICE_PICKER_FX", CONST_traceFX_dist );
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
}

attach_pick( price )
{
	if ( isdefined( price.picks ) )
		return;
	price.picks = true;
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
}

attach_left_pick( price )
{
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
}

attach_right_pick( price )
{
	price anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );
}

detach_left_pick( price )
{
	price Detach( "weapon_ice_picker", "tag_weapon_left" );
}

detach_right_pick( price )
{
	price Detach( "weapon_ice_picker", "tag_inhand" );
}

price_gun_recall( price )
{
	price gun_recall();
}

detach_picks()
{
	if ( !isdefined( self.picks ) )
		return;
	self.picks = undefined;
	self Detach( "weapon_ice_picker", "tag_weapon_left" );
	self Detach( "weapon_ice_picker", "tag_inhand" );
}

price_exhales( price )
{
	playfxOnTag( getfx( "cigar_exhale" ), price, "tag_eye" );
	wait( 6.5 );
	price Detach( "prop_price_cigar", "tag_inhand" );

}

price_puffs( price )
{
	playfxOnTag( getfx( "cigar_glow_puff" ), price, "tag_cigarglow" );
	wait( 1 );
	playfxOnTag( getfx( "cigar_smoke_puff" ), price, "tag_eye" );
}

right_stab_fx( player_model )
{
	level.player PlayRumbleOnEntity( "icepick_climb" );
	fx_tag_name = get_icepick_tag_name( "right" );
	fx_tag = spawn_icepick_fx_tag( player_model, fx_tag_name );
	fx_tag traceFX_on_tag( "player_ice_pick", "tag_origin", 10 );
	fx_tag delete();
}

stab_fx( arm_model, arm )
{
	level.player PlayRumbleOnEntity( "icepick_climb" );
	fx_tag_name = get_icepick_tag_name( arm );
	fx_tag = spawn_icepick_fx_tag( arm_model, fx_tag_name );
	fx_tag traceFX_on_tag( "player_ice_pick", "tag_origin", 10 );
	fx_tag delete();
}

stab_fx_current( arm_model )
{
	arm = level.arm_ent_globals.current_arm;
	stab_fx( arm_model, arm );
}

stab_fx_left( arm_model )
{
	arm = "left";
	stab_fx( arm_model, arm );
}

stab_fx_right( arm_model )
{
	arm = "right";
	stab_fx( arm_model, arm );
}

#using_animtree( "player" );
player_animations()
{
	level.scr_animtree[ "player_rig" ] 							 = #animtree;
	level.scr_model[ "player_rig" ] 							 = "ch_viewhands_player_gk_ar15";
	level.scr_anim[ "player_rig" ][ "big_jump" ] 				 = %player_icepicker_bigjump;
	level.scr_anim[ "player_rig" ]["climb_finish" ] = %player_icepicker_bigjump_end_getup;
	
	level.scr_anim[ "player_rig" ][ "big_jump_both_in" ] = %player_icepicker_bigjump_slide_both_in;
	level.scr_anim[ "player_rig" ][ "big_jump_both_out" ] = %player_icepicker_bigjump_slide_both_out;
	level.scr_anim[ "player_rig" ][ "big_jump_left" ] = %player_icepicker_bigjump_slide_left_in;
	level.scr_anim[ "player_rig" ][ "big_jump_right" ] = %player_icepicker_bigjump_slide_right_in;

	level.scr_anim[ "player_rig" ][ "first_pullup_left" ] = %player_icepicker_climbup_from_left;
	level.scr_anim[ "player_rig" ][ "first_pullup_right" ] = %player_icepicker_climbup_from_right;

	level.scr_anim[ "player_rig" ][ "controller_slide" ] = %cliffhanger_bigjump;
	level.scr_anim[ "player_rig" ][ "controller_climb" ] = %player_climb;

	level.scr_anim[ "player_rig" ][ "controller_both_in" ] = %slide_both_in;
	level.scr_anim[ "player_rig" ][ "controller_both_out" ] = %slide_both_out;
	level.scr_anim[ "player_rig" ][ "controller_left" ] = %slide_left;
	level.scr_anim[ "player_rig" ][ "controller_right" ] = %slide_right;

	//addNotetrack_customFunction( "player_rig", "detach_pick_fall", maps\_climb::detach_pick_2, "big_jump" );
	//addNotetrack_customFunction( "player_rig", "detach_pick", maps\_climb::detach_pick, "big_jump" );
	addNotetrack_customFunction( "player_rig", "start_gaz", maps\_climb::gaz_catches_player );
	addNotetrack_customFunction( "player_rig", "stab", ::right_stab_fx, "big_jump" );

	addNotetrack_customFunction( "player_rig", "stab", ::stab_fx_current, "climbing" );
	addNotetrack_customFunction( "player_rig", "stab_left", ::stab_fx_left, "climbing" );
	addNotetrack_customFunction( "player_rig", "stab_right", ::stab_fx_right, "climbing" );

}

get_anims_for_climbing_direction( anims, dir, arm )
{
	anims[ "root" ] = %climb_root;
	anims[ "player_climb_root" ] = %player_climb;
	anims[ "wrist" ] = %climb_wrist;
	anims[ "jump_down_start" ] = %player_icepicker_drop_down_start;
	anims[ "jump_down_end" ] = %player_icepicker_drop_down_end;
	anims[ "big_jump" ] = %player_icepicker_bigjump;
	anims[ "big_jump_both_in" ] = %player_icepicker_bigjump_slide_both_in;
	anims[ "big_jump_both_out" ] = %player_icepicker_bigjump_slide_both_out;
	anims[ "big_jump_left" ] = %player_icepicker_bigjump_slide_left_in;
	anims[ "big_jump_right" ] = %player_icepicker_bigjump_slide_right_in;
	anims[ "sleeve_flap" ] = %player_sleeve_flapping;
	anims[ "climb_finish" ] = %player_icepicker_bigjump_end_getup;

	anims[ "start_climb_left" ] = %player_icepicker_start_climb_up_left;
	anims[ "start_climb_right" ] = %player_icepicker_start_climb_up_right;
	anims[ "early_climb_left" ] = %player_icepicker_start_climb_up_left_early;
	anims[ "early_climb_right" ] = %player_icepicker_start_climb_up_right_early;


	if ( dir == "up" )
	{
		if ( arm == "right" )
		{
			anims[ "stab" ] = %player_icepicker_right_high_stab_a;
			anims[ "settle" ] = %player_icepicker_right_high_settle_a;
			anims[ "fail" ] = %player_icepicker_right_high_stab_fail_a;
			anims[ "idle" ] = %player_icepicker_right_idle;
			anims[ "additive" ] = %climb_right_additive;
			anims[ "additive_in" ] = %player_icepicker_right_high_stab_in;
			anims[ "additive_out" ] = %player_icepicker_right_high_stab_out;
			anims[ "wrist_in" ] = %player_icepicker_right_high_wrist_in;
			anims[ "wrist_out" ] = %player_icepicker_right_high_wrist_out;
			anims[ "fall" ] = %player_icepicker_right_fall;
			anims[ "fall_small" ] = %player_icepicker_right_fall_small;
		}
		else
		{
			anims[ "stab" ] = %player_icepicker_left_high_stab_a;
			anims[ "settle" ] = %player_icepicker_left_high_settle_a;
			anims[ "fail" ] = %player_icepicker_left_high_stab_fail_a;
			anims[ "idle" ] = %player_icepicker_left_idle;
			anims[ "additive" ] = %climb_left_additive;
			anims[ "additive_in" ] = %player_icepicker_left_high_stab_in;
			anims[ "additive_out" ] = %player_icepicker_left_high_stab_out;
			anims[ "wrist_in" ] = %player_icepicker_left_high_wrist_in;
			anims[ "wrist_out" ] = %player_icepicker_left_high_wrist_out;
			anims[ "fall" ] = %player_icepicker_left_fall;
			anims[ "fall_small" ] = %player_icepicker_left_fall_small;
		}

		anims[ "additive_in_strength" ] = 1;
		anims[ "additive_out_strength" ] = 1;
		return anims;
	}

	if ( dir == "right" )
	{
		if ( arm == "right" )
		{
			anims[ "additive" ] = %climb_right_additive;
			anims[ "additive_in_strength" ] = 0.5;
			anims[ "additive_out_strength" ] = 1;

		}
		else
		{
			anims[ "fail" ] = %player_icepicker_left_high_stab_fail_a;
			anims[ "additive" ] = %climb_left_additive;
			anims[ "additive_in_strength" ] = 0.5;
			anims[ "additive_out_strength" ] = 0.5;
		}
		return anims;
	}

	if ( dir == "left" )
	{
		if ( arm == "right" )
		{
			anims[ "fail" ] = %player_icepicker_right_high_stab_fail_a;
			anims[ "additive" ] = %climb_right_additive;
			anims[ "additive_in_strength" ] = 0.5;
			anims[ "additive_out_strength" ] = 0.5;
		}
		else
		{
			anims[ "additive" ] = %climb_left_additive;
			anims[ "additive_in_strength" ] = 0.5;
			anims[ "additive_out_strength" ] = 1;

			anims[ "vertical_corrector" ] = %climb_left_vertical_corrector;
		}
		return anims;
	}

	assertex( 0, "No dir " + dir );
}


#using_animtree( "script_model" );
climb_preview_anim()
{
	anims = [];
	anims[ "cliff_hero1_pose_A" ] = %cliff_hero1_pose_A;
	anims[ "cliff_hero1_pose_B" ] = %cliff_hero1_pose_B;
	anims[ "cliff_hero1_pose_C" ] = %cliff_hero1_pose_C;
	anims[ "cliff_hero1_pose_D" ] = %cliff_hero1_pose_D;
	anims[ "cliff_hero2_pose_A" ] = %cliff_hero2_pose_A;
	anims[ "cliff_hero2_pose_B" ] = %cliff_hero2_pose_B;
	anims[ "cliff_hero2_pose_C" ] = %cliff_hero2_pose_C;
	anims[ "cliff_hero2_pose_D" ] = %cliff_hero2_pose_D;
	anims[ "cliff_hero1_pose_jump1" ] = %cliff_hero1_pose_jump1;
	anims[ "cliff_hero1_pose_jump2" ] = %cliff_hero1_pose_jump2;
	anims[ "cliff_hero1_pose_jump3" ] = %cliff_hero1_pose_jump3;
	anims[ "cliff_hero1_pose_jump4" ] = %cliff_hero1_pose_jump4;
	anims[ "cliff_hero1_pose_jump5" ] = %cliff_hero1_pose_jump5;
	anims[ "cliff_hero1_pose_jump6" ] = %cliff_hero1_pose_jump6;
	self useanimtree( #animtree );
	animation = anims[ self.animation ];
	origin = GetStartOrigin( self.origin, self.angles, animation );
	angles = GetStartAngles( self.origin, self.angles, animation );
	thread climb_preview_animates( animation, origin, angles );

	self anim_spawn_tag_model( "weapon_ice_picker", "tag_weapon_left" );
	self anim_spawn_tag_model( "weapon_ice_picker", "tag_inhand" );

	for ( ;; )
	{
		if ( distance( level.player.origin, self.origin ) < 150 )
			break;
		wait( 0.05 );
	}
	self delete();
}

climb_preview_animates( animation, origin, angles )
{
	self endon( "death" );
	for ( ;; )
	{
		self.origin = origin;
		self.angles = angles;
		self setflaggedanim( "anim", animation, 1, 0, 1 );
		self waittillmatch( "anim", "end" );
	}
}
