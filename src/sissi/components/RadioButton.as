package sissi.components
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import sissi.components.supportClasses.RadioButtonGroup;
	import sissi.core.sissi_internal;
	import sissi.interaction.RadioButtonInterAction;
	import sissi.managers.BMDCacheManager;
	import sissi.skin.SkinRadioButtonOverBMD;
	import sissi.skin.SkinRadioButtonSelectedOverBMD;
	import sissi.skin.SkinRadioButtonSelectedUpBMD;
	import sissi.skin.SkinRadioButtonUpBMD;

	use namespace sissi_internal;
	
	/**
	 * RadioButton被removeChild时，原有的groupName将无效。
	 * 注意对RadioButton的Group的取消引用。
	 * @author Alvin.Ju
	 */	
	public class RadioButton extends CheckBox
	{
		//----------------------------------
		//  selected
		//----------------------------------
		private var _selected:Boolean;
		override public function get selected():Boolean
		{
			return _selected;
		}
		override public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
//				changeSkin();
				dispatchEvent(new Event(Event.CHANGE));
				if(_selected && _groupName && _groupName != "" && group.selection != this)
						group.selection = this;
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		//----------------------------------
		//  group
		//----------------------------------
		private var _group:RadioButtonGroup;
		public function get group():RadioButtonGroup
		{
			if (!_group)
			{
				if (_groupName && _groupName != "")
				{
					var g:RadioButtonGroup = RadioButtonGroup.getRadioButtonGroup(_groupName);
					if(!g)
					{
						g = new RadioButtonGroup(_groupName);
						RadioButtonGroup.registerRadioButtonGroup(g);
					}
					_group = g;
				}
			}
			return _group;
		}
		public function set group(value:RadioButtonGroup):void
		{
			_group = value;
		}

		
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
		public function set groupName(value:String):void
		{
			//Del Old Group
			if(group)
				group.removeIntance(this);
			
			if (!value || value == "")
				return;
			
			_groupName = value;
			//New Group & AddInstance
			if(_groupName && _groupName != "")
				group.addInstance(this);
		}
		
		public var itemIndex:int;

		
		public function RadioButton()
		{
			super();
			explicitWidth = explicitHeight = NaN;
			interAction = new RadioButtonInterAction(this);
			skin.upSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonUpBMD));
			skin.overSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonOverBMD));
			skin.downSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonUpBMD));
			skin.selectedUpSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonSelectedUpBMD));
			skin.selectedOverSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonSelectedOverBMD));
			skin.selectedDownSkin = new Bitmap(BMDCacheManager.getBMD(SkinRadioButtonSelectedUpBMD));
		}
	}
}