#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track [ "bridge_ext0" ] = "ambient_bridge_ext0";
	

	ambientDelay( "bridge_ext0", 7.0, 15.0 );// Trackname, min and max delay between ambient events
	ambientEvent( "bridge_ext0", "null", 		1.0 );

	thread maps\_utility::set_ambient( "bridge_ext0" );
}
