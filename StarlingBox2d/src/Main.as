package
{
    import flash.display.Sprite;
    import starling.core.Starling;

    [SWF(width="800", height="600", frameRate="60", backgroundColor="#808080")]
    public class Main extends Sprite
    {
        private var _starling:Starling;

        public function Main()
        {
            _starling = new Starling(Game, stage);
            _starling.start();
        }
    }
}