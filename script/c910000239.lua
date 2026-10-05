local s,id=GetID()
    function s.initial_effect(c)

local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFEECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
function s.filtre(e,tp,eg,ep,c,ev,re,r,rp,chk)
    return c:IsType(TYPE_MONSTER)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.IsExistingMatchingCard(s.filtre,tp,LOCATION_GRAVE,O,1)
end
function s.cost(e,tp,eg,ep,c,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.PayLPCost(tp,200)
end
function s.target(e,tp,eg,ep,c,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=eg:FilterSelect(tp,s.filtre,1,1,nil,e,tp)
    Duel.SetTargetCard(g)
end
function s.condition(e,tp,eg,ep,c,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    tc:GetAttribute()
    Duel.Draw(tp,1,REASON_EFFECT)
end
