package
{
	import flash.geom.Point;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Color;
	import starling.events.Event;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Game extends Sprite
	{
		[Embed(source = "mushroom.png")]
		public static const Mushroom:Class;
		
		[Embed(source = "speech-bubble.png")]
		public static const SpeechBubble:Class;
		
		[Embed(source = "TextureAtlas.xml", mimeType = "application/octet-stream")]
		public static const AtlasXml:Class;
		
		[Embed(source = "penguflip-atlas.png")]
		public static const AtlasTexture:Class;
		
		public function Game()
		{
			trace("Game instance created");
		}
		
		public function start():void
		{
			trace("Game started!");
			// A Quad is a collection of at least two triangles spawning up a rectangle
			var quad:Quad = new Quad(10, 10, Color.RED);
			// se establecio que la ANCHURA DEL STAGE DE STARLING es 1024. Entonces el cuadrado se mostrara pegado a la esquina derecha sin importar la anchura del STARLING VIEWPORT
			quad.x = 1014;
			quad.y = 50;
			addChild(quad);
			
			var speechBubbleSprite:Sprite = new Sprite();
			//A texture is just the data that describes an image
			var speechBubbleTexture:Texture = Texture.fromEmbeddedAsset(SpeechBubble);
			//An Image is just a quad with a convenient constructor and a few additional methods
			var speechBubbleImage:Image = new Image(speechBubbleTexture);
			var textField:TextField = new TextField(200, 50, "Ay caramba!");
			textField.y = speechBubbleImage.height / 4;
			//Per default, Starling will use system fonts to render text. For example, if you set up your TextField to use "Arial", it will use the one installed on the system
			textField.format.setTo("Arial", 20, Color.RED);
			textField.format.horizontalAlign = Align.RIGHT;
			
			speechBubbleSprite.addChild(speechBubbleImage);
			speechBubbleSprite.addChild(textField);
			/*Per default, the pivot point is at (0, 0); in an image, that is the top left position. This method aligns the pivotX and pivotY to the center of the displayObject.*/
			speechBubbleSprite.alignPivot();
			speechBubbleSprite.x = stage.stageWidth / 2;
			speechBubbleSprite.y = stage.stageHeight / 2;
			speechBubbleSprite.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(speechBubbleSprite);
			
			var msgBox:MessageBox = new MessageBox("Really exit?");
			msgBox.x = 100;
			msgBox.y = 50;
			addChild(msgBox);
			
			var texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture);
			var xml:XML = XML(new AtlasXml());
			/*The trick is to have Stage3D use this big texture instead of the small ones, and to map only a part of it to each quad that
			 * is rendered. This will lead to a very efficient memory usage, wasting as little space as possible. (Some other frameworks
			 * call this feature Sprite Sheets.)*/
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			var moonTexture:Texture = atlas.getTexture("moon");
			var moonImage:Image = new Image(moonTexture);
			moonImage.alignPivot();
			moonImage.x = stage.stageWidth * 0.75;
			moonImage.y = stage.stageHeight * 0.75;
			addChild(moonImage);
			
			var dog:Dog = new Dog("shaggy");
			addChild(dog);
			dog.bark();
		}
		
		private function onTouch(event:TouchEvent):void
		{
			//As first parameter, we passed this to the getTouch method. Thus, we’re asking the the event to return any touches that occurred on on this or its children.
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				var localPos:Point = touchBegan.getLocation(this);
				trace("Touched object at position: " + localPos);
			}
			
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd) {
				var localPos:Point = touchEnd.getLocation(this);
				trace("Stopped touching object at position: " + localPos);
			}
		}
	}
}