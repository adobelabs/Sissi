package sissi.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sissi.interaction.supportClasses.IInterAction;
	import sissi.managers.ToolTipManager;
	
	use namespace sissi_internal;
	
	/**
	 * UITextField在外界没有设定width和height的时候，参考的大小为textWidth和textHeight
	 * @author Alvin.Ju
	 */	
	public class UITextField extends TextField implements IUIComponent, IToolTipHost
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		override public function set text(value:String):void
		{
			if(super.text != value)
			{
				isHTML = false;
				
				untruncatedText = value  ? value : "";
				explicitHTMLText = null;
				
				validateNow();
			}
		}
		//----------------------------------
		//  htmlText
		//----------------------------------
		private var isHTML:Boolean;
		private var explicitHTMLText:String;
		/**
		 * 使用HTMLText时候，textFormat将失效。
		 * truncateToFit为true时，回截取大小，但不会出现defaultTruncationIndicator（...）
		 */		
		override public function set htmlText(value:String):void
		{
			if(super.htmlText != value)
			{
				isHTML = true;
				
				explicitHTMLText = value ? value : "";
				untruncatedText = null;
				
				
				validateNow();
			}
		}
		
		//----------------------------------
		//  defaultTextFormat
		//----------------------------------
		private var textStyleChanged:Boolean;
		private var explicitTextFormat:TextFormat;
		/**
		 * 在访问 defaultTextFormat 属性时，返回的 TextFormat 对象已定义了它的所有属性。所有属性都不为 null。
		 * new TextFormat()里面的属性项默认为null，当不为null时，对文本才有效。
		 * @return 
		 */		
		override public function set defaultTextFormat(value:TextFormat):void
		{
			if(!value)
				return;
			
			explicitTextFormat = value;
			
			textStyleChanged = true;
			
			validateNow();
		}
		
		public static function copyTextFormat(sourceTextFormat:TextFormat):TextFormat
		{
			var copy:TextFormat = new TextFormat();
			if(sourceTextFormat == null)
				return copy;
			copy.align = sourceTextFormat.align;
			copy.blockIndent = sourceTextFormat.blockIndent;
			copy.bold = sourceTextFormat.bold;
			copy.bullet = sourceTextFormat.bullet;
			copy.color = sourceTextFormat.color;
			copy.font = sourceTextFormat.font;
			copy.indent = sourceTextFormat.indent;
			copy.italic = sourceTextFormat.italic;
			copy.kerning = sourceTextFormat.kerning;
			copy.leading = sourceTextFormat.leading;
			copy.leftMargin = sourceTextFormat.leftMargin;
			copy.letterSpacing = sourceTextFormat.letterSpacing;
			copy.rightMargin = sourceTextFormat.rightMargin;
			copy.size = sourceTextFormat.size;
			copy.tabStops = sourceTextFormat.tabStops;
			copy.target = sourceTextFormat.target;
			copy.underline = sourceTextFormat.underline;
			copy.url = sourceTextFormat.url;
			return copy;
		}
		
		//----------------------------------
		//  stroke
		//----------------------------------
		public function get stroke():Array
		{
			return filters;
		}
		public function set stroke(value:Array):void
		{
			filters = value;
			
			validateNow();
		}
		
		//----------------------------------
		//  color
		//----------------------------------
		private var explicitColorChanged:Boolean;
		private var explicitColor:uint;
		/**
		 * 颜色
		 */		
		public function get color():uint
		{
			return defaultTextFormat.color as uint;
		}
		public function set color(value:uint):void
		{
			explicitColor = value;
			
			textStyleChanged = true;
			explicitColorChanged = true;
			
			validateNow();
		}
		
		//----------------------------------
		//  leading
		//----------------------------------
		private var explicitLeadingChanged:Boolean;
		private var explicitLeading:int = 3;
		public function set leading(value:uint):void
		{
			explicitLeading = value;
			
			textStyleChanged = true;
			explicitLeadingChanged = true;
			
			validateNow();
		}
		
		//----------------------------------
		//  textAlign
		//----------------------------------
		private var explicitTextAlign:String;
		/**
		 * 文字对齐方式。
		 */		
		public function get textAlign():String
		{
			return defaultTextFormat.align;
		}
		public function set textAlign(value:String):void
		{
			var _textAlign:String;
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
			else
			{
				return;
			}
			explicitTextAlign = _textAlign;
			
			textStyleChanged = true;
			
			validateNow();
		}
		
		//----------------------------------
		//  thickness
		//----------------------------------
		override public function set thickness(value:Number):void
		{
			super.antiAliasType = AntiAliasType.ADVANCED;
			super.thickness = value;
			
			validateNow();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Override Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  override x, y
		//----------------------------------
		override public function set x(value:Number):void
		{
			super.x = value;
		}
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		public function move(toX:Number, toY:Number):void
		{
			super.x = toX;
			super.y = toY;
		}
		
		//----------------------------------
		//  enabled
		//----------------------------------
		private var _enabled:Boolean = true;
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			// If enabled, reset the mouseChildren, mouseEnabled to the previously
			// set explicit value, otherwise disable mouse interaction.
//			super.mouseChildren = value ? _explicitMouseChildren : false;
			super.mouseEnabled  = value ? _explicitMouseEnabled  : false; 
		}
		
		//----------------------------------
		//  override mouseEnable mouseChildren
		//----------------------------------
		private var _explicitMouseEnabled:Boolean = true;
		override public function set mouseEnabled(value:Boolean):void
		{
			if (enabled)
				super.mouseEnabled = value;
			_explicitMouseEnabled = value;
		}
