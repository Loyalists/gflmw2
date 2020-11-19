#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\af_caves;
#include maps\_vehicle;

#using_animtree( "generic_human" );

// -----------------------
// --- PLAYER/AI STUFF ---
// -----------------------
teleport_to_node( node )
{
	self teleport_to_origin( node.origin, node.angles );
}

teleport_to_origin( origin, angles )
{
	if ( !IsDefined( angles ) )
	{
		angles = ( 0, 0, 0 );
	}

	if ( !IsPlayer( self ) )
	{
		self ForceTeleport( groundpos( origin ), angles );
		self SetGoalPos( self.origin );
	}
	else
	{
		org = level.player spawn_tag_origin();
		level.player PlayerLinkTo( org, "tag_origin", 1 );
		org MoveTo( origin, 0.05 );
		org RotateTo( angles, 0.05 );
		wait( 0.1 );
		level.player Unlink();
		org Delete();
	}
}

price_spawn()
{
	level.price = self;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price cqb_walk( "on" );
	level.price AllowedStances( "prone" );
}

turn_off_stealth()
{
	disable_stealth_system();

	waittillframeend;	// wait for stealth system to finish setting ignoreme

	level.player player_speed_percent( 100 );

	SetSavedDvar( "ai_friendlyFireBlockDuration", "2000" );

	level.price.maxsightdistsqrd = 8192 * 8192;
	level.price cqb_walk( "off" );
	level.price.neverEnableCQB = true;
	level.price PushPlayer( false );
	level.price.ignoreall = false;
	level.price.moveplaybackrate = 1.0;
	level.price.dontEverShoot = undefined;

	battlechatter_on( "allies" );
}

price_be_stealthy()
{
	//level.price.dontshootwhilemoving = true;  // SRS not sure if we need this
	level.price.dontEverShoot = true;
	level.price.baseaccuracy = 1;
	level.price.maxsightdistsqrd = level.price_stealth_road_sightDistSqrd;
}

price_be_lethal()
{
	level.price.dontEverShoot = undefined;
	level.price.baseaccuracy = 5000000;
	level.price.maxsightdistsqrd = level.price_weaponsfree_sightDistSqrd;
}

price_kill( guy )
{
	guy.dontattackme = undefined;
	guy.threatbias = 5000;
	guy.health = 1;

	level.price.favoriteenemy = guy;
}

price_goto_node_and_wait_for_player( nodeTN, dist )
{
	level.price notify( "price_goto_node_and_wait_for_player" );
	level.price endon( "price_goto_node_and_wait_for_player" );

	thread price_goto_node( nodeTN );
	node = GetNode( nodeTN, "targetname" );
	price_wait_for_player( dist, node );
}

// destinationEnt: wait for the player to get near the destination rather than near price
price_wait_for_player( dist, destinationEnt )
{
	if ( !IsDefined( dist ) )
	{
		dist = 150;
	}

	if ( IsDefined( destinationEnt ) )
	{
		while ( Distance( destinationEnt.origin, level.player.origin ) > dist )
		{
			wait( 0.05 );
		}
	}
	else
	{
		while ( Distance( level.price.origin, level.player.origin ) > dist )
		{
			wait( 0.05 );
		}
	}

	level notify( "player_near_price" );
}

price_goto_node( nodeTN, goalradius )
{
	level.price notify( "stop_going_to_node" );
	level.price notify( "price_goto_node" );
	level.price endon( "price_goto_node" );

	if ( !IsDefined( goalradius ) )
	{
		goalradius = 24;
	}

	level.price.goalradius = goalradius;
	node = GetNode( nodeTN, "targetname" );
	level.price SetGoalNode( node );
	level.price waittill( "goal" );

	level notify( "price_at_node" );
}

restrict_fov_until_stealth_broken()
{
	self endon( "death" );
	
	self.fovcosine = .95;
	flag_wait( "_stealth_spotted" );
	
	if( !IsAlive( self ) )
	{
		return;
	}
	
	self.fovcosine = .76;	
}

player_unsuppressed_weapon_warning()
{
	if ( flag( "unsuppressed_weapon_warning_played" ) )
	{
		return;
	}

	level notify( "player_unsuppressed_weapon_warning" );
	level endon( "player_unsuppressed_weapon_warning" );

	level endon( "_stealth_spotted" );
	level endon( "steamroom_start" );

	while ( 1 )
	{
		wait( 0.25 );

		while ( IsDefined( level.player_radio_emitter ) && IsDefined( level.player_radio_emitter.function_stack ) && level.player_radio_emitter.function_stack.size > 0 )
		{
			wait( 0.05 );
		}

		weap = level.player GetCurrentWeapon();
		if ( weap != level.primaryweapon && weap != level.secondaryweapon && weap != "mp5_silencer_reflex" && weap != "rappel_knife" && weap != "none" )
		{
			break;
		}
	}

	flag_set( "unsuppressed_weapon_warning_played" );
	
	// "Make sure you're using a suppressed weapon, otherwise we're dead."
	radio_dialogue( "afcaves_pri_suppressedweapon" );
}

player_falling_kill_trigger()
{
	trigs = GetEntArray( "player_falling_kill", "targetname" );
	array_thread( trigs, ::player_falling_kill_trigger_think );
}

player_falling_kill_trigger_think()
{
	self waittill( "trigger" );

	if ( flag( "descending" ) )
	{
		return;
	}

	flagstr = "player_falling_kill_in_progress";

	if ( flag( flagstr ) )
	{
		return;
	}
	else
	{
		flag_set( flagstr );
	}
	
	endTime = GetTime() + 2000;
	while( !level.player IsOnGround() && GetTime() < endTime )
	{
		wait( 0.05 );
	}
	
	if( level.player IsOnGround() )
	{
		level.player Kill();
	}
	else
	{
		maps\_utility::missionFailedWrapper();
	}

	//blackout = create_client_overlay( "black", 0, level.player );
	//blackout FadeOverTime( 2 );
	//blackout.alpha = 1;

	//level.player Kill();
}

