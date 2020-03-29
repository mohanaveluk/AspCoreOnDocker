FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY AspCoreOnDocker/*.csproj ./AspCoreOnDocker/
RUN dotnet restore

# copy everything else and build app
COPY AspCoreOnDocker/. ./AspCoreOnDocker/
WORKDIR /app/AspCoreOnDocker
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/AspCoreOnDocker/out ./
ENTRYPOINT ["dotnet", "AspCoreOnDocker.dll"]