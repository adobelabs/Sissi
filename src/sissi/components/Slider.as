package sissi.components
{
	import flash.display.Graphics;
	import flash.events.Event;
	
	import sissi.core.UIComponent;
	import sissi.core.sissi_internal;
	import sissi.interaction.SliderInterActon;
	import sissi.layouts.LayoutDirection;
	import sissi.skins.SliderSkin;
	import sissi.skins.supportClasses.ISliderSkin;
	
	use namespace sissi_internal;
	
	public class Slider extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  skin
		//----------------------------------
		private var _skin:ISliderSkin;
		public function get skin():ISliderSkin
		{
			return _skin;
		}
		public function set skin(value:ISliderSkin):void
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
		//  snapInterval
		//----------------------------------
		private var _snapInterval:Number = 0;
		public function get snapInterval():Number
		{
			return _snapInterval;
		}
		public function set snapInterval(value:Number):void
		{
			if(value < 0)
				value = 0;
			_snapInterval = value;
		}

		
		//----------------------------------
		//  maxValue
		//----------------------------------
		private var _maxValue:Number = 10;
		public function get maxValue():Number
		{
			return _maxValue;
		}
		public function set maxValue(value:Number):void
		{
			if(_maxValue != value)
			{
				_maxValue = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		
		//----------------------------------
		//  minValue
		//----------------------------------
		private var _minValue:Number = 0;
		public function get minValue():Number
		{
			return _minValue;
		}
		public function set minValue(value:Number):void
		{
			if(_minValue != value)
			{
				_minValue = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//----------------------------------
		//  Value
		//----------------------------------
		private var _value:Number = 0;
		public function get value():Number
		{
			return _value;
		}
		public function set value(value:Number):void
		{
			if(_value != value)
			{
				_value = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function Slider(layoutDirection:String = LayoutDirection.VERTICAL)
		{
			super();
			
			this._direction = layoutDirection;
			if(_direction == LayoutDirection.HORIZONTAL)
			{
				setSize(200, 13);
			}
			else if(_direction == LayoutDirection.VERTICAL)
			{
				setSize(13, 200);
			}
			
			interAction = new SliderInterActon(this);
			skin = new SliderSkin(this);
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
		sissi_internal var thumb:Button;
		override protected function createChildren():void
		{
			if(!thumb)
			{
				thumb = new Button();
				//size by button self skin
				thumb.explicitWidth = NaN;
				thumb.explicitHeight = NaN;
				thumb.buttonMode = true;
				thumb.useHandCursor = true;
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
		sissi_internal var valueRange:Number;
		override protected function commitProperties():void
		{
			adjustValue();
			
			_skin.validateSkinChange();
			
			caculatePixelRange();
		}
		
		/**
		 * ButtonSkin中Thumb的Style进行pixelRange的赋值。
		 */		
		sissi_internal var pixelRange:Number = 0;
		/**
		 * ButtonSkin中Thumb的Style进行pixelRange的赋值。
		 * 如SKIN_THUMB_STYLE_ROUND，那么按钮的中心点在按钮中心，不考虑thumb的width, height。
		 */		
		protected function caculatePixelRange():void
		{
			if(_direction == LayoutDirection.VERTICAL)
			{
				if(skin.thumbStyle == SliderSkin.SKIN_THUMB_STYLE_ROUND)
				{
					pixelRange = height;
				}
				else if(skin.thumbStyle == SliderSkin.SKIN_THUMB_STYLE_RECT)
				{
					pixelRange = height - thumb.height;
				}
			}
			else if(_direction == LayoutDirection.HORIZONTAL)
			{
				if(skin.thumbStyle == SliderSkin.SKIN_THUMB_STYLE_ROUND)
				{
					pixelRange = width;
				}
				else if(skin.thumbStyle == SliderSkin.SKIN_THUMB_STYLE_RECT)
				{
					pixelRange = width - thumb.width;
				}
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
			adjustThumberPosition();
			
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
		
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
		/**
		 * 当有新的值传进来的时候，修正边界值大小。
		 */		
		private function adjustValue():void
		{
			if(_maxValue < _minValue)
			{
				_maxValue = _minValue;
			}
			_value = _value < _maxValue ? _value : _maxValue;
			_value = _value > _minValue ? _value : _minValue;
			valueRange = _maxValue - _minValue;
		}
		
		/**
		 * 修正位置。
		 */		
		private function adjustThumberPosition():void
		{
			if(_direction == LayoutDirection.HORIZONTAL)
			{
				thumb.x = (_value - _minValue) / (valueRange) * pixelRange;
				//居中
				thumb.y = (_height - thumb.height)>>1;
				
				if(skin.thumbStyle == SliderSkin.SKIN_THUMB_STYLE_ROUND)
				{
					//中心点
					thumb.x = thumb.x - thumb.width * .5;
				}
			}
			else if(_direction == LayoutDirection.VERTICAL)
			{
				//居中
				thumb.x = (_width - thumb.width)>>1;
				thumb.y = (_value - _minValue) / (valueRange) * pixelRange;
				
				if(skin.thumbStyle == SliderSkin.SKIN_THUMB_STYLE_ROUND)
				{
					//中心点
					thumb.y = thumb.y - thumb.height * .5;
				}
			}
		}
	}
}