player_falling_to_death()
{
	triggers = GetEntarray( "slide_to_death_triggers", "targetname" );	//includes all of Ned's remove_gun triggers and any other slide triggers I have added to ensure player slides to death
	array_thread( triggers,:: player_falling_to_death_think );
}

player_falling_to_death_think()
{
	level endon( "player_falling_to_death" );
	self waittill( "trigger" );
	level.player disableweapons();
	flag_clear( "can_save" );	//don't allow saving if we are falling/sliding to death
	level notify( "player_falling_to_death" );
}

scr_neverEnableCQB( state )
{
	self.neverEnableCQB = state;
}

set_threatbiasgroup( group )
{
	Assert( IsDefined( group ) );
	self SetThreatBiasGroup( group );
}

playerseek()
{
	self ClearGoalVolume();
	self SetGoalEntity( level.player );
}

be_aggressive()
{
	self.aggressivemode = true;
	//self enable_heat_behavior();
	self.doorFlashChance = .5;
}

is_dog()
{
	return( self.type == "dog" );
}

group_has_live_human( group )
{
	foreach ( ai in group )
	{
		if ( IsAlive( ai ) && !ai is_dog() )
		{
			return true;
		}
	}

	return false;
}

give_flashlight()
{
	self endon( "death" );
	self cqb_walk( "on" );
	self attach_flashlight();
}

attach_flashlight()
{
	PlayFXOnTag( level._effect[ "flashlight" ], self, "tag_flash" );
	self.have_flashlight = true;
}

patroller_do_cqbwalk()
{
	if ( IsDefined( self.script_patroller ) )
	{
		wait( 0.05 );
		self clear_run_anim();
	}

	self thread enable_cqbwalk();
	self.alertlevel = "alert";
	self.disablearrivals = undefined;
	self.disableexits = undefined;
	self.moveplaybackrate = .8;

	thread scan_when_idle();
}

scan_when_idle()
{
	self endon( "death" );
	self endon( "enemy" );
	self endon( "end_scan_when_idle" );
	self endon( "end_patrol" );

	while ( 1 )
	{
		self set_generic_idle_anim( "cqb_stand_idle_scan" );

		self waittill( "clearing_specialIdleAnim" );
	}
}

/* SRS DEPRECATED
friendly_adjust_movement_speed()
{
	self notify( "stop_adjust_movement_speed" );
	self endon( "death" );
	self endon( "stop_adjust_movement_speed" );
	
	for(;;)
	{
		wait .15;
		
		while( friendly_should_speed_up() )
		{
//			IPrintLnBold( "friendlies speeding up" );
			self.moveplaybackrate = 2.5;
			wait 0.05;
		}
		
		self.moveplaybackrate = 1.0;
	}
}

friendly_should_speed_up()
{
	prof_begin( "friendly_movement_rate_math" );
	
	if ( DistanceSquared( self.origin, self.goalpos ) <= level.goodFriendlyDistanceFromPlayerSquared )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	// check if AI is visible in player's FOV
	if ( within_fov( level.player.origin, level.player GetPlayerAngles(), self.origin, level.cosine[ "70" ] ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	prof_end( "friendly_movement_rate_math" );
	
	return true;
}
*/

force_weapon_when_player_not_looking( weaponName )
{
	self endon( "death" );
	while ( within_fov( level.player.origin, level.player GetPlayerAngles(), level.price.origin, level.cosine[ "45" ] ) )
	{
		wait 1;
	}
	self forceUseWeapon( weaponName, "primary" );
}

spawn_ai_group( aSpawners, doSafe, doStaggered )
{
	AssertEx( ( aSpawners.size > 0 ), "The array passed to array_spawn function is empty" );

	if ( !IsDefined( doSafe ) )
	{
		doSafe = false;
	}

	if ( !IsDefined( doStaggered ) )
	{
		doStaggered = false;
	}

	aSpawners = array_randomize( aSpawners );

	spawnedGuys = [];
	foreach ( index, spawner in aSpawners )
	{
		guy = spawner spawn_ai();
		spawnedGuys[ spawnedGuys.size ] = guy;

		if ( doStaggered )
		{
			if ( index != ( aSpawners.size - 1 ) )
			{
				wait( RandomFloatRange( .25, 1 ) );
			}
		}
	}

	if ( doSafe )
	{
		//check to ensure all the guys were spawned
		AssertEx( ( aSpawners.size == spawnedGuys.size ), "Not all guys were spawned successfully from array_spawn" );
	}

	return spawnedGuys;
}

