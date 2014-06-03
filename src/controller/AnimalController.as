package controller
{
	import model.player.GamePlayer;
	
	import view.FarmScene;
	import view.entity.CropEntity;
	import view.entity.GameEntity;
	import view.entity.WildEntity;
	import view.entity.animal.BeaEntity;
	import view.entity.animal.BirdEntity;

	public class AnimalController
	{
		private var beaRate:Number = 0.2;
		private var birdRate:Number = 0.01;
		private var lastAddTime:int = 500;
		private static var _controller:AnimalController;
		private var beaVec:Vector.<BeaEntity>;
		private var birdVec:Vector.<BirdEntity>;
		public static function get instance():AnimalController
		{
			if(!_controller){
				_controller = new AnimalController();
			}
			return _controller;
		}
		public function AnimalController()
		{
			
		}
		public function reset():void
		{
			initAnimals();
		}
		
		private function initAnimals():void
		{
			beaVec = new Vector.<BeaEntity>;
			birdVec = new Vector.<BirdEntity>;
			var max:int = Math.min(Math.round(player.cropItems.length /2),10);
			var crop :CropEntity;
			var bea:BeaEntity;
			var bird:BirdEntity;
			while(max >=1){
				crop = getBeaCrop();
				if(crop){
					bea = new BeaEntity(crop);
					beaVec.push(bea);
				}
				max --;
			}
			
			max = Math.min(player.level,8);
			while(max >=1){
				bird = new BirdEntity();
				birdVec.push(bird);
				max --;
			}
		}
		
		public function tick():void
		{
			if(lastAddTime < 0){
				var animal:WildEntity;
				if(Math.random() >0.4 && beaVec && (beaVec.length >0)){
					animal = beaVec[int(Math.random() * beaVec.length)];
				}else if(birdVec && (birdVec.length >0)){
					animal = birdVec[int(Math.random() * birdVec.length)];
				}
				if(animal){
					animal.play();
				}
				lastAddTime = 500 ;
			}
			lastAddTime --;
		}
		
		
		public function getBeaCrop():CropEntity
		{
			var crop:CropEntity;
			var entity:GameEntity;
			var cropsArr:Array = [];
			for each(entity in scene.entityDic){
				if(entity is CropEntity && (entity as CropEntity).cropItem.growStep > 2){
					cropsArr.push(entity);
				}
			}
			if(cropsArr.length >=1){
				var ran:int = Math.floor(cropsArr.length*Math.random());
				crop = cropsArr[ran];
			}
			
			return crop;
		}
		
		
		private function get scene():FarmScene
		{
			return GameController.instance.currentFarm;
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		
	}
}