include("shared.lua")

local drawCol = Color(255, 255, 255, 255)
function ENT:Draw()
	self:DrawModel()

	if LL_PLATES_SYSTEM.Config.NPCHeadText == false then
		self.Draw = self.DrawModel
		return
	end

	local _, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector(0, 0, maxs.z + 12)
	local ang = self:GetAngles()
	cam.Start3D2D(pos, Angle(0, ang.y + 90, 90), 0.2)
		draw.DrawText("Change plate", "ll_plates::header", 0, 0, drawCol, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

local upper = string.upper

function LL_PLATES_SYSTEM:OpenChangeMenu(leng, ply, veh)
	if IsValid(self.Frame) and self.Frame:IsVisible() then return end
	if IsValid(self.Frame) then self.Frame:Remove() end
	if not IsValid(veh) then return end

	local y
	self.Frame = vgui.Create("DFrame")
	self.Frame:SetTitle("")
	self.Frame:SetSize(500, 500)
	self.Frame:ShowCloseButton(true)
	self.Frame:Center()
	function self.Frame.Paint(panel, w, h)
		draw.RoundedBox(4, 3, 20, panel:GetWide() - 6, panel:GetTall() - 40, self.Config.DermaFrameCol)
	end

	self.Frame.TitleLabel = vgui.Create("DLabel", self.Frame)
	self.Frame.TitleLabel:SetText("Plate modifier")
	self.Frame.TitleLabel:SetFont("Trebuchet24")
	self.Frame.TitleLabel:SetTextColor(self.Config.DermaBrandCol)
	self.Frame.TitleLabel:SizeToContents()
	self.Frame.TitleLabel:SetPos((self.Frame:GetWide() - self.Frame.TitleLabel:GetWide()) / 2, 25)

	self.Frame.InfoLabel = vgui.Create("DLabel", self.Frame)
	self.Frame.InfoLabel:SetText(self.Language("dmv.body", {max = 9, dollar = self.Config.CurrencySymbol, cost = 2000}))
	self.Frame.InfoLabel:SetTextColor(self.Config.DermaTextCol)
	self.Frame.InfoLabel:SizeToContents()

	_, y = self.Frame.TitleLabel:GetPos()
	self.Frame.InfoLabel:SetPos(5, 5 + y + self.Frame.TitleLabel:GetTall())

	self.Frame.TextEntry = vgui.Create("DTextEntry", self.Frame)
	self.Frame.TextEntry:SetWide(self.Frame:GetWide() - 10)
	self.Frame.TextEntry:SetTextColor(self.Config.DermaTextCol)
	self.Frame.TextEntry:SetPaintBackground(true)
	self.Frame.TextEntry:SetDrawBorder(true)
	_, y = self.Frame.InfoLabel:GetPos()
	self.Frame.TextEntry:SetPos(5, 5 + y + self.Frame.InfoLabel:GetTall())
	function self.Frame.TextEntry.OnTextChanged(panel)
		panel:SetText(panel:GetText():gsub("[^%w- ]", ""):gsub("%l", function(val) return upper(val) end):sub(0, self.Config.MaxLength))
		panel:SetCaretPos(panel:GetText():len())
	end
	function self.Frame.TextEntry.Paint(panel, w, h)
		if panel:HasFocus() then
			local col = self.Config.DermaTextBGColFocused
			surface.SetDrawColor(col.r, col.g, col.b, col.a)
		else
			local col = self.Config.DermaTextBGCol
			surface.SetDrawColor(col.r, col.g, col.b, col.a)
		end
		surface.DrawRect(0, 0, w, h)

		panel:DrawTextEntryText(panel:GetTextColor(), panel:GetHighlightColor(), panel:GetCursorColor())
	end

	self.Frame.ModelPanel = vgui.Create("DModelPanel", self.Frame)
	_, y = self.Frame.TextEntry:GetPos()
	self.Frame.ModelPanel:SetPos(5, 5 + y + self.Frame.TextEntry:GetTall())

	self.Frame.Cancel = vgui.Create("DButton", self.Frame)
	self.Frame.Cancel:SetText(self.Language("cancel"))
	self.Frame.Submit = vgui.Create("DButton", self.Frame)
	self.Frame.Submit:SetText("Buy selected Plates")
	self.Frame.Random = vgui.Create("DButton", self.Frame)
	self.Frame.Random:SetText("Buy random Plates")
	local w1 = ((self.Frame:GetWide() - 10) / 3) - 3
	local x1, x2, x3 = 7, self.Frame:GetWide() - 7 - w1, self.Frame:GetWide() - 10 - w1*2

	y = self.Frame:GetTall() - (self.Frame.Cancel:GetTall() + 25)
	self.Frame.Cancel:SetPos(x1, y)
	self.Frame.Random:SetPos(x2, y)
	self.Frame.Submit:SetPos(x3, y)
	self.Frame.Cancel:SetSize(w1, 20)
	self.Frame.Random:SetSize(w1, 20)
	self.Frame.Submit:SetSize(w1, 20)

	function self.Frame.Submit.DoClick(panel)
		local text = self.Frame.TextEntry:GetText()

		net.Start("ll_plates::menu")
			net.WriteString(text)
			net.WriteUInt(2, 2)
		net.SendToServer()

		self.Frame:Remove()
	end

    function self.Frame.Random.DoClick(panel)
		net.Start("ll_plates::random")
			net.WriteUInt(2, 2)
		net.SendToServer()

		self.Frame:Remove()
	end

	function self.Frame.Cancel.DoClick(panel)
		self.Frame:Remove()
	end

	local _, y3 = self.Frame.TextEntry:GetPos()
	local h = y - (y3 + self.Frame.TextEntry:GetTall() + 10)
	self.Frame.ModelPanel:SetSize(self.Frame:GetWide() - 10, h)
	self.Frame.ModelPanel:SetModel(veh:GetModel())
	self.Frame.ModelPanel:SetFOV(90)

	local boundMax, boundMin = self.Frame.ModelPanel.Entity:GetRenderBounds()
	local size = math.max(0, math.abs(boundMax.x) + math.abs(boundMin.x), math.abs(boundMax.y) + math.abs(boundMin.y), math.abs(boundMax.z) + math.abs(boundMin.z)) * 0.75
	self.Frame.ModelPanel:SetCamPos(Vector(size, size, size))
	self.Frame.ModelPanel:SetLookAt(self.Frame.ModelPanel.Entity:GetPos())

	self.Frame:MakePopup()
	self.Frame.TextEntry:RequestFocus()
end

net.Receive("ll_plates::change_menu", function(leng, ply) LL_PLATES_SYSTEM:OpenChangeMenu(leng, ply, net.ReadEntity()) end)