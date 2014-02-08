package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class BuySkillCDCommand extends AbstractCommand
	{
		public function BuySkillCDCommand(gem:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.BuySkillCD,onResult,{gem:gem});
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


