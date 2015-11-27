package sissi.managers
{
	import flash.display.DisplayObject;
	
	public interface ICursorManager
	{
		function setCurrentCursor(customCursor:DisplayObject, xOffset:Number = 0, yOffset:Number = 0):void;
		function setDefaultCursor():void;
	}
}