#include maps\_utility;
#include maps\_vehicle;
#include maps\_vehicle_spline;
#include maps\_anim;
#include maps\_hud_util;
#include common_scripts\utility;



become_soap()
{
	AssertEx( !isdefined( level.soap ), "Too much soap!" );
	level.soap = self;
	self.animname = "soap";
	//self thread magic_bullet_shield();
	self make_hero();
}


become_price()
{
	level.price = self;
	self.health = 5000;
	self.animname = "price";
	self magic_bullet_shield();
	self make_hero();

	self.attackeraccuracy = 0;
	self.IgnoreRandomBulletDamage = true;
	//self forceUseWeapon( "ak47", "primary" );
	self gun_remove();
	//self Attach( "gulag_price_ak47", "tag_weapon_chest" );

	/*
	self waittill_any_timeout( 5, "death" );

	if ( !isalive( self ) )
	{	
		// the pow was killed
		SetDvar( "ui_deadquote", "@GULAG_PRICE_KILLED" );
		//maps\_utility::missionFailedWrapper();
		return;
	}
	
	*/
	self notify( "saved" );
	
	self waittill( "change_to_regular_weapon" );
	//self detach( "gulag_price_ak47", "tag_weapon_chest" );
	self forceUseWeapon( "ak47", "primary" );
	//self magic_bullet_shield();
}

become_redshirt()
{
	self.animname = "redshirt";
	level.redshirt = self;
	self magic_bullet_shield();
	self make_hero();
}

moderate_ai_moveplaybackrate()
{
	level endon( "cafeteria_sequence_begins" );
	ai = getaiarray( "allies" );
	
	min_playback = 1.00;
	min_dist = 50;
	max_playback = 1.00;
	max_dist = 200;

	// how much can the player sprint?	
	min_sprint = 1;
	max_sprint = 1.5;
	min_sprint_dist = 100;
	max_sprint_dist = 200;
	
	range_dist = max_dist - min_dist;
	range_playback = max_playback - min_playback;
	range_sprint = max_sprint - min_sprint;
	range_sprint_dist = max_sprint_dist - min_sprint_dist;
	
	if ( flag( "match_up_for_final_room" ) )
		return;

	level endon( "match_up_for_final_room" );

	
	max_speed_dif = 0.45; // the maximum difference in speed adjustment between the lead and last ai
	max_dist_dif = 200; // the distance at which to differ by max speed dif
	
	// the distance mods make the AI get a speed boost/slowdown to get them to the right place
	distance_mods = [];
	distance_mods[ "soap" ] = 20;
	distance_mods[ "redshirt" ] = -40;
	distance_mods[ "price" ] = -10;

	for ( ;; )
	{
		ai = [];
		ai[ "soap" ] = level.soap;
		ai[ "price" ] = level.price;
		ai[ "redshirt" ] = level.redshirt;

		if ( flag( "exit_collapses" ) )
		{
			distance_mods[ "soap" ] = 75;
			distance_mods[ "redshirt" ] = -25;
			distance_mods[ "price" ] = -40;
		}
		
		center = (0,0,0);
		ai_dist = [];
		foreach ( index, guy in ai )
		{
			center += guy.origin;
		
			// for adjusting the speed of the individual AI	
			dist = distance( guy.origin, level.friendly_endpoint );
			ai_dist[ index ] = dist + distance_mods[ index ];
		}
		center /= ai.size;

		// ==========================================================================================
		// for adjusting the speed of the individual AI	
		// ==========================================================================================
		lowest = 99999999;
		foreach ( dist in ai_dist )
		{
			if ( dist < lowest )
				lowest = dist;
		}
		
		ai_speedmod = [];
		foreach ( index, dist in ai_dist )
		{
			ai_dist[ index ] -= lowest;
		}

		highest = 0;
		foreach ( dist in ai_dist )
		{
			if ( dist > highest )
				highest = dist;
		}
		
		// 0.4
		// 200	ourdist
		
		current_speed_dif = highest * max_speed_dif / max_dist_dif;
		
		current_speed_dif *= 0.5; // lower the speed dif a bit
		
		//current_speed_dif *= 0.5; // you actually want it to be half cause we adjust it by the range from -1 to 1
		
		if ( current_speed_dif > max_speed_dif )
			current_speed_dif = max_speed_dif;
			
//		0 of 200
//		- half the range = 
//		-100 
//
		half_range = highest * 0.5;

		ai_speedmod = [];
		foreach ( index, dist in ai_dist )
		{
			dist -= half_range;
			dist /= abs( half_range );
			ai_speedmod[ index ] = dist * current_speed_dif;
		}

		
		// ==========================================================================================
		
		
		dist1 = distance( center, level.friendly_endpoint );
		dist2 = distance( level.player.origin, level.friendly_endpoint );
		dist = dist2 - dist1;
		
		level notify( "player_dist_from_squad", dist );
//		if ( dist > 1000 )
//			thread player_dies_to_cavein( 2 );
			
		old_dist = dist;
		
		
		dist -= min_dist;
		scale = dist / range_dist;
		
		if ( scale < 0 )
			scale = 0;
		else
		if ( scale > 1 )
			scale = 1;
		scale = 1 - scale;
		ai_playback = min_playback + range_playback * scale;
		
		
		//println( "dist " + old_dist + " ai_playback " + ai_playback );
		
		
		dist = old_dist - min_sprint_dist;
		scale = dist / range_sprint_dist;
		
		if ( scale < 0 )
			scale = 0;
		else
		if ( scale > 1 )
			scale = 1;
			
		sprint_speed = min_sprint + range_sprint * scale;

		if ( !flag( "exit_collapses" ) )
			setsaveddvar( "player_sprintSpeedScale", sprint_speed );
		
		
		if ( flag( "modify_ai_moveplaybackrate" ) )
		{
			foreach ( index, guy in ai )
			{
				guy.moveplaybackrate = ai_playback + ai_speedmod[ index ];
				if ( guy.moveplaybackrate > 1.15 )
					guy.moveplaybackrate = 1.15;
				
				//Print3d( guy.origin + (0,0,64), ai_speedmod[ index ], (1,1,0), 1, 1, 1 );
			}
		}
		
		/*
		foreach ( guy in ai )
		{
			guy.moveplaybackrate = ai_playback;
		}			
		*/
		
		/*
		foreach ( guy in ai )
		{
			if ( guy == level.price && flag( "price_speed_boost" ) )
				guy.moveplaybackrate += 0.15;
		}
		*/
		
		wait( 0.05 );
	}		
}		
		
		//println( "dist " + int( dist ) + " playback " + int ( ai_playback * 100 ) );
		
		// myrange
		//range_dist	range_playback
		
		


adjust_be_behind( guy )
{
	desired_dist = level.cafe_run_distances[ self.animname ][ guy.animname ];
	dist = distance( self.origin, guy.origin );

	speed_change = undefined;

	dot = get_dot( self.origin, self.angles, guy.origin );
	if ( dot < 0.8 )
	{
		// he should be in front of me, slow down
		speed_change = -0.15;
	}
	else
	{
	
		dist_dif = desired_dist - dist;
		dist_offset = 50;
		speed_offset = 0.15;
		
		/*
		dist_dif
		dist_offset	speed_offset
		35
		50	0.15
		*/
		
		speed_change = dist_dif * speed_offset / dist_offset;
		if ( speed_change > speed_offset )
		{
			speed_change = speed_offset;
		}
		else
		if ( speed_change < speed_offset * -1 )
		{
			speed_change = speed_offset * -1;
		}
	}
	
	self.moveplaybackrate = 1 + speed_change;
	num1 = self.moveplaybackrate;
	num2 = speed_change;
	
	num1 = int( num1 * 100 ) * 0.01;
	num2 = int( num2 * 100 ) * 0.01;
	
	Print3d( self geteye(), num1 + " (" + num2 + ")", (1,1,1), 1, 0.7 );
}

adjust_be_ahead_of( guy )
{
	desired_dist = level.cafe_run_distances[ self.animname ][ guy.animname ];
	dist = distance( self.origin, guy.origin );

	dot = get_dot( self.origin, self.angles, guy.origin );
	if ( dot > 0 )
	{
		// if he's ahead of us then we're negative distance relative to where we want to be
		dist *= -1;
	}
	
	dist_dif = desired_dist - dist;
	dist_offset = 50;
	speed_offset = 0.15;
	
	/*
	dist_dif
	dist_offset	speed_offset
	35
	50	0.15
	*/
	
	speed_change = dist_dif * speed_offset / dist_offset;
	if ( speed_change > speed_offset )
	{
		speed_change = speed_offset;
	}
	else
	if ( speed_change < speed_offset * -1 )
	{
		speed_change = speed_offset * -1;
	}
	
	self.moveplaybackrate = 1 + speed_change;
	num1 = self.moveplaybackrate;
	num2 = speed_change;
	
	num1 = int( num1 * 100 ) * 0.01;
	num2 = int( num2 * 100 ) * 0.01;
	
	Print3d( self geteye(), num1 + " (" + num2 + ")", (1,1,1), 1, 1 );
}

my_color_trail( color )
{
	self endon( "death" );
	org = self.origin;
	for ( ;; )
	{
		Line( self.origin, org, color, 1, 1, 50 );
		org = self.origin;
		wait( 0.05 );
	}
}

minor_earthquakes()
{
	level endon( "stop_minor_earthquakes" );
	
	min_eq = 0.15;
	max_eq = 0.25;
	
	dif_eq = max_eq - min_eq;
	
	min_phys = 0.20;
	max_phys = 0.30;
	
	dif_phys = max_phys - min_phys;
	first = true;
	
	for ( ;; )
	{
		scale = randomfloat( 1 );		
		if ( first )
		{
			first = false;
			scale = 1;
		}
		eq = min_eq + scale * dif_eq;
		phys = min_phys + scale * dif_phys;
		
		
		if ( randomint( 100 ) < 35 )
			player_gets_hit_by_rock();
			
		quake( eq, 3 + scale * 2, level.player.origin + randomvector( 1000 ), 5000 );
		angles = level.player getplayerangles();
		forward = anglestoforward( angles );
		org = level.player.origin + forward * 180;
		org = set_z( org, level.player.origin[2] + 64 );
		//PhysicsJitter( org, 350, 250, 0.05, 0.2 );
		vec = randomvector( phys );
		if ( vec[2] < 0 )
		{
			vec = set_z( vec, vec[2] * -1 );
		}
		PhysicsJolt( org, 350, 250, vec );
		//PhysicsExplosionSphere( org, 350, 250, 0.5 );
//		Print3d( org, ".", (1,0,0), 1, 1, 5 );
		
		wait( RandomFloatRange( 1, 5 ) );
	}
}

