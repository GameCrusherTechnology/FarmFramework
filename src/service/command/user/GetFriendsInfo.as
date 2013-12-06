package service.command.user
{
	import controller.FriendInfoController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetFriendsInfo extends AbstractCommand
	{
		public function GetFriendsInfo(friendsArr:Array)
		{
			super(Command.GETUSERINFO,onResult,{friends:friendsArr});
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				FriendInfoController.instance.addNewFriendsInfo(result.friends);
			}else{
				
			}
		}
	}
}


