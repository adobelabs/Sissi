package sissi.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sissi.core.DragSource;

	public class DragEvent extends MouseEvent
	{
		/**
		 *  对dragInitiator的定义，拖动开始
		 */		
		public static const DRAG_START:String = "dragStart";
		/**
		 * 对dragInitiator的定义，拖动结束
		 */		
		public static const DRAG_COMPLETE:String = "dragComplete";
		/**
		 * 对target的定义，拖拽物品的目标容器
		 */		
		public static const DRAG_DROP:String = "dragDrop";
		
		/**
		 * 在目标容器dropTarget上进行发布DRAG_ENTER事件
		 */		
		public static const DRAG_ENTER:String = "dragEnter";
		/**
		 * 对旧容器oldTarget的定义，拖动离开
		 */		
		public static const DRAG_EXIT:String = "dragExit";
		/**
		 * 在目标容器dropTarget上进行DRAG_OVER
		 */		
		public static const DRAG_OVER:String = "dragOver";
		

		public function DragEvent(type:String,
								  dragInitiator:DisplayObject = null, dragSource:DragSource = null,
								  bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			
			this.dragInitiator= dragInitiator;
			this.dragSource = dragSource;
		}
		
		public var dragInitiator:DisplayObject;
		public var dragSource:DragSource;
		
        override public function clone():Event
		{
			var cloneEvent:DragEvent =new DragEvent(type, dragInitiator, dragSource, bubbles, cancelable);
			return cloneEvent;
		}
	}
}