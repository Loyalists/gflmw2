#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;

// ---------------------------------------------------------------------------------

should_spawn()
{
	switch ( level.gameSkill )
	{
		case 0:
		case 1:	return !( self.spawnflags & 256 );
		case 2:	return !( self.spawnflags & 512 );
		case 3:	return !( self.spawnflags & 1024 );
	}
}

// ---------------------------------------------------------------------------------

create_ghillie_enemies( enemy_id, wait_id, activate_id )
{
	ghillie_enemies_init();
	
	assertex( isdefined( enemy_id ), "create_ghillie_enemies() requires a valid enemy_id" );

	ghillie_spawners = getentarray ( enemy_id, "targetname" );
	assertex( ghillie_spawners.size > 0, "create_ghillie_enemies() could not find any spawners with id " + enemy_id );

	if ( isdefined( wait_id ) )
		level waittill( wait_id );

	thread stealth_disable();
	
	array_thread( ghillie_spawners, ::add_spawn_function, ::ghillie_enemy_init, enemy_id, activate_id );
	foreach ( ghillie in ghillie_spawners )
	{
		if ( ghillie should_spawn() )
			ghillie spawn_ai( true );
	}
}

ghillie_enemies_init()
{
	if ( isdefined( level.ghillie_enemies_initialized ) && level.ghillie_enemies_initialized )
		return;

	foreach ( player in level.players )
		player thread ghillie_player_damage_tracker();
	
	level.ghillie_enemies_initialized = true;
	level.ghillies_unaware = [];
	level.ghillies_nofire = [];
	level.ghillies_active = [];
}

ghillie_player_damage_tracker()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	while ( 1 )
	{
		self waittill( "damage", damage, attacker );
		
		// is it a ghillie?
		if ( !isai( attacker ) || !isdefined( attacker.ghillie_is_prone ) )
			continue;

		// Only set this if they are currently unaware.
		if ( !array_contains( level.ghillies_unaware, attacker.unique_id ) )
			continue;

		attacker ghillie_enemy_set_fired();
	}
}

ghillie_enemy_init( enemy_id, activate_id )
{
	level.ghillie_count++;
	level.enemies_spawned++;
		
	// Ghillies count as "unaware" before they've fired their first shot.	
	ghillie_enemy_set_unaware();
	
//	self.sightlatency = 1000;
	self.baseaccuracy = 6;
	self.goalradius = 96;
	self.grenadeAmmo = 0;
	self.dontEverShoot = true;
	self.allowdeath = true;
	self.neverForceSniperMissEnemy = true;

	self.ghillie_is_prone = false;
	self.ghillie_is_frozen = false;

	ghillie_enemy_set_flub_time();

	anim.shootEnemyWrapper_func = animscripts\utility::ShootEnemyWrapper_shootNotify;

	thread ghillie_enemy_register_death();
	thread ghillie_enemy_behavior( activate_id );
	maps\_stealth_utility::disable_stealth_for_ai();
}

ghillie_enemy_register_death()
{
	level endon( "special_op_terminated" );
	self endon ("ghillie_silent_kill" );
	
	my_id = self.unique_id;
	
	self waittill( "death", attacker );

	level.ghillie_count--;
	
	if ( array_contains( level.ghillies_unaware, my_id ) )
		death_register_unaware( attacker, undefined, true );
	else
	if ( array_contains( level.ghillies_nofire, my_id ) )
		death_register_nofire( attacker, undefined, true );
	else
		death_register_basic( attacker, undefined, true );
}

// This can probably be revisited to be simpler.
ghillie_enemy_behavior( activate_id )
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "pain_death" );

	self.combatmode = "no_cover";

	ghillie_enemy_freeze_while_prone();
	
	if ( isdefined( activate_id ) )
		flag_wait( activate_id );
	else
		wait 1;

	thread ghillie_enemy_quit_when_sidearm();
	foreach ( player in level.players )
		thread ghillie_enemy_detect_player_looking( player );

	ghillie_enemy_resume_moving( "stand" );
	if ( !ghillie_enemy_can_be_seen( false, true ) )
		ghillie_enemy_crouch_and_fire();
	ghillie_enemy_go_prone();
	ghillie_enemy_freeze_while_prone();

	while( 1 )
	{
		if( ghillie_enemy_can_be_seen( false, true ) )
		{
			wait 0.5;
			continue;
		}

		move_time = ghillie_get_move_time();
		crouch = randomfloat( 1.0 ) < level.ghillie_crouch_chance;
		if ( crouch )
			thread ghillie_enemy_resume_moving( "crouch", move_time );
		else
			thread ghillie_enemy_resume_moving( "prone", move_time );

		time_moved = 0.0;
		while( time_moved < move_time )
		{
			wait 1.0;
			time_moved += 1.0;
			if ( ghillie_enemy_can_be_seen( false, false ) )
			{
				self notify( "stop_moving" );
				if ( crouch )
					ghillie_enemy_go_prone();
				ghillie_enemy_freeze_while_prone();
				while ( ghillie_enemy_can_be_seen( false, false ) )
					wait 0.05;
			}

			new_move_time = clamp( move_time - time_moved, 0, move_time );
			if ( new_move_time > 0 )
			{
				if ( crouch )
					thread ghillie_enemy_resume_moving( "crouch", new_move_time );
				else
					thread ghillie_enemy_resume_moving( "prone", new_move_time );
			}
		}

		self notify( "stop_moving" );
		shot_attempts = 0;
		ghillie_enemy_crouch_and_fire();
		while ( !ghillie_enemy_can_be_seen( false, false ) && ( shot_attempts <= randomintrange( 1, 4 ) ) )
		{
			shot_attempts++;
			ghillie_enemy_crouch_and_fire();
		}
		ghillie_enemy_go_prone();
		ghillie_enemy_freeze_while_prone();
	}
}

