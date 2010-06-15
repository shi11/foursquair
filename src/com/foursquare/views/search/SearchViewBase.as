////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.search
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.SearchEvent;
	import com.foursquare.models.vo.CityVO;
	import com.foursquare.skins.search.SearchButton;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.SkinnableContainer;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	/*
	*  Dispatched when the user clicks SHOUT to send a message
	*  @eventType com.foursquare.events.CheckinEvent.SHOUT
	*/
	[Event(name="shout", type="com.foursquare.events.CheckinEvent")]
	
	public class SearchViewBase extends SkinnableContainer
	{
		
		public var searchList:List;
		public var cityLabel:Label;
		public var searchInput:TextInput;
		public var searchButton:Button;
		public var shoutButton:Button;
		public var shoutText:TextArea;
		
		private var _results:ArrayCollection;
		private var resultsChanged:Boolean;
		
		public function SearchViewBase()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			searchInput.addEventListener(FlexEvent.ENTER, onSearchClick);
			searchButton.addEventListener( MouseEvent.CLICK, onSearchClick);
			shoutButton.addEventListener( MouseEvent.CLICK, onShoutClick);
		}
		
		public function bounceShoutEvent( event:CheckinEvent ):void{
			dispatchEvent( event.clone() );
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			if(resultsChanged){
				resultsChanged = false;
				searchList.dataProvider = _results;
			}
		}
		
		public function setCity(city:CityVO):void{
			cityLabel.text = "You're in " + city.name;
		}
		
		public function shoutSent():void{
			shoutText.text = "";
			shoutButton.enabled = true;
		}
		
		private function onSearchClick(event:Event):void{
			var searchEvent:SearchEvent = new SearchEvent(SearchEvent.QUERY);
			searchEvent.keyword = searchInput.text;
			dispatchEvent( searchEvent );
			
			setFocus();
		}
		
		private function onShoutClick(event:MouseEvent):void
		{
			var checkinEvent:CheckinEvent = new CheckinEvent( CheckinEvent.SHOUT );
			checkinEvent.message = shoutText.text;
			dispatchEvent( checkinEvent );
			
			shoutButton.enabled = false;
		}

		public function get results():ArrayCollection
		{
			return _results;
			
		}

		public function set results(value:ArrayCollection):void
		{
			_results = value;
			resultsChanged = true;
			invalidateProperties();
		}

	}
}