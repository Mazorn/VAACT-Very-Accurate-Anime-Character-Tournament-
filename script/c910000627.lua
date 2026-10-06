--天刑王 ブラック・ハイランダー
--Dark Highlander
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FIEND),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_FIEND),1,99)
	c:EnableReviveLimit()
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return (sumtp&SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function s.filter(c)
	return c:GetEquipCount()>0
end
function s.disfilter(c)
return c:IsType(TYPE_SYNCHRO)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetCurrentChain()==0 and eg:IsExists(s.disfilter,1,nil)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local eqg=g:GetFirst():GetEquipGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eqg,#eqg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#eqg*400)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local eqg=tc:GetEquipGroup()
		if #eqg>0 then
			local des=Duel.Destroy(eqg,REASON_EFFECT)
			Duel.Damage(1-tp,des*400,REASON_EFFECT)
		end
	end
end
