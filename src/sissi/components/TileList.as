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
	import sissi.interaction.TileListInterAction;
	import sissi.layouts.TileLayout;

	public class TileList extends VirtualGroup
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
		 * 满足此显示的个数的大小，区别于List.showCount
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
		
		private var _columnCount:int;
		public function get columnCount():int
		{
			return _columnCount;
		}
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function TileList(columnCount:int = 1, virtualMode:Boolean = true)
		{
			super();
			_columnCount = columnCount;
			_useVirtualMode = virtualMode;
			
			layout = new TileLayout();
			interAction = new TileListInterAction(this);
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
				count = Math.ceil(height / (measuredItemRendererHeight + (layout as TileLayout).verticalGap));
				count += 1;
				count = count * _columnCount;
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
			var vGap:Number = (layout as TileLayout).verticalGap;
			var hGap:Number = (layout as TileLayout).horizontalGap;
			var marginX:Number = (layout as TileLayout).marginX;
			var marginY:Number = (layout as TileLayout).marginY;
			if(!vScrollSize)
				vScrollSize = measuredItemRendererHeight +vGap ;
			if(!hScrollSize)
				hScrollSize = measuredItemRendererWidth + hGap;
			
			measuredWidth = length > 0 ? (measuredItemRendererWidth + hGap) * _columnCount - hGap + 2*marginX : 0;
			measuredHeight = length > 0 ? (measuredItemRendererHeight + vGap) * Math.ceil(length / _columnCount) - vGap + 2*marginY : 0;
			
			if(_showCount)
			{
				// 不用关注explicitWidth
				explicitHeight = (measuredItemRendererHeight + vGap) * Math.ceil(_showCount / _columnCount) - vGap + 2*marginY;
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
			
			var vGap:Number = (layout as TileLayout).verticalGap;
			var hGap:Number = (layout as TileLayout).horizontalGap;
			var rowIndex:int;
			var columnIndex:int;
			for(var t:int = 0; t < virtualNumChildren; t++)
			{
				rowIndex = t / _columnCount;
				columnIndex = t % _columnCount;
				
				virtualChildren[t].x = columnIndex * (measuredItemRendererWidth + hGap);
				virtualChildren[t].y = rowIndex * (measuredItemRendererHeight + vGap);
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
				var vGap:Number = (layout as TileLayout).verticalGap;
				var hGap:Number = (layout as TileLayout).horizontalGap;
				var marginX:Number = (layout as TileLayout).marginX;
				var marginY:Number = (layout as TileLayout).marginY;
				//不仅要参考dataProvider的变化引起的变化，还要参考目前的滚动条位置，来确定是否对组件进行赋值变更
				var currentStartIndex:int;
				var currentEndIndex:int;
				//那几行
				var currentStartRowIndex:int;
				var currentEndRowIndex:int;
				var perSize:Number;
				
				perSize = measuredItemRendererHeight + vGap;
				currentStartRowIndex = verticalScrollPosition / perSize;
				currentEndRowIndex = (verticalScrollPosition + height) / perSize;
				//ReSet
				var maxIndex:int = length - 1;
				//确定要显示的个数
				var needShowDataLgh:int = 0;
				var needShowData:Vector.<VirtualItemRenderer>;
				if(length > 0)
				{
					currentStartIndex = currentStartRowIndex * _columnCount;
					currentEndIndex = currentEndRowIndex * _columnCount + columnCount - 1;
					
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
					if(i < needShowDataLgh)
					{
						contentGroup.getChildAt(i).x = needShowData[i].x - horizontalScrollPosition;
						contentGroup.getChildAt(i).y = needShowData[i].y - verticalScrollPosition;
					}
					else
					{
						contentGroup.getChildAt(i).x = width;
						contentGroup.getChildAt(i).y = height;
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
				var vGap:Number = (layout as TileLayout).verticalGap;
				var hGap:Number = (layout as TileLayout).horizontalGap;
				var marginX:Number = (layout as TileLayout).marginX;
				var marginY:Number = (layout as TileLayout).marginY;
				
				var stagePt:Point = new Point(event.stageX, event.stageY);
				var contentPt:Point = sissi_internal::contentGroup.globalToLocal(stagePt);
				//高亮位置，相对于容器而言
				var cursorIndex:int;
				//那几行，那几列
				var cursorRowIndex:int;
				var cursorColumnIndex:int;
				//高亮显示的item位置，相对于数据而言
				var cursorItemIndex:int;
				if(_useVirtualMode)
				{
					cursorRowIndex = (contentPt.y + verticalScrollPosition) / (measuredItemRendererHeight + vGap);
					cursorColumnIndex = (contentPt.x + horizontalScrollPosition) / (measuredItemRendererWidth + hGap);
				}
				else
				{
					cursorRowIndex = contentPt.y / (measuredItemRendererHeight + vGap);
					cursorColumnIndex = contentPt.x / (measuredItemRendererWidth + hGap);
				}
				cursorIndex = cursorRowIndex * _columnCount + cursorColumnIndex;
				if(cursorItemIndex < length)
				{
					rollOverSkin.visible = true;
					rollOverSkin.y = cursorRowIndex * (measuredItemRendererHeight + vGap) - verticalScrollPosition;
					rollOverSkin.x = cursorColumnIndex * (measuredItemRendererWidth + hGap) - horizontalScrollPosition;
				}
			}
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