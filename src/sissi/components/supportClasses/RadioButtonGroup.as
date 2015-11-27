package sissi.components.supportClasses
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sissi.components.Button;
	import sissi.components.RadioButton;

	public class RadioButtonGroup extends EventDispatcher
	{
		//----------------------------------
		//  groupName
		//----------------------------------
		private var _groupName:String;
		/**
		 * 可以设置组名字，用来自动设置按钮状态之间的排斥性。
		 * @return 
		 */		
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function RadioButtonGroup(radioButtonGroupName:String)
		{
			_groupName = radioButtonGroupName;
		}
		
		private static var radioButtonDic:Dictionary = new Dictionary();
		public static function getRadioButtonGroup(groupName:String):RadioButtonGroup
		{
			var radioButtonGroup:RadioButtonGroup = radioButtonDic[groupName];
			return radioButtonGroup;
		}
		public static function registerRadioButtonGroup(group:RadioButtonGroup):void
		{
			radioButtonDic[group.groupName] = group;
		}
		
		public static function unregisterRadioButtonGroup(groupName:String):void
		{
			if(radioButtonDic[groupName])
			{
				radioButtonDic[groupName] = null;
				delete radioButtonDic[groupName];
			}
		}
		
		
		/**
		 *  The number of RadioButtons that belong to this RadioButtonGroup.
		 * 
		 *  @default "undefined"
		 */
		public function get numRadioButtons():int
		{
			return radioButtons ? radioButtons.length : 0;
		}
		private var radioButtons:Array;
		
		public function removeIntance(intance:RadioButton):void
		{
			if(radioButtons)
			{
				var intanceIndex:int = radioButtons.indexOf(intance);
				if(intanceIndex != -1)
					radioButtons.splice(intanceIndex, 1);
			}
		}
		
		public function addInstance(intance:RadioButton):void
		{
			radioButtons ||= [];
			radioButtons.push(intance);
		}
		
		private var _selectIndex:int;
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		public function set selectIndex(value:int):void
		{
			setSelectIndex(value);
		}
		
		private function setSelectIndex(indexValue:int):void
		{
			if (indexValue < 0 && _selection != null)
			{
				_selection.selected = false;
				_selection = null;
				_selectIndex = -1;
			}
			else
			{
				if(indexValue < numRadioButtons)
				{
					var n:int = numRadioButtons;
					for (var i:int = 0; i < n; i++)
					{
						var loopRadioButton:RadioButton =  radioButtons[i];
						if(indexValue == i)
						{
							loopRadioButton.selected =  true;
							_selection = loopRadioButton;
							_selectIndex = i;
						}
						else
						{
							loopRadioButton.selected =  false;
						}
					}
				}
			}
		}
		
		
		private var _selection:RadioButton;
		public function get selection():RadioButton
		{
			return _selection;
		}
		public function set selection(value:RadioButton):void
		{
			//需要判断才能确定selection，因为有可能传进来的并非一定是这个Group的。
			setSelection(value); 
		}
		
		private function setSelection(value:RadioButton):void
		{
			if (value == null && _selection != null)
			{
				_selection.selected = false;
				_selection = null;
				_selectIndex = -1;
			}
			else
			{
				var n:int = numRadioButtons;
				for (var i:int = 0; i < n; i++)
				{
					var loopRadioButton:RadioButton =  radioButtons[i];
					if(value == loopRadioButton)
					{
						loopRadioButton.selected =  true;
						_selection = loopRadioButton;
						_selectIndex = i;
					}
					else
					{
						loopRadioButton.selected =  false;
					}
				}
			}
		}
	}
}