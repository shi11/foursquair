package com.seeclickfix.events
{
	import com.foursquare.models.vo.CityVO;
	import com.seeclickfix.models.vo.IssueVO;
	
	import flash.events.Event;

	public class IssueEvent extends Event
	{
		
		public static const READ:String = "read";
		public static const READ_RETURNED:String = "readReturned";
		
		public var cityVO:CityVO;
		
		public var issues:Vector.<IssueVO>;
		
		public function IssueEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event{
			var issueEvent:IssueEvent = new IssueEvent(type);
			issueEvent.cityVO = cityVO;
			issueEvent.issues = issues;
			return issueEvent;
		}
	}
}