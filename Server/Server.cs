using CitizenFX.FiveM.Server;
using CitizenFX.FiveM.Shared.Script;

namespace Server
{
    public class Server : IScript
    {
        public void Initialize()
        {
            API.Log.Info("Server side initialised");
        }
    }
}