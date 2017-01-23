package oty
{
	import starling.textures.Texture;
	
	public class TextureRepository
	{
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
		
		private static var _instance:TextureRepository;
		private var _moveButtonTexture:Texture;
		
		public function get moveButtonTexture():Texture  { return _moveButtonTexture; }
		private var _wheelTexture:Texture;
		
		public function get wheelTexture():Texture  { return _wheelTexture; }
		private var _carTexture:Texture;
		
		public function get carTexture():Texture  { return _carTexture; }
		private var _otyLogoTexture:Texture;
		
		public function get otyLogoTexture():Texture  { return _otyLogoTexture; }
		private var _woodTexture:Texture;
		
		public function get woodTexture():Texture  { return _woodTexture; }
		private static var _allowInstantiation:Boolean;
		
		public static function getInstance():TextureRepository
		{
			if (!_instance)
			{
				_allowInstantiation = true;
				_instance = new TextureRepository();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function TextureRepository():void
		{
			if (_allowInstantiation)
			{
				_moveButtonTexture = Texture.fromEmbeddedAsset(ForwardButtonBmp);
				_wheelTexture = Texture.fromEmbeddedAsset(WheelBmp);
				_carTexture = Texture.fromEmbeddedAsset(CarBmp);
				_otyLogoTexture = Texture.fromEmbeddedAsset(OtyBmp);
				_woodTexture = Texture.fromEmbeddedAsset(WoodBmp);
			}
			else
			{
				throw new Error("CLASE SINGLETON! USAR getInstance!.");
			}
		}
	}
}