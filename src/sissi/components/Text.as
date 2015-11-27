package sissi.components
{
	import flash.text.TextFormat;
	
	public class Text extends Label
	{
		public function Text(textFormat:TextFormat = null, textStroke:Array = null, textValue:String = "", isHTML:Boolean = false)
		{
			super(textFormat, textStroke, textValue, isHTML);
			multiline = true;
			wordWrap = true;
			mouseWheelEnabled = false;
		}
	}
}