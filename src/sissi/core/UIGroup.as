package sissi.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sissi.components.HScrollBar;
	import sissi.components.ScrollBar;
	import sissi.components.VScrollBar;
	import sissi.layouts.supportClasses.LayoutBase;
	
	use namespace sissi_internal;
	
	public class UIGroup extends UIComponent implements IUIGroup
	{
		//-------------------------
		// Layout
		//-------------------------
		private var _layout:LayoutBase;
		public function get layout():LayoutBase
		{
			return _layout;
		}
		public function set layout(value:LayoutBase):void
		{
			if (_layout)
				_layout.target = null;
			_layout = value; 
			if (_layout)
				_layout.target = this;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------------------
		//
		// Scroll About
		//
		//------------------------------------------------
		//-------------------------
		// verticalScrollEnable
		//-------------------------
		private var _verticalScrollEnable:Boolean = false;
		public function get verticalScrollEnable():Boolean
		{
			return _verticalScrollEnable;
		}
		public function set verticalScrollEnable(value:Boolean):void
		{
			if(_verticalScrollEnable != value)
			{
				_verticalScrollEnable = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//-------------------------
		// horizontalScrollEnable
		//-------------------------
		private var _horizontalScrollEnable:Boolean = false;
		public function get horizontalScrollEnable():Boolean
		{
			return _horizontalScrollEnable;
		}
		public function set horizontalScrollEnable(value:Boolean):void
		{
			if(_horizontalScrollEnable != value)
			{
				_horizontalScrollEnable = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//----------------------------------
		//  hScrollSize
		//----------------------------------
		private var _hScrollSize:Number = 0;
		public function get hScrollSize():Number
		{
			return _hScrollSize;
		}
		public function set hScrollSize(value:Number):void
		{
			if(value < 0)
				value = 0;
			_hScrollSize = value;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//-------------------------
		// horizontalScrollPosition
		//-------------------------
		private var _horizontalScrollPosition:Number = 0;
		public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		public function set horizontalScrollPosition(value:Number):void
		{
			if(_horizontalScrollPosition != value)
			{
				_horizontalScrollPosition = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//-------------------------
		// maxHorizontalScrollPosition
		//-------------------------
		private var _maxHorizontalScrollPosition:Number = 0;
		public function get maxHorizontalScrollPosition():Number
		{
			return _maxHorizontalScrollPosition;
		}
		sissi_internal function set maxHorizontalScrollPosition(value:Number):void
		{
			value = value > 0 ? value : 0;
			_maxHorizontalScrollPosition = value;
		}
		
		//----------------------------------
		//  vScrollSize
		//----------------------------------
		private var _vScrollSize:Number = 0;
		public function get vScrollSize():Number
		{
			return _vScrollSize;
		}
		public function set vScrollSize(value:Number):void
		{
			if(value < 0)
				value = 0;
			_vScrollSize = value;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//-------------------------
		// verticalScrollPosition
		//-------------------------
		private var __verticalScrollPosition:Number = 0;

		public function get _verticalScrollPosition():Number
		{
			return __verticalScrollPosition;
		}

		public function set _verticalScrollPosition(value:Number):void
		{
			__verticalScrollPosition = value;
		}

		public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}
		public function set verticalScrollPosition(value:Number):void
		{
			if(_verticalScrollPosition != value)
			{
				_verticalScrollPosition = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//-------------------------
		// maxVerticalScrollPosition
		//-------------------------
		private var _maxVerticalScrollPosition:Number = 0;
		public function get maxVerticalScrollPosition():Number
		{
			return _maxVerticalScrollPosition;
		}
		sissi_internal function set maxVerticalScrollPosition(value:Number):void
		{
			value = value > 0 ? value : 0;
			_maxVerticalScrollPosition = value;
		}
		
		//-------------------------
		// contentGroup
		//-------------------------
		private var _contentGroup:UIComponent = new UIComponent();
		/**
		 * Child添加进来的真正内容。
		 */
		sissi_internal function get contentGroup():UIComponent
		{
			return _contentGroup;
		}
		
		
		//-------------------------
		// background
		//-------------------------
		private var _background:Boolean;
		public function get background():Boolean
		{
			return _background;
		}
		public function set background(value:Boolean):void
		{
			if(_background != value)
			{
				_background = value;
				
				invalidateDisplayList();
			}
		}
		
		//-------------------------
		// backgroundDisplayObject
		//-------------------------
		private var _backgroundDisplayObject:DisplayObject;
		public function get backgroundDisplayObject():DisplayObject
		{
			return _backgroundDisplayObject;
		}
		public function set backgroundDisplayObject(value:DisplayObject):void
		{
			if(_backgroundDisplayObject && sissi_internal::contains(_backgroundDisplayObject))
			{
				sissi_internal::removeChild(_backgroundDisplayObject);
			}
			_backgroundDisplayObject = value;
			
			if(_backgroundDisplayObject)
			{
				if(_backgroundDisplayObject is InteractiveObject)
					(_backgroundDisplayObject as InteractiveObject).mouseEnabled = false;
				if(_backgroundDisplayObject is DisplayObjectContainer)
					(_backgroundDisplayObject as DisplayObjectContainer).mouseChildren = false;
				
				sissi_internal::addChildAt(_backgroundDisplayObject, 0);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function UIGroup()
		{
			super();
			_contentGroup.name = "SissiContenGroup";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: LifeCycle
		//
		//--------------------------------------------------------------------------
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			
			calculateMaxScrollPosition();
			createScrollbarsIfNeeded();
			if(scrollPositionOrDataProviderChanged)
				adjustContentScrollPosition();
		}
		
		
		/**
		 * 计算出是否要有滚动条 
		 */		
		protected function calculateMaxScrollPosition():void
		{
			var newScrollableWidth:Number = measuredWidth;
			var newScrollableHeight:Number = measuredHeight;
			var newViewableWidth:Number = width;
			var newViewableHeight:Number = height;
			
			scrollableWidth = newScrollableWidth;
			scrollableHeight = newScrollableHeight;
			viewableWidth = newViewableWidth;
			viewableHeight = newViewableHeight;
		}
		
		sissi_internal var hScrollBar:HScrollBar;
		sissi_internal var vScrollBar:VScrollBar;
		/**
		 *  @private
		 *  Cached values describing the total size of the content being scrolled
		 *  and the size of the area in which the scrolled content is displayed.
		 */
		protected var scrollableWidth:Number = 0;
		protected var scrollableHeight:Number = 0;
		protected var viewableWidth:Number = 0;
		protected var viewableHeight:Number = 0;
		protected var oldHorizontalScrollPosition:Number = 0;
		protected var oldVerticalScrollPosition:Number = 0
		protected var scrollPositionOrDataProviderChanged:Boolean = true;
		
		public var alwaysShowVScrollBar:Boolean;
		/**
		 * 是否要有滚动条
		 */		
		protected function createScrollbarsIfNeeded():void
		{
			if(vScrollBar)
				scrollableWidth += vScrollBar.width;
			
			if(hScrollBar)
				scrollableHeight += hScrollBar.height;
			
			//H
			if(_horizontalScrollEnable && (scrollableWidth - viewableWidth) > 0)
			{
				if(!hScrollBar)
				{
					hScrollBar = new HScrollBar();
					hScrollBar.addEventListener(Event.CHANGE, handleHScrollChanged);
					super.addChild(hScrollBar);
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
			else
			{
				if(hScrollBar)
				{
					if(super.contains(hScrollBar))
						super.removeChild(hScrollBar);
					hScrollBar.removeEventListener(Event.CHANGE, handleHScrollChanged);
					hScrollBar = null;
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
			
			//V
			if(alwaysShowVScrollBar || (_verticalScrollEnable && (scrollableHeight - viewableHeight) > 0) )
			{
				if(!vScrollBar)
				{
					vScrollBar = new VScrollBar();
					vScrollBar.addEventListener(Event.CHANGE, handleVScrollChanged);
					super.addChild(vScrollBar);
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
			else
			{
				if(vScrollBar)
				{
					if(super.contains(vScrollBar))
						super.removeChild(vScrollBar);
					vScrollBar.removeEventListener(Event.CHANGE, handleVScrollChanged);
					vScrollBar = null;
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
			
			sissi_internal::maxHorizontalScrollPosition = scrollableWidth - viewableWidth;
			if(hScrollBar)
			{
				hScrollBar.y = height - hScrollBar.height;
				
				hScrollBar.maxScrollPosition = _maxHorizontalScrollPosition;
				hScrollBar.thumbSizePercent = width / (width + _maxHorizontalScrollPosition);
				hScrollBar.scrollSize = _hScrollSize;
				
				if(vScrollBar)
					hScrollBar.width = width - hScrollBar.height;
				else
					hScrollBar.width = width;
				hScrollBar.validateNow();
			}
			
			sissi_internal::maxVerticalScrollPosition = scrollableHeight - viewableHeight;
			if(vScrollBar)
			{
				vScrollBar.x = width - vScrollBar.width;
				vScrollBar.maxScrollPosition = _maxVerticalScrollPosition;
				vScrollBar.thumbSizePercent = height / (height + _maxVerticalScrollPosition);
				vScrollBar.scrollSize = _vScrollSize;
				
				if(hScrollBar)
					vScrollBar.height = height - vScrollBar.width;
				else
					vScrollBar.height = height;
				
				vScrollBar.validateNow();
			}
		}
		
		/**
		 * 滚动内容
		 */		
		protected function adjustContentScrollPosition():void
		{
			contentGroup.x = -_horizontalScrollPosition;
			contentGroup.y = -_verticalScrollPosition;
			oldHorizontalScrollPosition = _horizontalScrollPosition;
			oldVerticalScrollPosition = _verticalScrollPosition;
			if(vScrollBar)
				vScrollBar.scrollPosition = _verticalScrollPosition;
			if(hScrollBar)
				hScrollBar.scrollPosition = _horizontalScrollPosition;
			scrollPositionOrDataProviderChanged = false;
		}
		
		private function handleHScrollChanged(event:Event):void
		{
			horizontalScrollPosition = (event.currentTarget as ScrollBar).scrollPosition;
		}
		
		private function handleVScrollChanged(event:Event):void
		{
			verticalScrollPosition = (event.currentTarget as ScrollBar).scrollPosition;
		}
		
		
		/**
		 * 遮罩。也是容器的大小。
		 */	
		protected var containerMask:Shape;
		override protected function createChildren():void
		{
			if(!containerMask)
			{
				containerMask = new Shape();
				super.addChild(containerMask);
			}
			if(!super.contains(_contentGroup))
			{
				super.addChild(_contentGroup);
			}
			this.mask = containerMask;
		}
		override protected function commitProperties():void
		{
			adjustScrollPosition();
		}
		/**
		 * 当有新的值传进来的时候，修正边界值大小。
		 */		
		protected function adjustScrollPosition():void
		{
			_horizontalScrollPosition = _horizontalScrollPosition < _maxHorizontalScrollPosition ? _horizontalScrollPosition : _maxHorizontalScrollPosition;
			_horizontalScrollPosition = _horizontalScrollPosition < 0 ? 0 : _horizontalScrollPosition;
			_verticalScrollPosition = _verticalScrollPosition < _maxVerticalScrollPosition ? _verticalScrollPosition : _maxVerticalScrollPosition;
			_verticalScrollPosition = _verticalScrollPosition < 0 ? 0 : _verticalScrollPosition;
			
			if(_horizontalScrollPosition != oldHorizontalScrollPosition || _verticalScrollPosition != oldVerticalScrollPosition)
				scrollPositionOrDataProviderChanged = true;
		}
		
		override protected function measure():void
		{
			if(_layout)
				_layout.measure();
			else
				super.measure();
		}
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			var g:Graphics;
			if(containerMask)
			{
				g = containerMask.graphics;
				g.clear();
				g.beginFill(0, 0);
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
			}
			if(_background)
			{
				g = this.graphics;
				g.clear();
				//g.beginFill(0xFFFFFF * Math.random());
				g.beginFill(0, 0);
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
			}
			else
			{
				g = this.graphics;
				g.clear();
			}
			if(_layout)
				_layout.layoutContents(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public functions
		//
		//--------------------------------------------------------------------------
		sissi_internal function contains(child:DisplayObject):Boolean
		{
			return super.contains(child);
		}
		override public function contains(child:DisplayObject):Boolean
		{
			return contentGroup.contains(child);
		}
		
		sissi_internal function addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		override public function addChild(child:DisplayObject):DisplayObject
		{
			contentGroup.addChild(child);
			invalidateSize();
			invalidateDisplayList();
			return child;
		}
		
		sissi_internal function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			contentGroup.addChildAt(child, index);
			invalidateSize();
			invalidateDisplayList();
			return child;
		}
		
		sissi_internal function removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			contentGroup.removeChild(child);
			invalidateSize();
			invalidateDisplayList();
			return child;
		}
		
		sissi_internal function removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = contentGroup.removeChildAt(index);
			invalidateSize();
			invalidateDisplayList();
			return child;
		}
		
		sissi_internal function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			return super.removeChildren(beginIndex, endIndex);
		}
		override public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			contentGroup.removeChildren(beginIndex, endIndex);
			invalidateSize();
			invalidateDisplayList();
		}
		
		sissi_internal function setChildIndex(child:DisplayObject, index:int):void
		{
			return super.setChildIndex(child, index);
		}
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			contentGroup.setChildIndex(child, index);
		}
		
		sissi_internal function getChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index);
		}
		override public function getChildAt(index:int):DisplayObject
		{
			return contentGroup.getChildAt(index);
		}
		
		sissi_internal function getChildByName(name:String):DisplayObject
		{
			return super.getChildByName(name);
		}
		override public function getChildByName(name:String):DisplayObject
		{
			return contentGroup.getChildByName(name);
		}
		
		sissi_internal function getChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child);
		}
		override public function getChildIndex(child:DisplayObject):int
		{
			return contentGroup.getChildIndex(child);
		}
		
		sissi_internal function get numChildren():int
		{
			return super.numChildren;
		}
		override public function get numChildren():int
		{
			return contentGroup.numChildren;
		}
		//------------------------------------------------
		//
		// override add, remove, set display children function
		//
		//------------------------------------------------
//		sissi_internal function contains(child:DisplayObject):Boolean
//		{
//			return super.contains(child);
//		}
//		override public function contains(child:DisplayObject):Boolean
//		{
//			throw new Error("Please override this function.");
//			return false;
//		}
//		
//		sissi_internal function addChild(child:DisplayObject):DisplayObject
//		{
//			return super.addChild(child);
//		}
//		override public function addChild(child:DisplayObject):DisplayObject
//		{
//			throw new Error("Please override this function.");
//			return null;
//		}
//		
//		sissi_internal function addChildAt(child:DisplayObject, index:int):DisplayObject
//		{
//			return super.addChildAt(child, index);
//		}
//		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
//		{
//			throw new Error("Please override this function.");
//			return null;
//		}
//		
//		sissi_internal function removeChild(child:DisplayObject):DisplayObject
//		{
//			return super.removeChild(child);
//		}
//		override public function removeChild(child:DisplayObject):DisplayObject
//		{
//			throw new Error("Please override this function.");
//			return null;
//		}
//		
//		sissi_internal function removeChildAt(index:int):DisplayObject
//		{
//			return super.removeChildAt(index);
//		}
//		override public function removeChildAt(index:int):DisplayObject
//		{
//			throw new Error("Please override this function.");
//			return null;
//		}
//		
//		sissi_internal function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
//		{
//			return super.removeChildren(beginIndex, endIndex);
//		}
//		override public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
//		{
//			throw new Error("Please override this function.");
//		}
//		
//		sissi_internal function setChildIndex(child:DisplayObject, index:int):void
//		{
//			return super.setChildIndex(child, index);
//		}
//		override public function setChildIndex(child:DisplayObject, index:int):void
//		{
//			throw new Error("Please override this function.");
//		}
//		
//		sissi_internal function getChildAt(index:int):DisplayObject
//		{
//			return super.getChildAt(index);
//		}
//		override public function getChildAt(index:int):DisplayObject
//		{
//			throw new Error("Please override this function.");
//			return null;
//		}
//		
//		sissi_internal function getChildByName(name:String):DisplayObject
//		{
//			return super.getChildByName(name);
//		}
//		override public function getChildByName(name:String):DisplayObject
//		{
//			throw new Error("Please override this function.");
//			return null;
//		}
//		
//		sissi_internal function getChildIndex(child:DisplayObject):int
//		{
//			return super.getChildIndex(child);
//		}
//		override public function getChildIndex(child:DisplayObject):int
//		{
//			throw new Error("Please override this function.");
//			return -1;
//		}
//		
//		override public function get numChildren():int
//		{
//			return _contentGroup.numChildren;
//		}
		//--------------------------------------------------------------------------
		//
		//  Protected functions
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
	}
}