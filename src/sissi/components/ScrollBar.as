package sissi.components
{
	import flash.display.Graphics;
	import flash.events.Event;
	
	import sissi.core.UIComponent;
	import sissi.core.sissi_internal;
	import sissi.interaction.ScrollBarInterAction;
	import sissi.layouts.LayoutDirection;
	import sissi.skins.ScrollBarSkin;
	import sissi.skins.supportClasses.IScrollBarSkin;
	
	use namespace sissi_internal;
	
	public class ScrollBar extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  skin
		//----------------------------------
		private var _skin:IScrollBarSkin;
		public function get skin():IScrollBarSkin
		{
			return _skin;
		}
		public function set skin(value:IScrollBarSkin):void
		{
			if(_skin)
			{
				_skin.dispose();
			}
			_skin = value;
		}
		
		//----------------------------------
		//  orientation
		//----------------------------------
		private var _direction:String;
		public function get direction():String
		{
			return _direction;
		}
		
		//----------------------------------
		//  scrollSize
		//----------------------------------
		private var _scrollSize:Number = 0;
		public function get scrollSize():Number
		{
			return _scrollSize;
		}
		public function set scrollSize(value:Number):void
		{
			if(value < 0)
				value = 0;
			_scrollSize = value;
		}
		
		
		//----------------------------------
		//  maxScrollPosition
		//----------------------------------
		private var _maxScrollPosition:Number = 10;
		public function get maxScrollPosition():Number
		{
			return _maxScrollPosition;
		}
		public function set maxScrollPosition(value:Number):void
		{
			if(_maxScrollPosition != value)
			{
				_maxScrollPosition = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		
		//----------------------------------
		//  minValue
		//----------------------------------
		private var _minScrollPosition:Number = 0;
		public function get minScrollPosition():Number
		{
			return _minScrollPosition;
		}
		public function set minScrollPosition(value:Number):void
		{
			if(_minScrollPosition != value)
			{
				_minScrollPosition = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//----------------------------------
		//  scrollPosition
		//----------------------------------
		private var _scrollPosition:Number = 0;
		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}
		public function set scrollPosition(value:Number):void
		{
			if(_scrollPosition != value)
			{
				_scrollPosition = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		//----------------------------------
		//  thumbSizePercent
		//----------------------------------
		private var _thumbSizePercent:Number;
		public function get thumbSizePercent():Number
		{
			return _thumbSizePercent;
		}

		public function set thumbSizePercent(value:Number):void
		{
			if(_thumbSizePercent != value)
			{
				_thumbSizePercent = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}

		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ScrollBar(layoutDirection:String = LayoutDirection.VERTICAL)
		{
			super();
			
			this._direction = layoutDirection;
			
			interAction = new ScrollBarInterAction(this);
			skin = new ScrollBarSkin(this);
		}
		//--------------------------------------------------------------------------
		//
		//  LifeCycle
		//
		//--------------------------------------------------------------------------
		//------------------------------------------------
		//
		// createChildren
		//
		//------------------------------------------------
		sissi_internal var upArrow:Button;
		sissi_internal var downArrow:Button;
		sissi_internal var thumb:Button;
		override protected function createChildren():void
		{
			if(!upArrow)
			{
				upArrow = new Button();
				//size by button self skin
				upArrow.explicitWidth = NaN;
				upArrow.explicitHeight = NaN;
				upArrow.autoRepeat = true;
				addChild(upArrow);
			}
			if(!downArrow)
			{
				downArrow = new Button();
				//size by button self skin
				downArrow.explicitWidth = NaN;
				downArrow.explicitHeight = NaN;
				downArrow.autoRepeat = true;
				addChild(downArrow);
			}
			if(!thumb)
			{
				thumb = new Button();
				//size by button self skin
				thumb.explicitWidth = NaN;
				thumb.explicitHeight = NaN;
				addChild(thumb);
			}
		}
		
		//------------------------------------------------
		//
		// commitProperties
		//
		//------------------------------------------------
		/**
		 * maxValue, minValue值差
		 * commitProperties()中adjustValue()进行计算
		 */		
		sissi_internal var scrollPositionRange:Number;
		/**
		 * ButtonSkin中Thumb的Style进行pixelRange的赋值。
		 */		
		sissi_internal var pixelRange:Number = 0;
		/**
		 * Thumb按钮大小比例
		 * commitProperties()中adjustValue()进行计算
		 */		
		protected var minThumbSize:int = 10;
		override protected function commitProperties():void
		{
			adjustValue();
			
			_skin.validateSkinChange();
			
			caculatePixelRange();
		}
		
		override protected function measure():void
		{
			if(_direction == LayoutDirection.HORIZONTAL)
			{
				measuredWidth = 178;
				measuredHeight = upArrow.height;
			}
			else if(_direction == LayoutDirection.VERTICAL)
			{
				measuredWidth = upArrow.width;
				measuredHeight = 178;
			}
		}
		//------------------------------------------------
		//
		// updateDisplayList
		//
		//------------------------------------------------
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			skin.updateDisplayList(unscaledWidth, unscaledHeight);
			var thumbSize:int;
			if(_direction == LayoutDirection.VERTICAL)
			{
				thumbSize = (height - upArrow.height - downArrow.height) * _thumbSizePercent;
				thumbSize = thumbSize > minThumbSize ? thumbSize : minThumbSize;
				thumb.height = thumbSize;
				caculatePixelRange();
				
				thumb.x = (unscaledWidth - thumb.width)>>1;
				thumb.y = (_scrollPosition - _minScrollPosition) / (scrollPositionRange) * pixelRange;
				thumb.y += upArrow.height;
				
				upArrow.x = (unscaledWidth - upArrow.width)>>1;
				upArrow.y = 0;
				
				downArrow.x = (unscaledWidth - downArrow.width)>>1;
				downArrow.y = unscaledHeight - downArrow.height;
			}
			else if(_direction == LayoutDirection.HORIZONTAL)
			{
				thumbSize = (width - upArrow.width - downArrow.width) * _thumbSizePercent;
				thumbSize = thumbSize > minThumbSize ? thumbSize : minThumbSize;
				thumb.width = thumbSize;
				caculatePixelRange();
				
				thumb.x = (_scrollPosition - _minScrollPosition) / (scrollPositionRange) * pixelRange;
				thumb.x += upArrow.width;
				thumb.y = (unscaledHeight - thumb.height)>>1;
				
				upArrow.x = 0;
				upArrow.y = (unscaledHeight - upArrow.height)>>1;
				
				downArrow.x = unscaledWidth - downArrow.width;
				downArrow.y = (unscaledHeight - downArrow.height)>>1;
			}
			
			//For mouseClick if trackskin is not fulll with size.
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0, 0);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
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
		/**
		 * 当有新的值传进来的时候，修正边界值大小。
		 */		
		protected function adjustValue():void
		{
			if(_maxScrollPosition < _minScrollPosition)
				_maxScrollPosition = _minScrollPosition;
			_scrollPosition = _scrollPosition < _maxScrollPosition ? _scrollPosition : _maxScrollPosition;
			_scrollPosition = _scrollPosition > _minScrollPosition ? _scrollPosition : _minScrollPosition;
			scrollPositionRange = _maxScrollPosition - _minScrollPosition;
			
			//若外面没有设定，那么用这个公式来计算
			if(isNaN(_thumbSizePercent))
			{
				if(_maxScrollPosition == _minScrollPosition)
				{
					_thumbSizePercent = 1;
				}
				else
				{
					_thumbSizePercent = 1 / (_maxScrollPosition - _minScrollPosition);
					_thumbSizePercent = _thumbSizePercent == 1 ? .5 : _thumbSizePercent
				}
			}
		}
		
		/**
		 * ButtonSkin中Thumb的Style进行pixelRange的赋值。
		 * 如SKIN_THUMB_STYLE_ROUND，那么按钮的中心点在按钮中心，不考虑thumb的width, height。
		 */		
		protected function caculatePixelRange():void
		{
			if(_direction == LayoutDirection.VERTICAL)
				pixelRange = height - thumb.height - upArrow.height - downArrow.height;
			else if(_direction == LayoutDirection.HORIZONTAL)
				pixelRange = width - thumb.width - upArrow.width - downArrow.width;
		}
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
	}
}