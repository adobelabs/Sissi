package sissi.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sissi.core.UIComponent;
	import sissi.core.UIGroup;
	import sissi.core.sissi_internal;
	import sissi.layouts.supportClasses.LayoutBase;

	public class VerticalLayout extends LayoutBase
	{
		public function VerticalLayout()
		{
			super();
			direction = LayoutDirection.VERTICAL;
			align = HorizontalAlign.CENTER;
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
				childTotalHeight += child.height;
				childTotalWidth = child.width > childTotalWidth ? child.width : childTotalWidth;
				childIndex++;
			}
			
			if(target is UIGroup)
			{
				UIComponent(target).measuredWidth = childTotalWidth;
				UIComponent(target).measuredHeight = target.numChildren > 0 ? childTotalHeight + gap * (target.numChildren - 1) : 0;
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
			
			var nextY:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				child.y = nextY;
				nextY += gap + child.height;
				
				//Switch写在这里主要考虑元素不一样的情况。
				switch(align)
				{
					case HorizontalAlign.CENTER:
					{
						child.x = (container.width - child.width) * .5;
						break;
					}
					case HorizontalAlign.RIGHT:
					{
						child.x = container.width - child.width;
						break;
					}
					default:
					{
						//case HorizontalAlign.LEFT:
						child.x = 0;
						break;
					}
				}
			}
		}
	}
}