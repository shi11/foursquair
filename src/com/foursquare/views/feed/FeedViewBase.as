////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Lucas Hrabovsky, Seth Hillinger
// Created: Nov 16, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.feed
{
	
	import com.foursquare.controller.UserDetailsCommand;
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.events.VenueEvent;
	import com.foursquare.models.vo.CheckinVO;
	import com.foursquare.models.vo.UserVO;
	import com.foursquare.views.user.UserDetailsView;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.SkinnableContainer;
	
	public class FeedViewBase extends SkinnableContainer
	{
		
		private var _checkins:ArrayCollection;
		
		public function FeedViewBase()
		{
			super();
			addEventListener( UserEvent.GET_DETAILS, getUserDetails, true);
			addEventListener( VenueEvent.GET_VENUE_DETAILS, getVenueDetails, true);
		}
		
		public function getCheckins():void{
			var checkinEvent:CheckinEvent = new CheckinEvent( CheckinEvent.READ );
			dispatchEvent( checkinEvent );
		}
		
		public function createView(value:ArrayCollection):void{
			_checkins = value;
			
			var checkinItem:FeedItem;
			for (var i:int=0; i<numElements;i++){
				checkinItem = getElementAt(i) as FeedItem;
				checkinItem.unload();
			}
			removeAllElements();
			
			for each(var checkin:CheckinVO in _checkins){
				checkinItem = new FeedItem();
				checkinItem.checkinVO = checkin;
				addElement( checkinItem );
			}
		}
		
		public function openUserDetails(userVO:UserVO):void{
			var userDetails:UserDetailsView = new UserDetailsView();
			userDetails.addEventListener(CloseEvent.CLOSE, onDetailsClose);
			userDetails.user = userVO;
			PopUpManager.addPopUp( userDetails,this);
		}
		
		private function onDetailsClose(event:CloseEvent):void{
			PopUpManager.removePopUp( event.currentTarget as UserDetailsView );
		}
		
		private function getUserDetails(event:UserEvent):void{
			dispatchEvent( event.clone() );
		}
		
		private function getVenueDetails(event:VenueEvent):void{
			dispatchEvent( event.clone() );
		}
		
	}
}