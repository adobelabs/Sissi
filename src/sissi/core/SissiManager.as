package sissi.core
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import sissi.managers.LayoutManager;

	use namespace sissi_internal;
	public class SissiManager
	{
		private static var _sissiManager:DisplayObject;
		/**
		 * 注册系统
		 * 一般传入的为永久在显示列表，最顶层的对象
		 * @param system
		 */		
		public static function set sissiManager(topDisplayObject:DisplayObject):void
		{
			_sissiManager = topDisplayObject;
		}
		public static function get sissiManager():DisplayObject
		{
			return _sissiManager
		}
		
		private static var _layoutManager:LayoutManager;
		public static function get layoutManager():LayoutManager
		{
			if(!_layoutManager)
			{
				_layoutManager = new LayoutManager();
			}
			return _layoutManager;
		}
		
		private static var _stage:Stage;
		/**
		 * 优先获得对象自己的stage
		 * 如果没有，则试探是否在SissiFramework的Application下，返回Application的stage
		 * @param displayObject
		 * @return 
		 */		
		public static function getStage(displayObject:DisplayObject):Stage
		{
			if(displayObject.stage)
				return displayObject.stage;
			
			if(_stage)
				return _stage;
			
			if(_sissiManager && _sissiManager.stage)
			{
				_stage = sissiManager.stage;
				return _sissiManager.stage;
			}
			return null;
		}
		
		sissi_internal static var callLaterDispatcherCount:int = 0;
		sissi_internal static var catchCallLaterExceptions:Boolean = false;
		/**
		 * 在用Tween进行width属性等赋值的时候会跑layoutManager
		 * 如果Tween的过程中不需要关心属性的变更，那么应该再Tween完成之后才进行一次画面更新
		 * 因此在Tween之前suspendBackgroundProcessing()
		 * Tween结束之后resumeBackgroundProcessing()
		 */		
		sissi_internal static var callLaterSuspendCount:int = 0;
		public static function suspendBackgroundProcessing():void
		{
			callLaterSuspendCount++;
		}
		public static function resumeBackgroundProcessing():void
		{
			if (callLaterSuspendCount > 0)
			{
				callLaterSuspendCount--;
				
				// Once the suspend count gets back to 0, we need to
				// force a render event to happen
				if (callLaterSuspendCount == 0)
				{
					if (_sissiManager && _sissiManager.stage)
						_sissiManager.stage.invalidate();
				}
			}
		}
	}
}