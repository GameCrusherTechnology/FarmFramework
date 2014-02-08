package model.entity
{
	import gameconfig.LanguageController;

	public class AnimalItem extends EntityItem
	{
		public function AnimalItem(data:Object)
		{
			super(data);
		}
		
		override public function get cname():String
		{
			return itemspec? itemspec.cname : LanguageController.getInstance().getString("field");
		}
		
		override public function get itemType():String
		{
			return "Animal";
		}
		override public function get bound_x():int
		{
			return 0;
		}
		
		override public function get bound_y():int
		{
			return 0;
		}
		
	}
}


