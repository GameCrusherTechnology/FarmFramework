package service.command.pet
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class PetLookAfterCommand extends AbstractCommand
	{
		public function PetLookAfterCommand(item_id:String,animal:Number,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.PETLOOKAFTER,onResult,{item_id:item_id,animal_id:animal});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess(result.type);
			}else{
				
			}
		}
	}
}



