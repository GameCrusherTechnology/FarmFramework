package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.UiController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import view.render.MenuListRender;
	
	public class RatingPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var list:List;
		public function RatingPanel()
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
			listLayout.paddingTop = 20*scale;
			listLayout.gap = 10*scale;
			
			
			list = new List();
			list.layout = listLayout;
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("panelSkin"), new Rectangle(20, 20, 20, 20));
			list.backgroundSkin = new Scale9Image(skintextures);
			list.dataProvider = menuArr;
			list.width =  panelwidth*0.8;
			list.height = panelheight *0.85;
			list.itemRendererFactory =function tileListItemRendererFactory():IListItemRenderer
			{
				const renderer:DefaultListItemRenderer = new MenuListRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("PanelRenderSkin"));
				renderer.defaultSelectedSkin = new Image(Game.assets.getTexture("whitePanelSkin"));
				renderer.labelField = "label";
				renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				renderer.iconSourceField = "texture";
				renderer.iconPosition = Button.ICON_POSITION_TOP;
				renderer.width = panelwidth *0.7;
				renderer.height = 100*scale;
				return renderer;
			};
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.1;
			list.y =  50*scale;
		}
		
		private function get menuArr():ListCollection
		{
			return new ListCollection([
				{ label: LanguageController.getInstance().getString("profile"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_HARVEST,event:"profile"},
				{ label: LanguageController.getInstance().getString("skill"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_SEED,event:"skill"},
				{ label: LanguageController.getInstance().getString("social"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_HARVEST,event:"social"},
				{ label: LanguageController.getInstance().getString("achieve"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_SEED,event:"achieve"},
				{ label: LanguageController.getInstance().getString("rating"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_HARVEST,event:"rating"},
				{ label: LanguageController.getInstance().getString("setting"), texture: Game.assets.getTexture("reapIcon"),type:UiController.TOOL_SEED,event:"setting"}
			]);
		}
	}
}
import view.panel;

