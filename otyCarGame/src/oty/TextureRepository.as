package oty
{
	import starling.textures.Texture;
	
	/**
	 * Repositorio de texturas.
	 * @author martin
	 */
	public class TextureRepository
	{
		private static const UNIQUE_ID:Number = Math.random();
		
		[Embed(source = "img/forward-button.png")]
		public static const ForwardButtonBmp:Class;
		[Embed(source = "img/wheel.png")]
		public static const WheelBmp:Class;
		[Embed(source = "img/car.png")]
		public static const CarBmp:Class;
		[Embed(source = "img/oty.png")]
		public static const OtyBmp:Class;
		[Embed(source = "img/wood-texture.jpg")]
		public static const WoodBmp:Class;
		[Embed(source = "img/reset-button.png")]
		public static const ResetButtonBmp:Class;
		[Embed(source = "img/mario-background_2.gif")]
		public static const BackgroundBmp:Class;
		
		private static var $instance:TextureRepository;
		
		private var _moveButtonTexture:Texture;
		private var _wheelTexture:Texture;
		private var _carTexture:Texture;
		private var _otyLogoTexture:Texture;
		private var _woodTexture:Texture;
		private var _resetButtonTexture:Texture;
		private var _backgroundTexture:Texture;
		
		public function get woodTexture():Texture  { return _woodTexture; }
		
		public function get otyLogoTexture():Texture  { return _otyLogoTexture; }
		
		public function get carTexture():Texture  { return _carTexture; }
		
		public function get wheelTexture():Texture  { return _wheelTexture; }
		
		public function get moveButtonTexture():Texture  { return _moveButtonTexture; }
		
		public function get resetButtonTexture():Texture  { return _resetButtonTexture; }
		
		public function get backgroundTexture():Texture  { return _backgroundTexture; }
		
		public static function getInstance():TextureRepository
		{
			$instance = $instance ? $instance : new TextureRepository(UNIQUE_ID);
			return $instance;
		}
		
		public function TextureRepository(uniqueId:Number):void
		{
			if (UNIQUE_ID == uniqueId)
			{
				_moveButtonTexture = Texture.fromEmbeddedAsset(ForwardButtonBmp);
				_wheelTexture = Texture.fromEmbeddedAsset(WheelBmp);
				_carTexture = Texture.fromEmbeddedAsset(CarBmp);
				_otyLogoTexture = Texture.fromEmbeddedAsset(OtyBmp);
				_woodTexture = Texture.fromEmbeddedAsset(WoodBmp);
				_resetButtonTexture = Texture.fromEmbeddedAsset(ResetButtonBmp);
				_backgroundTexture = Texture.fromEmbeddedAsset(BackgroundBmp);
				
			}
			else
			{
				throw new Error("CLASE SINGLETON! USAR getInstance!.");
			}
		}
	}
}