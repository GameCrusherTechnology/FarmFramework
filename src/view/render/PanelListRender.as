package view.render
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.display.DisplayObject;
	
	import view.panel.AchievePanel;
	import view.panel.PackagePanel;
	import view.panel.PetInfoPanel;
	import view.panel.ProfilePanel;
	import view.panel.RatingPanel;
	import view.panel.SettingPanel;
	import view.panel.SkillPanel;
	import view.panel.SocialPanel;
	
	public class PanelListRender extends DefaultListItemRenderer
	{
		public function PanelListRender()
		{
			super();
		}
		private var currentPanel:DisplayObject;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value){
				if(currentPanel){
					if(currentPanel.parent){
						currentPanel.parent.removeChild(currentPanel);
					}
					currentPanel =null;
				}
				trace(value.name);
				if(!currentPanel){
					if(value.name == "profile"){
						currentPanel = new ProfilePanel();
					}else if(value.name == "social"){
						currentPanel = new SocialPanel();
					}else if(value.name == "achieve"){
						currentPanel = new AchievePanel();
					}else if(value.name == "setting"){
						currentPanel = new SettingPanel();
					}else if(value.name == "skill"){
						currentPanel = new SkillPanel();
					}else if(value.name == "rating"){
						currentPanel = new RatingPanel();
					}else if(value.name == "package"){
						currentPanel = new PackagePanel();
					}else if(value.name == "pet"){
						currentPanel = new PetMenuPanel();
					}else{
						currentPanel = new ProfilePanel();
					}
					addChild(currentPanel);
				}
			}
		}
		
		
	}
}


