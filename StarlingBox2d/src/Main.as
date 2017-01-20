package
{
	import flash.display.Sprite;
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(width = "800", height = "600", frameRate = "60", backgroundColor = "#ffffff")]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		
		public function Main()
		{
			Starling.multitouchEnabled = true
			
			_starling = new Starling(Game, stage);
			
			_starling.showStats = true;
			/*Permite probar la funcionalidad multitouch en pcs de escritorio*/
			_starling.simulateMultitouch = true;
			
			_starling.addEventListener(Event.ROOT_CREATED, rootCreated);
			
			_starling.start();
		}
		
		private function rootCreated(event:Event, root:Game):void
		{
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
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
		
			root.start();
		}
	}
}