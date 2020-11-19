#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;

// ---------------------------------------------------------------------------------

track_infinite_ammo_time()
{
	level.normal_time = 0;
	level.infinite_time = 0;
	
	flag_wait( "so_demoman_start" );
	
	while ( !flag( "special_op_terminated" ) )
	{
		wait 0.05;
		if ( !isdefined( level.infinite_ammo ) || !level.infinite_ammo )
			level.normal_time += 0.05;
		else
			level.infinite_time += 0.05;
	}
}

// ---------------------------------------------------------------------------------

register_bridge_enemy()
{
	if ( !isdefined( level.bridge_enemies ) )
	{
		level.bridge_enemies = 0;
		level.enemy_list = [];
	}
	
	level.bridge_enemies++;
	level.enemy_list = array_add( level.enemy_list, self );
	
	if ( !flag( "so_demoman_start" ) )
		flag_set( "so_demoman_start" );
	
	self waittill( "death" );
	
	level.bridge_enemies--;
	level.enemy_list = array_remove( level.enemy_list, self );
	foreach ( player in level.players )
		player.target_reminder_time = gettime();
}

// ---------------------------------------------------------------------------------

player_refill_ammo()
{
	level endon( "special_op_terminated" );
	
	while ( true )
	{
		wait 0.05;
		if ( !player_can_refill() )
		{
			if ( isdefined( self.maintain_stock ) )
				self.maintain_stock = [];
			continue;
		}

		if ( !isdefined( self.maintain_stock ) )
			self.maintain_stock = [];

		weapons = self getweaponslistall();
		foreach ( weapon in weapons )
		{
			if ( weapon == "claymore" )
				continue;
			if ( weapon == "c4" )
				continue;
							
			if ( !isdefined( self.maintain_stock[ weapon ] ) )
				self.maintain_stock[ weapon ] = self getweaponammostock( weapon );
			
			self setweaponammostock( weapon, self.maintain_stock[ weapon ] );
		}
	}
}

player_can_refill()
{
	if ( !isdefined( level.infinite_ammo ) || !level.infinite_ammo )
		return false;
	
	return true;
}

player_wait_for_fire()
{
	notifyoncommand( "player_fired", "+attack" );
	notifyoncommand( "player_fired", "+melee" );
	notifyoncommand( "player_fired", "+frag" );
	notifyoncommand( "player_fired", "+smoke" );
	
	while( true )
	{
		self waittill( "player_fired" );

		// Placing sentry is ok.
		if ( isdefined( self.placingSentry ) )
			continue;
		
		// Certain weapons are allowed...
		weapon = self getcurrentweapon();
		if ( weapon == "claymore" )
			continue;

		if ( weapon == "c4" )
		{
			if ( !isdefined( self.c4array ) || ( self.c4array.size <= 0 ) )
				continue;
		}

		// Start the challenge!
		break;
	}
	
	if ( !flag( "so_demoman_start" ) )
		flag_set( "so_demoman_start" );
	
	foreach ( player in level.players )
	{
		player.target_reminder_time = gettime();
		player thread player_refill_ammo();
	}
}

// ---------------------------------------------------------------------------------

vehicle_alive_think()
{
	level endon( "special_op_terminated" );

	if ( !isdefined( level.vehicles_alive ) )
		level.vehicles_alive = 0;
		
	level.vehicles_alive++;
	self thread vehicle_track_damage();
	
	self waittill( "exploded", attacker );

	// In case pesky players find a way to explode a car before doing anything else the normal script catches.
	if ( !flag( "so_demoman_start" ) )
		flag_set( "so_demoman_start" );
		
	level.vehicles_alive--;
	level.vehicle_list = array_remove( level.vehicle_list, self );

	if ( isdefined( attacker ) && IsPlayer( attacker ) )
	{
		attacker.target_reminder_time = gettime();
	}
	else
	{
		foreach ( player in level.players )
			player.target_reminder_time = gettime();
	}
		
	level notify( "vehicle_destroyed" );
	thread so_dialog_counter_update( level.vehicles_alive, level.vehicles_max );
	if ( level.vehicles_alive <= 0 )
		flag_set( "so_demoman_complete" );
}

vehicle_track_damage()
{
	level endon( "special_op_terminated" );
	self endon( "exploded" );
	
	while ( 1 )
	{
		self waittill( "damage", damage, attacker );
		
		if ( !vehicle_attacker_is_player( attacker ) )
		{
			if ( isai( attacker ) )
				level.vehicle_damage += damage;
			continue;
		}

		if ( isplayer( attacker ) )
			attacker.vehicle_damage += damage;	
		else
			attacker.owner.vehicle_damage += damage;
	}
}

