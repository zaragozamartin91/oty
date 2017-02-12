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
			var multitouchEnabled = false;
			Starling.multitouchEnabled = multitouchEnabled;
			
			var screenWidth:int = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
			/* EL VIEWPORT ES EL RANGO DE DIBUJO DE LA PANTALLA */
			var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			trace("viewPort: " + viewPort);
			var screenRatio:Number = screenWidth / screenHeight;
			trace("screenRatio: " + screenRatio);
			
			_starling = new Starling(Game, stage, viewPort);
			/* EL STAGEWIDTH Y STAGEHEIGHT DEL STAGE DE STARLING ESTABLECEN LOS LIMITES DEL SISTEMA DE COORDENADAS DEL JUEGO */
			_starling.stage.stageWidth = 1000;
			_starling.stage.stageHeight = Math.ceil(_starling.stage.stageWidth / screenRatio);
			trace("_starling.stage.stageWidth: " + _starling.stage.stageWidth);
			trace("_starling.stage.stageHeight: " + _starling.stage.stageHeight);
			
			_starling.showStats = true;
			
			/*Permite probar la funcionalidad multitouch en pcs de escritorio*/
			_starling.simulateMultitouch = multitouchEnabled;
			
			_starling.addEventListener(Event.ROOT_CREATED, rootCreated);
			
			_starling.start();
		}
		
		private function rootCreated(event:Event, root:Game):void
		{			
			root.start();
		}
	}
}