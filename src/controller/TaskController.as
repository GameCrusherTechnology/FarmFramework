package controller
{
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.gameSpec.CropSpec;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	import model.task.TaskData;
	
	import service.command.task.CreatTaskCommand;
	import service.command.task.FinishOrder;

	public class TaskController
	{
		private static var control:TaskController;
		public static function get instance():TaskController
		{
			if(!control){
				control = new TaskController();
			}
			return control;
		}
		
		public function TaskController()
		{
			
		}
		
		public function initTask():void
		{
			if(!needToCreat()){
				UiController.instance.showTaskButton();
			}else{
				new CreatTaskCommand(creatNpcTask(),onCreat);
			}
			
//			var timer:Timer = new Timer(50);
//			timer.addEventListener(TimerEvent.TIMER,onTick,false,0,true);
		}
		
		
		private function needToCreat():Boolean
		{
			
			if((SystemDate.systemTimeS - localPlayer.npc_time )>= Configrations.ORDER_CD)
			{
				if(localPlayer.npc_order && !localPlayer.npc_order.getIsExpired()){
					return false;
				}else{
					return true;
				}
			}else{
				return false;
			}
			
		}
		
		public function getTaskPanelShow():Boolean
		{
			if(localPlayer.npc_order){
				if(localPlayer.npc_order.getIsExpired()){
					return false;
				}else{
					return true;
				}
			}else{
				return false;
			}
		}
		
		private function onCreat():void
		{
			if(GameController.instance.isHomeModel){
				UiController.instance.showTaskButton();
			}
		}
		
		public function creatNpcTask(npc:int = 0):TaskData
		{
			var taskdata:TaskData = new TaskData;
			
			var vec:Vector.<OwnedItem> = new Vector.<OwnedItem>;
			var owned:Vector.<OwnedItem> = localPlayer.ownedItemVec;
			var cropSpecArr:Object = SpecController.instance.getGroup("Crop");
			var spec:CropSpec ;
			var level:int = Configrations.expToGrade(localPlayer.exp);
			for each(spec in cropSpecArr){
				if(spec.level<=level){
					vec.push(localPlayer.getOwnedItem(spec.item_id));
				}
			}
			var length:int = Math.min(3,vec.length);
			var requestVec:Array = [];
			var index:int;
			var item:OwnedItem;
			var str:String;
			var count:int;
			while(length>0){
				index = Math.floor(Math.random()*vec.length);
				item = vec[index];
				count = getQuestCount(item);
				str = item.itemid+":"+Math.max(20,Math.floor(count))
				requestVec.push(str);
				vec.splice(index,1);
				length--;
			}
			taskdata.requstStr = requestVec.join("|");
			if(npc!=0){
				taskdata.npc = npc;
			}else{
				taskdata.npc = Math.random() >0.5?Configrations.NPC_MALE:Configrations.NPC_FEMALE;
			}
			return taskdata;
		}
		
		private function getQuestCount(item:OwnedItem):int{
			var questCount:int;
			var spec:ItemSpec = SpecController.instance.getItemSpec(item.itemid);
			if(spec is CropSpec){ 
				var totalTime :int = Configrations.ORDER_EXPIRED;
				var m:int = Math.max(1,Math.min(Math.random()*6,totalTime/(spec as CropSpec).totleGrowTime));
				questCount = Math.floor(m*localPlayer.cropItems.length);
			}
			return questCount;
		}
		
		public function checkCurrentOrder(player:GamePlayer):void
		{
			if(player.my_order && player.my_order.getIsExpired()){
				new FinishOrder(player.gameuid,onFinishedOrder,1);
			} 
		}
		private function onFinishedOrder():void
		{
			var player:GamePlayer = GameController.instance.currentPlayer;
			var orderdata:TaskData = player.my_order;
			if(GameController.instance.isHomeModel){
				var reqestArr:Array = orderdata.requstStr.split("|");
				var itemStr:String;
				for each(itemStr in reqestArr){
					var itemArr :Array = itemStr.split(":");
					player.addItem(new OwnedItem(itemArr[0],itemArr[1]));
				}
			}
			
			player.my_order = null;
		}
		public function getTaskPrice():int
		{
			return Math.pow(2,localPlayer.buy_task_count);
		}
		
		private function get localPlayer():GamePlayer
		{
			return GameController.instance.localPlayer;
		}
		
	}
}