gulag_player_loadout()
{
	level.player takeallweapons();
	//level.player GiveWeapon( "m14_scoped" );
	level.player GiveWeapon( "m4m203_reflex_arctic" );
	//level.player GiveWeapon( "fraggrenade" );
	//level.player GiveWeapon( "flash_grenade" );
	//level.player SetOffhandSecondaryClass( "flash" );
	level.player SetViewModel( "ch_viewhands_gk_ar15" );
	level.player SwitchToWeapon( "m4m203_reflex_arctic" );
	//level.player GiveWeapon( "claymore" );
	//level.player SetActionSlot( 4, "weapon", "claymore" );
	//level.player GiveMaxAmmo( "claymore" );

	level.player SwitchToWeapon( "m14_scoped_arctic" );

}

stumble_trigger_think()
{
	level endon( "skip_stumble_trigger_think" );
	wait( 3 ); // for start points
	// the roller does the actual rotation
	eq_view_roller = getent( "eq_view_roller", "targetname" );

	player_ent = spawn_tag_origin();
	
	// move the roller to the ent that the player refers to for ground
	eq_view_roller.origin = player_ent.origin;
	player_ent linkto( eq_view_roller );
	
	level.player PlayerSetGroundReferenceEnt( player_ent );
	ent = spawn_tag_origin();
	
	if ( !flag( "exit_collapses" ) )
	{
		self waittill( "trigger", other );
		thread ceiling_collapse_begins();
		
		ducks = [];
		ducks[ ducks.size ] = "run_duck";
		ducks[ ducks.size ] = "run_flinch";
		ducks[ ducks.size ] = "run_stumble";
		
		ai = getaiarray( "allies" );
		assertex( ai.size == 3, "Huh, wasnt 3!" );
		
		foreach ( index, guy in ai )
		{
			guy thread stumble_anim( ducks[ index ] );
		}		
		
		quake( 0.25, 4, self.origin, 5000 );
		
		vec = randomvector( 0.6 );
		jolt_origin = level.player.origin;
		PhysicsJolt( jolt_origin, 350, 250, vec );
		
		/*
		angles = level.player getplayerangles();
		angles = ( 0, angles[ 1 ], 0 );
		ent.angles = angles;
		*/
		start_angles = eq_view_roller.angles;
	
		// spawn a reference ent to do the rotation on, because this rotation is at server framerate	
		ent.angles = eq_view_roller.angles;
		ent addpitch( 30 );
		ent addroll( 5 );
		
		eq_view_roller RotateTo( ent.angles, 1, 0.5, 0.5 );
		wait( 1 );
	
		ent addpitch( -35 );
		ent addroll( -15 );
		eq_view_roller RotateTo( ent.angles, 1, 0.5, 0.5 );
		wait( 1 );
	
		eq_view_roller RotateTo( start_angles, 1, 0.5, 0.5 );
	
		
		flag_wait( "exit_collapses" );
		flag_set( "controlled_player_rumble" );
		level.player PlayRumbleOnEntity( "heavy_3s" );
		delaythread( 3.0, ::flag_clear, "controlled_player_rumble" );
		
		thread stumble_baddie();
	}
	
	if ( !flag( "big_earthquake_hits" ) )
	{
			
		flag_wait( "big_earthquake_hits" ); // this is actually the second big earthquake
		trigger = getentwithflag( "big_earthquake_hits" );
		eq_view_roller = getent( trigger.target, "targetname" );
		jolt_origin = eq_view_roller.origin;
		start_angles = eq_view_roller.angles;
		
		// move the roller to the ent that the player refers to for ground
		eq_view_roller.origin = player_ent.origin;
	
		player_ent linkto( eq_view_roller );
	
		quake( 0.25, 4, self.origin, 5000 );
	
		vec = randomvector( 0.6 );
		PhysicsJolt( jolt_origin, 350, 250, vec );
	}	
		
	flag_wait( "player_falls_down" ); // during cafeteria ending

	quake( 0.35, 4, self.origin, 5000 );
	vec = randomvector( 0.6 );
	jolt_origin = level.player.origin;
	PhysicsJolt( jolt_origin, 350, 250, vec );
	
	flag_set( "controlled_player_rumble" );
	
	level.player PlayRumbleOnEntity( "light_3s" );
	level.player delaycall( 1.5, ::PlayRumbleOnEntity, "heavy_2s" );
	delaythread( 3.5, ::flag_clear, "controlled_player_rumble" );

	start_angles = eq_view_roller.angles;
	
	// move the roller to the ent that the player refers to for ground
	eq_view_roller.origin = player_ent.origin;

	// angle the ents with the player so its relative to the player's current view
	player_angles = level.player getplayerAngles();
	eq_view_roller.angles = ( 0, player_angles[ 1 ], 0 );
	ent.angles = eq_view_roller.angles;

	player_ent linkto( eq_view_roller );

	forward = anglestoforward( eq_view_roller.angles );
	right = anglestoright( eq_view_roller.angles );
	above_player = level.player.origin + (0,0,100 ) + forward * 50;
	
	level.player enabledeathshield( true );
	level.player setmovespeedscale( 0.25 );
	level.player DoDamage( ( level.player.health - 5 ) / level.player.damageMultiplier, above_player );
	level.player thread player_blur_manager();
	level.player disableweapons();
	
	time_until_buried = 1.9;
	// set up the mix track we're going to blend to
	thread maps\_ambient::use_eq_settings( "gulag_cavein", level.eq_mix_track );
	
	level.player SetEqLerp( 1, level.eq_main_track );
	// blend out the ambient and blend in to the mix track
	noself_delaycall( time_until_buried, ::AmbientStop, 2 );
	delaythread( time_until_buried, maps\_ambient::blend_to_eq_track, level.eq_mix_track, 2 );
	
	/*

	for ( i = 0; i < 3; i++ )
	{
		ent addyaw( 250 );
		ent addpitch( 18 );
		ent addroll( 18 );
		
		// player gets knocked sideways
		timer = 0.5;
		eq_view_roller RotateTo( ent.angles, timer, 0, 0 );
		wait( timer );
	}
	*/

//	Line( fx_org, fx_org + (0,0,-32), (1,0,0), 1, 0, 500 );
//	Line( fx_org, level.player.origin, (1,0,1), 1, 0, 500 );
	
	
	
	/*
	level.player delaycall( 0.05, ::setstance, "prone" );
	level.player delaycall( 0.5, ::allowcrouch, false );
	level.player delaycall( 0.5, ::allowstand, false );
	level.player delaycall( 0.5, ::ShellShock, "gulag_attack", 5, false );
	*/

	

	ent addyaw( 20 );
	ent addpitch( 35 );
	ent addroll( 25 );
	// player gets knocked sideways
	timer = 0.2;
	eq_view_roller RotateTo( ent.angles, timer, timer * 0.5, timer * 0.5 );
	wait( timer );
	
	thread fx_fall_around_player( eq_view_roller.angles );
//	Line( fx_org, fx_org + (0,0,-32), (1,0,0), 1, 0, 500 );
//	Line( fx_org, level.player.origin, (1,0,1), 1, 0, 500 );
	
	wait( 0.75 );


	// player wobbles left
	timer = 0.5;
//	ent addyaw( 20 );
	ent addpitch( -35 );
	ent addroll( -25 );
	eq_view_roller RotateTo( ent.angles, timer, timer * 0.5, timer * 0.5 );
	wait( timer );

	timer = 0.5;
//	ent addyaw( 20 );
	ent addpitch( 5 );
	ent addroll( -15 );
	eq_view_roller RotateTo( ent.angles, timer, 0, timer );
	wait( timer );
	timer = 0.55;
	ent addpitch( 15 );
	ent addroll( -60 );
	eq_view_roller RotateTo( ent.angles, timer, 0, 0 );

	level.player setstance( "prone" );
	wait( 0.65 );

	
	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay.alpha = 1;
	
//	level.player Shellshock( "nosound", 1, false );
	



/*
	level.player delaycall( 0.05, ::setstance, "prone" );
	level.player delaycall( 0.05, ::allowcrouch, false );
	level.player delaycall( 0.05, ::allowstand, false );
	level.player delaycall( 0.05, ::ShellShock, "gulag_attack", 5, false );
*/

	level.player allowcrouch( true );
	level.player allowstand( true );
	flag_clear( "player_falls_down" ); // during cafeteria ending
	wait( 1 );
	black_overlay destroy();


//	timer = 0.3;
//	eq_view_roller RotateTo( start_angles, timer, timer * 0.5, timer * 0.5 );

	
}

player_blur_manager()
{
	level endon( "time_to_evac" );
	level.player ent_flag_set( "player_no_auto_blur" );
	level.player SetBlurForPlayer( 12, 0.05 );
	clear_time = 0.8;
	clear_blur = 0.4;
	very_blur = 7;
	blur_time = 1;
	
	for ( ;; )
	{
		level.player SetBlurForPlayer( clear_blur, clear_time );
		wait( clear_time );
		level.player SetBlurForPlayer( very_blur, blur_time );
		wait( blur_time );
		very_blur *= 1.5;
	}
}

fx_fall_around_player( angles )
{
	forward = anglestoforward( angles );
	right = anglestoright( angles );
	above_player = level.player.origin + (0,0,100 ) + forward * 50;


	
	fx_org = level.player.origin + forward * 35 + right * -10 + ( 0, 0, 32 );
	/*
	fx = getfx( "0_ceiling_rock_explosion" );
//	thread player_ending_cavein();
	//thread player_dies_to_cavein( 2 );
	noself_delaycall( 0.05, ::PlayFX, fx, fx_org );
	noself_delaycall( 0.05, ::PlayFX, fx, fx_org );
	noself_delaycall( 0.05, ::PlayFX, fx, fx_org );
	noself_delaycall( 0.05, ::PlayFX, fx, fx_org );
	*/

//	fx = getfx( "0_ceiling_rock" );
	fx = getfx( "hallway_collapsing_huge" );
	for ( i = 0; i < 10; i++ )
	{
		fx_org = level.player.origin + forward * 35 + right * -10 + ( 0, 0, 180 );
		noself_delaycall( 0.05, ::PlayFX, fx, fx_org );
		wait( randomfloatrange( 0.1, 0.25 ) );
	}
}


