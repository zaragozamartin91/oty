package
{
	import flash.display.Bitmap;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.text.TextField;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author martin
	 */
	public class MessageBox extends DisplayObjectContainer
	{
		[Embed(source = "chessboard.png")]
		private static const BackgroundBmp:Class;
		
		[Embed(source = "button.png")]
		private static const ButtonBmp:Class;
		
		private var _background:Image;
		private var _textField:TextField;
		private var _yesButton:Button;
		private var _noButton:Button;
		
		public function MessageBox(text:String)
		{
			var bitmap:Bitmap = new BackgroundBmp(); 
			var bgTexture:Texture = Texture.fromBitmap(bitmap); 
			var buttonTexture:Texture = Texture.fromEmbeddedAsset(ButtonBmp);
			
			_background = new Image(bgTexture);
			_background.width = 200;
			_background.height = 200;
			_textField = new TextField(100, 200, text);
			_yesButton = new Button(buttonTexture, "yes");
			_yesButton.width = 50;
			_yesButton.height = 50;
			_noButton = new Button(buttonTexture, "no");
			_noButton.width = 50;
			_noButton.height = 50;
			
			_yesButton.x = 10;
			_yesButton.y = 150;
			_noButton.x = 60;
			_noButton.y = 150;
			
			addChild(_background);
			addChild(_textField);
			addChild(_yesButton);
			addChild(_noButton);
			
			_yesButton.addEventListener(Event.TRIGGERED, cleanUp);
			_noButton.addEventListener(Event.TRIGGERED, function():void {
				_textField.text = "sure you dont??";
			});
		}
		
		private function cleanUp():void
		{
			//When you don’t want an object to be displayed any longer, you simply remove it from its parent
			removeFromParent();
			//When you dispose display objects, they will free up all the resources that they (or any of their children) have allocated. That’s important, because many Stage3D related data is not reachable by the garbage collector
			dispose();
		}
	
	}

}