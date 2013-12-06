package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	
	import starling.events.Event;
	
	import view.render.AchieveListRender;

	public class AchievePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var list:List;
		public function AchievePanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth*0.86;
			panelheight = Configrations.ViewPortHeight*0.7;
			var scale:Number = Configrations.ViewScale;

			const listLayout: VerticalLayout= new VerticalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.scrollPositionVerticalAlign  = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.paddingTop = 30*scale;
			listLayout.gap = 10*scale;
			
			
			list = new List();
			list.layout = listLayout;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			list.backgroundSkin = new Scale9Image(skintextures);
			list.dataProvider = menuArr;
			list.width =  panelwidth*0.8;
			list.height = panelheight *0.95;
			list.itemRendererFactory = 
				function tileListItemRendererFactory():AchieveListRender
			{
				const renderer:AchieveListRender = new AchieveListRender()
				renderer.width = panelwidth *0.7;
				renderer.height = Math.min(panelheight *0.2,100);
				return renderer;
			};
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.1;
			list.y =  10*scale;
		}
		
		private function get menuArr():ListCollection
		{
			var goupe:Object = SpecController.instance.getGroup("AchieveItem");
			var spec:ItemSpec;
			var list:ListCollection = new ListCollection;
			for each(spec in goupe){
				list.push({item_id:spec.item_id});
			}
			
			return list;
		}
	}
}