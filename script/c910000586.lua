--Red Giant
--spsummon
local s,id=GetID()
function s.initial_effect(c)
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e1:SetRange(LOCATION_HAND)
e1:SetCode(EVENT_MSET)
e1:SetCondition(s.spcon)
e1:SetTarget(s.sptg)
e1:SetOperation(s.spop)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EVENT_SSET)
c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,0))
e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e3:SetCode(EVENT_SPSUMMON_SUCCESS)
e3:SetRange(LOCATION_MZONE)
e3:SetCondition(s.spcon2)
e3:SetOperation(s.battle)
c:RegisterEffect(e3)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then
return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
return Duel.IsBattlePhase()
end
function s.battle(e,tp,eg,ep,ev,re,r,rp)
return Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE|PHASE_BATTLE,1)
end
