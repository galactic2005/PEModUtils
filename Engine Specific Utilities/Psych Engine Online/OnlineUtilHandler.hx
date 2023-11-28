import online.GameClient;
import psychlua.LuaUtils;

var tablePlayerStatStrings:Array<String> = [
	'score',
	'misses',
	'sicks',
	'goods',
	'bads',
	'shits',
	'name',
	'hasSong',
	'hasLoaded',
	'hasEnded',
	'ping'
];

createGlobalCallback('getDefaultPlayerStats', function():Array<Dynamic>
{
	return [0, 0, 0, 0, 0, 0, '', false, false, false, 0];
});

createGlobalCallback('getPEOnlineUtilityVersion', function():String
{
	return '1.0.0';
});
	

createGlobalCallback('getPlayerStat', function(player:Dynamic, stat:String):Dynamic
{
	var playerType:String = Std.string(player);
	if (playerType != '1' && playerType != '2')
	{
		return null;
	}
	return Reflect.getProperty((playerType == '1' ? GameClient.room.state.player1 : GameClient.room.state.player2), stat);
});

createGlobalCallback('getPlayerStatsTable', function(player:Dynamic):Array<Dynamic>
{
	var playerType:String = Std.string(player);
	if (playerType != '1' && playerType != '2')
	{
		return [null, null, null, null, null, null, null, null, null, null];
	}

	var clientType = (playerType == '1' ? GameClient.room.state.player1 : GameClient.room.state.player2);
	var statTable:Array<Dynamic> = [];
	for(stat in tablePlayerStatStrings)
	{
		statTable.push(Reflect.getProperty(clientType, stat));
	}
	return statTable;
});

createGlobalCallback('getPsychEngineOnlineVersion', function():Int
{
	return Reflect.getProperty(MainMenuState, 'psychOnlineVersion');
});

createGlobalCallback('isAnarchyMode', function():Bool
{
	return GameClient.room.state.anarchyMode;
});

createGlobalCallback('isClientOnline', function():Bool
{
	return GameClient.room != null;
});

createGlobalCallback('isClientOwner', function():Bool
{
	return GameClient.isOwner;
});

createGlobalCallback('isOpponent', function():Bool
{
	if (GameClient.room != null)
	{
		return (GameClient.room.state.swagSides ? !GameClient.isOwner : GameClient.isOwner);
	}
	return PlayState.opponentMode;
});

createGlobalCallback('isPrivateRoom', function():Bool
{
	return GameClient.room.state.isPrivate;
});

createGlobalCallback('isSwapSides', function():Bool
{
	return GameClient.room.state.swagSides;
});