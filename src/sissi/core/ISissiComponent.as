package sissi.core
{
	import flash.display.DisplayObject;
	
	import sissi.interaction.supportClasses.IInterAction;

	public interface ISissiComponent
	{
		//----------------------------------
		//  interAction
		//----------------------------------
		/**
		 * 交互
		 * @return 
		 */		
		function get interAction():IInterAction;
		function set interAction(value:IInterAction):void;
		//----------------------------------
		//  Drag
		//----------------------------------
		function registerDragComponent(dragBar:DisplayObject):void;
		function unRegisterDragComponent(dragBar:DisplayObject):void;
	}
}