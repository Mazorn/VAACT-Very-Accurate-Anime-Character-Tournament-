--モンスター回収
--Monster Recovery
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.atkcost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.mfilter(c,tp)
	return c:IsAbleToDeck() 
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	end
	local g1=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,cf)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=#g
	if tc and tc:IsRelateToEffect(e) and ct>0 then
		g:AddCard(tc)
		local f=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local cf=f+1
		Duel.ShuffleDeck(tp)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,cf,REASON_EFFECT)
		end
	end
end