vehicle_attacker_is_player( attacker )
{
	// No attacker...
	if ( !isdefined( attacker ) )
		return false;
	
	// Player attacker...
	if ( isplayer( attacker ) )
		return true;
	
	// Player's turret attacker
	if ( !isdefined( attacker.targetname ) )
		return false;
	if ( attacker.targetname != "sentry_minigun" )
		return false;
	if ( !isdefined( attacker.owner ) )
		return false;
	if ( !isplayer( attacker.owner ) )
		return false;
		
	return true;
}

vehicle_get_slide_car( car_id )
{
	slide_cars = getentarray( car_id, "script_noteworthy" );
	foreach ( ent in slide_cars )
	{
		if ( ent.classname == "script_model" )
			return ent;
	}
}

// ---------------------------------------------------------------------------------

// Run on an individual player to help them out.
hud_display_cars_hint()
{
	level endon( "special_op_terminated" );

	assertex( isplayer( self ), "hud_display_cars_help() can only be called on players." );
	gameskill = self get_player_gameskill();
	self.target_reminder_time = gettime();
	self.target_help_time = 20000;

	thread hud_display_car_locations();
//	thread hud_display_car_objectives();
		
	while ( !flag( "so_demoman_complete" ) )
	{
		while ( hud_disable_cars_hint() )
		{
			wait 1;
			continue;
		}
		self notify( "show_vehicle_locs" );	
		
		while( !hud_disable_cars_hint() )
		{
			wait 1;
			continue;
		}
		self notify( "hide_vehicle_locs" );	
	}
}

hud_disable_cars_hint()
{
	if ( !flag( "so_demoman_start" ) )
		return true;
		
	if ( isdefined( level.bridge_enemies ) && ( level.bridge_enemies > 0 ) )
	{
		close_enemies = get_array_of_closest( self.origin, level.enemy_list, undefined, undefined, 4096, 0 );
		if ( close_enemies.size > 0 )
			return true;
	}
		
	player_time_test = gettime() - self.target_help_time;
	return ( self.target_reminder_time > player_time_test );
}

// ---------------------------------------------------------------------------------

hud_display_car_locations()
{
	level endon( "special_op_terminated" );

	while ( !flag( "so_demoman_complete" ) )
	{
		self waittill( "show_vehicle_locs" );

		thread hud_refresh_car_locations();

		self waittill( "hide_vehicle_locs" );
	}
}

hud_refresh_car_locations()
{
	level endon( "special_op_terminated" );
	self endon( "hide_vehicle_locs" );
	
	while( 1 )
	{
		self notify( "refresh_vehicle_locs" );
		close_vehicles = get_array_of_closest( self.origin, level.vehicle_list, undefined, 3 );
		foreach ( vehicle in close_vehicles )
			thread hud_show_target_icon( vehicle );
		wait 1;
	}
}

hud_show_target_icon( vehicle )
{
	assertex( isdefined( vehicle ), "hud_show_target_icon() requires a valid vehicle entity to place an icon over." );

	icon = NewClientHudElem( self );
	icon SetShader( "waypoint_targetneutral", 1, 1 );
	icon.alpha = 0;
	icon.color = ( 1, 1, 1 );
	icon.x = vehicle.origin[ 0 ];
	icon.y = vehicle.origin[ 1 ];
	icon.z = vehicle.origin[ 2 ] + 48;
	icon SetWayPoint( true, true );

	icon thread fade_over_time( 1, 0.25 );

	self waittill_any( "hide_vehicle_locs", "refresh_vehicle_locs" );
	icon fade_over_time( 0, 0.25 );
	
	icon Destroy();
}

// ---------------------------------------------------------------------------------

hud_display_car_objectives()
{
	level endon( "special_op_terminated" );

	Objective_SetPointerTextOverride( 1, &"SO_DEMO_SO_BRIDGE_OBJ_DESTROY" );

	while ( !flag( "so_demoman_complete" ) )
	{
		self waittill( "show_vehicle_locs" );

		thread hud_refresh_car_objectives();

		self waittill( "hide_vehicle_locs" );

		thread hud_hide_car_objectives();
	}
}

hud_refresh_car_objectives()
{
	level endon( "special_op_terminated" );
	self endon( "hide_vehicle_locs" );

	while( 1 )
	{
		close_vehicles = get_array_of_closest( self.origin, level.vehicle_list, undefined, 3 );
		i = 0;
		foreach ( vehicle in close_vehicles )
		{
			thread hud_show_target_objective( vehicle, i );
			i++;
		}
		wait 0.5;
	}
}

