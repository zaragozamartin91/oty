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
		private var _floorWidthPx:Number;
		private var _floorHeightPx:Number;
		
		public function TestStageBuilder(stage:Stage, starlingWorld:Sprite, floorWidthPx:Number, floorHeightPx:Number)
		{
			_stage = stage;
			_starlingWorld = starlingWorld;
			_floorWidthPx = floorWidthPx || stage.stageWidth * 4;
			_floorHeightPx = floorHeightPx || 100;
		}
		
		public function buildStage():void
		{
			var rampPosX:Number = _floorWidthPx / 2;
			var rampPosY:Number = _stage.stageHeight - _floorHeightPx / 2;
			var rampWidth:Number = 600;
			var rampHeight:Number = _floorHeightPx;
			var rampAngle:Number = -Math.PI / 12;
			
			addRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX = _floorWidthPx;
			rampPosY = rampPosY - rampHeight;
			rampWidth = 1200;
			rampAngle = -Math.PI / 12;
			
			addRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampAngle = Math.abs(rampAngle);
			var rampLenX:Number = Math.abs(rampWidth * Math.cos(rampAngle));
			var rampLenY:Number = Math.abs(rampWidth * Math.sin(rampAngle));
			rampPosX = rampPosX + rampLenX / 2 + rampWidth / 2;
			rampPosY = rampPosY - rampLenY / 2;
			rampAngle = 0;
			rampWidth = 900;
			
			addRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampWidth = 1200;
			rampPosX = rampPosX + rampWidth;
			rampPosY = rampPosY + rampHeight * 3;
			
			addRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
		}
		
		private function addRamp(rampPosX:Number, rampPosY:Number, rampWidth:Number, rampHeight:Number, rampAngle:Number):void
		{
			var ramp:StraightRamp = new StraightRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle).addToWorld(_starlingWorld);
			ramp.body.SetUserData({name: NameLibrary.RAMP_BODY_NAME});
		}
	}

}