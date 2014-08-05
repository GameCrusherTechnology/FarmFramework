package view.render
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class PetTabRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var spec:ItemSpec;
		public function PetTabRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				spec = value as ItemSpec;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				configLayout();
			}
		}
		private var renderwidth:Number;
		private function configLayout():void
		{
			var l:Number = width;
			var image:Image = new Image(Game.assets.getTexture(spec.name+"Icon"));
			addChild(image);
			image.width = image.height = l*0.8;
			image.x = width/2 - image.width/2;
			image.y = height/2 - image.height/2;
			
		}
		
	}
}


