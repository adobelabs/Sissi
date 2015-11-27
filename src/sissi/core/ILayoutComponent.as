package sissi.core
{
	public interface ILayoutComponent
	{
		//----------------------------------
		//  x
		//----------------------------------
		/**
		 * 坐标X
		 * @return 
		 */		
		function get x():Number;
		function set x(value:Number):void;
		
		//----------------------------------
		//  y
		//----------------------------------
		/**
		 * 坐标Y
		 * @return 
		 */		
		function get y():Number;
		function set y(value:Number):void;
		
		function move(toX:Number, toY:Number):void;
		
		
		
			
			
		//----------------------------------
		//  width
		//----------------------------------
		function get explicitWidth():Number;
		function set explicitWidth(value:Number):void;
		
		function get measuredWidth():Number;
		function set measuredWidth(value:Number):void;
		/**
		 * 宽度
		 * @return 
		 */		
		function get width():Number;
		function set width(value:Number):void;
		
		//----------------------------------
		//  height
		//----------------------------------
		function get explicitHeight():Number;
		function set explicitHeight(value:Number):void;
		
		function get measuredHeight():Number;
		function set measuredHeight(value:Number):void;
		/**
		 * 高度
		 * @return 
		 */		
		function get height():Number;
		function set height(value:Number):void;
		
		function setSize(widthValue:Number, heightValue:Number):void;
		//----------------------------------
		//  top
		//----------------------------------
		/**
		 * 离顶部为多少距离
		 * 如果同时设置bottom，则会忽略设置的高度height
		 * @return 
		 */		
		function get top():Number;
		function set top(value:Number):void;
		
		//----------------------------------
		//  bottom
		//----------------------------------
		/**
		 * 离底部为多少距离
		 * 如果同时设置top，则会忽略设置的高度height
		 * @return 
		 */		
		function get bottom():Number;
		function set bottom(value:Number):void;
		
		//----------------------------------
		//  left
		//----------------------------------
		/**
		 * 离左边为多少距离
		 * 如果同时设置right，则会忽略设置的高度width
		 * @return 
		 */		
		function get left():Number;
		function set left(value:Number):void;
		
		//----------------------------------
		//  right
		//----------------------------------
		/**
		 * 离右边为多少距离
		 * 如果同时设置left，则会忽略设置的高度width
		 * @return 
		 */		
		function get right():Number;
		function set right(value:Number):void;
		
		//----------------------------------
		//  horizontalCenter
		//----------------------------------
		/**
		 * 如果设置为0，则横向居中，有设置，会忽略x, left, right等。
		 * @return 
		 */		
		function get horizontalCenter():Number;
		function set horizontalCenter(value:Number):void;
		
		//----------------------------------
		//  verticalCenter
		//----------------------------------
		/**
		 * 如果设置为0，则竖向居中，有设置，会忽略y, top, bottom等。
		 * @return 
		 */		
		function get verticalCenter():Number;
		function set verticalCenter(value:Number):void;
	}
}