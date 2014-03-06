package service.command.scene
{
	import controller.GameController;
	
	import model.avatar.Tile;
	import model.entity.EntityItem;
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.FarmScene;
	
	public class CreatWeed extends AbstractCommand
	{
		public function CreatWeed(tile:Tile,dataid:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CREATWEED,onResult,{x:tile.x,y:tile.y,data_id:dataid});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
				var data:Object = result.weed;
				if(data){
					var player:GamePlayer = GameController.instance.localPlayer;
					data['gameuid'] = player.gameuid;
					var item:EntityItem = new EntityItem(data);
					player.addDecoration(item);
					var scene:FarmScene = GameController.instance.currentFarm;
					scene.addEntity(item);
				}
			}else{
				
			}
		}
	}
}



