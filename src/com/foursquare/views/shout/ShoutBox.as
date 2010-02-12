////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Seth Hillinger
// Created: Feb 12, 2010 
////////////////////////////////////////////////////////////

package com.foursquare.views.shout
{
	import flash.events.MouseEvent;
	
	import spark.components.PopUpAnchor;
	import spark.components.TextArea;
	import spark.components.supportClasses.ButtonBase;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class ShoutBox extends SkinnableComponent
	{
		
		[SkinPart(required="true")]
		public var openButton:ButtonBase;

		[SkinPart(required="true")]
		public var closeButton:ButtonBase;

		[SkinPart(required="true")]
		public var popUp:PopUpAnchor;

		[SkinPart(required="true")]
		public var shoutButton:ButtonBase;
		
		[SkinPart(required="true")]
		public var shoutText:TextArea;
		
		public function ShoutBox()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object) : void{
			switch(partName){
				case "openButton":
					openButton.addEventListener(MouseEvent.CLICK, openPopUp);
					break;
				case "closeButton":
					closeButton.addEventListener(MouseEvent.CLICK, closePopUp);
					break;
				case "shoutButton":
					shoutButton.addEventListener(MouseEvent.CLICK, shoutMessage);
					break;
			}
		}
		
		private function shoutMessage(event:MouseEvent):void
		{
			
		}
		
		private function openPopUp(event:MouseEvent=null):void{
			popUp.displayPopUp = true;
			skin.currentState = "open";
		}
		
		private function closePopUp(event:MouseEvent=null):void{
			popUp.displayPopUp = false;
			skin.currentState = "normal";
		}
		
	}
}