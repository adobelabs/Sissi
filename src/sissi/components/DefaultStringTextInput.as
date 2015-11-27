package sissi.components
{
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import sissi.core.UIComponent;
	import sissi.core.UITextField;

	public class DefaultStringTextInput extends UIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
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
		// defaultText
		//----------------------------------
		private var _defaultText:String;
		private var defaultTextChanged:Boolean = false;
		private var isDefaultTextHTML:Boolean;
		public function get defaultText():String
		{
			return _defaultText;
		}
		public function set defaultText(value:String):void
		{
			if (_defaultText != value)
			{
				_defaultText = value;
				
				defaultTextChanged = true;
				isDefaultTextHTML = false;
				_htmlText = null;
				
				validateNow();
			}
		}
		//----------------------------------
		// defaultHtmlText
		//----------------------------------
		private var _defaultHtmlText:String;
		public function get defaultHtmlText():String
		{
			return _defaultHtmlText;
		}
		public function set defaultHtmlText(value:String):void
		{
			if (_defaultHtmlText != value)
			{
				_defaultHtmlText = value;
				
				defaultTextChanged = true;
				isDefaultTextHTML = true;
				_defaultHtmlText = null;
				
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
		// defaultTextDefaultTextFormat
		//----------------------------------
		private var defaultTextTextStyleChanged:Boolean;
		private var explicitDefaultTextTextFormat:TextFormat;
		
		public function set defaultTextDefaultTextFormat(value:TextFormat):void
		{
			if(!value)
				return;
			
			explicitDefaultTextTextFormat = value;
			defaultTextTextStyleChanged = true;
			
			validateNow();
		}
		
		//----------------------------------
		// color
		//----------------------------------
		private var explicitColor:uint;
		public function set color(value:uint):void
		{
			explicitColor = value;
			
			textStyleChanged = true;
			
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
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function DefaultStringTextInput(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super();
			defaultTextFormat = textFormat;
			stroke = textStroke;
			if(isHTML)
				htmlText = textValue;
			else
				text = textValue;
			tabChildren = mouseEnabled= false;
			
			setSize(200, 22);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			if(initialized)
				return;
			if(nestLevel > 0)
				validateNow();
		}
		
		/**
		 * 若不是sissi，那么在添加到舞台后，才使用validateNow，获取到正确的width&height。
		 */		
		override public function validateNow():void
		{
			//当有父对象才可以，在被添加到舞台上的时候会自动
			if(!parent)
				return;
			
			if(!realTextInput)
				return;
			
			if(textChanged)
			{
				if(isHTML)
					realTextInput.htmlText = _htmlText;
				else
					realTextInput.text = _text;
				
				textChanged = false;
			}
			if(defaultTextChanged)
			{
				if(isDefaultTextHTML)
					defaultStringUITextField.htmlText = _defaultHtmlText;
				else
					defaultStringUITextField.text = _defaultText;
				
				defaultTextChanged = false;
			}
			
			realTextInput.stroke = _stroke;
			realTextInput.thickness = _thickness;
			realTextInput.maxChars = maxChars;
			realTextInput.restrict = _restrict;
			
			//改变TextFormat要重新赋值
			if (textStyleChanged)
			{
				realTextInput.defaultTextFormat = explicitTextFormat;
				if(explicitColor)
					realTextInput.color = explicitColor;
				if(explicitTextAlign)
					realTextInput.textAlign = explicitTextAlign;
				
				textStyleChanged = false;
			}
			if(defaultTextTextStyleChanged)
			{
				defaultStringUITextField.defaultTextFormat = explicitDefaultTextTextFormat;
				
				defaultTextTextStyleChanged = false;
			}
			
			if(realTextInput.text || realTextInput.htmlText)
				defaultStringUITextField.visible = false;
			else
				defaultStringUITextField.visible = true;
			
			setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			realTextInput.setSize(width, height);
			defaultStringUITextField.setSize(width, height);
			
			initialized = true;
		}
		//--------------------------------------------------------------------------
		//
		//  Methods: LifeCycle
		//
		//--------------------------------------------------------------------------
		protected var realTextInput:TextInput;
		protected var defaultStringUITextField:UITextField;
		override protected function createChildren():void
		{
			if(!defaultStringUITextField)
			{
				defaultStringUITextField = new UITextField();
				defaultStringUITextField.mouseEnabled = defaultStringUITextField.selectable = false;
				addChild(defaultStringUITextField);
			}
			if(!realTextInput)
			{
				realTextInput = new TextInput();
				realTextInput.addEventListener(Event.CHANGE, textField_changeHandler);
				realTextInput.background = false;
				addChild(realTextInput);
			}
		}
		override protected function commitProperties():void
		{
		}
		override protected function measure():void
		{
		}
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
		}
		//--------------------------------------------------------------------------
		//
		//  Public functions
		//
		//--------------------------------------------------------------------------
		public function setFous():void
		{
			if(stage && realTextInput)
			{
				stage.focus = realTextInput;
			}
		}
		//--------------------------------------------------------------------------
		//
		//  Protected functions
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 *  Only gets called on keyboard not programmatic setting of text.
		 */
		protected function textField_changeHandler(event:Event):void
		{
			if(realTextInput.text || realTextInput.htmlText)
				defaultStringUITextField.visible = false;
			else
				defaultStringUITextField.visible = true;
			
			_text = realTextInput.text;
			_htmlText = realTextInput.htmlText;
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