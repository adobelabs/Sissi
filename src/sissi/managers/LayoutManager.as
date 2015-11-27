package sissi.managers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sissi.core.IUIComponent;
	import sissi.core.SissiManager;
	import sissi.core.sissi_internal;
	import sissi.managers.layoutClasses.PriorityQueue;
	
	use namespace sissi_internal;
	public class LayoutManager extends EventDispatcher
	{
		/**
		 *  @private
		 *  The sole instance of this singleton class.
		 */
		private static var instance:LayoutManager;
		
		private var sissiManager:DisplayObject;
		public function LayoutManager()
		{
			super();
			sissiManager = SissiManager.sissiManager;
		}
		
		//--------------------------------------------------------------------------
		//
		//  invalidate
		//
		//--------------------------------------------------------------------------
		/**
		 * 在下一帧ui进行validateProperties()的显示对象
		 */		
		private var invalidatePropertiesQueue:PriorityQueue = new PriorityQueue();
		/**
		 * 是否在下一帧对invalidatePropertiesQueue队列里面的对象进行validateProperties()
		 */		
		private var invalidatePropertiesFlag:Boolean = false;
		public function invalidateProperties(ui:IUIComponent):void
		{
			if(!invalidatePropertiesFlag && sissiManager)
			{
				invalidatePropertiesFlag = true;
				
				if(!listenersAttached)
					attachListeners(sissiManager);
			}
			
			// trace("LayoutManager adding " + Object(obj) + " to invalidatePropertiesQueue");
			if(targetLevel <= ui.nestLevel)
				invalidateClientPropertiesFlag = true;
			
			invalidatePropertiesQueue.addObject(ui, ui.nestLevel);
			// trace("LayoutManager added " + Object(obj) + " to invalidatePropertiesQueue");
		}
		
		/**
		 * 在下一帧ui进行validateSize()的显示对象
		 */		
		private var invalidateSizeQueue:PriorityQueue = new PriorityQueue();
		/**
		 * 是否在下一帧对invalidateSizeQueue队列里面的对象进行validateSize()
		 */		
		private var invalidateSizeFlag:Boolean = false;
		public function invalidateSize(ui:IUIComponent):void
		{
			if(!invalidateSizeFlag && sissiManager)
			{
				invalidateSizeFlag = true;
				
				if(!listenersAttached)
				{
					attachListeners(sissiManager);
				}
			}
			
			// trace("LayoutManager adding " + Object(obj) + " to invalidateSizeQueue");
			if(targetLevel <= ui.nestLevel)
				invalidateClientSizeFlag = true;
			
			invalidateSizeQueue.addObject(ui, ui.nestLevel);
			// trace("LayoutManager added " + Object(obj) + " to invalidateSizeQueue");
		}
		
		/**
		 * 在下一帧ui进行validateDisplayList()的显示对象
		 */		
		private var invalidateDisplayListQueue:PriorityQueue = new PriorityQueue();
		/**
		 * 是否在下一帧对invalidateDisplayListQueue队列里面的对象进行validateDisplayList()
		 */		
		private var invalidateDisplayListFlag:Boolean = false;
		public function invalidateDisplayList(ui:IUIComponent):void
		{
			if(!invalidateDisplayListFlag && sissiManager)
			{
				invalidateDisplayListFlag = true;
				
				if(!listenersAttached)
				{
					attachListeners(sissiManager);
				}
			}
			// trace("LayoutManager adding " + Object(obj) + " to invalidateDisplayListQueue");
			invalidateDisplayListQueue.addObject(ui, ui.nestLevel);
			// trace("LayoutManager added " + Object(obj) + " to invalidateDisplayListQueue");
		}
		
		//--------------------------------------------------------------------------
		//
		//  ENTER_FRAME RENDER
		//
		//--------------------------------------------------------------------------
		/**
		 * 是否已经实施了在下一帧执行layout
		 */
		private var listenersAttached:Boolean = false;
		public function attachListeners(sissiManager:DisplayObject):void
		{
			sissiManager.addEventListener(Event.ENTER_FRAME, doPhasedInstantiationCallback);
			if(sissiManager && sissiManager.stage)
			{
				sissiManager.addEventListener(Event.RENDER, doPhasedInstantiationCallback);
				if(sissiManager.stage)
					sissiManager.stage.invalidate();
			}
		
			listenersAttached = true;
		}
		
		/**
		 * 条件允许的话，执行layout
		 * @param event
		 */		
		private function doPhasedInstantiationCallback(event:Event):void
		{
			// if our background processing is suspended, then we shouldn't do any 
			// validation
			if(SissiManager.sissi_internal::callLaterSuspendCount > 0)
				return;
			
			sissiManager.removeEventListener(Event.ENTER_FRAME, doPhasedInstantiationCallback);
			sissiManager.removeEventListener(Event.RENDER, doPhasedInstantiationCallback);		
			
			doPhasedInstantiation();
		}
		
		//--------------------------------------------------------------------------
		//
		//  doPhasedInstantiation
		//
		//--------------------------------------------------------------------------
		/**
		 * 对象在validate后的时候updateCompletePendingFlag设置为true，并且存入该队列，到最后将对象的updateCompletePendingFlag设置为flase
		 */
		private var updateCompleteQueue:PriorityQueue = new PriorityQueue();
		/**
		 *  @private
		 */
		private function doPhasedInstantiation():void
		{
			// do one pass of all three phases.
			if(invalidatePropertiesFlag)
				validateProperties();
			
			if(invalidateSizeFlag)
				validateSize();
			
			if(invalidateDisplayListFlag)
				validateDisplayList();
			
			// trace("invalidatePropertiesFlag " + invalidatePropertiesFlag);
			// trace("invalidateSizeFlag " + invalidateSizeFlag);
			// trace("invalidateDisplayListFlag " + invalidateDisplayListFlag);
			
			if (invalidatePropertiesFlag ||
				invalidateSizeFlag ||
				invalidateDisplayListFlag)
			{
				attachListeners(sissiManager);
			}
			else
			{
				listenersAttached = false;
				
				var obj:IUIComponent = IUIComponent(updateCompleteQueue.removeLargest());
				while(obj)
				{
					if(!obj.initialized && obj.processedDescriptors)
						obj.initialized = true;
					obj.updateCompletePendingFlag = false;
					obj = IUIComponent(updateCompleteQueue.removeLargest());
				}
			}
		}
		
		/**
		 *  Validates all components whose properties have changed and have called
		 *  the <code>invalidateProperties()</code> method.  
		 *  It calls the <code>validateProperties()</code> method on those components
		 *  and will call <code>validateProperties()</code> on any other components that are 
		 *  invalidated while validating other components.
		 * 从父对象到子对象一层一层进行设置属性
		 * 设置属性可能改变大小，可能更改布局
		 */
		private function validateProperties():void
		{
//			 trace("--- LayoutManager: validateProperties --->smallestUI");
			
			// Keep traversing the invalidatePropertiesQueue until we've reached the end.
			// More elements may get added to the queue while we're in this loop, or a
			// a recursive call to this function may remove elements from the queue while
			// we're in this loop.
			var smallestUI:IUIComponent = IUIComponent(invalidatePropertiesQueue.removeSmallest());
			while(smallestUI)
			{
				//nestLevel == 0则表明不在舞台上
				if(smallestUI.nestLevel)
				{
//					trace(smallestUI, ", nestLevel:", smallestUI.nestLevel)
					smallestUI.validateProperties();
					if(!smallestUI.updateCompletePendingFlag)
					{
						updateCompleteQueue.addObject(smallestUI, smallestUI.nestLevel);
						smallestUI.updateCompletePendingFlag = true;
					}
				}
				// Once we start, don't stop.
				smallestUI = IUIComponent(invalidatePropertiesQueue.removeSmallest());
			}
			
			if(invalidatePropertiesQueue.isEmpty())
			{
				// trace("Properties Queue is empty");
				invalidatePropertiesFlag = false;
			}
			// trace("<--- LayoutManager: validateProperties ---");
		}
		
		/**
		 * 从子对象到父对象一层一层进行设置大小
		 * 更改大小，不一定更改排版布局
		 */		
		private function validateSize():void
		{
//			 trace("--- LayoutManager: validateSize --->largestUI");
			var largestUI:IUIComponent = IUIComponent(invalidateSizeQueue.removeLargest());
			while(largestUI)
			{
				// trace("LayoutManager calling validateSize() on " + Object(obj));
				//nestLevel == 0则表明不在舞台上
				if(largestUI.nestLevel)
				{
//					trace(largestUI, ", nestLevel:", largestUI.nestLevel)
					largestUI.validateSize();
					if(!largestUI.updateCompletePendingFlag)
					{
						updateCompleteQueue.addObject(largestUI, largestUI.nestLevel);
						largestUI.updateCompletePendingFlag = true;
					}
				}
				largestUI = IUIComponent(invalidateSizeQueue.removeLargest());
			}
			
			if(invalidateSizeQueue.isEmpty())
			{
				// trace("Measurement Queue is empty");
				invalidateSizeFlag = false;
			}
			// trace("<--- LayoutManager: validateSize ---");
		}
		
		/**
		 * 从父对象到子对象一层一层进行设置大小
		 * 更改排版布局
		 */		
		private function validateDisplayList():void
		{
//			 trace("--- LayoutManager: validateDisplayList --->smallestUI");        
			var smallestUI:IUIComponent = IUIComponent(invalidateDisplayListQueue.removeSmallest());
			while(smallestUI)
			{
				// trace("LayoutManager calling validateDisplayList on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);
				//nestLevel == 0则表明不在舞台上
//				trace(smallestUI, ", nestLevel:", smallestUI.nestLevel)
				if(smallestUI.nestLevel)
				{
					smallestUI.validateDisplayList();
					if(!smallestUI.updateCompletePendingFlag)
					{
						updateCompleteQueue.addObject(smallestUI, smallestUI.nestLevel);
						smallestUI.updateCompletePendingFlag = true;
					}
				}
				smallestUI = IUIComponent(invalidateDisplayListQueue.removeSmallest());
			}
			
			if(invalidateDisplayListQueue.isEmpty())
			{
				// trace("Layout Queue is empty");
				invalidateDisplayListFlag = false;
			}
			// trace("<--- LayoutManager: validateDisplayList ---");
		}
		
		//--------------------------------------------------------------------------
		//
		//  validateClient
		//
		//--------------------------------------------------------------------------
		/**
		 *  当使用validateClient的时候，用于判断某些处理
		 */
		private var targetLevel:int = int.MAX_VALUE;
		/**
		 * 当使用validateClient的时候用
		 */		
		private var invalidateClientPropertiesFlag:Boolean = false;
		/**
		 * 当使用validateClient的时候用
		 */		
		private var invalidateClientSizeFlag:Boolean = false;
		/**
		 * 正常情况下，它其实只是直接执行了validateProperties(), validateSize(), validateDisplayList()
		 * 当validateAll(targetUI)的时候，若有代码otherUI.invalidateProperties() otherUI.invalidateSize()
		 * 这时候就要检测targetUI otherUI的nestLevel关系
		 * 若otherUI.nestLevel>=targetUI.nestLevel
		 * 首先完成targetUI.validateProperties(), validateSize(), validateDisplayList()
		 * 然后根据target.nestLevel一层层对otherUI.validateProperties(), validateSize(), validateDisplayList()
		 * @param target
		 */		
		public function validateNow(targetUI:IUIComponent):void
		{
			var ui:IUIComponent;
			var i:int = 0;
			var done:Boolean = false;
			var oldTargetLevel:int = targetLevel;
			
			// the theory here is that most things that get validated are deep in the tree
			// and so there won't be nested calls to validateClient.  However if there is,
			// we don't want to have a more sophisticated scheme of keeping track
			// of dirty flags at each level that is being validated, but we definitely
			// do not want to keep scanning the queues unless we're pretty sure that
			// something might be dirty so we just say that if something got dirty
			// during this call at a deeper nesting than the first call to validateClient
			// then we'll scan the queues.  So we only change targetLevel if we're the
			// outer call to validateClient and only that call restores it.
			if(targetLevel == int.MAX_VALUE)
				targetLevel = targetUI.nestLevel;
			
			// trace("--- LayoutManager: validateClient ---> target = " + target);
			while(!done)
			{
				// assume we won't find anything
				done = true;
				
				// Keep traversing the invalidatePropertiesQueue until we've reached the end.
				// More elements may get added to the queue while we're in this loop, or a
				// a recursive call to this function may remove elements from the queue while
				// we're in this loop.
				ui = IUIComponent(invalidatePropertiesQueue.removeSmallestChild(targetUI));
				while(ui)
				{
					// trace("LayoutManager calling validateProperties() on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);
					//nestLevel == 0则表明不在舞台上
					if(ui.nestLevel)
					{
						ui.validateProperties();
						if(!ui.updateCompletePendingFlag)
						{
							updateCompleteQueue.addObject(ui, ui.nestLevel);
							ui.updateCompletePendingFlag = true;
						}
					}
					// Once we start, don't stop.
					ui = IUIComponent(invalidatePropertiesQueue.removeSmallestChild(targetUI));
				}
				if(invalidatePropertiesQueue.isEmpty())
				{
					// trace("Properties Queue is empty");
					
					invalidatePropertiesFlag = false;
					invalidateClientPropertiesFlag = false;
				}
				
				// trace("--- LayoutManager: validateSize --->");
				ui = IUIComponent(invalidateSizeQueue.removeLargestChild(targetUI));
				while(ui)
				{
					// trace("LayoutManager calling validateSize() on " + Object(obj));
					
					if(ui.nestLevel)
					{
						ui.validateSize();
						if(!ui.updateCompletePendingFlag)
						{
							updateCompleteQueue.addObject(ui, ui.nestLevel);
							ui.updateCompletePendingFlag = true;
						}
					}
					
					// trace("LayoutManager validateSize: " + Object(obj) + " " + IFlexDisplayObject(obj).measuredWidth + " " + IFlexDisplayObject(obj).measuredHeight);
					
					if(invalidateClientPropertiesFlag)
					{
						// did any properties get invalidated while validating size?
						ui = IUIComponent(invalidatePropertiesQueue.removeSmallestChild(targetUI));
						if(ui)
						{
							// re-queue it. we'll pull it at the beginning of the loop
							invalidatePropertiesQueue.addObject(ui, ui.nestLevel);
							done = false;
							break;
						}
					}
					
					ui = IUIComponent(invalidateSizeQueue.removeLargestChild(targetUI));
				}
				
				if(invalidateSizeQueue.isEmpty())
				{
					// trace("Measurement Queue is empty");
					
					invalidateSizeFlag = false;
					invalidateClientSizeFlag = false;
				}
				
//				if(!skipDisplayList)
//				{
				// trace("--- LayoutManager: validateDisplayList --->");
				
				ui = IUIComponent(invalidateDisplayListQueue.removeSmallestChild(targetUI));
				while(ui)
				{
					// trace("LayoutManager calling validateDisplayList on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);
					
					if(ui.nestLevel)
					{
						ui.validateDisplayList();
						if(!ui.updateCompletePendingFlag)
						{
							updateCompleteQueue.addObject(ui, ui.nestLevel);
							ui.updateCompletePendingFlag = true;
						}
					}
					// trace("LayoutManager return from validateDisplayList on " + Object(obj) + " " + DisplayObject(obj).width + " " + DisplayObject(obj).height);
					
					if(invalidateClientPropertiesFlag)
					{
						// did any properties get invalidated while validating size?
						ui = IUIComponent(invalidatePropertiesQueue.removeSmallestChild(targetUI));
						if(ui)
						{
							// re-queue it. we'll pull it at the beginning of the loop
							invalidatePropertiesQueue.addObject(ui, ui.nestLevel);
							done = false;
							break;
						}
					}
					
					if(invalidateClientSizeFlag)
					{
						ui = IUIComponent(invalidateSizeQueue.removeLargestChild(targetUI));
						if(ui)
						{
							// re-queue it. we'll pull it at the beginning of the loop
							invalidateSizeQueue.addObject(ui, ui.nestLevel);
							done = false;
							break;
						}
					}
					
					// Once we start, don't stop.
					ui = IUIComponent(invalidateDisplayListQueue.removeSmallestChild(targetUI));
				}
				
				
				if(invalidateDisplayListQueue.isEmpty())
				{
					// trace("Layout Queue is empty");
					
					invalidateDisplayListFlag = false;
				}
			}
			
			if(oldTargetLevel == int.MAX_VALUE)
			{
				targetLevel = int.MAX_VALUE;
				ui = IUIComponent(updateCompleteQueue.removeLargestChild(targetUI));
				while(ui)
				{
					if(!ui.initialized)
						ui.initialized = true;
					ui.updateCompletePendingFlag = false;
					ui = IUIComponent(updateCompleteQueue.removeLargestChild(targetUI));
				}
			}
		}
	}
}