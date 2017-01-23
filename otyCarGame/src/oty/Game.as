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
		private var box2dWorld:b2World;
		
		private var buttonSpacing:Number;
		
		private var cameraCenter:Sprite;
		private var cam:Fluocam;
		
		private var starlingWorld:Sprite;
		
		private var moveButtonTexture:Texture;
		
		private var floorSprite:Sprite;
		private var floor:b2Body;
		private var floorWidthPx:Number;
		private var floorHeightPx:Number;
		
		private var car:DummyCar;
		
		public function Game():void
		{
		}
		
		public function start():void
		{
			trace("INIT!");
			//var debugSprite = new flash.display.Sprite();
			//Starling.current.nativeOverlay.addChild(debugSprite)
			
			box2dWorld = MainBox2dWorld.getInstance().world;
			
			debugDraw();
			
			starlingWorld = new Sprite();
			
			// ************************ THE FLOOR ************************ //
			
			floorWidthPx = stage.stageWidth * 2;
			floorHeightPx = 10;
			
			// shape
			var floorShape:b2PolygonShape = new b2PolygonShape();
			floorShape.SetAsBox(pixelsToMeters(floorWidthPx) / 2, pixelsToMeters(floorHeightPx) / 2);
			// fixture
			var floorFixture:b2FixtureDef = new b2FixtureDef();
			floorFixture.density = 0;
			floorFixture.friction = 3;
			floorFixture.restitution = 0;
			floorFixture.shape = floorShape;
			// body definition
			var floorBodyDef:b2BodyDef = new b2BodyDef();
			floorBodyDef.position.Set(pixelsToMeters(stage.stageWidth) / 2, pixelsToMeters(stage.stageHeight));
			// the floor itself
			floor = box2dWorld.CreateBody(floorBodyDef);
			floor.CreateFixture(floorFixture);
			
			/* SPRITES ----------------------------------------------------------------------------------------------------- */
			
			car = new DummyCar();
			car.addToWorld(starlingWorld);
			
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
			
			moveButtonTexture = TextureRepository.getInstance().moveButtonTexture;
			buttonSpacing = stage.stageHeight * 0.05;
			addForwardButton();
			addBackButton();
			
			var floorTexture:Texture = TextureRepository.getInstance().woodTexture;
			floorSprite = new Sprite();
			floorSprite.addChild(new Image(floorTexture));
			floorSprite.alignPivot();
			floorSprite.width = floorWidthPx;
			floorSprite.height = floorHeightPx;
			floorSprite.x = metersToPixels(floor.GetPosition().x);
			floorSprite.y = metersToPixels(floor.GetPosition().y);
			starlingWorld.addChild(floorSprite);
			
			addChild(starlingWorld);
			
			/* CAMERA ----------------------------------------------------------------------------------------------------- */
			
			var cam:Fluocam = new Fluocam(starlingWorld, stage.stageWidth, stage.stageHeight, false);
			addChild(cam);
			cameraCenter = new Sprite();
			cam.changeTarget(cameraCenter);
			
			/* LISTENERS ----------------------------------------------------------------------------------------------------- */
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		private function addForwardButton():void
		{
			var buttonImg:Image = new Image(moveButtonTexture);
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
			var buttonImg:Image = new Image(moveButtonTexture);
			var buttonSprite:Sprite = new Sprite();
			buttonSprite.addChild(buttonImg);
			buttonSprite.rotation = Math.PI;
			
			buttonSprite.width = stage.stageWidth * 0.15;
			buttonSprite.height = stage.stageWidth * 0.15;
			/* la separacion es de buttonSprite.width * 1.1 debido a que la rotacion de 180° provoca un "desplazamiento" del boton a la izquierda. */
			buttonSprite.x = stage.stageWidth - buttonSprite.width * 1.1 - buttonSpacing;
			buttonSprite.y = buttonSprite.height + buttonSpacing;
			
			buttonSprite.addEventListener(TouchEvent.TOUCH, onBackButtonTouch);
			
			addChild(buttonSprite);
		}
		
		public function debugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(Starling.current.nativeOverlay);
			debugDraw.SetDrawScale(MainBox2dWorld.PIXELS_TO_METER);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetAlpha(1);
			debugDraw.SetFillAlpha(0.4);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			//debugDraw.SetDrawScale(50);
			box2dWorld.SetDebugDraw(debugDraw);
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
		
		private function keyPressed(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
			case 37: 
				trace("LEFT");
				car.goLeft();
				break;
			case 39: 
				trace("RIGHT");
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
			cameraCenter.x = car.sprite.x;
			cameraCenter.y = car.sprite.y - 30;
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
