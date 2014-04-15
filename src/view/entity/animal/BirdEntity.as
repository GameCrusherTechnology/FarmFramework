package view.entity.animal
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import controller.AnimalController;
	
	import model.avatar.Map;
	import model.avatar.Tile;
	import model.entity.AnimalItem;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.utils.deg2rad;
	
	import view.entity.AnimalEntity;
	
	public class BirdEntity extends AnimalEntity
	{
		override protected function get speed():int{
			return  200;
		}
		override protected function get scale():Number{
			return  0.5;
		}
		public function BirdEntity()
		{
			var item:AnimalItem = new AnimalItem({item_id:"60002"});
			super(item);
		}
		
		private var tile:Tile;
		private var isLeft:Boolean ;
		override protected function configPosition():void
		{
			tile = Map.intance.getRandom();
			var pos:Point = Map.intance.iosToScene(tile.x,tile.y);
			var inP:Point = new Point(isLeft?-100:(scene.width+100),Math.random()*100);
			x = inP.x;
			y = inP.y;
		}
		override protected function creatSurface():void
		{
			setFlySurface(true);
			this.rotation = deg2rad(isLeft?45:-45);
		}
		
		override public function play():void
		{
			if(!parent){
				isLeft = Math.random()>0.5;
				this.rotation = deg2rad(isLeft?45:-45);
				surface.scaleX = surface.scaleY = scale;
				if(isLeft){
					surface.scaleX = -scale;
					surface.x = surface.width/2;
				}
				configPosition();
				Starling.juggler.add(surface);
				scene.addAnimalEntity(this);
				flyIn();
				
			}
		}
		
		private function findAction():void
		{
			setFlySurface(false);
			this.rotation = deg2rad(0);
			setTimeout(flyAway,10000);
		}
		
		private var tween:Tween;
		override public function get sceneIndex():Number
		{
			return (tile.x+1/2+tile.y+1/2)* 1000 + tile.x+1/2;
		}
		
		private function setFlySurface(isFly:Boolean):void
		{
			Starling.juggler.remove(surface);
			removeChild(surface);
			
			var name:String = isFly?"BirdFly":"BirdAnimal";
			surface = new MovieClip(Game.assets.getTextures(name));
			addChild(surface);
			surface.y = - surface.height;
			Starling.juggler.add(surface);
			surface.scaleY = scale;
			if(!isLeft){
				surface.scaleX = scale;
				surface.x = -surface.width/2;
			}else{
				surface.scaleX = -scale;
				surface.x = surface.width/2;
			}
			
		}
		private function flyIn():void
		{
			Starling.juggler.remove(tween);
			
			setFlySurface(true);
			
			var pos:Point = Map.intance.iosToScene(tile.x,tile.y);
			var time:Number = Math.sqrt(Math.pow(pos.x - x,2)+Math.pow(pos.y-y,2))/speed;
			tween = new Tween(this,time);
			tween.moveTo(pos.x,pos.y);
			tween.onComplete = function():void{
				findAction();
			};
			Starling.juggler.add(tween);
		}
		private function flyAway():void
		{
			Starling.juggler.remove(tween);
			setFlySurface(true);
			
			var awayP:Point = new Point(isLeft?(scene.width+100):-100,Math.random()*100);
			var time:Number = Math.sqrt(Math.pow(awayP.x - x,2)+Math.pow(awayP.y-y,2))/speed;
			tween = new Tween(this,time);
			tween.moveTo(awayP.x,awayP.y);
			tween.onComplete = function():void{
				endPlaying();
			};
			Starling.juggler.add(tween);
		}
		
		override public function endPlaying():void
		{
			Starling.juggler.remove(tween);
			Starling.juggler.remove(surface);
			scene.removeEntity(this);
		}
	}
}

