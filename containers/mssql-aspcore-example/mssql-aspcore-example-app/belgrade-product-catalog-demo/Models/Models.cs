using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProductCatalog.Models
{
    [Table("Product")]
    public class Product
    {
        public int ProductId { get; set; }

        public string Name { get; set; }

        public string Color { get; set; }

        public string Size { get; set; }

        public decimal Price { get; set; }

        public int Quantity { get; set; }

        public int CompanyID { get; set; }

        [NotMapped]
        public string[] Tags
        {
            get { return _Tags == null ? null : JsonConvert.DeserializeObject<string[]>(_Tags); }
            set { _Tags = JsonConvert.SerializeObject(value); }
        }

        internal string _Tags { get; set; }

        [NotMapped]
        public Properties Data
        {
            get { return (this._Data == null) ? null : JsonConvert.DeserializeObject<Properties>(this._Data); }
            set { _Data = JsonConvert.SerializeObject(value); }
        }

        internal string _Data { get; set; }
    }

    public class Properties
    {
        public string Type { get; set; }

        public string MadeIn { get; set; }
    }

    public class ProductCatalogContext : DbContext
    {
        public ProductCatalogContext(DbContextOptions<ProductCatalogContext> options)
            : base(options)
        { }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Product>()
                  .Property(x => x.ProductId)
                  .HasDefaultValueSql("NEXT VALUE FOR ProductId");

            modelBuilder.Entity<Product>()
                .Property(b => b._Tags).HasColumnName("Tags");

            modelBuilder.Entity<Product>()
                .Property(b => b._Data).HasColumnName("Data");
        }

        public DbSet<Product> Products { get; set; }
    }

}