//		private var _explicitMouseChildren:Boolean = true;
//		override public function set mouseChildren(value:Boolean):void
//		{
//			if (enabled)
//				super.mouseChildren = value;
//			_explicitMouseChildren = value;
//		}
		
		
		//----------------------------------
		//  override width, height
		//----------------------------------
		private var _explicitWidth:Number;
		/**
		 * explicitWidth存放的为用户设定的宽度数值，如果isNaN为true，那么由我们自己设定宽度
		 */
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		public function set explicitWidth(value:Number):void
		{
			if(_explicitWidth == value)
				return;
			_explicitWidth = value;
		}
		
		private var _measuredWidth:Number = 0;
		/**
		 * measuredWidth是自己根据内容的测量出来的值
		 * 如果explicitWidth is NaN，那么width就会参考measuredWidth
		 */
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
		}
		
		sissi_internal var _width:Number = 0;
		/**
		 * IUIComponent的宽度
		 * @return 
		 */		
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if(explicitWidth != value)
			{
				explicitWidth = value;
			}
			if(_width != value)
			{
				_width = value;
				
				validateNow();
			}
		}
		
		private var _explicitHeight:Number;
		/**
		 * explicitWidth存放的为用户设定的高度数值，如果isNaN为true，那么由我们自己设定高度
		 */
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		public function set explicitHeight(value:Number):void
		{
			if(_explicitHeight == value)
				return;
			_explicitHeight = value;
		}
		
		private var _measuredHeight:Number = 0;
		/**
		 * measuredHeight是自己根据内容的测量出来的值
		 * 如果explicitHeight is NaN，那么height就会参考measuredHeight
		 */
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}
		
		/**
		 * measuredHeight是自己根据内容的测量出来的值
		 * 如果explicitHeight is NaN，那么height就会参考measuredHeight
		 */		
		sissi_internal var _height:Number = 0;
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if(explicitHeight != value)
			{
				explicitHeight = value;
			}
			if(_height != value)
			{
				_height = value;
				
				validateNow();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * UITextField
		 * @param textFormat textStyle
		 * @param textStroke text滤镜
		 * @param textValue text值
		 * @param isHTML textValue是否为HTML
		 */		
		public function UITextField(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super();
			focusRect = false;
			selectable = false;
			tabEnabled = false;
			
			this.defaultTextFormat = textFormat;
			this.filters = textStroke;
			
			if(isHTML)
				this.htmlText = textValue;
			else
				this.text = textValue;
			
//			this.background = true;
//			this.backgroundColor = 0xFFFFFF * Math.random();
		}
		
		/**
		 * 改变UITextField样式
		 * @param textFormat
		 * @param textStroke
		 */		
		public function changeLabelStyle(textFormat:TextFormat, textStroke:Array):void
		{
			this.defaultTextFormat = textFormat;
			this.filters = textStroke;
		}
		
		override public function set type(value:String):void
		{
			super.type = value;
			if(super.type == TextFieldType.INPUT)
			{
				//用户向文本字段中键入文本，则在每次键击后调度 change 事件，若组件使用的HTML，那么这时候就应该对HTML值失效
				addEventListener(Event.CHANGE, changeHandler);
				//			addEventListener("textFieldStyleChange", textFieldStyleChangeHandler);
			}
			else
			{
				removeEventListener(Event.CHANGE, changeHandler);
			}
		}
		
		/**
		 * 用户向文本字段中键入文本，则在每次键击后调度 change 事件，若组件使用的HTML，那么这时候就应该对HTML值失效
		 * @param event
		 */		
		protected function changeHandler(event:Event):void
		{
			untruncatedText = super.text;
			explicitHTMLText = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Lifecycle
		//
		//--------------------------------------------------------------------------
		//Lifecycle Start--------------------------------------------------------------------------
		//----------------------------------
		//  initialized
		//----------------------------------
		private var _initialized:Boolean = false;
		/**
		 * initialized，判断是否还需要重新初始化，
		 * initialized 成功之后 IUIComponent 才为可见。
		 **/
		public function get initialized():Boolean
		{
			return _initialized;
		}
		public function set initialized(value:Boolean):void
		{
			_initialized = value;
			if(_initialized)
			{
				if(_interAction && !_interAction.isActive)
					_interAction.active();
//				visible = _visible;
			}
		}
		//----------------------------------
		//  nestLevel
		//----------------------------------
		private var _nestLevel:int = 0;
		/**
		 * 嵌套级，并不代表真正的嵌套层级，而指的是进行生命周期时候进行深层排序的参考值。
		 * nestLevel为0，则表示这个组件不在舞台上
		 * 若父对象为Application的nestLevel为1，因此，其的子对象的nestLevel肯定大于1
		 * 若父对象为Sprite，那么往父对象的父对象寻找是否可以寻找到nestLevel，若找到，则赋值，若没有找到，nestLevel为？1？
		 * 每次nestLevel改变，那么对其子对象的nestLevel也要进行相应的更改
		 * @return 
		 */		
		public function get nestLevel():int
		{
			//若_nestLevel为0，若其有父对象，则试着计算出自己的nestLevel。
			if(parent && _nestLevel == 0)
			{
				var tmpNestLevel:int = 0;
				var uiParent:DisplayObjectContainer = parent;
				while(uiParent)
				{
					tmpNestLevel++;
					
					//无论嵌套多少层， 只要父对象不在显示队列里面
					if(uiParent == null)
					{
						tmpNestLevel = 0;
						break;
					}
					if(uiParent is IUIComponent)
					{
						//在父对象序列中若寻找到一个IUIComponent，那么根据这个IUIComponent，来计算此nestLevel。
						nestLevel = IUIComponent(uiParent).nestLevel + 1;
						break;
					}
					if(uiParent is Stage)
					{
						//计算到最顶层了，可以计算出临时的嵌套层级
						break;
					}
					
					uiParent = uiParent.parent;
				}
				//根据最终计算，临时设置其嵌套级
				nestLevel = tmpNestLevel;
			}
			return _nestLevel;
		}
		public function set nestLevel(value:int):void
		{
			if(_nestLevel != value)
			{
				_nestLevel = value;
				if(value > 0)
				{
					if(value == 1)
					{
						//若父对象为Application的nestLevel为1，因此，其的子对象的nestLevel肯定大于1
						//若父对象为Sprite，那么往父对象的父对象寻找是否可以寻找到nestLevel，若找到，则赋值，若没有找到，nestLevel为？1？
						//因此出现1的情况要么就是Application，要么其在最上层
					}
					//若对象已经初始化完成
					//var ui:IUIComponent = new IUIComponent();
					//addChild(ui);//nestLevel = n;
					//然后把对象移除
					//removeChild(ui);//nestLevel = 0;
					//对ui的属性发生改变
					//ui.width = 100;
					//然后再添加到舞台上
					//addChild(ui);//nestLevel = n;
					//其中ui.width = 100;赋值时不在舞台上，因此不会进LayoutManager队列
					//第二次addChild时候因为检测到initialized已经初始化了，不会重新进initialize中的3个invalidate方法
					//因此也就是此时，应该重新检查是否要进LayoutManager中的3个invalidate方法
//					if(invalidateDisplayListFlag)
//						SissiManager.layoutManager.invalidateDisplayList(this);
//					if(invalidateSizeFlag)
//						SissiManager.layoutManager.invalidateSize(this);
//					if(invalidatePropertiesFlag)
//						SissiManager.layoutManager.invalidateProperties(this);
					validateNow();
					//对其子对象进行nestLevel赋值
//					var n:int = numChildren;
//					for(var i:int = 0 ; i < n; i++)
//					{
//						var ui:DisplayObject  = getChildAt(i);
//						if(ui is IUIComponent)
//						{
//							IUIComponent(ui).nestLevel = _nestLevel + 1;
//						}
//					}
				}
			}
		}
		
		//------------------------------------------------
		//
		// initialize
		//
		//------------------------------------------------
		private var _processedDescriptors:Boolean = true;
		/**
		 * 作为第一次实例化子对象的标志位，经过了initialize()的方法。
		 * 如果为true，那么子对象就已经实例化了。
		 */
		public function get processedDescriptors():Boolean
		{
			return _processedDescriptors;
		}
		public function set processedDescriptors(value:Boolean):void
		{
			_processedDescriptors = value;
		}
		
		private var _updateCompletePendingFlag:Boolean = false;
		/**
		 * true则表示在LayoutManager控制之中
		 * false则表明LayoutManager结束
		 */
		public function get updateCompletePendingFlag():Boolean
		{
			return _updateCompletePendingFlag;
		}
		public function set updateCompletePendingFlag(value:Boolean):void
		{
			_updateCompletePendingFlag = value;
		}
		
		/**
		 * initialize 初始化方法，
		 * 由 UIComonent.addChild(UIComonent) 进行驱动。
		 * 先读取相关的style定义，再读取皮肤，再生成基本的子对象，如果定义了 InterAction， 则进行相应的监听及设置。
		 * 再下一帧后，再设置属性，测量，渲染。
		 **/
		public function initialize():void
		{
			//初始化完成 或者 初始化正在进行中
			if(_initialized || processedDescriptors)
				return;
//			
//			//创建子对象
////			createChildren();
//			
//			//添加在舞台上的话
//			if(nestLevel > 0)
//			{
//				//交给LayoutManager在下一帧根据嵌套层级进行相应计算
////				invalidateProperties();
////				invalidateSize();
////				invalidateDisplayList();
				validateNow();
//			}
//			
			processedDescriptors = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Invalidation
		//
		//--------------------------------------------------------------------------
		/**
		 * 交给LayoutManager根据嵌套层次进行属性设定
		 * 对IUIComponent进行属性赋值的时候使用此方法
		 */		
		public function invalidateProperties():void
		{
		}
		/**
		 * 交给LayoutManager根据嵌套层次进行量测
		 * 需要重新测量大小的时候使用此方法
		 */		
		public function invalidateSize():void
		{
		}
		/**
		 * 交给LayoutManager根据嵌套层次进行更改视图
		 * 需要重新布局的时候使用此方法
		 */		
		public function invalidateDisplayList():void
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Validation
		//
		//--------------------------------------------------------------------------
		/**
		 * 由LayoutManager进行调用
		 */		
		public function validateProperties():void
		{
		}
		
		private var oldMeasureWidth:Number;
		private var oldMeasureHeight:Number;
		/**
		 * 由LayoutManager进行调用
		 * @param recursive 是否迭代执行
		 */		
		public function validateSize(recursive:Boolean = false):void
		{
		}
		
		private var oldUnscaledWidth:Number;
		private var oldUnscaledHeight:Number;
		/**
		 *  由LayoutManager进行调用
		 */
		public function validateDisplayList():void
		{
		}
		/**
		 * 父对象的大小也可能改变
		 */		
		protected function invalidateParentSizeAndDisplayList():void
		{
			var p:UIComponent = parent as UIComponent;
			if (!p)
				return;
			
			p.invalidateSize();
			p.invalidateDisplayList();
		}
		/**
		 * 如果玩家设定，参考玩家的，如果不是，那么根据自己的测量数值
		 * @return 
		 */		
		protected function getExplicitOrMeasuredWidth():Number
		{
			return isNaN(_explicitWidth) ? _measuredWidth : _explicitWidth;
		}
		/**
		 * 如果玩家设定，参考玩家的，如果不是，那么根据自己的测量数值
		 * @return 
		 */	
 		protected function getExplicitOrMeasuredHeight():Number
		{
			return isNaN(_explicitHeight) ? _measuredHeight : _explicitHeight;
		}
		/**
		 * 使用此方法，不经过validate
		 * 也不会对explicitWidth explicitHeight进行赋值。
		 */		
 		public function setActualSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
		}
		
		/**
		 * 若不是sissi，那么在添加到舞台后，才使用validateNow，获取到正确的width&height。
		 */		
		public function validateNow():void
		{
			if(isHTML)
			{
				super.htmlText = explicitHTMLText ? explicitHTMLText : "";
			}
			else
			{
				super.text =  untruncatedText ? untruncatedText : "";
			}
			//当有父对象才可以，在被添加到舞台上的时候会自动
			if(!parent)
				return;
			
			//改变TextFormat要重新赋值
			if (textStyleChanged)
			{
				var tf:TextFormat = copyTextFormat(explicitTextFormat);
				
				if(explicitTextAlign)
					tf.align = explicitTextAlign;
				if(explicitColorChanged)
				{
					tf.color = explicitColor;
					explicitColorChanged = false;
				}
				if(explicitLeadingChanged)
				{
					tf.leading = explicitLeading;
					explicitLeadingChanged = false;
				}
				
				textStyleChanged = false;
				
				super.setTextFormat(tf);
				super.defaultTextFormat = tf;
				
				if(isHTML)
				{
					super.htmlText = explicitHTMLText ? explicitHTMLText : "";
				}
				else
				{
					super.text =  untruncatedText ? untruncatedText : "";
				}
			}
			
			//Same thing as validateProperties, validateSize, validateDisplayList
			measuredWidth = textWidth + WIDTH_PADDING;
			measuredHeight = textHeight + HEIGHT_PADDING;
			
			//如果玩家设定，参考玩家的，如果不是，那么根据自己的测量数值
  			setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			//只考虑unscale情况
			//若自己大小改变，那么通知父对象
			if(oldUnscaledWidth != _width || oldUnscaledHeight != _height)
				invalidateParentSizeAndDisplayList();
			super.width = oldUnscaledWidth = _width;
			super.height = oldUnscaledHeight = _height;
			
			if(truncateToFit)
			{
				var truncated:Boolean;
				if (isHTML)
				{
					truncated = measuredWidth > (isNaN(explicitWidth) ? measuredWidth : explicitWidth);
					//					doTruncateToFit();
					autoTruncatedToolTip = truncated ? super.htmlText : null;
				}
				else
				{
					truncated = doTruncateToFit();
					autoTruncatedToolTip = truncated ? untruncatedText : null;
				}
			}
			
			if(!_initialized)
				initialized = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: LifeCycle
		//
		//--------------------------------------------------------------------------
		/**
		 * 创建子对象。
		 */		
		protected function createChildren():void
		{
		}
		protected function commitProperties():void
		{
		}
		/**
		 * 需要有4, 5像素的突出
		 */		
		private static const WIDTH_PADDING:int = 5;
		private static const HEIGHT_PADDING:int = 4;
		
		protected function measure():void
		{
		}
		protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void
		{
		}
		
		/**
		 * 若设置的宽度太小，是否自动截断，并且自动出现ToolTip
		 * 目前不支持Change引起的truncateToFit。
		 */		
		public var truncateToFit:Boolean = false;
		private var untruncatedText:String;
		private var defaultTruncationIndicator:String = "...";
		/**
		 * HTMLText无效
		 * @param truncationIndicator
		 * @return 
		 */		
		private function doTruncateToFit(truncationIndicator:String = null):Boolean
		{
			if (!truncationIndicator)
				truncationIndicator = defaultTruncationIndicator;
			
			var originalText:String = untruncatedText;
			
//			untruncatedText = originalText;
			
			var w:Number = width;
			
			if (originalText != "" && textWidth + WIDTH_PADDING > w + 0.00000000000001)
			{
				var s:String = super.text = originalText;
				originalText.slice(0,
					Math.floor((w / (textWidth + WIDTH_PADDING)) * originalText.length));
				
				while (s.length > 1 && textWidth + WIDTH_PADDING > w)
				{
					s = s.slice(0, -1);
					super.text = s + truncationIndicator;
				}
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * 自动截断成功后产生的ToolTip
		 */		
		private var _autoTruncatedToolTip:*;
		private function set autoTruncatedToolTip(value:*):void
		{
			_autoTruncatedToolTip = value;
			updateTooltip();
		}
		//Lifecycle End--------------------------------------------------------------------------


		/**
		 * 同时更改宽高。
		 * @param w
		 * @param h
		 */		
		public function setSize(widthValue:Number, heightValue:Number):void
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
		//  Sissi
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  interAction
		//----------------------------------
		private var _interAction:IInterAction;
		/**
		 * InterAction，交互。
		 * 比如，同样一个Button在面对桌面设备和移动设备上有不一样的交互，
		 * 这时候，就需要把互动提出来，因为Button自身显示的逻辑代码无需重写。
		 * InterAction 自己有 active() 和 deactive() 两种方式。
		 * 当设置一个 IUIComponent 一个新的 IInterAction 的时候，需要先 deactive 原先的交互，便于垃圾回收。
		 */		
		public function get interAction():IInterAction
		{
			return _interAction;
		}
		public function set interAction(value:IInterAction):void
		{
			if(_interAction)
				_interAction.deactive();
			_interAction = value;
			//如果已经初始化
			if(_interAction && _initialized)
				_interAction.active();
		}
		
		//----------------------------------
		//  tooltip
		//----------------------------------
		private var _toolTip:*;
		/**
		 * Value or Function
		 * @return 
		 */		
		public function get toolTip():*
		{
			return _toolTip ? _toolTip : _autoTruncatedToolTip;
		}
		public function set toolTip(value:*):void
		{
			_toolTip = value;
			updateTooltip();
		}
		private function updateTooltip():void
		{
			if(_toolTip)
			{
				ToolTipManager.registerToolTip(this, _toolTip);
			}
			else
			{
				ToolTipManager.registerToolTip(this, _autoTruncatedToolTip);
			}
		}
		
		//----------------------------------
		//  toolTipClass
		//----------------------------------
		private var _toolTipClass:Class;
		public function get toolTipClass():Class
		{
			return _toolTipClass;
		}
		public function set toolTipClass(value:Class):void
		{
			_toolTipClass = value;
		}
		
		//----------------------------------
		//  toolTipPosition
		//----------------------------------
		private var _toolTipPosition:*;
		/**
		 * Value or Function
		 * @return 
		 */		
		public function get toolTipPosition():*
		{
			return _toolTipPosition;
		}
		public function set toolTipPosition(value:*):void
		{
			_toolTipPosition = value;
		}
		
		//----------------------------------
		//  toolTipShapeFlag
		//----------------------------------
		private var _toolTipShapeFlag:Boolean;
		/**
		 * Check transparent
		 */
		public function get toolTipShapeFlag():Boolean
		{
			return _toolTipShapeFlag;
		}
		/**
		 * @private
		 */
		public function set toolTipShapeFlag(value:Boolean):void
		{
			_toolTipShapeFlag = value;
		}
		
		//------------------------------------------------
		//
		// Drag About
		//
		//------------------------------------------------
		/**
		 * 注册可拖动的组件。
		 * 注册之后，基于注册点拖动整个容器。
		 * @param dragBar 被注册的可视组件。
		 */		
		public function registerDragComponent(dragBar:DisplayObject):void
		{
		}
		
		/**
		 * 取消注册可拖动的组件。
		 * 取消注册之后，基于原来注册点无法拖动整个容器。
		 * @param dragBar 被注册的可视组件。
		 */		
		public function unRegisterDragComponent(dragBar:DisplayObject):void
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Style Properties
		//
		//--------------------------------------------------------------------------
		public function get top():Number
		{
			return 0;
		}
		public function set top(value:Number):void
		{
		}
		
		public function get bottom():Number
		{
			return 0;
		}
		public function set bottom(value:Number):void
		{
		}
		
		public function get left():Number
		{
			return 0;
		}
		public function set left(value:Number):void
		{
		}
		
		public function get right():Number
		{
			return 0;
		}
		public function set right(value:Number):void
		{
		}
		
		public function get horizontalCenter():Number
		{
			return 0;
		}
		public function set horizontalCenter(value:Number):void
		{
		}
		
		public function get verticalCenter():Number
		{
			return 0;
		}
		public function set verticalCenter(value:Number):void
		{
		}
	}
}