package  sissi.events
{
	import flash.events.Event;
	
	/**
	 * PagerEvent
	 * @blog http://blog.richmediaplus.com
	 * @author Alvin / Aedis.Ju
	 */    
	public class PagerEvent extends Event
	{
		public static const PAGE_INDEX_CHANGED:String = "pageIndexChanged";
		
		public var pageIndex:int;
		
		public function PagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}