package service.command.factory
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class AddFormulaCommand extends AbstractCommand
	{
		public function AddFormulaCommand(_id:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.ADD_FORMULA,onResult,{id:_id});
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