/*
	fx = [];
	fx[ fx.size ] = "0_ceiling_collapse";
	fx[ fx.size ] = "0_ceiling_collapse_big";
	fx[ fx.size ] = "0_ceiling_collapse_huge";
	fx[ fx.size ] = "0_ceiling_collapse_huge";

	index = start_index;
	if ( !isdefined( index ) )
		index = 0;
	
	counts = [];
	counts[ 0 ] = 12;
	counts[ 1 ] = 15;
	counts[ 2 ] = 10;
	counts[ 3 ] = 20;

	thread black_death();

	last_org = level.player.origin;
	for ( ;; )
	{
		for ( i = 0; i < counts[ index ]; i++ )
		{
			angles = level.player getplayerangles();
			forward = anglestoforward( angles );
			vec = level.player.origin - last_org;
						
			
			org = level.player.origin + forward * 100 + vec * 10;
			org = set_z( org, level.player.origin[2] );
			
			trace = BulletTrace( org, org + (0,0,3000), false, undefined );
			current_fx = getfx( fx[ index ] );
			PlayFX( current_fx, trace[ "position" ] );
			last_org = level.player.origin;
			
			if ( randomint( 100 ) > 40 )
			{
				if ( index == 1 )
					level.player DoDamage( 5, randomvector( 500 ) );
				if ( index > 1 )
					level.player DoDamage( 15, randomvector( 500 ) );
			}
			wait( 0.05 );
		}
		
		if ( index == 2 )
		{
			level.player kill();
		}

		index++;
		if ( index >= fx.size )
			break;
	}
*/


	/*
	
	ent.angles = eq_view_roller.angles;
	ent addpitch( 10 );
	ent addroll( 12 );
	
	timer = 0.3;
	eq_view_roller RotateTo( ent.angles, timer, timer * 0.5, timer * 0.5 );
	wait( timer );

	ent addpitch( -15 );
	ent addroll( -18 );


	timer = 0.4;
	eq_view_roller RotateTo( ent.angles, timer, timer * 0.5, timer * 0.5 );
	wait( timer );

	timer = 0.3;
	eq_view_roller RotateTo( start_angles, timer, timer * 0.5, timer * 0.5 );

	*/
	
	
	/*
	eq_view_roller RotateRoll( -10, 1, 0.5, 0.5 );
	wait( 1 );
	eq_view_roller RotateRoll( 20, 1, 0.5, 0.5 );
	wait( 1 );
	eq_view_roller RotateRoll( -10, 1, 0.5, 0.5 );
	*/


	
	/*
	
	// each guy that hits the trigger does a unique stumble
	doing_anim = [];

	ducks = [];
	ducks[ ducks.size ] = "run_duck";
	ducks[ ducks.size ] = "run_flinch";
	ducks[ ducks.size ] = "run_stumble";
	
	index = 0;
	ent = spawnstruct();
	ent.eq = false;
	
	for ( ;; )
	{
		self waittill( "trigger", guy );
		if ( !isalive( guy ) )
			return;
		if ( isdefined( doing_anim[ guy.unique_id ] ) )
			continue;
		
		doing_anim[ guy.unique_id ] = true;
		animation = ducks[ index ];
		index++;
		if ( index >= ducks.size )
			index = 0;
			
		guy thread guy_ducks( animation, ent );
	}
	*/


stumble_anim( animation )
{
	animation = getgenericanim( animation );
	self.run_overrideanim = animation;
	self SetFlaggedAnimKnob( "stumble_run", animation, 1, 0.2, 1, true );
	wait( 1.5 );
	
	run_root = getgenericanim( "run_root" );
	old_time = 0;
	for ( ;; )
	{
		if ( self getAnimTime( run_root ) < old_time )
			break;
		old_time = self getAnimTime( run_root );
			
		wait( 0.05 );
	}
	self.run_overrideanim = undefined;
	self notify( "movemode" );
}

turnaround_trigger_think()
{
	// each guy that hits the trigger does a unique stumble
	doing_anim = [];

	ducks = [];
	ducks[ ducks.size ] = "reaction_180";
	ducks[ ducks.size ] = "reaction_180";
	ducks[ ducks.size ] = "run_180";
	
	index = 0;
	eq = false;
	
	for ( ;; )
	{
		self waittill( "trigger", guy );
		if ( !isalive( guy ) )
			return;
		if ( isdefined( doing_anim[ guy.unique_id ] ) )
			continue;
		
		doing_anim[ guy.unique_id ] = true;
		animation = ducks[ index ];
		index++;
		if ( index >= ducks.size )
			index = 0;
			
		guy thread guy_animates( animation );
	}
}

guy_animates( animation )
{
	orgs = getentarray( "friendly_changedirection_org", "targetname" );
	orgs = array_index_by_parameters( orgs );
	self thread maps\_spawner::go_to_node( orgs[ self.animname ], "struct" );
	self anim_generic( self, animation );
}

eq_happens()
{
	wait( 0.3 );
	quake( 0.25, 4, self.origin, 5000 );
}

guy_ducks( animation, ent )
{
	self endon( "death" );
	
	run_root = getgenericanim( "run_root" );

	old_time = self getAnimTime( run_root );
	for ( ;; )
	{
		if ( self getAnimTime( run_root ) < old_time )
			break;
		old_time = self getAnimTime( run_root );
			
		wait( 0.05 );
	}

	if ( isdefined( ent ) && !ent.eq )
	{
		ent.eq = true;
		quake( 0.25, 4, self.origin, 5000 );
	}
	
	
	self.run_overrideanim = getgenericanim( animation );

	old_time = self getAnimTime( run_root );
	for ( ;; )
	{
		if ( self getAnimTime( run_root ) < old_time )
			break;
		old_time = self getAnimTime( run_root );
			
		wait( 0.05 );
	}
		
	self.run_overrideanim = undefined;
	self notify( "movemode" );
//	runAnim = animscripts\run::GetRunAnim();
//	self setFlaggedAnimKnobLimited( "runanim", runAnim, 1, 0.1, 1, true );
}

hallway_flicker_light()
{
	off = "com_floodlight";
	on = "com_floodlight_on";
	
	model = self;
	light = getent( model.target, "targetname" );
	intensity = light getLightIntensity();
	
	/*
	for ( ;; )
	{
		off_count = randomint( 3 ) + 1;
		for ( p = 0; p < off_count; p++ )
		{
			count = randomint( 4 ) + 2;
			for ( i = 0; i < count; i++ )
			{
				light setLightIntensity( 0 );
				model setmodel( off );
				wait( 0.05 );
				light setLightIntensity( intensity );
				model setmodel( on );
				wait( 0.05 );
			}
			light setLightIntensity( 0 );
			model setmodel( off );
			wait( randomfloatrange( 0.2, 0.3 ) );
		}

		count = randomint( 4 ) + 2;
		for ( i = 0; i < count; i++ )
		{
			light setLightIntensity( 0 );
			model setmodel( off );
			wait( 0.05 );
			light setLightIntensity( intensity );
			model setmodel( on );
			wait( 0.05 );
		}

		light setLightIntensity( intensity );
		model setmodel( on );
		wait( randomfloatrange( 0.35, 0.45 ) );
		if ( flag( "exit_collapses" ) )
			break;
	}
	*/
	
	for ( ;; )
	{
		count = randomint( 3 ) + 2;
		for ( i = 0; i < count; i++ )
		{
			light setLightIntensity( 0 );
			model setmodel( off );
			wait( randomfloatrange( 0.05, 0.1 ) );
			light setLightIntensity( intensity );
			model setmodel( on );
			wait( 0.05 );
		}

		light setLightIntensity( intensity );
		model setmodel( on );
		wait( randomfloatrange( 1.2, 2 ) );
	}
}

ending_window_littlebird()
{
	self godon();
	hover = 50;
	self SetYawSpeed( 140, 80, 80 ); //, 60, overshoot percent );
	self SetHoverParams( 5, 5, hover );
}

ptest()
{
	for ( ;; )
	{
		angles = level.player getplayerangles();
		forward = anglestoforward( angles );
		org = level.player.origin + forward * 180;
		org = set_z( org, level.player.origin[2] + 64 );
		//PhysicsJitter( org, 350, 250, 0.05, 0.2 );
		vec = randomvector( 0.3 );
		PhysicsJolt( org, 350, 250, vec );
		//PhysicsExplosionSphere( org, 350, 250, 0.5 );
		Print3d( org, ".", (1,0,0), 1, 1, 5 );
		wait( 0.5 );
	}
}

first_hallway_collapse( pos )
{
	// 11.6
	wait( 10.3 );
	if ( distance( level.player.origin, pos ) > 700 )
		exploder( "first_hallway_collapse" );
}

stumble_baddie()
{
	spawner = getent( "stumble_baddie_spawner", "targetname" );
	
	// don't do it if the player is looking this way
	if ( within_fov_of_players( spawner.origin, 0.7 ) )
		return;
		
	if ( distance( spawner.origin, level.player.origin ) < 500 )
		return;

	thread first_hallway_collapse( spawner.origin );
	guy = spawner stalingradspawn();
	guy.animname = "stumble_baddie";
	
	ent = getstruct( guy.target, "targetname" );
	guy gun_remove();
	guy.allowDeath = true;
	guy endon( "death" );
	guy.health = 1;
	guy.ignoreme = true;
	guy.diequietly = true;
	setsaveddvar( "ragdoll_explode_force", 0 );
	ent anim_first_frame_solo( guy, "stumble" );
	wait( 8.4 );
	ent anim_single_solo( guy, "stumble" );
	guy kill();
}

trash_sound_think()
{
	self waittill( "trigger" );
	self play_sound_in_space( "scn_gulag_exp_trashcan_debris", self.org );
}

file_cabinet_show()
{
	models = getentarray( "file_cabinet_anim", "targetname" );
	array_thread( models, ::path_anim_setup );
	
	models = array_index_by_parameters( models );
	flag_wait( "enter_final_room" );
	//flag_wait( "reach_mound" );
	wait( 3 );
	
	models[ "1" ] path_anim( 0.2 );
	wait( 0.1 );	
	models[ "1" ] path_anim( 0.1  );	
	models[ "2" ] path_anim( 0.1 );	
	wait( 0.1 );
	models[ "1" ] path_anim( 0.3 );	
	models[ "2" ] path_anim( 0.3 );	
	models[ "3" ] path_anim( 0.3 );	
}

path_anim_setup()
{
	self.paths = self get_anim_paths();
	self.path_index = 0;
}

path_anim( time, time_in, time_out )
{
	path = self.paths[ self.path_index ];
	if ( !isdefined( path ) )
		return;
		
	self.path_index++;
	
	if ( isdefined( time_in ) )
	{
		self moveto( path[ "origin" ], time, time_in, time_out );
		self rotateto( path[ "angles" ], time, time_in, time_out );
	}
	else
	{
		self moveto( path[ "origin" ], time );
		self rotateto( path[ "angles" ], time );
	}
}


