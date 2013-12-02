package service.command.task
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class FinishTaskCommand extends AbstractCommand
	{
		public function FinishTaskCommand(callBack:Function)
		{
			onSuccess =callBack;
			super(Command.FINISH_TASK,onResult);
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
			}else{
				
			}
		}
	}
}

