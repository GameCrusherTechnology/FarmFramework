package service.command.task
{
	import controller.GameController;
	import controller.TaskController;
	
	import model.task.TaskData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class BuyTaskCommand extends AbstractCommand
	{
		public function BuyTaskCommand(task:TaskData,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.BUY_TASK,onResult,{npc:task.npc,request:task.requstStr});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.new_task){
					GameController.instance.localPlayer.changeGem(-TaskController.instance.getTaskPrice());
					GameController.instance.localPlayer.user_task = result.new_task;
				}
				onSuccess();
			}else{
				
			}
		}
	}
}