ghillie_enemy_go_prone()
{
	self allowedstances( "prone" );

	if ( !self.ghillie_is_prone )
	{
		self.ghillie_is_frozen = false;
		self.ghillie_is_prone = true;
		self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	}
}

ghillie_enemy_freeze_while_prone()
{
	if ( self.ghillie_is_frozen )
		return;
		
	self allowedstances( "prone" );
	self.ghillie_is_prone = true;
	self.ghillie_is_frozen = true;
	self thread anim_generic_loop( self, "prone_idle", "stop_loop" );
}	

ghillie_enemy_resume_moving( stance, move_time )
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "pain_death" );

	self endon( "stop_moving" );

	anim_stopanimscripted();

	self allowedstances( stance );
	self.ghillie_is_frozen = false;
	switch ( stance )
	{
		case "prone":	self.ghillie_is_prone = true;	break;
		case "crouch":	self.ghillie_is_prone = false;	break;
		case "stand":	self.ghillie_is_prone = false;	break;
	}
	
	ghillie_enemy_set_goal_pos();

	self waittill( "goal_changed" );

	if ( !isdefined( move_time ) )
		move_time = ghillie_get_move_time();
	
	wait move_time;
}

ghillie_get_move_time()
{
	if ( isdefined( self.ghillie_moved_once ) && self.ghillie_moved_once )
		return ghillie_get_time( level.ghillie_move_time_min, level.ghillie_move_time_max );

	self.ghillie_moved_once = true;
	return ghillie_get_time( level.ghillie_move_intro_min, level.ghillie_move_intro_max );
}

ghillie_enemy_crouch_and_fire()
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "pain_death" );

	anim_stopanimscripted();

	self allowedstances( "crouch" );
	self.ghillie_is_prone = false;
	self.ghillie_is_froze = false;

	self setgoalpos( self.origin );

	thread ghillie_enemy_enable_shooting();
	thread ghillie_enemy_abandon_shooting();

//	if ( isdefined( level.ghillies_unaware[ self.unique_id ] ) )
//		thread ghillie_enemy_detect_fire();

	waittill_any( "shooting", "abandon_shooting" );
	
	self.dontEverShoot = true;

	wait ghillie_get_time( level.ghillie_shoot_hold_min, level.ghillie_shoot_hold_max );
}

ghillie_enemy_detect_fire()
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "pain_death" );

	self endon( "abandon_shooting" );
	
	self waittill( "shooting" );
	
	ghillie_enemy_set_fired();
}

ghillie_enemy_enable_shooting()
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "pain_death" );
	self endon( "abandon_shooting" );

	wait ghillie_get_time( level.ghillie_shoot_pause_min, level.ghillie_shoot_pause_max );

	self.dontEverShoot = undefined;
}

ghillie_enemy_abandon_shooting()
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "pain_death" );

	self endon( "shooting" );
	self endon( "enemy_visible" );

	wait ghillie_get_time( level.ghillie_shoot_quit_min, level.ghillie_shoot_quit_max );

	self notify( "abandon_shooting" );
}

ghillie_enemy_quit_when_sidearm()
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_forever" );
	self endon( "death" );
	self endon( "pain_death" );

	self waittill( "switched_to_sidearm" );

	ghillie_enemy_quit_ghillie();
}

ghillie_enemy_detect_player_looking( player )
{
	level endon( "special_op_terminated" );
	self endon( "quit_ghillie_forever" );
	self endon( "death" );
	self endon( "pain_death" );

	while ( 1 )
	{
		self waittill_player_lookat( 0.95, 1.0, true, undefined, undefined, player );
		
		dist = distance( self.origin, player.origin );
		if ( dist > level.ghillie_go_aggro_distance )
		{
			wait 0.5;
			continue;
		}
		
		break;
	}

	ghillie_enemy_quit_ghillie();
}

ghillie_enemy_quit_ghillie()
{
	ghillie_enemy_set_fired();
	thread ghillie_enemy_detect_fire_active();
	
	self.ghillie_is_prone = false;
	self.ghillie_is_frozen = false;
//	self.combatmode = "cover";
	self.dontEverShoot = undefined;
	self allowedstances( "stand", "crouch" );
	self.goalradius = 512;
	self setEngagementMinDist( 0, 0 );
	self setEngagementMaxDist( 8000, 9000 );

	self anim_stopanimscripted();
	self notify ( "quit_ghillie_behavior" );
	self notify( "quit_ghillie_forever" );

	self thread ghillie_enemy_update_target();
}

