Tween = {}
Tween.__index = Tween

function Tween.new(start, finish, totalDuration, tweenF)
    local this = {
        tweenF = tweenF or Tween.Linear,
        distance = finish - start,
        startValue = start,
        current = start,
        totalDuration = totalDuration,
        timePassed = 0,
        finished = false
    }

    setmetatable(this, Tween)

    return this
end

function Tween:Update(dt)
    self.timePassed = self.timePassed + dt
    self.current = self.tweenF(self.timePassed, self.startValue, self.distance, self.totalDuration)

    if self.timePassed > self.totalDuration then
        self.current = self.startValue + self.distance
        self.finished = true
    end
end

function Tween.Linear(timePassed, start, distance, duration)
    return distance * timePassed / duration + start
end

function Tween.EaseOutBounce(t, b, c, d)
    t = t / d
    if t < 1 / 2.75 then
        return c * (7.5625 * t * t) + b
    elseif t < 2 / 2.75 then
        t = t - (1.5 / 2.75)
        return c * (7.5625 * t * t + 0.75) + b
    elseif t < 2.5 / 2.75 then
        t = t - (2.25 / 2.75)
        return c * (7.5625 * t * t + 0.9375) + b
    else
        t = t - (2.625 / 2.75)
        return c * (7.5625 * t * t + 0.984375) + b
    end
end

function Tween.inOutBack(t, b, c, d, s)
    if not s then s = 1.70158 end
    s = s * 1.525
    t = t / d * 2
    if t < 1 then
      return c / 2 * (t * t * ((s + 1) * t - s)) + b
    else
      t = t - 2
      return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
    end
end

function Tween:IsFinished()
    return self.finished
end

function Tween:Value()
    return self.current
end