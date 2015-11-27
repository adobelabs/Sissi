package sissi.events
{
	import flash.events.Event;
	
	public class SissiEvent extends Event
	{
		public static const BUTTON_DOWN:String = "buttonDown";
		
		public function SissiEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var cloneEvent:SissiEvent = new SissiEvent(type, bubbles, cancelable);
			return cloneEvent;
		}
	}
}