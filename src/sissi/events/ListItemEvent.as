package sissi.events
{
	import flash.events.Event;
	
	public class ListItemEvent extends Event
	{
		public static const ITEM_TOUCHED:String = "itemTouched";
		public static const COMBOBOX_VALUE_CHANGED:String = "comboBoxValueChanged";
		
		public function ListItemEvent(type:String, listItemIndex:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.itemIndex = listItemIndex;
			super(type, bubbles, cancelable);
		}
		
		public var itemIndex:int;
		override public function clone():Event
		{
			var event:ListItemEvent = new ListItemEvent(this.type, this.itemIndex, this.bubbles, this.cancelable);
			return event;
		}
	}
}