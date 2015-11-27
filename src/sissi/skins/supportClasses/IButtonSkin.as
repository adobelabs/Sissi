package sissi.skins.supportClasses
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import sissi.core.ISkin;

	public interface IButtonSkin extends ISkin
	{
		function get label():String;
		function set label(value:String):void;
		
		function get labelStroke():Array;
		function set labelStroke(value:Array):void;
			
		function get labelTextFormat():TextFormat;
		function set labelTextFormat(value:TextFormat):void;
		function get selectedLabelTextFormat():TextFormat;
		function set selectedLabelTextFormat(value:TextFormat):void;
		function get disabledLabelTextFormat():TextFormat
		function set disabledLabelTextFormat(value:TextFormat):void
			
		function get labelSkin():DisplayObject;
		function set labelSkin(value:DisplayObject):void;
		function get labelSelectedSkin():DisplayObject;
		function set labelSelectedSkin(value:DisplayObject):void;
		function get labelDisabledSkin():DisplayObject;
		function set labelDisabledSkin(value:DisplayObject):void;
		
		function get labelSkinPosition():Point;
		function set labelSkinPosition(value:Point):void;
		
		function get iconSkin():DisplayObject;
		function set iconSkin(value:DisplayObject):void;
		function get iconSkinPosition():Point;
		function set iconSkinPosition(value:Point):void;
		
		function get upSkin():DisplayObject;
		function set upSkin(value:DisplayObject):void;
		function get overSkin():DisplayObject;
		function set overSkin(value:DisplayObject):void;
		function get downSkin():DisplayObject;
		function set downSkin(value:DisplayObject):void;
		
		function get selectedUpSkin():DisplayObject;
		function set selectedUpSkin(value:DisplayObject):void;
		function get selectedOverSkin():DisplayObject;
		function set selectedOverSkin(value:DisplayObject):void;
		function get selectedDownSkin():DisplayObject;
		function set selectedDownSkin(value:DisplayObject):void;
		
		function get disabledSkin():DisplayObject;
		function set disabledSkin(value:DisplayObject):void;
		
		/**
		 * 验证是否更改现有的状态
		 */		
		function currentStateChanged():void;
	}
}