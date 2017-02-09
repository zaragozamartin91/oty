package oty
{
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author martin
	 */
	public class Background extends Sprite
	{
		private var bg:Image;
		private var rect:Rectangle;
		
		public function Background(widthPx:Number, heightPx:Number)
		{
			super();
			
			rect = new Rectangle();
			
			bg = new Image(TextureRepository.getInstance().backgroundTexture);
			//bg.alignPivot();
			//bg.x = widthPx / 2;
			//bg.y = heightPx / 2 ;
			bg.height = heightPx;
			bg.width = widthPx;
			bg.tileGrid = rect;
			
			addChild(bg);
		}
		
		public function update(_dt:Number, speedXPx:Number, speedYPx:Number):void
		{
			rect.x -= _dt * speedXPx;
			rect.y -= rect.y < -250 ? 0 : _dt * speedYPx / 2;
			trace("rect.y:" + rect.y);
			bg.tileGrid = rect;
		}
	}

}