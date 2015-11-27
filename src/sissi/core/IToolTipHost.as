package sissi.core
{
	public interface IToolTipHost
	{
		//----------------------------------
		//  toolTip
		//----------------------------------
		/**
		 * The value of this component's tooltip.
		 */
		function get toolTip():*;
		/**
		 * @private
		 */
		function set toolTip(value:*):void;
		
		//----------------------------------
		//  toolTipClass
		//----------------------------------
		/**
		 * The class of this component's tooltip.
		 */
		function get toolTipClass():Class;
		/**
		 * @private
		 */
		function set toolTipClass(value:Class):void;
		
		//----------------------------------
		//  toolTipPositionFunction
		//----------------------------------
		/**
		 * The class of this component set tooltip's position.
		 */
		function get toolTipPosition():*;
		/**
		 * @private
		 */
		function set toolTipPosition(value:*):void;
		
		//----------------------------------
		//  toolTipPositionFunction
		//----------------------------------
		/**
		 * The class of this component set tooltip's position.
		 */
		function get toolTipShapeFlag():Boolean;
		/**
		 * @private
		 */
		function set toolTipShapeFlag(value:Boolean):void;
	}
}