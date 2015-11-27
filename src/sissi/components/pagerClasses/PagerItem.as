package sissi.components.pagerClasses
{
	import flash.text.TextFormat;
	
	import sissi.components.Label;
	
	public class PagerItem extends Label implements IPagerItemRenderer
	{
		public function PagerItem(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super(textFormat, textStroke, textValue, isHTML);
		}
		
		
		//----------------------------------
		// pageIndex
		//----------------------------------
		private var _pageIndex:int = -1;
		public function set pageIndex(value:int):void
		{
			if(_pageIndex != value)
			{
				_pageIndex = value;
				text = (_pageIndex + 1).toString();
			}
		}
		public function get pageIndex():int
		{
			return _pageIndex;
		}
		
		//----------------------------------
		//  Set PagerItem selected
		//----------------------------------
		public function setSelected(b:Boolean):void
		{
			color = b ? 0xFF0000 : 0x000000;
//			if(b)
//				setStyle("color", 0x000000);
//			else
//				setStyle("color", 0x0000FF);
		}
	}
}