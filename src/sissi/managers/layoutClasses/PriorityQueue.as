package sissi.managers.layoutClasses
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import sissi.core.IUIComponent;
	
	/**
	 *  @private
	 *  The PriorityQueue class provides a general purpose priority queue.
	 *  It is used internally by the LayoutManager.
	 */
	public class PriorityQueue
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function PriorityQueue()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var priorityBins:Array = [];
		
		/**
		 *  @private
		 *  The smallest occupied index in arrayOfDictionaries.
		 */
		private var minPriority:int = 0;
		
		/**
		 *  @private
		 *  The largest occupied index in arrayOfDictionaries.
		 */
		private var maxPriority:int = -1;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		public function addObject(obj:IUIComponent, priority:int):void
		{       
			//首先更新现有的最大和最小的值
			if(maxPriority < minPriority)
			{
				minPriority = maxPriority = priority;
			}
			else
			{
				if(priority < minPriority)
					minPriority = priority;
				if(priority > maxPriority)
					maxPriority = priority;
			}
			
			//根据nestLevel生成相应的PriorityBin
			//也就是相同的nestLevel是存放在一起的
			//然后在PriorityBin存放ui
			var bin:PriorityBin = priorityBins[priority];
			
			if(!bin)
			{
				// If no hash exists for the specified priority, create one.
				bin = new PriorityBin();
				priorityBins[priority] = bin;
				bin.items[obj] = true;
				bin.length++;
			}
			else
			{
				// If we don't already hold the obj in the specified hash, add it
				// and update our item count.
				if(bin.items[obj] == null)
				{ 
					bin.items[obj] = true;
					bin.length++;
				}
			}
			
		}
		
		/**
		 *  @private
		 */
		public function removeLargest():IUIComponent
		{
			var obj:IUIComponent = null;
			
			if(minPriority <= maxPriority)
			{
				var bin:PriorityBin = priorityBins[maxPriority];
				while(!bin || bin.length == 0)
				{
					maxPriority--;
					if(maxPriority < minPriority)
						return null;
					bin = priorityBins[maxPriority];
				}
				
				// Remove the item with largest priority from our priority queue.
				// Must use a for loop here since we're removing a specific item
				// from a 'Dictionary'(no means of directly indexing).
				for(var key:Object in bin.items)
				{
					//一个个移除所以用break;因为dic，所以用for in
					obj = IUIComponent(key);
					removeChild(IUIComponent(key), maxPriority);
					break;
				}
				
				// Update maxPriority if applicable.
				while(!bin || bin.length == 0)
				{
					maxPriority--;
					if(maxPriority < minPriority)
						break;
					bin = priorityBins[maxPriority];
				}
				
			}
			
			return obj;
		}
		
		/**
		 * 返回比传进来的client更大nestLevel的显示对象
		 */
		public function removeLargestChild(client:IUIComponent):IUIComponent
		{
			var max:int = maxPriority;
			var min:int = client.nestLevel;
			
			while(min <= max)
			{
				var bin:PriorityBin = priorityBins[max];
				if(bin && bin.length > 0)
				{
					if(max == client.nestLevel)
					{
						// If the current level we're searching matches that of our
						// client, no need to search the entire list, just check to see
						// if the client exists in the queue(it would be the only item
						// at that nestLevel).
						if(bin.items[client])
						{
							removeChild(IUIComponent(client), max);
							return client;
						}
					}
					else
					{
						for(var key:Object in bin.items)
						{
							if((key is DisplayObject) && contains(DisplayObject(client), DisplayObject(key)))
							{
								removeChild(IUIComponent(key), max);
								return IUIComponent(key);
							}
						}
					}
					
					max--;
				}
				else
				{
					if(max == maxPriority)
						maxPriority--;
					max--;
					if(max < min)
						break;
				}           
			}
			
			return null;
		}
		
		/**
		 *  @private
		 */
		public function removeSmallest():Object
		{
			var obj:Object = null;
			
			if(minPriority <= maxPriority)
			{
				var bin:PriorityBin = priorityBins[minPriority];
				while(!bin || bin.length == 0)
				{
					minPriority++;
					if(minPriority > maxPriority)
						return null;
					bin = priorityBins[minPriority];
				}           
				
				// Remove the item with smallest priority from our priority queue.
				// Must use a for loop here since we're removing a specific item
				// from a 'Dictionary'(no means of directly indexing).
				for(var key:Object in bin.items)
				{
					obj = key;
					removeChild(IUIComponent(key), minPriority);
					break;
				}
				
				// Update minPriority if applicable.
				while(!bin || bin.length == 0)
				{
					minPriority++;
					if(minPriority > maxPriority)
						break;
					bin = priorityBins[minPriority];
				}           
			}
			
			return obj;
		}
		
		/**
		 *  @private
		 */
		public function removeSmallestChild(client:IUIComponent):Object
		{
			var min:int = client.nestLevel;
			
			while(min <= maxPriority)
			{
				var bin:PriorityBin = priorityBins[min];
				if(bin && bin.length > 0)
				{   
					if(min == client.nestLevel)
					{
						// If the current level we're searching matches that of our
						// client, no need to search the entire list, just check to see
						// if the client exists in the queue(it would be the only item
						// at that nestLevel).
						if(bin.items[client])
						{
							removeChild(IUIComponent(client), min);
							return client;
						}
					}
					else
					{
						for(var key:Object in bin.items)
						{
							if((key is DisplayObject) && contains(DisplayObject(client), DisplayObject(key)))
							{
								removeChild(IUIComponent(key), min);
								return key;
							}
						}
					}
					
					min++;
				}
				else
				{
					if(min == minPriority)
						minPriority++;
					min++;
					if(min > maxPriority)
						break;
				}           
			}
			
			return null;
		}
		
		/**
		 *  @private
		 */
		private function removeChild(client:IUIComponent, level:int=-1):Object
		{
			var priority:int =(level >= 0) ? level : client.nestLevel;
			var bin:PriorityBin = priorityBins[priority];
			if(bin && bin.items[client] != null)
			{
				delete bin.items[client];
				bin.length--;
				return client;
			}
			return null;
		}
		
		/**
		 *  @private
		 */
		private function removeAll():void
		{
			priorityBins.length = 0;
			minPriority = 0;
			maxPriority = -1;
		}
		
		/**
		 *  @private
		 */
		public function isEmpty():Boolean
		{
			return minPriority > maxPriority;
		}
		
		/**
		 *  @private
		 */
		private function contains(parent:DisplayObject, child:DisplayObject):Boolean
		{
			if(parent is DisplayObjectContainer)
			{
				return DisplayObjectContainer(parent).contains(child);
			}
			return parent == child;
		}
		
	}
	
}

import flash.utils.Dictionary;

/**
 *  Represents one priority bucket of entries.
 *  @private
 */
class PriorityBin 
{
	public var length:int;
	public var items:Dictionary = new Dictionary();
	
}
