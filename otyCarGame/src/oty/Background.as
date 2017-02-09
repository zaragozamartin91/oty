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
		private static const UNIQUE_ID:Number = Math.random();
		
		private static var $instance;
		
		private var _bg:Image;
		private var _rect:Rectangle;
		
		public static function buildNew(widthPx:Number, heightPx:Number):Background
		{
			$instance = new Background(UNIQUE_ID, widthPx, heightPx);
			return $instance;
		}
		
		public static function getInstance():Background
		{
			if ($instance)
			{
				return $instance;
			}
			else
			{
				throw new Error("Instancia no construida aun! usar buildNew");
			}
		}
		
		public function Background(uniqueId:Number, widthPx:Number, heightPx:Number)
		{
			if (UNIQUE_ID == uniqueId)
			{
				super();
				
				_rect = new Rectangle();
				
				_bg = new Image(TextureRepository.getInstance().backgroundTexture);
				_bg.height = heightPx;
				_bg.width = widthPx;
				_bg.tileGrid = _rect;
				
				addChild(_bg);
			}
			else
			{
				throw new Error("Clase singleton, usar getInstance");
			}
		
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