FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY belgrade-product-catalog-demo/*.csproj ./belgrade-product-catalog-demo/
RUN dotnet restore ./belgrade-product-catalog-demo/

# copy everything else and build app
COPY belgrade-product-catalog-demo/. ./belgrade-product-catalog-demo/
WORKDIR /app/belgrade-product-catalog-demo
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.2-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/belgrade-product-catalog-demo/out ./

EXPOSE 5000

ENTRYPOINT ["dotnet", "belgrade-product-catalog-demo.dll"]