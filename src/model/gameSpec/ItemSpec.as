package model.gameSpec
{
	public class ItemSpec
	{
		public function ItemSpec(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in ItemSpec: ItemSpec["+str+"]="+data[str]);
				}
			}
			
		}
		public var group_id:String;
		public var item_id:String;
		public var name:String;
		public var bound_x:int;
		public var bound_y:int;
		public var level:int = 0;
		
		public var coinPrice:int;
		public var gemPrice:int;
	}
}