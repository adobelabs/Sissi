package sissi.interaction
{
	import flash.events.MouseEvent;
	
	import sissi.components.CheckBox;
	import sissi.interaction.supportClasses.IInterAction;
	
	/**
	 * 按钮式交互。
	 * @author Alvin
	 */	
	public class CheckBoxInterAction extends ButtonInterAction implements IInterAction
	{
		public function CheckBoxInterAction(hostComponent:CheckBox)
		{
			super(hostComponent);
		}
		
		/**
		 * 激活。
		 */		
		override public function active():void
		{
			if(!isActive)
			{
				super.active();
				
				hostComponent.addEventListener(MouseEvent.CLICK, toggleHandler,false,9999);
			}
		}
		
		/**
		 * 更改ToggleButton状态。
		 * @param event
		 */		
		protected function toggleHandler(event:MouseEvent):void
		{
			(hostComponent as CheckBox).selected = !(hostComponent as CheckBox).selected;
		}
		
		/**
		 * 取消激活。
		 */		
		override public function deactive():void
		{
			hostComponent.removeEventListener(MouseEvent.CLICK, toggleHandler);
			super.deactive();
		}
	}
}