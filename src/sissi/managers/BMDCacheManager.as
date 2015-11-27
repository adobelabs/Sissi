package sissi.managers
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * 位图数据缓存管理器。
	 * 保证在内存当中，同一个位图数据缓存只保留一份。
	 * 适用于多个显示对象使用同一个位图数据的管理。
	 * @author Alvin
	 */	
	public class BMDCacheManager
	{
		private static var cache:Dictionary = new Dictionary();
		/**
		 * 拿到位图数据。
		 * @param cls 位图类
		 * @return 位图数据
		 */		
		public static function getBMD(cls:Class):BitmapData
		{
			if(!cache[cls])
			{
				cache[cls] = new cls();
			}
			return cache[cls];
		}
		
		/**
		 * 删除相应的位图数据
		 * @param cls 位图类
		 */		
		public static function deleteBMD(cls:Class):void
		{
			if(cache[cls])
			{
				delete cache[cls];
			}
		}
	}
}