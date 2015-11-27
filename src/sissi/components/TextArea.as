package sissi.components
{
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sissi.core.UIComponent;
	import sissi.core.UITextField;
	import sissi.core.sissi_internal;
	import sissi.layouts.LayoutDirection;
	
	use namespace sissi_internal;
	
	public class TextArea extends UIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		override public function initialize():void
		{
			super.initialize();
			
			if(initialized)
				return;
			if(nestLevel > 0)
				validateNow();
		}
		
//		override public function initialize():void
//		{
//			super.initialize();
//			//初始化完成 或者 初始化正在进行中
//			if(initialized || processedDescriptors)
//				return;
//			
//			validateNow();
//		}
		//----------------------------------
		// text
		//----------------------------------
		private var _text:String;
		private var textChanged:Boolean = false;
		private var isHTML:Boolean;
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			if (_text != value)
			{
				_text = value;
				
				textChanged = true;
				isHTML = false;
				_htmlText = null;
				
				validateNow();
			}
		}

		//----------------------------------
		// htmlText
		//----------------------------------
		private var _htmlText:String;
		public function get htmlText():String
		{
			return _htmlText;
		}
		public function set htmlText(value:String):void
		{
			if (_htmlText != value)
			{
				_htmlText = value;
				
				textChanged = true;
				isHTML = true;
				_text = null;
				
				validateNow();
			}
		}
		
		//----------------------------------
		// defaultTextFormat
		//----------------------------------
		private var textStyleChanged:Boolean;
		private var explicitTextFormat:TextFormat;

		public function set defaultTextFormat(value:TextFormat):void
		{
			if(!value)
				return;
			
			explicitTextFormat = value;
			textStyleChanged = true;
			
			validateNow();
		}

		//----------------------------------
		// color
		//----------------------------------
		private var explicitColor:uint;
		private var explicitColorChanged:Boolean;
		public function set color(value:uint):void
		{
			explicitColor = value;
			
			textStyleChanged = true;
			explicitColorChanged = true;
			
			validateNow();
		}

		
		//----------------------------------
		// textAlign
		//----------------------------------
		private var explicitTextAlign:String;
		public function set textAlign(value:String):void
		{
			explicitTextAlign = value;
			
			textStyleChanged = true;
			
			validateNow();
		}
		
		//----------------------------------
		// leading
		//----------------------------------
		private var explicitLeading:int = 3;
		/**
		 * 指定行与行之间的前导量（垂直间距）；对应于 TextFormat.leading。正数和负数均可以接受。
		 * @return 
		 */		
		public function set leading(value:int):void
		{
			explicitLeading = value;
			
			textStyleChanged = true;
			
			validateNow();
		}
		
		//----------------------------------
		//  autoScrollToMax
		//----------------------------------
		private var _autoScrollToMax:Boolean;
		/**
		 * 是否赋值时自动滚动到最下面。只有selectable为false的情况下起作用。
		 * @return 
		 */		
		public function get autoScrollToMax():Boolean
		{
			return _autoScrollToMax;
		}
		public function set autoScrollToMax(value:Boolean):void
		{
			_autoScrollToMax = value;
		}
		
		//----------------------------------
		// stroke
		//----------------------------------
		private var _stroke:Array;
		public function get stroke():Array
		{
			return _stroke;
		}
		public function set stroke(value:Array):void
		{
			_stroke = value;
			
			validateNow();
		}
		
		//----------------------------------
		// thickness
		//----------------------------------
		private var _thickness:Number = 0;
		public function get thickness():Number
		{
			return _thickness;
		}
		
		public function set thickness(value:Number):void
		{
			_thickness = value;
			
			validateNow();
		}
		
		//----------------------------------
		//  maxChars
		//----------------------------------
		private var _maxChars:int = 0;
		public function get maxChars():int
		{
			return _maxChars;
		}
		public function set maxChars(value:int):void
		{
			if(_maxChars != value)
			{
				_maxChars = value;
				
				validateNow();
			}
		}
		
		//----------------------------------
		//  restrict
		//----------------------------------
		private var _restrict:String = null;
		public function get restrict():String
		{
			return _restrict;
		}
		
		public function set restrict(value:String):void
		{
			if(_restrict != value)
			{
				_restrict = value;
				
				validateNow();
			}
		}
		
		//----------------------------------
		//  selectable
		//----------------------------------
		private var _selectable:Boolean = true;
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			
			validateNow();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function TextArea(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super();
			defaultTextFormat = textFormat;
			stroke = textStroke;
			if(isHTML)
				htmlText = textValue;
			else
				text = textValue;
			
			setSize(200, 50);
		}
		//--------------------------------------------------------------------------
		//
		//  LifeCycle
		//
		//--------------------------------------------------------------------------
		/**
		 * 若不是sissi，那么在添加到舞台后，才使用validateNow，获取到正确的width&height。
		 */		
		override public function validateNow():void
		{
			//当有父对象才可以，在被添加到舞台上的时候会自动
			if(!parent)
				return;
			
			if(!uiTF)
				return;
			
			if(textChanged)
			{
				if(isHTML)
					uiTF.htmlText = _htmlText;
				else
					uiTF.text = _text;
				
				textChanged = false;
			}
			
			uiTF.stroke = _stroke;
			uiTF.thickness = _thickness;
			uiTF.maxChars = maxChars;
			uiTF.restrict = _restrict;
			uiTF.selectable = _selectable;
			
			//改变TextFormat要重新赋值
			if (textStyleChanged)
			{
				uiTF.defaultTextFormat = explicitTextFormat;
				if(explicitColorChanged)
					uiTF.color = explicitColor;
				if(explicitTextAlign)
					uiTF.textAlign = explicitTextAlign;
				uiTF.leading = explicitLeading;
				
				textStyleChanged = false;
			}
			
			setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			
			createScrollBarIfNeeded();
			
			initialized = true;
		}
		//------------------------------------------------
		//
		// createChildren
		//
		//------------------------------------------------
		protected var uiTF:UITextField;
		sissi_internal var vScrollBar:ScrollBar;
		override protected function createChildren():void
		{
			if(!uiTF)
			{
				uiTF = new UITextField();
				uiTF.type = TextFieldType.INPUT;
				uiTF.selectable = true;
				uiTF.tabEnabled = true;
				uiTF.multiline = true;
				uiTF.wordWrap = true;
				uiTF.width = width;
				uiTF.height = height;
				uiTF.addEventListener(Event.CHANGE, textField_changeHandler);
				uiTF.addEventListener(Event.SCROLL, handleTFieldScroll);
				addChild(uiTF);
			}
		}
		//------------------------------------------------
		//
		// commitProperties
		//
		//------------------------------------------------
