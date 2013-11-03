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
		public var id:int;
		public var name:String;
		public var bound_x:int;
		public var bound_y:int;
	}
}