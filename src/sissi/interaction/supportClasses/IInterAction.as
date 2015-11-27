package sissi.interaction.supportClasses
{
	import flash.display.DisplayObject;

	/**
	 * InterAction 顾名思义为交互。
	 * InterAction 指的是根据用户的操作习惯和操作需求得出来的一系列的交互行为
	 * InterAction 必须添加到舞台时候才初始化，也只有在舞台上才会起作用
	 * @author Alvin.Ju
	 */	
	public interface IInterAction
	{
		function get hostComponent():DisplayObject;
		/**
		 * 是否已经激活
		 **/
		function get isActive():Boolean;
		
		/**
		 * 激活。
		 */		
		function active():void;
		/**
		 * 取消激活。
		 */		
		function deactive():void;
	}
}