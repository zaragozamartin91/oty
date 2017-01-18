package
{
	import citrus.core.starling.StarlingCitrusEngine;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author martin
	 */
	public class Main extends StarlingCitrusEngine
	{
		
		public function Main()
		{
		}
		
		override public function initialize():void
		{
			setUpStarling(true);
		}
		
		override public function handleStarlingReady():void
		{
			state = new StarlingDemoGameState();
		}
	}

}