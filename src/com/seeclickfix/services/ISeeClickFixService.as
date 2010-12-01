package com.seeclickfix.services
{
	import com.foursquare.events.LoginEvent;
	import com.foursquare.models.vo.CityVO;

	public interface ISeeClickFixService
	{
		function login(event:LoginEvent):void;
		function getIssues(cityVO:CityVO):void;
	}
}