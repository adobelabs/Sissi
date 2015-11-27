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
	
	public class LinkLabel extends UIComponent
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
		
		override public function set width(value:Number):void
		{
			if(super.width != value)
			{
				super.width = value;
				validateNow();
			}
		}
		
		override public function set height(value:Number):void
		{
			if(super.height != value)
			{
				super.height = value;
				validateNow();
			}
		}
		
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
		private var _selectable:Boolean = false;
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			
			validateNow();
		}
		
		private var _truncateToFit:Boolean;
		public function get truncateToFit():Boolean
		{
			return _truncateToFit;
		}
		public function set truncateToFit(value:Boolean):void
		{
			_truncateToFit = value;
			
			validateNow();
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function LinkLabel(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super();
			defaultTextFormat = textFormat;
			stroke = textStroke;
			if(isHTML)
				htmlText = textValue;
			else
				text = textValue;
			
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
		}
		/**
		 * 同时更改宽高。
		 * @param w
		 * @param h
		 */		
		override public function setSize(widthValue:Number, heightValue:Number):void
		{
			if(this._width != widthValue || this._height != heightValue)
			{
				this.width = widthValue;
				this.height = heightValue;
				validateNow();
			}
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
			
			if(!textField)
				return;
			
			if(textChanged)
			{
				if(isHTML)
					textField.htmlText = _htmlText;
				else
					textField.text = _text;
				
				textChanged = false;
			}
			//Same thing as validateProperties, validateSize, validateDisplayList
			measuredWidth = textField.width;
			measuredHeight = textField.height;
			
			textField.truncateToFit = _truncateToFit;
			textField.stroke = _stroke;
			textField.thickness = _thickness;
			textField.restrict = _restrict;
			textField.selectable = _selectable;
			
			//改变TextFormat要重新赋值
			if (textStyleChanged)
			{
				textField.defaultTextFormat = explicitTextFormat;
				if(explicitColorChanged)
					textField.color = explicitColor;
				if(explicitTextAlign)
					textField.textAlign = explicitTextAlign;
				textField.leading = explicitLeading;
				
				textStyleChanged = false;
			}
			
			setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			textField.setSize(width, height);
			
			initialized = true;
		}
		//------------------------------------------------
		//
		// createChildren
		//
		//------------------------------------------------
		protected var textField:UITextField;
		override protected function createChildren():void
		{
			if(!textField)
			{
				textField = new UITextField();
				textField.selectable = false;
				textField.tabEnabled = false;
				addChild(textField);
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
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
		
	}
}