using Belgrade.SqlClient;
using Belgrade.SqlClient.SqlDb;
using Belgrade.SqlClient.SqlDb.Rls;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using ProductCatalog.Models;
using Serilog;
#if NET46 
using Serilog.Sinks.MSSqlServer;
#endif
using System;
using System.Data.SqlClient;
using System.Linq;

namespace ProductCatalog
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            string ConnString = Configuration["ConnectionStrings:BelgradeDemo"];

            services.AddDbContext<ProductCatalogContext>(options => options.UseSqlServer(new SqlConnection(ConnString)));

            // Adding data access services/components.
            services.AddTransient<IQueryPipe>(
                sp => new QueryPipe(new SqlConnection(ConnString))
                           .AddRls("CompanyID",() => GetCompanyIdFromSession(sp))
                );

            services.AddTransient<ICommand>(
                sp => new Command(new SqlConnection(ConnString))
                           .AddRls("CompanyID", () => GetCompanyIdFromSession(sp))
                );

            //// Add framework services.
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddLogging();
            services.AddSession();
            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();
            loggerFactory.AddSerilog();

            app.UseSession();
            app.UseStaticFiles();
            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=ProductCatalog}/{action=Index}");
            });
            
        }

        /// <summary>
        /// Utility method that takes CompanyID from HttpSession.
        /// You need to add: services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
        /// </summary>
        /// <param name="serviceProvider">IServiceProvider interface.</param>
        /// <returns>Session value</returns>
        private static string GetCompanyIdFromSession(IServiceProvider serviceProvider)
        {
            var session = serviceProvider.GetServices<IHttpContextAccessor>().First().HttpContext.Session;
            return session.GetString("CompanyID") ?? "-1";
        }
    }
}
