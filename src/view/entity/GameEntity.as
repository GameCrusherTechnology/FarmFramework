package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.EntityItem;
	
	import starling.core.RenderSupport;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
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
		
		public function getTopTile():Tile
		{
			return Map.intance.getTileByIos(item.ios_x,item.ios_y);
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
		protected function update():void
		{
			if(item.update()){
				refresh();
			}
		}
			
	}
}