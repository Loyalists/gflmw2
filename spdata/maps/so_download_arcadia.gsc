#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\so_download_arcadia_code;

main()
{
	// ------------- TWEAKABLES -------------
	level.DOWNLOAD_TIME = 60;				// how long it takes to download the files at each spot
	level.DOWNLOAD_INTERRUPT_RADIUS = 256;	// how close to the download an enemy has to be to "interrupt" it
	level.NEARBY_CHARGE_RADIUS = 1000;		// radius around the download from which we'll pull existing enemies to charge the download spot
	level.NUM_ENEMIES_LEFT_TOLERANCE = 0;	// how many guys we will tolerate still being alive in a wave before it's done
	level.NUM_FILES_MIN = 900;
	level.NUM_FILES_MAX = 2400;
	// --------------------------------------

	level.friendlyfire_warnings = true;
	so_download_arcadia_init_flags();
	
	so_download_arcadia_precache();
	so_download_arcadia_anims();
	
	maps\_stryker50cal::main( "vehicle_stryker_config2" );
	maps\arcadia_anim::dialog();
	
	so_delete_all_by_type( ::type_spawn_trigger, ::type_flag_trigger, ::type_spawners, ::type_killspawner_trigger, ::type_goalvolume );
	thread enable_escape_warning();
	thread enable_escape_failure();
	
	maps\arcadia_precache::main();
	maps\createart\arcadia_art::main();
	maps\_utility::set_vision_set( "arcadia_secondstreet", 1 );
	maps\arcadia_fx::main();
	
	default_start( ::start_so_download_arcadia );
	add_start( "so_escape", ::start_so_download_arcadia );
	
	precache_strings();
	maps\_load::set_player_viewhand_model( "viewhands_player_us_army" );
	maps\_load::main();
	
	common_scripts\_sentry::main();
	
	add_hint_string( "use_laser1", &"SO_DOWNLOAD_ARCADIA_LASER_HINT1", ::so_stop_laser_hint1 );
	add_hint_string( "use_laser2", &"SO_DOWNLOAD_ARCADIA_LASER_HINT2", ::so_stop_laser_hint2 );
	
	deadquotes = [];
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_CLAYMORE_POINT_ENEMY";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_CLAYMORE_ENEMIES_SHOOT";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_TURRET_PLACEMENT";
	so_include_deadquote_array( deadquotes );

	maps\_compass::setupMiniMap( "compass_map_arcadia" );
	
	thread so_download_arcadia_enemy_setup();
	
	thread maps\arcadia_amb::main();
	run_thread_on_noteworthy( "plane_sound", maps\_mig29::plane_sound_node );

	thread so_fake_choppers();
	thread so_mansion_pool();
	
	
	//thread maps\_debug::debug_character_count();

//	so_disable_player_laser_init();
}

precache_strings()
{
	PrecacheString( &"ARCADIA_LASER_HINT" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_OBJ_REGULAR" );

	PrecacheString( &"SO_DOWNLOAD_ARCADIA_OBJ_EXTRACT" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_USE_HINT" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_FRAME" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_INIT" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_CONNECTING" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_LOGIN" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_LOCATE" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_PROGRESS" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DSM_TOTALFILES" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DOWNLOAD_COMPLETE" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DOWNLOAD_INTERRUPTED" );

	// Hints
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DEADQUOTE_HINT1" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DEADQUOTE_HINT2" );
	PrecacheString( &"SO_DOWNLOAD_ARCADIA_DEADQUOTE_HINT3" );
}

so_download_arcadia_init_flags()
{
	flag_init( "intro_dialogue_done" );
	flag_init( "first_download_started" );
	flag_init( "player_has_escaped" );
	flag_init( "all_downloads_finished" );
	flag_init( "stryker_extraction_done" );
	
	flag_init( "used_laser" );
	flag_init( "laser_hint_print" );
	flag_set( "laser_hint_print" ); // Don't do the SP version of the laser hint
	
	flag_init( "golf_course_vehicles" );
	flag_init( "golf_course_mansion" );
	
	flag_init( "start_challenge" );

	flag_init( "no_living_enemies" );

	// Arcadia flag
	flag_init( "disable_stryker_dialog" );
	flag_init( "disable_stryker_laser" );
	flag_init( "golf_course_vehicles" );
	flag_init( "golf_course_vehicles_stop" );
}

