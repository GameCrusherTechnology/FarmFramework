package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.UiController;
	
	import gameconfig.Configrations;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.CropItem;
	
	import starling.display.Image;
	import starling.display.MovieClip;
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
		private var movableMc:MovieClip;
		private var currentEntity:GameEntity;
		public function MovableEntity(entity:GameEntity)
		{
			currentEntity = entity;
			len_x = entity.length_x;
			len_y = entity.length_y;
			if(entity is CropEntity){
				var fieldSur:Image = (entity as CropEntity).fieldSUR;
				fieldSur.x = - fieldSur.width/2;
				fieldSur.y = - fieldSur.height;
				currentEntity.addChild((entity as CropEntity).fieldSUR);
			}
			currentEntity.x = currentEntity.y = 0;
			addChild(currentEntity);
			currentTile = entity.getTopTile();
			movableMc = new MovieClip(Game.assets.getTextures("movableSkin"));
			movableMc.width = (len_x+len_y)/2*Configrations.Tile_Width+5;
			movableMc.height = (len_x+len_y)/2*Configrations.Tile_Height+4;
			addChild(movableMc);
			movableMc.x = -movableMc.width/2;
			movableMc.y = -movableMc.height+2;
			
			moveToTile(currentTile);
			currentEntity.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			e.stopPropagation();
			var touches:Vector.<Touch> = e.getTouches(currentEntity, TouchPhase.MOVED);
			if (touches.length >= 1){
				var scenePos:Point = touches[0].getLocation(scene);
				var tile:Tile = Map.intance.sceneToIso(scenePos);
				if(tile &&  tile != currentTile){
					var tile1:Tile = Map.intance.getTileByIos(tile.x+len_x-1,tile.y+len_y-1);
					if(tile1){
						moveToTile(tile);
						currentTile = tile;
					}
				}
			}
			
			touches = e.getTouches(currentEntity,TouchPhase.ENDED);
			if(touches.length >= 1){
				var valiable:Boolean = checkValiable(currentTile);
				if(valiable){
					putDown();
				}
			}
		}
		
		private function moveToTile(tile:Tile):void
		{
			var valiable:Boolean = checkValiable(tile);
			if(valiable){
				movableMc.currentFrame = 0;
			}else{
				movableMc.currentFrame = 1;
			}
			trace("tile+ "+tile.x + "y: "+tile.y);
			var topPoint:Point = Map.intance.iosToScene(tile.x +len_x,tile.y+len_y);
			x = topPoint.x;
			y = topPoint.y;
		}
		
		private function creatTileSkin(topTile:Tile):Array
		{
			var index_x:int;
			var index_y:int;
			var tile:Tile;
			var tilesArr:Array=[];
			var mc:MovieClip ;
			while(index_x<len_x){
				//				index_y = 0;
				//				while(index_y < len_y){
				//					mc = new MovieClip(Game.assets.getTextures("movableSkin"));
				//					mc.width  = Configrations.Tile_Width+8;
				//					mc.height = Configrations.Tile_Height+4;
				//					mcSp.addChild(mc);
				//					mc.x = (index_y-index_x)/2*Configrations.Tile_Width - mc.width/2;
				//					mc.y = (index_x+index_y)/2*Configrations.Tile_Height;
				//					index_y++;
				//				}
				//				index_x++;
							}
			return tilesArr;
		}
		private function checkValiable(toptile:Tile):Boolean
		{
			var index_x:int = toptile.x;
			var index_y:int;
			var tile:Tile;
			while(index_x<(toptile.x + len_x)){
				index_y = toptile.y;
				while(index_y <(toptile.y+len_y)){
					tile = Map.intance.getTileByIos(index_x,index_y);
					if(tile && (!tile.owner ||tile.owner == currentEntity)){
						
					}else{
						return false;
					}
					index_y++;
				}
				index_x++;
			}
			return true;
		}
		private function putDown():void
		{
			scene.putDownEntity(currentEntity);
			currentEntity.moveToIso(currentTile);
			destroy();
		}
		public function cancel():void
		{
			currentEntity.moveToIso(currentEntity.getTopTile());
			destroy();
		}
		private function destroy():void
		{
			currentEntity.removeEventListener(TouchEvent.TOUCH,onTouch);
			if(movableMc && movableMc.parent){
				movableMc.parent.removeChild(movableMc);
			}
			if(parent){
				parent.removeChild(this);
			}
		}
		private function get scene():FarmScene
		{
			return GameController.instance.currentFarm;
		}
	}
}