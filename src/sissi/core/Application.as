package sissi.core
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import sissi.managers.ToolTipManager;
	
	use namespace sissi_internal;
	
	/**
	 * Application
	 * @author Alvin.Ju
	 */	
	public class Application extends UIComponent implements IApplication
	{
		/**
		 * Application 单例自己。
		 */		
		public static var application:Application;
		
		
		/**
		 * Application 构造函数。
		 */		
		public function Application()
		{
			super();
			if(application)
			{
				throw new Error('Application 是唯一的，');
				return;
			}
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		private function handleAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			initialize();
			visible = true;
			application = this;
		}
		
		/**
		 * 实际内容层级.
		 */		
		sissi_internal var contentLayer:UIComponent = new UIComponent();
		/**
		 * PopUpManage, DragManager添加对象的层级.
		 */		
		sissi_internal var popUpLayer:UIComponent;
		/**
		 * ToolTip 的层级.
		 */		
		sissi_internal var toolTipLayer:UIComponent;
		
		private var mouseCatcher:Shape;
		/**
		 * Application 创建子对象。
		 * 实际内容层级
		 * Pop层级
		 * ToolTip层级
		 */		
		override protected function createChildren():void
		{
			if(!mouseCatcher)
			{
				mouseCatcher = new Shape();
				super.addChildAt(mouseCatcher, 0);
				mouseCatcher.visible = false;
				mask = mouseCatcher;
			}
			if(!super.contains(contentLayer))
			{
				super.addChild(contentLayer);
			}
			if(!popUpLayer)
			{
				popUpLayer = new UIComponent();
				super.addChild(popUpLayer);
			}
			if(!toolTipLayer)
			{
				toolTipLayer = new UIComponent();
				toolTipLayer.mouseEnabled = toolTipLayer.mouseChildren = false;
				super.addChild(toolTipLayer);
				
				ToolTipManager.registerToolTipLayer(toolTipLayer);
			}
		}
		
		override protected function measure():void
		{
			measuredWidth = 1000;
			measuredHeight = 600;
		}
			
		/**
		 * 若Application改变大小，则更新其他大小。
		 */		
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			if(mouseCatcher)
			{
				try
				{
					var g:Graphics = mouseCatcher.graphics;
					g.clear();
					g.beginFill(0xFFFFFF * Math.random(), 1);
					g.drawRect(0, 0, unscaledWidth, unscaledHeight);
					g.endFill();
				}
				catch(e:Error)
				{
				}
			}
			
			contentLayer.setSize(unscaledWidth, unscaledHeight);
			popUpLayer.setSize(unscaledWidth, unscaledHeight);
			toolTipLayer.setSize(unscaledWidth, unscaledHeight);
			
			
			if(popUpLayer.numChildren)
			{
				for(var i:int = 0; i<popUpLayer.numChildren; i++)
				{
					var popChild:DisplayObject = popUpLayer.getChildAt(i);
					if(modalDic[popChild])
					{
						popChild.x = (unscaledWidth - popChild.width)/2;
						popChild.y = (unscaledHeight - popChild.height)/2;
					}
				}
			}
		}
		
		
		//------------------------------------------------
		//
		// Public Method
		//
		//------------------------------------------------
		
		//添加对象到PopUpChild层上
		public function addPopUpChild(child:DisplayObject, modal:Boolean = false):void
		{
			if(!modalDic)
			{
				modalDic = new Dictionary();
			}
			if(modal)
			{
				var modalSprite:ModalSprite;
				if(modalDic[child])
				{
					modalSprite = modalDic[child];	
				}
				else
				{
					modalSprite = new ModalSprite();
					modalDic[child] = modalSprite;
				}
				popUpLayer.addChild(modalSprite);
			}
			popUpLayer.addChild(child);
		}
		
		private var modalDic:Dictionary;
		
		public function removePopUpChild(child:DisplayObject):void
		{
			if(popUpLayer.contains(child))
			{
//				var childIndex:int = popUpLayer.getChildIndex(child);
//				var tryModalIndex:int = childIndex - 1 > 0 ? childIndex - 1 : 0;
				//检查最上层的是否为modalSprite元素，如果是，则自动移除。
				if(modalDic[child])
				{
					popUpLayer.removeChild(modalDic[child]);
				}
//				if(popUpLayer.getChildAt(tryModalIndex) is ModalSprite)
//				{
//					popUpLayer.removeChildAt(tryModalIndex);
//				}
//				
				popUpLayer.removeChild(child);
			}
		}
		
		public function containsPopUpChild(child:DisplayObject):Boolean
		{
			return popUpLayer && popUpLayer.contains(child);
		}
		
		//------------------------------------------------
		//
		// override width, height, setSize, add, remove, set display children function
		//
		//------------------------------------------------
//		private var _width:Number = 0;
//		override public function get width():Number
//		{
//			return _width;
//		}
//		override public function set width(value:Number):void
//		{
//			if(_width != value)
//			{
//				_width = value;
//				invalidateDisplayList();
//			}
//		}
//		
//		private var _height:Number;
//		override public function get height():Number
//		{
//			return _height;
//		}
//		override public function set height(value:Number):void
//		{
//			if(_height != value)
//			{
//				_height = value;
//				invalidateDisplayList();
//			}
//		}
		
		override public function set mouseEnabled(value:Boolean):void
		{
			super.mouseEnabled = contentLayer.mouseEnabled = value;
		}
		
		override public function contains(child:DisplayObject):Boolean
		{
			return contentLayer.contains(child);
		}
		override public function addChild(child:DisplayObject):DisplayObject
		{
			contentLayer.addChild(child);
			return child;
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			contentLayer.addChildAt(child, index);
			return child;
		}
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			contentLayer.removeChild(child);
			return child;
		}
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = contentLayer.removeChildAt(index);
			return child;
		}
		override public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			contentLayer.removeChildren(beginIndex, endIndex);
		}
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			contentLayer.setChildIndex(child, index);
		}
		override public function getChildAt(index:int):DisplayObject
		{
			return contentLayer.getChildAt(index);
		}
		override public function getChildByName(name:String):DisplayObject
		{
			return contentLayer.getChildByName(name);
		}
		override public function getChildIndex(child:DisplayObject):int
		{
			return contentLayer.getChildIndex(child);
		}
		override public function get numChildren():int
		{
			return contentLayer.numChildren;
		}
		
		sissi_internal function get numChildren():int
		{
			return super.numChildren;
		}
		sissi_internal function contains(child:DisplayObject):Boolean
		{
			return super.contains(child);
		}
		sissi_internal function addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		sissi_internal function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}
		
		sissi_internal function removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		sissi_internal function removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		sissi_internal function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			return super.removeChildren(beginIndex, endIndex);
		}
		sissi_internal function setChildIndex(child:DisplayObject, index:int):void
		{
			return super.setChildIndex(child, index);
		}
		sissi_internal function getChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index);
		}
		sissi_internal function getChildByName(name:String):DisplayObject
		{
			return super.getChildByName(name);
		}
		sissi_internal function getChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child);
		}
	}
}