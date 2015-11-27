package sissi.interaction
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import sissi.components.List;
	import sissi.core.sissi_internal;
	import sissi.interaction.supportClasses.IInterAction;
	
	public class ListInterAction implements IInterAction
	{
		public function ListInterAction(hostComponent:List)
		{
			this._hostComponent = hostComponent;
			this._contentGroup = hostComponent.sissi_internal::contentGroup;
			this._direction = _hostComponent.layout.direction;
		}
		
		/**
		 * 是否已经激活
		 **/
		private var _isActive:Boolean;
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		public function active():void
		{
			if(!_isActive)
			{
				_isActive = true;
				if(_hostComponent.enableMouseWheel)
					_hostComponent.addEventListener(MouseEvent.MOUSE_WHEEL, handlecontentGroupMouseWheel);
			}
		}
		
		public function deactive():void
		{
			_hostComponent.removeEventListener(MouseEvent.MOUSE_WHEEL, handlecontentGroupMouseWheel);
			_isActive = false;
			_contentGroup = null;
			_hostComponent = null;
		}
		
		private var _contentGroup:DisplayObjectContainer;
		private var _hostComponent:List;
		public function get hostComponent():DisplayObject
		{
			return _hostComponent;
		}
		
		private var _direction:String;
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * 对ContentGroup，在鼠标滚动时进行监听。
		 * @param event MouseEvent.MouseWheel
		 */		
		protected function handlecontentGroupMouseWheel(event:MouseEvent):void
		{
			if(_hostComponent.verticalScrollEnable)
			{
				_hostComponent.verticalScrollPosition -= event.delta * _hostComponent.vScrollSize;
			}
			else if(_hostComponent.horizontalScrollEnable)
			{
				_hostComponent.horizontalScrollPosition -= event.delta * _hostComponent.hScrollSize;
			}
		}
	}
}