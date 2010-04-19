////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 23, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.models
{
	import com.foursquare.models.vo.UserVO;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.iotashan.oauth.OAuthToken;
	import org.robotlegs.mvcs.Actor;
	
	public class FoursquareModel extends Actor
	{
		
		/**
		 * log for service results 
		 */		
		private var _log:String;
		
		/**
		 * current version of users app 
		 */		
		public var currentVersion:String;
		
		/**
		 * oauth file 
		 */		
		public var oauthFile:File;
		
		/**
		 * oauth token 
		 */		
		public var oauth_token : OAuthToken;
		
		/**
		 * used during login 
		 */		
		public var rememberMe:Boolean;
		
		/**
		 * current user details 
		 */		
		public var currentUser:UserVO;
		
		private var _checkins:ArrayCollection=new ArrayCollection();
		
		public function FoursquareModel()
		{
			super();
			//instantiate oauthFile
			oauthFile = File.applicationStorageDirectory.resolvePath("user/oauth_token.xml");
		}
		
		/**
		 * CHECKINS 
		 * @return 
		 * 
		 */		
		public function get checkins():ArrayCollection
		{
			return _checkins;
		}

		public function set checkins(value:ArrayCollection):void
		{
			_checkins = value;
		}

		public function log(value:String):void{
			_log = value;
		}
		
	}
}