package service.command.pet
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class CreatPetCommand extends AbstractCommand
	{
		public function CreatPetCommand(item_id:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CREATPET,onResult,{item_id:item_id});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess(result.pet);
			}else{
				
			}
		}
	}
}



