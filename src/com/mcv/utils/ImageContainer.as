package com.mcv.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	/**
	 * ...
	 * @author Matthew C. Valverde
	 */
	
	public class ImageContainer extends Sprite
	{
		public static var BITMAP_COMPLETE:String = "bitmap_complete";
		public static var CROPPED:String = "cropped";
		
		private var _bitmapWidth:Number;
		private var _bitmapHeight:Number;
		private var _containerWidth:Number;
		private var _containerHeight:Number;
		private var _loader:Loader;
		private var _bitmap:Bitmap;
		private var _scale:Number;
		
		private var _cropRect:Sprite
		private var _croppedBitmap:Bitmap;
		private var _cropped:Boolean;
		
		public function ImageContainer(path:String, w:Number, h:Number)
		{
			containerWidth = w;
			containerHeight = h;
			
			addEventListener(MouseEvent.RIGHT_MOUSE_UP, rightUpHandler);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightClickHandler);
			
			_loader = new Loader();
			
			try
			{
				_loader.load(new URLRequest(path));
			}
			catch (error:Error)
			{
				
			}
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
		}
		
		private function loaderComplete(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
			var w:Number = loader.width;
			var h:Number = loader.height;
			
			var matrix:Matrix = new Matrix();
			
			if (w > h)
			{
				scale = containerWidth / w;
			}
			else
			{
				scale = containerHeight / h;
			}
			
			if (scale < 1)
			{	
				scale = Math.abs(scale);
				w = (w * scale) || 1;
				h = (h * scale) || 1;
				matrix.scale(scale, scale);	
			}
			
			var bitmapData:BitmapData = new BitmapData(w, h, false, 0xFFFFFFFF);
			bitmapData.draw(loader, matrix)
			bitmap = new Bitmap(bitmapData);
			bitmap.smoothing = true;
			addChild(bitmap);
			
			bitmapWidth = bitmap.width;
			bitmapHeight = bitmap.height;
			
			loader.unload();
			loader = null;
			
			cropRect = new Sprite();
			cropRect.graphics.lineStyle(0, 0xffffff);
			cropRect.graphics.beginFill(0, .2);
			cropRect.graphics.drawRect(-125, -200, 250, 400);
			cropRect.graphics.endFill();
			addChild(cropRect);
			cropRect.y = (cropRect.height / 2)
			cropRect.x = (cropRect.width / 2)
			cropRect.visible = false;
			cropRect.addEventListener(MouseEvent.DOUBLE_CLICK, cropDoubleClickHandler);
			cropRect.doubleClickEnabled = true;
			
			dispatchEvent(new Event(BITMAP_COMPLETE, true));
		}
		
		private function rightClickHandler(event:MouseEvent):void
		{
			if (cropped)
				return;
			
			cropRect.startDrag(true);
			
			cropRect.visible = true;
			cropRect.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			cropRect.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			cropRect.stopDrag();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			//cropRect.startDrag(true);
		}
		
		private function cropDoubleClickHandler(event:MouseEvent):void
		{
			if (cropped)
				return;
			
			cropped = true;
			
			var bmd2:BitmapData = new BitmapData(cropRect.width, cropRect.height, false, 0xffffff);
			var pt:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(cropRect.x - (cropRect.width / 2), cropRect.y - (cropRect.height / 2), cropRect.width, cropRect.height);
			
			try
			{
				bmd2.copyPixels(bitmap.bitmapData, rect, pt);
			}
			catch (error:Error)
			{
				return;
			}
			
			croppedBitmap = new Bitmap(bmd2);
			croppedBitmap.smoothing = true;
			addChild(croppedBitmap);
			croppedBitmap.x = 0; //cropRect.x - (cropRect.width / 2);
			croppedBitmap.y = 0; // cropRect.y - (cropRect.height / 2);
			cropRect.visible = false;
			bitmap.visible = false;
			
			cropRect.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			cropRect.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			dispatchEvent(new Event(CROPPED, true));
		}
		
		private function rightUpHandler(event:MouseEvent):void
		{
			if (cropped)
				return;		
		}
		
		public function get bitmapWidth():Number
		{
			return _bitmapWidth;
		}
		
		public function set bitmapWidth(value:Number):void
		{
			_bitmapWidth = value;
		}
		
		public function get bitmapHeight():Number
		{
			return _bitmapHeight;
		}
		
		public function set bitmapHeight(value:Number):void
		{
			_bitmapHeight = value;
		}
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function set bitmap(value:Bitmap):void
		{
			_bitmap = value;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function set scale(value:Number):void
		{
			_scale = value;
		}
		
		public function get cropRect():Sprite
		{
			return _cropRect;
		}
		
		public function set cropRect(value:Sprite):void
		{
			_cropRect = value;
		}
		
		public function get croppedBitmap():Bitmap
		{
			return _croppedBitmap;
		}
		
		public function set croppedBitmap(value:Bitmap):void
		{
			_croppedBitmap = value;
		}
		
		public function get containerWidth():Number
		{
			return _containerWidth;
		}
		
		public function set containerWidth(value:Number):void
		{
			_containerWidth = value;
		}
		
		public function get containerHeight():Number
		{
			return _containerHeight;
		}
		
		public function set containerHeight(value:Number):void
		{
			_containerHeight = value;
		}
		
		public function get cropped():Boolean
		{
			return _cropped;
		}
		
		public function set cropped(value:Boolean):void
		{
			_cropped = value;
		}
	}

}