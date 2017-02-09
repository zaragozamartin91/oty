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
	import starling.extensions.krecha.ScrollImage;
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
		
		private var buttonSpacing:Number;
		
		private var floor:StraightRamp;
		private var floorWidthPx:Number;
		private var floorHeightPx:Number;
		
		private var car:DummyCar;
		
		private var camera:MainCamera;
		
		private var cameraPos:*;
		
		public function Game():void
		{
		}
		
		public function start():void
		{
			trace("INIT!");
			//var debugSprite = new flash.display.Sprite();
			//Starling.current.nativeOverlay.addChild(debugSprite)
			
			MainBox2dWorld.getInstance().debugDraw();
			MainBox2dWorld.getInstance().world.SetContactListener(MainBox2dContactListener.getInstance());
			
			var tumbleCollisionAction:CollisionAction = new CollisionAction(function(body1:b2Body, body2:b2Body):Boolean
			{
				var body1UserData:* = body1.GetUserData() ? body1.GetUserData() : {};
				var body2UserData:* = body2.GetUserData() ? body2.GetUserData() : {};
				var carBody:b2Body = body1UserData.name == NameLibrary.CAR_BODY_NAME ? body1 : null;
				carBody = body2UserData.name == NameLibrary.CAR_BODY_NAME ? body2 : carBody;
				if (carBody)
				{
					trace("CAR/TRUNK/HOOD BODY ANGLE: " + carBody.GetAngle());
					return carBody.GetAngle() > Math.PI / 2 && carBody.GetAngle() < 3 * Math.PI / 2;
				}
				return false;
			}, function(body1, body2):void
			{
				trace("CAR TUMBLE");
				restoreCar();
			});
			
			MainBox2dContactListener.getInstance().addBeginContactAction(tumbleCollisionAction);
			
			// ************************ BACKGROUND ************************ //
			
			_background = new Background(stage.stageWidth, stage.stageHeight);
			this.addChild(_background);
			
			// ************************ THE FLOOR ************************ //
			
			floorWidthPx = stage.stageWidth * 4;
			floorHeightPx = 100;
			floor = new StraightRamp(floorWidthPx / 2, stage.stageHeight, floorWidthPx, floorHeightPx);
			floor.body.GetDefinition();
			floor.addToWorld(STARLING_WORLD);
			floor.body.SetUserData({name: NameLibrary.FLOOR_BODY_NAME});
			
			// ************************ STAGE BUILD ************************ //
			
			var stageBuilder:TestStageBuilder = new TestStageBuilder(stage, STARLING_WORLD, floorWidthPx, floorHeightPx);
			stageBuilder.buildStage();
			
			// ************************ CAR ************************ //
			
			car = new DummyCar();
			car.addToWorld(STARLING_WORLD);
			
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
			
			buttonSpacing = stage.stageHeight * 0.05;
			addForwardButton();
			addBackButton();
			addResetButton();
			
			// ************************ CAMERA ************************ //
			
			MainCamera.buildNew(STARLING_WORLD, stage.stageWidth, stage.stageHeight);
			camera = MainCamera.getInstance().setOffset(0, -30).setTarget(car.sprite).addToWorld(this);
			
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
			
			buttonSprite.width = stage.stageWidth * 0.15;
			buttonSprite.height = stage.stageWidth * 0.15;
			buttonSprite.x = stage.stageWidth - buttonSprite.width - buttonSpacing;
			buttonSprite.y = buttonSpacing;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onForwardButtonTouch);
			
			addChild(buttonSprite);
		}
		
		private function addBackButton():void
		{
			var buttonImg:Image = new Image(TextureRepository.getInstance().moveButtonTexture);
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(buttonImg);
			buttonSprite.rotation = Math.PI;
			
			buttonSprite.width = stage.stageWidth * 0.15;
			buttonSprite.height = stage.stageWidth * 0.15;
			/* la separacion es de buttonSprite.width * 1.1 debido a que la rotacion de 180° provoca un "desplazamiento" del boton a la izquierda. */
			buttonSprite.x = stage.stageWidth - buttonSprite.width - buttonSpacing * 2;
			buttonSprite.y = buttonSprite.height + buttonSpacing;
			
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
			buttonSprite.x = stage.stageWidth - buttonSprite.width * 3 - buttonSpacing * 3;
			buttonSprite.y = buttonSpacing;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onResetButtonTouch);
			
			addChild(buttonSprite);
		}
		
		private function onForwardButtonTouch(event:TouchEvent):void
		{
			//As first parameter, we passed this to the getTouch method. Thus, we’re asking the the event to return any touches that occurred on on this or its children.
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				var touchPosStart:Point = touchBegan.getLocation(this);
				trace("Touched object at position: " + touchPosStart);
				car.goRight();
			}
			
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd)
			{
				var touchPosEnd:Point = touchEnd.getLocation(this);
				trace("Stopped touching object at position: " + touchPosEnd);
				car.stopRight();
			}
		}
		
		private function onBackButtonTouch(event:TouchEvent):void
		{
			//As first parameter, we passed this to the getTouch method. Thus, we’re asking the the event to return any touches that occurred on on this or its children.
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				var touchPosStart:Point = touchBegan.getLocation(this);
				trace("Touched object at position: " + touchPosStart);
				car.goLeft();
			}
			
			var touchEnd:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touchEnd)
			{
				var touchPosEnd:Point = touchEnd.getLocation(this);
				trace("Stopped touching object at position: " + touchPosEnd);
				car.stopLeft();
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
			var xpx:Number = car.sprite.x;
			var ypx:Number = car.sprite.y - car.sprite.height;
			car.tweenToPosition(xpx, ypx);
		}
		
		private function resetCar():void
		{
			var xpx:Number = floorWidthPx / 4;
			var ypx:Number = floor.sprite.y - floor.sprite.height - car.sprite.height * 2;
			car.tweenToPosition(xpx, ypx);
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				car.goLeft();
				break;
			case 39: 
				car.goRight();
				break;
			}
		}
		
		private function keyReleased(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				car.stopLeft();
				break;
			case 39: 
				car.stopRight();
				break;
			}
		}
		
		// este metodo sera invocado en cada frame
		private function updateWorld(e:Event, time:Number):void
		{
			car.update(time);
			MainBox2dWorld.getInstance().update();
			
			if (camera)
			{
				camera.update();
			}
			
			var vxpx:Number = metersToPixels(car.body.GetLinearVelocity().x);
			var vypx:Number = metersToPixels(car.body.GetLinearVelocity().y);
			_background.update(time, vxpx, vypx);
		}
		
		public static function metersToPixels(m:Number):Number
		{
			return MainBox2dWorld.metersToPixels(m);
		}
		
		public static function pixelsToMeters(p:Number):Number
		{
			return MainBox2dWorld.pixelsToMeters(p);
		}
	}
}
