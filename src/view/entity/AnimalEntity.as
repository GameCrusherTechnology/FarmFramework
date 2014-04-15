package view.entity
{
	import model.entity.AnimalItem;

	public class AnimalEntity extends GameEntity
	{
		protected function get speed():int{
			return  50;
		}
		protected function get scale():Number{
			return  0.5;
		}
		public function AnimalEntity(item:AnimalItem)
		{
			super(item);
		}
		
		public function play():void
		{
			//do 
		}
		
		public function endPlaying():void
		{
			
		}
		
	}
}