ghillie_enemies_quit_ghillie()
{
	enemies = getaiarray( "axis" );
	foreach ( guy in enemies )
	{
		if ( guy.classname == "actor_enemy_ghillie_sniper" )
		{
			wait 0.05;
			if ( !isalive( guy ) || !isdefined( guy ) )
				continue;
			
			guy ghillie_enemy_quit_ghillie();
		}
	}
}

ghillie_enemy_update_target()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	self endon( "pain_death" );

	while ( 1 )
	{
		self setgoalentity( get_closest_player_healthy( self.origin ) );
		wait 1;
	}
}

ghillie_enemy_detect_fire_active()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	self endon( "pain_death" );

	waittill_any( "shooting", "meleeanim" );
	
	ghillie_enemy_set_active();
}

ghillie_enemy_set_goal_pos()
{
	close_player = get_closest_player_healthy( self.origin );
	self setgoalpos( close_player.origin );
}

ghillie_enemy_silent_remove()
{
	self endon( "death" );
	level endon( "special_op_terminated" );

	while ( 1 )
	{
		if ( !ghillie_enemy_should_delete() )
		{
			wait 1;
			continue;
		}
			
		self notify( "ghillie_silent_kill" );
		self Delete();
		break;
	}
}

ghillie_enemy_should_delete()
{
	if ( ghillie_enemy_can_be_seen( false, true ) )
		return false;

	foreach ( player in level.players )
	{
		if ( distance( player.origin, self.origin ) < 512 )
			return false;
	}
	
	return true;
}

ghillie_enemy_can_be_seen( check_for_flub, check_offset )
{
	can_see_me = ghillie_enemy_sight_test( level.player, check_offset );
	if ( !can_see_me && is_coop() )
		can_see_me = ghillie_enemy_sight_test( level.player2, check_offset );

	// If I can be seen, then check for a flub. If not, then restart my flub from scratch.
	if ( isdefined( check_for_flub ) && check_for_flub )
	{
		if ( can_see_me )
			can_see_me = ghillie_enemy_check_flub();
		else
			ghillie_enemy_clear_flub_time();
	}
			
	return can_see_me;
}

ghillie_enemy_sight_test( player, check_offset )
{
	if ( is_player_down_and_out( player ) )
		return false;
		
	my_eye = self geteye();
	their_eye = player geteye();

	dot = 0.9;
	if ( player playerADS() >= 0.8 )
		dot = 0.998;

	if ( !player player_looking_at( my_eye, dot, true ) )
		return false;

	// Normal tests
	can_see_me = SightTracePassed( my_eye, their_eye, false, self );
	if ( !can_see_me )
		can_see_me = SightTracePassed( self.origin, their_eye, false, self );
	
	if ( !can_see_me && self.ghillie_is_prone && isdefined( check_offset ) && check_offset )
	{		
		offset = 96;
		can_see_me = SightTracePassed( my_eye + ( 0, 0, offset ), their_eye, false, self );
		if ( !can_see_me )
			can_see_me = SightTracePassed( self.origin + ( 0, 0, offset ), their_eye, false, self );
	}

	return can_see_me;
}

ghillie_enemy_check_flub()
{
	// If we aren't allowing flubs, always return true.
	if ( !isdefined( level.ghillie_flub_time_min ) )
		return true;

	// If we don't have a current flub time, set it now and return.
	// This makes it so the time is set from the first moment of being seen again.
	if ( !isdefined( self.ghillie_flub_time ) )
	{
		ghillie_enemy_set_flub_time();
		return true;
	}

	// Otherwise, player has been staring at me, see if I should make a mistake.
	if ( gettime() < self.ghillie_flub_time	)
		return true;
	
	// We are ready to make a mistake.
	ghillie_enemy_clear_flub_time();
	return false;
}

ghillie_enemy_set_unaware()
{
	my_id = self.unique_id;
	
	level.ghillies_unaware[ my_id ] = my_id;
	level.ghillies_nofire = array_remove( level.ghillies_nofire, my_id );
	level.ghillies_active = array_remove( level.ghillies_active, my_id );
}

ghillie_enemy_set_fired()
{
	my_id = self.unique_id;
	
	level.ghillies_nofire[ my_id ] = my_id;
	level.ghillies_unaware = array_remove( level.ghillies_unaware, my_id );
	level.ghillies_active = array_remove( level.ghillies_active, my_id );
}

ghillie_enemy_set_active()
{
	my_id = self.unique_id;
	
	level.ghillies_active[ my_id ] = my_id;
	level.ghillies_unaware = array_remove( level.ghillies_unaware, my_id );
	level.ghillies_nofire = array_remove( level.ghillies_nofire, my_id );
}

ghillie_enemy_set_flub_time()
{
	if ( !isdefined( level.ghillie_flub_time_min ) )
		return;
		
	self.ghillie_flub_time = gettime() + ghillie_get_time( level.ghillie_flub_time_min, level.ghillie_flub_time_max );
}

ghillie_enemy_clear_flub_time()
{
	self.ghillie_flub_time = undefined;
}

ghillie_get_time( time_min, time_max )
{
	wait_time = randomfloatrange( time_min, time_max );
	if ( is_coop() )
		wait_time *= level.coop_difficulty_scalar;
	return wait_time;
}

// ---------------------------------------------------------------------------------

