package sissi.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sissi.components.TileList;
	import sissi.layouts.supportClasses.LayoutBase;
	
	public class TileLayout extends LayoutBase
	{
		public function TileLayout()
		{
			super();
		}
		
		/**
		 * 横间距。
		 */		
		public var horizontalGap:Number = 10;
		/**
		 * 竖间距。
		 */		
		public var verticalGap:Number = 10;
		
		/**
		 * 实际内容距离0，0点的坐标
		 */
		public var marginX:int = 0;
		public var marginY:int = 0;
		
		/**
		 * Layout测量。
		 */		
		override public function measure():void
		{
		}
		
		/**
		 * 实施Layout。
		 * @param container target或者target内部容器。
		 */		
		override public function layoutContents(container:DisplayObjectContainer):void
		{
			if(!target)
				return;
			
			var numChildren:int = container.numChildren;
			var columnCount:int = (target as TileList).columnCount;
			var nextX:Number;
			var nextY:Number;
			var rowMaxY:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				if(i % columnCount == 0)
				{
					nextX = 0;
					nextY = rowMaxY;
				}
				var child:DisplayObject = container.getChildAt(i);
				child.x = marginX + nextX;
				child.y = marginY + nextY;
				nextX += horizontalGap + child.width;
				rowMaxY = Math.max(nextY, child.y + child.height + verticalGap - marginY);
			}
		}
	}
}