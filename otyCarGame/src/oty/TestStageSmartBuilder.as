package oty
{
	import starling.display.Sprite;
	import starling.display.Stage;
	
	/**
	 * Constructor de nivel de prueba inteligente.
	 * Agrega elementos al nivel a medida que
	 *
	 * @author martin
	 */
	public class TestStageSmartBuilder
	{
		private var _stage:Stage;
		private var _starlingWorld:Sprite;
		private var _floorWidthPx:Number;
		private var _floorHeightPx:Number;
		private var _mainSprite:Sprite;
		
		private var _rampManagers:Vector.<Function> = new Vector.<Function>();
		
		public function TestStageSmartBuilder(stage:Stage, starlingWorld:Sprite, floorWidthPx:Number, floorHeightPx:Number)
		{
			_stage = stage;
			_starlingWorld = starlingWorld;
			_floorWidthPx = floorWidthPx || stage.stageWidth * 4;
			_floorHeightPx = floorHeightPx || 100;
			buildStage();
		}
		
		/**
		 * Asigna el sprite principal que el constructor de nivel seguira para la construccion y destruccion del nivel.
		 * @param	mainSprite Sprite principal a seguir.
		 * @return this.
		 */
		public function withMainSprite(mainSprite:Sprite):TestStageSmartBuilder
		{
			_mainSprite = mainSprite;
			return this;
		}
		
		public function update():void
		{
			_rampManagers.forEach(function(rampManager:Function, index:int, vector:Vector.<Function>):void
			{
				rampManager();
			});
		}
		
		private function buildStage():void
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
			
			rampAngle = Math.PI / 6;
			rampPosX += Math.abs(rampWidth * Math.cos(rampAngle)) + 130;
			rampPosY += Math.abs(rampWidth * Math.sin(rampAngle)) / 2;
			addRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += Math.abs(rampWidth * Math.cos(rampAngle));
			rampPosY += Math.abs(rampWidth * Math.sin(rampAngle)) / 2;
		}
		
		private function addRamp(rampPosX:Number, rampPosY:Number, rampWidth:Number, rampHeight:Number, rampAngle:Number):void
		{
			var rampAdded:Boolean = false;
			var rampDisposed:Boolean = false;
			var ramp:StraightRamp = null
			var createThresholdX:Number = rampPosX - rampWidth * 2;
			var destroyThresholdX:Number = rampPosX + rampWidth * 2;
			
			_rampManagers.push(function():void
			{
				if (_mainSprite.x > createThresholdX && !rampAdded)
				{
					ramp = new StraightRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle).addToWorld(_starlingWorld);
					ramp.body.SetUserData({name: NameLibrary.RAMP_BODY_NAME});
					rampAdded = true;
					trace("ADDING RAMP!");
				}
				
				if (_mainSprite.x > destroyThresholdX && rampAdded && !rampDisposed)
				{
					//_starlingWorld.removeChild(ramp.sprite, true);
					ramp.dispose();
					rampDisposed = true;
					trace("DISPONSING RAMP!");
				}
			});
		}
	}
}