hud_show_target_objective( vehicle, index )
{
	assertex( isdefined( vehicle ), "hud_show_target_icon() requires a valid vehicle entity to place an icon over." );

	if ( index == 0 )
		Objective_Position( 1, vehicle.origin + ( 0, 0, 48 ) );
	else
		Objective_AdditionalPosition( 1, index, vehicle.origin + ( 0, 0, 48 ) );
}

hud_hide_car_objectives()
{
	for ( i = 0; i < 3; i++ )
	{
		if ( i == 0 )
			Objective_Position( 1, ( 0, 0, 0 ) );
		else
			Objective_AdditionalPosition( 1, i, ( 0, 0, 0 ) );
	}
}

// ---------------------------------------------------------------------------------

hud_display_cars_remaining()
{
	self.car_title = so_create_hud_item( 3, so_hud_ypos(), &"SO_DEMO_SO_BRIDGE_VEHICLES", self );
	self.car_count = so_create_hud_item( 3, so_hud_ypos(), undefined, self );
	self.car_count.alignx = "left";
	self.car_count SetValue( level.vehicles_alive );
	level.vehicles_max = level.vehicles_alive;
	
	while( true )
	{
		level waittill( "vehicle_destroyed" );
		if ( level.vehicles_alive <= 0 )
			break;
		
		self.car_count SetValue( level.vehicles_alive );
		if ( level.vehicles_alive <= 5 )
		{
			self.car_title thread so_hud_pulse_close();
			self.car_count thread so_hud_pulse_close();
		}
	}

	self.car_count so_remove_hud_item( true );
	self.car_count = so_create_hud_item( 3, so_hud_ypos(), &"SPECIAL_OPS_DASHDASH", self );
	self.car_count.alignx = "left";

	self.car_title thread so_hud_pulse_success();
	self.car_count thread so_hud_pulse_success();

	self.car_title thread so_remove_hud_item();
	self.car_count thread so_remove_hud_item();
}

hud_display_wreckage_count()
{
	self.bonus_title = so_create_hud_item( 4, so_hud_ypos(), &"SO_DEMO_SO_BRIDGE_WRECKAGE_IN", self );
	self hud_create_bonus_count();
	self.bonus_count_current = level.bonus_count_goal;
	self.bonus_count SetValue( level.bonus_count_goal );

	while( 1 )
	{
		level waittill( "vehicle_destroyed" );
		self.bonus_count_current--;
		if ( self.bonus_count_current <= 0 )
		{
			if ( level.vehicles_alive < level.bonus_count_goal )
				break;

			self.bonus_count_current = level.bonus_count_goal;
			thread hud_rebuild_time_bonus( level.bonus_time_amount );
		}

		self.bonus_count SetValue(  self.bonus_count_current );
		self.bonus_title thread so_hud_pulse_default();
		self.bonus_count thread so_hud_pulse_default();
	}

	self hud_create_bonus_count( &"SPECIAL_OPS_DASHDASH" );

	self.bonus_title thread so_hud_pulse_default();
	self.bonus_count thread so_hud_pulse_default();

	level waittill( "special_op_terminated" );
	
	self.bonus_title thread so_remove_hud_item();
	self.bonus_count thread so_remove_hud_item();

	self.time_title thread so_remove_hud_item();
	self.time_bonus thread so_remove_hud_item();
}

hud_create_bonus_count( label )
{
	if ( isdefined( self.bonus_count ) )
		self.bonus_count so_remove_hud_item( true );

	self.bonus_count = so_create_hud_item( 4, so_hud_ypos(), label, self );
	self.bonus_count.alignx = "left";
	self.bonus_count.pulse_sound = "arcademode_checkpoint";
}

