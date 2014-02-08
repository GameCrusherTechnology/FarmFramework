package service.command.user
{
	import controller.GameController;
	
	import model.SkillData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UpgradeSkillCommand extends AbstractCommand
	{
		public function UpgradeSkillCommand(callBack:Function)
		{
			onSuccess =callBack;
			super(Command.UpgradeSkill,onResult);
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				GameController.instance.localPlayer.skillData = new SkillData(result.skill);
				onSuccess();
			}else{
				
			}
		}
	}
}


