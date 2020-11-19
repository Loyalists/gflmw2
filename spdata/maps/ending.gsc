#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

main()
{
	/*
	// for launcher
	add_start( "wakeup", 		 		::start_wakeup_after_crash, "", 					::wakeup_after_crash );
	add_start( "wakefast", 		 		::start_wakeup_after_crash, "", 					::wakeup_after_crash );
	add_start( "turnbuckle", 			::start_turnbuckle, "", 							::fight_turnbuckle );
	add_start( "gloat", 				::start_shepherd_gloats, "", 						::shepherd_gloats );
	add_start( "gun_drop", 	 			::start_gun_drop, "", 								::gun_drop );
	add_start( "crawl", 				::start_gun_crawl, "", 								::gun_crawl );
	add_start( "gun_kick", 				::start_gun_kick, "", 								::gun_kick );
	add_start( "wounded", 				::start_wounded_show, "Watch Price/Shep fight", 	::wounded_show );
	add_start( "pullout", 				::start_knife_pullout, "", 	 						::knife_pullout );
	add_start( "kill", 					::start_knife_kill, "", 	 						::knife_kill );
	add_start( "price_wakeup", 			::start_price_wakeup, "", 							::price_wakeup );
	add_start( "walkoff", 				::start_walkoff, "", 								::walkoff );
	*/
	
//	PreCacheItem( "cheytac" );
	precachestring( &"AF_CHASE_PURSUE" );
	precachestring( &"AF_CHASE_MISSION_FAILED_IN_THE_OPEN" );
	precachestring( &"AF_CHASE_MISSION_FAILED_KEEP_UP" );
	precachestring( &"AF_CHASE_FAILED_TO_SHOOT_DOWN" );
	precachestring( &"AF_CHASE_PRESS_USE" );
	precachestring( &"AF_CHASE_HINT_CRAWL_RIGHT" );
	precachestring( &"AF_CHASE_HINT_CRAWL_LEFT" );
	precachestring( &"AF_CHASE_KILL_SHEPHERD" );
	precachestring( &"SCRIPT_WAYPOINT_SHEPHERD" );
	precachestring( &"AF_CHASE_FAILED_TO_CRAWL" );
	precachestring( &"AF_CHASE_FAILED_TO_PULL_KNIFE" );
	
	PreCacheItem( "m203" );
	PreCacheRumble( "steady_rumble" );
	PreCacheRumble( "smg_fire" );
	PreCacheItem( "m16_grenadier" );
	PreCacheItem( "rpg_straight_af_chase" );
	PreCacheItem( "rpg_af_chase" );
	PreCacheItem( "rpd" );
	PreCacheItem( "uzi" );
	PreCacheItem( "littlebird_FFAR" );
	PreCacheModel( "weapon_commando_knife" );
	PreCacheModel( "weapon_commando_knife_bloody" );
	PreCacheModel( "viewmodel_commando_knife" );
	PreCacheModel( "viewmodel_commando_knife_bloody" );
	PreCacheModel( "zodiac_head_roller" );
	PreCacheModel( "weapon_colt_anaconda" );
	PreCacheModel( "vehicle_pickup_destroyed" );
	PreCacheModel( "weapon_colt_anaconda_animated" );
	PreCacheModel( "fx_rifle_shell" );
	PreCacheModel( "body_desert_tf141_zodiac" );
	PreCacheModel( "viewhands_player_tf141_bloody" );
//	precachemodel( "head_hero_price_desert_beaten" );
//	precachemodel( "head_vil_shepherd_damaged" );
	precachemodel( "vehicle_little_bird_bench_afghan" );
	
	PreCacheRumble( "heavy_1s" );
	PreCacheRumble( "heavy_2s" );
	PreCacheRumble( "heavy_3s" );

	PreCacheRumble( "light_1s" );
	PreCacheRumble( "light_2s" );
	PreCacheRumble( "light_3s" );

//	precachemodel( "body_vil_shepherd_no_gun" );

	PreCacheModel( "prop_misc_literock_small_01" );
	PreCacheModel( "prop_misc_literock_small_02" );
	PreCacheModel( "prop_misc_literock_small_03" );
	PreCacheModel( "prop_misc_literock_small_04" );
	PreCacheModel( "prop_misc_literock_small_05" );
	PreCacheModel( "prop_misc_literock_small_06" );
	PreCacheModel( "prop_misc_literock_small_07" );
	PreCacheModel( "prop_misc_literock_small_08" );
	
	
	PreCacheShellShock( "af_chase_turn_buckle_slam" );
	PreCacheShellShock( "af_chase_ending_wounded" );
	PreCacheShellShock( "af_chase_ending_pulling_knife_later" );
	PreCacheShellShock( "af_chase_ending_no_control" );
	PreCacheShellShock( "af_chase_ending_no_control_lowkick" );
	PreCacheShellShock( "af_chase_ending_wakeup" );
	PreCacheShellShock( "af_chase_ending_wakeup_nomove" );
	PreCacheShellShock( "af_chase_ending_fakeout" );
	

	PreCacheShader( "overlay_hunted_black" );
	precacheItem( "ending_knife" );
//	precacheItem( "ending_knife_silent" );
	
	precacheShader( "hud_icon_commando_knife" );
	precacheShader( "reticle_center_throwingknife" );
	precacherumble( "tank_rumble" );
	precacherumble( "damage_light" );
	precacherumble( "damage_heavy" );

	setdvarifuninitialized( "ui_char_museum_mode", "credits_1" );	
	
	if( !isdefined( level.player ) )
		level.player = getentarray( "player", "classname" )[ 0 ];	
	
	weapons = level.player GetWeaponsListAll();
	if( isdefined( weapons ) && weapons.size )
		setdvar( "ui_char_museum_mode", "credits_1" );
	
	level.level_mode =  getdvar( "ui_char_museum_mode" );
	SetSavedDvar( "ui_hidemap", "1" );
	
	if( level.level_mode == "credits_1" )
	{
		maps\af_chase_fx::main();
		maps\af_chase_knife_fight::add_knife_fight_starts();
		maps\char_museum::main();
		maps\af_chase_knife_fight::init_ending();
		thread maps\af_chase_knife_fight::init_main_and_ending_common_stuff();
		maps\af_chase_anim::main_anim();
			
		maps\ending_precache::main();
		maps\_load::main();
		
		thread exploder( "heli_fire" );
		thread maps\af_chase_knife_fight::startpoint_catchup();
		thread maps\af_chase_knife_fight::knife_fight_objectives();
		thread ending_music();
	}
	else
	{
		maps\animated_models\foliage_pacific_tropic_shrub01::main();
		maps\animated_models\foliage_tree_palm_tall_2::main();
		maps\animated_models\jeepride_shrubgroup_02_anim::main();
		maps\char_museum::main();
	}
}

ending_music()
{
	switch ( level.start_point )
	{
		case "default":
		case "wakeup":
		case "wakefast":
		case "turnbuckle":
		case "gloat":
		flag_wait( "af_chase_final_fight" );
		case "gun_drop":
		musicplaywrapper( "af_chase_final_fight" ); // becomes ~1 second desynced but I don't care.
		case "crawl":
		case "gun_kick":
		case "wounded":
		case "pullout":
		case "kill":
		case "price_wakeup":
		case "walkoff":
		
		flag_wait( "af_chase_final_ending" );
		musicplaywrapper( "af_chase_final_ending" );
		flag_wait( "af_chase_ending_credits" );
		music_loop( "af_chase_ending_credits" , 122, 1 );
		
		break;

		default:
			AssertMsg( "Unhandled start point " + level.start_point );
			break;
	}
	
}