pillar_anim_show()
{
	models = getentarray( "pillar_anim", "targetname" );
	models = array_index_by_parameters( models );

	model1targ = getent( models["1"].target, "targetname" );
	model2targ = getent( models["2"].target, "targetname" );
	
	//model1targ thread maps\_debug::drawOriginForever();
	//model2targ thread maps\_debug::drawOriginForever();
	
	models["1"] linkto( model1targ );
	models["2"] linkto( models["1"] );
	model2targ linkto( model1targ );
	
	flag_wait( "enter_final_room" );
	//flag_wait( "reach_mound" );
	wait( 1 );
	
	targ2 = getent( model1targ.target, "targetname" );
	
	model1targ moveto( targ2.origin, 5, 1, 2 );
	model1targ rotateto( targ2.angles, 5, 1, 2 );
	wait( 5 );
	
	pillar_rotater = getent( "pillar_rotater", "targetname" );
	model1targ linkto( pillar_rotater );
	
	pillar_targ = getent( pillar_rotater.target, "targetname" );
	pillar_rotater rotateto( pillar_targ.angles, 2, 2, 0 );
	pillar_rotater moveto( pillar_targ.origin, 2, 2, 0 );
	wait( 2 );
	
	pillar_rotater = getent( pillar_rotater.target, "targetname" );
	model1targ linkto( pillar_rotater );
	
	timer = 0.75;
	pillar_targ = getent( pillar_rotater.target, "targetname" );
	pillar_rotater rotateto( pillar_targ.angles, timer );
	pillar_rotater moveto( pillar_targ.origin, timer );
	wait( timer );
	
	
	
	targets = getentarray( pillar_targ.target, "targetname" );
	targets = array_index_by_classname( targets );
	
	models["2"] linkto( model2targ );
	model2targ linkto( targets[ "script_origin_pillar2" ] );
	
	models["1"] linkto( model1targ );
	model1targ linkto( targets[ "script_origin_pillar1" ] );
	
	timer = 0.4;
	model1targ unlink();
	model1targ rotateto( targets[ "script_origin_pillar1" ].angles, timer );
	model1targ moveto( targets[ "script_origin_pillar1" ].origin, timer );
	
	timer = 1.5;
	model2targ unlink();
	model2targ rotateto( targets[ "script_origin_pillar2" ].angles, timer, 0, timer );
	model2targ moveto( targets[ "script_origin_pillar2" ].origin, timer, 0, timer );
	
	
	/*
	models = getentarray( "pillar_anim", "targetname" );
	array_thread( models, ::path_anim_setup );
	
	models = array_index_by_parameters( models );
	//flag_wait( "reach_mound" );
	wait( 1 );
	
	ents = [];
	foreach ( model in models )
	{
		ent = spawn( "script_origin", (0,0,0) );
		path = model.paths[ 0 ];
		ent.paths = model.paths;
		ent.origin = path[ "origin" ];
		ent.angles = path[ "angles" ];
		
		ent.path_index = 0;
		
		model linkto( ent );
		ents[ model.script_parameters ] = ent;
	}

	//fakeseys on the first one
	ents[ "1" ] path_anim( 0.1 );
	ents[ "2" ] path_anim( 0.1 );
	
	// first grind in
	ents[ "1" ] path_anim( 2, 0.2, 0.2 );
	ents[ "2" ] path_anim( 2, 0.2, 0.2 );
	wait( 2.5 );

	// now start to fall
	ents[ "1" ] path_anim( 2, 2, 0 );
	ents[ "2" ] path_anim( 2, 2, 0 );
	wait( 2 );

	// falling
	ents[ "1" ] path_anim( 0.25 );
	ents[ "2" ] path_anim( 0.25 );
	wait( 0.25 );
	
	// falling
	ents[ "1" ] path_anim( 0.25 );
	ents[ "2" ] path_anim( 0.25 );
	wait( 0.25 );

	// BAM, slide apart	
	ents[ "1" ] path_anim( 2, 0, 2 );
	ents[ "2" ] path_anim( 2, 0, 2 );
	*/
}

delete_tree_think()
{
	// this ent is just for ref, delete all links
	ent = self;
	for ( ;; )
	{
		if ( !isdefined( ent.target ) )
			break;
		newent = getent( ent.target, "targetname" );
		ent delete();
		ent = newent;
	}
	
	ent delete();
}

eqtest()
{
	/*
	channels = [];
	channels[ "item"      			 ] = true;
	channels[ "menu"      			 ] = true;
	channels[ "weapon"      		 ] = true;
	channels[ "voice"     			 ] = true;	
	channels[ "body"           		 ] = true;	
	channels[ "physics"        		 ] = true;	
	channels[ "local"          		 ] = true;	
	channels[ "music"          		 ] = true;	
	channels[ "announcer"      		 ] = true;	
	channels[ "auto"           		 ] = true;	
	channels[ "physics" 			 ] = true;
	channels[ "ambdist1"         	 ] = true;
	channels[ "ambdist2"			 ] = true;	
	channels[ "auto"                 ] = true;	
	channels[ "auto2"                ] = true;	
	channels[ "auto2d"               ] = true;	
	channels[ "autodog"              ] = true;	
	channels[ "explosiveimpact"      ] = true;	
	channels[ "element"              ] = true;	
	channels[ "vehicle"              ] = true;	
	channels[ "vehiclelimited"       ] = true;	
	channels[ "body"                 ] = true;	
	channels[ "reload"               ] = true;	
	channels[ "effects1"             ] = true;	
	channels[ "effects2"             ] = true;	
	channels[ "voice"                ] = true;	
	channels[ "mission"              ] = true;	

		*/
	/*
	main_track = level.eq_main_track;
	mix_track = level.eq_mix_track;

	// put the player on the mixtrack first
	level.player SetEqLerp( 1, main_track );

	filter = "highshelf";
	db = -25;
	freq = 1100;
	a = 5;
	
	foreach ( channel, _ in channels )
	{
		level.player seteqbands( channel, mix_track, "highshelf", db, freq, 1, "lowshelf", 2, freq, 1 );
	}
	
	*/

	AmbientStop( 0.5 );
	
	thread maps\_ambient::use_eq_settings( "gulag_cavein", level.eq_mix_track );
	
	// now blend to the mix track, which is our filter
	maps\_ambient::blend_to_eq_track( level.eq_mix_track, 2 );
}



player_dies_to_cavein( start_index )
{
	// buried
	if ( flag( "player_died_to_cave_in" ) )
		return;
	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	flag_set( "player_died_to_cave_in" );
	level.player enabledeathshield( false );
	
	fx = [];
	fx[ fx.size ] = "hallway_collapsing";
	fx[ fx.size ] = "hallway_collapsing_big";
	fx[ fx.size ] = "hallway_collapsing_huge";
	fx[ fx.size ] = "hallway_collapsing_huge";

	index = start_index;
	if ( !isdefined( index ) )
		index = 0;
	
	counts = [];
	counts[ 0 ] = 12;
	counts[ 1 ] = 15;
	counts[ 2 ] = 10;
	counts[ 3 ] = 20;

	AmbientStop( 0.5 );
	thread maps\_ambient::use_eq_settings( "gulag_cavein", level.eq_mix_track );
	thread maps\_ambient::blend_to_eq_track( level.eq_mix_track, 2 );
	thread black_death();

	last_org = level.player.origin;
	for ( ;; )
	{
		for ( i = 0; i < counts[ index ]; i++ )
		{
			angles = level.player getplayerangles();
			forward = anglestoforward( angles );
			vec = level.player.origin - last_org;
						
			
			org = level.player.origin + forward * 100 + vec * 10;
			org = set_z( org, level.player.origin[2] );
			
			trace = BulletTrace( org, org + (0,0,3000), false, undefined );
			current_fx = getfx( fx[ index ] );
			PlayFX( current_fx, trace[ "position" ] );
			last_org = level.player.origin;
			
			if ( randomint( 100 ) > 40 )
			{
				if ( index == 1 )
					level.player DoDamage( 5 / level.player.damageMultiplier, randomvector( 500 ) );
				if ( index > 1 )
					level.player DoDamage( 15 / level.player.damageMultiplier, randomvector( 500 ) );
					
				level.player PlayRumbleOnEntity( "damage_heavy" );
			}
			wait( 0.05 );
		}
		
		if ( index == 2 )
		{
			level.player kill();
		}

		index++;
		if ( index >= fx.size )
			break;
	}
}

player_ending_cavein()
{
	level endon( "stop_cavein" );
	
	fx = getfx( "player_cavein" );
	/*
	tag_origin = spawn_tag_origin();
	tag_origin.origin = level.player.origin + (0,0,60);
	tag_origin linkto( level.player );
	PlayFXOnTag( fx, tag_origin, "tag_origin" );
	*/
	
//	thread black_death();

//	wait( 1.2 );
	delay = 1.5;
	for ( ;; )
	{
		wait( delay );
		PlayFX( fx, level.player.origin + (0,0,60 ) );
		delay -= 0.75;
		if ( delay <= 0.2 )
			delay = 0.2;
	}
	
	/*
	fx = [];
	fx[ fx.size ] = "hallway_collapsing";
	fx[ fx.size ] = "hallway_collapsing_big";
	fx[ fx.size ] = "hallway_collapsing_huge";

	index = 0;
	
	counts = [];
	counts[ 0 ] = 4;
	counts[ 1 ] = 80;
	counts[ 2 ] = 80;

	thread black_death();

	last_org = level.player.origin;
	for ( ;; )
	{
		for ( i = 0; i < counts[ index ]; i++ )
		{
			angles = level.player getplayerangles();
			forward = anglestoforward( angles );
			vec = level.player.origin - last_org;
						
			
			org = level.player.origin + forward * 100 + vec * 10;
			org = set_z( org, level.player.origin[2] );
			
			trace = BulletTrace( org, org + (0,0,3000), false, undefined );
			current_fx = getfx( fx[ index ] );
			PlayFX( current_fx, trace[ "position" ] );
			last_org = level.player.origin;
			
			wait( 0.1 );
		}
		
		index++;
		if ( index >= fx.size )
			break;
	}
	*/
}

black_death()
{
	wait( 4.5 );
	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay fadeOverTime( 2.5 );
	black_overlay.alpha = 1;
	black_overlay.foreground = false;
	level waittill( "stop_cavein" );
	wait( 0.05 );
	black_overlay destroy();
}

