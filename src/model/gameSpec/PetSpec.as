package model.gameSpec
{
	public class PetSpec extends ItemSpec
	{
		public function PetSpec(data:Object)
		{
			super(data);
		}
		
		public var skills:String;
		public var petCost:int;
		public var randomActions:String;
		public var moveSpeed:Number = 50;
	}
}