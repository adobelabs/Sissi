package sissi.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sissi.components.supportClasses.UITextFieldListItemRenderer;
	import sissi.events.ListItemEvent;

	public class VirtualGroup extends UIGroup
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------------------
		//
		// Virtual About
		//
		//------------------------------------------------
		//----------------------------------
		//  virtualChildren
		//----------------------------------
		/**
		 * 虚拟位置数据
		 */		
		public var virtualChildren:Vector.<VirtualItemRenderer>;
		
		//----------------------------------
		//  useVirtualMode
		//----------------------------------
		/**
		 * 是否开启虚拟。
		 */		
		protected var _useVirtualMode:Boolean;
		public function get useVirtualMode():Boolean
		{
			return _useVirtualMode;
		}
		//----------------------------------
		//  dataProvider
		//----------------------------------
		/**
		 * 数据源四是否变化。
		 */		
		protected var dataProviderChanged:Boolean;
		/**
		 * 数据源。
		 **/
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			if(value is Array)
			{
				_dataProvider = value as Array;
			}
			else if(value is Vector.<*>)
			{
				_dataProvider = value as Vector.<*>;
			}
			else
			{
				_dataProvider = null;
			}
			dataProviderChanged = true;
			
			//clearSelectionData()
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  length
		//----------------------------------
		/**
		 * 数据源长度。
		 * @return 数据源长度。
		 */		
		public function get length():int
		{
			if(_dataProvider is Array
				|| _dataProvider as Vector.<*>)
			{
				return _dataProvider.length;
			}
			else
			{
				return 0;
			}
		}
		
		//----------------------------------
		//  itemRenderer
		//----------------------------------
		/**
		 * 类对象。
		 */	
		protected var itemRendererChanged:Boolean;
		private var _itemRenderer:IFactory;
		/**
		 * 重复的类对象。
		 */	
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			if(_itemRenderer != value)
			{
				_itemRenderer = value;
				itemRendererChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//----------------------------------
		//  selectIndex selectItem
		//----------------------------------
		private var explicitSelectIndex:int = -1;
		private var explicitSelectItem:*;
		
		private var _selectIndex:int = -1;
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		public function set selectIndex(value:int):void
		{
			if(explicitSelectIndex != value)
			{
				explicitSelectIndex = value;
				explicitSelectItem = null;
				
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		private var _selectItem:*;
		public function get selectItem():*
		{
			return _selectItem;
		}
		public function set selectItem(value:*):void
		{
			explicitSelectItem = value;
			explicitSelectIndex = -1;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  enableMouseWheel
		//----------------------------------
		private var _enableMouseWheel:Boolean;
		public function get enableMouseWheel():Boolean
		{
			return _enableMouseWheel;
		}
		public function set enableMouseWheel(value:Boolean):void
		{
			_enableMouseWheel = value;
		}
		
		//----------------------------------
		//  rollOverSkin
		//----------------------------------
		private var _rollOverSkin:DisplayObject;
		public function get rollOverSkin():DisplayObject
		{
			return _rollOverSkin;
		}
		public function set rollOverSkin(value:DisplayObject):void
		{
			if(_rollOverSkin && sissi_internal::contains(_rollOverSkin))
			{
				sissi_internal::removeChild(_rollOverSkin);
			}
			sissi_internal::contentGroup.removeEventListener(MouseEvent.MOUSE_MOVE, rollOverSkinMoveHandler);
			sissi_internal::contentGroup.removeEventListener(MouseEvent.ROLL_OUT, rollOutSkinMoveHandler);
			_rollOverSkin = value;
			
			if(_rollOverSkin)
			{
				if(_rollOverSkin is InteractiveObject)
					(_rollOverSkin as InteractiveObject).mouseEnabled = false;
				if(_rollOverSkin is DisplayObjectContainer)
					(_rollOverSkin as DisplayObjectContainer).mouseChildren = false;
				
				//注意与backgroundDisplayObject的层次关系
				if(backgroundDisplayObject)
					sissi_internal::addChildAt(_rollOverSkin, 1);
				else
					sissi_internal::addChildAt(_rollOverSkin, 0);
				
				sissi_internal::contentGroup.addEventListener(MouseEvent.MOUSE_MOVE, rollOverSkinMoveHandler);
				sissi_internal::contentGroup.addEventListener(MouseEvent.ROLL_OUT, rollOutSkinMoveHandler);
				_rollOverSkin.visible = false;
			}
		}
		protected function rollOverSkinMoveHandler(event:MouseEvent):void
		{
		}
		
		protected function rollOutSkinMoveHandler(event:MouseEvent):void
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function VirtualGroup()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: LifeCycle
		//
		//--------------------------------------------------------------------------
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			
			setSelecetedItems();
		}
		/**
		 * 根据值返回itemIndex。
		 * @param itemValue
		 * @return 
		 */		
		protected function getItemIndexByItemValue(itemValue:*):int
		{
			var itemIndex:int = -1;
			for (var d:int = 0; d < length; d++) 
			{
				if(_dataProvider[d] == itemValue)
				{
					itemIndex = d;
					break;
				}
			}
			return itemIndex;
		}
		/**
		 * 统一由selectIndex来确定
		 * 如果selectItem传入，那么也是先计算其selectIndex然后来计算
		 */		
		protected function setSelecetedItems():void
		{
			if(explicitSelectItem)
				explicitSelectIndex = getItemIndexByItemValue(explicitSelectItem);
			
			if(explicitSelectIndex != -1)
			{
				//Reset
				if(trySelectedRender)
				{
					trySelectedRender.selected = false;
					trySelectedRender.currentState = TouchStates.NORMAL;
					trySelectedRender = null;
				}
				
				var contentGroup:DisplayObjectContainer = sissi_internal::contentGroup;
				//更改位置
				var contentGroupNumberChildren:int = contentGroup.numChildren;
				//不会出现_selectIndex和_selectItem都要判断的情况
				if(explicitSelectIndex != -1)
				{
					for (var i:int = 0; i < contentGroupNumberChildren; i++) 
					{
						var selectIndexItemRenderer:IListItemRenderer = contentGroup.getChildAt(i) as IListItemRenderer;
						if(selectIndexItemRenderer.itemIndex == explicitSelectIndex)
						{
							//New Get Renderer
							trySelectedRender = selectIndexItemRenderer;
							break;
						}
					}
				}
				//Reset
				if(trySelectedRender)
				{
					trySelectedRender.selected = true;
					trySelectedRender.currentState = TouchStates.NORMAL;
					
					_selectIndex = trySelectedRender.itemIndex;
					_selectItem = trySelectedRender.data;
				}
			}
			else
			{
				if(trySelectedRender)
				{
					trySelectedRender.selected = false;
					trySelectedRender.currentState = TouchStates.NORMAL;
					trySelectedRender = null;
				}
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(dataProviderChanged)
			{
				horizontalScrollPosition = verticalScrollPosition = 0;
				scrollPositionOrDataProviderChanged = true;
			}
				
			if(_itemRenderer == null)
			{
				var defaultFactory:ClassFactory = new ClassFactory(UITextFieldListItemRenderer);
				defaultFactory.properties = {width:200, height:22};
				_itemRenderer = defaultFactory;
			}
		}
		/**
		 * 测量出来的ItemRenderer宽度，高度
		 */		
		protected var measuredItemRendererWidth:Number;
		protected var measuredItemRendererHeight:Number;
		
		
		override protected function measure():void
		{
			var measuredItemRenderer:DisplayObject = _itemRenderer.newInstance();
			measuredItemRendererWidth = measuredItemRenderer.width;
			measuredItemRendererHeight = measuredItemRenderer.height;
			//由继承者去计算
			//measuredWidth
			//measuredHeight
		}
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			//数据改变，并且是虚拟时
			if(dataProviderChanged)
			{
				listDataProviderChanged = true;
				if(_useVirtualMode)
				{
					virtualChildren = new Vector.<VirtualItemRenderer>;
					var v:int = 0;
					while(v < length)
					{
						var virtualItemRenderer:VirtualItemRenderer = new VirtualItemRenderer();
						virtualItemRenderer.data = dataProvider[v];
						virtualItemRenderer.itemIndex = v;
						virtualChildren.push(virtualItemRenderer);
						v++;
					}
				}
				if(_useVirtualMode)
					layoutVirtualChildren();
				createNeededChildren();
				
				dataProviderChanged = false;
			}
		}
		/**
		 * 根据组件设定virtualItemRenderer的坐标
		 */		
		protected function layoutVirtualChildren():void
		{
			
		}
		/**
		 * dataProviderChanged指的是dataProvider的变化
		 * listDataProviderChanged指的是子组件是否要重新赋值
		 * 全部实例化的子组件，只要dataProviderChanged变更，那么子组件的值需要重新赋值变更
		 * 虚拟实例化的子组件，除了要dataProviderChanged变更，还要对目前显示组件与滚动条之间的关系来确定是否要重新赋值变更。
		 */		
		protected var listDataProviderChanged:Boolean;
		
		/**
		 * 根据组件本身的定义计算出需要的ItemRenderer总数
		 * @return 
		 */		
		protected function calculateNeededItemRendererCount():int
		{
			return 0;
		}
		
		/**
		 * 创建出组件需要的子对象
		 */		
		protected function createNeededChildren():void
		{
			var neededItemRendererCount:int = calculateNeededItemRendererCount();
			var contentGroup:DisplayObjectContainer = sissi_internal::contentGroup;
			if(itemRendererChanged)
			{
				while(contentGroup.numChildren > 0)
				{
					renderRemoved(contentGroup.removeChildAt(0));
				}
				while(contentGroup.numChildren < neededItemRendererCount)
				{
					renderAdded(contentGroup.addChild(itemRenderer.newInstance()));
				}
				itemRendererChanged = false;
			}
			else
			{
				//对相应的子控件进行监听
				if(contentGroup.numChildren == 0)
				{
					while(neededItemRendererCount > contentGroup.numChildren)
					{
						renderAdded(contentGroup.addChild(itemRenderer.newInstance()));
					}
				}
				else
				{
					if(neededItemRendererCount < contentGroup.numChildren)
					{
						while(neededItemRendererCount < contentGroup.numChildren)
						{
							renderRemoved(contentGroup.removeChildAt(0));
						}
					}
					else if(neededItemRendererCount > contentGroup.numChildren)
					{
						while(neededItemRendererCount > contentGroup.numChildren)
						{
							renderAdded(contentGroup.addChild(itemRenderer.newInstance()));
						}
					}
				}
			}
		}
		/**
		 * 增加各子控件的监听
		 * @param render 子控件
		 */		
		protected function renderAdded(render:DisplayObject):void
		{
			render.addEventListener(MouseEvent.MOUSE_DOWN, renderMouseDownHandler);
		}
		/**
		 * 去除各子控件的监听
		 * @param render 子控件
		 */	
		protected function renderRemoved(render:DisplayObject):void
		{
			render.removeEventListener(MouseEvent.MOUSE_DOWN, renderMouseDownHandler);
		}
		
		private var oldSelectedRender:IListItemRenderer;
		/**
		 * 选中的
		 */		
		private var trySelectedRender:IListItemRenderer;
		protected function renderMouseDownHandler(event:Event):void
		{
			//Reset
			oldSelectedRender = trySelectedRender;
			//New Get Renderer
			trySelectedRender = (event.currentTarget as IListItemRenderer);
			trySelectedRender.currentState = TouchStates.DOWN;
			
			//			addEventListener("scrolling", contentGroupScrolling);
		}
		
		//		/**
		//		 * Mobile use
		//		 * @param event
		//		 */		
		//		protected function contentGroupScrolling(event:Event):void
		//		{
		//			if(trySelectedRender)
		//			{
		//				trySelectedRender.selected = false;
		//				trySelectedRender.currentState = TouchStates.NORMAL;
		//				trySelectedRender = null;
		//			}
		//			removeEventListener("scrolling", contentGroupScrolling);
		//		}
		/**
		 * 
		 * @param event
		 */		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if(oldSelectedRender && trySelectedRender && trySelectedRender != oldSelectedRender)
			{
				oldSelectedRender.selected = false;
				oldSelectedRender.currentState = TouchStates.NORMAL;
			}
			if(trySelectedRender && (trySelectedRender.currentState == TouchStates.DOWN))
			{
				dispatchEvent(new ListItemEvent(ListItemEvent.ITEM_TOUCHED, trySelectedRender.itemIndex));
				trySelectedRender.selected = true;
				trySelectedRender.currentState = TouchStates.NORMAL;
				
				explicitSelectIndex = trySelectedRender.itemIndex;
				
				_selectIndex = trySelectedRender.itemIndex;
				_selectItem = trySelectedRender.data;
			}
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
		//------------------------------------------------
		//
		// override add, remove, set display children function
		//
		//------------------------------------------------
		override public function contains(child:DisplayObject):Boolean
		{
//			if(_useVirtualMode)
//			{
//				throw new Error("Not available for this Class.");
//				return false;
//			}
//			else
//			{
				return super.contains(child);
//			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
				return null;
			}
			else
			{
				return super.addChild(child);
			}
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
				return null;
			}
			else
			{
				return super.addChildAt(child, index);
			}
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
				return null;
			}
			else
			{
				return super.removeChild(child);
			}
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
				return null;
			}
			else
			{
				return super.removeChildAt(index);
			}
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
			}
			else
			{
				return super.setChildIndex(child, index);
			}
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
				return null;
			}
			else
			{
				return super.getChildAt(index);
			}
			
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
				return null;
			}
			else
			{
				return super.getChildByName(name);
			}
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			if(_useVirtualMode)
			{
				throw new Error("Not available for this Class.");
				return -1;
			}
			else
			{
				return super.getChildIndex(child);
			}
		}
		
		override public function get numChildren():int
		{
			if(_useVirtualMode)
			{
				return 0;
			}
			else
			{
				return super.numChildren;
			}
//			throw new Error("Not available for this Class.");
		}
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
	}
}