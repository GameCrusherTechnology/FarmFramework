package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.UiController;
	
	import game.utils.Configrations;
	
	import gameconfig.Configrations;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.CropItem;
	import model.entity.EntityItem;
	
	import starling.core.RenderSupport;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.FarmScene;
	import view.TweenEffectLayer;

	public class GameEntity extends Sprite
	{
		public var surface:MovieClip;
		protected var item:EntityItem;
		public function GameEntity(entityItem:EntityItem) 
		{
			item = entityItem;
			setTile();
			configPosition();
		}
		private function setTile():void
		{
			var i:int;
			var j:int;
			var tile:Tile;
			while(i < item.bound_x){
				j=0;
				while(j<item.bound_y){
					tile = Map.intance.getTileByIos(item.ios_x+i,item.ios_y+j);
					if(tile){
						tile.owner  = this;
					}
					j++;
				}
				i++;
			}
		}
		private var currentMoveTile:Tile ;
		private var movableMc:MovieClip;
		public function intoMoveMode():void
		{
			currentMoveTile = getTopTile();
			movableMc = new MovieClip(Game.assets.getTextures("movableSkin"));
			movableMc.width = (length_x+length_y)/2*Configrations.Tile_Width+5;
			movableMc.height = (length_x+length_y)/2*Configrations.Tile_Height+4;
			addChild(movableMc);
			movableMc.x = -movableMc.width/2;
			movableMc.y = -movableMc.height+2;
			
			dragmoveToTile(currentMoveTile);
		}
		protected function dragmoveToTile(tile:Tile):void
		{
			trace("tile" + tile.x);
			var topPoint:Point = Map.intance.iosToScene(tile.x +length_x,tile.y+length_y);
			x = topPoint.x;
			y = topPoint.y;
		}
		
		public function moveEntity(scenePos:Point):void
		{
			var tile:Tile = Map.intance.sceneToIso(scenePos);
			if(tile &&  tile != currentMoveTile){
				var tile1:Tile = Map.intance.getTileByIos(tile.x+length_x-1,tile.y+length_y-1);
				if(tile1){
					var valiable:Boolean = checkValiable(tile);
					if(valiable){
						movableMc.currentFrame = 0;
					}else{
						movableMc.currentFrame = 1;
					}
					dragmoveToTile(tile);
					currentMoveTile = tile;
				}
			}

		}
		public function releaseEntity():void
		{
			var valiable:Boolean = checkValiable(currentMoveTile);
			if(valiable){
				putDown();
			}
		}
		public function get sceneIndex():Number
		{
			return item.sceneIndex;
		}
		private function putDown():void
		{
			clearTile();
			moveToIso(currentMoveTile);
			scene.putDownEntity(this);
			setTile();
			destroyMoveMc();
		}
		protected function clearTile():void
		{
			var i:int;
			var j:int;
			var tile:Tile;
			while(i < item.bound_x){
				j=0;
				while(j<item.bound_y){
					tile = Map.intance.getTileByIos(item.ios_x+i,item.ios_y+j);
					if(tile){
						tile.owner  = null;
					}
					j++;
				}
				i++;
			}
		}
		public function cancel():void
		{
			moveToIso(getTopTile());
			destroyMoveMc();
		}
		private function destroyMoveMc():void
		{
			if(movableMc && movableMc.parent){
				movableMc.parent.removeChild(movableMc);
			}
		}
		
		private function checkValiable(toptile:Tile):Boolean
		{
			var index_x:int = toptile.x;
			var index_y:int;
			var tile:Tile;
			while(index_x<(toptile.x + length_x)){
				index_y = toptile.y;
				while(index_y <(toptile.y+length_y)){
					tile = Map.intance.getTileByIos(index_x,index_y);
					if(tile && (!tile.owner ||tile.owner == this)){
						
					}else{
						return false;
					}
					index_y++;
				}
				index_x++;
			}
			return true;
		}
		protected function configPosition():void
		{
			var topPoint:Point = Map.intance.iosToScene(item.ios_x +item.bound_x,item.ios_y+item.bound_y);
			x = topPoint.x;
			y = topPoint.y;
		}
		public function getTopTile():Tile
		{
			return Map.intance.getTileByIos(item.ios_x,item.ios_y);
		}
		public function get length_x():int
		{
			return item.bound_x;
		}
		public function get length_y():int
		{
			return item.bound_y;
		}
		
		public function moveToIso(tile:Tile):void
		{
			clearTile();
			item.ios_x = tile.x;
			item.ios_y = tile.y;
			configPosition();
			setTile();
		}
		protected function refresh():void
		{
			
		}
		public function doTouchEvent(type:String):void
		{
			trace("click")
			
		}
		override public function render(support:RenderSupport, parentAlpha:Number):void{
			super.render(support,parentAlpha);
			update()
		}
		protected function get sceneEffectLayer():Sprite
		{
			return GameController.instance.currentFarm.effectLayer;
		}
		
		protected function get stageEffectLayer():TweenEffectLayer
		{
			return GameController.instance.effectLayer;
		}
		protected function get scene():FarmScene
		{
			return GameController.instance.currentFarm;
		}
		protected function destroy():void
		{
			clearTile();
			scene.removeEntity(this);
		}
		protected function update():void
		{
			if(item.update()){
				refresh();
			}
		}
			
	}
}