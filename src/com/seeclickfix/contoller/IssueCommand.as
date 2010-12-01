////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Nov 23, 2010 
////////////////////////////////////////////////////////////

package com.seeclickfix.contoller
{
	import com.foursquare.events.ErrorEvent;
	import com.foursquare.models.FoursquareModel;
	import com.foursquare.models.vo.CityVO;
	import com.foursquare.services.IGeoService;
	import com.foursquare.views.FeedMediator;
	import com.foursquare.views.MainViewMediator;
	import com.seeclickfix.events.IssueEvent;
	import com.seeclickfix.models.vo.IssueVO;
	import com.seeclickfix.services.ISeeClickFixService;
	
	import org.robotlegs.mvcs.Command;

	public class IssueCommand extends Command
	{
		[Inject]
		public var event:IssueEvent;
		
		[Inject]
		public var seeClickFixService:ISeeClickFixService;
		[Inject]
		public var maxmindService:IGeoService;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var checkinMediator:FeedMediator;
		
		[Inject]
		public var foursquareModel:FoursquareModel;

		public function IssueCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch(event.type){
				case IssueEvent.READ:
					//getIssues();
					getLocation();
					break;
				case IssueEvent.READ_RETURNED:
					issuesGot( event.issues );
					break;
				/*case CheckinEvent.CHECKIN:
					createCheckin( event ); 
					break;
				case CheckinEvent.CHECKIN_SUCCESS:
					handleCheckin(event.message);
					break;
				case CheckinEvent.CHANGE_POLL_INTERVAL:
					checkinMediator.pollInterval = (event as CheckinEvent).interval;
					break;
				case CheckinEvent.TOGGLE_GROWL_MESSAGING:
					mainViewMediator.showGrowl =  (event as CheckinEvent).useGrowl;
					break;*/
			}
		}
		
		private function getIssues(event:IssueEvent):void{
			seeClickFixService.getIssues(event.cityVO);
		}
		
		/**
		 * pings a service and returns the user's long/lat 
		 * 
		 */		
		private function getLocation():void{
			maxmindService.getGeospatialInfos(handleLocation, faultLocation);
		}
		
		private function issuesGot( issues: Vector.<IssueVO> ):void{
			
		}
		
		/**
		 * callback for geocoding results.
		 * set the currentUser's cityVO 
		 * @param xml
		 * 
		 */		
		private function handleLocation(xml : XML):void{
			var cityVO:CityVO = new CityVO(null);
			cityVO.geolat = xml.geoip_latitude.@value;
			cityVO.geolong = xml.geoip_longitude.@value;
			cityVO.region = xml.geoip_region.@value;
			cityVO.city = xml.geoip_city.@value;
			cityVO.postal_code = xml.postal_code.@value;
			
			var issueEvent:IssueEvent = new IssueEvent( IssueEvent.READ );
			issueEvent.cityVO = cityVO;
			getIssues( issueEvent);
		}
		
		private function faultLocation():void{
			var errorEvent:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR );
			errorEvent.error = new Error("could not get your location");
			dispatch(errorEvent);
		}
		
		
	}
}