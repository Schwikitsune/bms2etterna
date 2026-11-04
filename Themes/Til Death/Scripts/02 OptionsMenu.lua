function getPlayerOptionsList(itemSet)
	-- 7k plays by LR2 rules: judge rank and gauge replace judge and life
	local rules = "Judge,Life,Fail"
	if hideMSD() then
		rules = "JudgeRank,Gauge,Fail"
		-- charts with their own #RANK / #JUDGERANK / #DEFEXRANK always play on it
		if getBMSChartJudgeRank() then
			rules = "Gauge,Fail"
		end
	end
	local Items = {
		["Main"] = "Speed,RateList,NoteSk,RS,PRAC,CG,ScrollDir,Center,Persp,BG,SF,Background," .. rules .. ",Assist,Score",
		["Theme"] = "LC,CBHL,JT,CT,DP,DM,TT,TG,TTM,JC,EB,EBC,PI,FBP,FB,MB,LEADB,NPS",
		["Effect"] = "Persp,App,GHO,SHO,Acc,Hide,Effect1,Effect2,Scroll,Turn,Insert,R1,R2,Holds,Mines,HoldReleases"
	}
	return Items[itemSet] .. ",NextScr"
end
