#include maps\_utility;
#include common_scripts\utility;

init_loadout()
{
	if ( !isdefined( level.dodgeloadout ) )
		give_loadout();
	level.loadoutComplete = true;
	level notify( "loadout complete" );
}


SetDefaultActionSlot()
{
	self SetActionSlot( 1, "" );
	self SetActionSlot( 2, "" );
	self SetActionSlot( 3, "altMode" );	// toggles between attached grenade launcher
	self SetActionSlot( 4, "" );
}

init_player()
{
	self SetDefaultActionSlot();
	self takeAllweapons();
}

// checks if character switched in coop mode, if so returns true, call once.
char_switcher()
{
	level.coop_player1 = level.player;
	level.coop_player2 = level.player2;

	if ( isdefined( level.character_switched ) && level.character_switched )
	{
		if ( is_coop() )
		{
			foreach ( player in level.players )
			{
				player init_player();
			}

			level.coop_player1 = level.player2;
			level.coop_player2 = level.player;
			level.character_switched = true;
			return true;
		}
		else
		{
			level.player init_player();

			level.coop_player1 = undefined;
			level.coop_player2 = level.player;

			level.character_switched = true;
			return true;
		}
	}
	return false;
}


give_loadout( character_selected )
{

	if ( !isdefined( character_selected ) )
		character_selected = false;

	level.character_selected = character_selected;

	// used to precach weapons for alternate character loadouts, will be replaced by later code efficent support.
	possible_precache_items = [];

	level.player SetDefaultActionSlot();
	if ( is_coop() )
		level.player2 SetDefaultActionSlot();

	if ( !isdefined( game[ "expectedlevel" ] ) )
		game[ "expectedlevel" ] = "";

	if ( !isdefined( level.campaign ) )
		level.campaign = "american";

	if ( string_starts_with( level.script, "pmc_" ) )
	{
		level.player setViewmodel( "viewmodel_base_viewhands" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );
			level.player2 setViewmodel( "viewmodel_base_viewhands" );
		}
		level.campaign = "american";
		return;
	}

	if ( is_specialop() )
	{
		give_loadout_specialops( character_selected );
		return;
	}
	