create_patrol_enemies( enemy_id, wait_id, spawn_delay )
{
	patrol_enemies_init();

	assertex( isdefined( enemy_id ), "create_patrol_enemies() requires a valid enemy_id" );
		
	if ( isdefined( wait_id ) )
		level waittill( wait_id );

	thread stealth_enable();

	patrol_spawners = getentarray( enemy_id, "targetname" );
	assertex( patrol_spawners.size > 0, "create_patrol_enemies() could not find any spawners with id " + enemy_id );
	
	array_thread( patrol_spawners, ::add_spawn_function, ::patrol_enemy_init );
	foreach ( spawner in patrol_spawners )
		spawner patrol_enemy_spawn();
}

patrol_enemy_spawn()
{
	if ( !should_spawn() )
		return ;
		
	level endon( "special_op_terminated" );

	stagger = isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "patrol_stagger_spawn" );
	if ( stagger )
		wait randomfloatrange( 0.0, 3.0 );
		
	self spawn_ai( true );
}

patrol_enemies_init()
{
	if ( isdefined( level.patrol_enemies_initialized ) && level.patrol_enemies_initialized )
		return;
		
	thread script_chatgroups();
	level.patrol_enemies_initialized = true;
	level.patrols = [];
	level.patrols_unaware = [];
	level.patrols_nofire = [];
}

patrol_enemy_init()
{
	level.patrol_count++;
	level.enemies_spawned++;

	thread patrol_enemy_register_alert();
	thread patrol_enemy_register_attack();
	thread patrol_enemy_register_death();
	maps\_stealth_utility::stealth_default();

	if ( isdefined( self.target ) )
		thread maps\_patrol::patrol();

	self.patrol_stop = [];
	self.patrol_start = [];
	self.baseaccuracy = 2.0;
}

patrol_enemy_register_alert()
{
	level endon( "special_op_terminated" );

	my_id = self.unique_id;
	level.patrols_unaware[ my_id ] = my_id;
	
	self waittill( "enemy" );

	level.patrols_unaware = array_remove( level.patrols_unaware, my_id );
}

patrol_enemy_register_attack()
{
	level endon( "special_op_terminated" );

	my_id = self.unique_id;
	level.patrols_nofire[ my_id ] = my_id;
	
	self waittill( "shooting" );

	level.patrols_nofire = array_remove( level.patrols_nofire, my_id );
}

patrol_enemy_register_death()
{
	level endon( "special_op_terminated" );
	self endon( "patrol_silent_kill" );

	my_id = self.unique_id;
	level.patrols = array_add( level.patrols, self );

	self waittill( "death", attacker, cause, weapon_name );

	level.patrol_count--;

	level.patrols = array_removedead( level.patrols );

	if ( patrol_enemy_can_multi_kill( attacker, cause, weapon_name ) )
	{
		// Only register multi-kills when in stealth.
		current_time = gettime();
		if ( current_time == level.patrol_death_time )
			level.patrol_multi_kills++;
		else
			patrol_enemy_reset_multi_kill();
	}
	else
	{
		patrol_enemy_reset_multi_kill();
	}

	special_dialog = false;
	if ( level.patrol_multi_kills > 1 )
	{
		special_dialog = true;
		switch ( level.patrol_multi_kills )
		{
			case 2:		thread patrol_enemy_kill_double();	break;
			case 3:		thread patrol_enemy_kill_triple();	break;
			default:	// No known 4x+ kill possibilities. Better to say nothing than sound dumb.
		}
	}

	if ( array_contains( level.patrols_unaware, my_id )	)
		thread death_register_unaware( attacker, false, special_dialog );
	else
	if ( array_contains( level.patrols_nofire, my_id ) )
		thread death_register_nofire( attacker, false, special_dialog );
	else
		thread death_register_basic( attacker, false, special_dialog );
}

patrol_enemy_can_multi_kill( attacker, cause, weapon_name )
{
	if ( flag( "_stealth_spotted" ) )
		return false;

	if ( !isdefined( attacker ) || !isplayer( attacker ) )
		return false;

	if( !( cause == "MOD_PISTOL_BULLET" || cause == "MOD_RIFLE_BULLET" ) )
		return false;

	return true;
}

patrol_enemy_reset_multi_kill()
{
	level.patrol_multi_kills = 1;
	level.patrol_death_time = gettime();
}

patrol_enemy_kill_double()
{
	level endon( "special_op_terminated" );
	level notify( "multi_kill_message" );
	level endon( "multi_kill_message" );

	wait 0.5;

	radio_dialogue( "so_hid_ghil_double_kill" );
}

patrol_enemy_kill_triple()
{
	level endon( "special_op_terminated" );
	level notify( "multi_kill_message" );
	level endon( "multi_kill_message" );

	wait 0.5;

	radio_dialogue( "so_hid_ghil_triple_kill" );
}

patrol_enemy_silent_remove()
{
	self endon( "death" );
	level endon( "special_op_terminated" );
	
	while( 1 )
	{
		if ( !patrol_enemy_should_delete() )
		{
			wait 1;
			continue;
		}
			
		self notify( "patrol_silent_kill" );
		level.patrols = array_remove( level.patrols, self );
		self Delete();
		break;
	}
}

