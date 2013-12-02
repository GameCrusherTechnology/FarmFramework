package model.task
{
	import gameconfig.Configrations;
	import gameconfig.SystemDate;

	public class TaskData
	{
		public function TaskData(dataStr:String = null)
		{
			if(dataStr){
				var arr:Array = dataStr.split(";");
				npc = arr[0];
				requstStr = arr[1];
				rewards = arr[2];
				creatTime = arr[3];
			}
		}
		
		public var npc:int = Configrations.NPC_MALE;
		public var requstStr:String;
		public var rewards:String;
		public var creatTime:Number;
		
		public function getIsExpired():Boolean
		{
			return (creatTime+Configrations.ORDER_EXPIRED)<SystemDate.systemTimeS;
		}
	}
}