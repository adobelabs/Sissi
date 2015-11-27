package sissi.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sissi.core.UIComponent;
	import sissi.core.UIGroup;
	import sissi.core.sissi_internal;
	import sissi.layouts.supportClasses.LayoutBase;

	/**
	 * 横向排版。
	 * 默认对齐方式为居中，间隔为10像素。
	 * @author Alvin
	 */	
	public class HorizontalLayout extends LayoutBase
	{
		public function HorizontalLayout()
		{
			super();
			direction = LayoutDirection.HORIZONTAL;
			align = HorizontalAlign.LEFT;
			gap = 10;
		}
		
		/**
		 * 测量尺寸。
		 */		
		override public function measure():void
		{
			if(!target)
				return;
			
			var childContainer:DisplayObjectContainer;
			if(target is UIGroup)
			{
				childContainer = UIGroup(target).sissi_internal::contentGroup;
			}
			else
			{
				childContainer = target;
			}
			
			var childTotalWidth:Number = 0;
			var childTotalHeight:Number = 0;
			
			var numChildren:int = childContainer.numChildren;
			var childIndex:int = 0;
			while(childIndex < numChildren)
			{
				var child:DisplayObject = childContainer.getChildAt(childIndex);
//				if(child is UIComponent)
//				{
//					UIComponent(child).validateSize();
//				}
				childTotalWidth += child.width;
				childTotalHeight = child.height > childTotalHeight ? child.height : childTotalHeight;
				childIndex++;
			}
			
			if(target is UIGroup)
			{
				UIGroup(target).measuredWidth = (target.numChildren > 0 ? childTotalWidth + gap * (target.numChildren - 1) : 0);
				UIGroup(target).measuredHeight = childTotalHeight;
			}
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
			
			var totalWidth:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				totalWidth += child.width + gap;
			}
			totalWidth -= gap;//减去多加的最后一个
			
			var startX:Number = 0;
			switch(align)
			{
				case HorizontalAlign.LEFT:
				{
					startX = 0;
					break;
				}
				case HorizontalAlign.CENTER:
				{
					startX = (container.width - totalWidth) * .5;
					break;
				}
				case HorizontalAlign.RIGHT:
				{
					startX = container.width - totalWidth;
					break;
				}
			}
			
			for(i = 0; i < numChildren; i++)
			{
				child = container.getChildAt(i);
				child.x = startX;
				startX += gap + child.width;
			}
		}
	}
}