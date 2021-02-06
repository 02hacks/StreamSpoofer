LP = game:GetService("Players").LocalPlayer

function StringGenerator(Args)
	local String = ""
		for i = 1, Args do 
			if math.random(0,9) <= 5 then
				String = String..string.char(math.random(48,57))
			else
				if math.random(0,9) <= 5 then
					String = String..string.char(math.random(65,90))
				else
					String = String..string.char(math.random(97,122))
				end
			end
		end
	return String
end

StreamSpoofer = {
	Dev = "02hacks",
	Active = false
}

function StreamSpoofer.Chat(Args,Spoof)
	if Args.Name ~= "UIListLayout" and Args:FindFirstChild("TextLabel") then
		if Args.TextLabel:FindFirstChild("TextButton") then
			if Args.TextLabel.TextButton.Text ~= "{Team}" then
				local txt = Args.TextLabel.TextButton
				if Args.TextLabel.TextButton.Text == "["..LP.Name.."]:" then
					txt.Text = "["..Spoof.."]:"
				else
					local rand,len = 2,string.len(txt.Text)
					if len >= 8 then
						rand = math.random(3,5)
					end
					txt.Text = "["..string.sub(txt.Text,2,len-(2+rand))..string.rep("*", rand).."]:"
				end
			end
		end
	end
end

function StreamSpoofer.PLRLM(Spoof)
	local Scoll = game.CoreGui.RobloxGui.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame
	if Scoll.OffsetUndoFrame:FindFirstChild("p_"..LP.UserId) then
		Scoll.OffsetUndoFrame["p_"..LP.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = Spoof
	end
	Scoll:GetPropertyChangedSignal("CanvasPosition"):connect(function()
		if Scoll.OffsetUndoFrame:FindFirstChild("p_"..LP.UserId) and StreamSpoofer.Active then
			Scoll.OffsetUndoFrame["p_"..LP.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = Spoof
		end
	end)
end

function StreamSpoofer.Func() -- StreamSpoofer v2.00 Created: 8.10.20
	if StreamSpoofer.Active	then
		SpoofString = StringGenerator(string.len(LP.Name)-2)
		for i,v in next, game.Players:GetChildren() do
			if game.Workspace:FindFirstChild(v.Name) and game.Workspace[v.Name]:FindFirstChild("Humanoid") then
				game.Workspace[v.Name].Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
		end
		if game.CoreGui.RobloxGui:FindFirstChild("PlayerListMaster") then
			game.CoreGui.RobloxGui.PlayerListMaster.Visible = false
			StreamSpoofer.PLRLM(SpoofString)
			game.CoreGui.RobloxGui.PlayerListMaster.Visible = true
		end
		for i,v in next, LP.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller:GetChildren() do 
			StreamSpoofer.Chat(v,SpoofString)
		end
		warn("Started StreamSpoofer",1)
		repeat wait()
			--
		until StreamSpoofer.Active == false
		warn("Stopped StreamSpoofer",1)
	end
end

game.Workspace.ChildAdded:connect(function(v)
	wait(0.15)
	if StreamSpoofer.Active	and game.Players:FindFirstChild(v.Name) and v.Name ~= LP.Name then
		wait()
		if game.Workspace:FindFirstChild(v.Name) then
			game.Workspace[v.Name].Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
	end
end)

game.CoreGui.RobloxGui.ChildAdded:connect(function(Added)
	if StreamSpoofer.Active	and tostring(Added) == "PlayerListMaster" then
		wait(0.15)
		StreamSpoofer.PLRLM(SpoofString)
	end
end)

LP.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller.ChildAdded:connect(function(v)
	StreamSpoofer.Chat(v,SpoofString)
end)

StreamSpoofer.Active = true
StreamSpoofer.Func()
