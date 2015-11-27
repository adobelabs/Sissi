package sissi.core
{
	import flash.display.Sprite;
	
	public class UISprite extends Sprite
	{
		public function UISprite()
		{
			super();
		}
		
		//------------------------------------------------
		//
		// override width, height function
		//
		//------------------------------------------------
		private var _width:Number;
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if(_width != value)
			{
				_width = value;
			}
		}
		
		private var _height:Number;
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if(_height != value)
			{
				_height = value;
			}
		}
	}
}