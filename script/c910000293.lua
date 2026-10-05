--潜入！スパイ・ヒーロー
--Spy Hero
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
if not s.global_check then
        s.global_check = true
        local ge1 = Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        --ge1:SetCode(EVENT_PHASE|PHASE_END)
        ge1:SetOperation(s.checkop)
        Duel.RegisterEffect(ge1, 0)
    end
end

function s.filter(c)
    return c:GetOriginalCode() == id
		and not c:IsHasEffect(99999999)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
local c = Duel.GetFirstMatchingCard(s.filter, 0, LOCATION_HAND, LOCATION_HAND, 0)
	if c then
	Duel.SendtoHand(c, 1-c:GetControler(), REASON_EFFECT)
	c:RegisterFlagEffect(99999999, PHASE_STANDBY, 0, 1)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_DECK,0,2,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_DECK,0,nil):RandomSelect(tp,2)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsSpell() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(aux.AND(Card.IsSpell,Card.IsAbleToHand),tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,aux.AND(Card.IsSpell,Card.IsAbleToHand),tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		tc:RegisterFlagEffect(id,RESET_EVENT|RESET_TOGRAVE|RESET_REMOVE|RESET_TEMP_REMOVE|RESET_TODECK|RESET_PHASE|PHASE_END,0,1)
	end
end
