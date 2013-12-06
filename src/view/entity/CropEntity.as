package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.UiController;
	import controller.UpdateController;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.OwnedItem;
	import model.UpdateData;
	import model.avatar.Tile;
	import model.entity.CropItem;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import view.effect.RainEffect;

	public class CropEntity extends GameEntity
	{
		public var fieldSUR:Image;
		public function CropEntity(cropItem:CropItem)
		{
			fieldSUR = new Image(Game.assets.getTexture("FieldLand"));
			fieldSUR.x = - fieldSUR.width/2;
			fieldSUR.y = - fieldSUR.height;
			
			super(cropItem);
			
			if(cropItem.hasCrop){
				creatSurface();
			}
		}
		
		private function creatSurface():void
		{
			surface = new MovieClip(Game.assets.getTextures(cropItem.name));
			addChild(surface);
			surface.currentFrame = cropItem.growStep;
			surface.x = - surface.width/2;
			surface.y = - surface.height;
		}
		override protected function dragmoveToTile(tile:Tile):void
		{
			super.dragmoveToTile(tile);
			fieldSUR.x = x - fieldSUR.width/2;
			fieldSUR.y = y - fieldSUR.height;
		}
		override protected function configPosition():void
		{
			super.configPosition();
			fieldSUR.x = x - fieldSUR.width/2;
			fieldSUR.y = y - fieldSUR.height;

		}
		override protected function refresh():void
		{
			if(cropItem.hasCrop){
				if(!surface){
					creatSurface();
				}
				surface.currentFrame = cropItem.growStep;
				surface.x = - surface.width/2;
				surface.y = - surface.height;
			}else{
				if(surface && surface.parent){
					surface.parent.removeChild(surface);
					surface = null;
				}
			}
		}
		override public function doTouchEvent(type:String):void
		{
			switch(type){
				case TouchPhase.BEGAN:
					checkCurrentTool();
					break;
				case TouchPhase.MOVED:
					onToolMoved();
					break;
				case TouchPhase.HOVER:
					onToolMoved();
					break;
				case TouchPhase.ENDED:
					hasSpeed = false;
					break;
			}
			
		}
		private var hasSpeed:Boolean;
		private function checkCurrentTool():void
		{
			var tool:String = GameController.instance.selectTool;
			if(GameController.instance.isHomeModel){
				if(tool == UiController.TOOL_SELL){
					sellCrop();
				}else if(tool == UiController.TOOL_MOVE){
					scene.addMoveEntity(this);
				}else{
					if(cropItem.hasCrop){
						if(cropItem.canHarvest){
							if(tool !=UiController.TOOL_HARVEST){
								//show harvest
								UiController.instance.showUiTools(UiController.TOOL_HARVEST,this);
							}else{
								harvest();
							}
						}else if(tool !=UiController.TOOL_SPEED){
							//show time
							
							var remainTime:Number = cropItem.remainTime;
							UiController.instance.showUiTools(UiController.TOOL_SPEED,this);
						}else{
							speedCrop();
						}
					}else if(tool !=UiController.TOOL_SEED){
						// show plant
						UiController.instance.showUiTools(UiController.TOOL_SEED,this);
					}else{
						plant();
					}
				}
			}else{
				
			}
		}
		
		private function onToolHoved():void
		{
			var tool:String = GameController.instance.selectTool;
			switch(tool){
				case UiController.TOOL_HARVEST:
					if(cropItem.hasCrop && cropItem.canHarvest){
						harvest();
					}
					break;
			}
		}
		private function onToolMoved():void
		{
			var tool:String = GameController.instance.selectTool;
			switch(tool){
				case UiController.TOOL_HARVEST:
					if(cropItem.hasCrop && cropItem.canHarvest){
						harvest();
					}
					break;
				case UiController.TOOL_SPEED:
					if(cropItem.canSpeed){
						speedCrop();
					}
					break;
				case UiController.TOOL_SEED:
					if(!cropItem.hasCrop){
						plant();
					}
					break;
			}
		}
		
		private function plant():void
		{
			if(GameController.instance.selectSeed){
				if(player.hasItem(GameController.instance.selectSeed)){
					UpdateController.instance.pushActionData(new UpdateData(cropItem.gameuid,Configrations.PLANT,{data_id:cropItem.data_id,gameuid:cropItem.gameuid,item_id:GameController.instance.selectSeed,plant_time:SystemDate.systemTimeS}));
					cropItem.plant(GameController.instance.selectSeed);
				}else{
					GameController.instance.resetTools();
				}
			}
		}
		
		private function speedCrop():void
		{
			if(!hasSpeed){
				if(player.hasItem(Configrations.SPEED_ITEMID))
				{
					UpdateController.instance.pushActionData(new UpdateData(cropItem.gameuid,Configrations.SPEED,{data_id:cropItem.data_id,gameuid:cropItem.gameuid}));
					player.deleteItem(new OwnedItem(Configrations.SPEED_ITEMID,1));
					cropItem.speed();
					showSpeedAnimation();
				}else{
					GameController.instance.resetTools();
				}
				hasSpeed = true;
			}
		}
		private function harvest():void
		{
			UpdateController.instance.pushActionData(new UpdateData(cropItem.gameuid,Configrations.HARVEST,{data_id:cropItem.data_id,gameuid:cropItem.gameuid}));
			player.addExp(cropItem.exp);
			GameController.instance.localPlayer.addItem(new OwnedItem(Configrations.getAchieveId(cropItem.item_id,"harvestCrop"),1));
			showHarvestAnimation(Game.assets.getTexture(cropItem.name +"Icon"));
			cropItem.harvest();
			refresh();
		}
		private function sellCrop():void
		{
			UpdateController.instance.pushActionData(new UpdateData(cropItem.gameuid,Configrations.SELL,{data_id:cropItem.data_id,gameuid:cropItem.gameuid}));
			destroy();
		}
		private function showHarvestAnimation(texture:Texture):void
		{
			var index:int = 0;
			var stagePoint:Point ;
			while(index <10){
				stagePoint = scene.localToGlobal(new Point(x + Math.random()*50-25,y + Math.random()*50-25));
				stageEffectLayer.addTweenCrop(texture,stagePoint,0.1*index);
				
				index++;
			}
			stageEffectLayer.showExpAddEffect(cropItem.exp,stagePoint);
			UiController.instance.showToolStateEffect();
		}
		private function showSpeedAnimation():void
		{
			var rainEffect:RainEffect = new RainEffect();
			sceneEffectLayer.addChild(rainEffect);
			rainEffect.x = x;
			rainEffect.y = y;
			
		}
		
		private function get cropItem():CropItem
		{
			return item as CropItem;
		}
		
		
		
	}
}