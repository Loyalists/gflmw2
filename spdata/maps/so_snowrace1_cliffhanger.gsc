#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\_hud_util;
#include maps\so_snowrace_code;
#include maps\_vehicle_spline;

main()
{
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_SPECOP_TIMER" );
	precacheString( &"SPECIAL_OPS_WAITING_OTHER_PLAYER" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_SCOREBOARD_TIMETOBEAT" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_YOUWIN" );
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_YOULOSE" );
	
	level.objective_desc = &"SO_SNOWRACE1_CLIFFHANGER_OBJ_FINISHLINE";
	precacheString( level.objective_desc );
	
	precacheShader( "difficulty_star" );
	
	init_snow_race( true );
	
	flag_init( "individual_timers" );
	
	// This makes it so that all players have individual timers. When one player finishes the other timers keep running.
	flag_set( "individual_timers" );
	
	array_thread( level.players, ::ent_flag_init, "finish_line" );
	
	level.raceWinner = undefined;
	level.timeToBeatString = "@SO_SNOWRACE1_CLIFFHANGER_SCOREBOARD_TIMETOBEAT";
	
	thread start_race();
	thread finishline();
	thread speed_balance();
	thread stop_enemies_on_player_death();
	thread enemies();
	
	if ( is_coop() )
	{
		// don't print "challenge success" because a player can not finish the race, or lose, and that isn't a success
		level.suppress_challenge_success_print = true;
	}
	
	level.show_time_to_beat = true;
	level.challenge_time_force_on = true;
	
	level.race_times[ "normal" ] 	= 120;
	level.race_times[ "hard" ] 		= 90;
	level.race_times[ "veteran" ] 	= 70;
	foreach( player in level.players )
		player thread star_challenge( level.race_times[ "veteran" ], level.race_times[ "hard" ], level.race_times[ "normal" ] );
	
	thread enable_challenge_timer( "race_started", "finish_line" );

	maps\_specialops_battlechatter::disable_chatter();
}

freeze_snowmobile( player )
{
	player EnableInvulnerability();
	player FreezeControls( true );
	player.ignoreme = true;
	player setBlurForPlayer( 6, 1 );
	
	if ( !isdefined( player.vehicle ) )
		return;
	
	player.vehicle thread stop_vehicle();
}

finishline()
{
	level endon( "time_ran_out" );
	
	playersRequired = level.players.size;
	trigger = getent( "finishline", "targetname" );
	assert( isdefined( trigger ) );
	
	// wait for all players to cross the finish line
	for(;;)
	{
		trigger waittill( "trigger", player );
		assert( isplayer( player ) );
		
		// a player crossed the finish line
		if ( isdefined( player.crossed_finish_line ) )
			continue;
		player.crossed_finish_line = true;
		
		player.finish_time = getTime();
		
		// stop the players timer
		player ent_flag_set( "finish_line" );
		
		// freeze player
		thread freeze_snowmobile( player );
		
		// player finish race so gets some stars now
		player.award_no_stars = undefined;
		
		// this player is the winner
		if ( !isdefined( level.raceWinner ) )
		{
			level.raceWinner = player;
			if ( is_coop() )
			{
				//assert( isdefined( player.playername ) );
				thread print_winners();
			}
		}
		
		playersRequired--;
		if ( playersRequired <= 0 )
			break;
		
		// print message on screen that we're waiting for other players
		player thread finishline_waiting_for_players_message();
	}
	
	level notify( "all_players_finished" );
	
	race_finished( true );
}

race_finished( was_success )
{
	if ( isdefined( level.race_finished_thread_running ) )
		return;
	level.race_finished_thread_running = true;
	
	stop_enemies();
	end_race_cleanup();
	
	if ( was_success )
	{
		flag_set( "finish_line" );
		waittillframeend;
		flag_set( "so_snowrace_complete" );
	}
	else
	{
		// make sure both player times exist because some might not have finished the race
		foreach( player in level.players )
		{
			if ( !isdefined( player ) )
				continue;
			if ( !isdefined( player.finish_time ) )
			{
				player.dnf = true;
				player.finish_time = getTime();
			}
		}
		
		flag_set( "finish_line" );
			waittillframeend;
		if ( is_coop() )
			flag_set( "so_snowrace_complete" );
		else
			missionfailedwrapper();
	}
}

