package oty
{
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * Fondo scroleable.
	 * @author martin
	 */
	public class Background extends Sprite
	{
		private var _bg:Image;
		private var _rect:Rectangle;
		
		public function Background(widthPx:Number, heightPx:Number)
		{
			super();
			
			_rect = new Rectangle();
			
			_bg = new Image(TextureRepository.getInstance().backgroundTexture);
			_bg.height = heightPx;
			_bg.width = widthPx;
			_bg.tileGrid = _rect;
			
			addChild(_bg);
		}
		
		public function updateFromVel(dt:Number, speedXPx:Number, speedYPx:Number):void
		{
			var distXPx:Number = dt * speedXPx;
			var distYPx:Number = dt * speedYPx / 2;
			updateFromDist(distXPx, distYPx);
		}
		
		public function updateFromDist(distXPx:Number, distYPx:Number):void
		{
			_rect.x -= distXPx;
			_rect.y -= _rect.y < -250 ? 0 : distYPx;
			_bg.tileGrid = _rect;
		}
	}

}