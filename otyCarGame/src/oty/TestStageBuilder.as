package oty
{
	import starling.display.Sprite;
	import starling.display.Stage;
	
	/**
	 * Constructor de nivel de prueba
	 * @author martin
	 */
	public class TestStageBuilder
	{
		private var _stage:Stage;
		private var _starlingWorld:Sprite;
		
		public function TestStageBuilder(stage:Stage, starlingWorld:Sprite)
		{
			_stage = stage;
			_starlingWorld = starlingWorld;
		}
		
		public function buildStage()
		{
			var floorWidthPx = _stage.stageWidth * 4;
			var floorHeightPx = 100;
			var ramp:StraightRamp = new StraightRamp(floorWidthPx / 2, _stage.stageHeight - floorHeightPx / 2, 600, floorHeightPx, -Math.PI / 12).addToWorld(_starlingWorld);
			ramp.body.SetUserData({name: NameLibrary.RAMP_BODY_NAME});
		}
	}

}