//	if ( string_starts_with( level.script, "co_" ) )
//	{
//		precacheModel( "weapon_parabolic_knife" );
//	}

	if ( level.script == "background" )
	{
		level.player takeallweapons();
		return;
	}
	if ( level.script == "iw4_credits" )
	{
		level.player takeallweapons();
		return;
	}
	
	if ( level.script == "contingency" )
	{
		level.starting_sidearm = "usp_silencer";
		level.starting_rifle = "m21_scoped_arctic_silenced";
		
		level.player giveWeapon( level.starting_sidearm );
		level.player giveWeapon( level.starting_rifle );
		level.player giveWeapon( "fraggrenade" );
		
		//order matters
		//level.player SetOffhandSecondaryClass( "other" );
		//level.player giveWeapon( "semtex_grenade" );

		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "flash_grenade" );
		
		level.player switchToWeapon( level.starting_rifle );
		level.player setViewmodel( "ch_viewhands_gk_ar15" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "invasion" )
	{
		level.player giveWeapon( "beretta" );
		//level.player giveWeapon( "scar_h" );
		//level.player giveWeapon( "scar_h_reflex" );
		level.player giveWeapon( "scar_h_reflex_shotgun" );
		
		level.player giveWeapon( "fraggrenade" );
		
		//order matters
		//level.player SetOffhandSecondaryClass( "other" );
		//level.player giveWeapon( "semtex_grenade" );

		level.player giveWeapon( "smoke_grenade_american" );
		level.player setOffhandSecondaryClass( "smoke" );
		
		//level.player giveWeapon( "flash_grenade" );
		//level.player setOffhandSecondaryClass( "flash" );
		
		//level.player switchToWeapon( "scar_h" );
		//level.player switchToWeapon( "scar_h_reflex" );
		level.player switchToWeapon( "scar_h_reflex_shotgun" );
		level.player setViewmodel( "ch_viewhands_gk_ump9" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "arcadia" )
	{
		level.player giveWeapon( "beretta" );
		//level.player giveWeapon( "scar_h" );
		level.player giveWeapon( "scar_h_reflex" );
		level.player giveWeapon( "fraggrenade" );
		
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "flash_grenade" );
		
		level.player switchToWeapon( "scar_h_reflex" );
		level.player setViewmodel( "ch_viewhands_gk_ump9" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "airport" )
	{
		//level.player giveWeapon( "usp" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "m240" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m240" );
		level.player setViewmodel( "ch_viewhands_gk_ump45" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "cliffhanger" )
	{
		//see player_weapon_init in cliffhanger_code
		level.player setViewmodel( "ch_viewhands_gk_ar15" );
		level.campaign = "british";
		return;
	}

	if ( level.script == "hacienda" )
	{
		level.player giveWeapon( "cheytac" );
		level.player giveWeapon( "usp_silencer" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "cheytac" );
		level.player setViewmodel( "viewmodel_base_viewhands" );

		level.campaign = "american";
		return;
	}
	
	if ( level.script == "cityscale" )
	{
		level.player giveWeapon( "p90" );
		level.player givemaxammo( "p90" );
		level.player giveWeapon( "usp_silencer" );
		level.player givemaxammo( "usp_silencer" );
		level.player giveWeapon( "fraggrenade" );
		level.player switchToWeapon( "p90" );
		level.player setViewmodel( "viewhands_sas_woodland" );

		level.campaign = "american";
		return;
	}

	if ( level.script == "tulsa" )
	{
		level.player giveWeapon( "p90" );
		level.player givemaxammo( "p90" );
		level.player giveWeapon( "colt45" );
		level.player givemaxammo( "colt45" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "p90" );
		level.player setViewmodel( "viewmodel_base_viewhands" );

		level.campaign = "american";
		return;
	}

	if ( level.script == "bridge" )
	{
		level.player takeAllWeapons();
		level.player giveWeapon( "g36c_reflex" );
		level.player givemaxammo( "g36c_reflex" );
		level.player giveWeapon( "aa12" );
		level.player givemaxammo( "aa12" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "g36c_reflex" );
		level.player setViewmodel( "viewhands_black_kit" );

		level.campaign = "secretservice";
		return;
	}

	if ( level.script == "moto" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player givemaxammo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "usp_silencer" );
		level.player givemaxammo( "usp_silencer" );
		level.player giveWeapon( "fraggrenade" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		level.player setViewmodel( "viewmodel_base_viewhands" );

		level.campaign = "american";
		return;
	}
	
	if ( level.script == "dcburning" )
	{

		level.player giveWeapon( "m4m203_eotech" );
		level.player giveWeapon( "Beretta" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player SetActionSlot( 1, "nightvision" );
		level.player giveWeapon("claymore");
		level.player givemaxammo( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player setViewmodel( "ch_viewhands_gk_ump9" );
		level.player switchToWeapon( "m4m203_eotech" );
		level.campaign = "american";
		return;
	}
	if ( level.script == "trainer" )
	{

		level.player giveWeapon( "m4_grunt" );
		level.player giveWeapon( "deserteagle" );
		level.player giveWeapon( "fraggrenade" );
		level.player SetWeaponAmmoStock( "fraggrenade", 0 );
		level.player SetWeaponAmmoClip( "fraggrenade", 0 );
		level.player setViewmodel( "ch_viewhands_gk_ump45" );
		level.player switchToWeapon( "m4_grunt" );
		level.campaign = "american";
		return;
	}
	if ( level.script == "dcemp" )
	{
		level.player giveWeapon( "m4m203_eotech" );
		level.player giveWeapon( "Beretta" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		//level.player SetActionSlot( 1, "nightvision" );
		level.player setViewmodel( "ch_viewhands_gk_ump9" );
		level.player switchToWeapon( "m4m203_eotech" );
		level.campaign = "american";
		return;
	}
	if ( level.script == "dc_whitehouse" )
	{
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "dcemp" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player giveWeapon( "m4_grenadier" );
			level.player giveWeapon( "Beretta" );
			level.player giveWeapon( "fraggrenade" );
			level.player giveWeapon( "flash_grenade" );
			level.player switchToWeapon( "m4_grenadier" );
		}

		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "ch_viewhands_gk_ump9" );
		level.campaign = "american";

		return;
	}

	if ( level.script == "roadkill" )
	{
		weapon = "m14_scoped";
		weapon = "m4m203_acog";
		//weapon = "javelin";
		// "m79"

		//level.player giveWeapon( weapon );
		level.player giveWeapon( "beretta" );
		level.player giveWeapon( "m4m203_eotech" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "ch_viewhands_gk_ump45" );
		level.player switchToWeapon( "m4m203_eotech" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "suburban_america" )
	{
		level.player giveWeapon( "p90" );
		level.player givemaxammo( "p90" );
		level.player giveWeapon( "usp_silencer" );
		level.player givemaxammo( "usp_silencer" );
		level.player giveWeapon( "fraggrenade" );
		level.player switchToWeapon( "p90" );
		level.player setViewmodel( "viewhands_sas_woodland" );

		level.campaign = "american";
		return;
	}
	
	if ( level.script == "favela" )
	{
		level.player giveWeapon( "m1014" );
		level.player giveWeapon( "masada_grenadier_acog" );
		level.player switchToWeapon( "masada_grenadier_acog" );
		level.player setViewmodel( "ch_viewhands_gk_ar15" );
		level.campaign = "taskforce";
		return;
	}

	if ( level.script == "boneyard" )
	{
		level.player giveWeapon( "m14_scoped_silencer" );
		level.player giveWeapon( "mp5_silencer_reflex" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player switchToWeapon( "m14_scoped_silencer" );
		level.player setViewmodel( "ch_viewhands_gk_m4_sopmod_ii" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "af_caves" )
	{
		primary = "cheytac_silencer";
		secondary = "kriss_acog_silencer";
		
		level.player GiveWeapon( secondary );
		level.player GiveWeapon( primary );
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player switchToWeapon( primary );
		level.player setViewmodel( "ch_viewhands_gk_m4_sopmod_ii" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "af_chase" || level.script == "af_end" || level.script == "ending" )
	{               
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "af_caves" );
		
		if( ! bWeaponsCarriedOver )
		{
			level.player giveWeapon( "uzi" );
			level.player giveWeapon( "rpd" );
	//		level.player giveWeapon( "uzi_fast_reload", 0, true );
			level.player setOffhandSecondaryClass( "flash" );
			level.player giveWeapon( "fraggrenade" );
			level.player giveWeapon( "flash_grenade" );
			level.player switchToWeapon( "uzi" );
		}
		level.player setViewmodel( "ch_viewhands_gk_m4_sopmod_ii" );
		level.campaign = "american";
		return;
	}
	
	if ( level.script == "co_suburban_america" )
	{
		// this is too be replaced again by some kind of string table. I just couldn't stand the way it was setup and I think this will translate well to stringtable format.
		switch_char = char_switcher();

		// co player 1 loadout
		so_player_num( 0 );

		so_player_giveWeapon( "m4m203_silencer_reflex" );
		so_player_giveWeapon( "usp_silencer" );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_maxammo( "m4m203_silencer_reflex" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_set_switchToWeapon( "m4m203_silencer_reflex" );
		so_player_set_setViewmodel( "viewhands_sas_woodland" );
		so_player_SetModelFunc( ::so_body_player_woodland, ::so_body_player_woodland_precache );

		// co player 2 loadout
		so_player_num( 1 );

		so_player_giveWeapon( "m14_scoped_silencer_woodland" );
		so_player_giveWeapon( "usp_silencer" );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_maxammo( "m14_scoped_silencer_woodland" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_set_switchToWeapon( "m14_scoped_silencer_woodland" );
		so_player_set_setViewmodel( "viewhands_sas_woodland" );
		so_player_setactionslot( 4, "weapon", "claymore" );
		so_player_SetModelFunc( ::so_body_player_woodland, ::so_body_player_woodland_precache );

		so_players_give_loadout();
		level.campaign = "british";
		return;
	}


	if ( level.script == "co_overgrown" )
	{
		// everybody does it different!! I'm making a new way.
		switch_char = char_switcher();

		if ( !character_selected )
			precacheModel( "weapon_parabolic_knife" );

		// co player 1 loadout
		so_player_num( 0 );

		so_player_giveWeapon( "m4m203_silencer_reflex" );
		so_player_giveWeapon( "usp_silencer" );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_maxammo( "m4m203_silencer_reflex" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_set_switchToWeapon( "m4m203_silencer_reflex" );
		so_player_set_setViewmodel( "viewhands_sas_woodland" );
		so_player_SetModelFunc( ::so_body_player_woodland, ::so_body_player_woodland_precache );

		// co player 2 loadout
		so_player_num( 1 );

		so_player_giveWeapon( "m14_scoped_silencer_woodland" );
		so_player_giveWeapon( "usp_silencer" );
		so_player_giveWeapon( "fraggrenade" );
		so_player_giveWeapon( "flash_grenade" );
		so_player_set_maxammo( "m14_scoped_silencer_woodland" );
		so_player_set_setOffhandSecondaryClass( "flash" );
		so_player_set_switchToWeapon( "m14_scoped_silencer_woodland" );
		so_player_set_setViewmodel( "viewhands_sas_woodland" );
		so_player_setactionslot( 4, "weapon", "claymore" );
		so_player_SetModelFunc( ::so_body_player_woodland, ::so_body_player_woodland_precache );

		so_players_give_loadout();
		level.campaign = "british";
		return;
	}

/*
	if ( level.script == "co_hunted" )
	{
		if ( is_coop() )
		{
			// there is a wait at character selection, can not precache after a wait
			if ( !character_selected )
				precacheModel( "weapon_parabolic_knife" );

			assert( isdefined( level.players ) );
			assert( level.players.size >= 2 );
			for ( i = 0 ; i < level.players.size ; i++ )
			{
				level.players[ i ] SetModelFunc( ::so_body_player_ranger );
				level.players[ i ] giveWeapon( "Beretta" );
				level.players[ i ] giveWeapon( "m4_grenadier" );
				level.players[ i ] giveWeapon( "fraggrenade" );
				level.players[ i ] giveWeapon( "flash_grenade" );
				level.players[ i ] setOffhandSecondaryClass( "flash" );
				level.players[ i ] giveWeapon( "laser_targeting_device" );
				level.players[ i ] SetActionSlot( 4, "weapon", "laser_targeting_device" );
				level.players[ i ] switchToWeapon( "m4_grenadier" );
				level.players[ i ] setViewmodel( "viewmodel_base_viewhands" );
			}
		}
		else
		{
			level.player giveWeapon( "Beretta" );
			level.player giveWeapon( "m4_grenadier" );
			level.player giveWeapon( "fraggrenade" );
			level.player giveWeapon( "flash_grenade" );
			level.player setOffhandSecondaryClass( "flash" );
			level.player switchToWeapon( "m4_grenadier" );
			level.player setViewmodel( "viewmodel_base_viewhands" );
		}
		return;
	}
*/
	if ( level.script == "co_crossfire" )
	{
		foreach ( playerIndex, player in level.players )
		{
			so_player_num( playerIndex );

			so_player_giveWeapon( "Beretta" );
			so_player_giveWeapon( "m4_grenadier" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_giveWeapon( "claymore" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_set_switchToWeapon( "m203_m4" );
			so_player_set_setViewmodel( "viewmodel_base_viewhands" );
			so_player_set_maxammo( "claymore" );
			so_player_setactionslot( 4, "weapon", "claymore" );
			so_player_SetModelFunc( ::so_body_player_ranger, ::so_body_player_ranger_precache );
		}

		so_players_give_loadout();
		level.campaign = "american";
		return;

	}

	if ( level.script == "killhouse" )
	{
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player SetWeaponAmmoStock( "fraggrenade", 0 );
		level.player SetWeaponAmmoClip( "fraggrenade", 0 );
		level.player SetWeaponAmmoStock( "flash_grenade", 0 );
		level.player SetWeaponAmmoClip( "flash_grenade", 0 );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_black_kit" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 SetWeaponAmmoStock( "fraggrenade", 0 );
			level.player2 SetWeaponAmmoClip( "fraggrenade", 0 );
			level.player2 SetWeaponAmmoStock( "flash_grenade", 0 );
			level.player2 SetWeaponAmmoClip( "flash_grenade", 0 );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_black_kit" );
		}
		level.campaign = "british";
		return;
	}

	if ( level.script == "cargoship" )
	{
		level.player giveWeapon( "USP" );
		level.player giveWeapon( "mp5_silencer" );
		level.player giveMaxAmmo( "mp5_silencer" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon( "mp5_silencer" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_black_kit" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "USP" );
			level.player2 giveWeapon( "mp5_silencer" );
			level.player2 giveMaxAmmo( "mp5_silencer" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 switchtoWeapon( "mp5_silencer" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_black_kit" );
		}
		level.campaign = "british";
		return;
	}

	if ( level.script == "coup" )
	{
		level.campaign = "american";
		return;
	}

	if ( level.script == "blackout" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player givemaxammo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "m14_scoped_silencer_woodland" );
		level.player giveMaxAmmo( "m14_scoped_silencer_woodland" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m14_scoped_silencer_woodland" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "m4m203_silencer_reflex" );
			level.player2 giveWeapon( "m14_scoped_silencer_woodland" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
			level.player2 switchToWeapon( "m4m203_silencer_reflex" );
		}
		level.campaign = "american";
		return;
	}


	if ( level.script == "co_killhouse" )
	{
		switch_char = char_switcher();

		// used to precach weapons for alternate character loadouts, will be replaced by later code efficent support.
		possible_precache_items[ possible_precache_items.size ] = "mp5_silencer";
		possible_precache_items[ possible_precache_items.size ] = "claymore";

		// first character
		if ( isdefined( level.coop_player1 ) )
		{
			if ( is_coop() )
				level.coop_player1 SetModelFunc( ::so_body_player_woodland );

			level.coop_player1 giveWeapon( "usp_silencer" );
			level.coop_player1 givemaxammo( "m4m203_silencer_reflex" );
			level.coop_player1 giveWeapon( "m4m203_silencer_reflex" );
			level.coop_player1 giveWeapon( "fraggrenade" );
			level.coop_player1 giveWeapon( "flash_grenade" );
			level.coop_player1 setOffhandSecondaryClass( "flash" );
			level.coop_player1 switchToWeapon( "m4m203_silencer_reflex" );
			level.coop_player1 setViewmodel( "viewhands_black_kit" );
		}

		// second character
		if ( isdefined( level.coop_player2 ) )
		{
			if ( is_coop() )
				level.coop_player2 SetModelFunc( ::so_body_player_woodland );

			level.coop_player2 giveWeapon( "usp_silencer" );
			level.coop_player2 giveWeapon( "mp5_silencer" );
			level.coop_player2 giveMaxAmmo( "mp5_silencer" );
			level.coop_player2 giveWeapon( "fraggrenade" );
			level.coop_player2 giveWeapon( "flash_grenade" );
			level.coop_player2 setOffhandSecondaryClass( "flash" );
			level.coop_player2 switchToWeapon( "mp5_silencer" );
			level.coop_player2 setViewmodel( "viewhands_black_kit" );

		}

		if ( !character_selected )
		{
			if ( is_coop() )
				precacheModel( "weapon_parabolic_knife" );
			possible_precache( possible_precache_items );
		}

		level.campaign = "american";
		return;
	}

	if ( level.script == "co_blackout" )
	{
		// used to precach weapons for alternate character loadouts, this will be replaced by later code efficent support.
		possible_precache_items[ possible_precache_items.size ] = "m14_scoped_silencer_woodland";

		foreach ( playerIndex, player in level.players )
		{
			player init_player();
			if ( playerIndex % 2 == 0 )
			{
				player SetModelFunc( ::so_body_player_woodland );
				player giveWeapon( "usp_silencer" );
				player givemaxammo( "m4m203_silencer_reflex" );
				player giveWeapon( "m4m203_silencer_reflex" );
				player giveWeapon( "fraggrenade" );
				player giveWeapon( "flash_grenade" );
				player setOffhandSecondaryClass( "flash" );
				player switchToWeapon( "m4m203_silencer_reflex" );
				player SetActionSlot( 1, "nightvision" );
				player setViewmodel( "viewhands_sas_woodland" );
			}
			else
			{
				player SetModelFunc( ::so_body_player_woodland );
				player giveWeapon( "usp_silencer" );
				player giveWeapon( "m14_scoped_silencer_woodland" );
				player giveMaxAmmo( "m14_scoped_silencer_woodland" );
				player giveWeapon( "fraggrenade" );
				player giveWeapon( "flash_grenade" );
				player setOffhandSecondaryClass( "flash" );
				player switchToWeapon( "m14_scoped_silencer_woodland" );
				player SetActionSlot( 1, "nightvision" );
				player setViewmodel( "viewhands_sas_woodland" );
			}
		}

		if ( !character_selected )
		{
			if ( is_coop() )
				precacheModel( "weapon_parabolic_knife" );
			possible_precache( possible_precache_items );
		}

		level.campaign = "american";
		return;
	}

	if ( level.script == "co_rescue" )
	{
		switch_char = char_switcher();

		foreach ( playerIndex, player in level.players )
		{
			if ( is_coop() )
				player SetModelFunc( ::so_body_player_ranger );

			player giveWeapon( "Beretta" );
			player giveWeapon( "m4_grunt" );
			player switchToWeapon( "m4_grunt" );
			player giveWeapon( "fraggrenade" );
			player giveWeapon( "flash_grenade" );
			player setOffhandSecondaryClass( "flash" );
			player setViewmodel( "viewmodel_base_viewhands" );
		}

		if ( !character_selected )
		{
			if ( is_coop() )
				precacheModel( "weapon_parabolic_knife" );
			possible_precache( possible_precache_items );
		}

		level.campaign = "american";
		return;
	}

	if ( level.script == "co_armada" )
	{
		switch_char = char_switcher();

		foreach ( playerIndex, player in level.players )
		{
		  // co player 1 loadout
		  so_player_num( playerIndex );
  
		  so_player_giveWeapon( "Beretta" );
		  so_player_giveWeapon( "m4_grunt" );
		  so_player_giveWeapon( "fraggrenade" );
		  so_player_giveWeapon( "flash_grenade" );
		  so_player_giveWeapon( "claymore" );
		  so_player_set_setOffhandSecondaryClass( "flash" );
		  so_player_set_switchToWeapon( "m4_grunt" );
		  so_player_set_setViewmodel( "viewmodel_base_viewhands" );
		  so_player_set_maxammo( "claymore" );
		  so_player_setactionslot( 4, "weapon", "claymore" );
		  so_player_SetModelFunc( ::so_body_player_ranger, ::so_body_player_ranger_precache );
   		}

		so_players_give_loadout();
		level.campaign = "american";
		return;

	}

	if ( level.script == "armada" )
	{
		level.player giveWeapon( "Beretta" );
		level.player giveWeapon( "m4_grunt" );
		level.player switchToWeapon( "m4_grunt" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "claymore" );
		level.player givemaxammo( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player takeweapon( "claymore" );
		level.player setViewmodel( "viewmodel_base_viewhands" );

		if ( is_coop() )
		{
			level.player2 giveWeapon( "Beretta" );
			level.player2 giveWeapon( "m4_grunt" );
			level.player2 switchToWeapon( "m4_grunt" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 giveWeapon( "claymore" );
			level.player2 givemaxammo( "claymore" );
			level.player2 SetActionSlot( 4, "weapon", "claymore" );
			level.player2 takeweapon( "claymore" );
			level.player2 setViewmodel( "viewmodel_base_viewhands" );
		}

		level.campaign = "american";
		return;
	}

	if ( level.script == "bog_a" || level.script == "co_break" )
	{
		level.player giveWeapon( "Beretta" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.player switchToWeapon( "m4_grenadier" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "Beretta" );
			level.player2 giveWeapon( "m4_grenadier" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewmodel_base_viewhands" );
			level.player2 switchToWeapon( "m4_grenadier" );
		}
		level.campaign = "american";
		return;
	}


	if ( level.script == "oilrig" )
	{
		level.player giveWeapon( "scar_h_thermal_silencer" );
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "ch_viewhands_gk_ar15" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		level.player giveWeapon("claymore");
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.campaign = "seal";
		return;
	}
	
	if ( level.script == "gulag" )
	{
		//level.player giveWeapon( "glock" );
		//level.player giveWeapon( "barrett" );
		//level.player giveWeapon( "ump45" );
		//level.player giveWeapon( "fraggrenade" );
		//level.player giveWeapon( "flash_grenade" );
		//level.player setOffhandSecondaryClass( "flash" );
		//level.player setViewmodel( "viewhands_black_kit" );
		//level.player switchToWeapon( "barrett" );
		//level.player switchToWeapon( "ump45" );
		//level.player giveWeapon( "claymore" );
		//level.player SetActionSlot( 4, "weapon", "claymore" );
		
		level.campaign = "seal";
		return;
	}

	if( level.script == "favela_escape" )
	{
		//level.favela_escape_main_weapon = "m4m203_acog";
		level.favela_escape_main_weapon = "ump45_acog";
		set_legit_weapons_for_favela_escape();
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "favela" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player GiveWeapon( level.favela_escape_main_weapon );
			level.player GiveWeapon( "glock" );
			level.player SwitchToWeapon( level.favela_escape_main_weapon );
		}
		else
		{
			force_player_to_use_legit_sniper_escape_weapon();
		}

		level.player GiveWeapon( "fraggrenade" );
		level.player GiveWeapon( "flash_grenade" );
		level.player SetOffhandSecondaryClass( "flash" );

		level.player setViewmodel( "ch_viewhands_gk_ar15" );
		
		level.campaign = "taskforce";

		return;
	}

	if ( level.script == "highrise" )
	{
		level.player giveWeapon( "usp_silencer" );
		level.player giveWeapon( "uzi_sd" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.player switchToWeapon( "uzi_sd" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_seal );
			level.player2 SetModelFunc( ::so_body_player_seal );
			level.player2 giveWeapon( "usp_silencer" );
			level.player2 giveWeapon( "uzi_sd" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_black_kit" );
			level.player2 switchToWeapon( "uzi_sd" );
		}
		level.campaign = "american";
		return;
	}


	if ( level.script == "drydock" )
	{
		level.player giveWeapon( "deserteagle" );
		level.player giveWeapon( "g36c_reflex" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.player switchToWeapon( "g36c_reflex" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_seal );
			level.player2 SetModelFunc( ::so_body_player_seal );
			level.player2 giveWeapon( "deserteagle" );
			level.player2 giveWeapon( "g36c_reflex" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_black_kit" );
			level.player2 switchToWeapon( "g36c_reflex" );
		}
		level.campaign = "american";
		return;
	}


	if ( level.script == "bog_a_backhalf" )
	{
		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "c4" );
		level.player SetActionSlot( 2, "weapon", "c4" );
		level.player switchToWeapon( "m4_grenadier" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "ambush" )
	{

		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "remington700" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player SetWeaponAmmoStock( "remington700", 10 );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "remington700" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}

	if ( level.script == "hunted" )
	{
		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "colt45" );
		level.player setViewmodel( "viewhands_sas_woodland" );

		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "colt45" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 switchToWeapon( "colt45" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
		}
		level.campaign = "british";
		return;
	}

	if ( level.script == "aftermath" )
	{
		level.player takeallweapons();
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "bog_b" )
	{
		level.player giveWeapon( "Beretta" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player giveWeapon( "remote_missile_detonator" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m4_grenadier" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.player SetActionSlot( 4, "weapon", "remote_missile_detonator" );

		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "Beretta" );
			level.player2 giveWeapon( "m4_grenadier" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 switchToWeapon( "m4_grenadier" );
			level.player2 setViewmodel( "viewmodel_base_viewhands" );
			level.player2 SetActionSlot( 4, "weapon", "remote_missile_detonator" );
		}
		level.campaign = "american";
		return;
	}

	if ( level.script == "airlift" )
	{
		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player switchToWeapon( "m4_grenadier" );
		level.player setViewmodel( "viewmodel_base_viewhands" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "village_assault" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player giveMaxAmmo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "m1014" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player giveMaxAmmo( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "c4" );
		level.player giveWeapon( "cobra_air_support" );
		level.player SetActionSlot( 4, "weapon", "cobra_air_support" );
		level.player SetActionSlot( 2, "weapon", "c4" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		level.player setViewmodel( "viewhands_sas_woodland" );

		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "m4m203_silencer_reflex" );
			level.player2 giveMaxAmmo( "m4m203_silencer_reflex" );
			level.player2 giveWeapon( "m1014" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 giveMaxAmmo( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 giveWeapon( "c4" );
			level.player2 giveWeapon( "cobra_air_support" );
			level.player2 SetActionSlot( 4, "weapon", "cobra_air_support" );
			level.player2 SetActionSlot( 2, "weapon", "c4" );
			level.player2 switchToWeapon( "m4m203_silencer_reflex" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
		}

		level.campaign = "british";
		return;
	}

	if ( level.script == "scoutsniper" )
	{
		level.player giveWeapon( "m14_scoped_silencer" );
		level.player givemaxammo( "m14_scoped_silencer" );
		level.player giveWeapon( "usp_silencer" );
		level.player givemaxammo( "usp_silencer" );
		level.player giveWeapon( "fraggrenade" );
		level.player switchToWeapon( "m14_scoped_silencer" );
		level.player setViewmodel( "viewhands_marine_sniper" );

		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ghillie );
			level.player2 SetModelFunc( ::so_body_player_ghillie );

			level.player giveWeapon( "claymore" );
			level.player givemaxammo( "claymore" );
			level.player SetActionSlot( 4, "weapon", "claymore" );

			level.player2 giveWeapon( "m14_scoped_silencer" );
			level.player2 givemaxammo( "m14_scoped_silencer" );
			level.player2 giveWeapon( "usp_silencer" );
			level.player2 givemaxammo( "usp_silencer" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "claymore" );
			level.player2 givemaxammo( "claymore" );
			level.player2 SetActionSlot( 4, "weapon", "claymore" );
			level.player2 switchToWeapon( "m14_scoped_silencer" );
			level.player2 setViewmodel( "viewhands_marine_sniper" );
		}

		level.campaign = "british";
		return;
	}

	if ( level.script == "co_scoutsniper" )
	{
		precacheModel( "weapon_parabolic_knife" );

		foreach ( playerIndex, player in level.players )
		{
			player SetModelFunc( ::so_body_player_ghillie );
			player giveWeapon( "m14_scoped_silencer" );
			player givemaxammo( "m14_scoped_silencer" );
			player giveWeapon( "usp_silencer" );
			player givemaxammo( "usp_silencer" );
			player giveWeapon( "fraggrenade" );
			player giveWeapon( "claymore" );
			player givemaxammo( "claymore" );
			player giveWeapon( "c4" );
			player SetActionSlot( 2, "weapon", "c4" );
			player SetActionSlot( 4, "weapon", "claymore" );
			player switchToWeapon( "m14_scoped_silencer" );
			player setViewmodel( "viewhands_marine_sniper" );
		}
		level.campaign = "british";
		return;
	}

	if ( level.script == "sniperescape" )
	{
		level.sniperescape_main_weapon = "m14_scoped_woodland";
		set_legit_weapons_for_sniper_escape();
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "scoutsniper" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player giveWeapon( level.sniperescape_main_weapon );
			level.player giveWeapon( "usp_silencer" );
			level.player switchtoWeapon( level.sniperescape_main_weapon );
		}
		else
		{
			force_player_to_use_legit_sniper_escape_weapon();
		}

		// set these regardless of starting from level select menu OR previous level
		level.campaign = "british";
		level.initclaymoreammo = 6;

		sniper_escape_initial_secondary_weapon_loadout();

		return;
	}

	if ( level.script == "village_defend" )
	{
		level.player giveWeapon( "m14_scoped_woodland" );
		level.player giveWeapon( "saw" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "smoke_grenade_american" );
		level.player setOffhandSecondaryClass( "smoke" );
		level.player giveWeapon( "claymore" );
		level.player givemaxammo( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player switchToWeapon( "saw" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}

	if ( level.script == "icbm" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		level.player giveWeapon( "usp_silencer" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player giveWeapon( "c4" );
		level.player SetActionSlot( 2, "weapon", "c4" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		maps\_load::set_player_viewhand_model( "viewhands_player_sas_woodland" );
		level.campaign = "british";
		return;
	}

	if ( level.script == "co_launchfacility_a" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player giveMaxAmmo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "usp_silencer" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		level.initclaymoreammo = 6;
		level.player giveWeapon( "claymore" );
		level.player givemaxammo( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "smoke_grenade_american" );
		level.player setOffhandSecondaryClass( "smoke" );
		level.player setViewmodel( "viewhands_sas_woodland" );

		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_woodland );
			level.player2 SetModelFunc( ::so_body_player_woodland );

			level.player2 giveWeapon( "m1014" );
			level.player2 giveMaxAmmo( "m1014" );
			level.player2 giveWeapon( "m14_scoped_woodland" );
			level.player2 switchToWeapon( "m1014" );
			level.initclaymoreammo = 6;
			level.player2 giveWeapon( "claymore" );
			level.player2 givemaxammo( "claymore" );
			level.player2 SetActionSlot( 4, "weapon", "claymore" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "smoke_grenade_american" );
			level.player2 setOffhandSecondaryClass( "smoke" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
		}

		level.campaign = "british";

		return;
	}

	if ( level.script == "launchfacility_a" )
	{
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "icbm" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player giveWeapon( "usp_silencer" );
			level.player giveWeapon( "m4m203_silencer_reflex" );
			level.player switchToWeapon( "m4m203_silencer_reflex" );

			if ( is_coop() )
			{
				level.player2 giveWeapon( "usp_silencer" );
				level.player2 giveWeapon( "m4m203_silencer_reflex" );
				level.player2 switchToWeapon( "m4m203_silencer_reflex" );
			}
		}


		// set these regardless of starting from level select menu OR previous level
		level.campaign = "british";
		level.initclaymoreammo = 6;
		level.player giveWeapon( "claymore" );
		level.player givemaxammo( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player giveWeapon( "c4" );
		level.player SetActionSlot( 2, "weapon", "c4" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "smoke_grenade_american" );
		level.player setOffhandSecondaryClass( "smoke" );
		level.player setViewmodel( "viewhands_sas_woodland" );


		if ( is_coop() )
		{
			level.player2 giveWeapon( "claymore" );
			level.player2 givemaxammo( "claymore" );
			level.player2 SetActionSlot( 4, "weapon", "claymore" );
			level.player2 giveWeapon( "c4" );
			level.player2 SetActionSlot( 2, "weapon", "c4" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "smoke_grenade_american" );
			level.player2 setOffhandSecondaryClass( "smoke" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
		}

		return;
	}

	if ( level.script == "launchfacility_b" )
	{
		// if started from previous level and weapons were saved, carry them over
		bWeaponsCarriedOver = RestorePlayerWeaponStatePersistent( "launchfacility_a" );

		// if started cold from level select menu, give a loadout
		if ( !bWeaponsCarriedOver )
		{
			level.player giveWeapon( "usp_silencer" );
			level.player giveWeapon( "m4m203_silencer_reflex" );
			level.player switchToWeapon( "m4m203_silencer_reflex" );

			if ( is_coop() )
			{
				level.player2 giveWeapon( "usp_silencer" );
				level.player2 giveWeapon( "m4m203_silencer_reflex" );
				level.player2 switchToWeapon( "m4m203_silencer_reflex" );
			}
		}

		// set these regardless of starting from level select menu OR previous level
		level.campaign = "british";
		level.player giveWeapon( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player giveWeapon( "c4" );
		level.player SetActionSlot( 2, "weapon", "c4" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_sas_woodland" );

		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_seal );
			level.player2 SetModelFunc( ::so_body_player_seal );

			level.player2 giveWeapon( "claymore" );
			level.player2 SetActionSlot( 4, "weapon", "claymore" );
			level.player2 giveWeapon( "c4" );
			level.player2 SetActionSlot( 2, "weapon", "c4" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );

		}
		return;
	}

	if ( level.script == "bigcity_destroyed" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player givemaxammo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "m4m203_silencer_reflex" );
			level.player2 giveWeapon( "m14_scoped_silencer_woodland" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
			level.player2 switchToWeapon( "m4m203_silencer_reflex" );
		}
		level.campaign = "american";
		return;
	}

	if ( level.script == "iss" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player givemaxammo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "m4m203_silencer_reflex" );
			level.player2 giveWeapon( "m14_scoped_silencer_woodland" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
			level.player2 switchToWeapon( "m4m203_silencer_reflex" );
		}
		level.campaign = "american";
		return;
	}

	if ( level.script == "gasstation" )
	{
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player givemaxammo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "m4m203_silencer_reflex" );
			level.player2 giveWeapon( "m14_scoped_silencer_woodland" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
			level.player2 switchToWeapon( "m4m203_silencer_reflex" );
		}
		level.campaign = "american";
		return;
	}

	if ( level.script == "terminal" )
	{
		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "m4m203_silencer_reflex" );
		level.player givemaxammo( "m4m203_silencer_reflex" );
		level.player giveWeapon( "fraggrenade" );
		level.player giveWeapon( "flash_grenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.player switchToWeapon( "m4m203_silencer_reflex" );
		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ranger );
			level.player2 SetModelFunc( ::so_body_player_ranger );

			level.player2 giveWeapon( "m4m203_silencer_reflex" );
			level.player2 giveWeapon( "m14_scoped_silencer_woodland" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "flash_grenade" );
			level.player2 setOffhandSecondaryClass( "flash" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
			level.player2 switchToWeapon( "m4m203_silencer_reflex" );
		}
		level.campaign = "american";
		return;
	}

	if ( level.script == "jeepride" )
	{
		level.player giveWeapon( "colt45" );
		level.player giveWeapon( "M4_grunt" );
		level.player switchToWeapon( "M4_grunt" );
		level.player giveWeapon( "fraggrenade" );
		level.player setViewmodel( "viewhands_sas_woodland" );
		level.campaign = "british";
		return;
	}

	if ( level.script == "whitehouse_assault" )
	{
		level.player giveWeapon( "usp_silencer" );
		level.player giveWeapon( "m4_grenadier" );
		level.player switchToWeapon( "m4_grenadier" );
		level.player giveWeapon( "fraggrenade" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.campaign = "american";
		return;
	}

	if ( level.script == "simplecredits" )
	{
		return;
	}

	if ( level.script == "airplane" )
	{
		level.player giveWeapon( "usp_silencer" );
		level.player giveWeapon( "mp5_silencer" );
		level.player giveWeapon( "flash_grenade" );
		level.player switchtoWeapon( "mp5_silencer" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player setViewmodel( "viewhands_black_kit" );
		level.campaign = "british";
		return;
	}
	if ( level.script == "co_airplane" )
	{
		if ( level.players.size > 1 )
		{
			level.player SetModelFunc( ::so_body_player_seal );
			precacheModel( "weapon_parabolic_knife" );
		}

		for ( i = 0;i < level.players.size;i++ )
		{
			if ( level.players[ i ] != level.player )
				level.players[ i ] SetModelFunc( ::so_body_player_seal );

			level.players[ i ] giveWeapon( "usp_silencer" );
			level.players[ i ] giveWeapon( "mp5_silencer" );
			level.players[ i ] giveWeapon( "flash_grenade" );
			level.players[ i ] switchtoWeapon( "mp5_silencer" );
			level.players[ i ] setOffhandSecondaryClass( "flash" );
			level.players[ i ] setViewmodel( "viewhands_black_kit" );
		}

		level.campaign = "british";
		return;
	}
	
	if ( level.script == "estate" )
	{
		level.main_gun = "masada_digital_grenadier_eotech";
		level.player giveWeapon( level.main_gun );
		level.player givemaxammo( level.main_gun );
		level.player giveWeapon( "beretta" );
		level.player givemaxammo( "beretta" );
		level.player setOffhandPrimaryClass( "frag" );
		level.player giveWeapon( "fraggrenade" );
		level.player setOffhandSecondaryClass( "flash" );
		level.player giveWeapon( "flash_grenade" );
		level.player giveWeapon( "claymore" );
		level.player givemaxammo( "claymore" );
		level.player SetActionSlot( 4, "weapon", "claymore" );
		level.player switchToWeapon( level.main_gun );
		level.player setViewmodel( "ch_viewhands_gk_ar15" );

		if ( is_coop() )
		{
			precacheModel( "weapon_parabolic_knife" );
			level.player SetModelFunc( ::so_body_player_ghillie );
			level.player2 SetModelFunc( ::so_body_player_ghillie );

			level.player giveWeapon( "claymore" );
			level.player givemaxammo( "claymore" );
			level.player SetActionSlot( 4, "weapon", "claymore" );

			level.player2 giveWeapon( "m4_grenadier" );
			level.player2 givemaxammo( "m4_grenadier" );
			level.player2 giveWeapon( "usp" );
			level.player2 givemaxammo( "usp" );
			level.player2 giveWeapon( "fraggrenade" );
			level.player2 giveWeapon( "claymore" );
			level.player2 givemaxammo( "claymore" );
			level.player2 SetActionSlot( 4, "weapon", "claymore" );
			level.player2 switchToWeapon( "m4_grenadier" );
			level.player2 setViewmodel( "viewhands_sas_woodland" );
		}

		level.campaign = "british";
		return;
	}
	
	if ( issubstr( level.script, "firingrange" ) )
	{
		return;	// no weapons on firing range
	}

	if ( level.script == "co_strike" )
	{
		return;	// no weapons on firing range
	}

	if ( level.script == "overwatch" )
	{
		return;	// no weapons
	}

	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// level.script is not a single player level. give default weapons.
	println( "loadout.gsc:     No level listing in _loadout.gsc, giving default guns" );
	level.testmap = true;

	give_default_loadout();
}

give_loadout_specialops( character_selected )
{
	// Ensures the Beretta is ready in case the players don't have a pistol when they go down
	foreach ( player in level.players )
	{
		player giveWeapon( "beretta" );
		player takeWeapon( "beretta" );
	}

	if ( level.script == "so_crossing_so_bridge" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "deserteagle" );
			so_player_giveWeapon( "scar_h_reflex" );
			so_player_set_switchToWeapon( "scar_h_reflex" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();

		foreach ( player in level.players )
		{
			player giveWeapon( "claymore" );
			player setActionSlot( 4, "weapon", "claymore" );
			player SetWeaponAmmoStock( "claymore", 4 );
			player giveWeapon( "c4" );
			player setActionSlot( 2, "weapon", "c4" );
		}
		return;
	}

	if ( level.script == "so_hidden_so_ghillies" )
	{
		level.so_campaign = "ghillie";
		level.so_stealth = true;
		
		level.coop_incap_weapon = "usp_silencer";

		switch_char = char_switcher();
		
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );

			so_player_giveWeapon( "fraggrenade" );
//			so_player_giveWeapon( "flash_grenade" );
//			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "usp_silencer" );
			so_player_giveWeapon( "cheytac_silencer" );
			so_player_set_switchToWeapon( "cheytac_silencer" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();

		// Has to be done separately due to order requirements.
		foreach ( player in level.players )
		{
			player giveWeapon( "claymore" );
			player setActionSlot( 4, "weapon", "claymore" );
			player SetWeaponAmmoStock( "claymore", 4 );
			player giveWeapon( "c4" );
			player setActionSlot( 2, "weapon", "c4" );
			player SetWeaponAmmoStock( "c4", 5 );

		}
		return;
	}
	
	if ( level.script == "so_killspree_invasion" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "beretta" );
			so_player_giveWeapon( "scar_h_reflex" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_set_switchToWeapon( "scar_h_reflex" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();

		// Has to be done separately due to order requirements.
		foreach ( player in level.players )
		{
			player SetOffhandSecondaryClass( "other" );
			player giveWeapon( "semtex_grenade" );
		}
		return;
	}

	if ( level.script == "so_forest_contingency" )
	{
		level.so_campaign = "arctic";
		level.so_stealth = true;
		level.coop_incap_weapon = "usp_silencer";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "usp_silencer" );
			so_player_giveWeapon( "m21_scoped_arctic_silenced" );
			so_player_set_switchToWeapon( "m21_scoped_arctic_silenced" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}

	if ( level.script == "so_rooftop_contingency" )
	{
		level.so_campaign = "arctic";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "deserteagle" );
			so_player_giveWeapon( "barrett" );
			so_player_set_switchToWeapon( "barrett" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}

	if ( level.script == "so_sabotage_cliffhanger" )
	{
		level.so_campaign = "arctic";
		level.so_stealth = true;
		level.coop_incap_weapon = "usp_silencer";
		
		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "aa12_hb_silencer" );
			so_player_giveWeapon( "usp_silencer" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_set_switchToWeapon( "aa12_hb_silencer" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		
		return;
	}
	
	if ( level.script == "so_escape_airport" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "m240" );
			so_player_giveWeapon( "striker" );
			so_player_set_switchToWeapon( "striker" );
			so_player_setup_body( i );
			so_player_giveWeapon( "claymore" );
			so_player_set_maxammo( "claymore" );
			so_player_setactionslot( 4, "weapon", "claymore" );
		}

		so_players_give_loadout();
		
		return;
	}
	
	if ( level.script == "so_killspree_favela" )
	{
		level.so_campaign = "desert";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "ranger" );
			so_player_giveWeapon( "tavor_eotech" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_set_switchToWeapon( "tavor_eotech" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		
		return;
	}

	if ( level.script == "so_defense_invasion" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "beretta" );
			so_player_giveWeapon( "scar_h_reflex" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_set_switchToWeapon( "scar_h_reflex" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();

		// Has to be done separately due to order requirements.
		foreach ( player in level.players )
		{
			player SetOffhandSecondaryClass( "other" );
			player giveWeapon( "semtex_grenade" );
		}
		return;
	}

	if ( level.script == "so_demo_so_bridge" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "beretta" );
			so_player_giveWeapon( "rpg_player" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_set_switchToWeapon( "rpg_player" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();

		// Has to be done separately due to order requirements.
		foreach ( player in level.players )
		{
			player giveWeapon( "claymore" );
			player setActionSlot( 4, "weapon", "claymore" );
			if ( !is_coop() )
				player giveMaxAmmo( "claymore" );
			else
				player SetWeaponAmmoStock( "claymore", 4 );
			player giveWeapon( "c4" );
			player setActionSlot( 2, "weapon", "c4" );
			if ( !is_coop() )
				player giveMaxAmmo( "c4" );
			else
				player SetWeaponAmmoStock( "c4", 5 );
			player SetOffhandSecondaryClass( "other" );
			player giveWeapon( "semtex_grenade" );
		}
		return;
	}

	if ( level.script == "so_ac130_co_hunted" )
	{
		level.so_campaign = "woodland";
		switch_char = char_switcher();

		// there is a wait at character selection, can not precache after a wait
		if ( !character_selected )
			precacheModel( "weapon_parabolic_knife" );

		assert( isdefined( level.players ) );
		assert( level.players.size >= 2 );
		
		for ( i = 0 ; i < level.players.size ; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "scar_h_reflex" );
			so_player_giveWeapon( "beretta" );
			so_player_giveWeapon( "fraggrenade" );
//			so_player_giveWeapon( "laser_targeting_device" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_set_switchToWeapon( "scar_h_reflex" );
//			so_player_setactionslot( 4, "weapon", "laser_targeting_device" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}

	if ( level.script == "so_showers_gulag" )
	{
		level.so_campaign = "seal";
		
		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "m4m203_reflex_arctic" );
			so_player_giveWeapon( "m1014" );
			if ( i == 0 )
				so_player_set_switchToWeapon( "m4m203_reflex_arctic" );
			else
				so_player_set_switchToWeapon( "m1014" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		
		foreach( player in level.players )
		{
			switch( level.gameskill )
			{
				case 2:
					player SetWeaponAmmoStock( "flash_grenade", 2 );			//flash count = 2
					player SetWeaponAmmoStock( "m203_m4_reflex_arctic", 4 );	//m203 count = 5 ( one is in the clip )
					break;
				case 3:
					player SetWeaponAmmoStock( "flash_grenade", 1 );			//flash count = 1 
					player SetWeaponAmmoStock( "m203_m4_reflex_arctic", 1 );	//m203 count = 2 ( one is in the clip )
					break;
			}
		}

		return;
	}

	if ( level.script == "so_assault_oilrig" )
	{
		level.so_campaign = "seal";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_giveWeapon( "m4m203_reflex" );
			so_player_giveWeapon( "m1014" );
			so_player_giveWeapon("claymore");
			so_player_set_maxammo( "claymore" );
			so_player_setactionslot( 4, "weapon", "claymore" );
			if ( i == 0 )
				so_player_set_switchToWeapon( "m4m203_reflex" );
			else
				so_player_set_switchToWeapon( "m4m203_reflex" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}


	if ( level.script == "so_killspree_trainer" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "m4_grunt" );
			so_player_giveWeapon( "usp" );
			if ( i == 0 )
				so_player_set_switchToWeapon( "m4_grunt" );
			else
				so_player_set_switchToWeapon( "m4_grunt" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}
	
	if( level.script == "so_defuse_favela_escape" )
	{
		level.so_campaign = "desert";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "m1014_eotech" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();

		foreach ( player in level.players )
		{
			player giveWeapon( "glock_akimbo", 0 , true );
			player switchToWeapon( "glock_akimbo" );
		}
				
		return;
	}
/*
	if( level.script == "so_defense_dcemp" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();

		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "m4m203_eotech" );
			so_player_giveWeapon( "Beretta" );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_set_switchToWeapon( "m4m203_eotech" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		
		return;
	}
*/
	if ( level.script == "so_timed_so_quicky" )
	{
//		level.so_campaign = "ranger";
//		level.so_campaign = "seal";
//		level.so_campaign = "arctic";
		level.so_campaign = "woodland";
//		level.so_campaign = "desert";
//		level.so_campaign = "ghillie";
		
		give_default_loadout();

		foreach ( player in level.players )
		{
			player takeWeapon( "mp5" );
			player giveWeapon( "m14ebr_thermal" );
			player switchToWeapon( "m14ebr_thermal" );
		}
		
		return;
	}
	
	if ( level.script == "so_takeover_oilrig" )
	{
		level.so_campaign = "seal";

		switch_char = char_switcher();
		
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			
			so_player_giveWeapon( "m240" );
			so_player_set_maxammo( "m240" );
			
			so_player_giveWeapon( "m79" );
			so_player_set_maxammo( "m79" );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_set_maxammo( "fraggrenade" );
			
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_maxammo( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_giveWeapon("claymore");
			so_player_set_maxammo( "claymore" );
			so_player_setactionslot( 4, "weapon", "claymore" );
			
			so_player_set_switchToWeapon( "m240" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}
	
	if ( level.script == "so_takeover_estate" )
	{
		level.so_campaign = "woodland";
		level.so_stealth = true;

		switch_char = char_switcher();
		
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );		
			so_player_giveWeapon( "m4m203_eotech" );
			so_player_giveWeapon( "barrett" );
			so_player_giveWeapon("claymore");
			so_player_set_maxammo( "claymore" );
			so_player_setactionslot( 4, "weapon", "claymore" );
			so_player_set_switchToWeapon( "m4m203_eotech" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}
	
	if ( level.script == "so_intel_boneyard" )
	{
		level.so_campaign = "desert";

		switch_char = char_switcher();
		
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );		
			so_player_giveWeapon( "m4m203_reflex" );
			so_player_giveWeapon( "cheytac" );
			so_player_set_switchToWeapon( "m4m203_reflex" );
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}
	
	if ( level.script == "so_juggernauts_favela" )
	{
		level.so_campaign = "desert";
		
		switch_char = char_switcher();
		
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			
			so_player_giveWeapon( "m79" );
			so_player_set_maxammo( "m79" );
			so_player_giveWeapon( "rpg_player" );
			so_player_set_maxammo( "rpg_player" );
			
			so_player_giveWeapon("c4");
			so_player_set_maxammo( "c4" );
			so_player_setactionslot( 2, "weapon", "c4" );
			
			so_player_giveWeapon("claymore");
			so_player_set_maxammo( "claymore" );
			so_player_setactionslot( 4, "weapon", "claymore" );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			so_player_set_switchToWeapon( "m79" );
			so_player_setup_body( i );
		}
		
		so_players_give_loadout();
		
		return;
	}
	
	if ( level.script == "so_download_arcadia" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();
		
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_giveWeapon( "scar_h_reflex" );
			so_player_giveWeapon( "beretta" );
			so_player_set_switchToWeapon( "scar_h_reflex" );
			
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}
	
	if ( level.script == "so_chopper_invasion" )
	{
		level.so_campaign = "ranger";

		switch_char = char_switcher();
		
		for ( i = 0; i < level.players.size; i++ )
		{
			so_player_num( i );
			
			so_player_giveWeapon("c4");
			so_player_set_maxammo( "c4" );
			so_player_setactionslot( 2, "weapon", "c4" );
			
			so_player_giveWeapon("claymore");
			so_player_set_maxammo( "claymore" );
			so_player_setactionslot( 4, "weapon", "claymore" );
			
			so_player_giveWeapon( "fraggrenade" );
			so_player_giveWeapon( "flash_grenade" );
			so_player_set_setOffhandSecondaryClass( "flash" );
			
			so_player_giveWeapon( "ump45_digital_eotech" );
			so_player_giveWeapon( "deserteagle" );
			so_player_set_switchToWeapon( "ump45_digital_eotech" );
			
			so_player_setup_body( i );
		}

		so_players_give_loadout();
		return;
	}
	
	if ( level.script == "so_snowrace1_cliffhanger" )
	{
		level.so_campaign = "arctic";
		give_default_loadout();
		return;
	}

	if ( level.script == "so_snowrace2_cliffhanger" )
	{
		level.so_campaign = "arctic";
		give_default_loadout();
		return;
	}

	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	println( "loadout.gsc:     No level listing in _loadout::give_loadout_specialops(), giving default guns" );
	level.testmap = true;
	level.so_campaign = "ranger";
	
	give_default_loadout();
}


// To precache possible weapons for alternate character loadout
possible_precache( possible_precache_items )
{
	foreach ( item in possible_precache_items )
		PreCacheItem( item );
}

give_default_loadout()
{
	if ( is_coop() )
	{
		switch_char = char_switcher();

		give_default_loadout_coop( 0 );
		give_default_loadout_coop( 1 ) ;

		so_players_give_loadout();
		return;
	}

	level.player giveWeapon( "fraggrenade" );
	level.player giveWeapon( "flash_grenade" );
	level.player setOffhandSecondaryClass( "flash" );
	if ( is_specialop() )
		level.player giveWeapon( "m1014" );
	level.player giveWeapon( "mp5" );
	level.player switchToWeapon( "mp5" );
	level.player setViewmodel( "viewmodel_base_viewhands" );
}

give_default_loadout_coop( num )
{
	so_player_num( num );
	so_player_giveWeapon( "fraggrenade" );
	so_player_giveWeapon( "flash_grenade" );
	so_player_set_setOffhandSecondaryClass( "flash" );
	so_player_giveWeapon( "mp5" );
	so_player_giveWeapon( "m1014" );
	if (num == 0)
		so_player_set_switchToWeapon( "mp5" );
	else
		so_player_set_switchToWeapon( "m1014" );
	so_player_setup_body( num );
}

///////////////////////////////////////////////
// SavePlayerWeaponStatePersistent
// 
// Saves the player's weapons and ammo state persistently( in the game variable )
// so that it can be restored in a different map.
// You can use strings for the slot:
// 
// SavePlayerWeaponStatePersistent( "russianCampaign" );
// 
// Or you can just use numbers:
// 
// SavePlayerWeaponStatePersistent( 0 );
// SavePlayerWeaponStatePersistent( 1 ); etc.
// 
// In a different map, you can restore using RestorePlayerWeaponStatePersistent( slot );
// Make sure that you always persist the data between map changes.

SavePlayerWeaponStatePersistent( slot )
{
	level.player endon( "death" );
	if ( level.player.health == 0 )
		return;
	current = level.player GetCurrentPrimaryWeapon();
	if ( ( !isdefined( current ) ) || ( current == "none" ) )
		assertmsg( "Player's current weapon is 'none' or undefined. Make sure 'disableWeapons()' has not been called on the player when trying to save weapon states." );
	game[ "weaponstates" ][ slot ][ "current" ] = current;

	offhand = level.player getcurrentoffhand();
	game[ "weaponstates" ][ slot ][ "offhand" ] = offhand;

	game[ "weaponstates" ][ slot ][ "list" ] = [];
	weapList = array_combine( level.player GetWeaponsListPrimaries(), level.player GetWeaponsListOffhands() );
	for ( weapIdx = 0; weapIdx < weapList.size; weapIdx++ )
	{
		game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ] = weapList[ weapIdx ];

		// below is only used if we want to NOT give max ammo
		// game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] = level.player GetWeaponAmmoClip( weapList[ weapIdx ] );
		// game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] = level.player GetWeaponAmmoStock( weapList[ weapIdx ] );
	}
}

RestorePlayerWeaponStatePersistent( slot )
{
	if ( !isDefined( game[ "weaponstates" ] ) )
		return false;
	if ( !isDefined( game[ "weaponstates" ][ slot ] ) )
		return false;

	level.player takeallweapons();

	for ( weapIdx = 0; weapIdx < game[ "weaponstates" ][ slot ][ "list" ].size; weapIdx++ )
	{
		weapName = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ];

		if ( isdefined( level.legit_weapons ) )
		{
			// weapon doesn't exist in this level
			if ( !isdefined( level.legit_weapons[ weapName ] ) )
				continue;
		}

		// don't carry over C4 or claymores
		if ( weapName == "c4" )
			continue;
		if ( weapName == "claymore" )
			continue;
		level.player GiveWeapon( weapName );
		level.player GiveMaxAmmo( weapName );

		// below is only used if we want to NOT give max ammo
		// level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
		// level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
	}

	if ( isdefined( level.legit_weapons ) )
	{
		weapname = game[ "weaponstates" ][ slot ][ "offhand" ];
		if ( isdefined( level.legit_weapons[ weapName ] ) )
			level.player switchtooffhand( weapname );

		weapname = game[ "weaponstates" ][ slot ][ "current" ];
		if ( isdefined( level.legit_weapons[ weapName ] ) )
			level.player SwitchToWeapon( weapname );
	}
	else
	{
		level.player switchtooffhand( game[ "weaponstates" ][ slot ][ "offhand" ] );
		level.player SwitchToWeapon( game[ "weaponstates" ][ slot ][ "current" ] );
	}

	return true;
}


sniper_escape_initial_secondary_weapon_loadout()
{
	level.player giveWeapon( "claymore" );
	level.player giveWeapon( "c4" );
	if ( level.gameskill >= 2 )
	{
		level.player SetWeaponAmmoClip( "claymore", 10 );
		level.player SetWeaponAmmoClip( "c4", 6 );
	}
	else
	{
		level.player SetWeaponAmmoClip( "claymore", 8 );
		level.player SetWeaponAmmoClip( "c4", 3 );
	}
	level.player SetActionSlot( 4, "weapon", "claymore" );
	level.player SetActionSlot( 2, "weapon", "c4" );
	level.player giveWeapon( "fraggrenade" );
	level.player giveWeapon( "flash_grenade" );
	level.player setOffhandSecondaryClass( "flash" );

	level.player setViewmodel( "viewhands_marine_sniper" );
}

set_legit_weapons_for_sniper_escape()
{
	legit_weapons = [];
	legit_weapons = [];
	legit_weapons[ "mp5" ] = true;
	legit_weapons[ "usp_silencer" ] = true;
	legit_weapons[ "ak47" ] = true;
	legit_weapons[ "g3" ] = true;
	legit_weapons[ "usp" ] = true;
	legit_weapons[ level.sniperescape_main_weapon ] = true;
	legit_weapons[ "dragunov" ] = true;
	legit_weapons[ "winchester1200" ] = true;
	legit_weapons[ "beretta" ] = true;
	legit_weapons[ "rpd" ] = true;
	legit_weapons[ "rpg" ] = true;
	level.legit_weapons = legit_weapons;
}

set_legit_weapons_for_favela_escape()
{
	legit_weapons = [];
	legit_weapons[ level.favela_escape_main_weapon ] = true;
	legit_weapons[ "beretta" ] = true;
	legit_weapons[ "glock" ] = true;
	
	legit_weapons[ "uzi" ] = true;
	legit_weapons[ "mp5" ] = true;
	legit_weapons[ "ump45" ] = true;
	legit_weapons[ "ump45_acog" ] = true;
	legit_weapons[ "ump45_reflex" ] = true;
	
	legit_weapons[ "ranger" ] = true;
	legit_weapons[ "model1887" ] = true;
	
	legit_weapons[ "m4m203_reflex" ] = true;
	legit_weapons[ "m4m203_eotech" ] = true;
	legit_weapons[ "m4_grenadier" ] = true;
	legit_weapons[ "m4_grunt" ] = true;
	legit_weapons[ "tavor_mars" ] = true;
	legit_weapons[ "tavor_acog" ] = true;
	legit_weapons[ "masada" ] = true;
	legit_weapons[ "masada_acog" ] = true;
	legit_weapons[ "masada_reflex" ] = true;
	legit_weapons[ "scar_h" ] = true;
	legit_weapons[ "scar_h_acog" ] = true;
	legit_weapons[ "scar_h_reflex" ] = true;
	legit_weapons[ "scar_h_shotgun" ] = true;
	legit_weapons[ "ak47" ] = true;
	legit_weapons[ "ak47_acog" ] = true;
	legit_weapons[ "ak47_reflex" ] = true;
	
	legit_weapons[ "dragunov" ] = true;
	
	legit_weapons[ "rpd" ] = true;
	legit_weapons[ "m240_reflex" ] = true;
	
	legit_weapons[ "rpg" ] = true;
	legit_weapons[ "m79" ] = true;
	
	level.legit_weapons = legit_weapons;
}

set_legit_weapons_for_dc_whitehouse()
{
	legit_weapons = [];
	legit_weapons[ level.dc_whitehouse_main_weapon ] = true;
	legit_weapons[ "beretta" ] = true;
	legit_weapons[ "glock" ] = true;
	
	legit_weapons[ "uzi" ] = true;
	legit_weapons[ "mp5" ] = true;
	legit_weapons[ "ump45" ] = true;
	legit_weapons[ "ump45_acog" ] = true;
	legit_weapons[ "ump45_reflex" ] = true;
	
	legit_weapons[ "ranger" ] = true;
	legit_weapons[ "model1887" ] = true;
	
	legit_weapons[ "m4m203_reflex" ] = true;
	legit_weapons[ "m4m203_eotech" ] = true;
	legit_weapons[ "m4_grenadier" ] = true;
	legit_weapons[ "m4_grunt" ] = true;
	legit_weapons[ "tavor_mars" ] = true;
	legit_weapons[ "tavor_acog" ] = true;
	legit_weapons[ "masada" ] = true;
	legit_weapons[ "masada_acog" ] = true;
	legit_weapons[ "masada_reflex" ] = true;
	legit_weapons[ "scar_h" ] = true;
	legit_weapons[ "scar_h_acog" ] = true;
	legit_weapons[ "scar_h_reflex" ] = true;
	legit_weapons[ "scar_h_shotgun" ] = true;
	legit_weapons[ "ak47" ] = true;
	legit_weapons[ "ak47_acog" ] = true;
	legit_weapons[ "ak47_reflex" ] = true;
	
	legit_weapons[ "dragunov" ] = true;
	
	legit_weapons[ "rpd" ] = true;
	legit_weapons[ "m240_reflex" ] = true;
	
	legit_weapons[ "rpg" ] = true;
	legit_weapons[ "m79" ] = true;
	
	level.legit_weapons = legit_weapons;
}

max_ammo_on_legit_sniper_escape_weapon()
{
	heldweapons = level.player GetWeaponsListAll();
	for ( i = 0; i < heldweapons.size; i++ )
	{
		weapon = heldweapons[ i ];
		if ( !isdefined( level.legit_weapons[ weapon ] ) )
			continue;
		if ( weapon == "rpg" )
			continue;

		level.player givemaxammo( weapon );
	}
}

force_player_to_use_legit_sniper_escape_weapon()
{
	heldweapons = level.player GetWeaponsListAll();

	// take away weapons mo has in scoutsniper that we dont have in sniperescape
	held_weapons = [];
	count = 0;

	for ( i = 0; i < heldweapons.size; i++ )
	{
		weapon = heldweapons[ i ];
		held_weapons[ weapon ] = true;
		if ( isdefined( level.legit_weapons[ weapon ] ) )
		{
			count++ ;
			continue;
		}

		level.player takeweapon( weapon );
	}

	if ( count == 2 )
		return;

	if ( count == 0 )
	{
		// need to fill in a slot
		level.player giveweapon( "ak47" );
		level.player switchtoWeapon( "ak47" );
	}

	// does player have a sniper rifle?
	if ( !isdefined( held_weapons[ level.sniperescape_main_weapon ] ) && !isdefined( held_weapons[ "dragunov" ] ) )
	{
		level.player giveweapon( level.sniperescape_main_weapon );
		level.player switchtoWeapon( level.sniperescape_main_weapon );
	}
}

//======================prototype=======================
// coop character selection script:

coop_gamesetup_menu()
{
	assert( is_coop() );
		
	// update difficulty:
	maps\_gameskill::setGlobalDifficulty();

	foreach ( idx, player in level.players )
		player maps\_gameskill::setDifficulty();

	// character selection: 
	level.character_switched = false;
	flag_init( "character_selected" );

	char_select_levels = "";  // "co_blackout co_suburban_america co_overgrown
	levels_array = [];
	levels_array = strTok( char_select_levels, " " );

	foreach ( level_string in levels_array )
	{
		if ( level_string == level.script )
		{
			// non-switched
			flag_set( "character_selected" );
			
			//precacheMenu( "coop_characterselect" );
			//character_select_menu();
		}
	}

	char_select_coop_ac130 = "so_ac130_co_hunted co_hunted co_ac130";
	levels_array_ac130 = [];
	levels_array_ac130 = strTok( char_select_coop_ac130, " " );

	foreach ( level_string in levels_array_ac130 )
	{
		if ( is_coop() && ( level_string == level.script ) )
		{
			pilot_num = getdvar( "ui_ac130_pilot_num" );
			
			if ( isdefined( pilot_num ) && pilot_num != "0" )
				level.character_switched = true;
			
			//reset
			//setdvar ( "ui_ac130_pilot_num", "" );
			
			flag_set( "character_selected" );
			
			//precacheMenu( "coop_characterselect" );
			//character_select_menu();
		}
	}
}

/*
character_select_menu()
{
	setup_character_menu();

	// close previous menus and open character selection
	level.response_queue = [];

	setblur( 2, .1 );
	foreach ( idx, player in level.players )
	{
		player closepopupMenu();
		player freezecontrols( true );
		player openpopupMenu( "coop_characterselect" );

		flag_init( "player" + idx + "_ready" );

		thread waittill_each_ready( player, "player" + idx + "_ready" );
		add_wait( ::flag_wait, "player" + idx + "_ready" );
	}

	do_wait();
 	setblur( 0, .2 );

 	foreach ( player in level.players )
 	{
		player closepopupMenu();
		player freezecontrols( false );
	}

 	// responses
 	assert( isdefined( level.response_queue[ 0 ] ) );
 	first_player = level.response_queue[ 0 ][ "player" ];
 	first_player_response = level.response_queue[ 0 ][ "response" ];

 	//assert( isdefined( level.response_queue[ 1 ] ) );
 	//second_player = level.response_queue[ 1 ][ "player" ];
 	//second_player_response = level.response_queue[ 1 ][ "response" ];

	// coop two player situation:
	if ( first_player == level.player )
	{
		if ( first_player_response == "char2" )
		{
			level.character_switched = true;
			maps\_loadout::give_loadout( true );
		}
	}
	else
	{
		if ( first_player_response == "char1" )
		{
			level.character_switched = true;
			maps\_loadout::give_loadout( true );
		}
	}

	flag_set( "character_selected" );
	//autosave_now( true );
}
*/

/*
waittill_each_ready( player, ready_flag )
{
	response = " ";
	while ( response != "char1" && response != "char2" )
	{
		player waittill( "menuresponse", menu, response );

		index = level.response_queue.size;
		level.response_queue[ index ] = [];
		level.response_queue[ index ][ "player" ] = player;
		level.response_queue[ index ][ "response" ] = response;

		break;
	}
	flag_set( ready_flag );
}
*/
/*
// temp - prototype, will be using string tables in the future
setup_character_menu()
{
	if ( level.script == "co_ac130" || level.script == "co_hunted" )
	{
		setdvar( "ui_character1_name", "AC130" );
		setdvar( "ui_character1_image", "level_character_ac130" );
		setdvar( "ui_character1_primary", "ui_transparent" );
		setdvar( "ui_character1_inv", "ui_transparent" );
		setdvar( "ui_character1_inv_counter", "" );

		setdvar( "ui_character2_name", "James" );
		setdvar( "ui_character2_image", "level_character_james" );
		setdvar( "ui_character2_primary", "weapon_m4carbine" );
		setdvar( "ui_character2_inv", "weapon_attachment_m203" );
		setdvar( "ui_character2_inv_counter", "x10" );
		return;
	}
	else if ( level.script == "co_blackout" )
	{
		setdvar( "ui_character1_name", "Price" );
		setdvar( "ui_character1_image", "level_character_price" );
		setdvar( "ui_character1_primary", "weapon_m4carbine" );
		setdvar( "ui_character1_inv", "weapon_attachment_m203" );
		setdvar( "ui_character1_inv_counter", "x10" );

		setdvar( "ui_character2_name", "Gaz" );
		setdvar( "ui_character2_image", "level_character_gaz" );
		setdvar( "ui_character2_primary", "weapon_m14_scoped" );
		setdvar( "ui_character2_inv", "ui_transparent" );
		setdvar( "ui_character2_inv_counter", "" );
		return;
	}
	else if ( level.script == "co_overgrown" )
	{
		setdvar( "ui_character1_name", "Price" );
		setdvar( "ui_character1_image", "level_character_price" );
		setdvar( "ui_character1_primary", "weapon_m4carbine" );
		setdvar( "ui_character1_inv", "weapon_attachment_m203" );
		setdvar( "ui_character1_inv_counter", "x10" );

		setdvar( "ui_character2_name", "Gaz" );
		setdvar( "ui_character2_image", "level_character_gaz" );
		setdvar( "ui_character2_primary", "weapon_m14_scoped" );
		setdvar( "ui_character2_inv", "weapon_claymore" );
		setdvar( "ui_character2_inv_counter", "x10" );
		return;
	}
	else if ( level.script == "co_suburban_america" )
	{
		setdvar( "ui_character1_name", "Price" );
		setdvar( "ui_character1_image", "level_character_price" );
		setdvar( "ui_character1_primary", "weapon_m4carbine" );
		setdvar( "ui_character1_inv", "weapon_attachment_m203" );
		setdvar( "ui_character1_inv_counter", "x10" );

		setdvar( "ui_character2_name", "Gaz" );
		setdvar( "ui_character2_image", "level_character_gaz" );
		setdvar( "ui_character2_primary", "weapon_m14_scoped" );
		setdvar( "ui_character2_inv", "weapon_claymore" );
		setdvar( "ui_character2_inv_counter", "x10" );
		return;
	}

	// Default
	setdvar( "ui_character1_name", "Price" );
	setdvar( "ui_character1_image", "level_character_price" );
	setdvar( "ui_character1_primary", "weapon_m4carbine" );
	setdvar( "ui_character1_inv", "weapon_attachment_m203" );
	setdvar( "ui_character1_inv_counter", "x10" );

	setdvar( "ui_character2_name", "Gaz" );
	setdvar( "ui_character2_image", "level_character_gaz" );
	setdvar( "ui_character2_primary", "weapon_m14_scoped" );
	setdvar( "ui_character2_inv", "weapon_claymore" );
	setdvar( "ui_character2_inv_counter", "x10" );
}

*/
//==========================================

/*
=============
///ScriptDocBegin
"Name: coop_gamesetup_ac130()"
"Summary: Opens difficulty menus for both co-op players and returns selected AC130 pilot (player entity). Must call precacheMenu("coop_setup"); precacheMenu("coop_setup2"); in level script."
"Module: gameskill"
"Example: 	ac130_pilot = coop_gamesetup_ac130();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
coop_gamesetup_ac130()
{
	assertex( isdefined( level.specops_character_selector ), "Failed to select character" );
	
	if ( level.specops_character_selector == "so_char_host" )
		return level.players[ 0 ];
		
	if ( level.specops_character_selector == "so_char_client" )
		return level.players[ 1 ];
	
	// failed to select	
	return level.players[ 0 ];
	
/*		
	if ( cointoss() )
		return level.player2;
	else
		return level.player;
		*/
/*
	if ( isdefined( level.character_switched ) && level.character_switched )
		return level.player2;

	return level.player;
*/
}

so_player_num( num )
{
	level.so_player_num = num;
	level.so_player_add_player_giveWeapon[ num ] = [];

	// level vars if this becomes more commmonly used should put the init somewhere above the loadout section.	
	if ( !isdefined( level.so_player_set_maxammo ) )
		level.so_player_set_maxammo = [];
	if ( !isdefined( level.so_player_set_setViewmodel ) )
		level.so_player_set_setViewmodel = [];
	if ( !isdefined( level.so_player_add_player_giveWeapon ) )
		level.so_player_add_player_giveWeapon = [];
	if ( !isdefined( level.so_player_set_setOffhandSecondaryClass ) )
		level.so_player_set_setOffhandSecondaryClass = [];
	if ( !isdefined( level.so_player_set_switchToWeapon ) )
		level.so_player_set_switchToWeapon = [];
	if ( !isdefined( level.so_player_SetModelFunc ) )
		level.so_player_SetModelFunc = [];
	if ( !isdefined( level.so_player_SetModelFunc_precache ) )
		level.so_player_SetModelFunc_precache = [];
	if ( !isdefined( level.so_player_SetActionSlot ) )
		level.so_player_SetActionSlot = [];

	level.so_player_set_maxammo[ num ] = [];
	level.so_player_set_setOffhandSecondaryClass[ num ] = [];
	level.so_player_add_player_giveWeapon[ num ] = [];
}

so_player_giveWeapon( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	if ( ! level.character_selected )
		precacheitem( weapon );
	level.so_player_add_player_giveWeapon[ num ][ weapon ] = 1;
}

so_player_set_maxammo( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_set_maxammo[ num ][ weapon ] = 1;
}

so_player_set_setOffhandSecondaryClass( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_set_setOffhandSecondaryClass[ num ] = weapon ;
}

so_player_set_switchToWeapon( weapon )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_set_switchToWeapon[ num ] = weapon;
}

so_player_set_setViewmodel( model )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	if ( ! level.character_selected )
		precachemodel( model );
	level.so_player_set_setViewmodel[ num ] = model ;
}

so_player_SetModelFunc( func, precache_func )
{
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;
	level.so_player_SetModelFunc[ num ] = func;

	assert( isdefined( precache_func ) );
	if ( ! level.character_selected )
		[[ precache_func ]]();

}


so_player_SetActionSlot( slot, parm1, parm2 )
{
	assert( isdefined( slot ) );
	assert( isdefined( parm1 ) );
	assert( isdefined( level.so_player_num ) );
	num = level.so_player_num;

	struct = spawnstruct();
	struct.slot = slot;
	struct.parm1 = parm1;
	if ( isdefined( parm2 ) )
		struct.parm2 = parm2;
	if ( isdefined( level.so_player_SetActionSlot[ num ] ) )
		index = level.so_player_SetActionSlot[ num ].size;
	else
		index = 0;
	level.so_player_SetActionSlot[ num ][ index ] = struct;
}


#using_animtree( "multiplayer" );


so_player_give_loadout( num )
{
	player = self;

	if ( isdefined( level.so_player_SetModelFunc[ num ] ) )
	{
		player setmodelfunc( level.so_player_SetModelFunc[ num ] );
		player setanim( %code, 1, 0 );
	}

	weapons = getarraykeys( level.so_player_add_player_giveWeapon[ num ] );
	foreach ( weapon in weapons )
	{
		player giveweapon( weapon );
		if ( isdefined( level.so_player_set_maxammo[ num ][ weapon ] ) )
			player givemaxammo( weapon );
	}

	if ( isdefined( level.so_player_set_setOffhandSecondaryClass[ num ] ) )
		player setOffhandSecondaryClass( "flash" );

	if ( isdefined( level.so_player_SetActionSlot[ num ] ) )
		player so_players_give_action( num );

	if ( isdefined( level.so_player_set_switchToWeapon[ num ] ) )
		player switchtoweapon( level.so_player_set_switchToWeapon[ num ] );

	if ( isdefined( level.so_player_set_setViewmodel[ num ] ) )
		player setviewmodel( level.so_player_set_setViewmodel[ num ] );
}

so_players_give_action( num )
{
	player = self;
	
	foreach( struct in level.so_player_SetActionSlot[ num ] )
	{
		if ( isdefined( struct.parm2 ) )
			player SetActionSlot( struct.slot, struct.parm1, struct.parm2 );
		else
			player SetActionSlot( struct.slot, struct.parm1 );
	}
}

so_players_give_loadout()
{
	foreach ( playerIndex, player in level.players )
	{
		player so_player_give_loadout( playerIndex );
	}
}

UpdateModel( modelFunc )
{

	self notify( "newupdatemodel" );

	if ( !isdefined( modelFunc ) )
	{
		self DetachAll();
		self setModel( "" );
		return;
	}

	self.last_modelfunc = modelFunc;

	if ( isdefined( self.is_hidden ) && self.is_hidden )
		return;

	self endon( "newupdatemodel" );

	for ( ;; )
	{
		self DetachAll();

		[[ modelFunc ]]();

		weapon_model = self GetPlayerWeaponModel();
		if ( isdefined( weapon_model ) )
		{
			switch ( weapon_model )
			{
				case "weapon_riot_shield":
					self attach( weapon_model, "tag_weapon_left", false );
					break;
				case "weapon_claymore":
				case "weapon_c4":
				case "weapon_claymore_no_legs":
					self attach( weapon_model, "tag_inhand", false );
					break;
				default:
					self attach( weapon_model, "tag_weapon_right", true );
					break;
			}
		}

		// Figure out what, if anything, to put in the left hand.
		knife_model = self GetPlayerKnifeModel();
		if ( isdefined( knife_model ) )
		{
			self attach( knife_model, "tag_inhand", true );
		}
		else
		if ( self isDualWielding() )
		{
			if ( isdefined( weapon_model ) )
				self attach( weapon_model, "tag_weapon_left", true );
		}

		// Need to swap this to do all weapons that are visible when stowing is supported.
		// Note: Dual Wielded weapons don't properly hide the extra hand.
		weapon = self GetCurrentWeapon();
		weapon_model = self GetPlayerWeaponModel();
		if ( isdefined( weapon_model ) )
		{
			hide_tag_list = GetWeaponHideTags( weapon );
			if ( isDefined( hide_tag_list ) )
			{		
				foreach ( part in hide_tag_list )
					self HidePart_AllInstances( part, weapon_model );
			}
		}
		
		self waittill( "weaponchange" );
	}
}

so_player_setup_body( num )
{
	so_player_set_setViewmodel( so_player_get_hands() );
	if ( is_coop() )
		so_player_SetModelFunc( so_player_get_bodyfunc( num ), so_player_get_bodyfunc_precache( num ) );
}

so_player_get_bodyfunc( num )
{
	switch ( level.so_campaign )
	{
		case "ranger":		return ::so_body_player_ranger;
		case "seal":		return ::so_body_player_seal;
		case "arctic":		return ::so_body_player_arctic;
		case "woodland":	return ::so_body_player_woodland;
		case "desert":		return ::so_body_player_desert;
		case "ghillie":		return ::so_body_player_ghillie;
		default:			assertex( false, "Special Ops requires level.campaign to be set to a valid value in order to setup the character body." );	
	}
	return ;
}

so_player_get_bodyfunc_precache( num )
{
	switch ( level.so_campaign )
	{
		case "ranger":		return ::so_body_player_ranger_precache;
		case "seal":		return ::so_body_player_seal_precache;
		case "arctic":		return ::so_body_player_arctic_precache;
		case "woodland":	return ::so_body_player_woodland_precache;
		case "desert":		return ::so_body_player_desert_precache;
		case "ghillie":		return ::so_body_player_ghillie_precache;
	}
	return ;
}

so_player_get_hands()
{
	switch ( level.so_campaign )
	{
		case "ranger":		return "ch_viewhands_gk_ump9";
		case "seal":		return "ch_viewhands_gk_ar15";
		case "arctic":		return "ch_viewhands_gk_ar15";
		case "woodland":	return "ch_viewhands_gk_ar15";
		case "desert":		return "ch_viewhands_gk_m4_sopmod_ii";
		case "ghillie":		return "ch_viewhands_gk_ump9";
	}
}

so_body_player_ranger()				
{ 
	self setModel( "ch_coop_body_gk_m4_sopmod_ii" );			
	self attach( "ch_head_gk_m4_sopmod_ii", "", true ); 
	self attach( "ch_hair_gk_m4_sopmod_ii", "", true ); 
}

so_body_player_seal()				
{ 
	self setModel( "ch_coop_body_gk_m4_sopmod_ii" );			
	self attach( "ch_head_gk_m4_sopmod_ii", "", true ); 
	self attach( "ch_hair_gk_m4_sopmod_ii", "", true ); 
}

so_body_player_arctic()				
{	
	self setModel( "ch_coop_body_gk_m4_sopmod_ii" );			
	self attach( "ch_head_gk_m4_sopmod_ii", "", true ); 
	self attach( "ch_hair_gk_m4_sopmod_ii", "", true ); 
}

so_body_player_woodland()			
{ 
	self setModel( "ch_coop_body_gk_m4_sopmod_ii" );			
	self attach( "ch_head_gk_m4_sopmod_ii", "", true ); 
	self attach( "ch_hair_gk_m4_sopmod_ii", "", true ); 
}

so_body_player_desert()				
{ 
	self setModel( "ch_coop_body_gk_m4_sopmod_ii" );			
	self attach( "ch_head_gk_m4_sopmod_ii", "", true ); 
	self attach( "ch_hair_gk_m4_sopmod_ii", "", true ); 
}
so_body_player_ghillie()			
{	
	self setModel( "ch_coop_body_gk_m4_sopmod_ii" );			
	self attach( "ch_head_gk_m4_sopmod_ii", "", true ); 
	self attach( "ch_hair_gk_m4_sopmod_ii", "", true ); 
}

so_body_player_ranger_precache()	
{ 
	precachemodel( "ch_coop_body_gk_m4_sopmod_ii" );			
	precachemodel( "ch_head_gk_m4_sopmod_ii" ); 
	precachemodel( "ch_hair_gk_m4_sopmod_ii" ); 
}

so_body_player_seal_precache()		
{ 
	precachemodel( "ch_coop_body_gk_m4_sopmod_ii" );			
	precachemodel( "ch_head_gk_m4_sopmod_ii" ); 
	precachemodel( "ch_hair_gk_m4_sopmod_ii" ); 
}

so_body_player_arctic_precache()	
{ 
	precachemodel( "ch_coop_body_gk_m4_sopmod_ii" );			
	precachemodel( "ch_head_gk_m4_sopmod_ii" ); 
	precachemodel( "ch_hair_gk_m4_sopmod_ii" ); 
}

so_body_player_woodland_precache()	
{ 
	precachemodel( "ch_coop_body_gk_m4_sopmod_ii" );			
	precachemodel( "ch_head_gk_m4_sopmod_ii" ); 
	precachemodel( "ch_hair_gk_m4_sopmod_ii" ); 
}

so_body_player_desert_precache()	
{ 
	precachemodel( "ch_coop_body_gk_m4_sopmod_ii" );			
	precachemodel( "ch_head_gk_m4_sopmod_ii" ); 
	precachemodel( "ch_hair_gk_m4_sopmod_ii" ); 
}

so_body_player_ghillie_precache()	
{ 
	precachemodel( "ch_coop_body_gk_m4_sopmod_ii" );			
	precachemodel( "ch_head_gk_m4_sopmod_ii" ); 
	precachemodel( "ch_hair_gk_m4_sopmod_ii" ); 
}
