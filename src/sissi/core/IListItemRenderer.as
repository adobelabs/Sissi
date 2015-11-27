package sissi.core
{

	public interface IListItemRenderer extends IDataRenderer
	{
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		function get itemIndex():int;
		function set itemIndex(value:int):void;
		
		//touchDown可以在这里做highlight的操作。
		//也是是否可以触发touched事件的判断。
		function get currentState():String;
		function set currentState(value:String):void;
	}
}