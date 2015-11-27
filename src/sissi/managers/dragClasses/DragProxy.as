package sissi.managers.dragClasses
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import sissi.core.Application;
	import sissi.core.DragSource;
	import sissi.core.IApplication;
	import sissi.core.SissiManager;
	import sissi.core.UIGroup;
	import sissi.core.sissi_internal;
	import sissi.events.DragEvent;
	import sissi.managers.DragManager;
	
	use namespace sissi_internal;
		
	public class DragProxy extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * 拖拽物品的目标容器。
		 */		
		public var target:DisplayObject;
		/**
		 * 是否在拖动。
		 */		
		public var bDoingDrag:Boolean;
		
		/**
		 * 发起该拖曳的发起组件
		 **/		
		private var dragInitiator:DisplayObject;
		/**
		 * 拖动的真实数据。
		 */
		private var dragSource:DragSource;
		/**
		 * 鼠标事件。
		 */		
		private var mouseEvent:MouseEvent;
		/**
		 * 拖曳代理相对于鼠标的X位移
		 */
		private var xOffset:Number = 0;
		/**
		 * 拖曳代理相对于鼠标的Y位移
		 */
		private var yOffset:Number = 0;
		/**
		 * 拖拽物体的起始坐标
		 */
		private var startX:Number;
		/**
		 * 拖拽物体的起始坐标
		 */
		private var startY:Number;
		/**
		 * 拖拽的时候显示的图标。
		 */		
		private var dragImage:DisplayObject;
		/**
		 * 拖动时图标的缩放尺寸 
		 */
		private var imageScale:Number;
		/**
		 * 触发拖动的最小距离。
		 */
		private static const MIN_DRAG_OFFSET:int = 10;
		/**
		 * 主程序。
		 */		
		private function get application():IApplication
		{
			return Application.application
		}
		
		/**
		 * X素材。
		 */		
		[Embed(source="close.png")]
		private var ImgX:Class;
		/**
		 * 错误提示。
		 **/
		private var rejectCursor:Bitmap;
		
		/**
		 * 拖动代理。
		 * @param dragInitiator 拖动原始目标
		 * @param dragSource 拖动数据
		 * @param mouseEvent 拖动鼠标事件
		 * @param dragImage 拖动时候显示的图像
		 * @param xOffset 偏移坐标X
		 * @param yOffset 偏移坐标Y
		 * @param imageAlpha 拖动图像alpha值
		 */		
		public function DragProxy(dragInitiator:DisplayObject, 
								  dragSource:DragSource, 
								  mouseEvent:MouseEvent,
								  dragImage:DisplayObject = null,
								  xOffset:Number = 0,
								  yOffset:Number = 0,
								  imageAlpha:Number = 0.7,
								  imageScale:Number = 1.0)
		{
			super();			
			this.dragInitiator = dragInitiator;
			this.dragSource = dragSource;
			this.mouseEvent = mouseEvent;
			this.dragImage = dragImage;
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			this.alpha = imageAlpha;
			this.imageScale = imageScale;
			mouseEnabled = mouseChildren = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * 只有不是在Sissi系统才临时有用。
		 * 为了获取到鼠标事件。
		 */		
		private var mouseCatcher:Sprite;
		
		/**
		 * 是否在Sissi系统下还是纯Flash下。
		 */		
		private var applicationSystem:DisplayObject;
		//--------------------------------------------------------------------
		//Event handler  		开始监听MouseMove,mouseUp事件
		//--------------------------------------------------------------------
		protected function addedToStageHandler(event:Event):void
		{
			//适用于非Sissi系统的一些设置。
			if(!application)
			{
				if(!mouseCatcher)
					mouseCatcher = new Sprite();
				SissiManager.getStage(this).addChildAt(mouseCatcher, 0);
				var g:Graphics = mouseCatcher.graphics;
				g.clear();
				g.beginFill(0x000000, 0);
				var w:Number;
				var h:Number;
				try
				{
					w = loaderInfo.width;
					h = loaderInfo.height;
				}
				catch(e:Error)
				{
					w = SissiManager.getStage(this).stageWidth;
					h = SissiManager.getStage(this).stageHeight;
				}
				g.drawRect(0, 0, w, h);
				g.endFill();
			}
			//判断检查原件的时候需要参考的最顶父容器。
			applicationSystem = application != null ? application as DisplayObject : stage.loaderInfo.content;
			
			// Find mouse coordinates in global space
			var nonNullTarget:Object = mouseEvent.target;
			if (nonNullTarget == null)
				nonNullTarget = dragInitiator;
			var point:Point = new Point(mouseEvent.localX, mouseEvent.localY);
			point = DisplayObject(nonNullTarget).localToGlobal(point);
			point = DisplayObject(applicationSystem).globalToLocal(point);
			//			trace(point.x, point.y);
			
			// Find the proxy origin in global space
			var proxyOrigin:Point = DisplayObject(dragInitiator).localToGlobal(new Point(-xOffset, -yOffset));
			proxyOrigin = DisplayObject(applicationSystem).globalToLocal(proxyOrigin);
			//			trace(proxyOrigin.x, proxyOrigin.y);
			
			// Set dragProxy.offset to the mouse offset within the drag proxy.
			this.xOffset = point.x - proxyOrigin.x;
			this.yOffset = point.y - proxyOrigin.y;
			
			// Setup the initial position of the drag proxy.
			this.x = proxyOrigin.x;
			this.y = proxyOrigin.y;
			// Remember the starting location of the drag proxy so it can be
			// "snapped" back if the drop was refused.
			startX = this.x;
			startY = this.y;
			
			SissiManager.getStage(this).addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			SissiManager.getStage(this).addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			SissiManager.getStage(this).addEventListener(Event.DEACTIVATE, dropRefusedHandler);
			SissiManager.getStage(this).addEventListener(Event.MOUSE_LEAVE, dropRefusedHandler);
		}		
		
		//移除监听
		private function removeListener():void
		{
			if(SissiManager.getStage(this))
			{
				SissiManager.getStage(this).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				SissiManager.getStage(this).removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				SissiManager.getStage(this).removeEventListener(Event.DEACTIVATE, dropRefusedHandler);
				SissiManager.getStage(this).removeEventListener(Event.MOUSE_LEAVE, dropRefusedHandler);
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function mouseMoveHandler(event:MouseEvent):void
		{
			//判断是否已经开始拖动。
			if(!bDoingDrag)
			{
				var minX:int = event.stageX - startX;
				var minY:int = event.stageY - startY;
				minX = minX > 0 ? minX : -minX;
				minY = minY > 0 ? minY : -minY;
				if(minX > MIN_DRAG_OFFSET || minY > MIN_DRAG_OFFSET)
				{
					//符合条件，开始拖动，并且创建拖动图像。
					bDoingDrag = true;
					//开始事件。
					dispatchDragEvent(DragEvent.DRAG_START, dragInitiator);
					createDragImage();
				}
				else
				{
					return;
				}
			}
			
			//计算出DragProxy的位置。
			var pt:Point = new Point();
			var point:Point = new Point(event.localX, event.localY);
			var stagePoint:Point = DisplayObject(event.target).localToGlobal(point);
			point = DisplayObject(applicationSystem).globalToLocal(stagePoint);
			
			var mouseX:Number = point.x;
			var mouseY:Number = point.y;
			x = mouseX - xOffset;
			y = mouseY - yOffset;
			event.updateAfterEvent();
			
			//获得对象，并对对象分别派送拖动事件。
			var dropTarget:DisplayObject;
			var targetList:Array = [];

			//获得鼠标经过的对象。
			getObjectsUnderDragPoint(applicationSystem, new Point(event.stageX, event.stageY), targetList);
			
			// targetList is in depth order, and we want the top of the list. However, we
			// do not want the target to be a decendent of us.
			var targetIndex:int = targetList.length -1;
            var newTarget:DisplayObject = null;
			while(targetIndex >= 0)
			{
				newTarget = targetList[targetIndex];
				if (newTarget != this && !contains(newTarget))
					break;
				targetIndex--;
			}
			
			// If we already have a target, send it a dragOver event
			// if we're still over it.
			// If we're not over it, send it a dragExit event.
//			trace(target);
//			trace("newTarget", newTarget);
//			trace("targetList", targetList.length);
			if(target)
			{
				var foundIt:Boolean = false;
				var oldTarget:DisplayObject = target;
				dropTarget = newTarget;
				while(dropTarget)
				{
					//dragOver
					if(dropTarget == target)
					{
						//target.dispatchEvent(new DragEvent(DragEvent.DRAG_OVER));
						// trace("    dispatch DRAG_OVER on", dropTarget);
						// Dispatch a "dragOver" event
						dispatchDragEvent(DragEvent.DRAG_OVER, dropTarget);
						foundIt = true;
						//是否显示出拒绝的图标。
						rejectCursor.visible = false;
						break;
					}					
					else
					{
						// Dispatch a "dragEnter" event and see if a new object
						// steals the target.
						dispatchDragEvent(DragEvent.DRAG_ENTER, dropTarget);
						// If the potential target accepted the drag, our target
						// now points to the dropTarget. Bail out here, but make 
						// sure we send a dragExit event to the oldTarget.
						if(target == dropTarget)
						{
							foundIt = false;
							//是否显示出拒绝的图标。
							rejectCursor.visible = true;
							break;
						}
					}
					dropTarget = dropTarget.parent;
					
					
				}
				
				if(!foundIt)
				{
					// Dispatch a "dragExit" event on the old target.
					dispatchDragEvent(DragEvent.DRAG_EXIT, oldTarget);
					if(target == oldTarget)
						target = null;
				}
			}	
			
			// If we don't have an existing target, go look for one.
			if(!target)
			{
				// Dispatch a "dragEnter" event.
				dropTarget = newTarget;
				while(dropTarget)
				{
					//dragEnter
					if(dropTarget != this)
					{
						dispatchDragEvent(DragEvent.DRAG_ENTER, dropTarget);
						rejectCursor.visible = true;
						if(target)
							break;
					}
					dropTarget = dropTarget.parent;
				}
			}
		}	
				
		/**
		 * 生成拖动图片。
		 */		
		private function createDragImage():void
		{
			if(!rejectCursor)
			{
				rejectCursor = new ImgX();
			}
			//如果dragImage有值，那么使用传进来的图像，如果没有，则默认使用dragInitiator的图像。
			if(!dragImage)
			{
				dragImage = new Bitmap(null,"auto",true);
				(dragImage as Bitmap).bitmapData = new BitmapData(dragInitiator.width, dragInitiator.height, true, 0x00000000);
				(dragImage as Bitmap).bitmapData.draw(dragInitiator);
			}
			dragImage.scaleX = dragImage.scaleY = imageScale;
			if(dragImage is Bitmap)
			{
				(dragImage as Bitmap).smoothing = true;
			}
			rejectCursor.x = dragImage.width - rejectCursor.width;
			rejectCursor.y = dragImage.height - rejectCursor.height;
			addChild(dragImage);
			addChild(rejectCursor);
		}
		
		/**
		 * 鼠标放手后的处理。
		 * 一种是正确扔到了可以放的容器里。
		 * 一种则是没有，则需要有个动画来过渡回原来的位置。
		 * @param event
		 */		
		private function mouseUpHandler(event:MouseEvent):void
		{
			//是否正在拖动，还是只是没有拖动就已经放弃。
			if(bDoingDrag)
			{
				if(target)
				{
					dispatchDragEvent(DragEvent.DRAG_DROP, target);
					removeListener();
					dragEnd();
				}
				else
				{					
					dropRefusedHandler();
				}	
			}
			else
			{
				//取消拖动。
				removeListener();
				dragEnd();
			}
		}
		
		/**
		 * 扔到不可接受区域时，返回原定位置的动画。
		 */		
		private function dropRefusedHandler(e:Event = null):void
		{
			if(rejectCursor)
				rejectCursor.visible = false;
			
			//清除监听
			removeListener();
			
			var subX:Number = (x - this.startX)/10;
			var subY:Number = (y - this.startY)/10;
			var timer:Timer = new Timer(20, 10);
			timer.addEventListener(TimerEvent.TIMER, tweenToStart);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, immediatelyDestroy);
			timer.start();
			function tweenToStart(e:TimerEvent):void
			{
				x -= subX;
				y -= subY;
				e.updateAfterEvent();
			}
			
			function immediatelyDestroy(e:TimerEvent):void
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, tweenToStart);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, immediatelyDestroy);
				timer = null;
				dragEnd();
			}
		}
		
		/**
		 * 拖拽结束。
		 */		
		private function dragEnd():void
		{
			bDoingDrag = false;
			
			//适用于非Sissi系统。
			if(!application)
			{
				if(mouseCatcher)
				{
					if(SissiManager.getStage(this).contains(mouseCatcher))
						SissiManager.getStage(this).removeChild(mouseCatcher);
					
					mouseCatcher = null;
				}
			}
			
			//完成事件。
			dispatchDragEvent(DragEvent.DRAG_COMPLETE, dragInitiator);
			
			if(dragImage is Bitmap)
				(dragImage as Bitmap).bitmapData.dispose();
			if(dragImage is MovieClip)
				(dragImage as MovieClip).stop();
			if(dragImage && contains(dragImage))
				removeChild(dragImage);
			dragImage = null;
			dragInitiator = null;
			dragSource = null;
			mouseEvent = null;
			
			//告诉Manager停止拖动。
			DragManager.endDrag();
		}
		
		/**
		 * 
		 * @param type
		 * @param mouseEvent
		 * @param eventTarget
		 */
		private function dispatchDragEvent(type:String, eventTarget:Object):void
		{
			eventTarget.dispatchEvent(new DragEvent(type, dragInitiator, dragSource));
		}
		
		//--------------------------------------------------------------------------
		//
		//  can be static Methods
		//
		//--------------------------------------------------------------------------
		private function getObjectsUnderDragPoint(obj:DisplayObject, pt:Point, arr:Array):void
		{
			if (!obj.visible)
				return;
			
			//计算obj是否与stagePoint点有相交
			if(obj.hitTestPoint(pt.x,pt.y,true))
			{	
				//如果obj是可交互对象
				if(obj is InteractiveObject && InteractiveObject(obj).mouseEnabled)
					arr.push(obj);
				//obj是个容器
				if(obj is DisplayObjectContainer)
				{
					var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
					//如果doc的子对象接受鼠标事件。
					if(doc.mouseChildren)
					{
						var n:int;
						if(doc is Application)
						{
							n = Application(doc).sissi_internal::numChildren;
						}
						else
						{
							n = doc.numChildren
						}
						if(n > 0)
						{
							for(var i:int = 0;i<=n;i++)
							{
								try
								{
									var child:DisplayObject;
									if(doc is UIGroup)
									{
										child = UIGroup(doc).sissi_internal::getChildAt(i);
									}
									else if(doc is Application)
									{
										child = Application(doc).sissi_internal::getChildAt(i);
									}
									else
									{
										child = doc.getChildAt(i);
									}
									getObjectsUnderDragPoint(child, pt, arr);
								}
								catch(e:Error)
								{
								}
							}
						}
					}
				}
			}
		}
	}
}