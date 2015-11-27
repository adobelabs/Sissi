package sissi.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class HitTestUtil
	{
		public static function hitTestPoint(displayTarget:DisplayObject, globalPt:Point):Boolean
		{
			//If we’re already dealing with a BitmapData object then we just use the hitTest method of that BitmapData.
			if(displayTarget is Bitmap)
			{
				return (displayTarget as BitmapData).hitTest(new Point(0,0), 0, displayTarget.globalToLocal(globalPt));
			}
			else
			{
				/* 
				* First we check if the hitTestPoint method returns false. If it does, that
				* means that we definitely do not have a hit, so we return false. But if this
				* returns true, we still don’t know 100% that we have a hit because it might
				* be a transparent part of the image.
				*/
				if(!displayTarget.hitTestPoint(globalPt.x, globalPt.y, true))
				{
					return false;
				}
				else {
					/* 
					* So now we make a new BitmapData object and draw the pixels of our object
					* in there. Then we use the hitTest method of that BitmapData object to
					* really find out of we have a hit or not.
					* 1 pixel
					*/
					var bmapData:BitmapData = new BitmapData(1, 1, true, 0x00000000);
					var m:Matrix = new Matrix();
					var localPt:Point = displayTarget.globalToLocal(globalPt);
					m.tx = -localPt.x;
					m.ty = -localPt.y;
					bmapData.draw(displayTarget, m);
					var returnVal:Boolean = bmapData.hitTest(new Point(0,0), 128, new Point(0, 0));
					bmapData.dispose();
					return returnVal;
				}
			}
		}
	}
}