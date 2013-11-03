package model.entity
{
	import controller.SpecController;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.gameSpec.ItemSpec;
	
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
			
			if(itemType){
				itemspec = SpecController.instance.getItemSpec(item_id,itemType);
			}
		}
		protected var itemspec:ItemSpec ;
		public var data_id:Number;
		public var item_id:String;
		
		public var ios_x:int;
		public var ios_y:int;
		
		public function get tile():Tile
		{
			return Map.intance.getTileByIos(ios_x,ios_y);
		}
		public function update():Boolean
		{
			return false;
		}
		public function get name():String
		{
			return itemspec.name;
		}
		protected function get itemType():String
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
	}
}