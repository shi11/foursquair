package com.seeclickfix.models.vo{
	public class IssueVO{
		
		public var address:String;
		public var bitly:String;
		public var created_at:String;
		public var description:String;
		public var issue_id:String;
		public var lat:Number;
		public var lng:Number;
		public var minutes_since_created:int;
		public var page:int;
		public var rating:int;
		public var slug:String;
		public var status:String;
		public var summary:String;
		public var updated_at:String;
		public var updated_at_raw:String;
		
		public function IssueVO(remote:Object){
			if(remote){
				address = remote.address;
				bitly = remote.bitly;
				created_at = remote.created_at;
				description = remote.description;
				issue_id = remote.issue_id;
				lat = remote.lat;
				lng = remote.lng;
				minutes_since_created = remote.minutes_since_created;
				page = remote.page;
				rating = remote.rating;
				slug = remote.slug;
				status = remote.status;
				summary = remote.summary;
				updated_at = remote.updated_at;
				updated_at_raw = remote.updated_at_raw;
			}
		}
	}
}