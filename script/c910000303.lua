--E・HERO ストーム・ネオス
--Elemental HERO Storm Neos
local s,id=GetID()
function s.initial_effect(c)
	--Contact Fusion procedure
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_NEOS,910000270,910000269)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--Destroy all Spells/Traps on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--Shuffle all cards on the field into the Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	aux.EnableNeosReturn(c,nil,nil,nil,e2)
end
s.listed_names={CARD_NEOS,910000270,910000269}
s.material_setcode={SET_HERO,SET_ELEMENTAL_HERO,SET_NEOS,SET_NEO_SPACIAN}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST|REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.filtre(c,e,tp,g)
return c:IsCode(CARD_NEOS) or c:IsCode(910000270) or c:IsCode(910000269)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return type(re:GetLabelObject())=='Effect' and re:GetLabelObject()==e
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	if Duel.GetLocationCount(tp,LOCATION_DECK)>=3 and Duel.IsExistingMatchingCard(CARD_NEOS,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(910000270,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(910000269,tp,LOCATION_DECK,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.filtre,tp,LOCATION_DECK,0,3,3,nil)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(1,CATEGORY_SPECIAL_SUMMON,tg,3,tp,LOCATION_DECK)
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(CARD_NEOS,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(910000270,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(910000269,tp,LOCATION_DECK,0,1,nil) then
	local tg=Duel.SelectMatchingCard(tp,s.filtre,tp,LOCATION_DECK,0,3,3,nil)
		if #tg>0 then
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
