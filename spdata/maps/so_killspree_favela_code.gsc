#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#using_animtree( "generic_human" );

/*dog_goto_player()
{
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );

	if ( level.player.size == 2 )
	{
		if ( randomint( 100 ) > 50 )
			self setgoalentity( level.player[ 0 ] );
		else
			self setgoalentity( level.player[ 1 ] );
	}
	else
		self setgoalentity( level.player );
		
	self.goalradius = 300;
}*/

ambush_to_seek()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	if ( !isdefined( self.script_combatmode ) )
		return;
		
	if ( self.script_combatmode == "ambush" )
	{
		while( 1 )
		{
			wait level.ambush_to_seeker_delay + randomint( level.ambush_to_seeker_delay );
			flag_wait( "detailed_enemy_population_info_available" );
			if( ( level.ambush_to_seeker + level.enemy_seekers ) > level.current_enemy_population/3 )
				continue;
			else
				break;	
		}
		
		self.combatmode = "cover";	
		self.ambush_to_seeker = true;
		
		self enemy_seek_player( 1024 );
		wait level.ambush_to_seeker_delay;
		self enemy_seek_player( 256 );
	}
}

enemy_seek_player( goalradius )
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );

	self.goalheight = 80;
	self.goalradius = goalradius;
	
	while ( 1 )
	{
		closest_player = get_closest_player_healthy( self.origin );
		if ( isdefined( closest_player ) )
			self setgoalpos( closest_player.origin );
		wait 2;
	}
}

release_doggy()
{
	level endon( "special_op_terminated" );

	dog_spawner = getentarray( "fence_dog_spawner", "targetname" );
	array_spawn_function( dog_spawner, ::dog_register_death );
	array_spawn_function( dog_spawner, ::enemy_seek_player, 300 );

	if( !isdefined( level.gameskill ) )
		num_of_dogs = max( int( getdvar( "g_gameskill" ) ), 1 );
	else
		num_of_dogs = max( level.gameskill, 1 );
		
	// difficulty modifier
	if( is_Coop() )
		num_of_dogs	+= 1;

	while( 1 )
	{
		level waittill( "who_let_the_dogs_out" );
		
		for( i = 0; i < num_of_dogs; i++ )
		{
			doggy = random( dog_spawner );
			if ( getaiSpeciesArray( "axis", "dog" ).size < level.max_dogs_at_once )
			{
				doggy.count = 1;
				doggy stalingradSpawn();
			}
			wait 1 + randomint( 5 );
		}
	}
}

hud_create_kill_counter()
{
	level endon( "special_op_terminated" );
	self endon( "hud_cleaned_up" );

	self.kill_hudelem = so_create_hud_item( 3, so_hud_ypos(), &"SPECIAL_OPS_HOSTILES", self );
	self.kill_hudelem_score = so_create_hud_item( 3, so_hud_ypos(), undefined, self );
	self.kill_hudelem_score.alignx = "left";
	self.kill_hudelem_score SetValue( level.points_counter );
	thread hud_clean_up();
	
	flag_wait( "favela_enemies_spawned" );
	
	while ( level.points_counter > 0 )
	{
		level waittill( "enemy_killed_by_player" );

		thread hud_update_kill_counter();
	}

	// Give both players a chance to update their huds.
	if ( self == level.player )
	{
		wait 0.05;
		flag_set( "challenge_success" );
	}
}

hud_update_kill_counter()
{
	if ( self == level.player )
		thread so_dialog_counter_update( level.points_counter, level.points_target );

	// Above 5 kills, just update data.
	if ( level.points_counter > 5 )
	{
		self.kill_hudelem_score SetValue( level.points_counter );
		return;
	}

	// Success!
	if ( level.points_counter <= 0 )
	{
		self.kill_hudelem_score so_remove_hud_item( true );
		self.kill_hudelem_score = so_create_hud_item( 3, so_hud_ypos(), &"SPECIAL_OPS_DASHDASH", self );
		self.kill_hudelem_score.alignx = "left";

		self.kill_hudelem thread so_hud_pulse_success();
		self.kill_hudelem_score thread so_hud_pulse_success();
		return;
	}
	
	// Crossed the barrier, let the player know they are close.
	self.kill_hudelem thread so_hud_pulse_close();
	self.kill_hudelem_score thread so_hud_pulse_close();
	self.kill_hudelem_score SetValue( level.points_counter );
}

