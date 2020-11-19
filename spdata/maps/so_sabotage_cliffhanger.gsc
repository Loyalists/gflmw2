#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\so_sabotage_cliffhanger_code;

// ---------------------------------------------------------------------------------
//	Tweakables
// ---------------------------------------------------------------------------------

CONST_regular_obj			= &"SO_SABOTAGE_CLIFFHANGER_OBJ_REGULAR";
CONST_hardened_obj			= &"SO_SABOTAGE_CLIFFHANGER_OBJ_HARDENED";
CONST_veteran_obj			= &"SO_SABOTAGE_CLIFFHANGER_OBJ_VETERAN";

CONST_regular_accuracy		= 2; 		// accuracy modifier
CONST_hardened_accuracy		= 2; 		// accuracy modifier
CONST_veteran_accuracy		= 1.75; 	// accuracy modifier

// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	// optimization
	setsaveddvar( "sm_sunShadowScale", 0.5 );
	setsaveddvar( "r_lightGridEnableTweaks", 1 );
	setsaveddvar( "r_lightGridIntensity", 1.5 );
	setsaveddvar( "r_lightGridContrast", 0 );

	PreCacheShader( "overlay_frozen" );
	PreCacheItem( "c4" );

	level.strings[ "hint_c4_plant" ] = &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES";

	level._effect[ "extraction_smoke" ] = loadfx( "smoke/signal_smoke_green" );

	// from precache script
	maps\cliffhanger_precache::main();

	// Special Op mode deleting all original spawn triggers, vehicles and spawners
	so_delete_all_by_type( ::type_spawn_trigger, ::type_vehicle_special, ::type_spawners_special );

	// delete chad's new snowmobiles
	voltron_array = getentarray( "script_vehicle_snowmobile_coop_alt", "classname" );
	voltron_array = array_combine( voltron_array, getentarray( "script_vehicle_snowmobile_coop", "classname" ) );
	foreach( sm in voltron_array )
		sm delete();

	truck_patrol = getent( "truck_patrol", "targetname" );
	truck_patrol.target = "truck_patrol_target" ;

	default_start( ::start_so_sabotage );
	add_start( "sabotage", ::start_so_sabotage );

	flags_init();

	// init stuff
	maps\cliffhanger_fx::main();

	maps\cliffhanger_anim::generic_human();
	maps\cliffhanger_anim::script_models();
	maps\cliffhanger_anim::player_anims();

	maps\_load::main();

	thread maps\cliffhanger_amb::main();
	maps\createart\cliffhanger_art::main();

	maps\_idle::idle_main();
	maps\_idle_coffee::main();
	maps\_idle_smoke::main();
	maps\_idle_lean_smoke::main();
	maps\_idle_phone::main();
	maps\_idle_sleep::main();
	maps\_idle_sit_load_ak::main();

	maps\_patrol_anims::main();

	maps\_stealth::main();
	stealth_settings();

	maps\_compass::setupMiniMap( "compass_map_cliffhanger" );
}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------

start_so_sabotage()
{
	spawn_funcs();

	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:								// Easy
		case 1:	so_setup_Regular();	break;	// Regular
		case 2:	so_setup_hardened();break;	// Hardened
		case 3:	so_setup_veteran();	break;	// Veteran
	}
	level.challenge_objective_escape	= &"SO_SABOTAGE_CLIFFHANGER_OBJ_ESCAPE";

	deadquotes = [];
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_LOOK_FOR_ENEMIES";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_STAY_LOW";
	deadquotes[ deadquotes.size ] = "@DEADQUOTE_SO_STEALTH_USE_SILENCERS";
	deadquotes[ deadquotes.size ] = "@SO_SABOTAGE_CLIFFHANGER_AA12_HELP";
	so_include_deadquote_array( deadquotes );

	thread set_flags();			 // set off flags to trigger original cliffhanger stuff
	thread setup_explosives();
	thread explosives_planted_monitor();
	thread blizzard_control();
	thread start_truck_patrol();

	thread maps\cliffhanger_code::script_chatgroups();
	
	thread force_players_prone();

	thread enable_escape_warning();
	thread enable_escape_failure();
	thread fade_challenge_in();
	thread fade_challenge_out( "sabotage_success" );
	thread enable_challenge_timer( "challenge_start", "sabotage_success" );
	thread enable_triggered_complete( "player_outside_compound", "sabotage_success", "all" );

	thread cliffhanger_dialogue();
}

so_setup_regular()
{
	level.challenge_objective 	= CONST_regular_obj;
	level.new_enemy_accuracy	= CONST_regular_accuracy;
}

so_setup_hardened()
{
	level.challenge_objective 	= CONST_hardened_obj;
	level.new_enemy_accuracy 	= CONST_hardened_accuracy;
}

so_setup_veteran()
{
	level.challenge_objective 	= CONST_veteran_obj;
	level.new_enemy_accuracy	= CONST_veteran_accuracy;
}