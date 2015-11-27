package sissi.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sissi.core.IListItemRenderer;
	import sissi.core.TouchStates;
	import sissi.core.VirtualGroup;
	import sissi.core.VirtualItemRenderer;
	import sissi.core.sissi_internal;
	import sissi.interaction.ListInterAction;
	import sissi.layouts.HorizontalAlign;
	import sissi.layouts.HorizontalLayout;
	import sissi.layouts.LayoutDirection;
	import sissi.layouts.VerticalAlign;
	import sissi.layouts.VerticalLayout;

	public class List extends VirtualGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  showCount
		//----------------------------------
		private var _showCount:int;
		/**
		 * 显示的个数，如果设置了，则不会参考相应的width和height值。
		 **/
		public function get showCount():int
		{
			return _showCount;
		}
		public function set showCount(value:int):void
		{
			if(_showCount != value)
			{
				_showCount = value;
				if(_showCount > 0)
				{
					invalidateSize();
					invalidateDisplayList();
				}
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function List(direction:String = LayoutDirection.VERTICAL, virtualMode:Boolean = true)
		{
			super();
			
			if(direction == LayoutDirection.VERTICAL)
			{
				layout = new VerticalLayout();
				layout.align = HorizontalAlign.LEFT;
			}
			else
			{
				layout = new HorizontalLayout();
				layout.align = VerticalAlign.TOP;
			}
				
			
			_useVirtualMode = virtualMode;
			
			interAction = new ListInterAction(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: LifeCycle
		//
		//--------------------------------------------------------------------------
		override protected function createChildren():void
		{
			super.createChildren();
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		/**
		 * 计算出需要创建子对象数量
		 * @return 
		 */		
		override protected function calculateNeededItemRendererCount():int
		{
			var count:int = 0;
			if(_useVirtualMode)
			{
				if(layout.direction == LayoutDirection.VERTICAL)
				{
					count = Math.ceil(height / (measuredItemRendererHeight + layout.gap));
				}
				else if(layout.direction == LayoutDirection.HORIZONTAL)
				{
					count = Math.ceil(width / (measuredItemRendererWidth + layout.gap));
				}
				count += 1;
			}
			else
			{
				count = length;
			}
			return count;
		}
		
		override protected function measure():void
		{
			super.measure();
			if(layout.direction == LayoutDirection.VERTICAL)
			{
				if(!vScrollSize)
					vScrollSize = measuredItemRendererHeight + layout.gap;
			}
			else if(layout.direction == LayoutDirection.HORIZONTAL)
			{
				if(!hScrollSize)
					hScrollSize = measuredItemRendererWidth + layout.gap;
			}
			
			if(layout.direction == LayoutDirection.VERTICAL)
			{
				measuredWidth = measuredItemRendererWidth;
				measuredHeight = length > 0 ? (measuredItemRendererHeight + layout.gap) * length - layout.gap : 0;
			}
			else if(layout.direction == LayoutDirection.HORIZONTAL)
			{
				measuredWidth = length > 0 ? (measuredItemRendererWidth + layout.gap) * length - layout.gap : 0;
				measuredHeight = measuredItemRendererHeight;
			}
			if(_showCount)
			{
				if(layout.direction == LayoutDirection.VERTICAL)
				{
					explicitHeight = length > 0 ? (measuredItemRendererHeight + layout.gap) * _showCount - layout.gap : 0;
				}
				else if(layout.direction == LayoutDirection.HORIZONTAL)
				{
					explicitWidth = length > 0 ? (measuredItemRendererWidth + layout.gap) * _showCount - layout.gap : 0;
				}
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(!useVirtualMode)
			{
				layout.layoutContents(sissi_internal::contentGroup);
			}
		}
		/**
		 * 根据组件设定virtualItemRenderer的坐标
		 */		
		override protected function layoutVirtualChildren():void
		{
			var virtualNumChildren:int = virtualChildren.length;
			
			var virtualItemRendererWidth:Number = measuredItemRendererWidth;
			var virtualItemRendererHeight:Number = measuredItemRendererHeight;
			if(layout.direction == LayoutDirection.VERTICAL)
			{
				for(var v:int = 0; v < virtualNumChildren; v++)
				{
					virtualChildren[v].y = v * (layout.gap + virtualItemRendererHeight);
				}
			}
			else if(layout.direction == LayoutDirection.HORIZONTAL)
			{
				for(var h:int = 0; h < virtualNumChildren; h++)
				{
					virtualChildren[h].x = h * (layout.gap + virtualItemRendererWidth);
				}
			}
		}
		
		private var lastStartIndex:int =  -1;
		private var lastEndIndex:int = -1;
		/**
		 * 滚动内容
		 */		
		override protected function adjustContentScrollPosition():void
		{
			var contentGroup:DisplayObjectContainer = sissi_internal::contentGroup;
			if(useVirtualMode)
			{
				//不仅要参考dataProvider的变化引起的变化，还要参考目前的滚动条位置，来确定是否对组件进行赋值变更
				var currentStartIndex:int;
				var currentEndIndex:int;
				var perSize:Number;
				if(layout.direction == LayoutDirection.VERTICAL)
				{
					perSize = measuredItemRendererHeight + layout.gap;
					currentStartIndex = verticalScrollPosition / perSize;
					currentEndIndex = (verticalScrollPosition + height) / perSize;
				}
				else if(layout.direction == LayoutDirection.HORIZONTAL)
				{
					perSize = measuredItemRendererWidth + layout.gap;
					currentStartIndex = horizontalScrollPosition / perSize;
					currentEndIndex = (horizontalScrollPosition + width) / perSize;
				}
				//ReSet
				var maxIndex:int = length - 1;
				//确定要显示的个数
				var needShowDataLgh:int = 0;
				var needShowData:Vector.<VirtualItemRenderer>;
				if(length > 0)
				{
					currentEndIndex = currentEndIndex >maxIndex ? maxIndex : currentEndIndex;
					
					needShowData = virtualChildren.slice(currentStartIndex, currentEndIndex+1);
					needShowDataLgh = needShowData.length;
					
					//赋值，赋值多少个
					for(var n:int = 0; n < needShowDataLgh; n++)
					{
						var reUseItem:IListItemRenderer = contentGroup.getChildAt(n) as IListItemRenderer;
						if(reUseItem)
						{
							reUseItem.data = needShowData[n].data;
							reUseItem.itemIndex = needShowData[n].itemIndex;
							reUseItem.currentState = TouchStates.NORMAL;
							reUseItem.selected = false;
						}
					}
				}
				//更改位置
				var contentGroupNumberChildren:int = contentGroup.numChildren;
				for (var i:int = 0; i < contentGroupNumberChildren; i++) 
				{
					if(layout.direction == LayoutDirection.VERTICAL)
					{
						if(i < needShowDataLgh)
						{
							contentGroup.getChildAt(i).y = needShowData[i].y - verticalScrollPosition;
						}
						else
						{
							contentGroup.getChildAt(i).y = height;
						}
					}
					else if(layout.direction == LayoutDirection.HORIZONTAL)
					{
						if(i < needShowDataLgh)
						{
							contentGroup.getChildAt(i).x = needShowData[i].x - horizontalScrollPosition;
						}
						else
						{
							contentGroup.getChildAt(i).x = width;
						}
					}
				}
				
				oldHorizontalScrollPosition = horizontalScrollPosition;
				oldVerticalScrollPosition = verticalScrollPosition;
				if(sissi_internal::vScrollBar)
					sissi_internal::vScrollBar.scrollPosition = verticalScrollPosition;
				if(sissi_internal::hScrollBar)
					sissi_internal::hScrollBar.scrollPosition = horizontalScrollPosition;
			}
			else
			{
				//跟随dataProvider变化而变化，其他情况不需要变化
				if(listDataProviderChanged)
				{
					for(var r:int = 0; r < contentGroup.numChildren; r++)
					{
						var item:IListItemRenderer = contentGroup.getChildAt(r) as IListItemRenderer;
						item.data = dataProvider[r];
						item.itemIndex = r;
						item.currentState = TouchStates.NORMAL;
						item.selected = false;
					}
					listDataProviderChanged = false;
				}
				super.adjustContentScrollPosition();
			}
			scrollPositionOrDataProviderChanged = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public functions
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Protected functions
		//
		//--------------------------------------------------------------------------
		override protected function rollOverSkinMoveHandler(event:MouseEvent):void
		{
			if(rollOverSkin)
			{
				var stagePt:Point = new Point(event.stageX, event.stageY);
				var contentPt:Point = sissi_internal::contentGroup.globalToLocal(stagePt);
				//高亮位置，相对于容器而言
				var cursorIndex:int;
				//高亮显示的item位置，相对于数据而言
				var cursorItemIndex:int;
				if(layout.direction == LayoutDirection.VERTICAL)
				{
					if(_useVirtualMode)
						cursorIndex = (contentPt.y + verticalScrollPosition) / (measuredItemRendererHeight + layout.gap);
					else
						cursorIndex = contentPt.y / (measuredItemRendererHeight + layout.gap);
					
					rollOverSkin.y = cursorIndex * (measuredItemRendererHeight + layout.gap) - verticalScrollPosition;
				}
				else if(layout.direction == LayoutDirection.HORIZONTAL)
				{
					if(_useVirtualMode)
						cursorIndex = (contentPt.x + horizontalScrollPosition) / (measuredItemRendererWidth + layout.gap);
					else
						cursorIndex = contentPt.x / (measuredItemRendererWidth + layout.gap);
					
					rollOverSkin.x = cursorIndex * (measuredItemRendererWidth + layout.gap) - horizontalScrollPosition;
				}
				if(cursorItemIndex < length)
					rollOverSkin.visible = true;
			}
			trace(rollOverSkin.x, rollOverSkin.y)
			event.updateAfterEvent();
		}
		
		override protected function rollOutSkinMoveHandler(event:MouseEvent):void
		{
			if(rollOverSkin)
			{
				rollOverSkin.visible = false;
			}
			event.updateAfterEvent();
		}
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
	}
}