package com.mcv.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.*;
	
	/**
	 * ...
	 * @author Matthew C Valverde
	 */
	public class GoogleImageAPI extends Sprite
	{
		private var _currentSearchTerm:String;
		private var _currentStartValue:int;
		public static var SEARCH_COMPLETE:String = "google_search_complete";
		public static var SEARCH_ERROR:String = "google_search_error";
		public var objectResults:Array;
		
		public function GoogleImageAPI()
		{
			super();
		}
		
		public function search(searchTerm:String, startValue:int = 0):void
		{
			if (objectResults)
			{
				objectResults = null;
			}
			
			objectResults = new Array();
			currentStartValue = 0;
			currentSearchTerm = "";
			
			currentSearchTerm = searchTerm;
			currentStartValue = startValue;
			
			go();
		
		}
		
		private function go():void
		{
			var urlreq:URLRequest = new URLRequest("https://ajax.googleapis.com/ajax/services/search/images");
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.v = '1.0';
			urlVariables.q = currentSearchTerm;
			urlVariables.resultFormat = "text";
			urlVariables.rsz = 'large';
			urlVariables.start = currentStartValue;
			urlreq.method = URLRequestMethod.GET;
			urlreq.data = urlVariables;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(urlreq);
		}
		
		private function onLoad(event:Event):void
		{
			var obj:Object = JSON.parse(event.target.data);
			if (obj.responseData==null)
			{
				dispatchErrorHandler(event);
				return;
			}
						
			var array:Array = obj.responseData.results;
			for (var i:String in array)
			{
				objectResults.push(array[i].url);
			}
			currentStartValue = currentStartValue + 8;
			
			if (currentStartValue == 64)
			{
				dispatchEvent(new Event(SEARCH_COMPLETE));
				event.target.removeEventListener(Event.COMPLETE, onLoad);
				return;
			}
			
			go();
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			dispatchErrorHandler(event);
		}
		
		private function dispatchErrorHandler(event:Event):void
		{
			dispatchEvent(new Event(SEARCH_ERROR));
			event.target.removeEventListener(Event.COMPLETE, onLoad);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		public function get currentSearchTerm():String
		{
			return _currentSearchTerm;
		}
		
		public function set currentSearchTerm(value:String):void
		{
			_currentSearchTerm = value;
		}
		
		public function get currentStartValue():int
		{
			return _currentStartValue;
		}
		
		public function set currentStartValue(value:int):void
		{
			_currentStartValue = value;
		}
	
	}

}