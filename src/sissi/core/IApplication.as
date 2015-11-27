package sissi.core
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	public interface IApplication extends IEventDispatcher
	{
		function addPopUpChild(child:DisplayObject, modal:Boolean = false):void;
		
		function removePopUpChild(child:DisplayObject):void;
		
		function containsPopUpChild(child:DisplayObject):Boolean;
	}
}