package sissi.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Mouse;
	import flash.utils.getQualifiedClassName;
	
	import sissi.core.Application;
	
	/**
	 * 鼠标样式控制器。
	 * @author Monster
	 */	
	public class CursorManagerImpl implements ICursorManager
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CursorManagerImpl()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//-------------------------------------------------------------------------
		//----------------------------------
		//  currentCursor
		//----------------------------------
		private var currentCursor:DisplayObject;
		
		/**
		 * 是否为其他光标。
		 */		
		private var isCustomCursor:Boolean;
		
		//----------------------------------
		//  application
		//----------------------------------
		/**
		 * 主程序。
		 */		
		private var application:Application;
		
		//----------------------------------
		//  xyOffset
		//----------------------------------
		private var xOffset:Number = 0;
		private var yOffset:Number = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 新建一个光标，并且设置可选优先级。
		 *  将新创建的光标加入光标列表。  
		 * @param customCursor  显示的光标
		 * @param xOffset      x的偏移量
		 * @param yOffset      y的偏移量
		 */		
		public function setCurrentCursor(customCursor:DisplayObject, xOffset:Number = 0, yOffset:Number = 0):void
		{
			//如果存在，先判断是否与当前相同，如果相同则返回，如果不同，则删除原来的，添加新的。
			if(currentCursor)
			{
				//				if(getQualifiedClassName(currentCursor) == getQualifiedClassName(customCursor))
				//				{
				//					trace("setCurrentCursor RETURN");
				//					return;
				//				}
				if(currentCursor.parent)
					currentCursor.parent.removeChild(currentCursor);
				currentCursor = null;
			}
			//获得引用。
			application = Application.application;
			
			//生成新的显示物件。
			currentCursor = customCursor;
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			
			//系统光标，隐藏它
			Mouse.hide();
			
			//如果当前的光标被改变
			if(currentCursor is InteractiveObject)
			{
				InteractiveObject(currentCursor).mouseEnabled = false;
			}
			if(currentCursor is DisplayObjectContainer)
			{
				DisplayObjectContainer(currentCursor).mouseChildren = false;
			}
			
			//添加到显示列表。
			//			application.addCursorChild(currentCursor);
			application.stage.addChild(currentCursor);
			
			//改变位置。
			currentCursor.x = (application as DisplayObject).mouseX - xOffset;
			currentCursor.y = (application as DisplayObject).mouseY - yOffset;
			
			//监听鼠标移动时候的处理。
			application.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			isCustomCursor = true;
		}
		
		/**
		 * 从光标列表上移除一个光标 
		 * 假如移除的是当前正在显示的光标，那么如果光标列表中还有光标，则显示刚删除的下一个，
		 * 如果光标列表空了，则显示系统光标
		 */	
		public function setDefaultCursor():void
		{
			if(isCustomCursor)
			{
				if(currentCursor && currentCursor.parent)
					currentCursor.parent.removeChild(currentCursor);
				currentCursor = null;
				
				if(application)
				{
					application.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					application = null;
				}
				
				Mouse.show();
				
				isCustomCursor = false;
			}
		}
		
		/**
		 *  @private
		 */
		private var overTextField:Boolean = false;
		/**
		 *  @private
		 */
		private var showSystemCursor:Boolean = false;
		
		/**
		 *  @private
		 */
		private var showCustomCursor:Boolean = false;
		/**
		 * 鼠标移动。
		 * @param event
		 */		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			currentCursor.x = (application as DisplayObject).mouseX - xOffset;
			currentCursor.y = (application as DisplayObject).mouseY - yOffset;
			event.updateAfterEvent();
			
			var target:Object = event.target;
			// Do target test.
			if (target is TextField && target.type == TextFieldType.INPUT)
				showCustomCursor = false;
			else
				showCustomCursor = true;
			
			if (showCustomCursor)
			{
				currentCursor.visible = true;
				Mouse.hide();
			}
			else
			{
				currentCursor.visible = false;
				Mouse.show();
			}
		}
	}
}
