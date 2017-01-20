package 
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
 
    import starling.core.Starling;
 
    [SWF(width="600", height="300", frameRate="60", backgroundColor="#000000")]
    public class Main extends Sprite
    {
        private var mStarling:Starling;
 
        public function Main()
        {
            // These settings are recommended to avoid problems with touch handling
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
 
            // Create a Starling instance that will run the "Game" class
            mStarling = new Starling(Game, stage);

			mStarling.simulateMultitouch=true;
			
            mStarling.start();
        }
    }
}