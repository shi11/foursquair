package com.seeclickfix.services
{
	import com.adobe.serialization.json.JSON;
	import com.foursquare.events.ErrorEvent;
	import com.foursquare.events.LoginEvent;
	import com.foursquare.models.vo.CityVO;
	import com.seeclickfix.events.IssueEvent;
	import com.seeclickfix.models.vo.IssueVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.mvcs.Actor;
	
	public class SeeClickFixService extends Actor implements ISeeClickFixService
	{
		public function SeeClickFixService()
		{
			super();
		}
		
		public function login(event:LoginEvent):void
		{
		}
		
		public function getIssues(cityVO:CityVO):void
		{
			var request : URLRequest = new URLRequest("http://seeclickfix.com/api/issues.json" +
														"?at="+cityVO.city+",+"+cityVO.region+
														"&lat="+cityVO.geolat+"&lng="+cityVO.geolong);
			request.method = URLRequestMethod.GET;
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(Event.COMPLETE, onResult_getIssues);
			loader.load(request);
		}
		
		/**
		 * process results of getFeed 
		 * @param event
		 * 
		 */		
		private function onResult_getIssues(event : Event):void{

			var data:Array = JSON.decode( event.target.data );
			var issues:Vector.<IssueVO> = new Vector.<IssueVO>;
			for( var i:int=0; i<data.length; i++){
				issues.push( new IssueVO( data[i] ));
			}
			
			var issueEvent:IssueEvent = new IssueEvent( IssueEvent.READ_RETURNED );
			issueEvent.issues = issues;
			dispatch( issueEvent );
		}
		
		private function onIOError(event:IOErrorEvent):void{
			var error : Error = new Error( (event.target as URLLoader).data, event.errorID );
			handleError(error);
		}
		
		private function handleError(error : Error) : void
		{
			var errorEvent:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR);
			errorEvent.error = error;
			dispatch(errorEvent);
		}
	}
}