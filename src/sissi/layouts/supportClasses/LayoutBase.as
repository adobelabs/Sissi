package sissi.layouts.supportClasses
{
	import flash.display.DisplayObjectContainer;

	public class LayoutBase
	{
		public function LayoutBase()
		{
		}
		
		/**
		 * 实施Layout的目标组件。
		 */		
		public var target:DisplayObjectContainer;
		
		/**
		 * Layout的方向。
		 */		
		public var direction:String;
		
		/**
		 * Layout对齐方式。
		 */		
		public var align:String;
		
		/**
		 * Layout间距。
		 */		
		public var gap:Number = 0;
		
		/**
		 * Layout测量。
		 */		
		public function measure():void
		{
		}
		
		/**
		 * 实施Layout。
		 * @param container target或者target内部容器。
		 */		
		public function layoutContents(container:DisplayObjectContainer):void
		{
		}
	}
}