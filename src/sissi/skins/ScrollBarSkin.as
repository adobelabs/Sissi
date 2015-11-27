package sissi.skins
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sissi.components.ScrollBar;
	import sissi.core.sissi_internal;
	import sissi.layouts.LayoutDirection;
	import sissi.managers.BMDCacheManager;
	import sissi.skin.SkinHScrollBarDownArrowDownBMD;
	import sissi.skin.SkinHScrollBarDownArrowOverBMD;
	import sissi.skin.SkinHScrollBarDownArrowUpBMD;
	import sissi.skin.SkinHScrollBarThumbDownScale;
	import sissi.skin.SkinHScrollBarThumbOverScale;
	import sissi.skin.SkinHScrollBarThumbUpScale;
	import sissi.skin.SkinHScrollBarTrackScale;
	import sissi.skin.SkinHScrollBarUpArrowDownBMD;
	import sissi.skin.SkinHScrollBarUpArrowOverBMD;
	import sissi.skin.SkinHScrollBarUpArrowUpBMD;
	import sissi.skin.SkinVScrollBarDownArrowOverBMD;
	import sissi.skin.SkinVScrollBarDownArrowUpBMD;
	import sissi.skin.SkinVScrollBarThumbOverScale;
	import sissi.skin.SkinVScrollBarThumbUpScale;
	import sissi.skin.SkinVScrollBarTrackScale;
	import sissi.skin.SkinVScrollBarUpArrowOverBMD;
	import sissi.skin.SkinVScrollBarUpArrowUpBMD;
	import sissi.skins.supportClasses.IScrollBarSkin;
	
	public class ScrollBarSkin extends EventDispatcher implements IScrollBarSkin
	{
		public function ScrollBarSkin(target:ScrollBar)
		{
			_hostComponent = target;
		}
		
		/**
		 * InterAction交互的对象为Button。
		 */		
		private var _hostComponent:ScrollBar;
		public function get hostComponent():DisplayObjectContainer
		{
			return _hostComponent;
		}
		
		private var _trackSkin:DisplayObject;
		public function get trackSkin():DisplayObject
		{
			return _trackSkin;
		}
		public function set trackSkin(value:DisplayObject):void
		{
			_trackSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _thumbUpSkin:DisplayObject;
		public function get thumbUpSkin():DisplayObject
		{
			return _thumbUpSkin;
		}
		public function set thumbUpSkin(value:DisplayObject):void
		{
			_thumbUpSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _thumbDownSkin:DisplayObject;
		public function get thumbDownSkin():DisplayObject
		{
			return _thumbDownSkin;
		}
		public function set thumbDownSkin(value:DisplayObject):void
		{
			_thumbDownSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _thumbOverSkin:DisplayObject;
		public function get thumbOverSkin():DisplayObject
		{
			return _thumbOverSkin;
		}
		public function set thumbOverSkin(value:DisplayObject):void
		{
			_thumbOverSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _upArrowUpSkin:DisplayObject;
		public function get upArrowUpSkin():DisplayObject
		{
			return _upArrowUpSkin;
		}
		public function set upArrowUpSkin(value:DisplayObject):void
		{
			_upArrowUpSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _upArrowDownSkin:DisplayObject;
		public function get upArrowDownSkin():DisplayObject
		{
			return _upArrowDownSkin;
		}
		public function set upArrowDownSkin(value:DisplayObject):void
		{
			_upArrowDownSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _upArrowOverSkin:DisplayObject;
		public function get upArrowOverSkin():DisplayObject
		{
			return _upArrowOverSkin;
		}
		public function set upArrowOverSkin(value:DisplayObject):void
		{
			_upArrowOverSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _downArrowUpSkin:DisplayObject;
		public function get downArrowUpSkin():DisplayObject
		{
			return _downArrowUpSkin;
		}
		public function set downArrowUpSkin(value:DisplayObject):void
		{
			_downArrowUpSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _downArrowDownSkin:DisplayObject;
		public function get downArrowDownSkin():DisplayObject
		{
			return _downArrowDownSkin;
		}
		public function set downArrowDownSkin(value:DisplayObject):void
		{
			_downArrowDownSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		private var _downArrowOverSkin:DisplayObject;
		public function get downArrowOverSkin():DisplayObject
		{
			return _downArrowOverSkin;
		}
		public function set downArrowOverSkin(value:DisplayObject):void
		{
			_downArrowOverSkin = value;
			skinChanged = true;
			
			_hostComponent.invalidateProperties();
			_hostComponent.invalidateSize();
			_hostComponent.invalidateDisplayList();
		}
		
		public static const SKIN_TRACK:String = "skinTrack";
		
		public static const SKIN_THUMB_UP:String = "skinThumbUp";
		public static const SKIN_THUMB_OVER:String = "skinThumbOver";
		public static const SKIN_THUMB_DOWN:String = "skinThumbDown";
		
		public static const SKIN_UP_ARROW_UP:String = "skinUpArrowUp";
		public static const SKIN_UP_ARROW_OVER:String = "skinUpArrowOver";
		public static const SKIN_UP_ARROW_DOWN:String = "skinUpArrowDown";
		
		public static const SKIN_DOWN_ARROW_UP:String = "skinDownArrowUp";
		public static const SKIN_DOWN_ARROW_OVER:String = "skinDownArrowOver";
		public static const SKIN_DOWN_ARROW_DOWN:String = "skinDownArrowDown";
		/**
		 * 验证是否更改现有的皮肤
		 */		
		protected var skinChanged:Boolean = true;
		public function validateSkinChange():void
		{
			if(skinChanged)
			{
				detachSkin();
				attachSkin();
				
				skinChanged = false;
			}
		}
		
		public function get measuredWidth():Number
		{
			return 0;
		}
		
		public function get measuredHeight():Number
		{
			return 0;
		}
		
		
//		private var oldUnscaledWidth:Number;
//		private var oldUnscaledHeight:Number;
		/**
		 * 不需要每次都进来
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */		
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
//			if(oldUnscaledWidth == unscaledWidth && oldUnscaledHeight == unscaledHeight)
//				return;
//			oldUnscaledWidth = unscaledWidth;
//			oldUnscaledHeight = unscaledHeight;
			if(!skins)
				return;
			
			var skinTrack:DisplayObject = skins[SKIN_TRACK];
			if(skinTrack)
			{
				if(_hostComponent.direction == LayoutDirection.HORIZONTAL)
				{
					skinTrack.width = unscaledWidth  - _hostComponent.sissi_internal::upArrow.width - _hostComponent.sissi_internal::downArrow.width;
					skinTrack.x = _hostComponent.sissi_internal::upArrow.width;
					skinTrack.y = (unscaledHeight - skinTrack.height)>>1;
				}
				else if(_hostComponent.direction == LayoutDirection.VERTICAL)
				{
					skinTrack.height = unscaledHeight -  _hostComponent.sissi_internal::upArrow.height - _hostComponent.sissi_internal::downArrow.height;
					skinTrack.y = _hostComponent.sissi_internal::upArrow.height;
					skinTrack.x = (unscaledWidth - skinTrack.width)>>1;
				}
			}
		}
		
		protected var skins:Dictionary;
		protected function attachSkin():void
		{
			if(!skins)
				skins = new Dictionary();
			
			if(_hostComponent.direction == LayoutDirection.HORIZONTAL)
			{
				if(!_trackSkin)
					_trackSkin = new SkinHScrollBarTrackScale();
				
				if(!_thumbUpSkin)
					_thumbUpSkin = new SkinHScrollBarThumbUpScale();
				if(!_thumbOverSkin)
					_thumbOverSkin = new SkinHScrollBarThumbOverScale();
				if(!_thumbDownSkin)
					_thumbDownSkin = new SkinHScrollBarThumbDownScale();
				
				if(!_upArrowUpSkin)
					_upArrowUpSkin = new Bitmap(BMDCacheManager.getBMD(SkinHScrollBarUpArrowUpBMD));
				if(!_upArrowOverSkin)
					_upArrowOverSkin = new Bitmap(BMDCacheManager.getBMD(SkinHScrollBarUpArrowOverBMD));
				if(!_upArrowDownSkin)
					_upArrowDownSkin = new Bitmap(BMDCacheManager.getBMD(SkinHScrollBarUpArrowDownBMD));
				
				if(!_downArrowUpSkin)
					_downArrowUpSkin = new Bitmap(BMDCacheManager.getBMD(SkinHScrollBarDownArrowUpBMD));
				if(!_downArrowOverSkin)
					_downArrowOverSkin = new Bitmap(BMDCacheManager.getBMD(SkinHScrollBarDownArrowOverBMD));
				if(!_downArrowDownSkin)
					_downArrowDownSkin = new Bitmap(BMDCacheManager.getBMD(SkinHScrollBarDownArrowDownBMD));
			}
			else if(_hostComponent.direction == LayoutDirection.VERTICAL)
			{
				if(!_trackSkin)
					_trackSkin = new SkinVScrollBarTrackScale();
				
				if(!_thumbUpSkin)
					_thumbUpSkin = new SkinVScrollBarThumbUpScale();
				if(!_thumbOverSkin)
					_thumbOverSkin = new SkinVScrollBarThumbOverScale();
				if(!_thumbDownSkin)
					_thumbDownSkin = new SkinVScrollBarThumbUpScale();
				
				if(!_upArrowUpSkin)
					_upArrowUpSkin = new Bitmap(BMDCacheManager.getBMD(SkinVScrollBarUpArrowUpBMD));
				if(!_upArrowOverSkin)
					_upArrowOverSkin = new Bitmap(BMDCacheManager.getBMD(SkinVScrollBarUpArrowOverBMD));
				if(!_upArrowDownSkin)
					_upArrowDownSkin = new Bitmap(BMDCacheManager.getBMD(SkinVScrollBarUpArrowUpBMD));
				
				if(!_downArrowUpSkin)
					_downArrowUpSkin = new Bitmap(BMDCacheManager.getBMD(SkinVScrollBarDownArrowUpBMD));
				if(!_downArrowOverSkin)
					_downArrowOverSkin = new Bitmap(BMDCacheManager.getBMD(SkinVScrollBarDownArrowOverBMD));
				if(!_downArrowDownSkin)
					_downArrowDownSkin = new Bitmap(BMDCacheManager.getBMD(SkinVScrollBarDownArrowUpBMD));
			}
			
			partAdded(SKIN_TRACK, _trackSkin);
			
			partAdded(SKIN_THUMB_UP, _thumbUpSkin);
			partAdded(SKIN_THUMB_OVER, _thumbOverSkin);
			partAdded(SKIN_THUMB_DOWN, _thumbDownSkin);
			
			partAdded(SKIN_UP_ARROW_UP, _upArrowUpSkin);
			partAdded(SKIN_UP_ARROW_OVER, _upArrowOverSkin);
			partAdded(SKIN_UP_ARROW_DOWN, _upArrowDownSkin);
			
			partAdded(SKIN_DOWN_ARROW_UP, _downArrowUpSkin);
			partAdded(SKIN_DOWN_ARROW_OVER, _downArrowOverSkin);
			partAdded(SKIN_DOWN_ARROW_DOWN, _downArrowDownSkin);
		}
		
		protected function detachSkin():void
		{
			if(!skins)
				return;
			for(var skinId:String in skins)
			{
				partRemoved(skinId, skins[skinId] as DisplayObject);
			}
			skins = null;
		}
		
		protected function partAdded(skinId:String, skinPart:DisplayObject):void
		{
			if(!skinPart)
				return;
			
			skins[skinId] = skinPart;
			switch(skinId)
			{
				case SKIN_TRACK:
				{
					_hostComponent.addChildAt(skinPart, 0);
					break;
				}
				case SKIN_THUMB_UP:
				{
					_hostComponent.sissi_internal::thumb.skin.upSkin = skinPart;
				}
				case SKIN_THUMB_OVER:
				{
					_hostComponent.sissi_internal::thumb.skin.overSkin = skinPart;
				}
				case SKIN_THUMB_DOWN:
				{
					_hostComponent.sissi_internal::thumb.skin.downSkin = skinPart;
				}
					
				case SKIN_UP_ARROW_UP:
				{
					_hostComponent.sissi_internal::upArrow.skin.upSkin = skinPart;
				}
				case SKIN_UP_ARROW_OVER:
				{
					_hostComponent.sissi_internal::upArrow.skin.overSkin = skinPart;
				}
				case SKIN_UP_ARROW_DOWN:
				{
					_hostComponent.sissi_internal::upArrow.skin.downSkin = skinPart;
				}
					
				case SKIN_DOWN_ARROW_UP:
				{
					_hostComponent.sissi_internal::downArrow.skin.upSkin = skinPart;
				}
				case SKIN_DOWN_ARROW_OVER:
				{
					_hostComponent.sissi_internal::downArrow.skin.overSkin = skinPart;
				}
				case SKIN_DOWN_ARROW_DOWN:
				{
					_hostComponent.sissi_internal::downArrow.skin.downSkin = skinPart;
				}
			}
		}
		
		protected function partRemoved(skinId:String, skinPart:DisplayObject):void
		{
			switch(skinId)
			{
				case SKIN_TRACK:
				{
					if(skinPart && _hostComponent.contains(skinPart))
						_hostComponent.removeChild(skinPart);
					break;
				}
				case SKIN_THUMB_UP:
				{
					_hostComponent.sissi_internal::thumb.skin.upSkin = null;
				}
				case SKIN_THUMB_OVER:
				{
					_hostComponent.sissi_internal::thumb.skin.overSkin = null;
				}
				case SKIN_THUMB_DOWN:
				{
					_hostComponent.sissi_internal::thumb.skin.downSkin = null;
				}
				case SKIN_UP_ARROW_UP:
				{
					_hostComponent.sissi_internal::upArrow.skin.upSkin = null;
				}
				case SKIN_UP_ARROW_OVER:
				{
					_hostComponent.sissi_internal::upArrow.skin.overSkin = null;
				}
				case SKIN_UP_ARROW_DOWN:
				{
					_hostComponent.sissi_internal::upArrow.skin.downSkin = null;
				}
				case SKIN_DOWN_ARROW_UP:
				{
					_hostComponent.sissi_internal::downArrow.skin.upSkin = null;
				}
				case SKIN_DOWN_ARROW_OVER:
				{
					_hostComponent.sissi_internal::downArrow.skin.overSkin = null;
				}
				case SKIN_DOWN_ARROW_DOWN:
				{
					_hostComponent.sissi_internal::downArrow.skin.downSkin = null;
				}
			}
			delete skins[skinId];
		}
		
		/**
		 * 垃圾回收，此类完全销毁。
		 */		
		public function dispose():void
		{
			_trackSkin = null;
			_thumbUpSkin = _thumbOverSkin = _thumbDownSkin = null;
			
			_upArrowUpSkin = _upArrowOverSkin = _upArrowDownSkin = null;
			_downArrowUpSkin = _downArrowOverSkin = _downArrowDownSkin = null;
			
			detachSkin();
			
			_hostComponent = null;
		}
	}
}