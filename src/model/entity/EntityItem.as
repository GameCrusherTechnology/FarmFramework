package model.entity
{
	import controller.GameController;
	import controller.SpecController;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import starling.events.EventDispatcher;

	public class EntityItem extends EventDispatcher
	{
		public function EntityItem(data:Object)
		{
			var str:String;
			for(str in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in Item: EntityItem["+str+"]="+data[str]);
				}
			}
			
			if(itemType && item_id>0 && item_id!=""){
				itemspec = SpecController.instance.getItemSpec(item_id);
			}
		}
		
		public var gameuid:String;
		protected var itemspec:ItemSpec ;
		public var data_id:Number;
		public var item_id:String;
		public var status:int;
		public var positionx:int;
		public var positiony:int;
		
		public function get tile():Tile
		{
			return Map.intance.getTileByIos(positionx,positiony);
		}
		public function update():Boolean
		{
			return false;
		}
		public function get name():String
		{
			return itemspec.name;
		}
		public function get itemType():String
		{
			return null;
		}
		public function get bound_x():int
		{
			return itemspec.bound_x;
		}
		
		public function get bound_y():int
		{
			return itemspec.bound_y;
		}
		
		public function get sceneIndex():Number
		{
			return (positionx+positiony)* 1000 + positionx;
		}
		public function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}