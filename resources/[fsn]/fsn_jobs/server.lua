Citizen.CreateThread(function()
  while true do
    Citizen.Wait(3000000)
    print(':fsn_jobs: Paycheck time babies')
    TriggerClientEvent('fsn_jobs:paycheck', -1)
  end
end)
