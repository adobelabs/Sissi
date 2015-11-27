package sissi.core
{
	import sissi.layouts.supportClasses.LayoutBase;
	

	public interface IUIGroup extends IUIComponent
	{
		//-------------------------
		// verticalScrollEnable
		//-------------------------
		function get verticalScrollEnable():Boolean;
		function set verticalScrollEnable(value:Boolean):void;
		
		//-------------------------
		// horizontalScrollEnable
		//-------------------------
		function get horizontalScrollEnable():Boolean;
		function set horizontalScrollEnable(value:Boolean):void;
		
		//-------------------------
		// horizontalScrollPosition
		//-------------------------
		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		
		//-------------------------
		// maxHorizontalScrollPosition
		//-------------------------
		function get maxHorizontalScrollPosition():Number;
		
		//-------------------------
		// verticalScrollPosition
		//-------------------------
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		//-------------------------
		// maxVerticalScrollPosition
		//-------------------------
		function get maxVerticalScrollPosition():Number;
		
		//-------------------------
		// contentGroup
		//-------------------------
//		function get contentGroup():UIComponent;
		
		//-------------------------
		// background
		//-------------------------
		function get background():Boolean;
		function set background(value:Boolean):void;
			
		//-------------------------
		// layout
		//-------------------------
		function get layout():LayoutBase;
		function set layout(value:LayoutBase):void;
	}
}