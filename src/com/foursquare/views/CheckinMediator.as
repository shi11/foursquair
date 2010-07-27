////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.events.VenueEvent;
	import com.foursquare.models.Constants;
	import com.foursquare.models.FoursquareModel;
	import com.foursquare.models.vo.UserVO;
	import com.foursquare.views.feed.FeedView;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class CheckinMediator extends Mediator
	{

		[Inject]
		public var feedView : FeedView;
		
		[Inject]
		public var foursquareModel:FoursquareModel;

		/**
		 * flag for when to start polling
		 */
		private var _firstRead : Boolean = true;
		/**
		 * delay between timer events in milliseconds
		 */
		private var _pollInterval : int = Constants.defaultPollInterval;

		private var timer : Timer;

		public function CheckinMediator()
		{
			super();
		}

		override public function onRegister() : void
		{
			eventMap.mapListener(feedView, CheckinEvent.READ, getCheckins);
			eventMap.mapListener(feedView, UserEvent.GET_DETAILS, getUserDetails);
			eventMap.mapListener(feedView, VenueEvent.GET_VENUE_DETAILS, getVenueDetails);

			foursquareModel.feed.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCheckinsChange);
			
			getCheckins();
		}

		public function startPolling() : void
		{
			if (!timer)
			{
				timer = new Timer(_pollInterval);
				timer.addEventListener(TimerEvent.TIMER, getCheckins);
			}
			timer.start();
		}

		public function stopPolling() : void
		{
			timer.stop();
		}

		public function setUserDetails(userVO : UserVO) : void
		{
			feedView.openUserDetails(userVO);
		}
		
		public function handleResults():void{
			if (_firstRead)
			{
				_firstRead = false;
				startPolling();
			}
		}
		
		private function onCheckinsChange(event:CollectionEvent):void{
			feedView.createView( foursquareModel.feed );
		}

		private function getCheckins(event : TimerEvent=null) : void
		{
			eventDispatcher.dispatchEvent(new CheckinEvent(CheckinEvent.READ));
		}

		private function getUserDetails(event : UserEvent) : void
		{
			eventDispatcher.dispatchEvent(event.clone());
		}

		private function getVenueDetails(event : VenueEvent) : void
		{
			eventDispatcher.dispatchEvent(event.clone());
		}

		public function get firstRead() : Boolean
		{
			return _firstRead;
		}

		public function set pollInterval(interval : int) : void
		{
			_pollInterval = interval;
			timer.delay = _pollInterval;
			timer.reset();
		}

		public function get pollInterval() : int
		{
			return _pollInterval;
		}
	}
}