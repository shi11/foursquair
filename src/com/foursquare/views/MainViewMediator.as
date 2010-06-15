////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Jan 31, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.ErrorEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.events.NavigationEvent;
	import com.foursquare.models.Section;
	import com.foursquare.models.vo.CheckinVO;
	import com.foursquare.views.alert.Alert;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		
		[Inject]
		public var mainView:Foursquair;
		
		/**
		 * flag for whether to "growl"
		 * @see PurrWindow
		 */		
		public var showGrowl:Boolean;

		public function MainViewMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener( eventDispatcher, NavigationEvent.CHANGE, navigateToSection );
			eventMap.mapListener( eventDispatcher, ErrorEvent.ERROR, displayError );

			eventMap.mapListener( mainView, LoginEvent.LOGOUT, logout );
		}
		
		//returned from a shout message
		public function handleShout( message :String ) : void{
			mainView.handleShout( message );
		}
		
		public function growl( checkin:CheckinVO ):void{
			if( checkin.is_shout_only){
				mainView.growl( checkin.user.name_with_initial, checkin.shout);
			}else{
				mainView.growl( checkin.user.name_with_initial, checkin.venue.name +" at "+checkin.created_in_words +" /n "+checkin.shout);
			}
		}
		
		/**
		 * sets the currentState of the app 
		 * @param navigationEvent
		 * 
		 */		
		private function navigateToSection(navigationEvent:NavigationEvent):void{
			if(!mainView.hasState( navigationEvent.section )){
				throw new Error("missing state "+navigationEvent.section);
				return;
			}else{
				mainView.setCurrentState(navigationEvent.section);
			}
		}
		
		/**
		 * open alert window and show error message 
		 * @param event
		 * 
		 */		
		private function displayError(event:ErrorEvent):void{
			Alert.show( mainView, event.error.message, "hmm...", true );
		}
		
		/**
		 * logout 
		 * @param event
		 * 
		 */		
		private function logout(event:LoginEvent):void{
			dispatch( event.clone() );
			mainView.setCurrentState(Section.LOGIN);
		}
		
		}
}