trigger_damage_think()
{
	self waittill( "trigger" );
	ent = getstruct( self.target, "targetname" );
	RadiusDamage( ent.origin + (0,0,16), 32, 500, 500, level.player );
	wait( 0.2 );
	RadiusDamage( ent.origin - (0,0,16), 32, 500, 500, level.player );
//	Print3d( ent.origin, "x", (1,0,0), 1, 1, 50 );
}

chase_player_dies_if_goes_wrong_way()
{
	level.player endon( "death" );
	flag_wait( "chase_brush_kill_volume_activates" );
	wait( 2.5 ); // 2.3
	
	volume = getent( "player_cavein_kill_volume", "targetname" );
	time = 5;
	frames = time * 20;
	
	for ( i = 0; i < frames; i++ )
	{
		if ( level.player istouching( volume ) )
		{
			thread player_dies_to_cavein( 2 );
			return;
		}
		wait( 0.05 );
	}
	
}
	
chase_train_chases( dist, starter )
{
	level endon( "stop_chase_fx" );
	min_speed = 6.0; // 8.0; 
	max_speed = 16; // 20;
	min_dist = dist;
	max_dist = dist + 75;
	
	range_speed = max_speed - min_speed;
	range_dist = max_dist - min_dist;
	
	level.chasers[ starter ] = [];
	
	for ( ;; )
	{
		ai = getaiarray( "allies" );
		guy = getClosest( self.origin, ai );
		dist = distance( self.origin, guy.origin );

		level.chasers[ starter ][ "dist" ] = dist;
		
		dist -= min_dist;
		scale = dist / range_dist;

		if ( scale < 0 )
			scale = 0;
		else
		if ( scale > 1 )
			scale = 1;

		speed = min_speed + range_speed * scale;
		

		level.chasers[ starter ][ "speed" ] = speed;

		self Vehicle_SetSpeed( speed, 5, 5 );
		wait( 0.05 );
	}
}	

chase_brush_accellerates_to_max_speed( chase_vehicle, time, max_speed )
{
	frames = time * 20;
	
	for ( i = 0; i <= frames; i++ )
	{
		scale = i / frames;
		speed = max_speed * scale;
		if ( speed <= 0 )
			speed = 0.1;
		chase_vehicle Vehicle_SetSpeedImmediate( speed, speed, speed );
		wait( 0.05 );
	}
	
	wait( time );
}

chase_train()
{
	level notify( "collapse_fx_stop" );
	speed = 190; //186;
	speed = 270; //186;
	speed /= 19.76;
	speed = 6;
	
	chase_vehicle_spawner = getent( "chase_brush_vehicle", "targetname" );
	fx_vehicle = chase_vehicle_spawner vehicle_dospawn();
	level.fx_vehicle = fx_vehicle;
	fx_vehicle thread chase_train_fx();

	path = getvehiclenode( fx_vehicle.target, "targetname" );
	fx_vehicle attachpath( path );
	fx_vehicle startpath();
	
	
	time = 4;
	thread chase_brush_accellerates_to_max_speed( fx_vehicle, time, speed );
	thread chase_player_dies_if_goes_wrong_way();
	level.chasers = [];
	fx_vehicle thread chase_train_chases( 400, true );
	
	wait( 3.5 );
//	wait( 1.25 + 3.25 );
	chase_brush = getent( "chase_brush", "targetname" );
	chase_brush show();

	chase_vehicle_spawner = getent( "chase_brush_vehicle", "targetname" );
	chase_vehicle = chase_vehicle_spawner vehicle_dospawn();
	chase_vehicle thread chase_train_kills_player_if_it_gets_close();
	level.chase_vehicle = chase_vehicle;
	chase_vehicle attachpath( path );
	chase_vehicle startpath();
	chase_brush linkto( chase_vehicle );
	chase_vehicle thread chase_train_chases( 900, false );
	
	//chase_vehicle Vehicle_SetSpeedImmediate( speed, speed, speed );
	//fx_vehicle Vehicle_SetSpeedImmediate( speed, speed, speed );
	
	level waittill( "stop_chase_fx" );

	chase_vehicle delete();
}

chase_train_fx()
{
	level endon( "stop_chase_fx" );
	
	ent = spawn_tag_origin();
	
	fx = getfx( "hallway_collapsing_chase" );
	ent linkto( self, "tag_origin", (0,0,0), (0,0,-90) );
	//ent thread maps\_debug::drawtagforever( "tag_origin" );
	count = 5;
	for ( ;; )
	{
		angles = self.angles;
		forward = anglestoforward( angles );
		count--;
		if ( count <= 0 )
		{
			vec = randomvector( 0.125 );
			PhysicsJolt( level.player.origin + forward * 250, 250, 250, vec );
			count = randomint( 10 );
		}
		PlayFXOnTag( fx, ent, "tag_origin" );
		wait( 0.1 );
	}
}

chase_train_kills_player_if_it_gets_close()
{
	level endon( "stop_chase_fx" );
	
	black_screen();
	
	max_black = 400;
	min_black = 700;
	black_range = abs( max_black - min_black );

	for ( ;; )
	{
		org1 = level.player.origin;
		org1 = set_z( org1, 0 );

		org2 = self.origin;
		org2 = set_z( org2, 0 );
	
		level.chase_distance = distance( org1, org2 );
		chase_dist = level.chase_distance;
	
		// algebra!
		//1 - ( ( min_black - max_black ) / black_range ) = 1 - ( ( chase_dist - max_black ) / black_range );
		alpha = 1 - ( ( chase_dist - max_black ) / black_range );
		alpha = clamp( alpha, 0, 1 );
			
		level.black_overlay.alpha = alpha;
		level.black_overlay fadeOverTime( 0.2 );
		
		//Line( level.player.origin, self.origin, (1,0,1), 1, 0, 2 );
		
		//println( "distance " + distance( org1, org2 ) );
		if ( chase_dist < 260 )
		{
			// this function automatically early outs on second call
			thread player_dies_to_cavein( 2 );
		}
			
		wait( 0.1 );
	}
}


black_screen( _ )
{
	if ( isdefined( level.black_overlay ) )
	{
		level.black_overlay destroy();
		return;
	}
	
	hud = create_client_overlay( "black", 0, level.player );
	hud.alpha = 1;
	hud.foreground = false;
	
	level.black_overlay = hud;
}


ceiling_collapse_think()
{
	flag_wait( "rescue_begins" );
	org = self.origin;
	self.origin += (0,0,300);
	flag_wait( "exit_collapses" );

	self CastShadows();	
	script_delay();
	
	self moveto( org, 1, 0.2, 0 );
	Earthquake( 1.0, 4, org, 1000 );
}

set_friendly_endpoint_think()
{
	level.friendly_endpoint = self.origin;
	flag_wait( "exit_collapses" );
	
	
	new_org = getstruct( self.target, "targetname" );
	level.friendly_endpoint = new_org.origin;
	flag_clear( "friendlies_turn_corner" );
	flag_wait( "friendlies_turn_corner" );
	
	// This way this way!!!	
	level.redshirt thread dialogue_queue( "gulag_wrm_thisway" );

	hall_org = getstruct( new_org.target, "targetname" );
	level.friendly_endpoint = hall_org.origin;
	
	flag_wait( "friendlies_turn_to_cafeteria" );
	level.friendly_endpoint = self.origin;
}

ending_run_fx()
{
	if ( flag( "enter_final_room" ) )
		return;
	level endon( "enter_final_room" );
	
	level endon( "stop_ending_run_fx" );
	rocks = get_exploder_array( "wall_rock" );
	level.max_rocks = 3;
	
	level.ending_fx_min_dist = 280;
	level.ending_fx_max_dist = 700;
	level.ending_fx_dot = 0.8;
	
	foreach ( ent in rocks )
	{
		ent.flat_origin = flat_origin( ent.v[ "origin" ] );
		ent.last_occurred_time = 0;
	}
	
	
	for ( ;; )
	{
		exit_flag = flag( "exit_collapses" );
		
		rocks = array_randomize( rocks );
		origin = flat_origin( level.player.origin );
		angles = level.player.angles;
		forward = anglestoforward( angles );
		origin += forward * -350;
		
		array = [];
		foreach ( ent in rocks )
		{
			if ( !exit_flag && ent.v[ "fxid" ] == "ceiling_collapse_dirt1" )
				continue;
				
			if ( ent.last_occurred_time > gettime() - 1000 )
				continue;
			dist = distance( ent.flat_origin, origin );
			if ( dist < level.ending_fx_min_dist )
				continue;
			if ( dist < level.ending_fx_max_dist )
				continue;
			
			normal = vectorNormalize( ent.flat_origin - origin );
			dot = vectorDot( forward, normal );
			if ( dot < level.ending_fx_dot )
				continue;
			
			array[ array.size ] = ent;
			if ( array.size >= level.max_rocks )
				break;
		}
		
		foreach ( ent in array )
		{
			ent activate_individual_exploder();
			ent.last_occurred_time = gettime();
			wait( 0.1 );
		}
		wait( 0.1 );
	}
}

cafe_fx()
{
	flag_wait( "enter_final_room" );
	
	level endon( "stop_ending_run_fx" );
	rocks = get_exploder_array( "cafe_rock" );
	level.fx_fall_time = 0.07;

	for ( ;; )
	{
		rocks = array_randomize( rocks );
		foreach ( ent in rocks )
		{
			ent activate_individual_exploder();
			//ent.last_occurred_time = gettime();
			wait( level.fx_fall_time );
		}
		wait( 0.1 );
	}
}


ceiling_collapse_begins()
{
	level endon( "collapse_fx_stop" );
	org = getstruct( "ceiling_collapse_org", "targetname" );
	target = getstruct( org.target, "targetname" );
	angles = vectortoangles( target.origin - org.origin );
	dist = distance( org.origin, target.origin );
	forward = anglestoforward( angles );

	fx = [];
	fx[ fx.size ] = "hallway_collapsing";
	fx[ fx.size ] = "hallway_collapsing_big";
	fx[ fx.size ] = "hallway_collapsing_huge";

	thread playfx_collapse( org.origin, forward, dist, fx[0], 6 );
	wait( 3.5 );
	thread playfx_collapse( org.origin, forward, dist, fx[1], 3 );
	wait( 2.5 );
	thread playfx_collapse( org.origin, forward, 0, fx[2], 8 );
}

