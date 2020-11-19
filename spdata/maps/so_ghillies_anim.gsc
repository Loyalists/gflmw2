#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

main()
{
	anim_ghillies();
}

#using_animtree( "generic_human" );
anim_ghillies()
{
	level.scr_anim[ "generic" ][ "prone_idle" ][ 0 ] = %hunted_pronehide_idle_relative;
	level.scr_anim[ "generic" ][ "pronehide_idle" ][0]			= %hunted_pronehide_idle_v1;
	level.scr_anim[ "generic" ][ "pronehide_idle_frame" ][0]		= %hunted_pronehide_idle_v1;
	level.scr_anim[ "generic" ][ "pronehide_dive" ] = %hunted_dive_2_pronehide_v1;
}