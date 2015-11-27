package sissi.skins
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import sissi.components.Button;
	import sissi.components.CheckBox;
	import sissi.core.UITextField;
	import sissi.skin.SkinButtonDownScale;
	import sissi.skin.SkinButtonOverScale;
	import sissi.skin.SkinButtonUpScale;
	import sissi.skins.supportClasses.IButtonSkin;
	
	public class ButtonSkin extends EventDispatcher implements IButtonSkin
	{
		public function ButtonSkin(target:Button)
		{
			this._hostComponent = target;
		}
		/**
		 * InterAction交互的对象为Button。
		 */		
		private var _hostComponent:Button;
		public function get hostComponent():DisplayObjectContainer
		{
			return _hostComponent;
		}
		
		/**
		 * SKIN_LABEL是用UITextfield还是labelSkin。
		 */		
		private var isLabelSkin:Boolean;
		private var _label:String;
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			if(_label != value)
			{
				_label = value;
				skinChanged = true;
				
				isLabelSkin = false;
				_labelSkin = null;
				
				_hostComponent.invalidateProperties();
				_hostComponent.invalidateSize();
				_hostComponent.invalidateDisplayList();
			}
		}
		
		private var _labelStroke:Array;
		public function get labelStroke():Array
		{
			return _labelStroke;
		}
		public function set labelStroke(value:Array):void
		{
			_labelStroke = value;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _labelTextFormat:TextFormat;
		public function get labelTextFormat():TextFormat
		{
			return _labelTextFormat;
		}
		public function set labelTextFormat(value:TextFormat):void
		{
			_labelTextFormat = value;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _selectedLabelTextFormat:TextFormat;
		public function get selectedLabelTextFormat():TextFormat
		{
			return _selectedLabelTextFormat;
		}
		public function set selectedLabelTextFormat(value:TextFormat):void
		{
			_selectedLabelTextFormat = value;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _disabledLabelTextFormat:TextFormat;
		public function get disabledLabelTextFormat():TextFormat
		{
			return _disabledLabelTextFormat;
		}
		public function set disabledLabelTextFormat(value:TextFormat):void
		{
			_disabledLabelTextFormat = value;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _labelSkin:DisplayObject;
		public function get labelSkin():DisplayObject
		{
			return _labelSkin;
		}
		public function set labelSkin(value:DisplayObject):void
		{
			_labelSkin = value;
			isLabelSkin = true;
			
			_label = null;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _labelSelectedSkin:DisplayObject;
		public function get labelSelectedSkin():DisplayObject
		{
			return _labelSelectedSkin;
		}
		public function set labelSelectedSkin(value:DisplayObject):void
		{
			_labelSelectedSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _labelDisabledSkin:DisplayObject;
		public function get labelDisabledSkin():DisplayObject
		{
			return _labelDisabledSkin;
		}
		public function set labelDisabledSkin(value:DisplayObject):void
		{
			_labelDisabledSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _labelSkinPosition:Point;
		/**
		 * 若采用LabelSkin，可以通过此来设置LabelSkin的设置
		 * 若赋值为Label，那么其默认是居中的
		 * @return 
		 */		
		public function get labelSkinPosition():Point
		{
			return _labelSkinPosition;
		}
		public function set labelSkinPosition(value:Point):void
		{
			_labelSkinPosition = value;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _iconSkin:DisplayObject;
		public function get iconSkin():DisplayObject
		{
			return _iconSkin;
		}
		public function set iconSkin(value:DisplayObject):void
		{
			_iconSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _iconSkinPosition:Point;
		/**
		 * iconSkin的设置
		 * @return 
		 */		
		public function get iconSkinPosition():Point
		{
			return _iconSkinPosition;
		}
		public function set iconSkinPosition(value:Point):void
		{
			_iconSkinPosition = value;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _upSkin:DisplayObject;
		public function get upSkin():DisplayObject
		{
			return _upSkin;
		}
		public function set upSkin(value:DisplayObject):void
		{
			_upSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _overSkin:DisplayObject;
		public function get overSkin():DisplayObject
		{
			return _overSkin;
		}
		public function set overSkin(value:DisplayObject):void
		{
			_overSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _downSkin:DisplayObject;
		public function get downSkin():DisplayObject
		{
			return _downSkin;
		}
		public function set downSkin(value:DisplayObject):void
		{
			_downSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _selectedUpSkin:DisplayObject;
		public function get selectedUpSkin():DisplayObject
		{
			return _selectedUpSkin;
		}
		public function set selectedUpSkin(value:DisplayObject):void
		{
			_selectedUpSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _selectedOverSkin:DisplayObject;
		public function get selectedOverSkin():DisplayObject
		{
			return _selectedOverSkin;
		}
		public function set selectedOverSkin(value:DisplayObject):void
		{
			_selectedOverSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _selectedDownSkin:DisplayObject;
		public function get selectedDownSkin():DisplayObject
		{
			return _selectedDownSkin;
		}
		public function set selectedDownSkin(value:DisplayObject):void
		{
			_selectedDownSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _disabledSkin:DisplayObject;
		public function get disabledSkin():DisplayObject
		{
			return _disabledSkin;
		}
		public function set disabledSkin(value:DisplayObject):void
		{
			_disabledSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		
		public static const SKIN_ICON:String = "skinIcon";
		
		public static const SKIN_LABEL:String = "skinLabel";
		public static const SKIN_SELECTED_LABEL:String = "skinSelectedLabel";
		public static const SKIN_DISABLED_LABEL:String = "skinDisabledLabel";
		
		public static const SKIN_UP:String = "skinUp";
		public static const SKIN_OVER:String = "skinOver";
		public static const SKIN_DOWN:String = "skinDown";
		
		public static const SKIN_SELECTED_UP:String = "skinSelectedUp";
		public static const SKIN_SELECTED_OVER:String = "skinSelectedOver";
		public static const SKIN_SELECTED_DOWN:String = "skinSelectedDown";
		
		public static const SKIN_DISABLED:String = "skinDisabled";
		/**
		 * 验证是否更改现有的皮肤
		 */		
		protected var skinChanged:Boolean = true;
		public function validateSkinChange():void
		{
			if(skinChanged)
			{
				detachSkin();
				attachSkin();
				
				skinChanged = false;
			}
		}
		
		/**
		 * 验证是否更改现有的状态
		 */		
		public function currentStateChanged():void
		{
			//all unvisible
			for(var skinId:String in skins)
			{
				var skinPart:DisplayObject = skins[skinId] as DisplayObject
				skinPart.visible = false;
			}
			
			//Skins
			var visibleSkin:DisplayObject;
			if(!_hostComponent.enabled)
			{
				visibleSkin = skins[SKIN_DISABLED] ? skins[SKIN_DISABLED] : skins[SKIN_UP];
			}
			else
			{
				if(_hostComponent.currentState == Button.UP)
				{
					if(_hostComponent.selected)
						visibleSkin = skins[SKIN_SELECTED_UP] ? skins[SKIN_SELECTED_UP] : skins[SKIN_UP];
					else
						visibleSkin = skins[SKIN_UP];
				}
				else if(_hostComponent.currentState == Button.OVER)
				{
					if(_hostComponent.selected)
						visibleSkin = skins[SKIN_SELECTED_OVER] ? skins[SKIN_SELECTED_OVER] : skins[SKIN_SELECTED_UP];
					else
						visibleSkin = skins[SKIN_OVER] ? skins[SKIN_OVER] : skins[SKIN_UP];
				}
				else if(_hostComponent.currentState == Button.DOWN)
				{
					if(_hostComponent.selected)
						visibleSkin = skins[SKIN_SELECTED_DOWN] ? skins[SKIN_SELECTED_DOWN] : skins[SKIN_SELECTED_UP];
					else
						visibleSkin = skins[SKIN_DOWN] ? skins[SKIN_DOWN] : skins[SKIN_UP];
				}
			}
			//如果选择状态可视物件不存在，那么使用默认的SKIN_UP
			if(!visibleSkin)
			{
				visibleSkin = skins[SKIN_UP];
			}
			visibleSkin.visible = true;
			
				
			//Label
			if(skins[SKIN_LABEL])
			{
				//Labels
				if(isLabelSkin)
				{
					var visibleLabelSkin:DisplayObject;
					if(!_hostComponent.enabled)
					{
						visibleLabelSkin = skins[SKIN_DISABLED_LABEL] ? skins[SKIN_DISABLED_LABEL] : skins[SKIN_LABEL];
					}
					else
					{
						if(_hostComponent.selected)
							visibleLabelSkin = skins[SKIN_SELECTED_LABEL] ? skins[SKIN_SELECTED_LABEL] : skins[SKIN_LABEL];
						else
							visibleLabelSkin = skins[SKIN_LABEL];
					}
					visibleLabelSkin.visible = true;
				}
				else
				{
					var visibleLabelUITf:UITextField = skins[SKIN_LABEL];
					if(!_hostComponent.enabled)
					{
						if(_disabledLabelTextFormat)
							visibleLabelUITf.defaultTextFormat = _disabledLabelTextFormat;
					}
					else
					{
						if(_hostComponent.selected)
						{
							if(_selectedLabelTextFormat)
								visibleLabelUITf.defaultTextFormat = _selectedLabelTextFormat;
						}
						else
						{
							visibleLabelUITf.defaultTextFormat = _labelTextFormat;
						}
					}
					visibleLabelUITf.visible = true;
				}
			}
			
			//ICON
			if(skins[SKIN_ICON])
			{
				var iconSkin:DisplayObject = skins[SKIN_ICON];
				iconSkin.visible = true;
			}
		}
		
		public function get measuredWidth():Number
		{
			var upSkin:DisplayObject = skins[SKIN_UP];
			var upSkinWidth:Number = 0;
			if(upSkin)
				upSkinWidth = upSkin.width;
			
			var labelSkin:DisplayObject = skins[SKIN_LABEL];
			var labelSkinWidth:Number = 0;
			if(labelSkin)
				labelSkinWidth = labelSkin.width;
			
			if(_hostComponent is CheckBox)
			{
				return upSkinWidth + labelSkinWidth;
			}
			return upSkinWidth;
		}
		public function get measuredHeight():Number
		{
			var upSkin:DisplayObject = skins[SKIN_UP];
			var upSkinHeight:Number = 0;
			if(upSkin)
				upSkinHeight = upSkin.height;
			
			var labelSkin:DisplayObject = skins[SKIN_LABEL];
			var labelSkinHeight:Number = 0;
			if(labelSkin)
				labelSkinHeight = labelSkin.height;
			
			if(_hostComponent is CheckBox)
			{
				return upSkinHeight > labelSkinHeight ? upSkinHeight : labelSkinHeight;
			}
			return upSkinHeight;
		}
		
		/**
		 * 对Skin大小进行变更和布局
		 */		
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(_hostComponent is CheckBox)
			{
				//CheckBox RadioButton
				for(var labelSkinId:String in skins)
				{
					var labelSkinPart:DisplayObject = skins[labelSkinId] as DisplayObject;
					labelSkinPart.y = (unscaledHeight - labelSkinPart.height)>>1;
					//label部分不去约束其大小
					if(labelSkinId == SKIN_LABEL || labelSkinId == SKIN_SELECTED_LABEL || labelSkinId == SKIN_DISABLED_LABEL)
					{
						if(_labelSkinPosition)
						{
							labelSkinPart.x = labelSkinPosition.x;
							labelSkinPart.y = labelSkinPosition.y;
						}
						else
						{
							labelSkinPart.x = skins[SKIN_UP].width;
//							if(skinPart is UITextField)
//							{
//								labelSkinPart.y = (unscaledHeight - (labelSkinPart as UITextField).textHeight)>>1;
//							}
//							else
//							{
								labelSkinPart.y = Math.round((unscaledHeight - labelSkinPart.height) * .5);
//							}
						}
					}
					
				}
			}
			else
			{
				//Normal Button
				for(var skinId:String in skins)
				{
					var skinPart:DisplayObject = skins[skinId] as DisplayObject;
					//label部分不去约束其大小
					if(skinId == SKIN_LABEL || skinId == SKIN_SELECTED_LABEL || skinId == SKIN_DISABLED_LABEL)
					{
						if(_labelSkinPosition)
						{
							skinPart.x = _labelSkinPosition.x;
							skinPart.y = _labelSkinPosition.y;
						}
						else
						{
//							if(skinPart is UITextField)
//							{
//								skinPart.x = (unscaledWidth - (skinPart as UITextField).textWidth)>>1;
//								skinPart.y = (unscaledHeight - (skinPart as UITextField).textHeight)>>1;
//							}
//							else
//							{
								skinPart.x = Math.round((unscaledWidth - skinPart.width) * .5);
								skinPart.y = Math.round((unscaledHeight - skinPart.height) * .5);
//							}
						}
						continue;
					}
					if(skinId == SKIN_ICON)
					{
						if(_iconSkinPosition)
						{
							skinPart.x = _iconSkinPosition.x;
							skinPart.y = _iconSkinPosition.y;
						}
						else
						{
							skinPart.x = 5;
							skinPart.y = (unscaledHeight - skinPart.height)>>1;
						}
						continue;
						
					}
					skinPart.width = unscaledWidth;
					skinPart.height = unscaledHeight;
				}
			}
		}
		
		protected var skins:Dictionary;
		protected function attachSkin():void
		{
			if(!skins)
				skins = new Dictionary();
			
			//SKIN_LABEL是用UITextfield还是labelSkin。
			if(!isLabelSkin && _label)
			{
				_labelSkin = new UITextField(_labelTextFormat, _labelStroke, _label);
				(_labelSkin as UITextField).validateNow();
			}
				
			
			partAdded(SKIN_LABEL, _labelSkin);
			partAdded(SKIN_SELECTED_LABEL, _labelSelectedSkin);
			partAdded(SKIN_DISABLED_LABEL, _labelDisabledSkin);
			
			partAdded(SKIN_ICON, _iconSkin);
			
			if(!_upSkin)
				_upSkin = new SkinButtonUpScale();
			if(!_overSkin)
				_overSkin = new SkinButtonOverScale();
			if(!_downSkin)
				_downSkin = new SkinButtonDownScale();
			partAdded(SKIN_UP, _upSkin);
			partAdded(SKIN_OVER, _overSkin);
			partAdded(SKIN_DOWN, _downSkin);
			
			partAdded(SKIN_SELECTED_UP, _selectedUpSkin);
			partAdded(SKIN_SELECTED_OVER, _selectedOverSkin);
			partAdded(SKIN_SELECTED_DOWN, _selectedDownSkin);
			
			partAdded(SKIN_DISABLED, _disabledSkin);
		}
		
		protected function detachSkin():void
		{
			if(!skins)
				return;
			for(var skinId:String in skins)
			{
				partRemoved(skinId, skins[skinId] as DisplayObject);
			}
			skins = null;
		}
		
		protected function partAdded(skinId:String, skinPart:DisplayObject):void
		{
			if(!skinPart)
				return;
			
			skins[skinId] = skinPart;
			//要在上层
			if(skinId == SKIN_LABEL || skinId == SKIN_LABEL || skinId == SKIN_LABEL)
			{
				if(skins[SKIN_ICON])
				{
					_hostComponent.addChildAt(skinPart, _hostComponent.numChildren - 1);
				}
				else
				{
					_hostComponent.addChild(skinPart);
				}
			}
			else if(skinId == SKIN_ICON)
			{
				_hostComponent.addChild(skinPart);
			}
			else
			{
				_hostComponent.addChildAt(skinPart, 0);
			}
		}
		
		protected function partRemoved(skinId:String, skinPart:DisplayObject):void
		{
			if(skinPart && _hostComponent.contains(skinPart))
				_hostComponent.removeChild(skinPart);
			delete skins[skinId];
		}
		
		/**
		 * 垃圾回收，此类完全销毁。
		 */		
		public function dispose():void
		{
			_label = null;
			_labelStroke = null;
			_labelTextFormat = _selectedLabelTextFormat = _disabledLabelTextFormat = null;
			_labelSkin = _labelSelectedSkin = _labelSelectedSkin = null;
			_labelSkinPosition = null;
			
			_iconSkin = null;
			_iconSkinPosition = null;
			
			_upSkin = _overSkin = _downSkin = null;
			_selectedUpSkin = _selectedOverSkin = _selectedDownSkin = null;
			_disabledSkin = null;
			
			detachSkin();
			
			_hostComponent = null;
		}
	}
}