//so_disable_player_laser_init()
//{
//	triggers = GetEntArray( "so_disable_player_stryker", "targetname" );
//	array_thread( triggers, ::so_disable_player_laser_think );
//}

//so_disable_player_laser_think()
//{
//	while ( 1 )
//	{
//		self waittill( "trigger", other );
//
//		touched = true;
//		while ( touched )
//		{
//			touched = false;
//
//			foreach ( player in level.players )
//			{
//				if ( player IsTouching( self ) )
//				{
//					touched = true;
//					player ent_flag_set( "disable_stryker_laser" );
//				}
//				else
//				{
//					player ent_flag_clear( "disable_stryker_laser" );
//				}
//			}
//
//			if ( !touched )
//			{
//				break;
//			}
//
//			wait( 0.5 );
//		}
//
//		foreach ( player in level.players )
//		{
//			player ent_flag_clear( "disable_stryker_laser" );
//		}
//	}
//}

so_download_arcadia_precache()
{
	PrecacheItem( "m79" );
	PrecacheItem( "claymore" );
	
	PrecacheModel( "mil_wireless_dsm" );
	PrecacheModel( "mil_wireless_dsm_obj" );
	PrecacheModel( "com_laptop_rugged_open" );
	
	precacheShader( "dpad_laser_designator" );
}

start_so_download_arcadia()
{
	foreach ( player in level.players )
	{
		player thread player_laser_targeting_think();
		player ent_flag_init( "used_laser1" );
		player ent_flag_init( "used_laser2" );
	}

	level.hud_download_count = 0;

	thread enable_challenge_timer( "start_challenge", "stryker_extraction_done" );
	fade_challenge_in( undefined, false );
	
	so_download_objective_init( 0, &"SO_DOWNLOAD_ARCADIA_OBJ_REGULAR" );
	thread stryker_think();
	thread so_download_arcadia_intro_dialogue();

	quotes = [];
	quotes[ quotes.size ] = "@SO_DOWNLOAD_ARCADIA_DEADQUOTE_HINT1";
	quotes[ quotes.size ] = "@SO_DOWNLOAD_ARCADIA_DEADQUOTE_HINT2";
	quotes[ quotes.size ] = "@SO_DOWNLOAD_ARCADIA_DEADQUOTE_HINT3";
	quotes[ quotes.size ] = "@SO_DOWNLOAD_ARCADIA_DEADQUOTE_HINT4";
	so_include_deadquote_array( quotes );
}

so_fake_choppers()
{
	choppers = getentarray( "fake_creek_chopper", "targetname" );
	array_call( choppers, ::Delete );

	choppers = getentarray( "fake_golf_course_chopper", "targetname" );
	array_call( choppers, ::Delete );

	choppers = getentarray( "checkpoint_fake_chopper", "targetname" );
	array_call( choppers, ::Hide );

	foreach ( chopper in choppers )
	{
		chopper.destination = getstruct( chopper.target, "targetname" );
		chopper.origin = chopper.origin + ( 0, 0, -2000 );

		if ( chopper.origin[ 0 ] < 20000 )
		{
			chopper.origin = ( 20000, chopper.origin[ 1 ] + 10000, chopper.origin[ 2 ] );
		}
	}

	min_delay = 3;
	max_delay = 5;
	min_speed = 1000;
	max_speed = 1300;
	diff_speed = max_speed - min_speed;
	max_pitch = 15;
	min_pitch = 5;
	diff_pitch = max_pitch - min_pitch;
	level.chopper_max_count = 10;
	level.chopper_count = 0;
	
	while ( 1 )
	{
		choppers = array_randomize( choppers );

		foreach ( idx, chopper in choppers )
		{
			if ( level.chopper_count < level.chopper_max_count )
			{
				d = Distance( chopper.origin, chopper.destination.origin );
				speed = RandomIntRange( 1000, 1600 );
				move_time = d / speed;
	
				percent = 1 - ( max_speed - speed ) / diff_speed;
				pitch = ( diff_pitch * percent ) + min_pitch;
	
				chopper.angles = ( pitch, chopper.angles[ 1 ], chopper.angles[ 2 ] );
				chopper thread so_fake_chopper_create_and_move( move_time, chopper.destination.origin );
			}

			wait( RandomFloatRange( min_delay, max_delay ) );
		}
	}
}

