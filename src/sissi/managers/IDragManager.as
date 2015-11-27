package sissi.managers
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import sissi.core.DragSource;

	public interface IDragManager
	{
		/**
		 * 是否正在拖动。
		 * @return 
		 */		
		function get isDragging():Boolean;
		
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
		function doDrag(dragInitiator:DisplayObject,
						dragSource:DragSource,
		                mouseEvent:MouseEvent,
		                dragImage:DisplayObject = null,
		                xOffset:Number = 0,
		                yOffset:Number = 0,
		                imageAlpha:Number = 0.7,
						imageScale:Number = 1.0):void;
		
		/**
		 * 是否能够接受拖动物体的数据。
		 * @param target
		 */		
		function acceptDragDrop(target:DisplayObject):void;
		
		/**
		 * 停止拓动。
		 */		
		function endDrag():void;
	}
}