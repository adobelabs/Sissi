package sissi.components.supportClasses
{
	import flash.text.TextFormat;
	
	import sissi.core.IListItemRenderer;
	import sissi.core.UITextField;
	
	public class UITextFieldListItemRenderer extends UITextField implements IListItemRenderer
	{
		public function UITextFieldListItemRenderer(textFormat:TextFormat=null, textStroke:Array=null, textValue:String="", isHTML:Boolean=false)
		{
			super(textFormat, textStroke, textValue, isHTML);
		}
		
		private var _selected:Boolean;
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			value ? color = 0xFF0000 : color = 0;
			_selected = value;
		}
		
		private var _itemIndex:int;
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
		
		private var _currentState:String;
		public function get currentState():String
		{
			return _currentState;
		}
		public function set currentState(value:String):void
		{
			_currentState = value;
		}
		
		public function get data():Object
		{
			return text;
		}
		public function set data(value:Object):void
		{
			text = value.toString();
		}
	}
}