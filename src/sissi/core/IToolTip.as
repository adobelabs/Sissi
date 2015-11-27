package sissi.core
{
	public interface IToolTip extends IDataRenderer
	{
		//----------------------------------
		//  x
		//----------------------------------
		/**
		 * The x position of this component.
		 */
		function get x():Number;
		/**
		 * @private
		 */
		function set x(value:Number):void;
		
		//----------------------------------
		//  y
		//----------------------------------
		/**
		 * The y position of this component.
		 */
		function get y():Number;
		/**
		 * @private
		 */
		function set y(value:Number):void;
	}
}