package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class ExtendFarmCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function ExtendFarmCommand(method:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.EXTENDFARM,onResult,{method:method});
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
			}else{
				
			}
		}
	}
}