playfx_collapse( origin, forward, dist, fx_msg, time )
{
	level endon( "collapse_fx_stop" );
	ent = spawnstruct();
	ent endon( "stop" );
	ent delaythread( time, ::send_notify, "stop" );
	
	fx = getfx( fx_msg );
	wait_time = 0.5;
	for ( ;; )
	{
		org = origin + forward * randomfloat( dist );
		PlayFX( fx, org );
		wait( wait_time );
		wait_time -= 0.35;
		if ( wait_time < 0.5 )
			wait_time = 0.5;
	}
}

get_anim_paths()
{
	path = self;
	
	paths = [];
	for ( ;; )
	{
		if ( !isdefined( path.target ) )
			break;
			
		path = getent( path.target, "targetname" );
		
		array = [];
		array[ "angles" ] = path.angles;
		array[ "origin" ] = path.origin;
		array[ "model" ] = path;
		paths[ paths.size ] = array;
	}	
	
	foreach ( path in paths )
	{
		path[ "model" ] delete();
	}
	
	return paths;
}

friendly_car_slide_trigger()
{
	targ = getent( self.target, "targetname" );
	targ thread price_slide_box_topples();
	flag_wait( "exit_collapses" );

	for ( ;; )
	{
		self waittill( "trigger", other );
		
		if ( !isalive( other ) )
			continue;
			
		if ( other == level.redshirt )
			break;
	}
	
	if ( flag( "do_not_flip_box" ) )
	{
		wait( 0.35 );
		wait( 1.7 );
		flag_set( "match_up_for_final_room" );
		return;
	}
		
	targ notify( "topple" );	

	targ waittill( "trigger" );
	thread price_hurdles();
}

price_slide_box_topples()
{
	targets = getentarray( self.target, "targetname" );
	models = [];
	
	foreach ( target in targets )
	{
		models[ target.classname ] = target;
	}
	
	crate = models[ "script_model" ];
	models[ "script_brushmodel" ] linkto( crate );

	paths = crate get_anim_paths();
	
	self waittill( "topple" );
	crate delaythread( 0.25, ::play_sound_on_entity, "door_cargo_container_burst_open" );
	models[ "script_brushmodel" ] thread kill_player_on_touch();

	foreach ( path in paths )
	{
		crate moveto( path[ "origin" ], 0.1 );
		crate rotateto( path[ "angles" ], 0.1 );
		wait( 0.1 );
	}
	models[ "script_brushmodel" ] notify( "stop_killing" );
}

kill_player_on_touch()
{
	level.touchkill = self; // for debugging
	self endon( "stop_killing" );
	for ( ;; )
	{
		if ( level.player istouching( self ) )
		{
			level.player kill();
			return;
		}
		wait( 0.05 );
	}
}

price_hurdles()
{
	car_slide_org = getstruct( "car_slide_org", "targetname" );
	
	wait( 0.35 );
	car_slide_org thread anim_generic( level.redshirt, "slide_across_car" );
	wait( 1.7 );
	level.redshirt anim_stopanimscripted();
	flag_set( "match_up_for_final_room" );
	setsaveddvar( "player_sprintSpeedScale", level.default_sprint );
}

ambient_flicker_light_think()
{
	ent = spawnstruct();
	light = getent( self.target, "targetname" );
	
	turn_on[ "ch_street_wall_light_01_on" ] = "ch_street_wall_light_01_on";
	turn_on[ "ch_street_wall_light_01_off" ] = "ch_street_wall_light_01_on";

	turn_off[ "ch_street_wall_light_01_off" ] = "ch_street_wall_light_01_off";
	turn_off[ "ch_street_wall_light_01_on" ] = "ch_street_wall_light_01_off";
	
	turn_on[ "com_floodlight_on" ] = "com_floodlight_on";
	turn_on[ "com_floodlight" ] = "com_floodlight_on";

	turn_off[ "com_floodlight" ] = "com_floodlight";
	turn_off[ "com_floodlight_on" ] = "com_floodlight";
	
	ent.turn_on = turn_on;
	ent.turn_off = turn_off;
	ent.light = light;
	
	flicker_funcs = [];
	flicker_funcs[ "slow_flicker" ] = ::flicker_slow;
	
	ent.intensity = light getLightIntensity();
	
	if ( !isdefined( self.script_parameters ) )
		thread flicker_default( ent );
	else
		thread [[ flicker_funcs[ self.script_parameters ] ]]( ent );
}
		
flicker_default( ent )
{
	for ( ;; )
	{
		count = randomint( 5 ) + 2;
		for ( i = 0; i < count; i++ )
		{
			ent.light setLightIntensity( 0 );
			self setModel( ent.turn_off[ self.model ] );
			wait( 0.05 );
			ent.light setLightIntensity( ent.intensity );
			self setModel( ent.turn_on[ self.model ] );
			wait( 0.05 );
		}

		ent.light setLightIntensity( 0 );
		self setModel( ent.turn_off[ self.model ] );
		wait( randomfloatrange( 0.2, 0.3 ) );

		count = randomint( 5 ) + 2;
		for ( i = 0; i < count; i++ )
		{
			ent.light setLightIntensity( 0 );
			self setModel( ent.turn_off[ self.model ] );
			wait( 0.05 );
			ent.light setLightIntensity( ent.intensity );
			self setModel( ent.turn_on[ self.model ] );
			wait( 0.05 );
		}

		ent.light setLightIntensity( ent.intensity );
		self setModel( ent.turn_on[ self.model ] );
		wait( randomfloatrange( 0.2, 0.3 ) );
	}
}
		
flicker_slow( ent )
{
	for ( ;; )
	{
		count = randomint( 5 ) + 2;
		for ( i = 0; i < count; i++ )
		{
			ent.light setLightIntensity( 0 );
			self setModel( ent.turn_off[ self.model ] );
			wait( 0.1 );
			ent.light setLightIntensity( ent.intensity );
			self setModel( ent.turn_on[ self.model ] );
			wait( 0.1 );
		}

		ent.light setLightIntensity( ent.intensity );
		self setModel( ent.turn_on[ self.model ] );
		wait( randomfloatrange( 0.2, 0.3 ) );
	}
}


cafe_table_org_think()
{
	// these ents are associated by distance because a set of ents are in a prefab
	index = get_closest_index( self.origin, level.cafe_tables, 32 );
	if ( !isdefined( index ) )
		return;

	table = level.cafe_tables[ index ];
	level.cafe_tables[ index ] = undefined;
	
	ent = spawn( "script_origin", (0,0,0) );
	ent.origin = self.origin;
	ent.angles = self.angles;
	table linkto( ent );
	
	//ent thread maps\_debug::drawOriginForever();
	wait( 1 );
	
	
	target = getstruct( self.target, "targetname" );
	
	timer = 5;
	ent moveto( target.origin, timer, timer * 0.1, timer * 0.1 );
	ent rotateto( target.angles, timer, timer * 0.1, timer * 0.1 );
	
	frames = timer * 20;
	org = ent.origin + (0,0,32);
	for ( i = 0; i < frames; i++ )
	{
		PhysicsJolt( org, 350, 250, randomvector( 0.05 ) );
		wait( 0.05 );
	}
}

cafe_table_think()
{
	model = getent( self.target, "targetname" );
	model linkto( self );
}

cafe_table_eq_org_think()
{
	for ( ;; )
	{
		wait( randomfloatrange( 3, 17 ) );
		count = randomintrange( 4, 8 );
		for ( i = 0; i < count; i++ )
		{
			vec = randomvector( 0.18 );
			if ( vec[2] < 0 )
			{
				vec = set_z( vec, vec[2] * -1 );
			}
			
			PhysicsJolt( self.origin, 120, 80, vec );
			wait( 0.05 );
		}
	}
}

light_destructible_think()
{
	wait( randomfloatrange( 7, 20 ) );
	RadiusDamage( self.origin, 32, 500, 500 );
}

swing_light_think()
{
	ref_ent = spawn_tag_origin();
	
	old_angles = self.angles;
	range = 25;
	self SetLightFovRange( 50, 25 );

	for ( ;; )
	{
		ref_ent.angles = old_angles;
		pitch = randomfloatrange( range * -1, range );
		ref_ent addpitch( pitch );

		yaw = randomfloatrange( range * -1, range );
		ref_ent addyaw( yaw );
		
		self rotateto( ref_ent.angles, 1, 0.3, 0.3 );
		forward = anglestoforward( ref_ent.angles );
//		Line( self.origin, self.origin + forward * 100, (1,1,1), 1, 0, 20 );
		
		wait( 1 );
	}
	
}

evil_hidden_spawner()
{
	self hide();
	self setcontents( 0 );
	self.health = 50000;
	ent = getstruct( "weapon_drop_org", "targetname" );
	org = spawn_taG_origin();
	org.origin = ent.origin;
	org.angles = ent.angles;
	self linkto( org, "tag_origin", (0,0,0),(0,0,0) );
	self.team = "neutral";
	self.ignoreme = true;
	self.ignoreall = true;
	animation = getgenericanim( "gundrop_death" );
	org anim_generic_first_frame( self, "gundrop_death" );
	
	weapon = level.player getcurrentweapon();
	self forceUseWeapon( weapon, "primary" );
	wait( 0.05 );
	self unlink();
	
//	self Detach( "weapon_m4", "tag_weapon_right" );
	

	level waittill( "dropit" );
	wait( 0.30 );
	self SetAnim( animation, 1, 0, 0.55 );
	wait( 0.05 );	
	self DropWeapon( weapon, "right", 50000 );
	wait( 0.3 );

	org delete();
	self delete();
	
	weapon_impact_org = getstruct( "weapon_impact_org", "targetname" );
	
	delaythread( 0.20, ::play_sound_in_space, "physics_brick_default", weapon_impact_org.origin );
	delaythread( 0.20, ::play_sound_in_space, "physics_brick_default", weapon_impact_org.origin );
	delaythread( 0.20, ::play_sound_in_space, "physics_brick_default", weapon_impact_org.origin );
	delaythread( 0.20, ::play_sound_in_space, "physics_brick_default", weapon_impact_org.origin );
	delaythread( 0.20, ::play_sound_in_space, "physics_brick_default", weapon_impact_org.origin );

	/*
	wait( 0.30 );
	self SetAnim( animation, 1, 0, 0.95 );
	wait( 0.05 );	
	self DropWeapon( weapon, "right", 0 );
	*/
}

players_view_opens( player_rig )
{
	wait( 0.5 );
	//( linkto entity, tag, viewpercentag fraction, right arc, left arc, top arc, bottom arc, use tag angles  );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0, true );
	wait( 3.2 - 0.5 );
//	wait( 0.05 );
	//LerpViewAngleClamp( time, accel time, decel time, right arc, left arc, top arc, bottom arc );
	level.player LerpViewAngleClamp( 1, 0.5, 0.5, 17, 17, 12, 8 );
}