print_winners()
{
	foreach( player in level.players )
	{
		player.winnertext = player createClientFontString( "default", 3.0 );
		player.winnertext.hidewheninmenu = true;
		player.winnertext setPoint( "CENTER", undefined, 0, -55 );
		player.winnertext.sort = 0.5;
		player.winnertext.pulse_scale_normal = 3.0;
		player.winnertext.pulse_scale_big = 5.0;
		
		if ( player == level.raceWinner )
			player.winnertext thread so_hud_pulse_success( &"SO_SNOWRACE1_CLIFFHANGER_YOUWIN" );
		else
			player.winnertext thread so_hud_pulse_failure( &"SO_SNOWRACE1_CLIFFHANGER_YOULOSE" );
		
		player.winnertext delayThread( 4.0, ::destroyElem );
	}
}

finishline_waiting_for_players_message()
{
	waiting_hud = create_waiting_message( self );
	flag_wait( "finish_line" );
	waiting_hud destroy();
}

stop_vehicle()
{
	speed = int( self vehicle_GetSpeed() );
	while( isdefined( self ) )
	{
		speed -= 2;
		if ( speed < 0 )
			break;
		
		self VehPhys_SetSpeed( speed );
		wait 0.05;
	}
	if ( isdefined( self ) )
		self VehPhys_SetSpeed( 0 );
}

enemies()
{
	level.enemy_snowmobiles_max = 12;
	/*
	skill = getDifficulty();
	switch( skill )
	{
		case "easy":
		case "medium":
			return;
		case "hard":
			level.enemy_snowmobiles_max = 6;
			break;
		case "fu":
			level.enemy_snowmobiles_max = 12;
			break;
	}
	*/
	level.track_player_positions = true;
	level.DODGE_DISTANCE = 500;
	level.POS_LOOKAHEAD_DIST = 200;
	
	level.moto_drive = false;
	if ( getdvar( "moto_drive" ) == "" )
		setdvar( "moto_drive", "0" );
	
	thread maps\cliffhanger_code::enemy_init();
	init_vehicle_splines();
	
	flag_set( "reached_top" );
	
	foreach( player in level.players )
	{
		player thread track_player_progress( player.snowmobile.origin );
		player.baseIgnoreRandomBulletDamage = true;
	}
	
	level.ignoreRandomBulletDamage = true;
	setsaveddvar( "sm_sunSampleSizeNear", 1 );
	level.bike_score = 0;
	wait( 2.4 );
	thread enemy_snowmobiles_spawn_and_attack();
}

stop_enemies_on_player_death()
{
	if ( is_coop() )
		return;
	level.player waittill( "death" );
	stop_enemies();
}

stop_enemies()
{
	level notify( "stop_spawning_enemies" );
	array_thread( getaiarray( "axis" ), ::safe_stop_magic_bullet_shield );
	wait 0.05;
	array_call( getaiarray( "axis" ), ::kill );
}

safe_stop_magic_bullet_shield()
{
	if ( isdefined( self.magic_bullet_shield ) )
		self thread stop_magic_bullet_shield();
}

enemy_snowmobiles_spawn_and_attack()
{
	level endon( "snowmobile_jump" );
	level endon( "enemy_snowmobiles_wipe_out" );
	level endon( "stop_spawning_enemies" );
	
	wait_time = 2;

	for ( ;; )
	{
		thread spawn_enemy_bike_snowrace();
		wait( wait_time );
		wait_time -= 0.5;
		if ( wait_time < 0.5 )
			wait_time = 0.5;
	}
}

within_fov_allplayers( pos )
{
	in_fov = false;
	foreach( player in level.players )
	{
		if ( within_fov( player.origin, player.angles, pos, 0 ) )
			return true;
	}
	return false;
}

