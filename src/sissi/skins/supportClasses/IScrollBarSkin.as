package sissi.skins.supportClasses
{
	import flash.display.DisplayObject;
	
	import sissi.core.ISkin;
	
	public interface IScrollBarSkin extends ISkin
	{
		function get trackSkin():DisplayObject;
		function set trackSkin(value:DisplayObject):void;
		
		
		function get thumbUpSkin():DisplayObject;
		function set thumbUpSkin(value:DisplayObject):void;
		
		function get thumbDownSkin():DisplayObject;
		function set thumbDownSkin(value:DisplayObject):void;
		
		function get thumbOverSkin():DisplayObject;
		function set thumbOverSkin(value:DisplayObject):void;
		
		
		function get upArrowUpSkin():DisplayObject;
		function set upArrowUpSkin(value:DisplayObject):void;
		
		function get upArrowDownSkin():DisplayObject;
		function set upArrowDownSkin(value:DisplayObject):void;
		
		function get upArrowOverSkin():DisplayObject;
		function set upArrowOverSkin(value:DisplayObject):void;
		
		
		function get downArrowUpSkin():DisplayObject;
		function set downArrowUpSkin(value:DisplayObject):void;
		
		function get downArrowDownSkin():DisplayObject;
		function set downArrowDownSkin(value:DisplayObject):void;
		
		function get downArrowOverSkin():DisplayObject;
		function set downArrowOverSkin(value:DisplayObject):void;
	}
}