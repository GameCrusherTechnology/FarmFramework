package model.gameSpec
{
	public class FormulaItemSpec extends ItemSpec
	{
		public function FormulaItemSpec(data:Object)
		{
			super(data);
		}
		
		
		public var material:String;
		
		//一个产物
		public var product:String;
		
		public var workTime:Number = 120;
		
	}
}