package sissi.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import sissi.components.Button;
	import sissi.components.HScrollBar;
	import sissi.interaction.supportClasses.IInterAction;
	import sissi.managers.ToolTipManager;
	
	use namespace sissi_internal;
	
	public class UIComponent extends Sprite implements IUIComponent, IToolTipHost
	{
		//--------------------------------------------------------------------------
		//
		//  Override Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  visible
		//----------------------------------
		private var _visible:Boolean = true;
		override public function get visible():Boolean
		{
			return _visible;
		}
		override public function set visible(value:Boolean):void
		{
			_visible = value;
			if(_initialized)
			{
				super.visible = _visible;
			}
		}
		
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
			super.mouseChildren = value ? _explicitMouseChildren : false;
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
		private var _explicitMouseChildren:Boolean = true;
		override public function set mouseChildren(value:Boolean):void
		{
			if (enabled)
				super.mouseChildren = value;
			_explicitMouseChildren = value;
		}
		
		
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
			
			invalidateSize();
			invalidateParentSizeAndDisplayList();
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
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
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
			
			invalidateSize();
			invalidateParentSizeAndDisplayList();
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
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function UIComponent()
		{
			super();
			tabChildren = false;
			
			super.visible = false;
			
			//0, 0
			_width = super.width;
			_height = super.height;
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
				visible = _visible;
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
					if(invalidatePropertiesFlag && SissiManager.layoutManager)
						SissiManager.layoutManager.invalidateProperties(this);
					if(invalidateSizeFlag && SissiManager.layoutManager)
						SissiManager.layoutManager.invalidateSize(this);
					if(invalidateDisplayListFlag && SissiManager.layoutManager)
						SissiManager.layoutManager.invalidateDisplayList(this);
					
					// systemManager getter tries to set the internal _systemManager varaible 
					// if it is null. Hence a call to the getter is necessary.
					// Stage can be null when an untrusted application is loaded by an application
					// that isn't on stage yet.
					var sm:DisplayObject = SissiManager.sissiManager;
					if (sm && sm.stage)
					{
						if (methodQueue.length > 0 && !listeningForRender)
						{
							sm.addEventListener(Event.RENDER, callLaterDispatcher);
							sm.addEventListener(Event.ENTER_FRAME, callLaterDispatcher);
							listeningForRender = true;
						}
						if (sm.stage)
							sm.stage.invalidate();
					}
					
					//对其子对象进行nestLevel赋值
					var n:int = numChildren;
					for(var i:int = 0 ; i < n; i++)
					{
						var ui:DisplayObject  = getChildAt(i);
						if(ui is IUIComponent)
						{
							IUIComponent(ui).nestLevel = _nestLevel + 1;
						}
					}
				}
			}
		}
		
		//------------------------------------------------
		//
		// initialize
		//
		//------------------------------------------------
		private var _processedDescriptors:Boolean;
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
		 * initialize 初始化方法。若想直接初始化，请先被添加到显示列表中再使用此方法。
		 * 由 UIComonent.addChild(UIComonent) 进行驱动。
		 * 先读取相关的style定义，再读取皮肤，再生成基本的子对象，如果定义了 InterAction， 则进行相应的监听及设置。
		 * 再下一帧后，再设置属性，测量，渲染。
		 **/
		public function initialize():void
		{
			//初始化完成 或者 初始化正在进行中
			if(_initialized || processedDescriptors)
				return;
					
			//创建子对象
			createChildren();
			
			//正常流程
			if(nestLevel > 0)
			{
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
			else
			{
				//直接调用
				addEventListener(Event.ADDED_TO_STAGE, handleLaterInitialize);
			}
			
			processedDescriptors = true;
		}
		
		protected function handleLaterInitialize(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleLaterInitialize);
			//通过 get 计算出nestLevel
			nestLevel;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Invalidation
		//
		//--------------------------------------------------------------------------
		private var invalidatePropertiesFlag:Boolean = false;
		/**
		 * 交给LayoutManager根据嵌套层次进行属性设定
		 * 对IUIComponent进行属性赋值的时候使用此方法
		 */		
		public function invalidateProperties():void
		{
			if(!invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag = true;
				
				if(nestLevel && SissiManager.layoutManager)
					SissiManager.layoutManager.invalidateProperties(this);
			}
		}
		sissi_internal var invalidateSizeFlag:Boolean = false;
		/**
		 * 交给LayoutManager根据嵌套层次进行量测
		 * 需要重新测量大小的时候使用此方法
		 */		
		public function invalidateSize():void
		{
			if(!invalidateSizeFlag)
			{
				invalidateSizeFlag = true;
				
				if(nestLevel && SissiManager.layoutManager)
					SissiManager.layoutManager.invalidateSize(this);
			}
		}
		sissi_internal var invalidateDisplayListFlag:Boolean = false;
		/**
		 * 交给LayoutManager根据嵌套层次进行更改视图
		 * 需要重新布局的时候使用此方法
		 */		
		public function invalidateDisplayList():void
		{
			if(!invalidateDisplayListFlag)
			{
				invalidateDisplayListFlag = true;
				
				if(nestLevel && SissiManager.layoutManager)
					SissiManager.layoutManager.invalidateDisplayList(this);
			}
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
			if(invalidatePropertiesFlag)
			{
				commitProperties();
				
				invalidatePropertiesFlag = false;
			}
		}
		
		private var oldMeasureWidth:Number;
		private var oldMeasureHeight:Number;
		/**
		 * 由LayoutManager进行调用
		 * @param recursive 是否迭代执行
		 */		
		public function validateSize(recursive:Boolean = false):void
		{
			//是否迭代到子对象
			if(recursive)
			{
				for(var i:int = 0; i < numChildren; i++)
				{
					var child:DisplayObject = getChildAt(i);
					if(child is IUIComponent )
						(child as IUIComponent ).validateSize(true);
				}
			}
			if(invalidateSizeFlag)
			{
				//重新确认大小
				measure();
				//若测量的改变，有必要通知invalidateDisplayList，不要依赖于程序员的编写情况
				if(oldMeasureWidth != measuredWidth || oldMeasureHeight != measuredHeight)
					invalidateDisplayList();
				oldMeasureWidth = measuredWidth;
				oldMeasureHeight = measuredHeight;
				invalidateSizeFlag = false;
			}
		}
		
		private var oldUnscaledWidth:Number;
		private var oldUnscaledHeight:Number;
		/**
		 *  由LayoutManager进行调用
		 */
		public function validateDisplayList():void
		{
			if(invalidateDisplayListFlag)
			{
//				if(this is Button)
//				{
//					trace("m");
//				}
				//如果玩家设定，参考玩家的，如果不是，那么根据自己的测量数值
				setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
				
				//只考虑unscale情况
				//若自己大小改变，那么通知父对象
				if(oldUnscaledWidth != _width || oldUnscaledHeight != _height)
					invalidateParentSizeAndDisplayList();
				oldUnscaledWidth = _width;
				oldUnscaledHeight = _height;
				updateDisplayList(oldUnscaledWidth, oldUnscaledHeight);
				
				invalidateDisplayListFlag = false;
			}
		}
		/**
		 * 父对象的大小也可能改变
		 */		
		protected function invalidateParentSizeAndDisplayList():void
		{
			var p:UIComponent = parent as UIComponent;
			if (!p)
				return;
			
			if(p.name == "SissiContenGroup" && p.parent)
			{
				p = p.parent as UIGroup;
			}
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
		 * 直接马上同时跑3个validate方法
		 */		
		public function validateNow():void
		{
			SissiManager.layoutManager.validateNow(this);
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
		protected function measure():void
		{
			_measuredWidth = 0;
			_measuredHeight = 0;
			if(numChildren > 0)
			{
				var maxW:int = 0;
				var maxH:int = 0;
				var childIndex:int = 0;
				while(childIndex < numChildren)
				{
					var child:DisplayObject = getChildAt(childIndex);
					var childXX:Number = child.x + child.width;
					var childYY:Number = child.y + child.height;
					_measuredWidth = childXX > _measuredWidth ? childXX : _measuredWidth;
					_measuredHeight = childYY > _measuredHeight ? childYY : _measuredHeight;
					childIndex++;
				}
			}
		}
		protected function updateDisplayList(unscaledWidth:Number,
											 unscaledHeight:Number):void
		{
//			var g:Graphics = this.graphics;
//			g.clear();
//			//Style Start
//			var boderThickness:Number = 1;
//			var boderColor:uint = 0x888888;
//			var backgroundColor:uint = 0xFFFFFF * Math.random();
//			//Style End
//			g.lineStyle(boderThickness, boderColor);
//			g.beginFill(backgroundColor);
//			g.drawRect(boderThickness * .5, boderThickness * .5, unscaledWidth, unscaledHeight);
//			g.endFill();
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
			}
		}
		//----------------------------------
		//  override addChild, removeChild
		//----------------------------------
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			childAdded(child);
			return child;
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			childAdded(child);
			return child;
		}
		private function childAdded(child:DisplayObject):void
		{
			if(child is IUIComponent)
			{
				IUIComponent(child).nestLevel = nestLevel + 1;
				//如果初始化完成，那么激活，如果没完成，那去做初始化的过程。
				if(IUIComponent(child).initialized)
				{
					if(child is UIComponent)
						UIComponent(child).sissi_internal::sissi_active();
				}
				else
				{
					IUIComponent(child).initialize();
				}
			}
		}
		
		/**
		 * 要注意removeChild之后重新addChild
		 */		
		sissi_internal function sissi_active():void
		{
			if(_interAction)
				_interAction.active();
		}
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			childRemoved(child)
			return child;
		}
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = getChildAt(index);
			super.removeChild(child);
			childRemoved(child)
			return child;
		}
		private function childRemoved(child:DisplayObject):void
		{
			if(child is IUIComponent)
			{
				IUIComponent(child).nestLevel = 0;
				
				//如果初始化完成，那么激活，如果没完成，那去做初始化的过程。
//				if(IUIComponent(child).initialized)
//				{
//					if(child is UIComponent)
//						UIComponent(child).sissi_internal::sissi_deactive();
//				}
			}
		}
		/**
		 * 要注意removeChild之后重新addChild
		 */		
		sissi_internal function sissi_deactive():void
		{
//			if(_interAction)
//				_interAction.deactive();
			dragBarMouseUpHandler();
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
			return _toolTip;
		}
		public function set toolTip(value:*):void
		{
			_toolTip = value;
			if(_toolTip != undefined)
				ToolTipManager.registerToolTip(this, value);
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
		
		//------------------------------------
		// Drag About
		//------------------------------------
		/**
		 * 注册可拖动的组件。
		 * 注册之后，基于注册点拖动整个容器。
		 * @param dragBar 被注册的可视组件。
		 */		
		public function registerDragComponent(dragBar:DisplayObject):void
		{
			if(enabled)
				dragBar.addEventListener(MouseEvent.MOUSE_DOWN, dragBarMouseDownHandler);
		}
		
		/**
		 * 取消注册可拖动的组件。
		 * 取消注册之后，基于原来注册点无法拖动整个容器。
		 * @param dragBar 被注册的可视组件。
		 */		
		public function unRegisterDragComponent(dragBar:DisplayObject):void
		{
			dragBar.removeEventListener(MouseEvent.MOUSE_DOWN, dragBarMouseDownHandler);
		}
		/**
		 * 鼠标按住注册控件，可以进行拖动。
		 * @param event
		 */		
		private function dragBarMouseDownHandler(event:MouseEvent):void
		{
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, dragBarMouseUpHandler);
				stage.addEventListener(Event.MOUSE_LEAVE, dragBarMouseUpHandler);
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
				this.startDrag(false, new Rectangle(0, 0, stage.stageWidth - width, stage.stageHeight - height));
			}
			
		}
		/**
		 * 鼠标放开注册控件，取消拖动。
		 * @param event
		 */		
		private function dragBarMouseUpHandler(event:MouseEvent = null):void
		{
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, dragBarMouseUpHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE, dragBarMouseUpHandler);
			}
			this.stopDrag();
		}
		
		//--------------------------------------------------------------------------
		//
		//  callLater
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 *  List of methods used by callLater().
		 */
		private var methodQueue:Array /* of MethodQueueElement */ = [];
		private var listeningForRender:Boolean = false;
		public function callLater(method:Function,
								  args:Array /* of Object */ = null):void
		{
			// trace(">>calllater " + this)
			// Push the method and the arguments onto the method queue.
			methodQueue.push(new MethodQueueElement(method, args));
			
			// Register to get the next "render" event
			// just before the next rasterization.
			
			// Stage can be null when an untrusted application is loaded by an application
			// that isn't on stage yet.
			var sm:DisplayObject = SissiManager.sissiManager;
			if (sm && (sm.stage))
			{
				if (!listeningForRender)
				{
					// trace("  added");
					sm.addEventListener(Event.RENDER, callLaterDispatcher);
					sm.addEventListener(Event.ENTER_FRAME, callLaterDispatcher);
					listeningForRender = true;
				}
				
				// Force a "render" event to happen soon
				if (sm.stage)
					sm.stage.invalidate();
			}
			
			// trace("<<calllater " + this)
		}
		
		/**
		 *  @private
		 *  Callback that then calls queued functions.
		 */
		private function callLaterDispatcher(event:Event):void
		{
			// trace(">>calllaterdispatcher " + this);
			SissiManager.callLaterDispatcherCount++;
			
			// At run-time, callLaterDispatcher2() is called
			// without a surrounding try-catch.
			if (!SissiManager.catchCallLaterExceptions)
			{
				callLaterDispatcher2(event);
			}
				
				// At design-time, callLaterDispatcher2() is called
				// with a surrounding try-catch.
			else
			{
				try
				{
					callLaterDispatcher2(event);
				}
				catch(e:Error)
				{
//					var callLaterErrorEvent:DynamicEvent = new DynamicEvent("callLaterError");
//					callLaterErrorEvent.error = e;
//					systemManager.dispatchEvent(callLaterErrorEvent);
				}
			}
			// trace("<<calllaterdispatcher");
			SissiManager.callLaterDispatcherCount--;
		}
		
		/**
		 *  @private
		 *  Callback that then calls queued functions.
		 */
		private function callLaterDispatcher2(event:Event):void
		{
			if (SissiManager.callLaterSuspendCount > 0)
				return;
			
			// trace("  >>calllaterdispatcher2");
			var sm:DisplayObject = SissiManager.sissiManager;
			
			// Stage can be null when an untrusted application is loaded by an application
			// that isn't on stage yet.
			if (sm && sm.stage && listeningForRender)
			{
				// trace("  removed");
				sm.removeEventListener(Event.RENDER, callLaterDispatcher);
				sm.removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
				listeningForRender = false;
			}
			
			// Move the method queue off to the side, so that subsequent
			// calls to callLater get added to a new queue that'll get handled
			// next time.
			var queue:Array = methodQueue;
			methodQueue = [];
			
			// Call each method currently in the method queue.
			// These methods can call callLater(), causing additional
			// methods to be queued, but these will get called the next
			// time around.
			var n:int = queue.length;
			//  trace("  queue length " + n);
			for (var i:int = 0; i < n; i++)
			{
				var mqe:MethodQueueElement = MethodQueueElement(queue[i]);
				
				mqe.method.apply(null, mqe.args);
			}
			
			// trace("  <<calllaterdispatcher2 " + this);
		}
		
		/**
		 *  @private
		 *  Cancels all queued functions.
		 */
		sissi_internal function cancelAllCallLaters():void
		{
			var sm:DisplayObject = SissiManager.sissiManager;
			
			// Stage can be null when an untrusted application is loaded by an application
			// that isn't on stage yet.
			if (sm && sm.stage)
			{
				if (listeningForRender)
				{
					sm.removeEventListener(Event.RENDER, callLaterDispatcher);
					sm.removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
					listeningForRender = false;
				}
			}
			
			// Empty the method queue.
			methodQueue.splice(0);
		}
		//--------------------------------------------------------------------------
		//
		//  Style Properties
		//
		//--------------------------------------------------------------------------
		private var _top:Number;
		public function get top():Number
		{
			return _top;
		}
		public function set top(value:Number):void
		{
			if(_top != value)
			{
				_top = value;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private var _bottom:Number;
		public function get bottom():Number
		{
			return _bottom;
		}
		public function set bottom(value:Number):void
		{
			_bottom = value;
		}
		
		private var _left:Number;
		public function get left():Number
		{
			return _left;
		}
		public function set left(value:Number):void
		{
			_left = value;
		}
		
		private var _right:Number;
		public function get right():Number
		{
			return _right;
		}
		public function set right(value:Number):void
		{
			_right = value;
		}
		
		private var _horizontalCenter:Number;
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		public function set horizontalCenter(value:Number):void
		{
			_horizontalCenter = value;
		}
		
		private var _verticalCenter:Number;
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		public function set verticalCenter(value:Number):void
		{
			_verticalCenter = value;
		}
	}
}
////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: MethodQueueElement
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 *  An element of the methodQueue array.
 */
class MethodQueueElement
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 */
	public function MethodQueueElement(method:Function,
									   args:Array /* of Object */ = null)
	{
		super();
		
		this.method = method;
		this.args = args;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  method
	//----------------------------------
	
	/**
	 *  A reference to the method to be called.
	 */
	public var method:Function;
	
	//----------------------------------
	//  args
	//----------------------------------
	
	/**
	 *  The arguments to be passed to the method.
	 */
	public var args:Array /* of Object */;
}
