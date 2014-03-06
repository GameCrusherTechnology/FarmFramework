package model.entity
{
	import flash.geom.Point;
	
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
			
			if(itemType&&item_id && item_id !="0"  && item_id!=""){
				itemspec = SpecController.instance.getItemSpec(item_id);
			}
		}
		public var type:int;
		public var gameuid:String;
		public var itemspec:ItemSpec ;
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
		public function get cname():String
		{
			return itemspec.cname;
		}
		public function get itemType():String
		{
			return "Entity";
		}
		public function get bound_x():int
		{
			return itemspec.bound_x;
		}
		
		public function get bound_y():int
		{
			return itemspec.bound_y;
		}
		
		public function get topPos():Point
		{
			return Map.intance.iosToScene(positionx +bound_x,positiony+bound_y);
		}
		public function get sceneIndex():Number
		{
			return (positionx+bound_x/2+positiony+bound_y/2)* 1000 + positionx+bound_x/2;
		}
		public function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		
		public function get ishouse():Boolean
		{
			return itemspec && itemspec.type == "house";
		}
		
		public function get isWild():Boolean
		{
			return itemspec && itemspec.type =="wild";
		}
		public function get serchingCost():Object
		{
			if(itemspec.gemPrice>0){
				return {type:"gem",price:itemspec.gemPrice};
			}else{
				return {type:"coin",price:itemspec.coinPrice};
			}
		}
	}
}