unslowmo()
{
	level.forced_slowmo_breach_slowdown = false;
}

white_punch_screen()
{
	white = create_client_overlay( "white", 0, level.player );
	white.alpha = 1;
	white fadeovertime( 1 );
	white.alpha = 0;
	wait 1;
	white destroy();
}

player_gets_knocked_out_by_price( player_rig )
{
	tag_origin = spawn_tag_origin();
	tag_origin LinkTo( player_rig, "tag_player", (0,0,0), (0,0,0) );

	//evil_hidden_spawner = getent( "evil_hidden_spawner", "targetname" );
	//evil_hidden_spawner thread add_spawn_function( ::evil_hidden_spawner );
	//evil_hidden_spawner spawn_ai();


	thread spawn_ak47();
	queue = gettime();
	level.queue_time = queue;
	level.q = level.queue_time;
	wait( 0.5 );
	delaythread( 0.5, ::unslowmo );
	
	level.forced_slowmo_breach_lerpout = 2;
	wait_for_buffer_time_to_pass( queue, 2.8 );
	

	level notify( "dropit" );
	level.player delaycall( 0.05, ::disableweapons );
	time = 0.25;
	level.price_breach_ent unlink();
	level.price_breach_ent moveto( level.price_breach_struct.origin, 0.5, 0.2, 0.2 );
	level.price_breach_ent rotateto( level.price_breach_struct.angles, 0.5, 0.2, 0.2 );
	level.price_breach_ent notify( "stop_following_player" );
	
	//noself_delayCall( 0.0, ::Earthquake, 0.2, 0.5, level.player.origin, 128 );
//	Earthquake( scale, duration, source, radius );
	noself_delayCall( 0.1, ::Earthquake, 1.0, 0.6, level.player.origin, 128 );
	delaythread( 0.0, ::white_punch_screen );
//	level.player delaycall( 0.1, ::SetBlurForPlayer, 20, 0 );
//	level.player delaycall( 0.3, ::SetBlurForPlayer, 0, 1.5 );
//	level.player delaycall( 0.5, ::SetBlurForPlayer, 0, 0.5 );

//	noself_delayCall( 0.1, ::SetBlur, 2.5, 0.1 );
//	noself_delayCall( 0.21, ::SetBlur, 0, 1 );

//	level.player PlayerSetGroundReferenceEnt( tag_origin );	
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", time, time * 0.4, time * 0.4 );
	delaythread( time, ::players_view_opens, player_rig );

	level notify( "breach_concludes" );
	level.player DoDamage( 50 / level.player.damageMultiplier, level.price.origin );

	
	

	// slow mo for a bit
	wait_for_buffer_time_to_pass( queue, 6.7 );
	
	//slowmo_start();
	//slowmo_setspeed_slow( 0.1 );
	//slowmo_setlerptime_in( 0.2 );
	//slowmo_lerp_in();


	// soap enters scene
	wait_for_buffer_time_to_pass( queue, 7.3 );

	//slowmo_setlerptime_out( 0.2 );
	//slowmo_lerp_out();
	//slowmo_end();

	wait_for_buffer_time_to_pass( queue, 24.6 );
	thread radio_dialogue( "gulag_hqr_getout" );
}

spawn_ak47()
{
	queue = gettime();
	wait( 4.2 );
	ak47 = spawn( "script_model", (0,0,0) );
	ak47.origin = (-4245.72, 1688.15, 167.671);
	ak47.angles = (63.0343, 48.6473, -14.4095);

	hide_parts = [];
	hide_parts[ "tag_acog_2" ] = true;
	hide_parts[ "tag_heartbeat" ] = true;
	hide_parts[ "tag_m203" ] = true;
	hide_parts[ "tag_red_dot_mars" ] = true;
	hide_parts[ "tag_shotgun" ] = true;
	hide_parts[ "tag_silencer" ] = true;
	hide_parts[ "tag_flash_silenced" ] = true;
	hide_parts[ "tag_motion_tracker" ] = true;
//	hide_parts[ "tag_heartbeat" ] = true;
//	hide_parts[ "tag_heartbeat" ] = true;

	ak47 setmodel( "gulag_price_ak47" );
	foreach ( part, _ in hide_parts )
	{
		//ak47 hidepart( part );
	}

//	ak47.origin = level.price gettagorigin( "tag_weapon_chest" );
//	ak47.angles = level.price gettagangles( "tag_weapon_chest" );	
	ak47 linkto( level.price, "tag_weapon_chest", (0,0,0), (0,0,0) );
	wait( 1.4 );
//	ak47 unlink();	
	println( "ak update info:" );
	println( "	ak47.origin = " + ak47.origin + ";" );
	println( "	ak47.angles = " + ak47.angles + ";" );
	
	wait_for_buffer_time_to_pass( queue, 11.3 );
	ak47 linkto( level.price, "tag_weapon_chest", (0,0,0), (0,0,0) );
	level.price waittill( "change_to_regular_weapon" );
	ak47 delete();
}

calculate_cafe_run_distances()
{
	// grab the required distances from placed ents
	cafe_distance_trackersA = getentarray( "cafe_distance_tracker", "targetname" );
	cafe_distance_trackersB = cafe_distance_trackersA;
	dists = [];
	
	foreach ( dist1 in cafe_distance_trackersA )
	{
		foreach ( dist2 in cafe_distance_trackersB )
		{
			if ( dist1 == dist2 )
				continue;
			
			name1 = dist1.script_parameters;
			name2 = dist2.script_parameters;
			dist = distance( dist1.origin, dist2.origin );
			dists[ name1 ][ name2 ] = dist;
		}	
	}

	level.cafe_run_distances = dists;
	
	foreach ( ent in cafe_distance_trackersA )
	{
		ent delete();
	}
}

cavein_spawner_think()
{
	self endon( "death" );
	flag_wait( "enemy_cavein" ); // exploder
	wait( 0.5 );
	for ( ;; )
	{
		RadiusDamage( self.origin, 35, 10, 10 );
		wait( 0.05 );
	}
}

new_interval()
{
	wait( 10 );
	self.interval = 64;
}

endlog_friendly_runout_settings()
{
	self.interval = 16;
	//self.noDodgeMove = true;
	thread new_interval();
	//self delaythread( 5.5, ::ramp_interval, 64, 4 );
//		self.run_overrideanim = getgenericanim( "panic_run" );
	self ent_flag_init( "run_into_room" );
	self.ignoresuppression = true;
	self.animplaybackrate = 1;
	self.moveTransitionRate = 1;
	self.moveplaybackrate = 1;
	self.sideStepRate = 1.35;
	self pushplayer( true );
	self.dontavoidplayer = true;
	self disable_ai_color();
	self.disablearrivals = true;
	self.goalradius = 45;
	self.pathrandompercent = 0;
	self.walkdist = 16;
	self.walkdistFacingMotion = 16;
	
	if ( self.animname == "redshirt" )
	{
		self waittillmatch( "single anim", "end" );
		self.moveplaybackrate = 1.1;
		wait( 1 );
		self.moveplaybackrate = 1.0;
	}

	/*
	if ( self.animname == "soap" )
	{
		self waittillmatch( "single anim", "end" );
		wait( 8 );
		self.moveplaybackrate = 0.96;
		wait( 12 );
		self.moveplaybackrate = 1.0;
	}
	*/
}

ramp_interval( num, time )
{
	frames = time * 20;
	for ( i = 0; i < frames; i++ )
	{
		dif = i / frames;
		self.interval = num * dif;
		wait( 0.05 );
	}
}
	
gulag_glass_shatter()
{
	default_delay = 0.3;
	delays = [];
	delays[ 0 ] = default_delay;
	delays[ 1 ] = default_delay;
	delays[ 2 ] = default_delay;
	delays[ 3 ] = default_delay;
	delays[ 4 ] = default_delay;
	
	index = 0;
	
	struct = getstruct( "glass_shatter_struct", "targetname" );
	for ( ;; )
	{
		RadiusDamage( struct.origin, 64, 350, 250 );
		delay = delays[ index ];
		index++;

		if ( !isdefined( delay ) )
		{
			delay = randomfloatrange( 0.3, 1.5 );
		}
		
		wait( delay );
		
		if ( !isdefined( struct.target ) )
			return;
		struct = getstruct( struct.target, "targetname" );
	}	
}

evac_slowmo()
{
	wait( 3.5 );
 	slowmo_start();

	slowmo_setspeed_slow( 0.4 );
	slowmo_setlerptime_in( 0.05 );
	slowmo_lerp_in();

	/*
	//wait( 8 );
	
	//wait( 1.75 );
	wait( 1.1 );

	slowmo_setspeed_slow( 0.8 );
	slowmo_setlerptime_in( 0.05 );
	slowmo_lerp_in();
	
	wait( 0.5 );
	//wait( 3 );

	slowmo_setspeed_slow( 0.4 );
	slowmo_setlerptime_in( 0.05 );
	slowmo_lerp_in();
	
	wait ( 3 - 1.6 );
	*/
	wait( 3 );
	

	outblend = 0.5;
	level notify( "blend_out_dof", outblend );
	slowmo_setlerptime_in( outblend );

 	slowmo_lerp_out();
 	
 	slowmo_end();
}

evac_dof()
{
	start = level.dofDefault;
	dof_all_blur = [];
	dof_all_blur[ "nearStart" ] = 50;
	dof_all_blur[ "nearEnd" ] = 100;
	dof_all_blur[ "nearBlur" ] = 10;
	dof_all_blur[ "farStart" ] = 100;
	dof_all_blur[ "farEnd" ] = 200;
	dof_all_blur[ "farBlur" ] = 4;
	level.dofDefault = dof_all_blur;
                       
	wait( 1.25 );    
                       
	dof_see_price = [];          
	dof_see_price[ "nearStart" ] = 1;
	dof_see_price[ "nearEnd" ] = 1;
	dof_see_price[ "nearBlur" ] = 4;
	dof_see_price[ "farStart" ] = 100;
	dof_see_price[ "farEnd" ] = 200;
	dof_see_price[ "farBlur" ] = 4;
	thread blend_dof( dof_all_blur, dof_see_price, 0.9 );
	
	wait( 1.5 );

	dof_see_soap = [];
	dof_see_soap[ "nearStart" ] = 0;
	dof_see_soap[ "nearEnd" ] = 150;
	dof_see_soap[ "nearBlur" ] = 10;
	dof_see_soap[ "farStart" ] = 300;
	dof_see_soap[ "farEnd" ] = 800;
	dof_see_soap[ "farBlur" ] = 4;
	thread blend_dof( dof_see_price, dof_see_soap, 0.3 );
	
	level waittill( "blend_out_dof", outblend );
	thread blend_dof( dof_see_soap, start, outblend );
	
}