// basically copied from move::moveCoverToCover(), with some modifications and hardcoded values
scripted_covercrouch_shuffle_left()
{
	self thread scripted_covercrouch_earlyout_notify( "barracks_player_near_stair_shooting_spot", level );
	level endon( "barracks_player_near_stair_shooting_spot" );

	node = self.scripted_shuffleNode;
	Assert( IsDefined( node ) );

	serverFPS = 20;
	serverSPF = 0.05;

	shuffleNodeType = "Cover Crouch";
	nodeForwardYaw = node.angles[ 1 ];

	moveDir = node.origin - self.origin;

	startAnim = %covercrouch_hide_2_shuffleL;
	shuffleAnim = %covercrouch_shuffleL;
	endAnim = %covercrouch_shuffleL_2_hide;

	blendTime = 0.4;

	startEndTime = GetNotetrackTimes( startAnim, "finish" )[ 0 ];

	startDist   = Length( GetMoveDelta( startAnim, 0, startEndTime ) );
	shuffleDist	 = Length( GetMoveDelta( shuffleAnim, 0, 1 ) );
	endDist		 = Length( GetMoveDelta( endAnim, 0, 1 ) );

	self ClearAnim( %body, blendTime );

	self AnimMode( "zonly_physics", false );

	remainingDist = Distance( self.origin, node.origin );

	if ( remainingDist > startDist )
	{
		self OrientMode( "face angle", nodeForwardYaw );

		self SetFlaggedAnimRestart( "shuffle_start", startAnim, 1, blendTime );
		self animscripts\shared::DoNoteTracks( "shuffle_start" );
		self ClearAnim( startAnim, 0.2 );
		remainingDist -= startDist;

		blendTime = 0.2;// reset blend for looping move
	}
	else
	{
		self OrientMode( "face angle", node.angles[ 1 ] );
	}

	playEnd = false;
	if ( remainingDist > endDist )
	{
		playEnd = true;
		remainingDist -= endDist;
	}

	loopTime = GetAnimLength( shuffleAnim );
	playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;
	playTime = floor( playTime * serverFPS ) * serverSPF;

	self SetFlaggedAnim( "shuffle", shuffleAnim, 1, blendTime, 0.75 );
	self animscripts\shared::DoNoteTracksForTime( playTime, "shuffle" );

	// account for loopTime not being exact since loop animation delta isn't uniform over time
	for ( i = 0; i < 2; i++ )
	{
		remainingDist = Distance( self.origin, node.origin );
		if ( playEnd )
			remainingDist -= endDist;

		if ( remainingDist < 4 )
			break;

		playTime = loopTime * ( remainingDist / shuffleDist ) * 0.9;	// don't overshoot
		playTime = floor( playTime * serverFPS ) * serverSPF;

		if ( playTime < 0.05 )
			break;

		self animscripts\shared::DoNoteTracksForTime( playTime, "shuffle" );
	}

	if ( playEnd )
	{
		// hardcoded here, derived based on node type in animscript
		blendTime = 0.2;

		self ClearAnim( shuffleAnim, blendTime );
		self SetFlaggedAnim( "shuffle_end", endAnim, 1, blendTime );
		self animscripts\shared::DoNoteTracks( "shuffle_end" );

		// clear animation in moveCoverToCoverFinish if needed
	}

	self SafeTeleport( node.origin );
	self AnimMode( "normal" );

	self ClearAnim( %cover_shuffle, 0.2 );

	self.shuffleMoveInterrupted = undefined;
	self AnimMode( "none", false );
	self OrientMode( "face default" );

	self notify( "scripted_shuffle_done" );

	// now exit the cover
	level.scr_anim[ self.animname ][ "scripted_covercrouch_shuffle_exit" ] = %covercrouch_run_out_ML;
	self anim_single_run_solo( self, "scripted_covercrouch_shuffle_exit" );
}

scripted_covercrouch_earlyout_notify( killNotify, ent )
{
	self endon( "scripted_shuffle_done" );
	
	if( !IsDefined( ent ) )
	{
		ent = self;
	}
	
	ent waittill( killNotify );
	self notify( "scripted_shuffle_done" );
}


// ----------------------------------
// --- STEALTH NOSIGHT CLIP LOGIC ---
// ----------------------------------
clip_nosight_logic()
{
	if( IsDefined( self.script_parameters ) )
	{
		if( IsSubStr( self.script_parameters, "difficultymedium" ) )
		{
			if( level.gameskill > 1 )
			{
				self Delete();
				return;
			}
		}
	}
	
	self endon( "death" );

	flag_wait( self.script_flag );

	self thread clip_nosight_logic2();
	self SetCanDamage( true );

	self clip_nosight_wait();

	self Delete();
}

clip_nosight_wait()
{
	if ( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );

	self waittill( "damage" );
}

clip_nosight_logic2()
{
	self endon( "death" );

	flag_wait_either( "_stealth_spotted", "_stealth_found_corpse" );

	self Delete();
}


// ---------------------
// --- PLAYER RAPPEL ---
// ---------------------
delay_lerpViewAngleClamp()
{
	wait( 0.2 );
	level.player LerpViewAngleClamp( 1, 0.5, 0.5, 45, 45, 45, 45 );
}

should_stop_descend_hint()
{
	if ( flag( "rappel_end" ) )
		return true;

	return flag( "player_braked" );
}

player_gets_groundref_and_opens_fov( tag_origin )
{
	level.player PlayerSetGroundReferenceEnt( tag_origin );
	wait( 3.8 );
	open_up_fov( 0.5, tag_origin, "tag_origin", 20, 20, 12, 12 );
	tag_origin waittill( "open_fov" );
	open_up_fov( 0.5, tag_origin, "tag_origin", 25, 25, 15, 15 );
}

af_caves_rappel_behavior()
{
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "actionSlotsHide", 1 );
	SetSavedDvar( "hud_showStance", 0 );
	SetSavedDvar( "hud_drawhud", 0 );
	level.player DisableWeapons();
	level.player DisableOffhandWeapons();
	level.player DisableWeaponSwitch();
	level.player AllowCrouch( false );
	level.player AllowProne( false );

	stance = level.player GetStance();
	level.player SetStance( "stand" );

	if ( stance != "stand" )
		wait( 0.5 );


	old_weapon = level.player GetCurrentWeapon();

	weapon = "rappel_knife";
	level.player GiveWeapon( weapon );
	level.player SwitchToWeapon( weapon );

	ent = GetEnt( "rappel_animent", "targetname" );

	// first hook up
	player_rig = spawn_anim_model( "player_rig" );
	player_rig Hide();
	//player_rig thread maps\_debug::drawTagForever( "tag_player", ( 1, 1, 0 ) );

	ending_player_rig = spawn_anim_model( "player_rig" );
	ending_player_rig Hide();
	ending_player_rig DontCastShadows();
	//ending_player_rig thread maps\_debug::drawTagForever( "tag_player", ( 0, 1, 1 ) );

	node = GetEnt( "guard_assassinate", "script_noteworthy" );
	node anim_first_frame_solo( ending_player_rig, "rappel_kill" );


	player_rope = spawn_anim_model( "rope" );
	player_rope Hide();

	rig_and_rope[ 0 ] = player_rig;
	rig_and_rope[ 1 ] = player_rope;

	ent anim_first_frame( rig_and_rope, "rappel_hookup" );

