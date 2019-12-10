FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY sampledocker/*.csproj ./sampledocker/
RUN dotnet restore

# copy everything else and build app
COPY sampledocker/. ./sampledocker/
WORKDIR /app/sampledocker
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/sampledocker/out ./
ENTRYPOINT ["dotnet", "sampledocker.dll"]