hud_create_civ_counter()
{
	self endon( "hud_cleaned_up" );

	self.civ_hudelem = so_create_hud_item( 4, so_hud_ypos(), &"SO_KILLSPREE_FAVELA_CIVILIANS", self );
	self.civ_hudelem_score = so_create_hud_item( 4, so_hud_ypos(), undefined, self );
	self.civ_hudelem_score.alignx = "left";
	self.civ_hudelem_score SetValue( 0 );
	switch ( level.gameskill )
	{
		case 0:
		case 1: self.civ_hudelem_score.label = &"SO_KILLSPREE_FAVELA_CIV_COUNT_REGULAR";	break;
		case 2: self.civ_hudelem_score.label = &"SO_KILLSPREE_FAVELA_CIV_COUNT_HARDENED";	break;
		case 3: self.civ_hudelem_score.label = &"SO_KILLSPREE_FAVELA_CIV_COUNT_VETERAN";	break;
	}
	
	flag_wait( "favela_enemies_spawned" );
	
	while ( level.civilian_killed < level.civilian_kill_fail )
	{
		level waittill( "civilian_died" );

		kills_remaining = level.civilian_kill_fail - level.civilian_killed;
		if ( kills_remaining >= 1 )
			thread so_dialog_killing_civilians();

		self.civ_hudelem_score SetValue( level.civilian_killed );
		switch ( kills_remaining )
		{
			case 0:
				self.civ_hudelem thread so_hud_pulse_failure();
				self.civ_hudelem_score thread so_hud_pulse_failure();
				break;
			case 1:
				self.civ_hudelem thread so_hud_pulse_alarm();
				self.civ_hudelem_score thread so_hud_pulse_alarm();
				break;
			case 2:
				self.civ_hudelem thread so_hud_pulse_warning();
				self.civ_hudelem_score thread so_hud_pulse_warning();
				break;
			default:
				self.civ_hudelem thread so_hud_pulse_default();
				self.civ_hudelem_score thread so_hud_pulse_default();
				break;
		}
	}

	so_force_deadquote( "@SO_KILLSPREE_FAVELA_MISSION_FAILED_CIVILIAN" );
	thread missionfailedwrapper();
}

hud_clean_up()
{
	level waittill( "special_op_terminated" );
	
	if ( isdefined( self.kill_hudelem ) )
	{
		self.kill_hudelem thread so_remove_hud_item();
		self.kill_hudelem_score thread so_remove_hud_item();
		self.civ_hudelem thread so_remove_hud_item();
		self.civ_hudelem_score thread so_remove_hud_item();
	}
	
	self notify( "hud_cleaned_up" );
}

// ---------------------------------------------------------------------------------


enemy_type_monitor()
{
	level endon( "special_op_terminated" );

	flag_wait( "enemy_population_info_available" );
	
	while ( 1 )
	{
		enemies = getaiarray( "axis" );
		
		level.ambush_to_seeker = 0;
		level.enemy_seekers = 0;
		level.enemy_ambushers = 0;
		
		foreach ( ai in enemies )
		{
			if( isdefined( ai.ambush_to_seeker ) )
				level.ambush_to_seeker++;
			
			if( isdefined( ai.script_noteworthy ) && ai.script_noteworthy == "seek_player" )
				level.enemy_seekers++;
				
			if( isdefined( ai.combatmode ) && ai.combatmode == "ambush" )
				level.enemy_ambushers++;
		}
		
		flag_set( "detailed_enemy_population_info_available" );
		wait 1;
	}
}

hunter_enemies_level_init()
{
	if ( !isdefined( level.hunter_kill_value ) )
	{
		level.hunter_kill_value = 1;
	}
}

hunter_init()
{
	if( !isdefined( level.current_enemy_population ) )
	{
		level.current_enemy_population = 1;
	}

	level.current_enemy_population++;
	level notify( "enemy_number_changed" );	

	flag_set( "enemy_population_info_available" );
}

hunter_register_death()
{
	while( 1 )
	{
		level waittill( "specops_player_kill", attacker );
	
		level.current_enemy_population--;
		level notify( "enemy_number_changed" );
		level notify( "enemy_downed" );

		level.points_counter--;
		level notify( "enemy_killed_by_player" );
	}
}

dog_register_death()
{
	self waittill( "death", attacker );
	
	if ( isplayer( attacker ) )
	{
		attacker.dogs_killed++;
	}
}

civilian_register_death()
{
	self waittill( "death", attacker );
	
	assert( isdefined( level.gameskill ) );
	if ( isplayer( attacker ) )
	{
		attacker.civilians_killed++;
		level.civilian_killed++;
		level notify( "civilian_died" );
	}
}