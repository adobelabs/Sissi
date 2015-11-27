package sissi.components.pagerClasses
{
	public interface IPagerItemRenderer
	{
		function set pageIndex(value:int):void
		
		function get pageIndex():int
		
		function setSelected(b:Boolean):void
	}
}