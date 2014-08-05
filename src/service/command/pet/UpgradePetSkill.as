package service.command.pet
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UpgradePetSkill extends AbstractCommand
	{
		public function UpgradePetSkill(item_id:String,skill_id:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.UPGRADEPETSKILL,onResult,{item_id:item_id,skill_id:skill_id});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess(result.skill);
			}else{
				
			}
		}
	}
}



