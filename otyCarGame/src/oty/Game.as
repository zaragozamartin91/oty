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
		
		private var buttonSpacing:Number;
		
		private var moveButtonTexture:Texture;
		
		private var floor:StraightRamp;
		private var floorWidthPx:Number;
		private var floorHeightPx:Number;
		
		private var car:DummyCar;
		
		private var camera:MainCamera;
		
		public function Game():void
		{
		}
		
		public function start():void
		{
			trace("INIT!");
			//var debugSprite = new flash.display.Sprite();
			//Starling.current.nativeOverlay.addChild(debugSprite)
			
			MainBox2dWorld.getInstance().debugDraw();
			
			// ************************ THE FLOOR ************************ //
			
			floorWidthPx = stage.stageWidth * 4;
			floorHeightPx = 100;
			floor = new StraightRamp(floorWidthPx / 2, stage.stageHeight, floorWidthPx, floorHeightPx);
			floor.addToWorld(STARLING_WORLD);
			
			new StraightRamp(floorWidthPx / 2, stage.stageHeight - floorHeightPx / 2, 600, floorHeightPx, -Math.PI / 12).addToWorld(STARLING_WORLD);
			
			car = new DummyCar();
			car.addToWorld(STARLING_WORLD);
			
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
			
			this.addChild(STARLING_WORLD);
			
			/* CAMERA ----------------------------------------------------------------------------------------------------- */
			
			MainCamera.buildNew(STARLING_WORLD, stage.stageWidth, stage.stageHeight);
			camera = MainCamera.getInstance().addToWorld(this);
			
			/* LISTENERS ----------------------------------------------------------------------------------------------------- */
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			this.addEventListener(Event.ENTER_FRAME, updateWorld);
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
			
			if (camera)
			{
				camera.setCenterX(car.sprite.x).setCenterY(car.sprite.y - 30);
			}
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
