package sissi.skins.supportClasses
{
	import flash.display.DisplayObject;
	
	import sissi.core.ISkin;

	public interface ISliderSkin extends ISkin
	{
		function get trackSkin():DisplayObject;
		function set trackSkin(value:DisplayObject):void;
		
		function get thumbUpSkin():DisplayObject;
		function set thumbUpSkin(value:DisplayObject):void;
		
		function get thumbDownSkin():DisplayObject;
		function set thumbDownSkin(value:DisplayObject):void;
		
		function get thumbOverSkin():DisplayObject;
		function set thumbOverSkin(value:DisplayObject):void;
		
		function get thumbStyle():String;
		function set thumbStyle(value:String):void;
	}
}