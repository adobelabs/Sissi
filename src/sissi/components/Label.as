package sissi.components
{
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sissi.core.UIComponent;
	import sissi.core.UITextField;
	
	public class Label extends UITextField
	{
		public function Label(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super(textFormat, textStroke, textValue, isHTML);
			mouseEnabled = selectable = false;
		}
	}
}