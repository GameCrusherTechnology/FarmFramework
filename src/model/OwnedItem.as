package model
{
	public class OwnedItem
	{
		public function OwnedItem(_itemid:String,_count:int)
		{
			itemid = _itemid;
			count = _count;
		}
		public var itemid:String;
		public var count:int;
	}
}