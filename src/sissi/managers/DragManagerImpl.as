package sissi.managers
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import sissi.core.Application;
	import sissi.core.DragSource;
	import sissi.core.IApplication;
	import sissi.core.SissiManager;
	import sissi.managers.dragClasses.DragProxy;
	
	public class DragManagerImpl implements IDragManager
	{
		public function DragManagerImpl()
		{
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * 拖动目标。
		 */		
		private var dragInitiator:DisplayObject;
		
		/**
		 * 拖动代理。
		 * 存放数据和显示图像。
		 */		
		private var dragProxy:DragProxy;
		
		/**
		 * 主程序。
		 */		
		private function get application():IApplication
		{
			return Application.application
		}

		/**
		 * 是否正在拖动。
		 * @return 
		 */		
		public function get isDragging():Boolean
		{
			if(dragProxy)
				return dragProxy.bDoingDrag;
			return false;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 进行拖动。
		 * @param dragInitiator 拖动目标
		 * @param dragSource 拖动数据
		 * @param mouseEvent 拖动鼠标事件
		 * @param dragImage 拖动图像
		 * @param xOffset 偏移坐标
		 * @param yOffset 偏移坐标
		 * @param imageAlpha 图像透明度。
		 */		
		public function doDrag(dragInitiator:DisplayObject, 
							   dragSource:DragSource, 
							   mouseEvent:MouseEvent,
							   dragImage:DisplayObject = null,
							   xOffset:Number = 0,
							   yOffset:Number = 0,
							   imageAlpha:Number = 0.7,
							   imageScale:Number = 1.0):void
		{		
			//如果已经在拖动中了，不能再拖动别的
			if (dragProxy && dragProxy.bDoingDrag)
				return;
			//鼠标必须按下状态
			if (!(mouseEvent.type == MouseEvent.MOUSE_DOWN ||
				mouseEvent.type == MouseEvent.CLICK ||
				mouseEvent.buttonDown))
			{
				return;
			}
			
			this.dragInitiator = dragInitiator;	
			dragProxy = new DragProxy(dragInitiator, dragSource, mouseEvent, dragImage, xOffset, yOffset, imageAlpha, imageScale);
			
			//先加入到显示列表里面以此进行事件的监听。
			if(application)
			{
				application.addPopUpChild(dragProxy);
			}
			else
			{
				if(dragInitiator.stage)
					dragInitiator.stage.addChild(dragProxy);
			}
		}

		/**
		 * 是否能够接受拖动物体的数据。
		 * @param target
		 */		
		public function acceptDragDrop(target:DisplayObject):void
		{
			if(dragProxy)
				dragProxy.target = target as DisplayObject;
		}
		
		/**
		 * 停止拓动。
		 */		
		public function endDrag():void
		{
			if(dragProxy)
			{
				if(application)
				{
					if(application.containsPopUpChild(dragProxy))
						application.removePopUpChild(dragProxy);
				}
				else
				{
					if(dragInitiator.stage && dragInitiator.stage.contains(dragProxy))
						dragInitiator.stage.removeChild(dragProxy);
				}
				
				dragProxy.removeChildren();
				dragProxy = null;
			}
			dragInitiator = null;
		}
	}	
}