//	wait( 0.05 );

	level.player_rig = player_rig;
	tag_origin = spawn_tag_origin();
	tag_origin LinkTo( player_rig, "tag_player", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	time = 0.5;

	tag_origin_start = spawn_tag_origin();
	tag_origin_start.angles = level.player GetPlayerAngles();
	tag_origin_start.origin = level.player.origin;

	level.player PlayerLinkTo( tag_origin_start );
	wait( 0.05 );	// why?
	level.player PlayerLinkToBlend( tag_origin, "tag_origin", time, 0.2, 0.2 );
	delayThread( time, ::player_gets_groundref_and_opens_fov, tag_origin );
	tag_origin_start Delete();

	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guard2_patrol );
	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guard2_kill_player );
	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guard2_death );
	array_spawn_function_noteworthy( "rappel_guard_1", ::rappel_guard1_kill_player );
	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guards_think );
	array_spawn_function_noteworthy( "rappel_guard_1", ::rappel_guards_think );

	rappel_baddie_spawners = GetEntArray( "rappel_baddie_spawner", "targetname" );
	array_spawn( rappel_baddie_spawners );

	delayThread( 6, ::display_hint, "begin_descent" );// 8

	player_rig delayCall( 0.6, ::Show );
	player_rope delayCall( 0.6, ::Show );
	player_rig DontCastShadows();

	flag_set( "player_hooking_up" );
	ent anim_single( rig_and_rope, "rappel_hookup" );
	tag_origin notify( "open_fov" );

	flag_set( "player_hooked_up" );

	player_rig Hide();

	// do some anim of starting carabiner here

	flag_set( "descending" );

	root_anim = player_rig getanim( "rappel_root" );

	player_rig SetAnim( root_anim, 0, 0, 1 );

	far_anim = player_rig getanim( "rappel_far" );
	far_anim_node = player_rig getanim( "rappel_far_node" );

	close_anim = player_rig getanim( "rappel_close" );
	close_anim_node = player_rig getanim( "rappel_close_node" );

	start_org = GetStartOrigin( ent.origin, ent.angles, far_anim );
	start_ang = GetStartAngles( ent.origin, ent.angles, far_anim );

	player_rig SetAnimLimited( close_anim, 1, 0, 1 );
	player_rig SetAnimLimited( close_anim_node, 1, 0, 1 );
	player_rig SetAnimLimited( far_anim, 0.01, 0, 1 );
	player_rig SetAnimLimited( far_anim_node, 0.01, 0, 1 );

	player_rig SetAnimKnob( root_anim, 1, 1, 1 );
	rappel_hookup = player_rig getanim( "rappel_hookup" );
	wait( 0.05 );
	player_rig ClearAnim( rappel_hookup, 0.2 );
	level.player_rig = player_rig;

	min_speed = 0.30;// the slowest speed we can rappel
	max_speed = 3.5;// the fastest rappelling speed
	speed = 1;// ignore this, internal variable

	anim_min_time = 0.80;
	anim_min_time_clamp_speed = max_speed;

	anim_max_time = 0.9;
	anim_max_time_clamp_speed = 1.5;


	//ending_min_speed = 2; // Min speed during the ending moment
	//ending_max_speed = 2; // max speed during ending moment
	ending_speed = 0.13;

	break_speed = 0.375;// how fast the brakes work, the higher the number the more brakes

	nobreak_rate = 0.006;// the speed that we accumulate accelleration while not braking
	nobreak_maxspeed = 0.12;	// the maximum accelleration while not braking
	nobreak_minspeed = 0.08;	// our accelleration the moment we stop braking
	nobreak_speed = nobreak_minspeed;// internal variable


	// effects the way the player pops off the cliff while rappelling
	close_anim_dest = 100;
	far_anim_dest = 0.1;
	far_anim_min = 0.1;
	far_anim_max = 50;
	far_anim_rate = 1;
	old_org = level.player.origin;

	// the amount of time you have to be moving at max speed to DIE if you dont brake.
	death_buffer = 20000;// no fail on easy / normal
	if ( level.gameskill >= 2 )
		death_buffer = 1500;


	//tag_origin thread liner();
	was_breaking = false;
	sin_index_old = 0;
	sin_index = 0;
	sin_index_max = 0;

	player_fell = false;
	last_time_braked = 0;
	speaker = Spawn( "script_origin", ( 0, 0, 0 ) );
	speaker.origin = level.player.origin;
	speaker LinkTo( level.player );
	death_fall_timer = undefined;
	speaker PlaySound( "scn_afcaves_rappel_start_plr" );

	able_to_break_time = GetTime() + 1500;

	for ( ;; )
	{
		// at % through the anim, go into ending mode with the knife
		if ( player_rig GetAnimTime( far_anim ) >= 0.94 )// .94
			flag_set( "rappel_end" );

		breaking = level.player AdsButtonPressed() || level.player AttackButtonPressed() && !flag( "rappel_end" );

		if ( breaking )
			flag_set( "player_braked" );

		if ( flag( "rappel_end" ) )
		{
			if ( level.player MeleeButtonPressed() )
				break;
		}

		// last_time_braked + the amount of time you have to fall before you can brake
		if ( breaking && GetTime() > last_time_braked + 5 && GetTime() > able_to_break_time )
		{
			nobreak_speed = nobreak_minspeed;
			speed -= break_speed;
			if ( speed < min_speed )
				speed = min_speed;

			player_rig SetAnimLimited( close_anim, 1, 0, speed );
			player_rig SetAnimLimited( far_anim, 1, 0, speed );

			far_anim_dest -= far_anim_rate * 3;
			if ( far_anim_dest <= far_anim_min )
				far_anim_dest = far_anim_min;

			if ( !was_breaking )
			{
				was_breaking = true;
				death_fall_timer = undefined;
				sin_index = 90;
				sin_index_max = 180;
				sin_index_old = sin_index;
				speaker StopSounds();
				if ( !flag( "rappel_end" ) )
					speaker PlaySound( "scn_afcaves_rappel_stop_plr" );
			}

		}
		else
		{
			animtime = player_rig GetAnimTime( far_anim );
			nobreak_speed += nobreak_rate;
			if ( nobreak_speed > nobreak_maxspeed )
				nobreak_speed = nobreak_maxspeed;

			speed += nobreak_speed;
			if ( speed > max_speed )
			{
				if ( !isdefined( death_fall_timer ) )
				{
					death_fall_timer = GetTime();
				}

				speed = max_speed;

				if ( GetTime() > death_fall_timer + death_buffer )
				{
					if ( !flag( "rappel_end" ) )
					{
						//level.player Unlink();

						if ( animtime >= 0.65 && animtime < anim_min_time )
						{
							player_fell = true;
							break;
						}
					}
				}
			}

			if ( flag( "rappel_end" ) )
			{
				// blend the current speed with the desired ending_speed
				dif = 0.15;
				speed = ending_speed * dif + speed * ( 1 - dif );
			}

			player_rig SetAnimLimited( close_anim, 1, 0, speed );
			player_rig SetAnimLimited( far_anim, 1, 0, speed );

			if ( was_breaking )
			{
				speaker StopSounds();
				if ( !flag( "rappel_end" ) )
					speaker PlaySound( "scn_afcaves_rappel_start_plr" );

				last_time_braked = GetTime();
				was_breaking = false;
				sin_index = 0;
				sin_index_max = 90;
				sin_index_old = sin_index;
			}



			if ( !flag( "rappel_end" ) )
			{
				far_anim_dest += far_anim_rate;
				if ( far_anim_dest >= far_anim_max )
					far_anim_dest = far_anim_max;
			}
			else
			{
				// use the
				far_anim_dest -= far_anim_rate * 3;
				if ( far_anim_dest <= far_anim_min )
					far_anim_dest = far_anim_min;
			}
		}

		player_rig SetAnimLimited( close_anim_node, close_anim_dest, 0, speed );
		player_rig SetAnimLimited( far_anim_node, far_anim_dest, 0, speed );
		old_org = level.player.origin;

		wait( 0.05 );
		animtime = player_rig GetAnimTime( far_anim );

		max_speed = graph_position( animtime, anim_min_time, anim_min_time_clamp_speed, anim_max_time, anim_max_time_clamp_speed );
		max_speed = clamp( max_speed, anim_max_time_clamp_speed, anim_min_time_clamp_speed );

		if ( animtime >= 0.98 )
		{
			break;
		}
	}

	speaker Delete();
	percentage = player_rig GetAnimTime( far_anim );

	if ( player_fell )
	{

		for ( ;; )
		{
			far_anim_dest += far_anim_rate;
			close_anim_dest -= far_anim_rate;
			speed += nobreak_speed;

			player_rig SetAnimLimited( close_anim_node, close_anim_dest, 0, speed );
			player_rig SetAnimLimited( far_anim_node, far_anim_dest, 0, speed );

			if ( player_rig GetAnimTime( far_anim ) >= 0.78 )
				break;

			wait( 0.05 );
		}

		//println( "break!" );
		//angles = ( -15, -100, 0 );
		angles = tag_origin.angles;
		angles = ( 0, angles[ 1 ], 0 );
		forward = AnglesToForward( angles );
		up = AnglesToUp( angles );
		velocity = forward * 750;
	//	velocity = up * 500;
		tag_origin Unlink();
		tag_origin MoveSlide( ( 0, 0, 0 ), 32, velocity );
		tag_origin delayThread( 0.75, ::hurt_player_on_bounce );

		thread player_decent_death();

		wait( 3.5 );

		level.player Kill();
	}
	else
	{

		for ( ;; )
		{
			if ( !isalive( level.player ) )
				break;

			if ( level.player MeleeButtonPressed() )
				break;
			wait( 0.05 );
		}

		//level.player Unlink();
		// since I removed it at the begining no point in reseting it here.
		// level.player PlayerSetGroundReferenceEnt( undefined );
		// level.player EnableWeapons();
		if ( flag( "player_failed_rappel" ) )
			return;

		wait( 0.1 );

		flag_set( "player_killing_guard" );

		if ( !isalive( level.player ) )
			return;
		level.player endon( "death" );

		knife = Spawn( "script_model", ( 0, 0, 0 ) );
		knife SetModel( "weapon_parabolic_knife" );
		knife Hide();
		knife DontCastShadows();
		knife LinkTo( ending_player_rig, "tag_weapon_left", ( 0, 0, 0 ), ( 0, 0, 0 ) );

//		ending_player_rig delayCall( 0.6, ::Show );
//		knife delayCall( 0.6, ::Show );

		thread hint_fade();

		node = GetEnt( "guard_assassinate", "script_noteworthy" );
		Assert( IsDefined( node ) );

		guard_1 = get_living_ai_array( "rappel_guard_1", "script_noteworthy" );
		Assert( IsAlive( guard_1[ 0 ] ) );
		enemy = guard_1[ 0 ];
		enemy.animname = "guard_1";

		guys = [];
		guys[ 0 ] = player_rig;
		guys[ 1 ] = enemy;


		enemy.a.nodeath = true;
//		node.origin += (0,0,8);
		level.player Unlink();
		ending_player_rig relink_player_for_knife_kill( percentage );
		ending_player_rig Show();
		knife Show();

		node.guard = enemy;
		//enemy delayThread( 1.5, ::clear_nodeath_and_kill );
		enemy gun_remove();

		thread lerp_savedDvar( "sm_sunSampleSizeNear", 0.0156, 0.5 );
		delayThread( 6.1, ::lerp_savedDvar, "sm_sunSampleSizeNear", 0.25, 1 );
		
		node anim_single_solo( ending_player_rig, "rappel_kill" );

		flag_clear( "descending" );
		ending_player_rig waittillmatch( "single anim", "end" );

		//Print3d( player_rig.origin, ".", (1,0,0), 1, 1, 1000 );
		ending_player_rig MoveTo( ending_player_rig.origin + ( 0, 0, 12 ), 0.4, .2, .2 );

		if ( old_weapon != level.secondaryweapon )
		{
			// switch to the default secondary if it's in the player's inventory
			weaps = level.player GetWeaponsListAll();
			foreach ( weap in weaps )
			{
				if ( weap == level.secondaryweapon )
				{
					old_weapon = level.secondaryweapon;
				}
			}
		}

		level.player PlayerSetGroundReferenceEnt( undefined );
		knife Delete();

		flag_set( "end_of_rappel_scene" );
		wait( 0.8 );

		level.player SwitchToWeapon( old_weapon );

		level.player Unlink();
		ending_player_rig Delete();
		player_rig Delete();

		SetSavedDvar( "compass", 1 );
		SetSavedDvar( "ammoCounterHide", 0 );
		SetSavedDvar( "actionSlotsHide", 0 );
		SetSavedDvar( "hud_showStance", 1 );
		SetSavedDvar( "hud_drawhud", 1 );
		level.player EnableOffhandWeapons();
		level.player EnableWeaponSwitch();
		level.player AllowCrouch( true );
		level.player AllowProne( true );
	}
}

