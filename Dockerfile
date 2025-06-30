# Version values referenced from https://hub.docker.com/_/microsoft-dotnet-aspnet

FROM mcr.microsoft.com/dotnet/sdk:8.0-cbl-mariner2.0. AS build

WORKDIR /src
COPY [".", "./"]
RUN dotnet build "./src/Service/Azure.DataApiBuilder.Service.csproj" -c Docker -o /out -r linux-x64
RUN dotnet build "./src/Cli/Cli.csproj" -c Docker -o /out -r linux-x64

WORKDIR /out

# Run dotnet Microsoft.DataApiBuilder.dll commands here to configure
Examples
# RUN dotnet Microsoft.DataApiBuilder.dll init --database-type mssql --serverless true --host-mode development --graphql.disabled true --connection-string "@env('DATABASE_CONNECTION_STRING')" --auth.provider AzureAD --auth.audience "@env('AUTH_AUDIENCE')" --auth.issuer "@env('AUTH_ISSUER')"
# RUN dotnet Microsoft.DataApiBuilder.dll add mydata --source "mydata" --permissions "authenticated:read" --source.key-fields "id"

FROM mcr.microsoft.com/dotnet/aspnet:8.0-cbl-mariner2.0 AS runtime

COPY --from=build /out /App
WORKDIR /App
ENV ASPNETCORE_URLS=http://+:5000

ENTRYPOINT ["dotnet", "Azure.DataApiBuilder.Service.dll", "--verbose"]