spawn_enemy_bike_snowrace()
{
	assertex( isdefined( level.enemy_snowmobiles ), "Please add maps\_vehicle_spline::init_vehicle_splines(); to the beginning of your script" );
	
	/#
	debug_enemy_vehicles();
	#/
	
	if ( level.enemy_snowmobiles.size >= level.enemy_snowmobiles_max )
		return;

	player_targ = get_player_targ();
	player_progress = get_player_progress();
	my_direction = "forward";
	
	spawn_array = get_spawn_position( player_targ, player_progress - 1000 - level.POS_LOOKAHEAD_DIST );
	spawn_pos = spawn_array["spawn_pos"];
	
	player_sees_me_spawn = within_fov_allplayers( spawn_pos );
	
	if ( player_sees_me_spawn )
	{ 
		// player could see us so try spawning in front of the player and drive backwards
		spawn_array = get_spawn_position( player_targ, player_progress + 1000 );
		spawn_pos = spawn_array["spawn_pos"];
		my_direction = "backward";
		player_sees_me_spawn = within_fov_allplayers( spawn_pos );
		if ( player_sees_me_spawn )
		{
			return;
		}
	}
	
	// found a safe spawn pos
	spawn_pos = drop_to_ground( spawn_pos );
	
	snowmobile_spawner = getent( "snowmobile_spawner", "targetname" );
	assertEx( isdefined( snowmobile_spawner ), "Need a snowmobile spawner with targetname snowmobile_spawner in the level" );
	targ = spawn_array["targ"];

	snowmobile_spawner.origin = spawn_pos;
	
	//snowmobile_spawner.angles = vectortoangles( snowmobile_path_node.next_node.midpoint - snowmobile_path_node.midpoint );
	snowmobile_spawner.angles = vectortoangles( targ.next_node.midpoint - targ.midpoint );
	/*
	if ( isalive( level.player ) && isdefined( level.player.vehicle ) )
		snowmobile_spawner.angles = level.player.vehicle.angles;
	*/
	
	ai_spawners = snowmobile_spawner get_vehicle_ai_spawners();
	foreach ( spawner in ai_spawners )
	{
		spawner.origin = snowmobile_spawner.origin;
	}

	bike = vehicle_spawn( snowmobile_spawner );
	bike.offset_percent = spawn_array["offset"];
	bike VehPhys_SetSpeed( 95 );
	
	bike thread crash_detection();
	bike.left_spline_path_time = gettime() - 3000;
	waittillframeend; // for bike.riders to get defined
	if ( !isalive( bike ) )
		return;
	
	targ bike_drives_path( bike );
}

star_challenge( three_star_time, two_star_time, one_star_time )
{
	self thread star_challenge_hud( 2, three_star_time );
	self thread star_challenge_hud( 1, two_star_time );
	self thread star_challenge_hud( 0, one_star_time );
	self thread time_expires( one_star_time );
	
	self.award_no_stars = true;
	self.forcedGameSkill = 3;
	
	three_star_time *= 1000;
	two_star_time *= 1000;
	
	flag_wait( "race_started" );
	
	start_time = gettime();
	self.start_time = start_time;
	
	self ent_flag_wait( "finish_line" );
	
	elapsedTime = gettime() - start_time;
	if ( elapsedTime <= three_star_time )
		self.forcedGameSkill = 3;
	else if ( elapsedTime <= two_star_time )
		self.forcedGameSkill = 2;
	else
		self.forcedGameSkill = 1;
}

time_expires( time )
{
	level endon( "all_players_finished" );
	level endon( "special_op_terminated" );
	
	flag_wait( "race_started" );
	
	wait time;
	
	self.ran_out_of_time = true;
	level notify( "time_ran_out" );
	
	// stop the players timer
	self ent_flag_set( "finish_line" );
	
	// freeze player
	thread freeze_snowmobile( self );
	
	race_finished( false );
}

star_challenge_hud( x_pos_offset, removeTimer )
{	
	star_width = 25;
	ypos = maps\_specialops::so_hud_ypos();
	
	star = maps\_specialops::so_create_hud_item( 3, ypos, undefined, self );
	star.x = -10 - ( x_pos_offset * star_width );
	star setShader( "difficulty_star", 25, 25 );
	
	if ( !isdefined( removeTimer ) )
		return;
	
	flag_wait( "race_started" );
	
	self thread star_challenge_sound_and_flash( star, removeTimer );
	self thread star_challenge_force_alpha_at_finish( star );
	level waittill_any_timeout( removeTimer );
	
	if ( isdefined( level.raceWinner ) && self == level.raceWinner )
		return;
	
	wait 0.05;
	
	star notify( "destroy" );
	star destroy();
}

star_challenge_sound_and_flash( star, removeTimer )
{
	level endon( "special_op_terminated" );
	
	self endon( "finish_line" );
	
	secondsToTick = 5;
	timeToWait = removeTimer - secondsToTick;
	assert( timeToWait > 0 );
	
	wait timeToWait;
	
	for( i = 0 ; i < secondsToTick ; i++ )
	{
		self PlayLocalSound( "so_snowrace_star_tick" );
		star.alpha = 1;
		wait 0.5;
		star.alpha = 0.3;
		wait 0.5;
	}
	self PlayLocalSound( "so_snowrace_star_lost" );
}

star_challenge_force_alpha_at_finish( star )
{
	star endon( "destroy" );
	self ent_flag_wait( "finish_line" );
	waittillframeend;
	star.alpha = 1;
}