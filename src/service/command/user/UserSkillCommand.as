package service.command.user
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UserSkillCommand extends AbstractCommand
	{
		public function UserSkillCommand(speedArr:Array,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.UserSkill,onResult,{speed:speedArr});
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
