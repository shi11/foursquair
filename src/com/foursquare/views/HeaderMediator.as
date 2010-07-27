////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 9, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.events.VenueEvent;
	import com.foursquare.models.FoursquareModel;
	import com.foursquare.views.header.HeaderView;
	
	import org.robotlegs.mvcs.Mediator;

	public class HeaderMediator extends Mediator
	{
		[Inject]
		public var headerView:HeaderView;
		
		[Inject]
		public var model:FoursquareModel;
		
		public function HeaderMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener( eventDispatcher, UserEvent.MY_DETAILS_GOT, onMyDetailsGot );
			eventMap.mapListener( eventDispatcher, VenueEvent.VENUE_CHANGING, onVenueChanging );
			eventMap.mapListener( headerView, CheckinEvent.CHECKIN, shoutMessage );
			
			if(model.currentUser){
				showUser(model.currentUser.firstname, model.currentUser.lastname, model.currentUser.photo);
			}
		}
		
		private function shoutMessage( event:CheckinEvent ):void{
			dispatch( event.clone() );
		}
		
		/**
		 * display
		 * 
		 * @param firstName
		 * @param lastName
		 * @param photo
		 * 
		 */		
		private function showUser(firstName:String, lastName:String, photo:String):void{
			headerView.userName.text = firstName +" "+ lastName;
			headerView.userImage.source = photo;
		}
		
		/**
		 * recieve user details
		 * @param event
		 * 
		 */		
		private function onMyDetailsGot(event:UserEvent):void{
			var lastName:String;
			event.userVO.lastname ? lastName = event.userVO.lastname : lastName = "";
			showUser(event.userVO.firstname, lastName, event.userVO.photo);
		}
		
		/**
		 * when user is changing their venue 
		 * @param event
		 * 
		 */		
		private function onVenueChanging(event:VenueEvent):void{
			headerView.selectedVenue = event.venue;
		}
	}
}