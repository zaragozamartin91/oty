package oty
{
	import flash.geom.Point;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.core.Starling;
	
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import starling.extensions.fluocode.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	
	public class Game extends starling.display.Sprite
	{
		public static const STARLING_WORLD:Sprite = new Sprite();
		
		private var _background:Background;
		
		private var _buttonSpacing:Number;
		
		private var _floor:StraightRamp;
		private var _floorWidthPx:Number;
		private var _floorHeightPx:Number;
		
		private var _car:DummyCar;
		private var _carPrevPosXPx:Number = 0;
		private var _carPrevPosYPx:Number = 0;
		
		private var _camera:MainCamera;
		private var _cameraPos:*;
		
		private var _stageBuilder:TestStageSmartBuilder;
		
		private var _gameUpdater:GameUpdater = GameUpdater.getInstance();
		
		public function Game():void
		{
		}
		
		public function start():void
		{
			trace("INIT!");
			//var debugSprite = new flash.display.Sprite();
			//Starling.current.nativeOverlay.addChild(debugSprite)
			
			//MainBox2dWorld.getInstance().debugDraw();
			MainBox2dWorld.getInstance().world.SetContactListener(MainBox2dContactListener.getInstance());
			
			// ************************ COLLISION ************************ //
			
			var tumbleCollisionAction:CollisionAction = new CollisionAction(function(body1:b2Body, body2:b2Body):Boolean
			{
				var body1UserData:* = body1.GetUserData() || {};
				var body2UserData:* = body2.GetUserData() || {};
				
				var carBody:b2Body;
				var otherBody:b2Body;
				if (body1UserData.name == NameLibrary.CAR_BODY_NAME)
				{
					carBody = body1;
					otherBody = body2;
				}
				else if (body2UserData.name == NameLibrary.CAR_BODY_NAME)
				{
					carBody = body2;
					otherBody = body1;
				}
				
				if (carBody)
				{
					var angleDiff:Number = Math.abs(carBody.GetAngle() - otherBody.GetAngle());
					trace("angleDiff: " + radToDeg(angleDiff) + "°");
					return radToDeg(angleDiff) >= 80;
				}
				return false;
			}, function(body1, body2):void
			{
				trace("CAR TUMBLE");
				restoreCar();
			});
			
			MainBox2dContactListener.getInstance().addBeginContactAction(tumbleCollisionAction);
			
			// ************************ BACKGROUND ************************ //
			
			_background = Background.buildNew(stage.stageWidth, stage.stageHeight * 2, 10, 250);
			this.addChild(_background);
			
			// ************************ CAR ************************ //
			
			_car = new DummyCar();
			_car.addToWorld(STARLING_WORLD);
			_carPrevPosXPx = _car.sprite.x;
			_carPrevPosYPx = _car.sprite.y;
			
			// ************************ STAGE BUILDER ************************ //
			
			_floorWidthPx = stage.stageWidth * 4;
			_floorHeightPx = 100;
			_stageBuilder = new TestStageSmartBuilder(stage, STARLING_WORLD, _floorWidthPx, _floorHeightPx).withMainSprite(_car.sprite);
			
			// ************************ INTRO ANIMATION ************************ //
			
			var otyTexture:Texture = TextureRepository.getInstance().otyLogoTexture;
			var otySprite:Sprite = new Sprite();
			otySprite.addChild(new Image(otyTexture));
			otySprite.scale = 0.2;
			otySprite.alignPivot();
			otySprite.x = stage.stageWidth / 2;
			otySprite.y = stage.stageHeight * 0.45;
			addChild(otySprite);
			var otyTween:Tween = new Tween(otySprite, 2);
			otyTween.animate("scale", 0.5);
			otyTween.animate("alpha", 0.5);
			otyTween.animate("rotation", Math.PI * 2);
			Starling.juggler.add(otyTween);
			
			this.addChild(STARLING_WORLD);
			
			// ************************ BUTTONS ************************ //
			
			_buttonSpacing = stage.stageHeight * 0.05;
			addForwardButton();
			addBackButton();
			addResetButton();
			
			// ************************ CAMERA ************************ //
			
			MainCamera.buildNew(STARLING_WORLD, stage.stageWidth, stage.stageHeight);
			_camera = MainCamera.getInstance().setOffset(_car.sprite.width, 0).setTarget(_car.sprite).addToWorld(this);
			
			// ************************ UPDATABLES ************************ //
			
			_gameUpdater.addPermUpdatable(NameLibrary.STAGE_BUILDER, _stageBuilder);
			_gameUpdater.addPermUpdatable(NameLibrary.CAR_BODY_NAME, _car);
			_gameUpdater.addPermUpdatable(NameLibrary.BOX2D_WORLD, MainBox2dWorld.getInstance());
			_gameUpdater.addPermUpdatable(NameLibrary.CAMERA, _camera);
			
			// ************************ LISTENERS ************************ //
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			this.addEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		private function addForwardButton():void
		{
			var buttonImg:Image = new Image(TextureRepository.getInstance().moveButtonTexture);
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(buttonImg);
			
			/* El boton sera transparente */
			buttonSprite.alpha = 0;
			buttonSprite.width = stage.stageWidth / 2;
			buttonSprite.height = stage.stageHeight;
			buttonSprite.x = stage.stageWidth / 2;
			buttonSprite.y = 0;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onForwardButtonTouch);
			
			addChild(buttonSprite);
		}
		
		private function addBackButton():void
		{
			var buttonImg:Image = new Image(TextureRepository.getInstance().moveButtonTexture);
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(buttonImg);
			buttonSprite.rotation = Math.PI;
			
			/* El boton sera transparente */
			buttonSprite.alpha = 0;
			buttonSprite.width = stage.stageWidth / 2;
			buttonSprite.height = stage.stageHeight;
			/* la separacion es de buttonSprite.width * 1.1 debido a que la rotacion de 180° provoca un "desplazamiento" del boton a la izquierda. */
			buttonSprite.x = stage.stageWidth - buttonSprite.width;
			buttonSprite.y = buttonSprite.height;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onBackButtonTouch);
			
			addChild(buttonSprite);
		}
		
		private function addResetButton():void
		{
			var buttonImg:Image = new Image(TextureRepository.getInstance().resetButtonTexture);
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(buttonImg);
			
			buttonSprite.width = stage.stageWidth * 0.15;
			buttonSprite.height = stage.stageWidth * 0.15;
			buttonSprite.x = stage.stageWidth - buttonSprite.width * 3 - _buttonSpacing * 3;
			buttonSprite.y = _buttonSpacing;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onResetButtonTouch);
			
			addChild(buttonSprite);
		}
		
		private function onForwardButtonTouch(event:TouchEvent):void
		{
			/* EVITO LA PROPAGACION DE LOS EVENTOS TOUCH EN EL BOTON PARA EVITAR EL DESPLAZAMIENTO DE LA PANTALLA POR ARRAASTRE DEL DEDO (COMPORTAMIENTO POR DEFECTO DE STARLING) */
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			//As first parameter, we passed this to the getTouch method. Thus, we’re asking the the event to return any touches that occurred on on this or its children.
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				var touchPosStart:Point = touchBegan.getLocation(this);
				trace("Touched object at position: " + touchPosStart);
				_car.goRight();
			}
			
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd)
			{
				var touchPosEnd:Point = touchEnd.getLocation(this);
				trace("Stopped touching object at position: " + touchPosEnd);
				_car.stopRight();
			}
		}
		
		private function onBackButtonTouch(event:TouchEvent):void
		{
			/* EVITO LA PROPAGACION DE LOS EVENTOS TOUCH EN EL BOTON PARA EVITAR EL DESPLAZAMIENTO DE LA PANTALLA POR ARRAASTRE DEL DEDO (COMPORTAMIENTO POR DEFECTO DE STARLING) */
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			//As first parameter, we passed this to the getTouch method. Thus, we’re asking the the event to return any touches that occurred on on this or its children.
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				var touchPosStart:Point = touchBegan.getLocation(this);
				trace("Touched object at position: " + touchPosStart);
				_car.goLeft();
			}
			
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd)
			{
				var touchPosEnd:Point = touchEnd.getLocation(this);
				trace("Stopped touching object at position: " + touchPosEnd);
				_car.stopLeft();
			}
		}
		
		private function onResetButtonTouch(event:TouchEvent):void
		{
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd)
			{
				resetCar();
			}
		}
		
		private function restoreCar():void
		{
			var xpx:Number = _car.sprite.x;
			var ypx:Number = _car.sprite.y - _car.sprite.height;
			_car.tweenToPosition(xpx, ypx);
		}
		
		private function resetCar():void
		{
			var xpx:Number = _floorWidthPx / 4;
			//var ypx:Number = _floor.sprite.y - _floor.sprite.height - _car.sprite.height * 2;
			var ypx:Number = 0;
			var tweenTime:Number = Math.floor(_car.sprite.x / stage.stageWidth / 3);
			_car.tweenToPosition(xpx, ypx, tweenTime);
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				_car.goLeft();
				break;
			case 39: 
				_car.goRight();
				break;
			}
		}
		
		private function keyReleased(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				_car.stopLeft();
				break;
			case 39: 
				_car.stopRight();
				break;
			}
		
		}
		
		// este metodo sera invocado en cada frame
		private function updateWorld(e:Event, time:Number):void
		{
			_gameUpdater.update(time);
			
			_background.updateFromDist(_car.sprite.x - _carPrevPosXPx, _car.sprite.y - _carPrevPosYPx, 2, 3);
			_carPrevPosXPx = _car.sprite.x;
			_carPrevPosYPx = _car.sprite.y;
		}
		
		public static function metersToPixels(m:Number):Number
		{
			return MainBox2dWorld.metersToPixels(m);
		}
		
		public static function pixelsToMeters(p:Number):Number
		{
			return MainBox2dWorld.pixelsToMeters(p);
		}
		
		public static function radToDeg(rad:Number):Number
		{
			return 180 * rad / Math.PI;
		}
	}
}
