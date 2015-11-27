package sissi.components
{
	import flash.display.Graphics;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sissi.core.IToolTip;
	import sissi.core.UIComponent;
	import sissi.core.UITextField;
	import sissi.skin.SkinTooltipBg;
	
	public class ToolTip extends UIComponent implements IToolTip
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  data
		//----------------------------------
		private var _data:Object;
		private var dataChanged:Boolean;
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
			
			dataChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ToolTip()
		{
			super();
			mouseEnabled = mouseChildren = false;
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
		private var textField:UITextField;
		private var bg:SkinTooltipBg;
		override protected function createChildren():void
		{
			if(!bg)
			{
				bg = new SkinTooltipBg();
				addChild(bg);
			}
			if(!textField)
			{
				textField = new UITextField();
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.mouseEnabled = false;
				textField.multiline = true;
				textField.selectable = false;
				textField.wordWrap = false;
				textField.color = 0x444444;
				textField.x = PADDING_WIDTH;
				textField.y = PADDING_HEIGHT;
				addChild(textField);
			}
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			if (dataChanged)
			{
				var textFormat:TextFormat = textField.getTextFormat();
				textField.defaultTextFormat = textFormat;
				
				textField.text = _data.toString();
				textField.validateNow();
				dataChanged = false;
			}
		}
		private static const PADDING_WIDTH:int = 2;
		private static const PADDING_HEIGHT:int = 1;
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = textField.width + PADDING_WIDTH * 2;
			measuredHeight = textField.height + PADDING_HEIGHT * 2;
		}
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			if(bg)
			{
				bg.width = w;
				bg.height = h;
			}
		}
	}
}