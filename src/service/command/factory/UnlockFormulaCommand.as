package service.command.factory
{
	import controller.GameController;
	
	import model.gameSpec.ItemSpec;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UnlockFormulaCommand extends AbstractCommand
	{
		public function UnlockFormulaCommand(itemspec:ItemSpec,method:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.UNLOCK_FORMULA,onResult,{id:itemspec.item_id,method:method});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.formula){
					GameController.instance.localPlayer.user_factory = result.formula;
				}
				onSuccess();
			}else{
				
			}
		}
	}
}

