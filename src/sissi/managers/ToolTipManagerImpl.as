package sissi.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sissi.components.ToolTip;
	import sissi.core.IAlignTooltip;
	import sissi.core.IToolTip;
	import sissi.core.IToolTipHost;
	import sissi.layouts.HorizontalAlign;
	import sissi.layouts.VerticalAlign;
	import sissi.utils.HitTestUtil;

	public class ToolTipManagerImpl
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//----------------------------------
		//  currentTarget
		//----------------------------------
		/**
		 * 目前显示Tooltip的UI，若没有则为null。
		 */
		public var currentTarget:DisplayObject;
		
		//----------------------------------
		//  currentToolTip
		//----------------------------------
		/**
		 * 目前显示的toolTip，若没有则显示为null
		 */
		public var currentToolTip:IToolTip;
		
		//----------------------------------
		//  toolTipClass
		//----------------------------------
		/**
		 * 显示toolTip的类型
		 */
		public var currentToolTipClass:Class;
		
		//----------------------------------
		//  currentToolTipData
		//----------------------------------
		/**
		 * 目前显示的toolTip的数据。可以为具体数值，也可以是函数。
		 */
		public var currentToolTipData:*;
		
		//----------------------------------
		//  toolTipPositionFunction
		//----------------------------------
		/**
		 * 显示toolTip的位置（相对组件自己的位置）。
		 */
		public var currentToolTipPosition:*;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ToolTipManagerImpl()
		{
			if(_instance)
				throw new Error("TooltipManager instance already exists.");
		}
		
		private static var _instance:ToolTipManagerImpl;
		public static function getInstance():ToolTipManagerImpl
		{
			if(!_instance)
			{
				_instance = new ToolTipManagerImpl();
			}
			return _instance;
		}

		//--------------------------------------------------------------------------
		//
		//  Public functions
		//
		//--------------------------------------------------------------------------
		private var toolTipLayer:DisplayObjectContainer;
		/**
		 * 注册ToolTip存放位置。
		 * @param value
		 */		
		public function registerToolTipLayer(layer:DisplayObjectContainer):void
		{
			toolTipLayer = layer;
		}
		
		/**
		 * 对target注册Tooltip，显示出相应的toolTip。
		 * 其中toolTipData不仅能够支持简单的Object类型，还能接受Function类型。
		 * @param target 被注册的组件
		 * @param toolTipData 被注册的数据。
		 */		
		public function registerToolTip(target:DisplayObject, toolTipData:*):void
		{
			if(!toolTipLayer)
				return;
			
			this.currentToolTipData = toolTipData;
			this.currentTarget = target;
			currentTarget.addEventListener(MouseEvent.MOUSE_OVER, toolTipMouseOverHandler);
			currentTarget.addEventListener(MouseEvent.MOUSE_OUT, toolTipMouseOutHandler);
			checkIfTooltipChanged(target);
		}
		
		public function unRegisterToolTip(target:DisplayObject):void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER, toolTipMouseOverHandler);
			target.removeEventListener(MouseEvent.MOUSE_OUT, toolTipMouseOutHandler);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, toolTipMouseMoveHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private functions
		//
		//--------------------------------------------------------------------------
		/**
		 * 鼠标移动到注册组件上响应事件。
		 * @param event MouseEvent.MOUSE_OVER
		 */
		private function toolTipMouseOverHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(DisplayObject(event.currentTarget));
		}

		/**
		 * 鼠标从注册组件上移开的响应事件。
		 * 若有ToolTip显示，则进行删除。
		 * @param event MouseEvent.MOUSE_OUT
		 */
		private function toolTipMouseOutHandler(event:MouseEvent):void
		{
			//例如，发生 mouseOut 事件时，relatedObject 表示指针设备当前所指向的显示列表对象。此属性应用于 mouseOut、mouseOver、rollOut 和 rollOver 事件。
			checkIfTargetChanged(event.relatedObject);
		}
		
		//先前显示Tooltip的UI，若没有则为null。
		private var previousTarget:DisplayObject;
		
		/**
		 * 判断目标是否发生变化。
		 * 发生变化则需对ToolTip要显示出的显示类型和显示数据重新赋值。
		 * @param displayObject
		 */
		private function checkIfTargetChanged(displayObject:DisplayObject):void
		{
			findTarget(displayObject);
			if(currentTarget != previousTarget)
			{
				targetChanged();
				previousTarget = currentTarget;
			}
		}
		
		private function checkIfTooltipChanged(displayObject:DisplayObject):void
		{
			findTarget(displayObject);
			if(currentTarget == previousTarget)
			{
				targetChanged();
				previousTarget = currentTarget;
			}
		}
		
		/**
		 * 如果目标是IToolTipHost，则进行赋值。
		 * @param displayObject
		 */
		private function findTarget(displayObject:DisplayObject):void
		{
			currentToolTipPosition = currentToolTipClass = currentToolTipData = null;
			currentTarget = null;
			
			while(displayObject)
			{
				if(displayObject is IToolTipHost)
				{
					currentToolTipData = IToolTipHost(displayObject).toolTip;
					currentToolTipClass = IToolTipHost(displayObject).toolTipClass;
					currentToolTipPosition = IToolTipHost(displayObject).toolTipPosition;
					if(currentToolTipData)
					{
						currentTarget = displayObject;
						return;
					}
				}
				displayObject = displayObject.parent;
			}
		}
		
		/**
		 * 目标发生变化
		 */
		private function targetChanged():void
		{
			if(currentToolTip)
			{
				// Remove it.
				//var currentToolTipSM:ISystemManager = currentToolTip.systemManager as ISystemManager;
				//currentToolTipSM.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", currentToolTip as DisplayObject);
				if(toolTipLayer)
				{
					toolTipLayer.removeChildren();
				}
				currentToolTip = null;
			}
			if(previousTarget)
				previousTarget.removeEventListener(MouseEvent.MOUSE_MOVE, toolTipMouseMoveHandler);
			
			if(currentTarget)
			{
				// Don't display empty tooltips.
				if(!currentToolTipData)
					return;
				
				if(currentToolTipClass)
					currentToolTip = new currentToolTipClass();
				else
					currentToolTip = new ToolTip();
				
				//var appSM:ISystemManager = getSystemManager() as ISystemManager;
				//appSM.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", currentToolTip as DisplayObject);
				if(toolTipLayer)
				{
					toolTipLayer.addChild(currentToolTip as DisplayObject);
				}
				
				//Data
				if(currentToolTipData is Function)
				{
					currentToolTip.data = currentToolTipData();
				}
				else
				{
					currentToolTip.data = currentToolTipData;
				}
				
				//Position
				if(currentToolTipPosition)
				{
					if(currentToolTipPosition is Function)
					{
						if(currentToolTipPosition() is Point)
						{
							moveTipPosition(currentToolTipPosition());
						}
						else
						{
							moveTipPosition();
						}
					}
					else if(currentToolTipPosition is Point)
					{
						moveTipPosition(currentToolTipPosition);
					}
					else
					{
						moveTipPosition();
					}
				}
				else
				{
					moveTipPosition();
				}
			}
		}
		
		/**
		 * 如何排版鼠标的位置。
		 */
		private function moveTipPosition(pt:Point = null):void
		{
			if(currentTarget && currentToolTip)
			{
//				//真正的位置
//				var realPt:Point;
//				//有明确目标位置的情况
//				var hasTagetPt:Boolean;
				if(pt)
				{
//					hasTagetPt = true;
//					realPt = currentTarget.localToGlobal(pt);
					checkToolTipRangePosition(pt, true);
				}
				else
				{
//					realPt = currentTarget.localToGlobal(new Point(currentTarget.mouseX, currentTarget.mouseY));
					if(currentTarget)
						currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, toolTipMouseMoveHandler);
					checkToolTipRangePosition(currentTarget.localToGlobal(new Point(currentTarget.mouseX, currentTarget.mouseY)), false);
				}
//				checkToolTipRangePosition(currentTarget, pt, hasTagetPt);
			}
		}
		
		/**
		 * 默认的ToolTip的位置使用鼠标跟踪。
		 */
		private function toolTipMouseMoveHandler(event:MouseEvent):void
		{
			if(currentTarget && currentToolTip)
			{
				checkToolTipRangePosition(new Point(event.stageX, event.stageY),false);
				event.updateAfterEvent();
			}
		}
		
		/**
		 * 
		 * @param x
		 * @param y
		 * @param hasTagetPt 有明确目标位置的情况不需要限制visable为false。
		 */		
		private function checkToolTipRangePosition(targetP:Point, isCustomPoint:Boolean = false):void
		{
			var toolTip:DisplayObject = currentToolTip as DisplayObject
			var stage:Stage = toolTip.stage;
			if(stage && toolTip)
			{
				if(isCustomPoint)
				{
					toolTip.visible = true;
					if(currentTarget && (currentTarget as IToolTipHost).toolTipShapeFlag)
					{
						if(!HitTestUtil.hitTestPoint(currentTarget, currentTarget.localToGlobal(new Point(currentTarget.mouseX, currentTarget.mouseY))))
						{
							toolTip.visible = false;
						}
					}
				}
				else
				{
					//因为在最右边会出现闪动的情况，原因是因为toolTip可能还来不及算width&height，因此，目前如果任意一个为NaN，就不显示了。
					if(isNaN(toolTip.width) || isNaN(toolTip.height))
					{
						toolTip.visible = false;
					}
					else
					{
						toolTip.visible = true;
						
						if(currentTarget && (currentTarget as IToolTipHost).toolTipShapeFlag)
						{
							if(!HitTestUtil.hitTestPoint(currentTarget, currentTarget.localToGlobal(new Point(currentTarget.mouseX, currentTarget.mouseY))))
							{
								toolTip.visible = false;
							}
						}
					}
				}

				var toX:Number;
				var toY:Number;
				var realPoint:Point = isCustomPoint? currentTarget.localToGlobal(targetP) : targetP;
				var padding:int = isCustomPoint? 0:PADDING;
				var hAlign:String;
				var vAlign:String;
				
				if(realPoint.x + padding + toolTip.width < stage.stageWidth)
					hAlign = HorizontalAlign.LEFT;
				else
					hAlign = HorizontalAlign.RIGHT;
				if(realPoint.y + padding + toolTip.height < stage.stageHeight)
					vAlign = VerticalAlign.TOP;
				else
					vAlign = VerticalAlign.BOTTOM;
				
				if(toolTip is IAlignTooltip)
				{
					IAlignTooltip(toolTip).horizontalAlign = hAlign;
					IAlignTooltip(toolTip).verticalAlign = vAlign;
				}
				
				if(isCustomPoint)
				{
					var targetPoint:Point = currentTarget.localToGlobal(new Point());
					toX = hAlign == HorizontalAlign.LEFT ? realPoint.x : targetPoint.x - toolTip.width;
					toY = vAlign == VerticalAlign.TOP ? realPoint.y : targetPoint.y - (targetPoint.y + toolTip.height - stage.stageHeight);
				}
				else
				{
					toX = hAlign == HorizontalAlign.LEFT ? (realPoint.x + PADDING) : (realPoint.x + PADDING - toolTip.width);
					toY = vAlign == VerticalAlign.TOP ? (realPoint.y + PADDING) : (realPoint.y + PADDING - (realPoint.y + PADDING + toolTip.height - stage.stageHeight));
				}
				
				
				
				toX = toX < 0 ? 0 : toX;
				toolTip.x = toX;
				
				toY = toY < 0 ? 0 : toY;
				toolTip.y = toY;
			}
		}
		private const PADDING:int = 12;
	}
}