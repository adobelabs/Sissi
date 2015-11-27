package sissi.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sissi.core.Application;
	import sissi.core.IApplication;
	import sissi.core.IFactory;
	import sissi.core.SissiManager;
	import sissi.core.UIComponent;
	import sissi.events.ListItemEvent;
	import sissi.layouts.LayoutDirection;
	import sissi.skin.SkinComboBoxDownScale;
	import sissi.skin.SkinComboBoxOverScale;
	import sissi.skin.SkinComboBoxUpScale;

	public class ComboBox extends UIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  label
		//----------------------------------
		private var _label:String;
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  labelStroke
		//----------------------------------
		private var _labelStroke:Array;
		public function get labelStroke():Array
		{
			return _labelStroke;
		}
		public function set labelStroke(value:Array):void
		{
			_labelStroke = value;
			
			invalidateProperties();
			invalidateDisplayList();
		}

		//----------------------------------
		//  labelStroke
		//----------------------------------
		private var _labelTextFormat:TextFormat;
		public function get labelTextFormat():TextFormat
		{
			return _labelTextFormat;
		}
		public function set labelTextFormat(value:TextFormat):void
		{
			_labelTextFormat = value;
			
			invalidateProperties();
			invalidateDisplayList();
		}

		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		private var dataProviderChanged:Boolean;
		/**
		 * 数据源。
		 * 可以为Array或者Vector.
		 **/
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			
			dataProviderChanged = true;
			invalidateProperties();
		}
		
		//----------------------------------
		//  showCount
		//----------------------------------
		private var _showCount:int;
		/**
		 * 显示的个数，如果设置了，则不会参考相应的width和height值。
		 **/
		public function get showCount():int
		{
			return _showCount;
		}
		
		private var _listItemRenderer:IFactory;
		/**
		 * 重复的类对象。
		 */	
		public function get listItemRenderer():IFactory
		{
			return _listItemRenderer;
		}
		
		//----------------------------------
		//  openPosition
		//----------------------------------
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		private var _openPosition:String = BOTTOM;
		/**
		 * 设置当点击ComboBox时候，List的位置。
		 */
		public function set openPosition(value:String):void
		{
			_openPosition = value;
		}
		public function get openPosition():String
		{
			return _openPosition;
		}
		
		//----------------------------------
		//  isOpen
		//----------------------------------
		private var _open:Boolean;
		/**
		 * 判断现在ComboBox是否处理打开状态。
		 */
		public function get isOpen():Boolean
		{
			return _open;
		}
		
		//----------------------------------
		//  virtualMode
		//----------------------------------
		private var _virtualMode:Boolean;
		/**
		 * 判断现在ComboBox是否处理打开状态。
		 */
		public function get virtualMode():Boolean
		{
			return _virtualMode;
		}
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ComboBox(listShowCount:int = 3, listItemRenderer:IFactory = null, listVirtualMode:Boolean = true)
		{
			super();
			_showCount = listShowCount;
			_listItemRenderer = listItemRenderer;
			_virtualMode = listVirtualMode;
			setSize(200, 31);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: LifeCycle
		//
		//--------------------------------------------------------------------------
		private var btn:Button;
		private var lst:List;
		override protected function createChildren():void
		{
			if(!btn)
			{
				btn = new Button();
				btn.skin.overSkin = new SkinComboBoxOverScale();
				btn.skin.downSkin = new SkinComboBoxDownScale();
				btn.skin.upSkin = new SkinComboBoxUpScale();
				btn.addEventListener(MouseEvent.CLICK, handleBtnClick);
				addChild(btn);
			}
			if(!lst)
			{
				lst = new List(LayoutDirection.VERTICAL, _virtualMode);
				lst.itemRenderer = listItemRenderer;
				lst.showCount = _showCount;
				lst.addEventListener(ListItemEvent.ITEM_TOUCHED, handleListItemSelected);
				lst.verticalScrollEnable = true;
//				lst.background = true;
				lst.enableMouseWheel = true;
			}
		}
		override protected function commitProperties():void
		{
			btn.skin.label = _label;
			btn.skin.labelStroke = _labelStroke;
			btn.skin.labelTextFormat = _labelTextFormat;
			
			if(dataProviderChanged)
				lst.dataProvider = _dataProvider;
		}
		override protected function measure():void
		{
		}
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			btn.setSize(unscaledWidth, unscaledHeight);
			btn.validateNow();
		}
		//--------------------------------------------------------------------------
		//
		//  Public functions
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Protected functions
		//
		//--------------------------------------------------------------------------
		/**
		 * 查看是否在Sissi Application系统下面。
		 */		
		private var application:IApplication = Application.application;
		/**
		 * 点击ComboBox.
		 * 如果List已经打开状态，则关闭，
		 * 如果List关闭状态，则打开。
		 */		
		protected function handleBtnClick(event:Event = null):void
		{
			_open = !_open;
			if(_open)
			{
				//根据实际情况，获得添加List的父组件。
				if(application)
				{
					application.addPopUpChild(lst);
				}
				else
				{
					//Stage的话可能不会主动初始化
					if(!lst.initialized)
						lst.initialize();
					
					SissiManager.getStage(this).addChild(lst);
				}
				
				var point:Point = new Point();
				point.y = _openPosition == BOTTOM ? height : -lst.height;
				point = this.localToGlobal(point);
				lst.move(point.x, point.y);
				
				SissiManager.getStage(this).addEventListener(MouseEvent.CLICK, onStageClick);
			}
			else
			{
				removeList();
			}
		}
		
		/**
		 * 点击List里面的物件，进行赋值显示。
		 * @param event
		 */		
		protected function handleListItemSelected(event:ListItemEvent):void
		{
			btn.label = lst.dataProvider[event.itemIndex];
			var changeEvent:ListItemEvent = new ListItemEvent(ListItemEvent.COMBOBOX_VALUE_CHANGED, event.itemIndex);
			changeEvent.itemIndex = event.itemIndex;
			dispatchEvent(changeEvent);
			_open = false;
			removeList();
		}
		
		/**
		 * 点击List外，关闭List。
		 **/
		private function onStageClick(event:MouseEvent):void
		{
			if(event.target == btn)
				return;
			
			if(event.target is ScrollBar)
				return;
			if(new Rectangle(lst.x, lst.y, lst.width, lst.height).contains(event.stageX, event.stageY))
				return;
			
			_open = false;
			removeList();
		}
		
		
		
		/**
		 * 关掉List列表。
		 */		
		private function removeList():void
		{
			//根据实际情况，获得添加List的父组件。
			if(application)
			{
				if(application.containsPopUpChild(lst))
					application.removePopUpChild(lst);
			}
			else
			{
				if(SissiManager.getStage(this).contains(lst))
					SissiManager.getStage(this).removeChild(lst);
				SissiManager.getStage(this).removeEventListener(MouseEvent.CLICK, onStageClick);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
	}
}