// called when a notetrack hits
rappel_guard1_deathgurgle( guard1 )
{
	speaker = Spawn( "script_origin", guard1 GetEye() );
	speaker LinkTo( guard1 );
	
	speaker PlaySound( "scn_afcaves_rappel_kill_npc_dx", "sounddone" );
	speaker waittill( "sounddone" );
	
	speaker Unlink();
	speaker Delete();
}

player_decent_death()
{
	level.player waittill( "death" );

	level notify( "new_quote_string" );
	// You did not brake in time.
	SetDvar( "ui_deadquote", &"AF_CAVES_FELL_TO_DEATH" );
	blackout = create_client_overlay( "black", 0, level.player );
	blackout FadeOverTime( 1.5 );
	blackout.alpha = 1;
	
	missionfailedwrapper();
}

relink_player_for_knife_kill( percentage )
{
	waittillframeend;

	/*
	if ( percentage < 0.94 )
		time = 0.8;	
	else 
	if ( percentage < 0.96 )
		time = 0.6;	
	else
		time = 0.4;	
	*/

	time = 0.4;

//	time = 0.8;//0.4 // 0.866 sec is the length of the melee anim for the rappel_knife weapon
	level.player PlayerLinkToBlend( self, "tag_player", time, time * 0.5, time * 0.5 );// 0.5
	wait( time );

	level.player TakeWeapon( "rappel_knife" );
}