patrol_enemy_should_delete()
{
	if ( flag( "_stealth_spotted" ) )
		return false;

	foreach ( player in level.players )
	{
		if ( distance( player.origin, self.origin ) < 384 )
			return false;
		
		if ( patrol_enemy_sight_test( player ) )
			return false;
	}
	
	return true;
}

patrol_enemy_sight_test( player )
{
	my_eye = self geteye();
	if ( !player player_looking_at( self.origin, 0.9, true ) && !player player_looking_at( my_eye, 0.9, true ) )
		return false;

	their_eye = player geteye();
	if ( !SightTracePassed( self.origin, their_eye, false, self ) && !SightTracePassed( my_eye, their_eye, false, self ) )
		return false;
		
	return true;
}

// ---------------------------------------------------------------------------------

death_register_unaware( attacker, force_dialog, skip_dialog )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		level notify( "kill_registered" );
		attacker.kills_stealth++;
	}
		
	level.deaths_stealth++;
	level.bonus_time_given += level.bonus_stealth;
	death_dialog( level.dialog_kill_stealth, level.deaths_stealth, force_dialog, skip_dialog );
}

death_register_nofire( attacker, force_dialog, skip_dialog )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		level notify( "kill_registered" );
		attacker.kills_nofire++;
	}

	level.deaths_nofire++;
	level.bonus_time_given += level.bonus_nofire;
	death_dialog( level.dialog_kill_quiet, level.deaths_nofire, force_dialog, skip_dialog );
}

death_register_basic( attacker, force_dialog, skip_dialog )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		level notify( "kill_registered" );
		attacker.kills_basic++;
	}

	level.deaths_basic++;
	level.bonus_time_given += level.bonus_basic;
	// The "basic" dialog wound up being a bit too harsh, so using these lines for the kills, and will use
	// the "sloppy" type lines for once everyone is dead after stealth is broken.
//	death_dialog( level.dialog_kill_basic, level.deaths_basic, force_dialog, skip_dialog );
	// New update, no lines for "broken stealth" kills.
//	death_dialog( level.dialog_kill_quiet, level.deaths_nofire, force_dialog, skip_dialog );
}

death_dialog( dialog, total, force_dialog, skip_dialog )
{
	level endon( "special_op_terminated" );
	level endon( "multi_kill_message" );

	if ( isdefined( skip_dialog ) && skip_dialog )
		return;

	if ( !isdefined( force_dialog ) || !force_dialog )
	{
		if ( level.death_dialog_time > gettime() )
			return;
	}
			
	level.death_dialog_time = gettime() + level.death_dialog_throttle;

	wait 0.5;
		
	radio_dialogue( dialog[ total % dialog.size ], 1.0 );
}

// ---------------------------------------------------------------------------------

turn_on_stealth()
{
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );

	maps\_stealth::main();

	foreach ( player in level.players )
		player maps\_stealth_utility::stealth_default();

	init_prone_DOF();
	
	rangesHidden = [];
	rangesHidden[ "prone" ]		= 200;
	rangesHidden[ "crouch" ]	= 600;
	rangesHidden[ "stand" ]		= 1500;

	rangesSpotted = [];
	rangesSpotted[ "prone" ]	= 600;
	rangesSpotted[ "crouch" ]	= 1200;
	rangesSpotted[ "stand" ]	= 2500;
		
	maps\_stealth_utility::stealth_detect_ranges_set( rangesHidden, rangesSpotted );

	thread stealth_music_loop();
	// Decided to not chastize player ever.
//	thread stealth_chastize_loop();
}

stealth_disable()
{
	level endon( "special_op_terminated" );

	// Currently the Ghillies behave poorly when the Stealth System is active. The way the map is structured
	// makes it viable to disable stealth from pocket to pocket. Wait until all the patrols are dead before doing
	// so though, just in case they are at the edge. 
	// A flag can be set to force it (player touches a trigger where they've gone too far to allow stealth to continue.
	while ( level.patrol_count > 0 && !flag( "force_disable_stealth" ) )
		wait 1;

	foreach ( player in level.players )
	{
		player.maxVisibleDist = 8192;	
		
		if ( player ent_flag_exist( "_stealth_enabled" ) )
			player ent_flag_clear( "_stealth_enabled" );
	}
	
	if ( isdefined( level.patrols ) )
	{
		foreach ( patrol in level.patrols )
			patrol thread patrol_enemy_silent_remove();
	}
}

stealth_enable()
{
	// Clear this so the next trigger has a chance to set it when new ghillies are spawned.
	flag_clear( "force_disable_stealth" );

	// Force the ghillies out of ghillie mode.
	ghillie_enemies_quit_ghillie();
	
	foreach ( player in level.players )
	{
		if ( player ent_flag_exist( "_stealth_enabled" ) )
			player ent_flag_set( "_stealth_enabled" );

		player thread maps\_stealth_visibility_friendly::friendly_visibility_logic();
	}
}

stealth_music_loop()
{
	level endon( "special_op_terminated" );

	while ( 1 )
	{
		thread stealth_music_hidden_loop();

		flag_wait( "_stealth_spotted" );

		music_stop( .2 );
		wait .5;
		thread stealth_music_busted_loop();

		flag_waitopen( "_stealth_spotted" );

		music_stop( 3 );
		wait 3.25;
	}
}

