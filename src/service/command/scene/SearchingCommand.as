package service.command.scene
{
	import controller.DialogController;
	import controller.GameController;
	
	import model.OwnedItem;
	import model.entity.EntityItem;
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.FarmScene;
	import view.entity.GameEntity;
	import view.panel.RewardPanel;

	public class SearchingCommand extends AbstractCommand
	{
		private var curEntity:GameEntity;
		public function SearchingCommand(entity:GameEntity,callBack:Function)
		{
			curEntity = entity;
			onSuccess =callBack;
			super(Command.SEARCHING,onResult,{data_id:entity.item.data_id});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				var player:GamePlayer = GameController.instance.localPlayer;
				var cost:Object = result.cost;
				if(cost.id == "gem"){
					player.changeGem(cost.count);
				}else{
					player.addCoin(cost.count);
				}
				onSuccess();
				var reward:Object = result.reward;
				if(result.hasDeco){
					var item:EntityItem = new EntityItem({data_id:curEntity.item.data_id,item_id:reward.id,positionx:curEntity.item.positionx,positiony:curEntity.item.positiony});
					player.addDecoration(item);
					var scene:FarmScene = GameController.instance.currentFarm;
					scene.addEntity(item);
				}else{
					if(reward.id == "coin"){
						player.addCoin(reward.count);
					}else if(reward.id == "exp"){
						player.addExp(reward.count);
					}else {
						player.addItem(new OwnedItem(reward.id,reward.count));
					}
				}
				DialogController.instance.showPanel(new RewardPanel(reward.id,reward.count));
				
			}else{
				
			}
		}
	}
}