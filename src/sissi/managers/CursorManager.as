package sissi.managers
{
	import flash.display.DisplayObject;

	public class CursorManager
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		private static var _impl:ICursorManager;
		private static function get impl():ICursorManager
		{
			if (!_impl)
			{
				_impl = new CursorManagerImpl();
			}
			
			return _impl;
		}
		
		//------------------------------------------------------------------------------
		//
		//  Class Method
		//
		//-----------------------------------------------------------------------------
		/**
		 *  生成光标 
		 */	
		public static function setCurrentCursor(customCursor:DisplayObject, xOffset:Number = 0, yOffset:Number = 0):void
		{
			return impl.setCurrentCursor(customCursor, xOffset, yOffset);
		}
		/**
		 * 从光标列表上移除光标
		 */	
		public static function setDefaultCursor():void
		{
			impl.setDefaultCursor();
		}
	}
}