package oty
{
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * Fondo desplazable.
	 * @author martin
	 */
	public class Background extends Sprite
	{
		private static const UNIQUE_ID:Number = Math.random();
		
		private static var $instance:Background;
		
		private var _bg:Image;
		private var _rect:Rectangle;
		private var _upperBoundYPx:Number;
		private var _lowerBoundYPx:Number;
		
		public static function buildNew(widthPx:Number, heightPx:Number, upperBoundYPx:Number=100, lowerBoundYPx:Number=250):Background
		{
			$instance = new Background(UNIQUE_ID, widthPx, heightPx);
			$instance._upperBoundYPx = upperBoundYPx;
			$instance._lowerBoundYPx = lowerBoundYPx;
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
		
		/**
		 * Actualiza el desplazamiento del fondo a partir de una distancia medida en pixeles.
		 * @param	distXPx Distancia horizontal.
		 * @param	distYPx Distancia vertical.
		 * @param 	xfactor Factor divisor de ditancia horizontal.
		 * @param	yfactor Factor divisor de distancia vertical.
		 */
		public function updateFromDist(distXPx:Number, distYPx:Number, xfactor:Number = 1, yfactor:Number = 1):void
		{
			_rect.x -= distXPx / xfactor;
			
			if (_rect.y < -_lowerBoundYPx)
			{
				_rect.y = -_lowerBoundYPx;
			}
			else if (_rect.y > _upperBoundYPx)
			{
				_rect.y = _upperBoundYPx;
			}
			else
			{
				_rect.y -= distYPx / yfactor;
			}
			
			_bg.tileGrid = _rect;
			trace("_rect.y:" + _rect.y);
		}
	}

}