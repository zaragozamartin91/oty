package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/*Note that the class extends flash.display.Sprite, not the Starling variant. That’s simply a necessity of all Main
	 * classes in AS3. However, as soon as Starling has finished starting up, the logic is moved over to the Game class,
	 * which builds our link to the starling.display world*/
	[SWF(backgroundColor = "#FFFFFF", frameRate = "60")]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		private var viewPort:Rectangle;
		
		public function Main()
		{
			/*
			 * all parameters:
			 * rootClass:Class,
			   stage:Stage,
			   viewPort:Rectangle = null,
			   stage3D:Stage3D = null,
			   renderMode:String = auto,
			   profile:Object = auto);*/
			
			viewPort = new Rectangle(0, 0, 640, 480);
			
			_starling = new Starling(Game, stage, viewPort);
			_starling.addEventListener(Event.ROOT_CREATED, rootCreated);
			
			_starling.showStats = true;
			
			//the skipUnchangedFrames-property. If enabled, static scenes are recognized as such and the back buffer is simply left as it is. 
			/*it doesn’t work well with Render- and VideoTextures. Changes in those textures simply won’t show up.
			 * It’s easy to work around that, though: either disable skipUnchangedFrames temporarily while using them, or call stage.setRequiresRedraw() whenever their content changes*/
			_starling.skipUnchangedFrames = true;
			
			_starling.start();
		
			//Starling’s setup process is asynchronous
		}
		
		private function rootCreated(event:Event, root:Game):void
		{
			trace("root created!");
			
			/* anchura y altura del STAGE DE FLASH */
			stage.stageWidth = 800;
			stage.stageHeight = 600;
			
			/* the stage is always stretched across the complete viewPort. What you are changing, though, is the size of the
			 * stage’s coordinate system. That means that with a stage width of 1024, an object with an x-coordinate of 1000
			 * will be close to the right edge of the stage; no matter if the viewPort is 512, 1024, or 2048 pixels wide.
			 */
			_starling.viewPort.width = stage.stageWidth;
			_starling.viewPort.height = stage.stageHeight;			
			//The hierarchy of all display objects that will be rendered is called the display list. The Stage makes up the root of the display list
			// anchura y altura del stage de STARLING.
			_starling.stage.stageWidth = 1024;
			_starling.stage.stageHeight = 768;
			
			trace("_starling.contentScaleFactor:" + _starling.contentScaleFactor); // -> 2.0
			
			/* The nativeOverlay property is the easiest way to do so. That’s a conventional flash.display.Sprite that lies
			 * directly on top of Starling, taking viewPort and contentScaleFactor into account. If you need to use conventional
			 * Flash objects, add them to this overlay.
			   Beware, though, that conventional Flash content on top of Stage3D can lead to performance penalties on some (mobile) platforms. For that reason, always remove all objects from the overlay when you don’t need them any longer.
			 */
			
			root.start();
		}
	}
}