package sissi.components
{
	import flash.events.Event;
	
	import sissi.core.UIComponent;
	import sissi.core.sissi_internal;
	import sissi.interaction.ButtonInterAction;
	import sissi.skins.ButtonSkin;
	import sissi.skins.supportClasses.IButtonSkin;
	
	use namespace sissi_internal;
	public class Button extends UIComponent
	{
		public function Button()
		{
			super();
			mouseChildren = false;
			interAction = new ButtonInterAction(this);
			skin = new ButtonSkin(this);
		}
		
		/**
		 * 按钮的mouseChildren总是为false 
		 * @param value
		 * 
		 */
		public override function set mouseChildren(value:Boolean):void
		{
			super.mouseChildren = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  autoRepeat
		//----------------------------------
		/**
		 * 按下按钮后，连续的触发动作。触发SissiEvent.BUTTON_DOWN事件。
		 */		
		public var autoRepeat:Boolean = false;
		
		/**
		 * 按下按钮后，需过一段时间相应Click事件。
		 */		
		public var delayClick:Boolean = false;
		
		/**
		 * 按下按钮后，需过一段时间相应Click事件的时间，毫秒级
		 */		
		public var delayClickIntervalValue:int = 200;
		
		//----------------------------------
		//  skin
		//----------------------------------
		private var _skin:IButtonSkin;
		public function get skin():IButtonSkin
		{
			return _skin;
		}
		public function set skin(value:IButtonSkin):void
		{
			if(_skin)
			{
				_skin.dispose();
			}
			_skin = value;
			
			currentStateChanged = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  label
		//----------------------------------
		public function get label():String
		{
			return _skin.label;
		}
		public function set label(value:String):void
		{
			_skin.label = value;
		}
		
		/**
		 * 第一次为true，自动设置其Skin状态。
		 */		
		private var currentStateChanged:Boolean = true;
		
		public static const OVER:String = "over";
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		//----------------------------------
		//  currentState
		//----------------------------------
		private var _currentState:String = UP;
		public function get currentState():String
		{
			return _currentState;
		}
		public function set currentState(value:String):void
		{
			if(_currentState != value)
			{
				_currentState = value;
				currentStateChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		/**
		 * selected enabled currentState改变
		 */		
		//----------------------------------
		//  selected
		//----------------------------------
		private var _selected:Boolean;
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				currentStateChanged = true;
				dispatchEvent(new Event(Event.CHANGE));
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//----------------------------------
		//  enabled
		//----------------------------------
		private var _enabled:Boolean = true;
		override public function get enabled():Boolean
		{
			return _enabled;
		}
		override public function set enabled(value:Boolean):void
		{
			if(_enabled != value)
			{
				_enabled = value;
				currentStateChanged = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}

		//--------------------------------------------------------------------------
		//
		//  LifeCycle
		//
		//--------------------------------------------------------------------------
		override protected function commitProperties():void
		{
			_skin.validateSkinChange();
			if(currentStateChanged)
			{
				_skin.currentStateChanged();
			}
		}
		
		override protected function measure():void
		{
			measuredWidth = skin.measuredWidth
			measuredHeight = skin.measuredHeight;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			_skin.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		//------------------------------------------------
		//
		// dispose
		//
		//------------------------------------------------
		override sissi_internal function sissi_active():void
		{
			super.sissi_active();
		}
		override sissi_internal function sissi_deactive():void
		{
			super.sissi_deactive();
		}
	}
}