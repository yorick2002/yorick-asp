using CitizenFX.FiveM.Client;
using CitizenFX.FiveM.Shared.Script;

namespace Client
{
    public class Client : IScript
    {
        public void Initialize()
        {
            API.Log.Info("Client side initialised");
        }
    }
}