hurt_player_on_bounce()
{
	if ( !isalive( level.player ) )
		return;

	level.player endon( "death" );
	org = self.origin;
	old_vel = 0;
	maxhealth = level.player.maxhealth;
	for ( ;; )
	{
		vec = self.origin - org;
		vel = Length( vec );
		if ( vel < old_vel - 10 )
		{
			randomvec = randomvector( 1000 );
			level.player DoDamage( maxhealth * 0.35, randomvec );
			level.player Kill();
		}
		//println(  vel );

		if ( vel > old_vel )
			old_vel = vel;
		org = self.origin;
		wait( 0.05 );
	}
}

attach_model_if_not_attached( model, tag )
{
	hasModel = false;

	attachedCount = self GetAttachSize();
	for ( i = 0; i < attachedCount; i++ )
	{
		if ( self GetAttachModelName( i ) != model )
			continue;
		hasModel = true;
		break;
	}

	if ( !hasModel )
		self Attach( model, tag );
}

liner()
{
	for ( ;; )
	{
		Line( self.origin, level.player.origin );
		Print3d( self.origin, "x" );
		wait( 0.05 );
	}
}


// -----------------
// --- STEAMROOM ---
// -----------------
steamroom_door_crack_open()
{
	door = level.steamroom_door;

	yawopen = -50;
	yawclose = yawopen * -1;

	rotateTime = 0.25;

	door PlaySound( "door_cargo_container_push_open" );
	door RotateTo( door.angles + ( 0, yawopen, 0 ), rotateTime );
	door waittill( "rotatedone" );

	flag_wait( "steamroom_flash_out" );
	wait( 1 );

	door RotateTo( door.angles + ( 0, yawclose, 0 ), rotateTime );
	door waittill( "rotatedone" );
}

steamroom_door_full_open()
{
	door = level.steamroom_door;

	yawopen = -90;
	rotateTime = 0.5;

	door ConnectPaths();

	door PlaySound( "door_cargo_container_burst_open" );
	door RotateTo( door.angles + ( 0, yawopen, 0 ), rotateTime );
	door waittill( "rotatedone" );

	door DisconnectPaths();
}

// -----------------------------
// --- EXPLOSION EARTHQUAKES ---
// -----------------------------
setup_barrel_earthquake()
{
	array_thread( GetEntArray( "explodable_barrel", "targetname" ), ::barrel_earthquake_notify );

	level thread explosion_earthquake();
}

