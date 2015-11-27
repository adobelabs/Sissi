/**
 * bug:
 * 滚动条反应太灵敏 
 * 以表情结尾时，设置的格式将应用与所有后面的文本
 * 如何拦截copy事件
 */
package sissi.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sissi.core.UIComponent;
	import sissi.managers.BMDCacheManager;
	
	/**
	 * 表情符号的长度有限制，反斜杠后面最多2个 
	 * 
	 */
	public class RichTextArea extends UIComponent
	{
		/**
		 * 占位符 
		 */
		private static const PLACEHOLDER:String = '　';
		
		private static const PLACEHOLDER_WIDTH_ARRAY:Array = [0,0.5,1.5,2,2.5,3.5,6,4.5,5.5,6,6.5,7.5,8,8.5,9.5,10,10.5,11.5,12,12.5,13.45,13.95,14.45,15.45,15.95,16.45,17.45,17.95,18.45,19.45,19.95,20.45,21.45,21.95,22.45,22.95,23.95,24.45,24.95,25.95,26.45,26.95,27.95,28.45,28.95,29.95,30.45,30.95,31.95,32.45,32.95];
		private static const PLACEHOLDER_HEIGHT_ARRAY:Array = [0,1,2.5,3,5,6,7.5,8,9.5,10,11,12.5,13.5,14.5,16.5,16.95,17.95,19.45,20.45,21.45,22.95,23.95,25.45,26.45,27.45,28.45,29.95,30.45,31.95,33.45,33.95,34.95,36.45,37.45,38.45,39.95,40.45,41.95,42.95,44.45,44.95,46.95,47.45,48.95,49.95,51.45,51.95,53.45,54.4,55.4,56.9];
		
		private static const PLACEHOLDER_WH_RATIO:Number = 15/25;
		/**
		 * 默认图片的高和宽 
		 */
		private static const DEFAULT_WIDTH_HEIGHT:int = 30;
		/**
		 * 占位符左右的填补空隙 (这个值是要根据传进来的表情的大小来调整的)
		 */
		private static const PLACEHOLDER_PADDING_WIDTH:int = 16;
		
		/**
		 * 占位符位置的字体大小
		 */
		private static const PLACEHOLDER_SIZE:int = 22;
		
		/**
		 * 表情指示符 
		 */
		private static const IMAGE_INDICATOR:String = '\\';
		
		/**
		 * 占位符字体 
		 */
		private static var placeholderFormat:TextFormat ;
		
		private var _displayAsCode:Boolean = false;
		
		/**
		 * 不对表情代码进行处理，直接显示
		 * @return 
		 * 
		 */
		public function get displayAsCode():Boolean
		{
			return _displayAsCode;
		}
		
		public function set displayAsCode(value:Boolean):void
		{
			if(_displayAsCode == value)
				return;
			_displayAsCode = value;
			if(!indexDictionary)
				return;
			if(value)
			{
				imageArea.removeChildren();
			}
			text = _originalText;
		}
		
		
		
		//----------------------------------
		//  letterSpacing
		//----------------------------------
		private var _letterSpacing:int = 0;
		/**
		 * 文字间隔
		 */		
		public function get letterSpacing():int
		{
			return _letterSpacing;
		}
		public function set letterSpacing(value:int):void
		{
			_letterSpacing = value;
			
			if(textField)
			{
				defaultTextFormat.letterSpacing = _letterSpacing;
				textField.defaultTextFormat = defaultTextFormat;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  maxChars
		//----------------------------------
		protected var _maxChars:int = 0;
		public function get maxChars():int
		{
			return _maxChars;
		}
		public function set maxChars(value:int):void
		{
			if(_maxChars != value)
			{
				_maxChars = value;
				if(textField)
					textField.maxChars = value;
			}
		}
		
		//----------------------------------
		//  restrict
		//----------------------------------
		protected var _restrict:String;
		public function get restrict():String
		{
			return _restrict;
		}
		
		public function set restrict(value:String):void
		{
			if(_restrict != value)
			{
				_restrict = value;
				if(textField)
					textField.restrict = value;
			}
		}
		
		
		//----------------------------------
		//  selectable
		//----------------------------------
		protected var _selectable:Boolean;
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			if(textField)
			{
				textField.selectable = _selectable;
				textField.mouseEnabled = _selectable;
				mouseChildren = _selectable;
			}
		}
		
		
		//----------------------------------
		//  color
		//----------------------------------
		protected var _color:uint = 0x000000;
		/**
		 * 颜色
		 */		
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			if(_color != value)
			{
				_color = value;
				
				if(textField)
				{
					defaultTextFormat.color = _color;
					textField.defaultTextFormat = defaultTextFormat;
				}
			}
		}
		
		//----------------------------------
		//  font
		//----------------------------------
		protected var _font:String = "Arial";
		/**
		 * 字体
		 */		
		public function get font():String
		{
			return _font;
		}
		public function set font(value:String):void
		{
			_font = value;
			
			if(textField)
			{
				defaultTextFormat.font = _font;
				textField.defaultTextFormat = defaultTextFormat;
			}
		}
		
		//----------------------------------
		// leading
		//----------------------------------
		protected var _leading:int = 3;
		
		public function get leading():int
		{
			return _leading;
		}
		
		public function set leading(value:int):void
		{
			_leading = value;
			if(textField)
			{
				defaultTextFormat.leading = _leading;
				textField.defaultTextFormat = defaultTextFormat;
			}
		}
		//----------------------------------
		//  size
		//----------------------------------
		protected var _size:int = 12;
		/**
		 * 文字大小
		 */		
		public function get size():int
		{
			return _size;
		}
		public function set size(value:int):void
		{
			_size = value;
			
			if(textField)
			{
				defaultTextFormat.size = _size;
				textField.defaultTextFormat = defaultTextFormat;
			}
		}
		
		private var _backgroundColor:uint;
		private var _backgroundAlpha:Number;
		public function setBackgroundColor(color:uint, alpha:Number):void
		{
			_backgroundColor = color;
			_backgroundAlpha = alpha;
			if(bg)
			{
				bg.graphics.clear();
				bg.graphics.beginFill(color,alpha);
				bg.graphics.drawRect(0,0,1,1);
			}
		}
		
		public function get length():int
		{
			return textField.length;
		}
		
		//----------------------------------
		//  textAlign
		//----------------------------------
		protected var _textAlign:String = TextFormatAlign.LEFT;
		[Inspectable(category="General", enumeration="left, center, right", defaultValue="left")]
		/**
		 * 文字对齐方式。
		 */		
		public function get textAlign():String
		{
			return _textAlign;
		}
		public function set textAlign(value:String):void
		{
			if(value == "right")
			{
				_textAlign = TextFormatAlign.RIGHT;
			}
			else if(value == "center")
			{
				_textAlign = TextFormatAlign.CENTER;
			}
			else if(value == "left")
			{
				_textAlign = TextFormatAlign.LEFT;
			}
			
			if(textField)
			{
				defaultTextFormat.align = _textAlign;
				textField.defaultTextFormat = defaultTextFormat;
			}
		}
		
		//----------------------------------
		//  defaultTextFormat
		//----------------------------------
		protected var defaultTextFormat:TextFormat;
		
		private var imageArea:Sprite;
		
		public function RichTextArea()
		{
			placeholderFormat = new TextFormat(null,PLACEHOLDER_SIZE);
			placeholderFormat.letterSpacing = PLACEHOLDER_PADDING_WIDTH;
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  LifeCycle
		//
		//--------------------------------------------------------------------------
		protected var bg:Shape;
		protected var textField:TextField;
		protected var vScrollBar:ScrollBar;
		
		public var faceXOffset:int;
		public var faceYOffset:int;
		
		
		override protected function createChildren():void
		{
			if(!bg)
			{
				bg = new Shape();
				bg.graphics.beginFill(_backgroundColor,_backgroundAlpha);
				bg.graphics.drawRect(0,0,1,1);
				if(_autoFade)
				{
					bg.alpha = 0;
				}
				addChild(bg);
			}
			if(!textField)
			{
				defaultTextFormat = new TextFormat();
				defaultTextFormat.font = _font;
				defaultTextFormat.color = _color;
				defaultTextFormat.size = _size;
				defaultTextFormat.align = _textAlign;
				defaultTextFormat.leading = _leading;
				defaultTextFormat.letterSpacing = _letterSpacing;
				
				textField = new TextField();
				//默认的话左对齐，没有办法外界参数固定住width。
				textField.autoSize = TextFieldAutoSize.NONE;//LEFT TextFieldAutoSize.RIGHT TextFieldAutoSize.CENTER TextFieldAutoSize.NONE
				textField.defaultTextFormat = defaultTextFormat;
				
				textField.type = TextFieldType.DYNAMIC;
				textField.multiline = true;
				textField.wordWrap = true;
				//				textField.border = true;
				//				textField.borderColor = 0x000000;
				
				textField.maxChars = _maxChars;
				textField.restrict = _restrict;
				textField.addEventListener(Event.SCROLL, handleTFieldScroll);
				addChild(textField);
			}
			if(!imageArea)
			{
				imageArea = new Sprite();
				imageArea.mouseChildren = imageArea.mouseEnabled = false;
				addChild(imageArea);
			}
			if(!vScrollBar)
			{
				vScrollBar = new VScrollBar();
				vScrollBar.addEventListener(Event.CHANGE, handleScrollBarChange);
				if(_autoFade)
				{
					vScrollBar.alpha = 0;
				}
				addChild(vScrollBar);
			}
			//			addEventListener(Event.COPY, onCopyRichText);
		}
		
		//		/**
		//		 * 截获复制内容，修改空格为表情 
		//		 * @param event
		//		 * 
		//		 */
		//		protected function onCopyRichText(event:Event):void
		//		{
		//			// TODO Auto-generated method stub
		//			var i:int = 1;
		//			trace(event);
		//		}
		
		//------------------------------------------------
		//
		// measure
		//
		//------------------------------------------------
		override protected function measure():void
		{
			//			if(_text == "")
			//			{
			//				if(textField)
			//				{
			//					textField.text = "X";
			//					textField.height = textField.textHeight + 4;
			//					textField.text = "";
			//				}
			//			}
		}
		
		//------------------------------------------------
		//
		// updateDisplayList
		//
		//------------------------------------------------
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(bg)
			{
				bg.width = width;
				bg.height = height;
			}
			if(vScrollBar)
			{
				vScrollBar.setSize(20, height);
				vScrollBar.move(width - vScrollBar.width, 0);
			}
			if(textField)
			{
				textField.x = 2;
				textField.y = 2;
				textField.width = width - 4 - vScrollBar.width;
				textField.height = height - 4;
				textField.htmlText = _htmlText;
				if(imageArea)
				{
					imageArea.x = textField.x + faceXOffset;
					imageArea.y = textField.y + faceYOffset;
				}
			}
			callLater(updateScrollbar);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected functions
		//
		//--------------------------------------------------------------------------
		/**
		 * 鼠标滚轮事件。
		 */		
		protected function handleMouseWheel(event:MouseEvent):void
		{
			vScrollBar.scrollPosition -= event.delta;
			textField.scrollV = Math.round(vScrollBar.scrollPosition);			
		}
		
		/**
		 * 用户滚动后由 TextField 对象调度。
		 */		
		protected function handleTFieldScroll(event:Event):void
		{
			vScrollBar.scrollPosition = textField.scrollV;
			updateScrollbar();
		}
		
		/**
		 * 滚动条动作后的触发事件。
		 */		
		protected function handleScrollBarChange(event:Event):void
		{
			textField.scrollV = Math.round(vScrollBar.scrollPosition);
			if(!_displayAsCode)
				resetImage();
		}
		
		/**
		 * 更新滚动条。
		 */		
		protected function updateScrollbar():void
		{
			var visibleLines:int = textField.numLines - textField.maxScrollV + 1;
			var percent:Number = visibleLines / textField.numLines;
			vScrollBar.minScrollPosition = 1;
			vScrollBar.maxScrollPosition = textField.maxScrollV;
			vScrollBar.thumbSizePercent = percent;
			vScrollBar.scrollPosition = textField.scrollV;
			if(!_displayAsCode)
				resetImage();
		}
		
		private function resetImage():void
		{
			imageArea.removeChildren();
			needAddedImages = [];
			var startLine:int = textField.scrollV - 1;
			var endLine:int = textField.bottomScrollV - 1;
			var startCharIndex:int = textField.getLineOffset(startLine);
			var endCharIndex:int = textField.getLineOffset(endLine) + textField.getLineLength(endLine) - 1;
			
			while(startCharIndex <= endCharIndex)
			{
				var currentChar:String = textField.text.charAt(startCharIndex);
				if(currentChar == PLACEHOLDER && indexDictionary.hasOwnProperty(startCharIndex))//如果此位置是占位符
				{
					var imageClass:Class = imageDictionary[indexDictionary[startCharIndex]] as Class;
					if(imageClass)
					{
						var imageInstance:* = new imageClass();
						if(imageInstance is BitmapData)
						{
							var image:DisplayObject = new Bitmap(BMDCacheManager.getBMD(imageClass));
						}
						else
						{
							image = imageInstance;
						}
						changeFormatByImage(image, startCharIndex);
					}
				}
				startCharIndex ++;
			}
			
			renderImage();
			
			if(hasNewTextAppended)
			{
				callLater(scrollToBotton);
			}
		}
		
		/**
		 *  将表情渲染到对应的位置
		 * @param image
		 * @param index
		 * 
		 */
		private function changeFormatByImage(image:DisplayObject, index:int):void
		{
			var placeHolderSize:int = PLACEHOLDER_SIZE + (image.height - DEFAULT_WIDTH_HEIGHT);
			var newPlaceholderFormat:TextFormat = new TextFormat(null,placeHolderSize);
			textField.setTextFormat(newPlaceholderFormat,index,index+1);
			
			var rect:Rectangle = textField.getCharBoundaries(index);
			if(!rect)
				return;
			
			var placeHolderLetterSpaceing:int = image.width - PLACEHOLDER_WIDTH_ARRAY[placeHolderSize];// PLACEHOLDER_PADDING_WIDTH + (image.width - DEFAULT_WIDTH_HEIGHT) + (15 - rect.height * PLACEHOLDER_WH_RATIO)
			newPlaceholderFormat.letterSpacing = placeHolderLetterSpaceing;
			
			textField.setTextFormat(newPlaceholderFormat,index,index+1);
			
			needAddedImages[index] = image;
		}
		
		private function renderImage():void
		{
			for(var key:String in needAddedImages)
			{
				var index:int = int(key);
				var image:DisplayObject = needAddedImages[index] as DisplayObject;
				var rect:Rectangle = textField.getCharBoundaries(index);
				if (rect != null)
				{
//					var x:Number = (rect.x + (rect.width - image.width) * 0.5 + 0.5) >> 0;
//					var y:Number = (rect.y + (rect.height - image.height) * 0.5 + 0.5) >> 0;
					var x:Number = rect.x ;
					var y:Number = rect.y ;
					image.x = x;
					image.y = y;
					imageArea.addChild(image);
				}
			}
		}
		
		private var needAddedImages:Array;
		
		
		//------------------------------------------------------------------------
		//
		// 通过表情代号注册、查找表情
		//
		//------------------------------------------------------------------------
		/**
		 * imageDictionary[表情代号] = 可视对象类
		 */
		private var imageDictionary:Dictionary = new Dictionary();
		
		/**
		 * 注册表情 
		 * @param textCode 表情代号，由 表情指示符 + 1~2个char组成
		 * @param displayObject 表情
		 * 
		 */
		public function registerImage(textCode:String, displayObjectClass:Class):void
		{
			if(!imageDictionary)
				imageDictionary = new Dictionary();
			imageDictionary[textCode] = displayObjectClass;
		}
		
		
		/**
		 * 注销表情 
		 * @param textCode
		 * 
		 */
		public function deregisterImage(textCode:String = null):void
		{
			if(imageDictionary)
			{
				if(textCode)
					delete imageDictionary[textCode];
				else
					imageDictionary = new Dictionary();
			}
		}
		
		private function getImageByCode(code:String):DisplayObject
		{
			return imageDictionary[code] as DisplayObject;
		}
		
		
		//------------------------------------------------------------------------
		//
		// 文本赋值
		//
		//------------------------------------------------------------------------
		private var _originalText:String = '';
		private var _text:String = '';
		private var currentMaxLength:int;
		/**
		 * indexDictionary[占位符在字符串中的index] = 表情代号
		 */
		private var indexDictionary:Dictionary;
		public function set text(value:String):void
		{
			_originalText = value;
			
			currentMaxLength = 0;
			indexDictionary = new Dictionary();
			if(_displayAsCode)
			{
				_text = value;
				if(textField)
					textField.text = value;
			}
			else
			{
				var relacedText:String = replaceImageCode(value);
				_text = relacedText;
				if(textField)
				{
					textField.text = relacedText;
					resetImage();
				}
			}
		}
		
		private var _originalHtmlText:String = '';
		private var _htmlText:String = '';
		public function get htmlText():String
		{
			return _originalHtmlText;
		}
		
		// replaceImageCode he replaceImageCodeNotRecord 这里还要优化
		public function set htmlText(value:String):void
		{
			hasNewTextAppended = true;
			_originalHtmlText = value;
			currentMaxLength = 0;
			indexDictionary = new Dictionary();
			if(_displayAsCode)
			{
				_htmlText = value;
				if(textField)
					textField.htmlText = value;
			}
			else
			{
				textField.htmlText = value;
				replaceImageCode(textField.text);
				_htmlText = replaceImageCodeNotRecord(value);
				if(textField)
				{
					textField.htmlText = _htmlText;
					resetImage();
				}
			}
		}
		
		public function get text():String
		{
			return _originalText;
		}
		
		
		private var hasNewTextAppended:Boolean;
		public function appendText(newText:String):void
		{
			hasNewTextAppended = true;
			if(textField)
			{
				currentMaxLength = textField.length;
			}
			else
			{
				currentMaxLength = 0;
			}
			_originalText = _originalText.concat(newText);
			if(_displayAsCode)
			{
				textField.appendText(newText);
				callLater(scrollToBotton);
			}
			else
			{
				textField.appendText(replaceImageCode(newText));
				resetImage();
			}
		}
		
		
		public function setTextFormat(format:TextFormat, beginIndex:int=-1, endIndex:int=-1):void
		{
			textField.setTextFormat(format,beginIndex,endIndex);
		}
		
		
		/**
		 * 将新文本中的表情代码用空格替代处理 ，并且记录下它们的索引
		 * @param text
		 * @return 
		 * 
		 */
		private function replaceImageCode(text:String):String
		{
			var newText:String = text;
			if(!indexDictionary)
				indexDictionary = new Dictionary();
			var textLength:int = newText.length - 1;
			var char:String;
			var code1:String;
			var code2:String;
			var charCode:String;
			var charCodeLength:int;
			var i:int = 0;
			while(i <= textLength)
			{
				char = newText.charAt(i);
				code1 = newText.charAt(i+1);
				code2 = newText.charAt(i+2);
				if(char == IMAGE_INDICATOR && code1)
				{
					charCodeLength = 0;
					charCode = IMAGE_INDICATOR + code1;
					if(imageDictionary.hasOwnProperty(charCode)) //如果有一个字长度的表情代码  （如： \笑）
					{
						charCodeLength = 1;
					}
					else if(code2)
					{
						charCode += code2;
						if(imageDictionary.hasOwnProperty(charCode)) //如果有两个字长度的表情代码  （如： \大笑）
						{
							charCodeLength = 2;
						}
					}
					if(charCodeLength) //如果在字典中储存了这个表情号码对应的表情
					{
						indexDictionary[currentMaxLength + i] = charCode;
						textLength -= charCodeLength;
						newText = newText.substring(0, i) + PLACEHOLDER + newText.substring(i+1+charCodeLength);
					}
				}
				i ++;
			}
			return newText;
		}
		
		/**
		 * 将新文本中的表情代码用空格替代处理 
		 * @param text
		 * @return 
		 * 
		 */
		private function replaceImageCodeNotRecord(text:String):String
		{
			var newText:String = text;
			if(!indexDictionary)
				indexDictionary = new Dictionary();
			var textLength:int = newText.length - 1;
			var char:String;
			var code1:String;
			var code2:String;
			var charCode:String;
			var charCodeLength:int;
			var i:int = 0;
			while(i <= textLength)
			{
				char = newText.charAt(i);
				code1 = newText.charAt(i+1);
				code2 = newText.charAt(i+2);
				if(char == IMAGE_INDICATOR && code1)
				{
					charCodeLength = 0;
					charCode = IMAGE_INDICATOR + code1;
					if(imageDictionary.hasOwnProperty(charCode)) //如果有一个字长度的表情代码  （如： \笑）
					{
						charCodeLength = 1;
					}
					else if(code2)
					{
						charCode += code2;
						if(imageDictionary.hasOwnProperty(charCode)) //如果有两个字长度的表情代码  （如： \大笑）
						{
							charCodeLength = 2;
						}
					}
					if(charCodeLength) //如果在字典中储存了这个表情号码对应的表情
					{
						textLength -= charCodeLength;
						newText = newText.substring(0, i) + PLACEHOLDER + newText.substring(i+1+charCodeLength);
					}
				}
				i ++;
			}
			return newText;
		}
		
		private function scrollToBotton():void
		{
			textField.scrollV = textField.maxScrollV;
			hasNewTextAppended = false;
		}
		
		private var _autoFade:Boolean;
		public function get autoFade():Boolean
		{
			return _autoFade;
		}
		public function set autoFade(value:Boolean):void
		{
			_autoFade = value;
			if(_autoFade)
			{
				if(bg)
				{
					bg.alpha = 0;
				}
				if(vScrollBar)
				{
					vScrollBar.alpha = 0;
				}
				//				this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				//				this.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
				this.addEventListener(MouseEvent.MOUSE_OVER, showBackground);
				this.addEventListener(MouseEvent.MOUSE_OUT, hideBackground);
			}
			else
			{
				if(bg)
				{
					bg.alpha = 1;
				}
				if(vScrollBar)
				{
					vScrollBar.alpha = 1;
				}
				this.removeEventListener(MouseEvent.MOUSE_OVER, showBackground);
				this.removeEventListener(MouseEvent.MOUSE_OUT, hideBackground);
				//				this.removeEventListener(Event.ENTER_FRAME, updateAlpha);
			}
		}
		
		private var fadingIn:Boolean;
		private var fadingOut:Boolean;
		private function showBackground(e:MouseEvent):void
		{
			if(bg)
			{
				bg.alpha = 1;
			}
			if(vScrollBar)
			{
				vScrollBar.alpha = 1;
			}
			//			fadingIn = true;
			//			fadingOut = false;
			//			if(!this.hasEventListener(Event.ENTER_FRAME))
			//			{
			//				this.addEventListener(Event.ENTER_FRAME, updateAlpha);
			//			}
		}
		
		private function hideBackground(e:MouseEvent):void
		{
			if(bg)
			{
				bg.alpha = 0;
			}
			if(vScrollBar)
			{
				vScrollBar.alpha = 0;
			}
			//			fadingIn = false;
			//			setTimeout(startFadingOut, 800);
			//			if(!this.hasEventListener(Event.ENTER_FRAME))
			//			{
			//				this.addEventListener(Event.ENTER_FRAME, updateAlpha);
			//			}
		}
		
		private function startFadingOut():void
		{
			if(fadingIn == false)
				fadingOut = true;
		}
		
		private function updateAlpha(e:Event):void
		{
			if(fadingOut && !fadingIn)
			{
				bg.alpha -= .1;
				vScrollBar.alpha -= .1;
				if(bg.alpha <= 0)
				{
					bg.alpha = 0;
				}
				if(vScrollBar.alpha <= 0)
				{
					fadingOut = false;
					vScrollBar.alpha = 0;
					this.removeEventListener(Event.ENTER_FRAME, updateAlpha);
				}
			}
			else if(fadingIn && !fadingOut)
			{
				bg.alpha += .3;
				if(bg.alpha >= 1)
					bg.alpha = 1;
				vScrollBar.alpha += .3;
				if(vScrollBar.alpha >= 1)
				{
					fadingIn = false;
					vScrollBar.alpha = 1;
					this.removeEventListener(Event.ENTER_FRAME, updateAlpha);
				}
			}
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			this.autoFade = false;
		}
		private function onFocusOut(e:FocusEvent):void
		{
			this.autoFade = true;
		}
		
		
		
	}
}