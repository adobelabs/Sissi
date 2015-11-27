package sissi.interaction
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sissi.components.Button;
	import sissi.components.ScrollBar;
	import sissi.core.SissiManager;
	import sissi.core.sissi_internal;
	import sissi.events.SissiEvent;
	import sissi.interaction.supportClasses.IInterAction;
	import sissi.layouts.LayoutDirection;
	
	
	/**
	 * Slider的控制器。
	 * 需要拥有Slider本身，tracker底部物件，thumber按钮。
	 * @author Alvin.Ju
	 */	
	public class ScrollBarInterAction implements IInterAction
	{
		public function ScrollBarInterAction(hostComponent:ScrollBar)
		{
			this._hostComponent = hostComponent;
			this._direction = hostComponent.direction;
		}
		
		private var _hostComponent:ScrollBar;
		public function get hostComponent():DisplayObject
		{
			return _hostComponent;
		}
		
		private var _direction:String;
		public function get direction():String
		{
			return _direction;
		}
		
		private var _isActive:Boolean;
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		protected var thumb:Button;
		protected var upArrow:Button;
		protected var downArrow:Button;
		public function active():void
		{
			if(!_isActive)
			{
				_isActive = true;
				
				thumb = _hostComponent.sissi_internal::thumb;
				upArrow = _hostComponent.sissi_internal::upArrow;
				downArrow = _hostComponent.sissi_internal::downArrow;
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
				
				upArrow.addEventListener(MouseEvent.CLICK, handleUpValue);
				upArrow.addEventListener(SissiEvent.BUTTON_DOWN, handleUpValue);
				downArrow.addEventListener(MouseEvent.CLICK, handleDownValue);
				downArrow.addEventListener(SissiEvent.BUTTON_DOWN, handleDownValue);
				
				_hostComponent.addEventListener(MouseEvent.CLICK, trackerMouseClickHandler);
			}
		}
		
		protected function handleUpValue(event:Event):void
		{
			if(_hostComponent.scrollSize > 0)
				_hostComponent.scrollPosition -= _hostComponent.scrollSize;
			else
				_hostComponent.scrollPosition -= 1;
		}
		
		protected function handleDownValue(event:Event):void
		{
			if(_hostComponent.scrollSize > 0)
				_hostComponent.scrollPosition += _hostComponent.scrollSize;
			else
				_hostComponent.scrollPosition += 1;
		}
		
		/**
		 * 点击Tracker时候的处理。
		 * @param event
		 */		
		protected function trackerMouseClickHandler(event:MouseEvent):void
		{
			if(event.target == thumb || event.target == upArrow || event.target == downArrow)
				return;
			
			var tag:int;
			if(_direction == LayoutDirection.VERTICAL)
			{
				tag = event.stageY > _hostComponent.localToGlobal(new Point(thumb.x, thumb.y)).y ? 1 : -1;
			}
			else if(_direction == LayoutDirection.HORIZONTAL)
			{
				//如果直接用event.localX不准确、
				tag = event.stageX > _hostComponent.localToGlobal(new Point(thumb.x, thumb.y)).x ? 1 : -1;
			}
			
			//每次按下时需重新计算可以移动的范围。
			thumbRangeMin = 0;
			thumbRangeMax = _hostComponent.sissi_internal::pixelRange;
			
			//鼠标按下的位置值。
			var mouseDownValue:Number;
			if(_direction == LayoutDirection.VERTICAL)
			{
				mouseDownValue = calValueByThumberPosition(_hostComponent.globalToLocal(new Point(0, event.stageY)).y - _hostComponent.sissi_internal::upArrow.height);
			}
			else if(_direction == LayoutDirection.HORIZONTAL)
			{
				mouseDownValue = calValueByThumberPosition(_hostComponent.globalToLocal(new Point(event.stageX, 0)).x - _hostComponent.sissi_internal::upArrow.width);
			}
			
			//按下后移动的目标值，以某一个基数靠近，靠近后不超过。
			var nextValue:Number = _hostComponent.scrollPosition + _hostComponent.sissi_internal::scrollPositionRange * 0.2 * tag;
//			trace("nextValue", nextValue)
			if(_hostComponent.scrollSize > 0)
			{
				var prefValue:int = Math.round(_hostComponent.sissi_internal::scrollPositionRange * 0.2 / _hostComponent.scrollSize);
				prefValue = prefValue > 0 ? prefValue : 1;
				nextValue =  _hostComponent.scrollPosition + prefValue * _hostComponent.scrollSize * tag;
			}
			
//			trace(tag, nextValue, mouseDownValue)
//			if(tag == 1)
//			{
//				nextValue = nextValue > mouseDownValue ? mouseDownValue : nextValue;
//			}
//			else
//			{
//				nextValue = nextValue < mouseDownValue ? mouseDownValue : nextValue;
//			}
			
			_hostComponent.scrollPosition = nextValue;
			event.updateAfterEvent();
		}
		
		//鼠标按下去时候的位置。
		private var mouseDownStagePt:Point;
		//鼠标按下时候，thumber的位置。
		private var mouseDownTrumberPt:Point;
		//thumber的可移动区间。
		private var thumbRangeMin:Number;
		private var thumbRangeMax:Number;
		
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			mouseDownStagePt = new Point(event.stageX, event.stageY);
			mouseDownTrumberPt = new Point(thumb.x, thumb.y);
			
			//每次按下时需重新计算可以移动的范围。
			thumbRangeMin = 0;
			thumbRangeMax = _hostComponent.sissi_internal::pixelRange;
			
			SissiManager.getStage(_hostComponent).addEventListener(MouseEvent.MOUSE_MOVE, handlThumbMouseMove, false, 0, true);
			SissiManager.getStage(_hostComponent).addEventListener(MouseEvent.MOUSE_UP, handleThumbMouseUp, false, 0, true);
			SissiManager.getStage(_hostComponent).addEventListener(Event.MOUSE_LEAVE, handleThumbMouseUp, false, 0, true);
		}
		
		/**
		 * 按住Thumber进行移动时候的处理
		 * @param event
		 */		
		protected function handlThumbMouseMove(event:MouseEvent):void
		{
			if(thumbRangeMax <= 0 || !event.buttonDown)
				return;
			
			var globalPT:Point = new Point(event.stageX, event.stageY);
			var toXorY:Number;
			if(_direction == LayoutDirection.VERTICAL)
			{
				toXorY = globalPT.y - mouseDownStagePt.y;
				toXorY += mouseDownTrumberPt.y;
				toXorY -=  _hostComponent.sissi_internal::upArrow.height;
			}
			else if(_direction == LayoutDirection.HORIZONTAL)
			{
				toXorY = globalPT.x - mouseDownStagePt.x;
				toXorY += mouseDownTrumberPt.x;
				toXorY -=  _hostComponent.sissi_internal::upArrow.width;
			}
			
			_hostComponent.scrollPosition = calValueByThumberPosition(toXorY);
			_hostComponent.validateNow();
			event.updateAfterEvent();
		}
		
		/**
		 * 通过Thumber的位置获得value数值，value的数值有可能是越界的，会在_hostComponent.commintProperties里面修正
		 * @param toXorY 要移动的位置。
		 */		
		private function calValueByThumberPosition(toXorY:Number):Number
		{
			toXorY = toXorY < thumbRangeMax ? toXorY : thumbRangeMax;
			toXorY = toXorY > thumbRangeMin ? toXorY : thumbRangeMin;
			//现在的值
			var currentValue:Number;
			//能拖动的数据
			var pixelRange:Number = _hostComponent.sissi_internal::pixelRange;
			//能拖动的范围。
			var valueRange:Number = _hostComponent.sissi_internal::scrollPositionRange;
			if(_hostComponent.scrollSize > 0)
			{
				//位置最接近的单位
				(toXorY - thumbRangeMin) / pixelRange * valueRange
				
				//一个单位的像素长度
				var unitPixel:Number = pixelRange / valueRange;
				var snapIntervalPixel:Number = unitPixel * _hostComponent.scrollSize;
				var snapIntervalCount:int = Math.round((toXorY - thumbRangeMin)/snapIntervalPixel);
				currentValue = snapIntervalCount * _hostComponent.scrollSize + _hostComponent.minScrollPosition;
			}
			else
			{
				currentValue = Math.round((toXorY - thumbRangeMin) / pixelRange * valueRange) + _hostComponent.minScrollPosition;
			}
			
			return currentValue;
		}
		
		
		protected function handleThumbMouseUp(event:Event):void
		{
			if(SissiManager.getStage(_hostComponent))
			{
				SissiManager.getStage(_hostComponent).removeEventListener(MouseEvent.MOUSE_MOVE, handlThumbMouseMove);
				SissiManager.getStage(_hostComponent).removeEventListener(MouseEvent.MOUSE_UP, handleThumbMouseUp);
				SissiManager.getStage(_hostComponent).removeEventListener(Event.MOUSE_LEAVE, handleThumbMouseUp);
			}
		}
		
		public function deactive():void
		{
			_isActive = false;
			
			_hostComponent.sissi_internal::thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDownHandler);
			_hostComponent.removeEventListener(MouseEvent.CLICK, trackerMouseClickHandler);
			if(SissiManager.getStage(_hostComponent))
			{
				SissiManager.getStage(_hostComponent).removeEventListener(MouseEvent.MOUSE_MOVE, handlThumbMouseMove);
				SissiManager.getStage(_hostComponent).removeEventListener(MouseEvent.MOUSE_UP, handleThumbMouseUp);
				SissiManager.getStage(_hostComponent).removeEventListener(Event.MOUSE_LEAVE, handleThumbMouseUp);
			}
			
			upArrow = null;
			downArrow = null;
			thumb = null;
			_hostComponent = null;
		}
	}
}