package view.entity
{
	import flash.display.Scene;
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.UiController;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.FarmScene;

	public class MovableEntity extends Sprite
	{
		private var currentTile:Tile ;
		private var len_x:int ;
		private var len_y:int ;
		public function MovableEntity(entity:GameEntity)
		{
			var surface:DisplayObject ;
			if(GameController.instance.selectTool == UiController.TOOL_ADDFEILD){
				len_x = len_y = 2;
				surface = new Image(Game.assets.getTexture("FieldLand"));
				currentTile = scene.getCurrentFocusPos(2,2);
			}else if(entity){
				surface = entity;
				currentTile = entity.getTopTile();
			}
			addChild(surface);
			surface.x = - surface.width/2;
			surface.y = - surface.height;
			moveToTile(currentTile);
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.MOVED);
			if (touches.length >= 1){
				e.stopPropagation();
				var scenePos:Point = touches[0].getLocation(scene);
				var tile:Tile = Map.intance.sceneToIso(scenePos);
				if(tile && tile != currentTile){
					moveToTile(tile);
					currentTile = tile;
				}
			}
		}
		
		private function moveToTile(tile:Tile):void
		{
			var topPoint:Point = Map.intance.iosToScene(tile.x +len_x,tile.y+len_y);
			x = topPoint.x;
			y = topPoint.y;
		}
		public function cancel():void
		{
			
		}
		private function get scene():FarmScene
		{
			return GameController.instance.currentFarm;
		}
	}
}