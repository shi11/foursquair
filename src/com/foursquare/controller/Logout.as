////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.models.FoursquareModel;
	import com.foursquare.views.navigation.Navigation;
	
	import flash.filesystem.File;
	
	import org.robotlegs.mvcs.Command;
	
	public class Logout extends Command
	{
		
		[Inject]
		public var model:FoursquareModel;
		
		public function Logout()
		{
			super();
		}
		
		override public function execute() : void{
			var oauthFile:File = model.oauthFile;
			if(oauthFile.exists) oauthFile.deleteFile();
		}

	}
}