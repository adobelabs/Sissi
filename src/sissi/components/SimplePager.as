package sissi.components
{
	import flash.events.MouseEvent;
	
	import sissi.components.pagerClasses.IPagerItemRenderer;
	import sissi.components.pagerClasses.PagerItem;
	import sissi.events.PagerEvent;
	
	/**
	 * 整个分页 由 richmediaplus.controls.Pager
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
	public class SimplePager extends HGroup
	{
		public function SimplePager()
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
		private var _count:int = -1;
		private var maxCountIndex:int = 0;
		public function set count(value:int):void
		{
			if (_count != value)
			{
				needUpdate = true;
				
				_count = value > 1 ? value : 1;
				maxCountIndex = (_count - 1) > 0 ? (_count - 1) : 0;
				
				invalidateDisplayList();
			}
		}
		/**
		 * count定义的是总共有多少页
		 * 在没有数据的情况下，应该最低保持为1页， 所以最小拿到的值应该是1。
		 * @return 
		 */		
		public function get count():int
		{
			return _count;
		}
		
		//----------------------------------
		//  currentPageIndex
		//----------------------------------
		private var _currentPageIndex:int = 0;
		public function set currentPageIndex(value:int):void
		{
			if (_currentPageIndex != value)
			{
				needUpdate = true;
				
				_currentPageIndex = value > 0 ? value : 0;
				
				invalidateDisplayList();
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
		protected var pagerContentLabel:Label;
		
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
			addChild(firstBtn);
			firstBtn.addEventListener(MouseEvent.CLICK, handleFirst);
			if (!prevBtn)
			{
				prevBtn = new Button();
				prevBtn.label = "<";
			}
			addChild(prevBtn);
			prevBtn.addEventListener(MouseEvent.CLICK, handlePrev);
			if (!pagerContentLabel)
			{
				pagerContentLabel = new Label();
			}
			addChild(pagerContentLabel);
			if (!nextBtn)
			{
				nextBtn = new Button();
				nextBtn.label = ">";
			}
			addChild(nextBtn);
			nextBtn.addEventListener(MouseEvent.CLICK, handleNext);
			if (!lastBtn)
			{
				lastBtn = new Button();
				lastBtn.label = ">>";
			}
			addChild(lastBtn);
			lastBtn.addEventListener(MouseEvent.CLICK, handleLast);
		}
		
		/**
		 * UpdateDisplayList
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */        
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(needUpdate)
			{
				updatePagerContentLabel();
				needUpdate = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private function
		//
		//--------------------------------------------------------------------------
		/**
		 * ReCreate Pager by Real Pager's Count.
		 */        
		protected function updatePagerContentLabel():void
		{
			pagerContentLabel.text = _currentPageIndex + 1 + " / " + _count;
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * Set pageIndex selected, dispatch PagerEvent.PAGE_INDEX_CHANGED.
		 * Set currentPage selected.
		 */        
		protected function pageIndexChange():void
		{
//			trace("currentPage", _currentPageIndex + 1, "_currentPageIndex", _currentPageIndex, " dispatchEvent PagerEvent.PAGE_INDEX_CHANGED")
			var pageIndexChangeEvent:PagerEvent = new PagerEvent(PagerEvent.PAGE_INDEX_CHANGED);
			pageIndexChangeEvent.pageIndex = _currentPageIndex;
			dispatchEvent(pageIndexChangeEvent);
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
				updatePagerContentLabel();
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
			if (_currentPageIndex < maxCountIndex )
			{
				_currentPageIndex++;
				updatePagerContentLabel();
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
				updatePagerContentLabel();
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
				updatePagerContentLabel();
				pageIndexChange();
			}
			return _currentPageIndex;
		}
	}
}