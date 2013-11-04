package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.UiController;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.CropItem;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

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
		}
		
		private function sellCrop():void
		{
			destroy();
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
			cropItem.plant();
		}
		
		private function speedCrop():void
		{
			if(!hasSpeed){
				cropItem.speed();
				hasSpeed = true;
			}
		}
		private function harvest():void
		{
			showHarvestAnimation(Game.assets.getTexture(cropItem.name +"Icon"));
			cropItem.harvest();
			refresh();
			
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
			stageEffectLayer.showExpAddEffect(20,stagePoint);
			UiController.instance.showToolStateEffect();
		}
		
		private function get cropItem():CropItem
		{
			return item as CropItem;
		}
		
		
		
	}
}