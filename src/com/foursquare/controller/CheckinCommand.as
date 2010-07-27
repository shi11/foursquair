////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 30, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.controller
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.models.Constants;
	import com.foursquare.models.FoursquareModel;
	import com.foursquare.models.vo.CheckinVO;
	import com.foursquare.services.IFoursquareService;
	import com.foursquare.views.FeedMediator;
	import com.foursquare.views.MainViewMediator;
	import com.foursquare.views.SettingsMediator;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class CheckinCommand extends Command
	{
		[Inject]
		public var event:CheckinEvent;
		
		[Inject]
		public var foursquareService:IFoursquareService;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var checkinMediator:FeedMediator;
		
		[Inject]
		public var foursquareModel:FoursquareModel;

		public function CheckinCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch(event.type){
				case CheckinEvent.CHECKIN:
					createCheckin( event ); 
					break;
				case CheckinEvent.READ:
					getFeed();
					break;
				case CheckinEvent.READ_RETURNED:
					feedGot( event.checkins );
					break;
				case CheckinEvent.CHECKIN_SUCCESS:
					handleCheckin(event.message);
					break;
				case CheckinEvent.CHANGE_POLL_INTERVAL:
					checkinMediator.pollInterval = (event as CheckinEvent).interval;
					break;
				case CheckinEvent.TOGGLE_GROWL_MESSAGING:
					mainViewMediator.showGrowl =  (event as CheckinEvent).useGrowl;
					break;
			}
		}
		
		private function createCheckin( event : CheckinEvent ):void{
			if(!event.venueVO)
			{
				foursquareService.checkin( event.message );
			}else{
				foursquareService.checkin( event.message, event.venueVO );
			}
		}
		
		private function getFeed():void{
			foursquareService.getFeed();
		}
		
		private function feedGot( feed: Array ):void{
			
			if( !checkinMediator.firstRead && mainViewMediator.showGrowl){
				var newFeed:ArrayCollection = findNewFeed( feed );
				for each(var checkin:CheckinVO in newFeed){
					mainViewMediator.growl( checkin );
				}
			}

			checkinMediator.handleResults();
			foursquareModel.feed.source = feed;
		}
		
		/**
		 * checks for new feed since last timerEvent...
		 * @param currentCheckin
		 * @param newCheckin
		 * @return 
		 * 
		 */		
		private function findNewFeed(feed:Array):ArrayCollection{
			
			var timeFromLastPoll:Number = new Date().time - checkinMediator.pollInterval;
			var newFeed:ArrayCollection = new ArrayCollection();
			
			for each(var checkin:CheckinVO in feed){
				if( checkin.created.time > timeFromLastPoll){
					newFeed.addItem( checkin );
				}else{
					break;
				}
			}
			return newFeed;			
		}
		
		private function startPolling():void{
			checkinMediator.startPolling();
		}

		private function stopPolling():void{
			checkinMediator.stopPolling();
		}
		
		private function handleCheckin( message:String ):void{
			mainViewMediator.handleShout( message );
			getFeed();
		}

	}
}