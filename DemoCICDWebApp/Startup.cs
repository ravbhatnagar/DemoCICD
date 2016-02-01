using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(DemoCICDWebApp.Startup))]
namespace DemoCICDWebApp
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
