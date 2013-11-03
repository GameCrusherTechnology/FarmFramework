package model.gameSpec
{
	public class CropSpec extends ItemSpec
	{
		public function CropSpec(data:Object)
		{
			super(data);
		}
		
		public var growTimeArr:Array;
		public var totleGrowTime:Number = 0;
		
		public function set growtime(str:String):void
		{
			growTimeArr = str.split(":");
			var index:int=0;
			while(index < growTimeArr.length){
				totleGrowTime += (growTimeArr[index]*60);
				index ++;
			}
		}
		
	}
}