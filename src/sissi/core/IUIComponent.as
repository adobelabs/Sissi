package sissi.core
{
	import flash.events.IEventDispatcher;

	public interface IUIComponent extends IEventDispatcher, ILayoutComponent, ISissiComponent
	{
		function get nestLevel():int;
		function set nestLevel(value:int):void;
		
		function get initialized():Boolean;
		function set initialized(value:Boolean):void;
		
		function get processedDescriptors():Boolean;
		function set processedDescriptors(value:Boolean):void;
		
		function get updateCompletePendingFlag():Boolean;
		function set updateCompletePendingFlag(value:Boolean):void;
		
		/**
		 * 初始化
		 */		
		function initialize():void;
		
		/**
		 * 由LayoutManager进行控制
		 */		
		function validateProperties():void;
		function validateSize(recursive:Boolean = false):void;
		function validateDisplayList():void;
		function validateNow():void;
		
		/**
		 * 把自己的交给LayoutManager
		 */		
		function invalidateProperties():void;
		function invalidateSize():void;
		function invalidateDisplayList():void;
	}
}