barrel_earthquake_notify()
{
	self waittill( "exploding" );
	level notify( "explosion_earthquake", self.origin );

	start = self.origin + ( 0, 0, 96 );
	end = self.origin + ( 0, 0, 1024 );
	ceiling = PhysicsTrace( start, end );
	if ( ceiling != end )
	{
		current_fx = getfx( "hallway_collapsing_big" );
		PlayFX( current_fx, ceiling );
	}
}

explosion_earthquake()
{
	fx = [];
	fx[ 0 ] = "ceiling_rock_break";
	fx[ 1 ] = "ceiling_rock_break";
	fx[ 2 ] = "ceiling_rock_break";
	fx[ 3 ] = "ceiling_rock_break";
	fx[ 4 ] = "ceiling_rock_break";
	fx[ 5 ] = "hallway_collapsing_big";
	fx[ 6 ] = "hallway_collapsing_big";
	fx[ 7 ] = "hallway_collapsing_big";
	fx[ 8 ] = "hallway_collapsing_huge";
	fx[ 9 ] = "hallway_collapsing_huge";

	fx_angles = [];
	fx_angles[ 0 ] = ( 90, 154, 11 );
	fx_angles[ 1 ] = ( 90, 154, 11 );
	fx_angles[ 2 ] = ( 90, 154, 11 );
	fx_angles[ 3 ] = ( 90, 154, 11 );
	fx_angles[ 4 ] = ( 90, 154, 11 );
	fx_angles[ 5 ] = ( 0, 0, 0 );
	fx_angles[ 6 ] = ( 0, 0, 0 );
	fx_angles[ 7 ] = ( 0, 0, 0 );
	fx_angles[ 8 ] = ( 0, 0, 0 );
	fx_angles[ 9 ] = ( 0, 0, 0 );

	while ( true )
	{
		level waittill( "explosion_earthquake", exploding_ent_origin );

		max_intensity = fx.size - 1;
		max_dist = 1500;

		dist = Distance( level.player.origin, exploding_ent_origin );
		intensity = ( max_dist - dist ) / max_dist;

		if ( intensity < 0 )
			intensity = 0.01;
		intensity = Int( ceil( max_intensity * intensity ) );

		duration = intensity / 2.5;

		Earthquake( .25, duration, level.player.origin, 1024 );

		for ( i = 0; i <= intensity; i++ )
		{
			direction = flat_angle( level.player.angles ) + ( 0, RandomInt( 80 ) - 40, 0 );

			forward = AnglesToForward( direction );
			start = level.player.origin + forward * 256 + ( 0, 0, 72 );
			end = start + ( 0, 0, 1024 );

			ceiling = PhysicsTrace( start, end );
			if ( ceiling == end )
				continue;

			fx_index = intensity - i;
			forward = AnglesToForward( fx_angles[ fx_index ] );
			up = AnglesToUp( fx_angles[ fx_index ] );
			current_fx = getfx( fx[ fx_index ] );
			PlayFX( current_fx, ceiling, forward, up );

			wait RandomFloat( .5 );
		}
	}
}


// ----------------------------------
// --- CONTROL ROOM SWINGING LAMP ---
// ----------------------------------
hunted_hanging_light()
{
	fx = getfx( "gulag_cafe_spotlight" );
	tag_origin = spawn_tag_origin();

	tag_origin LinkTo( self.lamp, "j_hanging_light_04", ( 0, 0, -64 ), ( 0, 0, 0 ) );
	PlayFXOnTag( fx, tag_origin, "tag_origin" );

	flag_wait( "sheppard_southwest" );
	StopFXOnTag( fx, tag_origin, "tag_origin" );
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
	self.animname = "lamp";// uses one set of anims
	self.origin = root.origin;
	self DontCastShadows();

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
		yaw = RandomFloatRange( -30, 30 );
		ent AddYaw( yaw );
		time = RandomFloatRange( 0.5, 1.5 );
		self RotateTo( ent.angles, time, time * 0.4, time * 0.4 );
		wait( time );
	}
}


// --------------
// --- MUSIC ---
// --------------
intro_music()
{
	ender = "player_hooking_up";
	level endon( ender );

	thread kill_intro_music( ender );
	
	alias = "af_caves_desertdrone";
	tracktime = MusicLength( alias );

	while ( !flag( ender ) )
	{
		MusicPlayWrapper( alias );
		wait( tracktime );
		music_stop( 1 );
		wait( 1 );
	}
}

kill_intro_music( ender )
{
	flag_wait( "player_hooking_up" );
	music_stop( 5 );
	wait( 5 );
}

stealth_music()
{
	flag_wait( "player_killing_guard" );
	
	flag1 = "steamroom_price_moveup_2";
	flag2 = "_stealth_spotted";
	
	
	stealthAlias = "af_caves_stealth";
	stealth_trackTime = MusicLength( stealthalias );
	extraPauseTime = 7;
	
	while( !flag( flag1 ) && !flag( flag2 ) )
	{
		MusicPlayWrapper( stealthAlias );
		
		endTime = GetTime() + milliseconds( stealth_trackTime );
		
		while( GetTime() < endTime && !flag( flag1 ) && !flag( flag2 ) )
		{
			wait( 0.1 );
		}
		
		music_stop( 1 );
		wait( 1 );
		
		endTime = GetTime() + milliseconds( extraPauseTime );
		while( GetTime() < endTime && !flag( flag1 ) && !flag( flag2 ) )
		{
			wait( 0.1 );
		}
	}
	
	music_stop( 1 );
	wait( 1 );
	MusicPlayWrapper( "af_caves_stealth_busted" );
}


// ----------------
// --- TV STUFF ---
// ----------------
tv_cinematic_think()
{
	// play cinematics on the TVs
	SetSavedDvar( "cg_cinematicFullScreen", "0" );

	while ( 1 )
	{
		flag_wait( "backdoor_barracks_tv" );
		thread tv_movie();

		flag_waitopen( "backdoor_barracks_tv" );
		level notify( "stop_cinematic" );
		StopCinematicInGame();
	}
}

