package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UpdateMessagesCommand extends AbstractCommand
	{
		public function UpdateMessagesCommand(addMesArr:Array,delMesArr:Array,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.LEAVEMESSAGE,onResult,{addMes:addMesArr,delMes:delMesArr});
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


