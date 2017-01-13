package
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.Color;
	import starling.text.TextField;
	import starling.utils.Align;
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Game extends Sprite
	{
		private var fs:FileStream;
		
		public function Game()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		private function init():void
		{
			fs = new FileStream();
			fs.open(new File(getPath("logs", "todayLogs.txt")), FileMode.WRITE);
			fs.writeUTFBytes("added to stage\n");
			
			var quad:Quad = new Quad(200, 200, Color.RED);
			quad.x = 100;
			quad.y = 50;
			addChild(quad);
			
			var textField:TextField = new TextField(100, 20, "text");
			textField.format.setTo("Arial", 12, Color.RED);
			textField.format.horizontalAlign = Align.RIGHT;
			textField.border = true;
			addChild(textField);
			textField.text = "hola";
			
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		private function getPath(folderName:String, fileName:String):String
		{
			return File.applicationDirectory.resolvePath(folderName).resolvePath(fileName).nativePath;
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				fs.writeUTFBytes("LEFT\n");
				break;
			case 39: 
				fs.writeUTFBytes("RIGHT\n");
				break;
			}
		}
		
		private function keyReleased(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				fs.writeUTFBytes("LEFT\n");
				break;
			case 39: 
				fs.writeUTFBytes("RIGHT\n");
				break;
			}
		}
	}
}