stealth_music_hidden_loop()
{
	music_loop( "so_hidden_so_ghillies_stealth_music", 2 );

/*	level endon( "special_op_terminated" );
	level endon( "_stealth_spotted" );

	hidden_stealth_music_TIME = 119;
	while ( 1 )
	{
		MusicPlayWrapper( "so_hidden_so_ghillies_stealth_music" );
		wait hidden_stealth_music_TIME;
		wait 2;
	}*/
}

stealth_music_busted_loop()
{
	music_loop( "so_hidden_so_ghillies_busted_music", 2 );

/*	level endon( "special_op_terminated" );
	level endon( "_stealth_spotted" );

	hidden_stealth_busted_music_TIME = 88;
	while ( 1 )
	{
		MusicPlayWrapper( "so_hidden_so_ghillies_busted_music" );
		wait hidden_stealth_busted_music_TIME;
		wait 2;
	}*/
}

stealth_chastize_loop()
{
	level endon( "special_op_terminated" );

	while ( 1 )
	{
		flag_wait( "_stealth_spotted" );

		flag_waitopen( "_stealth_spotted" );
		wait 1;
		death_dialog( level.dialog_kill_basic, level.deaths_basic, true );
	}
}

// ---------------------------------------------------------------------------------

turn_on_radiation()
{
	thread maps\_radiation::main();
	
	wait 4;
	thread radio_dialogue( "so_hid_ghil_rad_warning" );
}

// ---------------------------------------------------------------------------------

hud_bonuses_create()
{
	ypos = so_hud_ypos();
	stealth_title	= so_create_hud_item( 3, ypos, &"SO_HIDDEN_SO_GHILLIES_KILL_STEALTH", self );
	nofire_title	= so_create_hud_item( 4, ypos, &"SO_HIDDEN_SO_GHILLIES_KILL_NOFIRE", self );
	basic_title		= so_create_hud_item( 5, ypos, &"SO_HIDDEN_SO_GHILLIES_KILL_BASIC", self );

	stealth_kills	= so_create_hud_item( 3, ypos, undefined, self );
	nofire_kills	= so_create_hud_item( 4, ypos, undefined, self);
	basic_kills		= so_create_hud_item( 5, ypos, undefined, self);
	
	stealth_kills.alignx	= "left";
	nofire_kills.alignx		= "left";
	basic_kills.alignx		= "left";
	
	stealth_kills	SetValue( 0 );
	nofire_kills	SetValue( 0 );
	basic_kills		SetValue( 0 );

	thread info_hud_handle_fade( stealth_title, "so_hidden_complete" );
	thread info_hud_handle_fade( nofire_title, "so_hidden_complete" );
	thread info_hud_handle_fade( basic_title, "so_hidden_complete" );

	thread info_hud_handle_fade( stealth_kills, "so_hidden_complete" );
	thread info_hud_handle_fade( nofire_kills, "so_hidden_complete" );
	thread info_hud_handle_fade( basic_kills, "so_hidden_complete" );

	thread hud_bonuses_update_scores( stealth_kills, nofire_kills, basic_kills );
	
	flag_wait( "so_hidden_complete" );

	stealth_title	thread so_remove_hud_item();
	nofire_title	thread so_remove_hud_item();
	basic_title		thread so_remove_hud_item();

	stealth_kills	thread so_remove_hud_item();
	nofire_kills	thread so_remove_hud_item();
	basic_kills		thread so_remove_hud_item();
}

hud_bonuses_update_scores( stealth_kills, nofire_kills, basic_kills )
{
	level endon( "special_op_terminated" );

	while ( 1 )
	{
		level waittill( "kill_registered" );

		stealth_kills	SetValue( self.kills_stealth );
		nofire_kills	SetValue( self.kills_nofire );
		basic_kills		SetValue( self.kills_basic );
	}
}

// ---------------------------------------------------------------------------------

objective_set_chopper()
{
	flag_wait( "so_hidden_obj_chopper" );
	
	obj = getstruct( "so_hidden_obj_chopper", "script_noteworthy" );
	objective_position( 1, obj.origin );
	playFX( getfx( "extraction_smoke" ), obj.origin );
}

// ---------------------------------------------------------------------------------

