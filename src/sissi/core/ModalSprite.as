package sissi.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ModalSprite extends Sprite
	{
		public function ModalSprite()
		{
			super();
			var bitmap:Bitmap = new Bitmap(new BitmapData(1, 1, false, 0x111111));
			addChild(bitmap);
			alpha = 0.4;
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		/**
		 * 添加到舞台上的时候进行居中操作。
		 * @param event
		 */		
		private function handleAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			if(SissiManager.sissiManager)
				SissiManager.sissiManager.stage.addEventListener(Event.RESIZE, handleResize);
			
			handleResize();
		}
		
		/**
		 * 移除舞台的时候，进行事件的销毁。
		 * @param event
		 */		
		protected function handleRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
			if(SissiManager.sissiManager)
				SissiManager.sissiManager.stage.removeEventListener(Event.RESIZE, handleResize);
		}
		
		/**
		 * 居中。
		 * @param event
		 */		
		protected function handleResize(event:Event = null):void
		{
			if(SissiManager.sissiManager)
			{
				width =  SissiManager.sissiManager.stage.stageWidth;
				height =  SissiManager.sissiManager.stage.stageHeight;
			}
		}
	}
}