//		override protected function commitProperties():void
//		{
//			
//		}
		//------------------------------------------------
		//
		// updateDisplayList
		//
		//------------------------------------------------
//		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
//		{
//			
//		}
		//--------------------------------------------------------------------------
		//
		//  Public functions
		//
		//--------------------------------------------------------------------------
		public function setFous():void
		{
			if(stage)
			{
				stage.focus = this;
			}
		}
		
		/**
		 * 改变样式
		 * @param textFormat
		 * @param textStroke
		 */		
		public function changeLabelStyle(textFormat:TextFormat, textStroke:Array):void
		{
			this.defaultTextFormat = textFormat;
			this.stroke = textStroke;
		}
		//--------------------------------------------------------------------------
		//
		//  Protected functions
		//
		//--------------------------------------------------------------------------
		/**
		 * 要不要出现滚动条
		 */		
		protected function createScrollBarIfNeeded():void
		{
			if(uiTF)
			{
				//是否应该显示滚动条
				if(uiTF.maxScrollV > 1)
				{
					if(!vScrollBar)
					{
						vScrollBar = new ScrollBar(LayoutDirection.VERTICAL);
						vScrollBar.addEventListener(Event.CHANGE, handleScrollBarChange);
						addChild(vScrollBar);
						
						vScrollBar.height = height;
						vScrollBar.x = width - vScrollBar.width;
					}
					//Change的赋值
					var visibleLines:int = uiTF.numLines - uiTF.maxScrollV + 1;
					var percent:Number = visibleLines / uiTF.numLines;
					vScrollBar.minScrollPosition = 1;
					vScrollBar.maxScrollPosition = uiTF.maxScrollV;
					vScrollBar.thumbSizePercent = percent;
					if(_autoScrollToMax && !_selectable)
					{
						vScrollBar.scrollPosition = uiTF.maxScrollV;
						uiTF.scrollV = uiTF.maxScrollV;
					}
					else
					{
						vScrollBar.scrollPosition = uiTF.scrollV;
					}
				}
				else
				{
					if(vScrollBar)
					{
						if(contains(vScrollBar))
							removeChild(vScrollBar);
						
						vScrollBar.removeEventListener(Event.CHANGE, handleScrollBarChange);
						vScrollBar = null;
					}
				}
				if(vScrollBar)
					uiTF.width = width - vScrollBar.width;
				else
					uiTF.width = width;
				uiTF.height = height;
			}
		}
		
		/**
		 * 滚动条动作后的触发事件。
		 */		
		protected function handleScrollBarChange(event:Event):void
		{
			if(uiTF)
				uiTF.scrollV = Math.round(vScrollBar.scrollPosition);
		}
		
		/**
		 * 用户滚动后由 TextField 对象调度。
		 */		
		protected function handleTFieldScroll(event:Event):void
		{
			if(vScrollBar)
				vScrollBar.scrollPosition = uiTF.scrollV;
		}
		
		/**
		 *  @private
		 *  Only gets called on keyboard not programmatic setting of text.
		 */
		protected function textField_changeHandler(event:Event):void
		{
			createScrollBarIfNeeded();
			
			// Stop this bubbling "change" event
			// and dispatch another one that doesn't bubble.
			event.stopImmediatePropagation();
			dispatchEvent(new Event(Event.CHANGE));
		}
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
		
	}
}