create_chatter_aliases_for_patrols()
{
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru1_passcig";
	aliases[ aliases.size ] = "scoutsniper_ru2_whoseturnisit";
	aliases[ aliases.size ] = "scoutsniper_ru1_wakeup";
	aliases[ aliases.size ] = "scoutsniper_ru2_buymotorbike";
	aliases[ aliases.size ] = "scoutsniper_ru1_tooexpensive";
	aliases[ aliases.size ] = "scoutsniper_ru2_illtakecareofit";
	aliases[ aliases.size ] = "scoutsniper_ru1_otherteam";
	aliases[ aliases.size ] = "scoutsniper_ru2_notwandering";
	aliases[ aliases.size ] = "scoutsniper_ru1_wandering";
	aliases[ aliases.size ] = "scoutsniper_ru2_zahkaevspayinggood";
	aliases[ aliases.size ] = "scoutsniper_ru1_wasteland";
	//aliases[ aliases.size ] = "scoutsniper_ru2_imonit";//yelling
	//aliases[ aliases.size ] = "scoutsniper_ru1_takealook";//radio and loud
	aliases[ aliases.size ] = "scoutsniper_ru2_whoseturnisit";
	aliases[ aliases.size ] = "scoutsniper_ru1_onourway";
	aliases[ aliases.size ] = "scoutsniper_ru1_passcig";
	aliases[ aliases.size ] = "scoutsniper_ru2_youidiot";
	aliases[ aliases.size ] = "scoutsniper_ru1_wakeup";
	aliases[ aliases.size ] = "scoutsniper_ru2_call";
	aliases[ aliases.size ] = "scoutsniper_ru1_tooexpensive";
	aliases[ aliases.size ] = "scoutsniper_ru2_americagoingtostartwar";
	aliases[ aliases.size ] = "scoutsniper_ru4_raise";
	aliases[ aliases.size ] = "scoutsniper_ru2_sendsomeonetocheck";
	aliases[ aliases.size ] = "scoutsniper_ru4_ifold";
	aliases[ aliases.size ] = "scoutsniper_ru2_andreibringingfood";
	aliases[ aliases.size ] = "scoutsniper_ru4_thisonesheavy";
	aliases[ aliases.size ] = "scoutsniper_ru2_quicklyaspossible";
	aliases[ aliases.size ] = "scoutsniper_ru4_didnteatbreakfast";
	aliases[ aliases.size ] = "scoutsniper_ru2_yescomrade";
	aliases[ aliases.size ] = "scoutsniper_ru4_takenzakhaevsoffer";
	aliases[ aliases.size ] = "scoutsniper_ru2_clearrotorblades";
	//aliases[ aliases.size ] = "scoutsniper_ru4_mayhaveproblem";//fear
	aliases[ aliases.size ] = "scoutsniper_ru2_radiationdosimeters";
	aliases[ aliases.size ] = "scoutsniper_ru4_canceltransactions";
	aliases[ aliases.size ] = "scoutsniper_ru2_dontbelieveatall";
	aliases[ aliases.size ] = "scoutsniper_ru4_cantwaitforshiftend";
	aliases[ aliases.size ] = "scoutsniper_ru2_ok";
	aliases[ aliases.size ] = "scoutsniper_ru4_hopeitdoesntrain";
	aliases[ aliases.size ] = "scoutsniper_ru2_professionaljob";

	level.chatter_aliases = aliases;
}

script_chatgroups()
{
	level.last_talker = undefined;
	talker = undefined;
	create_chatter_aliases_for_patrols();
	spawners = GetSpawnerTeamArray( "axis" );
	array_thread( spawners, ::add_spawn_function, ::setup_chatter );

	level.current_conversation_point = RandomInt( level.chatter_aliases.size );


	while ( true /*!flag( "done_with_stealth_camp" )*/ )
	{
		flag_waitopen( "_stealth_spotted" );

		closest_talker = undefined;
		next_closest = undefined;
		enemies = GetAIArray( "axis" );
		//sort from closest to furthest
		closest_enemies = get_array_of_closest( getAveragePlayerOrigin(), enemies );

		for ( i = 0; i < closest_enemies.size; i++ )
		{
			if ( IsDefined( closest_enemies[ i ].script_chatgroup ) )
			{
				closest_chat_group = closest_enemies[ i ].script_chatgroup;
				closest_talker = closest_enemies[ i ];
				if ( closest_talker ent_flag_exist( "_stealth_normal" ) )
					if ( !closest_talker ent_flag( "_stealth_normal" ) )
						continue;

				//find next closest member of same chat group
				next_closest = find_next_member( closest_enemies, i, closest_chat_group );

				//if has no buddy or is too far from buddy or buddy is alert find another

				if ( !isdefined( next_closest ) )
					continue;
				if ( next_closest ent_flag_exist( "_stealth_normal" ) )
					if ( !next_closest ent_flag( "_stealth_normal" ) )
						continue;
				d = Distance( next_closest.origin, closest_talker.origin );
				if ( d > 220 )
				{
					//println( d );
					continue;
				}
				else
					break;
			}
		}
		//we have a group, say something
		if ( IsDefined( next_closest ) )
		{
			//check if closest guy is our last talker, if so use second closest
			if ( IsDefined( level.last_talker ) )
			{
				if ( level.last_talker == closest_talker )
					talker = next_closest;
				else
					talker = closest_talker;
			}
			else
				talker = closest_talker;

			talker chatter_play_sound( level.chatter_aliases[ level.current_conversation_point ] );

			level.current_conversation_point++;
			if ( level.current_conversation_point >= level.chatter_aliases.size )
				level.current_conversation_point = 0;
			level.last_talker = talker;

			wait .5;// conversation has pauses
		}
		else
			wait 2;// lets try again in 2 seconds
	}
}

setup_chatter()
{
	if ( !isdefined( self.script_chatgroup ) )
		return;

	self endon( "death" );

	self ent_flag_init( "mission_dialogue_kill" );
	self setup_chatter_kill_wait();
	self ent_flag_set( "mission_dialogue_kill" );
}

setup_chatter_kill_wait()
{
	self endon( "death" );
	self endon( "event_awareness" );
	self endon( "enemy" );

	flag_wait_any( "_stealth_spotted", "_stealth_found_corpse" );
}

