package sissi.interaction
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sissi.components.Button;
	import sissi.core.SissiManager;
	import sissi.events.SissiEvent;
	import sissi.interaction.supportClasses.IInterAction;
	
	/**
	 * 按钮式交互。
	 * @author Alvin
	 */	
	public class ButtonInterAction implements IInterAction
	{
		public function ButtonInterAction(hostComponent:Button)
		{
			this._hostComponent = hostComponent;
		}
		
		/**
		 * InterAction交互的对象为Button。
		 */		
		private var _hostComponent:Button;
		public function get hostComponent():DisplayObject
		{
			return _hostComponent;
		}
		
		/**
		 * 是否已经激活
		 **/
		private var _isActive:Boolean;
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		/**
		 * 激活。
		 */		
		public function active():void
		{
			if(!_isActive)
			{
				_isActive = true;
				
				_hostComponent.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler,false,9999);
				_hostComponent.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler,false,9999);
				_hostComponent.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler,false,9999);
				_hostComponent.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler,false,9999);
				_hostComponent.addEventListener(MouseEvent.CLICK, mouseEventHandler, false, 9999);
			}
		}
		
		/**
		 * 获得当前对应的皮肤状态。
		 * @return button skin state.
		 */		
		protected function getCurrentState():String
		{
			if (isDown())
				return Button.DOWN;
			
			if (hovered || mouseCaptured)
				return Button.OVER;
			
			return Button.UP;
		}
		
		/**
		 * 判断鼠标是否在按钮上面，并且，鼠标是按下去的。
		 */    
		protected var mouseCaptured:Boolean;
		/**
		 * 判断鼠标是否在按钮上面。
		 */ 
		protected var hovered:Boolean;
		
		/**
		 * 鼠标是否按下。
		 * @return 鼠标是否按下。
		 */		
		protected function isDown():Boolean
		{
			if (!_hostComponent.enabled)
				return false;
			
			if (mouseCaptured && hovered)
				return true;
			
			return false;
		}
		
		/**
		 * 需要延迟Click时间的存储时间点。
		 */		
		private var delayClickTime:int;
		/**
		 * 对按钮的鼠标系交互事件。
		 * 需要充分考虑鼠标按住，移出，再移入等等情况。
		 * @event 鼠标事件。
		 */		
		protected function mouseEventHandler(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.ROLL_OVER:
				{
					if(event.buttonDown && !mouseCaptured)
						return;
					hovered = true;
					break;
				}
				case MouseEvent.ROLL_OUT:
				{
					hovered = false;
					break;
				}
				case MouseEvent.MOUSE_DOWN:
				{
					if(!_hostComponent.enabled)
					{
						event.stopImmediatePropagation();
						return;
					}
					
					mouseCaptured = true;
					//对Stage进行监听。因为有可能在按钮上面，按着鼠标然后移动到外面去了。
					SissiManager.getStage(_hostComponent).addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
					SissiManager.getStage(_hostComponent).addEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler, false, 0, true);
					break;
				}
				case MouseEvent.MOUSE_UP:
				{
					if(!_hostComponent.enabled)
					{
						event.stopImmediatePropagation();
						return;
					}
					
					//鼠标放开的部分处理，有部分处理是在stageMouseUpHandler的事件当中。
					if(event.target == _hostComponent)
					{
						hovered = true;
						mouseCaptured = false;
						//						if (mouseCaptured)
						//						{
						//							buttonReleased();
						//							mouseCaptured = false;
						//						}
					}
					break;
				}
				case MouseEvent.CLICK:
				{
					if(!_hostComponent.enabled)
					{
						event.stopImmediatePropagation();
						return;
					}
					if(_hostComponent.delayClick)
					{
						//delayTime > 0 for first time.
						if(delayClickTime > 0 && (getTimer() - delayClickTime) < _hostComponent.delayClickIntervalValue)
						{
							event.stopImmediatePropagation();
						}
						else
						{
							delayClickTime = getTimer();
						}
					}
					break;
				}
			}
			
			if(_hostComponent.autoRepeat)
				startRepeatDelay(event);
			
			_hostComponent.currentState = getCurrentState();
			event.updateAfterEvent();
		}
		
		/**
		 * 鼠标放开后关于按钮方面的处理。
		 */
		protected function stageMouseUpHandler(event:Event):void
		{
			SissiManager.getStage(_hostComponent).removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			SissiManager.getStage(_hostComponent).removeEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			
			// If the target is the button, do nothing because the
			// mouseEventHandler will be handle it.
			if (event.target == _hostComponent)
				return;
			
			stopRepeatEvent();
			mouseCaptured = false;
			
			_hostComponent.currentState = getCurrentState();
		}
		
		/**
		 * 鼠标按下去之后需要一定的时间后才开始Repeat的功能。
		 */		
		private var mouseDownDelayTimer:Timer;
		/**
		 * 开始延时。
		 */		
		private function startRepeatDelay(event:MouseEvent):void
		{
			//如果鼠标按下去的话，那么停止掉原来的，并且开始延时计时。
			stopRepeatDelay();
			stopRepeatEvent();
			
			if(event.buttonDown && isDown())
			{
				mouseDownDelayTimer = new Timer(500, 1);
				mouseDownDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startRepeatEvent);
				mouseDownDelayTimer.start();
			}
		}
		
		/**
		 * 停止延时时间。
		 */		
		private function stopRepeatDelay():void
		{
			if(mouseDownDelayTimer)
			{
				mouseDownDelayTimer.stop();
				mouseDownDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, startRepeatEvent);
				mouseDownDelayTimer = null;
			}
		}
		
		/**
		 * 通过计数器开始Repeat事件。
		 */		
		private var mouseDownRepeatTimer:Timer;
		private function startRepeatEvent(event:TimerEvent = null):void
		{
			stopRepeatEvent();
			
			mouseDownRepeatTimer = new Timer(100, 0);
			mouseDownRepeatTimer.addEventListener(TimerEvent.TIMER, repeatEventHandler);
			mouseDownRepeatTimer.start();
		}
		
		/**
		 * 停止Repeat事件。
		 */		
		private function stopRepeatEvent():void
		{
			if(mouseDownRepeatTimer)
			{
				mouseDownRepeatTimer.stop();
				mouseDownRepeatTimer.removeEventListener(TimerEvent.TIMER, repeatEventHandler);
				mouseDownRepeatTimer = null;
			}
		}
		
		/**
		 * Repeat事件。
		 */		
		protected function repeatEventHandler(event:TimerEvent):void
		{
			_hostComponent.dispatchEvent(new SissiEvent(SissiEvent.BUTTON_DOWN));
		}
		
		
		/**
		 * 取消激活。
		 */		
		public function deactive():void
		{
			_isActive = false;
			
			_hostComponent.removeEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
			_hostComponent.removeEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			_hostComponent.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			_hostComponent.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			_hostComponent.removeEventListener(MouseEvent.CLICK, mouseEventHandler);
			
			if(SissiManager.getStage(_hostComponent))
			{
				SissiManager.getStage(_hostComponent).removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
				SissiManager.getStage(_hostComponent).removeEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			}
			
			stopRepeatDelay();
			stopRepeatEvent();
			
			_hostComponent = null;
		}
	}
}