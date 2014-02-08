package model
{
	public class SkillData
	{
		public function SkillData(skillMes:String ="2|5")
		{
			var arr:Array = skillMes.split("|");
			speedCount = arr[0];
			speedTime = arr[1];
		}
		
		public var speedCount:int = 2;
		public var speedTime:int = 5;
		
		public function get skillLevel():int
		{
			return speedCount +speedTime  -7;
		}
	}
}