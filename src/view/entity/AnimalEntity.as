package view.entity
{
	import controller.AnimalController;
	
	import model.entity.AnimalItem;
	
	import starling.core.Starling;

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
			Starling.juggler.add(surface);
		}
		
		override public function dispose():void
		{
			AnimalController.instance.removeAnimal(this);
			super.dispose();
		}
	}
}