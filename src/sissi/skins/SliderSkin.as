package sissi.skins
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sissi.components.Slider;
	import sissi.core.sissi_internal;
	import sissi.layouts.LayoutDirection;
	import sissi.managers.BMDCacheManager;
	import sissi.skin.SkinHSliderTrackScale;
	import sissi.skin.SkinSliderThumbDownBMD;
	import sissi.skin.SkinSliderThumbOverBMD;
	import sissi.skin.SkinSliderThumbUpBMD;
	import sissi.skin.SkinVSliderTrackScale;
	import sissi.skins.supportClasses.ISliderSkin;
	
	public class SliderSkin extends EventDispatcher implements ISliderSkin
	{
		public function SliderSkin(target:Slider)
		{
			_hostComponent = target;
		}
		
		/**
		 * InterAction交互的对象为Button。
		 */		
		private var _hostComponent:Slider;
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
		
		
		
		/**
		 * 方形
		 */	
		public static const SKIN_THUMB_STYLE_RECT:String = "skinThumbShapeRect";
		/**
		 * 圆形
		 */	
		public static const SKIN_THUMB_STYLE_ROUND:String = "skinThumbShapeRound";
		private var _thumbShape:String = SKIN_THUMB_STYLE_ROUND;
		/**
		 * 默认为SKIN_THUMB_SHAPE_RECT，方形
		 * 可选择的还有SKIN_THUMB_SHAPE_ROUND，圆形
		 * @return 
		 */		
		public function get thumbStyle():String
		{
			return _thumbShape;
		}
		public function set thumbStyle(value:String):void
		{
			_thumbShape = value;
		}
		
		public static const SKIN_TRACK:String = "skinTrack";
		public static const SKIN_THUMB_UP:String = "skinThumbUp";
		public static const SKIN_THUMB_OVER:String = "skinThumbOver";
		public static const SKIN_THUMB_DOWN:String = "skinThumbDown";
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
		
		
		private var oldUnscaledWidth:Number;
		private var oldUnscaledHeight:Number;
		/**
		 * 不需要每次都进来
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */		
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(oldUnscaledWidth == unscaledWidth && oldUnscaledHeight == unscaledHeight)
				return;
			oldUnscaledWidth = unscaledWidth;
			oldUnscaledHeight = unscaledHeight;
			
			var skinTrack:DisplayObject = skins[SKIN_TRACK];
			if(skinTrack)
			{
				if(_hostComponent.direction == LayoutDirection.HORIZONTAL)
				{
					skinTrack.width = unscaledWidth;
					skinTrack.y = (unscaledHeight - skinTrack.height)>>1;
				}
				else if(_hostComponent.direction == LayoutDirection.VERTICAL)
				{
					skinTrack.height = unscaledHeight;
					skinTrack.x = (unscaledWidth - skinTrack.width)>>1;
				}
			}
		}
		
		protected var skins:Dictionary;
		protected function attachSkin():void
		{
			if(!skins)
				skins = new Dictionary();
			
			if(!_trackSkin)
			{
				if(_hostComponent.direction == LayoutDirection.HORIZONTAL)
				{
					_trackSkin = new SkinHSliderTrackScale();
				}
				else if(_hostComponent.direction == LayoutDirection.VERTICAL)
				{
					_trackSkin = new SkinVSliderTrackScale();
				}
			}
			if(!_thumbUpSkin)
			{
				//默认提供皮肤为圆形
				_thumbUpSkin = new Bitmap(BMDCacheManager.getBMD(SkinSliderThumbUpBMD));
				_thumbShape = SKIN_THUMB_STYLE_ROUND;
			}
			
			if(!_thumbOverSkin)
				_thumbOverSkin = new Bitmap(BMDCacheManager.getBMD(SkinSliderThumbOverBMD));
			
			if(!_thumbDownSkin)
				_thumbDownSkin = new Bitmap(BMDCacheManager.getBMD(SkinSliderThumbDownBMD));
			
			partAdded(SKIN_TRACK, _trackSkin);
			
			partAdded(SKIN_THUMB_UP, _thumbUpSkin);
			partAdded(SKIN_THUMB_OVER, _thumbOverSkin);
			partAdded(SKIN_THUMB_DOWN, _thumbDownSkin);
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
			
			detachSkin();
			
			_hostComponent = null;
		}
	}
}