package sissi.components
{
	import flash.events.MouseEvent;
	
	import sissi.core.UIGroup;
	import sissi.layouts.HorizontalLayout;
	
	public class HGroup extends UIGroup
	{
		public function HGroup()
		{
			super();
			layout = new HorizontalLayout();
		}
		
		//----------------------------------
		//  enableMouseWheel
		//----------------------------------
		private var _enableMouseWheel:Boolean;
		public function get enableMouseWheel():Boolean
		{
			return _enableMouseWheel;
		}
		public function set enableMouseWheel(value:Boolean):void
		{
			_enableMouseWheel = value;
			if(_enableMouseWheel)
			{
				this.addEventListener(MouseEvent.MOUSE_WHEEL, handlecontentGroupMouseWheel);
				this.hScrollSize = 20;
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, handlecontentGroupMouseWheel);
			}
		}
		
		/**
		 * 对ContentGroup，在鼠标滚动时进行监听。
		 * @param event MouseEvent.MouseWheel
		 */		
		protected function handlecontentGroupMouseWheel(event:MouseEvent):void
		{
			if(this.horizontalScrollEnable)
			{
				this.verticalScrollPosition -= event.delta * this.vScrollSize;
			}
//			else if(this.horizontalScrollEnable)
//			{
//				this.horizontalScrollPosition -= event.delta * this.hScrollSize;
//			}
		}
		
//		override protected function measure():void
//		{
//			layout.measure();
//		}
//		
//		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
//		{
//			super.updateDisplayList(unscaledWidth, unscaledHeight);
//			layout.layoutContents(this);
//		}
	}
}