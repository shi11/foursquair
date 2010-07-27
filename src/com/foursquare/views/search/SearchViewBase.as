////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Mar 7, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.search
{
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.SearchEvent;
	import com.foursquare.events.VenueEvent;
	import com.foursquare.models.vo.CityVO;
	import com.foursquare.models.vo.VenueVO;
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
	import spark.events.IndexChangeEvent;
	
	public class SearchViewBase extends SkinnableContainer
	{
		
		public var searchList:List;
		public var cityLabel:Label;
		public var searchInput:TextInput;
		public var searchButton:Button;
		
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
			searchList.addEventListener(IndexChangeEvent.CHANGE, onSearchListSelect);
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
		
		private function onSearchClick(event:Event):void{
			var searchEvent:SearchEvent = new SearchEvent(SearchEvent.QUERY);
			searchEvent.keyword = searchInput.text;
			dispatchEvent( searchEvent );
			
			setFocus();
		}
		
		private function onSearchListSelect(event:IndexChangeEvent):void{
			var venueEvent:VenueEvent = new VenueEvent(VenueEvent.VENUE_CHANGING);
			venueEvent.venue = searchList.selectedItem as VenueVO;
			dispatchEvent( venueEvent );
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