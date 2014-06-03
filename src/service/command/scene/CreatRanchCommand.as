package service.command.scene
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class CreatRanchCommand extends AbstractCommand
	{
		public function CreatRanchCommand(ranch:Object,animal:Object,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CREATRANCH,onResult,{ranch:ranch,animal:animal});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				
				if(result.change){
					var player:GamePlayer = GameController.instance.localPlayer;
					if(result.change.type == 'gem'){
						player.changeGem(result.change.number);
					}else if(result.change.type == 'coin'){
						player.addCoin(result.change.number);
					}
				}
				onSuccess();
			}else{
				
			}
		}
	}
}



