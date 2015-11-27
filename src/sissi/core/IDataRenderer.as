package sissi.core
{
	public interface IDataRenderer
	{
		//----------------------------------
		//  data
		//----------------------------------
		/**
		 * The data to render or edit.
		 */
		function get data():Object;
		/**
		 * @private
		 */
		function set data(value:Object):void;
	}
}