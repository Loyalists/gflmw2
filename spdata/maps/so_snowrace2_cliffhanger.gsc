#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\so_snowrace_code;

FLAG_TIME_VALUE = 4.0;
FLAG_TIME_VALUE_VETERAN = 3.0;

main()
{
	precacheString( &"SO_SNOWRACE1_CLIFFHANGER_COOPFAIL_HINT1" );
	level.objective_desc = &"SO_SNOWRACE1_CLIFFHANGER_OBJ_FINISHLINE_GATES";
	precacheString( level.objective_desc );
	
	init_snow_race();
	
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	
	flag_gates();
	
	thread start_race();
	thread finishline();
	
	time_limit[ "easy" ] = 15;
	time_limit[ "medium" ] = 15;
	time_limit[ "hard" ] = 10;
	time_limit[ "fu" ] = 8;
	
	difficulty = getDifficulty();
	assert( isdefined( time_limit[ difficulty ] ) );
	level.challenge_time_limit = time_limit[ difficulty ];
	level.challenge_time_silent = true;
	
	level.no_snowmobile_attack_hint = true;
	level.challenge_time_nudge = 6;
	level.challenge_time_hurry = 3;
	thread manage_timer();
	level.challenge_time_force_on = true;
	thread enable_challenge_timer( "race_started", "finish_line", &"SO_SNOWRACE1_CLIFFHANGER_SPECOP_TIMER" );
	
	thread special_coop_fail_quotes();
}

manage_timer()
{
	flag_wait( "race_started" );
	
	start_time = gettime();
	foreach( player in level.players )
	{
		player.start_time = start_time;
		player.gates_hit = 0;
	}
	
	timer = 0.1;
	
	for(;;)
	{
		level.challenge_time_limit -= timer;
		wait timer;
	}
}

flag_gates()
{
	// allow for different flags to be used for different difficulties or sp/coop
	array_thread( getentarray( "flag_trigger", "targetname" ), ::gate_think );
}

gate_think()
{
	assert( isdefined( self.target ) );
	flags = getentarray( self.target, "targetname" );
	assert( flags.size == 2 );
	
	flag_time = FLAG_TIME_VALUE;
	skill = getDifficulty();
	if ( skill == "fu" )
		flag_time = FLAG_TIME_VALUE_VETERAN;
	
	level endon( "special_op_terminated" );
	self waittill( "trigger", ent );
	
	if ( isplayer( ent ) )
	{
		ent.gates_hit++;
	}
	else
	{
		assert( isdefined( ent.player ) );
		assert( isplayer( ent.player ) );
		ent.player.gates_hit++;
	}
	
	level thread play_sound_in_space( "snowrace_flag_capture", self.origin + ( 0, 0, 40 ) );
	thread gate_splash();
	self delete();
	array_call( flags, ::delete );
	
	level notify( "new_challenge_timer" );
	level.challenge_time_limit += flag_time;
	thread enable_challenge_timer( "race_started", "finish_line", &"SO_SNOWRACE1_CLIFFHANGER_SPECOP_TIMER" );
}

gate_splash()
{
	level notify( "gate_splash" );
	level endon( "gate_splash" );
	
	if ( !isdefined( level.time_splash ) )
	{
		level.time_splash = so_create_hud_item( 2, 0, &"SO_SNOWRACE1_CLIFFHANGER_TIMESPLASH" );
		level.time_splash.alignx = "center";
		level.time_splash.horzAlign = "center";
		level.time_splash set_hud_yellow();

		if ( level.gameskill >= 3 )
			level.time_splash SetValue( FLAG_TIME_VALUE_VETERAN );
		else
			level.time_splash SetValue( FLAG_TIME_VALUE );
	}
		
	level.time_splash.alpha = 1;
	level.time_splash FadeOverTime( 1 ) ;
	level.time_splash.alpha = 0;
	
	level.time_splash.fontscale = 2;
	level.time_splash ChangeFontScaleOverTime( 1 );
	level.time_splash.fontscale = 0.5;
}

finishline()
{
	trigger = getent( "finishline", "targetname" );
	assert( isdefined( trigger ) );
	
	trigger waittill( "trigger", player );
	
	foreach( player in level.players )
		player.finish_time = getTime();
	
	assert( isplayer( player ) );
	assert( isdefined( player.playername ) );
	
	end_race_cleanup();
	
	flag_set( "finish_line" );
	flag_set( "so_snowrace_complete" );
}

special_coop_fail_quotes()
{
	if ( !is_coop() )
		return;
	
	level endon( "so_snowrace_complete" );
	level waittill( "challenge_timer_failed" );
	
	deadquotes = [];
	deadquotes[ 0 ] = "@SO_SNOWRACE1_CLIFFHANGER_COOPFAIL_HINT1";
	
	maps\_specialops_code::so_special_failure_hint_set_array( deadquotes );
}