package service.command.task
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class FinishOrder extends AbstractCommand
	{
		public function FinishOrder(targetId:String,callBack:Function,isNpc:int=0)
		{
			onSuccess =callBack;
			super(Command.FINISH_MYORDER,onResult,{isNpc:isNpc,f_gameuid:targetId});
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

