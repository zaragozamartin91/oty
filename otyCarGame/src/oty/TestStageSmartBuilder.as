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
	public class TestStageSmartBuilder implements Updatable
	{
		public static const UPDATE_CHECK_PERIOD:Number = 30;
		private var _frameCount:Number = 0;
		
		private var _stage:Stage;
		private var _stageWidth:Number;
		private var _starlingWorld:Sprite;
		
		private var _floorWidthPx:Number;
		private var _floorHeightPx:Number;
		private var _floor:StraightRamp;
		
		private var _mainSprite:Sprite;
		
		private var _rampCount:Number = 0;
		private var _rampManagers:Vector.<Function> = new Vector.<Function>();
		
		/**
		 * Constructor inteligente de nivel.
		 * @param	stage Nivel / stage de starling.
		 * @param	starlingWorld Sprite principal donde agregar los elementos.
		 * @param	floorWidthPx Anchura del suelo.
		 * @param	floorHeightPx Altura del suelo.
		 */
		public function TestStageSmartBuilder(stage:Stage, starlingWorld:Sprite, floorWidthPx:Number, floorHeightPx:Number)
		{
			_stage = stage;
			_stageWidth = _stage.stageWidth;
			_starlingWorld = starlingWorld;
			_floorWidthPx = floorWidthPx || stage.stageWidth * 4;
			_floorHeightPx = floorHeightPx || 100;
			
			addRampManager(_floorWidthPx / 2, stage.stageHeight, _floorWidthPx, _floorHeightPx, 0);
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
		
		public function update(time:Number = 0):void
		{
			if (_frameCount % UPDATE_CHECK_PERIOD == 0)
			{
				_rampManagers.forEach(function(rampManager:Function, index:int, vector:Vector.<Function>):void
				{
					rampManager();
				});
			}
			_frameCount = _frameCount > 999999 ? 0 : _frameCount + 1;
			_frameCount;
		}
		
		private function buildStage():void
		{
			var rampPosX:Number = _floorWidthPx / 2;
			var rampPosY:Number = _stage.stageHeight - _floorHeightPx / 2;
			var rampWidth:Number = 600;
			var rampHeight:Number = _floorHeightPx;
			var askewRampAngle = Math.PI / 12;
			var rampAngle:Number = -askewRampAngle;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX = _floorWidthPx;
			rampPosY = rampPosY - rampHeight;
			rampWidth = 1200;
			rampAngle = -askewRampAngle;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampAngle = Math.abs(rampAngle);
			var rampLenX:Number = Math.abs(rampWidth * Math.cos(rampAngle));
			var rampLenY:Number = Math.abs(rampWidth * Math.sin(rampAngle));
			rampPosX = rampPosX + rampLenX / 2 + rampWidth / 2;
			rampPosY = rampPosY - rampLenY / 2;
			rampAngle = 0;
			rampWidth = 900;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampWidth = 1200;
			rampPosX = rampPosX + rampWidth;
			rampPosY = rampPosY + rampHeight * 3;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampAngle = Math.PI / 6;
			rampPosX += Math.abs(rampWidth * Math.cos(rampAngle)) + 130;
			rampPosY += Math.abs(rampWidth * Math.sin(rampAngle)) / 2;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += Math.abs(rampWidth * Math.cos(rampAngle));
			rampPosY += Math.abs(rampWidth * Math.sin(rampAngle)) / 2;
			rampWidth = 600;
			rampPosX -= rampWidth / 2;
			rampAngle = 0;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += rampWidth / 2;
			rampAngle = -Math.PI / 6;
			rampWidth = 900;
			rampPosX += Math.abs(rampWidth * Math.cos(rampAngle)) / 2;
			rampPosY -= Math.abs(rampWidth * Math.sin(rampAngle)) / 2;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += Math.abs(rampWidth * Math.cos(rampAngle)) / 2;
			rampPosX += rampWidth / 2;
			rampAngle = 0;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			var spacingX = 90;
			var spacingY = 60;
			rampPosX += rampWidth + spacingX;
			rampWidth = 600;
			rampPosX -= rampWidth / 2;
			//rampPosY += spacingY;
			rampAngle = -askewRampAngle;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += rampWidth + spacingX;
			//rampPosY += spacingY;
			rampAngle = askewRampAngle;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += rampWidth + spacingX;
			//rampPosY += spacingY;
			rampAngle = -askewRampAngle;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += rampWidth + spacingX;
			//rampPosY += spacingY;
			rampAngle = askewRampAngle;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
			
			rampPosX += rampWidth + spacingX;
			//rampPosY += spacingY;
			rampAngle = -askewRampAngle;
			addRampManager(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle);
		}
		
		private function addRampManager(rampPosX:Number, rampPosY:Number, rampWidth:Number, rampHeight:Number, rampAngle:Number):void
		{
			var rampAdded:Boolean = false;
			var rampDisposed:Boolean = false;
			var ramp:StraightRamp = null
			var rampLowerBoundX:Number = rampPosX - rampWidth - _stageWidth;
			var rampUpperBoundX:Number = rampPosX + rampWidth + _stageWidth;
			var rampId:Number = _rampCount++;
			
			_rampManagers.push(function():void
			{
				if (_mainSprite.x > rampLowerBoundX && _mainSprite.x < rampUpperBoundX && !rampAdded)
				{
					ramp = new StraightRamp(rampPosX, rampPosY, rampWidth, rampHeight, rampAngle).addToWorld(_starlingWorld);
					ramp.body.SetUserData({name: NameLibrary.RAMP_BODY_NAME});
					rampAdded = true;
					rampDisposed = false;
					trace("ADDING RAMP #" + rampId);
				}
				
				if ((_mainSprite.x > rampUpperBoundX || _mainSprite.x < rampLowerBoundX) && rampAdded && !rampDisposed)
				{
					ramp.dispose();
					rampAdded = false;
					rampDisposed = true;
					/* Seteo la referencia a null para permitir al GargabeCollector reclamar la memoria */
					ramp = null;
					trace("DISPONSING RAMP #" + rampId);
				}
			});
		}
	}
}

