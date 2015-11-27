package sissi.core
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	public interface ISkin extends IEventDispatcher
	{
		function get hostComponent():DisplayObjectContainer;
		/**
		 * 验证是否需要更新Skin
		 */		
		function validateSkinChange():void;
		
		function get measuredWidth():Number;
		function get measuredHeight():Number;
		
		/**
		 * 对Skin大小进行变更和布局
		 * 仅仅是setActualSize并不准确，因为有时候还是要改变x,y，因此还是取名为updateDisplayList
		 * Skin的大小和布局相对来说比较确定，主要是hostComponent的width,height，
		 * 看具体情况可以确认是否加入oldUnscaledWidth oldUnscaledHeight来判断大小是否变更进行优化。
		 */		
		function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		
		/**
		 * 在hostComponent
		 */		
		function dispose():void;
		
//		function set backgroundAlpha(value:Number):void;
//		function get backgroundAlpha():Number;
//		
//		function set backgroundColor(value:uint):void;
//		function get backgroundColor():uint;
//		
//		function set borderAlpha(value:Number):void;
//		function get borderAlpha():Number;
//		
//		function set borderColor(value:uint):void;
//		function get borderColor():uint;
	}
}