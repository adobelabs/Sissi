package sissi.managers
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import sissi.core.DragSource;
	import sissi.core.IUIComponent;

	public class DragManager
	{
		private static var _impl:IDragManager;
		
		private static function get impl():IDragManager
		{
			if(!_impl)
				_impl = new DragManagerImpl();
			return _impl;
		}

		
		
		//----------------------------------
		//  isDragging
		//----------------------------------
		/**
		 * 是否正在拖动。
		 * @return 
		 */		
        public static function get isDragging():Boolean
		{
			return impl.isDragging;
		}
		
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
		public static function doDrag(dragInitiator:DisplayObject,
					                  dragSource:DragSource,
		                              mouseEvent:MouseEvent,
		                              dragImage:DisplayObject = null,
									  xOffset:int = 0,
									  yOffset:int = 0,
					                  imageAlpha:Number = 0.7,
									  imageScale:Number = 1.0):void
		{
			impl.doDrag(dragInitiator, dragSource, mouseEvent, dragImage, xOffset, yOffset, imageAlpha, imageScale);
		}


		/**
		 * 是否能够接受拖动物体的数据。
		 * @param target
		 */		
		public static function acceptDragDrop(target:DisplayObject):void
		{
			impl.acceptDragDrop(target);
		}
		
		/**
		 * 停止拓动。
		 */		
		public static function endDrag():void
		{
			impl.endDrag();
		}
	}
}