chatter_play_sound( alias )
{
	if ( is_dead_sentient() )
		return;

	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	thread maps\_utility::delete_on_death_wait_sound( org, "sounddone" );

	org.origin = self.origin;
	org.angles = self.angles;
	org LinkTo( self );

	org PlaySound( alias, "sounddone" );
	//println( "script_chatter alias = " + alias );

	self chatter_play_sound_wait( org );
	if ( IsAlive( self ) )
		self notify( "play_sound_done" );

	org StopSounds();
	wait( 0.05 );// stopsounds doesnt work if the org is deleted same frame

	org Delete();
}

chatter_play_sound_wait( org )
{
	self endon( "death" );
	self endon( "mission_dialogue_kill" );
	org waittill( "sounddone" );
}


find_next_member( closest_enemies, closest, closest_chat_group )
{
	for ( i = closest + 1; i < closest_enemies.size; i++ )
	{
		if ( IsDefined( closest_enemies[ i ].script_chatgroup ) )
		{
			if ( closest_enemies[ i ].script_chatgroup == closest_chat_group )
				return closest_enemies[ i ];
		}
	}
	return undefined;
}

// ---------------------------------------------------------------------------------

clip_nosight_wait_for_activate()
{
	self endon( "death" );

	flag_wait( self.script_flag );

	self thread clip_nosight_wait_damage();
	self thread clip_nosight_wait_stealth();
}

clip_nosight_wait_damage()
{
	if ( flag( "_stealth_spotted" ) )
		return;

	level endon( "_stealth_spotted" );

	self setcandamage( true );
	self waittill( "damage" );

	self delete();
}

clip_nosight_wait_stealth()
{
	self endon( "death" );

	flag_wait_either( "_stealth_spotted", "_stealth_found_corpse" );

	self delete();
}

// ---------------------------------------------------------------------------------

init_prone_DOF()
{
	foreach ( player in level.players )
	{
		player.dofDefault[ "nearStart" ]= level.dofDefault[ "nearStart" ];
		player.dofDefault[ "nearEnd" ]	= level.dofDefault[ "nearEnd" ];
		player.dofDefault[ "nearBlur" ]	= level.dofDefault[ "nearBlur" ];
		player.dofDefault[ "farStart" ]	= level.dofDefault[ "farStart" ];
		player.dofDefault[ "farEnd" ]	= level.dofDefault[ "farEnd" ];
		player.dofDefault[ "farBlur" ]	= level.dofDefault[ "farBlur" ];
	
		player.dofProne[ "nearStart" ]	= 10;
		player.dofProne[ "nearEnd" ]	= 50;
		player.dofProne[ "nearBlur" ]	= 6;
	
		player.dofReg[ "nearStart" ]	= player.dofDefault[ "nearStart" ];
		player.dofReg[ "nearEnd" ]		= player.dofDefault[ "nearEnd" ];
		player.dofReg[ "nearBlur" ]		= player.dofDefault[ "nearBlur" ];

		player thread player_prone_DOF();
	}
}

player_prone_DOF()
{
	self endon( "death" );
	
	while ( 1 )
	{
		my_stance = self getstance();
		if ( my_stance == "prone" )
			self set_prone_DOF();
		else
			self set_default_DOF();
		
		wait 0.05;
	}
}

set_default_DOF()
{
	if ( self.dofDefault[ "nearStart" ]	== self.dofReg[ "nearStart" ] )
		return;

	self.dofDefault[ "nearStart" ]	= self.dofReg[ "nearStart" ];
	self.dofDefault[ "nearEnd" ]	= self.dofReg[ "nearEnd" ];
	self.dofDefault[ "nearBlur" ]	= self.dofReg[ "nearBlur" ];

	self setViewModelDepthOfField( 0, 0 );

	self maps\_art::setdefaultdepthoffield();
}

set_prone_DOF()
{
	if ( self.dofDefault[ "nearStart" ]	== self.dofProne[ "nearStart" ] )
		return;

	self.dofDefault[ "nearStart" ]	= self.dofProne[ "nearStart" ];
	self.dofDefault[ "nearEnd" ]	= self.dofProne[ "nearEnd" ];
	self.dofDefault[ "nearBlur" ]	= self.dofProne[ "nearBlur" ];

	self setViewModelDepthOfField( 10, 50 );

	self maps\_art::setdefaultdepthoffield();
}

// ---------------------------------------------------------------------------------

dialog_unsilenced_weapons()
{
	self endon( "death" );
	level endon( "nonsilenced_weapon_pickup" );

	while ( true )
	{
		self waittill( "weapon_change"  );

		current_weapon = self getcurrentprimaryweapon();
		if ( !isdefined( current_weapon ) )
			continue;
			
		if ( current_weapon == "none" )
			continue;

		if ( current_weapon == "c4" )
			continue;
			
		if ( current_weapon == "claymore" )
			continue;
			
		if ( issubstr( current_weapon, "silence" ) )
			continue;
			
		//Be careful about picking up enemy weapons, Soap. Any un-suppressed firearms will attract a lot of attention.	
		thread radio_dialogue( "so_hid_ghil_pri_attractattn" );
		break;
	}

	level notify( "nonsilenced_weapon_pickup" );
}

// ---------------------------------------------------------------------------------