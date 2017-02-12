package oty
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(frameRate = "60", backgroundColor = "#e0e0ff")]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		
		public function Main()
		{
			Starling.multitouchEnabled = true
			
			var screenWidth:int = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
			var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			trace("viewPort: " + viewPort);
			
			_starling = new Starling(Game, stage, viewPort);
			_starling.stage.stageWidth = 800;
			_starling.stage.stageHeight = 600;
			
			_starling.showStats = true;
			/*Permite probar la funcionalidad multitouch en pcs de escritorio*/
			_starling.simulateMultitouch = true;
			
			_starling.addEventListener(Event.ROOT_CREATED, rootCreated);
			
			_starling.start();
		}
		
		private function rootCreated(event:Event, root:Game):void
		{			
			root.start();
		}
	}
}