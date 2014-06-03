package view.render
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	import view.entity.AnimalEntity;
	
	public class RanchAnimalRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var animalEntity:AnimalEntity;
		public function RanchAnimalRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value is AnimalEntity){
				animalEntity = value as AnimalEntity;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				configLayout();
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20, 20, 20, 20));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var _motion:String = "Stand";
			if(animalEntity.animalItem.canHarvest){
				_motion = "Produce";
			}else{
				_motion = "Stand";
			}
			var mc:MovieClip =  new MovieClip(Game.assets.getTextures(animalEntity.animalItem.name+"/"+animalEntity.animalItem.name+_motion));
			container.addChild(mc);
			mc.x = width/2- mc.width/2;
			mc.y = height/2 - mc.height;
			Starling.juggler.add(mc);
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
	}
}


