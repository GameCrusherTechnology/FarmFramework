package service.command.task
{
	import controller.GameController;
	
	import model.task.TaskData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class CreatTaskCommand extends AbstractCommand
	{
		public function CreatTaskCommand(task:TaskData,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CREAT_TASK,onResult,{npc:task.npc,request:task.requstStr,reward:task.rewards});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				GameController.instance.localPlayer.user_task = result.new_task;
				onSuccess();
			}else{
				
			}
		}
	}
}