die_soon()
{
	self endon( "death" );
	wait( RandomFloat( 3 ) );
	self.dieQuietly = true;
	self Kill();
}

soap_talks_to_heli()
{
	/*
	// Viper Six-Four, this is Bravo Six Actual! We're trapped in the mess hall at the northeast corner of the gulag, depth 100 meters!!! I need a four-point SPIE rig for emergency extraction over!	
	level.soap anim_single_solo( level.soap, "gulag_cmt_depth100" );
	
	// Roger on the SPIE rig - we're on the way, give us fifteen seconds.	
	radio_dialogue( "gulag_plp_15secs" );
		
	// We'll be dead in five!!! Move your arse man!!!	
	level.soap dialogue_queue( "gulag_cmt_deadinfive" );
	
	level waittill( "more_soap_dialogue" );	
	*/
	wait( 0.5 );
	
	// Six-Four, where the hell are you, over?!!!!	
//	level.soap dialogue_queue( "gulag_cmt_whereareyou" );
	wait( 2.8 );
//	wait( 3.2 );
	// Bravo Six, there's too much smoke, I can't see you I can't see you -	
	radio_dialogue( "gulag_plp_cantsee" );
}

set_new_ending_fx_dists()
{
	level.ending_fx_min_dist = 0;
	level.ending_fx_max_dist = 800;
	level.ending_fx_dot = 0.3;
}

cafe_falls_apart()
{
	thread fx_become_more_intense();
	thread earthquake_buildup();
	
	maps\_utility::fog_set_changes( "gulag_cafe_falls_apart", 5 );
	/*
	wait( 8 );
	black_overlay = create_client_overlay( "black", 0, level.player );
	black_overlay.alpha = 0;
	black_overlay fadeOverTime( 3 );
	black_overlay.alpha = 1;
	level waittill( "stop_cavein" );
	wait( 0.05 );
	black_overlay destroy();
	*/
}

earthquake_buildup()
{
	level notify( "stop_minor_earthquakes" );
	time = gettime();

	wait_for_buffer_time_to_pass( time, 2.9 );
	quake( 0.3, 1.4, level.soap.origin, 5000 );	
	
	wait_for_buffer_time_to_pass( time, 4.2 );
	thread player_ending_cavein();	
	
	wait_for_buffer_time_to_pass( time, 6.45 );
	
	quake( 0.45, 4, level.soap.origin, 5000 );	
	wait( 1 );
	quake( 0.45, 3, level.player.origin, 5000 );	
}

quake_rumble()
{
	if ( flag( "controlled_player_rumble" ) )
		return;

	level.player endon( "death" );

	rumbles = [];
	rumbles[ rumbles.size ] = "heavy_1s";		
	rumbles[ rumbles.size ] = "heavy_2s";
	rumbles[ rumbles.size ] = "heavy_1s";		
	rumbles[ rumbles.size ] = "heavy_2s";
	rumbles[ rumbles.size ] = "heavy_3s";
	rumbles[ rumbles.size ] = "light_1s";		
	rumbles[ rumbles.size ] = "light_2s";
	rumbles[ rumbles.size ] = "light_1s";		
	rumbles[ rumbles.size ] = "light_2s";
	rumbles[ rumbles.size ] = "light_1s";		
	rumbles[ rumbles.size ] = "light_2s";
	rumbles[ rumbles.size ] = "light_1s";		
	rumbles[ rumbles.size ] = "light_2s";
	rumbles[ rumbles.size ] = "light_3s";
	rumbles[ rumbles.size ] = "light_3s";
	
	rumble = random( rumbles );
	vec = randomvector( 1700 );
	PlayRumbleOnPosition( rumble, level.player.origin + vec );	
}

quake( mag, duration, org, range )
{
	//vec = randomvector( 5 );
	//PlayRumbleOnPosition( "heavy_3s", level.player.origin + vec );
	thread quake_rumble();
	

	Earthquake( mag, duration, org, range );
	level notify( "swing", mag );

	// artillery sound
	angles = ( randomint( 360 ), randomint( 360 ), randomint( 360 ) );
	forward = anglestoforward( angles );
	range = randomfloatrange( 500, 1000 );
	location = level.player.origin + forward * range;
	thread play_sound_in_space( "exp_artillery_underground", location );
}
	
fx_become_more_intense()
{
	time = 7;
	min = 0.01;
	max = level.fx_fall_time;
	range = max - min;
	
	frames = time * 20;
	
	for ( i = 0; i < frames; i++ )
	{
		dif = i / frames;
		dif = 1 - dif;
		level.fx_fall_time = min + range * dif;
		wait( 0.05 );
	}
}

cafe_lights_explode()
{
	wait( 3 );
	light_destructibles = getentarray( "light_destructible", "script_noteworthy" );
	array_thread( light_destructibles, ::light_destructible_think );
}

player_pushes_slab()
{
	if ( flag( "time_to_evac" ) )
		return;
	level endon( "time_to_evac" );
	
	for ( ;; )
	{
		flag_wait( "player_pushes_slab" );
		level.player disableweapons();
		flag_waitopen( "player_pushes_slab" );
		level.player enableweapons();
	}
}

rubble_think()
{
	if ( level.start_point == "evac" )
		return;
		
	offset = 240;
	self connectpaths();
	self.origin += ( 0, 0, offset * -1 );
	
	self hide();
	self notsolid();
	
	flag_wait( "enter_final_room" );
	wait( 4 );
	exploder( "cafeteria_collapse" );
	chase_brush = getent( "chase_brush", "targetname" );
	chase_brush unlink();
	thread player_touch_kill();
	self show();
	self solid();
	self moveto( self.origin + (0,0,offset), 4, 1, 3 );
	chase_brush moveto( chase_brush.origin + (0,0,-300), 4, 2 );
	wait( 4 );
	level notify( "stop_chase_fx" );
	chase_brush delete();
	self disconnectpaths();
	
}

player_touch_kill()
{
	level endon( "stop_chase_fx" );
	for ( ;; )
	{
		if ( level.player istouching( self ) )
			RadiusDamage( level.player.origin, 35, 10, 5 );
		wait( 0.05 );
	}
}

hunted_hanging_light()
{
	fx = getfx( "gulag_cafe_spotlight" );
	tag_origin = spawn_tag_origin();
	
	tag_origin LinkTo( self.lamp, "j_hanging_light_04", (0,0,-32), (0,0,0) );
	PlayFXOnTag( fx, tag_origin, "tag_origin" );
	
	flag_wait( "time_to_evac" );
	stopFXOnTag( fx, tag_origin, "tag_origin" );
}

swing_light_org_think()
{
	lamp = spawn_anim_model( "lamp" );
	lamp thread lamp_animates( self );
}

swing_light_org_off_think()
{
	lamp = spawn_anim_model( "lamp_off" );
	lamp thread lamp_animates( self );
}

lamp_animates( root )
{
	root.lamp = self;
	self.animname = "lamp"; // uses one set of anims
	self.origin = root.origin;
	self dontcastshadows();

	// cant blend to the same anim	
	odd = true;
	anims = [];
	anims[ 0 ] = self getanim( "swing" );
	anims[ 1 ] = self getanim( "swing_dup" );
	
	thread lamp_rotates_yaw();
	
	for ( ;; )
	{
		level waittill( "swing", mag );
		animation = anims[ odd ];
		off = !odd;
		self SetAnimRestart( animation, 1, 0.3, 1 );
		wait( 2.5 );
	}
}

lamp_rotates_yaw()
{
	ent = spawn_tag_origin();

	for ( ;; )
	{
		yaw = randomfloatrange( -30, 30 );
		ent addyaw( yaw );
		time = randomfloatrange( 0.5, 1.5 );
		self rotateto( ent.angles, time, time * 0.4, time * 0.4 );
		wait( time );
	}
}

swap_world_fx()
{
	wait( 3 );
	flag_clear( "enable_endlog_fx" );
	flag_clear( "disable_exterior_fx" );
}

orient_player_to_rig( player_rig )
{
	tag_origin = spawn_tag_origin();
//	angles = player_rig gettagangles( "tag_player" );
//	origin = player_rig gettagorigin( "tag_player" );
	tag_origin.origin = level.player.origin;
	tag_origin.angles = level.player.angles;
	wait( 0.05 );
	level.player PlayerSetGroundReferenceEnt( tag_origin );	
	wait( 5 );
	wait( 0.05 );
	tag_origin LinkToBlendToTag( player_rig, "tag_player", false );
//	tag_origin linkto( player_rig, "tag_player", (0,0,0),(0,0,0) );
//	tag_origin thread maps\_debug::drawtagforever( "tag_origin" );
}

map_spawners_to_starts( orgs )
{
	
	spawner = GetEnt( "price_spawner", "targetname" );
	spawner.origin = orgs[ "price" ].origin;
	spawner.angles = orgs[ "price" ].angles;
	spawner spawn_ai();

	spawner = GetEnt( "endlog_soap_spawner", "targetname" );
	spawner.origin = orgs[ "soap" ].origin;
	spawner.angles = orgs[ "soap" ].angles;
	spawner spawn_ai();
	
	spawner = getentarray( "endlog_redshirt_spawner", "targetname" )[ 0 ];
	spawner.origin = orgs[ "redshirt" ].origin;
	spawner.angles = orgs[ "redshirt" ].angles;
	spawner spawn_ai();
}

set_cafeteria_spotlight_dvars()
{

	setsaveddvar( "r_spotlightbrightness", "1.2" );
	setsaveddvar( "r_spotlightendradius", "1200" );
	setsaveddvar( "r_spotlightstartradius", "50" );
	setsaveddvar( "r_spotlightfovinnerfraction", "0.8" );
	setsaveddvar( "r_spotlightexponent", "2" );

}

player_gets_hit_by_rock()
{
	if ( flag( "time_to_evac" ) )
		return;
		
	vec = randomvector( 16 );
	vec = set_z( vec, 80 );
	if ( level.player.health > 80 )
		level.player DoDamage( 15 / level.player.damagemultiplier, level.player.origin + vec );
}

blend_in_player_movespeed()
{
	time = 2.5;
	dif = time / 20;
	
	for ( i = 0; i <= 1; i+= dif )
	{
		level.player SetMoveSpeedScale( i );
		wait( 0.05 );
	}
}
