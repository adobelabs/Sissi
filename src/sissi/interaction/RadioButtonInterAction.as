package sissi.interaction
{
	import flash.events.MouseEvent;
	
	import sissi.components.CheckBox;
	import sissi.components.RadioButton;
	
	public class RadioButtonInterAction extends CheckBoxInterAction
	{
		public function RadioButtonInterAction(hostComponent:CheckBox)
		{
			super(hostComponent);
		}
		
		/**
		 * 更改ToggleButton状态。
		 * @param event
		 */		
		override protected function toggleHandler(event:MouseEvent):void
		{
			(hostComponent as RadioButton).selected = true;
		}
	}
}