tv_movie()
{
	level endon( "stop_cinematic" );

	while ( 1 )
	{
		// SRS TODO need new video
		CinematicInGameLoopResident( "gulag_securitycam" );

		wait( 5 );

		while ( IsCinematicPlaying() )
		{
			wait( 1 );
		}
	}
}

barracks_tv_light()// turns off when tv gets shot
{
	light = GetEnt( "tv_light", "targetname" );

	wait_for_targetname_trigger( "tv_trigger" );
	light SetLightIntensity( 0 );
}

barracks_destroy_tv()// destroy it when stealth is broken or if the player passes by the stealth area.
{
	flag_wait( "destroy_tv" );

	wait( RandomIntRange( 2, 4 ) );
	exploder( "stealth_broken" );// destroy the tv

	light = GetEnt( "tv_light", "targetname" );
	light SetLightIntensity( 0 );
}


// ---------------------
// --- CANYON CONVOY ---
// ---------------------
convoy_loop( vehicleTN, sFlagToStop, minWait, maxWait )
{
	canyon_convoy = GetEntArray( vehicleTN, "targetname" );
	thread drone_vehicle_flood_start( canyon_convoy, "canyon_convoy", minWait, maxWait );

	flag_wait( sFlagToStop );

	drone_vehicle_flood_stop( "canyon_convoy" );
}

drone_vehicle_flood_start( aSpawners, groupName, minWait, maxWait, noSound )
{
	level endon( "stop_drone_vehicle_flood" + groupName );
	vehicle = undefined;
	while ( true )
	{
		aSpawners = array_randomize( aSpawners );

		foreach ( spawner in aSpawners )
		{
			vehicle = spawner thread spawn_vehicle_and_gopath();
			vehicle thread friendlyfire_shield();
			vehicle godon();
			if ( IsDefined( noSound ) )
				vehicle Vehicle_TurnEngineOff();
			vehicle = undefined;
			wait( RandomFloatRange( minWait, maxWait ) );
		}
	}
}

drone_vehicle_flood_stop( groupName )
{
	level notify( "stop_drone_vehicle_flood" + groupName );
}


// ------------
// --- MISC ---
// ------------
get_global_fx( name )
{
	fxName = level.global_fx[ name ];
	return level._effect[ fxName ];
}

delete_corpse_in_volume( volume )
{
	Assert( IsDefined( volume ) );
	if ( self IsTouching( volume ) )
		self Delete();
}

half_particles_setup()
{
	//half buffer particles for PS3/PC
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
	}
	else
	{
		return;
	}

	flag_wait( "disable_half_buffer" );
	SetHalfResParticles( false );
}

// if any trigger is activated in a trigger array
waittill_trigger_array( triggers )
{
	for ( k = 1; k < triggers.size; k++ )
		triggers[ k ] endon( "trigger" );
	triggers[ 0 ] waittill( "trigger" );
}

hide_triggers( trigger_name )
{
	friendly_trigger = GetEntArray( trigger_name, "script_noteworthy" );
	foreach ( trigger in friendly_trigger )
	trigger trigger_off();
}

delete_by_targetname_safe( entTN )
{
	ent = GetEnt( entTN, "targetname" );
	if ( IsDefined( ent ) )
	{
		ent Delete();
	}
}

delete_and_kill_targeted_spawners_by_targetname_safe( entTN )
{
	ent = GetEnt( entTN, "targetname" );
	if( !IsDefined( ent ) )
	{
		return;
	}
	
	targets = [];
	spawners = [];
	if( IsDefined( ent.target ) )
	{
		targets = GetEntArray( ent.target, "targetname" );
	}
	
	foreach( target in targets )
	{
		if( IsSubStr( target.classname, "actor" ) )
		{
			spawners[ spawners.size ] = target;
		}
	}
	
	if( spawners.size )
	{
		array_call( spawners, ::Delete );
	}
	
	ent Delete();
}

milliseconds( seconds )
{
	return seconds * 1000;
}

seconds( milliseconds )
{
	return milliseconds / 1000;
}

dialogue( line )
{
	controlflag = "scripted_dialogue";
	flag_waitopen( controlflag );

	flag_set( controlflag );

	self dialogue_queue( line );

	flag_clear( controlflag );
}

dialogue_temp( line, timeout )
{
	self dialogue_print( line, timeout );
}

dialogue_print( line, timeout )
{
	if ( !IsDefined( timeout ) )
	{
		timeout = 3;
	}

	prefix = "";
	if ( !IsSubStr( line, ":" ) )
	{
		if ( self == level.player )
		{
			prefix = "Radio: ";
		}
		else if ( self == level.price )
		{
			prefix = "Price: ";
		}
	}

	line = prefix + line;

	hintfade = 0.5;

	level endon( "clearing_hints" );

	if ( IsDefined( level.tempHint ) )
	{
		level.tempHint destroyElem();
	}

	level.tempHint = createFontString( "default", 1.5 );
	level.tempHint setPoint( "BOTTOM", undefined, 0, -40 );
	level.tempHint.color = ( 1, 1, 1 );
	level.tempHint SetText( line );
	level.tempHint.alpha = 0;
	level.tempHint FadeOverTime( 0.5 );
	level.tempHint.alpha = 1;
	level.tempHint.sort = 1;
	wait( 0.5 );
	level.tempHint endon( "death" );

	wait( timeout );

	level.tempHint FadeOverTime( hintfade );
	level.tempHint.alpha = 0;
	wait( hintfade );

	level.tempHint destroyElem();
}

should_not_do_melee_rappel_hint()
{
	if ( !isalive( level.player ) )
		return true;

	return flag( "player_failed_rappel" ) || flag( "player_killing_guard" );
}
