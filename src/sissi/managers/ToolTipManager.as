package sissi.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class ToolTipManager
	{
		private static var impl:ToolTipManagerImpl = ToolTipManagerImpl.getInstance();
		
		/**
		 * 注册ToolTip存放位置。
		 * @param value
		 */		
		public static function registerToolTipLayer(layer:DisplayObjectContainer):void
		{
			impl.registerToolTipLayer(layer);
		}
		
		/**
		 * 对target注册Tooltip，显示出相应的toolTip。
		 * 其中toolTipData不仅能够支持简单的Object类型，还能接受Function类型。
		 * @param target 被注册的组件
		 * @param toolTipData 被注册的数据。
		 */		
		public static function registerToolTip(target:DisplayObject, toolTipData:*):void
		{
			impl.registerToolTip(target, toolTipData);
		}
		
		/**
		 * 对target去除注册Tooltip。
		 * @param target 被注册的组件
		 */		
		public static function unRegisterToolTip(target:DisplayObject):void
		{
			impl.unRegisterToolTip(target);
		}
		
		/**
		 * 设定ToolTip显示的Class类型。
		 * @param toolTipCls ToolTip显示的Class类型
		 */		
		public static function setToolTipClass(toolTipCls:Class):void
		{
			impl.currentToolTipClass = toolTipCls;
		}
		
		/**
		 * 设定ToolTip的位置。
		 * 不仅能够支持简单的Object类型，还能接受Function类型。
		 * @param toolTipPosition ToolTip的位置
		 */		
		public static function setToolTipPosition(toolTipPosition:*):void
		{
			impl.currentToolTipPosition = toolTipPosition;
		}
	}
}