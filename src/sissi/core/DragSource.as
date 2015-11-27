package sissi.core
{
	public class DragSource
	{
		public function DragSource()
		{
			super();
		}
		
		private var dataHolder:Object = {};	
		private var formatHandlers:Object = {};
		private var _formats:Array /* of String */ = [];
		public function get formats():Array /* of String */
		{
			return _formats;
		}
		public function addData(data:Object, format:String):void
		{
			_formats.push(format);
			
			dataHolder[format] = data;
		}
		public function addHandler(handler:Function,
								   format:String):void
		{
			_formats.push(format);
			
			formatHandlers[format] = handler;
		}
		public function dataForFormat(format:String):Object
		{
			var data:Object = dataHolder[format];
			if (data)
				return data;
			
			if (formatHandlers[format])
				return formatHandlers[format]();
			
			return null;
		}
		public function hasFormat(format:String):Boolean
		{
			var n:int = _formats.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_formats[i] == format)
					return true;
			}
			
			return false;
		}
	}
}