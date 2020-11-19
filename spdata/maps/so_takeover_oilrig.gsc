#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

main()
{
	precacheModel( "com_barrel_white_rust" );
	precacheModel( "com_barrel_blue_rust" );
	
	// settings for this challenge
	level.pmc_gametype = "mode_elimination";
	level.pmc_enemies = 15;
	level.pmc_alljuggernauts = true;
	level.pmc_enemies_alive = 1;
	level.pmc_low_enemy_count = 3; // Used for pulsing the hud
	
	save_triggers();
	so_delete_all_spawntriggers();
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_breach_ents();
	
	maps\oilrig_precache::main();
	maps\createart\oilrig_fog::main();
	maps\oilrig_fx::main();
	maps\createfx\oilrig_audio::main();
	maps\_pmc::preLoad();
    maps\_load::main();
    maps\_pmc::main();
    level thread maps\oilrig_amb::main();
    thread scale_juggernaut_enemies();
	thread maps\oilrig::killtrigger_ocean_on();
    
    door1 = getent( "door_deck1", "targetname" );
    door1 connectPaths();
    door1 delete();
    
    door2 = getent( "door_deck1_opposite", "targetname" );
    door2 connectPaths();
    door2 delete();
    
    eGate = getent( "gate_01", "targetname" );
	eGate connectpaths();
	eGate moveto( ( eGate.origin - ( 0, -170, 0 ) ), 1 );
	
	fix_c4_barrels();
	
	maps\_compass::setupMiniMap( "compass_map_oilrig_lvl_1" );
	array_thread( getentarray( "compassTriggers", "targetname" ), ::compass_triggers_think );
	array_thread( getentarray( "compassTriggers", "targetname" ), maps\oilrig::compass_triggers_think );
	array_call( getentarray( "hide", "script_noteworthy" ), ::hide );

	music_loop( "so_takeover_oilrig_music", 136 );
	DDS = getentarray( "sub_dds_01", "targetname" );
	DoorDDS = getentarray( "dds_door_01", "targetname" );
	array_thread( DDS,::hide_entity );
	array_thread( DoorDDS,::hide_entity );
	DDS = getentarray( "sub_dds_02", "targetname" );
	DoorDDS = getentarray( "dds_door_02", "targetname" );
	array_thread( DDS,::hide_entity );
	array_thread( DoorDDS,::hide_entity );

	thread maps\oilrig::above_water_art_and_ambient_setup();
}

fix_c4_barrels()
{
	array_call( getentarray( "c4barrelPacks", "script_noteworthy" ), ::delete );
	
	barrels = getentarray( "c4_barrel", "script_noteworthy" );
	foreach( barrel in barrels )
	{
		if ( cointoss() )
			barrel setModel( "com_barrel_white_rust" );
		else
			barrel setModel( "com_barrel_blue_rust" );
	}
}

save_triggers()
{
	array_thread( getentarray( "compassTriggers", "targetname" ), ::make_special_op_ent );
	getent( "killtrigger_ocean", "targetname" ) make_special_op_ent();
}

make_special_op_ent()
{
	assert( isdefined( self ) );
	self.script_specialops = 1;
}

compass_triggers_think()
{
	assertex( isdefined( self.script_noteworthy ), "compassTrigger at " + self.origin + " needs to have a script_noteworthy with the name of the minimap to use" );
	while( true )
	{
		wait( 1 );
		self waittill( "trigger" );
		setsaveddvar( "ui_hidemap", 0 );
		maps\_compass::setupMiniMap( self.script_noteworthy );
	}
}

scale_juggernaut_enemies()
{
	for(;;)
	{
		level waittill( "update_enemies_remaining_count" );
		
		if ( level.pmc.enemies_remaining >= 12 )
			level.pmc.max_ai_alive = 1;
		else if ( level.pmc.enemies_remaining >= 8 )
			level.pmc.max_ai_alive = 2;
		else
			level.pmc.max_ai_alive = 3;
	}
}