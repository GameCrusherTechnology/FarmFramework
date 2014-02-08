package view.entity.animal
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import controller.AnimalController;
	
	import gameconfig.Configrations;
	
	import model.entity.AnimalItem;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	
	import view.entity.AnimalEntity;
	import view.entity.CropEntity;

	public class BeaEntity extends AnimalEntity
	{
		public function BeaEntity(crop:CropEntity)
		{
			currentCrop = crop;
			var item:AnimalItem = new AnimalItem({item_id:"60001"});
			super(item);
			surface.scaleX = surface.scaleY = scale;
			findAction();
		}
		
		override protected function configPosition():void
		{
			var tarPoint:Point = currentCrop.cropItem.topPos;
			x = tarPoint.x + (0.5-Math.random())*Configrations.Tile_Width;
			y = tarPoint.y - 2*Configrations.Tile_Height + (1-Math.random()*2)*Configrations.Tile_Height;

		}
		
		
		private var currentCrop:CropEntity;
		private var step:int;
		private function findAction():void
		{
			if(step >= 3){
				dispose();
			}else{
				currentCrop = AnimalController.instance.getBeaCrop();
				if(currentCrop){
					var tarPoint:Point = currentCrop.cropItem.topPos;
					if(currentCrop.cropItem.isTree){
						movePos(tarPoint.x + (0.5-Math.random())*Configrations.Tile_Width,tarPoint.y - currentCrop.surface.height + Configrations.Tile_Height + (1-Math.random()*2)*Configrations.Tile_Height);
					}else{
						movePos(tarPoint.x + (0.5-Math.random())*Configrations.Tile_Width,tarPoint.y - Configrations.Tile_Height + (0.5-Math.random())*Configrations.Tile_Height);
					}
				}else{
					dispose();
				}
				step++;
			}
		}
		private var tween:Tween;
		override public function get sceneIndex():Number
		{
			return currentCrop.sceneIndex + 10;
		}
		private function movePos(posX:Number,posY:Number):void
		{
			Starling.juggler.remove(tween);
			
			if(posX< x){
				surface.scaleX = -scale;
				surface.x = surface.width/2;
			}else{
				surface.scaleX = scale;
				surface.x = -surface.width/2;
			}
			var time:Number = Math.sqrt(Math.pow(posX - x,2)+Math.pow(posY-y,2))/speed;
			tween = new Tween(this,time);
			tween.moveTo(posX,posY);
			tween.onComplete = function():void{
				setTimeout(findAction,3000);
			};
			Starling.juggler.add(tween);
		}
		override protected function get scale():Number{
			return  0.3;
		}
		override public function dispose():void
		{
			Starling.juggler.remove(tween);
			super.dispose();
		}
	}
}