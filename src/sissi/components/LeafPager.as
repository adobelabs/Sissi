package sissi.components
{
	import flash.events.MouseEvent;
	
	import sissi.components.pagerClasses.IPagerItemRenderer;
	import sissi.components.pagerClasses.PagerItem;
	import sissi.events.PagerEvent;

	/**
	 * 整个分页 由 richmediaplus.controls.Pager 和 richmediaplus.controls.pagerClasses.PagerItem 组成。
	 * 配合由 『总页数』count 和 当前第N页currentPageIndex的数据 组合成的数据，进行相应的制作。
	 * Pager 掌握着整个分页的规则和设计。
	 * PagerItem 则为『页』元素，但不包括前一页，后一页，最前页，最后页。
	 * Pager.count 来进行 『页』元素PagerItem 数量的控制，不会触发 PagerEvent.PAGE_INDEX_CHANGED 事件。
	 * Pager.currentPageIndex 进行 『页』元素PagerItem 选择的控制，触发 PagerEvent.PAGE_INDEX_CHANGED 事件。
	 * Pager.showMaxCount 来进行 『页』元素PagerItem 最多显示数量的控制。
	 * Pager.direction 来进行 『页』元素PagerItem 排列的控制（横/竖）。
	 * @blog http://blog.richmediaplus.com
	 * @author Alvin / Aedis.Ju
	 */
	public class LeafPager extends HGroup
	{
		public function LeafPager()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		/**
		 * 是否需要更新视图。
		 */		
		private var needUpdate:Boolean;
		//----------------------------------
		//  count
		//----------------------------------
		private var _count:int = 0;
		private var maxCountIndex:int = 0;
		public function set count(value:int):void
		{
			if (_count != value)
			{
				//如果当前显示的已经越界，那么需要重新更新视图。
				if(pageStartIndex + realShowCount > value || _showMaxCount > _count)
				{
					needUpdate = true
				}
				
				_count = value > 0 ? value : 0;
				maxCountIndex = (_count - 1) > 0 ? (_count - 1) : 0;
				if(needUpdate)
				{
					invalidateDisplayList();
				}
			}
		}
		public function get count():int
		{
			return _count;
		}
		
		//----------------------------------
		//  showMaxCount
		//----------------------------------
		private var _showMaxCount:int = 5;
		public function set showMaxCount(value:int):void
		{
			if (_showMaxCount != value)
			{
				needUpdate = true;
				//当前已经满足了count的需求，并且，最新赋值也超越了count的需求，那么则是不需要改变的
				if((_showMaxCount >= _count && value >=_showMaxCount) || value <= 0)
				{
					needUpdate = false;
				}
				
				_showMaxCount =  value > 0 ? value : 0;
				if(needUpdate)
				{
					invalidateDisplayList();
				}
			}
		}
		public function get showMaxCount():int
		{
			return _showMaxCount;
		}
		
		//----------------------------------
		//  currentPageIndex
		//----------------------------------
		private var _currentPageIndex:int = 0;
		public function set currentPageIndex(value:int):void
		{
			if (_currentPageIndex != value)
			{
				_currentPageIndex = value > 0 ? value : 0;
				
				//首先符合边界
				if(_currentPageIndex >= 0 && _currentPageIndex <= maxCountIndex)
				{
					//如果符合现有的可用控件，那么在现有的直接修改，如果不符合，那么重造
					if(_currentPageIndex >= pageStartIndex && _currentPageIndex <= pageStartIndex + realShowCount - 1)
					{
						pageIndexChange();
					}
					else
					{
						invalidateDisplayList();
					}
				}
			}
		}
		public function get currentPageIndex():int
		{
			return _currentPageIndex;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		protected var firstBtn:Button;
		protected var prevBtn:Button;
		protected var nextBtn:Button;
		protected var lastBtn:Button;
		protected var pagerContent:HGroup;
		
		//Real Pager's Count Showed.
		private var realShowCount:int;
		//Page Start Index
		private var pageStartIndex:int;
		
		//--------------------------------------------------------------------------
		//
		//  Override function
		//
		//--------------------------------------------------------------------------
		/**
		 * CreateChildren
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if (!firstBtn)
			{
				firstBtn = new Button();
				firstBtn.label = "<<";
			}
			firstBtn.addEventListener(MouseEvent.CLICK, handleFirst);
			addChild(firstBtn);
			if (!prevBtn)
			{
				prevBtn = new Button();
				prevBtn.label = "<";
			}
			prevBtn.addEventListener(MouseEvent.CLICK, handlePrev);
			addChild(prevBtn);
			if (!pagerContent)
			{
				pagerContent = new HGroup();
			}
			addChild(pagerContent);
			if (!nextBtn)
			{
				nextBtn = new Button();
				nextBtn.label = ">";
			}
			nextBtn.addEventListener(MouseEvent.CLICK, handleNext);
			addChild(nextBtn);
			if (!lastBtn)
			{
				lastBtn = new Button();
				lastBtn.label = ">>";
			}
			lastBtn.addEventListener(MouseEvent.CLICK, handleLast);
			addChild(lastBtn);
		}
		
		
		/**
		 * UpdateDisplayList
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */        
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(needUpdate && calculateProperties())
			{
				reCreatePager();
				needUpdate = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private function
		//
		//--------------------------------------------------------------------------
		protected function calculateProperties():Boolean
		{
			if(_count > 0 && _showMaxCount > 0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * ReCreate Pager by Real Pager's Count.
		 */        
		protected function reCreatePager():void
		{
//			trace("reCreatePager")
			//Remove all Pagers.
			while(pagerContent.numChildren > 0)
			{
				pagerContent.removeChildAt(0).removeEventListener(MouseEvent.CLICK, handlePagerSelected);
			}
			//Calculate real showCount.
			realShowCount = _count > _showMaxCount ? _showMaxCount : _count;
			//Calculate start showIndex.
			if(_currentPageIndex > maxCountIndex)
			{
				_currentPageIndex = maxCountIndex;
			}
			//if showCount is 3, count is 10
			//So data: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
			//currentPageIndex - showIndex - showPage
			//6 - 6 7 8 - 7 8 9
			//7 - 7 8 9 - 8 9 10
			//8 - 7 8 9 - 8 9 10
			//9 - 7 8 9 - 8 9 10
			var diffIndex:int = _currentPageIndex + realShowCount - _count;
			if(diffIndex > 0)
			{
				pageStartIndex = _currentPageIndex - diffIndex;
			}
			else
			{
				pageStartIndex = _currentPageIndex;
			}
			for (var i:int = pageStartIndex; i < pageStartIndex + realShowCount; i++)
			{
				pagerContent.addChild(createSinglePager(i));
			}
//			pagerContent.validateNow();
			setSelected(_currentPageIndex);
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * Create single Pager.
		 * @param index Pager's NO.
		 * @return Pager
		 */        
		protected function createSinglePager(index:int):PagerItem
		{
			var p:PagerItem = new PagerItem();
			p.pageIndex = index;
			p.addEventListener(MouseEvent.CLICK, handlePagerSelected);
			return p;
		}
		
		/**
		 * Handle Pager's CLICK event.
		 * @param MouseEvent.CLICK
		 */
		protected function handlePagerSelected(event:MouseEvent):void
		{
			var eventPageIndex:int = (event.currentTarget as IPagerItemRenderer).pageIndex;
			if(_currentPageIndex != eventPageIndex)
			{
				_currentPageIndex = eventPageIndex;
				
				pageIndexChange();
			}
		}
		
		/**
		 * Set pageIndex selected, dispatch PagerEvent.PAGE_INDEX_CHANGED.
		 * Set currentPage selected.
		 */        
		protected function pageIndexChange():void
		{
			setSelected(_currentPageIndex);
			
//			trace("currentPage", _currentPageIndex + 1, "_currentPageIndex", _currentPageIndex, " dispatchEvent PagerEvent.PAGE_INDEX_CHANGED")
			var pageIndexChangeEvent:PagerEvent = new PagerEvent(PagerEvent.PAGE_INDEX_CHANGED);
			pageIndexChangeEvent.pageIndex = _currentPageIndex;
			dispatchEvent(pageIndexChangeEvent);
		}
		
		/**
		 * Set Pager Selected.
		 * DO NOT SET currentPageIndex.
		 * DO NOT Dispatch PagerEvent.PAGE_INDEX_CHANGED Event.
		 * @param selectedIndex
		 */        
		protected function setSelected(selectedIndex:int):void
		{
			var pagerContentLen:int = pagerContent.numChildren;
			for (var i:int = 0; i < pagerContentLen; i++)
			{
				var p:IPagerItemRenderer = pagerContent.getChildAt(i) as IPagerItemRenderer;
				if (p.pageIndex == _currentPageIndex)
				{
					p.setSelected(true);
				}
				else
				{
					p.setSelected(false);
				}
			}
		}
		
		/**
		 * Prev Event
		 * @param MouseEvent.CLICK
		 */
		protected function handlePrev(event:MouseEvent):int
		{
			if (_currentPageIndex > 0)
			{
				_currentPageIndex--;
				//如果能符合现有的规则，那么无需重造。
				if ((pagerContent.getChildAt(0) as IPagerItemRenderer).pageIndex <= _currentPageIndex && _currentPageIndex <= (pagerContent.getChildAt(pagerContent.numChildren - 1) as IPagerItemRenderer).pageIndex)
				{
				}
				else
				{
					reCreatePager();
				}
				pageIndexChange();
			}
			return _currentPageIndex;
		}
		
		/**
		 * Next Event
		 * @param MouseEvent.CLICK
		 */
		protected function handleNext(event:MouseEvent):int
		{
			if (_count >= 0 && _currentPageIndex < maxCountIndex )
			{
				_currentPageIndex++;
				//如果能符合现有的规则，那么无需重造。
				if ((pagerContent.getChildAt(0) as IPagerItemRenderer).pageIndex <= _currentPageIndex && _currentPageIndex <= (pagerContent.getChildAt(pagerContent.numChildren - 1) as IPagerItemRenderer).pageIndex)
				{
				}
				else
				{
					reCreatePager();
				}
				pageIndexChange();
			}
			return _currentPageIndex;
		}
		
		/**
		 * First Event
		 * @param MouseEvent.CLICK
		 */
		protected function handleFirst(event:MouseEvent):int
		{
			if(_currentPageIndex != 0)
			{
				_currentPageIndex = 0;
				if ((pagerContent.getChildAt(0) as IPagerItemRenderer).pageIndex != 0)
				{
					reCreatePager();
				}
				pageIndexChange();
			}
			return _currentPageIndex;
		}
		
		/**
		 * Last Event
		 * @param MouseEvent.CLICK
		 */
		protected function handleLast(event:MouseEvent):int
		{
			if(_currentPageIndex != maxCountIndex)
			{
				_currentPageIndex = maxCountIndex;
				if ((pagerContent.getChildAt(pagerContent.numChildren - 1) as IPagerItemRenderer).pageIndex != maxCountIndex)
				{
					reCreatePager();
				}
				pageIndexChange();
			}
			return _currentPageIndex;
		}
	}
}