hud_rebuild_time_bonus( timer )
{
	level endon( "special_op_terminated" );

	self notify( "rebuild_time_bonus" );
	self endon( "rebuild_time_bonus" );

	if ( level.vehicles_alive <= 0 )
		return;

	// Otherwise build, and wait for the timer to expire then rebuild.
	if ( self == level.player )
	{
		if ( !isdefined( level.infinite_ammo ) || !level.infinite_ammo )
		{
			level.infinite_ammo = true;
			foreach( player in level.players )
				player.infinite_ammo_time = 0;
		}
	}

	if ( !isdefined( self.time_bonus ) )
	{
		self.time_title = so_create_hud_item( 5, so_hud_ypos(), &"SO_DEMO_SO_BRIDGE_INFINITE_AMMO", self );
		self.time_bonus = so_create_hud_item( 5, so_hud_ypos(), &"SPECIAL_OPS_TIME_NULL", self );
		self.time_bonus.alignx = "left";
		self.time_bonus.pulse_sound = "infinite_ammo_on";
		self.time_title.pulse_scale = 1.33;
		self.time_bonus.pulse_scale = 1.75;
		self.time_title.pulse_time = 0.25;
		self.time_bonus.pulse_time = 0.25;
	}

	if ( self.time_title.alpha == 0 )
	{
		self.time_title set_hud_white();
		self.time_bonus set_hud_white();
	}
	
	self.time_title.alpha = 1;
	self.time_bonus.alpha = 1;

	thread hud_time_splash( timer );

	turn_red_time = 5;
	if ( timer > turn_red_time )
	{
		wait 3;	// This wait is for the hud splash to "absorb" into the hud timer.
		self.time_title set_hud_blue();
		self.time_bonus set_hud_blue();
		hud_time_bonus_wait( turn_red_time );
	}

	self.time_title set_hud_red();
	self.time_bonus set_hud_red();
	hud_time_bonus_wait( 0 );

	self.time_title.alpha = 0;
	self.time_bonus.alpha = 0;
	
	if ( self == level.player )
	{
		level.infinite_ammo_time = undefined;
		level.infinite_ammo = undefined;
		level.infinite_ammo_update = undefined;
		self PlaySound( "infinite_ammo_off" );
	}
}

hud_time_splash( timer )
{
	level endon( "special_op_terminated" );

	if ( !isdefined( self.splash_count ) )
		self.splash_count = 0;

	// Only allow one splash active at a time.	
	self.splash_count++;
	if ( self.splash_count > 1 )
		return;

	if ( !isdefined( self.time_splash ) )
	{
		self.time_msg = hud_create_splash( 0, &"SO_DEMO_SO_BRIDGE_WRECKAGE_ACTIVE" );
		self.time_msg_x = self.time_msg.x;
		self.time_msg_y = self.time_msg.y;

		self.time_splash = hud_create_splash( 1, &"SO_DEMO_SO_BRIDGE_INFINITE_AMMO_AMOUNT" );
		self.time_splash SetValue( level.bonus_time_amount );
		self.time_splash_x = self.time_splash.x;
		self.time_splash_y = self.time_splash.y;
	}

	while( self.splash_count > 0  )
	{
		if ( self == level.player )
			level.player PlaySound( "arcademode_kill_streak_won" );

		self.time_msg hud_boom_in_splash( self.time_msg_x, self.time_msg_y );
		self.time_splash hud_boom_in_splash( self.time_splash_x, self.time_splash_y );

		wait 2.5;

		self.time_msg hud_absorb_splash( self.time_title.y );
		self.time_splash hud_absorb_splash( self.time_title.y );

		wait 0.5;

		if ( self.infinite_ammo_time < 1 )
			self.infinite_ammo_time = 0;
		self.infinite_ammo_time += timer;
		self.time_bonus settenthstimer( self.infinite_ammo_time );

		self.time_title thread so_hud_pulse_create();
		self.time_bonus thread so_hud_pulse_create( "" );

		wait 0.25;

		self.splash_count--;
	}

	self.time_msg Destroy();
	self.time_splash Destroy();
}

hud_create_splash( yline, message )
{
	hud_elem = so_create_hud_item( yline, 0, message, self );
	hud_elem.alignX = "center";
	hud_elem.horzAlign = "center";
	return hud_elem;
}

hud_boom_in_splash( xpos, ypos )
{
	self.x = xpos;
	self.y = ypos;

	self.fontscale = 0.25;
	self.alpha = 0;
	self fadeovertime( 0.1 );
	self changefontscaleovertime( 0.1 );
	self.fontscale = 1;
	self.alpha = 1;
}

hud_absorb_splash( ypos )
{
	self changefontscaleovertime( 0.5 );
	self.fontscale = 0.5;

	self fadeovertime( 0.5 );
	self.alpha = 0;
	self moveovertime( 0.5 );
	self.x = 200;
	self.y = ypos;
}

hud_time_bonus_wait( stop_time )
{
	level endon( "special_op_terminated" );
	
	while ( ( self.splash_count > 0 ) || ( self.infinite_ammo_time > stop_time ) )
	{
		wait 0.05;
		self.infinite_ammo_time -= 0.05;
	}
}

// ---------------------------------------------------------------------------------