#using_animtree( "vehicles" );
so_fake_chopper_create_and_move( moveTime, destination )
{	
	assert( isdefined( moveTime ) );
	assert( moveTime > 0 );
	assert( isdefined( destination ) );
	
	chopper = spawn( "script_model", self.origin );
	chopper endon( "delete" );

	level.chopper_count++;

	chopper PlayLoopSound( "veh_helicopter_loop" );
	
	chopper.angles = self.angles;

	chopper thread so_fake_chopper_tilt();
	
	chopperModel[ 0 ] = "vehicle_blackhawk_low";
	chopperModel[ 1 ] = "vehicle_pavelow_low";
	chopper setModel( chopperModel[ randomint( chopperModel.size ) ] );
	
	chopper useAnimTree( #animtree );
	chopper setanim( %bh_rotors, 1, .2, 1 );
	
	chopper moveto( destination, moveTime, 0, 0 );
	wait moveTime;
	chopper delete();

	level.chopper_count--;
}

so_fake_chopper_tilt()
{
	self endon( "death" );
	start_angle = self.angles;

	while ( 1 )
	{
		time = RandomFloatRange( 2, 3 );
		pitch = start_angle[ 0 ] + RandomFloatRange( -5, 5 );
		yaw = start_angle[ 1 ] + RandomFloatRange( -7, 7 );
		roll = start_angle[ 2 ]  + RandomFloatRange( -10, 10 );

		self RotateTo( ( pitch, yaw, roll ), time, time * 0.5, time * 0.5 );
		wait( time );
	}
}

so_download_arcadia_intro_dialogue()
{

//	doExtraDialogue = false;
//	
//	dvar = GetDvarInt( "so_download_arcadia_introdialogue", -1 );
//	if( dvar <= 0 )
//	{
//		doExtraDialogue = true;
//		SetDvar( "so_download_arcadia_introdialogue", 5 );
//	}
//	else
//	{
//		dvar--;
//		SetDvar( "so_download_arcadia_introdialogue", dvar );
//	}
//	
//	if( doExtraDialogue )
//	{
//		// Hunter Two-One-Actual, Overlord. Gimme a sitrep over.
//		so_radio_dialogue( "arcadia_hqr_sitrep" );
//		
//		// We're just past the enemy blockade at heckpoint Lima. Now proceeding into Arcadia, over.
//		level.foley so_character_dialogue( "arcadia_fly_intoarcadia" );
//		
//		// Roger that. I have new orders for you. This comes down from the top, over.
//		so_radio_dialogue( "arcadia_hqr_neworders" );
//		
//		// Solid copy Overlord, send it.
//		level.foley so_character_dialogue( "arcadia_fly_solidcopy" );
//	}

	wait( 1 );
	
	// "There are several ruggedized laptops in your AO that contain high-value information."
	so_radio_dialogue( "so_dwnld_hqr_laptops" );
	
	// "Download the data from each of the laptops, then return to the Stryker for extraction."
	so_radio_dialogue( "so_dwnld_hqr_downloaddata" );
	
	flag_set( "intro_dialogue_done" );
	music_loop( "so_download_arcadia_music", 328 );
}

so_download_arcadia_anims()
{
	// "There are several ruggedized laptops in your AO that contain high-value information."
	level.scr_radio[ "so_dwnld_hqr_laptops" ] = "so_dwnld_hqr_laptops";
	
	// "Download the data from each of the laptops, then return to the Stryker for extraction."
	level.scr_radio[ "so_dwnld_hqr_downloaddata" ] = "so_dwnld_hqr_downloaddata";
	
	
	// "All Hunter units, Badger One will not engage targets without your explicit authorization."
	level.scr_radio[ "so_dwnld_stk_explicitauth" ] = "so_dwnld_stk_explicitauth";
	
	// "Hunter Two-One, I repeat, Badger One is not authorized to engage targets that you haven't designated."
	level.scr_radio[ "so_dwnld_stk_designated" ] = "so_dwnld_stk_designated";
	
	// "Hunter Two-One, we can't fire on enemies without your authorization!"
	level.scr_radio[ "so_dwnld_stk_cantfire" ] = "so_dwnld_stk_cantfire";
	
	
	// "Hunter Two-One, ten-plus foot-mobiles approaching from the east!"
	level.scr_radio[ "so_dwnld_stk_tenfootmobiles" ] = "so_dwnld_stk_tenfootmobiles";
	
	// "We've got activity to the west, they're coming from the light brown mansion!"
	level.scr_radio[ "so_dwnld_stk_brownmansion" ] = "so_dwnld_stk_brownmansion";
	
	// "Hostiles spotted across the street, they're moving to your position!"
	level.scr_radio[ "so_dwnld_stk_acrossstreet" ] = "so_dwnld_stk_acrossstreet";
	
	// "Hunter Two-One, you got movement right outside your location!"
	level.scr_radio[ "so_dwnld_stk_gotmovement" ] = "so_dwnld_stk_gotmovement";
	
	
	// "Hunter Two-One, there are hostiles in the area that can wirelessly disrupt the data transfer."
	level.scr_radio[ "so_dwnld_hqr_wirelesslydisrupt" ] = "so_dwnld_hqr_wirelesslydisrupt";
	
	// "Hunter Two-One, the download has been interrupted! You'll have to restart the data transfer manually."
	level.scr_radio[ "so_dwnld_hqr_restartmanually" ] = "so_dwnld_hqr_restartmanually";
	
	// "Hunter Two-One, hostiles have interrupted the download! Get back there and manually resume the transfer!"
	level.scr_radio[ "so_dwnld_hqr_getbackrestart" ] = "so_dwnld_hqr_getbackrestart";
	
	
	// "Good job, Hunter Two-One. Our intel indicates that there are two more laptops in the area - go find them and get their data."
	level.scr_radio[ "so_dwnld_hqr_gofindthem" ] = "so_dwnld_hqr_gofindthem";
	
	// "Stay frosty, Hunter Two-One, there's one laptop left."
	level.scr_radio[ "so_dwnld_hqr_onelaptop" ] = "so_dwnld_hqr_onelaptop";
	
	
	// "Nice work, Hunter Two-One. Now get back to the Stryker, we're pulling you out of the area."
	level.scr_radio[ "so_dwnld_hqr_pullingyouout" ] = "so_dwnld_hqr_pullingyouout";
	
	// "Hunter Two-One, get back to the Stryker for extraction!"
	level.scr_radio[ "so_dwnld_hqr_extraction" ] = "so_dwnld_hqr_extraction";
	
	// "Hunter Two-One, return to the Stryker to complete your mission!"
	level.scr_radio[ "so_dwnld_hqr_completemission" ] = "so_dwnld_hqr_completemission";
}

so_mansion_pool()
{
	foreach ( player in level.players )
	{
		player.so_in_water = false;
		player thread waterfx();
	}

	trigger = getent( "pool", "targetname" );
	
	while ( 1 )
	{
		trigger waittill( "trigger" );

		players_touching = [];
		foreach ( player in level.players )
		{
			if ( player IsTouching( trigger ) && !player.so_in_water )
			{
				player thread so_mansion_pool_internal( trigger );
			}
		}

		wait( 0.5 );
	}
}

so_mansion_pool_internal( trigger )
{
	self.so_in_water = true;
	while ( self IsTouching( trigger ) )
	{
		self SetMoveSpeedScale( 0.3 );
		self AllowStand( true );
		self AllowCrouch( false );
		self AllowProne( false );

		wait( 0.1 );
	}

	self SetMoveSpeedScale( 1 );
	self AllowStand( true );
	self AllowCrouch( true );
	self AllowProne( true );
	self.so_in_water = false;
}